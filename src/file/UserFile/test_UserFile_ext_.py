import sys
import os
import colorama
from colorama import Fore
from robot.api import logger

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','file','UserFile')
sys.path.append( src_path )

from UserFile_ext import UserFile_ext


def passed( text ):
    print( Fore.GREEN + "PASS - " +text + Fore.WHITE )
    
def failed( text ):
    print( Fore.RED + "FAIL - " +text + Fore.WHITE )

###
# It verify the users has been loaded without problems
###
def test_UserFile_get_all_users():
    exp = 4
    uf = UserFile_ext()
    
    users = uf.load_users_from_file()
    #print("[")
    #for usr in users:
    #    print( usr )    
    #print("]")
    size = len( users )
    if size ==exp:
        passed("TC: test_UserFile_get_all_users - The quantity of user is correct")
    else:
        failed("TC: test_UserFile_get_all_users - The quantity of users are differents: exp (" + str( exp ) + " != current(" + size + ") ")
        
def test_UserFile_get_one_especific_user():
    exp = '{"UserObj":{"id": "3333", "name": "May", "lastname": "Realy", "email": "May.Realy@test.com"}}'
    uf = UserFile_ext()
    
    user = uf.get_user_position( 2 )
    cur = str( user )
    if exp == cur:
        passed("TC: test_UserFile_get_one_especific_user - The object returned is the correct")
    else:
        print( "exp: " + exp )
        print( "cur: " + cur )
        failed("TC: test_UserFile_get_one_especific_user - The object returned ar not the same.")
test_UserFile_get_all_users()
test_UserFile_get_one_especific_user()