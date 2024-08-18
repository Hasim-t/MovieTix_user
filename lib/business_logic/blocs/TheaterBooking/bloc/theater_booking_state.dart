part of 'theater_booking_bloc.dart';

class TheaterBookingState extends Equatable {
  final List<DateTime> availableDates;
  final DateTime selectedDate;
  final List<TheaterData> theaters;
  final bool isLoading;

  const TheaterBookingState({
    this.availableDates = const [],
    required this.selectedDate,
    this.theaters = const [],
    this.isLoading = false,
  });

  TheaterBookingState copyWith({
    List<DateTime>? availableDates,
    DateTime? selectedDate,
    List<TheaterData>? theaters,
    bool? isLoading,
  }) {
    return TheaterBookingState(
      availableDates: availableDates ?? this.availableDates,
      selectedDate: selectedDate ?? this.selectedDate,
      theaters: theaters ?? this.theaters,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object> get props => [availableDates, selectedDate, theaters, isLoading];
}

class TheaterData {
  final String screenName;
  final String ownerName;
  final String screenId;
  final String ownerId;

  TheaterData({
    required this.screenName,
    required this.ownerName,
    required this.screenId,
    required this.ownerId,
  });
}