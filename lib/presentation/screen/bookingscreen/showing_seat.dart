import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie/presentation/constants/color.dart';

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
              foregroundColor: Colors.white, backgroundColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  void _proceedToBooking() {

  }
}


class TheaterSeatLayout extends StatelessWidget {
  final Map<String, dynamic> screenData;
  final String screenId;
  final Function(int, int) onSeatTap;
  final List<int> selectedSeats;

  TheaterSeatLayout({
    required this.screenData,
    required this.screenId,
    required this.onSeatTap,
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    final int rows = screenData['rows'] ?? 0;
    final int cols = screenData['cols'] ?? 0;
    final List<dynamic> seatStates = screenData['seatStates'] as List<dynamic>? ?? [];
    final List<dynamic> seatVisibility = screenData['seatVisibility'] as List<dynamic>? ?? [];
    final List<int> horizontalGaps = List<int>.from(screenData['horizontalGaps'] ?? []);
    final List<int> verticalGaps = List<int>.from(screenData['verticalGaps'] ?? []);

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: EdgeInsets.all(20),
      minScale: 0.5,
      maxScale: 2.0,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(rows, (rowIndex) {
                return Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 20,
                          child: Text(
                            String.fromCharCode(65 + rowIndex),
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        ...List.generate(cols, (colIndex) {
                          final seatIndex = rowIndex * cols + colIndex;
                          final isVisible = seatVisibility.isNotEmpty && seatIndex < seatVisibility.length
                              ? seatVisibility[seatIndex]
                              : true;
                          final seatState = seatStates.isNotEmpty && seatIndex < seatStates.length
                              ? SeatState.values.firstWhere(
                                  (e) => e.toString().split('.').last == seatStates[seatIndex],
                                  orElse: () => SeatState.unselected,
                                )
                              : SeatState.unselected;

                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () => onSeatTap(rowIndex, colIndex),
                                child: SeatSpace(
                                  isVisible: isVisible,
                                  state: seatState,
                                  rowIndex: rowIndex,
                                  colIndex: colIndex,
                                  isSelected: selectedSeats.contains(seatIndex),
                                ),
                              ),
                              if (colIndex < cols - 1)
                                SizedBox(width: horizontalGaps.isNotEmpty ? horizontalGaps[colIndex].toDouble() : 0),
                            ],
                          );
                        }),
                      ],
                    ),
                    if (rowIndex < rows - 1)
                      SizedBox(height: verticalGaps.isNotEmpty ? verticalGaps[rowIndex].toDouble() : 0),
                  ],
                );
              }),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: Image.asset('asset/theaterscreenpng.png', height: 300,width: 300,),
          ),
        ],
      ),
    );
  }
}

class SeatSpace extends StatelessWidget {
  final bool isVisible;
  final SeatState state;
  final int rowIndex;
  final int colIndex;
  final bool isSelected;

  SeatSpace({
    required this.isVisible,
    required this.state,
    required this.rowIndex,
    required this.colIndex,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      margin: EdgeInsets.all(2),
      child: isVisible ? SeatWidget(
        state: state,
        rowIndex: rowIndex,
        colIndex: colIndex,
        isSelected: isSelected,
      ) : null,
    );
  }
}

class SeatWidget extends StatelessWidget {
  final SeatState state;
  final int rowIndex;
  final int colIndex;
  final bool isSelected;

  SeatWidget({
    required this.state,
    required this.rowIndex,
    required this.colIndex,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _getSeatColor(state, isSelected),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(
        child: Text(
          '${String.fromCharCode(65 + rowIndex)}${colIndex + 1}',
          style: TextStyle(
            fontSize: 10,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Color _getSeatColor(SeatState state, bool isSelected) {
    if (isSelected) return Colors.green;
    switch (state) {
      case SeatState.selected:
        return Colors.blue;
      case SeatState.sold:
        return Colors.red;
      case SeatState.disabled:
        return Colors.grey;
      case SeatState.unselected:
      default:
        return MyColor().primarycolor;
    }
  }
}

enum SeatState {
  unselected,
  selected,
  sold,
  disabled,
}