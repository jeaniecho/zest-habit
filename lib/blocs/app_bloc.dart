import 'package:habit_app/models/task_model.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc {
  late final Isar isar;

  final BehaviorSubject<int> _bottomIndex = BehaviorSubject.seeded(0);
  Stream<int> get bottomIndex => _bottomIndex.stream;
  Function get setBottomIndex => _bottomIndex.add;

  final BehaviorSubject<List<Task>> _tasks = BehaviorSubject.seeded([]);
  Stream<List<Task>> get tasks => _tasks.stream;

  AppBloc() {
    initBloc();
  }

  initBloc() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [TaskSchema],
      directory: dir.path,
    );
    await getTasks();
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
  }

  deleteTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.delete(task.id);
    });
  }
}
