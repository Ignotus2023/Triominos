import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/extensions/build_context.dart';

class GameSetupPage extends ConsumerWidget {
  const GameSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.gameSetupTitle)),
      body: const Center(child: Text('TODO — game setup stepper')),
    );
  }
}
