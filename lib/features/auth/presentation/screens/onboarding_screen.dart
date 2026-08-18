import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../core/onboarding/onboarding_answers_provider.dart';
import '../../../../core/onboarding/onboarding_provider.dart';
import '../../../../core/router/route_paths.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../diet_generator/domain/usecases/diet_calculator.dart';

const _totalQuestionSteps = 6; // goal, sex, age, weight, height, activity
const _stepWelcome = 0;
const _stepGoal = 1;
const _stepSex = 2;
const _stepAge = 3;
const _stepWeight = 4;
const _stepHeight = 5;
const _stepActivity = 6;
const _stepResult = 7;

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  int _step = _stepWelcome;

  DietGoal? _goal;
  Sex? _sex;
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();
  ActivityLevel? _activityLevel;

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  bool get _canProceed {
    switch (_step) {
      case _stepGoal:
        return _goal != null;
      case _stepSex:
        return _sex != null;
      case _stepAge:
        return int.tryParse(_ageController.text) != null;
      case _stepWeight:
        return double.tryParse(_weightController.text.replaceAll(',', '.')) !=
            null;
      case _stepHeight:
        return double.tryParse(_heightController.text.replaceAll(',', '.')) !=
            null;
      case _stepActivity:
        return _activityLevel != null;
      default:
        return true;
    }
  }

  void _back() {
    if (_step == _stepWelcome) return;
    setState(() => _step--);
  }

  void _next() {
    if (!_canProceed) return;
    if (_step == _stepActivity) {
      ref.read(onboardingAnswersProvider.notifier).update(
            (_) => OnboardingAnswers(
              goal: _goal,
              sex: _sex,
              age: int.tryParse(_ageController.text),
              weightKg:
                  double.tryParse(_weightController.text.replaceAll(',', '.')),
              heightCm:
                  double.tryParse(_heightController.text.replaceAll(',', '.')),
              activityLevel: _activityLevel,
            ),
          );
      setState(() => _step = _stepResult);
      return;
    }
    setState(() => _step++);
  }

  Future<void> _skipToLogin() async {
    await ref.read(onboardingSeenProvider.notifier).markSeen();
    if (mounted) context.go(RoutePaths.login);
  }

  Future<void> _goToRegister() async {
    await ref.read(onboardingSeenProvider.notifier).markSeen();
    if (mounted) context.go(RoutePaths.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _buildStep(context)));
  }

  Widget _buildStep(BuildContext context) {
    switch (_step) {
      case _stepWelcome:
        return _WelcomeStep(onStart: _next, onSkip: _skipToLogin);
      case _stepResult:
        return _ResultStep(
          macros: OnboardingAnswers(
            goal: _goal,
            sex: _sex,
            age: int.tryParse(_ageController.text),
            weightKg:
                double.tryParse(_weightController.text.replaceAll(',', '.')),
            heightCm:
                double.tryParse(_heightController.text.replaceAll(',', '.')),
            activityLevel: _activityLevel,
          ).macros,
          onCreateAccount: _goToRegister,
        );
      default:
        return _QuestionScaffold(
          step: _step,
          onBack: _back,
          onNext: _canProceed ? _next : null,
          child: _questionContent(),
        );
    }
  }

  Widget _questionContent() {
    switch (_step) {
      case _stepGoal:
        return _SingleChoiceQuestion<DietGoal>(
          title: '¿Cuál es tu objetivo?',
          options: DietGoal.values,
          labelOf: (g) => g.label,
          selected: _goal,
          onSelected: (g) => setState(() => _goal = g),
        );
      case _stepSex:
        return _SingleChoiceQuestion<Sex>(
          title: '¿Cuál es tu sexo?',
          options: Sex.values,
          labelOf: (s) => s == Sex.male ? 'Hombre' : 'Mujer',
          selected: _sex,
          onSelected: (s) => setState(() => _sex = s),
        );
      case _stepAge:
        return _NumberQuestion(
          title: '¿Cuál es tu edad?',
          suffix: 'años',
          controller: _ageController,
          onChanged: () => setState(() {}),
        );
      case _stepWeight:
        return _NumberQuestion(
          title: '¿Cuál es tu peso actual?',
          suffix: 'kg',
          controller: _weightController,
          allowDecimal: true,
          onChanged: () => setState(() {}),
        );
      case _stepHeight:
        return _NumberQuestion(
          title: '¿Cuál es tu estatura?',
          suffix: 'cm',
          controller: _heightController,
          allowDecimal: true,
          onChanged: () => setState(() {}),
        );
      case _stepActivity:
        return _SingleChoiceQuestion<ActivityLevel>(
          title: '¿Qué tan activo eres?',
          options: ActivityLevel.values,
          labelOf: (a) => a.label,
          selected: _activityLevel,
          onSelected: (a) => setState(() => _activityLevel = a),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}

class _WelcomeStep extends StatelessWidget {
  const _WelcomeStep({required this.onStart, required this.onSkip});

  final VoidCallback onStart;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
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
                  child: const Icon(
                    Icons.fitness_center,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: AppSizes.xxl),
                Text(
                  'Bienvenido a FitNutri',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: AppSizes.md),
                Text(
                  'Respondamos unas preguntas rápidas para armar tu plan de calorías y macros personalizado.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
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
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onStart,
                  child: const Text('Comenzar'),
                ),
              ),
              TextButton(
                onPressed: onSkip,
                child: const Text('Ya tengo cuenta'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _QuestionScaffold extends StatelessWidget {
  const _QuestionScaffold({
    required this.step,
    required this.onBack,
    required this.onNext,
    required this.child,
  });

  final int step;
  final VoidCallback onBack;
  final VoidCallback? onNext;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final progress = step / _totalQuestionSteps;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSizes.sm,
            AppSizes.sm,
            AppSizes.lg,
            AppSizes.sm,
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: AppSizes.sm),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Theme.of(
                      context,
                    ).colorScheme.surfaceContainerHighest,
                    valueColor: const AlwaysStoppedAnimation(AppColors.seed),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: child,
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
              onPressed: onNext,
              child: const Text('Siguiente'),
            ),
          ),
        ),
      ],
    );
  }
}

