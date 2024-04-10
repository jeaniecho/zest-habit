import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_app/blocs/etc/subscription_bloc.dart';
import 'package:habit_app/blocs/event_service.dart';
import 'package:habit_app/iap/iap_service.dart';
import 'package:habit_app/gen/assets.gen.dart';
import 'package:habit_app/pages/etc/webview_page.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:habit_app/styles/typos.dart';
import 'package:habit_app/utils/enums.dart';
import 'package:habit_app/utils/functions.dart';
import 'package:habit_app/widgets/ht_dialog.dart';
import 'package:habit_app/widgets/ht_text.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  static const routeName = '/subscription';

  @override
  Widget build(BuildContext context) {
    SubscriptionBloc bloc = context.read<SubscriptionBloc>();

    return PopScope(
      canPop: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: [
            const Scaffold(
              backgroundColor: HTColors.black,
              body: SafeArea(
                child: Column(
                  children: [
                    SubscriptionAppbar(),
                    SubscriptionImage(),
                    SubscriptionProducts(),
                    SubscriptionButton(),
                    SubscriptionMenu(),
                  ],
                ),
              ),
            ),
            StreamBuilder<bool>(
                stream: bloc.isLoading,
                builder: (context, snapshot) {
                  bool isLoading = snapshot.data ?? false;

                  return isLoading
                      ? Container(
                          color: HTColors.black50,
                          child:
                              const Center(child: CircularProgressIndicator()),
                        )
                      : const SizedBox.shrink();
                }),
          ],
        ),
      ),
    );
  }
}

class SubscriptionAppbar extends StatelessWidget {
  const SubscriptionAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          width: 28.h,
          height: 28.h,
          margin: HTEdgeInsets.all16.h,
          decoration: BoxDecoration(
            color: HTColors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.close,
            color: HTColors.black,
            size: 24.h,
          ),
        ),
      ),
    );
  }
}

class SubscriptionImage extends StatelessWidget {
  const SubscriptionImage({super.key});

  @override
  Widget build(BuildContext context) {
    SubscriptionBloc bloc = context.read<SubscriptionBloc>();
    IAPService iapService = context.read<IAPService>();

    List<ProductDetails> subscriptions = iapService.productsValue;
    subscriptions.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));

    double originalPrice = subscriptions[1].rawPrice * 12;
    double currPrice = subscriptions[2].rawPrice;

    int discount =
        (((originalPrice - currPrice) / originalPrice) * 100).floor();

    final List<Widget> images = [
      Stack(
        children: [
          Center(
            child: Assets.images.imgPaywallEarlybird.image(
              width: 388.h,
              height: 388.h,
              fit: BoxFit.contain,
            ),
          ),
          Positioned.fill(
              top: 40.h,
              child: Padding(
                padding: EdgeInsets.only(right: 40.h),
                child: Text(
                  discount.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: HTColors.white,
                    fontFamily: 'WalterTurncoat',
                    fontSize: 64.h,
                  ),
                ),
              )),
        ],
      ),
      Assets.images.imgPaywallProBenefits.image(
        width: 388.h,
        fit: BoxFit.contain,
      ),
    ];

    return StreamBuilder<int>(
        stream: bloc.imageIndex,
        builder: (context, snapshot) {
          int imageIndex = snapshot.data ?? 0;

          return Column(
            children: [
              SizedBox(
                  height: 388.h,
                  child: PageView.builder(
                    onPageChanged: (int index) {
                      bloc.setImageIndex(index);
                    },
                    itemBuilder: (context, index) {
                      return images[index];
                    },
                    itemCount: images.length,
                  )),
              HTSpacers.height8,
              SizedBox(
                height: 8.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 8.h,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: imageIndex == index
                            ? HTColors.grey010
                            : HTColors.grey080,
                        shape: BoxShape.circle,
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return SizedBox(width: 8.h);
                  },
                  itemCount: images.length,
                ),
              ),
            ],
          );
        });
  }
}

class SubscriptionProducts extends StatelessWidget {
  const SubscriptionProducts({super.key});

