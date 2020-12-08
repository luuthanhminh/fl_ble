
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';

class ScanningDevicesProvider with ChangeNotifier {

  //#region Privates properties
  //-----------------
  //Flutter blue instance
  final FlutterBlue _flutterBlue = FlutterBlue.instance;
  //Bluetooth devices name list
  final List<String> _bluetoothDevicesName = <String>[];

  //#region Public properties
  //-----------------
  //Bluetooth devices list
  List<BluetoothDevice> bluetoothDevices = <BluetoothDevice>[];


  //#region Methods
  //-----------------
  //Start scan BLE devices
  void scanBLEDevices() {
    // Start scanning
    _flutterBlue.startScan(timeout: const Duration(seconds: 4));

    // Listen to scan results
    _flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (final ScanResult r in results) {
        if (!_bluetoothDevicesName.contains(r.device.name)) {
          _bluetoothDevicesName.add(r.device.name);
          bluetoothDevices.add(r.device);
          notifyListeners();
        }
      }
    });
    // Stop scanning
    _flutterBlue.stopScan();
  }



}