import 'package:flutter/material.dart';
import 'neuromorphic_theme.dart';

class AdminScaffold extends StatelessWidget {
  final Widget body;
  final String title;
  final Widget? floatingActionButton;
  final List<Widget>? actions;
  final Widget? drawer;

  const AdminScaffold({
    super.key,
    required this.body,
    required this.title,
    this.floatingActionButton,
    this.actions,
    this.drawer,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final isMobile = constraints.maxWidth < 600;

      return Scaffold(
        backgroundColor: NeuromorphicTheme.background,
        appBar: AppBar(
          title: Text(title, style: TextStyle(fontSize: isMobile ? 18 : 22)),
          actions: actions,
          elevation: 0,
          backgroundColor: NeuromorphicTheme.background,
        ),
        drawer: drawer,
        body: body,
        floatingActionButton: floatingActionButton,
      );
    });
  }
}
