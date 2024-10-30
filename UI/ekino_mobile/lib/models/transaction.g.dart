// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      (json['transactionId'] as num?)?.toInt(),
      (json['userId'] as num?)?.toInt(),
      (json['reservationId'] as num?)?.toInt(),
      json['date'] == null ? null : DateTime.parse(json['date'] as String),
      (json['number'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'transactionId': instance.transactionId,
      'userId': instance.userId,
      'reservationId': instance.reservationId,
      'date': instance.date?.toIso8601String(),
      'number': instance.number,
    };
