import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:space_anywhere/controllers/wallpaper_controller.dart';
import 'package:space_anywhere/internet/check_internet.dart';
import 'package:space_anywhere/pages/expanded_image_page.dart';
import 'package:space_anywhere/repositories/implementations/wallpaper_implementation_http.dart';
import 'package:space_anywhere/widgets/image_widget.dart';
import 'package:space_anywhere/widgets/info_error_home.dart';
import 'package:space_anywhere/widgets/stylized_container.dart';

class WallpaperPage extends StatefulWidget {
  const WallpaperPage({super.key});

  @override
  State<WallpaperPage> createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  late final WallpaperController wallpaperController;
  bool checkInternet = false;
  bool checkAPI = false;
  int offset = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    wallpaperController = WallpaperController(
      WallpaperImplementationHttp(Client())
    );

    getImages();
  }

  Future<void> verifyInternet() async {
    checkInternet = await Internet.hasInternet();
  }

  Future<void> getImages() async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await verifyInternet();

      if (!checkInternet) return;

      checkAPI = await Internet.hasInternet();

      if (!checkAPI) return;

      await wallpaperController.onGetWallpaper(offset: offset);

      setState(() => isLoading = false);
    });
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
          StylizedContainer(
            height: size.height * 0.6,
            child: CircularProgressIndicator(
              color: Colors.white.withValues(alpha: 0.5),
            )
          )
        ] else if (!checkInternet)...[
          InfoErrorHome(message: "Erro. Sem conexão com a internet", icon: Icons.wifi_off, height: size.height * 0.6)
        ] else if (!checkAPI)...[
          InfoErrorHome(message: "Erro. Não foi possível se conectar ao servidor", icon: Icons.dns, height: size.height * 0.6)
        ] else if (wallpaperController.getErrorWallpaper == null)...[
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.7), 
              itemCount: 7,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    seeImageExpanded(imagePath: wallpaperController.getWallpaperModel[index]!.fullImageUrl, context: context);
                  },
                  child: Container(
                    padding: index % 2 == 0 
                      ? const EdgeInsets.only(right: 5, bottom: 10)
                      : const EdgeInsets.only(left: 5, bottom: 10),
                    child: ImageWidget(
                      imagePath: wallpaperController.getWallpaperModel[index]!.fullImageUrl,
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

          final tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        }
      )
    );
  }
