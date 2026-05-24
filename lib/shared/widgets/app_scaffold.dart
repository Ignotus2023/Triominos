import 'package:flutter/material.dart';

import '../../core/theme/app_spacing.dart';

/// Bazowy szkielet ekranu z gradientowym tłem indigo, nad którym pływają
/// powierzchnie [GlassContainer].
class AppScaffold extends StatelessWidget {
  const AppScaffold({
    required this.body,
    this.title,
    this.actions,
    this.floatingActionButton,
    this.bottomBar,
    this.automaticBack = true,
    this.padding = const EdgeInsets.all(AppSpacing.x16),
    super.key,
  });

  final Widget body;
  final String? title;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final Widget? bottomBar;
  final bool automaticBack;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: title == null
          ? null
          : AppBar(
              title: Text(title!),
              automaticallyImplyLeading: automaticBack,
              actions: actions,
            ),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomBar,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    scheme.surface,
                    Theme.of(context).scaffoldBackgroundColor,
                  ]
                : [
                    scheme.primary.withValues(alpha: 0.18),
                    Theme.of(context).scaffoldBackgroundColor,
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(padding: padding, child: body),
        ),
      ),
    );
  }
}
