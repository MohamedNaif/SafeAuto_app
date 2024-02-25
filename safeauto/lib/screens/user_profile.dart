import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart'; // Added image_picker import

import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import 'my_image_screen.dart';
import 'package:path_provider/path_provider.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  List<File> _selectedImages = [];

  List<String> _imageUrls = [];

  @override
  void initState() {
    super.initState();
    // Fetch and set images URLs when the widget is initialized
    fetchAndSetImageUrls();
  }

  Future<void> fetchAndSetImageUrls() async {
    try {
      // Get the current user's ID
      var userId = FirebaseAuth.instance.currentUser!.uid;

      // Get a reference to the folder where user's images are stored
      var refStorage = FirebaseStorage.instance.ref().child('Trusted');

      // List all items in the folder
      var result = await refStorage.listAll();

      // Iterate through the items and fetch download URLs
      for (var imageRef in result.items) {
        var url = await imageRef.getDownloadURL();
        _imageUrls.add(url);
      }

      // Update the UI
      setState(() {});
    } catch (e) {
      print("Failed to fetch image URLs from Firebase Storage: $e");
    }
  }

  Future<void> getImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    if (image != null) {
      setState(() {
        _selectedImages.add(File(image.path));
      });
    }
  }

  Future<void> uploadImagesToFirebaseStorage() async {
    try {
      // var userId = FirebaseAuth.instance.currentUser!.uid;
      for (var imageFile in _selectedImages) {
        String imageName = basename(imageFile.path);
        var refStorage =
            FirebaseStorage.instance.ref().child('Trusted/$imageName');
        await refStorage.putFile(imageFile);
        String downloadURL = await refStorage.getDownloadURL();
        print("Image uploaded to Firebase Storage. Download URL: $downloadURL");
      }
    } catch (e) {
      print("Failed to upload images to Firebase Storage: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get current user
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email ?? '';

    return Scaffold(
      backgroundColor: const Color(0xff030A10),
      appBar: AppBar(
        backgroundColor: const Color(0xff030A10),
        title: Text(
          'User Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              GoogleSignIn googleSignIn = GoogleSignIn();
              googleSignIn.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
              size: 25,
            ),
          ),
        ],
      ),
      // Your existing scaffold code
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: 320,
                  width: 300,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    color: Color.fromARGB(44, 74, 91, 92),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          SizedBox(height: 10),
                          Icon(
                            size: 40,
                            Icons.assignment_ind_rounded,
                            color: const Color(0xFF00E5F9),
                          ),
                          SizedBox(height: 5),
                          Text(
                            email, // User's email
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 15),
                          CarStatusOfMyCar()
                        ],
                      ),
                    ),
                  ),
                ),
                // Your existing UI widgets
                SizedBox(height: 50),
                Text(
                  'Add a picture of the people allowed to use the car',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return SafeArea(
                          child: Wrap(
                            children: <Widget>[
                              ListTile(
                                leading: Icon(Icons.photo_library),
                                title: Text('Choose from gallery'),
                                onTap: () async {
                                  await getImage(ImageSource.gallery);
                                  await uploadImagesToFirebaseStorage();
                                  // Fetch and set image URLs again
                                  await fetchAndSetImageUrls();
                                  Navigator.pop(context);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.photo_camera),
                                title: Text('Take a picture'),
                                onTap: () async {
                                  await getImage(ImageSource.camera);
                                  await uploadImagesToFirebaseStorage();
                                  // Fetch and set image URLs again
                                  await fetchAndSetImageUrls();
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    'Add a picture',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SelectedImageScreen(
                          imageUrls: _imageUrls,
                        ),
                      ),
                    );
                  },
                  child: Text('View Selected Images'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

  @override
  void initState() {
    super.initState();
    _carStatusStream = FirebaseFirestore.instance
        .collection('carStatus')
        .doc('status')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 170, // Set a fixed height to avoid infinite size error
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
