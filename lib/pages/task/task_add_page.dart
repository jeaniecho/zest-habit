import 'package:flutter/material.dart';
import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:provider/provider.dart';

class TaskAddPage extends StatelessWidget {
  const TaskAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    AppBloc appBloc = context.read<AppBloc>();

    TextEditingController titleController = TextEditingController();
    TextEditingController emojiController = TextEditingController();
    TextEditingController goalController = TextEditingController();
    TextEditingController descController = TextEditingController();

    return SingleChildScrollView(
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
                appBloc.addTask(Task(
                  from: DateTime.now(),
                  emoji: emojiController.text,
                  title: titleController.text,
                  repeatAt: [1, 2, 3, 4, 5, 6, 7],
                  goal: goalController.text,
                  desc: descController.text,
                ));
              },
              child: const Text('add')),
        ],
      ),
    );
  }
}
