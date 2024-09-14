import 'package:flutter_test/flutter_test.dart';
import 'package:mc_dio_wrapper/mc_dio_wrapper.dart';

import 'responses/empty_response_datum.dart';
import 'responses/post_response.dart';
import 'responses/post_show_response.dart';

void main() {
  McHttpWrapperInitializer.by(
    baseUrl: 'https://jsonplaceholder.typicode.com',
    httpLoggerLevel: LogDetails.none,
  );
  group('MC Dio Wrapper Tests', () {
    test('GET Request', () async {
      final McHttpWrapper dioWrapper = McHttpWrapper();
      final McResponse<PostShowResponse> response = await dioWrapper.get<PostShowResponse>(
        'posts/1',
        converter: PostShowResponse.fromJson,
      );

      expect(response.statusCode, equals(200));
      expect(response.data!.data.id, equals(1));
    });

    test('POST Request', () async {
      final McHttpWrapper dioWrapper = McHttpWrapper();
      final Map<String, Object> data = {'title': 'foo', 'body': 'bar', 'userId': 1};

      final McResponse<PostResponse> response = await dioWrapper.post<PostResponse>(
        'posts',
        converter: PostResponse.fromJson,
        payload: HttpRequestPayload.fromMap(data),
      );

      expect(response.statusCode, equals(201));
      expect(response.data!.data.id, equals(101));
    });

    test('Handles Errors Gracefully', () async {
      final McHttpWrapper dioWrapper = McHttpWrapper();

      try {
        await dioWrapper.get<EmptyResponseDatum>(
          'invalid_endpoint',
          converter: EmptyResponseDatum.fromJson,
        );
      } catch (e) {
        expect(e, isException);
      }
    });
  });
}
