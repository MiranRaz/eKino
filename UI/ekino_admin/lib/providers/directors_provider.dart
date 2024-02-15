import 'package:ekino_admin/models/directors.dart';
import 'package:ekino_admin/providers/base_provider.dart';

class DirectorsProvider extends BaseProvider<Director> {
  DirectorsProvider() : super("Director");

  @override
  Director fromJson(data) {
    return Director.fromJson(data);
  }
}
