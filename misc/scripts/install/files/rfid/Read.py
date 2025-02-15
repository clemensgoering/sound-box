#!/usr/bin/env python3
# -*- coding: utf8 -*-
#
#    Copyright 2018 Daniel Perron
#
#    Base on Mario Gomez <mario.gomez@teubi.co>   MFRC522-Python
#
#    This file use part of MFRC522-Python
#    MFRC522-Python is a simple Python implementation for
#    the MFRC522 NFC Card Reader for the Raspberry Pi.
#
#    MFRC522-Python is free software:
#    you can redistribute it and/or modify
#    it under the terms of
#    the GNU Lesser General Public License as published by the
#    Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    MFRC522-Python is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU Lesser General Public License for more details.
#
#    You should have received a copy of the
#    GNU Lesser General Public License along with MFRC522-Python.
#    If not, see <http://www.gnu.org/licenses/>.
#

import MFRC522
import signal
import os
from pathlib import Path


continue_reading = True


# function to read uid an conver it to a string

def uidToString(uid):
    mystring = ""
    for i in uid:
        mystring = format(i, '02X') + mystring
    return mystring


# Capture SIGINT for cleanup when the script is aborted
def end_read(signal, frame):
    global continue_reading
    print("Manual execution: Ctrl+C captured, ending read.")
    continue_reading = False

# Hook the SIGINT
signal.signal(signal.SIGINT, end_read)

# Create an object of the class MFRC522
MIFAREReader = MFRC522.MFRC522()

# Welcome message
print("Version 1.63")
status_file = os.path.dirname(Path.home()) + "/pi/sound-box/docker/public/files/status.txt"
try:
    f = open(status_file, "a") #a, append. Instead of w, write
    f.write("RFID:ON")
    f.close()
except IOError:
    print("Stautsfile update failed")

# This loop keeps checking for chips.
# If one is near it will get the UID and authenticate
while continue_reading:

    # Scan for cards
    (status, TagType) = MIFAREReader.MFRC522_Request(MIFAREReader.PICC_REQIDL)

    # If a card is found
    if status == MIFAREReader.MI_OK:
        logger_file = os.path.dirname(Path.home()) + "/pi/sound-box/docker/public/files/rfid_logger.txt"
        # Get the UID of the card
        (status_tags, uid) = MIFAREReader.MFRC522_SelectTagSN()

        # If we have the UID, continue
        if status_tags == MIFAREReader.MI_OK:
            print("Card read UID: %s" % uidToString(uid))
            f = open(logger_file, "w")
            f.write(uidToString(uid))
            f.close()
        else:
            print("Authentication error")
