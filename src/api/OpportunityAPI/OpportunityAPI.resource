*** Settings ***
Documentation  This manage the events relate to the endpoint related to the opportunities.

Library    RequestsLibrary
Library    Collections
Library    JSONLibrary

Resource    ../../../src/common/libs/GlobalAPI.resource
Variables    ../../../src/common/libs/variables.yml
Variables    ../../../config.yml

Library    ../../../src/common/libs/DictTools.py
Library    ../../../src/api/OpportunityAPI/OpportunityAPI_ext.py
Library    ../../../src/common/libs/DataRecorder.py

*** Variables ***
# It contains the reference to the endppoint for the oipportunities
${endPoint_opp}  /v1/projects/opportunities
# It is the id of the endpoints created.
${recordPath_opp}  /resources/records/opportunities_created.dat

*** Keywords ***
####################################################### HTTP REQUESTS #######################################################
###
# It made a GET reques to the REST api service and return the response of the request.
# -param opportunityID(String): It is the id of the opportunity to get the data.
# -return(response): It is the response of the request.
###
GET request
    [Arguments]  ${opportunityID}
    ${headers}=  Create Dictionary  Authorization=${token}
    ${response}=  GET On Session  ${SessionAPI}  ${endPoint_opp}/${opportunityID}  ${headers}
    #GlobalAPI.WriteBox  OPPORTUNITY GET Response  ${response.content }
    [Return]  ${response}

###
# It excute the POST request to the opportunity endopoint.
# -param dictData(Dictionaty): It is a dictionary with the data used to be created.
# -return(response): It is the reponse of the PORT request.
###
POST request
    [Arguments]  ${dictData}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}    # It does a POST request
    ${response}=  POST On Session  ${SessionAPI}  ${endPoint_opp}  headers=${headers}  json=${dictData}
    [Return]  ${response}
###
# It is the execution of a PUT request to the opportunity endpoint.
# -param oppID(String): It is the id of the opportunity to be modified.
# -param dictData(dictionary): It is the dictionary with the data to be modified, the atributes as keys and values.
# -return(response): It is the response object from the PUT request.
###
PUT request
    [Arguments]  ${oppID}  ${dictData}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  PUT On Session  ${SessionAPI}  url=${endPoint_opp}/${oppID}  headers=${headers}  json=${dictData}
    #GlobalAPI.WriteBox  OPPORTUNITY PUT Response  ${response.content }
    [Return]  ${response}
###
# It excute the DELETE request to the opportunity endopoint.
# -param oppID(string): It is the id of the opportunity to be deleted.
# -return(response): It is the reponse of the DELETE request.
###
DELETE request
    [Arguments]  ${oppID}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  DELETE On Session  ${SessionAPI}  ${endPoint_opp}/${oppID}  headers=${headers}
    #GlobalAPI.WriteBox  OPPORTUNITY DELETE Response  ${response.content}
    [Return]  ${response}

####################################################### ACTIONS #######################################################
###
# It create a opportunity from a dictionary.
# -param dataDict(Dictionary):
# -return(OpportunityObj): It is the Opportunity object created with the dictionary.
###
Create from
    [Arguments]  ${dataDict}
    ${res}=  OpportunityAPI_ext.create from data  ${dataDict}
    [Return]  ${res}
### 
# It verify if a opportunity exists in the system.
# -param  oppID(String): It is the ID of the opportunity.
# -return(bool): It is true if the opportunity exist in the system.
###
Exists by ID
    [Arguments]  ${oppID}
    ${response}=  GET request  ${oppID}
    ${status_code}=  Convert to string  ${response.status_code}
    ${res}=  Set Variable  True
    ${content}=  Convert to string   ${response.content}
    IF  ${status_code} != ${http_success}
        ${res}=  Set Variable  False
    END
    ${flag}=  GlobalAPI.String contains string  ${content}  "opportunity":null
    IF  ${flag} == True
        ${res}=  Set Variable  False
    END
    [return]  ${res}    
###
# It return the data related to a çn opportunity.
# -param opportunityID(string): it is the ID of the opportunity.
# -return(dictionary): It return a dicttionary related to the opportunity.
Get Info
    [Arguments]  ${opportunityID}  ${exp_code}=200
    GlobalAPI.Action  GETTING OPPORTUNITY ----------------
    GlobalAPI.Write  Get data of the opportunity ID: ${opportunityID}
    ${response}=  GET request  ${opportunityID}
    IF  ${response.status_code} != ${exp_code}
        ${msg}=  Set Variable  Wrong expected code. Expectected code ${exp_code}, but the current code is ${response.status_code}
        GlobalAPI.Failed  ${msg}
    END
    ${strContent}=  Convert To String  ${response.content}
    Should Contain  ${strContent}  "id":
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  Get From Dictionary  ${res}  opportunity
    ${res}=  OpportunityAPI_ext.create from data  ${res}
    [Return]  ${res}
###
# It verify the the response has the correct code and the data of the opbject in attribute. If the status code of the content
# is not correct or the content of the attribute specified is not correct then thjis keyword fail.
# -param response(response): It is the response of the request.
# -param field(String): It is the attribute to search in the response.
###
Verify the data exists for
    [Arguments]  ${response}  ${field}
    Pass verification code  ${response.status_code}
    # It verify the data of the opportunity exists
    ${content}=  Convert to string   ${response.content}
    Should Not Contain  ${content}  "${field}":null

