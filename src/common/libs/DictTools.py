import sys
import os
import string
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
            self.mGlobal.warning("It is not possible get a value of an attribute for a None object.")
            return None
        if attr == None:
            self.mGlobal.warning("It is not poissible get an attribute when this attribute is none value.")
            return None
        
        attr = attr.capitalize()
        value = obj.get( attr )
        self.mGlobal.write( "Getting attribute: " + str( attr) + " = " + str( value ) )
        return value
    ####
    # It verify is an attribute exists in an object, the attribute is capitalized to verify if the object exists.
    # -param obj(BaseObj): It is the object where the attribute will be verified.
    # -param attr(string): It is the attribute to be search.
    # -return(bool): It is true if the attribute exists.
    ###
    @keyword
    def object_attribute_exists( self, obj, attr ):
        if obj == None:
            self.mGlobal.warning("It is not possible know if an attribute exist if the object is NULL.")
            return None
        if attr == None:
            self.mGlobal.warning("It is not possible if an NULL attribute exists in açn object.")
            return None
        attr = attr.capitalize()
        res = obj.exists( attr )
        if res == False:
            self.mGlobal.error('The [' + attr + '] attribute not exists. In the object: ' + str( obj ) )
        return res
    ####
    # It verify is an attribute exists in an object, the attribute is capitalized to verify if the object exists.
    # It the attribute not exists then a FAIL exception is raised and stop the execution.
    # -param obj(BaseObj): It is the object where the attribute will be verified.
    # -param attr(string): It is the attribute to be search.
    ###
    @keyword
    def object_attribute_should_exists( self, obj, attr ):
        if obj == None:
            self.mGlobal.warning("It is not possible know if an attribute exist if the object is NULL.")
            return None
        if attr == None:
            self.mGlobal.warning("It is not possible if an NULL attribute exists in an object.")
            return None
        attr = attr.capitalize()
        res = obj.exists( attr )
        if res == False:
            self.mGlobal.failed('The [' + attr + '] attribute not exists. In the object: ' + str( obj ) )
    ###
    # It call a write() method to raise a message-
    # -param toShow( Logger ): It is th elog object ot raise message.
    # -param text(String): It is a message that will be raised the message.
    ###
    def printing(self, toShow, text ):
        if not toShow == None:
            toShow.write( text )
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
    ###
    # It create a dictionary using 2 list, the first list are the keys and the second the values, the dictionary use all keys,
    # if the values are shoter than the keyes then the rest of keys will have a None value.
    # -param keys(list): It is the list of keys used for the dictionary.
    # -param values(list): It is the list of values used for the dictionary.
    # -return(dictionary): It is the dictionary crated in base of the list used as parameters.
    ###
    @keyword
    def dictionary_create_from_lists(self, keys, values):
        res = {}
        if keys == None:
            return res
        if values == None:
            values = []
        size = len( keys )
        size2 = len( values )
        for index in range( size ):
            key = keys[ index ]
            if index < size2 :
                value = values[ index ]
            else:
                value = None
            res[ key ] = value
        return res