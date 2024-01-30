import 'package:json_annotation/json_annotation.dart';
part 'movies.g.dart';

@JsonSerializable()
class Movies {
  int? movieId;
  String? title;
  String? description;

  Movies(this.movieId, this.title, this.description);

  factory Movies.fromJson(Map<String, dynamic> json) => _$MoviesFromJson(json);
  Map<String, dynamic> toJson() => _$MoviesToJson(this);
}

//  public partial class Movies
//     {
//         public int MovieId { get; set; }
//         public string Title { get; set; }
//         public string Description { get; set; }
//         public DateTime Year { get; set; }
//         public string RunningTime { get; set; }
//         public byte[] Photo { get; set; }
//         public int DirectorId { get; set; }
//         public override string ToString()
//         {
//             return Title;
//         }
//         //public virtual Director Director { get; set; } = null!;
//         //public virtual ICollection<MovieGenre> MovieGenres { get; set; }
//         //public virtual ICollection<Projection> Projections { get; set; }
//         //public virtual ICollection<Rating> Ratings { get; set; }
//     }