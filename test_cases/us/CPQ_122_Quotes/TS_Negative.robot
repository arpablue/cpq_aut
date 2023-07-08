*** Settings ***
Library    RequestsLibrary
Library    Collections

Resource    ../../../src/common/libs/Validations.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI_steps.resource
Resource    ../../../src/api/QuoteAPI/QuoteAPI.resource
Resource    ../../../src/api/QuoteAPI/QuoteAPI_steps.resource

Suite Setup  Start session 

*** Variables ***

*** Test Cases ***

###
# It verify that it is not possible create an quote without a name.
###
It is not possible createa an quote without a name
    [Tags]  negative  cpq-122
    ${opp}=  OpportunityAPI_steps.Create a random opportunity
    ${id}=  GlobalAPI.Object get attribute  ${opp}  id
    ${name}=  GlobalAPI.Object get attribute  ${opp}  name
    &{data}=  Create Dictionary  description=Description for ${name}  opportunityId=${id}
    QuoteAPi.Create  ${data}  400

###
# It verify that it is possible to create an quote without a description.
###
It is possible create an quote without Opportunity
    [Tags]  negative  cpq-122
    ${opp}=  OpportunityAPI_steps.Create a random opportunity
    ${id}=  GlobalAPI.Object get attribute  ${opp}  id
    ${name}=  GlobalAPI.Object get attribute  ${opp}  name
    &{data}=  Create Dictionary  name=Quote_${name}  description=Description for ${name}
    QuoteAPi.Create  ${data}  400
###
# It verify that it is possible to create an quote without a description.
###
It is possible create an quote without a description
    [Tags]  negative  cpq-122
    ${opp}=  OpportunityAPI_steps.Create a random opportunity
    ${id}=  GlobalAPI.Object get attribute  ${opp}  id
    ${name}=  GlobalAPI.Object get attribute  ${opp}  name
    &{data}=  Create Dictionary  name=Quote_${name}  opportunityId=${id}
    QuoteAPi.Create  ${data}  200
###
# It verify that it is not possible create an quote without data.
###
It is not possible create an quote without data
    [Tags]  negative  cpq-122
    &{data}=  Create Dictionary
    QuoteAPi.Create  ${data}  400

