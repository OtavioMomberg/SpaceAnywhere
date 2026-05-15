import 'package:url_launcher/url_launcher.dart';

class OpenLinks {
  static Future<void> openLink(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw Exception("Não foi possível abrir o link");
    }
  }
}