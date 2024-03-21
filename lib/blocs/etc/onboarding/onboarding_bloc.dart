import 'package:flutter/material.dart';
import 'package:habit_app/gen/assets.gen.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:rxdart/rxdart.dart';

class OnboardingBloc extends Disposable {
  final BehaviorSubject<int> _imageIndex = BehaviorSubject.seeded(0);
  Stream<int> get imageIndex => _imageIndex.stream;
  Function(int) get setImageIndex => _imageIndex.add;

  final PageController imageController = PageController();
  final PageController textController = PageController();

  final List<AssetGenImage> images = [
    Assets.images.imgOnboarding1,
    Assets.images.imgOnboarding2,
    Assets.images.imgOnboarding3,
  ];

  final List<String> texts = [
    'Bring to life the version\nof yourself you desire!',
    'Check your day and\nmake habits',
    'Use a timer and\nperform efficiently',
  ];

  OnboardingBloc();

  @override
  void dispose() {
    _imageIndex.close();
  }

  movePage(int index) {
    imageController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    textController.animateToPage(index,
        duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
  }
}
