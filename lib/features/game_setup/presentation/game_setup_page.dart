import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/game/end_game_evaluator.dart';
import '../../../core/haptics/haptics_service.dart';
import '../../../core/routing/app_routes.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../shared/widgets/secondary_button.dart';
import 'game_setup_controller.dart';
import 'start_game_use_case.dart';
import 'widgets/end_mode_step.dart';
import 'widgets/players_step.dart';
import 'widgets/review_step.dart';
import 'widgets/variant_step.dart';

class GameSetupPage extends ConsumerStatefulWidget {
  const GameSetupPage({super.key});

  @override
  ConsumerState<GameSetupPage> createState() => _GameSetupPageState();
}

class _GameSetupPageState extends ConsumerState<GameSetupPage> {
  int _step = 0;
  bool _starting = false;

  static const _stepCount = 4;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(gameSetupControllerProvider.notifier).reset());
  }

  bool get _canAdvance {
    final state = ref.read(gameSetupControllerProvider);
    if (_step == 0) return state.canStart;
    return true;
  }

  Future<void> _next() async {
    if (_step < _stepCount - 1) {
      setState(() => _step++);
      return;
    }
    await _start();
  }

  void _back() {
    if (_step == 0) {
      context.pop();
    } else {
      setState(() => _step--);
    }
  }

  Future<void> _start() async {
    setState(() => _starting = true);
    final setup = ref.read(gameSetupControllerProvider);
    final useCase = ref.read(startGameUseCaseProvider);
    await ref.read(hapticsServiceProvider).trigger(HapticPattern.medium);
    final gameId = await useCase(setup);
    if (mounted) {
      context.pushReplacementNamed(
        AppRoute.game,
        pathParameters: {'gameId': gameId},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final state = ref.watch(gameSetupControllerProvider);
    final stepTitles = [
      l10n.gameSetupStepPlayers,
      l10n.gameSetupStepVariant,
      l10n.gameSetupStepEndMode,
      l10n.gameSetupStepReview,
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.gameSetupTitle),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: _back,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _StepProgress(current: _step, total: _stepCount, titles: stepTitles),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                child: KeyedSubtree(
                  key: ValueKey(_step),
                  child: switch (_step) {
                    0 => const PlayersStep(),
                    1 => const VariantStep(),
                    2 => const EndModeStep(),
                    _ => const ReviewStep(),
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x20,
                AppSpacing.x8,
                AppSpacing.x20,
                AppSpacing.x20,
              ),
              child: Row(
                children: [
                  if (_step > 0) ...[
                    Expanded(
                      child: SecondaryButton(
                        label: l10n.commonBack,
                        onPressed: _back,
                      ),
                    ),
                    AppSpacing.w12,
                  ],
                  Expanded(
                    flex: 2,
                    child: PrimaryButton(
                      label: _step == _stepCount - 1
                          ? l10n.gameSetupStart
                          : l10n.commonNext,
                      loading: _starting,
                      onPressed: _canAdvance && !_starting ? _next : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StepProgress extends StatelessWidget {
  const _StepProgress({
    required this.current,
    required this.total,
    required this.titles,
  });

  final int current;
  final int total;
  final List<String> titles;

  @override
  Widget build(BuildContext context) {
    final scheme = context.colors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.x20,
        AppSpacing.x16,
        AppSpacing.x20,
        AppSpacing.x8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(total, (i) {
              final active = i <= current;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: i == total - 1 ? 0 : AppSpacing.x4),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 6,
                    decoration: BoxDecoration(
                      color: active ? scheme.primary : scheme.outlineVariant,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  ),
                ),
              );
            }),
          ),
          AppSpacing.h12,
          Text(
            '${current + 1}/$total · ${titles[current]}',
            style: context.textStyles.titleMedium,
          ),
        ],
      ),
    );
  }
}
