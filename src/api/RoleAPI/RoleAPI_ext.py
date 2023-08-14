#from robot.libraris.BuiltIn import BuiltIn
from robot.api.deco import library
from robot.api.deco import keyword
from robot.api import logger
import sys
import os


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','obj','RoleObj')
sys.path.append( src_path )
from RoleObj import RoleObj

###
# It is extencion of the methods used to manage the data of the Rol.
###
@library
class RoleAPI_ext:
    ###    
    # It create a Rol object using as base a dictionary.
    # -param dict(dictionary): It is the data used to crearte the Rol object.
    # -return( RoleObj ) It is the Rol created from the data.
    ###
    @keyword
    def create_from_data(self, dict ):
        res = RoleObj( dict )
        return res
    # It is a flexible comparison. Both objects could have differents numbers of atributes,
    # but all attributes of the first object should be exists in the second object and they 
    # they should have the same values.
    # -param rolA(RoleObj) : It is the first roles to be compared.
    # -param rolB(RoleObj) :It is the second Rol to be compared.
    ###
    @keyword
    def compare(self, rolA , rolB):
        if ( rolA == None ) and ( rolB == None ):
            return True
        if rolA == None :
            return False
        return rolA.compare_to( rolB )
    ###
    # It is a strict comparison. Both objects should have the same number of attributes,
    # the same attributes and the same values.
    # -param rolA(RoleObj) : It is the first roles to be compared.
    # -param rolB(RoleObj) :It is the second Rol to be compared.
    ###
    @keyword
    def equal(self, rolA , rolB):
        if ( rolA == None ) and ( rolB == None ):
            return True
        if rolA == None :
            return False
        return rolA.equal( rolB )
    ###
    # It returnt the list of QuotesObj related to the current Rol.
    # -param rol(RoleObj): It is the Rol to get the quotes.
    # -return(list): It is the list of QuoteObj related to the current Rol.
    ###
    @keyword
    def get_quotes( self , rol):
        if role == None:
            return []
        return role.get_quotes()
    ###
    # It return the quantity of the quotes related to the current Rol.
    # -param rol(RoleObj): It is the Rol to get the quotes.
    # -return(Int): It is the quantity of quotes related to the current Rol.
    ###
    @keyword
    def  get_quote_quantity(self, role):
        if role == None:
            return 0
        return role.quotes_quantity()
