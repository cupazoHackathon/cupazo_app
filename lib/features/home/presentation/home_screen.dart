import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../profile/presentation/pages/profile_screen.dart';
import 'pages/category_products_screen.dart';
import 'widgets/recommended_users_row.dart';

/// Pantalla principal de Cupazo
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Modern Search Header
            _buildSearchHeader(),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),

                    // Recommended Users Section
                    const RecommendedUsersRow(),
                    const SizedBox(height: 24),

                    // Title Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildTitleSection(),
                    ),
                    const SizedBox(height: 20),

                    // Modern Promo Banner
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildPromoBanner(),
                    ),
                    const SizedBox(height: 32),

                    // Categories Grid
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildCategoriesSection(),
                    ),
                    const SizedBox(height: 32),

                    // Unique Collections Section
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: _buildCollectionsSection(),
                    ),
                    const SizedBox(height: 100), // Space for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.line),
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar ropa, zapatillas...',
                  hintStyle: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    color: AppColors.inkLighter,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: AppColors.inkLight,
                  ),
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Cart Icon
          _buildHeaderIconButton(
            icon: Icons.shopping_cart_outlined,
            onTap: () {},
          ),
          const SizedBox(width: 12),

          // Profile Icon
          _buildHeaderIconButton(
            icon: Icons.person_outline,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.primaryYellow.withOpacity(0.2),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Icon(icon, color: AppColors.deepBlack, size: 24),
      ),
    );
  }

  Widget _buildTitleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '¡Ofertas Exclusivas!',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: AppColors.deepBlack,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Descubre productos únicos de emprendedores',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 15,
            color: AppColors.inkLight,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primaryYellow.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.deepBlack,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'PROMOCIÓN ESPECIAL',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 10,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryYellow,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Hasta 60% OFF\nen Moda',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.deepBlack,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Nuevos emprendedores destacados',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: AppColors.deepBlack.withOpacity(0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    final categories = [
      {
        'name': 'Ropa',
        'icon': Icons.checkroom,
        'color': AppColors.secondaryOrange,
      },
      {
        'name': 'Zapatillas',
        'icon': Icons.shopping_bag,
        'color': AppColors.secondaryTeal,
      },
      {
        'name': 'Accesorios',
        'icon': Icons.watch,
        'color': AppColors.primaryPurple,
      },
      {
        'name': 'Decoración',
        'icon': Icons.home,
        'color': AppColors.secondaryBlue,
      },
      {'name': 'Joyas', 'icon': Icons.diamond, 'color': AppColors.warning},
      {
        'name': 'Hecho a Mano',
        'icon': Icons.auto_awesome,
        'color': AppColors.error,
      },
      {'name': 'Cuidado', 'icon': Icons.water_drop, 'color': AppColors.info},
      {
        'name': 'Bolsos',
        'icon': Icons.shopping_bag_outlined,
        'color': AppColors.success,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categorías',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.deepBlack,
              ),
            ),
            Text(
              'Ver todo',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryPurple,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 16,
            mainAxisSpacing: 20,
            childAspectRatio: 0.75,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(
              category['name'] as String,
              category['icon'] as IconData,
              category['color'] as Color,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCategoryCard(String name, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(categoryName: name),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCollectionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Colecciones Únicas',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.deepBlack,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Text(
                'Ver todo →',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryPurple,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 240,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildProductCard(
                imageColor: AppColors.secondaryOrange.withOpacity(0.2),
                imageAsset: 'assets/ppr0b7t3pp9_1_1.jpg',
                badge: 'OFERTA',
                badgeColor: AppColors.error,
                discount: '-40%',
                isFavorite: false,
                title: 'Chaqueta Vintage',
                price: 'S/ 89.90',
              ),
              const SizedBox(width: 16),
              _buildProductCard(
                imageColor: AppColors.secondaryTeal.withOpacity(0.2),
                imageAsset:
                    'assets/HJ9105-100_1_032d4546-b7c6-4603-8458-38bdd77fc020.webp',
                badge: 'NUEVO',
                badgeColor: AppColors.primaryPurple,
                discount: null,
                isFavorite: false,
                title: 'Sneakers Urban',
                price: 'S/ 249.00',
              ),
              const SizedBox(width: 16),
              _buildProductCard(
                imageColor: AppColors.secondaryBlue.withOpacity(0.2),
                imageAsset: 'assets/w=800,h=800,fit=pad.webp',
                badge: 'OFERTA',
                badgeColor: AppColors.error,
                discount: '-25%',
                isFavorite: true,
                title: 'Jeans Slim Fit',
                price: 'S/ 129.90',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard({
    required Color imageColor,
    String? imageAsset,
    required String badge,
    required Color badgeColor,
    String? discount,
    required bool isFavorite,
    required String title,
    required String price,
  }) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Area
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: imageColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: imageAsset != null
                      ? ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                          child: Image.asset(
                            imageAsset,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(
                                child: Icon(
                                  Icons.broken_image,
                                  size: 48,
                                  color: AppColors.inkLighter.withOpacity(0.5),
                                ),
                              );
                            },
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.image,
                            size: 48,
                            color: AppColors.inkLighter.withOpacity(0.5),
                          ),
                        ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      badge,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      size: 18,
                      color: isFavorite ? AppColors.error : AppColors.inkLight,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Info Area
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      price,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepBlack,
                      ),
                    ),
                    if (discount != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          discount,
                          style: const TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
          if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          }
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: AppColors.primaryPurple,
        unselectedItemColor: AppColors.inkLight,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedLabelStyle: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        elevation: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            activeIcon: Icon(Icons.search, weight: 600),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
