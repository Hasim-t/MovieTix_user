part of 'theater_booking_bloc.dart';

abstract class TheaterBookingEvent extends Equatable {
  const TheaterBookingEvent();

  @override
  List<Object> get props => [];
}

class LoadAvailableDates extends TheaterBookingEvent {}

class SelectDate extends TheaterBookingEvent {
  final DateTime selectedDate;

  const SelectDate(this.selectedDate);

  @override
  List<Object> get props => [selectedDate];
}

class LoadTheaters extends TheaterBookingEvent {}