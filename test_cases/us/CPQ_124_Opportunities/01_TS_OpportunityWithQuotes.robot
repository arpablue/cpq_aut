*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    OperatingSystem

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI_steps.resource
Resource    ../../../src/api/QuoteAPI/QuoteAPI_steps.resource

Suite Setup  Start session 

*** Variables ***

${opportunityID}  08a0001mtxdifryw
${rand}=  0
${name}=  Set Variable  Jazz
${valueExp}=  Set Variable  Updated Opportunity for Arcee ${rand}
${attr}=  Set Variable  description

*** Test Cases ***

It is not possible delete opportunity with association 3 quote
    ${qtyQuotes}=  Set Variable  3
    ${rand}=  GlobalAPI.Generate number
    ${qtyQuotes}=  Convert To Integer  ${qtyQuotes}
    ${opp}=  Create an opportunity  ${rand}
    GlobalAPI.WriteBox  Opportunity data  ${opp}
    FOR  ${index}  IN RANGE  0  ${qtyQuotes}
        ${quote}=  Create a quote  ${opp}  ${index}_${rand}
    END
    ${id}=  GlobalAPI.Object get attribute  ${opp}  id
    ${opp}=  OpportunityAPI.Get Info  ${id}
    GlobalAPI.WriteBox  Opportunity data  ${opp}
    ${quotes}=  OpportunityAPI.Get quotes from  ${opp}
    ${qty}=  OpportunityAPI.Get quotes quantity from  ${opp}

    GlobalAPI.WrtiLine
    #OpportunityAPI_steps.Delete an opportunity  ${opp}
    #Verify the opportunity has not been deleted  ${opp}

*** Keywords ***
It is not possible delete opportunity with association quotes
    [Arguments]  ${qtyQuotes}
    ${rand}=  GlobalAPI.Generate number
    ${qtyQuotes}=  Convert To Integer  ${qtyQuotes}
    FOR  ${index}  IN RANGE  0  ${qtyQuotes}
        Log To Console  --- ${index}
    END
    #${opp}=  Create an opportunity  ${rand}
    #${quote}=  Create a quote  ${opp}  ${rand}
    #OpportunityAPI_steps.Delete an opportunity  ${opp}
    #Verify the opportunity has not been deleted  ${opp}
Create an opportunity
    [Arguments]  ${rand}
    GlobalAPI.Step  Create an opportunity
    &{data}=  Create Dictionary  name=Optimus_${rand}  description=Description for Optimus_${rand}
    ${obj}=  OpportunityAPI.Create  ${data}
    [Return]  ${obj}
Create a quote
    [Arguments]  ${opp}  ${rand}
    GlobalAPI.Step  Create a quote
    ${obj}=  QuoteAPI_steps.Create a new quote  Quote_${rand}  Description for Quote_${rand}  ${opp}
    [Return]  ${obj}
Verify the opportunity has not been deleted
    [Arguments]  ${target}
    GlobalAPI.Step  Verify the opportunity has not been deleted
    ${id}=  GlobalAPI.Object get attribute  ${target}  id
    ${flag}=  OpportunityAPI.Exists by ID  ${id}
    IF  ${flag} == False
        GlobalAPI.Failed  The Opportunity ${id} has been deleted when it should not be deleted because it is related to a quote.
    END
    