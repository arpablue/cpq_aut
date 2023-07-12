*** Settings ***
Library  Collections
Resource  ../../../src/file/PartnerFile/PartnerFile.resource

*** Test Cases ***
###
# It verify thast is possible recover the second partner fro
###
Get the second position of the file
    Log to Console  ${\n}---- Get the second position of the file
    ${partner}=  PartnerFile.Get partner in the position  2
    IF  ${partner} == None
        Fail  The returned partner is None, It is not correct when should be an object.
    END

Verify that all partners can be loaded
    Log to Console  ${\n}---- Verify that all partners can be loaded
    ${partners}=  PartnerFile.Get partners in file
    ${size}=  Get Length  ${partners}
    IF  ${size} < 1
        FAIL  The partners cannot be loaded.
    END
