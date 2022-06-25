*** Settings ***
Resource        ../resource.robot
Library         orders.Order             WITH NAME  Order

Suite Setup     Suite Setup
Suite Teardown  Suite Teardown

Test Timeout  0.5s

Metadata  Author   Logvinov Nikita
Metadata  Message  Checking expected identity of results from DB and Rest
...                Ставил минимальные значения для timeout. Не знаю насколько скорость выполнения зависит от железа

*** Test Cases ***
Check Order ID By Order Date And Total Amount
    [Documentation]  Total amount>300  Order date=2004-01-01
    [Timeout]  0.1s
    ${orderids_rest}  ${orderdates_rest}  Get Order Date From PostRest  arguments=totalamount=gt.300&orderdate=eq.2004-01-01
    ${orderids_db}  ${orderdates_db}  Get Order Date And Total Amount From DB  orderdate=2004-01-01  totalamount=300
    Compare Order Date And Order ID From PostRest And DB  ${orderdates_rest}  ${orderids_rest}  ${orderids_db}  ${orderdates_db}

*** Keywords ***
Get Order Date From PostRest
    [Documentation]  Get order_ids and order_dates by Rest
    [Timeout]  0.08
    [Arguments]  ${arguments}

    ${orderid}  ${orderdate}  Order.Get Orders From Rest  alias  ${arguments}  200

    [Return]  ${orderid}  ${orderdate}

Get Order Date and Total Amount From DB
    [Documentation]  Get order_ids and order_dates by DB
    [Arguments]  &{args}
    [Timeout]  0.01

    ${params}  Create Dictionary  &{args}

    ${result}  Order.Get Orders By Date And Total Amount  &{params}  #orderdate=${params}[orderdate]  totalamount=${params}[totalamount]

    ${orderids_db}  ${orderdates_db}  Order.Get Orders And Dates  data=${result}

    [Return]  ${orderids_db}  ${orderdates_db}

Compare Order Date and Order ID From PostRest And DB
    [Documentation]  Compare results from Rest and DB
    [Arguments]  ${orderdates}  ${orderids}  ${orderids_db}  ${orderdates_db}
    [Timeout]  0.005

    Col.Lists Should Be Equal   ${orderids}        ${orderids_db}
    Col.Lists Should Be Equal   ${orderdates}      ${orderdates_db}