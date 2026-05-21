import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/extensions/build_context.dart';

class GamePage extends ConsumerWidget {
  const GamePage({required this.gameId, super.key});

  final String gameId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.gameRoundLabel(1))),
      body: Center(child: Text('TODO — game screen for $gameId')),
    );
  }
}
