*** Settings ***
Library  Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/common/libs/Validations.resource

Library    ../../../src/file/UserFile/UserFile_ext.py


*** Keywords ***
###
# It return an user form th file specified by a position.
# -param position(int): It is the position of the user to be taked.
# -return(UserObj):  It is the user of the position specified.
###
Get user in the position
    [Arguments]  ${position}
    ${user}=  UserFile_ext.Get user position  ${position}
    [Return]  ${user}
###
# It return a list of all ÜserObj in the files.
# -return(List): It is the list of UserObj in the file.
Get users in file
    ${users}=  UserFile_ext.Load users from file
    [Return]  ${users}


