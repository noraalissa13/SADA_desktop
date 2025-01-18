import firebase_admin
from firebase_admin import credentials, firestore
import uuid
import time 
from datetime import datetime
import asyncio
import logging

# Initialize Firebase Admin SDK
cred = credentials.Certificate("sadadesktopCredentials.json")
firebase_admin.initialize_app(cred)

# Get Firestore client
db = firestore.client()

def save_eeg_data_to_firestore(collection_name, document_id, eeg_data):
    # This function will save the EEG data to Firestore
    print(f"Saving EEG data to Firestore: {eeg_data}")  # Debug print
    try:
        # Reference to the Firestore collection
        collection_ref = db.collection(collection_name)

        # Create a new document with the given ID or use the provided document ID
        doc_ref = collection_ref.document(document_id)

        # Set the EEG data in the document
        doc_ref.set(eeg_data)

        print(f"Data saved to Firestore with document ID: {document_id}")
    except Exception as e:
        print(f"Error saving data to Firestore: {e}")

def read_raw_eeg_from_firestore(collection, document):
    doc_ref = firestore_client.collection(collection).document(document)
    doc = doc_ref.get()
    if doc.exists:
        logging.info("Raw EEG data fetched from Firestore.")
        return pd.DataFrame(doc.to_dict()["data"])
    else:
        logging.warning("No such document in Firestore.")
        return None

def save_processed_eeg_to_firestore(collection, document, data):
    doc_ref = firestore_client.collection(collection).document(document)
    doc_ref.set({"data": data.to_dict(orient="records"), "timestamp": datetime.now()})
    logging.info("Processed EEG data saved to Firestore.")

def read_processed_eeg_from_firestore(collection, document):
    doc_ref = firestore_client.collection(collection).document(document)
    doc = doc_ref.get()
    if doc.exists:
        logging.info("Processed EEG data fetched from Firestore.")
        return pd.DataFrame(doc.to_dict()["data"])
    else:
        logging.warning("No such document in Firestore.")
        return None