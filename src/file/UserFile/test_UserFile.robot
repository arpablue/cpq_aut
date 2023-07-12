*** Settings ***
Library  Collections
Resource  ../../../src/file/UserFile/UserFile.resource

*** Test Cases ***
###
# IT verify thast is possible recover the second user fro
###
Get the second position of the file
    Log to Console  ${\n}---- Get the second position of the file
    ${user}=  UserFile.Get user in the position  2
    IF  ${user} == None
        Fail  The returned user is None, IT is bnot correct when should be an object.
    END

Verify that all users can be loaded
    Log to Console  ${\n}---- Verify that all users can be loaded
    ${users}=  UserFile.Get users in file
    ${size}=  Get Length  ${users}
    IF  ${size} < 1
        FAIL  The users cannot be loaded.
    END
