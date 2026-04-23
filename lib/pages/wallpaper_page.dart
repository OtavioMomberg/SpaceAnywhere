import 'package:flutter/material.dart';

class WallpaperPage extends StatelessWidget {
  const WallpaperPage({super.key});

  @override
  Widget build(BuildContext context) {
    //final size = MediaQuery.of(context).size;
    
    return Center(child: const Text("WALLPAPER", style: TextStyle(color: Color.fromARGB(255, 206, 206, 207))));
  }
}