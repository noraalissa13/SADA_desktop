import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClientPage extends StatefulWidget {
  @override
  _WebSocketClientPageState createState() => _WebSocketClientPageState();
}

class _WebSocketClientPageState extends State<WebSocketClientPage> {
  late WebSocketChannel channel;
  String message = "Waiting for data...";

  @override
  void initState() {
    super.initState();
    // Connect to WebSocket server
    channel = WebSocketChannel.connect(
      Uri.parse('ws://localhost:8765'), // Use the correct server address
    );

    // Listen for incoming messages from the WebSocket server
    channel.stream.listen((data) {
      setState(() {
        message = data; // Update message with data from the server
      });
    });
  }

  @override
  void dispose() {
    channel.sink.close(); // Close the connection when the widget is disposed
    super.dispose();
  }

  // Function to send a message to the WebSocket server
  void sendMessage(String msg) {
    channel.sink.add(msg);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('WebSocket Client')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Server Response: $message'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                sendMessage('start_streaming'); // Send start streaming command
              },
              child: Text('Start Streaming'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                sendMessage('stop_streaming'); // Send stop streaming command
              },
              child: Text('Stop Streaming'),
            ),
          ],
        ),
      ),
    );
  }
}
