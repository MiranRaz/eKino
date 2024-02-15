// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movies _$MoviesFromJson(Map<String, dynamic> json) => Movies(
      json['movieId'] as int?,
      json['title'] as String?,
      json['description'] as String?,
      json['year'] == null ? null : DateTime.parse(json['year'] as String),
      json['runningTime'] as String?,
      json['photo'] as String?,
      json['directorId'] as int?,
    );

Map<String, dynamic> _$MoviesToJson(Movies instance) => <String, dynamic>{
      'movieId': instance.movieId,
      'title': instance.title,
      'description': instance.description,
      'year': instance.year?.toIso8601String(),
      'runningTime': instance.runningTime,
      'photo': instance.photo,
      'directorId': instance.directorId,
    };
