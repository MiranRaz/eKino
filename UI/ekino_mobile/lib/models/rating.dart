import 'package:ekino_mobile/models/movies.dart';
import 'package:ekino_mobile/models/user.dart';
import 'package:json_annotation/json_annotation.dart';
part 'rating.g.dart';

@JsonSerializable()
class Rating {
  int? ratingId;
  int? userId;
  Users user;
  int? movieId;
  Movies? movie;
  int? value;
  DateTime? dateOfRating;

  Rating(
    this.ratingId,
    this.userId,
    this.user,
    this.movieId,
    this.movie,
    this.value,
    this.dateOfRating,
  );

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
