# MADE BY: NORA ALISSA BINTI ISMAIL (2117862)
from quart import Quart, jsonify, request, send_file
from functions import browse_devices, start_streaming, stop_recording, fetch_attention_level
import threading
import os
import time
import random

# Register all routes to the Quart app
def register_routes(app):
    # Route to browse available devices
    @app.route('/browse_devices', methods=['GET'])
    async def browse_devices_route():
        """
        This route handles GET requests to browse available devices.
        It calls the 'browse_devices' function and returns the result as JSON.
        The 'browse_devices' function will scan for nearby devices and filter for Muse devices.
        """
        return jsonify(await browse_devices())  # Return the result of browsing devices as JSON

    # Route to start streaming from a selected device
    @app.route('/start', methods=['POST'])
    async def start_streaming_route():
        """
        This route handles POST requests to start streaming EEG data.
        It expects a JSON payload containing the device name.
        If the device name is missing or invalid, it returns an error message.
        Otherwise, it calls the 'start_streaming' function to initiate the streaming.
        """
        try:
            data = await request.get_json()  # Get the JSON data from the request
            device_name = data.get('device_name')  # Extract the device name from the JSON

            # Check if device_name is provided
            if not device_name:
                return jsonify({"status": "error", "message": "device_name is required"}), 400

            # Start streaming with the given device name
            result = await start_streaming(device_name)  # Call the start_streaming function with the device name
            return jsonify(result)  # Return the result of the streaming attempt as JSON
        except Exception as e:
            # Return an error response if an exception occurs
            return jsonify({"status": "error", "message": str(e)}), 500

    # Route to stop the recording of EEG data
    @app.route('/stop_recording', methods=['POST'])
    async def stop_recording_route():
        """
        This route handles POST requests to stop the EEG recording.
        It calls the 'stop_recording' function and returns a success message.
        In case of failure, it returns an error message.
        """
        try:
            stop_recording()  # Call the stop_recording function to stop the recording
            return jsonify({'status': 'success', 'message': 'Recording stopped'}), 200
        except Exception as e:
            # Return an error response if an exception occurs
            return jsonify({'status': 'error', 'message': str(e)}), 500

    # Route to fetch the current attention level from the system
    @app.route('/attention_level', methods=['GET'])
    async def attention_level_route():
        """
        This route handles GET requests to fetch the current attention level.
        It calls the 'fetch_attention_level' function and returns the result as JSON.
        The 'fetch_attention_level' function predicts attention levels based on EEG data.
        """
        try:
            result = fetch_attention_level()  # Get the attention level from the system
            return jsonify(result)  # Return the attention level as JSON
        except Exception as e:
            # Return an error response if an exception occurs
            return jsonify({'error': str(e)}), 500
