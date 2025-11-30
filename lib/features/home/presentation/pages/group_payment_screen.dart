import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../domain/models/product.dart';
import '../../domain/models/group_purchase.dart';

import '../../../../data/repositories/match_group_repository.dart';
import '../../../../data/repositories/match_group_member_repository.dart';
import '../../../../data/repositories/transaction_repository.dart';
import '../../../../services/supabase_service.dart';
import 'order_tracking_screen.dart';

/// Pantalla de pago de grupo
class GroupPaymentScreen extends StatefulWidget {
  final Product product;
  final GroupPurchase group;
  final String? selectedSize;
  final String dealId;
  final bool isJoining;

  const GroupPaymentScreen({
    super.key,
    required this.product,
    required this.group,
    this.selectedSize,
    required this.dealId,
    required this.isJoining,
  });

  @override
  State<GroupPaymentScreen> createState() => _GroupPaymentScreenState();
}

class _GroupPaymentScreenState extends State<GroupPaymentScreen> {
  String _selectedPaymentMethod = 'card'; // 'card', 'yape', 'plin'
  String? _selectedCardId;
  bool _isAddingNewCard = false;
  String _selectedSubMethod = 'push'; // 'push' o 'qr' para Yape/Plin
  final TextEditingController _phoneController = TextEditingController();

  // Controllers for new card
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cardHolderController = TextEditingController();

  final List<Map<String, dynamic>> _savedCards = [
    {'id': '1', 'type': 'visa', 'last4': '4567', 'expiry': '12/25'},
    {'id': '2', 'type': 'mastercard', 'last4': '8901', 'expiry': '08/26'},
  ];

  bool _isProcessing = false;
  final _groupRepository = MatchGroupRepository();
  final _memberRepository = MatchGroupMemberRepository();
  final _transactionRepository = TransactionRepository();

