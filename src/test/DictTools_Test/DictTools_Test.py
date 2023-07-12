import pytest

import sys
import os
import shutil
import json

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','libs')
sys.path.append( src_path )

from DictTools import DictTools

def test_DictTools_CreateDictionary_Create_dictionary_from_lists_with_equal_size():
    print("--- TC: test_DictTools_CreateDictionary_Create_dictionary_from_lists_with_equal_size")
    tools = DictTools()
    listA = ['a','b','c','d','e','f','g']
    listB = [1,2,3,4,5,6,7]
    
    dict = tools.dictionary_create_from_lists( listA, listB )
    
    print( dict )
def test_DictTools_CreateDictionary_Create_dictionary_from_lists_with_bigger_size():
    print("--- TC: test_DictTools_CreateDictionary_Create_dictionary_from_lists_with_bigger_size")
    tools = DictTools()
    listA = ['a','b','c','d','e','f','g']
    listB = [1,2,3,4,5,6,7,8,9,10]
    
    dict = tools.dictionary_create_from_lists( listA, listB )
    
    print( dict )
def test_DictTools_CreateDictionary_Create_dictionary_from_lists_with_shorter_size():
    print("--- TC: test_DictTools_CreateDictionary_Create_dictionary_from_lists_with_shorter_size")
    tools = DictTools()
    listA = ['a','b','c','d','e','f','g']
    listB = [1,2,3,4]
    
    dict = tools.dictionary_create_from_lists( listA, listB )
    
    print( dict )
    
test_DictTools_CreateDictionary_Create_dictionary_from_lists_with_equal_size()
test_DictTools_CreateDictionary_Create_dictionary_from_lists_with_bigger_size()
test_DictTools_CreateDictionary_Create_dictionary_from_lists_with_shorter_size()