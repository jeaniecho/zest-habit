import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_app/blocs/app_service.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/utils/notifications.dart';
import 'package:rxdart/rxdart.dart';

class TaskAddBloc extends Disposable {
  final AppService appService;
  final Task? task;

  final BehaviorSubject<String> _title = BehaviorSubject.seeded('');
  Stream<String> get title => _title.stream;
  Function(String) get setTitle => _title.add;

  final BehaviorSubject<String> _emoji = BehaviorSubject.seeded('');
  Stream<String> get emoji => _emoji.stream;
  Function(String) get setEmoji => _emoji.add;

  final BehaviorSubject<String> _goal = BehaviorSubject.seeded('');
  Stream<String> get goal => _goal.stream;
  Function(String) get setGoal => _goal.add;

  final BehaviorSubject<bool> _isRepeat = BehaviorSubject.seeded(true);
  Stream<bool> get isRepeat => _isRepeat.stream;
  bool get isRepeatValue => _isRepeat.value;

  final BehaviorSubject<RepeatType> _repeatType =
      BehaviorSubject.seeded(RepeatType.everyday);
  Stream<RepeatType> get repeatType => _repeatType.stream;
  Function(RepeatType) get setRepeatType => _repeatType.add;

  final BehaviorSubject<List<int>> _repeatAt =
      BehaviorSubject.seeded([1, 2, 3, 4, 5, 6, 7]);
  Stream<List<int>> get repeatAt => _repeatAt.stream;
  Function(List<int>) get setRepeatAt => _repeatAt.add;

  final BehaviorSubject<DateTime> _from =
      BehaviorSubject.seeded(DateTime.now().getDate());
  Stream<DateTime> get from => _from.stream;
  Function(DateTime) get setFrom => _from.add;

  final BehaviorSubject<DateTime?> _until = BehaviorSubject.seeded(null);
  Stream<DateTime?> get until => _until.stream;
  Function(DateTime?) get setUntil => _until.add;

  final BehaviorSubject<bool> _openEmoji = BehaviorSubject.seeded(false);
  Stream<bool> get openEmoji => _openEmoji.stream;
  Function(bool) get setOpenEmoji => _openEmoji.add;

  final BehaviorSubject<int> _selectedColor =
      BehaviorSubject.seeded(0xFF000000);
  Stream<int> get selectedColor => _selectedColor.stream;
  Function(int) get setSelectedColor => _selectedColor.add;

  final BehaviorSubject<DateTime?> _alarmTime = BehaviorSubject.seeded(null);
  Stream<DateTime?> get alarmTime => _alarmTime.stream;
  Function(DateTime?) get setAlarmTime => _alarmTime.add;

  final BehaviorSubject<bool> _titleError = BehaviorSubject.seeded(false);
  Stream<bool> get titleError => _titleError.stream;
  Function(bool) get setTitleError => _titleError.add;

  final BehaviorSubject<bool> _showColorTooltip = BehaviorSubject.seeded(false);
  Stream<bool> get showColorTooltip => _showColorTooltip.stream;
  Function(bool) get setShowColorTooltip => _showColorTooltip.add;
  bool get showColorTooltipValue => _showColorTooltip.value;

  final BehaviorSubject<bool> _showStartCalendar =
      BehaviorSubject.seeded(false);
  Stream<bool> get showStartCalendar => _showStartCalendar.stream;
  Function(bool) get setShowStartCalendar => _showStartCalendar.add;

  final BehaviorSubject<bool> _showEndCalendar = BehaviorSubject.seeded(true);
  Stream<bool> get showEndCalendar => _showEndCalendar.stream;
  Function(bool) get setShowEndCalendar => _showEndCalendar.add;

  late final TextEditingController titleController;
  late final TextEditingController goalController;

  final ScrollController scrollController = ScrollController();

