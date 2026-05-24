import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/routing/app_routes.dart';
import '../../../core/settings/settings_provider.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../shared/extensions/build_context.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/primary_button.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<_Slide> _slides(BuildContext context) {
    final l10n = context.l10n;
    return [
      _Slide(Icons.waving_hand_outlined, l10n.onb1Title, l10n.onb1Body),
      _Slide(Icons.touch_app_outlined, l10n.onb2Title, l10n.onb2Body),
      _Slide(Icons.auto_awesome_outlined, l10n.onb3Title, l10n.onb3Body),
      _Slide(Icons.sports_esports_outlined, l10n.onb4Title, l10n.onb4Body),
    ];
  }

  Future<void> _finish() async {
    await ref.read(settingsRepositoryProvider).setOnboardingCompleted();
    if (mounted) context.goNamed(AppRoutes.home);
  }

  void _next(int count) {
    if (_page >= count - 1) {
      _finish();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final slides = _slides(context);
    final isLast = _page == slides.length - 1;

    return AppScaffold(
      body: Column(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: _finish,
              child: Text(l10n.onboardingSkip),
            ),
          ),
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: slides.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) => _SlideView(slide: slides[i]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (var i = 0; i < slides.length; i++)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: i == _page ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: i == _page
                        ? context.colors.primary
                        : context.colors.onSurface.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.x24),
          PrimaryButton(
            label: isLast ? l10n.onboardingStart : l10n.commonNext,
            onPressed: () => _next(slides.length),
          ),
          const SizedBox(height: AppSpacing.x16),
        ],
      ),
    );
  }
}

class _Slide {
  const _Slide(this.icon, this.title, this.body);
  final IconData icon;
  final String title;
  final String body;
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide});

  final _Slide slide;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.x24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(slide.icon, size: 96, color: context.colors.primary),
          const SizedBox(height: AppSpacing.x48),
          Text(
            slide.title,
            style: context.text.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.x16),
          Text(
            slide.body,
            style: context.text.bodyLarge?.copyWith(
              color: context.colors.onSurface.withValues(alpha: 0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
