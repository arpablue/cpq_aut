import sys
import os

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','http_requests','ContextAPI')
sys.path.append( src_path )
from ContextAPI import ContextAPI

class ValidationAPI(ContextAPI):
    ###
    # Default constructor.
    ###
    def __init__(self) -> None:
        super().__init__()
    
        ###
    # It is verify that is a valid code, this means the code could be a success or a not found.
    # -param code(String): It is the code to be verified if is a valid code.
    # -return(Bool): It is true if is a valid code.
    ###
    def is_valid_code( self, code ):
        code = str( code )
        code = int( code )
        if ( 199 < code ) and ( code < 300 ):
            return True
        nfcode = self.get_code_for( 'NotFound' )
        nfcode = str( nfcode )
        nfcode = int( nfcode )
        return code == nfcode
    
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
    def evaluate_Success_Get(self, code):
        return self.evaluate_response_code( 'Success_Get' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_Success_Get( self, code, msg=None ):
        self.verification_response_code( 'Success_Get' ,code , msg )
        
    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_Success_Get_NoContent(self, code):
        return self.evaluate_response_code( 'Success_Get_NoContent' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_Success_Get_NoContent( self, code, msg=None ):
        self.verification_response_code( 'Success_Get_NoContent' ,code , msg )
        
    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_Success_Post(self, code):
        return self.evaluate_response_code( 'Success_Post' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_Success_Post( self, code, msg=None ):
        self.verification_response_code( 'Success_Post' ,code , msg )

    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_Success_Post_NoContent(self, code):
        return self.evaluate_response_code( 'Success_Post_NoContent' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_Success_Post_NoContent( self, code, msg=None ):
        self.verification_response_code( 'Success_Post_NoContent' , code , msg )
    
    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_Success_Put(self, code):
        return self.evaluate_response_code( 'Success_Put' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_Success_Put( self, code, msg=None ):
        self.verification_response_code( 'Success_Put' ,code , msg )
    
    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_Success_Put_NoContent(self, code):
        return self.evaluate_response_code( 'Success_Put_NoContent' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_Success_Put_NoContent( self, code, msg=None ):
        self.verification_response_code( 'Success_Put_NoContent' ,code , msg )

    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_Success_Delete(self, code):
        return self.evaluate_response_code( 'Success_Delete' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_Success_Delete( self, code, msg=None ):
        self.verification_response_code( 'Success_Delete' ,code , msg )

    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_Success_Delete_NoContent(self, code):
        return self.evaluate_response_code( 'Success_Delete_NoContent' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_Success_Delete_NoContent( self, code, msg=None ):
        self.verification_response_code( 'Success_Delete_NoContent' ,code , msg )

    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_Success_Patch(self, code):
        return self.evaluate_response_code( 'Success_Patch' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_Success_Patch( self, code, msg=None ):
        self.verification_response_code( 'Success_Patch' , code , msg )

    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_Success_Patch_NoContent(self, code):
        return self.evaluate_response_code( 'Success_Patch_NoContent' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_Success_Patch_NoContent( self, code, msg=None ):
        self.verification_response_code( 'Success_Patch_NoContent' , code , msg )

    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_No_User(self, code):
        return self.evaluate_response_code( 'No_User' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_No_User( self, code, msg=None ):
        self.verification_response_code( 'No_User' , code , msg )

    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_Unauthorized_Access(self, code):
        return self.evaluate_response_code( 'Unauthorized_Access' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_Unauthorized_Access( self, code, msg=None ):
        self.verification_response_code( 'Unauthorized_Access' , code , msg )

    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_Forbidden(self, code):
        return self.evaluate_response_code( 'Forbidden' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_Forbidden( self, code, msg=None ):
        self.verification_response_code( 'Forbidden' , code , msg )

    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_NotFound(self, code):
        return self.evaluate_response_code( 'NotFound' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_NotFound( self, code, msg=None ):
        self.verification_response_code( 'NotFound' , code , msg )

    ###
    # It evaluate the current code with the expected code of Success_Get according to the execution context.
    # -param code(String): It is the code to be evualeted.
    # -return(Bool): It is the true if the code es equalst to the evaluated code.
    ###
    def evaluate_Server_Error(self, code):
        return self.evaluate_response_code( 'Server_Error' , code )
    ###
    # It verify the code is the same than the expected code. If the code is not the expected
    # then a FAIL exception is raised to stop the execution of the step.
    # -param code(String/Int): It is the code to be verified.
    ###
    def verification_Server_Error( self, code, msg=None ):
        self.verification_response_code( 'Server_Error' ,code, msg )

