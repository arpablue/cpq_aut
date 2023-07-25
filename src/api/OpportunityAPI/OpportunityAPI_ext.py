#from robot.libraris.BuiltIn import BuiltIn
from robot.api.deco import library
from robot.api.deco import keyword
from robot.api import logger
import sys
import os


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','obj','OpportunityObj')
sys.path.append( src_path )
from OpportunityObj import OpportunityObj

###
# It is extencion of the methods used to manage the data of the opportunity.
###
@library
class OpportunityAPI_ext:
        
    # It create a opportunity object using as base a dictionary.
    # -param dict(dictionary): It is the data used to crearte the opportunity object.
    # -return( OpportunityObj ) It is the opportunity created from the data.
    ###
    @keyword
    def create_from_data(self, dict ):
        res = OpportunityObj( dict )
        return res
    ###
    # It return true if a string contains another string.
    # -param str: It is the string where will be search.
    # -param substr: It is string to search in another string.
    # -return(bool): It is true if the str contains the substr.
    #@keyword
    #def string_contains_substr( self, str, substr):
    #    if str == None:
    #        return False
    #    if substr == None:
    #        return False
    #    if str.find( substr ) > 0 :
    #        return True
    #    return False
    ###
    # It is a flexible comparison. Both objects could have differents numbers of atributes,
    # but all attributes of the first object should be exists in the second object and they 
    # they should have the same values.
    # -param oppA(OpportunityObj) : It is the first opportunities to be compared.
    # -param oppB(OpportunityObj) :It is the second opportunity to be compared.
    ###
    @keyword
    def compare(self, oppA , oppB):
        if ( oppA == None ) and ( oppB == None ):
            return True
        if oppA == None :
            return False
        return oppA.compare_to( oppB )
    ###
    # It is a strict comparison. Both objects should have the same number of attributes,
    # the same attributes and the same values.
    # -param oppA(OpportunityObj) : It is the first opportunities to be compared.
    # -param oppB(OpportunityObj) :It is the second opportunity to be compared.
    ###
    @keyword
    def equal(self, oppA , oppB):
        if ( oppA == None ) and ( oppB == None ):
            return True
        if oppA == None :
            return False
        return oppA.equal( oppB )
    ###
    # It returnt the list of QuotesObj related to the current opportunity.
    # -param opp(OpportunityObj): It is the opportunity to get the quotes.
    # -return(list): It is the list of QuoteObj related to the current opportunity.
    ###
    @keyword
    def get_quotes( self , opp):
        if opp == None:
            return []
        return opp.get_quotes()
    ###
    # It return the quantity of the quotes related to the current opportunity.
    # -param opp(OpportunityObj): It is the opportunity to get the quotes.
    # -return(Int): It is the quantity of quotes related to the current opportunity.
    ###
    @keyword
    def  get_quotes_quantity(self, opp):
        if opp == None:
            return 0
        return opp.quotes_quantity()
    
    