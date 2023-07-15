import sys
import os


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','test','TestLib')
sys.path.append( src_path )

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','Context')
sys.path.append( src_path )

from TestLib import TestLib   

from ContextList import ContextList

test = TestLib()
def test_ContextLibs_toString():
    test.tc( 'test_ContextLibs_toString' )
    contexts = ContextList()
    ctx = contexts.get_context( "fpx" )
    
    print( 'domain: ' + str( ctx.get_domain() ) )
    
test_ContextLibs_toString()