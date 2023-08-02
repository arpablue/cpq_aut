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
    ${opp}=  Create an opportunity  ${rand}
    #@{quotes}=  Create List
    OpportunityAPI_steps.Verify if the opportunity has been created  ${opp}
    
    ${quoteList}=  Quote - Create quotes for opportunity  ${opp}  ${rand}  ${qty}
    ${quoteLinesList}=  QuoteLines - Create quoteLines for the quote list  ${quoteList}  ${rand}  ${qty}

    ${quoteSize}=   Get Length  ${quoteList}
    ${qlSize}=  Get Length  ${quoteLinesList}

    # Target actions to be tested
    OpportunityAPI_steps.Delete an opportunity  ${opp}

    ${flag}=  QuoteAPI_steps.Validate all quotes not exists  ${quoteList}
    ${flag2}=  QuoteLinesAPI_steps.Validate all quotes lines not exists  ${quoteLinesList}

    Validations.Verify it is True  ${flag}  Some Quotes or QuoteLines has not been deleted.
    Validations.Verify it is True  ${flag2}  Some Quote Lines or QuoteLines has not been deleted.

*** Keywords ***
###
# It create an opportunity using a random number as part of the name and description.
# -param text(String): It is the text to be added to the name and description of the opportunity.
# -return(OpportunityObj): It is the Opportunity created.
###
Create an opportunity
    [Arguments]  ${text}
    GlobalAPI.Step  Create an text
    &{data}=  Create Dictionary  name=Optimus_${text}  Description=Description for Optimus_${text}
    ${obj}=  OpportunityAPI.Create  ${data}
    [Return]  ${obj}
###
# It cereate a quote usign a random value for the name and description for an opportunity. 
# -param obj(OpportunityObj): It is the opportunity used to created the quote.
# -param text(String): It is the text used to created the quote.
###
Create a quote
    [Arguments]  ${obj}  ${text}
    GlobalAPI.Step  Create a quote
    ${obj}=  QuoteAPI_steps.Create a new quote  Quote_${text}  Description for Quote_${text}  ${obj}
    [Return]  ${obj}
###
# It cereate a quote usign a random value for the name and description for an opportunity. 
# -param obj(QuoteObj): It is the opportunity used to created the quote.
# -param text(String): It is the text used to created the quote.
###
Create a Quote Line
    [Arguments]  ${obj}  ${text}
    GlobalAPI.Step  Create a Quote Line
    ${obj}=  QuoteLinesAPI_steps.Created a QuoteLine  Quote_${text}  Description for Quote_${text}  ${obj}
    [Return]  ${obj}
###
# It verify if a opportunity not exist, if the opportunity exists then this step raise a fail event.
# -param opp(OpportunityObj): It is the Opportuntity used to verify that not exists.
###
Opportunity - verify the has been deleted
    [Arguments]  ${opp}
    GlobalAPI.Step  Opportunity - verify the has been deleted
    OpportunityAPI_steps.Delete an opportunity  ${opp}
    OpportunityAPI_steps.Verify the opportunity not exist  ${opp}
###
# It verify if each quote of the list exists in the system.
# -param quoteList(List): It is a list of quotes.
###
Quote - verify been delete for the opportunity
    [Arguments]  ${quoteList}
    GlobalAPI.Step  Quote - verify been delete for the opportunity
    ${isPassed}=  Set Variable  True
    FOR  ${quote}  IN  @{quoteList}
        ${id}=  GlobalAPI.Object get attribute  ${quote}  Id
        ${flag}=  QuoteAPI.Exists by ID  ${id}
        IF  ${flag} == False
            GlobalAPI.Success  The Quote[${id}] has been deleted.
        ELSE
            GlobalAPI.ERROR  The Quote[${id}] exists when should be deleted.
            ${isPassed}=  Set Variable  False
        END
    END
    Validations.Verify it is true  ${isPassed}  Some quotes has not been deleted when should all quotes should be deleted.
###
# It create a number of quotes for specific opportunity.
# -param opp(OpportunityObj): It is the opportunity to create the quotes.
# -param qty(Int): It is the quantity of quotes to be created for the opportunity.
# -return(List): It is the list of quotes created.
###
Quote - Create quotes for opportunity
    [Arguments]  ${opp}  ${text}  ${qty}
    GlobalAPI.Step  Quote - Create quotes for opportunity - Quantity[${qty}]
    IF  ${qty} < 1
        GlobalAPI.Failed  It is not possible create quotes for an opportunity, because the quantity is [${qty}]
    END
    ${id}=  GlobalAPI.Object get attribute  ${opp}  Id
    @{quotes}=  Create List
    FOR  ${pos}  IN RANGE  ${qty}
        GlobalAPI.Step  +++ ${pos}) Creating quote for the opportunity[${id}]
        ${quote}=  Create a quote  ${opp}  ${text}
        QuoteAPI_steps.Verify if the quote has been created  ${quote}
        Append To List  ${quotes}  ${quote}
    END
    [return]  ${quotes}
###
# It create QuoteLines for a specific quote.
# -param quote(QuoteObj): It is the quote use d to created the QuoteLines.
# -param text(String): It is the text used for the name and description of the QuoteLine.
# -param qty(String): It is the text used to create the name and the descritption.
# -return(list): It is the list of the QuoteLines created for the quoted.
###
QuoteLine - Create QuoteLines for a quote
    [Arguments]  ${quote}  ${text}  ${qty}
    GlobalAPI.Step  QuoteLine - Create QuoteLines for a quote - Quantity[${qty}]
    IF  ${qty} < 1
        GlobalAPI.Failed  It is not possible create QuoteLines for a quote, because the quantity is [${qty}]
    END
    ${id}=  GlobalAPI.Object get attribute  ${quote}  Id
    @{qls}=  Create List
    ${index}=  Set Variable  0
    FOR  ${pos}  IN RANGE  ${qty}
        GlobalAPI.Step  +++ ${pos}) Creating QuoteLines for the quote[${id}]
        ${data}=  Create Dictionary  Name=QL_${text}  Description=Description for ${text}  ProductId=${productID}  ParentQuoteId=${id}  Quantity=${productQTY}
        ${obj}=  QuoteLinesAPI.Create  ${data}
        #QuoteLinesAPI_steps.Verify if the QuoteLine has been created  ${ql}
        Append To List  ${qls}  ${obj}
        ${index}=  Evaluate  ${index} + 1
        ${size}=  GlobalAPI.List size  ${qls}
    END
    [return]  ${qls}
###
# It create quote lines for a each quote of list of quotes.
# -param quotes(List): It is the a list of quotes.
# -param text(String): It is the string used fo rth ename and the edescription used in the quote line creation process.
# -param qyt(int): It is the quantity of the product used in the creation of the quote line.
###
QuoteLines - Create quoteLines for the quote list
    [Arguments]  ${quotes}  ${text}  ${qty}
    GlobalAPI.Step  QuoteLines - Create quoteLines for the quote lists - Quantity[${qty}]
    IF  ${qty} < 1
        GlobalAPI.Failed  It is not possible create QuoteLines for a quote, because the quantity is [${qty}]
    END
    ${qls}=  Create List
    ${size}=  Get Length  ${qls}
    FOR  ${quote}  IN  @{quotes}
        ${list}=  QuoteLine - Create QuoteLines for a quote  ${quote}  ${text}  ${qty}
        ${qls}=  GlobalAPI.List concat  ${qls}  ${list}
        ${size}=  Get Length  ${qls}
    END
    [Return]  ${qls}

