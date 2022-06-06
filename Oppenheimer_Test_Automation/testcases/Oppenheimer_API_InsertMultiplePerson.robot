*** Settings ***
Library    Collections
Library    RequestsLibrary
Library    JSONLibrary
Library    DataDriver   ../test_data/create_working_class_hero_multiple.xlsx
Resource    ../resources/Common_Keywords.robot
Test Template   create multiple working class hero

Suite Setup    Create Session  Oppenheimer  http://localhost:8080

*** Variables ***
#${base_url}    http://localhost:8080

*** Test Cases ***

create more than one working class hero functional validation    ${run_tag}    ${test_name}    ${test_documentation}    ${request_payload}    ${expected_resp_code}    ${expected_resp_content}
    [Tags]    YES

*** Keywords ***

create multiple working class hero

    # Parameters retrieved from test data sheet
    [Arguments]    ${run_tag}    ${test_name}    ${test_documentation}    ${request_payload}    ${expected_resp_code}    ${expected_resp_content}

    IF    '${run_tag}' == 'YES'
        # Get data from test data sheet
        ${data}    Set Variable    ${request_payload}

        # Trigger rakeDatabase API and clean up all existing data
        Delete all working class hero

        # Trigger insert API and get response status code/content
        ${actual_resp_status_code}    ${actual_resp_content}    Trigger create multiple working class hero API    ${data}

        # Validate response code
        Status Should Be    ${expected_resp_code}  ${actual_resp_status_code}

        # If Status code is 500 then validate the error message displayed in the reponse content
        IF    '${actual_resp_status_code.status_code}' == '500'

            ${actual_resp_message}=  Get value from JSON    ${actual_resp_status_code.json()}    $..message

            # Validate response content
            Should Be Equal As Strings    ${expected_resp_content}    ${actual_resp_message}[0]
        ELSE
            # Validate response content
            Should Be Equal As Strings    ${expected_resp_content}    ${actual_resp_content}

            # Validate if data is added for successful cases
            ${actual_resp_get_status_code}    ${actual_resp_get_content}    Get Tax Relief Summary

            #Get field value from Get Tax Relief Summary API
            ${GET_resp_NoOfWorkingClassHeros}=  Get value from JSON    ${actual_resp_get_status_code.json()}    $..totalWorkingClassHeroes
            ${GET_resp_totalTaxRelief}=  Get value from JSON    ${actual_resp_get_status_code.json()}    $..totalTaxReliefAmount

            #Verify total number of working heros is displayed as expected
            Should Be Equal As Strings    ${GET_resp_NoOfWorkingClassHeros}[0]    2    Number Of Working Heros not matched
        END
    ELSE
        Skip    test
    END