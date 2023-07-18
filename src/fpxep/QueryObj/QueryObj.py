from robot.libraries.BuiltIn import BuildIn


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','Context','Context')
sys.path.append( src_path )
###
# It manage the query Objects require for FPX API
# .....Currently is blicked by change the objectives.
###
class QueryObj:
    def __init__(self) -> None:
        self.mRequest = BuiltIn().get_library_instance('RequestsLibrary')
        self.mHeaders = None
        self.mCookies = None
        self.mUrl = '/api/cpq/object/'
        self.mContext = 
    def set_Headers( self, headers ):
        self.mHeaders = headers
    def set_cookies( self, cookies ):
        self.mCookies = cookies
    def http_get( url , params=None):
        response = self.mRequest.get_request( url, params=params, headers=self.mHeaders, cookies=self.mCookies )
        return response
    ###ef get_data()
    ###
    ###
        
    