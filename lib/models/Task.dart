class Task{
  final int id;
  final String taskTitle ;
  final String taskTime ;
  final String taskDate;
  final String status;
  Task({this.id=0,
    required this.taskTitle,
    required this.taskTime,
    required this.taskDate,
    this.status="new"});
}