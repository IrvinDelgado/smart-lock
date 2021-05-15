import serial
import serial.tools.list_ports

import threading
from picamera import PiCamera
from time import sleep
import LockSim
import imageRec

open_lock = b'c'
close_lock = b'd'
lockData = LockSim.getLockData()


# Connect to the serial port of the Arduino
ser = None
ports=list(serial.tools.list_ports.comports())
camera = PiCamera()
for p in ports:
    if "ttyUSB" in p.device:
        ser = serial.Serial(p.device, timeout = 5)
        print("Successfully connected to : " + p.device)

def sendPassCodeToPete(passCode):
    passCode = [bytes(str(c),encoding='utf-8') for c in passCode]
    passCode.insert(0, b"x")
    passCode.insert(0, b"<")
    passCode.append(b">")
    for h in passCode:
        ser.write(h)
    print(passCode)

callback_done = threading.Event()
# Create a callback on_snapshot function to capture changes
def on_snapshot(doc_snapshot, changes, read_time):
    for doc in doc_snapshot:
        # print(f'Received document snapshot: {doc.id}')
        # print(f'Doc: {doc.to_dict()}')
        # print(f'SUPER SECURE SECRETE ENCRYPTED INFORMATION')
        lock = doc.to_dict()
        sendPassCodeToPete(lock["keypad"])
        print("===")
        print(lock["status"])
        print(lockData["status"])
        if lock["status"]!=lockData["status"]:
            if  lock["status"]==0:
                ser.write(b"<")
                ser.write(close_lock)
                ser.write(b">")
                lockData["status"]=1
                LockSim.lock()
            else:
                ser.write(b"<")
                ser.write(open_lock)
                ser.write(b">")
                lockData["status"]=0
                LockSim.unlock()
        #if lock["takingPhoto"]!=lockData["takingPhoto"]:
            # if lock["takingPhoto"]==1:
            #     imageUrl = LockSim.uploadImage()
            #     LockSim.takePhoto(imageUrl)
    callback_done.set()


sendPassCodeToPete(lockData["keypad"])
doc_watch = LockSim.doc_ref.on_snapshot(on_snapshot)
while(True):
    x = ser.read(1)
    print(x)
    # if (x == b'1'):
        # camera.start_preview()
        # sleep(1)
        # camera.capture('/home/pi/Desktop/image.jpg')
        # camera.stop_preview()
        # Upload to Firebase
        # doc_watch = LockSim.doc_ref.on_snapshot(on_snapshot)
        # imageUrl = LockSim.uploadImage()
        # for profile in LockSim.getUserData()["profiles"]:
        #     isTrue = imageRec.testFaces(profile,imageUrl)
        #     if isTrue:
        #         ser.write(open_lock)
        #     else:
        #         ser.write(close_lock)
# %%

# %%
