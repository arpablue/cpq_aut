import sys
import os


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','http_requests','ValidationAPI')
sys.path.append( src_path )
from ValidationAPI import ValidationAPI


class DataAPI(ValidationAPI):
    ###
    # Default constructor.
    ###
    def ___init__():
        super().__init__()
    # It is a flexible comparison. Both objects could have differents numbers of atributes,
    # but all attributes of the first object should be exists in the second object , but not necessary have the same values.
    # -param objA(DataObj) : It is the first objects to be compared.
    # -param objB(DataObj) :It is the second obj to be compared.
    ###
    def compare_attr(self, objA , objB):
        if ( objA == None ) and ( objB == None ):
            return True
        if objA == None :
            return False
        return objA.compare_attr( objB )
    # It is a flexible comparison. Both objects could have differents numbers of atributes,
    # but all attributes of the first object should be exists in the second object and they 
    # they should have the same values.
    # -param objA(DataObj) : It is the first objects to be compared.
    # -param objB(DataObj) :It is the second obj to be compared.
    ###
    def compare(self, objA , objB):
        if ( objA == None ) and ( objB == None ):
            return True
        if objA == None :
            return False
        return objA.compare_to( objB )
    ### 
    # It is a strict comparison. Both objects should have the same number of attributes,
    # the same attributes and the same values.
    # -param objA(DataObj) : It is the first objects to be compared.
    # -param objB(DataObj) :It is the second obj to be compared.
    ###
    def equal(self, objA , objB):
        if ( objA == None ) and ( objB == None ):
            return True
        if objA == None :
            return False
        return objA.equal( objB )

