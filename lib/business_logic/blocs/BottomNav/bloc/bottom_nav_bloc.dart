import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'bottom_nav_event.dart';
part 'bottom_nav_state.dart';

class BottomNavBloc extends Bloc<BottomNavEvent, BottomNavState> {
  BottomNavBloc() : super( BottomNavState()) {
    on<ChangeBottomNavIndex>((event, emit) {
      emit(state.copyWith(selectedIndex: event.index));
    });
  }
}