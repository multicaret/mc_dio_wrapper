import 'dart:convert';

import 'package:mc_dio_wrapper/src/interfaces/base_response.dart';

base class PostResponse extends BaseResponse<PostResponseDatum> {
  PostResponse({
    required super.data,
    required super.errors,
    required super.message,
    required super.status,
  });

  factory PostResponse.fromJson(Map<String, dynamic> json) => PostResponse(
        data: PostResponseDatum.fromJson(json),
        errors: [],
        message: '',
        status: 200,
      );
}

class PostResponseDatum {
  PostResponseDatum({
    required this.body,
    required this.id,
    required this.title,
    required this.userId,
  });

  final String body;
  final int id;
  final String title;
  final int userId;

  factory PostResponseDatum.fromRawJson(String str) => PostResponseDatum.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PostResponseDatum.fromJson(Map<String, dynamic> json) => PostResponseDatum(
        body: json["body"] ?? '',
        id: json["id"],
        title: json["title"] ?? '',
        userId: json["userId"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "body": body,
        "id": id,
        "title": title,
        "userId": userId,
      };
}
