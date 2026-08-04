import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../providers/auth_provider.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    final error =
        await ref.read(authControllerProvider.notifier).resetPassword(
              _emailController.text.trim(),
            );
    if (!mounted) return;
    if (error != null) {
      context.showSnackBar(error, isError: true);
    } else {
      setState(() => _sent = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider).isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Recuperar contraseña')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.lg),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: _sent
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.mark_email_read_outlined,
                            size: 48, color: context.colors.primary),
                        const SizedBox(height: AppSizes.md),
                        const Text(
                          'Te enviamos un enlace para restablecer tu contraseña. Revisa tu correo.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Ingresa tu correo y te enviaremos instrucciones para restablecer tu contraseña.',
                          ),
                          const SizedBox(height: AppSizes.lg),
                          AppTextField(
                            controller: _emailController,
                            label: 'Correo electrónico',
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: Icons.email_outlined,
                            validator: Validators.email,
                          ),
                          const SizedBox(height: AppSizes.lg),
                          PrimaryButton(
                            label: 'Enviar enlace',
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
