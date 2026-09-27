import 'package:flutter/material.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget tabletBody;

  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.tabletBody,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Breakpoint standard : 650 pixels pour basculer sur une ergonomie tablette
        if (constraints.maxWidth < 650) {
          return mobileBody;
        } else {
          return tabletBody;
        }
      },
    );
  }
}
