*** Settings ***
Resource  ../resource.robot

Suite Teardown  Suite Teardown
Suite Setup     Suite Setup

*** Variables ***
${SQL_insert}  BEGIN WORK; INSERT INTO categories VALUES (%(category)s, %(categoryname)s); COMMIT WORK; SELECT * FROM "categories";
${SQL_select}  SELECT * FROM "categories";

*** Test Cases ***
Check Insert Into DB
    @{result_insert}  Insert Category To DB.Categories  category=17  categoryname=Smthng
    @{result_select}  Get All From DB.Category by DB
    ${categories}     Get All From DB.Category By PostRest
    Compare DB After Inserting  ${result_select}  ${result_insert}
*** Keywords ***
Insert Category to DB.Categories
    [Arguments]  &{args}

    ${params}  Create Dictionary  &{args}
    @{result}  DB.Execute Sql String Mapped  ${SQL_insert}  &{params}

    [Return]  @{result}

Get All From DB.Category by DB
    @{result}  DB.Execute Sql String Mapped  ${SQL_select}
    [Return]  @{result}

Get All From DB.Category by PostRest
    ${resp}  Req.GET On Session  alias  /categories?

    ${category}  JS.Get Elements  ${resp.json()}  $..category

    [Return]  ${category}


Compare DB After Inserting
    [Arguments]  ${results_select}  ${results_insert}

    Col.Lists Should Be Equal   ${results_select}    ${results_insert}
