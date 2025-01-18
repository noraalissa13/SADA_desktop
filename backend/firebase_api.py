# MADE BY: NORA ALISSA BINTI ISMAIL (2117862)
# This file contains functions to save and read EEG data from Firestore.

import firebase_admin
from firebase_admin import credentials, firestore
import uuid
import time
from datetime import datetime
import asyncio
import logging

# Initialize Firebase Admin SDK
# This is used to authenticate and initialize the Firebase Admin SDK with the credentials.
cred = credentials.Certificate("sadadesktopCredentials.json")
firebase_admin.initialize_app(cred)

# Get Firestore client
# This creates a Firestore client that will be used to interact with the Firestore database.
db = firestore.client()

def save_eeg_data_to_firestore(collection_name, document_id, eeg_data):
    """
    This function saves raw EEG data to a Firestore document.
    
    Args:
    - collection_name: The name of the Firestore collection where the data will be saved.
    - document_id: The ID of the document where the EEG data will be stored.
    - eeg_data: The EEG data to be saved (can be a dictionary or other serializable format).
    
    This function will:
    - Reference the Firestore collection and document.
    - Set the provided EEG data in the document.
    """
    print(f"Saving EEG data to Firestore: {eeg_data}")  # Debug print to check the data being saved.
    try:
        # Reference to the Firestore collection
        collection_ref = db.collection(collection_name)

        # Create or get the document with the provided document ID
        doc_ref = collection_ref.document(document_id)

        # Set the EEG data in the document
        doc_ref.set(eeg_data)

        print(f"Data saved to Firestore with document ID: {document_id}")
    except Exception as e:
        print(f"Error saving data to Firestore: {e}")

def read_raw_eeg_from_firestore(collection, document):
    """
    This function reads raw EEG data from Firestore.

    Args:
    - collection: The Firestore collection where the raw EEG data is stored.
    - document: The ID of the document containing the raw EEG data.

    Returns:
    - A pandas DataFrame containing the EEG data, or None if no document is found.
    
    This function will:
    - Fetch the document from Firestore.
    - If the document exists, return the EEG data as a pandas DataFrame.
    - If the document does not exist, log a warning and return None.
    """
    doc_ref = firestore_client.collection(collection).document(document)
    doc = doc_ref.get()
    if doc.exists:
        logging.info("Raw EEG data fetched from Firestore.")
        # Convert the fetched data into a pandas DataFrame (assuming the data is stored as a dictionary)
        return pd.DataFrame(doc.to_dict()["data"])
    else:
        logging.warning("No such document in Firestore.")
        return None

def save_processed_eeg_to_firestore(collection, document, data):
    """
    This function saves processed EEG data to Firestore.

    Args:
    - collection: The Firestore collection where the processed EEG data will be saved.
    - document: The ID of the document where the processed data will be stored.
    - data: The processed EEG data to be saved (expected to be a pandas DataFrame).
    
    This function will:
    - Convert the processed data to a dictionary format.
    - Save the data along with the current timestamp to Firestore.
    """
    doc_ref = firestore_client.collection(collection).document(document)
    # Save the processed data and timestamp to Firestore
    doc_ref.set({"data": data.to_dict(orient="records"), "timestamp": datetime.now()})
    logging.info("Processed EEG data saved to Firestore.")

def read_processed_eeg_from_firestore(collection, document):
    """
    This function reads processed EEG data from Firestore.

    Args:
    - collection: The Firestore collection where the processed EEG data is stored.
    - document: The ID of the document containing the processed EEG data.

    Returns:
    - A pandas DataFrame containing the processed EEG data, or None if no document is found.
    
    This function will:
    - Fetch the document from Firestore.
    - If the document exists, return the processed EEG data as a pandas DataFrame.
    - If the document does not exist, log a warning and return None.
    """
    doc_ref = firestore_client.collection(collection).document(document)
    doc = doc_ref.get()
    if doc.exists:
        logging.info("Processed EEG data fetched from Firestore.")
        # Convert the fetched data into a pandas DataFrame (assuming the data is stored as a dictionary)
        return pd.DataFrame(doc.to_dict()["data"])
    else:
        logging.warning("No such document in Firestore.")
        return None
