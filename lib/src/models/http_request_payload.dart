import 'dart:collection';

class HttpRequestPayload extends MapBase<String, dynamic> {
  final Map<String, dynamic> _map = HashMap.identity();

  HttpRequestPayload._();

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

  factory HttpRequestPayload.fromMap(Map<String, dynamic> map) {
    final payload = HttpRequestPayload._();
    payload.addAll(map);
    return payload;
  }

  factory HttpRequestPayload.fromList(List<MapEntry> map) {
    final payload = HttpRequestPayload._();
    for (var element in map) {
      payload[element.key.toString()] = element.value.toString();
    }
    return payload;
  }

  bool hasKey(Object? key) {
    return _map.containsKey(key);
  }
}
