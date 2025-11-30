import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../shared/constants/routes.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../core/ui/theme/typography.dart';

/// Pantalla de registro con formulario completo
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Strong orange color for buttons
  static const Color _strongOrange = Color(0xFFFF6B35);
  // Deep blue for titles
  static const Color _deepBlue = Color(0xFF0D47A1);
  // Light blue for info card
  static const Color _lightBlue = Color(0xFFE3F2FD);
  // Dark blue for info card border
  static const Color _darkBlue = Color(0xFF1976D2);
  // Light yellow for confirmation message
  static const Color _lightYellow = Color(0xFFFFF9C4);
  static const Color _darkYellow = Color(0xFFFFD54F);

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _cityController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final supabase = Supabase.instance.client;

      // Sign up with Supabase
      final response = await supabase.auth.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        data: {
          'full_name': _nameController.text.trim(),
          'city': _cityController.text.trim(),
          'phone': _phoneController.text.trim(),
        },
      );

      if (!mounted) return;

      if (response.user != null) {
        // Show success dialog
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text(
              '¡Cuenta creada!',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.bold,
              ),
            ),
            content: const Text(
              'Te hemos enviado un correo de confirmación. Por favor revisa tu bandeja de entrada.',
              style: TextStyle(fontFamily: 'Plus Jakarta Sans'),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil(AppRoutes.login, (route) => false);
                },
                child: const Text(
                  'Aceptar',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    color: _strongOrange,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          _errorMessage =
              'Error al crear la cuenta. Por favor intenta de nuevo.';
        });
      }
    } on AuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error inesperado: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Widget _buildYellowBorderedTextField({
    required String label,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.bodySmall),
        const SizedBox(height: 8),
        Container(
          height: 52,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryYellow, width: 2),
          ),
          child: TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            validator: validator,
            style: AppTypography.body,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTypography.body.copyWith(color: AppColors.inkSoft),
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 8),
                child: Icon(icon, color: AppColors.inkMuted, size: 22),
              ),
              prefixIconConstraints: const BoxConstraints(
                minWidth: 42,
                minHeight: 52,
              ),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 0,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background, // Light cream
              Color(0xFFFFFFFF), // White
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),

                    // Logo placeholder (user will replace with asset)
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.image,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Title: Cupazo
                    Text(
                      'Cupazo',
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: _deepBlue,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    Text(
                      'Únete a la comunidad de compras colaborativas',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        color: _deepBlue.withOpacity(0.8),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // White card with form
                    Container(
                      padding: const EdgeInsets.all(24),
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Title: Crear Cuenta
                            Text(
                              'Crear Cuenta',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: _deepBlue,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Nombre completo
                            _buildYellowBorderedTextField(
                              label: 'Nombre completo',
                              hint: 'Juan Pérez',
                              icon: Icons.person_outline,
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El nombre es requerido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Correo electrónico
                            _buildYellowBorderedTextField(
                              label: 'Correo electrónico',
                              hint: 'tu@email.com',
                              icon: Icons.email_outlined,
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El correo es requerido';
                                }
                                final emailRegex = RegExp(
                                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                );
                                if (!emailRegex.hasMatch(value)) {
                                  return 'Correo inválido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Contraseña
                            _buildYellowBorderedTextField(
                              label: 'Contraseña',
                              hint: '********',
                              icon: Icons.lock_outline,
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
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'La contraseña es requerida';
                                }
                                if (value.length < 8) {
                                  return 'Mínimo 8 caracteres';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 8),

                            // Helper text for password
                            Text(
                              'Mínimo 8 caracteres. Usa una combinación de letras, números y símbolos.',
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                color: AppColors.inkSoft,
                              ),
                            ),
                            const SizedBox(height: 20),

                            // Ciudad / Distrito
                            _buildYellowBorderedTextField(
                              label: 'Ciudad / Distrito',
                              hint: 'Miraflores, Lima',
                              icon: Icons.location_on_outlined,
                              controller: _cityController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'La ciudad es requerida';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),

                            // Teléfono
                            _buildYellowBorderedTextField(
                              label: 'Teléfono',
                              hint: '999 999 999',
                              icon: Icons.phone_outlined,
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'El teléfono es requerido';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 24),

                            // Verification info card
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _lightBlue,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: _darkBlue, width: 1),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: _darkBlue,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Proceso de verificación',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: _deepBlue,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Después del registro te pediremos verificar tu identidad mediante tu documento de identidad. Solo personas reales participan en las compras colaborativas.',
                                          style: TextStyle(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 12,
                                            color: _deepBlue,
                                            height: 1.4,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Crear Cuenta button
                            SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _handleSignUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: _strongOrange,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor: Colors.grey[300],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Colors.white,
                                              ),
                                        ),
                                      )
                                    : const Text(
                                        'Crear Cuenta',
                                        style: TextStyle(
                                          fontFamily: 'Plus Jakarta Sans',
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Error message
                            if (_errorMessage != null)
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.accentDanger.withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _errorMessage!,
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    color: AppColors.accentDanger,
                                  ),
                                ),
                              ),

                            // Confirmation message box
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: _lightYellow,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: _darkYellow,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                'Te enviaremos un correo para confirmar tu cuenta. Hasta que la confirmes, no podrás usar Cupazo.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12,
                                  color: AppColors.ink,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Footer: ¿Ya tienes una cuenta?
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¿Ya tienes una cuenta? ',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 15,
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
                          child: const Text(
                            'Inicia sesión aquí',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: _strongOrange,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
