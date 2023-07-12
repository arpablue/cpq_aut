import pytest

import sys
import os
import shutil
import json

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','pylib')
sys.path.append( src_path )

from RecordFile import RecordFile
###
# It verify the writeln is working correctly.
###
def test_writeln():
    exp = ["Hello","World","Hello World"]
    target = RecordFile()
    target.set_file("RecordFile_Test.txt")
    target.delete()
    target.open()
    target.writeln("Hello")
    target.writeln("World")
    target.writeln("Hello World")
    target.close()
    cur = target.load()
    print("--------------List-----------")
    assert exp == cur
###
# It verify the exists() and delete() method works correctky.
###
def test_exists_delete():
    target = RecordFile()
    target.set_file("RecordFile_ExistsDelete.txt")
    if target.exists():
        target.delete()
    target.open()
    target.writeln( "Hello world")
    target.close()
    flag = target.exists()
    assert flag == True
    target.delete()
    flag = target.exists()
    assert flag == False
###
# It verify that a folder is created correctly.
###
def  test_RecordFile_mkdir():
    target = RecordFile()
    folder = os.path.join("one","two","three")
    if( os.path.exists( folder ) ):
        os.path.exists( folder )  
    target.mkdir(folder)
    if( not os.path.exists( folder ) ):
        pytest.fail( "The folder " + folder + "has not been created." )
    else:
        shutil.rmtree( folder )