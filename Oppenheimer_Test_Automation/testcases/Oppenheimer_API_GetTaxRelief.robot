*** Settings ***
Library    RequestsLibrary
Library    JSONLibrary
Library    Collections
Library    String
Library    DataDriver   ../test_data/get_tax_relief.xlsx
Resource    ../resources/Common_Keywords.robot
Library    ../resources/Common_Logic.py
Test Template   create working class hero and get the tax relief

Suite Setup    Create Session  Oppenheimer  http://localhost:8080

*** Variables ***
#${base_url}    http://localhost:8080

*** Test Cases ***

create working class hero and validate tax relief calculation    ${run_tag}    ${test_name}    ${test_documentation}    ${birthday}    ${gender}    ${name}    ${natid}    ${salary}    ${tax}    ${expected_resp_code}    ${expected_resp_content}
    [Tags]    YES

*** Keywords ***

create working class hero and get the tax relief
    [Documentation]    ${test_documentation}
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
        Status Should Be    ${expected_resp_code}  ${actual_resp_status_code}

        # Validate response content
        Should Be Equal As Strings    ${expected_resp_content}    ${actual_resp_content}

        # calculated expected Tax Relief Amount and Nationality for data inserted through common logic
        ${exp_calculated_taxRelief}    calculate Tax Relief    ${salary}  ${tax}  ${gender}  ${birthday}
        ${exp_National_ID}    generate mask nationalid    ${natid}

        # Validate Get API Response for Tax relief
        ${actual_resp_get_status_code}    ${actual_resp_get_content}    Get Tax Relief

        #Get value using the Get Tax Relief API
        ${act_resp_name}=  Get value from JSON    ${actual_resp_get_status_code.json()}    $..name
        ${act_resp_nationalID}=  Get value from JSON    ${actual_resp_get_status_code.json()}    $..natid
        ${act_resp_TaxRelief}=  Get value from JSON    ${actual_resp_get_status_code.json()}    $..relief

        #compare expected and actual Name field
        Should Be Equal As Strings    ${name}    ${act_resp_name}[0]

        #compare expected and actual National ID field
        Should Be Equal As Strings    ${exp_National_ID}    ${act_resp_nationalID}[0]

        #compare expected and actual Tax Relief Amount
        Should Be Equal As Strings    ${exp_calculated_taxRelief}    ${act_resp_TaxRelief}[0]

        # Validate Get API Response for Tax relief Summary
        ${actual_resp_get_status_code}    ${actual_resp_get_content}    Get Tax Relief Summary

        #Get value using the Get Tax Relief Summary API
        ${act_resp_NoOfWorkingClassHeros}=  Get value from JSON    ${actual_resp_get_status_code.json()}    $..totalWorkingClassHeroes
        ${act_resp_totalTaxRelief}=  Get value from JSON    ${actual_resp_get_status_code.json()}    $..totalTaxReliefAmount

        #compare expected and actual no of working heros
        Should Be Equal As Strings    ${act_resp_NoOfWorkingClassHeros}[0]    1    Number Of Working Heros not matched

        #compare expected and actual total tax relief amount
        Should Be Equal As Strings    ${exp_calculated_taxRelief}    ${act_resp_totalTaxRelief}[0]
    ELSE
        Skip    test
    END
