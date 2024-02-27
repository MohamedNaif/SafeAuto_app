import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class Communication {
  FlutterBluetoothSerial? fls;
  BluetoothConnection? connection; // Change to nullable
  BluetoothState bluetoothState = BluetoothState.UNKNOWN;
  String result = '';

  // Connect to the device via Bluetooth
  Future<void> connectBl(String address) async {
    try {
      connection = await BluetoothConnection.toAddress(address);
      print('Connected to the device');

      // Creates a listener to receive data
      connection!.input!.listen(onDataReceived).onDone(() {
        print('Disconnected remotely');
        // Implement any necessary handling for disconnection here
      });
    } catch (error) {
      print('Cannot connect, exception occurred: $error');
      // Implement error handling here
    }
  }

  // When receive information
  void onDataReceived(Uint8List data) {
    // Your onDataReceived implementation remains unchanged
    // Add any necessary processing here
  }

  // To send Message
  Future<void> sendMessage(String text) async {
    text = text.trim();

    if (text.isNotEmpty && connection != null && connection!.isConnected) {
      try {
        connection!.output.add(utf8.encode(text + "\r\n"));
        await connection!.output.allSent;
      } catch (e) {
        print('Error sending message: $e');
        // Implement error handling here
      }
    }
  }

  Future<void> dispose() async {
    if (connection != null && connection!.isConnected) {
      await connection!.finish();
      connection = null;
    }
  }
}
