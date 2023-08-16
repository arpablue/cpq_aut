import sys
import os
from robot.api import logger

###Load the Context file.
dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','Context')
sys.path.append( src_path )
from ContextList import ContextList




class ContextAPI:
    ###
    # Default constructor.
    ###
    def __init__(self) -> None:
        self.mData = self.load_yml('config.yml')
        self.mFile_output = self.mData["file_output"]
        self.mConsole_output = self.mData["console_output"]
        self.mExecutionContext = self.mData["context"]
        # Loading the context
        contexts = ContextList()
        # loading the selected context
        self.mContext = contexts.get_context( self.mExecutionContext )        
    ###
    # It return the url of the execution of the automation.
    # -return(String): It is the URL used in the execution of the automation.
    def get_url( self ):
        return self.mContext.get_url()
    ###
    # It return the token used in the test.
    # -return(String): It is the token used in the automation.
    ### 
    def get_token(self):
        return self.mData[ 'token' ]
