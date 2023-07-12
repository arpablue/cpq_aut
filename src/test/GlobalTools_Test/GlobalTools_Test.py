import pytest

import sys
import os
import shutil
import json

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','libs')
sys.path.append( src_path )

from GlobalTools import GlobalTools
def test_set_path_format():
    print( "--- TEST: test_set_path_format"  )
    exp ="/v1/projects/quotes"
    target = "\\v1\\projects\\quotes"
    tools = GlobalTools()
    path = tools.set_path_format( target )
    print( "PATH: " + path)

def test_path_folder():
    print( "--- TEST: test_path_folder"  )
    target = GlobalTools()
    path = target.get_prj_folder( "/v1/projects/quotes" )
    print( "PATH: " + path)
test_set_path_format()
test_path_folder()