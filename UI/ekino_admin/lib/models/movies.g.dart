// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movies.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Movies _$MoviesFromJson(Map<String, dynamic> json) => Movies(
      json['movieId'] as int?,
      json['title'] as String?,
      json['description'] as String?,
    );

Map<String, dynamic> _$MoviesToJson(Movies instance) => <String, dynamic>{
      'movieId': instance.movieId,
      'title': instance.title,
      'description': instance.description,
    };
