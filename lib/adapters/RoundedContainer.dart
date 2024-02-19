import 'package:flutter/material.dart';

class RoundedContainer extends StatelessWidget {
  const RoundedContainer({
    Key? key,
    required this.child,
    required this.height,
    required this.width,
    this.color = Colors.white,
    this.padding = const EdgeInsets.all(16.0),
    required this.margin,
    required this.borderRadius,
  }) : super(key: key);
  final Widget child;
  final double width;
  final double height;
  final Color color;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? BorderRadius.circular(20.0),
        border: Border.all(
          color: Colors.transparent,
          width: 0.5,
        ),
      ),
      child: child,
    );
  }
}