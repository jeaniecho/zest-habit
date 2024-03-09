import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:habit_app/iap/iap_service.dart';
import 'package:habit_app/models/settings_model.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/utils/notifications.dart';
import 'package:isar/isar.dart';
import 'package:rxdart/rxdart.dart';

class AppBloc {
  final Isar isar;
  final IAPService iapService;

  final BehaviorSubject<Settings> _settings =
      BehaviorSubject.seeded(Settings());
  Stream<Settings> get settings => _settings.stream;
  Function(Settings) get setSettings => _settings.add;
  Settings get settingsValue => _settings.value;

  final BehaviorSubject<int> _bottomIndex = BehaviorSubject.seeded(0);
  Stream<int> get bottomIndex => _bottomIndex.stream;
  Function(int) get setBottomIndex => _bottomIndex.add;
  int get bottomIndexValue => _bottomIndex.value;

  final BehaviorSubject<List<Task>> _tasks = BehaviorSubject.seeded([]);
  Stream<List<Task>> get tasks => _tasks.stream;
  List<Task> get tasksValue => _tasks.value;

  final BehaviorSubject<Task?> _timerTask = BehaviorSubject.seeded(null);
  Stream<Task?> get timerTask => _timerTask.stream;
  Function(Task?) get setTimerTask => _timerTask.add;
  Task? get timerTaskValue => _timerTask.value;

  Stream<List> get purchases => iapService.purchases;
  Stream<bool> get isPro => purchases.map((purchases) => purchases.isNotEmpty);

  AppBloc({required this.isar, required this.iapService}) {
    getSettings();
    getTasks();
  }

  Future<Settings> getSettings() async {
    Settings settings = await isar.settings.where().findFirst() ??
        Settings(
            isDarkMode: SchedulerBinding
                    .instance.platformDispatcher.platformBrightness ==
                Brightness.dark);

    _settings.add(settings);
    return settings;
  }

  setDarkMode(bool value, BuildContext context) async {
    Settings newSettings = _settings.value.copyWith(isDarkMode: value);

    await isar.writeTxn(() async {
      await isar.settings.put(newSettings);
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

    await incrementCreatedTaskCount();

    return task;
  }

  Future deleteTask(Task task) async {
    await HTNotification.cancelNotification(task);

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

    try {
      final toRemove = task.doneWithTimer
          .firstWhere((element) => htIsSameDay(element, date));
      task.doneWithTimer.remove(toRemove);
      // ignore: empty_catches
    } catch (e) {}

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

  Future incrementCreatedTaskCount() async {
    Settings settings = _settings.value;
    settings =
        settings.copyWith(createdTaskCount: settings.createdTaskCount + 1);

    await isar.writeTxn(() async {
      await isar.settings.put(settings);
    });

    await getSettings();
  }
}
