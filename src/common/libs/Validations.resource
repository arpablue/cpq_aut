*** Settings ***
Library    String
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource

*** Keywords *** 
###
# It evaluate if 2 values are equals or not, this evaluation keyword raise the results in 
# the acativity files, if the elements are not equalls then a fail action is raised with a specific message.
# -param expected(any): It is the first element to be evaluated.
# -param current(any): It is the second element to be evaluated.
# -param message(String): It is the message to be displayed as a fail message.
###
Evaluate to be equals
    [Arguments]  ${expected}  ${current}  ${message}
    ${expected}=  Convert to String  ${expected}
    ${current}=  Convert to String  ${current}
    GlobalAPI.Write  Element 1: ${expected}
    GlobalAPI.Write  Element 2: ${current}
    IF  ${expected} != ${current}
        GlobalAPI.Failed  ${message}
        FAIL  ${message}
    END
    GlobalAPI.Success  Both elements are equals.

###
# It evaluate if 2 values are not equals or not, this evaluation keyword raise the results in 
# the acativity files, if the elements are equals then a fail action is raised with a specific message.
# -param expected(any): It is the first element to be evaluated.
# -param current(any): It is the second element to be evaluated.
# -param message(String): It is the message to be displayed as a fail message.
###
Evaluate to not be equals
    [Arguments]  ${expected}  ${current}  ${message}
    ${expected}=  Convert to String  ${expected}
    ${current}=  Convert to String  ${current}
    GlobalAPI.Write  Expected: ${expected}
    GlobalAPI.Write  _Current: ${current}
    IF  ${expected} != ${current}
        GlobalAPI.Failed  ${message}
        FAIL  ${message}
    END
    GlobalAPI.Success  Both elements are equals.

Verify it is false
    [Arguments]  ${current}  ${message}
    ${current}=  Convert to String  ${current}
    IF  True == ${current}
        GlobalAPI.Failed  ${message}
        FAIL  ${message}
    END
    GlobalAPI.Success  The element is FALSE

Verify it is true
    [Arguments]  ${current}  ${message}
    ${current}=  Convert to String  ${current}
    IF  False == ${current}
        GlobalAPI.Failed  ${message}
        FAIL  ${message}
    END
    GlobalAPI.Success  The element is TRUE
