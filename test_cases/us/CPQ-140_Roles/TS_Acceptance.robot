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
# It verify that it is possible get all roles from the syste.
###
Verify that it is possible get the all roles
    ${list}=  RoleAPI.Get all roles
    GlobalAPI.WriteBox  Lits of roles  ${list}
###
# It verify that it is possibke et the list of the roles taht are visible.
###
Verify that it is possible get all visible roles
    ${list}=  RoleAPI.Get all visible roles
    GlobalAPI.WriteBox  Lits of roles  ${list}
