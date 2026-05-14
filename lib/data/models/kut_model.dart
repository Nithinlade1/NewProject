class KutModel {
  final String id;
  final String name;
  final String? imageUrl;
  final String kutComId;
  final bool isHTud;
  final bool hasActiveInterest;
  final int unreadMessages;
  final RequestStatus requestStatus;
  final int rating;
  final bool isBlocked;
  final DateTime? lastActivity;

  const KutModel({
    required this.id,
    required this.name,
    this.imageUrl,
    required this.kutComId,
    this.isHTud = false,
    this.hasActiveInterest = false,
    this.unreadMessages = 0,
    this.requestStatus = RequestStatus.none,
    this.rating = 0,
    this.isBlocked = false,
    this.lastActivity,
  });

  KutModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    String? kutComId,
    bool? isHTud,
    bool? hasActiveInterest,
    int? unreadMessages,
    RequestStatus? requestStatus,
    int? rating,
    bool? isBlocked,
    DateTime? lastActivity,
  }) {
    return KutModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      kutComId: kutComId ?? this.kutComId,
      isHTud: isHTud ?? this.isHTud,
      hasActiveInterest: hasActiveInterest ?? this.hasActiveInterest,
      unreadMessages: unreadMessages ?? this.unreadMessages,
      requestStatus: requestStatus ?? this.requestStatus,
      rating: rating ?? this.rating,
      isBlocked: isBlocked ?? this.isBlocked,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'kutComId': kutComId,
      'isHTud': isHTud,
      'hasActiveInterest': hasActiveInterest,
      'unreadMessages': unreadMessages,
      'requestStatus': requestStatus.name,
      'rating': rating,
      'isBlocked': isBlocked,
      'lastActivity': lastActivity?.toIso8601String(),
    };
  }

  factory KutModel.fromJson(Map<String, dynamic> json) {
    return KutModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String?,
      kutComId: json['kutComId'] as String,
      isHTud: json['isHTud'] as bool? ?? false,
      hasActiveInterest: json['hasActiveInterest'] as bool? ?? false,
      unreadMessages: json['unreadMessages'] as int? ?? 0,
      requestStatus: RequestStatus.values.firstWhere(
        (e) => e.name == json['requestStatus'],
        orElse: () => RequestStatus.none,
      ),
      rating: json['rating'] as int? ?? 0,
      isBlocked: json['isBlocked'] as bool? ?? false,
      lastActivity: json['lastActivity'] != null
          ? DateTime.parse(json['lastActivity'] as String)
          : null,
    );
  }
}

enum RequestStatus {
  none,
  requested,
  undecided,
  declined,
  delivered,
  unableToServe,
  customerUnavailable,
}
