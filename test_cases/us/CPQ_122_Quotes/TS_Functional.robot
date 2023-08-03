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
It is not possible delete quotes with is associated with one quote
    ${qty}=  Set Variable  3
    ${opp}=  OpportunityAPI_steps.Create a new opportunity  Optimus  This description is for
    ${quoteNew}=  QuoteAPI_steps.Create a new quote  OptimusQuote  Description for  ${opp}
    ${quoteList}=  Create List  ${quoteNew}
    ${quoteLinesList}=  QuoteLinesAPI_steps.Create quoteLines for the quote list  ${quoteList}  ${rand}  ${qty}

    # Target actions to be tested
    QuoteAPI_steps.Delete a quote  ${quoteNew}

    ${flag}=  QuoteLinesAPI_steps.Validate all quotes lines not exists  ${quoteLinesList}
    Validations.Verify it is True  ${flag}  Some Quote Lines or QuoteLines has not been deleted.