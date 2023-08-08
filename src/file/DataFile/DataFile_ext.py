import os
import sys
from robot.api import logger

class DataFile_ext:
    def list_to_str( self, list, sep='  '):
        if list == None:
            return ''
        if sep == None:
            sep = '  '
        res = ''
        flag = False
        for e in list:
            if flag == True:
                res = res + str( sep )
            res = res + str( e )
            flag = True
        return res
    ###
    # It save the data of a list of DataObj in a file, where the attribute names are the columns and the records are the 
    # values of the attributes.
    # -param list(List):  It is a list of DataObj to be saved.
    # -param pathFile(String): It is the path of the file where the data will be saved.
    ###
    def list_save_list( self, list, pathFile ):
        if pathFile == None:
            return False
        if list == None:
            return False
        if os.path.exists( pathFile ):
            os.remove( pathFile )
    
        f = open( pathFile, 'a' )
        flag = True
        for element in list:
            if element == None:
                continue
            if flag == True:
                columns = element.keys()
                strs = self.list_to_str( columns )
                f.write( strs )
                f.write("\n")
                flag = False
            values = element.values()
            strs = self.list_to_str( values )
            f.write( strs )
            f.write("\n")
        f.seek(0)
        f.close()
    
            
        
        
        
    