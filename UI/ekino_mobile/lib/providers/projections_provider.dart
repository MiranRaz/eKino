import 'package:ekino_mobile/models/projection.dart';
import 'package:ekino_mobile/providers/base_provider.dart';

class ProjectionsProvider extends BaseProvider<Projection> {
  ProjectionsProvider() : super("Projection");

  @override
  Projection fromJson(data) {
    return Projection.fromJson(data);
  }
}
