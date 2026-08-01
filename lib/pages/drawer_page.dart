import 'package:flutter/material.dart';
import 'package:space_anywhere/routes/app_routes.dart';
import 'package:space_anywhere/themes/app_theme.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final List<IconData> _drawerIcons = const [
    Icons.home,
    Icons.quiz,
    Icons.analytics,
    Icons.wallpaper,
    Icons.calculate
  ];
  int selectedPage = 0;
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppTheme.color2,
        foregroundColor: AppTheme.color1
      ),
      drawer: Drawer(
        backgroundColor: AppTheme.color2,
        child: ListView(
          padding: EdgeInsets.only(left: 10, right: 10),
          children: <Widget>[
            SizedBox(
              height: size.height * 0.15,
              child: const DrawerHeader(
                child: Column(
                  mainAxisAlignment: .center,
                  crossAxisAlignment: .start,
                  children: <Widget>[
                    Text(
                      "Menu", 
                      style: TextStyle(
                        color: AppTheme.color1, 
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
                  selectedTileColor: AppTheme.color1.withValues(alpha: 0.15),
                  leading: Icon(
                    _drawerIcons[index],
                    color: selectedPage == index 
                      ? AppTheme.color5.withValues(alpha: 0.8) 
                      : AppTheme.color1
                  ),
                  title: Text(
                    AppRoutes.pageNames[index], 
                    style: TextStyle(
                      color: selectedPage == index 
                        ? AppTheme.color5.withValues(alpha: 0.8)  
                        : AppTheme.color1
                    )
                  ),
                  shape: RoundedRectangleBorder(borderRadius: AppTheme.borderRadius),
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
          height: double.infinity,
          width: double.infinity,
          padding: selectedPage == 2 
            ? const EdgeInsets.only(bottom: 15)
            : const EdgeInsets.only(left: 15, right: 15, bottom: 15),
          decoration: BoxDecoration(gradient: AppTheme.mainGradient),
          child: AppRoutes.pages[selectedPage]
        )
      ),
      backgroundColor: AppTheme.color4,
      resizeToAvoidBottomInset: false
    );
  }
}