import 'dart:async';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:path/path.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart'; // Added image_picker import

import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import 'my_image_screen.dart';

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
      var refStorage = FirebaseStorage.instance.ref().child('users/$userId');

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
      var userId = FirebaseAuth.instance.currentUser!.uid;
      for (var imageFile in _selectedImages) {
        String imageName = basename(imageFile.path);
        var refStorage =
            FirebaseStorage.instance.ref().child('users/$userId/$imageName');
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
                  height: 350,
                  width: 300,
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    color: const Color(0xFF00E5F9),
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundColor: const Color(0xFF062A3A),
                            radius: 55,
                            child: CircleAvatar(
                              radius: 50,
                              // backgroundImage: AssetImage(
                              //     'assets/images/photo_2023-12-14_16-40-34.jpg'),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(
                            userName.text, // User's name
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            email ?? '', // User's email
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
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
