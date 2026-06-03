import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:space_anywhere/controllers/wallpaper_controller.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/pages/expanded_image_page.dart';
import 'package:space_anywhere/repositories/implementations/wallpaper_implementation_http.dart';
import 'package:space_anywhere/services/image_cache_service.dart';
import 'package:space_anywhere/widgets/image_widget.dart';
import 'package:space_anywhere/widgets/info_error_home.dart';

class WallpaperPage extends StatefulWidget {
  const WallpaperPage({super.key});

  @override
  State<WallpaperPage> createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  late final WallpaperController wallpaperController;
  bool isLoading = true;
  bool checkInternet = false;
  bool checkAPI = false;
  int offset = 0;

  @override
  void initState() {
    super.initState();

    wallpaperController = WallpaperController(
      WallpaperImplementationHttp(Client())
    );

    if (ImageCacheService.wallpapers != null) {
      isLoading = false;
      checkInternet = true;
      checkAPI = true;
    } else {
      getImages();
    }
  }

  Future<void> verifyInternet() async {
    checkInternet = await Internet.hasInternet();
  }

  Future<void> getImages() async {
    await verifyInternet();

    if (!checkInternet) return;

    checkAPI = await Internet.isApiAwake();

    if (!checkAPI) return;

    await wallpaperController.onGetWallpaper(offset: offset);

    if (wallpaperController.getErrorWallpaper == null) {
      ImageCacheService.wallpapers = wallpaperController.getWallpaperModel;
    }

    setState(() => isLoading = false);
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
        ] else if (!checkInternet)...[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InfoErrorHome(message: "Erro. Sem conexão com a internet", icon: Icons.wifi_off, height: size.height * 0.6),
          )
        ] else if (!checkAPI)...[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: InfoErrorHome(message: "Erro. Não foi possível se conectar ao servidor", icon: Icons.dns, height: size.height * 0.6),
          )
        ] else if (ImageCacheService.wallpapers != null)...[
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7), 
              itemCount: ImageCacheService.wallpapers!.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    seeImageExpanded(imagePath: ImageCacheService.wallpapers![index]!.fullImageUrl, context: context);
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
        ]
      ]
    );
  }
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
