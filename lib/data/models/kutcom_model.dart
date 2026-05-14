class KutComModel {
  final String id;
  final String name;
  final String code;
  final String? imageUrl;
  final int activeInterest;
  final int passiveInterest;
  final int unreadMessages;
  final String? groupName;
  final KutComGroupType groupType;
  final DateTime? lastActivity;

  const KutComModel({
    required this.id,
    required this.name,
    required this.code,
    this.imageUrl,
    this.activeInterest = 0,
    this.passiveInterest = 0,
    this.unreadMessages = 0,
    this.groupName,
    this.groupType = KutComGroupType.individual,
    this.lastActivity,
  });

  KutComModel copyWith({
    String? id,
    String? name,
    String? code,
    String? imageUrl,
    int? activeInterest,
    int? passiveInterest,
    int? unreadMessages,
    String? groupName,
    KutComGroupType? groupType,
    DateTime? lastActivity,
  }) {
    return KutComModel(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      imageUrl: imageUrl ?? this.imageUrl,
      activeInterest: activeInterest ?? this.activeInterest,
      passiveInterest: passiveInterest ?? this.passiveInterest,
      unreadMessages: unreadMessages ?? this.unreadMessages,
      groupName: groupName ?? this.groupName,
      groupType: groupType ?? this.groupType,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'imageUrl': imageUrl,
      'activeInterest': activeInterest,
      'passiveInterest': passiveInterest,
      'unreadMessages': unreadMessages,
      'groupName': groupName,
      'groupType': groupType.name,
      'lastActivity': lastActivity?.toIso8601String(),
    };
  }

  factory KutComModel.fromJson(Map<String, dynamic> json) {
    return KutComModel(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      imageUrl: json['imageUrl'] as String?,
      activeInterest: json['activeInterest'] as int? ?? 0,
      passiveInterest: json['passiveInterest'] as int? ?? 0,
      unreadMessages: json['unreadMessages'] as int? ?? 0,
      groupName: json['groupName'] as String?,
      groupType: KutComGroupType.values.firstWhere(
        (e) => e.name == json['groupType'],
        orElse: () => KutComGroupType.individual,
      ),
      lastActivity: json['lastActivity'] != null
          ? DateTime.parse(json['lastActivity'] as String)
          : null,
    );
  }
}

enum KutComGroupType { individual, kutcomGroup, locationDeliveryGroup }

class KutComGroup {
  final String name;
  final String? imageUrl;
  final KutComGroupType type;
  final List<KutComModel> kutcoms;

  const KutComGroup({
    required this.name,
    this.imageUrl,
    required this.type,
    required this.kutcoms,
  });

  int get totalActiveInterest =>
      kutcoms.fold(0, (sum, k) => sum + k.activeInterest);

  int get totalPassiveInterest =>
      kutcoms.fold(0, (sum, k) => sum + k.passiveInterest);

  int get totalUnread =>
      kutcoms.fold(0, (sum, k) => sum + k.unreadMessages);
}
