import 'package:flutter/material.dart';

class RoundedBox extends StatelessWidget {
  const RoundedBox({super.key, this.radius = 4, this.child});
  final double radius;
  final Widget? child;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: child,
    );
  }
}
