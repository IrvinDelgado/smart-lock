#%% 
#sudo pip3 install --upgrade azure-cognitiveservices-vision-face
import asyncio
import io
import glob
import os
import sys
import time
import uuid
import requests
#import LockSim
from urllib.parse import urlparse
from io import BytesIO
# To install this module, run:
# python -m pip install Pillow
from PIL import Image, ImageDraw
from azure.cognitiveservices.vision.face import FaceClient
from msrest.authentication import CognitiveServicesCredentials
from azure.cognitiveservices.vision.face.models import TrainingStatusType, Person

import serial
import serial.tools.list_ports

from picamera import PiCamera
from time import sleep

def getNameFromUrl(url):
    beg = url.find("%2F")+3
    end = url.find("?")
    return url[beg:end]
#%%

#% KEYS AND ENDPOINT
KEY = "6362bd36ccf84baab7f37188ffb6de4f"
ENDPOINT = "https://smartlockfaces420.cognitiveservices.azure.com/"

# % CREATE CLIENT
# Create an authenticated FaceClient.
face_client = FaceClient(ENDPOINT, CognitiveServicesCredentials(KEY))
#%%
def testFaces(profile_image_url,rasp_image_url):
    #% DETECT FACE TO GET ID
    # Detect a face in an image that contains a single face
    profile_image_name = getNameFromUrl(profile_image_url)
    # We use detection model 3 to get better performance.
    detected_profile_face = face_client.face.detect_with_url(url=profile_image_url, detection_model='detection_03')
    if not detected_profile_face:
        raise Exception('No face detected from image {}'.format(profile_image_name))

    # Display the detected face ID in the first single-face image.
    # Face IDs are used for comparison to faces (their IDs) detected in other images.
    print('Detected face ID from', profile_image_name, ':')
    for face in detected_profile_face: print (face.face_id)
    print()

    # Save this ID for use in Find Similar
    profile_image_face_ID = detected_profile_face[0].face_id
    # %
    # Detect the faces in an image that contains multiple faces
    # Each detected face gets assigned a new ID
    rasp_image_name = getNameFromUrl(rasp_image_url)
    # We use detection model 3 to get better performance.
    detected_faces2 = face_client.face.detect_with_url(url=rasp_image_url, detection_model='detection_03')


    # %
    # Search through faces detected in group image for the single face from first image.
    # First, create a list of the face IDs found in the second image.
    second_image_face_IDs = list(map(lambda x: x.face_id, detected_faces2))
    # Next, find similar face IDs like the one detected in the first image.
    similar_faces = face_client.face.find_similar(face_id=profile_image_face_ID, face_ids=second_image_face_IDs)
    if not similar_faces:
        print('No similar faces found in', rasp_image_name, '.')
        #LockSim.accessDenied()
        return False
    # Print the details of the similar faces detected
    else:
        print('Similar faces found in', rasp_image_name + ':')
        #LockSim.accessGranted()
        for face in similar_faces:
            profile_image_face_ID = face.face_id
            # The similar face IDs of the single face image and the group image do not need to match, 
            # they are only used for identification purposes in each image.
            # The similar faces are matched using the Cognitive Services algorithm in find_similar().
            face_info = next(x for x in detected_faces2 if x.face_id == profile_image_face_ID)
            if face_info:
                print('  Face ID: ', profile_image_face_ID)
                print('  Face rectangle:')
                print('    Left: ', str(face_info.face_rectangle.left))
                print('    Top: ', str(face_info.face_rectangle.top))
                print('    Width: ', str(face_info.face_rectangle.width))
                print('    Height: ', str(face_info.face_rectangle.height))
        return True
# %%

# %%
