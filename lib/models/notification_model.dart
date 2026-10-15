class NotificationModel {
  final String id;
  final String title;
  final String body;
  final DateTime dateTime;
  final String? filePath;
  final String type; // 'export', 'budget', 'bill', 'reminder'
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.dateTime,
    this.filePath,
    this.type = 'reminder',
    this.isRead = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'dateTime': dateTime.toIso8601String(),
      'filePath': filePath,
      'type': type,
      'isRead': isRead ? 1 : 0,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      body: map['body'] ?? '',
      dateTime: DateTime.tryParse(map['dateTime'] ?? '') ?? DateTime.now(),
      filePath: map['filePath'],
      type: map['type'] ?? 'reminder',
      isRead: map['isRead'] == 1,
    );
  }
}
