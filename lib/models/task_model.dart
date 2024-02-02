class TaskVM {
  int id;
  DateTime from;
  String emoji;
  String title;
  DateTime? until;
  List<int> repeatAt; // weekdays (1 ~ 7 == Mon ~ Sun) / if empty: one time
  String goal;
  String desc;
  List<DateTime> doneAt;

  TaskVM({
    required this.id,
    required this.from,
    required this.emoji,
    required this.title,
    this.until,
    required this.repeatAt,
    required this.goal,
    required this.desc,
    required this.doneAt,
  });

  TaskVM copyWith({
    DateTime? from,
    String? emoji,
    String? title,
    List<int>? repeatAt,
    String? goal,
    String? desc,
    List<DateTime>? doneAt,
  }) {
    return TaskVM(
      id: id,
      from: from ?? this.from,
      emoji: emoji ?? this.emoji,
      title: title ?? this.title,
      until: until,
      repeatAt: repeatAt ?? this.repeatAt,
      goal: goal ?? this.goal,
      desc: desc ?? this.desc,
      doneAt: doneAt ?? this.doneAt,
    );
  }

  TaskVM updateUntil(DateTime? until) {
    return TaskVM(
      id: id,
      from: from,
      emoji: emoji,
      title: title,
      until: until,
      repeatAt: repeatAt,
      goal: goal,
      desc: desc,
      doneAt: doneAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'from': '${from.year}-${from.month}-${from.day}',
      'emoji': emoji,
      'title': title,
      'until':
          until == null ? '' : '${until!.year}-${until!.month}-${until!.day}',
      'repeatAt': repeatAt.toString(),
      'goal': goal,
      'desc': desc,
      'doneAt': doneAt
          .map((e) => '${e.year}-${e.month}-${e.day}')
          .toList()
          .toString(),
    };
  }
}
