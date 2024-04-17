import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:habit_app/blocs/event_service.dart';
import 'package:habit_app/iap/iap_service.dart';
import 'package:habit_app/models/settings_model.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/utils/notifications.dart';
import 'package:icloud_storage/icloud_storage.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

const String iCloudContainerId = 'iCloud.dev.jeanie.habitApp';
const String iCloudRelativePath = 'zest-habit/backup';

class AppService {
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
  List get purchasesValue => iapService.purchasesValue;

  // late final BehaviorSubject<bool> _isPro;
  Stream<bool> get isPro => purchases.map((purchases) => purchases.isNotEmpty);
  // Stream<bool> get isPro => _isPro.stream;
  // bool get isProValue => _isPro.value;
  bool get isProValue => purchasesValue.isNotEmpty;

  final BehaviorSubject<bool> _isLoading = BehaviorSubject.seeded(false);
  Stream<bool> get isLoading => _isLoading.stream;
  Function(bool) get setIsLoading => _isLoading.add;

  AppService({required this.isar, required this.iapService}) {
    // _isPro = BehaviorSubject.seeded(true);

    getSettings();
    getTasks().then((value) {
      if (isProValue) {
        setupNotifications();
      } else {
        HTNotification.cancelAllNotifications();
      }
    });
  }

  setIsPro(bool value) {
    // _isPro.add(value);

    if (value) {
      setupNotifications();
    } else {
      HTNotification.cancelAllNotifications();
    }
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

    EventService.changeMode(modeType: value ? ModeType.dark : ModeType.light);
  }

  Future<List<Task>> getTasks() async {
    List<Task> tasks = [];

    await isar.writeTxn(() async {
      tasks = await isar.tasks.where().findAll();
    });

    final dir = await getApplicationDocumentsDirectory();
    isar.copyToFile(dir.path).then((value) => uploadToICloud());

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

  Future<Task> duplicateTask(Task task) async {
    Task dup = Task(
      from: task.from,
      emoji: task.emoji,
      title: '$task.title} (Copy)',
      repeatAt: task.repeatAt,
      goal: task.goal,
      desc: task.desc,
      color: task.color,
      alarmTime: task.alarmTime,
    );

    return await addTask(dup);
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

    DateTime now = DateTime.now();
    EventService.deleteTask(
      taskTitle: task.title,
      taskStartDate: task.from,
      taskEndDate: task.until,
      taskRepeatType:
          task.repeatAt == null ? null : htGetRepeatType(task.repeatAt!),
      taskEmoji: task.emoji,
      taskCreateDate: task.from,
      taskAlarm: task.alarmTime != null,
      deleteDate: now,
      taskPeriod: now.difference(task.from).inDays,
      subscribeStatus: getSubscriptionType(iapService.purchasesValue),
    );
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

      EventService.tapTaskDone(
        taskTitle: task.title,
        taskStartDate: task.from,
        taskEndDate: task.until,
        taskRepeatType:
            task.repeatAt == null ? null : htGetRepeatType(task.repeatAt!),
        taskEmoji: task.emoji,
        taskCreateDate: task.from,
        taskAlarm: task.alarmTime != null,
        doneDate: date,
      );
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

  Future updateOnboardingStatus(bool value) async {
    Settings settings = _settings.value;
    settings = settings.copyWith(completedOnboarding: value);

    await isar.writeTxn(() async {
      await isar.settings.put(settings);
    });

    await getSettings();
  }

  int activeTaskCount() {
    return _tasks.value
        .where((element) =>
            element.until == null ||
            element.until!.isAfter(DateTime.now().getDate()))
        .length;
  }

  int repeatingTaskCount() {
    return _tasks.value
        .where((element) =>
            element.repeatAt != null && element.repeatAt!.isNotEmpty)
        .length;
  }

  setupNotifications() {
    List<Task> tasks = _tasks.value;
    List<Task> activeTasks = tasks
        .where((element) =>
            element.until == null ||
            !element.until!.isBefore(DateTime.now().getDate()))
        .toList();

    HTNotification.cancelAllNotifications().then((value) async {
      for (Task task in activeTasks) {
        await HTNotification.scheduleNotification(task);
      }
    });
  }

  Future downloadFromICloud() async {
    final dir = await getApplicationDocumentsDirectory();

    await ICloudStorage.download(
        containerId: iCloudContainerId,
        relativePath: iCloudRelativePath,
        destinationFilePath: dir.path,
        onProgress: (stream) {
          stream.listen(
            (progress) => log('ICloud Download Progress : $progress'),
            onDone: () => log('ICloud Download Complete'),
            onError: (error) => log('ICloud Download Error: $error'),
            cancelOnError: true,
          );
        });

    await getTasks();
  }

  Future uploadToICloud() async {
    final dir = await getApplicationDocumentsDirectory();

    await ICloudStorage.upload(
        containerId: iCloudContainerId,
        filePath: dir.path,
        destinationRelativePath: iCloudRelativePath,
        onProgress: (stream) {
          stream.listen(
            (progress) => log('ICloud Upload Progress : $progress'),
            onDone: () => log('ICloud Upload Complete'),
            onError: (error) => log('ICloud Upload Error: $error'),
            cancelOnError: true,
          );
        });
  }
}
