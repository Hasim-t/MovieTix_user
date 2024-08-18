import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:movie/presentation/screen/bookingscreen/seat_layout.dart';
import 'package:movie/presentation/screen/bookingscreen/ticket.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class ShowingSeat extends StatefulWidget {
  final String movieId;
  final String screenId;
  final String ownerId;
  final DateTime selectedDate;
  final String selectedTime;

  const ShowingSeat({
    Key? key,
    required this.movieId,
    required this.screenId,
    required this.ownerId,
    required this.selectedDate,
    required this.selectedTime,
  }) : super(key: key);

  @override
  _ShowingSeatState createState() => _ShowingSeatState();
}

class _ShowingSeatState extends State<ShowingSeat> {
  Map<String, dynamic> screenData = {};
  List<int> selectedSeats = [];

  @override
  void initState() {
    super.initState();
    _loadScreenData();
  }

  Future<void> _loadScreenData() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('owners')
        .doc(widget.ownerId)
        .collection('screens')
        .doc(widget.screenId)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        screenData = docSnapshot.data() as Map<String, dynamic>;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        backgroundColor: MyColor().primarycolor,
        title: Text('Select Seats'),
      ),
      body: Column(
        children: [
          Expanded(
            child: screenData.isNotEmpty
                ? TheaterSeatLayout(
                    screenData: screenData,
                    screenId: widget.screenId,
                    onSeatTap: _onSeatTap,
                    selectedSeats: selectedSeats,
                  )
                : Center(child: CircularProgressIndicator()),
          ),
          _buildLegend(),
          _buildBottomBar(),
        ],
      ),
    );
  }

  void _onSeatTap(int rowIndex, int colIndex) {
    final seatIndex = rowIndex * (screenData['cols'] ?? 0) + colIndex;
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
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
        SizedBox(width: 8),
        Text(label, style: TextStyle(color: Colors.white)),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.all(16),
      color: MyColor().primarycolor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${selectedSeats.length} seats selected',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          ElevatedButton(
            onPressed: selectedSeats.isNotEmpty ? _proceedToBooking : null,
            child: Text('Proceed to Booking'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

 void _proceedToBooking() {
  final int seatPrice = 100; 
  final int totalAmount = selectedSeats.length * seatPrice * 100; // Total in paise

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

  handlePaymentErrorResponse(PaymentFailureResponse response) {
    print(response);
  }

  handlePaymentSuccessResponse(PaymentSuccessResponse response) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return TicketScreen();
    }));
    print(response);
  }

  handleExternalWalletSelected(ExternalWalletResponse response) {
    print(response);
  }
}
