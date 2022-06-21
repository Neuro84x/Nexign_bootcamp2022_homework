*** Settings ***
Resource  ../resource.robot
Suite Setup     Suite Setup
Suite Teardown  Suite Teardown

*** Variables ***
${SQL}              SELECT zip, lastname
...                 FROM public.customers
...                 WHERE state=%(state)s
...                 AND age<%(age)s
*** Test Cases ***
Check Horizontal Filtering

    ${lastname}  ${zip}  Get Last Name And Zip From PostRest    arguments=age=lt.21&state=eq.SD
    @{result}           Get Last Name And Zip From DB          age=21  state=SD
    Compare Results  ${result}  ${lastname}  ${zip}

*** Keywords ***
Get Last Name And Zip From PostRest
    [Arguments]  ${arguments}
    ${resp}  Req.GET On Session  alias  /customers?  params=${arguments}

    ${lastname}  JS.Get Elements  ${resp.json()}  $..lastname
    ${zip}  JS.Get Elements  ${resp.json()}  $..zip

    [Return]  ${lastname}  ${zip}

Get Last Name And Zip From DB
    [Arguments]  &{args}

    ${params}  Create Dictionary  &{args}
    @{result}  DB.Execute Sql String Mapped  ${SQL}  &{params}

    [Return]  @{result}

Compare Results
    [Arguments]  ${result_from_db}  ${lastnames}  ${zips}

    ${lastnames_db}  Create List
    ${zips_db}       Create List

    FOR   ${k}  IN  @{result_from_db}
        ${k2}                convert to number   ${k}[zip]
        Col.Append To List   ${lastnames_db}      ${k}[lastname]
        Col.Append To List   ${zips_db}           ${k2}
    END

    Col.Lists Should Be Equal   ${lastnames}    ${lastnames_db}
    Col.Lists Should Be Equal   ${zips}      ${zips_db}


