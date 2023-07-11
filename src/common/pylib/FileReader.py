import os
import sys

class FileReader:
    ###
    # Default constructor.
    ###
    def __init__(self) -> None:
        self.mPath = None
        self.mIsOpen = False
    ###
    # It specify the file to be used.
    # -param path(String): It is the path of the file.
    ###
    def set_file( self, path ):
        self.mPath = path
    ###
    # It return the path of the current file.
    # -return(String): It is the path of the current file.
    ### 
    def get_file( self ):
        return self.mPath
    ###
    # It open the file to be written or read.
    # -return(Bool): It is true if the file has been opened.
    ###
    def  open( self ):
        #if not self.exists() :
        #    return False
        self.mIsOpen = True
        return True
    ###
    # It close the file and cannot be read or write a file.
    ###
    def  close( self ):
        self.mIsOpen = True
    ###
    # It return the current state of the file, if it is True the file is ready to be read or written.
    # -return(Bool): It is True the file can be read or written.
    ###
    def is_open( self ):
        return self.mIsOpen
    ###
    # It verify if the current file exists or not.
    # -return(Bool): It is True the file exists.
    ###
    def exists( self ):
        if( self.get_file() == None ):
            return False
        return os.path.isfile(  self.get_file() )
    ###
    # It proccess the current line of the file.
    # -param line(String): It is line of the file.
    ###
    def process_line( self, line ):
        pass
    ###
    # It load the file especified.
    ###
    def processFile( self ) -> bool:
        try:
            if not self.is_open():
                return False
            with open( self.get_file() , 'r') as file :
                for line in file:
                    if not line == None:
                        if not line.isspace() :
                            line = line.replace( "\n", "" )
                            self.process_line( line )
        except FileNotFoundError:
            return False
        except Exception as e:
            return False
        return True
    ###
    # It load the content of a file, if it exists and return the LOL of the file, the double white space is used to separate the data in teh file.
    # -param path(String): It is the path of the file.
    # -return(List): It is a list of lists.
    ###
    def load( self, path ):
        self.set_file( path )
        if not self.open():
            print( "ERROR( FileReader - load ): It is not possible load the [" + self.get_file() + "] file." )
            return False
        flag = self.processFile()
        self.close()    
        return flag
        
