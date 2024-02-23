import 'package:json_annotation/json_annotation.dart';
part 'reservation.g.dart';

@JsonSerializable()
class Reservation {
  int? reservationId;
  int? userId;
  int? projectionId;
  String? row;
  String? column;
  String? numTickets;

  Reservation(
    this.reservationId,
    this.userId,
    this.projectionId,
    this.row,
    this.column,
    this.numTickets,
  );

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);
  Map<String, dynamic> toJson() => _$ReservationToJson(this);
}
