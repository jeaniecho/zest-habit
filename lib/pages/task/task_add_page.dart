import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_appbar.dart';
import 'package:provider/provider.dart';

class TaskAddPage extends StatelessWidget {
  const TaskAddPage({super.key});

  static const routeName = '/task-add';

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = context.read<AppBloc>();

    TextEditingController titleController = TextEditingController();
    TextEditingController emojiController = TextEditingController();
    TextEditingController goalController = TextEditingController();
    TextEditingController descController = TextEditingController();

    return Scaffold(
      appBar: const HTAppbar(showClose: true),
      body: SingleChildScrollView(
        padding: HTEdgeInsets.h24v16,
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(hintText: 'title'),
            ),
            TextField(
              controller: emojiController,
              decoration: const InputDecoration(hintText: 'emoji'),
            ),
            TextField(
              controller: goalController,
              decoration: const InputDecoration(hintText: 'goal'),
            ),
            TextField(
              controller: descController,
              decoration: const InputDecoration(hintText: 'desc'),
            ),
            ElevatedButton(
                onPressed: () {
                  DateTime now = DateTime.now().getDate();
                  DateTime today = DateTime(now.year, now.month, now.day);

                  appBloc.addTask(Task(
                    from: today,
                    emoji: emojiController.text,
                    title: titleController.text,
                    repeatAt: [1, 2, 3, 4, 5, 6, 7],
                    goal: goalController.text,
                    desc: descController.text,
                  ));
                  Navigator.pop(context);
                },
                child: const Text('add')),
          ],
        ),
      ),
    );
  }
}
