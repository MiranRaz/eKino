// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auditorium.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Auditorium _$AuditoriumFromJson(Map<String, dynamic> json) => Auditorium(
      (json['auditoriumId'] as num?)?.toInt(),
      json['name'] as String?,
    );

Map<String, dynamic> _$AuditoriumToJson(Auditorium instance) =>
    <String, dynamic>{
      'auditoriumId': instance.auditoriumId,
      'name': instance.name,
    };
