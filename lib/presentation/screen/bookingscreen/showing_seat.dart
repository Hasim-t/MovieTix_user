import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/bookingscreen/seat_layout.dart';
import 'package:movie/presentation/screen/bookingscreen/ticket.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ShowingSeat extends StatelessWidget {
  final String movieId;
  final String screenId;
  final String ownerId;
  final DateTime selectedDate;
  final String selectedTime;
  final dynamic movieName;

  const ShowingSeat({
    super.key,
    required this.movieId,
    required this.screenId,
    required this.ownerId,
    required this.selectedDate,
    required this.selectedTime,
    required this.movieName,
  });
 @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        backgroundColor: MyColor().primarycolor,
        title: const Text('Select Seats'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _loadScreenData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(child: Text('No data available'));
          }

          final screenData = snapshot.data!;
          return _SeatSelectionContent(
            movieName: movieName,
            screenData: screenData,
            movieId: movieId,
            screenId: screenId,
            ownerId: ownerId,
            selectedDate: selectedDate,
            selectedTime: selectedTime,
            theaterName: screenData['theaterName'] ?? 'Unknown Theater',  // Add this line
          );
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _loadScreenData() async {
    try {
      final ownerDoc = await FirebaseFirestore.instance
          .collection('owners')
          .doc(ownerId)
          .get();

      final screenDoc = await FirebaseFirestore.instance
          .collection('owners')
          .doc(ownerId)
          .collection('screens')
          .doc(screenId)
          .get();

      if (!screenDoc.exists) {
        throw Exception('Screen configuration not found');
      }

      final screenConfig = screenDoc.data() as Map<String, dynamic>;
      final showingDoc = await FirebaseFirestore.instance
          .collection('owners')
          .doc(ownerId)
          .collection('screens')
          .doc(screenId)
          .collection('movie_schedules')
          .doc(movieId)
          .collection('showings')
          .doc('${selectedDate.toIso8601String().split('T')[0]}_$selectedTime')
          .get();

      Map<String, dynamic> showingData;
      if (showingDoc.exists) {
        showingData = showingDoc.data() as Map<String, dynamic>;
      } else {
        showingData = _createDefaultShowingData(screenConfig);
        await showingDoc.reference.set(showingData);
      }

      return {
        ...screenConfig,
        'seatStates': showingData['seatStates'],
        'theaterName': ownerDoc['name'] ?? 'Unknown Theater',  // Add this line
      };
    } catch (e) {
      print('Error loading screen data: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _createDefaultShowingData(
      Map<String, dynamic> screenConfig) {
    final int totalSeats = screenConfig['rows'] * screenConfig['cols'];
    return {
      'seatStates': List.filled(
          totalSeats, SeatState.unselected.toString().split('.').last),
    };
  }
}

class _SeatSelectionContent extends StatefulWidget {
  final Map<String, dynamic> screenData;
  final String movieId;
  final String screenId;
  final String ownerId;
  final DateTime selectedDate;
  final String selectedTime;
  final String movieName;
  final String theaterName;  // Add this line

  const _SeatSelectionContent({
    required this.screenData,
    required this.movieId,
    required this.screenId,
    required this.ownerId,
    required this.selectedDate,
    required this.selectedTime,
    required this.movieName,
    required this.theaterName,  // Add this line
  });

  @override
  _SeatSelectionContentState createState() => _SeatSelectionContentState();
}

class _SeatSelectionContentState extends State<_SeatSelectionContent> {
  List<int> selectedSeats = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: TheaterSeatLayout(
            screenData: widget.screenData,
            screenId: widget.screenId,
            onSeatTap: _onSeatTap,
            selectedSeats: selectedSeats,
          ),
        ),
        _buildLegend(),
        _buildBottomBar(),
      ],
    );
  }

  void _onSeatTap(int rowIndex, int colIndex) {
    final seatIndex = rowIndex * (widget.screenData['cols'] ?? 0) + colIndex;
    setState(() {
      if (selectedSeats.contains(seatIndex)) {
        selectedSeats.remove(seatIndex);
      } else {
        selectedSeats.add(seatIndex.toInt());
      }
    });
  }

  Widget _buildLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      color: MyColor().darkblue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _legendItem(MyColor().primarycolor, 'Available'),
          _legendItem(Colors.green, 'Selected'),
          _legendItem(Colors.red, 'Sold'),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: MyColor().primarycolor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${selectedSeats.length} seats selected',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          ElevatedButton(
            onPressed: selectedSeats.isNotEmpty ? _proceedToBooking : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
            child: const Text('Proceed to Booking'),
          ),
        ],
      ),
    );
  }

  void _proceedToBooking() {
    const int seatPrice = 100;
    final int totalAmount =
        selectedSeats.length * seatPrice * 100; // Total in paise

    Razorpay razorpay = Razorpay();
    var options = {
      'key': 'rzp_test_aSdoLl3SMxLJpu',
      'amount': totalAmount,
      'name': 'Movie Ticket Booking',
      'description': '${selectedSeats.length} seat(s) @ ₹$seatPrice each',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '7736463266', 'email': 'test@razorpay.com'},
    };

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentErrorResponse);
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccessResponse);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWalletSelected);
    razorpay.open(options);
  }

  void handlePaymentErrorResponse(PaymentFailureResponse response) {
    print(response);
  
  }

void handlePaymentSuccessResponse(PaymentSuccessResponse response) async {
  await _updateSoldSeats();
  Navigator.of(context).push(MaterialPageRoute(builder: (context) {
    return TicketScreen(
      movieName: widget.movieName,
      theaterName: widget.theaterName,
      numberOfSeats: selectedSeats.length,
      seatNumbers: _generateSeatNumbers(),
      date: widget.selectedDate,
      time: widget.selectedTime,
      screenName: widget.screenId,
    );
  }));
  print(response);
}

  List<String> _generateSeatNumbers() {
    return selectedSeats.map((index) {
      int row = index ~/ widget.screenData['cols'];
      num col = index % widget.screenData['cols'];
      String rowLetter = String.fromCharCode(65 + row);
      return '$rowLetter${col + 1}';
    }).toList();
  }

  void handleExternalWalletSelected(ExternalWalletResponse response) {
    print(response);
  }

  Future<void> _updateSoldSeats() async {
    final showingRef = FirebaseFirestore.instance
        .collection('owners')
        .doc(widget.ownerId)
        .collection('screens')
        .doc(widget.screenId)
        .collection('movie_schedules')
        .doc(widget.movieId)
        .collection('showings')
        .doc(
            '${widget.selectedDate.toIso8601String().split('T')[0]}_${widget.selectedTime}');

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      final docSnapshot = await transaction.get(showingRef);
      Map<String, dynamic> showingData = docSnapshot.data() ?? {};
      List<String> seatStates =
          List<String>.from(showingData['seatStates'] ?? []);

      if (seatStates.isEmpty) {
        seatStates = List.filled(
            widget.screenData['rows'] * widget.screenData['cols'],
            SeatState.unselected.toString().split('.').last);
      }

      for (int seatIndex in selectedSeats) {
        if (seatIndex < seatStates.length) {
          seatStates[seatIndex] = SeatState.sold.toString().split('.').last;
        }
      }

      transaction.set(
          showingRef, {'seatStates': seatStates}, SetOptions(merge: true));
    });

    
  }
}
