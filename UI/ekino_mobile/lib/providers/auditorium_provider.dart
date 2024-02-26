import 'package:ekino_mobile/models/auditorium.dart';
import 'package:ekino_mobile/providers/base_provider.dart';

class AuditoriumProvider extends BaseProvider<Auditorium> {
  AuditoriumProvider() : super("Auditorium");

  @override
  Auditorium fromJson(data) {
    return Auditorium.fromJson(data);
  }
}
