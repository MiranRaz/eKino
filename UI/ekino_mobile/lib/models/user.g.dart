// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Users _$UsersFromJson(Map<String, dynamic> json) => Users(
      json['userId'] as int?,
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['username'] as String?,
      json['status'] as bool?,
      json['email'] as String?,
      json['phone'] as String?,
    )
      ..userRoles = (json['userRoles'] as List<dynamic>?)
          ?.map((e) => UserRole.fromJson(e as Map<String, dynamic>))
          .toList()
      ..roleNames = json['roleNames'] as String?;

Map<String, dynamic> _$UsersToJson(Users instance) => <String, dynamic>{
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'username': instance.username,
      'status': instance.status,
      'email': instance.email,
      'phone': instance.phone,
      'userRoles': instance.userRoles,
      'roleNames': instance.roleNames,
    };
