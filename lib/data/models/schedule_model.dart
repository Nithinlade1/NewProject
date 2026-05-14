class ScheduleModel {
  final String id;
  final String kutComId;
  final String kutComName;
  final DateTime date;
  final String time;
  final String? routeId;

  const ScheduleModel({
    required this.id,
    required this.kutComId,
    required this.kutComName,
    required this.date,
    required this.time,
    this.routeId,
  });

  ScheduleModel copyWith({
    String? id,
    String? kutComId,
    String? kutComName,
    DateTime? date,
    String? time,
    String? routeId,
  }) {
    return ScheduleModel(
      id: id ?? this.id,
      kutComId: kutComId ?? this.kutComId,
      kutComName: kutComName ?? this.kutComName,
      date: date ?? this.date,
      time: time ?? this.time,
      routeId: routeId ?? this.routeId,
    );
  }

  String get formattedDate {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'kutComId': kutComId,
      'kutComName': kutComName,
      'date': date.toIso8601String(),
      'time': time,
      'routeId': routeId,
    };
  }

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    return ScheduleModel(
      id: json['id'] as String,
      kutComId: json['kutComId'] as String,
      kutComName: json['kutComName'] as String,
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String,
      routeId: json['routeId'] as String?,
    );
  }
}

class LanguageModel {
  final String code;
  final String name;
  final String nativeName;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName,
  });
}
