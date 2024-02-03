import 'package:habit_app/models/task_model.dart';
import 'package:habit_app/utils/disposable.dart';

class TaskDetailBloc extends Disposable {
  final Task task;

  TaskDetailBloc({required this.task});

  @override
  void dispose() {}
}
