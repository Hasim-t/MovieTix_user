part of 'bottom_nav_bloc.dart';

@immutable
sealed class BottomNavEvent {}

class ChangeBottomNavIndex extends BottomNavEvent {
  final int index;
  ChangeBottomNavIndex(this.index);
}
