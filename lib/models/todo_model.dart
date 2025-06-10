class TodoModel {
  final String id;
  final String title;
  final String subtitle;
  final String icon;
  final DateTime time;
  final bool isDone;

  TodoModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.time,
    required this.isDone,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'icon': icon,
      'time': time.toIso8601String(),
      'isDone': isDone,
    };
  }

  factory TodoModel.fromMap(Map<String, dynamic> map) {
    return TodoModel(
      id: map['id'],
      title: map['title'],
      subtitle: map['subtitle'],
      icon: map['icon'],
      time: DateTime.parse(map['time']),
      isDone: map['isDone'],
    );
  }
}
