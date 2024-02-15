import 'package:ekino_mobile/models/directors.dart';
import 'package:ekino_mobile/providers/base_provider.dart';

class DirectorsProvider extends BaseProvider<Director> {
  DirectorsProvider() : super("Director");

  @override
  Director fromJson(data) {
    return Director.fromJson(data);
  }
}
