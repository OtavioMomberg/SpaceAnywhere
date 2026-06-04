import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:space_anywhere/services/cache_manager_service.dart';

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
        : CachedNetworkImage(
            imageUrl: imagePath,
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
            colorBlendMode: BlendMode.darken,
            cacheManager: CacheManagerService.instance,
            placeholder: (context, url) {
              return Container(
                color: Colors.white.withValues(alpha: 0.05),
                child: Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.white.withValues(alpha: 0.5),
                  )
                )
              );
            },
            errorWidget: (context, url, error) {
              return Container(
                color: Colors.white.withValues(alpha: 0.05),
                child: const Icon(Icons.broken_image, color: Colors.white38)
              );
            }
          )
    );
  }
}