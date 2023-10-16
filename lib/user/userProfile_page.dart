import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  String urlfile = "";

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedFile = result.files.first;
    });
  }

  String generateRandomString({int length = 10}) {
    const chars =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    final result = List<String>.generate(
        length, (index) => chars[random.nextInt(chars.length)]).join();
    return result;
  }

  // Method to show a loading dialog
  void showLoadingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text("Uploading Image..."),
            ],
          ),
        );
      },
    );
  }

  // Method to dismiss the loading dialog
  void dismissLoadingDialog() {
    Navigator.of(context).pop();
  }

  // Method to show an alert dialog
  void showAlert(String title, String msg) {
    Widget continueButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        if (title == "Success") {
          if (urlfile == '') urlfile = "-";
        }
      },
      child: const Text("OK"),
    );

    AlertDialog alert = AlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: [continueButton],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  Future uploadImage() async {
    if (pickedFile != null) {
      String randomFileName = generateRandomString(length: 10);
      Reference storageReference = FirebaseStorage.instance
          .ref()
          .child('user_profile_images/$randomFileName');
      uploadTask = storageReference.putFile(File(pickedFile!.path!));
      // Commented out the setState method
      // setState(() {
      //   urlfile = '';
      // });
      await uploadTask!.whenComplete(() {
        storageReference.getDownloadURL().then((value) {
          // Commented out the setState method
          // setState(() {
          //   urlfile = value;
          // });
          updateDatabase(value); // Call the method to update Firestore
        });
      });
    }
  }

  Widget checkImage() {
    if (pickedFile != null) {
      return Image.file(
        File(pickedFile!.path!),
        width: double.infinity,
        height: 250,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'images/no-image.png',
        fit: BoxFit.cover,
      );
    }
  }

  // Method to show an alert dialog for upload confirmation
  void showAlertDialogUpload(BuildContext context) {
    Widget cancelButton = TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const Text('Cancel'),
    );

    Widget continueButton = TextButton(
      onPressed: () {
        Navigator.of(context).pop();
        uploadImage();
      },
      child: const Text('Continue'),
    );

    AlertDialog alert = AlertDialog(
      title: const Text('Question'),
      content: Text("Are you sure you want to upload this image?"),
      actions: [cancelButton, continueButton],
    );

    showDialog(
      context: context,
      builder: (context) {
        return alert;
      },
    );
  }

  // Method to update Firestore database
  void updateDatabase(String imageUrl) {
    FirebaseFirestore.instance.collection('name').doc('id').update({
      'image_url': imageUrl,
    }).then((value) {
      showAlert("Success", "Image uploaded successfully!");
    }).catchError((error) {
      showAlert("Error", "Failed to update the database.");
    });
  }

  // New method for displaying a progress bar
  Widget progressBar(double progress) {
    return LinearProgressIndicator(value: progress);
  }

  // Build method with the progress bar added
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 195, 171, 235),
        title: const Text('User Profile'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              selectFile();
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(
                  width: 2,
                  color: Colors.grey,
                ),
              ),
              child: checkImage(),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: () {
              selectFile();
            },
            child: const Text('Select Image'),
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton.icon(
            onPressed: () {
              if (pickedFile != null) {
                showAlertDialogUpload(context);
              } else {
                showAlert("Error", "Please select a photo!");
              }
            },
            icon: const Icon(Icons.upload),
            label: const Text('Upload Image'),
          ),
          // Add the progress bar as the last child
          if (uploadTask != null)
            progressBar(uploadTask!.snapshot.bytesTransferred /
                uploadTask!.snapshot.totalBytes),
        ],
      ),
    );
  }
}
