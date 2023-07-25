*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI_steps.resource
Resource    ../../../src/api/QuoteAPI/QuoteAPI.resource
Resource    ../../../src/api/QuoteAPI/QuoteAPI_steps.resource

Suite Setup  Start session 

*** Variables ***

${attr}  description
${value}  <value> - It is the description
*** Test Cases ***
Verify the quotes can be created without problems
    [Tags]  cpq-122
    ${opp}=  OpportunityAPI_steps.Create a new opportunity  Optimus  This description is for
    ${quoteNew}=  QuoteAPI_steps.Create a new quote  OptimusQuote  Description for  ${opp}
    QuoteAPI_steps.Verify if the quote has been created  ${quoteNew}

It is possible modify a quote
    [Tags]  acceptance  cpq-122
    ${opp}=  OpportunityAPI_steps.Create a new opportunity  Optimus  This description is for
    ${quoteNew}=  QuoteAPI_steps.Create a new quote  OptimusQuote  Description for  ${opp}
    ${quoteEdit}=  QuoteAPI_steps.Modify a quote  ${quoteNew}  ${attr}  ${value}
    QuoteAPI_steps.Verify modifications  ${quoteNew}  ${quoteEdit}

It is possible delete a quote
    [Tags]  acceptance  cpq-122
    ${opp}=  OpportunityAPI_steps.Create a new opportunity  Optimus  This description is for
    ${quoteNew}=  QuoteAPI_steps.Create a new quote  OptimusQuote  Description for  ${opp}
    QuoteAPI_steps.Delete a quote  ${quoteNew}
    
 