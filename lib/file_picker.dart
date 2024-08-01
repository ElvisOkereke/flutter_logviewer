import 'package:file_picker/file_picker.dart';

Future<String?> pickFile() async {
  final result = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ['csv']);
  if (result != null) {
    return result.files.single.path;
  }
  return null;
}
