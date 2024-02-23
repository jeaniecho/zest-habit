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

  Future<Task?> getTask(int id) async {
    return await isar.tasks.get(id);
  }

  addTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
    await getTasks();
  }

  deleteTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.delete(task.id);
    });
    await getTasks();
  }

  updateTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
    await getTasks();
  }

  toggleTask(Task task, DateTime date) async {
    try {
      final toRemove =
          task.doneAt.firstWhere((element) => htIsSameDay(element, date));
      task.doneAt.remove(toRemove);
    } catch (e) {
      task.doneAt.add(date);
    }

    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
    await getTasks();
  }

  setTaskDone(Task task, DateTime date) async {
    if (!task.doneAt.contains(date)) {
      task.doneAt.add(date);

      await isar.writeTxn(() async {
        await isar.tasks.put(task);
      });
      await getTasks();
    }
  }

  bool isDone(Task task, DateTime date) {
    try {
      task.doneAt.firstWhere((element) => htIsSameDay(element, date));
      return true;
    } catch (e) {
      return false;
    }
  }
}
