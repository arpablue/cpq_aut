*** Settings ***
Library  RequestsLibrary
Library  String

Resource  ../../../src/common/libs/GlobalAPI.resource

Variables  ../../../config.yml

*** Variables ***

${url}  https://dfr-co2-dev-webapp.azurewebsites.net
*** Test Cases ***
Requesrt an opportuntity
    Create Session  mySession  ${url}  verify=true
    ${domain}=  Set Variable  ".dfr-co2-dev-webapp.azurewebsites.net"
    ${headers}=  Create Dictionary  Authorization=${token}
    ${encodeToken}=  Set Variable  ${token}

    ${cookies}=  Create Dictionary  name=testCookie  domain=${domain}  JSESSIONID=${SessionID}  Authorization=${encodeToken}  arp_scroll_position=1800
    ${data}=  Create Dictionary  resolveNames=true
    #Log To Console  ${encodeToken}
    ${response}=  GET On Session  mySession  /api/cpq/object/opportunity/08a0001zlpiom5zh  params=${data}  cookies=${cookies}
    Log To Console  ${\n}--------- Response ---------------
    Log to console  ${response.content}