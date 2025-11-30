import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../data/repositories/deal_repository.dart';
import '../../data/deal_to_product_mapper.dart';
import '../../domain/models/product.dart';
import '../widgets/app_search_bar.dart';
import '../widgets/category_header.dart';
import '../widgets/filter_bar.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

/// Pantalla que muestra productos de una categoría específica
class CategoryProductsScreen extends StatefulWidget {
  final String categoryName;

  const CategoryProductsScreen({super.key, required this.categoryName});

  @override
  State<CategoryProductsScreen> createState() => _CategoryProductsScreenState();
}

class _CategoryProductsScreenState extends State<CategoryProductsScreen> {
  List<Product> _products = [];
  String _selectedSort = 'relevante';
  String _searchQuery = '';
  bool _isLoading = true;
  String? _errorMessage;

  final _dealRepository = DealRepository();

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  /// Map UI category names to Supabase category values
  String _mapCategoryToSupabase(String categoryName) {
    // Normalizamos la entrada a minúsculas para buscar en el mapa
    final key = categoryName.toLowerCase();

    final categoryMap = {
      'ropa': 'ropa',
      'zapatillas': 'zapatillas',
      'accesorios': 'accesorios',
      'decoración': 'decoracion',
      'joyas': 'joyas',
      'hecho a mano': 'hecho_a_mano',
      'cuidado personal': 'cuidado_personal',
      'bolsos': 'bolsos',
      'food': 'food',
    };

    // Si no está en el mapa, devolvemos el nombre original (capitalizado por defecto)
    return categoryMap[key] ?? categoryName;
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Map category name to Supabase category value
      final supabaseCategory = _mapCategoryToSupabase(widget.categoryName);

      // LOG: Valor de categoría mapeado
      print(
        '🔍 [CategoryProductsScreen] Categoría UI: "${widget.categoryName}"',
      );
      print(
        '🔍 [CategoryProductsScreen] Categoría Supabase mapeada: "$supabaseCategory"',
      );

      // Get deals from Supabase
      print('📡 [CategoryProductsScreen] Iniciando petición a Supabase...');
      final deals = await _dealRepository.getDealsByCategory(supabaseCategory);

      // LOG: Cantidad de deals retornados
      print('✅ [CategoryProductsScreen] Deals retornados: ${deals.length}');
      if (deals.isNotEmpty) {
        print(
          '📦 [CategoryProductsScreen] Primer deal: ${deals.first.title} (categoría: ${deals.first.category})',
        );
      }

      // Convert DealModel to Product
      final products = DealToProductMapper.toProductList(deals);
      print(
        '🔄 [CategoryProductsScreen] Productos convertidos: ${products.length}',
      );

      setState(() {
        _products = products;
        _applySort();
        _isLoading = false;
      });

      print('✅ [CategoryProductsScreen] Carga completada exitosamente');
    } catch (e, stackTrace) {
      // LOG: Error capturado con stack trace
      print('❌ [CategoryProductsScreen] ERROR al cargar productos: $e');
      print('❌ [CategoryProductsScreen] Stack trace: $stackTrace');

      setState(() {
        _errorMessage = 'Error al cargar productos: $e';
        _isLoading = false;
      });
    }
  }

  void _applySort() {
    switch (_selectedSort) {
      case 'precio_asc':
        _products.sort((a, b) => a.currentPrice.compareTo(b.currentPrice));
        break;
      case 'precio_desc':
        _products.sort((a, b) => b.currentPrice.compareTo(a.currentPrice));
        break;
      default:
        // Mantener orden original (más relevante)
        break;
    }
  }

  void _onSortChanged(String sort) {
    setState(() {
      _selectedSort = sort;
      _applySort();
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  List<Product> get _filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    }
    return _products.where((product) {
      return product.name.toLowerCase().contains(_searchQuery) ||
          product.brand.toLowerCase().contains(_searchQuery);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Top Search Bar
            AppSearchBar(
              hintText: 'Buscar en esta categoría',
              onSearchChanged: _onSearchChanged,
            ),

            // Category Header - sin espacio extra
            CategoryHeader(
              categoryName: widget.categoryName,
              productCount: _filteredProducts.length,
            ),

            // Filter Bar
            FilterBar(
              selectedSort: _selectedSort,
              onSortChanged: _onSortChanged,
            ),

            // Products Grid
            Expanded(
              child: _isLoading
                  ? _buildLoadingState()
                  : _errorMessage != null
                  ? _buildErrorState()
                  : _filteredProducts.isEmpty
                  ? _buildEmptyState()
                  : RefreshIndicator(
                      onRefresh: _loadProducts,
                      color: AppColors.primaryYellow,
                      backgroundColor: Colors.white,
                      child: GridView.builder(
                        padding: const EdgeInsets.all(16),
                        physics: const AlwaysScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.70,
                            ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          final ranking = index < 2 ? index + 1 : null;
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: Duration(
                              milliseconds: 300 + (index * 50),
                            ),
                            curve: Curves.easeOut,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 20 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: ProductCard(
                              product: product,
                              ranking: ranking,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                    pageBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                        ) => ProductDetailScreen(
                                          product: product,
                                        ),
                                    transitionsBuilder:
                                        (
                                          context,
                                          animation,
                                          secondaryAnimation,
                                          child,
                                        ) {
                                          return FadeTransition(
                                            opacity: animation,
                                            child: child,
                                          );
                                        },
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.70,
      ),
      itemCount: 6, // Mostrar 6 skeleton loaders
      itemBuilder: (context, index) {
        return _buildSkeletonLoader();
      },
    );
  }

  Widget _buildSkeletonLoader() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Skeleton image
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
            ),
          ),
          // Skeleton content
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 12,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    height: 10,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.accentDanger.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.error_outline_rounded,
                  size: 64,
                  color: AppColors.accentDanger,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Oops! Algo salió mal',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _errorMessage ?? 'No se pudo cargar los productos',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  color: AppColors.inkSoft,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: _loadProducts,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Reintentar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryYellow,
                  foregroundColor: AppColors.deepBlack,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.search_off_rounded,
                  size: 64,
                  color: AppColors.inkSoft,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'No se encontraron productos',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBlack,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                _searchQuery.isNotEmpty
                    ? 'Intenta buscar con otros términos'
                    : 'No hay productos disponibles en esta categoría por el momento',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  color: AppColors.inkSoft,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              if (_searchQuery.isNotEmpty) ...[
                const SizedBox(height: 24),
                OutlinedButton.icon(
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: const Icon(Icons.clear_rounded),
                  label: const Text('Limpiar búsqueda'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.deepBlack,
                    side: BorderSide(color: AppColors.primaryYellow, width: 2),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
