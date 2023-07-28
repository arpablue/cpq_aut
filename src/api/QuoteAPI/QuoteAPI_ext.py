#from robot.libraris.BuiltIn import BuiltIn
from robot.api.deco import library
from robot.api.deco import keyword
from robot.api import logger
import sys
import os

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','obj','QuoteObj')
sys.path.append( src_path )

from QuoteObj import QuoteObj

###
# It is extencion of the methods used to manage the data of the Quote.
###
@library
class QuoteAPI_ext:
    # It create a Quote object using as base a dictionary.
    # -param dict(Dictionary): It is the data used to crearte the Quote object.
    # -return( QuoteObj ) It is the Quote created from the data.
    ###
    @keyword
    def create_from_data(self, dict ):
        res = QuoteObj( dict )
        return res
    ###
    # It is a flexible comparison. Both objects could have differents numbers of atributes,
    # but all attributes of the first object should exists in the second object and they 
    # they should have the same values.
    # -param objA(QuoteObj) : It is the first quotes to be compared.
    # -param objB(QuoteObj) :It is the second Quote to be compared.
    ###
    @keyword
    def compare(self, objA , objB):
        if ( objA == None ) and ( objB == None ):
            return True
        if objA == None :
            return False
        return objA.compare_to( objB )
    ###
    # It is a flexible comparison. Both objects could have differents numbers of atributes,
    # but all attributes of the first object should exists in the second object and they 
    # they should have the same values.
    # -param objA(QuoteObj) : It is the first quotes to be compared.
    # -param objB(QuoteObj) :It is the second Quote to be compared.
    ###
    @keyword
    def compare_attrs(self, objA , objB):
        if ( objA == None ) and ( objB == None ):
            return True
        if objA == None :
            return False
        return objA.compare_attrs( objB )
###
    # It is a strict comparison. Both objects should have the same number of attributes,
    # the same attributes and the same values.
    # -param objA(QuoteObj) : It is the first quotes to be compared.
    # -param objB(QuoteObj) :It is the second Quote to be compared.
    ###
    @keyword
    def equal(self, objA , objB):
        if ( objA == None ) and ( objB == None ):
            return True
        if objA == None :
            return False
        return objA.equal( objB )
        