import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:habit_app/gen/assets.gen.dart';
import 'package:habit_app/models/auth_token_model.dart';
import 'package:habit_app/services/api_service.dart';
import 'package:habit_app/services/app_service.dart';
import 'package:habit_app/utils/disposable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SigninBloc extends Disposable {
  final AppService appService;

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

  SigninBloc(this.appService);

  @override
  void dispose() {
    _imageIndex.close();
  }

  movePage(int index) {
    setImageIndex(index);
    textController.animateToPage(index,
        duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
  }

  Future<AuthToken?> signInWithApple() async {
    try {
      AuthorizationCredentialAppleID credential =
          await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      log(credential.toString());

      // String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      // String? fcmToken =
      //     apnsToken != null ? await FirebaseMessaging.instance.getToken() : '';

      AuthToken auth = await ApiService().postAuthLoginApple(
        authorizationCode: credential.authorizationCode,
        snsUserId: credential.userIdentifier ?? '',
        deviceToken: '',
      );
      appService.setAuth(auth);

      return auth;
    } catch (e) {
      log(e.toString());
    }

    return null;
  }

  Future<AuthToken?> signInWithGoogle() async {
    try {
      const List<String> scopes = <String>[
        'email',
      ];

      GoogleSignIn googleSignIn = GoogleSignIn(scopes: scopes);
      GoogleSignInAccount? credential = await googleSignIn.signIn();

      if (credential != null) {
        log(credential.toString());

        GoogleSignInAuthentication googleAuth = await credential.authentication;

        // String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
        // String? fcmToken = apnsToken != null
        //     ? await FirebaseMessaging.instance.getToken()
        //     : '';

        AuthToken auth = await ApiService().postAuthLoginGoogle(
          authorizationCode: googleAuth.idToken ?? '',
          deviceToken: '',
        );

        return auth;
      }
    } catch (e) {
      log(e.toString());
    }

    return null;
  }
}
