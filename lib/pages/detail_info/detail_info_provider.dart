
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:n7bluetooth/services/easy_debounce.dart';
import 'package:n7bluetooth/services/local/local_storage_key.dart';
import 'package:n7bluetooth/services/local/storage.dart';


class DetailInfoProvider with ChangeNotifier {

  DetailInfoProvider(this._storage);

  //#region DI services
  //-----------------
  final Storage _storage;

  //#region Privates properties
  //-----------------
  final String _weightCharacteristicsUUID = '00002a9c-0000-1000-8000-00805f9b34fb';

  //#region Public properties
  //-----------------
  //Bluetooth device
  BluetoothDevice bluetoothDevice;

  //Weight value for display on UI
  double weightValue = 0;

  //List weight chart data perday
  List<double> weightChartData = <double>[0, 0, 0, 0, 0, 0, 0];

  //#region Methods
  //-----------------
  //Read info from BLE device
  Future<void> readInfoFromBLEDevice() async {
    if (bluetoothDevice != null) {
      //Connect to device
      await bluetoothDevice.connect();
      //Get all services of this BLE
      final List<BluetoothService> services = await bluetoothDevice.discoverServices();

      for (final BluetoothService service in services) {
        // Reads all characteristics
        final List<BluetoothCharacteristic> characteristics = service.characteristics;
        for(final BluetoothCharacteristic c in characteristics) {
          if (c.uuid.toString() == _weightCharacteristicsUUID) {
            await c.setNotifyValue(true);
            c.value.listen((List<int> value) {

              weightValue = _calculateWeight(data: value);

              EasyDebounce.debounce('my-weigh-debounce',
                  const Duration(milliseconds: 3000), () {
                        //Save data to local
                        _saveWeightData(weightValue);
                  }
              );
              notifyListeners();
            });
          }

        }
      }

    }
  }

  //Calculate weight from list bytes data
  double _calculateWeight({List<int> data}) {
    if (data.length > 12) {
      return (((data[12] & 0xFF) << 8) | (data[11] & 0xFF)) / 200.0;
    }
    return 0;
  }

  //Save weight data to local
  Future<void> _saveWeightData(double weightValue) async {
    final DateTime date = DateTime.now();

    //Update chart value
    weightChartData[date.weekday] = weightValue;
    notifyListeners();

    switch (date.weekday) {
      case 0:
        await _storage.saveData(LocalStorageKey.sundayWeight, weightValue);
        break;
      case 1:
        await _storage.saveData(LocalStorageKey.mondayWeight, weightValue);
        break;
      case 2:
        await _storage.saveData(LocalStorageKey.tuesdayWeight, weightValue);
        break;
      case 3:
        await _storage.saveData(LocalStorageKey.wednesdayWeight, weightValue);
        break;
      case 4:
        await _storage.saveData(LocalStorageKey.thursdayWeight, weightValue);
        break;
      case 5:
        await _storage.saveData(LocalStorageKey.fridayWeight, weightValue);
        break;
      case 6:
        await _storage.saveData(LocalStorageKey.saturdayWeight, weightValue);
        break;
      default:
        break;
    }

  }

  //Load weight data follow day
  Future<double> _getWeightDataFollowWeekday(int weekDay) async {
    switch (weekDay) {
      case 0:
        return await _storage.getData(LocalStorageKey.sundayWeight) ?? 0.0;
        break;
      case 1:
        return await _storage.getData(LocalStorageKey.mondayWeight) ?? 0.0;
        break;
      case 2:
        return await _storage.getData(LocalStorageKey.tuesdayWeight) ?? 0.0;
        break;
      case 3:
        return await _storage.getData(LocalStorageKey.wednesdayWeight) ?? 0.0;
        break;
      case 4:
        return await _storage.getData(LocalStorageKey.thursdayWeight) ?? 0.0;
        break;
      case 5:
        return await _storage.getData(LocalStorageKey.fridayWeight) ?? 0.0;
        break;
      case 6:
        return await _storage.getData(LocalStorageKey.saturdayWeight) ?? 0.0;
        break;
      default:
        return 0;
        break;
    }
  }

  //Load weight chart data
  Future<void> loadWeightChartData() async {
    for( int i = 0 ; i < 7; i++ ) {
      final double weightData = await _getWeightDataFollowWeekday(i);
      if (weightData != null) {
        weightChartData[i] = weightData;
      }
    }
    notifyListeners();
  }

}