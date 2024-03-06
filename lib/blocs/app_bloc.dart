import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_app/models/settings_model.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc {
  final Isar isar;

  final BehaviorSubject<Settings> _settings =
      BehaviorSubject.seeded(Settings());
  Stream<Settings> get settings => _settings.stream;
  Function(Settings) get setSettings => _settings.add;

  final BehaviorSubject<int> _bottomIndex = BehaviorSubject.seeded(0);
  Stream<int> get bottomIndex => _bottomIndex.stream;
  Function(int) get setBottomIndex => _bottomIndex.add;

  final BehaviorSubject<List<Task>> _tasks = BehaviorSubject.seeded([]);
  Stream<List<Task>> get tasks => _tasks.stream;
  List<Task> get tasksValue => _tasks.value;

  final BehaviorSubject<Task?> _timerTask = BehaviorSubject.seeded(null);
  Stream<Task?> get timerTask => _timerTask.stream;
  Function(Task?) get setTimerTask => _timerTask.add;
  Task? get timerTaskValue => _timerTask.value;

  AppBloc({required this.isar}) {
    getSettings();
    getTasks();
  }

  Future<Settings> getSettings() async {
    Settings settings = await isar.settings.where().findFirst() ?? Settings();

    _settings.add(settings);
    return settings;
  }

  setDarkMode(bool value, BuildContext context) async {
    await isar.writeTxn(() async {
      await isar.settings.put(_settings.value.copyWith(isDarkMode: value));
    });
    await getSettings();
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

  Future<Task> addTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
    await getTasks();

    return task;
  }

  Future deleteTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.delete(task.id);
    });
    await getTasks();

    if (timerTaskValue?.id == task.id) {
      setTimerTask(null);
    }
  }

  Future<Task> updateTask(Task task) async {
    await isar.writeTxn(() async {
      await isar.tasks.put(task);
    });
    await getTasks();

    if (timerTaskValue?.id == task.id) {
      setTimerTask(task);
    }

    return task;
  }

  Future toggleTask(Task task, DateTime date) async {
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

  Future setTimerTaskDone(Task task, DateTime date) async {
    if (!task.doneWithTimer.contains(date)) {
      if (task.doneWithTimer.isEmpty) {
        task.doneWithTimer = [date];
      }
      task.doneWithTimer.add(date);
    }

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
