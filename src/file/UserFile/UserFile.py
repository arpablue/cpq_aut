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

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','pylib')
sys.path.append( src_path )

from FileReader import FileReader


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','obj','UserObj')
sys.path.append( src_path )

from UserObj import UserObj
from UserListObj import UserListObj

@library
class UserFile:
    def __init__( self ):
        super.__init__() 
        self.mGlobal = GlobalTools()
        self.mDataBank = self.mGlobal.get_prj_folder("resources/data/users.reg")
    ###
    # It load data realted to the users in a file.
    # -pram path(string): It is the path of the file
    # -return(bool): It is true if the file has been loaded without problems.
    ###
    @keyword
    def load_users_from_data_bank( self ):
        users = []
        
        
        
        self.mLists.clear()
        reader = FileReader()
        if not reader.load( self.mDataBank ):
            return False
        
        lists = reader.get_lol()
        for list in lists:
            user = UserObj()
            user.set
        
        
        return True
    