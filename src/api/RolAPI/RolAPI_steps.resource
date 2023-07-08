*** Settings ***
Library    RequestsLibrary
Library    Collections

Resource    ../../../src/common/libs/GlobalAPI.resource
Resource    ../../../src/common/libs/Validations.resource
Resource    ../../../src/api/RolAPI/RolAPI.resource

*** Keywords ***
###
# It prepare the initialise the global variables.
###
Prepare requierements
    GlobalAPI.Step  Prepare requirements
    ${rand}=  GlobalAPI.Generate number
    ${name}=  Set Variable  Jazz_${rand}
    Set Global Variable  ${name}
    ${valueExp}=  Set Variable  Updated Rol for Arcee ${rand}
    Set Global Variable  ${valueExp}
    ${attr}=  Set Variable  description
    Set Global Variable  ${attr}

###
# It creata a new Rol.
# -param name(String): It is the name of the Rol.
# -param description(String): It is the description of the new Rol.
# -return(RolObj): It is the Rol created.
###
Create a new Rol
    [Arguments]  ${name}  ${description}
    GlobalAPI.Step  Create a new Rol
    ${name}=  GlobalAPI.Generate number wiht text  ${name}
    ${description}=  Set Variable  ${Description} ${name}
    ${data}=  Create Dictionary  name=${name}  description=${description}
    ${new}=  RolAPI.Create  ${data}
    [Return]  ${new}
###
# It create an Rol using as a dictionary to create an Rol.
# -param data(Dictionary): It is the parameters used to create the Rol.
# -return(RolObj): It is the Rol created.
###
Create an Rol
    [Arguments]  ${data}
    GlobalAPI.Step  Create an rol
    GlobalAPI.WriteBox  Data for the rol  ${data}
    ${new}=  RolAPI.Create  ${data}
    [Return]  ${new}
    
###
###
# Create a neew Rol with random data and return the data of the Rol created.
# -return(RolObj): Is the data returned of the new Rol.
####
Add a new Rol
    GlobalAPI.Step  Add a new Rol
    ${name}=  GlobalAPI.Generate number wiht text  Optimus
    ${data}=  Create Dictionary  name=${name}  description=Test Rol for ${name}  currencyIsoCode=USD
    ${rol}=  RolAPI.Create  ${data}
    [Return]  ${rol}

###
# It create and verify the creation of a new Rol.
# -return(RolObj): It is the new rol created.
###
Create a random Rol
    GlobalAPI.Step  Create a random Rol
    ${newRol}=  Add a new Rol
    ${newRolID}=  GlobalAPI.Object get attribute  ${newRol}  id
    GlobalAPI.Write  ID of the new Rol: ${newRolId}
    ${rolInfo}=  RolAPI.Get Info  ${newRolID}
    [Return]  ${rolInfo}

###
# It verify that a rol is created
# -param rol(RolObj): It is the Rol to verify the object is the same.
###
Verify if the Rol has been created
    [Arguments]  ${rol}
    GlobalAPI.Step  Verify if the Rol has been created
    ${id}=  GlobalAPI.Object get attribute  ${rol}  id
    ${flag}=  RolAPI.Exists by ID  ${id}
    Validations.Verify it is true  ${flag}  The Rol not exist in the system, when should be created.
    ${rolInf}=  RolAPI.Get Info  ${id}
    ${flag}=  RolAPI.Compare  ${rol}  ${rolInf}
    Validations.Verify it is true  ${flag}  The Rol created is not the same than the system.
    GlobalAPI.Success  The Rol has been created without problem.

###
# It verify that a rol is created
# -param rol(RolObj): It is the Rol to verify the object is the same.
###
Verify the Rol exists
    [Arguments]  ${rol}
    GlobalAPI.Step  Verify the Rol exists
    ${id}=  GlobalAPI.Object get attribute  ${rol}  id
    ${flag}=  RolAPI.Exists by ID  ${id}
    Validations.Verify it is true  ${flag}  The Rol not exist in the system.
    ${rolInf}=  RolAPI.Get Info  ${id}
    ${flag}=  RolAPI.Compare  ${rol}  ${rolInf}
    Validations.Verify it is true  ${flag}  The Rol created is not the same than the system.
    GlobalAPI.Success  The Rol has been created without problem.

###
# It verify that a rol is created
# -param rol(RolObj): It is the Rol to verify the object is the same.
###
Verify the Rol not exist
    [Arguments]  ${rol}
    GlobalAPI.Step  Verify the Rol not exist
    ${id}=  GlobalAPI.Object get attribute  ${rol}  id
    ${flag}=  RolAPI.Exists by ID  ${id}
    Validations.Verify it is False  ${flag}  The Rol exist in the system when should not exists.
    GlobalAPI.Success  The Rol not exist in the system
###
# It modify the Rol with generated the data. This step generate random data to modify the 
# assigned attributed.
# -param rolInfo(RolObj): It is the Rol object to be modified.
# -return(RolObj): It is the Rol object wiht the data modified returned by the requests.
###
Modify an Rol 
    [Arguments]  ${rolInfo}
    GlobalAPI.Step  Modify an Rol
    ${rolID}=  GlobalAPI.Object get attribute  ${rolInfo}  id
    Write  Number generated to use in the new description ${rand}
    ${rolDataEdit}=  Create Dictionary  ${attr}=${valueExp}
    ${rolEdit}=  RolAPI.Modify  ${rolID}  ${rolDataEdit}
    [Return]  ${rolEdit}

###
# It delete an Rol
# -param rolInfo(QuoteObj): It is the Rol to be delete.
###
Delete an Rol
    [Arguments]  ${rolInfo}
    GlobalAPI.Step  Delete an Rol
    ${rolID}=  GlobalAPI.Object get attribute  ${rolInfo}  id
    #### Upate Rol
    ${rolEdit}=  RolAPI.Delete  ${rolID}
    [Return]  ${rolEdit}

###
# It verify that a object has been modified.
# -param rolInfo(RolObj): It is the Rol orignal object.
# -param rolEdit(RolObj): It is the Rol object wilth the modified data.
###
Verify the modifications
    [Arguments]  ${rolInfo}  ${rolEdit}
    GlobalAPI.Step  Verify the quote modifications
    #### Verification object
    ${attrsDif}=  GlobalAPI.Object get differences  ${rolInfo}  ${rolEdit}
    GlobalAPI.WriteBox  Attributes with differences  ${attrsDif}
    GlobalAPI.Object show attributes  ${rolInfo}  ${rolEdit}  ${attrsDif}
    ${flag}=  GlobalAPI.Dictionary key exists  ${attrsDif}  modified_time
    IF  ${flag} == False
        GlobalAPI.WriteBox  Attributes modified   ${attrsDif}
        GlobalAPI.Failed  The [modified_time] attribute not exist in the when should exists.
        Fail  The modified_time it is not present in the attributes modified when should be it.
    END
    ${size}=  Get Length  ${attrsDif}
    Validations.Evaluate to be equals  2  ${size}  The quantity of attributes modified are not 2
