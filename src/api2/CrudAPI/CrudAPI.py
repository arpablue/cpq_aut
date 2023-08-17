import os
import sys
import random
from robot.api.deco import library
from robot.api.deco import keyword
from robot.api import logger

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','http_requests')
sys.path.append( src_path )
from HttpRequests import HttpRequests

###
# It class contains the 
class CrudAPI( HttpRequests ):
    ###
    # Default constructor.
    ###
    def __init__( self ):
        super().__init__()
    ###
    # It generate a random number, if the number is 
    def rand(self, n=10000 ):
        res = random.randint( 0, n )
        self.write( 'Number generated: ' + str( res ) )
        return res