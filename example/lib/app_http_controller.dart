import 'package:example/models/user_index_response.dart';
import 'package:mc_dio_wrapper/mc_dio_wrapper.dart';

import 'api_endpoints.dart';

class AppHttpController {
  final McHttpWrapper _httpService = McHttpWrapper('ar');

  Future<List<User>> fetchUsers() async {
    try {
      McResponse<UserIndexResponse> response = await _httpService.get<UserIndexResponse>(
        AppApiEndpoints.userIndex.path,
        converter: UserIndexResponse.fromJson,
        queryParameters: RequestQueryParams.fromMap({'limit': 2}),
      );

      return response.data!.data.users;
    } catch (e) {
      rethrow;
    }
  }
}
