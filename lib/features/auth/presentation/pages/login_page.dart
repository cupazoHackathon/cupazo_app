import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../app/di/injection_container.dart';
import '../../../../shared/constants/routes.dart';
import '../../../../core/ui/widgets/widgets.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/gradients.dart';
import '../../../../core/ui/theme/typography.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _auth = InjectionContainer.authService;
  bool _isLoading = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      await _controller.forward();
      await _auth.loginWithGoogle();
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      }
    } catch (e) {
      debugPrint('Error login: $e');
      _controller.reverse();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al iniciar sesión: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    final size = MediaQuery.of(context).size;
    final double baseHeaderHeight = (size.height * 0.30).clamp(220.0, 400.0);

    if (user != null) {
      return _buildLoggedInView(user);
    }

    return AppScaffold(
      showAppBar: false,
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFFFFFFFF), Color(0xFFF2F4F7)],
              ),
            ),
          ),

          // Main Content
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: baseHeaderHeight + 20), // Clear the header
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    physics: const BouncingScrollPhysics(),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 600),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            _buildLoginCard(),
                            const SizedBox(height: 40),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Animated Header
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final currentHeight =
                    baseHeaderHeight +
                    (size.height + 100 - baseHeaderHeight) *
                        CurvedAnimation(
                          parent: _controller,
                          curve: Curves.easeInOutCubic,
                        ).value;

                return SizedBox(
                  height: currentHeight,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: AppGradients.flameHero,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryBlue.withOpacity(0.25),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Decorative Waves
                      Positioned(
                        bottom: -1,
                        left: 0,
                        right: 0,
                        child: CustomPaint(
                          size: Size(size.width, 60),
                          painter: _WavePainter(opacity: 0.3, offset: 0),
                        ),
                      ),
                      Positioned(
                        bottom: -1,
                        left: 0,
                        right: 0,
                        child: CustomPaint(
                          size: Size(size.width, 60),
                          painter: _WavePainter(opacity: 1.0, offset: 20),
                        ),
                      ),

                      // Back Button
                      if (Navigator.canPop(context) && _controller.value == 0)
                        Positioned(
                          top: MediaQuery.of(context).padding.top + 10,
                          left: 16,
                          child: IconButton(
                            icon: const Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),

                      // Wordmark
                      Positioned(
                        top: 0,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          child: Opacity(
                            opacity: (1.0 - _controller.value).clamp(0.0, 1.0),
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: CupazoWordmark(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInView(dynamic user) {
    return AppScaffold(
      showAppBar: true,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user.userMetadata?['avatar_url'] != null)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppGradients.flameHero,
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    user.userMetadata!['avatar_url'] as String,
                  ),
                  radius: 40,
                ),
              ),
            const SizedBox(height: 16),
            Text(
              'Hola, ${user.userMetadata?['full_name'] ?? user.userMetadata?['name'] ?? 'usuario'}',
              style: AppTypography.title,
            ),
            const SizedBox(height: 8),
            Text(user.email ?? '', style: AppTypography.body),
            const SizedBox(height: 32),
            PrimaryButton(
              text: 'Cerrar sesión',
              onPressed: () async {
                setState(() => _isLoading = true);
                try {
                  await _auth.logout();
                  setState(() {});
                } catch (e) {
                  debugPrint('Error logout: $e');
                } finally {
                  setState(() => _isLoading = false);
                }
              },
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
              child: const Text('Ir al Inicio'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoginCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Bienvenido !!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.5,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Inicia sesión para continuar',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            color: AppColors.inkMuted,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 40),

        // Login Button with Glow
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryBlue.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: PrimaryButton(
            text: 'Iniciar sesión',
            onPressed: _login,
            isLoading: _isLoading,
            fullWidth: true,
          ),
        ),

        const SizedBox(height: 32),

        // Divider
        Row(
          children: [
            Expanded(child: Container(height: 1, color: AppColors.line)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'O continúa con',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.inkMuted,
                ),
              ),
            ),
            Expanded(child: Container(height: 1, color: AppColors.line)),
          ],
        ),
        const SizedBox(height: 32),

        // Social Button - Google only, centered
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: _SocialButton(
              assetPath: 'assets/iconos/google.svg',
              label: 'Google',
              onPressed: _login,
            ),
          ),
        ),
        const SizedBox(height: 32),

        // Register Link
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '¿No tienes cuenta? ',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15,
                  color: AppColors.inkMuted,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.pushNamed(context, AppRoutes.signUp),
                child: Text(
                  'Regístrate',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WavePainter extends CustomPainter {
  final double opacity;
  final double offset;

  _WavePainter({this.opacity = 1.0, this.offset = 0.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFFFFFFF).withOpacity(opacity)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(
      size.width * 0.25,
      40 + offset,
      size.width * 0.5,
      20 + offset,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      0 + offset,
      size.width,
      30 + offset,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.opacity != opacity || oldDelegate.offset != offset;
}

class _SocialButton extends StatelessWidget {
  final String assetPath;
  final String label;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.assetPath,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.ink,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: AppColors.line.withOpacity(0.5),
            width: 1,
          ),
        ),
        shadowColor: Colors.black.withOpacity(0.1),
      ).copyWith(
        elevation: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) return 0;
          return 2;
        }),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetPath,
            width: 22,
            height: 22,
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