  TaskAddBloc({
    required this.appService,
    this.task,
  }) {
    if (task != null) {
      bool isRepeatValue = task!.repeatAt != null && task!.repeatAt!.isNotEmpty;

      _emoji.add(task!.emoji ?? '');
      _title.add(task!.title);
      _goal.add(task!.goal ?? '');
      _isRepeat.add(isRepeatValue);
      _repeatAt.add(task!.repeatAt ?? []);
      _repeatType.add(isRepeatValue
          ? htGetRepeatType(task!.repeatAt ?? [])
          : RepeatType.everyday);
      _from.add(task!.from);
      _until.add(task!.until);
      _selectedColor.add(task!.color);
      _alarmTime.add(task!.alarmTime);
    }

    titleController = TextEditingController(text: task?.title);
    goalController = TextEditingController(text: task?.goal);

    if (appService.settingsValue.createdTaskCount == 0) {
      _showColorTooltip.add(true);
    }
  }

  @override
  void dispose() {
    _title.close();
    _emoji.close();
    _goal.close();
    _isRepeat.close();
    _repeatType.close();
    _repeatAt.close();
    _from.close();
    _until.close();
    _openEmoji.close();
    _selectedColor.close();
    _alarmTime.close();
    _titleError.close();
    _showColorTooltip.close();
    _showStartCalendar.close();
    _showEndCalendar.close();
  }

  setIsRepeat(bool repeat) {
    _isRepeat.add(repeat);

    if (repeat) {
      _repeatType.add(RepeatType.everyday);
      _repeatAt.add([1, 2, 3, 4, 5, 6, 7]);
    } else {
      _repeatAt.add([]);
    }
  }

  toggleRepeatAt(int day) {
    List<int> rep = _repeatAt.value.toList();
    if (rep.contains(day)) {
      rep.remove(day);
    } else {
      rep.add(day);
    }

    _repeatAt.add(rep);
  }

  Task getNewTask() {
    return Task(
      from: _from.value,
      emoji: _emoji.value,
      title: _title.value,
      repeatAt: _repeatAt.value,
      goal: _goal.value,
      desc: '',
      until: _until.value,
      color: _selectedColor.value,
      alarmTime: _alarmTime.value,
    );
  }

  Future<Task> addTask() async {
    Task newTask = await appService.addTask(getNewTask());

    if (newTask.alarmTime != null) {
      await HTNotification.scheduleNotification(newTask);
    }

    return newTask;
  }

  Task getUpdatedTask(Task task) {
    return Task(
      id: task.id,
      from: _from.value,
      emoji: _emoji.value,
      title: _title.value,
      repeatAt: _repeatAt.value,
      goal: _goal.value,
      desc: '',
      until: _until.value,
      doneAt: task.doneAt,
      color: _selectedColor.value,
      alarmTime: _alarmTime.value,
    );
  }

  Future<Task?> updateTask() async {
    if (task != null) {
      Task newTask = getUpdatedTask(task!);

      if (newTask.alarmTime == null) {
        await HTNotification.cancelNotification(newTask);
      } else {
        await HTNotification.scheduleNotification(newTask);
      }

      return await appService.updateTask(newTask);
    }

    return null;
  }

  toggleOpenEmoji() {
    if (_openEmoji.value) {
      setOpenEmoji(false);
    } else {
      setOpenEmoji(true);
    }
  }

  toggleStartCalendar() {
    HapticFeedback.lightImpact();
    if (_showStartCalendar.value) {
      _showStartCalendar.add(false);
    } else {
      _showStartCalendar.add(true);
      scrollToStartCalendar();
    }
  }

  toggleEndCalendar() {
    HapticFeedback.lightImpact();
    if (_showEndCalendar.value) {
      _showEndCalendar.add(false);
    } else {
      _showEndCalendar.add(true);
      scrollToEndCalendar();
    }
  }

  scrollToStartCalendar() {
    double offset = 320;

    if (isRepeatValue) {
      offset += 240;
    }
    if (_repeatType.value == RepeatType.custom) {
      offset += 24;
    }

    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  scrollToEndCalendar() {
    double offset = 400;

    if (isRepeatValue) {
      offset += 240;
    }
    if (_repeatType.value == RepeatType.custom) {
      offset += 24;
    }
    if (_showStartCalendar.value) {
      offset += 440;
    }

    scrollController.animateTo(
      offset,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }
}
