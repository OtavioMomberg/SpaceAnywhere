import 'package:flutter/material.dart';
import 'package:space_anywhere/page_routes/app_routes.dart';
import 'package:space_anywhere/themes/app_theme.dart';
import 'package:space_anywhere/themes/stars_draw/stars_positions.dart';
import 'package:space_anywhere/widgets/star_painter_widget.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  late final StarsPositions _starsPositions;
  final List<Offset> stars = [];
  int selectedPage = 0;

  @override
    void initState() {
      super.initState();

      for (int i = 0; i < StarsPositions.starQuantity; i++) {
        stars.add(
          Offset(
            StarsPositions.random.nextDouble(),
            StarsPositions.random.nextDouble(),
          ),
        );
      }
      _starsPositions = StarsPositions(stars: stars);
    }
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: const Color.fromARGB(255, 38, 46, 139),
        foregroundColor: const Color.fromARGB(255, 206, 206, 207),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 38, 46, 139),
        child: ListView(
          padding: EdgeInsets.only(left: 10, right: 10),
          children: <Widget>[
            SizedBox(
              height: size.height * 0.15,
              child: const DrawerHeader(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Menu", 
                      style: TextStyle(
                        color: Color.fromARGB(255, 206, 206, 207), 
                        fontSize: 18
                      )
                    )
                  ]
                )
              )
            ),
            const SizedBox(height: 10),
            ...List.generate(AppRoutes.pages.length, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  selected: selectedPage == index,
                  selectedTileColor: Colors.white.withValues(alpha: 0.1),
                  title: Text(AppRoutes.pageNames[index], style: const TextStyle(color: Color.fromARGB(255, 206, 206, 207))),
                  splashColor: const Color.fromARGB(255, 206, 206, 207).withValues(alpha: 0.8),
                  shape: StadiumBorder(),
                  onTap: () {
                    setState(() {
                      selectedPage = index;
                    });
                    Navigator.pop(context);
                  }
                )
              );
            })
          ]
        )
      ),
      body: SafeArea(
        top: false,
        child: StarPainterWidget(
          stars: _starsPositions.getStarPositions(size),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(gradient: AppTheme.mainGradient),
            child: AppRoutes.pages[selectedPage]
          )
        ),
      )
    );
  }
}