*** Keywords ***

Trigger create working class hero API

    # Parameter passed with the keyword executed
    [Arguments]  ${data}
    
    # Header for the API
    ${headers}=    Create Dictionary    Content-Type    application/json
    
    # Trigger insert API
    ${resp_insertPerson}=    POST On Session    Oppenheimer    /calculator/insert    headers=${headers}    data=${data}    expected_status=anything

    # Return the status code and response body 
    [return]  ${resp_insertPerson}    ${resp_insertPerson.content}

Trigger create multiple working class hero API

    # Parameter passed with the keyword executed
    [Arguments]  ${data}

    # Header for the API
    ${headers}=    Create Dictionary    Content-Type    application/json

    # Trigger insert API
    ${resp_multiplePerson}=    POST On Session    Oppenheimer    /calculator/insertMultiple    headers=${headers}    data=${data}    expected_status=anything

    # Return the status code and response body
    [return]  ${resp_multiplePerson}    ${resp_multiplePerson.content}

Get Tax Relief

    # Trigger taxRelief API
    ${resp_taxRelief}=   GET On Session  Oppenheimer  /calculator/taxRelief

    # Return the status code and response body 
    [return]  ${resp_taxRelief}    ${resp_taxRelief.content}

Get Tax Relief Summary

    # Trigger taxRelief API
    ${resp_taxReliefsummary}=   GET On Session  Oppenheimer  /calculator/taxReliefSummary

    # Return the status code and response body
    [return]  ${resp_taxReliefsummary}    ${resp_taxReliefsummary.content}

Delete all working class hero

    # Trigger rakeDatabase API
    ${resp_rakeDatabase}=   POST On Session  Oppenheimer  /calculator/rakeDatabase  expected_status=200

