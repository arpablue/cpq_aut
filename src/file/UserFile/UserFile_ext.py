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
src_path = dir[:src_pos] + os.path.join('src','obj','UserObj')
sys.path.append( src_path )

from UserObj import UserObj

@library
class UserFile_ext( DataFile_ext ):
    def __init__( self ):
        #super.__init__() 
        self.mGlobal = GlobalTools()
        self.mTools = DictTools()
        self.mUserFile = self.mGlobal.get_prj_folder("resources/data/users.reg")
        print( self.mUserFile )
    ###
    # It load data realted to the users in a file.
    # -pram path(string): It is the path of the file
    # -return(bool): It is true if the file has been loaded without problems.
    ###
    @keyword
    def load_users_from_file( self ):
        users = []
        reader = LolFile()
        if not reader.load( self.mUserFile ):
            return users
        
        lists = reader.get_lol()
        index = 0
        attrs = None
        for list in lists:
            index = index + 1
            if index == 1:
                attrs = list
                continue
            data = self.mTools.dictionary_create_from_lists( attrs, list )
            user = UserObj()
            user.set_data( data )
            users.append( user )
            index = index + 1
        return users
    ###
    # It return an user from the file speccified in a position. If a user doesn't exist in the position specified then return None.
    # -param index(Int): It is the postition of the user.
    # -return(UsrObj): It is the user specified by the position.
    ###
    @keyword
    def get_user_position( self, index ):
        users = self.load_users_from_file()
        size = len( users )
        if type( index ) == str:
            index = int( index )
        if index < 0:
            return None
        if index > size -1:
            return None
        return users[ index ]