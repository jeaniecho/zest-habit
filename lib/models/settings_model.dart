import 'package:isar/isar.dart';

part 'settings_model.g.dart';

@collection
class Settings {
  Id id;
  bool isDarkMode;
  bool isNotificationOn;
  int createdTaskCount;

  Settings({
    this.id = 1,
    this.isDarkMode = false,
    this.isNotificationOn = false,
    this.createdTaskCount = 0,
  });

  Settings copyWith({
    bool? isDarkMode,
    bool? isNotificationOn,
    int? createdTaskCount,
  }) {
    return Settings(
      id: 1,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isNotificationOn: isNotificationOn ?? this.isNotificationOn,
      createdTaskCount: createdTaskCount ?? this.createdTaskCount,
    );
  }
}
