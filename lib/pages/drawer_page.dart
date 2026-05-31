import 'package:flutter/material.dart';
import 'package:space_anywhere/page_routes/app_routes.dart';
import 'package:space_anywhere/themes/app_theme.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final List<IconData> drawerIcons = [
    Icons.home,
    Icons.quiz,
    Icons.analytics,
    Icons.wallpaper,
    Icons.info
  ];
  int selectedPage = 0;
  
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
                  selectedTileColor: Colors.white.withValues(alpha: 0.15),
                  leading: Icon(
                    drawerIcons[index],
                    color: selectedPage == index 
                      ? const Color.fromARGB(255, 250, 221, 134).withValues(alpha: 0.8) 
                      : const Color.fromARGB(255, 206, 206, 207)
                  ),
                  title: Text(
                    AppRoutes.pageNames[index], 
                    style: TextStyle(
                      color: selectedPage == index 
                        ? const Color.fromARGB(255, 250, 221, 134).withValues(alpha: 0.8)  
                        : Color.fromARGB(255, 206, 206, 207)
                    )
                  ),
                  shape: StadiumBorder(),
                  onTap: () {
                    setState(() => selectedPage = index);
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
        child: Container(
          width: double.infinity,
          padding: selectedPage == 2 
            ? const EdgeInsets.only(bottom: 15)
            : const EdgeInsets.only(left: 15, right: 15, bottom: 10),
          decoration: BoxDecoration(gradient: AppTheme.mainGradient),
          child: AppRoutes.pages[selectedPage]
        )
      )
    );
  }
}