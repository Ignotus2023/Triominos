import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/settings/settings_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/primary_button.dart';

class _OnboardingSlide {
  const _OnboardingSlide({required this.title, required this.body, required this.icon});
  final String title;
  final String body;
  final IconData icon;
}

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  int _index = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _finish() {
    ref
        .read(settingsControllerProvider.notifier)
        .update((s) => s.copyWith(onboardingCompleted: true));
    if (mounted) {
      context.goNamed(AppRoute.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slides = [
      _OnboardingSlide(
        title: l10n.onboardingWelcomeTitle,
        body: l10n.onboardingWelcomeBody,
        icon: Icons.casino_outlined,
      ),
      _OnboardingSlide(
        title: l10n.onboardingSmartInputTitle,
        body: l10n.onboardingSmartInputBody,
        icon: Icons.touch_app_outlined,
      ),
      _OnboardingSlide(
        title: l10n.onboardingBonusesTitle,
        body: l10n.onboardingBonusesBody,
        icon: Icons.auto_awesome_outlined,
      ),
      _OnboardingSlide(
        title: l10n.onboardingReadyTitle,
        body: l10n.onboardingReadyBody,
        icon: Icons.rocket_launch_outlined,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: slides.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (_, i) {
                  final s = slides[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.x24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(s.icon, size: 72, color: context.colors.primary),
                        AppSpacing.h24,
                        Text(s.title, style: context.textStyles.displaySmall),
                        AppSpacing.h16,
                        Text(s.body, style: context.textStyles.bodyLarge),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.x24,
                vertical: AppSpacing.x16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(slides.length, (i) {
                  final active = i == _index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: AppSpacing.x4),
                    width: active ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: active ? context.colors.primary : context.colors.outlineVariant,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    ),
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.x24,
                AppSpacing.x8,
                AppSpacing.x24,
                AppSpacing.x32,
              ),
              child: PrimaryButton(
                label: _index == slides.length - 1 ? l10n.onboardingStart : l10n.commonNext,
                onPressed: () {
                  if (_index == slides.length - 1) {
                    _finish();
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
