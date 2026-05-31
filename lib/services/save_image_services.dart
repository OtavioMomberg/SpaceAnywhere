import 'dart:io';
import 'package:flutter/services.dart';
import 'package:gallery_saver_plus/gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class SaveImageServices {

  static Future<bool> saveImageFromAsset(String imagePath) async {
    final ByteData byteData = await rootBundle.load(imagePath);
    final Uint8List imageBytes = byteData.buffer.asUint8List();

    return _saveToGallery(imageBytes);
  }

  static Future<bool> saveImageFromUrl(String imageUrl) async {
    final http.Response response = await http.get(Uri.parse(imageUrl));
    final Uint8List imageBytes = response.bodyBytes;

    return _saveToGallery(imageBytes);
  }

  static Future<bool> _saveToGallery(Uint8List imageBytes) async {
    final Directory tempDir = await getTemporaryDirectory();
    final String tempPath = "${tempDir.path}/image_temp_${DateTime.now().millisecondsSinceEpoch}.png";
    final File tempFile = File(tempPath);

    await tempFile.writeAsBytes(imageBytes);

    final bool? response = await GallerySaver.saveImage(
      tempFile.path,
      albumName: "SpaceAnywhere",
    );

    await tempFile.delete();

    return response ?? false;
  }
}

