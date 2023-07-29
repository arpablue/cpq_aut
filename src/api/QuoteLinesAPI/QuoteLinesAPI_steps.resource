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
# It delete a QuoteLine
# -param oppInfo(QuoteLineObj): It is the opportunity to be delete.
###
Delete a QuoteLine
    [Arguments]  ${quoteline}
    GlobalAPI.Step  Delete an QuoteLine
    ${qlEdit}=  QuoteLinesAPI.Delete  ${quoteline}
    [Return]  ${qlEdit}
###
# It verify if a QuoteLine exists or not.
# -params ql(QuoteLinesObj): It is the QuoteLine object to verify if ecists.
###
Verify the QuoteLine not exists  
    [Arguments]  ${ql}
    ${id}=  GlobalAPI.Object get attribute  ${ql}  Id
    ${flag}=  QuoteLinesAPI.Exists by ID  ${id}
    Validations.Evaluate to be equals  False  ${flag}  The QuoteLine still exists when it should be delete.


