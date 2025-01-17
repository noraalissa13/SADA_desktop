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
  String displayText = "Monitor Your Study Session!";
  bool isMonitoring = false;
  Timer? _timer;
  double elapsedSeconds = 0;
  List<FlSpot> _dataPoints = [];
  Timer? _graphUpdateTimer;
  List<double> _attentionLevels =
      []; // List to store all fetched attention levels
  int _dataPointCount = 0; // Track the number of data points added

  @override
  void initState() {
    super.initState();
  }

  // Modify fetchAttentionLevel to fetch all attention levels at once
  Future<void> fetchAttentionLevel() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:5000/attention_level'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('Response data: $data'); // Debugging print statement

        if (data['attention_levels'] != null &&
            data['attention_levels'].isNotEmpty) {
          // Save all attention levels to the list
          _attentionLevels = List<double>.from(data['attention_levels']
              .map((level) => level.toDouble())); // Convert to double

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

  Future<void> generateAttentionLevel() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:5000/generate_attention'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final attentionLevel = data['attention_level'];

        // Check if attentionLevel is not null and is a valid number
        if (attentionLevel != null && attentionLevel is double) {
          setState(() {
            // Check if it's the 10th data point and add 0.5
            if (_dataPointCount % 10 == 0) {
              // Add a value of 0.5 for this 5th data point
              _dataPoints.add(FlSpot(_dataPoints.length.toDouble(), 0.5));
            } else {
              // Add the regular attention level data point
              _dataPoints
                  .add(FlSpot(_dataPoints.length.toDouble(), attentionLevel));
            }

            // Keep only the last 10 data points for better visualization
            if (_dataPoints.length > 10) {
              _dataPoints.removeAt(0);
            }

            // Normalize X-axis values to keep them within the window (0 to 9)
            for (int i = 0; i < _dataPoints.length; i++) {
              _dataPoints[i] = FlSpot(i.toDouble(), _dataPoints[i].y);
            }

            _dataPointCount++;
          });
        } else {
          print('Invalid attention level: $attentionLevel');
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

  // Update graph every 3 seconds by iterating over the attention levels
  void startMonitoring() {
    setState(() {
      displayText = "Monitoring Attention Level...";
      isMonitoring = true;
      elapsedSeconds = 0;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        elapsedSeconds++;
      });
    });

    // Start polling the backend every 3 seconds
    _graphUpdateTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      generateAttentionLevel();
    });
  }

  // Stop monitoring and reset
  void stopMonitoring() {
    setState(() {
      _timer?.cancel();
      _graphUpdateTimer?.cancel();
      isMonitoring = false;
      elapsedSeconds = 0;
      displayText = "Monitor Your Study Session!";
      _dataPoints.clear(); // Clear graph data
    });

    stopRecording();

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
                Navigator.of(context).pop();
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
    final connectionState = Provider.of<DeviceConnectionState>(context);
    return Scaffold(
      drawer: const NavBar(),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(132, 80, 227, 195),
        actions: [
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
              Text(
                displayText,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (!isMonitoring)
                ButtonWidget(
                  text: "Start",
                  onClicked: () async {
                    if (!connectionState.bluetoothConnected) {
                      showBluetoothDialog();
                    } else {
                      startMonitoring();
                    }
                  },
                ),
              if (isMonitoring) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Time Elapsed: ${Duration(seconds: elapsedSeconds.toInt()).toString().split('.').first}",
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: stopMonitoring,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text("Stop"),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Display the attention graph
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
