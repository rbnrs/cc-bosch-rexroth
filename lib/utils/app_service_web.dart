import 'dart:convert';
import 'dart:typed_data';
import "package:universal_html/html.dart";

import 'package:poll_app/utils/app_service.dart';

class AppServiceWeb extends AppService {
  @override
  Future<void> downloadPicture(Uint8List pngBytes, String fileName) async {
    // Encode our file in base64
    final base64 = base64Encode(pngBytes);
    // Create the link with the file
    final anchor =
        AnchorElement(href: 'data:application/octet-stream;base64,$base64')
          ..target = 'blank';

    anchor.download = fileName;
    // trigger download
    document.body!.append(anchor);
    anchor.click();
    anchor.remove();
    return;
  }
}
