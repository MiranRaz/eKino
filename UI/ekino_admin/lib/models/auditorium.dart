import 'package:json_annotation/json_annotation.dart';
part 'auditorium.g.dart';

@JsonSerializable()
class Auditorium {
  int? auditoriumId;
  String? name;

  Auditorium(
    this.auditoriumId,
    this.name,
  );

  factory Auditorium.fromJson(Map<String, dynamic> json) =>
      _$AuditoriumFromJson(json);
  Map<String, dynamic> toJson() => _$AuditoriumToJson(this);
}
