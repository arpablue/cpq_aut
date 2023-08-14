import os
import sys

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

class RoleAPI( HttpRequests ):
    ###
    # Default constructor.
    ###
    def __init__( self ):
        super().__init__()
        self.mEndPoint = '/roles'
    ###
    # It return a RoleObj with the data specified.
    # -param data(Dictionary): It is the data used to create the RoleObj.
    # -return(RoleObj): It is the role created in base the dictionary basaed.
    ###
    def create_from_data( self, data):
        res = RoleObj( data )
        return res
    ###
    # I call all rols in the system.
    # -return(List): It is a list of Roles RoleObj.
    def get_roles( self ):
        print( 'Enpoint Request: ' + str( self.mURL ) + str( self.mEndPoint ) )
        response = self.http_GET()
        code = response.status_code
        list = self.content_to_dictionary( response.content )        
        flag = self.evaluate_Success_Get( code )
        if not flag :
            print( 'Current status code: ' + str( code ) + ' - It is not possible get the roles list. ')
            return []
        list = list['data']
        size = len( list )
        return list
    
        
    