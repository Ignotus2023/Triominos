import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/primary_button.dart';

class PlayersListPage extends ConsumerWidget {
  const PlayersListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.playersTitle)),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.x20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.playersEmptyTitle, style: context.textStyles.headlineSmall),
            AppSpacing.h8,
            Text(l10n.playersEmptyBody, style: context.textStyles.bodyMedium),
            AppSpacing.h24,
            PrimaryButton(
              label: l10n.playersAdd,
              icon: Icons.add_rounded,
              onPressed: () => context.pushNamed(AppRoute.playerForm),
            ),
          ],
        ),
      ),
    );
  }
}
