import '../domain/models/group_purchase.dart';

/// Datos de ejemplo de grupos de compra
class MockGroups {
  static List<GroupPurchase> getActiveGroups(String productId) {
    // Retornar grupos de ejemplo para cualquier producto
    return [
      GroupPurchase(
        id: '1',
        creatorName: 'Juan M.',
        creatorInitials: 'JM',
        creatorAvatarUrl: '',
        currentMembers: 2,
        requiredMembers: 3,
        groupPrice: 169.90,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      GroupPurchase(
        id: '2',
        creatorName: 'Sofía T.',
        creatorInitials: 'ST',
        creatorAvatarUrl: '',
        currentMembers: 1,
        requiredMembers: 2,
        groupPrice: 179.90,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      GroupPurchase(
        id: '3',
        creatorName: 'Carlos R.',
        creatorInitials: 'CR',
        creatorAvatarUrl: '',
        currentMembers: 2,
        requiredMembers: 3,
        groupPrice: 169.90,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      ),
    ];
  }
}

