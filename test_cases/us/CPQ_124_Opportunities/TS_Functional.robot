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
${rand}=  0
${name}=  Set Variable  Jazz
${valueExp}=  Set Variable  Updated Opportunity for Arcee ${rand}
${attr}=  Set Variable  description

*** Test Cases ***
It is not possible delete opportunity with is associated with one quote
    ${qty}=  Set variable  2
    ${rand}=  GlobalAPI.Generate number
    ${opp}=  Create an opportunity  ${rand}
    #@{quotes}=  Create List
    OpportunityAPI_steps.Verify if the opportunity has been created  ${opp}
    
    @{quotes}=  Quote - Create quotes for opportunity  ${opp}  ${rand}  ${qty}
    @{quoteLines}=  QuoteLines - Create quoteLines for the quote list  ${quotes}  ${rand}  ${qty}
    ${size}=  Get Length  ${quoteLines}
    GlobalAPI.Write  ************ Quantity of QuoteLines created: ${size}
#    Opportunity - verify the has been deleted  ${opp}
#    Quote - verify been delete for the opportunity  ${quotes}

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
# -param opp(OpportunityObj): It is the opportunity used to created the quote.
# -param text(String): It is the text used to created the quote.
###
Create a quote
    [Arguments]  ${opp}  ${text}
    GlobalAPI.Step  Create a quote
    ${obj}=  QuoteAPI_steps.Create a new quote  Quote_${text}  Description for Quote_${text}  ${opp}
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
    ${quotes}=  Create List
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
    ${qls}=  Create List
    FOR  ${pos}  IN RANGE  ${qty}
        GlobalAPI.Step  +++ ${pos}) Creating QuoteLines for the quote[${id}]
        ${ql}=  Create a quote  ${quote}  ${text}
        QuoteLinesAPI_steps.Verify if the QuoteLine has been created  ${ql}
        Append To List  ${qls}  ${ql}
    END
    [return]  ${qls}

QuoteLines - Create quoteLines for the quote list
    [Arguments]  ${quotes}  ${text}  ${qty}
    GlobalAPI.Step  QuoteLines - Create quoteLines for the quote lists - Quantity[${qty}]
    IF  ${qty} < 1
        GlobalAPI.Failed  It is not possible create QuoteLines for a quote, because the quantity is [${qty}]
    END
    ${qls}=  Create List
    FOR  ${quote}  IN  ${quotes}
       ${list}=  QuoteLine - Create QuoteLines for a quote  ${quote}  ${text}  ${qty}
       ${qls}=  Set variable  ${qls} + ${list}
       ${size}=  Get Length  ${list}
       GLobalAPI.Write  ==== Size: ${size}
    END
    [Return]  ${qls}