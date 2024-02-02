import 'package:isar/isar.dart';

part 'task_model.g.dart';

@collection
class Task {
  Id id = Isar.autoIncrement;
  DateTime from;
  String? emoji;
  String title;
  DateTime? until;
  List<int>? repeatAt; // weekdays (1 ~ 7 == Mon ~ Sun) / if null: one time
  String? goal;
  String? desc;
  List<DateTime> doneAt;

  Task({
    required this.id,
    required this.from,
    required this.emoji,
    required this.title,
    this.until,
    required this.repeatAt,
    required this.goal,
    required this.desc,
    required this.doneAt,
  });
}
