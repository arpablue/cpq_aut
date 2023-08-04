*** Settings ***
Library    RequestsLibrary
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/api/SessionAPI/SessionAPI.resource
Resource    ../../../src/api/SessionAPI/SessionAPI_steps.resource

Suite Setup  Start session 

*** Variables ***


*** Test Cases ***
Verify the validation of the status token
    [Tags]  acceptance  session
    ${flag}=  SessionAPI.isActive
    IF  ${flag} == False
        FAIL  The current token is Unauthorized when should be authorized.
    END
    ${user}=  SessionAPI.Get User ID
    GlobalAPI.Write  User ID: ${user}
    IF  ${user} == None
        GlobalAPI.Failed  It is not possible get the user id of the session.
    END