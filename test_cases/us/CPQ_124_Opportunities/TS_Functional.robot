*** Settings ***
Library    RequestsLibrary
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI_steps.resource
Resource    ../../../src/api/QuoteAPI/QuoteAPI_steps.resource
Resource    ../../../src/api/QuoteLinesAPI/QuoteLinesAPI_steps.resource

Suite Setup  Start session 

*** Variables ***

${opportunityID}  08a0001mtxdifryw
${rand}  0
${name}  Set Variable  Jazz
${valueExp}  Set Variable  Updated Opportunity for Arcee ${rand}
${attr}  Set Variable  description
${productID}  FLX-2+0x2-M0120-L0070
${productQTY}  5

*** Test Cases ***
It is not possible delete opportunity with is associated with one quote
    ${qty}=  Set variable  2
    ${rand}=  GlobalAPI.Generate number
    ${opp}=  OpportunityAPI_steps.Create an opportunity using a text  ${rand}
    #@{quotes}=  Create List
    OpportunityAPI_steps.Verify if the opportunity has been created  ${opp}
    
    ${quoteList}=  QuoteAPI_steps.Create quotes for opportunity  ${opp}  ${rand}  ${qty}
    ${quoteLinesList}=  QuoteLinesAPI_steps.Create quoteLines for the quote list  ${quoteList}  ${rand}  ${qty}

    #${quoteSize}=   Get Length  ${quoteList}
    #${qlSize}=  Get Length  ${quoteLinesList}

    # Target actions to be tested
    OpportunityAPI_steps.Delete an opportunity  ${opp}

    ${flag}=  QuoteAPI_steps.Validate all quotes not exists  ${quoteList}
    ${flag2}=  QuoteLinesAPI_steps.Validate all quotes lines not exists  ${quoteLinesList}

    Validations.Verify it is True  ${flag}  Some Quotes or QuoteLines has not been deleted.
    Validations.Verify it is True  ${flag2}  Some Quote Lines or QuoteLines has not been deleted.


