import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../domain/models/product.dart';
import '../../domain/models/group_purchase.dart';
import '../../../../data/repositories/match_group_repository.dart';
import '../../data/group_mapper.dart';
import 'group_payment_screen.dart';
import '../../../../services/supabase_service.dart';

/// Pantalla de detalle de producto con compra en grupo
class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _isFavorite = false;
  String? _selectedSize;
  int _quantity = 1; // Cantidad seleccionada para grupo
  List<GroupPurchase> _activeGroups = [];
  bool _isLoadingGroups = true;
  final _groupRepository = MatchGroupRepository();

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.product.isFavorite;
    _selectedSize = 'M'; // Talla por defecto
    _loadGroups();
  }

  Future<void> _loadGroups() async {
    try {
      final currentUser = SupabaseService.client.auth.currentUser;
      final currentUserId = currentUser?.id;
      // Intenta obtener el avatar de los metadatos del usuario (Google, etc.)
      final currentUserAvatarUrl =
          currentUser?.userMetadata?['avatar_url'] as String?;

      print('Loading groups for deal: ${widget.product.id}');

      final groupsData = await _groupRepository.getGroupsWithMembersForDeal(
        widget.product.id,
      );

      print('Groups fetched: ${groupsData.length}');

      final groups = GroupMapper.fromSupabaseList(
        groupsData,
        widget.product.groupPrice3,
        currentUserId: currentUserId,
        currentUserAvatarUrl: currentUserAvatarUrl,
      );

      if (mounted) {
        setState(() {
          _activeGroups = groups;
          _isLoadingGroups = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingGroups = false;
        });
        // Opcional: mostrar error
        print('Error loading groups: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error cargando grupos: $e')));
      }
    }
  }

  void _joinGroup(GroupPurchase group) {
    // Navegar a la pantalla de pago para unirse a un grupo
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupPaymentScreen(
          product: widget.product,
          group: group, // Pasamos el grupo al que nos unimos
          selectedSize: _selectedSize,
          dealId: widget.product.id,
          isJoining: true,
        ),
      ),
    ).then((result) {
      if (result == true) {
        _loadGroups();
      }
    });
  }

  Future<void> _startNewGroup() async {
    // Navegar a la pantalla de pago para crear un nuevo grupo
    // Creamos un objeto GroupPurchase temporal para la vista
    final newGroup = GroupPurchase(
      id: 'new',
      creatorName: 'Tú',
      creatorInitials: 'Tú',
      creatorAvatarUrl: '',
      currentMembers: 1,
      requiredMembers: 2, // Debería venir del deal type (ej: 2 para 2x1)
      groupPrice: widget.product.groupPrice3,
      createdAt: DateTime.now(),
      isCurrentUserMember: true,
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GroupPaymentScreen(
          product: widget.product,
          group: newGroup,
          selectedSize: _selectedSize,
          dealId: widget.product.id,
          isJoining: false, // Es nuevo grupo
        ),
      ),
    );

    if (result == true && mounted) {
      // Dar un pequeño delay para asegurar que Supabase haya indexado el nuevo grupo
      // Aumentamos el delay a 1 segundo para mayor seguridad
      await Future.delayed(const Duration(seconds: 1));
      _loadGroups();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top Navigation Bar - Clean & Elegant
            Container(
              height: 70,
              color: AppColors.background,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(Icons.arrow_back, color: AppColors.deepBlack),
                    ),
                  ),
                  const Spacer(),
                  _buildHeaderActionButton(
                    icon: _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? AppColors.error : AppColors.deepBlack,
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                  ),
                  const SizedBox(width: 12),
                  _buildHeaderActionButton(
                    icon: Icons.share_outlined,
                    color: AppColors.deepBlack,
                    onTap: () {},
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image
                    Container(
                      width: double.infinity,
                      height: 300,
                      decoration: BoxDecoration(color: Colors.grey[200]),
                      child: Image.network(
                        widget.product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 80,
                                color: Colors.grey[600],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Product Info Section
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Material Section
                          Row(
                            children: [
                              Text(
                                'Material',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.purple[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Malla transpirable y suela de goma',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Size Selection
                          Text(
                            'Selecciona tu talla',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: ['S', 'M', 'L', 'XL'].map((size) {
                              final isSelected = _selectedSize == size;
                              return Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectedSize = size;
                                      });
                                    },
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      side: BorderSide(
                                        color: isSelected
                                            ? AppColors.deepBlack
                                            : Colors.grey[300]!,
                                        width: isSelected ? 2 : 1,
                                      ),
                                      backgroundColor: isSelected
                                          ? AppColors.deepBlack.withOpacity(0.1)
                                          : Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      size,
                                      style: TextStyle(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? AppColors.deepBlack
                                            : AppColors.ink,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),

                          // Product Name and Brand
                          Text(
                            widget.product.brand,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              color: AppColors.inkSoft,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.product.name,
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Prices
                          Row(
                            children: [
                              Text(
                                'S/ ${widget.product.originalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 18,
                                  decoration: TextDecoration.lineThrough,
                                  color: AppColors.inkSoft,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'S/ ${widget.product.currentPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.deepBlack,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '-${widget.product.discountPercentage}%',
                                  style: const TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Description Section
                          Text(
                            'Descripción',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Producto de alta calidad de la marca ${widget.product.brand}. '
                            'Perfecto para uso diario. Diseñado con materiales premium '
                            'que garantizan durabilidad y comodidad. Aprovecha nuestras '
                            'ofertas especiales y ahorra más comprando en grupo.',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              color: AppColors.inkSoft,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Group Purchase Section
                          _buildGroupPurchaseSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom Action Bar
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupPurchaseSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.deepBlack, // Cambiado a Negro
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.group, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Únete a una Compra de Grupo',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Ahorra comprando con otros',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Discount Info Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(
                0.1,
              ), // Ajustado para fondo oscuro
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Descuento de 3 unidades',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color:
                            AppColors.primaryYellow, // Amarillo para destacar
                      ),
                    ),
                    Text(
                      'S/ ${widget.product.groupPrice3.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color:
                            AppColors.primaryYellow, // Amarillo para destacar
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(
                      Icons.group,
                      size: 16,
                      color: Colors.white.withOpacity(0.7),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Faltan 2 personas para este descuento',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Active Groups List
          Text(
            'Grupos activos buscando este producto:',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          if (_isLoadingGroups)
            const Center(
              child: CircularProgressIndicator(color: AppColors.primaryYellow),
            )
          else if (_activeGroups.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Column(
                children: [
                  Text(
                    'No hay grupos activos. ¡Sé el primero en crear uno!',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextButton(
                    onPressed: _loadGroups,
                    child: Text(
                      'Actualizar lista',
                      style: TextStyle(color: AppColors.primaryYellow),
                    ),
                  ),
                ],
              ),
            )
          else
            ..._activeGroups.map((group) => _buildGroupCard(group)),
          const SizedBox(height: 16),

          // Start My Own Group Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              // Cambiado a ElevatedButton
              onPressed: _startNewGroup,
              icon: Icon(
                Icons.add_circle_outline,
                color: AppColors.deepBlack,
              ), // Icono negro
              label: Text(
                'Iniciar mi propio grupo',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBlack, // Texto negro
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow, // Fondo amarillo
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGroupCard(GroupPurchase group) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.deepBlack,
              shape: BoxShape.circle,
              image: group.creatorAvatarUrl.isNotEmpty
                  ? DecorationImage(
                      image: NetworkImage(group.creatorAvatarUrl),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: group.creatorAvatarUrl.isNotEmpty
                ? null
                : Center(
                    child: Text(
                      group.creatorInitials,
                      style: const TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
          ),
          const SizedBox(width: 12),
          // Group Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.isCurrentUserMember
                      ? 'Tu grupo'
                      : 'Grupo de ${group.creatorName}',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${group.currentMembers}/${group.requiredMembers} personas',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 12,
                    color: AppColors.inkSoft,
                  ),
                ),
              ],
            ),
          ),
          // Join Button
          if (group.isCurrentUserMember)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check, size: 16, color: Colors.green),
                  const SizedBox(width: 4),
                  Text(
                    'Unido',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            )
          else
            ElevatedButton(
              onPressed: group.isComplete ? null : () => _joinGroup(group),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow, // Fondo Amarillo
                foregroundColor: AppColors.deepBlack, // Texto Negro
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                '¡Unirme!',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Individual Purchase Button
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Compra individual iniciada: S/ ${widget.product.currentPrice.toStringAsFixed(2)}',
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: AppColors.ink, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Comprar Individualmente',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'S/ ${widget.product.currentPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Group Purchase Button with Quantity Selector
            Expanded(
              child: Container(
                height: 56, // Altura fija para igualar al otro botón
                decoration: BoxDecoration(
                  color: AppColors.primaryYellow,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Decrement Button
                    IconButton(
                      onPressed: () {
                        if (_quantity > 1) {
                          setState(() {
                            _quantity--;
                          });
                        }
                      },
                      icon: Icon(Icons.remove, color: AppColors.deepBlack),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),

                    // Action Button (Center)
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Iniciando compra en grupo de $_quantity unidades: S/ ${(widget.product.groupPrice3 * _quantity).toStringAsFixed(2)}',
                              ),
                              backgroundColor: AppColors.deepBlack,
                            ),
                          );
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Iniciar ($_quantity)',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepBlack,
                              ),
                            ),
                            Text(
                              'S/ ${(widget.product.groupPrice3 * _quantity).toStringAsFixed(2)}',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepBlack,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Increment Button
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _quantity++;
                        });
                      },
                      icon: Icon(Icons.add, color: AppColors.deepBlack),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
