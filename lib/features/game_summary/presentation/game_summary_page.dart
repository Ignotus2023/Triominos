import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/extensions/build_context.dart';

class GameSummaryPage extends ConsumerWidget {
  const GameSummaryPage({required this.gameId, super.key});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.summaryTitle)),
      body: Center(child: Text('TODO — summary for $gameId')),
    );
  }
}
