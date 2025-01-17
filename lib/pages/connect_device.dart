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
  bool get wantKeepAlive => true; // Ensures state persistence

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchDevices();
    });
  }

  Future<void> fetchDevices() async {
    final connectionState =
        Provider.of<DeviceConnectionState>(context, listen: false);

    if (connectionState.hasFetchedDevices) return; // Prevent repeated calls

    connectionState.setLoading(true);

    final url = Uri.parse('http://127.0.0.1:5000/browse_devices');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['status'] == 'success') {
          List<dynamic> devices = responseData['devices'];
          connectionState.setAvailableDevices(List<String>.from(devices));
        } else {
          showErrorDialog(
              responseData['message'] ?? 'Failed to fetch devices.');
        }
      } else {
        showErrorDialog(
            'Failed to fetch devices. Status code: ${response.statusCode}');
      }
    } catch (e) {
      showErrorDialog('An error occurred while fetching devices: $e');
    } finally {
      connectionState.setLoading(false);
    }
  }

  // Function to connect to a selected device
  Future<void> connectToDevice(String device) async {
    final connectionState =
        Provider.of<DeviceConnectionState>(context, listen: false);
    connectionState.setLoading(true);

    final url = Uri.parse('http://127.0.0.1:5000/start');
    final payload = {"device_name": device};

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Check if 'status' key exists in response data
        if (responseData.containsKey('status') &&
            responseData['status'] == 'success') {
          connectionState.setConnectionStatus('Connected to $device');
          connectionState.setBluetoothConnection(true);
          connectionState
              .setSelectedDevice(device); // Update the selected device
          showConnectionSuccessfulDialog();
        } else {
          connectionState.setConnectionStatus('Connection Failed');
          showErrorDialog(responseData['message'] ?? 'Failed to connect.');
        }
      } else {
        connectionState.setConnectionStatus('Connection Failed');
        showErrorDialog(
            'Failed to connect to the device. Status code: ${response.statusCode}');
      }
    } catch (e) {
      connectionState.setConnectionStatus('Connection Error');
      showErrorDialog('An error occurred: $e');
    } finally {
      connectionState.setLoading(false);
    }
  }

  // Function to show connection success dialog
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
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  // Function to show error dialog
  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
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
        title: const Text('Connect Your Device'),
        backgroundColor: const Color.fromARGB(132, 80, 227, 195),
      ),
      body: Consumer<DeviceConnectionState>(
          builder: (context, connectionState, child) {
        return Center(
          child: connectionState.isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 70),
                    const Icon(Icons.bluetooth, size: 200),
                    const SizedBox(height: 30),
                    Text(
                      connectionState.connectionStatus,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () => fetchDevices(),
                      child: const Text('Browse Devices'),
                    ),
                    if (connectionState.availableDevices.isNotEmpty)
                      Expanded(
                        child: ListView.builder(
                          itemCount: connectionState.availableDevices.length,
                          itemBuilder: (context, index) {
                            final device =
                                connectionState.availableDevices[index];
                            return ListTile(
                              title: Text(device),
                              onTap: () => connectToDevice(device),
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
