import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc {
  final Isar isar;

  final BehaviorSubject<int> _bottomIndex = BehaviorSubject.seeded(0);
  Stream<int> get bottomIndex => _bottomIndex.stream;
  Function get setBottomIndex => _bottomIndex.add;

  final BehaviorSubject<List<Task>> _tasks = BehaviorSubject.seeded([]);
  Stream<List<Task>> get tasks => _tasks.stream;
  List<Task> get tasksValue => _tasks.value;

  AppBloc({required this.isar}) {
    getTasks();
  }

  Future<List<Task>> getTasks() async {
    List<Task> tasks = [];

    await isar.writeTxn(() async {
      tasks = await isar.tasks.where().findAll();
    });

    _tasks.add(tasks);
    return tasks;
  }

  addTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
    getTasks();
  }

  deleteTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.delete(task.id);
    });
    getTasks();
  }

  toggleTask(Task task, DateTime date) async {
    try {
      final toRemove =
          task.doneAt.firstWhere((element) => isSameDay(element, date));
      task.doneAt.remove(toRemove);
    } catch (e) {
      task.doneAt.add(date);
    }

    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
    getTasks();
  }

  bool isDone(Task task, DateTime date) {
    try {
      task.doneAt.firstWhere((element) => isSameDay(element, date));
      return true;
    } catch (e) {
      return false;
    }
  }
}
