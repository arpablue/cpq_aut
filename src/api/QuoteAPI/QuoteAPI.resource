*** Settings ***
Documentation  This manage the events relate to the endpoint related to the opportunities.

Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

Resource    ../../../src/common/libs/GlobalAPI.resource
Variables    ../../../src/common/libs/variables.yml
Variables    ../../../config.yml

Library    ../../../src/common/libs/DictTools.py
Library    ../../../src/api/QuoteAPI/QuoteAPI_ext.py
Library    ../../../src/common/libs/DataRecorder.py
*** Variables ***
# It is the reference of the end point for quotes
${endPoint_quote}  /v1/projects/quotes
# It is the id of the endpoints created.
${recordPath_quotes}  resources/records/quotes_created.dat

*** Keywords ***
####################################################### HTTP REQUESTS #######################################################
###
# It made a GET reques to the REST api service and return the response of the request.
# -param quoteID(String): It is the id of the quote to get the data.
# -return(response): TI is the response of the request.
###
GET request
    [Arguments]  ${quoteID}
    ${headers}=  Create Dictionary  Authorization=${token}
    ${response}=  GET On Session  ${SessionAPI}  ${endPoint_quote}/${quoteID}  ${headers}
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
    ${response}=  POST On Session  ${SessionAPI}  ${endPoint_quote}  headers=${headers}  json=${dictData}
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
    ${response}=  PUT On Session  ${SessionAPI}  url=${endPoint_quote}/${quoteID}  headers=${headers}  json=${dictData}
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
    ${response}=  DELETE On Session  ${SessionAPI}  ${endPoint_quote}/${quoteID}  headers=${headers}
    #GlobalAPI.WriteBox  QUOTE DELETE Response  ${response.content }
    [Return]  ${response}
####################################################### ACTIONS #######################################################
###
# It return the data related to a quote.
# -param quoteID(string): it is the ID of the quote.
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
# -return(dictionary): It return a dicttionary related to the quote.
Get Info
    [Arguments]  ${quoteID}  ${exp_code}=200
    GlobalAPI.Write  QUOTE GET INFO ----------------
    GlobalAPI.Write  Getting data for Quote ID: ${quoteID}
    ${response}=  GET request  ${quoteID}
    IF  ${response.status_code} != ${exp_code}
        ${msg}=  Set Variable  Wrong expected code. Expectected code ${exp_code}, but the current code is ${response.status_code}
        GlobalAPI.Failed  ${msg}
    END
    ${strContent}=  Convert To String  ${response.content}
    Should Contain  ${strContent}  "id":
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  Get From Dictionary  ${res}  quote
    ${res}=  QuoteAPI_ext.create from data  ${res}
    [Return]  ${res}
###
# It add a new opportunity it have as parameter a dictionary wiht the data for the opportunity
# -param dictData(dictionary): It is a dictionary with the data of the new oppportunity
#        Ex:  ${dictData}=  Create Dictionary  name=Jazz Test  description=Test Opportunity  currencyIsoCode=USD
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
###
Create
    [Arguments]  ${dictData}  ${exp_code}=200
    GlobalAPI.Write  CREATING QUOTE ----------------
    ${response}=  POST request  ${dictData}
    IF  ${response.status_code} != ${exp_code}
        ${msg}=  Set Variable  Wrong expected code. Expectected code ${exp_code}, but the current code is ${response.status_code}
        GlobalAPI.Failed  ${msg}
    END    
    GlobalAPI.Verify the data exists for  ${response}  quote
    # It convert the response body in a dictionary
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  Get From Dictionary  ${res}  quote
    ${res}=  QuoteAPI_ext.create from data  ${res}
    ${id}=  GlobalAPI.Object get attribute  ${res}  id
    ${path}=  GlobalAPI.Get Path  ${recordPath_quotes}
    DataRecorder.Register in file  ${path}  ${id}
    GlobalAPI.WriteBox  NEW QUOTE  ${res}
    [Return]  ${res}

###
# It modify an quotes using a dictionary to specify the data that will be modified.
# -param quotesID(String): It is the id of the quotes to be modified.
# -param dictData(dictionary): It is the dictionary with the attributes and values to be modified.
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
# -return(QuotesOjct): It is the data of the request modified.
###
Modify
    [Arguments]  ${quoteID}  ${dictData}  ${exp_code}=200
    GlobalAPI.Write  MODIFYING QUOTE ---------------
    GlobalAPI.WriteBox  New data  ${dictData}
    ${body}=  Set Variable  ${dictData}
    ${response}=  PUT request  ${quoteID}  ${dictData}
    ${response}=  DELETE request  ${oppID}
    IF  ${response.status_code} != ${exp_code}
        ${msg}=  Set Variable  Wrong expected code. Expectected code ${exp_code}, but the current code is ${response.status_code}
        GlobalAPI.Failed  ${msg}
    END
    GlobalAPI.Verify the data exists for  ${response}  quote
    # It convert the response body in a dictionary
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  Get From Dictionary  ${res}  quote
    ${res}=  QuoteAPI_ext.create from data  ${res}
    GlobalAPI.WriteBox  QUOTE MODIFIED  ${res}
    [Return]  ${res}
###
# It delete an quote.
# -param quoteID(String): It is the id of the quote to be deleted.
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
###
Delete 
    [Arguments]  ${quoteID}  ${exp_code}=200
    GlobalAPI.Write  DELETING QUOTE ---------------
    GlobalAPI.Write  Deleting quote for: ${quoteID}
    ${response}=  DELETE request  ${quoteID}
    ${response}=  DELETE request  ${oppID}
    IF  ${response.status_code} != ${exp_code}
        ${msg}=  Set Variable  Wrong expected code. Expectected code ${exp_code}, but the current code is ${response.status_code}
        GlobalAPI.Failed  ${msg}
    END
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    [Return]  ${res}
###
# It is a flexible comparison. Both objects could have differents numbers of attributes,
# but all attributes of the first object should be exists in the second object and they 
# they should have the same values.
# -param quoteA(QuoteObj) : It is the first quote to be compared.
# -param quoteB(QuoteObj) :It is the second quote to be compared.
###
Compare
    [Arguments]  ${quoteA}  ${quoteB}
    ${flag}=  QuoteAPI_ext.Compare  ${quoteA}  ${quoteB}
    [Return]  ${flag}
###
# It is a strict comparison. Both objects should have the same number of attributes,
# the same attributes and the same values.
# -param oppA(QuoteObj) : It is the first quote to be compared.
# -param oppB(QuoteObj) :It is the second quote to be compared.
###
Equal
    [Arguments]  ${quoteA}  ${quoteB}
    ${flag}=  QuoteAPI_ext.Equal  ${quoteA}  ${quoteB}
    [Return]  ${flag}
###
# It create a quote from a dictionary.
# -param dataDict(Dictionary):
# -return(QuoteObj): It is the quote object created with the dictionary.
###
Create from
    [Arguments]  ${dataDict}
    ${res}=  QuoteAPI_ext.create from data  ${dataDict}
    [Return]  ${res}
### 
# It verify if a quote exists in the system.
# -param  quoteID(String): It is the ID of the quote.
# -return(bool): It is true if the quote exist in the system.
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
    ${flag}=  GlobalAPI.String contains string  ${content}  "quote":null
    IF  ${flag} == True
        ${res}=  Set Variable  False
    END
    [Return]  ${res}    
