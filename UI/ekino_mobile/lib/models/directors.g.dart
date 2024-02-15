// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directors.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Director _$DirectorFromJson(Map<String, dynamic> json) => Director(
      json['directorId'] as int?,
      json['fullName'] as String?,
      json['biography'] as String?,
      json['photo'] as String?,
    );

Map<String, dynamic> _$DirectorToJson(Director instance) => <String, dynamic>{
      'directorId': instance.directorId,
      'fullName': instance.fullName,
      'biography': instance.biography,
      'photo': instance.photo,
    };
