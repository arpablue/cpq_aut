import os
import sys
import datetime

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','pylib')
sys.path.append( src_path )


from FileReader import FileReader

class LolFile( FileReader ):
    ###
    # Default constructor
    ###
    def __init__(self) -> None:
        super().__init__()
        self.mLists = []
    ###
    # It process each file of the file loaded.
    # -param line(String): It is a line of the file.
    ###        
    def process_line(self, line):
        list = line.split( "  " )
        self.mLists.append( list )
    ###
    # It return the current list
    ###
    def get_lol( self ):
        return self.mLists
        