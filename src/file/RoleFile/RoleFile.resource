*** Settings ***
Library  Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/common/libs/Validations.resource

Library    ../../../src/file/RoleFile/RoleFile_ext.py


*** Keywords ***
###
# It return an role form th file specified by a position.
# -param position(int): It is the position of the role to be taked.
# -return(RoleObj):  It is the role of the position specified.
###
Get role in the position
    [Arguments]  ${position}
    ${role}=  RoleFile_ext.Get role position  ${position}
    [Return]  ${role}
###
# It return the all roles that exists int the file.
# -return(List): It is the list of RolesObj list.
###
Get roles in file
    ${roles}=  RoleFile_ext.Load roles from file
    [Return]  ${roles}


