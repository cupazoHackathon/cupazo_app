/// Modelo de grupo de compra
class GroupPurchase {
  final String id;
  final String creatorName;
  final String creatorInitials;
  final String creatorAvatarUrl;
  final int currentMembers;
  final int requiredMembers;
  final double groupPrice;
  final DateTime createdAt;

  GroupPurchase({
    required this.id,
    required this.creatorName,
    required this.creatorInitials,
    required this.creatorAvatarUrl,
    required this.currentMembers,
    required this.requiredMembers,
    required this.groupPrice,
    required this.createdAt,
  });

  int get missingMembers => requiredMembers - currentMembers;
  bool get isComplete => currentMembers >= requiredMembers;
}

