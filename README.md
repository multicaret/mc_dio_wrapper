# mc_dio_wrapper

A Flutter package for Multicaret projects that simplifies HTTP requests, logging, error handling, and caching.

## Features

- Simplified HTTP requests
- Built-in request/response logging
- Error handling
- Cache management
- Toast notifications

## Installation

Add `mc_dio_wrapper` to your `pubspec.yaml` file:

```yaml
dependencies:
  mc_dio_wrapper: latest_version
```

Run `flutter pub get` to install the package.

## Usage

### Basic Initialization

To use `mc_dio_wrapper`, initialize it in your Flutter application:

```dart
import 'package:mc_dio_wrapper/mc_dio_wrapper.dart';

void main() {
  // ...
  McHttpWrapperInitializer.by(
    baseUrl: const String.fromEnvironment('API_ORIGIN', defaultValue: 'https://dummyjson.com'),
  );
  // ...
  runApp(const MyApp());
}
```

### Making HTTP Requests

Here’s how to make a basic HTTP GET request:

```dart
import 'package:example/models/user_index_response.dart';
import 'package:mc_dio_wrapper/mc_dio_wrapper.dart';

import 'api_endpoints.dart';

class AppHttpController {
  final McHttpWrapper _httpService = McHttpWrapper();

  Future<List<User>> fetchUser() async {
    try {
      McResponse<UserIndexResponse> response = await _httpService.get<UserIndexResponse>(
        AppApiEndpoints.userIndex.path,
        converter: UserIndexResponse.fromJson,
        queryParameters: HttpRequestPayload.fromMap({'limit': 2}),
      );

      return response.data!.data.users;
    } catch (e) {
      rethrow;
    }
  }
}

```

### Enabling Features

Enable various features such as logging, headers, API version, and caching for your HTTP requests and responses:

```dart
void main() {
  /// ... 
  McHttpWrapperInitializer.by(
    baseUrl: const String.fromEnvironment('API_ORIGIN', defaultValue: 'https://dummyjson.com'),
    isLocalizedApi: false,
    httpLoggerLevel: LogDetails.full,
    headers: {
      'Authorization': 'Bearer YOUR_API_TOKEN',
      'Content-Type': 'application/json', // <-- This is already defined in the default header
    },
    apiVersion: 'v1',
    enableCaching: true,
  );

  /// ...
}
```

### Error Handling Example 1

Set up custom error handling using dialog:

```dart
/// Inside your widget
_loadData() {
  _controller.fetchUser().then((List<User> users) {
    if (kDebugMode) {
      print('Users Length => ${users.length}');
    }
  }).onError(McDioError.handlerByDialogByErrors(context));
}
```

### Error Handling Example 2

Set up custom error handling using toast error message:

```dart
/// Inside your widget
_loadData(BuildContext context) {
  _controller.fetchUser().then((List<User> users) {
    if (kDebugMode) {
      print('Users Length => ${users.length}');
    }
  }).onError(McDioError.handlerByToastMsg);
}
```

### Steps to Use the Example Project

1. **Clone the repository** and navigate to the `example` directory.
2. **Run `flutter pub get`** to install dependencies.
3. **Run the example app** using `flutter run`.

## License

This project is licensed under the MIT License.