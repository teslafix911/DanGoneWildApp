import 'package:flutter/material.dart';

class PineForestBackground extends StatelessWidget {
  final Widget child;

  const PineForestBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/pine_forest_background.png',
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.6),
        ),
        child,
      ],
    );
  }
}
