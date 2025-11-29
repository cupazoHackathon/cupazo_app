import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/ui/widgets/widgets.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/gradients.dart';
import '../../../../core/ui/theme/spacing.dart';
import '../../../../app/di/injection_container.dart';
import '../../../../shared/constants/routes.dart';

/// Pantalla de Registro
class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _auth = InjectionContainer.authService;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _dniController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _dniController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      if (!_acceptTerms) {
        AppSnackbar.show(
          context,
          message: 'Debes aceptar los términos y condiciones',
          icon: Icons.error_outline,
        );
        return;
      }

      setState(() => _isLoading = true);

      // TODO: Implementar lógica de registro real con API
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      setState(() => _isLoading = false);

      // Mostrar mensaje de éxito
      AppSnackbar.show(
        context,
        message: 'Cuenta creada exitosamente',
        icon: Icons.check_circle_outline,
      );

      // Navegar a Login o directamente a Home
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;

      Navigator.pushReplacementNamed(
        context,
        AppRoutes.login,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    // Header height is 25% of screen height, but at least 180px
    final double headerHeight = (size.height * 0.25).clamp(180.0, 400.0);

    return AppScaffold(
      showAppBar: false,
      body: Column(
        children: [
          // Header con curva y gradiente
          Container(
            height: headerHeight,
            decoration: const BoxDecoration(gradient: AppGradients.flameHero),
            child: Stack(
              children: [
                // Botón de regreso
                Positioned(
                  top: 40,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                // Contenido del header alineado a la izquierda
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CupazoWordmark(
                    padding: const EdgeInsets.fromLTRB(24, 40, 24, 0),
                  ),
                ),
                // Curva decorativa
                Positioned(
                  bottom: -1,
                  left: 0,
                  right: 0,
                  child: CustomPaint(
                    size: Size(MediaQuery.of(context).size.width, 50),
                    painter: _WavePainter(),
                  ),
                ),
              ],
            ),
          ),

          // Contenido principal
          Expanded(
            child: Container(
              color: const Color(0xFFF5F5F7),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: AppSpacing.md),

                          // Tarjeta blanca con formulario
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.xl),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Título principal
                                Text(
                                  'Comienza gratis',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.5,
                                    height: 1.2,
                                    color: AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Subtítulo
                                Text(
                                  'Crea tu cuenta en minutos',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 15,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0,
                                    height: 1.4,
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                                const SizedBox(height: 32),

                                // Campo Nombre
                                AppTextField(
                                  label: 'Nombre completo',
                                  hint: 'Ingresa tu nombre',
                                  leadingIcon: Icons.person_outline,
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El nombre es requerido';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Campo Email
                                AppTextField(
                                  label: 'Email',
                                  hint: 'tu@email.com',
                                  leadingIcon: Icons.email_outlined,
                                  controller: _emailController,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El email es requerido';
                                    }
                                    final emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                    );
                                    if (!emailRegex.hasMatch(value)) {
                                      return 'Email inválido';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Campo DNI
                                AppTextField(
                                  label: 'DNI',
                                  hint: 'Ingresa tu DNI',
                                  leadingIcon: Icons.badge_outlined,
                                  controller: _dniController,
                                  keyboardType: TextInputType.number,
                                  maxLength: 8,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'El DNI es requerido';
                                    }
                                    if (value.length != 8) {
                                      return 'El DNI debe tener 8 dígitos';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Campo Contraseña
                                AppTextField(
                                  label: 'Contraseña',
                                  hint: 'Mínimo 6 caracteres',
                                  leadingIcon: Icons.lock_outline,
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscurePassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: AppColors.inkMuted,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () => _obscurePassword =
                                            !_obscurePassword,
                                      );
                                    },
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'La contraseña es requerida';
                                    }
                                    if (value.length < 6) {
                                      return 'La contraseña debe tener al menos 6 caracteres';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Campo Confirmar Contraseña
                                AppTextField(
                                  label: 'Confirmar contraseña',
                                  hint: 'Repite tu contraseña',
                                  leadingIcon: Icons.lock_outline,
                                  controller: _confirmPasswordController,
                                  obscureText: _obscureConfirmPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _obscureConfirmPassword
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined,
                                      color: AppColors.inkMuted,
                                      size: 24,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () => _obscureConfirmPassword =
                                            !_obscureConfirmPassword,
                                      );
                                    },
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Confirma tu contraseña';
                                    }
                                    if (value != _passwordController.text) {
                                      return 'Las contraseñas no coinciden';
                                    }
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 20),

                                // Checkbox términos
                                AppCheckbox(
                                  value: _acceptTerms,
                                  onChanged: (value) {
                                    setState(
                                      () => _acceptTerms = value ?? false,
                                    );
                                  },
                                  label: 'Acepto los términos y condiciones',
                                ),
                                const SizedBox(height: 24),

                                // Botón Registro
                                PrimaryButton(
                                  text: 'Crear cuenta',
                                  onPressed: _handleSignUp,
                                  isLoading: _isLoading,
                                  fullWidth: true,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Divider "O regístrate con"
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.line,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                child: Text(
                                  'O regístrate con',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 0,
                                    height: 1.4,
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 1,
                                  color: AppColors.line,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Botón social - Google solo, centrado
                          Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: _SocialButton(
                                assetPath: 'assets/iconos/google.svg',
                                label: 'Google',
                                onPressed: () async {
                                  setState(() => _isLoading = true);
                                  try {
                                    await _auth.loginWithGoogle();
                                    if (mounted) {
                                      Navigator.pushReplacementNamed(
                                        context,
                                        AppRoutes.home,
                                      );
                                    }
                                  } catch (e) {
                                    debugPrint('Error registro Google: $e');
                                    if (mounted) {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(content: Text('Error: $e')),
                                      );
                                    }
                                  } finally {
                                    if (mounted)
                                      setState(() => _isLoading = false);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Link a login
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  '¿Ya tienes cuenta? ',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    letterSpacing: 0,
                                    height: 1.4,
                                    color: AppColors.inkMuted,
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      AppRoutes.login,
                                    );
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 4,
                                    ),
                                    minimumSize: const Size(44, 44),
                                  ),
                                  child: Text(
                                    'Iniciar sesión',
                                    style: TextStyle(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0,
                                      height: 1.4,
                                      color: AppColors.primaryBlue,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// CustomPainter para la curva del header
class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFF5F5F7)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, 50, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Widget para botones sociales
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
    return SizedBox(
      height: 52,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
          side: BorderSide(color: AppColors.line, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                assetPath,
                width: 24,
                height: 24,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0,
                  height: 1.4,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


