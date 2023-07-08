*** Settings ***
Documentation  This manage the events relate to the endpoint related to the opportunities.

Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

Resource    ../../../src/common/libs/GlobalAPI.resource
Library    ../../../src/common/libs/DictTools.py
*** Variables ***
# It is the reference of the end point for quotes
${endPoint_session}  /v1/access

*** Keywords ***
####################################################### HTTP REQUESTS #######################################################
GEt single request
    [Arguments]  ${path}
    ${headers}=  Create Dictionary  Authorization=${token}
    ${response}=  GET On Session  ${SessionAPI}  ${endPoint_session}/${path}  headers=${headers}
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
    ${response}=  GET On Session  ${SessionAPI}  ${endPoint_session}/${quoteID}  ${headers}
    #GlobalAPI.WriteBox  QUOTE GET Response  ${response.content }
    [Return]  ${response}

###
# It excute the POST request to the quote endopoint.
# -param dictData(Dictionaty): It is a dictionary with the data used to be created.
# -return(response): It is the reponse of the PORT request.
###
POST request
    [Arguments]  ${dictData}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}    # It does a POST request
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
IsActive
    ${response}=  GEt single request  status
    ${flag}=  Set Variable  False
    GlobalAPI.Write  ${response}
    #IF  ${response} != "None"
    #    GlobalAPI.Write  Status Code: ${response.status_code}
    #    GlobalAPI.Write  Content: ${response.content}
    #    IF  ${response.status_code} == 200
    #        ${flag}=  Set Variable  True
    #    END
    #END
    [Return]  ${flag}