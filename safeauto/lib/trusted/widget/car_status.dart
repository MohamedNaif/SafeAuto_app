import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:safeauto/home/home_screen.dart';

class CarStatus {
  final bool isDoorOpen;
  final bool isEngineOn;

  CarStatus({
    required this.isDoorOpen,
    required this.isEngineOn,
  });
}

class CarStatusOfMyCar extends StatefulWidget {
  @override
  State<CarStatusOfMyCar> createState() => _CarStatusOfMyCarState();
}

class _CarStatusOfMyCarState extends State<CarStatusOfMyCar> {
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _carStatusStream;
  late Stream<DocumentSnapshot<Map<String, dynamic>>> _notificationsStream;

  @override
  void initState() {
    super.initState();
    _carStatusStream = FirebaseFirestore.instance
        .collection('carStatus')
        .doc('status')
        .snapshots();

    _notificationsStream = FirebaseFirestore.instance
        .collection('Notifications')
        .doc('notifications')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170,
      child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: _carStatusStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data?.data() == null) {
            return Center(child: Text('No data available'));
          }
          final carStatusData = snapshot.data!.data()!;
          final carStatus = CarStatus(
            isDoorOpen: carStatusData['isDoorOpen'] ?? false,
            isEngineOn: carStatusData['isEngineOn'] ?? false,
          );

          // Check if the door is open and navigate to home
          // if (carStatus.isDoorOpen) {
          //   Navigator.of(context).pushReplacement(
          //     MaterialPageRoute(builder: (context) => HomeScreen()),
          //   );
          // }

          return Column(
            children: [
              ListTile(
                title: Text(
                  'Door Status: ${carStatus.isDoorOpen ? 'Open' : 'Closed'}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: Icon(Icons.directions_car),
                subtitle: Text(
                  "Your Current Door Status is ${carStatus.isDoorOpen ? 'Open' : 'Closed'}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Engine Status: ${carStatus.isEngineOn ? 'On' : 'Off'}',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                trailing: Icon(Icons.directions_car),
                subtitle: Text(
                  "Your Current Engine Status is ${carStatus.isEngineOn ? 'Open' : 'Closed'}",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
