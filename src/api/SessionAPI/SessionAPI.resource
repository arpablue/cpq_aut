*** Settings ***
Documentation  This manage the events relate to the endpoint related to the opportunities.

Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

Resource    ../../../src/common/libs/Validations.resource
Resource    ../../../src/common/libs/GlobalAPI.resource
Library    ../../../src/common/libs/DictTools.py
*** Variables ***
# It is the reference of the end point for quotes
${endPoint_session}  /v1/sessions

*** Keywords ***
####################################################### HTTP REQUESTS #######################################################
GET direct request
    ${headers}=  Create Dictionary  Authorization=${token}
    ${response}=  GET On Session  ${SessionAPI}  ${endPoint_session}  headers=${headers}  expected_status=any
    [Return]  ${response}

GET single request
    [Arguments]  ${path}
    ${headers}=  Create Dictionary  Authorization=${token}
    ${response}=  GET On Session  ${SessionAPI}  ${endPoint_session}/${path}  headers=${headers}  expected_status=any
    #GlobalAPI.WriteBox  QUOTE GET Response  ${response.content }
    [Return]  ${response}

###
# It made a GET reques to the REST api service and return the response of the request.
# -param quoteID(String): It is the id of the quote to get the data.
# -return(response): TI is the response of the request.
###
GET request
    [Arguments]  ${quoteID}
    ${headers}=  Create Dictionary  Authorization=${token}
    ${response}=  GET On Session  ${SessionAPI}  ${endPoint_session}/${quoteID}  ${headers}  expected_status=any
    #GlobalAPI.WriteBox  QUOTE GET Response  ${response.content }
    [Return]  ${response}

###
# It excute the POST request to the quote endopoint.
# -param dictData(Dictionaty): It is a dictionary with the data used to be created.
# -return(response): It is the reponse of the PORT request.
###
POST request
    [Arguments]  ${dictData}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}  expected_status=any    # It does a POST request
    ${response}=  POST On Session  ${SessionAPI}  ${endPoint_session}  headers=${headers}  json=${dictData}
    #GlobalAPI.WriteBox  QUOTE POST Response  ${response.content }
    [Return]  ${response}

###
# It is the execution of a PUT request to the quote endpoint.
# -param oppID(String): It is the id of the quote to be modified.
# -param dictData(dictionary): It is the dictionary with the data to be modified, the atributes as keys and values.
# -return(response): It is the response object from the PUT request.
###
PUT request
    [Arguments]  ${quoteID}  ${dictData}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  PUT On Session  ${SessionAPI}  url=${endPoint_session}/${quoteID}  headers=${headers}  json=${dictData}
    #GlobalAPI.WriteBox  QUOTE PUT Response  ${response.content }
    [Return]  ${response}

###
# It excute the DELETE request to the quote endopoint.
# -param oppID(string): It is the id of the quote to be deleted.
# -return(response): It is the reponse of the DELETE request.
###
DELETE request
    [Arguments]  ${quoteID}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  DELETE On Session  ${SessionAPI}  ${endPoint_session}/${quoteID}  headers=${headers}
    #GlobalAPI.WriteBox  QUOTE DELETE Response  ${response.content }
    [Return]  ${response}

####################################################### HTTP REQUESTS #######################################################
###
# It evaluate if the current token or teh session is authorized.
# -return(Bool): It is true if the session is authorized.
###
IsActive
    ${response}=  GET direct request  
    ${flag}=  GlobalAPI.Evaluate GET success  ${response.status_code} 
    IF  ${flag} == True
        ${strContent}=  Convert to String  ${response.content}
        ${flag}=  GlobalAPI.String contains string  ${strContent}  "authenticated":true
        GlobalAPI.Info  The token of the session is authorized: ${flag}
    ELSE
        GlobalAPI.Error  The current token is not authorized.
    END
    [Return]  ${flag}
###
# It return The current user id relate to the session.
# -return()
Get User ID
    ${response}=  GET direct request  
    ${flag}=  GlobalAPI.Evaluate GET success  ${response.status_code} 
    ${strContent}=  Convert to String  ${response.content}
    ${res}=  Set Variable  None
    IF  ${flag} == True
        ${flag}=  GlobalAPI.String contains string  ${strContent}  "authenticated":true
        GlobalAPI.Info  The token of the session is authorized: ${flag}
        GlobalAPI.WriteBox  DATA RESPONSE  ${response.content}
        ${data}=  Convert To Dictionary  ${response.content}
        ${data}=  Get From Dictionary  ${data}  data
        ${res}=  Get From Dictionary  ${data}  id

        GlobalAPI.Info  User ID of the current Session: ${res}
    ELSE
        GlobalAPI.Error  The current token is not authorized.

    END
    [Return]  ${res}
