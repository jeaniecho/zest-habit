import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:rxdart/rxdart.dart';

class TaskEditBloc extends Disposable {
  final Task task;
  final AppBloc appBloc;

  late final BehaviorSubject<List<int>> _repeatAt;
  Stream<List<int>> get repeatAt => _repeatAt.stream;
  Function(List<int>) get setRepeatAt => _repeatAt.add;

  late final BehaviorSubject<DateTime> _from;
  Stream<DateTime> get from => _from.stream;
  Function(DateTime) get setFrom => _from.add;

  late final BehaviorSubject<DateTime?> _until;
  Stream<DateTime?> get until => _until.stream;
  Function(DateTime?) get setUntil => _until.add;

  late final TextEditingController titleController;
  late final TextEditingController emojiController;
  late final TextEditingController goalController;
  late final TextEditingController descController;

  TaskEditBloc({
    required this.appBloc,
    required this.task,
  }) {
    _repeatAt = BehaviorSubject.seeded(task.repeatAt ?? []);
    _from = BehaviorSubject.seeded(task.from);
    _until = BehaviorSubject.seeded(task.until);

    titleController = TextEditingController(text: task.title);
    emojiController = TextEditingController(text: task.emoji);
    goalController = TextEditingController(text: task.goal);
    descController = TextEditingController(text: task.desc);
  }

  @override
  void dispose() {
    _repeatAt.close();
    _from.close();
    _until.close();

    titleController.dispose();
    emojiController.dispose();
    goalController.dispose();
    descController.dispose();
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
      emoji: emojiController.text,
      title: titleController.text,
      repeatAt: _repeatAt.value,
      goal: goalController.text,
      desc: descController.text,
      until: _until.value,
      doneAt: task.doneAt,
    );
  }

  updateTask() {
    appBloc.updateTask(getUpdatedTask());
  }
}
