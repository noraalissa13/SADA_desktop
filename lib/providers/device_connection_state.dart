// MADE BY: NORA ALISSA BINTI ISMAIL (2117862)
// This file contains the DeviceConnectionState provider class,
// which is used to manage the state of the device connection status,
// available devices, and loading state in the application.

import 'package:flutter/material.dart';

class DeviceConnectionState with ChangeNotifier {
  // Stores the current connection status (e.g., 'Connected', 'Not connected', etc.)
  String connectionStatus = 'Not connected';

  // List of available Bluetooth devices that can be connected to
  List<String> availableDevices = [];

  // Flag indicating whether the app is in a loading state (e.g., waiting for a response)
  bool isLoading = false;

  // Flag to check if devices have been fetched from the server
  bool hasFetchedDevices = false;

  // Flag to track if Bluetooth is currently connected
  bool bluetoothConnected = false;

  // Stores the name of the currently selected device
  String selectedDevice = '';

  // Sets the Bluetooth connection status (true = connected, false = disconnected)
  void setBluetoothConnection(bool enabled) {
    bluetoothConnected = enabled;
    // Notify listeners to update the UI or any dependent widgets
    notifyListeners();
  }

  // Sets the connection status message (e.g., 'Connected to device', 'Connection Failed', etc.)
  void setConnectionStatus(String status) {
    connectionStatus = status;
    // Notify listeners to update the UI or any dependent widgets
    notifyListeners();
  }

  // Sets the list of available devices fetched from the server
  void setAvailableDevices(List<String> devices) {
    availableDevices = devices;
    // Mark that devices have been fetched to prevent redundant API calls
    hasFetchedDevices = true;
    // Notify listeners to update the UI or any dependent widgets
    notifyListeners();
  }

  // Sets the loading state to true or false based on the app's current state
  void setLoading(bool loading) {
    isLoading = loading;
    // Notify listeners to update the UI or any dependent widgets
    notifyListeners();
  }

  // Resets the state, clearing the list of available devices and resetting connection status
  void resetState() {
    hasFetchedDevices = false;
    availableDevices = [];
    connectionStatus = 'Not Connected';
    // Notify listeners to update the UI or any dependent widgets
    notifyListeners();
  }

  // Sets the selected device (the device the user chooses to connect to)
  void setSelectedDevice(String device) {
    selectedDevice = device;
    // Notify listeners to update the UI or any dependent widgets
    notifyListeners();
  }
}
