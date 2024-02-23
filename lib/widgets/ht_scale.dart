import 'package:flutter/material.dart';

class HTScale extends StatefulWidget {
  final Widget child;
  final Function()? onTap;
  const HTScale({
    super.key,
    required this.child,
    this.onTap,
  });

  @override
  State<HTScale> createState() => _HTScaleState();
}

class _HTScaleState extends State<HTScale> with TickerProviderStateMixin {
  double _scale = 1;
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.98,
      upperBound: 1,
      value: 1,
    );
    _animationController.addListener(() {
      setState(() {
        _scale = _animationController.value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (widget.onTap != null) {
            widget.onTap!();
          }
        },
        onTapDown: (details) {
          setState(() {
            _animationController.reverse();
          });
        },
        onTapCancel: () {
          setState(() {
            _animationController.forward(from: 0);
          });
        },
        onTapUp: (details) {
          setState(() {
            _animationController.forward(from: 0);
          });
        },
        child: Transform.scale(
          scale: _scale,
          child: widget.child,
        ));
  }
}
