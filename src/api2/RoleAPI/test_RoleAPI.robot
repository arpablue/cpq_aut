*** Settings ***
Library    RequestsLibrary
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource

Library  ../../../src/api2/RoleAPI/RoleAPI.py

*** Test Cases ***
###
# It verify that it is possible get all roles from the syste.
###
#Verify that it is possible get the all roles
#    ${list}=  RoleAPI.Get all roles
#    ${size}=  Get Length  ${list}
#    GlobalAPI.Write  Quantity of roles: ${size}
#    IF  ${size} < 1 
#        GlobalAPI.Failed  "No roles has been found inthe systenm, when should be exists at less one role."
#    END
###
# It verify that it is possibke et the list of the roles taht are visible.
###
Verify that it is possible get all visible roles
    ${list}=  RoleAPI.Get all visible roles
    GlobalAPI.WriteBox  Lits of roles  ${list}
###
# It verify that it is possible get the roles assigned to a user.
###
#It is possible get the roles assigned to a user
#    ${user}=  USerFile.Get user in the position  2
#    RoleAPI.Get Roles of the user  ${user}