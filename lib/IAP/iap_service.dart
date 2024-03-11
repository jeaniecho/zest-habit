import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import 'package:rxdart/rxdart.dart';

import 'consumable_store.dart';

class IAPService {
  static bool kAutoConsume = true;
  static String kConsumableId = 'consumable';
  static String kUpgradeId = 'upgrade';
  static String kEarlybirdMonthlyId = 'dev.jeanie.habitApp.earlybird.monthly';
  static String kEarlybirdYearlyId = 'dev.jeanie.habitApp.earlybird.yearly';
  static String kMonthlySubscriptionId = 'dev.jeanie.habitApp.monthly';
  static String kYearlySubscriptionId = 'dev.jeanie.habitApp.yearly';
  static List<String> kProductIds = [
    kConsumableId,
    kUpgradeId,
    kMonthlySubscriptionId,
    kYearlySubscriptionId,
  ];
  static List<String> kSubscriptionIds = [
    kYearlySubscriptionId,
    kMonthlySubscriptionId,
  ];

  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  InAppPurchase get inAppPurchase => _inAppPurchase;

  final BehaviorSubject<List<String>> _notFoundIds = BehaviorSubject.seeded([]);
  Stream<List<String>> get notFoundIds => _notFoundIds.stream;

  final BehaviorSubject<List<ProductDetails>> _products =
      BehaviorSubject.seeded([]);
  Stream<List<ProductDetails>> get products => _products.stream;
  List<ProductDetails> get productsValue => _products.value;

  final BehaviorSubject<List<PurchaseDetails>> _purchases =
      BehaviorSubject.seeded([]);
  Stream<List<PurchaseDetails>> get purchases => _purchases.stream;
  List<PurchaseDetails> get purchasesValue => _purchases.value;

  final BehaviorSubject<List<String>> _consumables = BehaviorSubject.seeded([]);
  Stream<List<String>> get consumables => _consumables.stream;

  final BehaviorSubject<bool> _isAvailable = BehaviorSubject.seeded(false);
  Stream<bool> get isAvailable => _isAvailable.stream;

  final BehaviorSubject<bool> _purchasePending = BehaviorSubject.seeded(false);
  Stream<bool> get purchasePending => _purchasePending.stream;

  final BehaviorSubject<bool> _loading = BehaviorSubject.seeded(true);
  Stream<bool> get loading => _loading.stream;

  final BehaviorSubject<String?> _queryProductError =
      BehaviorSubject.seeded(null);
  Stream<String?> get queryProductError => _queryProductError.stream;

  IAPService() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription = purchaseUpdated.listen(
      (List<PurchaseDetails> purchaseDetailsList) {
        _listenToPurchaseUpdated(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (Object error) {
        // handle error here
      },
    );

    initStoreInfo();
  }

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      _isAvailable.add(isAvailable);
      _products.add([]);
      _purchases.add([]);
      _notFoundIds.add([]);
      _consumables.add([]);
      _purchasePending.add(false);
      _loading.add(false);

      return;
    }

    final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
        _inAppPurchase.getPlatformAddition();
    await iosPlatformAddition.setDelegate(PaymentQueueDelegate());

    final ProductDetailsResponse productDetailsResponse =
        await _inAppPurchase.queryProductDetails(kProductIds.toSet());
    if (productDetailsResponse.error != null) {
      _queryProductError.add(productDetailsResponse.error!.message);
      _isAvailable.add(isAvailable);
      _products.add([]);
      _purchases.add([]);
      _notFoundIds.add([]);
      _consumables.add([]);
      _purchasePending.add(false);
      _loading.add(false);

      return;
    }

    if (productDetailsResponse.productDetails.isEmpty) {
      _queryProductError.add(null);
      _isAvailable.add(isAvailable);
      _products.add([]);
      _purchases.add([]);
      _notFoundIds.add(kProductIds);
      _consumables.add([]);
      _purchasePending.add(false);
      _loading.add(false);

      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    _isAvailable.add(isAvailable);
    _products.add(productDetailsResponse.productDetails);
    _notFoundIds.add(productDetailsResponse.notFoundIDs);
    _consumables.add(consumables);
    _purchasePending.add(false);
    _loading.add(false);
  }

  bool isPro() {
    return _purchases.value
        .where((element) =>
            element.productID == kMonthlySubscriptionId ||
            element.productID == kYearlySubscriptionId)
        .isNotEmpty;
  }

  Future<bool> verifyPurchase(PurchaseDetails purchaseDetails) {
    // verify purchase
    return Future<bool>.value(true);
  }

  void handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    if (purchaseDetails.productID == kConsumableId) {
      await ConsumableStore.save(purchaseDetails.purchaseID!);
      final List<String> consumables = await ConsumableStore.load();

      _purchasePending.add(false);
      _consumables.add(consumables);
    } else {
      _purchases.add([..._purchases.value, purchaseDetails]);
      _purchasePending.add(false);
    }
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        // show pending UI
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          _purchasePending.add(false);
        } else if (purchaseDetails.status == PurchaseStatus.purchased ||
            purchaseDetails.status == PurchaseStatus.restored) {
          final bool valid = await verifyPurchase(purchaseDetails);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          } else {
            handleInvalidPurchase(purchaseDetails);
            return;
          }
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }
}

class PaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
