// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(Map<String, dynamic> json) => Reservation(
      json['reservationId'] as int?,
      json['userId'] as int?,
      json['projectionId'] as int?,
      json['row'] as String?,
      json['column'] as String?,
      json['numTickets'] as String?,
    );

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'reservationId': instance.reservationId,
      'userId': instance.userId,
      'projectionId': instance.projectionId,
      'row': instance.row,
      'column': instance.column,
      'numTickets': instance.numTickets,
    };
