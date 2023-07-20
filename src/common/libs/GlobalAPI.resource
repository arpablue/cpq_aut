*** Settings ***

Library  RequestsLibrary
Library  ../../../src/common/libs/GlobalTools.py
Library  ../../../src/common/libs/DictTools.py
#Library  ../../../src/common/pylib/TestActivityFile.py
Variables  ../../../src/common/libs/variables.yml
# It load the token used for the connection with the API
Variables  ../../../config.yml

*** Variables ***


*** Keywords ***
#################################### SUIT SETTINGS ####################################
###
# It start the variable for the http request environment
###
Start session
    Create Session  TestAPI  ${url}  verify=true
    ${SessionAPI}=  Set Variable    TestAPI
    Set Global Variable  ${SessionAPI}
#################################### TEST SUITS ####################################
Test Start
    ${Log_ACtitivity_Test}=  Set variable  None
    Set Global Variable  ${Log_ACtitivity_Test}

#################################### LOG METHODS ####################################
###
# It dilay a passed message with a speific text.
# -param text(String): It is the message to be di`layed with the pass message.
###
Passed
    [Arguments]  ${text}
    GlobalTools.Passed  ${text}

Success
    [Arguments]  ${text}
    GlobalTools.Success  ${text}

Unsuccess
    [Arguments]  ${text}
    GlobalTools.Unsuccess  ${text}

Warning
    [Arguments]  ${text}
    GlobalTools.Warning  ${text}

Info
    [Arguments]  ${text}
    GlobalTools.Info  ${text}

Step
    [Arguments]  ${text}
    GlobalTools.Step  ${text}

Action
    [Arguments]  ${text}
    GlobalTools.Action  ${text}

Write
    [Arguments]  ${text}
    GlobalTools.Write  ${text}

Mistake
    [Arguments]  ${text}
    GlobalTools.Mistake  ${text}

Error
    [Arguments]  ${text}
    GlobalTools.Error  ${text}

Failed
    [Arguments]  ${text}
    GlobalTools.Failed  ${text}
    #FAIL  ${text}
    
###
# It write a message in the console delimeted buy lines
# -params text: It is the message to be displayed
###
WriteBox
    [Arguments]  ${title}  ${text}
    Write  ================ ${title} ================
    Write  ${text}
    Write  =========================================
############################## eneral methods ######################
###
# It encode a string to URL format.
# -param target(String): It is the string to encode to URL format.
# -return(String): It is the string encoded.
###
URL encode
    [Arguments]  ${target}
    ${res}=  GlobalTools.URL encode  ${target}
    [Return]  ${res}
###
# It decode a url to a comprensible string.
# -param target(String): It is a string in URL format.
# -return(String): It is the uncoded string.
###
URL decode
    [Arguments]  ${target}
    ${res}=  GlobalTools.URL decode  ${target}
    [Return]  ${res}
###
# It retun the type of a variable
###
Type of
    [Arguments]  ${variable}
    ${res}=  GlobalTools.Get type  ${variable}
    ${res}=  Convert To String  ${res}
    [Return]  ${res}
###
# It print in the console the type of a variable
# -params vairable(any): It is the variable that the type will be display in console.
###
Print type of
    [Arguments]  ${variable}
    ${tipe}=  Type of  ${variable}
    Log To Console  ${\n}Type of: ${tipe}
###
# It conter a object in a string, to convert in a dictionary
# -param target(json str) :It is a object or string that contains of the data can be expressed in json format.
# -return (dictionary): It is the dictionary of the object returned
###
Convert to dictionary
    [Arguments]  ${target}
    # Convert the content to string
    ${strTarget}=  Convert to String    ${target}
    # It convert the response body in a dictionary
    ${result}=  Evaluate  json.loads('''${strTarget}''')
    [Return]  ${result}
###
# It verify if a key exits in dictionary,
# -param dict(dictionary): It is the dictionary used to verify if a key exists.
# -param key(String): It is the name of the key to verify if it exists in the dictionary.
# -return(bool): It is true if the key exists.
###
Dictionary key exists
    [Arguments]  ${dict}  ${key}
    Action  The key to search: ${key}
    #${flag}=  Run Keyword And Return Status  Evaluate  ${key} in ${dict}
    ${flag}=  DictTools.Dictionary this key exists  ${dict}  ${key}
    [Return]  ${flag}
###
# It create a dictionaty using two lists.
# -param listA(List): It the lists of keys.
# -param listB(List): It is the list of values for each key of  the list A.
# -return(Dictionary): It is the dictionary created from the lists.
###
Dictionary create from lists
    [Arguments]  ${listA}  ${listB}
    ${dict}=  DictTools.Dictionary Create From Lists  ${listA}  ${listB}
    [Return]  ${dict}
###
# It generate a random numbers of 4 digits.
# -returns (str) : It is aleatory number of 4 digits.
###
Generate number
    ${number}=  Evaluate  random.sample(range(100000, 999999), 1)  random
    ${res}=  Convert To String  ${number[0]}
    Action  Number Generated: ${res}
    [Return]  ${res}
###
# It generate a number and concatenate the number with the text.
# -param text (str): It is the text to concatenate the gnerated number.
# -return (str): It is the string concatenated with a number.
###
Generate number wiht text
    [Arguments]  ${text}
    ${number}=  Generate number
    ${res}=  Set Variable  ${text}_${number}
    Action  Generate number wiht text: ${res}
    [Return]  ${res}
