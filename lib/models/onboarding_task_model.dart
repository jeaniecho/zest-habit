import 'package:isar/isar.dart';

part 'onboarding_task_model.g.dart';

@collection
class OnboardingTask {
  Id id;
  int index;
  String emoji;
  String title;

  OnboardingTask({
    this.id = Isar.autoIncrement,
    required this.index,
    required this.emoji,
    required this.title,
  });
}
