import 'package:isar/isar.dart';

part 'task_model.g.dart';

@collection
class Task {
  Id id;
  DateTime from;
  String? emoji;
  String title;
  DateTime? until;
  List<int>? repeatAt; // weekdays (1 ~ 7 == Mon ~ Sun) / if null: one time
  String? goal;
  String? desc;
  List<DateTime> doneAt;
  List<DateTime> doneWithTimer;
  int color;

  Task({
    this.id = Isar.autoIncrement,
    required this.from,
    required this.emoji,
    required this.title,
    this.until,
    required this.repeatAt,
    required this.goal,
    required this.desc,
    this.doneAt = const [],
    this.doneWithTimer = const [],
    this.color = 0xFF000000,
  });
}
