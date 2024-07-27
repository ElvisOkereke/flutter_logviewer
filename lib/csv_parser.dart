import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
// import 'package:encoding/encoding.dart';

Future<List<List<dynamic>>> parseCsv(String path) async {
  final file = File(path);

  // Try reading the file with different encodings
  String content;
  try {
    content = await file.readAsString(encoding: utf8);
  } catch (e) {
    final encoding = await detectEncoding(file);
    content = await file.readAsString(encoding: encoding);
  }

  final csvData = CsvToListConverter().convert(content);
  return csvData;
}

Future<Encoding> detectEncoding(File file) async {
  final rawBytes = await file.readAsBytes();
  final detectedEncoding = detect(rawBytes);
  if (detectedEncoding != null) {
    return detectedEncoding;
  }
  return latin1; // Fallback encoding
}

Encoding? detect(List<int> rawBytes) {
  final utf8Decoder = utf8.decoder
      .startChunkedConversion(StringConversionSink.withCallback((_) {}));
  final latin1Decoder = latin1.decoder
      .startChunkedConversion(StringConversionSink.withCallback((_) {}));
  try {
    utf8Decoder.addSlice(rawBytes, 0, rawBytes.length, true);
    return utf8;
  } catch (_) {
    try {
      latin1Decoder.addSlice(rawBytes, 0, rawBytes.length, true);
      return latin1;
    } catch (_) {
      return null;
    }
  }
}
