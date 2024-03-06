import 'package:isar/isar.dart';

part 'settings_model.g.dart';

@collection
class Settings {
  Id id;
  bool isDarkMode;
  bool isNotificationOn;

  Settings({
    this.id = 1,
    this.isDarkMode = false,
    this.isNotificationOn = false,
  });

  Settings copyWith({
    bool? isDarkMode,
    bool? isNotificationOn,
  }) {
    return Settings(
      id: 1,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isNotificationOn: isNotificationOn ?? this.isNotificationOn,
    );
  }
}
