// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:local_auth/local_auth.dart';

// class BiometricService {
//   static final _auth = LocalAuthentication();

//   static Future<bool> hasBiometrics() async {
//     try {
//       return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
//     } on PlatformException catch (e) {
//       print(e); // For debugging, you can log the exception
//       return false;
//     }
//   }

//   static Future<List<BiometricType>> getBiometrics() async {
//     try {
//       return await _auth.getAvailableBiometrics();
//     } on PlatformException catch (e) {
//       print(e); // For debugging, you can log the exception
//       return <BiometricType>[];
//     }
//   }

//   static Future<bool> authenticate() async {
//     final isAvailable = await hasBiometrics();
//     if (!isAvailable) return false;

//     try {
//       return await _auth.authenticate(
//         localizedReason: 'Scan Fingerprint to Authenticate',
//         options: const AuthenticationOptions(
//           useErrorDialogs: true,
//           stickyAuth: true,
//         ),
//       );
//     } on PlatformException catch (e) {
//       print(e); // For debugging, you can log the exception
//       return false;
//     }
//   }
// }
