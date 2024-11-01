import 'package:flutter/material.dart';

class JungleBackground extends StatelessWidget {
  final Widget child;

  const JungleBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: Image.asset(
            'assets/jungle_bg.png',
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
