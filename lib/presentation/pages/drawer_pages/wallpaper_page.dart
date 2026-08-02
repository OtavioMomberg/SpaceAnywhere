import 'package:flutter/material.dart';
import 'package:space_anywhere/presentation/pages/additional_pages/expanded_image_page.dart';
import 'package:space_anywhere/core/routes/app_routes.dart';
import 'package:space_anywhere/services/wallpaper_service.dart';
import 'package:space_anywhere/presentation/themes/app_theme.dart';
import 'package:space_anywhere/core/utils/image_cache_service.dart';
import 'package:space_anywhere/core/utils/image_option_service.dart';
import 'package:space_anywhere/presentation/widgets/check_connection.dart';
import 'package:space_anywhere/presentation/widgets/image_widget.dart';

class WallpaperPage extends StatefulWidget {
  const WallpaperPage({super.key});

  @override
  State<WallpaperPage> createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  final WallpaperService _wallpaperService = WallpaperService.instance();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    if (!_wallpaperService.checkImageCache()) {
      isLoading = false;
      setState(() {});
    } else {
      _wallpaperService.getFunction(func: callWallpaperService);
      _wallpaperService.initializeInternetInstance();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          _wallpaperService.internet.retryConnectionSystem();
        } on Exception catch (error) {
          _wallpaperService.generalError = error.toString();
          _wallpaperService.internet.updateInternetStatus(status: true);
          _wallpaperService.internet.updateAPIStatus(status: true);
          setState(() => isLoading = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      spacing: 20,
      children: <Widget>[
        const Text(
          "Catálogo de Wallpapers",
          style: TextStyle(
            color: AppTheme.color1, 
            fontWeight: FontWeight.bold, 
            fontSize: 20
          )
        ),
        if (isLoading || !_wallpaperService.internet.checkInternet || !_wallpaperService.internet.checkAPI)...[
          CheckConnection(
            isLoading: isLoading,
            checkInternet: _wallpaperService.internet.checkInternet, 
            checkAPI: _wallpaperService.internet.checkAPI, 
            height: size.height * 0.6
          )
        ] else if (ImageCacheService.wallpapers != null)...[
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7), 
              itemCount: ImageCacheService.wallpapers!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    seeImageExpanded(
                      imagePath: ImageCacheService.wallpapers![index]!.fullImageUrl, 
                      context: context
                    );
                  },
                  child: Container(
                    padding: index % 2 == 0 
                      ? const EdgeInsets.only(right: 5, bottom: 10)
                      : const EdgeInsets.only(left: 5, bottom: 10),
                    child: ImageWidget(
                      imagePath: ImageCacheService.wallpapers![index]!.fullImageUrl,
                      option: ImageOption.network
                    )
                  )
                );
              }
            )
          )
        ] else...[
          Text(
            _wallpaperService.error,
            style: const TextStyle(color: AppTheme.color1),
            textAlign: TextAlign.center
          )
        ]
      ]
    );
  }

  Future<void> callWallpaperService() async {
    await _wallpaperService.getImages();

    await Future.delayed(Duration(seconds: 1));
    if (!mounted) { return; } 
    setState(() => isLoading = false);
  }

  void seeImageExpanded({required String imagePath, required BuildContext context}) {
    Navigator.push(
      context,
      AppRoutes.getRoute(
        page: ExpandedImagePage(
          imagePath: imagePath, 
          option: ImageOption.network
        ), 
        begin: Offset(0.0, 1.0)
      )
    );
  }
}
