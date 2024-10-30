// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      reservationId: (json['reservationId'] as num?)?.toInt(),
      userId: (json['userId'] as num?)?.toInt(),
      user: json['user'] == null
          ? null
          : UserReservations.fromJson(json['user'] as Map<String, dynamic>),
      projectionId: (json['projectionId'] as num?)?.toInt(),
      projection: json['projection'] == null
          ? null
          : Projection.fromJson(json['projection'] as Map<String, dynamic>),
      row: json['row'] as String?,
      column: json['column'] as String?,
      numTicket: json['numTicket'] as String?,
      dateOfReservation: json['dateOfReservation'] as String?,
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'reservationId': instance.reservationId,
      'userId': instance.userId,
      'user': instance.user,
      'projectionId': instance.projectionId,
      'projection': instance.projection,
      'row': instance.row,
      'column': instance.column,
      'numTicket': instance.numTicket,
      'dateOfReservation': instance.dateOfReservation,
    };
