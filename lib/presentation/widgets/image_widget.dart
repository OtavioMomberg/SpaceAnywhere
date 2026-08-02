import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:space_anywhere/presentation/themes/app_theme.dart';
import 'package:space_anywhere/core/utils/cache_manager_service.dart';
import 'package:space_anywhere/core/utils/image_option_service.dart';

class ImageWidget extends StatelessWidget {
  final String imagePath;
  final ImageOption option;

  const ImageWidget({
    required this.imagePath, 
    required this.option,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: AppTheme.borderRadius,
      child: option == ImageOption.asset 
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
                color: AppTheme.color1.withValues(alpha: 0.05),
                child: Center(
                  child: CircularProgressIndicator.adaptive(
                    backgroundColor: AppTheme.color1.withValues(alpha: 0.5),
                  )
                )
              );
            },
            errorWidget: (context, url, error) {
              return Container(
                color: AppTheme.color1.withValues(alpha: 0.05),
                child: const Icon(Icons.broken_image, color: Colors.white38)
              );
            }
          )
    );
  }
}