  @override
  void initState() {
    super.initState();
    // Seleccionar la primera tarjeta por defecto
    if (_savedCards.isNotEmpty) {
      _selectedCardId = _savedCards[0]['id'] as String;
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cardHolderController.dispose();
    super.dispose();
  }

  double get _groupPrice => widget.group.groupPrice;
  double get _originalPrice => widget.product.originalPrice;
  double get _savings => _originalPrice - _groupPrice;
  int get _quantity => 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: const EdgeInsets.all(8),
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
            child: Icon(Icons.arrow_back, color: AppColors.deepBlack, size: 20),
          ),
        ),
        title: Text(
          'Finalizar Pago de Grupo',
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Summary Card
            _buildProductSummaryCard(),
            const SizedBox(height: 24),

            // Payment Method Section
            _buildPaymentMethodSection(),
            const SizedBox(height: 24),

            // Secure Payment Info
            _buildSecurePaymentInfo(),
            const SizedBox(height: 100), // Space for button
          ],
        ),
      ),
      bottomNavigationBar: _buildConfirmButton(),
    );
  }

  Widget _buildProductSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
        border: Border.all(color: AppColors.line),
      ),
      child: Column(
        children: [
          // Product Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.product.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      style: TextStyle(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          'S/ ${_originalPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            color: AppColors.inkSoft,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'S/ ${_groupPrice.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.statusSuccess,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Savings Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.success.withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.savings_outlined,
                  color: AppColors.success,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ahorro por compra en grupo: S/ ${_savings.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quantity
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Cantidad',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  color: AppColors.inkSoft,
                ),
              ),
              Text(
                '$_quantity unidad',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          // Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Monto a Pagar',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              Text(
                'S/ ${_groupPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepBlack,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Método de Pago',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 16),

        // Payment Method Tabs
        Row(
          children: [
            Expanded(
              child: _buildPaymentTab(
                'card',
                'Tarjeta',
                'assets/MasterCard_Logo.svg.png', // Updated to Mastercard logo
                _selectedPaymentMethod == 'card',
                AppColors.deepBlack,
                isImage: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPaymentTab(
                'yape',
                'Yape',
                'assets/yape.png', // Imagen real de Yape
                _selectedPaymentMethod == 'yape',
                const Color(0xFF7B2CBF), // Púrpura Yape
                isImage: true,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPaymentTab(
                'plin',
                'Plin',
                'assets/pin.png', // Imagen real de Plin
                _selectedPaymentMethod == 'plin',
                const Color(0xFF0066CC), // Azul Plin oficial
                isImage: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Saved Cards (only show if card is selected)
        if (_selectedPaymentMethod == 'card') ...[
          if (!_isAddingNewCard) ...[
            ..._savedCards.map((card) => _buildSavedCard(card)),
            const SizedBox(height: 12),
            _buildAddNewCardButton(),
          ] else ...[
            _buildNewCardForm(),
          ],
        ],

        // Yape or Plin options
        if (_selectedPaymentMethod == 'yape' ||
            _selectedPaymentMethod == 'plin') ...[
          _buildDigitalWalletOptions(),
        ],
      ],
    );
  }

  Widget _buildPaymentTab(
    String method,
    String label,
    String iconPath,
    bool isSelected,
    Color color, {
    bool isImage = false,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
          if (method != 'card') {
            _selectedCardId = null;
            _selectedSubMethod = 'push'; // Resetear a push por defecto
          }
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            SizedBox(
              width: 40,
              height: 40,
              child: isImage
                  ? Image.asset(iconPath, fit: BoxFit.contain)
                  : isSelected
                  ? SvgPicture.asset(
                      iconPath,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    )
                  : SvgPicture.asset(
                      iconPath,
                      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                    ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSavedCard(Map<String, dynamic> card) {
    final isSelected = _selectedCardId == card['id'];
    final cardType = card['type'] as String;
    final cardIconPath = cardType == 'visa'
        ? 'assets/iconos/visa.svg'
        : 'assets/MasterCard_Logo.svg.png'; // Imagen real de Mastercard
    final isMastercard = cardType == 'mastercard';
    final cardColor = cardType == 'visa'
        ? AppColors
              .deepBlack // Changed from Blue to Black
        : const Color(0xFFEB001B); // Rojo Mastercard oficial

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCardId = card['id'] as String;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? cardColor : AppColors.line,
            width: isSelected ? 2.5 : 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: cardColor.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 36,
              decoration: BoxDecoration(
                color: isMastercard ? Colors.white : cardColor,
                borderRadius: BorderRadius.circular(6),
                border: isMastercard
                    ? Border.all(color: Colors.grey[200]!, width: 1)
                    : null,
              ),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: isMastercard
                    ? Image.asset(cardIconPath, fit: BoxFit.contain)
                    : SvgPicture.asset(
                        cardIconPath,
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                      ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${cardType.toUpperCase()} •••• ${card['last4']}',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Vence ${card['expiry']}',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 13,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.statusSuccess.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_rounded,
                  color: AppColors.statusSuccess,
                  size: 28,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewCardButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isAddingNewCard = true;
          _selectedCardId = null;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey[300]!,
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add_circle_outline, color: AppColors.inkSoft, size: 20),
            const SizedBox(width: 8),
            Text(
              'Agregar Nueva Tarjeta',
              style: TextStyle(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.inkSoft,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewCardForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Nueva Tarjeta',
                style: TextStyle(
                  fontFamily: 'Plus Jakarta Sans',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.ink,
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    _isAddingNewCard = false;
                    if (_savedCards.isNotEmpty) {
                      _selectedCardId = _savedCards[0]['id'] as String;
                    }
                  });
                },
                child: Text('Cancelar', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Card Number
          _buildTextField(
            controller: _cardNumberController,
            label: 'Número de Tarjeta',
            hint: '0000 0000 0000 0000',
            keyboardType: TextInputType.number,
            icon: Icons.credit_card,
          ),
          const SizedBox(height: 12),
          // Expiry and CVV
          Row(
            children: [
              Expanded(
                child: _buildTextField(
                  controller: _expiryController,
                  label: 'Vencimiento',
                  hint: 'MM/AA',
                  keyboardType: TextInputType.datetime,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTextField(
                  controller: _cvvController,
                  label: 'CVV',
                  hint: '123',
                  keyboardType: TextInputType.number,
                  isPassword: true,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Card Holder Name
          _buildTextField(
            controller: _cardHolderController,
            label: 'Nombre del Titular',
            hint: 'Como aparece en la tarjeta',
            keyboardType: TextInputType.name,
            icon: Icons.person_outline,
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: Colors.grey[400],
            ),
            prefixIcon: icon != null
                ? Icon(icon, color: Colors.grey[500], size: 20)
                : null,
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.primaryYellow,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDigitalWalletOptions() {
    final isYape = _selectedPaymentMethod == 'yape';
    final primaryColor = isYape
        ? const Color(0xFF7B2CBF) // Púrpura Yape oficial
        : const Color(0xFF0066CC); // Azul Plin oficial
    final accountName = isYape ? 'Yape' : 'Plin';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Selecciona el método de pago',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 14,
            color: AppColors.inkSoft,
          ),
        ),
        const SizedBox(height: 16),

        // Opciones: Push Notification y QR Code
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.line, width: 1),
          ),
          child: Column(
            children: [
              // Push Notification Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSubMethod = 'push';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _selectedSubMethod == 'push'
                        ? primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.phone_android,
                            color: _selectedSubMethod == 'push'
                                ? primaryColor
                                : AppColors.inkSoft,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Notificación Push',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedSubMethod == 'push'
                                        ? primaryColor
                                        : AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Aprueba desde tu app',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    color: primaryColor.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (_selectedSubMethod == 'push')
                            Icon(
                              Icons.check_circle,
                              color: AppColors.statusSuccess,
                              size: 24,
                            ),
                        ],
                      ),
                      if (_selectedSubMethod == 'push') ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '🔔 Notificación enviada a tu celular',
                                  ),
                                  backgroundColor: primaryColor,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.notifications_active,
                              size: 18,
                            ),
                            label: const Text('Enviar Notificación'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              textStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // QR Code Option
              GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSubMethod = 'qr';
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: _selectedSubMethod == 'qr'
                        ? primaryColor.withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.qr_code,
                            color: _selectedSubMethod == 'qr'
                                ? primaryColor
                                : AppColors.inkSoft,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Código QR',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _selectedSubMethod == 'qr'
                                        ? primaryColor
                                        : AppColors.ink,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Escanea para pagar',
                                  style: TextStyle(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 12,
                                    color: primaryColor.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (_selectedSubMethod == 'qr') ...[
                        const SizedBox(height: 16),
                        Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.qr_code_2,
                              size: 150,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Escanea con tu app de $accountName',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Phone Number Input
        Text(
          'Número de celular',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.ink,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _phoneController,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            hintText: '999 999 999',
            hintStyle: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: Colors.grey[400],
            ),
            filled: true,
            fillColor: AppColors.primaryYellow.withOpacity(0.2),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.line, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.line, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: primaryColor, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Número vinculado a tu cuenta $accountName',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 12,
            color: primaryColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurePaymentInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.deepBlack,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pago Seguro en Custodia',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tu pago se mantendrá en custodia hasta que el grupo esté completo. '
            'Si el grupo no se completa en 7 días, recibirás un reembolso automático.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Container(
      padding: const EdgeInsets.all(20),
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
        child: SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isProcessing
                ? null
                : () async {
                    // Validar que se haya seleccionado un método de pago
                    if (_selectedPaymentMethod == 'card') {
                      if (!_isAddingNewCard && _selectedCardId == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Por favor selecciona una tarjeta'),
                            backgroundColor: AppColors.statusError,
                          ),
                        );
                        return;
                      } else if (_isAddingNewCard) {
                        if (_cardNumberController.text.isEmpty ||
                            _expiryController.text.isEmpty ||
                            _cvvController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Por favor completa los datos de la tarjeta',
                              ),
                              backgroundColor: AppColors.statusError,
                            ),
                          );
                          return;
                        }
                      }
                    }

                    if ((_selectedPaymentMethod == 'yape' ||
                            _selectedPaymentMethod == 'plin') &&
                        _phoneController.text.trim().isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Por favor ingresa tu número de celular',
                          ),
                          backgroundColor: AppColors.statusError,
                        ),
                      );
                      return;
                    }

                    setState(() {
                      _isProcessing = true;
                    });

                    try {
                      final userId =
                          SupabaseService.client.auth.currentUser?.id;
                      if (userId == null) {
                        throw 'Usuario no autenticado';
                      }

                      String groupId;

                      if (widget.isJoining) {
                        groupId = widget.group.id;
                        // Verificar si el grupo aún tiene espacio (opcional, ya se valida en UI)
                      } else {
                        // Crear nuevo grupo
                        final newGroup = await _groupRepository.createGroup(
                          dealId: widget.dealId,
                          maxGroupSize: widget.group.requiredMembers,
                          status: 'open',
                        );
                        groupId = newGroup.id;
                      }

                      // Agregar miembro al grupo
                      await _memberRepository.addMemberToGroup(
                        groupId: groupId,
                        userId: userId,
                        role: widget.isJoining ? 'member' : 'creator',
                        deliveryAddress: 'Av. Larco 1234, Miraflores', // Mock
                        deliveryLat: -12.12, // Mock
                        deliveryLng: -77.03, // Mock
                      );

                      // Registrar transacción
                      await _transactionRepository.createTransaction(
                        matchGroupId: groupId,
                        payerUserId: userId,
                        amountTotal: _groupPrice,
                        platformFee: 0.0, // Mock
                        deliveryFee: 0.0, // Mock
                        paymentStatus: 'pending',
                        stripePaymentId: 'mock_payment_id',
                      );

                      // Verificar si el grupo se completó con este usuario
                      bool isGroupComplete = false;
                      if (widget.isJoining) {
                        // Si me uno a un grupo existente, sumo 1 al conteo actual
                        final newMemberCount = widget.group.currentMembers + 1;
                        isGroupComplete =
                            newMemberCount >= widget.group.requiredMembers;
                      } else {
                        // Si creo un nuevo grupo, soy el primer miembro
                        // El grupo estará completo solo si requiredMembers es 1
                        isGroupComplete = 1 >= widget.group.requiredMembers;
                      }

                      if (mounted) {
                        if (isGroupComplete) {
                          // Si el grupo se completó, ir a la pantalla de seguimiento
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderTrackingScreen(
                                product: widget.product,
                                orderCode:
                                    'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                                paymentMethod: _selectedPaymentMethod == 'card'
                                    ? 'Tarjeta ${_savedCards.firstWhere((c) => c['id'] == _selectedCardId, orElse: () => {'type': 'Unknown'})['type']?.toString().toUpperCase()}'
                                    : _selectedPaymentMethod == 'yape'
                                    ? 'Yape'
                                    : 'Plin',
                                shippingCost: 5.00, // Mock shipping cost
                                deliveryAddress:
                                    'Av. Larco 1234, Miraflores', // Mock address
                              ),
                            ),
                          );
                        } else {
                          // Si no se completó, volver a la pantalla anterior
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                '¡Grupo creado exitosamente! Esperando a otros miembros.',
                              ),
                              backgroundColor: AppColors.statusSuccess,
                            ),
                          );
                          Navigator.of(context).pop(true);
                        }
                      }
                    } catch (e) {
                      if (mounted) {
                        setState(() {
                          _isProcessing = false;
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error al procesar el pago: $e'),
                            backgroundColor: AppColors.statusError,
                          ),
                        );
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryYellow,
              foregroundColor: AppColors.deepBlack,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: _isProcessing
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.deepBlack,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Pagar S/ ${_groupPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
