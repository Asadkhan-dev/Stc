import 'dart:convert';

PosmPhotoModel posmPhotoModelFromJson(String str) =>
    PosmPhotoModel.fromJson(json.decode(str));

String posmPhotoModelToJson(PosmPhotoModel data) => json.encode(data.toJson());

class PosmPhotoModel {
  final int id;
  final String image;

  PosmPhotoModel({
    required this.id,
    required this.image,
  });

  factory PosmPhotoModel.fromJson(Map<String, dynamic> json) => PosmPhotoModel(
        id: json["id"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
      };
}
