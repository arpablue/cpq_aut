#from robot.libraris.BuiltIn import BuiltIn
from robot.api.deco import library
from robot.api.deco import keyword
from robot.api import logger
import sys
import os


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','libs')
sys.path.append( src_path )

from GlobalTools import GlobalTools
from DictTools import DictTools

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','pylib')
sys.path.append( src_path )

from LolFile import LolFile


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','obj','PermissionObj')
sys.path.append( src_path )

from PermissionObj import PermissionObj
###
# It contain the methods to process some action related to permissions.
### 
@library
class PermissionFile_ext:
    def __init__( self ):
        self.mGlobal = GlobalTools()
        self.mTools = DictTools()
        self.mPermissionFile = self.mGlobal.get_prj_folder("resources/data/permissions.reg")
        print( self.mPermissionFile )
    ###
    # It load data realted to the permissions in a file.
    # -pram path(string): It is the path of the file
    # -return(bool): It is true if the file has been loaded without problems.
    ###
    @keyword
    def load_permissions_from_file( self ):
        permissions = []
        reader = LolFile()
        if not reader.load( self.mPermissionFile ):
            return permissions
        
        lists = reader.get_lol()
        index = 0
        attrs = None
        for list in lists:
            index = index + 1
            if index == 1:
                attrs = list
                continue
            data = self.mTools.dictionary_create_from_lists( attrs, list )
            permission = PermissionObj()
            permission.set_data( data )
            permissions.append( permission )
            index = index + 1
        return permissions
    ###
    # It return an permission from the file speccified in a position. If a permission doesn't exist in the position specified then return None.
    # -param index(Int): It is the postition of the permission.
    # -return(UsrObj): It is the permission specified by the position.
    ###
    @keyword
    def get_permission_position( self, index ):
        permissions = self.load_permissions_from_file()
        size = len( permissions )
        if type( index ) == str:
            index = int( index )
        if index < 0:
            return None
        if index > size -1:
            return None
        return permissions[ index ]