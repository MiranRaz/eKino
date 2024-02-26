import 'package:ekino_mobile/models/role.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_role.g.dart';

@JsonSerializable()
class UserRole {
  int? userRoleId;
  int? userId;
  int? roleId;
  DateTime? dateModified;
  List<Role>? role;

  UserRole(this.userRoleId, this.userId, this.roleId, this.dateModified);

  factory UserRole.fromJson(Map<String, dynamic> json) =>
      _$UserRoleFromJson(json);
  Map<String, dynamic> toJson() => _$UserRoleToJson(this);
}
