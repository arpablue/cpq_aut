*** Settings ***
Library    RequestsLibrary
Library    Collections

Resource    ../../../src/common/libs/Validations.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI.resource
Resource    ../../../src/api/OpportunityAPI/OpportunityAPI_steps.resource
Resource    ../../../src/api/QuoteAPI/QuoteAPI.resource
Resource    ../../../src/api/QuoteAPI/QuoteAPI_steps.resource
Resource    ../../../src/api/QuoteLinesAPI/QuoteLinesAPI.resource
Resource    ../../../src/api/QuoteLinesAPI/QuoteLinesAPI_steps.resource

Suite Setup  Start session 

*** Variables ***
${productID}  FLX-2+0x2-M0120-L0070
*** Test Cases ***

###
# It verify that it is not possible create an quoteline without a name.
###
It is not possible createa an quoteline without a name
    [Tags]  negative  cpq-123
    ${rand}=  GlobalAPI.Generate number
    &{oppdata}=  Create dictionary  name=NoDesc_${rand}  description=NoDescription ${rand}  currencyIsoCode=USD
    ${opp}=  OpportunityAPI.Create  ${oppData}
    ${oppId}=  GlobalAPI.Object get attribute  ${opp}  id
    &{quoteData}=  Create dictionary  name=NoDesc_${rand}  description=NoDescription ${rand}  opportunityId=${oppId}
    ${quote}=  QuoteAPI.Create  ${quoteData}
    ${quoteId}=  GlobalAPI.Object get attribute  ${quote}  id
    &{quoteData}=  Create dictionary  description=NoDesc_${rand}  parentQuoteId=${quoteId}  productId=${productID}
    ${ql}=  QuoteLinesAPI.Create  ${quoteData}
    Verify the quoteline not exists  ${ql}  A QuoteLine without a name has been created when this should not be possible
###
# It verify that it is possible to create an quoteline without a description.
###
It is possible create an quoteline without a description
    [Tags]  negative  cpq-123
    ${rand}=  GlobalAPI.Generate number
    &{oppdata}=  Create dictionary  name=NoDesc_${rand}  description=NoDescription ${rand}  currencyIsoCode=USD
    ${opp}=  OpportunityAPI.Create  ${oppData}
    ${oppId}=  GlobalAPI.Object get attribute  ${opp}  id
    &{quoteData}=  Create dictionary  name=NoDesc_${rand}  description=NoDescription ${rand}  opportunityId=${oppId}
    ${quote}=  QuoteAPI.Create  ${quoteData}
    ${quoteId}=  GlobalAPI.Object get attribute  ${quote}  id
    &{quoteData}=  Create dictionary  name=NoDesc_${rand}  parentQuoteId=${quoteId}  productId=${productID}
    ${ql}=  QuoteLinesAPI.Create  ${quoteData}
    Verify the quoteline not exists  ${ql}  A QuoteLine without a name has been created when this should not be possible
###
# It verify that it is possible to create an quoteline without a description.
###
It is possible create an quoteline without a ProductID
    [Tags]  negative  cpq-123
    ${rand}=  GlobalAPI.Generate number
    &{oppdata}=  Create dictionary  name=NoDesc_${rand}  description=NoDescription ${rand}  currencyIsoCode=USD
    ${opp}=  OpportunityAPI.Create  ${oppData}
    ${oppId}=  GlobalAPI.Object get attribute  ${opp}  id
    &{quoteData}=  Create dictionary  name=NoDesc_${rand}  description=NoDescription ${rand}  opportunityId=${oppId}
    ${quote}=  QuoteAPI.Create  ${quoteData}
    ${quoteId}=  GlobalAPI.Object get attribute  ${quote}  id
    &{quoteData}=  Create dictionary  name=NoDesc_${rand}  description=NoDescription_${rand}  parentQuoteId=${quoteId}
    ${ql}=  QuoteLinesAPI.Create  ${quoteData}
    Verify the quoteline not exists  ${ql}  A QuoteLine without a Product ID has been created when this should not be possible
###
# It verify that it is not possible create an quoteline without data.
###
#It is not possible create an quoteline without data
#    [Tags]  negative  cpq-123
#    ${data}=  Create dictionary
#    ${ql}=  QuoteLinesAPI.Create  ${data}
#    Verify the quoteline not exists  ${ql}  A QuoteLine without data has been created when it should not be possible

*** Keywords ***

###
# It verify if an opportuntity not exists. If the object exists then a fail is raised.
# -param opp(quotelineObj): It is the quoteline to verify that not exist in the system.
####
Verify the quoteline not exists
    [Arguments]  ${quoteline}  ${errorMsg}
    GlobalAPI.step  Verify the quoteline not exists
    ${id}=  GlobalAPI.Object get attribute  ${quoteline}  id
    ${flag}=  QuoteLinesAPI.Exists by ID  ${id}
    Validations.Verify it is false  ${flag}  ${errorMsg}
    
