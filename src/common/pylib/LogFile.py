import os
import sys
import datetime

from RecordFile import RecordFile
###
# It register the action in a log file.
###
class LogFile( RecordFile ):
    ###
    # Default constructor.
    ###
    def __init__(self):
        super().__init__()
        self.mPath = 'actgivity.log'
    ###
    # It return the current instant time.
    # -return(String): It is the instant time.
    ###
    def get_instant(self):
        date = datetime.datetime.now()
        return date.strftime("%Y-%m-%d %H:%M:%S.%f")
    ###
    # IT return the current time stamp.
    # -return(String): It is the current timestamp.
    ###
    def get_timestamp(self):
        date = datetime.datetime.now()
        return date.strftime("%Y%m%d_%H%M%S")
    ###
    # It add a line to the file.
    # -param test(String): It is the text to e added
    ###
    def writeln(self, text):
        time = self.get_instant()
        text = time + ": " + str( text )
        super().writeln( text )

