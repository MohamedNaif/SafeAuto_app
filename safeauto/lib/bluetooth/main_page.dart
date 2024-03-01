import 'dart:convert';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:safeauto/bluetooth/widgets/action_button.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _bluetooth = FlutterBluetoothSerial.instance;
  bool _bluetoothState = false;
  bool _isConnecting = false;
  BluetoothConnection? _connection;
  List<BluetoothDevice> _devices = [];
  BluetoothDevice? _deviceConnected;
  int times = 0;

  void _getDevices() async {
    var res = await _bluetooth.getBondedDevices();
    setState(() => _devices = res);
  }

  void _receiveData() {
    _connection?.input?.listen((event) {
      if (String.fromCharCodes(event) == "p") {
        setState(() => times = times + 1);
      }
    });
  }

  void _sendData(String data) {
    if (_connection?.isConnected ?? false) {
      _connection?.output.add(utf8.encode(data));
    }
  }

  void _requestPermission() async {
    await Permission.location.request();
    await Permission.bluetooth.request();
    await Permission.bluetoothScan.request();
    await Permission.bluetoothConnect.request();
  }

  @override
  void initState() {
    super.initState();

    _requestPermission();

    _bluetooth.state.then((state) {
      setState(() => _bluetoothState = state.isEnabled);
    });

    _bluetooth.onStateChanged().listen((state) {
      if (state == BluetoothState.STATE_OFF) {
        setState(() => _bluetoothState = false);
      } else if (state == BluetoothState.STATE_ON) {
        setState(() => _bluetoothState = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Bluetooth Screen',
          style: TextStyle(
            color:
                Colors.white, // Set text color to white for better visibility
          ),
        ),
        backgroundColor:
            Colors.grey[900], // Set a dark background color for the AppBar
        iconTheme: IconThemeData(
          color: Colors.white, // Set the color of the back arrow to white
        ),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildControlBT(),
              const SizedBox(height: 16.0),
              _buildInfoDevice(),
              const SizedBox(height: 16.0),
              _buildListDevices(),
              const SizedBox(height: 16.0),
              _buildInputSerial(),
              const SizedBox(height: 30.0),
              _buildButtons(),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xff030A10), // Dark background color
    );
  }

  Widget _buildControlBT() {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(16.0), // Adjust the border radius as needed
        color: Colors.grey[800], // Darker color
      ),
      child: SwitchListTile(
        value: _bluetoothState,
        onChanged: (bool value) async {
          if (value) {
            await _bluetooth.requestEnable();
          } else {
            await _bluetooth.requestDisable();
          }
        },
        title: Text(
          _bluetoothState ? "Bluetooth is On" : "Bluetooth is Off",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text color
          ),
        ),
      ),
    );
  }

  Widget _buildInfoDevice() {
    return Container(
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(16.0), // Adjust the border radius as needed
        color: Colors.grey[700], // Darker color
      ),
      child: ListTile(
        title: Text(
          "Connected to: ${_deviceConnected?.name ?? "None"}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text color
          ),
        ),
        trailing: _connection?.isConnected ?? false
            ? TextButton(
                onPressed: () async {
                  await _connection?.finish();
                  setState(() => _deviceConnected = null);
                },
                child: const Text(
                  "Disconnect",
                  style: TextStyle(
                    color: Colors.white, // White text color
                  ),
                ),
              )
            : TextButton(
                onPressed: _getDevices,
                child: const Text(
                  "View Devices",
                  style: TextStyle(
                    color: Colors.white, // White text color
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildListDevices() {
    return _isConnecting
        ? Center(child: CircularProgressIndicator())
        : Container(
            color: Colors.grey[600], // Dark color
            child: Column(
              children: [
                for (final device in _devices)
                  ListTile(
                    title: Text(
                      device.name ?? device.address,
                      style: TextStyle(
                        color: Colors.white, // White text color
                      ),
                    ),
                    trailing: TextButton(
                      child: const Text(
                        'Connect',
                        style: TextStyle(
                          color: Colors.white, // White text color
                        ),
                      ),
                      onPressed: () async {
                        setState(() => _isConnecting = true);
                        _connection =
                            await BluetoothConnection.toAddress(device.address);
                        _deviceConnected = device;
                        _devices = [];
                        _isConnecting = false;
                        _receiveData();
                        setState(() {});
                      },
                    ),
                  ),
              ],
            ),
          );
  }

  Widget _buildInputSerial() {
    return ListTile(
      trailing: TextButton(
        onPressed: () => setState(() => times = 0),
        child: const Text(
          "Restart",
          style: TextStyle(
            color: Colors.white, // White text color
          ),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: Text(
          "Button Pressed (x$times)",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text color
          ),
        ),
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Car Control",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.white, // White text color
          ),
        ),
        const SizedBox(height: 16.0),
        Row(
          children: [
            Expanded(
              child: ActionButton(
                text: "Control the Doors",
                color: const Color(0xFF062A3A),
                textColor: Color.fromARGB(255, 255, 255, 255),
                onTap: () => _sendData("1"),
                fontSize: 18,
              ),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: ActionButton(
                color: const Color(0xFF00E5F9),
                text: "Start the Engine",
                fontSize: 18,
                textColor: const Color(0xFF030F1B),
                onTap: () => _sendData("2"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
