import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:habit_app/blocs/etc/subscription_bloc.dart';
import 'package:habit_app/iap/iap_service.dart';
import 'package:habit_app/gen/assets.gen.dart';
import 'package:habit_app/styles/colors.dart';
import 'package:habit_app/styles/tokens.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  static const routeName = '/subscription';

  @override
  Widget build(BuildContext context) {
    return const PopScope(
      canPop: false,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: HTColors.black,
          body: SafeArea(
            child: Column(
              children: [
                SubscriptionAppbar(),
                SubscriptionImage(),
                SubscriptionProducts(),
                SubscriptionButton(),
              ],
            ),
          ),
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
          child: const Icon(Icons.close, color: HTColors.black),
        ),
      ),
    );
  }
}

class SubscriptionImage extends StatefulWidget {
  const SubscriptionImage({super.key});

  @override
  State<SubscriptionImage> createState() => _SubscriptionImageState();
}

class _SubscriptionImageState extends State<SubscriptionImage> {
  final List<AssetGenImage> _images = [
    Assets.images.imgPaywallEarlybird,
    Assets.images.imgPaywallProBenefits,
  ];

  int _imageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
            height: 428.h,
            child: PageView.builder(
              onPageChanged: (int index) {
                setState(() {
                  _imageIndex = index;
                });
              },
              itemBuilder: (context, index) {
                return (_images[index]).image(
                  width: 428.h,
                  fit: BoxFit.contain,
                );
              },
              itemCount: _images.length,
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
                  color: _imageIndex == index
                      ? HTColors.grey010
                      : HTColors.grey080,
                  shape: BoxShape.circle,
                ),
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(width: 8.h);
            },
            itemCount: _images.length,
          ),
        ),
      ],
    );
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
          List<ProductDetails> products = snapshot.data ?? [];
          List<ProductDetails> subscriptions = products
              .where(
                  (element) => IAPService.kSubscriptionIds.contains(element.id))
              .toList();
          subscriptions.sort((a, b) => -a.price.compareTo(b.price));

          if (subscriptions.isEmpty) {
            return const Expanded(
                child: Center(child: CircularProgressIndicator()));
          }

          bloc.setSelectedProduct(subscriptions[1]);

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
                          bloc.setSelectedProduct(subscriptions[0]);
                        },
                        child: SubscriptionProductBox(
                          isSelected: selectedIndex == 0,
                          index: 0,
                          title: 'Yearly',
                          details: subscriptions[0],
                        ),
                      ),
                      SizedBox(width: 16.h),
                      GestureDetector(
                        onTap: () {
                          bloc.setSelectedIndex(1);
                          bloc.setSelectedProduct(subscriptions[1]);
                        },
                        child: SubscriptionProductBox(
                          isSelected: selectedIndex == 1,
                          index: 1,
                          title: 'Monthly',
                          details: subscriptions[1],
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
  const SubscriptionProductBox(
      {super.key,
      required this.isSelected,
      required this.index,
      required this.title,
      required this.details});

  @override
  Widget build(BuildContext context) {
    String dividedPrice =
        (details.rawPrice / (index == 0 ? 12 : 4)).toStringAsFixed(2);
    String dividedIn = (index == 0 ? 'month' : 'week');

    double originalPrice = index == 0 ? 95.88 : 7.99;
    int discount =
        (((originalPrice - details.rawPrice) / originalPrice) * 100).floor();

    String currency = details.price.split(RegExp(r'\d+')).first;

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
                  details.price,
                  style: TextStyle(
                    fontSize: 20.h,
                    color: isSelected ? HTColors.white : HTColors.grey040,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  '($currency$dividedPrice / $dividedIn)',
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
                  PurchaseParam purchaseParam =
                      PurchaseParam(productDetails: productDetails);

                  iapService.inAppPurchase
                      .buyNonConsumable(purchaseParam: purchaseParam)
                      .then((value) => Navigator.pop(context));
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
                          '${productDetails.price} / year will be paid after trial ends',
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
