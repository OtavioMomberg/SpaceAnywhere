import 'package:flutter/material.dart';
import 'package:space_anywhere/pages/expanded_image_page.dart';
import 'package:space_anywhere/services/wallpaper_service.dart';
import 'package:space_anywhere/utils/image_cache_service.dart';
import 'package:space_anywhere/widgets/check_connection.dart';
import 'package:space_anywhere/widgets/image_widget.dart';

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
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        try {
          _wallpaperService.getFunction(func: callWallpaperService);
          _wallpaperService.initializeInternetInstance();
          _wallpaperService.internet.retryConnectionSystem();
        } on Exception catch (error) {
          _wallpaperService.generalError = error.toString();
          _wallpaperService.internet.updateInternetStatus(status: true);
          _wallpaperService.internet.updateAPIStatus(status: true);
          isLoading = false;
          setState(() {});
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
          style: TextStyle(color: Color.fromARGB(255, 206, 206, 207), fontWeight: FontWeight.bold, fontSize: 20)
        ),
        if (isLoading)...[
          CircularProgressIndicator.adaptive(
            backgroundColor: Color.fromARGB(255, 206, 206, 207),
          )
        ] else if (!_wallpaperService.internet.checkInternet || !_wallpaperService.internet.checkAPI)...[
          CheckConnection(
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
                      option: "network"
                    )
                  )
                );
              }
            )
          )
        ] else...[
          Text(
            _wallpaperService.error,
            style: const TextStyle(color: Color.fromARGB(255, 206, 206, 207)),
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
      PageRouteBuilder(
        pageBuilder: (_, _, _) => ExpandedImagePage(imagePath: imagePath, option: "network"),
        transitionsBuilder: (_, animation, _, child) {
          const begin = Offset(0.0, 1.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child
          );
        }
      )
    );
  }
}
