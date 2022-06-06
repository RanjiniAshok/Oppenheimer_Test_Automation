*** Settings ***
Documentation  File Upload Download in Robot Framework
Library    SeleniumLibrary
Library    RequestsLibrary
Resource    ../resources/Common_Keywords.robot
Suite Setup    Create Session  Oppenheimer  http://localhost:8080

*** Variables ***
#URL and Browser
${LoginURL}  http://localhost:8080/
${Browser}   Chrome
#Input dataupload file
${testdata_input}  ${CURDIR}/Upload_50Records.csv

#Locators
${btn_uploadfile}  xpath://input[@type='file']
${btn_Refresh}  xpath://button[@type='button'][1]
${btn_cashdispense}  xpath://a[@href='dispense']
${txt_TotaltaxMsg}  xpath://p[contains(text(),'Working Class Hero/s')]
${txt_btnDispense}  xpath://a[text()='Dispense Now']
${txt_dispenseMsg}  xpath://div[contains(text(),'Cash dispensed')]

*** Test Cases ***

Validate upload csv with working class heros
    [Tags]    YES
    Set Screenshot Directory    ${OUTPUTDIR}/Screenshots

    # Trigger rakeDatabase API and clean up all existing data
    Delete all working class hero

    #Navigating to the Browser
    Open Browser   ${LoginURL}    ${Browser}
    Maximize Browser Window
    Capture Page Screenshot
    Sleep    2s

    #Verify CSV Upload through UI
    Choose File    ${btn_uploadfile}    ${testdata_input}

    # Click Refresh Button to verify data displayed in table
    Click Button    ${btn_Refresh}
    Capture Page Screenshot
    Sleep    2s

    #Execute Javascript for scrolling till end of page
    Execute Javascript    window.scrollTo(0, window.scrollY+20000)

    # Verify text message displayed shows the total no of records  inserted
    Element Text Should Be    ${txt_TotaltaxMsg}        £94204404.91 will be dispensed to 50 Working Class Hero/s    Text message not displayed as expected
    Capture Page Screenshot
    Sleep    2s

    #  Click on dispense now button to verify text message displayed in new window
    Click Element    ${txt_btnDispense}
    Element Text Should Be    ${txt_dispenseMsg}    Cash dispensed    Text message not displayed as expected
    Capture Page Screenshot