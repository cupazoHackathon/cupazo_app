import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../domain/models/product.dart';
import '../../domain/models/group_purchase.dart';
import 'order_tracking_screen.dart';

/// Pantalla de pago de grupo
class GroupPaymentScreen extends StatefulWidget {
  final Product product;
  final GroupPurchase group;
  final String? selectedSize;

  const GroupPaymentScreen({
    super.key,
    required this.product,
    required this.group,
    this.selectedSize,
  });

  @override
  State<GroupPaymentScreen> createState() => _GroupPaymentScreenState();
}

class _GroupPaymentScreenState extends State<GroupPaymentScreen> {
  String _selectedPaymentMethod = 'card'; // 'card', 'yape', 'plin'
  String? _selectedCardId;
  String _selectedSubMethod = 'push'; // 'push' o 'qr' para Yape/Plin
  final TextEditingController _phoneController = TextEditingController();

  final List<Map<String, dynamic>> _savedCards = [
    {
      'id': '1',
      'type': 'visa',
      'last4': '4567',
      'expiry': '12/25',
    },
    {
      'id': '2',
      'type': 'mastercard',
      'last4': '8901',
      'expiry': '08/26',
    },
  ];

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
    super.dispose();
  }

  double get _groupPrice => widget.group.groupPrice;
  double get _originalPrice => widget.product.originalPrice;
  double get _savings => _originalPrice - _groupPrice;
  int get _quantity => 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF8E1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.deepBlack),
          onPressed: () => Navigator.of(context).pop(),
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
        centerTitle: false,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
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
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.statusSuccess.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.savings,
                  color: AppColors.statusSuccess,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Ahorro por compra en grupo: S/ ${_savings.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.statusSuccess,
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
                  color: const Color(0xFFFF8A00),
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
                Icons.credit_card,
                _selectedPaymentMethod == 'card',
                Colors.blue,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPaymentTab(
                'yape',
                'Yape',
                Icons.account_balance_wallet,
                _selectedPaymentMethod == 'yape',
                Colors.purple,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPaymentTab(
                'plin',
                'Plin',
                Icons.payment,
                _selectedPaymentMethod == 'plin',
                Colors.lightBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Saved Cards (only show if card is selected)
        if (_selectedPaymentMethod == 'card') ...[
          ..._savedCards.map((card) => _buildSavedCard(card)),
          const SizedBox(height: 12),
          _buildAddNewCardButton(),
        ],

        // Yape or Plin options
        if (_selectedPaymentMethod == 'yape' || _selectedPaymentMethod == 'plin') ...[
          _buildDigitalWalletOptions(),
        ],
      ],
    );
  }

  Widget _buildPaymentTab(
    String method,
    String label,
    IconData icon,
    bool isSelected,
    Color color,
  ) {
    // Colores específicos para Yape (púrpura) y Plin (azul claro)
    Color selectedColor = color;
    if (method == 'yape' && isSelected) {
      selectedColor = Colors.purple;
    } else if (method == 'plin' && isSelected) {
      selectedColor = Colors.lightBlue;
    }

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
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? selectedColor : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? selectedColor : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 24,
            ),
            const SizedBox(height: 4),
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
    final cardColor = card['type'] == 'visa' ? Colors.blue[200] : Colors.orange[200];

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCardId = card['id'] as String;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFFF8A00)
                : AppColors.primaryYellow.withOpacity(0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 32,
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.credit_card,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${card['type']?.toString().toUpperCase()} .... ${card['last4']}',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Vence ${card['expiry']}',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 12,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: AppColors.statusSuccess,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewCardButton() {
    return Container(
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
          Icon(
            Icons.add_circle_outline,
            color: AppColors.inkSoft,
            size: 20,
          ),
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
    );
  }

  Widget _buildDigitalWalletOptions() {
    final isYape = _selectedPaymentMethod == 'yape';
    final primaryColor = isYape ? Colors.purple : Colors.lightBlue;
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
            border: Border.all(
              color: AppColors.primaryYellow.withOpacity(0.5),
              width: 1,
            ),
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
                  child: Row(
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
                  child: Row(
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
              borderSide: BorderSide(
                color: AppColors.primaryYellow.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.primaryYellow.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: primaryColor,
                width: 2,
              ),
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
        color: AppColors.primaryYellow,
        borderRadius: BorderRadius.circular(12),
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
              color: AppColors.deepBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tu pago se mantendrá en custodia hasta que el grupo esté completo. '
            'Si el grupo no se completa en 7 días, recibirás un reembolso automático.',
            style: TextStyle(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 14,
              color: AppColors.deepBlack,
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
            onPressed: () {
              // Validar que se haya seleccionado un método de pago
              if (_selectedPaymentMethod == 'card' && _selectedCardId == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Por favor selecciona una tarjeta'),
                    backgroundColor: AppColors.statusError,
                  ),
                );
                return;
              }

              if ((_selectedPaymentMethod == 'yape' || _selectedPaymentMethod == 'plin') &&
                  _phoneController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Por favor ingresa tu número de celular'),
                    backgroundColor: AppColors.statusError,
                  ),
                );
                return;
              }

              // Navegar a la pantalla de seguimiento de pedido
              String paymentMethodText;
              if (_selectedPaymentMethod == 'card' && _selectedCardId != null) {
                final card = _savedCards.firstWhere((c) => c['id'] == _selectedCardId);
                paymentMethodText = 'Tarjeta ${card['type']?.toString().toUpperCase()} terminada en ${card['last4']}';
              } else if (_selectedPaymentMethod == 'yape') {
                paymentMethodText = 'Yape';
              } else {
                paymentMethodText = 'Plin';
              }

              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => OrderTrackingScreen(
                    product: widget.product,
                    orderCode: 'CUP-2024-001234',
                    paymentMethod: paymentMethodText,
                    shippingCost: 15.00,
                    deliveryAddress: 'Av. Larco 1234, Miraflores',
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.statusSuccess,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Confirmar Pago',
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

