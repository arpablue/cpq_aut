import os
import sys


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','test','TestLib')
sys.path.append( src_path )

from TestLib import testLib

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('fpxep','QueryObj','QueryObj')
sys.path.append( src_path )


def test_QueryObj_get_data_from_opportunity():
    query = QueryObj()
    