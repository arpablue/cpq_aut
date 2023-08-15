import os
import sys

from robot.api import logger

from robot.libraries.BuiltIn import BuiltIn

### Loading the TestActivitFile
dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','pylib')
sys.path.append( src_path )
from TestActivityFile import TestActivityFile

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','http_requests','LogAPI')
sys.path.append( src_path )
from ContextAPI import ContextAPI

class LogAPI( ContextAPI ):
    ###
    # Default constructor.
    ###
    def __init__(self) -> None:
        super().__init__()
        
        self.mTestActivityFile = TestActivityFile()
        
        self.mLog = None
        ########################### Log methods #####################################
    ###
    # It write a message in the console
    # text: It is the message to be displayed
    ###
    def display( self, text ):
        if  self.mConsole_output  == 1:
            logger.console( text )
        if  self.mFile_output == 1:
            self.mTestActivityFile.writeln( text )
    ###
    # It display a passed message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    def passed( self, text ):
        self.display( "PASS: " + str( text ) )
    ###
    # It display a success message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    def success( self, text ):
        self.display( "\t\tSUCCESS: " + str( text ) )
    ###
    # It display an unsuccess message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    def unsuccess( self, text ):
        self.display( "\t\tUNSUCCESS: " + str( text ) )
    ###
    # It display a warning message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    def warning( self, text ):
        self.display( "\t\tWARNING: " + str( text ) )
    ###
    # It display an info message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    def info( self, text ):
        self.display( "\t\tINFO: " + str( text ) )
    ###
    # It display a step message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    def step( self, text ):
        self.display( "\tSTEP: " + str( text ) )
    ###
    # It display a action message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    def action( self, text ):
        self.display( "\t\tACTION: " + str( text ) )
    ###
    # It display a write message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    def write( self, text ):
        self.display( "\t\t\t" + str( text ) )
    ###
    # It display a mistake message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    def mistake( self, text ):
        self.display( "\t\tMISTAKE: " + str( text ) )
    ###
    # It display a error message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    def error( self, text ):
        self.display( "\t\tERROR: " + str( text ) )
    ###
    # It display a failed message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    def failed( self, text ):
        self.display( "FAIL:" + str( text ) )
        raise Exception( str( text ) )

