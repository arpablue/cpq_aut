

##########
# Mierda
###########
class Context:
    ###
    # Default constructor.
    # -param name(String): It is the name of the context.
    ###
    def __init__( self, name= None) -> None:
        self.mData = None
        self.mName = name
        self.mUrl = "url"
        self.mDomain = "domain"
        self.mCodes = "http_codes"
        
        self.mSuccess_Get = "Success_Get"
        self.mSuccess_Get_NoContent = "Success_Get_NoContent"
        self.mSuccess_Post = "Success_Post"
        self.mSuccess_Post_NoContent = "Success_Post_NoContent"
        self.mSuccess_Put = "Success_Put"
        self.mSuccess_Put_NoContent = "Success_Put_NoContent"
        self.mSuccess_Delete = "Success_Delete"
        self.mSuccess_Delete_NoContent = "Success_Delete_NoContent"
        self.mSuccess_Patch = "Success_Patch"
        self.mSuccess_Patch_NoContent = "Success_Patch_NoContent"
        self.mNo_User = "No_User"
        self.mUnauthorized_Access = "Unauthorized_Access"
        self.mForbidden = "Forbidden"
        self.mServer_Error = "Server_Error"
    ###
    # It return the tuype and the name of the name of the current context.
    # -return(String): It is the string of the current 
    ###
    def __str__(self):
        return str( '{"Objcet":"Context","name":"' + self.get_name() + '"}' )
    ###
    # It specify the data for the context.
    # -param data(Dictionary): It is the data used as context.
    ###
    def set_data( self, data ):
        self.mData = data
    ###
    # It return the name of the current context.
    # -return(String): It is the name of the current name.
    ###
    def get_name( self ):
        return self.mName
    ###
    # It set the name for the current context.
    # -param name(String): It is the neam of the current name.
    ###
    def set_name( self, name ):
        self.mName = name
    ###
    # It return the current 
    def get_url( self ):    
        if self.mData == None:
            return None
        if not self.mUrl in self.mData:
            return None
        return self.mData[ self.mUrl ]
    
    def get_domain( self ):
        if self.mData == None:
            return None
        if not self.mDomain in self.mData:
            return None
        return self.mData[ self.mDomain ]
    
    
    def get_code( self, code):
        
        if code == None:
            return 
        if self.mData == None:
            return None
        if not self.mCodes in self.mData:
            return None
        codes = self.mData[self.mCodes]
        if not code in codes:
            return None
        return codes[ code ]
        
    def get_Success_Get( self ):
        return self.get_code( self.mSuccess_Get )
    def get_Success_Get_NoContent( self ):
        return self.get_code( self.mSuccess_Get_NoContent )
    def get_Success_Post( self ):
        return self.get_code( self.mSuccess_Post )
    def get_Success_Post_NoContent( self ):
        return self.get_code( self.mSuccess_Post_NoContent )
    def get_Success_Put( self ):
        return self.get_code( self.mSuccess_Put )
    def get_Success_Put_NoContent( self ):
        return self.get_code( self.mSuccess_Put_NoContent )
    def get_Success_Delete( self ):
        return self.get_code( self.mSuccess_Delete )
    def get_Success_Delete_NoContent( self ):
        return self.get_code( self.mSuccess_Delete_NoContent )
    def get_Success_Patch( self ):
        return self.get_code( self.mSuccess_Patch )
    def get_Success_Patch_NoContent( self ):
        return self.get_code( self.mSuccess_Patch_NoContent )
    def get_No_User( self ):
        return self.get_code( self.mNo_User )
    def get_Unauthorized_Access( self ):
        return self.get_code( self.mUnauthorized_Access )
    def get_Forbidden( self ):
        return self.get_code( self.mForbidden )
    def get_Server_Error( self ):
        return self.get_code( self.mServer_Error )