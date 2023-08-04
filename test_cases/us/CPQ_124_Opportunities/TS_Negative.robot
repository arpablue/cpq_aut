*** Settings ***
Library    RequestsLibrary
Library    Collections

Resource    ../../../src/common/libs/Validations.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI_steps.resource

Suite Setup  Start session 

*** Variables ***

*** Test Cases ***

###
# It verify that it is not possible create an opportunity without a name.
###
It is not possible create an opportunity without a name
    [tags]  negative  cpp-123
    ${rand}=  GlobalAPI.Generate number
    ${data}=  Create dictionary  description=Test Opportunity_${rand}
    ${opp}=  OpportunityAPI.create  ${data}  400
###
# It verify that it is not possible create an opportunity without data.
###
It is not possible create an opportunity without data
    [tags]  negative  cpp-123
    ${rand}=  GlobalAPI.Generate number
    ${data}=  Create dictionary
    ${opp}=  OpportunityAPI.create  ${data}  400
###
# It verify that it is possible to create an opportunity without a description.
###
It is possible create an opportunity without a description
    [tags]  negative  cpp-123
    ${rand}=  GlobalAPI.Generate number
    ${data}=  Create dictionary  name=NoDesc_${rand}
    ${opp}=  OpportunityAPI.create  ${data}  200
###
# It verify that it is not possible if the attribute are not in capitalize format.
###
Verify that it is not possible create an oportunity with no capitaluise format
    [Tags]  cpq-124  retest  regression  cpq-202  opportunity
    OpportunityAPI_steps.Prepare requierements
    ${data}=  Create Dictionary  name=Opptimus  description=It is a description for Opptimus
    ${response}=  OpportunityAPI.POST request  ${data}
    ${flag}=  GlobalAPI.Evaluate POST success  ${response.status_code}
    IF  ${flag} == True
        GlobalAPI.Failed  A opportunity with invalid vallues has been created, when it should not be created.
    END

###
# It verify that it is not possible if the attribute are not in capitalize format.
###
Verify that an opportunity cannnot be created without a name
    [Tags]  cpq-124  retest  regression  cpq-202  opportunity
    OpportunityAPI_steps.Prepare requierements
    ${data}=  Create Dictionary  Description=It is a description for Opptimus
    ${response}=  OpportunityAPI.POST request  ${data}
    ${flag}=  GlobalAPI.Evaluate POST success  ${response.status_code}
    IF  ${flag} == True
        GlobalAPI.Failed  A opportunity with invalid vallues has been created, when it should not be created.
    END