###
# It add a new opportunity it have as parameter a dictionary wiht the data for the opportunity
# -param dictData(dictionary): It is a dictionary with the data of the new oppportunity
#        Ex:  ${dictData}=  Create Dictionary  name=Jazz Test  description=Test Opportunity  currencyIsoCode=USD
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
###
Create
    [Arguments]  ${dictData}  ${exp_code}=200
    GlobalAPI.Action  CREATING OPPORTUNITY ----------------
    GlobalAPI.WriteBox  Data for the new opportunity  ${dictData}
    ${response}=  POST request  ${dictData}
    IF  ${response.status_code} != ${exp_code}
        ${msg}=  Set Variable  Wrong expected code. Expectected code ${exp_code}, but the current code is ${response.status_code}
        GlobalAPI.Failed  ${msg}
    END
    GlobalAPI.Verify the data exists for  ${response}  opportunity
    # It convert the response body in a dictionary
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  Get From Dictionary  ${res}  opportunity
    ${res}=  OpportunityAPI_ext.create from data  ${res}
    ${id}=  GlobalAPI.Object get attribute  ${res}  id
    ${path}=  GlobalAPI.Get Path  ${recordPath_opp}
    DataRecorder.Register in file  ${path}  ${id}
    GlobalAPI.WriteBox  OPPORTUNITY CREATED  ${res}
    [Return]  ${res}
###
# It modify an opportunity using a dictionary to specify the data that will be modified.
# -param opportunityID(String): It is the id of the opportunity to be modified.
# -param dictData(dictionary): It is the dictionary with the attributes and values to be modified.
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
# -return(OpportunityOjct): It is the data of the request modified.
###
Modify
    [Arguments]  ${opportunityID}  ${dictData}  ${exp_code}=200
    GlobalAPI.Action  MODIFYING OPPORTUNITY ---------------
    GlobalAPI.WriteBox  New Opportunity data  ${dictData}
    ${body}=  Set Variable  ${dictData}
    ${response}=  PUT request  ${opportunityID}  ${dictData}
    IF  ${response.status_code} != ${exp_code}
        ${msg}=  Set Variable  Wrong expected code. Expectected code ${exp_code}, but the current code is ${response.status_code}
        GlobalAPI.Failed  ${msg}
    END
    GlobalAPI.Verify the data exists for  ${response}  opportunity
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  Get From Dictionary  ${res}  opportunity
    ${res}=  OpportunityAPI_ext.create from data  ${res}
    GlobalAPI.WriteBox  OPPORTUNITY MODIFIED  ${res}
    [Return]  ${res}
###
# It delete an opportunity.
# -param oppID(String): It is the id of the opportunity to be deleted.
# -param exp_code(String)= It is the expected code of the requests, if the expected request is different to this a fail is reqised, the default response code is 200.
###
Delete 
    [Arguments]  ${oppID}  ${exp_code}=200
    GlobalAPI.Action  DELETING OPPORTUNITY ---------------
    GlobalAPI.Write  Deleting opportunity for: ${oppID}
    ${response}=  DELETE request  ${oppID}
    IF  ${response.status_code} != ${exp_code}
        ${msg}=  Set Variable  Wrong expected code. Expectected code ${exp_code}, but the current code is ${response.status_code}
        GlobalAPI.Failed  ${msg}
    END
    IF  ${response.status_code} == 200
        ${content}=  Convert to string   ${response.content}
        Should Not Contain  ${content}  "success": true
    END
    ${strContent}=  Convert To String  ${response.content}
    ${res}=  Convert to dictionary  ${response.content}
    [Return]  ${res}

###
# It is a flexible comparison. Both objects could have differents numbers of atributes,
# but all attributes of the first object should be exists in the second object and they 
# they should have the same values.
# -param oppA(OpportunityObj) : It is the first opportunities to be compared.
# -param oppB(OpportunityObj) :It is the second opportunity to be compared.
###
Compare
    [Arguments]  ${oppA}  ${oppB}
    GlobalAPI.Action  Compare Opportunities
    GlobalAPI.WriteBox  Opportunity A  ${oppA}
    GlobalAPI.WriteBox  Opportunity B  ${oppB}
    ${flag}=  OpportunityAPI_ext.Compare  ${oppA}  ${oppB}
    [Return]  ${flag}
###
# It is a strict comparison. Both objects should have the same number of attributes,
# the same attributes and the same values.
# -param oppA(OpportunityObj) : It is the first opportunities to be compared.
# -param oppB(OpportunityObj) :It is the second opportunity to be compared.
###
Equal
    [Arguments]  ${oppA}  ${oppB}
    GlobalAPI.Action  Verify if are equals
    GlobalAPI.WriteBox  Opportunity A  ${oppA}
    GlobalAPI.WriteBox  Opportunity B  ${oppB}
    ${flag}=  OpportunityAPI_ext.Equal  ${oppA}  ${oppB}
    [Return]  ${flag}
###
# It return the list of quotes related to the current opportunity.
# -param opp(OpportunityObj):  It is the opportunity to get the list of opportunity.
# -return(list): It is the list of QuoteObj list related to the opportunity.
###
Get quotes from
    [Arguments]  ${opp}
    ${res}=  OpportunityAPI_ext.Get quotes  ${opp}
    [Return]  ${res}
###
# It return the list of quotes related to the current opportunity.
# -param opp(OpportunityObj):  It is the opportunity to get the list of opportunity.
# -return(Int): It is the quantity of quotes of the opportunity.
###
Get quotes quantity from
    [Arguments]  ${opp}
    ${res}=  OpportunityAPI_ext.Get quote quantity  ${opp}
    [Return]  ${res}