  @override
  Widget build(BuildContext context) {
    IAPService iapService = context.read<IAPService>();
    SubscriptionBloc bloc = context.read<SubscriptionBloc>();

    return StreamBuilder<List<ProductDetails>>(
        stream: iapService.products,
        builder: (context, snapshot) {
          List<ProductDetails> subscriptions = snapshot.data ?? [];
          subscriptions.sort((a, b) => a.rawPrice.compareTo(b.rawPrice));

          if (subscriptions.isEmpty) {
            return const Expanded(
                child: Center(child: CircularProgressIndicator()));
          }

          bloc.setSelectedProduct(subscriptions[0]);

          return StreamBuilder<int>(
              stream: bloc.selectedIndex,
              builder: (context, snapshot) {
                int selectedIndex = snapshot.data ?? 1;

                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          bloc.setSelectedIndex(0);
                          bloc.setSelectedProduct(subscriptions[2]);
                          EventService.tapYearlyPlan();
                        },
                        child: SubscriptionProductBox(
                          isSelected: selectedIndex == 0,
                          index: 0,
                          title: 'Yearly',
                          details: subscriptions[2],
                          originalPrice: subscriptions[1].rawPrice * 12,
                        ),
                      ),
                      SizedBox(width: 16.h),
                      GestureDetector(
                        onTap: () {
                          bloc.setSelectedIndex(1);
                          bloc.setSelectedProduct(subscriptions[0]);
                          EventService.tapMonthlyPlan();
                        },
                        child: SubscriptionProductBox(
                          isSelected: selectedIndex == 1,
                          index: 1,
                          title: 'Monthly',
                          details: subscriptions[0],
                          originalPrice: subscriptions[1].rawPrice,
                        ),
                      ),
                    ],
                  ),
                );
              });
        });
  }
}

class SubscriptionProductBox extends StatelessWidget {
  final bool isSelected;
  final int index;
  final String title;
  final ProductDetails details;
  final double originalPrice;
  const SubscriptionProductBox({
    super.key,
    required this.isSelected,
    required this.index,
    required this.title,
    required this.details,
    required this.originalPrice,
  });

