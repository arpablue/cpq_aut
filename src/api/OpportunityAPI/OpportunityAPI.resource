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
    ${response}=  GET On Session  ${SessionAPI}  ${endPoint_opp}/${opportunityID}  headers=${headers}  expected_status=any
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
    ${response}=  POST On Session  ${SessionAPI}  ${endPoint_opp}  headers=${headers}  json=${dictData}  expected_status=any
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
    ${response}=  PUT On Session  ${SessionAPI}  url=${endPoint_opp}/${oppID}  headers=${headers}  json=${dictData}  expected_status=any
    #GlobalAPI.WriteBox  OPPORTUNITY PUT Response  ${response.content }
    [Return]  ${response}
###
# It excute the DELETE request to the opportunity endopoint.
# -param oppID(string): It is the id of the opportunity to be deleted.
# -return(response): It is the reponse of the DELETE request.
###
DELETE request
    [Arguments]  ${oppID}
    GlobalAPI.Write  Delete Opportunity ID: ${oppID}
    &{headers}=  Create Dictionary  Content-Type=${content_type}  Application=${application}  Authorization=${token}
    ${response}=  DELETE On Session  ${SessionAPI}  ${endPoint_opp}/${oppID}  headers=${headers}  expected_status=any
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
    GlobalAPI.Action  Exists by ID [${oppID}]
    ${response}=  GET request  ${oppID}
    ${status_code}=  Convert to string  ${response.status_code}
    ${res}=  Set Variable  True
    ${content}=  Convert to string   ${response.content}
    ${flag}=  GlobalAPI.Validate code  ${status_code}
    IF  ${flag} == False
        GlobalAPI.Warning  The [${status_code}] response code is not a valid code.
        [Return]  False
    END
    ${flag}=  GlobalAPI.Evaluate GET success  ${status_code}
    [Return]  ${res}    
###
# It return the data related to an opportunity.
# -param opportunityID(string): it is the ID of the opportunity.
# -return(dictionary): It return a dicttionary related to the opportunity.
Get Info
    [Arguments]  ${opportunityID}
    GlobalAPI.Action  GETTING OPPORTUNITY ----------------
    GlobalAPI.Write  Get data of the opportunity ID: ${opportunityID}
    ${response}=  GET request  ${opportunityID}
    GlobalAPI.Verification GET success  ${response.status_code} 
    ${dictBody}=  Convert to dictionary  ${response.content}
    GlobalAPI.WriteBox  Opportunity data getted  ${dictBody}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  OpportunityAPI_ext.Create from data  ${res}
    GlobalAPI.Object attribute should exists  ${res}  id
    [Return]  ${res}
###
# It verify the the response has the correct code and the data of the opbject in attribute. If the status code of the content
# is not correct or the content of the attribute specified is not correct then thjis keyword fail.
# -param response(response): It is the response of the request.
# -param field(String): It is the attribute to search in the response.
###
Verify the data exists for
    [Arguments]  ${response}  ${field}
    
    # It verify the data of the opportunity exists
    ${content}=  Convert to string   ${response.content}
    Should Not Contain  ${content}  "${field}":null

###
# It add a new opportunity it have as parameter a dictionary wiht the data for the opportunity
# -param dictData(dictionary): It is a dictionary with the data of the new oppportunity
#        Ex:  ${dictData}=  Create Dictionary  name=Jazz Test  description=Test Opportunity  currencyIsoCode=USD
# -return(OpportunityObj): It is the opportunity related to the data of the response.
###
Create
    [Arguments]  ${dictData}
    GlobalAPI.Action  CREATING OPPORTUNITY ----------------
    GlobalAPI.WriteBox  Data for the new opportunity  ${dictData}
    ${response}=  POST request  ${dictData}
    GlobalAPI.Verification POST success  ${response.status_code} 
    GlobalAPI.Verify the data exists for  ${response}  data
    # It convert the response body in a dictionary
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  OpportunityAPI_ext.create from data  ${res}
    ${id}=  GlobalAPI.Object get attribute  ${res}  Id
    ${path}=  GlobalAPI.Get Path  ${recordPath_opp}
    DataRecorder.Register in file  ${path}  ${id}
    GlobalAPI.WriteBox  OPPORTUNITY CREATED  ${res}
    [Return]  ${res}
###
# It modify an opportunity using a dictionary to specify the data that will be modified.
# -param opportunityID(String): It is the id of the opportunity to be modified.
# -param dictData(dictionary): It is the dictionary with the attributes and values to be modified.
# -return(OpportunityOjct): It is the data of the request modified.
###
Modify
    [Arguments]  ${opportunityID}  ${dictData}
    GlobalAPI.Action  MODIFYING OPPORTUNITY ---------------
    GlobalAPI.WriteBox  New Opportunity data  ${dictData}
    ${body}=  Set Variable  ${dictData}
    ${response}=  PUT request  ${opportunityID}  ${dictData}
    GlobalAPI.Verification PUT success  ${response.status_code}
    GlobalAPI.WriteBox  Opportunity Modify Response  ${response.content}
    GlobalAPI.Verify the data exists for  ${response}  description
    ${dictBody}=  Convert to dictionary  ${response.content}
    ${res}=  Get From Dictionary  ${dictBody}  data
    ${res}=  OpportunityAPI_ext.create from data  ${res}
    [Return]  ${res}
###
# It delete an opportunity.
# -param oppID(String): It is the id of the opportunity to be deleted.
# -return(Dictionary): It is the data of the request.
###
Delete 
    [Arguments]  ${opp}
    GlobalAPI.Action  DELETING OPPORTUNITY ---------------
    ${oppID}=  GlobalAPI.Object get attribute  ${opp}  Id
    ${response}=  DELETE request  ${oppID}
    GlobalAPI.Verification DELETE success  ${response.status_code} 
    ${content}=  Convert to string   ${response.content}
    Should Not Contain  ${content}  "success": true
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
    ${flag}=  GlobalAPI.Objects Compare  ${oppA}  ${oppB}
    [Return]  ${flag}
###
# It is a flexible comparison. Both objects could have differents numbers of atributes,
# but all attributes of the first object should be exists in the second object and they 
# they should have the same values.
# -param oppA(OpportunityObj) : It is the first opportunities to be compared.
# -param oppB(OpportunityObj) :It is the second opportunity to be compared.
###
Compare attrs
    [Arguments]  ${oppA}  ${oppB}
    GlobalAPI.Action  Compare Opportunities
    GlobalAPI.WriteBox  Opportunity A  ${oppA}
    GlobalAPI.WriteBox  Opportunity B  ${oppB}
    ${flag}=  GlobalAPI.Objects Compare attrs  ${oppA}  ${oppB}
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
    ${flag}=  GlobalAPI.Objects Should be equals  ${oppA}  ${oppB}
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
    ${res}=  OpportunityAPI_ext.Get quotes quantity  ${opp}
    [Return]  ${res}
