import 'package:ekino_admin/models/auditorium.dart';
import 'package:ekino_admin/providers/base_provider.dart';

class AuditoriumProvider extends BaseProvider<Auditorium> {
  AuditoriumProvider() : super("Auditorium");

  @override
  Auditorium fromJson(data) {
    return Auditorium.fromJson(data);
  }
}
