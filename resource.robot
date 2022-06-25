*** Settings ***
Library  RequestsLibrary  WITH NAME  Req
Library  PostgreSQLDB     WITH NAME  DB
Library  JsonValidator    WITH NAME  JS
Library  Collections      WITH NAME  Col

*** Keywords ***
Suite Setup
    Req.Create session           alias  http://localhost:3000
    DB.Connect To Postgresql     app_db   app_user  password  localhost  5432  db1

Suite Teardown
    Req.Delete All Sessions
    DB.Disconnect From Postgresql