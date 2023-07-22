*** Settings ***
Library  RequestsLibrary
Resource  ../../../src/common/libs/GlobalAPI.resource


Suite Setup  Start session 

*** Test Cases ***

Validate the verification code for Success GET Success
     GlobalAPI.Verification GET success  200
Validate the verification code for Success GET NoContent
     GlobalAPI.Verification GET NoContent  204
Validate the verification code for POST Success
     GlobalAPI.Verification POST Success  201
Validate the verification code for POST Success NoContent
     GlobalAPI.Verification POST Success NoContent  204
Validate the verification code for PUT Success
     GlobalAPI.Verification PUT Success  200
Validate the verification code for PUT Success NoContent
     GlobalAPI.Verification PUT Success NoContent  204
Validate the verification code for DELETE Success
     GlobalAPI.Verification DELETE Success  200
Validate the verification code for DELETE Success NoContent
     GlobalAPI.Verification DELETE Success NoContent  204
Validate the verification code for PATCH Success
     GlobalAPI.Verification PATCH Success  200
Validate the verification code for PATCH Success NoContent
     GlobalAPI.Verification PATCH Success NoContent  204
Validate the verification code for No User
     GlobalAPI.Verification NoUser  400
Validate the verification code for Unauthorized Access
     GlobalAPI.Verification Unauthorized Access  401
Validate the verification code for Forbidden
     GlobalAPI.Verification Forbidden  403
Validate the verification code for Server Error
     GlobalAPI.Verification Server Error  500
