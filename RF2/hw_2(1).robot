*** Settings ***
Resource  ../resource.robot
Suite Setup  Suite Setup
Suite Teardown  Suite Teardown

*** Variables ***
${SQL_orders}  SELECT orderid, orderdate, totalamount
...            FROM "orders"
...            WHERE totalamount>%(totalamount)s
...            AND orderdate=%(orderdate)s

*** Test Cases ***
Check Order ID By Order Date And Total Amount
    ${orderid}  ${orderdate}  ${totalamount}  Get Order Date And Total Amount From PostRest  arguments=totalamount=gt.300&orderdate=eq.2004-01-01
    @{result}  Get Order Date And Total Amount From DB  totalamount=300  orderdate=2004-01-01
    Compare Order Date And Order ID From PostRest And DB  ${result}  ${orderdate}  ${orderid}
*** Keywords ***
Get Order Date and Total Amount From PostRest
    [Arguments]  ${arguments}

    ${resp}  Req.GET On Session  alias  /orders?  params=${arguments}

    ${orderid}      JS.Get Elements  ${resp.json()}  $..orderid
    ${orderdate}    JS.Get Elements  ${resp.json()}  $..orderdate
    ${totalamount}  JS.Get Elements  ${resp.json()}  $..totalamount

    [Return]  ${orderid}  ${orderdate}  ${totalamount}

Get Order Date and Total Amount From DB
    [Arguments]  &{args}

    ${params}  Create Dictionary  &{args}
    @{result}  DB.Execute Sql String Mapped  ${SQL_orders}  &{params}

    [Return]  @{result}
Compare Order Date and Order ID From PostRest And DB
    [Arguments]  ${results_db}  ${orderdates}  ${orderids}

    ${orderdates_db}           Create List
    ${orderids_db}       Create List

    FOR   ${k}  IN  @{results_db}
        ${k2}                Convert To Number   ${k}[orderid]
        ${k3}                Convert To String   ${k}[orderdate]
        Col.Append To List   ${orderdates_db}    ${k3}
        Col.Append To List   ${orderids_db}      ${k2}
    END

    Col.Lists Should Be Equal   ${orderids}    ${orderids_db}
    Col.Lists Should Be Equal   ${orderdates}      ${orderdates_db}