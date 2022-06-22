*** Settings ***
Resource  ../resource.robot
Suite Setup  Suite Setup
Suite Teardown  Suite Teardown
Test Template  Get And Check Response

*** Test Cases ***
Check Search One Table 200  customers        age=lt.21&state=eq.SD          200
Check Search One Table 404  cstomers         age=lt.21&state=eq.SD          404      does not exist
Check Search One Table 400  customers        age=lt.21&state=SD             400      failed to parse filter
Check Search One Table 400  customers        age=lt.gt&state=eq.SD         400      invalid input syntax

*** Keywords ***
Get And Check Response
    [Arguments]     ${table}     ${params}     ${expected result}     ${message}=‘’

    ${response}      Req.GET On Session     alias    /${table}?   params=${params}     expected_status=${expected result}

    run keyword if      ${expected result} != 200
    ...       should contain   ${response.json()}[message]      ${message}