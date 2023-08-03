*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/common/libs/Validations.resource
Resource    ../../../src/api/QuoteAPI/QuoteAPI.resource
Resource    ../../../src/api/QuoteLinesAPI/QuoteLinesAPI.resource

*** Keywords ***
# It create a quote to create a new quote in base an Quote.
# -param name(String): It is the name assigned to the quote.
# -param description(String): It is the description for the quote.
# -param obj(QuoteObj): It is the Quote to create the quote.
###
Create a new quote
    [Arguments]  ${name}  ${description}  ${obj}
    GlobalAPI.Action  Create a new quote
    ${id}=  GlobalAPI.Object get attribute  ${obj}  Id
    ${name}=  Set Variable  ${name}_${id}
    ${description}=  Set Variable  ${name} : ${description}
    ${data}=  Create Dictionary  Name=${name}  Description=${description}  OpportunityId=${id}
    ${quote}=  QuoteAPI.Create  ${data}
    [Return]  ${quote}
###
# It cereate a quote usign a random value for the name and description for an opportunity. 
# -param obj(OpportunityObj): It is the opportunity used to created the quote.
# -param text(String): It is the text used to created the quote.
###
Create a quote
    [Arguments]  ${obj}  ${text}
    GlobalAPI.Step  Create a quote
    ${obj}=  Create a new quote  Quote_${text}  Description for Quote_${text}  ${obj}
    [Return]  ${obj}
###
# It create a number of quotes for specific opportunity.
# -param opp(OpportunityObj): It is the opportunity to create the quotes.
# -param qty(Int): It is the quantity of quotes to be created for the opportunity.
# -return(List): It is the list of quotes created.
###
Create quotes for opportunity
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
        Verify if the quote has been created  ${quote}
        Append To List  ${quotes}  ${quote}
    END
    [return]  ${quotes}    
    
###
# It compare two objects in base to the attribute specified. It the attribute have
# different value on both objects then the keyword fail.
# -param objA(QuoteObj): It is the first object to be compared.
# -param objB(QuoteObj): It is the second object to be compared.
###
Quote should be different
    [Arguments]  ${objA}  ${objB}  ${attr}
    GlobalAPI.Step  Quote should be different
    # Get the attributes that have differents attributes.
    ${attrsDif}=  GlobalAPI.Object get differences  ${objA}  ${objB}
    GlobalAPI.Object show attributes  ${objA}  ${objB}  ${attrsDif}
    # Verify if the target attribute exists in the attributes with differents values
    ${flag}=  GlobalAPI.Dictionary key exists  ${attrsDif}  ${attr}
    Should Be True  ${flag}
    # It verify the ModifiedTime field is one of the attributes modified
    ${flag}=  GlobalAPI.Dictionary key exists  ${attrsDif}  ModifiedTime
    Should Be True  ${flag}
    # Verifying the values of the target values are differents
    ${valueA}=  GlobalAPI.Object get attribute  ${objA}  ${attr}
    ${valueB}=  GlobalAPI.Object get attribute  ${objB}  ${attr}
    Should Not Be Equal  ${valueA}  ${valueB}
    # Verify the quantity of of attributes changed should be 2
    ${sizeExp}=  Convert To String  2
    ${size}=  Get Length  ${attrsDif}
    ${size}=  Convert To String  ${size}

    Should Be Equal  ${sizeExp}  ${size}
###
# It modify an quote using the id, the atribute of the object and the vqalue assigned to the attribute.
# -param obj(QuoteObj): It is the quote to be modified.
# -param attr(string): It is the name of the attribute to be modified.
# -param value(String): -It is the new value assigned to the attributed specified.
###
Modify a quote
    [Arguments]  ${obj}  ${attr}  ${value}
    GlobalAPI.Step  Modify a quote
    ${id}=  GlobalAPI.Object get attribute  ${obj}  Id
    ${random}=  GlobalAPI.Generate number
    ${value}=  Replace String  ${value}  <value>  ${random}
    &{data}=  Create Dictionary  ${attr}=${value}
    ${res}=  QuoteAPI.Modify  ${id}  ${data}
    [Return]  ${res}

