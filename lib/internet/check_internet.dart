import "package:http/http.dart" as http;
import "package:space_anywhere/repositories/route/api_route.dart";

class Internet{
  static Future<bool> hasInternet() async {
    print("AQUI");
    try {
      final url = "$URL/health/";
      final response = await http.get(Uri.parse(url)).timeout(Duration(seconds: 5));
      print("BOA");
      print(response.body);
      return response.statusCode == 200;
    } catch(error) {
      print("RUIM");
      print(error.toString());
      return false;
    }
  }
}