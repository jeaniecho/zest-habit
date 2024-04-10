import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_app/blocs/app_service.dart';
import 'package:habit_app/blocs/event_service.dart';
import 'package:habit_app/blocs/task/task_add_bloc.dart';
import 'package:habit_app/blocs/task/task_detail_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/pages/task/task_add_page.dart';
import 'package:habit_app/pages/task/task_detail_page.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/widgets/ht_tooltip.dart';
import 'package:provider/provider.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

GlobalKey firstTaskKey = GlobalKey();
GlobalKey editButtonKey = GlobalKey();
GlobalKey emojiButtonKey = GlobalKey();
GlobalKey emojiPickerKey = GlobalKey();
GlobalKey doneButtonKey = GlobalKey();
GlobalKey addButtonKey = GlobalKey();

List<TargetFocus> targets = [
  TargetFocus(
    identify: 1,
    keyTarget: firstTaskKey,
    shape: ShapeLightFocus.RRect,
    radius: 14,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        padding: const EdgeInsets.only(left: 16, bottom: 8),
        child: const HTTooltip(
          '📝 Tap task and check details',
        ),
      ),
    ],
  ),
  TargetFocus(
    identify: 2,
    keyTarget: editButtonKey,
    shape: ShapeLightFocus.RRect,
    radius: 14,
    contents: [
      TargetContent(
        align: ContentAlign.bottom,
        padding: const EdgeInsets.only(right: 16, top: 8),
        child: const HTTooltip(
          '✏️ You can edit task details here',
          alignment: Alignment.bottomRight,
        ),
      ),
    ],
  ),
  TargetFocus(
    identify: 3,
    keyTarget: emojiButtonKey,
    shape: ShapeLightFocus.RRect,
    radius: 12,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        padding: const EdgeInsets.only(left: 16, bottom: 8),
        child: const HTTooltip(
          '😎 Tap and change emoji',
        ),
      ),
    ],
  ),
  TargetFocus(
    identify: 4,
    keyTarget: emojiPickerKey,
    shape: ShapeLightFocus.RRect,
    radius: 10,
    paddingFocus: 0,
    contents: [
      TargetContent(
        align: ContentAlign.custom,
        customPosition: CustomTargetContentPosition(top: 120),
        padding: const EdgeInsets.only(bottom: 8),
        child: const HTTooltip(
          '🤓 Choose emoji you like!',
          alignment: Alignment.center,
        ),
      ),
    ],
  ),
  TargetFocus(
    identify: 5,
    keyTarget: doneButtonKey,
    shape: ShapeLightFocus.RRect,
    radius: 16,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        padding: const EdgeInsets.only(bottom: 8),
        child: const HTTooltip(
          '👍 You\'re all set! Finish Editing your task',
          alignment: Alignment.center,
        ),
      ),
    ],
  ),
  TargetFocus(
    identify: 6,
    keyTarget: addButtonKey,
    shape: ShapeLightFocus.Circle,
    contents: [
      TargetContent(
        align: ContentAlign.top,
        padding: const EdgeInsets.only(bottom: 8),
        child: const HTTooltip(
          '🍋 Tap here to add your task',
          alignment: Alignment.center,
        ),
      ),
    ],
  ),
];

showTutorial({required AppService appService, required Task firstTask}) {
  if (shellNavKey.currentContext == null) {
    return;
  }

  EventService.viewTutorial();

  BuildContext context = shellNavKey.currentContext!;
  TaskDetailBloc taskDetailBloc = TaskDetailBloc(task: firstTask);
  TaskAddBloc taskAddBloc =
      TaskAddBloc(appService: appService, task: firstTask);

  TutorialCoachMark(
      targets: targets,
      hideSkip: true,
      opacityShadow: 0.5,
      paddingFocus: 0,
      onClickTarget: (p0) {
        switch (p0.identify) {
          case 1:
            context.push(TaskDetailPage.routeName, extra: firstTask);
            break;
          case 2:
            taskDetailBloc.showTutorialEditModal(context, taskAddBloc);
            taskDetailBloc.dispose();
            break;
          case 3:
            taskAddBloc.toggleOpenEmoji();
            break;
          case 4:
            taskAddBloc.toggleOpenEmoji();
            break;
          case 5:
            while (context.canPop()) {
              context.pop();
            }
            taskAddBloc.dispose();
            break;
          case 6:
            showModalBottomSheet(
                context: rootNavKey.currentContext ?? context,
                isScrollControlled: true,
                backgroundColor: HTColors.clear,
                barrierColor: htGreys(context).black.withOpacity(0.3),
                useSafeArea: true,
                builder: (context) {
                  return Provider(
                      create: (context) =>
                          TaskAddBloc(appService: context.read<AppService>()),
                      dispose: (context, value) => value.dispose(),
                      child: const TaskAddWidget());
                });
            break;
          default:
            break;
        }
      },
      onFinish: () {
        EventService.completeTutorial();
      }).show(
    context: context,
    rootOverlay: true,
  );
}
