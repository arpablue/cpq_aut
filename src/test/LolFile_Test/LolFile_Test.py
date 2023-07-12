import pytest
import sys
import os
import json

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','pylib')
sys.path.append( src_path )

from LolFile import LolFile

def test_LolFile_load_using_a_file_with():
    print("---------- TC: test_LolFile_load_using_a_file_with ----------")
    lol = LolFile()
    lol.load( "C:\\work\\DoverPrj\\cpq_aut\\src\\test\\LolFile_Test\\LolFile_Test.txt" )
    lists =  lol.get_lol()
    for list in lists:
        print( list )
    size = len( lists )
    print("Quantity of elements: " + str( size ) )
def test_LolFile_load_file_doesnt_exists():
    print("---------- TC: test_LolFile_load_file_doesnt_exists ----------")
    lol = LolFile()
    lol.load( "C:\\work\\DoverPrj\\cpq_aut\\src\\test\\LolFile_Test\\LolFile_Test_not_exist.txt" )
    lists =  lol.get_lol()
    for list in lists:
        print( list )
    size = len( lists )
    print("Quantity of elements: " + str( size ) )
    print(" List -> " + str( lists ) )
    
test_LolFile_load_using_a_file_with()
test_LolFile_load_file_doesnt_exists()