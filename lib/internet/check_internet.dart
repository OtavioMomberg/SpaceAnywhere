import "package:http/http.dart" as http;
import "package:space_anywhere/repositories/route/api_route.dart";

class Internet{
  static Future<bool> hasInternet() async {
    try {
      final url = "$URL/health/";
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 5));

      return response.statusCode == 200;
    } catch(_) {
      return false;
    }
  }
}