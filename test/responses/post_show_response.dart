import 'package:mc_dio_wrapper/src/interfaces/base_response.dart';

base class PostShowResponse extends BaseResponse<PostShowResponseDatum> {
  PostShowResponse({
    required super.data,
    required super.errors,
    required super.message,
    required super.status,
  });

  factory PostShowResponse.fromJson(Map<String, dynamic> json) {
    return PostShowResponse(
      data: PostShowResponseDatum.fromJson(json),
      errors: json["errors"] ?? [],
      message: json["message"] ?? '',
      status: json["status"] ?? 200,
    );
  }
}

class PostShowResponseDatum {
  PostShowResponseDatum({
    required this.body,
    required this.id,
    required this.title,
    required this.userId,
  });

  final String body;
  final int id;
  final String title;
  final int userId;

  factory PostShowResponseDatum.fromJson(Map<String, dynamic> json) => PostShowResponseDatum(
        body: json["body"],
        id: json["id"],
        title: json["title"],
        userId: json["userId"],
      );

  Map<String, dynamic> toJson() => {
        "body": body,
        "id": id,
        "title": title,
        "userId": userId,
      };
}
