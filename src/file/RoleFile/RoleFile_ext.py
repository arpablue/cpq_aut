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
src_path = dir[:src_pos] + os.path.join('src','file','DataFile')
sys.path.append( src_path )

from DataFile_ext import DataFile_ext

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','obj','RoleObj')
sys.path.append( src_path )

from RoleObj import RoleObj
###
# It contain the methods to process some action related to roles.
### 
@library
class RoleFile_ext( DataFile_ext ):
    def __init__( self ):
        self.mGlobal = GlobalTools()
        self.mTools = DictTools()
        self.mRoleFile = self.mGlobal.get_prj_folder("resources/data/roles.reg")
        print( self.mRoleFile )
    ###
    # It load data realted to the roles in a file.
    # -pram path(string): It is the path of the file
    # -return(bool): It is true if the file has been loaded without problems.
    ###
    @keyword
    def load_roles_from_file( self ):
        roles = []
        reader = LolFile()
        if not reader.load( self.mRoleFile ):
            return roles
        
        lists = reader.get_lol()
        index = 0
        attrs = None
        for list in lists:
            index = index + 1
            if index == 1:
                attrs = list
                continue
            data = self.mTools.dictionary_create_from_lists( attrs, list )
            role = RoleObj()
            role.set_data( data )
            roles.append( role )
            index = index + 1
        return roles
    ###
    # It return an role from the file speccified in a position. If a role doesn't exist in the position specified then return None.
    # -param index(Int): It is the postition of the role.
    # -return(UsrObj): It is the role specified by the position.
    ###
    @keyword
    def get_role_position( self, index ):
        roles = self.load_roles_from_file()
        size = len( roles )
        if type( index ) == str:
            index = int( index )
        if index < 0:
            return None
        if index > size -1:
            return None
        return roles[ index ]