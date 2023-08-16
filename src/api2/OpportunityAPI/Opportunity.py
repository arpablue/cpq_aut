import os
import sys
from robot.api.deco import library
from robot.api.deco import keyword
from robot.api import logger


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','obj','RoleObj')
sys.path.append( src_path )
from RoleObj import RoleObj

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','http_requests')
sys.path.append( src_path )
from HttpRequests import HttpRequests
@library
class OpportunityAPI( HttpRequests ):
    ###
    # Default constructor.
    ###
    def __init__( self ):
        super().__init__()
        self.mEndPoint = '/opportunity'