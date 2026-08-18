import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/onboarding/onboarding_provider.dart';
import '../../../../core/router/route_paths.dart';

class _OnboardingPage {
  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;
}

const _pages = [
  _OnboardingPage(
    icon: Icons.fitness_center,
    title: 'Tu compañero de fitness',
    description:
        'Arma tus rutinas, prográmalas en el calendario y sigue tu progreso semana a semana.',
  ),
  _OnboardingPage(
    icon: Icons.restaurant,
    title: 'Come mejor, sin complicarte',
    description:
        'Registra tus comidas, escanea tu plato con una foto y deja que la IA estime las calorías por ti.',
  ),
  _OnboardingPage(
    icon: Icons.water_drop,
    title: 'Todo en un solo lugar',
    description:
        'Agua, sueño, pasos diarios y objetivos — sin andar saltando entre varias apps.',
  ),
  _OnboardingPage(
    icon: Icons.flag,
    title: 'Empecemos',
    description: 'Crea tu cuenta y arma tu primer plan en un par de minutos.',
  ),
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _index = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await ref.read(onboardingSeenProvider.notifier).markSeen();
    if (mounted) context.go(RoutePaths.login);
  }

  void _next() {
    if (_index == _pages.length - 1) {
      _finish();
      return;
    }
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _index == _pages.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(AppSizes.sm),
                child: TextButton(
                  onPressed: isLast ? null : _finish,
                  child: Text(isLast ? '' : 'Saltar'),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _index = i),
                itemBuilder: (context, i) =>
                    _OnboardingPageView(page: _pages[i]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSizes.lg),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _pages.length,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: i == _index ? 22 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: i == _index
                          ? AppColors.seed
                          : Theme.of(context).colorScheme.outlineVariant,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSizes.lg,
                0,
                AppSizes.lg,
                AppSizes.lg,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(isLast ? 'Crear cuenta' : 'Siguiente'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageView extends StatelessWidget {
  const _OnboardingPageView({required this.page});

  final _OnboardingPage page;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.seed, AppColors.seedDeep],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 64, color: Colors.white),
          ),
          const SizedBox(height: AppSizes.xxl),
          Text(
            page.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: AppSizes.md),
          Text(
            page.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
