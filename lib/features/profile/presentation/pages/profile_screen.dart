import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../services/supabase_service.dart';
import '../../../auth/presentation/pages/login_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = 'Usuario';
  String _userEmail = 'usuario@email.com';
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final user = SupabaseService.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _userEmail = user.email ?? '';
        // Intentar obtener nombre y avatar de user_metadata (Google Auth)
        _userName =
            user.userMetadata?['full_name'] ??
            user.userMetadata?['name'] ??
            'Usuario';
        _avatarUrl =
            user.userMetadata?['avatar_url'] ?? user.userMetadata?['picture'];
      });
    }
  }

  Future<void> _signOut() async {
    try {
      await SupabaseService.client.auth.signOut();
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al cerrar sesión: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.deepBlack),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Mi Perfil',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.deepBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                      border: Border.all(
                        color: AppColors.primaryYellow,
                        width: 2,
                      ),
                      image: _avatarUrl != null
                          ? DecorationImage(
                              image: NetworkImage(_avatarUrl!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _avatarUrl == null
                        ? const Icon(Icons.person, size: 50, color: Colors.grey)
                        : null,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _userName,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.deepBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _userEmail,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      color: Colors.purple[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Miembro desde Enero 2024',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Stats Row
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!),
                  bottom: BorderSide(color: Colors.grey[200]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem('12', 'Pedidos'),
                  _buildVerticalDivider(),
                  _buildStatItem('5', 'En Grupo'),
                  _buildVerticalDivider(),
                  _buildStatItem('8', 'Favoritos'),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Menu Options
            _buildMenuItem(
              icon: Icons.shopping_bag_outlined,
              title: 'Mis Pedidos',
              subtitle: 'Ver historial de compras',
              color: AppColors.primaryYellow,
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.favorite_border,
              title: 'Favoritos',
              subtitle: 'Productos guardados',
              color: Colors.pink,
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.location_on_outlined,
              title: 'Direcciones',
              subtitle: 'Gestionar direcciones de envío',
              color: Colors.teal,
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.credit_card,
              title: 'Métodos de Pago',
              subtitle: 'Tarjetas y billeteras',
              color: Colors.orange,
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.notifications_none,
              title: 'Notificaciones',
              subtitle: 'Configurar alertas',
              color: Colors.amber,
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.help_outline,
              title: 'Ayuda y Soporte',
              subtitle: 'Centro de ayuda',
              color: Colors.purple,
              onTap: () {},
            ),
            _buildMenuItem(
              icon: Icons.settings_outlined,
              title: 'Configuración',
              subtitle: 'Preferencias de cuenta',
              color: Colors.grey,
              onTap: () {},
            ),
            const SizedBox(height: 32),

            // Logout Button
            TextButton.icon(
              onPressed: _signOut,
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Cerrar Sesión',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.deepBlack,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: Colors.grey[200]);
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.deepBlack,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
