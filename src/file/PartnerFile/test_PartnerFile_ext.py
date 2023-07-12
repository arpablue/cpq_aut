import sys
import os
import colorama
from colorama import Fore
from robot.api import logger

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','file','PartnerFile')
sys.path.append( src_path )

from PartnerFile_ext import PartnerFile_ext


def passed( text ):
    print( Fore.GREEN + "PASS - " +text + Fore.WHITE )
    
def failed( text ):
    print( Fore.RED + "FAIL - " +text + Fore.WHITE )

###
# It verify the partners has been loaded without problems
###
def test_PartnerFile_get_all_partners():
    exp = 3
    uf = PartnerFile_ext()
    
    partners = uf.load_partners_from_file()
    #print("[")
    #for usr in partners:
    #    print( usr )    
    #print("]")
    size = len( partners )
    if size ==exp:
        passed("TC: test_PartnerFile_get_all_partners - The quantity of partner is correct")
    else:
        failed("TC: test_PartnerFile_get_all_partners - The quantity of partners are differents: exp (" + str( exp ) + ") != current(" + str( size ) + ") ")
        
def test_PartnerFile_get_one_especific_partner():
    exp = '{"PartnerObj":{"id": "17a0001yw6qc6ned", "name": "HillPhonix AM 44556", "createAt": "2022-12-01 06:49:37", "modifyAt": "2022-12-01 06:49:37"}}'
    uf = PartnerFile_ext()
    
    partner = uf.get_partner_position( 2 )
    cur = str( partner )
    if exp == cur:
        passed("TC: test_PartnerFile_get_one_especific_partner - The object returned is the correct")
    else:
        print( "exp: " + exp )
        print( "cur: " + cur )
        failed("TC: test_PartnerFile_get_one_especific_partner - The object returned ar not the same.")
test_PartnerFile_get_all_partners()
test_PartnerFile_get_one_especific_partner()