#from robot.libraris.BuiltIn import BuiltIn
from robot.api.deco import library
from robot.api.deco import keyword
from robot.api import logger
import sys
import os

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','obj','QuoteLinesObj')
sys.path.append( src_path )

from QuoteLinesObj import QuoteLinesObj

@library
class QuoteLinesAPI_ext:
        
    # It create a Quote object using as base a dictionary.
    # -param dict(Dictionary): It is the data used to crearte the Quote object.
    # -return(QuoteLinesObj) It is the QuoteLines created from the data.
    ###
    @keyword
    def create_from_data(self, dict ):
        res = QuoteLinesObj( dict )
        return res
    ###
    # It is a flexible comparison. Both objects could have differents numbers of atributes,
    # but all attributes of the first object should exists in the second object and they 
    # they should have the same values.
    # -param objA(QuoteLinesObj) : It is the first QuoteLines to be compared.
    # -param objB(QuoteLinesObj) :It is the second QuoteLines to be compared.
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
    # -param objA(QuoteLinesObj) : It is the first QuoteLines to be compared.
    # -param objB(QuoteLinesObj) :It is the second QuoteLines to be compared.
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
    # -param objA(QuoteLinesObj) : It is the first QuoteLines to be compared.
    # -param objB(QuoteLinesObj) :It is the second QuoteLines to be compared.
    ###
    @keyword
    def equal(self, objA , objB):
        if ( objA == None ) and ( objB == None ):
            return True
        if objA == None :
            return False
        return objA.equal( objB )
