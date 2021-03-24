'''
    Requirements:
        pip install firebase_admin
    Documentation Websites
        firebase_admin
            https://firebase.google.com/docs/reference/admin/python
        firestore
            https://googleapis.dev/python/firestore/latest/client.html
'''
#%%
import firebase_admin
from firebase_admin import firebase_admin,credentials, firestore
import threading
import time

# initialize sdk if needed
if not firebase_admin._apps:
    cred = credentials.Certificate("../.secrets/smart-lock-admin_sdk.json") 
    default_app = firebase_admin.initialize_app(cred)
    
# initialize firestore instance
firestore_db = firestore.client()
doc_ref = firestore_db.document('locks/front-door')

# Create an Event for notifying main thread.
callback_done = threading.Event()

def lock():
    doc_ref.update({'status':1,})
def unlock():
    doc_ref.update({'status':0,})
def toggleLock():
    lockData = doc_ref.get().to_dict()
    if lockData['status']==0:
        lock()
    else:
        unlock()

# Create a callback on_snapshot function to capture changes
def on_snapshot(doc_snapshot, changes, read_time):
    for doc in doc_snapshot:
        print(f'Received document snapshot: {doc.id}')
        print(f'Doc: {doc.to_dict()}')
    callback_done.set()


# Watch the document
doc_watch = doc_ref.on_snapshot(on_snapshot)
# Keep the app running
while True:
    time.sleep(100)

