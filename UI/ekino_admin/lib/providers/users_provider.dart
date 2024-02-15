import 'package:ekino_admin/models/user.dart';
import 'package:ekino_admin/providers/base_provider.dart';

class UsersProvider extends BaseProvider<Users> {
  UsersProvider() : super("Users");

  @override
  Users fromJson(data) {
    return Users.fromJson(data);
  }
}
