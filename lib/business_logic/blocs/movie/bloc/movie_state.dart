part of 'movie_bloc.dart';

class MovieState extends Equatable {
  final List<DocumentSnapshot> movies;
  final List<DocumentSnapshot> malayalamMovies;
  final bool isLoading;
  final String? error;
  final int currentCarouselPage;
  final String searchQuery;
  final String selectedLanguage;
  final bool isSearching;

  const MovieState({
    this.movies = const [],
    this.malayalamMovies = const [],
    this.isLoading = false,
    this.error,
    this.currentCarouselPage = 0,
    this.searchQuery = '',
    this.selectedLanguage = 'All',
    this.isSearching = false,
  });

  MovieState copyWith({
    List<DocumentSnapshot>? movies,
    List<DocumentSnapshot>? malayalamMovies,
    bool? isLoading,
    String? error,
    int? currentCarouselPage,
    String? searchQuery,
    String? selectedLanguage,
    bool? isSearching,
  }) {
    return MovieState(
      movies: movies ?? this.movies,
      malayalamMovies: malayalamMovies ?? this.malayalamMovies,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      currentCarouselPage: currentCarouselPage ?? this.currentCarouselPage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isSearching: isSearching ?? this.isSearching,
    );
  }

  @override
  List<Object?> get props => [movies, malayalamMovies, isLoading, error, currentCarouselPage, searchQuery, selectedLanguage, isSearching];
}