import time
import csv
import threading
from muselsl import stream  # Importing MuseLSL library for EEG streaming
from pylsl import StreamInlet, resolve_streams  # Importing LSL (Lab Streaming Layer) libraries

##HAYANI NAZURAH HASRAM 2117628
##NORA ALISSA BINTI ISMAIL 2117862

##This python script is to record and save raw EEG data to a csv file for project SADA.

class EEGRecorder:
    def __init__(self, filename="eegdata.csv"):
        """
        Initialize the EEGRecorder object.
        :param filename: The name of the CSV file where EEG data will be saved (default: 'eegdata.csv').
        """
        self.filename = filename  # File to save EEG data
        self.recording = False  # Flag to track recording state
        self.data = []  # List to store recorded data
        self.inlet = None  # Inlet for receiving EEG data
        self.thread = None  # Thread for running the recording function

    def start_recording(self):
        """
        Start the EEG data recording in a separate thread.
        This method sets the recording flag to True, resets the data, and starts the recording thread.
        """
        self.recording = True  # Set the recording flag to True
        self.data = []  # Reset the data list to start fresh
        self.thread = threading.Thread(target=self.record_data)  # Create a new thread to record data
        self.thread.start()  # Start the thread

    def stop_recording(self):
        """
        Stop the EEG data recording.
        This method sets the recording flag to False and waits for the recording thread to finish.
        """
        self.recording = False  # Set the recording flag to False
        if self.thread:
            self.thread.join()  # Wait for the recording thread to finish

    def record_data(self):
        """
        Continuously record EEG data in real-time and save it to a CSV file.
        This method runs in a separate thread and pulls EEG data from the Muse device.
        """
        print("Resolving EEG streams...")
        streams = resolve_streams()  # Resolve available EEG streams

        if not streams:
            print("No EEG streams found. Please make sure the Muse headband is connected.")
            return  # Exit if no streams are found

        # Connect to the first available EEG stream
        self.inlet = StreamInlet(streams[0])  # Create an inlet to receive data from the first stream
        print(f"Connected to EEG stream: {streams[0].name()}")  # Print the name of the connected stream

        # Open the CSV file and write the headers for the data columns
        with open(self.filename, 'w', newline='') as f:
            writer = csv.writer(f)  # Create a CSV writer object
            writer.writerow(["Timestamp", "TP9", "AF7", "AF8", "TP10"])  # Write the column headers

            print("Recording started. Press Enter to stop.")  # Notify the user that recording has started
            while self.recording:  # Continuously record data while the recording flag is True
                sample, timestamp = self.inlet.pull_sample()  # Pull a sample from the stream
                self.data.append([timestamp] + sample)  # Append the timestamp and sample to the data list
                writer.writerow([timestamp] + sample)  # Write the data to the CSV file
                time.sleep(0.01)  # Sleep to control the sample rate (adjust if needed)

        print(f"Recording complete. Data saved to {self.filename}.")  # Notify the user that the recording is complete

def main():
    """
    Main function to initiate the EEG recording process.
    It creates an EEGRecorder object, starts recording, and waits for user input to stop the recording.
    """
    recorder = EEGRecorder(filename="eegdata_session1.csv")  # Create an EEGRecorder object with a specified file name
    recorder.start_recording()  # Start recording EEG data

    # Wait for user input to stop the recording
    input("Press Enter to stop recording...\n")
    recorder.stop_recording()  # Stop the recording when the user presses Enter

if __name__ == "__main__":
    main()  # Run the main function if the script is executed directly
