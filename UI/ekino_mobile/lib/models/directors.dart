import 'package:json_annotation/json_annotation.dart';
part 'directors.g.dart';

@JsonSerializable()
class Director {
  int? directorId;
  String? fullName;
  String? biography;
  String? photo;

  Director(
    this.directorId,
    this.fullName,
    this.biography,
    this.photo,
  );

  factory Director.fromJson(Map<String, dynamic> json) =>
      _$DirectorFromJson(json);
  Map<String, dynamic> toJson() => _$DirectorToJson(this);
}
