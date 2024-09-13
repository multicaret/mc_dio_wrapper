import 'dart:collection';

class RequestQueryParams extends MapBase<String, dynamic> {
  final Map<String, dynamic> _map = HashMap.identity();

  RequestQueryParams._();

  @override
  dynamic operator [](Object? key) => _map[key];

  @override
  void operator []=(String key, dynamic value) => _map[key] = value;

  @override
  void clear() => _map.clear();

  @override
  Iterable<String> get keys => _map.keys;

  @override
  dynamic remove(Object? key) => _map.remove(key);

  factory RequestQueryParams.fromMap(Map<String, dynamic> map) {
    final payload = RequestQueryParams._();
    payload.addAll(map);
    return payload;
  }

  factory RequestQueryParams.fromCleanMap(Map<String, dynamic> map) {
    final payload = RequestQueryParams._();
    map.removeWhere((key, value) => value == null || (value is String && value.isEmpty));
    payload.addAll(map);
    return payload;
  }

  factory RequestQueryParams.empty() => RequestQueryParams._();

  bool hasKey(Object? key) {
    return _map.containsKey(key);
  }
}
