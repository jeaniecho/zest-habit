import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:habit_app/iap/iap_service.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/notifications.dart';
import 'package:habit_app/widgets/ht_appbar.dart';
import 'package:habit_app/widgets/ht_dialog.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class DevPage extends StatelessWidget {
  const DevPage({super.key});

  static const routeName = '/dev';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: htGreys(context).white,
      appBar: const HTAppbar(
        title: 'Dev Menu',
        showClose: true,
      ),
      body: const SingleChildScrollView(
        padding: HTEdgeInsets.vertical24,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ViewNotiButton(),
            CancelNotiButton(),
            ViewIAPProducts(),
          ],
        ),
      ),
    );
  }
}

class ViewNotiButton extends StatelessWidget {
  const ViewNotiButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: ElevatedButton(
        onPressed: () async {
          List<PendingNotificationRequest> pendingeNotifications =
              await HTNotification.getPendingNotifications();

          // ignore: use_build_context_synchronously
          showDialog(
              context: context,
              builder: (context) {
                return Dialog(
                  surfaceTintColor: htGreys(context).white,
                  child: Container(
                    width: 300,
                    height: 300,
                    padding: HTEdgeInsets.horizontal32,
                    child: ListView.separated(
                      padding: HTEdgeInsets.vertical24,
                      itemBuilder: (context, index) {
                        PendingNotificationRequest item =
                            pendingeNotifications[index];

                        return Row(
                          children: [
                            Container(
                              padding: HTEdgeInsets.all4,
                              decoration: BoxDecoration(
                                color: htGreys(context).black,
                                borderRadius: HTBorderRadius.circular4,
                              ),
                              child: Center(
                                child: HTText(
                                  item.id.toString(),
                                  typoToken: HTTypoToken.subtitleXXSmall,
                                  color: htGreys(context).white,
                                  height: 1,
                                ),
                              ),
                            ),
                            HTSpacers.width8,
                            HTText(
                              item.title ?? '?',
                              typoToken: HTTypoToken.bodySmall,
                              color: htGreys(context).black,
                              height: 1,
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return HTSpacers.height8;
                      },
                      itemCount: pendingeNotifications.length,
                    ),
                  ),
                );
              });
        },
        child: HTText(
          'View Notifications',
          typoToken: HTTypoToken.buttonTextMedium,
          color: htGreys(context).white,
          height: 1.25,
        ),
      ),
    );
  }
}

class CancelNotiButton extends StatelessWidget {
  const CancelNotiButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: HTEdgeInsets.horizontal24,
      child: ElevatedButton(
        onPressed: () {
          HTDialog.showConfirmDialog(
            context,
            title: 'Delete All Notifications',
            content: 'This will delete all scheduled notifications.',
            action: () {
              HTNotification.cancelAllNotifications();
            },
            buttonText: 'Delete',
          );
        },
        child: HTText(
          'Delete All Notifications',
          typoToken: HTTypoToken.buttonTextMedium,
          color: htGreys(context).white,
          height: 1.25,
        ),
      ),
    );
  }
}

class ViewIAPProducts extends StatelessWidget {
  const ViewIAPProducts({super.key});

  @override
  Widget build(BuildContext context) {
    IAPService iapService = context.read<IAPService>();

    return StreamBuilder<List>(
        stream: Rx.combineLatestList([
          iapService.loading,
          iapService.isAvailable,
          iapService.purchases,
          iapService.products,
        ]),
        builder: (context, snapshot) {
          bool loading = snapshot.data?[0] ?? false;
          bool isAvailable = snapshot.data?[1] ?? false;
          List<PurchaseDetails> purchases = snapshot.data?[2] ?? [];
          List<ProductDetails> products = snapshot.data?[3] ?? [];

          Map<String, PurchaseDetails> purchaseMap =
              Map<String, PurchaseDetails>.fromEntries(
                  purchases.map((purchase) {
            if (purchase.pendingCompletePurchase) {
              iapService.inAppPurchase.completePurchase(purchase);
            }
            return MapEntry<String, PurchaseDetails>(
                purchase.productID, purchase);
          }));

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HTSpacers.height12,
              Padding(
                padding: HTEdgeInsets.horizontal24,
                child: HTText('Subscriptions',
                    typoToken: HTTypoToken.headlineXSmall,
                    color: htGreys(context).black),
              ),
              HTSpacers.height8,
              SizedBox(
                height: 80,
                child: loading
                    ? const Center(child: CircularProgressIndicator())
                    : !isAvailable
                        ? Center(
                            child: HTText(
                              'IAP Not available',
                              typoToken: HTTypoToken.bodyMedium,
                              color: htGreys(context).black,
                            ),
                          )
                        : ListView.separated(
                            padding: HTEdgeInsets.horizontal24,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              ProductDetails productDetails = products[index];
                              PurchaseDetails? previousPurchase =
                                  purchaseMap[productDetails.id];

                              return Container(
                                padding: HTEdgeInsets.all16,
                                decoration: BoxDecoration(
                                  color: htGreys(context).grey010,
                                  borderRadius: HTBorderRadius.circular12,
                                ),
                                child: Row(
                                  children: [
                                    HTText(
                                      productDetails.title,
                                      typoToken: HTTypoToken.subtitleMedium,
                                      color: htGreys(context).black,
                                    ),
                                    HTSpacers.width8,
                                    previousPurchase != null
                                        ? const Icon(
                                            Icons.check,
                                            color: HTColors.blue,
                                          )
                                        : ElevatedButton(
                                            onPressed: () {
                                              PurchaseParam purchaseParam =
                                                  PurchaseParam(
                                                      productDetails:
                                                          productDetails);

                                              if (productDetails.id ==
                                                  IAPService.kConsumableId) {
                                                iapService.inAppPurchase
                                                    .buyConsumable(
                                                        purchaseParam:
                                                            purchaseParam);
                                              } else {
                                                iapService.inAppPurchase
                                                    .buyNonConsumable(
                                                        purchaseParam:
                                                            purchaseParam);
                                              }
                                            },
                                            child: HTText(
                                              productDetails.price,
                                              typoToken:
                                                  HTTypoToken.buttonTextSmall,
                                              color: htGreys(context).white,
                                              height: 1.25,
                                            ),
                                          ),
                                  ],
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return HTSpacers.width12;
                            },
                            itemCount: products.length,
                          ),
              ),
            ],
          );
        });
  }
}
