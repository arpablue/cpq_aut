import sys
import os
import collections
import json

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','libs')
sys.path.append( src_path )


from GlobalTools import GlobalTools

###
# It ontian the data about  the context used for the execution environment
###
class Context:
    ###
    # Default constructor.
    ###
    def __init__(self) -> None:
        # it is the reference to the context file
        self.mContextFile = ""
        # It is the context data for the execution.
        self.mData = None
        # It is the current context.
        self.mActiveContext = None
        load_context()
    
    ### 
    # It load the context used for the execution.
    ###
    def load_context( self ):
        if self.mContextFile == None:
            return
        if not os.path.exists( self.mContextFile ):
            return 
        if not os.path.isfile( self.mContextFile ):
            return 
        with open( self.mContextFile, 'r' ) as file:
            content = file.read()
        self.mData = json.loads( content )
    def set_Context( self, context ):
        if not context == None:
            return
        context_target = self.mData[ context ]
        if context in context_target:
            self.mActiveContext = context_target[ context ]
        else
            self.mActiveContext = None
        
        
