import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class ImageConverter {
  static Future<String> imageToBytes(File pickedImage) async {
    Uint8List imagebytes = await pickedImage.readAsBytes();
    final base64String = base64.encode(imagebytes);
    return base64String;
  }
}
