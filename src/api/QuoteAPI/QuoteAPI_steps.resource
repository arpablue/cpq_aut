*** Settings ***
Library    RequestsLibrary
Library    String
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/common/libs/Validations.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI.resource
Resource    ../../../src/api/QuoteAPI/QuoteAPI.resource

*** Keywords ***

# It create a quote to create a new quote in base an opportunity.
# -param name(Text): It is the name assigned to the quote.
# -param description(text): It is the description for the quote.
# -param opp(OpportunityObj): It is the opportunity to create the quote.
###
Create a new quote
    [Arguments]  ${name}  ${description}  ${opp}
    GlobalAPI.Action  Create a new quote
    ${oppID}=  GlobalAPI.Object get attribute  ${opp}  Id
    ${name}=  Set Variable  ${name}_${oppID}
    ${description}=  Set Variable  ${name} : ${description}
    ${data}=  Create Dictionary  Name=${name}  Description=${description}  OpportunityId=${oppID}
    ${quote}=  QuoteAPI.Create  ${data}
    [Return]  ${quote}
    
###
# It compare two objects in base to the attribute specified. It the attribute have
# different value on both objects then the keyword fail.
# -param objA(Quote): It is the first object to be compared.
# -param objB(Quote): It is the second object to be compared.
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
    # Veirfying the values of the target values are differents
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
# -param quoteObj(QuoteObj): It is the quote to be modified.
# -param attr(string): It is the name of the attribute to be modified.
# -param value(String): -It is the new value assigned to the attributed specified.
###
Modify a quote
    [Arguments]  ${quoteObj}  ${attr}  ${value}
    GlobalAPI.Step  Modify a quote
    ${id}=  GlobalAPI.Object get attribute  ${quoteObj}  Id
    ${random}=  GlobalAPI.Generate number
    ${value}=  Replace String  ${value}  <value>  ${random}
    &{data}=  Create Dictionary  ${attr}=${value}
    ${res}=  QuoteAPI.Modify  ${id}  ${data}
    [Return]  ${res}

###
# It verify that a opportuninty is created
# -param opp(OpportunityObj): It is the opportunity to verify the object is the same.
###
Verify if the quote has been created
    [Arguments]  ${quote}
    GlobalAPI.Step  Verify if the quote has been created
    ${id}=  GlobalAPI.Object get attribute  ${quote}  Id
    ${flag}=  QuoteAPI.Exists by ID  ${id}
    #${oppInf}=  QuoteAPI.Get Info  ${id}
    #Validations.Verify it is true  ${flag}  The quote[${id}] has not been created in the system
    #${flag}=  QuoteAPI.Compare  ${quote}  ${oppInf}
    #Validations.Verify it is true  ${flag}  the quotes[${id}] created and the quote that exists in the system are not the same
    #GlobalAPI.Success  the quote [${id}] exists in the system

###
# It verify that a opportuninty is created
# -param opp(OpportunityObj): It is the opportunity to verify the object is the same.
###
Verify if the quote exists
    [Arguments]  ${quote}
    GlobalAPI.Step  Verify if the quote has been created
    ${id}=  GlobalAPI.Object get attribute  ${quote}  Id
    ${flag}=  QuoteAPI.Exists by ID  ${id}
    ${oppInf}=  QuoteAPI.Get Info  ${id}
    Validations.Verify it is true  ${flag}  The quote [${id}] exists in the system
    ${flag}=  QuoteAPI.Compare  ${quote}  ${oppInf}
    Validations.Verify it is true  ${flag}  The quotes created and the quote that exists in the system are not the same
    GlobalAPI.Success  The quote [${id}] exists in the system

###
# It verify that a opportuninty is created
# -param opp(OpportunityObj): It is the opportunity to verify the object is the same.
###
Verify if the quote not exist
    [Arguments]  ${quote}
    GlobalAPI.Step  Verify if the quote not exist
    ${id}=  GlobalAPI.Object get attribute  ${quote}  Id
    ${flag}=  QuoteAPI.Exists by ID  ${id}
    ${oppInf}=  QuoteAPI.Get Info  ${id}
    Validations.Verify it is false  ${flag}  The quote exists in the system when should not exist
    GlobalAPI.Success  the quote [${id}] not exist


###
# It verify that a object has been modified.
# -param quoteInfo(QuoteObj): It is the opportunity orignal object.
# -param quoteEdit(QuoteObj): It is the opportunity object wilth the modified data.
###
Verify modifications
    [Arguments]  ${quoteInfo}  ${quoteEdit}
    GlobalAPI.Step  Verify the quote modifications
    #### Verification object
    ${attrsDif}=  GlobalAPI.Object get differences  ${quoteInfo}  ${quoteEdit}
    GlobalAPI.WriteBox  Attributes with differences  ${attrsDif}
    GlobalAPI.Object show attributes  ${quoteInfo}  ${quoteEdit}  ${attrsDif}
    ${flag}=  GlobalAPI.Dictionary key exists  ${attrsDif}  ModifiedTime
    IF  ${flag} == False
        GlobalAPI.WriteBox  Attributes modified   ${attrsDif}
        GlobalAPI.Failed  the [ModifiedTime] attribute not exist in the when should exists.
        Fail  the ModifiedTime it is not present in the attributes modified when should be it.
    END
    ${size}=  Get Length  ${attrsDif}
    Validations.Evaluate to be equals  2  ${size}  the quantity of attributes modified are not 2

###
# It delete an opportunity
# -param quoteInfo(QuoteObj): It is the opportunity to be delete.
###
Delete a Quote
    [Arguments]  ${obj}
    GlobalAPI.Step  Delete an opportunity
    ${res}=  QuoteAPI.Delete  ${obj}
    [Return]  ${res}

# It verify if a qUoteLine exists or not.
# -params quote(QuoteObj): It is the QuoteLine object to verify if ecists.
###
Verify the Quote not exists  
    [Arguments]  ${quote}
    ${id}=  GlobalAPI.Object get attribute  ${quote}  Id
    ${flag}=  QuoteAPI.Exists by ID  ${id}
    Validations.Evaluate to be equals  False  ${flag}  the QuoteLine still exists when it should be delete.
