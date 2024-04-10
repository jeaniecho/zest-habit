import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:habit_app/utils/enums.dart';

class EventService {
  // 1.0.2
  // setUser() {
  //   FirebaseAnalytics.instance.setUserId(id: id);
  //   FirebaseAnalytics.instance.setUserProperty(name: name, value: value);
  // }

  /// 로그인
  static void login(String loginMethod) {
    FirebaseAnalytics.instance.logLogin(loginMethod: loginMethod);
  }

  /// 가입
  static void signUp(String signUpMethod) {
    FirebaseAnalytics.instance.logSignUp(signUpMethod: signUpMethod);
  }

  /// 하단 네비에서 태스크 탭을 탭했을 때
  static void tapNavTask() {
    FirebaseAnalytics.instance.logEvent(name: 'tap_nav_task');
  }

  /// 하ㄴ 네비에서 타이머 탭을 탭했을 때
  static void tapNavTimer() {
    FirebaseAnalytics.instance.logEvent(name: 'tap_nav_timer');
  }

  /// 상단 햄버거 메뉴 아이콘 버튼을 탭했을 때
  static void tapMenu() {
    FirebaseAnalytics.instance.logEvent(name: 'tap_menu');
  }

  /// 하단 네비 태스크 생성 버튼을 탭했을 때
  static void tapNavCreateTask() {
    FirebaseAnalytics.instance.logEvent(name: 'tap_nav_createtask');
  }

  /// 전체 태스크 탭을 탭했을 때
  static void tapTabAllTask({
    required int totalNumTask,
    required int totalNumTaskActive,
    required int totalNumTaskInactive,
    required int totalNumTaskRepeat,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'tap_tab_alltask',
      parameters: {
        'total_num_task': totalNumTask,
        'total_num_taskactive': totalNumTaskActive,
        'total_num_taskinactive': totalNumTaskInactive,
        'total_num_taskrepeat': totalNumTaskRepeat,
      },
    );
  }

  /// 태스크를 탭해 상세로 들어갈 때
  static void tapTask({
    required String taskTitle,
    required DateTime taskStartDate,
    DateTime? taskEndDate,
    RepeatType? taskRepeatType,
    String? taskEmoji,
    required DateTime taskCreateDate,
    required bool taskAlarm,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'tap_task',
      parameters: {
        'task_title': taskTitle,
        'task_start_date': taskStartDate.toIso8601String(),
        'task_end_date': taskEndDate?.toIso8601String() ?? 'forever',
        'task_repeat_type': taskRepeatType?.name ?? 'none',
        'task_emoji': taskEmoji ?? 'default',
        'task_create_date': taskCreateDate.toIso8601String(),
        'task_alarm': taskAlarm,
      },
    );
  }

  /// 캘린더 탭 화면으로 유저가 랜딩되었을 때
  static void viewCalendarTask({
    required int todayNumTask,
    required int todayNumTaskRepeat,
    required DateTime date,
    required DateTime viewDate,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'view_calendar_task',
      parameters: {
        'today_num_task': todayNumTask,
        'today_num_task_repeat': todayNumTaskRepeat,
        'date': date.toIso8601String(),
        'view_date': viewDate.toIso8601String(),
      },
    );
  }

  /// 상단 날짜를 탭했을 때
  static void tapCalendarDate({
    required DateTime calendarDate,
    required DateTime tapDate,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'tap_calendar_date',
      parameters: {
        'calendar_date': calendarDate.toIso8601String(),
        'tap_date': tapDate.toIso8601String(),
      },
    );
  }

  /// 캘린더 탭을 탭했을 때
  static void tapTabCalendar() {
    FirebaseAnalytics.instance.logEvent(name: 'tap_tab_calendar');
  }

  /// 생성된 태스크 완료를 탭했을 때
  static void tapTaskDone() {
    FirebaseAnalytics.instance.logEvent(name: 'tap_taskdone');
  }

  /// 태스크 삭제를 탭했을 때
  static void deleteTask({
    required String taskTitle,
    required DateTime taskStartDate,
    DateTime? taskEndDate,
    RepeatType? taskRepeatType,
    String? taskEmoji,
    required DateTime taskCreateDate,
    required bool taskAlarm,
    required DateTime deleteDate,
    required int taskPeriod,
    required SubscriptionType subscribeStatus,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'delete_task',
      parameters: {
        'task_title': taskTitle,
        'task_start_date': taskStartDate.toIso8601String(),
        'task_end_date': taskEndDate?.toIso8601String() ?? 'forever',
        'task_repeat_type': taskRepeatType?.name ?? 'none',
        'task_emoji': taskEmoji ?? 'default',
        'task_create_date': taskCreateDate.toIso8601String(),
        'task_alarm': taskAlarm,
        'delete_date': deleteDate.toIso8601String(),
        'task_period': taskPeriod,
        'subscribe_status': subscribeStatus.name,
      },
    );
  }

