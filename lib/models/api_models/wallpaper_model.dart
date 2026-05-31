import 'dart:convert';

class WallpaperModel {
  int id;
  String fullImageUrl;
  String thumbnailImageUrl;

  WallpaperModel({
    required this.id,
    required this.fullImageUrl,
    required this.thumbnailImageUrl
  });

  factory WallpaperModel.fromMap(Map<String, dynamic> map) {
    return WallpaperModel(
      id: map["id"], 
      fullImageUrl: map["full_image_url"], 
      thumbnailImageUrl: map["thumbnail_image_url"]
    );
  }

  static List<WallpaperModel> listFromJson(String source) {
    final List decoded = jsonDecode(source);
    return decoded.map((item) => WallpaperModel.fromMap(item)).toList();
  }
}