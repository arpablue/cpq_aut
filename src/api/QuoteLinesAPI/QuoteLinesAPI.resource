*** Settings ***
Documentation  This manage the events relate to the endpoint related to the opportunities.

Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

Resource    ../../../src/common/libs/GlobalAPI.resource
Variables    ../../../src/common/libs/variables.yml
Variables    ../../../config.yml

Library    ../../../src/common/libs/DictTools.py
Library    ../../../src/api/QuoteLinesAPI/QuoteLinesAPI_ext.py
Library    ../../../src/common/libs/DataRecorder.py
*** Variables ***
# It is the reference of the end point for QuoteLiness
${endPoint_QuoteLines}  /v1/projects/quoteLines
# It is the id of the endpoints created.
${recordPath_QuoteLiness}  resources/records/QuoteLiness_created.dat

*** Keywords ***
####################################################### HTTP REQUESTS #######################################################
###
# It made a GET reques to the REST api service and return the response of the request.
# -param QuoteLinesID(String): It is the id of the QuoteLines to get the data.
# -return(response): TI is the response of the request.
###
GET request
    [Arguments]  ${QuoteLinesID}
    ${headers}=  Create Dictionary  Authorization=${token}
    ${response}=  GET On Session  ${SessionAPI}  ${endPoint_QuoteLines}/${QuoteLinesID}  ${headers}
    #GlobalAPI.WriteBox  QuoteLines GET Response  ${response.content }
    [Return]  ${response}

###
# It excute the POST request to the QuoteLines endopoint.
# -param dictData(Dictionaty): It is a dictionary with the data used to be created.
# -return(response): It is the reponse of the PORT request.
###
POST request
    [Arguments]  ${dictData}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}    # It does a POST request
    ${response}=  POST On Session  ${SessionAPI}  ${endPoint_QuoteLines}  headers=${headers}  json=${dictData}
    #GlobalAPI.WriteBox  QuoteLines POST Response  ${response.content }
    [Return]  ${response}

###
# It is the execution of a PUT request to the QuoteLines endpoint.
# -param quoteID(String): It is the id of the QuoteLines to be modified.
# -param dictData(dictionary): It is the dictionary with the data to be modified, the atributes as keys and values.
# -return(response): It is the response object from the PUT request.
###
PUT request
    [Arguments]  ${QuoteLinesID}  ${dictData}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  PUT On Session  ${SessionAPI}  url=${endPoint_QuoteLines}/${QuoteLinesID}  headers=${headers}  json=${dictData}
    #GlobalAPI.WriteBox  QuoteLines PUT Response  ${response.content }
    [Return]  ${response}

###
# It excute the DELETE request to the QuoteLines endopoint.
# -param quoteID(string): It is the id of the QuoteLines to be deleted.
# -return(response): It is the reponse of the DELETE request.
###
DELETE request
    [Arguments]  ${QuoteLinesID}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  DELETE On Session  ${SessionAPI}  ${endPoint_QuoteLines}/${QuoteLinesID}  headers=${headers}
    #GlobalAPI.WriteBox  QuoteLines DELETE Response  ${response.content }
    [Return]  ${response}
####################################################### ACTIONS #######################################################
###
# It return the data related to a QuoteLines.
# -param QuoteLinesID(string): it is the ID of the QuoteLines.
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
# -return(dictionary): It return a dicttionary related to the QuoteLines.
Get Info  ${exp_code}=200
    [Arguments]  ${QuoteLinesID}
    GlobalAPI.Action  QuoteLines GET INFO
    GlobalAPI.Write  Getting data for QuoteLines ID: ${QuoteLinesID}
    ${response}=  GET request  ${QuoteLinesID}
    ${response}=  DELETE request  ${oppID}
    IF  ${response.status_code} != ${exp_code}
        ${msg}=  Set Variable  Wrong expected code. Expectected code ${exp_code}, but the current code is ${response.status_code}
        GlobalAPI.Failed  ${msg}
    END
    ${strContent}=  Convert To String  ${response.content}
    Should Contain  ${strContent}  "id":
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  Get From Dictionary  ${res}  quoteLine
    ${res}=  QuoteLinesAPI_ext.Create from data  ${res}
    [Return]  ${res}
###
# It add a new opportunity it have as parameter a dictionary wiht the data for the opportunity
# -param dictData(dictionary): It is a dictionary with the data of the new oppportunity
#        Ex:  ${dictData}=  Create Dictionary  name=Jazz Test  description=Test Opportunity  currencyIsoCode=USD
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
###
Create
    [Arguments]  ${dictData}  ${exp_code}=200
    GlobalAPI.Action  QuoteLines CREATING QUOTE LINES
    ${response}=  POST request  ${dictData}
    ${response}=  DELETE request  ${oppID}
    IF  ${response.status_code} != ${exp_code}
        ${msg}=  Set Variable  Wrong expected code. Expectected code ${exp_code}, but the current code is ${response.status_code}
        GlobalAPI.Failed  ${msg}
    END
    GlobalAPI.Verify the data exists for  ${response}  quoteLine
    # It convert the response body in a dictionary
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  Get From Dictionary  ${res}  quoteLine
    ${res}=  QuoteLinesAPI_ext.Create from data  ${res}
    ${id}=  GlobalAPI.Object get attribute  ${res}  id
    ${path}=  GlobalAPI.Get Path  ${recordPath_QuoteLiness}
    DataRecorder.Register in file  ${path}  ${id}
    GlobalAPI.WriteBox  NEW QUOTE LINES  ${res}
    [Return]  ${res}
