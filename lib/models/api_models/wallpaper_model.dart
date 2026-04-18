import 'dart:convert';

class WallpaperModel {
  int id;
  String fullImageUrl;
  String thumbnailImageUrl;

  WallpaperModel({
    required this.id,
    required this.fullImageUrl,
    required this.thumbnailImageUrl,
  });

  factory WallpaperModel.fromMap(Map<String, dynamic> map) {
    return WallpaperModel(
      id: map["id"], 
      fullImageUrl: map["fullImageUrl"], 
      thumbnailImageUrl: map["thumbnailImageUrl"],
    );
  }

  factory WallpaperModel.fromJson(String source) => WallpaperModel.fromMap(jsonDecode(source));
}