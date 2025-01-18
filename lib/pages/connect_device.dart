// MADE BY: NORA ALISSA BINTI ISMAIL (2117862)
// This file contains the ConnectDevicePage widget,
// which allows users to connect to a Bluetooth device.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert'; // To decode JSON response
import 'package:sada_desktop/providers/device_connection_state.dart';
import 'package:http/http.dart' as http;

class ConnectDevicePage extends StatefulWidget {
  const ConnectDevicePage({super.key});

  @override
  _ConnectDevicePageState createState() => _ConnectDevicePageState();
}

class _ConnectDevicePageState extends State<ConnectDevicePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive =>
      true; // Ensures state persistence across widget rebuilds

  @override
  void initState() {
    super.initState();
    // Fetch devices once the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDevices();
    });
  }

  // Function to fetch the list of available Bluetooth devices from the backend
  Future<void> fetchDevices() async {
    final connectionState =
        Provider.of<DeviceConnectionState>(context, listen: false);

    if (connectionState.hasFetchedDevices) return; // Prevent repeated calls

    connectionState.setLoading(true); // Show loading indicator

    final url =
        Uri.parse('http://127.0.0.1:5000/browse_devices'); // Backend URL
    try {
      final response = await http.get(url); // HTTP GET request to fetch devices

      if (response.statusCode == 200) {
        final responseData =
            json.decode(response.body); // Decode the JSON response

        // Check if the response is successful
        if (responseData['status'] == 'success') {
          List<dynamic> devices =
              responseData['devices']; // List of available devices
          connectionState.setAvailableDevices(
              List<String>.from(devices)); // Update the available devices list
        } else {
          showErrorDialog(responseData['message'] ??
              'Failed to fetch devices.'); // Show error if the status is not success
        }
      } else {
        showErrorDialog(
            'Failed to fetch devices. Status code: ${response.statusCode}'); // Show error for unsuccessful HTTP status
      }
    } catch (e) {
      showErrorDialog(
          'An error occurred while fetching devices: $e'); // Show error in case of an exception
    } finally {
      connectionState
          .setLoading(false); // Hide loading indicator after the request
    }
  }

  // Function to connect to a selected Bluetooth device
  Future<void> connectToDevice(String device) async {
    final connectionState =
        Provider.of<DeviceConnectionState>(context, listen: false);
    connectionState.setLoading(true); // Show loading indicator

    final url = Uri.parse(
        'http://127.0.0.1:5000/start'); // Backend URL to start connection
    final payload = {
      "device_name": device
    }; // Payload with the selected device name

    try {
      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json"
        }, // Set content type to JSON
        body: jsonEncode(payload), // Send the device name as JSON
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body); // Decode the response

        // Check if 'status' key exists and is 'success'
        if (responseData.containsKey('status') &&
            responseData['status'] == 'success') {
          connectionState.setConnectionStatus(
              'Connected to $device'); // Update connection status
          connectionState
              .setBluetoothConnection(true); // Set Bluetooth connection to true
          connectionState
              .setSelectedDevice(device); // Update the selected device
          showConnectionSuccessfulDialog(); // Show success dialog
        } else {
          connectionState.setConnectionStatus(
              'Connection Failed'); // Update connection status on failure
          showErrorDialog(responseData['message'] ??
              'Failed to connect.'); // Show error message
        }
      } else {
        connectionState.setConnectionStatus(
            'Connection Failed'); // Update connection status on failure
        showErrorDialog(
            'Failed to connect to the device. Status code: ${response.statusCode}'); // Show error for unsuccessful HTTP status
      }
    } catch (e) {
      connectionState.setConnectionStatus(
          'Connection Error'); // Update connection status on exception
      showErrorDialog('An error occurred: $e'); // Show error message
    } finally {
      connectionState
          .setLoading(false); // Hide loading indicator after the request
    }
  }

  // Function to show a dialog when the connection is successful
  void showConnectionSuccessfulDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Connection Successful!"),
          content: const Text(
              "Head back to the home page to start monitoring your study session."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to show an error dialog with a custom message
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message), // Display the error message
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Your Device'), // App bar title
        backgroundColor:
            const Color.fromARGB(132, 80, 227, 195), // App bar color
      ),
      body: Consumer<DeviceConnectionState>(
          // Listen to changes in the connection state
          builder: (context, connectionState, child) {
        return Center(
          child: connectionState.isLoading
              ? const CircularProgressIndicator() // Show loading indicator if loading
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 70),
                    const Icon(Icons.bluetooth, size: 200), // Bluetooth icon
                    const SizedBox(height: 30),
                    Text(
                      connectionState
                          .connectionStatus, // Display connection status
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () =>
                          fetchDevices(), // Fetch devices when button is pressed
                      child: const Text('Browse Devices'),
                    ),
                    if (connectionState.availableDevices.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: connectionState.availableDevices
                              .length, // List of available devices
                          itemBuilder: (context, index) {
                            final device =
                                connectionState.availableDevices[index];
                            return ListTile(
                              title: Text(device), // Display device name
                              onTap: () => connectToDevice(
                                  device), // Connect to the device when tapped
                            );
                          },
                        ),
                      ),
                  ],
                ),
        );
      }),
    );
  }
}
