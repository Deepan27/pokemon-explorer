import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:pokemon_explorer/core/services/image_service.dart';

class MockDio extends Mock implements Dio {}

class MockResponse extends Mock implements Response {}

class MockPathProviderPlatform extends Mock
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '.';
  }
}

void main() {
  late ImageService imageService;
  late MockDio mockDio;

  setUp(() {
    mockDio = MockDio();
    imageService = ImageService(mockDio);
    PathProviderPlatform.instance = MockPathProviderPlatform();
  });

  const tUrl = 'https://example.com/image.png';
  const tWidth = 100;
  const tHeight = 100;

  // Note: Testing actual Isolate.run and file writing in unit tests can be tricky
  // because of the isolated environment.
  // We will test that the service attempts to download when file doesn't exist.
  // For a full test we would need integration tests or to mock File/Isolate.

  test('should call Dio.get when file does not exist', () async {
    // arrange
    final mockResponse = MockResponse();
    when(() => mockResponse.data).thenReturn(Uint8List(0));
    when(() => mockDio.get(any(), options: any(named: 'options')))
        .thenAnswer((_) async => mockResponse);

    // act
    try {
      await imageService.getOptimizedImage(tUrl,
          width: tWidth, height: tHeight);
    } catch (_) {
      // Ignore errors from Isolate/File writing in this mock environment
    }

    // assert
    verify(() => mockDio.get(tUrl, options: any(named: 'options'))).called(1);
  });
}
