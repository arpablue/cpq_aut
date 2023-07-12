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
    ${flag}=  SessionAPI.isActive
    IF  ${flag} == False
        FAIL  The current token is Unauthorized when should be authorized.
    END
    