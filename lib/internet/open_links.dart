import 'package:url_launcher/url_launcher.dart';

class OpenLinks {
  static Future<void> openLink(String url) async {
    final Uri uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
    } else {
      throw Exception("Erro ao acessar o link.");
    }
  }
}