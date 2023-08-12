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
    response = target.http_GET()
    list = target.content_to_dictionary( response.content )
    response = target.http_GET()
    print('Response Code: ' + str( response.status_code ) )
    print('-----------------')
    print('-----------------')
    print('-----------------')
    list = list['data']
    size = len( list )
    print( 'Qunatity of elements: ' + str( size ) )
        
def test_HttpRequets_http_POST_create_an_opportunity():
    target = HttpRequests()
    target.set_endpoint('v1/projects/opportunities')
    data = {
        "Name": "Opportunity name 001",
        "Description": "Description of the Opportunity",
        "CurrencyIsoCode": "USD"
    }
    response = target.http_POST( None, data )
    print('Response Code: ' + str( response.status_code ) )
    if not response.status_code == 201:
        print( "FAIL: It is not possible create a new opportunity. stataus code["+str(response.status_code)+"]")
        if response.status_code == 401:
            print("Status code["+str(response.status_code)+"] your are not authorizxed to create a Opportunity.")
    newData = target.content_to_dictionary( response.content )    
    name = newData[ 'data' ][ 'Name' ]
    id = newData[ 'data' ][ 'Id' ]
    
    print( 'Opportunity created: ' + id + ' - '+ name )
    
    if name == data[ 'Name' ]:
        print( "PASS: The name are equals.")
    else:
        print( "FAIL: The name are not equal. exp[" + name  + "] cur[" + data['Name'] + "]")
    

def test_HttpRequets_http_PUT_modify_an_opportunity():
    target = HttpRequests()
    target.set_endpoint('v1/projects/opportunities')
    data = {
        "Name": "Opportunity name 001",
        "Description": "Description of the Opportunity for 001"
    }
    response = target.http_POST( None, data )
    print('Response Code: ' + str( response.status_code ) )
    if not response.status_code == 201:
        print( "FAIL: It is not possible create a new opportunity. stataus code["+str(response.status_code)+"]")
        if response.status_code == 401:
            print("Status code["+str(response.status_code)+"] your are not authorizxed to create a Opportunity.")
    newData = target.content_to_dictionary( response.content )    
    name = newData[ 'data' ][ 'Name' ]
    id = newData[ 'data' ][ 'Id' ]
    
    print( 'Opportunity created: ' + id + ' - '+ name )
    
    if not name == data[ 'Name' ]:
        print( "FAIL: The name are not equal. exp[" + name  + "] cur[" + data['Name'] + "]")


    data = {
        "Name": "Opportunity name 002",
        "Description": "Description of the Opportunity for 002"
    }
    
    response = target.http_PUT( "/" + str( id ), data )
    
    newData = target.content_to_dictionary( response.content )    
    name = newData[ 'data' ][ 'Name' ]
    id = newData[ 'data' ][ 'Id' ]
    
    print( 'Opportunity Modified: ' + id + ' - '+ name )
    
    if name == data[ 'Name' ]:
        print( "PASS: The name are equals.")
    else:
        print( "FAIL: The name are not equal. exp[" + name  + "] cur[" + data['Name'] + "]")



def test_HttpRequets_http_DELETE_delete_an_opportunity():
    target = HttpRequests()
    target.set_endpoint('v1/projects/opportunities')
    data = {
        "Name": "Opportunity name 001",
        "Description": "Description of the Opportunity for 001"
    }
    response = target.http_POST( None, data )
    print('Response Code: ' + str( response.status_code ) )
    if not response.status_code == 201:
        print( "FAIL: It is not possible create a new opportunity. stataus code["+str(response.status_code)+"]")
        if response.status_code == 401:
            print("Status code["+str(response.status_code)+"] your are not authorizxed to create a Opportunity.")
    newData = target.content_to_dictionary( response.content )    
    name = newData[ 'data' ][ 'Name' ]
    id = newData[ 'data' ][ 'Id' ]
    
    print( 'Opportunity created: ' + id + ' - '+ name )
    
    if not name == data[ 'Name' ]:
        print( "FAIL: The name are not equal. exp[" + name  + "] cur[" + data['Name'] + "]")


    data = {
        "Name": "Opportunity name 002",
        "Description": "Description of the Opportunity for 002"
    }
    
    response = target.http_DELETE( "/" + str( id ) )
    
    print( '----------------------------' )
    print('Response Code: ' + str( response.status_code ) )
    print( response.content )

#test_HttpRequests_load_YML_file()
#test_HttpRequests_http_GET_it_is_possible_do_a_GET_and_get_a_response()
#test_HttpRequets_http_POST_create_an_opportunity()
#test_HttpRequets_http_PUT_modify_an_opportunity()
test_HttpRequets_http_DELETE_delete_an_opportunity()