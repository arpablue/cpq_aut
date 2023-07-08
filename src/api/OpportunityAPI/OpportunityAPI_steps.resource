*** Settings ***
Library    RequestsLibrary
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/common/libs/Validations.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI.resource

*** Keywords ***
###
# It prepare the initialise the global variables.
###
Prepare requierements
    GlobalAPI.Step  Prepare requirements
    ${rand}=  GlobalAPI.Generate number
    ${name}=  Set Variable  Jazz_${rand}
    Set Global Variable  ${name}
    ${valueExp}=  Set Variable  Updated Opportunity for Arcee ${rand}
    Set Global Variable  ${valueExp}
    ${attr}=  Set Variable  description
    Set Global Variable  ${attr}

###
# It creata a new opportunity.
# -param name(String): It is the name of the opportunity.
# -param description(String): It is the description of the new opportunity.
# -return(OpportunityObj): It is the opportunity created.
###
Create a new opportunity
    [Arguments]  ${name}  ${description}
    GlobalAPI.Step  Create a new opportunity
    ${name}=  GlobalAPI.Generate number wiht text  ${name}
    ${description}=  Set Variable  ${Description} ${name}
    ${data}=  Create Dictionary  name=${name}  description=${description}
    ${new}=  OpportunityAPI.Create  ${data}
    [Return]  ${new}
###
# It create an opportunity using as a dictionary to create an opportunity.
# -param data(Dictionary): It is the parameters used to create the opportunity.
# -return(OpportunityObj): It is the opportunity created.
###
Create an opportunity
    [Arguments]  ${data}
    GlobalAPI.Step  Create an opportunit
    GlobalAPI.WriteBox  Data for the opportunitiy  ${data}
    ${new}=  OpportunityAPI.Create  ${data}
    [Return]  ${new}
    
###
###
# Create a neew opportunity with random data and return the data of the opportunity created.
# -return(OpportunityObj): Is the data returned of the new opportunity.
####
Add a new opportunity
    GlobalAPI.Step  Add a new opportunity
    ${name}=  GlobalAPI.Generate number wiht text  Optimus
    ${oppData}=  Create Dictionary  name=${name}  description=Test Opportunity for ${name}  currencyIsoCode=USD
    ${oppRes}=  OpportunityAPI.Create  ${oppData}
    [Return]  ${oppRes}

###
# It create and verify the creation of a new opportunity.
# -return(OpportunityObj): It is the new oppoortunity created.
###
Create a random opportunity
    GlobalAPI.Step  Create a random opportunity
    ${newOpp}=  Add a new opportunity
    ${newOppID}=  GlobalAPI.Object get attribute  ${newOpp}  id
    GlobalAPI.Write  ID of the new opportunity: ${newOppId}
    ${oppInfo}=  OpportunityAPI.Get Info  ${newOppID}
    [Return]  ${oppInfo}

###
# It verify that a opportuninty is created
# -param opp(OpportunityObj): It is the opportunity to verify the object is the same.
###
Verify if the opportunity has been created
    [Arguments]  ${opp}
    GlobalAPI.Step  Verify if the opportunity has been created
    ${id}=  GlobalAPI.Object get attribute  ${opp}  id
    ${flag}=  OpportunityAPI.Exists by ID  ${id}
    Validations.Verify it is true  ${flag}  The opportunity not exist in the system, when should be created.
    ${oppInf}=  OpportunityAPI.Get Info  ${id}
    ${flag}=  OpportunityAPI.Compare  ${opp}  ${oppInf}
    Validations.Verify it is true  ${flag}  The opportunity created is not the same than the system.
    GlobalAPI.Success  The opportunity has been created without problem.

###
# It verify that a opportuninty is created
# -param opp(OpportunityObj): It is the opportunity to verify the object is the same.
###
Verify the opportunity exists
    [Arguments]  ${opp}
    GlobalAPI.Step  Verify the opportunity exists
    ${id}=  GlobalAPI.Object get attribute  ${opp}  id
    ${flag}=  OpportunityAPI.Exists by ID  ${id}
    Validations.Verify it is true  ${flag}  The opportunity not exist in the system.
    ${oppInf}=  OpportunityAPI.Get Info  ${id}
    ${flag}=  OpportunityAPI.Compare  ${opp}  ${oppInf}
    Validations.Verify it is true  ${flag}  The opportunity created is not the same than the system.
    GlobalAPI.Success  The opportunity has been created without problem.

###
# It verify that a opportuninty is created
# -param opp(OpportunityObj): It is the opportunity to verify the object is the same.
###
Verify the opportunity not exist
    [Arguments]  ${opp}
    GlobalAPI.Step  Verify the opportunity not exist
    ${id}=  GlobalAPI.Object get attribute  ${opp}  id
    ${flag}=  OpportunityAPI.Exists by ID  ${id}
    Validations.Verify it is False  ${flag}  The opportunity exist in the system when should not exists.
    GlobalAPI.Success  The opportunity not exist in the system
###
# It modify the opportunity with generated the data. This step generate random data to modify the 
# assigned attributed.
# -param oppInfo(OpportunityObj): It is the opportunity object to be modified.
# -return(OpportunityObj): It is the Opportunity object wiht the data modified returned by the requests.
###
Modify an opportunity 
    [Arguments]  ${oppInfo}
    GlobalAPI.Step  Modify an opportunity
    ${oppID}=  GlobalAPI.Object get attribute  ${oppInfo}  id
    Write  Number generated to use in the new description ${rand}
    ${oppDataEdit}=  Create Dictionary  ${attr}=${valueExp}
    ${oppEdit}=  OpportunityAPI.Modify  ${oppID}  ${oppDataEdit}
    [Return]  ${oppEdit}

###
# It delete an opportunity
# -param oppInfo(QuoteObj): It is the opportunity to be delete.
###
Delete an opportunity
    [Arguments]  ${oppInfo}
    GlobalAPI.Step  Delete an opportunity
    ${oppID}=  GlobalAPI.Object get attribute  ${oppInfo}  id
    #### Upate Opportunity
    ${oppEdit}=  OpportunityAPI.Delete  ${oppID}
    [Return]  ${oppEdit}

###
# It verify that a object has been modified.
# -param oppInfo(OpportunityObj): It is the opportunity orignal object.
# -param oppEdit(OpportunityObj): It is the opportunity object wilth the modified data.
###
Verify the modifications
    [Arguments]  ${oppInfo}  ${oppEdit}
    GlobalAPI.Step  Verify the quote modifications
    #### Verification object
    ${attrsDif}=  GlobalAPI.Object get differences  ${oppInfo}  ${oppEdit}
    GlobalAPI.WriteBox  Attributes with differences  ${attrsDif}
    GlobalAPI.Object show attributes  ${oppInfo}  ${oppEdit}  ${attrsDif}
    ${flag}=  GlobalAPI.Dictionary key exists  ${attrsDif}  modified_time
    IF  ${flag} == False
        GlobalAPI.WriteBox  Attributes modified   ${attrsDif}
        GlobalAPI.Failed  The [modified_time] attribute not exist in the when should exists.
        Fail  The modified_time it is not present in the attributes modified when should be it.
    END
    ${size}=  Get Length  ${attrsDif}
    Validations.Evaluate to be equals  2  ${size}  The quantity of attributes modified are not 2
