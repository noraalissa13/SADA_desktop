import 'package:flutter/material.dart';

class DeviceConnectionState with ChangeNotifier {
  String connectionStatus = 'Not connected';
  List<String> availableDevices = [];
  bool isLoading = false;
  bool hasFetchedDevices = false;
  bool bluetoothConnected = false;
  String selectedDevice = '';

  void setBluetoothConnection(bool enabled) {
    bluetoothConnected = enabled;
    notifyListeners();
  }

  void setConnectionStatus(String status) {
    connectionStatus = status;
    notifyListeners();
  }

  void setAvailableDevices(List<String> devices) {
    availableDevices = devices;
    hasFetchedDevices = true; // Mark as fetched
    notifyListeners();
  }

  void setLoading(bool loading) {
    isLoading = loading;
    notifyListeners();
  }

  void resetState() {
    hasFetchedDevices = false;
    availableDevices = [];
    connectionStatus = 'Not Connected';
    notifyListeners();
  }

  void setSelectedDevice(String device) {
    selectedDevice = device;
    notifyListeners();
  }
}
