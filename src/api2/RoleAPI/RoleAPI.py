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
    # It convert a list of dictionaries and return ta list of Roles.
    # -param list(List): It a list of dictionary.
    # -return(List): It is a list of RoleObj object.
    ###
    def create_role_list( self, list ):
        if list == None:
            return []
        obj = None
        res = []
        for element in list:
            obj = RoleObj()
            obj.set_data( element )
            res.append( obj )
        return res
    ###
    # I call all rols in the system.
    # -return(List): It is a list of Roles RoleObj.
    @keyword
    def get_all_roles( self ):
        response = self.http_GET()
        code = response.status_code
        list = self.content_to_dictionary( response.content )        
        flag = self.evaluate_Success_Get( code )
        if not flag :
            self.write( 'Current status code: ' + str( code ) + ' - It is not possible get the roles list.')
            return []
        list = list['data']
        list = self.create_role_list( list )
        return list
    
        
    