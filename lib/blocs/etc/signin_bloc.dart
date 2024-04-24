import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habit_app/gen/assets.gen.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SigninBloc extends Disposable {
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

  SigninBloc();

  @override
  void dispose() {
    _imageIndex.close();
  }

  movePage(int index) {
    setImageIndex(index);
    textController.animateToPage(index,
        duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  signInWithApple() async {
    try {
      AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      log(credential.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  signInWithGoogle() async {
    try {
      const List<String> scopes = <String>[
        'email',
      ];

      GoogleSignIn googleSignIn = GoogleSignIn(scopes: scopes);
      GoogleSignInAccount? credential = await googleSignIn.signIn();

      if (credential != null) {
        log(credential.toString());
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
