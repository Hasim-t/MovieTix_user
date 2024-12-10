import 'dart:async';

import 'package:bloc/bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

part 'movie_event.dart';
part 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  final FirebaseFirestore _firestore;
  Timer? _carouselTimer;

  MovieBloc(this._firestore) : super(const MovieState()) {
    on<FetchMovies>(_onFetchMovies);
    on<UpdateCarouselPage>(_onUpdateCarouselPage);
    on<SearchMovies>(_onSearchMovies);
    on<FilterMovies>(_onFilterMovies);
     on<ToggleSearch>(_onToggleSearch);
    on<ClearSearch>(_onClearSearch);
  }

  Future<void> _onFetchMovies(FetchMovies event, Emitter<MovieState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final snapshots = await _firestore.collection('movies').get();
      final allMovies = snapshots.docs;
      final malayalamMovies = allMovies.where((movie) => 
        (movie.data())['language'] == 'Malayalam'
      ).toList();
      
      emit(state.copyWith(
        movies: allMovies, 
        malayalamMovies: malayalamMovies,
        isLoading: false
      ));
      _startCarouselTimer();
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  void _onUpdateCarouselPage(UpdateCarouselPage event, Emitter<MovieState> emit) {
    emit(state.copyWith(currentCarouselPage: event.page));
  }

  void _startCarouselTimer() {
    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      final nextPage = (state.currentCarouselPage + 1 ) % (state.malayalamMovies.length > 3 ? 3 : state.malayalamMovies.length);
      add(UpdateCarouselPage(nextPage));
    });
  }

   void _onSearchMovies(SearchMovies event, Emitter<MovieState> emit) {
  emit(state.copyWith(searchQuery: event.query));
}

  void _onFilterMovies(FilterMovies event, Emitter<MovieState> emit) {
    emit(state.copyWith(selectedLanguage: event.language));
  }
void _onToggleSearch(ToggleSearch event, Emitter<MovieState> emit) {
  emit(state.copyWith(
    isSearching: !state.isSearching,
    searchQuery: state.isSearching ? '' : state.searchQuery
  ));
}

  void _onClearSearch(ClearSearch event, Emitter<MovieState> emit) {
    emit(state.copyWith(searchQuery: '', isSearching: false));
  }

List<DocumentSnapshot> get filteredMovies {
  return state.movies.where((movie) {
    final data = movie.data() as Map<String, dynamic>;
    final name = data['name'].toString().toLowerCase();
    final language = data['language'].toString();
    
    bool matchesSearch = state.searchQuery.isEmpty || 
                         name.contains(state.searchQuery.toLowerCase());
    bool matchesLanguage = state.selectedLanguage == 'All' || 
                           language == state.selectedLanguage;
    
    return matchesSearch && matchesLanguage;
  }).toList();
}

  @override
  Future<void> close() {
    _carouselTimer?.cancel();
    return super.close();
  }
}


