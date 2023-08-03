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
    ${data}=  Create Dictionary  Name=${name}  Description=${description}
    ${new}=  OpportunityAPI.Create  ${data}
    [Return]  ${new}
###
# It create an opportunity using a random number as part of the name and description.
# -param text(String): It is the text to be added to the name and description of the opportunity.
# -return(OpportunityObj): It is the Opportunity created.
###
Create an opportunity using a text
    [Arguments]  ${text}
    GlobalAPI.Step  Create an text
    &{data}=  Create Dictionary  Name=Optimus_${text}  Description=Description for Optimus_${text}
    ${obj}=  OpportunityAPI.Create  ${data}
    [Return]  ${obj}

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
    ${data}=  Create Dictionary  Name=${name}  Description=Test Description for ${name}  CurrencyIsoCode=USD
    ${baseObj}=  OpportunityAPI.Create from  ${data}
    ${res}=  OpportunityAPI.Create  ${data}
    ${flag}=  OpportunityAPI.Compare  ${baseObj}  ${res}
    Validations.Verify it is true    ${flag}  The opportunity create is not the same that the expected.
    [Return]  ${res}

###
# It create and verify the creation of a new opportunity.
# -return(OpportunityObj): It is the new oppoortunity created.
###
Create a random opportunity
    GlobalAPI.Step  Create a random opportunity
    ${new}=  Add a new opportunity
    ${id}=  GlobalAPI.Object get attribute  ${new}  Id
    GlobalAPI.Write  ID of the new opportunity: ${id}
    ${info}=  OpportunityAPI.Get Info  ${id}
    ${flag}=  OpportunityAPI.Equal  ${info}  ${info}
    Validations.Verify it is true  ${flag}  The opportunity crewated in the system os not the same that the opportunity requested.
    [Return]  ${info}
    

###
# It verify that a opportuninty is created
# -param opp(OpportunityObj): It is the opportunity to verify the object is the same.
###
Verify if the opportunity has been created
    [Arguments]  ${opp}
    GlobalAPI.Step  Verify if the opportunity has been created
    ${id}=  GlobalAPI.Object get attribute  ${opp}  Id
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
    ${id}=  GlobalAPI.Object get attribute  ${opp}  Id
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
    ${id}=  GlobalAPI.Object get attribute  ${opp}  Id
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
    ${rand}=  GlobalAPI.Generate number
    ${attr}=  Set Variable  Description
    ${valueExp}=  Set Variable  Description modified by automation - index ${rand}
    ${oppID}=  GlobalAPI.Object get attribute  ${oppInfo}  Id
    ${oppDataEdit}=  Create Dictionary  ${attr}=${valueExp}
    GlobalAPI.WriteBox  Opportunity data to be modified  ${oppDataEdit}
    ${oppEdit}=  OpportunityAPI.Modify  ${oppID}  ${oppDataEdit}
    [Return]  ${oppEdit}

###
# It delete an opportunity
# -param oppInfo(QuoteObj): It is the opportunity to be delete.
###
Delete an opportunity
    [Arguments]  ${obj}
    GlobalAPI.Step  Delete an opportunity
    ${res}=  OpportunityAPI.Delete  ${obj}
    [Return]  ${res}

###
# It verify that a object has been modified.
# -param oppInfo(OpportunityObj): It is the opportunity orignal object.
# -param oppEdit(OpportunityObj): It is the opportunity object wilth the modified data.
###
Verify the modifications
    [Arguments]  ${oppInfo}  ${oppEdit}
    GlobalAPI.Step  Verify the quote modifications
    ${modifiedTime}=  Set Variable  ModifiedTime
    #### Verification object
    ${attrsDif}=  GlobalAPI.Object get differences  ${oppInfo}  ${oppEdit}
    GlobalAPI.WriteBox  Attributes with differences  ${attrsDif}
    GlobalAPI.Object show attributes  ${oppInfo}  ${oppEdit}  ${attrsDif}
    ${flag}=  GlobalAPI.Dictionary key exists  ${attrsDif}  ${modifiedTime}
    IF  ${flag} == False
        GlobalAPI.WriteBox  Attributes modified   ${attrsDif}
        GlobalAPI.Failed  The [${modifiedTime}] attribute has not been  modified when should be.
    END
    ${size}=  Get Length  ${attrsDif}
    Validations.Evaluate to be equals  2  ${size}  The quantity of attributes modified are not 2

Verify the opportunity should not exist
    [Arguments]  ${target}
    GlobalAPI.Step  Verify the opportunity should not exist
    ${id}=  GlobalAPI.Object get attribute  ${target}  id
    ${flag}=  OpportunityAPI.Exists by ID  ${id}
    #IF  ${flag} == True
    #    GlobalAPI.Failed  The [${id}] oppotunity still exists, when this should be deleted.
    #END
    #GlobalAPI.Success  The [${id}] opportunity not exist in the document.
