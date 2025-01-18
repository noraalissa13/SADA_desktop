# MADE BY: NORA ALISSA BINTI ISMAIL (2117862)
import asyncio
import threading
import logging
from pylsl import StreamInlet, resolve_byprop  # Library for streaming EEG data from LSL (Lab Streaming Layer)
from bleak import BleakScanner, BleakClient  # Library for Bluetooth communication (Muse device)
from firebase_api import save_eeg_data_to_firestore, read_raw_eeg_from_firestore, save_processed_eeg_to_firestore, read_processed_eeg_from_firestore  # Functions for interacting with Firestore
import uuid
import time
import numpy as np
import pandas as pd
from tensorflow.keras.models import load_model  # For loading pre-trained LSTM model
from sklearn.preprocessing import StandardScaler  # For data scaling before prediction
import matplotlib.pyplot as plt  # For visualizing data
import io
import mne  # For EEG data preprocessing
from IPython.display import display, Javascript  # For displaying interactive visualizations in Jupyter notebooks
from playsound import playsound  # For playing sound alerts

# Configure logging for debugging and informational messages
logging.basicConfig(level=logging.INFO)

# Global variables for device management, streaming, and data processing
muses = []  # List of discovered Muse devices
is_streaming = False  # Flag to check if streaming is active
recording_thread = None  # Thread object for recording
recording_lock = asyncio.Lock()  # Asynchronous lock for thread-safe operations
stream_inlet = None  # Inlet for receiving EEG data
data_points = []  # Stores predicted attention levels for visualization
last_alert_time = None  # Global variable to track the last alert time
threshold_time = 300  # 5 minutes cooldown for alert repetition

# Load the pre-trained LSTM model for attention level prediction
model = load_model('lstm_model.keras')  # Load the LSTM model for attention level prediction
scaler = StandardScaler()  # Initialize the scaler for feature scaling

# Asynchronous function to discover nearby Muse devices via Bluetooth
async def browse_devices():
    """
    Discovers nearby Bluetooth devices and filters for Muse devices.

    Returns:
        dict: Contains the discovered Muse devices or an error message.
    """
    global muses
    try:
        devices = await BleakScanner.discover(timeout=10)  # Scan for Bluetooth devices for 10 seconds
        muses = [device for device in devices if device.name and "Muse" in device.name]  # Filter Muse devices
        if muses:
            return {"status": "success", "devices": [device.name for device in muses]}  # Return list of Muse devices
        else:
            return {"status": "error", "message": "No Muse devices found"}  # Return error if no Muse devices found
    except Exception as e:
        logging.error(f"Error fetching devices: {e}")
        return {"status": "error", "message": str(e)}

# Asynchronous function to start streaming EEG data from a selected Muse device
async def start_streaming(device_name):
    """
    Initiates EEG data streaming from a selected Muse device.

    Args:
        device_name (str): The name of the Muse device to stream from.

    Returns:
        dict: Status of the streaming operation.
    """
    global is_streaming
    try:
        if not device_name:
            return {'status': 'error', 'message': 'Device name is missing'}

        logging.info(f"Received request to start streaming from device: {device_name}")

        # Find the target device in the list of discovered Muse devices
        target_device = next((device for device in muses if device.name == device_name), None)
        if not target_device:
            logging.error(f"Device {device_name} not found")
            return {'status': 'error', 'message': 'Device not found'}

        async with recording_lock:  # Ensure thread-safe access
            if is_streaming:
                logging.info("Streaming is already in progress")
                return {'status': 'error', 'message': 'Streaming is already in progress'}
            is_streaming = True  # Set streaming flag to True

        start_stream(target_device.address)  # Start the streaming process by calling start_stream
        logging.info(f"Started streaming from device: {device_name}")
        return {'status': 'success', 'message': f'Streaming started for {device_name}'}
    except Exception as e:
        logging.error(f"Error: {e}")
        return {'status': 'error', 'message': str(e)}

# Function to handle the event loop for starting asynchronous streaming
def start_stream(address):
    """
    Handles the event loop for starting asynchronous streaming.

    Args:
        address (str): The Bluetooth address of the Muse device.
    """
    loop = asyncio.get_event_loop()
    if loop.is_running():
        loop.create_task(async_stream(address))  # Add the task to the running loop
    else:
        loop.run_until_complete(async_stream(address))  # Run the event loop if not already running

