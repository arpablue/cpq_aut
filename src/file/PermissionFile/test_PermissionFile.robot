*** Settings ***
Library  Collections
Resource  ../../../src/file/PermissionFile/PermissionFile.resource

*** Test Cases ***
###
# It verify thast is possible recover the second permission fro
###
Get the second position of the file
    Log to Console  ${\n}---- Get the second position of the file
    ${permission}=  PermissionFile.Get permission in the position  2
    IF  ${permission} == None
        Fail  The returned permission is None, It is not correct when should be an object.
    END

Verify that all permissions can be loaded
    Log to Console  ${\n}---- Verify that all permissions can be loaded
    ${permissions}=  PermissionFile.Get permissions in file
    ${size}=  Get Length  ${permissions}
    IF  ${size} < 1
        FAIL  The permissions cannot be loaded.
    END