  @override
  Widget build(BuildContext context) {
    String dividedPrice = subscriptionPriceFormat(
        details.rawPrice / (index == 0 ? 12 : 4), details.currencySymbol);
    String dividedIn = (index == 0 ? 'month' : 'week');

    int discount =
        (((originalPrice - details.rawPrice) / originalPrice) * 100).floor();

    return ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10.h)),
      child: Stack(
        children: [
          Container(
            width: 182.h,
            height: 200.h,
            decoration: BoxDecoration(
              color: HTColors.grey090,
              border: isSelected
                  ? Border.all(color: HTColors.white, width: 3.h)
                  : null,
              borderRadius: BorderRadius.circular(10.h),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 24.h),
                Text(
                  subscriptionPriceFormat(
                      details.rawPrice, details.currencySymbol),
                  style: TextStyle(
                    fontSize: 20.h,
                    color: isSelected ? HTColors.white : HTColors.grey040,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '($dividedPrice/$dividedIn)',
                  style: TextStyle(
                    fontSize: 16.h,
                    color: HTColors.grey050,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                SizedBox(
                  height: 24.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 4.h),
                        decoration: BoxDecoration(
                          color: HTColors.grey080,
                          borderRadius: BorderRadius.circular(4.h),
                        ),
                        child: Center(
                          child: Text(
                            '$discount% Off',
                            style: TextStyle(
                              fontSize: 13.h,
                              color: HTColors.grey040,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      if (index == 0)
                        Container(
                          margin: EdgeInsets.only(left: 8.h),
                          padding: EdgeInsets.symmetric(horizontal: 4.h),
                          decoration: BoxDecoration(
                            color: HTColors.grey080,
                            borderRadius: BorderRadius.circular(4.h),
                          ),
                          child: Center(
                            child: Text(
                              'Free Trial',
                              style: TextStyle(
                                fontSize: 13.h,
                                color: HTColors.grey040,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 0,
            child: Container(
              width: 182.h,
              height: 36.h,
              color: isSelected ? HTColors.white : HTColors.grey080,
              child: Center(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.h,
                    color: isSelected ? HTColors.black : HTColors.grey040,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SubscriptionButton extends StatelessWidget {
  const SubscriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    IAPService iapService = context.read<IAPService>();
    SubscriptionBloc bloc = context.read<SubscriptionBloc>();

    return StreamBuilder<List>(
        stream:
            Rx.combineLatestList([bloc.selectedProduct, bloc.selectedIndex]),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox.shrink();
          }

          ProductDetails productDetails = snapshot.data?[0];
          int selectedIndex = snapshot.data?[1] ?? 1;

          return Container(
              height: 64.h,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 24.h),
              child: ElevatedButton(
                onPressed: () {
                  EventService.tapSubscribe(
                      planType: selectedIndex == 0
                          ? SubscriptionType.yearly
                          : SubscriptionType.monthly);

                  PurchaseParam purchaseParam =
                      PurchaseParam(productDetails: productDetails);

                  iapService.inAppPurchase
                      .buyNonConsumable(purchaseParam: purchaseParam)
                      .then((value) {
                    iapService.purchases.listen((event) {
                      if (event.isNotEmpty) {
                        Navigator.pop(context);

                        EventService.completeSubscribe(
                          planType: selectedIndex == 0
                              ? SubscriptionType.yearly
                              : SubscriptionType.monthly,
                          location: bloc.location,
                        );
                      }
                    });
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: HTColors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.h)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      selectedIndex == 0 ? 'Start Free Trial' : 'Subscribe Now',
                      style: TextStyle(
                        fontSize: 20.h,
                        color: HTColors.black,
                        fontWeight: FontWeight.w700,
                        height: 1.h,
                      ),
                    ),
                    if (selectedIndex == 0)
                      Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Text(
                          '${productDetails.price}/year will be paid after trial ends',
                          style: TextStyle(
                            fontSize: 12.h,
                            color: HTColors.grey050,
                            fontWeight: FontWeight.w500,
                            height: 1.h,
                          ),
                        ),
                      ),
                  ],
                ),
              ));
        });
  }
}

class SubscriptionMenu extends StatelessWidget {
  const SubscriptionMenu({super.key});

  @override
  Widget build(BuildContext context) {
    SubscriptionBloc bloc = context.read<SubscriptionBloc>();
    IAPService iapService = context.read<IAPService>();

    return Column(
      children: [
        HTSpacers.height24,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                bloc.setIsLoading(true);
                iapService.restroePurchases().then((value) {
                  bloc.setIsLoading(false);

                  iapService.purchases.listen((event) {
                    if (event.isNotEmpty) {
                      HTDialog.showConfirmDialog(
                        context,
                        title: 'Restoration Completed',
                        content: 'You can now access Zest Pro features.',
                        action: () {
                          Navigator.pop(context);
                        },
                        buttonText: 'OK',
                        isDestructive: false,
                        showCancel: false,
                      );
                    }
                  });
                });
              },
              child: const HTText(
                'Restore Purchase',
                typoToken: HTTypoToken.bodyXXSmall,
                color: HTColors.grey050,
              ),
            ),
            const Padding(
              padding: HTEdgeInsets.horizontal8,
              child: HTText(
                '|',
                typoToken: HTTypoToken.bodyXXSmall,
                color: HTColors.grey050,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WebviewPage(
                            title: 'Terms of Service',
                            url:
                                'https://dour-rhodium-0f4.notion.site/Zest-Terms-of-Use-3d0f81cfe4d94feaae19ccd6dcbe1d66?pvs=4')));
              },
              child: const HTText(
                'Terms of Service',
                typoToken: HTTypoToken.bodyXXSmall,
                color: HTColors.grey050,
              ),
            ),
            const Padding(
              padding: HTEdgeInsets.horizontal8,
              child: HTText(
                '|',
                typoToken: HTTypoToken.bodyXXSmall,
                color: HTColors.grey050,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const WebviewPage(
                            title: 'Privacy Policy',
                            url:
                                'https://dour-rhodium-0f4.notion.site/Zest-Privacy-Policy-bb8879af28fa4d83862300eb6c1f99ea?pvs=4')));
              },
              child: const HTText(
                'Privacy Policy',
                typoToken: HTTypoToken.bodyXXSmall,
                color: HTColors.grey050,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
