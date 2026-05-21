import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';

class RulesPage extends ConsumerWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final sections = [
      l10n.rulesTocSetup,
      l10n.rulesTocTurn,
      l10n.rulesTocBonuses,
      l10n.rulesTocPenalties,
      l10n.rulesTocEndOfRound,
      l10n.rulesTocEndOfGame,
    ];
    return Scaffold(
      appBar: AppBar(title: Text(l10n.rulesTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.x20),
        children: [
          for (final section in sections) ...[
            Text(section, style: context.textStyles.headlineSmall),
            AppSpacing.h8,
            Text('TODO — content', style: context.textStyles.bodyMedium),
            AppSpacing.h24,
          ],
        ],
      ),
    );
  }
}
