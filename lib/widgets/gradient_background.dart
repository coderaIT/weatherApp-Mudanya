import 'package:flutter/material.dart';

/// Tüm ekranlarda kullanılan yumuşak gradyan arka plan.
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF3949AB),
            Color(0xFF5C6BC0),
            Color(0xFF7986CB),
          ],
        ),
      ),
      child: child,
    );
  }
}
