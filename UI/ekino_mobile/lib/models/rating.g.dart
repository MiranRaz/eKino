// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rating.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Rating _$RatingFromJson(Map<String, dynamic> json) => Rating(
      (json['ratingId'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      Users.fromJson(json['user'] as Map<String, dynamic>),
      (json['movieId'] as num?)?.toInt(),
      json['movie'] == null
          ? null
          : Movies.fromJson(json['movie'] as Map<String, dynamic>),
      (json['value'] as num?)?.toInt(),
      json['dateOfRating'] == null
          ? null
          : DateTime.parse(json['dateOfRating'] as String),
    );

Map<String, dynamic> _$RatingToJson(Rating instance) => <String, dynamic>{
      'ratingId': instance.ratingId,
      'userId': instance.userId,
      'user': instance.user,
      'movieId': instance.movieId,
      'movie': instance.movie,
      'value': instance.value,
      'dateOfRating': instance.dateOfRating?.toIso8601String(),
    };
