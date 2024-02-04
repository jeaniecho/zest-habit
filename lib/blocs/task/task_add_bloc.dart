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
  Function(List<int>) get setRepeatAt => _repeatAt.add;

  final BehaviorSubject<DateTime> _from =
      BehaviorSubject.seeded(DateTime.now().getDate());
  Stream<DateTime> get from => _from.stream;
  Function(DateTime) get setFrom => _from.add;

  final BehaviorSubject<DateTime?> _until = BehaviorSubject.seeded(null);
  Stream<DateTime?> get until => _until.stream;
  Function(DateTime?) get setUntil => _until.add;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController emojiController = TextEditingController();
  final TextEditingController goalController = TextEditingController();
  final TextEditingController descController = TextEditingController();

  TaskAddBloc({required this.appBloc});

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

  addTask() {
    appBloc.addTask(Task(
      from: _from.value,
      emoji: emojiController.text,
      title: titleController.text,
      repeatAt: _repeatAt.value,
      goal: goalController.text,
      desc: descController.text,
      until: _until.value,
    ));
  }
}
