import 'package:habit_app/blocs/app_service.dart';
import 'package:habit_app/models/onboarding_task_model.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/router.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_snackbar.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:rxdart/rxdart.dart';

final List<OnboardingTask> onboardingTasks = [
  // Popular
  OnboardingTask(index: 0, emoji: '📕', title: 'Read Book'),
  OnboardingTask(index: 1, emoji: '️🏋️‍♀', title: 'Workout'),
  OnboardingTask(index: 2, emoji: '💧', title: 'Drink Water'),
  OnboardingTask(index: 3, emoji: '📓', title: 'Write Journal'),
  OnboardingTask(index: 4, emoji: '🛏️', title: 'Make Bed'),
  OnboardingTask(index: 5, emoji: '🌷', title: 'Meditation'),

  // Health & Sports
  OnboardingTask(index: 6, emoji: '🧘‍♀️', title: 'Yoga'),
  OnboardingTask(index: 7, emoji: '🏊‍♂️', title: 'Swimming'),
  OnboardingTask(index: 8, emoji: '🏃‍♂️', title: 'Running'),
  OnboardingTask(index: 9, emoji: '🚴', title: 'Cycling'),
  OnboardingTask(index: 10, emoji: '🍊', title: 'Take Vitamins & Supplements'),
  OnboardingTask(index: 11, emoji: '🥦', title: 'Eat Vegetables'),
  OnboardingTask(index: 12, emoji: '🍎', title: 'Eat Fruits'),

  // Work Management
  OnboardingTask(index: 13, emoji: '📰', title: 'Read Article'),
  OnboardingTask(index: 14, emoji: '✉️', title: 'Check Emails'),
  OnboardingTask(index: 15, emoji: '💻', title: 'Study Coding'),
  OnboardingTask(index: 16, emoji: '🗓️', title: 'Review My Day'),

  // Language
  OnboardingTask(index: 17, emoji: '🇪🇸', title: 'Study Spanish'),
  OnboardingTask(index: 18, emoji: '🇫🇷', title: 'Study French'),
  OnboardingTask(index: 19, emoji: '🇩🇪', title: 'Study German'),
  OnboardingTask(index: 20, emoji: '🇰🇷', title: 'Study Korean'),
  OnboardingTask(index: 21, emoji: '🇯🇵', title: 'Study Japanese'),
  OnboardingTask(index: 22, emoji: '🇨🇳', title: 'Study Chinese'),

  // Better Life
  OnboardingTask(index: 23, emoji: '🥘', title: 'Try New Recipe'),
  OnboardingTask(index: 24, emoji: '👩‍🍳', title: 'Cook for Myself'),
  OnboardingTask(index: 25, emoji: '💃', title: 'Dancing'),
  OnboardingTask(index: 26, emoji: '🎸', title: 'Play Guitar'),
  OnboardingTask(index: 27, emoji: '📸', title: 'Take Photo'),
  OnboardingTask(index: 28, emoji: '🎹', title: 'Play Piano'),
  OnboardingTask(index: 29, emoji: '🎤', title: 'Singing'),
  OnboardingTask(index: 30, emoji: '🎨', title: 'Drawing'),
];

class OnboardingTaskBloc extends Disposable {
  final AppService appService;

  final BehaviorSubject<List<int>> _selectedTasks = BehaviorSubject.seeded([]);
  Stream<List<int>> get selectedTasks => _selectedTasks.stream;

  OnboardingTaskBloc({
    required this.appService,
  });

  @override
  void dispose() {
    _selectedTasks.close();
  }

  toggleTask(OnboardingTask task) {
    if (_selectedTasks.value.contains(task.index)) {
      _selectedTasks.add(_selectedTasks.value..remove(task.index));
    } else {
      _selectedTasks.add(_selectedTasks.value..add(task.index));
    }
  }

  showErrorToast(int limit) {
    HTToastBar(
      name: 'onboarding-task-limit',
      autoDismiss: true,
      snackbarDuration: const Duration(seconds: 3),
      position: HTSnackbarPosition.top,
      builder: (context) => HTToastCard(
        title: HTText(
          '😅 You can choose up to $limit habits',
          typoToken: HTTypoToken.bodyMedium,
          color: htGreys(context).white,
        ),
        color: htGreys(context).grey080,
      ),
    ).show(rootNavKey.currentContext!);
  }

  Future<List<Task>> addTasks() async {
    List<OnboardingTask> tasks = _selectedTasks.value
        .map((e) => onboardingTasks.firstWhere((element) => element.index == e))
        .toList();

    List<Task> addedTasks = [];

    for (OnboardingTask task in tasks) {
      Task addedTask = await appService.addTask(
        Task(
          from: DateTime.now().getDate(),
          emoji: task.emoji,
          title: task.title,
          repeatAt: RepeatType.everyday.days,
          goal: '',
          desc: '',
        ),
      );

      addedTasks.add(addedTask);
    }

    return addedTasks;
  }
}
