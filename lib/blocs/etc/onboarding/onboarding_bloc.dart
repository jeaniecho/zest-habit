import 'package:habit_app/utils/disposable.dart';
import 'package:rxdart/rxdart.dart';

class OnboardingBloc extends Disposable {
  final BehaviorSubject<int> _imageIndex = BehaviorSubject.seeded(0);
  Stream<int> get imageIndex => _imageIndex.stream;
  Function(int) get setImageIndex => _imageIndex.add;

  OnboardingBloc();

  @override
  void dispose() {
    _imageIndex.close();
  }
}
