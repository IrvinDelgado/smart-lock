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
from firebase_admin import credentials, firestore

# initialize sdk if needed
if not firebase_admin._apps:
    cred = credentials.Certificate("../.secrets/smart-lock-admin_sdk.json") 
    default_app = firebase_admin.initialize_app(cred)
# initialize firestore instance
firestore_db = firestore.client()
doc_ref = firestore_db.document('locks/front-door')

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

# %%
toggleLock()
# %%
