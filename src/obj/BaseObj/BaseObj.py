import json
import sys
import os

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','libs')
sys.path.append( src_path )

from GlobalTools import GlobalTools

###
# It is the base object of the ojcts for that and contains the commons methods.
###
class BaseObj:
    ###
    # Default constructor, it sa as parmeter the data of the object, if the data is None then the data of the quote will be empty.
    # -params dictData(dictionary): It is the data used by the quote, by default is empty.
    ###
    def __init__(self, dictData = {}) -> None:
        self.mGlobalTools = GlobalTools()
        self.set_data( dictData )
        if self.mAttrs == None :
            self.mAttrs = {}
    ###
    # It specify the attributes for the current object
    ###
    def set_data( self, data ):
        self.mAttrs = data
    ###
    # It return the list of attributes of the current oobject.
    # -return(list): It is the list of attributes.
    ###
    def keys(self):
        if self.mAttrs == None:
            return []
        return self.mAttrs.keys()
    ###
    # It return a list of all values of the attributes of the current object.
    # -return(List)
    ###
    def values(self):
        keys = self.keys()
        list = []
        for key in keys:
            value = self.mAttrs[ key ]
            list.append( value )
        return list
    ###
    # It return the data of the current quote in a strting using a json format.
    # -return(string): It is the data of the quote.
    ###
    def __str__(self):
        res = json.dumps( self.mAttrs )
        res = "{\"" + self.__class__.__name__ + "\":" + res + "}"
        return res
    ###
    # It return the ID if the current quote
    # -return(str): It is the value of the id.
    ###
    def get_id( self ):
        return self.Get( "id" )
    ###
    # It set a value to an attribute.
    # -param key(str): It is the name of key of the attribute.
    # -param value(any): It is the value assigned to the attrbite.
    ####
    def set( self, key, value ):
        self.mAttrs[ key ] = value
    ###
    # It evaluate est on format the to be used on the attributes of the current object.
    # -param key(string): It is the key to set on format.
    # -return(string): It is the key with format.
    def formatKey( self, key):
        key = str( key )
        key = key.strip()
        key = key.capitalize()
        return key
        
    ###
    # It return the value of an attribute or a key. If the value not exists then return None.
    # -param key(str): It is the name of the atrubue or the key
    # -return(any): It is the value of the atribute or the key
    def get( self, key ):
        if key == None:
            return None
        key = self.formatKey( key )
        
        if self.exists( key ):
            return self.mAttrs[ key ]
        return None
    ###
    # It return true if a key exists in the attributes of the quote.
    # -param key(str): It is the attribute name or the key.
    # -return(bool): It is True id the key exists
    def exists( self, key):
        if key == None:
            return None
        key = self.formatKey( key )
        if key in self.mAttrs:
            return True
        return False
    ###
    # It return th number of the attributes of the current quote.
    # -return(int): It is the number of atributes.
    ###
    def size( self ):
        return len( self.mAttrs )
    ###
    # It compare some attributes with another opportubity object to verify if thay are the same object.
    # -param opportuity(quote): It is another quote objedt
    # -return(bool): It is True if both object has the same id.
    ###
    def is_this(self, quote):
        local_id = self.Get_ID()
        target_id = quote.get_id()
        if local_id == None :
            return False
        if target_id == None : 
            return False
        return local_id == target_id
    ###
    # It compare the current object with another object. 
    # This is a strict comparison, the values, attributes and numbers of attributes.
    # This method return true if the attributes and the value are the same.
    # -param target(quote): It is the object to be compared.
    # -return(bool): It is true both objects are the same.
    ###
    def equal( self, target ):
        self.mGlobalTools.action('Verify if are the objects are equals:')
        self.mGlobalTools.action('    Object A: ' + str( self.__str__() ) )
        self.mGlobalTools.action('    Object B: ' + str( target.__str__() ) )
        if  target == None :
            self.mGlobalTools.warning('It is not possible compare the current object wit a NULL object.')
            return False 
        if not self.size() == target.size():
            self.mGlobalTools.warning('The quantity of atributes are differents.')
            return False
        attrs = target.mAttrs
        my_attrs = self.mAttrs
        res = True
        for key in my_attrs:
            if not key in attrs:
                res = False
                self.warning('The [' + key + '] key the attribute is not present in the second object.')
                continue
            if not my_attrs[ key ] == attrs[ key ]:
                self.warning('The [' + key + '] key value is different in both objects:')
                self.warning('    - Value A:  ' + str( my_attrs[ key ] ) )
                self.warning('    - Value B:  ' + str( attrs[ key ] ) )
                res = False
        return res
    ###
    # It compare the current object with another object. It is a flexible comparison ( keys and values ).
    # This method return true if the keys and the value are the same, It is possible that
    # the target object have more attributes, these are not covered, only the attriutes of
    # the current object.
    # -param target(quote): It is the quote to be compared.
    # -return(bool): It is true bot opportunities are the same.
    ###
    def compare_to( self, target ):
        if(  target == None ):
            self.mGlobalTools.warning('It is not possible compare the current object wit a NULL object.')
            return False
        self.mGlobalTools.action('Comparing the Object A with the Object B:')
        self.mGlobalTools.action('    Object A: ' + str( self.__str__() ) )
        self.mGlobalTools.action('    Object B: ' + str( target.__str__() ) )
        attrs = target.mAttrs
        my_attrs = self.mAttrs
        res = True
        for key in my_attrs:
            if not key in attrs:
                self.mGlobalTools.warning('The [' + key + '] key the attribute is not present in the second object.')
                res = False
                continue
                
            if not my_attrs[ key ] == attrs[ key ]:
                self.mGlobalTools.warning('The [' + key + '] key value is different in both objects:')
                self.mGlobalTools.warning('    - Value A:  ' + str( my_attrs[ key ] ) )
                self.mGlobalTools.warning('    - Value B:  ' + str( attrs[ key ] ) )
                res = False
        return res
   ###
   # It compare two object, It is a key evaluation.
   # It compare the attributes of each object,  but not the values of the attributes.
   # -param target(Object): It is the object to comkpare.
   # -return(bool): It is true if both objects has the samñe number of attributes and attributes.
    def compare_attrs( self, target):
        if(  target == None ):
            self.mGlobalTools.warning('It is not possible compare the current object wit a NULL object.')
            return False
        self.mGlobalTools.action('Comparing the aattributes of the Object A with object B (Only attributes):')
        self.mGlobalTools.action('    Object A: ' + str( self.__str__() ) )
        self.mGlobalTools.action('    Object B: ' + str( target.__str__() ) )       
        attrs = target.mAttrs
        my_attrs = self.mAttrs
        for key in my_attrs:
            if not key in attrs:
                self.mGlobalTools.warning('The [' + key + '] key the attribute is not present in the second object.')
                return False
        return True
    ###
    # It return a dictionary of the attributes and values that are different in the quote to be compared.
    # It the all the attributes and value are equals then the return a empty list.
    # -params target(quote): It is the quote to be compared
    # -return(dictionary): It is the dictionary with the attributes and values that are different in the quote to be compared.
    ###
    def get_different_values( self, target):
        res = {}
        if target == None:
            return self.mAttrs.keys()
        attrs = target.mAttrs
        for key in self.mAttrs:
            if not key in attrs:
                res[ key ] = None
            if not self.mAttrs[ key ] == attrs[ key ]:
                res[ key ] = attrs[ key ]
        return res
