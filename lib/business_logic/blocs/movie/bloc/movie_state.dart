part of 'movie_bloc.dart';



class MovieState extends Equatable {
  final List<DocumentSnapshot> movies;
  final List<DocumentSnapshot> malayalamMovies;
  final bool isLoading;
  final String? error;
  final int currentCarouselPage;

  const MovieState({
    this.movies = const [],
    this.malayalamMovies = const [],
    this.isLoading = false,
    this.error,
    this.currentCarouselPage = 0,
  });

  MovieState copyWith({
    List<DocumentSnapshot>? movies,
    List<DocumentSnapshot>? malayalamMovies,
    bool? isLoading,
    String? error,
    int? currentCarouselPage,
  }) {
    return MovieState(
      movies: movies ?? this.movies,
      malayalamMovies: malayalamMovies ?? this.malayalamMovies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentCarouselPage: currentCarouselPage ?? this.currentCarouselPage,
    );
  }

  @override
  List<Object?> get props => [movies, malayalamMovies, isLoading, error, currentCarouselPage];
}