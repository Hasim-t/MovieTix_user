// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter/material.dart';
// import 'package:movie/presentation/screen/profil_screen.dart'; // Import your profile screen

// class Authserviec {
//   // Google sign in
//   Future<UserCredential?> signInWithGoogle(BuildContext context) async {
//     try {
//       // Begin interactive sign in process
//       final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

//       if (gUser != null) {
//         // Obtain auth details from request
//         final GoogleSignInAuthentication gAuth = await gUser.authentication;
//         // Create a new credential for the user
//         final credential = GoogleAuthProvider.credential(
//           accessToken: gAuth.accessToken,
//           idToken: gAuth.idToken,
//         );

//         // Finally, sign in with the credential
//         UserCredential userCredential =
//             await FirebaseAuth.instance.signInWithCredential(credential);

//         // Navigate to profile screen
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => ProfilScreen()), // Replace ProfilScreen() with your actual profile screen widget
//         );

//         return userCredential; // Return user credential if needed
//       }

//       return null;
//     } catch (e) {
//       print('Error signing in with Google: $e');
//       return null;
//     }
//   }
// }
