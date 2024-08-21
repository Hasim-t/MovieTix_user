import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:ticket_widget/ticket_widget.dart';

class TicketViewScreen extends StatelessWidget {
  final dynamic movieName;
  final String theaterName;
  final int numberOfSeats;
  final List<String> seatNumbers;
  final DateTime date;
  final String time;

  const TicketViewScreen({
    super.key,
    required this.movieName,
    required this.theaterName,
    required this.numberOfSeats,
    required this.seatNumbers,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().darkblue,
      appBar: AppBar(
        backgroundColor: MyColor().primarycolor,
        title: const Text('Ticket'),
      ),
      body: Center(
        child: TicketWidget(
          isCornerRounded: true,
          padding: const EdgeInsets.all(20),
          width: 350,
          height: 560,
          child: TicketViewData(
            movieName: movieName,
            theaterName: theaterName,
            numberOfSeats: numberOfSeats,
            seatNumbers: seatNumbers,
            date: date,
            time: time,
            screenName: 'screen 1',
          ),
        ),
      ),
    );
  }
}

class TicketViewData extends StatelessWidget {
  final String movieName;
  final String theaterName;
  final String screenName;
  final int numberOfSeats;
  final List<String> seatNumbers;
  final DateTime date;
  final String time;

  const TicketViewData({
    required this.movieName,
    required this.theaterName,
    required this.screenName,
    required this.numberOfSeats,
    required this.seatNumbers,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColor().white,
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'MovieTix Ticket',
                style:  TextStyle(fontFamily: 'Cabin', fontSize: 28),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                movieName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 10),
            buildInfoRow('Theater Name:', theaterName),
            SizedBox(height: 10),
            buildInfoRow('No. of Seats:', numberOfSeats.toString()),
            SizedBox(height: 10),
            buildInfoRow('Seat Numbers:', seatNumbers.join(', ')),
            SizedBox(height: 10),
            buildInfoRow('Date:', '${date.day}/${date.month}/${date.year}'),
            SizedBox(height: 10),
            buildInfoRow('Time:', time),
            SizedBox(height: 10),
            buildInfoRow('Screens:', screenName),
            Center(
              child: Container(
                height: 150,
                width: 150,
                child: QrImageView(
                  data:
                      '$movieName is running at $theaterName at $time on ${date.day}/${date.month}/${date.year} seats $seatNumbers',
                  size: 100,
                ),
              ),
            ),
            Center(
              child: Text('Scan the QR code'),
            ),
            SizedBox(height: 2),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: MyColor().darkblue,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(MyColor().primarycolor),
                  elevation: WidgetStateProperty.all(12),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            overflow: TextOverflow.fade,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
