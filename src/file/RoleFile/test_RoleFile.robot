*** Settings ***
Library  Collections
Resource  ../../../src/file/RoleFile/RoleFile.resource

*** Test Cases ***
###
# It verify thast is possible recover the second role fro
###
Get the second position of the file
    Log to Console  ${\n}---- Get the second position of the file
    ${role}=  RoleFile.Get role in the position  2
    IF  ${role} == None
        Fail  The returned role is None, IT is bnot correct when should be an object.
    END

Verify that all roles can be loaded
    Log to Console  ${\n}---- Verify that all roles can be loaded
    ${roles}=  RoleFile.Get roles in file
    ${size}=  Get Length  ${roles}
    IF  ${size} < 1
        FAIL  The roles cannot be loaded.
    END
