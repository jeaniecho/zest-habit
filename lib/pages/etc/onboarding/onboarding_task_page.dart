import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:habit_app/blocs/app_service.dart';
import 'package:habit_app/blocs/etc/onboarding/onboarding_task_bloc.dart';
import 'package:habit_app/models/onboarding_task_model.dart';
import 'package:habit_app/models/settings_model.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class OnboardingTaskPage extends StatelessWidget {
  const OnboardingTaskPage({super.key});

  static const routeName = '/onboarding-task';

  @override
  Widget build(BuildContext context) {
    AppService appService = context.read<AppService>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([appService.settings, appService.isPro]),
        builder: (context, snapshot) {
          Settings settings = snapshot.data?[0] ?? Settings();
          bool isPro = snapshot.data?[1] ?? false;

          return AnnotatedRegion<SystemUiOverlayStyle>(
            value: settings.isDarkMode
                ? SystemUiOverlayStyle.light
                : SystemUiOverlayStyle.dark,
            child: Scaffold(
              backgroundColor: htGreys(context).grey010,
              body: SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HTText(
                        'What habit\nwould you like to start?',
                        typoToken: HTTypoToken.headlineLarge,
                        color: htGreys(context).black,
                      ),
                      HTSpacers.height8,
                      HTText(
                        isPro
                            ? 'Please choose up to 10 habits'
                            : 'Please choose 1 or 2 habits',
                        typoToken: HTTypoToken.buttonTextMedium,
                        color: htGreys(context).grey050,
                      ),
                      HTSpacers.height32,
                      OnboardingTaskCategoryList(
                        title: 'Popular',
                        taskList: onboardingTasks.sublist(0, 6),
                      ),
                      OnboardingTaskCategoryList(
                        title: 'Health & Sports',
                        taskList: onboardingTasks.sublist(6, 13),
                      ),
                      OnboardingTaskCategoryList(
                        title: 'Work Management',
                        taskList: onboardingTasks.sublist(13, 17),
                      ),
                      OnboardingTaskCategoryList(
                        title: 'Language',
                        taskList: onboardingTasks.sublist(17, 23),
                      ),
                      OnboardingTaskCategoryList(
                        title: 'Better Life',
                        taskList: onboardingTasks.sublist(23, 30),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class OnboardingTaskCategoryList extends StatelessWidget {
  final String title;
  final List<OnboardingTask> taskList;
  const OnboardingTaskCategoryList({
    super.key,
    required this.title,
    required this.taskList,
  });

  @override
  Widget build(BuildContext context) {
    OnboardingTaskBloc bloc = context.watch<OnboardingTaskBloc>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        HTText(
          title,
          typoToken: HTTypoToken.headlineMedium,
          color: htGreys(context).black,
        ),
        StreamBuilder<List<int>>(
            stream: bloc.selectedTasks,
            builder: (context, snapshot) {
              List<int> selectedTasks = snapshot.data ?? [];

              return ListView.separated(
                shrinkWrap: true,
                padding: HTEdgeInsets.vertical16,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  OnboardingTask task = taskList[index];
                  bool isSelected = selectedTasks.contains(task.index);

                  return OnboardingTaskBox(task: task);
                },
                separatorBuilder: (context, index) {
                  return HTSpacers.height8;
                },
                itemCount: taskList.length,
              );
            }),
        HTSpacers.height32,
      ],
    );
  }
}

class OnboardingTaskBox extends StatelessWidget {
  final OnboardingTask task;
  const OnboardingTaskBox({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    AppService appService = context.read<AppService>();
    OnboardingTaskBloc bloc = context.watch<OnboardingTaskBloc>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([appService.isPro, bloc.selectedTasks]),
        builder: (context, snapshot) {
          bool isPro = snapshot.data?[0] ?? false;
          List<int> selectedTasks = snapshot.data?[1] ?? [];

          bool isSelected = selectedTasks.contains(task.index);

          return GestureDetector(
            onTap: () {
              if (isSelected ||
                  (isPro && selectedTasks.length < 10) ||
                  (!isPro && selectedTasks.length < 2)) {
                bloc.toggleTask(task);
              } else {
                bloc.showErrorToast(isPro ? 10 : 2);
              }
            },
            child: Container(
              padding: HTEdgeInsets.all16.copyWith(left: 20),
              decoration: BoxDecoration(
                  color: htGreys(context).white,
                  borderRadius: HTBorderRadius.circular10,
                  border: isSelected
                      ? Border.all(
                          color: htGreys(context).black,
                          width: 2,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        )
                      : null),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HTText(
                        task.emoji,
                        typoToken: HTTypoToken.subtitleLarge,
                        color: htGreys(context).black,
                      ),
                      HTSpacers.height2,
                      HTText(
                        task.title,
                        typoToken: HTTypoToken.subtitleLarge,
                        color: htGreys(context).black,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Icon(
                    Icons.check_circle_rounded,
                    size: 24,
                    color: isSelected
                        ? htGreys(context).black
                        : htGreys(context).grey030,
                  ),
                ],
              ),
            ),
          );
        });
  }
}
