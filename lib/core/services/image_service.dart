import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class ImageService {
  final Dio _dio;

  ImageService(this._dio);

  Future<File> getOptimizedImage(String url, {required int width, required int height}) async {
    final filename = _getFilenameFromUrl(url, width, height);
    final cacheDir = await getApplicationDocumentsDirectory();
    final file = File(p.join(cacheDir.path, 'images', filename));

    if (await file.exists()) {
      return file;
    }

    // Download
    try {
      final response = await _dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final bytes = response.data as Uint8List;

      // Process in Isolate
      final processedBytes = await Isolate.run(() => _processImage(bytes, width, height));

      // Save to cache
      await file.parent.create(recursive: true);
      await file.writeAsBytes(processedBytes);

      return file;
    } catch (e) {
      throw Exception('Failed to load image: $e');
    }
  }

  String _getFilenameFromUrl(String url, int width, int height) {
    final uri = Uri.parse(url);
    final name = uri.pathSegments.last.split('.').first;
    return '${name}_${width}x${height}.jpg';
  }

  static Uint8List _processImage(Uint8List input, int width, int height) {
    final image = img.decodeImage(input);
    if (image == null) throw Exception('Failed to decode image');

    final resized = img.copyResize(image, width: width, height: height);
    return Uint8List.fromList(img.encodeJpg(resized, quality: 80));
  }
}
