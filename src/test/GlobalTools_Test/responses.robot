*** Settings ***
Library  RequestsLibrary
Library  Collections


*** Variables ***
${url}  https://reqres.in/
${endpoint}  /api/users


*** Test Cases ***
Headers validation
    Create session  sesion  ${url}
    ${response}=  GET On Session  sesion  ${endpoint}/2
    # Äccessing the headers - Display the headers
    Log to console  ${response.headers}
    # Accesing a value in the headers
    ${application}=  Get from dictionary  ${response.headers}  Content-Type



