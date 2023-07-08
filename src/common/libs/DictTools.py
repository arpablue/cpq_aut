import sys
import os
from robot.api.deco import library
from robot.api.deco import keyword
from robot.api import logger

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','commons','libs')
sys.path.append( src_path )
from GlobalTools import GlobalTools
###
# It contain the method to process the dictionaries
###
@library
class DictTools:
    ###
    # Defautl constructor.
    ###
    def __init__(self):
        self.mGlobal = GlobalTools()
    ################################ Dictionary ################################
    ###
    # It verify if a key exists in a dictionary.
    ###
    @keyword
    def dictionary_this_key_exists(self, list, key):
        if list == None :
            return False
        if key == None:
            return False
        if key in list:
            return True
        return False
    ###
    # It return the keys that exists in the dictionary A not exist in the dictionary B.
    # -param dictA(dictionary): It is the dictionary to get the key to be verified.
    # -param dictB(dictionary): It is the dictionary to verify the keys if the dictionary exists in this dictionary.
    # -return(list): It is the list of keys from the dictionary A that exists in the dictionary B.
    ###
    @keyword
    def Get_list_keys_exists(self, dictA, dictB ):
        res = []
        if ( ( dictA == None ) and ( dictB == None ) ):
            return res
        if dictA == None:
            return res
        if dictB == None:
            return res
        for key in dictA:
            if key in dictB:
                res.append(key)
        return res
    ###
    # It return true if a string contains another string.
    # -param str: It is the string where will be search.
    # -param substr: It is string to search in another string.
    # -return(bool): It is true if the str contains the substr.
    @keyword
    def string_contains_substr( self, str, substr):
        if str == None:
            return False
        if substr == None:
            return False
        if str.find( substr ) > 0 :
            return True
        return False
    ###    
    ###
    # It return the keys that not exists in the dictionary A not exist in the dictionary B.
    # -param dictA(dictionary): It is the dictionary to get the key to be verified.
    # -param dictB(dictionary): It is the dictionary to verify the keys if the dictionary exists in this dictionary.
    # -return(list): It is the list of keys from the dictionary A that not exists in the dictionary B,
    ###
    @keyword
    def Get_list_keys_not_exists(self, dictA, dictB ):
        res = []
        if ( ( dictA == None ) and ( dictB == None ) ):
            return res
        if dictA == None:
            return res
        if dictB == None:
            return res
        for key in dictA:
            if not key in dictB:
                res.append(key)
        return res
    ###
    # It return the list of the keys that not exists or have differents values in both dictionaries.
    # -param dictA(dictionary): It is the first dictionary to verify the keys.
    # -param dictB(dictionary): It is the second dictionary to verify the keys if the dictionary exists in this dictionary.
    # -return(list): It is the list of keys with differents values.
    ###
    @keyword
    def Get_list_not_equals_keys( self, dictA, dictB):
        res = []
        if ( dictA == None ) and ( dictB == None ):            
            return res
        if dictA == None:
            return res
        if dictB == None:
            return dictA.keys()
        attrs = self.mGlobal.list_concat_unique_values( dictA.keys() , dictB.keys() )
        for attr in attrs:
            valueA = dictA.get( attr )
            valueB = dictB.get( attr )
            if not valueA == valueB:
                res.append( attr )
            
        return res
    ################################ Objects ################################
    ###
    # It returnthe quantity of attributes that have difference values in both atributes.
    # -param objA(Object): It is the first object to get the differences.
    # -param objB(Object): It is the second object to get the differences
    # -return(list): It is the list of jçkeys with different values in both objects.
    ###
    @keyword
    def objects_get_differences( self, objA, objB ):
        res = []
        if ( objA == None ) and ( objB == None ):
            return res
        if objA == None:
            return objB.mAttrs.keys()
        if objB == None:
            return objA.mAttrs.keys()
        list = self.Get_list_not_equals_keys( objA.mAttrs, objB.mAttrs )
        return list
    ###
    # It returnt the vaue of attribute from an object. If the attribute not exist then return None.
    # -param obj(Object): It is the object where get the atribute value.
    # -param attr(string): It is the name of the attribute.
    # -return(any): It is the value of the aattribute.
    ###
    @keyword
    def object_get_attribute( self, obj, attr):
        if obj == None:
            return None
        return obj.get( attr )
    def printing(self, toShow, text ):
        if not toShow == None:
            toShow.wrtite( text )
    ###
    # It print in console th values of two objects in base a list of attributes.
    # -param objA(Object): It is the first object to display the object.
    # -param objB(Object): It is the second object to display the attributes.
    # -param attrs(list): It is the list of attibutes.
    ###
    @keyword
    def object_diplay_atributes(self, objA, objB, attrs, toShow = None):
        if ( objA == None ) and ( objB == None ):
            return res
        if objA == None:
            self.printing( toShow, "Warning ( object_diplay_atributes ): The first parameter cannot be NONE." )
            return
        if objB == None:
            self.printing( toShow, "Warning ( object_diplay_atributes ): The second parameter cannot be NONE." )
            return
        if attrs == None:
            self.printing( toShow, "Warning ( object_diplay_atributes ): The attrs parameter cannot be NONE." )
            return
        self.printing( toShow, "=== List of attributes ===")
        for attr in attrs:
            self.printing( toShow, "- Atrtibute: " + str( attr ) )
            value = objA.get( attr )
            if value == None:
                self.printing( toShow, "\t\tValue A: None")
            else:
                self.printing( toShow, "\t\tvalue A: " + str( value ) )
            value = objB.get( attr )
            if value == None:
                self.printing( toShow, "\t\tValue B: None")
            else:
                self.printing( toShow, "\t\tValue B: " + str( value ) )
        self.printing( toShow, "==========================")
            
