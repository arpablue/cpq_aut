import os
import sys
from robot.api import logger

class RecordFile:
    ###
    # Default constructor.
    ###
    def __init__(self):
        self.mPath = 'recordFile.txt'
        self.mbOpen = False
    ###
    # It specify the path of the activity file.
    # -param pathFile(String): It is the path of the activity file.
    ###
    def set_file( self, pathFile):
        self.mPath = pathFile
    ###
    # It return the path of the file used.
    # -return(String): It ist the path of the file.
    ###
    def get_file(self):
        return self.mPath
    ###
    # It return the status of the file, if is True the file is ready to be write.
    # -return(bool): It is true then the file can be written.
    ###
    def is_open(self):
        return self.mbOpen
    ###
    # It read the file and return an array with the content of the file. If the file
    # doesn't have content then return an empty list.
    # -return(list): It is the lines of the text.
    ###
    def load(self):
        res = []
        with open( self.get_file(), "r") as file:
            lines = file.readlines()
            for line in lines:
                res.append( line.replace("\n","") )
        return res
    ###
    # It verify if the file exists.
    # -return(bool): It is true if the file exists.
    def exists(self):
        return os.path.exists( self.get_file() )
    ###
    # It delete the current file.
    # -return(bool): It return true if the file has been delete.
    ###
    def delete(self):
        if os.path.exists( self.get_file() ):
            os.remove( self.get_file() )
            return True
        return False     
    ###        
    # I open the activity file to be writer. If the file not exists then is created.
    ###
    def open(self):
        self.mbOpen = True
    ###
    # It close the file and disable the posibility to write in the file.
    ###
    def close(self):
        self.mbOpen = False
    ###
    # It add a text as line in a file.
    ### 
    def writeln(self, text):
        if( not self.is_open() ):
            return
        f = open(self.mPath,'a')
        f.write( str(text) )
        f.write("\n")
        f.seek(0)
        f.close()
    ###
    # It create the folder or all folders specified in the path.
    # -param folder(string): It is the path of the folder to be created.
    ###
    def mkdir( self, folder ):
        if not os.path.exists( folder ):
            os.makedirs( folder )
        