###
# It modify an QuoteLiness using a dictionary to specify the data that will be modified.
# -param QuoteLinessID(String): It is the id of the QuoteLiness to be modified.
# -param dictData(dictionary): It is the dictionary with the attributes and values to be modified.
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
# -return(QuoteLinessOjct): It is the data of the request modified.
###
Modify
    [Arguments]  ${QuoteLinesID}  ${dictData}  ${exp_code}=200
    GlobalAPI.Action  QuoteLines MODIFYING QUOTE LINES
    GlobalAPI.Write  Modiying the QuoteLine: ${QuoteLinesID}
    GlobalAPI.WriteBox  New data  ${dictData}
    ${body}=  Set Variable  ${dictData}
    ${response}=  PUT request  ${QuoteLinesID}  ${dictData}
    ${response}=  DELETE request  ${oppID}
    IF  ${response.status_code} != ${exp_code}
        ${msg}=  Set Variable  Wrong expected code. Expectected code ${exp_code}, but the current code is ${response.status_code}
        GlobalAPI.Failed  ${msg}
    END
    GlobalAPI.Verify the data exists for  ${response}  QuoteLines
    # It convert the response body in a dictionary
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  Get From Dictionary  ${res}  quoteLine
    ${res}=  QuoteLinesAPI_ext.create from data  ${res}
    GlobalAPI.WriteBox  QUOTE LINES MODIFIED  ${res}
    [Return]  ${res}
###
# It delete an QuoteLines.
# -param QuoteLinesID(String): It is the id of the QuoteLines to be deleted.
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
###
Delete 
    [Arguments]  ${QuoteLinesID}  ${exp_code}=200
    GlobalAPI.Write  QuoteLines DELETING QUOTE LINES ---------------
    GlobalAPI.Write  Deleting QuoteLines for: ${QuoteLinesID}
    ${response}=  DELETE request  ${QuoteLinesID}
    ${response}=  DELETE request  ${oppID}
    IF  ${response.status_code} != ${exp_code}
        ${msg}=  Set Variable  Wrong expected code. Expectected code ${exp_code}, but the current code is ${response.status_code}
        GlobalAPI.Failed  ${msg}
    END
    GlobalAPI.WriteBox  Response of the DELETE  ${response}
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    [Return]  ${res}
###
# It is a flexible comparison. Both objects could have differents numbers of attributes,
# but all attributes of the first object should be exists in the second object and they 
# they should have the same values.
# -param QuoteLinesA(QuoteLinesObj) : It is the first QuoteLines to be compared.
# -param QuoteLinesB(QuoteLinesObj) :It is the second QuoteLines to be compared.
###
Compare
    [Arguments]  ${QuoteLinesA}  ${QuoteLinesB}
    GLobalAPI.Action  Comparing QuoteLines
    ${flag}=  QuoteLinesAPI_ext.Compare  ${QuoteLinesA}  ${QuoteLinesB}
    IF  ${flag} == True
        GlobalAPI.Success  Both objects are equals
    ELSE
        GlobalAPI.Write  QuoteLine A: ${QuoteLinesA}
        GlobalAPI.Write  QuoteLine B: ${QuoteLinesB}
        GlobalAPI.Unsuccess  The Quote Lines are different.
    END
    [Return]  ${flag}
###
# It is a strict comparison. Both objects should have the same number of attributes,
# the same attributes and the same values.
# -param quoteA(QuoteLinesObj) : It is the first QuoteLines to be compared.
# -param quoteB(QuoteLinesObj) :It is the second QuoteLines to be compared.
###
Equal
    [Arguments]  ${QuoteLinesA}  ${QuoteLinesB}
    ${flag}=  QuoteLinesAPI_ext.Equal  ${QuoteLinesA}  ${QuoteLinesB}
    [Return]  ${flag}
###
# It create a QuoteLines from a dictionary.
# -param dataDict(Dictionary):
# -return(QuoteLinesObj): It is the QuoteLines object created with the dictionary.
###
Create from
    [Arguments]  ${dataDict}
    ${res}=  QuoteLinesAPI_ext.create from data  ${dataDict}
    [Return]  ${res}
### 
# It verify if a QuoteLines exists in the system.
# -param  quoteID(String): It is the ID of the QuoteLines.
# -return(bool): It is true if the QuoteLines exist in the system.
###
Exists by ID
    [Arguments]  ${quoteID}
    ${response}=  GET request  ${quoteID}
    ${status_code}=  Convert to string  ${response.status_code}
    ${res}=  Set Variable  True
    ${content}=  Convert to string   ${response.content}
    IF  ${status_code} != ${http_success}
        ${res}=  Set Variable  False
    END
    ${flag}=  GlobalAPI.String contains string  ${content}  "quoteLine":null
    IF  ${flag} == True
        ${res}=  Set Variable  False
    END
    [Return]  ${res}    
