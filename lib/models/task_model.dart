

class TaskModel {
  String title;
  String? subtitle;
  bool isCompleted;
  DateTime createdAt;
  TaskModel(
      {required this.title,
      this.subtitle,
      this.isCompleted = false,
      required this.createdAt});
}
