base class BaseResponse<T> {
  BaseResponse({
    required this.data,
    required this.errors,
    required this.message,
    required this.status,
  });

  final T data;
  final List<dynamic> errors;
  final String message;
  final int status;

  Map<String, dynamic> toJson() => {
        "data": data,
        "errors": List<dynamic>.from(errors.map((dynamic x) => x)),
        "message": message,
        "status": status,
      };
}
