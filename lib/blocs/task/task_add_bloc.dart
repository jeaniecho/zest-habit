import 'package:habit_app/blocs/app_bloc.dart';
import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:rxdart/rxdart.dart';

class TaskAddBloc extends Disposable {
  final AppBloc appBloc;

  final BehaviorSubject<String> _title = BehaviorSubject.seeded('');
  Stream<String> get title => _title.stream;
  Function(String) get setTitle => _title.add;

  final BehaviorSubject<String> _emoji = BehaviorSubject.seeded('');
  Stream<String> get emoji => _emoji.stream;
  Function(String) get setEmoji => _emoji.add;

  final BehaviorSubject<String> _goal = BehaviorSubject.seeded('');
  Stream<String> get goal => _goal.stream;
  Function(String) get setGoal => _goal.add;

  final BehaviorSubject<bool> _isRepeat = BehaviorSubject.seeded(false);
  Stream<bool> get isRepeat => _isRepeat.stream;
  Function(bool) get setIsRepeat => _isRepeat.add;

  final BehaviorSubject<RepeatType> _repeatType =
      BehaviorSubject.seeded(RepeatType.everyday);
  Stream<RepeatType> get repeatType => _repeatType.stream;
  Function(RepeatType) get setRepeatType => _repeatType.add;

  final BehaviorSubject<List<int>> _repeatAt = BehaviorSubject.seeded([]);
  Stream<List<int>> get repeatAt => _repeatAt.stream;
  Function(List<int>) get setRepeatAt => _repeatAt.add;

  final BehaviorSubject<DateTime> _from =
      BehaviorSubject.seeded(DateTime.now().getDate());
  Stream<DateTime> get from => _from.stream;
  Function(DateTime) get setFrom => _from.add;

  final BehaviorSubject<DateTime?> _until = BehaviorSubject.seeded(null);
  Stream<DateTime?> get until => _until.stream;
  Function(DateTime?) get setUntil => _until.add;

  final BehaviorSubject<bool> _openEmoji = BehaviorSubject.seeded(false);
  Stream<bool> get openEmoji => _openEmoji.stream;
  Function(bool) get setOpenEmoji => _openEmoji.add;

  TaskAddBloc({required this.appBloc});

  @override
  void dispose() {
    _title.close();
    _emoji.close();
    _goal.close();
    _isRepeat.close();
    _repeatType.close();
    _repeatAt.close();
    _from.close();
    _until.close();
    _openEmoji.close();
  }

  toggleRepeatAt(int day) {
    List<int> rep = _repeatAt.value;
    if (rep.contains(day)) {
      rep.remove(day);
    } else {
      rep.add(day);
    }

    _repeatAt.add(rep);
  }

  addTask() {
    appBloc.addTask(Task(
      from: _from.value,
      emoji: _emoji.value,
      title: _title.value,
      repeatAt: _repeatAt.value,
      goal: _goal.value,
      desc: '',
      until: _until.value,
    ));
  }

  toggleOpenEmoji() {
    if (_openEmoji.value) {
      setOpenEmoji(false);
    } else {
      setOpenEmoji(true);
    }
  }
}
