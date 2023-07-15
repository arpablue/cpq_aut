import sys
import os
import collections
import json

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','libs')
sys.path.append( src_path )


#from GlobalTools import GlobalTools

from Context import Context

###
# It ontian the data about  the context used for the execution environment
###
class ContextList:
    ###
    # Default constructor.
    ###
    def __init__(self) -> None:
        # it is the reference to the context file
        self.mContextFile = "C:\\work\\DoverPrj\\cpq_aut\\resources\\config\\context.json"
        # It is the context data for the execution.
        self.mData = {}
        # It is the current context.
        self.mActiveContext = None
        self.load_context()
    
    ### 
    # It load the context used for the execution.
    ###
    def load_context( self ):
        
        #self.mData.clear()
        if self.mContextFile == None:
            print( "ERROR: The context file not exist.")
            return
        if not os.path.exists( self.mContextFile ):
            print( "ERROR: The [" + str( self.mContextFile ) + "] file not exit.")
            return 
        if not os.path.isfile( self.mContextFile ):
            print( "ERROR: The [" + str( self.mContextFile ) + "]")
            return 
        with open( self.mContextFile, 'r' ) as file:
            content = file.read()
        self.mData = json.loads( content )
        keyContexts = 'context'
        if not keyContexts in self.mData:
            print( 'ERROR: The [' + str( keyContexts  ) +']')
            return None
        contexts = self.mData[ keyContexts ]
        cntx = None
        for context in contexts:
            cntx = Context()
            cntx.set_data( contexts[ context ] )
            cntx.set_name( context )
            self.mData[ context ] = cntx
    ###
    # It return the data of the currents context.
    ###
    def get_data( self ):
        return  self.mData
    ###
    # It return a context, if the context not exist then return None.
    # -param context(String): It is the name of the context.
    # -return(Context): It return a context object.
    ###
    def get_context(self, context ):
        if self.mData == None:
            print( 'ERROR: The context not exists.')
            return None
        if not context in self.mData:
            print('ERROR: The [' + str( context ) + '] context not exist.')
            return None
        return self.mData[ context ]
    
            
    ###
    # It specify the contexts.
    # -param context(Dictionary): It is a diccitionary with the structure and the data used fo rthe contexts.
    ###
    def set_Context( self, context ):
        if not context == None:
            return
        context_target = self.mData[ context ]
        if context in context_target:
            self.mActiveContext = context_target[ context ]
        else:
            self.mActiveContext = None
    ###
    # IT returnt he data in string.
    ###
    def __str__(self):
        return str( self.mData )
