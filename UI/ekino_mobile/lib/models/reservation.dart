import 'package:ekino_mobile/models/userReservations.dart';
import 'package:json_annotation/json_annotation.dart';
import 'projection.dart'; // Import Projection model

part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  int? reservationId;
  int? userId;
  UserReservations? user; // Use UserReservations model
  int? projectionId;
  Projection? projection; // Add projection field
  String? row;
  String? column;
  String? numTicket;
  String? dateOfReservation; // Add dateOfReservation field

  Reservation({
    this.reservationId,
    this.userId,
    this.user,
    this.projectionId,
    this.projection,
    this.row,
    this.column,
    this.numTicket,
    this.dateOfReservation,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
