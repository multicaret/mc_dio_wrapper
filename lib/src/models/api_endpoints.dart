sealed class _ApiEndpointsInitializer {
  final String _path;

  const _ApiEndpointsInitializer._([this._path = '']);

  // Example 1: final endpoint = ApiEndpoints.login.endpoint;
  // Example 2: final endpoint = ApiEndpoints.showPages[['articles', 1]];
  String byParams(List<Object> params) {
    const String pattern = '[^]';
    final RegExp regExp = RegExp(r"\{(.*?)\}");
    String tempString = _path.replaceAll(regExp, pattern);
    final int urlParamsCount = tempString.split(pattern).length - 1;

    assert(urlParamsCount == params.length, 'Endpoint params count not correct');

    int foundedParams = -1;
    return _path.replaceAllMapped(regExp, (Match _) {
      foundedParams++;
      return params[foundedParams].toString();
    });
  }
}

base class ApiEndpoints extends _ApiEndpointsInitializer {
  const ApiEndpoints([super.path]) : super._();

  String get path => _path;
}
