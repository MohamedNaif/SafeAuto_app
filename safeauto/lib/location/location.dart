import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';

import 'widget/bubble.dart';

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String address = '';
  String formattedTimestamp = '';
  bool isLoading = false;

  GlobalKey _bubbleKey = GlobalKey(); // Key for the bubble overlay

  Future<void> _getCoordinatesAndTimestampFromFirebase() async {
    try {
      setState(() {
        isLoading = true;
        address = ''; // Clear the existing address
        formattedTimestamp = ''; // Clear the existing timestamp
      });

      // Fetch coordinates from the specific document in the 'locations' collection
      DocumentSnapshot locationSnapshot = await FirebaseFirestore.instance
          .collection('locations')
          .doc('2aITZ2jCbMpiX9UF2OLU')
          .get();

      // Check if the document contains the required fields
      if (locationSnapshot.exists) {
        Map<String, dynamic> data =
            locationSnapshot.data() as Map<String, dynamic>;

        if (data.containsKey('latitude') && data.containsKey('longitude')) {
          double latitude = data['latitude'] ?? 0.0;
          double longitude = data['longitude'] ?? 0.0;

          // Get address from coordinates
          await _getAddressFromCoordinates(latitude, longitude);
        } else {
          print('Document does not contain latitude and longitude fields');
        }
      } else {
        print('Document not found');
      }
    } catch (e) {
      print("Error fetching coordinates and timestamp from Firebase: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _getAddressFromCoordinates(
      double latitude, double longitude) async {
    try {
      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);
      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark placemark = placemarks[0];
        DateTime currentDateTime = DateTime.now();

        setState(() {
          address =
              "${placemark.street}, ${placemark.locality}, ${placemark.country}";
          formattedTimestamp =
              "Time: ${currentDateTime.day}/${currentDateTime.month}/${currentDateTime.year} at ${currentDateTime.hour}:${currentDateTime.minute}:${currentDateTime.second}";
        });
      } else {
        setState(() {
          address = 'No address found';
          formattedTimestamp = '';
        });
      }
    } catch (e) {
      print("Error during geocoding: $e");
    }
  }

  void _showBubble() {
    final RenderBox overlay =
        Overlay.of(context)!.context.findRenderObject() as RenderBox;

    final RenderBox bubbleBox =
        _bubbleKey.currentContext!.findRenderObject() as RenderBox;

    final Offset position =
        bubbleBox.localToGlobal(Offset.zero, ancestor: overlay);
    final overlayEntry = OverlayEntry(
      builder: (context) => BubbleOverlay(
        position: position,
        address: address,
        timestamp: formattedTimestamp,
      ),
    );

    Overlay.of(context)!.insert(overlayEntry);
  }

  @override
  void initState() {
    _getCoordinatesAndTimestampFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffdfe9ef),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/Map-ui.png',
                ))),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.2,
              child: Icon(
                Icons.directions_car,
                size: MediaQuery.of(context).size.width * 0.15,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.3,
              left: MediaQuery.of(context).size.width * 0.1,
              child: Container(
                key: _bubbleKey,
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.35),
                child: isLoading
                    ? Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: CircularProgressIndicator())
                    : Container(
                        alignment: Alignment.topCenter,
                        width: MediaQuery.of(context).size.width * 0.8,
                        height: MediaQuery.of(context).size.height * 0.15,
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.02),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 5.0,
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Address: $address',
                              style: const TextStyle(fontSize: 16),
                            ),
                            SizedBox(height: 2),
                            Text(
                              ' $formattedTimestamp',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            // SizedBox(height: 40),
                          ],
                        ),
                      ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  _getCoordinatesAndTimestampFromFirebase();
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xff6A63FA)),
                ),
                child: const Text(
                  'Get Address',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
