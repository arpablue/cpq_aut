import sys
import os
import json

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
src_path = dir[:src_pos] + os.path.join('src','obj','BaseObj')
sys.path.append( src_path )

from BaseObj import BaseObj
from UserObj import UserObj

###
# It manage a group of user in the system.
###
class UserListObj( BaseObj ):
    def __init__( self ):
        super.__init__()
        self.mUsers = []
        global = GlobalTools()
        self.mUsersFile = global.get_prj_folder("resources/data/users.reg")
    ###
    # It load data realted to the users in a file.
    # -pram path(string): It is the path of the file
    # -return(bool): It is true if the file has been loaded without problems.
    ###
    def load_file( self, path ):
        
        self.mLists.clear()
        reader = FileReader()
        if not reader.load( self.mUsersFile ):
            return False
        
        return True
    
