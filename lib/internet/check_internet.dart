import "package:http/http.dart" as http;
import "package:space_anywhere/repositories/route/api_route.dart";

class Internet{
  static Future<bool> hasInternet() async {
    try {
      final url = "https://www.google.com";
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> isApiAwake() async {
    try {
      final url = "$URL/health/";
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 60));
      return response.statusCode == 200;
    } catch(error) {
      return false;
    }
  }
}