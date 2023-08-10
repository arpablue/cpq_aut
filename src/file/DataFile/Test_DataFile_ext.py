import sys
import os
import colorama
from colorama import Fore

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','file','DataFile')
sys.path.append( src_path )
from DataFile_ext import DataFile_ext

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','obj','UserObj')
sys.path.append( src_path )
from UserObj import UserObj

###
# It verify that a group of object can be saved in a file.
def test_DataFile_Save_List():
    list = []
    for i in range(10):
        data = {}
        data['Name'] = 'Carl_' + str( i )
        data['Lastname'] = 'CarlLast_' + str( i )
        data['Age'] = i + 10
        if i % 3 == 0:
            data['Sex'] = 'F'
        else:
            data['Sex'] = 'M'
        usr = UserObj()
        usr.set_data( data )
        
        #print( str( usr ) )
        list.append( usr )
    df = DataFile_ext()
    df.list_save_list( list ,'data_test.txt')

test_DataFile_Save_List()