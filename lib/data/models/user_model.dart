class UserModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? profilePhoto;
  final String? tudNumber;
  final bool isRegistered;
  final String language;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.profilePhoto,
    this.tudNumber,
    this.isRegistered = false,
    this.language = 'en',
    required this.createdAt,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? profilePhoto,
    String? tudNumber,
    bool? isRegistered,
    String? language,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      tudNumber: tudNumber ?? this.tudNumber,
      isRegistered: isRegistered ?? this.isRegistered,
      language: language ?? this.language,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'profilePhoto': profilePhoto,
      'tudNumber': tudNumber,
      'isRegistered': isRegistered,
      'language': language,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String?,
      profilePhoto: json['profilePhoto'] as String?,
      tudNumber: json['tudNumber'] as String?,
      isRegistered: json['isRegistered'] as bool? ?? false,
      language: json['language'] as String? ?? 'en',
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }
}
