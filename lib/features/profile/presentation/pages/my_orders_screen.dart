import 'package:flutter/material.dart';
import '../../../../core/ui/theme/colors.dart';
import '../../../../data/models/transaction_model.dart';
import '../../../home/domain/models/product.dart';
import '../../../home/presentation/pages/order_tracking_screen.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  bool _isLoading = true;
  List<Map<String, dynamic>> _orders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    final mockOrders = [
      {
        'transaction': TransactionModel(
          id: 'txn_12345678',
          matchGroupId: 'group_1',
          payerUserId: 'user_1',
          amountTotal: 429.90,
          platformFee: 10.0,
          deliveryFee: 15.0,
          paymentStatus: 'delivered',
          createdAt: DateTime.now().subtract(const Duration(days: 5)),
        ),
        'product': Product(
          id: 'prod_1',
          brand: 'Nike',
          name: 'Nike Air Force 1 \'07',
          originalPrice: 499.90,
          currentPrice: 414.90,
          discountPercentage: 17,
          imageUrl:
              'https://static.nike.com/a/images/t_PDP_1280_v1/f_auto,q_auto:eco/b7d9211c-26e7-431a-ac24-b0540fb3c00f/air-force-1-07-zapatillas-GjGXSP.png',
          groupPrice3: 380.0,
          groupPrice6Plus: 350.0,
          interestedCount: 12,
          category: 'sneakers',
        ),
        'status': 'Entregado',
      },
      {
        'transaction': TransactionModel(
          id: 'txn_87654321',
          matchGroupId: 'group_2',
          payerUserId: 'user_1',
          amountTotal: 129.90,
          platformFee: 5.0,
          deliveryFee: 10.0,
          paymentStatus: 'shipped',
          createdAt: DateTime.now().subtract(const Duration(days: 1)),
        ),
        'product': Product(
          id: 'prod_2',
          brand: 'Adidas',
          name: 'Polera Essentials Fleece',
          originalPrice: 199.90,
          currentPrice: 119.90,
          discountPercentage: 40,
          imageUrl:
              'https://assets.adidas.com/images/h_840,f_auto,q_auto,fl_lossy,c_fill,g_auto/4e894c2b76dd4c8e9013aafc016047af_9366/Polera_con_Capucha_Essentials_Fleece_3_Tiras_Negro_DQ3096_21_model.jpg',
          groupPrice3: 110.0,
          groupPrice6Plus: 100.0,
          interestedCount: 8,
          category: 'clothing',
        ),
        'status': 'En Camino',
      },
      {
        'transaction': TransactionModel(
          id: 'txn_11223344',
          matchGroupId: 'group_3',
          payerUserId: 'user_1',
          amountTotal: 89.90,
          platformFee: 2.0,
          deliveryFee: 8.0,
          paymentStatus: 'pending',
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        ),
        'product': Product(
          id: 'prod_3',
          brand: 'Puma',
          name: 'Gorra Essentials',
          originalPrice: 69.90,
          currentPrice: 49.90,
          discountPercentage: 28,
          imageUrl:
              'https://images.puma.com/image/upload/f_auto,q_auto,b_rgb:fafafa,w_600,h_600/global/052919/01/fnd/PER/fmt/png/Gorra-PUMA-Essentials',
          groupPrice3: 45.0,
          groupPrice6Plus: 40.0,
          interestedCount: 5,
          category: 'accessories',
        ),
        'status': 'Pendiente',
      },
    ];

    if (mounted) {
      setState(() {
        _orders = mockOrders;
        _isLoading = false;
      });
    }
  }

  String _mapStatus(String status) {
    switch (status) {
      case 'pending':
        return 'Pendiente';
      case 'paid':
        return 'Pagado';
      case 'shipped':
        return 'En Camino';
      case 'delivered':
        return 'Entregado';
      default:
        return status;
    }
  }

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
          'Mis Pedidos',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.deepBlack,
          ),
        ),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primaryYellow),
            )
          : _orders.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_bag_outlined,
                    size: 64,
                    color: AppColors.inkSoft,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No tienes pedidos aún',
                    style: TextStyle(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 16,
                      color: AppColors.inkSoft,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                final transaction = order['transaction'] as TransactionModel;
                final product = order['product'] as Product;
                final status = order['status'] as String;

                return _buildOrderCard(context, transaction, product, status);
              },
            ),
    );
  }

  Widget _buildOrderCard(
    BuildContext context,
    TransactionModel transaction,
    Product product,
    String status,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderTrackingScreen(
              product: product,
              orderCode: 'ORD-${transaction.id.substring(0, 8).toUpperCase()}',
              paymentMethod: 'Tarjeta', // Mocked for now
              shippingCost: transaction.deliveryFee,
              deliveryAddress: 'Av. Larco 1234, Miraflores', // Mocked
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                // Product Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.imageUrl,
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
                const SizedBox(width: 16),
                // Order Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryYellow.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              status,
                              style: TextStyle(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: AppColors.deepBlack,
                              ),
                            ),
                          ),
                          Text(
                            'S/ ${transaction.amountTotal.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.deepBlack,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        product.name,
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pedido el ${_formatDate(transaction.createdAt)}',
                        style: TextStyle(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 12,
                          color: AppColors.inkSoft,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
