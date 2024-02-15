using System;
using AutoMapper;
using eKino.Model.Requests;
using eKino.Model.SearchObjects;
using eKino.Services.Database;
using eKino.Services.Interfaces;
using Microsoft.EntityFrameworkCore;
using Microsoft.ML;
using Microsoft.ML.Data;
using Microsoft.ML.Trainers;

namespace eKino.Services.Services
{
    public class MoviesServices : BaseCRUDService<Model.Movies, Database.Movie, MoviesSearchObject, MovieUpsertRequest, MovieUpsertRequest>, IMoviesServices
    {
        public MoviesServices(eKinoContext context, IMapper mapper) : base(context, mapper)
        {
        }

        public override IQueryable<Movie> AddFilter(IQueryable<Movie> query, MoviesSearchObject? search = null)
        {
            var filteredQuery = base.AddFilter(query, search);
             
            if (!string.IsNullOrWhiteSpace(search.FTS))
            {
                filteredQuery = filteredQuery.Where(x => x.Title.Contains(search.FTS) || x.Description.Contains(search.FTS));
            }

            if (!string.IsNullOrWhiteSpace(search.Title))
            {
                filteredQuery = filteredQuery.Where(x => x.Title.Contains(search.Title));
            }

            if (search.DirectorId != null)
            {
                filteredQuery = filteredQuery.Where(x => x.DirectorId == search.DirectorId);
            }

            return filteredQuery;
        }

        public override IQueryable<Database.Movie> AddInclude(IQueryable<Database.Movie> query, MoviesSearchObject search = null)
        {
            query = query.Include(x => x.Director);
            query = query.Include("MovieGenres.Genre");
            return base.AddInclude(query, search);
        }

        // recommendation algorithm

        static MLContext mlContext = null;
        static object isLocked = new object();
        static ITransformer model = null;

        public List<Model.Movies> Recommend(int id)
        {
            lock (isLocked)
            {
                if (mlContext == null)
                {
                    mlContext = new MLContext();

                    // Load data from the database
                    var tmpData = _context.Genres.Include("MovieGenres").ToList();

                    // Create data for training
                    var data = new List<MovieEntry>();

                    foreach (var x in tmpData)
                    {
                        if (x.MovieGenres.Count > 1)
                        {
                            var distinctItemId = x.MovieGenres.Select(y => y.MovieId).ToList();

                            distinctItemId.ForEach(y =>
                            {
                                var relatedItems = x.MovieGenres.Where(z => z.MovieId != y);

                                foreach (var z in relatedItems)
                                {
                                    data.Add(new MovieEntry()
                                    {
                                        MovieID = (uint)y,
                                        CoPurchaseMovieID = (uint)z.MovieId,
                                    });
                                }
                            });
                        }
                    }

                    // Load training data
                    var traindata = mlContext.Data.LoadFromEnumerable(data);

                    // Configure trainer options
                    MatrixFactorizationTrainer.Options options = new MatrixFactorizationTrainer.Options();
                    options.MatrixColumnIndexColumnName = nameof(MovieEntry.MovieID);
                    options.MatrixRowIndexColumnName = nameof(MovieEntry.CoPurchaseMovieID);
                    options.LabelColumnName = "Label";
                    options.LossFunction = MatrixFactorizationTrainer.LossFunctionType.SquareLossOneClass;
                    options.Alpha = 0.01;
                    options.Lambda = 0.025;
                    // For better results use the following parameters
                    options.NumberOfIterations = 100;
                    options.C = 0.00001;

                    // Train the model
                    var est = mlContext.Recommendation().Trainers.MatrixFactorization(options);
                    model = est.Fit(traindata);
                }
            }

            // Prediction
            var movies = _context.Movies.Where(x => x.MovieId != id);

            var predictionResult = new List<Tuple<Database.Movie, float>>();

            foreach (var movie in movies)
            {
                var predictionengine = mlContext.Model.CreatePredictionEngine<MovieEntry, Copurchase_prediction>(model);
                var prediction = predictionengine.Predict(new MovieEntry()
                {
                    MovieID = (uint)id,
                    CoPurchaseMovieID = (uint)movie.MovieId
                });

                predictionResult.Add(new Tuple<Database.Movie, float>(movie, prediction.Score));
            }

            var finalResult = predictionResult.OrderByDescending(x => x.Item2).Select(x => x.Item1).Take(3).ToList();

            return _mapper.Map<List<Model.Movies>>(finalResult);
        }
    }

    public class Copurchase_prediction
    {
        public float Score { get; set; }
    }

    public class MovieEntry
    {
        [KeyType(count: 10)]
        public uint MovieID { get; set; }

        [KeyType(count: 10)]
        public uint CoPurchaseMovieID { get; set; }

        public float Label { get; set; }
    }
}