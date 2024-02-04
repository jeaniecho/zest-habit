import 'package:flutter/material.dart';
import 'package:habit_app/blocs/task/task_add_bloc.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_appbar.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:provider/provider.dart';

class TaskAddPage extends StatelessWidget {
  const TaskAddPage({super.key});

  static const routeName = '/task-add';

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    return Scaffold(
      appBar: const HTAppbar(showClose: true),
      body: SingleChildScrollView(
        padding: HTEdgeInsets.h24v16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: taskAddBloc.titleController,
              decoration: const InputDecoration(hintText: 'Title'),
            ),
            TextField(
              controller: taskAddBloc.emojiController,
              decoration: const InputDecoration(hintText: 'Emoji'),
            ),
            TextField(
              controller: taskAddBloc.goalController,
              decoration: const InputDecoration(hintText: 'Goal'),
            ),
            HTSpacers.height12,
            const TaskAddRepeatAt(),
            HTSpacers.height24,
            ElevatedButton(
                onPressed: () {
                  taskAddBloc.addTask();
                  Navigator.pop(context);
                },
                child: const Text('Add Task')),
          ],
        ),
      ),
    );
  }
}

class TaskAddRepeatAt extends StatelessWidget {
  const TaskAddRepeatAt({super.key});

  @override
  Widget build(BuildContext context) {
    TaskAddBloc taskAddBloc = context.read<TaskAddBloc>();

    List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    List<int> dayNums = [7, 1, 2, 3, 4, 5, 6];

    double size = (MediaQuery.sizeOf(context).width - 48 - 48) / 7;

    return StreamBuilder<List<int>>(
        stream: taskAddBloc.repeatAt,
        builder: (context, snapshot) {
          List<int> repeatAt = snapshot.data ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HTText(
                'Repeat At',
                typoToken: HTTypoToken.subtitleMedium,
                color: HTColors.black,
              ),
              HTSpacers.height8,
              SizedBox(
                height: size,
                child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    padding: HTEdgeInsets.zero,
                    itemBuilder: (context, index) {
                      bool isSelected = repeatAt.contains(dayNums[index]);

                      return GestureDetector(
                        onTap: () {
                          taskAddBloc.toggleRepeatAt(dayNums[index]);
                        },
                        child: Container(
                          width: size,
                          height: size,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                                color: isSelected
                                    ? HTColors.black
                                    : HTColors.grey020,
                                width: 1),
                            color: isSelected ? HTColors.black : HTColors.white,
                          ),
                          child: Center(
                              child: HTText(
                            days[index],
                            typoToken: HTTypoToken.subtitleXSmall,
                            color:
                                isSelected ? HTColors.white : HTColors.grey040,
                            height: 1.25,
                          )),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return HTSpacers.width8;
                    },
                    itemCount: 7),
              ),
            ],
          );
        });
  }
}
