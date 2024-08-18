import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'theater_booking_event.dart';
part 'theater_booking_state.dart';

// theater_booking_bloc.dart


class TheaterBookingBloc extends Bloc<TheaterBookingEvent, TheaterBookingState> {
  final String movieId;
  final FirebaseFirestore firestore;

  TheaterBookingBloc({required this.movieId, required this.firestore}) 
      : super(TheaterBookingState(selectedDate: DateTime.now())) {
    on<LoadAvailableDates>(_onLoadAvailableDates);
    on<SelectDate>(_onSelectDate);
    on<LoadTheaters>(_onLoadTheaters);
  }

  void _onLoadAvailableDates(LoadAvailableDates event, Emitter<TheaterBookingState> emit) {
    final availableDates = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
    emit(state.copyWith(availableDates: availableDates));
  }

  void _onSelectDate(SelectDate event, Emitter<TheaterBookingState> emit) {
    emit(state.copyWith(selectedDate: event.selectedDate));
    add(LoadTheaters());
  }

  Future<void> _onLoadTheaters(LoadTheaters event, Emitter<TheaterBookingState> emit) async {
    emit(state.copyWith(isLoading: true));
    try {
      final ownersSnapshot = await firestore.collection('owners').get();
      List<TheaterData> theaters = [];

      for (var owner in ownersSnapshot.docs) {
        final ownerData = owner.data();
        final screensSnapshot = await firestore
            .collection('owners')
            .doc(owner.id)
            .collection('screens')
            .get();
        
        for (var screen in screensSnapshot.docs) {
          final screenData = screen.data();
          theaters.add(TheaterData(
            screenName: screenData['name'] ?? 'Screen ${screen.id}',
            ownerName: ownerData['name'] ?? 'Owner ${owner.id}',
            screenId: screen.id,
            ownerId: owner.id,
          ));
        }
      }

      emit(state.copyWith(theaters: theaters, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      // Handle error
    }
  }
}