*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections

Resource    ../../../src/api/OpportunityAPI/OpportunityAPI_steps.resource
Resource    ../../../src/api/QuoteAPI/QuoteAPI_steps.resource
Resource    ../../../src/api/QuoteLinesAPI/QuoteLinesAPI_steps.resource

Suite Setup  Start session 


*** Variables ***
${productID}  FLX-2+0x2-M0120-L0070
${attr}  description
${value}  <value> - It is the description
*** Test Cases ***
Verify the QuoteLines can be created without problems
    [Tags]  cpq-123
    ${opp}=  OpportunityAPI_steps.Create a new opportunity  Optimus  This description is for
    ${quoteNew}=  QuoteAPI_steps.Create a new quote  OptimusQuote  Description for  ${opp}
    ${qlNew}=  QuoteLinesAPI_steps.Created a QuoteLine  OptimusQL  ${quoteNew}  ${productID}
    QuoteLinesAPI_steps.Verify if the QuoteLine has been created  ${qlNew}

It is possible modify a QuoteLines
    [Tags]  acceptance  cpq-123
    ${opp}=  OpportunityAPI_steps.Create a new opportunity  Optimus  This description is for
    ${quoteNew}=  QuoteAPI_steps.Create a new quote  OptimusQuote  Description for  ${opp}
    ${qlNew}=  QuoteLinesAPI_steps.Created a QuoteLine  OptimusQL  ${quoteNew}  ${productID}
    ${qlEdit}=  QuoteLinesAPI_steps.Modify a QuoteLine  ${qlNew}  ${attr}  ${value}
    QuoteLinesAPI_steps.Verify the QuoteLine modifications  ${qlNew}  ${qlEdit}

It is possible delete a QuoteLines
    [Tags]  acceptance  cpq-123
    ${opp}=  OpportunityAPI_steps.Create a new opportunity  Optimus  This description is for
    ${quoteNew}=  QuoteAPI_steps.Create a new quote  OptimusQuote  Description for  ${opp}
    ${qlNew}=  QuoteLinesAPI_steps.Created a QuoteLine  OptimusQL  ${quoteNew}  ${productID}
    QuoteLinesAPI_steps.Delete a QuoteLine  ${qlNew}
    QuoteLinesAPI_steps.Verify the QuoteLine not exists  ${qlNew}
    
