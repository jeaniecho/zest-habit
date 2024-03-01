import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:habit_app/styles/effects.dart';
import 'package:habit_app/styles/tokens.dart';

List<HTToastBar> _toastBars = [];

/// HT Toast core class
class HTToastBar {
  /// Duration of toast when autoDismiss is true
  final Duration snackbarDuration;

  /// Position of toast
  final HTSnackbarPosition position;

  /// Set true to dismiss toast automatically based on snackbarDuration
  final bool autoDismiss;

  /// Pass the widget inside builder context
  final WidgetBuilder builder;

  /// Duration of animated transitions
  final Duration animationDuration;

  /// Animation Curve
  final Curve animationCurve;

  /// Info on each snackbar
  late final SnackBarInfo info;

  // Name
  final String name;

  /// Initialise HT Toastbar with required parameters
  HTToastBar({
    this.snackbarDuration = const Duration(seconds: 3),
    this.position = HTSnackbarPosition.bottom,
    required this.builder,
    this.animationDuration = const Duration(milliseconds: 200),
    this.autoDismiss = false,
    this.animationCurve = Curves.ease,
    required this.name,
  }) : assert(
            snackbarDuration.inMilliseconds > animationDuration.inMilliseconds);

  /// Remove individual toasbars on dismiss
  void remove() {
    info.entry.remove();
    _toastBars.removeWhere((element) => element == this);
  }

  /// Push the snackbar in current context
  void show(BuildContext context) {
    OverlayState overlayState = Navigator.of(context).overlay!;
    info = SnackBarInfo(
      key: GlobalKey<RawHTToastState>(),
      createdAt: DateTime.now(),
    );

    bool hasSame = checkSame(name, info.key) > 0;
    if (hasSame) {
      gapBetweenCard = 0;
    } else {
      gapBetweenCard = 16;
    }

    info.entry = OverlayEntry(
      builder: (_) => RawHTToast(
        key: info.key,
        animationDuration:
            hasSame ? const Duration(seconds: 0) : animationDuration,
        snackbarPosition: position,
        animationCurve: animationCurve,
        autoDismiss: autoDismiss,
        getPosition: () => calculatePosition(_toastBars, this),
        getscaleFactor: () => calculateScaleFactor(_toastBars, this),
        snackbarDuration: snackbarDuration,
        onRemove: remove,
        child: builder.call(context),
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _toastBars.add(this);
      overlayState.insert(info.entry);

      if (checkSame(name, info.key) > 0) {
        Future.delayed(const Duration(milliseconds: 100), () {
          removeSame(name, info.key);
        });
      }
    });
  }

  /// Remove all the snackbar in the context
  static void removeAll() {
    for (int i = 0; i < _toastBars.length; i++) {
      _toastBars[i].info.entry.remove();
    }
    _toastBars.removeWhere((element) => true);
  }

  // Check if same snackbar exists
  static int checkSame(String name, GlobalKey except) {
    return _toastBars
        .where((element) => element.name == name && element.info.key != except)
        .length;
  }

  // Remove same contents
  static void removeSame(String name, GlobalKey except) {
    for (int i = 0; i < _toastBars.length; i++) {
      if (_toastBars[i].name == name && _toastBars[i].info.key != except) {
        _toastBars[i].info.entry.remove();
      }
    }
    _toastBars.removeWhere(
        (element) => element.name == name && element.info.key != except);
  }
}

/// Snackbar info class
class SnackBarInfo {
  late final OverlayEntry entry;
  final GlobalKey<RawHTToastState> key;
  final DateTime createdAt;

  SnackBarInfo({required this.key, required this.createdAt});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SnackBarInfo &&
        other.entry == entry &&
        other.key == key &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => entry.hashCode ^ key.hashCode ^ createdAt.hashCode;
}

/// Get all the toastbars which currenlty on context
extension Cleaner on List<HTToastBar> {
  /// clean function to iterate over toastbars which are in context
  List<HTToastBar> clean() {
    return where((element) => element.info.key.currentState != null).toList();
  }
}

