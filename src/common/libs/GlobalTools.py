from robot.api.deco import library
from robot.api.deco import keyword
from robot.libraries.BuiltIn import BuiltIn
import os
import sys
import urllib.parse
import yaml

### Loading the TestActivitFile
dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','pylib')
sys.path.append( src_path )

from TestActivityFile import TestActivityFile

###Load the Context file.
dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','Context')
sys.path.append( src_path )
from ContextList import ContextList

# It contain the global method to process special action in the execution of the test cases
@library
class GlobalTools:
    ###
    # Default constructor.
    ###
    def __init__( self ):
        #self.mTLib = TestLib()
        self.mBI = BuiltIn()
        globalvar = self.load_global_vars()
        
        self.mConsole_output = globalvar["console_output"]
        self.mFile_output = globalvar["file_output"]
        self.mExeutionContext = globalvar["context"]
        
        self.mTestActivityFile = TestActivityFile()
        
        contexts = ContextList()
        self.mContext = contexts.get_context( self.mExeutionContext )
    ###
    # It return the quantity of elements of a list. If the list is empty or null then the method return 0.
     # -param list(List): It is the list to count the quantity of elements.
     # -return(Int): It is the quantity of elements of the list.
     ###
    @keyword
    def list_size( self, list ):
        size = 0
        if list == None:
            return size
        for element in list:
            size = size + 1
        return size
    
    ###
    # It load the globals var of the projects in the config.yml file.
    ##
    def load_global_vars( self ):
        pathFile = self.get_prj_folder('config.yml')
        with open( pathFile, 'r' ) as file:
            data = yaml.safe_load( file )
        return data

    ###
    # It return true if a string contains another string.
    # -param str: It is the string where will be search.
    # -param substr: It is string to search in another string.
    # -return(bool): It is true if the str contains the substr.
    @keyword
    def string_contains_substr( self, strg, substrg):
        if strg == None:
            return False
        if substrg == None:
            return False
        strg = str( strg )
        substrg = str( substrg )
        substrg = substrg.strip()
        flag =  strg.find( strg )
        flag = flag > -1
        if  flag  :
            return True
        return False
    ###
    # It return the type of a variable.
    # -param target(any): It is the a variable.
    # -return(string): It is the string with type of the variable.
    @keyword
    def get_type(self, target ):
        return type( target ) 
    ###
    # It return a value of an attribute of an object, if the attribute not exists then return None.
    # -param obj(Object): It is the object to get the attribute.
    # -param attr(string): It is the name of the attribute if the object.
    # -return(any): It is the value of the attribute of the object.
    ###
    @keyword
    def get_attribute(self, obj, attr):
        if obj == None :
            return None
        if attr == None:
            return None
        if attr in obj.mAttrs:
            return obj.mAttrs[ attr ]
        return None
    ###
    # It compare the compare two objects. It is a flexible comparison, only compare
    # the atributes and the values of the first object.
    # -param objA(Dictionary): It is the firts opbjet to compare, it wikk use the attributes of the first object.
    # -param objB(Dictionary): It is the second object to be compared.
    # -return(Bool): It return true if bot objects are equals.
    ###
    @keyword
    def objects_are_equals( self, objA, objB):
        res = objA.equal( objB )
        return res
    ###
    # It compare the compare two objects. It evaluate that both objects should have the same keys.
    # the values of the attributes are not evaluated.
    # the atributes and the values of the first object.
    # -param objA(Dictionary): It is the firts opbjet to compare, it will use the attributes of the first object.
    # -param objB(Dictionary): It is the second object to be compared.
    # -return(Bool): It return true if bot objects are equals.
    ###
    @keyword
    def object_compare( self, objA, objB):
        res = objA.compare_to( objB )
        return res
    ###
    # It evaluate if two objectas are equals. It is is a strict comparison, both objects should have the same attributes
    # and values.
    # -param objA(Dictionary): It is the firts opbjet ot compare
    # -param objB(Dictionary): It is the second object to be compared.
    # -return(Bool): It return true if bot objects are equals.
    ###
    @keyword
    def object_compare_attrs( self, objA, objB):
        res = objA.compare_attrs( objB )
        return res
    ###
    # It add a value to a list, if the value exists in the list then the value is not added.
    # -param list(list): It is the list where the value will be added.
    # -param value(any): It is the element to be added to be added to the list.
    ###
    @keyword
    def list_add_unique_value(self, list, value):
        if list == None:
            return
        if value == None:
            return
        if not value in list:
            list.append( value )
    ###
    # It concat two list, but in the list generated by this containsunique elments.
    # -param listA: It is the first list to be concated.
    # -param ListB: It is the second list to be concated.
    # -return(lisy): It is the result list with the unique elemnets.
    ####
    @keyword
    def list_concat_unique_values( self, listA, listB ):
        res = []
        if ( listA == None ) and ( listB == None ):
            return res
        if listA == None:
            return listB
        if listB == None:
            return listA
        res = listA
        for key in listB:
            if not key in listA:
                res.append( key )
        return res
    ###
    # It set on format a path.
    # -param pathFile(String): It is the path file used.
    ###
    def set_path_format(self, pathFile ):
        if pathFile == None:
            return ""
        pathFile = pathFile.replace("\\","/")
        parts = pathFile.split("/")
        pathFile = os.path.sep.join( parts)
        return pathFile
    ###
    # It return the project folder.
    # -return(String): It is the path of the project.
    ###
    @keyword
    def get_prj_folder(self, prjPath):
        if prjPath == None:
            rprjPath = ''
        prjPath = self.set_path_format( prjPath )
        dir = os.path.dirname( __file__ )
        src_pos = dir.index( 'src' )
        src_path = dir[ :src_pos ]
        src_path = src_path + prjPath
        sep = os.path.sep
        src_path = src_path.replace( sep + sep, sep )
        return src_path
    ###
    # It encode a string to URL format.
    # -param target(String): It is the string to encode to URL format.
    # -return(String): It is the string encoded.
    ###
    @keyword
    def url_encode( self, target ):
        if target == None:
            return None
        return urllib.parse.quote( target )
    ###
    # It decode a url to a comprensible string.
    # -param target(String): It is a string in URL format.
    # -return(String): It is the uncoded string.
    ###
    @keyword
    def url_decode( self, target ):
        if target == None:
            return None
        return urllib.parse.unquote( target )
    ########################### Log methods #####################################
    ###
    # It write a message in the console
    # text: It is the message to be displayed
    ###
    def display( self, text ):
        if  self.mConsole_output  == 1:
            logger.console( text )
        if  self.mFile_output == 1:
            self.mTestActivityFile.writeln( text )
    ###
    # It display a passed message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    @keyword
    def passed( self, text ):
        self.display( "PASS: " + str( text ) )
    ###
    # It display a success message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    @keyword
    def success( self, text ):
        self.display( "\t\tSUCCESS: " + str( text ) )
    ###
    # It display an unsuccess message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    @keyword
    def unsuccess( self, text ):
        self.display( "\t\tUNSUCCESS: " + str( text ) )
    ###
    # It display a warning message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    @keyword
    def warning( self, text ):
        self.display( "\t\tWARNING: " + str( text ) )
    ###
    # It display an info message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    @keyword
    def info( self, text ):
        self.display( "\t\tINFO: " + str( text ) )
    ###
    # It display a step message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    @keyword
    def step( self, text ):
        self.display( "\tSTEP: " + str( text ) )
    ###
    # It display a action message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    @keyword
    def action( self, text ):
        self.display( "\t\tACTION: " + str( text ) )
    ###
    # It display a write message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    @keyword
    def write( self, text ):
        self.display( "\t\t\t" + str( text ) )
    ###
    # It display a mistake message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    @keyword
    def mistake( self, text ):
        self.display( "\t\tMISTAKE: " + str( text ) )
    ###
    # It display a error message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    @keyword
    def error( self, text ):
        self.display( "\t\tERROR: " + str( text ) )
    ###
    # It display a failed message with a speific text.
    # -param text(String): It is the message to be displayed with the pass message.
    ###
    @keyword
    def failed( self, text ):
        self.display( "FAIL:" + str( text ) )
        raise Exception( str( text ) )

    ######################### Response Verification code ###########################
    ###
    # It is verify that is a valid code, this means the code could be a success or a not found.
    # -param code(String): It is the code to be verified if is a valid code.
    # -return(Bool): It is true if is a valid code.
    ###
    @keyword
    def is_valid_code( self, code ):
        code = str( code )
        code = int( code )
        if ( 199 < code ) and ( code < 300 ):
            return True
        nfcode = self.get_code_for( 'NotFound' )
        nfcode = str( nfcode )
        nfcode = int( nfcode )
        if code == nfcode:
            return True
        return code
    
    ###
    # It return a code for spcific response.
    # -param code_name(String): It is the name of the code of the response.
    # -return(String): It is the code of the request type
    ###
    def get_code_for( self, code_name ):
        return self.mContext.get_code( code_name)
    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_response_code( self,code_name, code):
        exp = self.mContext.get_code( code_name)
        exp = str( exp )
        code = str( code )
        if code == None:
            self.error('( GlobalTools - evaluetion_code_' + code_name + ' ): It is not possible verify a code for a NULL value.')
            return False
        if exp == None:
            self.error( '( GlobalsTools - evaluate_code_' + code_name + ' ): It is not possible verify the code because the expected result is NULL.')
            return False
        code = str( code )
        exp = str( exp )
        if not code == exp:
            self.warning('The current response code is not the same that expected code. exp[' + exp + '] vs cur[' + code + ']')
            return False
        return True
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_response_code( self, code_name, code, message=None ):
        flag = self.evaluate_response_code( code_name, code )
        code = str( code )
        if flag == False:
            msg = code_name +" - The current code is not the expected code. Currrent code [" + str( code ) + "]"
            if not message == None:

                msg = str( message ) + " - Current code[" + str( code ) +"]"
            self.failed( msg )






    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_Success_Get(self, code):
        return self.evaluate_response_code( 'Success_Get' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_Success_Get( self, code, msg=None ):
        self.verification_response_code( 'Success_Get' ,code , msg )
        
        
        
        
    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_Success_Get_NoContent(self, code):
        return self.evaluate_response_code( 'Success_Get_NoContent' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_Success_Get_NoContent( self, code, msg=None ):
        self.verification_response_code( 'Success_Get_NoContent' ,code , msg )



        
        
        
    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_Success_Post(self, code):
        return self.evaluate_response_code( 'Success_Post' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_Success_Post( self, code, msg=None ):
        self.verification_response_code( 'Success_Post' ,code , msg )





    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_Success_Post_NoContent(self, code):
        return self.evaluate_response_code( 'Success_Post_NoContent' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_Success_Post_NoContent( self, code, msg=None ):
        self.verification_response_code( 'Success_Post_NoContent' , code , msg )
    



    
    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_Success_Put(self, code):
        return self.evaluate_response_code( 'Success_Put' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_Success_Put( self, code, msg=None ):
        self.verification_response_code( 'Success_Put' ,code , msg )
        
        

    
    
    
    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_Success_Put_NoContent(self, code):
        return self.evaluate_response_code( 'Success_Put_NoContent' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_Success_Put_NoContent( self, code, msg=None ):
        self.verification_response_code( 'Success_Put_NoContent' ,code , msg )



    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_Success_Delete(self, code):
        return self.evaluate_response_code( 'Success_Delete' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_Success_Delete( self, code, msg=None ):
        self.verification_response_code( 'Success_Delete' ,code , msg )



    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_Success_Delete_NoContent(self, code):
        return self.evaluate_response_code( 'Success_Delete_NoContent' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_Success_Delete_NoContent( self, code, msg=None ):
        self.verification_response_code( 'Success_Delete_NoContent' ,code , msg )
        



    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_Success_Patch(self, code):
        return self.evaluate_response_code( 'Success_Patch' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_Success_Patch( self, code, msg=None ):
        self.verification_response_code( 'Success_Patch' , code , msg )
        



    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_Success_Patch_NoContent(self, code):
        return self.evaluate_response_code( 'Success_Patch_NoContent' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_Success_Patch_NoContent( self, code, msg=None ):
        self.verification_response_code( 'Success_Patch_NoContent' , code , msg )
        

    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_No_User(self, code):
        return self.evaluate_response_code( 'No_User' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_No_User( self, code, msg=None ):
        self.verification_response_code( 'No_User' , code , msg )



    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_Unauthorized_Access(self, code):
        return self.evaluate_response_code( 'Unauthorized_Access' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_Unauthorized_Access( self, code, msg=None ):
        self.verification_response_code( 'Unauthorized_Access' , code , msg )








    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_Forbidden(self, code):
        return self.evaluate_response_code( 'Forbidden' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_Forbidden( self, code, msg=None ):
        self.verification_response_code( 'Forbidden' , code , msg )






    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_NotFound(self, code):
        return self.evaluate_response_code( 'NotFound' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_NotFound( self, code, msg=None ):
        self.verification_response_code( 'NotFound' , code , msg )
    



    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    @keyword
    def evaluate_Server_Error(self, code):
        return self.evaluate_response_code( 'Server_Error' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    @keyword
    def verification_Server_Error( self, code, msg=None ):
        self.verification_response_code( 'Server_Error' ,code, msg )

