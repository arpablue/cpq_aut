import os
import sys
dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','api2','RoleAPI')
sys.path.append( src_path )

from RoleAPI import RoleAPI



def test_RoleApi_getRoles():
    target = RoleAPI()
    list = target.get_roles()
    if list == None:
        print( '[ERROR] The list of roles is empty.')
        return
    size = len( list )
    if size < 1:
        print( '[ERROR] No roles exist in the systen when should  exoists some roles.')
        return
    print( '[PASS] Quantity of roles: ' + str( size ) )
    
    

test_RoleApi_getRoles()