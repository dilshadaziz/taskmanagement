class TasksDB {
  int? id;
  String? taskTitle;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;

  TasksDB({
    this.id,
    this.taskTitle,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
  });

  static TasksDB fromMap(Map<String, Object?> map) {
    int id = map['id'] as int;
    String taskTitle = map['tasktitle'] as String;
    int isCompleted = map['iscompleted'] as int;
    String date = map['date'] as String;
    String startTime = map['starttime'] as String;
    String endTime = map['endtime'] as String;
    int color = map['color'] as int;
    int remind = map['remind'] as int;
    String repeat = map['repeat'] as String;

    return TasksDB(
     id: id,
     taskTitle: taskTitle,
     isCompleted: isCompleted,
     date: date,
     startTime: startTime,
     endTime: endTime,
     color: color,
     remind: remind,
     repeat: repeat
     );
  }
}