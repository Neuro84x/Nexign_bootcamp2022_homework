*** Settings ***
Library  Collections  WITH NAME  Col

*** Variables ***
@{LIST}     ${1}  ${-2}  ${1}  ${0}  ${500}  ${-1}  ${10}  ${-2}  ${0}
@{UNIQUE_LIST}
@{CELSIUS}  ${0}  ${350}  ${-32}  ${100}
@{FAHRENHEIT}  ${32}  ${662}  ${-25.6}  ${212}

*** Test Cases ***
Min and Max Values In List
    ${min}      Set Variable        ${LIST}[0]
    ${max}      Set Variable        ${LIST}[0]

    FOR  ${k}  IN  @{LIST}
        IF  ${k}>${max}
            ${max}  Set Variable  ${k}
        END
        IF  ${k}<${min}
            ${min}  Set Variable  ${k}
        END
    END
    Log     Min = ${min}
    Log     Max = ${max}

Show Unique Values In List
    FOR  ${k}  IN  @{LIST}
        TRY
            Should Contain X Times  ${LIST}  ${k}  1
            Col.Append To List  ${UNIQUE_LIST}  ${k}
        EXCEPT
            No Operation
        END
    END
    Should Not Be Empty  ${UNIQUE_LIST}
    Log Many  ${UNIQUE_LIST}

Sum Of List Values
    ${sum}  Set Variable  ${0}
    FOR  ${k}  IN  @{LIST}
        ${sum}  Set Variable  ${${sum}+${k}}
    END
    Log  Sum of list values: ${sum}

Celsius To Fahrenheit Is Correct
    [Documentation]  Сравнивает исходные данные {FAHRENHEIT} и вычисленные значения
    @{fahr}=  Create List
    FOR  ${k}  IN  @{CELSIUS}
        ${converted}  Convert Celsius To Fahrenheit  ${k}
        Col.Append To List  ${fahr}  ${converted}
    END
    Lists Should Be Equal  ${FAHRENHEIT}  ${fahr}
    Log  Сalculations are correct

*** Keywords ***
Convert Celsius To Fahrenheit
    [Arguments]  ${celsius}
    ${fahr}  Set Variable  ${9/5*${celsius}+32}
    [Return]  ${fahr}