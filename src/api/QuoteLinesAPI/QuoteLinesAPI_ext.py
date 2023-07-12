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
    # -param dict(dictionary): It is the data used to crearte the Quote object.
    # -return( QuoteObj ) It is the Quote created from the data.
    ###
    @keyword
    def create_from_data(self, dict ):
        res = QuoteLinesObj( dict )
        return res
    ###
    # It is a flexible comparison. Both objects could have differents numbers of atributes,
    # but all attributes of the first object should be exists in the second object and they 
    # they should have the same values.
    # -param quoteA(QuoteObj) : It is the first quotes to be compared.
    # -param quoteB(QuoteObj) :It is the second Quote to be compared.
    ###
    @keyword
    def compare(self, quoteA , quoteB):
        if ( quoteA == None ) and ( quoteB == None ):
            return True
        if quoteA == None :
            return False
        return quoteA.compare_to( quoteB )
    ###
    # It is a strict comparison. Both objects should have the same number of attributes,
    # the same attributes and the same values.
    # -param quoteA(QuoteObj) : It is the first quotes to be compared.
    # -param quoteB(QuoteObj) :It is the second Quote to be compared.
    ###
    @keyword
    def equal(self, quoteA , quoteB):
        if ( quoteA == None ) and ( quoteB == None ):
            return True
        if quoteA == None :
            return False
        return quoteA.equal( quoteB )
