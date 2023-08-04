*** Settings ***
Library    RequestsLibrary
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/common/libs/Validations.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI_steps.resource

Suite Setup  Start session 

*** Variables ***

${opportunityID}  08a0001mtxdifryw
${rand}=  0
${name}=  Set Variable  Jazz
${valueExp}=  Set Variable  Updated Opportunity for Arcee ${rand}
${attr}=  Set Variable  description

*** Test Cases ***
###
# It verify the a new opportunity can be creaated
###
It is possible creating a new opportunity
    [Tags]  cpq-124
    OpportunityAPI_steps.Prepare requierements
    ${oppNew}=  OpportunityAPI_steps.Create a random opportunity
    OpportunityAPI_steps.Verify if the opportunity has been created  ${oppNew}

###
# It verify that is that a opportunity can be modified.
###
It is possible modify an opportunity
    [Tags]  acceptance  cpq-124
    OpportunityAPI_steps.Prepare requierements
    ${oppNew}=  OpportunityAPI_steps.Create a random opportunity
    ${oppEdit}=  OpportunityAPI_steps.Modify an opportunity  ${oppNew}
    OpportunityAPI_steps.Verify the modifications  ${oppNew}  ${oppEdit}

###
# It create an an opportunity and verify that it is possible ddelete.
# The opportunity created doesn't have relation with another modules.
###
It is possible delete an opportunity
    [Tags]  acceptance  cpq-124
    OpportunityAPI_steps.Prepare requierements
    ${oppNew}=  OpportunityAPI_steps.Create a random opportunity
    OpportunityAPI.Delete  ${oppNew}
    OpportunityAPI_steps.Verify the opportunity should not exist  ${oppNew}

Verify the data to create an opportunity is saved
    [Tags]  cpq-124  acceptance
    OpportunityAPI_steps.Prepare requierements
    ${data}=  Create Dictionary  Name=Opptimus  Description=It is a description for Opptimus
    ${opp}=  OpportunityAPI.Create from  ${data}
    ${oppNew}=  OpportunityAPI.Create  ${data}
    ${flag}=  OpportunityAPI.Compare  ${opp}  ${oppNew}
    IF  ${flag} == False
        GlobalAPI.Failed  The data in the system is not the same that specified in the test case.
    END
    
