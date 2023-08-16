import os
import sys
import yaml
import requests
import json
from robot.libraries.BuiltIn import BuiltIn


dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','http_requests','DataAPI')
sys.path.append( src_path )
from DataAPI import DataAPI


###
# It contains the method to execute HTTP requests.
###
class HttpRequests( DataAPI ):
    ###
    # Default constructor.
    ###
    def __init__( self ) -> None:
        super().__init__()
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
    ###
    # It convert the content of the response to a dicttionary.
    # -param content(ReponseData): It is the content of a response.
    # -return(Dictionary):It is the data of the response in a dictionary.
    ####
    def content_to_dictionary( self, content):
        data = json.loads( content.decode( 'utf-8' ) )
        return data
    ###
    # It ser in format a URL.
    # -param target(String): It is the URL to set on format,
    # -return(String): It is the URL set on format.
    ###
    def url_format( self, target ):
        if target == None:
            return None
        target = target.strip()
        target = target.replace('//','/')
        target = target.replace('https:/','https://')
        target = target.replace('http:/','http://')
        return target
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
        url = self.url_format( url )
        h = {
            'Authorization': self.get_token()
        }
        self.write('GET requests: ' + url )
        response = requests.get( url, headers=h )
        return response
    ###
    # It execute a http POST request.
    # -param json(Dictionary): It is the dictionary used to send to the host.
    # -return(response): It is the response of the post request.
    ###
    def http_POST( self, value=None,  json=None, ):
        url = self.get_url()
        if not self.mEndPoint == None:
            url = url + '/' + self.mEndPoint
        if not value == None:
            url = url + value
        h = {
            'Authorization': self.get_token()
        }
        self.write('POST requests: ' + url )
        if json == None:
            response = requests.post( url, headers=h )
        else:
            response = requests.post( url, json=json, headers=h )
        
        return response
    ###
    # It execute a http PUT request.
    # -param json(Dictionary): It is the dictionary used to send to the host.
    # -return(response): It is the response of the post request.
    ###
    def http_PUT( self,  value=None, json=None):
        url = self.get_url()
        if not self.mEndPoint == None:
            url = url + '/' + self.mEndPoint
        if not value == None:
            url = url + value
        h = {
            'Authorization': self.get_token()
        }
        self.write('PUT requests: ' + url )
        if json == None:
            response = requests.put( url, headers=h )
        else:
            response = requests.put( url, json=json, headers=h )
        
        return response
    ###
    # It execute a http PUT request.
    # -param json(Dictionary): It is the dictionary used to send to the host.
    # -return(response): It is the response of the post request.
    ###
    def http_DELETE( self, value=None):
        url = self.get_url()
        if not self.mEndPoint == None:
            url = url + '/' + self.mEndPoint
        if not value == None:
            url = url + value
        h = {
            'Authorization': self.get_token()
        }
        self.write('DELETE requests: ' + url )
        response = requests.delete( url, headers=h )
        return response