/// ToastCard widget to display decent and rich looking snackbar
class HTToastCard extends StatelessWidget {
  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final Color? color;
  final Color? shadowColor;
  final Function()? onTap;
  const HTToastCard({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.color,
    this.shadowColor,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: HTEdgeInsets.horizontal20,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).dialogBackgroundColor,
        borderRadius: HTBorderRadius.circular12,
        boxShadow: HTBoxShadows.shadows01,
      ),
      child: ListTile(
        contentPadding: HTEdgeInsets.horizontal24,
        leading: leading,
        trailing: trailing,
        subtitle: subtitle,
        title: title,
        onTap: onTap,
      ),
    );
  }
}

class RawHTToast extends StatefulWidget {
  final Widget child;
  final Duration animationDuration;
  final Duration snackbarDuration;
  final Curve? animationCurve;
  final bool autoDismiss;
  final HTSnackbarPosition snackbarPosition;
  final Function() getscaleFactor;
  final Function() getPosition;

  final Function() onRemove;
  const RawHTToast(
      {super.key,
      required this.child,
      required this.animationDuration,
      required this.snackbarPosition,
      required this.snackbarDuration,
      required this.onRemove,
      this.autoDismiss = true,
      required this.getPosition,
      this.animationCurve,
      required this.getscaleFactor});

  @override
  State<RawHTToast> createState() => RawHTToastState();
}

class RawHTToastState extends State<RawHTToast> {
  final GlobalKey positionedKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  Widget getChildBasedOnDissmiss(Widget child) {
    return Animate(
      onComplete: (controller) {
        if (widget.autoDismiss) {
          widget.onRemove();
        }
      },
      effects: [
        SlideEffect(
            begin: Offset(0,
                widget.snackbarPosition == HTSnackbarPosition.bottom ? 2 : -2),
            end: Offset.zero,
            duration: Duration(
                milliseconds: 2 * widget.animationDuration.inMilliseconds),
            curve: widget.animationCurve ?? Curves.elasticOut),
        FadeEffect(duration: widget.animationDuration, begin: 0, end: 1),
        if (widget.autoDismiss)
          SlideEffect(
            delay: widget.snackbarDuration,
            duration: const Duration(milliseconds: 500),
            curve: widget.animationCurve ?? Curves.easeInOut,
            begin: Offset.zero,
            end: const Offset(1, 0),
          )
      ],
      child: Dismissible(
          key: UniqueKey(),
          onDismissed: (direction) {
            widget.onRemove();
          },
          child: widget.child),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: widget.animationDuration.inMilliseconds),
      key: positionedKey,
      curve: Curves.easeOutBack,
      top: widget.snackbarPosition == HTSnackbarPosition.top
          ? widget.getPosition() + 70
          : null,
      bottom: widget.snackbarPosition == HTSnackbarPosition.bottom
          ? widget.getPosition() + 70
          : null,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: AnimatedScale(
          duration: widget.animationDuration,
          curve: Curves.bounceOut,
          scale: widget.getPosition() == 0 ? 1 : widget.getscaleFactor(),
          child: getChildBasedOnDissmiss(widget.child),
        ),
      ),
    );
  }
}

enum HTSnackbarPosition { top, bottom }

/// The gap between stack of cards
int gapBetweenCard = 16;

/// calculate position of old cards based on current position
double calculatePosition(List<HTToastBar> toastBars, HTToastBar self) {
  if (toastBars.isNotEmpty && self != toastBars.last) {
    final box = self.info.key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null) {
      return gapBetweenCard * (toastBars.length - toastBars.indexOf(self) - 1);
    }
  }
  return 0;
}

/// rescale the old cards based on its position
double calculateScaleFactor(List<HTToastBar> toastBars, HTToastBar current) {
  int index = toastBars.indexOf(current);
  int indexValFromLast = toastBars.length - 1 - index;
  double factor = indexValFromLast / 25;
  double res = 0.97 - factor;
  return res < 0 ? 0 : res;
}