###
# It verify the code status is equals to the pass code
# -param status_code(int): It is the nuber of the status code.
###
#Pass verification code
#    [Arguments]  ${status_code}
#    # Verification of the 
#    ${code}=  Convert To String  ${status_code}
#    Write  Verifiying the PASS code (${code}) with ${status_code}
#    Should be equal  ${code}  ${http_success}

###########################  OBJECTS #######################################
###
# It return the full path of a path in the automation project.
# -param path(String): It is the path inthe project.
# -return(String): It is the full path in the project.
###
Get Path
    [Arguments]  ${path}
    ${res}=  GlobalTools.Get Prj Folder  ${path}
    [Return]  ${res}
###
# It return the value from an object. If the attribute not exist then the method return None.
# -param object(Object): It is the object to get the value of an attribute.
# -param attribute(String): It is the name of the atribute.
# -return(any): It is the value of the attribute.
###
Object get attribute
    [Arguments]  ${object}  ${attribute}
    ${value}=  DictTools.Object Get Attribute  ${object}  ${attribute}
    [Return]  ${value}
###
# It returnt the vaue of attribute from an object. If the attribute not exist then return None.
# -param object(DataObj): It is the object where get the atribute value.
# -param attr(string): It is the name of the attribute.
# -return(any): It is the value of the aattribute.
###
Object attribute exists
    [Arguments]  ${object}  ${attribute}
    ${res}=  DictTools.Object attribute exists  ${object}  ${attribute}
    [Return]  ${res}
###
# It verify is an attribute exists in an object, the attribute is capitalized to verify if the object exists.
# It the attribute not exists then a FAIL exception is raised and stop the execution.
# -param object(DataObj): It is the object where get the atribute value.
# -param attr(string): It is the name of the attribute.
###
Object attribute should exists
    [Arguments]  ${object}  ${attribute}
    ${res}=  DictTools.Object attribute should exists  ${object}  ${attribute}

###
# It compare two Opportunity object and return the list of fields that are differents
# -param objA(Object): It is the first opportunity to be compared.
# -param objB(Object): It is the second opportunity to be compared.
# -return(list): It is the list of attributes that have a different values.
###
Object get differences 
    [Arguments]  ${objA}  ${objB}
    WriteBox  OBJECT A  ${objA}
    WriteBox  OBJECT B  ${objB}
    ${attrs}=  DictTools.Objects get differences  ${objA}  ${objB}
    [Return]  ${attrs}
###
# It display the values of the attributes from two objects. If an attribute not exists the value is None.
# -param objA(Object): It is the first object to display the values of its attributes.
# -param objA(Object): It is the second object to display the values of its attributes.
###
Object show attributes 
    [Arguments]  ${objA}  ${objB}  ${attrs}
    DictTools.Object Diplay Atributes  ${objA}  ${objB}  ${attrs} GlobalAPI
###
# It verify the the response has the correct code and the data of the opbject in attribute. If the status code of the content
# is not correct or the content of the attribute specified is not correct then thjis keyword fail.
# -param response(response): It is the response of the request.
# -param field(String): It is the attribute to search in the response.
###
Verify the data exists for
    [Arguments]  ${response}  ${field}
    # It verify the data of the opportunity exists
    ${content}=  Convert to string   ${response.content}
    Should Not Contain  ${content}  '${field}'
###
# It verify if a string conatains another string.
# -param str(String): It is the string to searach the string.
# -param substr(String): It is the substring to search in the string.
# -return[bool]: It is True if the string contains the substring.
###
String contains string
    [Arguments]  ${str}  ${substr}
    ${res}=  GlobalTools.String contains substr  ${str}  ${substr}
    [Return]  ${res}


################  Http request library  #########################
Verification GET success
    [Arguments]  ${code}
    GlobalTools.Verification Success Get  ${code}

Verification GET NoContent
    [Arguments]  ${code}
    GlobalTools.Verification Success Get NoContent  ${code}


Verification POST Success
    [Arguments]  ${code}
    GlobalTools.Verification Success POST  ${code}

Verification POST Success NoContent
    [Arguments]  ${code}
    GlobalTools.Verification Success POST NoContent  ${code}

Verification PUT Success
    [Arguments]  ${code}
    GlobalTools.Verification Success PUT  ${code}

Verification PUT Success NoContent
    [Arguments]  ${code}
    GlobalTools.Verification Success PUT NoContent  ${code}

Verification DELETE Success
    [Arguments]  ${code}
    GlobalTools.Verification Success DELETE  ${code}

Verification DELETE Success NoContent
    [Arguments]  ${code}
    GlobalTools.Verification Success DELETE NoContent  ${code}

Verification PATCH Success
    [Arguments]  ${code}
    GlobalTools.Verification Success PATCH  ${code}

Verification PATCH Success NoContent
    [Arguments]  ${code}
    GlobalTools.Verification Success PATCH NoContent  ${code}

Verification NoUser
    [Arguments]  ${code}
    GlobalTools.Verification NoUser  ${code}

Verification Unauthorized Access
    [Arguments]  ${code}
    GlobalTools.Verification Unauthorized Access  ${code}

Verification Forbidden
    [Arguments]  ${code}
    GlobalTools.Verification Forbidden  ${code}

Verification Server Error 
    [Arguments]  ${code}
    GlobalTools.Verification Server Error  ${code}
