import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../domain/entities/ai_food_estimate.dart';
import '../providers/nutrition_provider.dart';

/// Lets the user take/pick a food photo, sends it to the `analyze-food`
/// Edge Function, and pops with an [AiFoodEstimate] the caller uses to
/// prefill a meal log. The user always sees the estimate before it's saved
/// anywhere — this screen never writes to the database itself.
class AiFoodScanScreen extends ConsumerStatefulWidget {
  const AiFoodScanScreen({super.key});

  @override
  ConsumerState<AiFoodScanScreen> createState() => _AiFoodScanScreenState();
}

class _AiFoodScanScreenState extends ConsumerState<AiFoodScanScreen> {
  Uint8List? _imageBytes;
  String? _mediaType;
  bool _isAnalyzing = false;

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, imageQuality: 85);
    if (picked == null) return;
    final bytes = await picked.readAsBytes();
    setState(() {
      _imageBytes = bytes;
      _mediaType = picked.mimeType ?? 'image/jpeg';
    });
  }

  Future<void> _analyze() async {
    final bytes = _imageBytes;
    final mediaType = _mediaType;
    if (bytes == null || mediaType == null) return;

    setState(() => _isAnalyzing = true);
    try {
      final AiFoodEstimate result =
          await ref.read(aiFoodDatasourceProvider).analyze(bytes, mediaType: mediaType);
      if (!mounted) return;
      Navigator.of(context).pop(result);
    } on ServerException catch (e) {
      if (!mounted) return;
      context.showSnackBar(e.message, isError: true);
    } catch (_) {
      if (!mounted) return;
      context.showSnackBar('No se pudo analizar la foto. Revisa tu conexión', isError: true);
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Foto de comida (IA)')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.lg),
          child: Column(
            children: [
              Expanded(
                child: _imageBytes == null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.restaurant_menu,
                              size: 64,
                              color: context.colors.onSurfaceVariant,
                            ),
                            const SizedBox(height: AppSizes.md),
                            Text(
                              'Toma o elige una foto de tu comida\ny estimamos sus calorías y macros',
                              textAlign: TextAlign.center,
                              style: context.textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
                        child: Image.memory(_imageBytes!, fit: BoxFit.cover, width: double.infinity),
                      ),
              ),
              const SizedBox(height: AppSizes.lg),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isAnalyzing ? null : () => _pickImage(ImageSource.camera),
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Cámara'),
                    ),
                  ),
                  const SizedBox(width: AppSizes.sm),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _isAnalyzing ? null : () => _pickImage(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library_outlined),
                      label: const Text('Galería'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.md),
              PrimaryButton(
                label: 'Analizar foto',
                isLoading: _isAnalyzing,
                onPressed: _imageBytes == null ? null : _analyze,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
