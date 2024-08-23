
import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';

class TheaterSeatLayout extends StatelessWidget {
  final Map<String, dynamic> screenData;
  final String screenId;
  final Function(int, int) onSeatTap;
  final List<int> selectedSeats;

 const  TheaterSeatLayout({super.key,
    required this.screenData,
    required this.screenId,
    required this.onSeatTap,
    required this.selectedSeats,
  });

  @override
  Widget build(BuildContext context) {
    final int rows = screenData['rows'] ?? 0;
    final int cols = screenData['cols'] ?? 0;
    final List<dynamic> seatStates =
        screenData['seatStates'] as List<dynamic>? ?? [];
    final List<dynamic> seatVisibility =
        screenData['seatVisibility'] as List<dynamic>? ?? [];
    final List<int> horizontalGaps =
        List<int>.from(screenData['horizontalGaps'] ?? []);
    final List<int> verticalGaps =
        List<int>.from(screenData['verticalGaps'] ?? []);

    return InteractiveViewer(
      constrained: false,
      boundaryMargin: const EdgeInsets.all(20),
      minScale: 0.5,
      maxScale: 2.0,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
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
                            style:  TextStyle(
                                color: MyColor().white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ...List.generate(cols, (colIndex) {
                        final seatIndex = rowIndex * cols + colIndex;
                        final isVisible = seatVisibility.isNotEmpty &&
                                seatIndex < seatVisibility.length
                            ? seatVisibility[seatIndex]
                            : true;
                        final seatState = seatStates.isNotEmpty &&
                                seatIndex < seatStates.length
                            ? SeatState.values.firstWhere(
                                (e) =>
                                    e.toString().split('.').last ==
                                    seatStates[seatIndex],
                                orElse: () => SeatState.unselected,
                              )
                            : SeatState.unselected;

                        return Row(
                          children: [
                            GestureDetector(
                              onTap: seatState != SeatState.sold
                                  ? () => onSeatTap(rowIndex, colIndex)
                                  : null,
                              child: SeatSpace(
                                isVisible: isVisible,
                                state: seatState,
                                rowIndex: rowIndex,
                                colIndex: colIndex,
                                isSelected: selectedSeats.contains(seatIndex),
                                ),
                              ),
                              if (colIndex < cols - 1)
                                SizedBox(
                                    width: horizontalGaps.isNotEmpty
                                        ? horizontalGaps[colIndex].toDouble()
                                        : 0),
                            ],
                          );
                        }),
                      ],
                    ),
                    if (rowIndex < rows - 1)
                      SizedBox(
                          height: verticalGaps.isNotEmpty
                              ? verticalGaps[rowIndex].toDouble()
                              : 0),
                  ],
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Image.asset(
              'asset/theaterscreenpng.png',
              height: 300,
              width: 300,
            ),
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
 
  const SeatSpace({super.key, 
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
      margin: const EdgeInsets.all(2),
      child: isVisible
          ? SeatWidget(
              state: state,
              rowIndex: rowIndex,
              colIndex: colIndex,
              isSelected: isSelected,
            )
          : null,
    );
  }
}

class SeatWidget extends StatelessWidget {
  final SeatState state;
  final int rowIndex;
  final int colIndex;
  final bool isSelected;

  const SeatWidget({super.key, 
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
          style:  TextStyle(
            fontSize: 10,
            color:MyColor().white,
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
