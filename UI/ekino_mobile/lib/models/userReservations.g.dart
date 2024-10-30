// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userReservations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserReservations _$UserReservationsFromJson(Map<String, dynamic> json) =>
    UserReservations(
      userId: (json['userId'] as num?)?.toInt(),
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      username: json['username'] as String?,
      status: json['status'] as bool?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
    );

Map<String, dynamic> _$UserReservationsToJson(UserReservations instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'username': instance.username,
      'status': instance.status,
      'email': instance.email,
      'phone': instance.phone,
    };
