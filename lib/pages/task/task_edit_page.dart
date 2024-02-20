import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/task/task_edit_bloc.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class TaskEditWidget extends StatelessWidget {
  const TaskEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    TaskEditBloc taskEditBloc = context.read<TaskEditBloc>();

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: SingleChildScrollView(
        padding: HTEdgeInsets.h24v16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: taskEditBloc.titleController,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              style: HTTypoToken.subtitleSmall.textStyle.copyWith(height: 1.25),
              decoration: const InputDecoration(
                  labelText: 'Title',
                  hintText: 'Title',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextField(
              controller: taskEditBloc.emojiController,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              style: HTTypoToken.subtitleSmall.textStyle.copyWith(height: 1.25),
              decoration: const InputDecoration(
                  labelText: 'Emoji',
                  hintText: 'Emoji',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            TextField(
              controller: taskEditBloc.goalController,
              onTapOutside: (event) => FocusScope.of(context).unfocus(),
              style: HTTypoToken.subtitleSmall.textStyle.copyWith(height: 1.25),
              decoration: const InputDecoration(
                  labelText: 'Goal',
                  hintText: 'Goal',
                  floatingLabelBehavior: FloatingLabelBehavior.always),
            ),
            HTSpacers.height24,
            const TaskAddRepeatAt(),
            HTSpacers.height24,
            const TaskAddFrom(),
            HTSpacers.height24,
            const TaskEditUntil(),
            HTSpacers.height48,
            ElevatedButton(
                onPressed: () {
                  taskEditBloc.updateTask();
                  context.pop(taskEditBloc.getUpdatedTask());
                },
                child: const Text('Edit Task')),
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
    TaskEditBloc taskEditBloc = context.read<TaskEditBloc>();

    List<String> days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    List<int> dayNums = [7, 1, 2, 3, 4, 5, 6];

    double size = (MediaQuery.sizeOf(context).width - 48 - 48) / 7;

    return StreamBuilder<List<int>>(
        stream: taskEditBloc.repeatAt,
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
                          taskEditBloc.toggleRepeatAt(dayNums[index]);
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
              HTSpacers.height12,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      taskEditBloc.setRepeatAt([1, 2, 3, 4, 5, 6, 7]);
                    },
                    child: Container(
                      padding: HTEdgeInsets.h16v12,
                      decoration: BoxDecoration(
                        color: repeatAt.length == 7
                            ? HTColors.black
                            : HTColors.white,
                        border: Border.all(color: HTColors.grey020),
                        borderRadius: HTBorderRadius.circularMax,
                      ),
                      child: HTText(
                        'Everyday',
                        typoToken: HTTypoToken.subtitleXSmall,
                        color: repeatAt.length == 7
                            ? HTColors.white
                            : HTColors.grey060,
                        height: 1,
                      ),
                    ),
                  ),
                  HTSpacers.width8,
                  GestureDetector(
                    onTap: () {
                      taskEditBloc.setRepeatAt([1, 2, 3, 4, 5]);
                    },
                    child: Container(
                      padding: HTEdgeInsets.h16v12,
                      decoration: BoxDecoration(
                        color: repeatAtToText(repeatAt) == 'Weekday'
                            ? HTColors.black
                            : HTColors.white,
                        border: Border.all(color: HTColors.grey020),
                        borderRadius: HTBorderRadius.circularMax,
                      ),
                      child: HTText(
                        'Weekday',
                        typoToken: HTTypoToken.subtitleXSmall,
                        color: repeatAtToText(repeatAt) == 'Weekday'
                            ? HTColors.white
                            : HTColors.grey060,
                        height: 1,
                      ),
                    ),
                  ),
                  HTSpacers.width8,
                  GestureDetector(
                    onTap: () {
                      taskEditBloc.setRepeatAt([6, 7]);
                    },
                    child: Container(
                      padding: HTEdgeInsets.h16v12,
                      decoration: BoxDecoration(
                        color: repeatAtToText(repeatAt) == 'Weekend'
                            ? HTColors.black
                            : HTColors.white,
                        border: Border.all(color: HTColors.grey020),
                        borderRadius: HTBorderRadius.circularMax,
                      ),
                      child: HTText(
                        'Weekend',
                        typoToken: HTTypoToken.subtitleXSmall,
                        color: repeatAtToText(repeatAt) == 'Weekend'
                            ? HTColors.white
                            : HTColors.grey060,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}

class TaskAddFrom extends StatelessWidget {
  const TaskAddFrom({super.key});

  @override
  Widget build(BuildContext context) {
    TaskEditBloc taskEditBloc = context.read<TaskEditBloc>();

    return StreamBuilder<DateTime>(
        stream: taskEditBloc.from,
        builder: (context, snapshot) {
          DateTime from = snapshot.data ?? DateTime.now().getDate();

          return Row(
            children: [
              const SizedBox(
                width: 40,
                child: HTText(
                  'From',
                  typoToken: HTTypoToken.subtitleMedium,
                  color: HTColors.black,
                ),
              ),
              HTSpacers.width12,
              GestureDetector(
                onTap: () {
                  showDatePicker(
                          context: context,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2101))
                      .then((value) {
                    if (value != null) {
                      taskEditBloc.setFrom(value);
                    }
                  });
                },
                child: HTText(
                  DateFormat('yyyy.MM.dd (E)').format(from),
                  typoToken: HTTypoToken.subtitleMedium,
                  color: HTColors.grey040,
                ),
              )
            ],
          );
        });
  }
}

class TaskEditUntil extends StatelessWidget {
  const TaskEditUntil({super.key});

  @override
  Widget build(BuildContext context) {
    TaskEditBloc taskEditBloc = context.read<TaskEditBloc>();

    DateTime today = DateTime.now().getDate();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([taskEditBloc.until, taskEditBloc.from]),
        builder: (context, snapshot) {
          DateTime? until = snapshot.data?[0];
          DateTime from = snapshot.data?[1] ?? today;

          if (until != null && until.isBefore(from)) {
            taskEditBloc.setUntil(null);
          }

          return Row(
            children: [
              const SizedBox(
                width: 40,
                child: HTText(
                  'Until',
                  typoToken: HTTypoToken.subtitleMedium,
                  color: HTColors.black,
                ),
              ),
              HTSpacers.width12,
              GestureDetector(
                onTap: () {
                  showDatePicker(
                          context: context,
                          firstDate: from,
                          lastDate: DateTime(2101))
                      .then((value) => taskEditBloc.setUntil(value));
                },
                child: HTText(
                  until != null
                      ? DateFormat('yyyy.MM.dd (E)').format(until)
                      : 'Forever',
                  typoToken: HTTypoToken.subtitleMedium,
                  color: HTColors.grey040,
                ),
              )
            ],
          );
        });
  }
}
