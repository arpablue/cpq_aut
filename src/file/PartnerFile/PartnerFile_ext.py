#from robot.libraris.BuiltIn import BuiltIn
from robot.api.deco import library
from robot.api.deco import keyword
from robot.api import logger
import sys
import os


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','libs')
sys.path.append( src_path )

from GlobalTools import GlobalTools
from DictTools import DictTools

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','pylib')
sys.path.append( src_path )

from LolFile import LolFile


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','obj','PartnerObj')
sys.path.append( src_path )

from PartnerObj import PartnerObj
###
# It contain the methods to process some action related to partners.
### 
@library
class PartnerFile_ext:
    def __init__( self ):
        self.mGlobal = GlobalTools()
        self.mTools = DictTools()
        self.mPartnerFile = self.mGlobal.get_prj_folder("resources/data/partners.reg")
        print( self.mPartnerFile )
    ###
    # It load data realted to the partners in a file.
    # -pram path(String): It is the path of the file
    # -return(Bool): It is true if the file has been loaded without problems.
    ###
    @keyword
    def load_partners_from_file( self ):
        partners = []
        reader = LolFile()
        if not reader.load( self.mPartnerFile ):
            return partners
        
        lists = reader.get_lol()
        index = 0
        attrs = None
        for list in lists:
            index = index + 1
            if index == 1:
                attrs = list
                continue
            data = self.mTools.dictionary_create_from_lists( attrs, list )
            partner = PartnerObj()
            partner.set_data( data )
            partners.append( partner )
            index = index + 1
        return partners
    ###
    # It return an partner from the file speccified in a position. If a partner doesn't exist in the position specified then return None.
    # -param index(Int): It is the postition of the partner.
    # -return(UsrObj): It is the partner specified by the position.
    ###
    @keyword
    def get_partner_position( self, index ):
        partners = self.load_partners_from_file()
        size = len( partners )
        if type( index ) == str:
            index = int( index )
        if index < 0:
            return None
        if index > size -1:
            return None
        return partners[ index ]