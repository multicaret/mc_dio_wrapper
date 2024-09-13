import 'package:mc_dio_wrapper/mc_dio_wrapper.dart';

base class AppApiEndpoints extends ApiEndpoints {
  const AppApiEndpoints(super.path);

  /// Usage Example: AppApiEndpoints.productShow.path;
  static const AppApiEndpoints userIndex = AppApiEndpoints('users');

  /// Usage Example: AppApiEndpoints.productShow.productShow.byParams([1]);
  static const AppApiEndpoints productShow = AppApiEndpoints('products/{id}');
}
