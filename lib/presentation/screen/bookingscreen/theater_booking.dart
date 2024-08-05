import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
class TheaterBookingScreen extends StatefulWidget {
  final String movieId;

  TheaterBookingScreen({required this.movieId});

  @override
  _TheaterBookingScreenState createState() => _TheaterBookingScreenState();
}

class _TheaterBookingScreenState extends State<TheaterBookingScreen> {
  late DateTime _selectedDate;
  List<DateTime> _availableDates = [];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadAvailableDates();
  }

  void _loadAvailableDates() {
    _availableDates = List.generate(7, (index) => DateTime.now().add(Duration(days: index)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0F1B2B),
      appBar: AppBar(
        backgroundColor: Color(0xFF24FBFE),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF0F1B2B)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Book Tickets', style: TextStyle(color: Color(0xFF0F1B2B))),
      ),
      body: Column(
        children: [
          // Date selection (unchanged)
          Container(
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _availableDates.length,
              itemBuilder: (context, index) {
                final date = _availableDates[index];
                final isSelected = date.day == _selectedDate.day &&
                    date.month == _selectedDate.month &&
                    date.year == _selectedDate.year;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                      });
                    },
                    child: Container(
                      width: 60,
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF24FBFE) : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFF24FBFE)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            DateFormat('dd').format(date),
                            style: TextStyle(
                              color: isSelected ? Color(0xFF0F1B2B) : Color(0xFF24FBFE),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            DateFormat('MMM').format(date),
                            style: TextStyle(
                              color: isSelected ? Color(0xFF0F1B2B) : Color(0xFF24FBFE),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Theater list
         
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('owners').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                final owners = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: owners.length,
                  itemBuilder: (context, index) {
                    final owner = owners[index];
                    final ownerData = owner.data() as Map<String, dynamic>;
                    return FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('owners')
                          .doc(owner.id)
                          .collection('screens')
                          .get(),
                      builder: (context, screensSnapshot) {
                        if (screensSnapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (screensSnapshot.hasError) {
                          return Center(child: Text('Error: ${screensSnapshot.error}'));
                        }
                        final screens = screensSnapshot.data!.docs;
                        return Column(
                          children: screens.map((screen) {
                            final screenData = screen.data() as Map<String, dynamic>;
                            return TheaterCard(
                              screenName: screenData['name'] ?? 'Screen ${screen.id}',
                              ownerName: ownerData['name'] ?? 'Owner ${owner.id}',
                              movieId: widget.movieId,
                              screenId: screen.id,
                              ownerId: owner.id,
                              selectedDate: _selectedDate,
                            );
                          }).toList(),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class TheaterCard extends StatelessWidget {
  final String screenName;
  final String ownerName;
  final String movieId;
  final String screenId;
  final String ownerId;
  final DateTime selectedDate;

  TheaterCard({
    required this.screenName,
    required this.ownerName,
    required this.movieId,
    required this.screenId,
    required this.ownerId,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color(0xFF1C3049),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$screenName - $ownerName',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('owners')
                  .doc(ownerId)
                  .collection('screens')
                  .doc(screenId)
                  .collection('movie_schedules')
                  .doc(movieId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  print('Error fetching data: ${snapshot.error}');
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  print('No data found for movieId: $movieId, screenId: $screenId, ownerId: $ownerId');
                  return Text('No showtimes available', style: TextStyle(color: Colors.white));
                }

                final scheduleData = snapshot.data!.data() as Map<String, dynamic>?;
                print('Fetched data: $scheduleData');

                if (scheduleData == null || !scheduleData.containsKey('schedules')) {
                  return Text('No schedules available', style: TextStyle(color: Colors.white));
                }

                final schedules = scheduleData['schedules'] as Map<String, dynamic>;
                final selectedDateString = DateFormat('yyyy-MM-dd').format(selectedDate);
                
                // Find the matching date in the schedules
                final matchingDate = schedules.keys.firstWhere(
                  (date) => date.startsWith(selectedDateString),
                  orElse: () => '',
                );

                final showtimes = schedules[matchingDate] as List<dynamic>? ?? [];

                if (showtimes.isEmpty) {
                  return Text('No showtimes available for ${DateFormat('MMMM d, yyyy').format(selectedDate)}', 
                               style: TextStyle(color: Colors.white));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Showtimes for ${DateFormat('MMMM d, yyyy').format(selectedDate)}:',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: showtimes.map((time) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF24FBFE),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        child: Text(
                          time.toString(),
                          style: TextStyle(color: Color(0xFF0F1B2B))
                        ),
                        onPressed: () {
                          print('Showtime selected: $time');
                          // Add your booking logic here
                        },
                      )).toList(),
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}