class _SingleChoiceQuestion<T> extends StatelessWidget {
  const _SingleChoiceQuestion({
    required this.title,
    required this.options,
    required this.labelOf,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  final String title;
  final List<T> options;
  final String Function(T) labelOf;
  final T? selected;
  final ValueChanged<T> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const SizedBox(height: AppSizes.md),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSizes.lg),
        ...options.map((option) {
          final isSelected = option == selected;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.sm),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppSizes.radiusMd),
              onTap: () => onSelected(option),
              child: AppCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        labelOf(option),
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Theme.of(context).colorScheme.primary
                              : null,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      )
                    else
                      const Icon(Icons.circle_outlined, color: Colors.grey),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _NumberQuestion extends StatelessWidget {
  const _NumberQuestion({
    required this.title,
    required this.suffix,
    required this.controller,
    required this.onChanged,
    this.allowDecimal = false,
  });

  final String title;
  final String suffix;
  final TextEditingController controller;
  final VoidCallback onChanged;
  final bool allowDecimal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppSizes.md),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: AppSizes.xxl),
        TextField(
          controller: controller,
          autofocus: true,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.numberWithOptions(decimal: allowDecimal),
          style: Theme.of(
            context,
          ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800),
          decoration: InputDecoration(suffixText: suffix),
          onChanged: (_) => onChanged(),
        ),
      ],
    );
  }
}

class _ResultStep extends StatelessWidget {
  const _ResultStep({required this.macros, required this.onCreateAccount});

  final MacroResult? macros;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    final result = macros;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.lg),
            child: ListView(
              children: [
                const SizedBox(height: AppSizes.lg),
                Text(
                  '¡Tu plan está listo! 🎉',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: AppSizes.sm),
                Text(
                  'Esta es tu meta diaria estimada — la puedes ajustar cuando quieras.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSizes.xl),
                if (result != null)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSizes.lg),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.seed, AppColors.seedDeep],
                      ),
                      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${result.dailyCalories.round()}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 44,
                          ),
                        ),
                        const Text(
                          'kcal / día',
                          style: TextStyle(color: Colors.white70),
                        ),
                        const SizedBox(height: AppSizes.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _MacroChip(
                              label: 'Proteína',
                              value: result.proteinG,
                            ),
                            _MacroChip(label: 'Carbos', value: result.carbsG),
                            _MacroChip(label: 'Grasa', value: result.fatG),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
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
              onPressed: onCreateAccount,
              child: const Text('Crear cuenta'),
            ),
          ),
        ),
      ],
    );
  }
}

class _MacroChip extends StatelessWidget {
  const _MacroChip({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '${value.round()}g',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 18,
          ),
        ),
        Text(label,
            style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
