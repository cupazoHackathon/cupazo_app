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

      // Get deals from Supabase
      final deals = await _dealRepository.getDealsByCategory(supabaseCategory);

      // Convert DealModel to Product
      final products = DealToProductMapper.toProductList(deals);

      setState(() {
        _products = products;
        _applySort();
        _isLoading = false;
      });
    } catch (e) {
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
      backgroundColor: const Color(0xFFFFF8E1),
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
                  ? const Center(child: CircularProgressIndicator())
                  : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: AppColors.inkSoft,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage!,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 16,
                              color: AppColors.inkSoft,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadProducts,
                            child: const Text('Reintentar'),
                          ),
                        ],
                      ),
                    )
                  : _filteredProducts.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: AppColors.inkSoft,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No se encontraron productos',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 16,
                              color: AppColors.inkSoft,
                            ),
                          ),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio:
                                0.70, // Ajustado para evitar overflow
                          ),
                      itemCount: _filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts[index];
                        // Asignar ranking a los primeros 2 productos (más populares)
                        final ranking = index < 2 ? index + 1 : null;
                        return ProductCard(
                          product: product,
                          ranking: ranking,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailScreen(product: product),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
