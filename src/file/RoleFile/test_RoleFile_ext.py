import sys
import os
import colorama
from colorama import Fore
from robot.api import logger

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','file','RoleFile')
sys.path.append( src_path )

from RoleFile_ext import RoleFile_ext


def passed( text ):
    print( Fore.GREEN + "PASS - " +text + Fore.WHITE )
    
def failed( text ):
    print( Fore.RED + "FAIL - " +text + Fore.WHITE )

###
# It verify the roles has been loaded without problems
###
def test_RoleFile_get_all_roles():
    exp = 9
    uf = RoleFile_ext()
    
    roles = uf.load_roles_from_file()
    #print("[")
    #for usr in roles:
    #    print( usr )    
    #print("]")
    size = len( roles )
    if size ==exp:
        passed("TC: test_RoleFile_get_all_roles - The quantity of role is correct")
    else:
        failed("TC: test_RoleFile_get_all_roles - The quantity of roles are differents: exp (" + str( exp ) + " != current(" + str( size ) + ") ")
        
def test_RoleFile_get_one_especific_role():
    exp = '{"RoleObj":{"id": "0ba0006dp3394wu", "name": "Customer Accounts Champion", "createAt": "20-10-31 19:34:26", "modifyAt": "2018-10-31 19:34:35"}}'
    uf = RoleFile_ext()
    
    role = uf.get_role_position( 2 )
    cur = str( role )
    if exp == cur:
        passed("TC: test_roleFile_get_one_especific_role - The object returned is the correct")
    else:
        print( "exp: " + exp )
        print( "cur: " + cur )
        failed("TC: test_roleFile_get_one_especific_role - The object returned ar not the same.")
test_RoleFile_get_all_roles()
test_RoleFile_get_one_especific_role()