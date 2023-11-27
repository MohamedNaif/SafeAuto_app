import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class LocalAuthApi {
  static final _auth = LocalAuthentication();

  static Future<bool> hasBiometrics() async {
    return await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
  }

  // static Future<List<BiometricType>> getBiometrics() async {
  //   try {
  //     return await _auth.getAvailableBiometrics();
  //   } on PlatformException catch (e) {
  //     return <BiometricType>[];
  //   }
  // }

  static Future<bool> authenticate() async {
    try {
      if (!await hasBiometrics()) return false;
      return await _auth.authenticate(
        options: const AuthenticationOptions(
          useErrorDialogs: true,
          stickyAuth: true,
        ),
        localizedReason: 'Scan Fingerprint to Authenticate',
      );
    } catch (e) {
      return false;
    }
  }
}
