*** Settings ***
Library  Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/common/libs/Validations.resource

Library    ../../../src/file/PartnerFile/PartnerFile_ext.py


*** Keywords ***
###
# It return an partner form th file specified by a position.
# -param position(int): It is the position of the partner to be taked.
# -return(PartnerObj):  It is the partner of the position specified.
###
Get partner in the position
    [Arguments]  ${position}
    ${partner}=  PartnerFile_ext.Get partner position  ${position}
    [Return]  ${partner}
###
# It return the all partners that exists int the file.
# -return(List): It is the list of partnersObj list.
###
Get partners in file
    ${partners}=  PartnerFile_ext.Load partners from file
    [Return]  ${partners}


