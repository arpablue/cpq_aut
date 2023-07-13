*** Settings ***
Library  RequestsLibrary
Library  String

Resource  ../../../src/common/libs/GlobalAPI.resource

Variables  ../../../config.yml

*** Variables ***

${url}  https://dfr-co2-dev-webapp.azurewebsites.net
${jsonID}  FD978B0651B4DBDC691107726A04CC87
*** Test Cases ***
Requesrt an opportuntity
    Create Session  mySession  ${url}  verify=true
    ${domain}=  Set Variable  ".dfr-co2-dev-webapp.azurewebsites.net"
    ${headers}=  Create Dictionary  Authorization=${token}
    #${encodeToken}=  GlobalAPI.URL encode  ${token}
    ${encodeToken}=  Set Variable  ${token}

    ${cookies}=  Create Dictionary  name=testCookie  domain=${domain}  JSESSIONID=${jsonID}  Authorization=${encodeToken}  arp_scroll_position=1800
    ${data}=  Create Dictionary  resolveNames=true
    #Log To Console  ${encodeToken}
    #${response}=  GET On Session  mySession  /api/cpq/object/opportunity/08a0001zlpiom5zh  params=${data}  headers=${headers}  cookies=${cookies}
    #${response}=  GET On Session  mySession  /api/cpq/object/opportunity/08a0001zlpiom5zh  params=${data}  headers=${headers}
    ${response}=  GET On Session  mySession  /api/cpq/object/opportunity/08a0001zlpiom5zh  params=${data}  cookies=${cookies}
    Log To Console  ${\n}--------- Response ---------------
    Log to console  ${response.content}