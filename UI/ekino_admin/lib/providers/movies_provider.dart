import 'package:ekino_admin/models/movies.dart';
import 'package:ekino_admin/providers/base_provider.dart';

class MoviesProvider extends BaseProvider<Movies> {
  MoviesProvider() : super("Movies");

  @override
  Movies fromJson(data) {
    return Movies.fromJson(data);
  }
}
