import sys
import os
import json
from robot.api.deco import library
from robot.api.deco import keyword
from robot.api import logger

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','pylib')
sys.path.append( src_path )

from RecordFile import RecordFile
###
# AIt help to save data in a file.
###
@library
class DataRecorder:
    ###
    # It save a text of data inthe text in a file specified.
    # -param filePath(String): It is the path of the file where the file will be saved.
    # -param text(String): It is the text or data to be added inthe file.
    ###
    @keyword
    def register_in_file( self, filePath, text ):
        record = RecordFile()
        record.set_file( filePath )
        record.open()
        record.writeln( text )
        record.close()
    ###
    # It delete a file
    # -param filePath(String): It delete a specific file.
    ###
    @keyword
    def delete_file( self, filePath ):
        record = RecordFile()
        record.set_file( filePath )
        record.delete()
        
    