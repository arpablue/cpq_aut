*** Settings ***
Library    RequestsLibrary
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
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
#It is possible modify an opportunity
#    [Tags]  acceptance  cpq-124
#    OpportunityAPI_steps.Prepare requierements
#    ${oppNew}=  OpportunityAPI_steps.Create a random opportunity
#    ${oppEdit}=  OpportunityAPI_steps.Modify an opportunity  ${oppNew}
#    OpportunityAPI_steps.Verify the modifications  ${oppNew}  ${oppEdit}

###
# It create an an opportunity and verify that it is possible ddelete.
# The opportunity created doesn't have relation with another modules.
###
#It is possible delete an opportunity
#    [Tags]  acceptance  cpq-124
#    OpportunityAPI_steps.Prepare requierements
#    ${oppNew}=  Create a random opportunity
#    OpportunityAPI.Delete  ${oppNew}  200
 