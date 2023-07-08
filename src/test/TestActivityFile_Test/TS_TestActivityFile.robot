*** Settings ***
Resource  ../../../src/common/libs/GlobalAPI.resource

*** Test Cases ***

Firts Test Case
    GlobalAPI.Write  --- It is the first line
    GlobalAPI.Write  --- It is the second file
