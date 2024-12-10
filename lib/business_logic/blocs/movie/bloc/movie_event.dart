
part of 'movie_bloc.dart';


abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class FetchMovies extends MovieEvent {}

class UpdateCarouselPage extends MovieEvent {
  final int page;

  const UpdateCarouselPage(this.page);

  @override
  List<Object> get props => [page];
}

class SearchMovies extends MovieEvent {
  final String query;

  const SearchMovies(this.query);

  @override
  List<Object> get props => [query];
}

class FilterMovies extends MovieEvent {
  final String language;

  const FilterMovies(this.language);

  @override
  List<Object> get props => [language];
}

class ToggleSearch extends MovieEvent {}
class ClearSearch extends MovieEvent {}