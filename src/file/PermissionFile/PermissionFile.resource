*** Settings ***
Library  Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/common/libs/Validations.resource

Library    ../../../src/file/PermissionFile/PermissionFile_ext.py


*** Keywords ***
###
# It return an permission form th file specified by a position.
# -param position(int): It is the position of the permission to be taked.
# -return(PermissionObj):  It is the permission of the position specified.
###
Get permission in the position
    [Arguments]  ${position}
    ${permission}=  PermissionFile_ext.Get permission position  ${position}
    [Return]  ${permission}
###
# It return the all permissions that exists int the file.
# -return(List): It is the list of permissionsObj list.
###
Get permissions in file
    ${permissions}=  PermissionFile_ext.Load permissions from file
    [Return]  ${permissions}


