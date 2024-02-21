// import 'package:flutter/services.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:permission_handler/permission_handler.dart';

// // Replace with your actual sensor name or UUID
// const String sensorName = "YOUR_SENSOR_NAME";
// const String serviceUuid = "YOUR_SERVICE_UUID";
// const String characteristicUuid = "YOUR_CHARACTERISTIC_UUID";

// Future<bool> requestPermissions() async {
//   var locationStatus = await Permission.locationWhenInUse.request();
//   var bluetoothStatus = await Permission.bluetoothScan.request();
//   // Handle permission request results and display appropriate messages
//   return locationStatus == PermissionStatus.granted && bluetoothStatus == PermissionStatus.granted;
// }

// Future<BluetoothDevice> scanAndConnect() async {
//   // Start scanning for devices
//   await FlutterBluePlus.startScan(timeout: Duration(seconds: 5));

//   // Filter discovered devices based on name or UUID
//   final devices = await FlutterBluePlus.getConnectedDevices().where((device) =>
//       device.name.contains(sensorName) ||
//       device.uuid.toString().contains(serviceUuid)).toList();

//   // Select the first matching device
//   final device = devices.first;

//   // Connect to the device
//   await device.connect();

//   return device;
// }

// Future<BluetoothCharacteristic> discoverCharacteristic(BluetoothDevice device) async {
//   await device.discoverServices();

//   // Filter services and characteristics based on UUIDs
//   final service = device.services.firstWhere((service) => service.uuid.toString().contains(serviceUuid));
//   final characteristic = service.characteristics.firstWhere((characteristic) => characteristic.uuid.toString().contains(characteristicUuid));

//   return characteristic;
// }

// void listenForCommands(BluetoothCharacteristic characteristic) {
//   characteristic.valueStream.listen((data) {
//     final asciiString = String.fromCharCodes(data);
//     if (asciiString == "1" || asciiString == "0") {
//       // Handle the received command appropriately (e.g., update UI, trigger actions)
//     } else {
//       // Handle invalid data
//     }
//   });
// }

// main() async {
//   // Request permissions
//   if (!await requestPermissions()) {
//     // Handle permission denied scenario
//     return;
//   }

//   // Scan and connect to the sensor
//   final device = await scanAndConnect();

//   // Discover the characteristic
//   final characteristic = await discoverCharacteristic(device);

//   // Start listening for commands
//   listenForCommands(characteristic);
// }
