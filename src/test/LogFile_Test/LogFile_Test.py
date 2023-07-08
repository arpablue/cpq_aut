import pytest
import sys
import os
import json

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','libs')
sys.path.append( src_path )

from LogFile import LogFile

def test_LogFile_writeln():
    log = LogFile()
    log.set_file("LogFile_Writln.log")
    if log.exists():
        log.delete()
    log.open()
    log.writeln("Hello world")
    log.writeln("Aloha world")
    log.close()

