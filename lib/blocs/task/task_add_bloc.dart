import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:rxdart/rxdart.dart';

class TaskAddBloc extends Disposable {
  final AppBloc appBloc;

  final BehaviorSubject<List<int>> _repeatAt = BehaviorSubject.seeded([]);
  Stream<List<int>> get repeatAt => _repeatAt.stream;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController emojiController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  TaskAddBloc({required this.appBloc});

  @override
  void dispose() {
    _repeatAt.close();
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

  addTask() {
    DateTime now = DateTime.now().getDate();

    appBloc.addTask(Task(
      from: now,
      emoji: emojiController.text,
      title: titleController.text,
      repeatAt: _repeatAt.value,
      goal: goalController.text,
      desc: descController.text,
    ));
  }
}
