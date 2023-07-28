*** Settings ***
Documentation  This manage the events relate to the endpoint related to the Quotes.

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
# -param id(String): It is the id of the quote to get the data.
# -return(response): TI is the response of the request.
###
GET request
    [Arguments]  ${id}
    ${headers}=  Create Dictionary  Authorization=${token}
    ${response}=  GET On Session  ${SessionAPI}  ${endPoint_quote}/${id}  headers=${headers}
    [Return]  ${response}

###
# It excute the POST request to the quote endopoint.
# -param dictData(Dictionaty): It is a dictionary with the data used to be created.
# -return(response): It is the reponse of the PORT request.
###
POST request
    [Arguments]  ${dictData}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  POST On Session  ${SessionAPI}  ${endPoint_quote}  headers=${headers}  json=${dictData}
    [Return]  ${response}

###
# It is the execution of a PUT request to the quote endpoint.
# -param id(String): It is the id of the quote to be modified.
# -param dictData(dictionary): It is the dictionary with the data to be modified, the atributes as keys and values.
# -return(response): It is the response object from the PUT request.
###
PUT request
    [Arguments]  ${id}  ${dictData}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  PUT On Session  ${SessionAPI}  url=${endPoint_quote}/${id}  headers=${headers}  json=${dictData}
    [Return]  ${response}

###
# It excute the DELETE request to the quote endopoint.
# -param id(string): It is the id of the quote to be deleted.
# -return(response): It is the reponse of the DELETE request.
###
DELETE request
    [Arguments]  ${id}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  DELETE On Session  ${SessionAPI}  ${endPoint_quote}/${id}  headers=${headers}
    [Return]  ${response}
####################################################### ACTIONS #######################################################
###
# It return the data related to a quote.
# -param id(string): it is the ID of the quote.
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
# -return(dictionary): It return a dicttionary related to the quote.
Get Info
    [Arguments]  ${id}
    GlobalAPI.Action  GETTING QUOTE ----------------
    GlobalAPI.Write  Get data of the QUOTE ID: ${id}
    ${response}=  GET request  ${id}
    GlobalAPI.Verification GET success  ${response.status_code} 
    ${dictBody}=  Convert to dictionary  ${response.content}
    GlobalAPI.WriteBox  QUOTE data getted  ${dictBody}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  QUOTEAPI_ext.Create from data  ${res}
    GlobalAPI.Object attribute should exists  ${res}  id
    [Return]  ${res}
###
# It add a new QUOTE it have as parameter a dictionary wiht the data for the QUOTE
# -param dictData(dictionary): It is a dictionary with the data of the new quote.
#        Ex:  ${dictData}=  Create Dictionary  name=Jazz Test  description=Test QUOTE  currencyIsoCode=USD
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
###
Create
    [Arguments]  ${dictData}
    GlobalAPI.Write  CREATING QUOTE ----------------
    GlobalAPI.WriteBox  Data for the new quote  ${dictData}
    ${response}=  POST request  ${dictData}
    GlobalAPI.Verification POST success  ${response.status_code} 
    GlobalAPI.Verify the data exists for  ${response}  data
    # It convert the response body in a dictionary
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  QuoteAPI_ext.create from data  ${res}
    ${id}=  GlobalAPI.Object get attribute  ${res}  Id
    ${path}=  GlobalAPI.Get Path  ${recordPath_quotes}
    DataRecorder.Register in file  ${path}  ${id}
    GlobalAPI.WriteBox  QUOTE CREATED  ${res}
    [Return]  ${res}

###
# It modify an quotes using a dictionary to specify the data that will be modified.
# -param quotesID(String): It is the id of the quotes to be modified.
# -param dictData(Dictionary): It is the dictionary with the attributes and values to be modified.
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
# -return(QuotesOjct): It is the data of the request modified.
###
Modify
    [Arguments]  ${id}  ${dictData}
    GlobalAPI.Action  MODIFYING QUOTE ---------------
    GlobalAPI.WriteBox  New Quote data  ${dictData}
    ${body}=  Set Variable  ${dictData}
    ${response}=  PUT request  ${id}  ${dictData}
    GlobalAPI.Verification PUT success  ${response.status_code}
    GlobalAPI.WriteBox  Quote Modified Response  ${response.content}
    GlobalAPI.Verify the data exists for  ${response}  description
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  QuoteAPI_ext.create from data  ${res}
    [Return]  ${res}
###
# It delete an quote.
# -param obj(QuoteObj): It is the id of the quote to be deleted.
# -param exp_code(String): It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
# -return(Bool): It is True if the quote has been deleted.
###
Delete 
    [Arguments]  ${obj}
    GlobalAPI.Action  DELETING QUOTE ---------------
    ${id}=  GlobalAPI.Object get attribute  ${obj}  Id
    ${response}=  DELETE request  ${id}
    GlobalAPI.Verification DELETE success  ${response.status_code} 
    ${content}=  Convert to string   ${response.content}
    ${flag}=  GlobalAPI.String contains string  ${content}  "success": true
    IF  ${flag} == False
        GlobalAPI.WriteBox  DELETE Response  ${content}
        GlobalAPI.Error   The ${id} has not been deleted.
    END
    #${strContent}=  Convert To String  ${response.content}
    #${res}=  Convert to dictionary  ${response.content}
    [Return]  ${flag}
###
# It is a flexible comparison. Both objects could have differents numbers of attributes,
# but all attributes of the first object should be exists in the second object and they 
# they should have the same values.
# -param objA(QuoteObj) : It is the first quote to be compared.
# -param objB(QuoteObj) :It is the second quote to be compared.
###
Compare
    [Arguments]  ${objA}  ${objB}
    ${flag}=  QuoteAPI_ext.Compare  ${objA}  ${objB}
    [Return]  ${flag}
###
# It is a strict comparison. Both objects should have the same number of attributes,
# the same attributes and the same values.
# -param objA(QuoteObj) : It is the first quote to be compared.
# -param objB(QuoteObj) :It is the second quote to be compared.
###
Equal
    [Arguments]  ${objA}  ${objB}
    ${flag}=  QuoteAPI_ext.Equal  ${objA}  ${objB}
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
# -param  id(String): It is the ID of the quote.
# -return(Bool): It is true if the quote exist in the system.
###
Exists by ID
    [Arguments]  ${id}
    GlobalAPI.Action  GETTING QUOTE ----------------
    GlobalAPI.Write  Get data of the quote ID: ${id}
    ${response}=  GET request  ${id}
    GlobalAPI.Verification GET success  ${response.status_code} 
    ${dictBody}=  Convert to dictionary  ${response.content}
    GlobalAPI.WriteBox  Quote data getted  ${dictBody}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  QuoteAPI_ext.Create from data  ${res}
    GlobalAPI.Object attribute should exists  ${res}  id
    [Return]  ${res}

