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
from firebase_admin import credentials, firestore, storage
import time
import serial
import serial.tools.list_ports
import datetime


ports=list(serial.tools.list_ports.comports())

ser = None

print(ports)

for p in ports:
    if "ttyUSB" in p.description:
        ser = serial.Serial(p.description, timeout = 5)
        print(p.description)


# initialize sdk if needed
if not firebase_admin._apps:
    cred = credentials.Certificate("./smart-lock-admin_sdk.json") 
    default_app = firebase_admin.initialize_app(cred, {
        # 'projectId': PROJECT_ID,
        'storageBucket': "smart-lock-92985.appspot.com"
    })
    
# initialize firestore instance
firestore_db = firestore.client()
doc_ref = firestore_db.document('locks/front-door')
user_ref = firestore_db.document('users/eHSXBoTXwAVOiMxgTXxhHMnys752')

# returns imageURL of current image upload
def uploadImage():
    imageName = "raspImage"
    bucket = storage.bucket()
    imagePath = '/home/pi/Desktop/image.jpg'
    imageBlob = bucket.blob(imageName)
    imageBlob.upload_from_filename(imagePath)
    blob = bucket.blob(imageName)
    blobUrl = blob.generate_signed_url(datetime.timedelta(seconds=300), method='GET') 
    print(blobUrl)
    return blobUrl
# Create an Event for notifying main thread.
#callback_done = threading.Event()
def lock():
    doc_ref.update({'status':1,})
def unlock():
    doc_ref.update({'status':0,})
def takePhoto(url):
    doc_ref.update({'imageUrl':url,'takingPhoto':0,})
def toggleLock():
    lockData = doc_ref.get().to_dict()
    if lockData['status']==0:
        lock()
    else:
        unlock()
def getLockData():
    return doc_ref.get().to_dict()
def getUserData():
    return user_ref.get().to_dict()

# Create a callback on_snapshot function to capture changes
# def on_snapshot(doc_snapshot, changes, read_time):
#     for doc in doc_snapshot:
#         # print(f'Received document snapshot: {doc.id}')
#         #print(f'Doc: {doc.to_dict()}')
#         # print(f'SUPER SECURE SECRETE ENCRYPTED INFORMATION')
#         if doc.to_dict()["status"]==0:
#             ser.write(close_lock)
#         else:
#             ser.write(open_lock)
#    callback_done.set()


# Watch the document
#doc_watch = doc_ref.on_snapshot(on_snapshot)
#%%
# Keep the app running
#while True:
#    time.sleep(100)
