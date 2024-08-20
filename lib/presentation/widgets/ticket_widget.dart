
import 'package:flutter/material.dart';
import 'package:movie/presentation/constants/color.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketData extends StatelessWidget {
    final String movieName;
  final String theaterName;
  final String screenName; // Add this line
  final int numberOfSeats;
  final List<String> seatNumbers;
  final DateTime date;
  final String time;

  const TicketData({
    required this.movieName,
    required this.theaterName,
    required this.screenName, // Add this line
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
        padding:  EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'MovieTix Ticket',
                style: TextStyle(fontFamily: 'Cabin', fontSize: 28),
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                movieName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
           const  SizedBox(height: 10),
            buildInfoRow('Theater Name:', theaterName),
           const  SizedBox(height: 10),
              buildInfoRow('No. of Seats:', numberOfSeats.toString()),
             const  SizedBox(height: 10),
            buildInfoRow('Seat Numbers:', seatNumbers.join(', ')),
             SizedBox(height: 10),
            buildInfoRow('Date:', '${date.day}/${date.month}/${date.year}'),
            SizedBox(height: 10),
            buildInfoRow('Time:', time),
             SizedBox(
               height: 10,
             ),
              buildInfoRow('Screens:', time),

            Center(
              child: Container(
                height: 150,
                width: 150,
                child: QrImageView(data:' $movieName is runing the  $theaterName  at $time  ${date.day}/${date.month}/${date.year}  seats $seatNumbers'
                 ,size:  100,
                  ) ,
              ),
            ),
               const  Center(
              child: Text(  ' Scan hjhthe Qr code'),
            ),
            SizedBox(height: 2,),
            Center(child: ElevatedButton(
  onPressed: () {
    
  },
  child: Text('Save', style: TextStyle(
    color: MyColor().darkblue,
  ),),
  style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(MyColor().primarycolor) ,
    elevation: WidgetStateProperty.all(12),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
)
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
          style: TextStyle(fontWeight: FontWeight.bold),
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