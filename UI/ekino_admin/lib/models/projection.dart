import 'package:ekino_admin/models/movies.dart'; // Import the Movie model

class Projection {
  int? projectionId;
  DateTime dateOfProjection;
  int auditoriumId;
  Movies movie; // Reference to the Movie model
  double ticketPrice;

  Projection(
    this.projectionId,
    this.dateOfProjection,
    this.auditoriumId,
    this.movie,
    this.ticketPrice,
  );

  factory Projection.fromJson(Map<String, dynamic> json) {
    return Projection(
      json['projectionId'] as int?,
      DateTime.parse(json['dateOfProjection'] as String),
      json['auditoriumId'] as int,
      Movies.fromJson(
          json['movie'] as Map<String, dynamic>), // Parse the Movie object
      json['ticketPrice'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'projectionId': projectionId,
      'dateOfProjection': dateOfProjection.toIso8601String(),
      'auditoriumId': auditoriumId,
      'movie': movie.toJson(), // Convert the Movie object to JSON
      'ticketPrice': ticketPrice,
    };
  }
}
