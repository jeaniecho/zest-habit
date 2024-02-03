import 'package:flutter/material.dart';
import 'package:habit_app/widgets/ht_appbar.dart';

class TaskEditPage extends StatelessWidget {
  const TaskEditPage({super.key});

  static const routeName = '/task-edit';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: HTAppbar(),
    );
  }
}
