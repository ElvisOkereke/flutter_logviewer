import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

Future<String?> pickFile() async {
  final result = await FilePicker.platform.pickFiles();
  if (result != null) {
    return result.files.single.path;
  }
  return null;
}
