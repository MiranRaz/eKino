import 'package:ekino_mobile/models/movies.dart';
import 'package:ekino_mobile/providers/base_provider.dart';

class MoviesProvider extends BaseProvider<Movies> {
  MoviesProvider() : super("Movies");

  @override
  Movies fromJson(data) {
    return Movies.fromJson(data);
  }
}
