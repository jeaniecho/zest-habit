import 'package:isar/isar.dart';

part 'settings_model.g.dart';

@collection
class Settings {
  Id id;
  bool isDarkMode;
  bool isNotificationOn;
  int createdTaskCount;
  bool completedOnboarding;

  Settings({
    this.id = 1,
    this.isDarkMode = false,
    this.isNotificationOn = false,
    this.createdTaskCount = 0,
    this.completedOnboarding = false,
  });

  Settings copyWith({
    bool? isDarkMode,
    bool? isNotificationOn,
    int? createdTaskCount,
    bool? completedOnboarding,
  }) {
    return Settings(
      id: 1,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isNotificationOn: isNotificationOn ?? this.isNotificationOn,
      createdTaskCount: createdTaskCount ?? this.createdTaskCount,
      completedOnboarding: completedOnboarding ?? this.completedOnboarding,
    );
  }
}
