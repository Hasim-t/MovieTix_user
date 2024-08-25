import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
part 'ticket_event.dart';
part 'ticket_state.dart';


class TicketBloc extends Bloc<TicketEvent, TicketState> {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;

  TicketBloc({
    required FirebaseFirestore firestore,
    required FirebaseAuth auth,
  })  : _firestore = firestore,
        _auth = auth,
        super(TicketInitial()) {
    on<LoadTickets>(_onLoadTickets);
  }

  Future<void> _onLoadTickets(LoadTickets event, Emitter<TicketState> emit) async {
    emit(TicketLoading());
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) {
        emit(const TicketError('User not authenticated'));
        return;
      }
      final ticketsStream = _firestore
          .collection('users')
          .doc(userId)
          .collection('tickets')
          .snapshots();

      await emit.forEach(ticketsStream, onData: (QuerySnapshot snapshot) {
        return TicketLoaded(snapshot.docs);
      });
    } catch (e) {
      emit(TicketError(e.toString()));
    }
  }
}