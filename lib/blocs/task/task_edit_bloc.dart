import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:rxdart/rxdart.dart';

class TaskEditBloc extends Disposable {
  final Task task;
  final AppBloc appBloc;

  late final BehaviorSubject<String> _title;
  Stream<String> get title => _title.stream;
  Function(String) get setTitle => _title.add;
  String get titleValue => _title.value;

  late final BehaviorSubject<String> _emoji;
  Stream<String> get emoji => _emoji.stream;
  Function(String) get setEmoji => _emoji.add;

  late final BehaviorSubject<String> _goal;
  Stream<String> get goal => _goal.stream;
  Function(String) get setGoal => _goal.add;

  late final BehaviorSubject<bool> _isRepeat;
  Stream<bool> get isRepeat => _isRepeat.stream;
  Function(bool) get setIsRepeat => _isRepeat.add;

  late final BehaviorSubject<RepeatType> _repeatType;
  Stream<RepeatType> get repeatType => _repeatType.stream;
  Function(RepeatType) get setRepeatType => _repeatType.add;

  late final BehaviorSubject<List<int>> _repeatAt;
  Stream<List<int>> get repeatAt => _repeatAt.stream;
  Function(List<int>) get setRepeatAt => _repeatAt.add;

  late final BehaviorSubject<DateTime> _from;
  Stream<DateTime> get from => _from.stream;
  Function(DateTime) get setFrom => _from.add;

  late final BehaviorSubject<DateTime?> _until;
  Stream<DateTime?> get until => _until.stream;
  Function(DateTime?) get setUntil => _until.add;

  final BehaviorSubject<bool> _openEmoji = BehaviorSubject.seeded(false);
  Stream<bool> get openEmoji => _openEmoji.stream;
  Function(bool) get setOpenEmoji => _openEmoji.add;

  late final TextEditingController titleController;
  late final TextEditingController goalController;

  TaskEditBloc({
    required this.appBloc,
    required this.task,
  }) {
    bool isRepeatValue = task.repeatAt != null || task.repeatAt!.isNotEmpty;

    _emoji = BehaviorSubject.seeded(task.emoji ?? '');
    _title = BehaviorSubject.seeded(task.title);
    _goal = BehaviorSubject.seeded(task.goal ?? '');
    _isRepeat = BehaviorSubject.seeded(isRepeatValue);
    _repeatAt = BehaviorSubject.seeded(task.repeatAt ?? []);
    _repeatType = BehaviorSubject.seeded(isRepeatValue
        ? getRepeatType(task.repeatAt ?? [])
        : RepeatType.everyday);
    _from = BehaviorSubject.seeded(task.from);
    _until = BehaviorSubject.seeded(task.until);

    titleController = TextEditingController(text: task.title);
    goalController = TextEditingController(text: task.goal);
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

    titleController.dispose();
    goalController.dispose();
  }

  toggleRepeatAt(int day) {
    List<int> rep = _repeatAt.value;
    if (rep.contains(day)) {
      rep.remove(day);
    } else {
      rep.add(day);
    }

    _repeatAt.add(rep);
  }

  Task getUpdatedTask() {
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
    );
  }

  updateTask() {
    appBloc.updateTask(getUpdatedTask());
  }

  toggleOpenEmoji() {
    if (_openEmoji.value) {
      setOpenEmoji(false);
    } else {
      setOpenEmoji(true);
    }
  }
}
