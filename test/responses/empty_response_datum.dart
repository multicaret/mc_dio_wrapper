import 'package:mc_dio_wrapper/src/interfaces/base_response.dart';

base class EmptyResponseDatum extends BaseResponse {
  EmptyResponseDatum({
    required super.data,
    required super.errors,
    required super.message,
    required super.status,
  });

  factory EmptyResponseDatum.fromJson(Map<String, dynamic> json) {
    return EmptyResponseDatum(
      data: json['data'],
      errors: [],
      message: '',
      status: 200,
    );
  }
}
