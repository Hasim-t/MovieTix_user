part of 'bottom_nav_bloc.dart';

@immutable
class BottomNavState {
  final int selectedIndex;

  BottomNavState({ this.selectedIndex =0} );


  BottomNavState copyWith({int? selectedIndex}) {
    return BottomNavState(
      selectedIndex: selectedIndex ?? this.selectedIndex,
    );
  }
}

final class BottomNavInitial extends BottomNavState {}

