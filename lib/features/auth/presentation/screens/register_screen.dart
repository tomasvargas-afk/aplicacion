import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final error = await ref.read(authControllerProvider.notifier).signUp(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _nameController.text.trim(),
        );
    if (!mounted) return;
    if (error != null) {
      context.showSnackBar(error, isError: true);
    } else {
      context.showSnackBar('Cuenta creada. ¡Bienvenido!');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AppTextField(
                      controller: _nameController,
                      label: 'Nombre completo',
                      prefixIcon: Icons.person_outline,
                      validator: Validators.required,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSizes.md),
                    AppTextField(
                      controller: _emailController,
                      label: 'Correo electrónico',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: Icons.email_outlined,
                      validator: Validators.email,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSizes.md),
                    AppTextField(
                      controller: _passwordController,
                      label: 'Contraseña',
                      obscureText: true,
                      prefixIcon: Icons.lock_outline,
                      validator: Validators.password,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: AppSizes.md),
                    AppTextField(
                      controller: _confirmController,
                      label: 'Confirmar contraseña',
                      obscureText: true,
                      prefixIcon: Icons.lock_outline,
                      validator: Validators.matches(() => _passwordController.text),
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: AppSizes.lg),
                    PrimaryButton(
                      label: 'Crear cuenta',
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
