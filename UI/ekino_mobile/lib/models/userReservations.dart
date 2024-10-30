import 'package:json_annotation/json_annotation.dart';

part 'userReservations.g.dart';

@JsonSerializable()
class UserReservations {
  int? userId;
  String? firstName;
  String? lastName;
  String? username;
  bool? status;
  String? email;
  String? phone;

  UserReservations({
    this.userId,
    this.firstName,
    this.lastName,
    this.username,
    this.status,
    this.email,
    this.phone,
  });

  factory UserReservations.fromJson(Map<String, dynamic> json) =>
      _$UserReservationsFromJson(json);
  Map<String, dynamic> toJson() => _$UserReservationsToJson(this);
  @override
  String toString() {
    return 'UserReservations(userId: $userId, firstName: $firstName, lastName: $lastName, username: $username, status: $status, email: $email, phone: $phone)';
  }
}
