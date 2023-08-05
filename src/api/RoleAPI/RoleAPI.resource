*** Settings ***
Documentation  This manage the events relate to the endpoint related to the Roles.

Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

Resource    ../../../src/common/libs/GlobalAPI.resource
Variables    ../../../src/common/libs/variables.yml
Variables    ../../../config.yml

Library    ../../../src/common/libs/DictTools.py
Library    ../../../src/api/RoleAPI/RoleAPI_ext.py
Library    ../../../src/common/libs/DataRecorder.py


*** Variables ***
# It contains the reference to the endppoint for the oipportunities
${endPoint_role}  /v1/roles
# It is the id of the endpoints created.
${recordPath_rol}  /resources/records/roles_created.dat

*** Keywords ***
####################################################### HTTP REQUESTS #######################################################
###
# It made a GET reques to the REST api service and return the response of the request.
# -param RolID(String): It is the id of the Rol to get the data.
# -return(response): It is the response of the request.
###
GET single request
    ${headers}=  Create Dictionary  Authorization=${token}
    ${response}=  GET On Session  ${SessionAPI}  ${endPoint_role}  headers=${headers}  expected_status=any
    [Return]  ${response}

###
# It made a GET reques to the REST api service and return the response of the request.
# -param RolID(String): It is the id of the Rol to get the data.
# -return(response): It is the response of the request.
###
GET request
    [Arguments]  ${RolID}
    ${headers}=  Create Dictionary  Authorization=${token}
    ${response}=  GET On Session  ${SessionAPI}  ${endPoint_role}/${RolID}  headers=${headers}  expected_status=any
    #GlobalAPI.WriteBox  Rol GET Response  ${response.content }
    [Return]  ${response}

###
# It excute the POST request to the Rol endopoint.
# -param dictData(Dictionaty): It is a dictionary with the data used to be created.
# -return(response): It is the reponse of the PORT request.
###
POST request
    [Arguments]  ${dictData}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}    # It does a POST request
    ${response}=  POST On Session  ${SessionAPI}  ${endPoint_role}  headers=${headers}  json=${dictData}  expected_status=any
    [Return]  ${response}
###
# It is the execution of a PUT request to the Rol endpoint.
# -param rolID(String): It is the id of the Rol to be modified.
# -param dictData(dictionary): It is the dictionary with the data to be modified, the atributes as keys and values.
# -return(response): It is the response object from the PUT request.
###
PUT request
    [Arguments]  ${rolID}  ${dictData}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  PUT On Session  ${SessionAPI}  url=${endPoint_role}/${rolID}  headers=${headers}  json=${dictData}   expected_status=any
    #GlobalAPI.WriteBox  Rol PUT Response  ${response.content }
    [Return]  ${response}
###
# It excute the DELETE request to the Rol endopoint.
# -param rolID(string): It is the id of the Rol to be deleted.
# -return(response): It is the reponse of the DELETE request.
###
DELETE request
    [Arguments]  ${rolID}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  DELETE On Session  ${SessionAPI}  ${endPoint_role}/${rolID}  headers=${headers}   expected_status=any
    #GlobalAPI.WriteBox  Rol DELETE Response  ${response.content}
    [Return]  ${response}

####################################################### ACTIONS #######################################################
###
# It return the a Role object using the data as attributes of the object.
# -param data(Dictionary): It is the collection of attributes used for the new Role object.
# -return(RoleObj): It is the object ucreated using the data of values.
###
Create from data 
    [Arguments]  ${data}
    ${res}=  RoleAPI_ext.Create from data  ${data}
    [Return]  ${res}
###
# It return the list of Roles object that exist in the system.
# -return(List): It is the list of Roles Obj that exist in the system.
###
Get all roles
    GlobalAPI.Action  Get all roles
    ${response}=  GET single request
    ${flag}=  GlobalAPI.Verification GET Success  ${response.status_code}
    ${data}=  Convert to dictionary  ${response.content}
    ${list}=  Get from dictionary  ${data}  data
    ${roles}=  Create List
    FOR  ${element}  IN  @{list}
        ${role}=  Create from data  ${element}
        Append to list  ${roles}  ${role}
        GlobalAPI.Write  ${role}
    END
    ${size}=  Get Length  ${roles}
    GlobalAPI.Write  Number of roles: ${size}
    [Return]  ${roles}
    
Get all visible roles
    pass
    # crate a keywork to pass a content and return the list of roles from the previous keyword