import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void showImageSourceDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Choose image source"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: const Text("Camera"),
                onTap: () {
                  getImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
              const Padding(padding: EdgeInsets.all(8.0)),
              GestureDetector(
                child: const Text("Gallery"),
                onTap: () {
                  getImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        ),
      );
    }
  );
}

Future<void> getImage(ImageSource source) async {
  final picker = ImagePicker();
  final pickedFile = await picker.pickImage(source: source);

  if (pickedFile != null) {
    await _uploadImage(pickedFile);
  }
}
Future<void> _uploadImage(XFile xFile) async {
  final User? currentUser = FirebaseAuth.instance.currentUser;
  if (currentUser == null) {
    print("No authenticated user found");
    return;
  }

  try {
    File file = File(xFile.path);
    final ref = FirebaseStorage.instance
        .ref()
        .child('user_images')
        .child('${currentUser.uid}.jpg');

    print("Attempting to upload file...");
    await ref.putFile(file);
    print("File uploaded successfully");

    print("Getting download URL...");
    final url = await ref.getDownloadURL();
    print("Download URL obtained: $url");

    print("Updating Firestore...");
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .update({'profileImageUrl': url});
    print("Firestore updated successfully");

  } catch (e) {
    print("Error uploading image: $e");
    if (e is FirebaseException) {
      print("Firebase error code: ${e.code}");
      print("Firebase error message: ${e.message}");
    }
  }
}