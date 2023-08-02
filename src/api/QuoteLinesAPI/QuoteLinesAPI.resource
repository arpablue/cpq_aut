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
# -param id(String): It is the id of the QuoteLines to get the data.
# -return(Response): It is the response of the request.
###
GET request
    [Arguments]  ${id}
    ${headers}=  Create Dictionary  Authorization=${token}
    ${response}=  GET On Session  ${SessionAPI}  ${endPoint_QuoteLines}/${id}  headers=${headers}  expected_status=any
    [Return]  ${response}

###
# It excute the POST request to the QuoteLines endopoint.
# -param dictData(Dictionaty): It is a dictionary with the data used to be created.
# -return(Response): It is the reponse of the PORT request.
###
POST request
    [Arguments]  ${dictData}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}    # It does a POST request
    ${response}=  POST On Session  ${SessionAPI}  ${endPoint_QuoteLines}  headers=${headers}  json=${dictData}  expected_status=any
    [Return]  ${response}

###
# It is the execution of a PUT request to the QuoteLines endpoint.
# -param id(String): It is the id of the QuoteLines to be modified.
# -param dictData(Dictionary): It is the dictionary with the data to be modified, the atributes as keys and values.
# -return(Response): It is the response object from the PUT request.
###
PUT request
    [Arguments]  ${id}  ${dictData}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  PUT On Session  ${SessionAPI}  url=${endPoint_QuoteLines}/${id}  headers=${headers}  json=${dictData}  expected_status=any
    [Return]  ${response}

###
# It excute the DELETE request to the QuoteLines endopoint.
# -param id(String): It is the id of the QuoteLines to be deleted.
# -return(Response): It is the reponse of the DELETE request.
###
DELETE request
    [Arguments]  ${id}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  DELETE On Session  ${SessionAPI}  ${endPoint_QuoteLines}/${id}  headers=${headers}  expected_status=any
    [Return]  ${response}
####################################################### ACTIONS #######################################################
###
# It return the data related to a quote line.
# -param id(String): it is the ID of the Quote Line.
# -return(Dictionary): It return a dicttionary related to the quote line.
Get Info
    [Arguments]  ${id}
    GlobalAPI.Action  GETTING QUOTE LINES ----------------
    GlobalAPI.Write  Get data of the QUOTE LINES ID: ${id}
    ${response}=  GET request  ${id}
    GlobalAPI.Verification GET success  ${response.status_code} 
    ${dictBody}=  Convert to dictionary  ${response.content}
    GlobalAPI.WriteBox  QUOTE LINES data getted  ${dictBody}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  QuoteLinesAPI_ext.Create from data  ${res}
    GlobalAPI.Object attribute should exists  ${res}  id
    [Return]  ${res}
###
# It add a new QUOTE LINE it have as parameter a dictionary wiht the data for the QUOTE LINE
# -param dictData(Dictionary): It is a dictionary with the data of the new quote.
#        Ex:  ${dictData}=  Create Dictionary  name=Jazz Test  description=Test QUOTE LINES  currencyIsoCode=USD
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
###
Create
    [Arguments]  ${dictData}
    GlobalAPI.Write  CREATING QUOTE LINES ----------------
    GlobalAPI.WriteBox  Data for the new QUOTE LINES  ${dictData}
    ${response}=  POST request  ${dictData}
    GlobalAPI.Verification POST success  ${response.status_code} 
    GlobalAPI.Verify the data exists for  ${response}  data
    # It convert the response body in a dictionary
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  QuoteLinesAPI_ext.Create from data  ${res}
    ${id}=  GlobalAPI.Object get attribute  ${res}  Id
    ${path}=  GlobalAPI.Get Path  ${recordPath_QuoteLiness}
    DataRecorder.Register in file  ${path}  ${id}
    GlobalAPI.WriteBox  QUOTE LINES CREATED  ${res}
    [Return]  ${res}

###
# It modify an quotes using a dictionary to specify the data that will be modified.
# -param quotesID(String): It is the id of the quotes to be modified.
# -param dictData(Dictionary): It is the dictionary with the attributes and values to be modified.
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
# -return(QuotesLinesObj): It is the data of the request modified.
###
Modify
    [Arguments]  ${id}  ${dictData}
    GlobalAPI.Action  MODIFYING QUOTE LINES ---------------
    GlobalAPI.WriteBox  New QUOTE LINES data  ${dictData}
    ${body}=  Set Variable  ${dictData}
    ${response}=  PUT request  ${id}  ${dictData}
    GlobalAPI.Verification PUT success  ${response.status_code}
    GlobalAPI.WriteBox  QUOTE LINES Modified Response  ${response.content}
    GlobalAPI.Verify the data exists for  ${response}  description
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  QuoteLinesAPI_ext.create from data  ${res}
    [Return]  ${res}
