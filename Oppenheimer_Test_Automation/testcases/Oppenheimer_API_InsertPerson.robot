*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    JSONLibrary
Library    DataDriver   ../test_data/create_working_class_hero.xlsx
Resource    ../resources/Common_Keywords.robot
Test Template   create working class hero

Suite Setup    Create Session  Oppenheimer  http://localhost:8080

*** Variables ***
#${base_url}    http://localhost:8080

*** Test Cases ***

create working class hero functional validation    ${run_tag}    ${test_name}    ${test_documentation}    ${birthday}    ${gender}    ${name}    ${natid}    ${salary}    ${tax}    ${expected_resp_code}    ${expected_resp_content}
    #[Documentation]    ${test_documentation}
    [Tags]    YES

*** Keywords ***

create working class hero

    # Parameters retrieved from test data sheet
    [Arguments]    ${run_tag}    ${test_name}    ${test_documentation}    ${birthday}    ${gender}    ${name}    ${natid}    ${salary}    ${tax}    ${expected_resp_code}    ${expected_resp_content}

    IF    '${run_tag}' == 'YES'
        # Get data from test data sheet
        ${data}    Set Variable    {"birthday":"${birthday}","gender":"${gender}","name":"${name}","natid":"${natid}","salary":"${salary}","tax":"${tax}"}

        # Trigger rakeDatabase API and clean up all existing data
        Delete all working class hero

        # Trigger insert API and get response status code/content
        ${actual_resp_status_code}    ${actual_resp_content}    Trigger create working class hero API    ${data}

        # Validate response code
        Status Should Be    ${expected_resp_code}    ${actual_resp_status_code}

        # If Status code is 500 then validate the error message displayed in the reponse content
        IF    '${actual_resp_status_code.status_code}' == '500'

            ${actual_resp_message}=  Get value from JSON    ${actual_resp_status_code.json()}    $..message
            Log    ${actual_resp_message}[0]

            # Validate response content
            Should Be Equal As Strings    ${expected_resp_content}    ${actual_resp_message}[0]
        ELSE
            # Validate response content
            Should Be Equal As Strings    ${expected_resp_content}    ${actual_resp_content}
        END
    ELSE
        Skip    test
    END