###
# It verify that a opportuninty is created
# -param obj(QuoteObj): It is the Quote to verify the object is the same.
# [toReview]
###
Verify if the quote has been created
    [Arguments]  ${obj}
    GlobalAPI.Step  Verify if the quote has been created
    ${id}=  GlobalAPI.Object get attribute  ${obj}  Id
    ${flag}=  QuoteAPI.Exists by ID  ${id}
    ${infObj}=  QuoteAPI.Get Info  ${id}
    Validations.Verify it is true  ${flag}  The quote[${id}] has not been created in the system
    ${flag}=  QuoteAPI.Compare  ${obj}  ${infObj}
    Validations.Verify it is true  ${flag}  the quotes[${id}] created and the quote that exists in the system are not the same
    GlobalAPI.Success  the quote [${id}] exists in the system

###
# It verify that a opportuninty is created
# -param obj(QuoteObj): It is the Quote to verify the object is the same.
###
Verify if the quote exists
    [Arguments]  ${obj}
    GlobalAPI.Step  Verify if the quote has been created
    ${id}=  GlobalAPI.Object get attribute  ${obj}  Id
    ${flag}=  QuoteAPI.Exists by ID  ${id}
    ${oppInf}=  QuoteAPI.Get Info  ${id}
    Validations.Verify it is true  ${flag}  The quote [${id}] exists in the system
    ${flag}=  QuoteAPI.Compare  ${obj}  ${oppInf}
    Validations.Verify it is true  ${flag}  The quotes created and the quote that exists in the system are not the same
    GlobalAPI.Success  The quote [${id}] exists in the system

###
# It verify that a opportuninty is created
# -param obj(QuoteObj): It is the Quote to verify the object is the same.
###
Verify if the quote not exist
    [Arguments]  ${obj}
    GlobalAPI.Step  Verify if the quote not exist
    ${id}=  GlobalAPI.Object get attribute  ${obj}  Id
    ${flag}=  QuoteAPI.Exists by ID  ${id}
    ${oppInf}=  QuoteAPI.Get Info  ${id}
    Validations.Verify it is false  ${flag}  The quote exists in the system when should not exist
    GlobalAPI.Success  the quote [${id}] not exist


###
# It verify that a object has been modified.
# -param objInfo(QuoteObj): It is the Quote orignal object.
# -param objEdit(QuoteObj): It is the Quote object wilth the modified data.
###
Verify modifications
    [Arguments]  ${objInfo}  ${objEdit}
    GlobalAPI.Step  Verify the quote modifications
    #### Verification object
    ${attrsDif}=  GlobalAPI.Object get differences  ${objInfo}  ${objEdit}
    GlobalAPI.WriteBox  Attributes with differences  ${attrsDif}
    GlobalAPI.Object show attributes  ${objInfo}  ${objEdit}  ${attrsDif}
    ${flag}=  GlobalAPI.Dictionary key exists  ${attrsDif}  ModifiedTime
    IF  ${flag} == False
        GlobalAPI.WriteBox  Attributes modified   ${attrsDif}
        GlobalAPI.Failed  the [ModifiedTime] attribute not exist in the when should exists.
        Fail  the ModifiedTime it is not present in the attributes modified when should be it.
    END
    ${size}=  Get Length  ${attrsDif}
    Validations.Evaluate to be equals  2  ${size}  The quantity of attributes modified are not 2

###
# It delete an Quote
# -param obj(QuoteObj): It is the Quote to be delete.
###
Delete a Quote
    [Arguments]  ${obj}
    GlobalAPI.Step  Delete an Quote
    ${res}=  QuoteAPI.Delete  ${obj}
    [Return]  ${res}

# It verify if a qUoteLine exists or not.
# -params obj(QuoteObj): It is the QuoteLine object to verify if ecists.
###
Verify the Quote not exists  
    [Arguments]  ${obj}
    ${id}=  GlobalAPI.Object get attribute  ${obj}  Id
    ${flag}=  QuoteAPI.Exists by ID  ${id}
    Validations.Evaluate to be equals  False  ${flag}  The Quote still exists when it should be delete.

###
# It verify tha all quotes of the list are deleted from the system.
# -param quoteList(List): It is a list of quotes to verified the quotes has been removed.
# -return(Bool): It is true all quotes has been removed of the system.
###
Validate all quotes not exists
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


