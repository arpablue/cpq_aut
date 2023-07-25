import sys
import os
import json
from robot.api import logger

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','obj','BaseObj')
sys.path.append( src_path )

from BaseObj import BaseObj

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','obj','QuoteObj')
sys.path.append( src_path )

from QuoteObj import QuoteObj

class OpportunityObj( BaseObj ):
    ###
    # Default constructor, it sa as parmeter the data of the object, if the data is None then the data of the quote will be empty.
    # -params dictData(dictionary): It is the data used by the quote, by default is empty.
    ###
    def __init__(self, dictData = {}) -> None:
        super().__init__( dictData )
        self.mAttrs = dictData
        if self.mAttrs == None :
            self.mAttrs = {}
        self.mQuotes = []
        self.get_quote_list()
    ###
    # It is get the list of the quotes from a collection of data  related to the opportunity.
    ###
    def get_quote_list( self ):
        if self.mQuotes == None:
            self.mQuotes = []
        if  'quotes' in self.mAttrs:
            quotes = self.mAttrs['quotes']
            for quote in quotes:
                qt = QuoteObj( quote )
                self.mQuotes.append( qt )
    ###
    # It returnt the quantity of the quotes.         
    ###
    def quotes_quantity( self ):
        if self.mQuotes == None:
            return 0
        return len( self.mQuotes )
    ###
    # It return the list of quotes realted to the opprtunity.
    ###
    def get_quotes( self ):
        if self.mQuotes == None:
            return []
        return self.mQuotes
    