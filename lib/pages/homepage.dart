// ignore_for_file: avoid_print
// MADE BY: NORA ALISSA BINTI ISMAIL (2117862)
// This file contains the implementation of the HomePage widget,
// which is the main page of the application.
// The HomePage widget displays the main content of the application,
// including the attention level graph and buttons for starting and stopping the monitoring session.
// The widget also communicates with the backend server to fetch attention levels and update the graph in real-time.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sada_desktop/providers/device_connection_state.dart';
import 'connect_device.dart';
import 'package:sada_desktop/button_widget.dart';
import 'package:sada_desktop/navbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Import for encoding JSON
import 'package:fl_chart/fl_chart.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String displayText =
      "Monitor Your Study Session!"; // Text displayed on the home page
  bool isMonitoring =
      false; // Boolean to track whether monitoring is in progress
  Timer? _timer; // Timer to track elapsed time
  double elapsedSeconds = 0; // Track the elapsed seconds for the session
  List<FlSpot> _dataPoints = []; // List to store data points for the graph
  Timer? _graphUpdateTimer; // Timer to periodically update the graph
  List<double> _attentionLevels =
      []; // List to store all fetched attention levels

  @override
  void initState() {
    super.initState();
  }

  // Fetches attention level from the backend server
  Future<void> fetchAttentionLevel() async {
    try {
      final response = await http.get(Uri.parse(
          'http://127.0.0.1:5000/attention_level')); // API endpoint to get attention levels

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body); // Decode the JSON response
        print('Response data: $data'); // Debugging print statement
        final attentionLevel =
            data['attention_level']; // Get the current attention level

        // Check if there are multiple attention levels in the response
        if (data['attention_levels'] != null &&
            data['attention_levels'].isNotEmpty) {
          // Save all attention levels to the list
          _attentionLevels = List<double>.from(data['attention_levels']
              .map((level) => level.toDouble())); // Convert to double
          _dataPoints.add(FlSpot(_dataPoints.length.toDouble(),
              attentionLevel)); // Add the new data point to the graph

          // Keep only the last 10 data points for better visualization
          if (_dataPoints.length > 10) {
            _dataPoints.removeAt(0);
          }

          // Normalize X-axis values to keep them within the window (0 to 9)
          for (int i = 0; i < _dataPoints.length; i++) {
            _dataPoints[i] = FlSpot(i.toDouble(), _dataPoints[i].y);
          }

          print(
              'Fetched attention levels: $_attentionLevels'); // Debugging print statement
        } else {
          print('No attention level found');
        }
      } else {
        print('Failed to fetch attention level: ${response.body}');
      }
    } catch (e) {
      print('Error fetching attention level: $e');
    }
  }

  // Send a POST request to the server to stop recording EEG data
  Future<void> stopRecording() async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/stop_recording'),
    );

    if (response.statusCode == 200) {
      print('Recording stopped successfully');
    } else {
      print('Failed to stop recording: ${response.body}');
    }
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  /// Start the monitoring session and update the graph every 3 seconds
  void startMonitoring() {
    setState(() {
      displayText = "Monitoring Attention Level..."; // Update display text
      isMonitoring = true; // Set monitoring status to true
      elapsedSeconds = 0; // Reset elapsed time
    });

    // Start a timer to update elapsed time every second
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds++; // Increment elapsed time
      });
    });

    // Start polling the backend every 3 seconds to fetch attention level data
    _graphUpdateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      fetchAttentionLevel(); // Fetch attention level data
    });
  }

  // Stop the monitoring session and reset the state
  void stopMonitoring() {
    setState(() {
      _timer?.cancel(); // Cancel the elapsed time timer
      _graphUpdateTimer?.cancel(); // Cancel the graph update timer
      isMonitoring = false; // Set monitoring status to false
      elapsedSeconds = 0; // Reset elapsed time
      displayText = "Monitor Your Study Session!"; // Reset display text
      _dataPoints.clear(); // Clear graph data
    });

    stopRecording(); // Stop recording EEG data

    // Show dialog box indicating the session is complete
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Session Complete!"),
          content: const Text(
              "Session is saved and can be viewed in the Session history found at your profile."),
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

  // Show dialog box when EEG headset is not connected
  void showBluetoothDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Bluetooth Not Connected"),
          content: const Text(
              "EEG Headset is not connected. Please connect to your EEG Headset first so we can monitor your EEG signals."),
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

  // Build the UI for the HomePage
  @override
  Widget build(BuildContext context) {
    final connectionState = Provider.of<DeviceConnectionState>(
        context); // Get the connection state from the provider
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor:
            const Color.fromARGB(132, 80, 227, 195), // AppBar background color
        actions: [
          // Button to navigate to the ConnectDevicePage to manage device connections
          IconButton(
            icon: const Icon(Icons.bluetooth_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ConnectDevicePage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(132, 80, 227, 195),
              Color.fromARGB(255, 126, 176, 233),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Display the current text for monitoring status
              Text(
                displayText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Show the "Start" button if monitoring is not active
              if (!isMonitoring)
                ButtonWidget(
                  text: "Start",
                  onClicked: () async {
                    // Check if the EEG headset is connected before starting the session
                    if (!connectionState.bluetoothConnected) {
                      showBluetoothDialog(); // Show dialog if Bluetooth is not connected
                    } else {
                      startMonitoring(); // Start monitoring if Bluetooth is connected
                    }
                  },
                ),
              // Show the monitoring interface if monitoring is active
              if (isMonitoring) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Display the elapsed time
                    Text(
                      "Time Elapsed: ${Duration(seconds: elapsedSeconds.toInt()).toString().split('.').first}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 20),
                    // Stop button to stop monitoring
                    ElevatedButton(
                      onPressed: stopMonitoring,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red, // Red color for the stop button
                      ),
                      child: const Text("Stop"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Display the attention level graph
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Background color of the container
                    borderRadius:
                        BorderRadius.circular(12.0), // Rounded corners
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12, // Shadow color with opacity
                        spreadRadius: 2, // How far the shadow spreads
                        blurRadius: 5, // How soft the shadow appears
                        offset: Offset(0, 3), // Position of the shadow (x, y)
                      ),
                    ],
                  ),
                  width: 800, // Increased width
                  height: 400, // Increased height

                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: LineChart(
                      LineChartData(
                        lineBarsData: [
                          LineChartBarData(
                            spots: _dataPoints,
                            color: Colors.black,
                            isCurved: true,
                            belowBarData: BarAreaData(show: false),
                            dotData: FlDotData(show: false),
                            preventCurveOverShooting: true,
                            gradient: LinearGradient(
                              colors: [
                                Colors.red,
                                Colors.yellow,
                                Colors.green,
                              ], // Gradient colors from bottom to top
                              begin: Alignment
                                  .bottomCenter, // Start from the bottom
                              end: Alignment.topCenter, // End at the top
                            ),
                          )
                        ],
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize:
                                  80, // Increase this value to allow more space for titles
                              getTitlesWidget: (double value, TitleMeta meta) {
                                if (value == 0.5) {
                                  return const Text('Low',
                                      style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold));
                                } else if (value == 1.5) {
                                  return const Text('Moderate',
                                      style: TextStyle(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold));
                                } else if (value == 2.5) {
                                  return const Text('High',
                                      style: TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold));
                                }
                                return const SizedBox.shrink();
                              },
                            ),
                            axisNameSize: 50,
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: false,
                              reservedSize: 30,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                // Format the elapsed seconds with "s" suffix
                                final formattedTime = '${value.toInt()}s';

                                return Text(
                                  formattedTime, // Display formatted time
                                  style: const TextStyle(
                                      color: Colors.blue, fontSize: 12),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            axisNameWidget: Text(
                              "Attention Level Over Time",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            sideTitles: SideTitles(showTitles: false),
                            axisNameSize: 40,
                          ),
                        ),
                        gridData: FlGridData(show: false),
                        minX: 0.0, // Start from the first point
                        maxX: 10.0, // End at the last point
                        minY: 0,
                        maxY: 3,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
