import 'package:url_launcher/url_launcher.dart';

void tapYouTube() async {
  const url = 'https://youtu.be/dQw4w9WgXcQ?si=jtkO5ZWIMYhdhT-e';
  final uri = Uri.parse(url);
  try {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  } catch (e) {}
}
