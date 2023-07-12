import sys
import os
import colorama
from colorama import Fore
from robot.api import logger

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','file','PermissionFile')
sys.path.append( src_path )

from PermissionFile_ext import PermissionFile_ext


def passed( text ):
    print( Fore.GREEN + "PASS - " +text + Fore.WHITE )
    
def failed( text ):
    print( Fore.RED + "FAIL - " +text + Fore.WHITE )

###
# It verify the permissions has been loaded without problems
###
def test_permissionFile_get_all_permissions():
    exp = 4
    uf = PermissionFile_ext()
    
    permissions = uf.load_permissions_from_file()
    #print("[")
    #for usr in permissions:
    #    print( usr )    
    #print("]")
    size = len( permissions )
    if size ==exp:
        passed("TC: test_permissionFile_get_all_permissions - The quantity of permission is correct")
    else:
        failed("TC: test_permissionFile_get_all_permissions - The quantity of permissions are differents: exp (" + str( exp ) + " != current(" + str( size ) + ") ")
        
def test_permissionFile_get_one_especific_permission():
    exp = '{"PermissionObj":{"id": "09a00001abcdef03", "name": "Admin Permission", "createAt": "2018-09-26 12:29:20"}}'
    uf = PermissionFile_ext()
    
    permission = uf.get_permission_position( 2 )
    cur = str( permission )
    if exp == cur:
        passed("TC: test_permissionFile_get_one_especific_permission - The object returned is the correct")
    else:
        print( "exp: " + exp )
        print( "cur: " + cur )
        failed("TC: test_permissionFile_get_one_especific_permission - The object returned ar not the same.")
test_permissionFile_get_all_permissions()
test_permissionFile_get_one_especific_permission()