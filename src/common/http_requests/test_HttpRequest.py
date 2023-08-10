import os
import sys

dir = os.path.dirname( __file__ )
src_pos = dir.index('src')
src_path = dir[:src_pos] + os.path.join('src','common','http_requests')
sys.path.append( src_path )
from HttpRequests import HttpRequests

def test_HttpRequests_load_YML_file():
    target = HttpRequests()
    data = target.get_data()
    key = 'application'
    if data == None:
        print("ERROR: The data is NULL when should not be it.")
    if key in data:
       print( ' - Data[ '+key+' ] = ' + str( data[ key ]) )

    for element in data:
        print( ' - Data[ '+ element +' ] = ' + str( data[ element ] ) )

def test_HttpRequests_http_GET_it_is_possible_do_a_GET_and_get_a_response():
    target = HttpRequests()
    target.set_endpoint('v1/roles')
    response = target.http_GET( )
    list = target.content_to_dictionary( response.content )
    print('-----------------')
    print('-----------------')
    print('-----------------')
    list = list['data']
    for element in list:
        print( ' - ' + str( element ) )
        

#test_HttpRequests_load_YML_file()
test_HttpRequests_http_GET_it_is_possible_do_a_GET_and_get_a_response()