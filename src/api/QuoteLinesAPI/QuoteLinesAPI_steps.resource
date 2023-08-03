*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/common/libs/Validations.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI.resource
Resource    ../../../src/api/QuoteAPI/QuoteAPI.resource
Resource    ../../../src/api/QuoteAPI/QuoteAPI_steps.resource
Resource    ../../../src/api/QuoteLinesAPI/QuoteLinesAPI.resource

*** Keywords ***
###
# It create a new quote.
# -param name(string): It is the name of the new quote line.
# -param quote(QuotePbj): It is the quote object used to create the quote line.
# -param productID( It is the quote ID relate to the Quote Line.
# -return(QuoteLinesObj): It sis the object create in the quote lines
###
Created a QuoteLine
    [Arguments]  ${name}  ${quote}  ${productID}
    GlobalAPI.Step  Created a quote Lines
    ${quoteID}=  GlobalAPI.Object get attribute  ${quote}  Id
    &{data}=  Create dictionary  Name=${name}  ParentQuoteId=${quoteID}  ProductId=${productID}  Quantity=3
    ${qlNew}=  QuoteLinesAPI.Create  ${data}
    [Return]  ${qlNew}
###
# It create a new quote.
# -param name(string): It is the name of the new quote line.
# -param quote(QuotePbj): It is the quote object used to create the quote line.
# -param productID( It is the quote ID relate to the Quote Line.
# -return(QuoteLinesObj): It sis the object create in the quote lines
###
Created a QuoteLine from data
    [Arguments]  ${data}
    GlobalAPI.Step  Created a quote Lines
    ${qlNew}=  QuoteLinesAPI.Create  ${data}
    [Return]  ${qlNew}
###
# It create QuoteLines for a specific quote.
# -param quote(QuoteObj): It is the quote use d to created the QuoteLines.
# -param text(String): It is the text used for the name and description of the QuoteLine.
# -param qty(String): It is the text used to create the name and the descritption.
# -return(list): It is the list of the QuoteLines created for the quoted.
###
Create QuoteLines for a quote
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
Create quoteLines for the quote list
    [Arguments]  ${quotes}  ${text}  ${qty}
    GlobalAPI.Step  QuoteLines - Create quoteLines for the quote lists - Quantity[${qty}]
    IF  ${qty} < 1
        GlobalAPI.Failed  It is not possible create QuoteLines for a quote, because the quantity is [${qty}]
    END
    ${qls}=  Create List
    ${size}=  Get Length  ${qls}
    FOR  ${quote}  IN  @{quotes}
        ${list}=  Create QuoteLines for a quote  ${quote}  ${text}  ${qty}
        ${qls}=  GlobalAPI.List concat  ${qls}  ${list}
        ${size}=  Get Length  ${qls}
    END
    [Return]  ${qls}
###
# It modify an quote using the id, the atribute of the object and the vqalue assigned to the attribute.
# -param quoteLineObj(QuoteObj): It is the quote to be modified.
# -param attr(string): It is the name of the attribute to be modified.
# -param value(String): -It is the new value assigned to the attributed specified.
###
Modify a QuoteLine
    [Arguments]  ${quoteLineObj}  ${attr}  ${value}
    GlobalAPI.Step  Modify a quote
    ${id}=  GlobalAPI.Object get attribute  ${quoteLineObj}  Id
    ${random}=  GlobalAPI.Generate number
    ${value}=  Replace String  ${value}  <value>  ${random}
    &{data}=  Create Dictionary  ${attr}=${value}
    ${res}=  QuoteLinesAPI.Modify  ${id}  ${data}
    [Return]  ${res}

###
# It delete a QuoteLine
# -param obj(QuoteLineObj): It is the quote line to be delete.
# -return(Bool): It is true if the quote line has been delete.
###
Delete a QuoteLine
    [Arguments]  ${obj}
    GlobalAPI.Step  Delete an QuoteLine
    ${flag}=  QuoteLinesAPI.Delete  ${obj}
    [Return]  ${flag}
###
# It verify that a opportuninty is created
# -param opp(OpportunityObj): It is the opportunity to verify the object is the same.
###
Verify if the QuoteLine has been created
    [Arguments]  ${quote}
    GlobalAPI.Step  Verify if the QuoteLines has been created
    ${id}=  GlobalAPI.Object get attribute  ${quote}  Id
    ${flag}=  QuoteLinesAPI.Exists by ID  ${id}
    Should Be True  ${flag}
    ${quoteInf}=  QuoteLinesAPI.Get Info  ${id}
    ${flag}=  QuoteLinesAPI.Compare  ${quote}  ${quoteInf}
    IF  ${flag} == False
        GlobalAPI.Write  The objects are differents
        GlobalAPI.Write  Original quoteline: ${quote}
        GlobalAPI.Write  GET Info quoteline: ${quoteInf}
    END
    Should Be True  ${flag}
    GlobalAPI.Success  The QuoteLine has been created without problems
###
# It verify that a object has been modified.
# -param quoteLineA(OpportunityObj): It is the opportunity orignal object.
# -param quoteLineB(OpportunityObj): It is the opportunity object wilth the modified data.
###
Verify the QuoteLine modifications
    [Arguments]  ${qlInfo}  ${qlEdit}
    GlobalAPI.Step  Verify the quote modifications
    #### Verification object
    ${attrsDif}=  GlobalAPI.Object get differences  ${qlInfo}  ${qlEdit}
    GlobalAPI.WriteBox  Attributes with differences  ${attrsDif}
    GlobalAPI.Object show attributes  ${qlInfo}  ${qlEdit}  ${attrsDif}
    ${flag}=  GlobalAPI.Dictionary key exists  ${attrsDif}  ModifiedTime
    IF  ${flag} == False
        GlobalAPI.WriteBox  Attributes modified   ${attrsDif}
        GlobalAPI.Failed  The [ModifiedTime] attribute not exist in the when should exists.
        Fail  The ModifiedTime it is not present in the attributes modified when should be it.
    END
    ${size}=  Get Length  ${attrsDif}
    Validations.Evaluate to be equals  2  ${size}  The quantity of attributes modified are not 2
###
# It verify if a QuoteLine exists or not.
# -params ql(QuoteLinesObj): It is the QuoteLine object to verify if ecists.
###
Verify the QuoteLine not exists
    [Arguments]  ${ql}
    GlobalAPI.Step  Verify the QuoteLine not exists
    ${id}=  GlobalAPI.Object get attribute  ${ql}  Id
    ${flag}=  QuoteLinesAPI.Exists by ID  ${id}
    Validations.Verify it is false  ${flag}  The QuoteLine still exists when it should be delete.
    GlobalAPI.Success  The Quote Line [${id}] not exists in the sytem.

###
# It verify tha all quotes of the list are deleted from the system.
# -param quoteList(List): It is a list of quotes to verified the quotes has been removed.
# -return(Bool): It is true all quotes has been removed of the system.
###
Validate all quotes lines not exists
    [Arguments]  ${list}
    GlobalAPI.Step  Validate all quotes has been remove                               
    ${res}=  Set Variable  True
    FOR  ${element}  IN  @{list}
        ${flag}=  QuoteAPI.Exists  ${element}
        ${id}=  GlobalAPI.Object get attribute  ${element}  Id
        IF  ${flag} == True
            ${res}=  Set Variable  False
            GlobalAPI.Error  The Quote[${id}] has not been removed the system.
        ELSE
            GlobalAPI.Success  The Quote[${id}] has been removed the system.
        END
    END
    [Return]  ${res}