###
# It delete an quote.
# -param obj(QuoteLinesObj): It is the id of the QUOTE LINES to be deleted.
# -param exp_code(String): It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
# -return(Bool): It is True if the QUOTE LINES has been deleted.
###
Delete 
    [Arguments]  ${obj}
    GlobalAPI.Action  DELETING QUOTE LINES ---------------
    ${id}=  GlobalAPI.Object get attribute  ${obj}  Id
    ${response}=  DELETE request  ${id}
    GlobalAPI.Verification DELETE success  ${response.status_code} 
    ${content}=  Convert to string   ${response.content}
    ${flag}=  GlobalAPI.String contains string  ${content}  "success": true
    IF  ${flag} == False
        GlobalAPI.WriteBox  DELETE Response  ${content}
        GlobalAPI.Error   The Quote Line[${id}] has not been deleted.
    ELSE
        GlobalAPI.Success  The Quote Line[${id}] has been deleted without problems.
    END
    [Return]  ${flag}
###
# It is a flexible comparison. Both objects could have differents numbers of attributes,
# but all attributes of the first object should be exists in the second object and they 
# they should have the same values.
# -param objA(QuoteLinesObj) : It is the first QUOTE LINES to be compared.
# -param objB(QuoteLinesObj) :It is the second QUOTE LINES to be compared.
###
Compare
    [Arguments]  ${objA}  ${objB}
    ${flag}=  QuoteLinesAPI_ext.Compare  ${objA}  ${objB}
    [Return]  ${flag}
###
# It is a flexible comparison. Both objects could have differents numbers of attributes,
# but all attributes of the first object should be exists in the second object and they 
# they should have the same values.
# -param objA(QuoteLinesObj) : It is the first QUOTE LINES to be compared.
# -param objB(QuoteLinesObj) :It is the second QUOTE LINES to be compared.
###
Compare attrs
    [Arguments]  ${objA}  ${objB}
    ${flag}=  QuoteLinesAPI_ext.Compare attrs  ${objA}  ${objB}
    [Return]  ${flag}
###
# It is a strict comparison. Both objects should have the same number of attributes,
# the same attributes and the same values.
# -param objA(QuoteLinesObj) : It is the first QUOTE LINES to be compared.
# -param objB(QuoteLinesObj) :It is the second QUOTE LINES to be compared.
###
Equal
    [Arguments]  ${objA}  ${objB}
    ${flag}=  QuoteLinesAPI_ext.Equal  ${objA}  ${objB}
    [Return]  ${flag}
###
# It create a QUOTE LINES from a dictionary.
# -param dataDict(Dictionary):
# -return(QuoteLinesObj): It is the QUOTE LINES object created with the dictionary.
###
Create from
    [Arguments]  ${dataDict}
    ${res}=  QuoteLinesAPI_ext.create from data  ${dataDict}
    [Return]  ${res}
### 
# It verify if a QUOTE LINES exists in the system.
# -param  id(String): It is the ID of the quote.
# -return(Bool): It is true if the QUOTE LINES exist in the system.
###
Exists by ID
    [Arguments]  ${id}
    GlobalAPI.Action  Quote Line Exists by ID [${id}]
    ${response}=  GET request  ${id}
    ${status_code}=  Convert to string  ${response.status_code}
    ${res}=  Set Variable  True
    ${content}=  Convert to string   ${response.content}
    ${flag}=  GlobalAPI.Validate code  ${status_code}
    IF  ${flag} == False
        GlobalAPI.Warning  The object not Exists. The [${status_code}] response code is not a valid code.
        ${res}=  Set Variable  False
    ELSE
        ${res}=  GlobalAPI.Evaluate GET success  ${status_code}
    END
    [Return]  ${res} 

###
# It verify if a quote exists in the system.
# -param obj(QuoteObj): It is the quote toi verify if the object exists in the system.
# -return(Bool): It is True if the object exists in the system.
###
Exists
    [Arguments]  ${obj}
    ${id}=  GlobalAPI.Object get attribute  ${obj}  Id
    ${flag}=  Exists by ID  ${id}
    [Return]  ${flag}
