import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/barcode_food_result.dart';
import '../providers/nutrition_provider.dart';

/// Scans a product barcode (camera) or accepts one typed manually, looks it
/// up on Open Food Facts, and pops with a [BarcodeFoodResult] the caller
/// uses to prefill a meal-log or recipe form.
class BarcodeScannerScreen extends ConsumerStatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  ConsumerState<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends ConsumerState<BarcodeScannerScreen> {
  final _controller = MobileScannerController(detectionSpeed: DetectionSpeed.noDuplicates);
  final _manualController = TextEditingController();
  bool _isLookingUp = false;

  @override
  void dispose() {
    _controller.dispose();
    _manualController.dispose();
    super.dispose();
  }

  Future<void> _lookup(String barcode) async {
    if (_isLookingUp || barcode.trim().isEmpty) return;
    setState(() => _isLookingUp = true);
    await _controller.stop();

    try {
      final result = await ref.read(openFoodFactsDatasourceProvider).lookup(barcode.trim());
      if (!mounted) return;
      Navigator.of(context).pop(result);
    } on NotFoundException {
      if (!mounted) return;
      context.showSnackBar('No encontramos ese código de barras', isError: true);
      setState(() => _isLookingUp = false);
      await _controller.start();
    } catch (_) {
      if (!mounted) return;
      context.showSnackBar('No se pudo consultar el producto. Revisa tu conexión', isError: true);
      setState(() => _isLookingUp = false);
      await _controller.start();
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (capture.barcodes.isEmpty) return;
    final code = capture.barcodes.first.rawValue;
    if (code != null) _lookup(code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear código de barras'),
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            tooltip: 'Linterna',
            onPressed: () => _controller.toggleTorch(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                  errorBuilder: (context, error) => Container(
                    color: Colors.black,
                    padding: const EdgeInsets.all(AppSizes.lg),
                    child: Center(
                      child: Text(
                        'No se pudo abrir la cámara.\nUsa la entrada manual abajo.',
                        textAlign: TextAlign.center,
                        style: context.textTheme.bodyMedium?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                ),
                if (_isLookingUp)
                  const ColoredBox(
                    color: Colors.black54,
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.all(AppSizes.md),
              child: Column(
                children: [
                  Text(
                    '¿No funciona la cámara? Ingresa el código manualmente',
                    style: context.textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSizes.sm),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          controller: _manualController,
                          label: 'Código de barras',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: AppSizes.sm),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Buscar',
                          isLoading: _isLookingUp,
                          onPressed: () => _lookup(_manualController.text),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
