import 'package:rxdart/rxdart.dart';

class AppBloc {
  final BehaviorSubject<int> _bottomIndex = BehaviorSubject.seeded(0);
  Stream<int> get bottomIndex => _bottomIndex.stream;
  Function get setBottomIndex => _bottomIndex.add;

  AppBloc();
}