# Asynchronous function to connect to a Muse device and stream EEG data
async def async_stream(address):
    """
    Asynchronously connects to a Muse device and starts streaming EEG data.

    Args:
        address (str): The Bluetooth address of the Muse device.
    """
    global is_streaming
    try:
        print(f"Connecting to Muse: {address}...")
        async with BleakClient(address, timeout=30) as client:
            await client.connect()  # Connect to the Muse device
            print(f"Connected to Muse: {address}")
            
            # Define Firestore collection and document naming scheme
            collection_name = "eeg_data_stream"
            
            async for raw_data in stream(address):  # Assuming stream yields raw EEG data
                print(f"Received EEG data: {raw_data}")
                
                # Preprocess the raw EEG data
                processed_data = preprocess_eeg_data(raw_data)
                
                # Create a unique document ID (e.g., timestamp-based)
                document_id = f"eeg_{int(time.time() * 1000)}"
                
                # Save processed EEG data to Firestore
                save_eeg_data_to_firestore(collection_name, document_id, processed_data)

            print(f"Streaming completed for device at {address}")
    except Exception as e:
        print(f"Error during streaming: {e}")
    finally:
        is_streaming = False  # Reset the streaming flag when streaming ends

# Function to stop the ongoing recording thread safely
def stop_recording():
    """
    Stops the ongoing recording thread safely.
    """
    global recording_thread
    with recording_lock:
        if recording_thread and recording_thread.is_alive():
            recording_thread.join()  # Wait for the thread to finish
            recording_thread = None

# Function to preprocess EEG data and extract features
def preprocess_eeg_data():
    """
    Preprocess EEG data and extract features.

    """
    # Fetch raw EEG data from Firestore
    raw_data = read_raw_eeg_from_firestore("eeg_raw_data", "session_1")
    if raw_data is None:
        return

    # Convert raw EEG data to MNE RawArray format for processing
    ch_names = ["TP9", "AF7", "AF8", "TP10"]
    ch_types = ["eeg"] * len(ch_names)
    info = mne.create_info(ch_names=ch_names, sfreq=256, ch_types=ch_types)
    raw = mne.io.RawArray(raw_data.values.T, info)

    # Apply bandpass filter (1-30 Hz) and ICA (Independent Component Analysis) for artifact removal
    raw.filter(1, 30, fir_design='firwin')
    ica = mne.preprocessing.ICA(n_components=4, random_state=97, max_iter=800)
    ica.fit(raw)
    raw = ica.apply(raw)

    # Extract frequency band features (delta, theta, alpha, beta)
    bands = {"delta": (0.5, 4), "theta": (4, 8), "alpha": (8, 13), "beta": (13, 30)}
    features = {}
    for band, (low, high) in bands.items():
        band_data = raw.copy().filter(low, high).get_data()  # Apply bandpass filter for each band
        features[band] = band_data.mean(axis=1)  # Calculate the mean for each channel

    # Save processed EEG data to Firestore
    processed_data = pd.DataFrame(features)
    save_processed_eeg_to_firestore("eeg_processed_data", "session_1", processed_data)

# Function to fetch attention levels using the pre-trained LSTM model
def fetch_attention_level():
    """
    Predicts attention levels using the pre-trained LSTM model and stores the results.

    Returns:
        dict: Contains the predicted attention levels or an error message.
    """
    processed_data = read_processed_eeg_from_firestore("eeg_processed_data", "session_1")
    global data_points
    try:
        # Scale the data before feeding it to the LSTM model
        data = scaler.transform(processed_data)
        sequences = np.array([data[i : i + 30] for i in range(len(data) - 30)])  # Create sequences of 30 samples
        predictions = lstm_model.predict(sequences)  # Get predictions from the LSTM model
        labels = ["Low", "Moderate", "High"]
        attention_levels = [labels[np.argmax(pred)] for pred in predictions]  # Get the highest prediction label
    
        # Store the attention levels and trigger alert for low attention
        for level in attention_levels:
            score = {"Low": 0.5, "Moderate": 1.5, "High": 3.0}[level]
            data_points.append(score)
    
            if score == 0.5:
                attention_alert()
        
        return {'attention_levels': data_points}  # Return the attention levels
    except Exception as e:
        logging.error(f"Error in fetch_attention_level: {e}")
        return {'error': str(e)}

# Asynchronous wrapper for fetch_attention_level to avoid blocking the event loop
async def fetch_attention_level_async():
    loop = asyncio.get_event_loop()
    return await loop.run_in_executor(None, fetch_attention_level)

# Function to check attention levels and trigger alerts if necessary
def attention_alert(sound_file='attention_low.mp3'):
    global last_alert_time  # Referencing the global variable for last alert time

    # Check if enough time has passed since the last alert (to avoid repeated alerts)
    current_time = datetime.now()        
    if last_alert_time is None or (current_time - last_alert_time).seconds > threshold_time:
        last_alert_time = current_time
        logging.info("Attention level is low. Triggering alert.")

        # Play sound alert
        try:
            playsound(sound_file)
        except Exception as e:
            print(f"Error playing sound: {e}")
            # Fallback sound if the specified sound file doesn't exist
            try:
                playsound('fallback_sound.mp3')
            except Exception as e:
                print(f"Error with fallback sound: {e}")

        # Update the last alert time
        last_alert_time = current_time
