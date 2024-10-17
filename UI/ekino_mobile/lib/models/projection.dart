import 'package:ekino_mobile/models/movies.dart'; // Import the Movie model

class Projection {
  int? projectionId;
  DateTime dateOfProjection;
  int? auditoriumId;
  int? movieId;
  Movies? movie;
  double? ticketPrice;

  Projection(
    this.projectionId,
    this.dateOfProjection,
    this.movieId,
    this.auditoriumId,
    this.movie,
    this.ticketPrice,
  );

  factory Projection.fromJson(Map<String, dynamic> json) {
    return Projection(
      json['projectionId'] as int?,
      json['dateOfProjection'] != null
          ? DateTime.parse(json['dateOfProjection'] as String)
          : DateTime.now(),
      json['auditoriumId'] as int?,
      json['movieId'] as int?,
      json['movie'] != null
          ? Movies.fromJson(json['movie'] as Map<String, dynamic>)
          : null,
      json['ticketPrice'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectionId': projectionId,
      'dateOfProjection': dateOfProjection,
      'auditoriumId': auditoriumId,
      'movieId': movieId,
      'movie': movie?.toJson(),
      'ticketPrice': ticketPrice,
    };
  }
}
