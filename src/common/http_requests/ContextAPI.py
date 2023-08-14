import sys
import os


###Load the Context file.
dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','Context')
sys.path.append( src_path )
from ContextList import ContextList


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','http_requests','LogAPI')
sys.path.append( src_path )
from LogAPI import LogAPI

class ContextAPI(LogAPI):
    ###
    # Default constructor.
    ###
    def __init__(self) -> None:
        super().__init__()
        self.mData = self.load_yml('config.yml')
        self.mFile_output = self.mData["file_output"]
        self.mExeutionContext = self.mData["context"]
        # Loading the context
        contexts = ContextList()
        # loading the selected context
        self.mContext = contexts.get_context( self.mExeutionContext )        
    