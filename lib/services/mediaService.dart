import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class MediaService {
  MediaService();

  Future<PlatformFile?> pickImageFromLibrary() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.media,
        withData: true,
      );

      if (result != null ) {
        return result.files[0];
      } else {
        print("User canceled the file picking operation.");
        return null;
      }
    } catch (e) {
      print("Error picking image: $e");
      return null;
    }
  }
}