  /// 태스크 편집을 탭했을 때
  static void editTask({
    required String taskTitle,
    required DateTime taskStartDate,
    DateTime? taskEndDate,
    RepeatType? taskRepeatType,
    String? taskEmoji,
    required DateTime taskCreateDate,
    required bool taskAlarm,
    required SubscriptionType subscribeStatus,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'edit_task',
      parameters: {
        'task_title': taskTitle,
        'task_start_date': taskStartDate.toIso8601String(),
        'task_end_date': taskEndDate?.toIso8601String() ?? 'forever',
        'task_repeat_type': taskRepeatType?.name ?? 'none',
        'task_emoji': taskEmoji ?? 'default',
        'task_create_date': taskCreateDate.toIso8601String(),
        'task_alarm': taskAlarm,
        'subscribe_status': subscribeStatus.name,
      },
    );
  }

  /// 태스크 생성을 정상적으로 완료했을 때
  static void createTaskComplete({
    required String taskTitle,
    required DateTime taskStartDate,
    DateTime? taskEndDate,
    RepeatType? taskRepeatType,
    String? taskEmoji,
    required DateTime taskCreateDate,
    required bool taskAlarm,
    required bool fillSubtitle,
    required SubscriptionType subscribeStatus,
  }) {
    FirebaseAnalytics.instance
        .logEvent(name: 'create_task_complete', parameters: {
      'task_title': taskTitle,
      'task_start_date': taskStartDate.toIso8601String(),
      'task_end_date': taskEndDate?.toIso8601String() ?? 'forever',
      'task_repeat_type': taskRepeatType?.name ?? 'none',
      'task_emoji': taskEmoji ?? 'default',
      'task_create_date': taskCreateDate.toIso8601String,
      'task_alarm': taskAlarm,
      'fill_subtitle': fillSubtitle,
      'subscribe_status': subscribeStatus.name,
    });
  }

  /// 구독화면에 랜딩되었을 때
  static void viewSubscribe() {
    FirebaseAnalytics.instance.logEvent(name: 'view_subscribe');
  }

  /// 연간 구독 상품을 탭했을 때
  static void tapYearlyPlan() {
    FirebaseAnalytics.instance.logEvent(name: 'tap_yearly_plan');
  }

  /// 월간 구독 상품을 탭했을 때
  static void tapMonthlyPlan() {
    FirebaseAnalytics.instance.logEvent(name: 'tap_monthly_plan');
  }

  /// 구독하기 버튼읋 탭했을 때
  static void tapSubscribe({required SubscriptionType planType}) {
    FirebaseAnalytics.instance.logEvent(
      name: 'tap_subscribe',
      parameters: {
        'plan_type': planType.name,
      },
    );
  }

  /// 구독을 완료했을 때
  static void completeSubscribe({
    required SubscriptionType planType,
    required SubscriptionLocation location,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'complete_subscribe',
      parameters: {
        'plan_type': planType.name,
        'location': location.name,
      },
    );
  }

  /// tap_subscribe_banner
  static void tapSubscribeBanner() {
    FirebaseAnalytics.instance.logEvent(name: 'tap_subscribe_banner');
  }

  /// 온보딩에서 Start Now 버튼을 탭했을 때
  static void completeOnboarding({
    required String taskTitle,
    required String taskCategory,
  }) {
    FirebaseAnalytics.instance.logEvent(
      name: 'complete_onboarding',
      parameters: {
        'task_title': taskTitle,
        'task_category': taskCategory,
      },
    );
  }

  /// 튜토리얼 첫화면에 랜딩했을 때
  static void viewTutorial() {
    FirebaseAnalytics.instance.logEvent(name: 'view_tutorial');
  }

  /// 튜토리얼을 모두 완료했을 때
  static void completeTutorial() {
    FirebaseAnalytics.instance.logEvent(name: 'complete_tutorial');
  }

  /// 모드 메뉴를 탭했을 때
  static void tapMode() {
    FirebaseAnalytics.instance.logEvent(name: 'tap_mode');
  }

  /// 모드 라디오 버튼을 탭했을 때
  static void changeMode({required ModeType modeType}) {
    FirebaseAnalytics.instance.logEvent(
      name: 'change_mode',
      parameters: {
        'mode_type': modeType.name,
      },
    );
  }

  /// 모드 탭에서 닫기 버튼을 탭했을 때
  static void closeMode({required ModeType modeType}) {
    FirebaseAnalytics.instance.logEvent(
      name: 'close_mode',
      parameters: {
        'mode_type': modeType.name,
      },
    );
  }

  /// 서포트를 탭했을 때
  static void tapSupport() {
    FirebaseAnalytics.instance.logEvent(name: 'tap_support');
  }

  /// 타이머 플레이를 탭했을 때
  tapTimerPlay({required String taskTitle}) {
    FirebaseAnalytics.instance.logEvent(
      name: 'tap_timer_play',
      parameters: {
        'task_title': taskTitle,
      },
    );
  }
}
