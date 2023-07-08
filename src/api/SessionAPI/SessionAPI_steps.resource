*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/common/libs/Validations.resource
Resource    ../../../src/api/SessionAPI/SessionAPI.resource

*** Keywords ***

# It create a quote to create a new quote in base an opportunity.
# -param name(Text): It is the name assigned to the quote.
# -param description(text): It is the description for the quote.
# -param opp(OpportunityObj): It is the opportunity to create the quote.
###
Create a new quote
    [Arguments]  ${name}  ${description}  ${opp}
    GlobalAPI.Action  Create a new quote
    ${oppID}=  GlobalAPI.Object get attribute  ${opp}  id
    ${name}=  Set Variable  ${name}_${oppID}
    ${description}=  Set Variable  ${name} : ${description}
    ${data}=  Create Dictionary  name=${name}  description=${description}  opportunityId=${oppID}
    ${quote}=  SessionAPI.Create  ${data}
    [Return]  ${quote}
