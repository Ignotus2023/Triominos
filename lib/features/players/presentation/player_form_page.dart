import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/extensions/build_context.dart';

class PlayerFormPage extends ConsumerWidget {
  const PlayerFormPage({this.playerId, super.key});

  final String? playerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          playerId == null ? l10n.playersFormTitleNew : l10n.playersFormTitleEdit,
        ),
      ),
      body: const Center(child: Text('TODO')),
    );
  }
}
