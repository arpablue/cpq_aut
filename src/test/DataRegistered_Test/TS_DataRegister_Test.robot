*** Settings ***
Library  ../../../src/common/libs/DataRecorder.py

*** Test Cases ***
Register a data
    DataRecorder.Register in file  recordTest.dat  MyData_001