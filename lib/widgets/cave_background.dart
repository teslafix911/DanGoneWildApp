import 'package:flutter/material.dart';

class CaveBackground extends StatelessWidget {
  final Widget child;

  const CaveBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/cave_background.png',
            fit: BoxFit.cover,
          ),
        ),
        child,
      ],
    );
  }
}
