*** Settings ***
Library    RequestsLibrary
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/api/RoleAPI/RoleAPI.resource
Resource    ../../../src/api/RoleAPI/RoleAPI_steps.resource

Suite Setup  Start session 

*** Variables ***


*** Test Cases ***
###
# It vrify that it is possible get all roles from the syste.
###
Verify that it is possible get the all roles
    ${list}=  RoleAPI.Get all roles
    GlobalAPI.WriteBox  Lits of roles  ${list}

