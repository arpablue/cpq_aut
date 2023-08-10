import os
import yaml
import requests
import json
from robot.libraries.BuiltIn import BuiltIn

###
# It contains the method to execute HTTP requests.
###
class HttpRequests:
    ###
    # Default constructor.
    ###
    def __init__( self ) -> None:
        self.mData = self.load_yml('config.yml')
        self.mEndPoint = None
    ###
    # It specify the endpoint to be used in the url.
    # -param endpoint(String): It is the endpoint to be used in the 
    def set_endpoint( self, endpoint ):
        self.mEndPoint = endpoint
    ###
    # It return the data of the global configuration
    # -return(Dictionary): It is the data of the global configuration.
    ###
    def get_data( self ):
        return self.mData
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
    # It return the complete path içsuing the project as base or the src folder as a base.
    # -param prjPath(String): It is the path in the project, it is in base of the project folder as the base of the path.
    # -return(String): It is the path of the project.
    ###
    def get_path(self, prjPath):
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
    # It load the content of a file. If the file not exists then the dictionary is empty.
    # -param path(String) : It is the path of the YAML file.
    # -return(Dictionary): It is a dictionary of the values and attributes specified in the file.
    ###
    def load_yml( self, path ):
        path = self.get_path( path )
        with open( path , 'r' ) as file:
            data = yaml.safe_load( file )
        return data
    def get_url( self ):
        return self.mData[ 'url' ]
    def get_token(self):
        return self.mData[ 'token' ]
    
    def create_session( self ):
        print(  'Under develolpment' )
    def content_to_dictionary( self, content):
        data = json.loads( content.decode( 'utf-8' ) )
        return data
    ###
    # It execute a http GET request.
    # -param value(String):It is the value add to the endpoint extension.
    # -return(Response): It is the response of the request.
    ###
    def http_GET( self, value = None ):
        url = self.get_url()
        if not self.mEndPoint == None:
            url = url + '/' + self.mEndPoint
        if not value == None:
            url = url + value
        h = {
            'Authorization': self.get_token()
        }
        print( 'GET Request to: ' + url )
        response = requests.get( url, headers=h )
        print('Response Code: ' + str( response.status_code ) )
        #print('Response content: ' + str( response.content ) )
        #print('Response: ' + str( response ) )
        return response
    