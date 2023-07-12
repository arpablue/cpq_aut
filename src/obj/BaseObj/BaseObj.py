import json
###
# It is the base object of the ojcts for that and contains the commons methods.
###
class BaseObj:
    ###
    # Default constructor, it sa as parmeter the data of the object, if the data is None then the data of the quote will be empty.
    # -params dictData(dictionary): It is the data used by the quote, by default is empty.
    ###
    def __init__(self, dictData = {}) -> None:
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
    # It return the value of an attribute or a key. If the value not exists then return None.
    # -param key(str): It is the name of the atrubue or the key
    # -return(any): It is the value of the atribute or the key
    def get( self, key ):
        if self.exits( key ):
            return self.mAttrs[ key ]
        return None
    ###
    # It return true if a key exists in the attributes of the quote.
    # -param key(str): It is the attribute name or the key.
    # -return(bool): It is True id the key exists
    def exits( self, key):
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
    # It compare the current comparet the curretn object with another opportuinity.
    # This method return true if the keys and the value are the same, It is possible that
    # the target object have more attributes, these are not covered, only the attriutes of
    # the current object.
    # -param target(quote): It is the quote to be compared.
    # -return(bool): It is true bot opportunities are the same.
    ###
    def compare_to( self, target ):
       if(  target == None ):
           return False
       attrs = target.mAttrs
       my_attrs = self.mAttrs
       for key in my_attrs:
           if not key in attrs:
               return False
           if not my_attrs[ key ] == attrs[ key ]:
               return False
       return True
       ###
    # It compare the current comparet the curretn oppportunity with another opportuinity.
    # This method return true if the keys and the value are the same.
    # -param opp(quote): It is the quote to be compared.
    # -return(bool): It is true bot opportunities are the same.
    ###
    def equal( self, opp ):
       if(  opp == None ):
           return False
       if not self.size() == opp.size():
           return False
       attrs = opp.mAttrs
       my_attrs = self.mAttrs
       for key in my_attrs:
           if not key in attrs:
               return False
           if not my_attrs[ key ] == attrs[ key ]:
               return False
       return True
    ###
    # It return a dictionary of the keys and values that are different in the quote to be compared.
    # It the all the keys and value are equals then the return a empty list.
    # -params opp(quote): It is the quote to be compared
    # -return(dictionary): It is the dictionary with the keys and values that are different in the quote to be compared.
    ###
    def get_different_values( self, opp):
        res = {}
        if opp == None:
            return self.mAttrs.keys()
        attrs = opp.mAttrs
        for key in self.mAttrs:
            if not key in attrs:
                res[ key ] = None
            if not self.mAttrs[ key ] == attrs[ key ]:
                res[ key ] = attrs[ key ]
        return res
