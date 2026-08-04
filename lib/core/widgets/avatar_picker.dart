import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Circular avatar with a camera badge; picks an image from the gallery
/// and hands the [File] back to the caller (profile/recipe photo upload).
class AvatarPicker extends StatelessWidget {
  const AvatarPicker({
    super.key,
    required this.onImageSelected,
    this.currentImageUrl,
    this.radius = 48,
  });

  final ValueChanged<File> onImageSelected;
  final String? currentImageUrl;
  final double radius;

  Future<void> _pick() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (picked != null) onImageSelected(File(picked.path));
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: _pick,
      child: Stack(
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: scheme.surfaceContainerHighest,
            backgroundImage:
                currentImageUrl != null ? NetworkImage(currentImageUrl!) : null,
            child: currentImageUrl == null
                ? Icon(Icons.person, size: radius, color: scheme.outline)
                : null,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: scheme.primary,
                shape: BoxShape.circle,
                border: Border.all(color: scheme.surface, width: 2),
              ),
              child: Icon(Icons.camera_alt, size: 16, color: scheme.onPrimary),
            ),
          ),
        ],
      ),
    );
  }
}
