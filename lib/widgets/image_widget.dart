import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imagePath;
  final String option;

  const ImageWidget({
    required this.imagePath, 
    required this.option,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: option == "asset" 
        ? Image.asset(
            imagePath,
            filterQuality: FilterQuality.high,
            fit: BoxFit.contain,
            colorBlendMode: BlendMode.darken,
          )
        : Image.network(
            imagePath,
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                color: Colors.white.withValues(alpha: 0.05),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white.withValues(alpha: 0.5),
                    value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null
                  )
                )
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.white.withValues(alpha: 0.05),
                child: const Icon(Icons.broken_image, color: Colors.white38),
              );
            }
          )
    );
  }
}