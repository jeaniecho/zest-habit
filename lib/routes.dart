import 'package:flutter/material.dart';
import 'package:habit_app/blocs/task/task_add_bloc.dart';
import 'package:habit_app/blocs/task/task_detail_bloc.dart';
import 'package:habit_app/blocs/task/task_edit_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/pages/base_page.dart';
import 'package:habit_app/pages/task/task_add_page.dart';
import 'package:habit_app/pages/task/task_detail_page.dart';
import 'package:habit_app/pages/task/task_edit_page.dart';
import 'package:provider/provider.dart';

final routes = {
  BasePage.routeName: (context) => const BasePage(),
  TaskAddPage.routeName: (context) => Provider<TaskAddBloc>(
        create: (context) => TaskAddBloc(),
        dispose: (context, value) => value.dispose(),
        child: const TaskAddPage(),
      ),
  TaskDetailPage.routeName: (context) {
    final Task task = ModalRoute.of(context)!.settings.arguments as Task;

    return Provider<TaskDetailBloc>(
      create: (context) => TaskDetailBloc(task: task),
      dispose: (context, value) => value.dispose(),
      child: const TaskDetailPage(),
    );
  },
  TaskEditPage.routeName: (context) => Provider<TaskEditBloc>(
        create: (context) => TaskEditBloc(),
        dispose: (context, value) => value.dispose(),
        child: const TaskEditPage(),
      ),
};
