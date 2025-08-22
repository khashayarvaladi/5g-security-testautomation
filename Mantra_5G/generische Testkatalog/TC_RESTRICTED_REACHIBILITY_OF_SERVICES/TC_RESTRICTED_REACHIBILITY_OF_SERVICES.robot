*** Settings ***
Library    Process
Library    PortValidationLibrary.py    ${ALLOWED_INTERFACE_FILE}    ${RESTRICTED_INTERFACE_FILE}
Resource    ../../resources/variables.robot

*** Variables ***
${INTERFACE_1}             10.57.0.1
${INTERFACE_2}             192.168.122.1
${EXPECTED_PORTS_NUMBER}          22,80,443,9000,9001,9003
${ALLOWED_INTERFACE_FILE}   generische\ Testkatalog/TC_RESTRICTED_REACHIBILITY_OF_SERVICES/interface_10_57_0_1.txt
${RESTRICTED_INTERFACE_FILE}   generische\ Testkatalog/TC_RESTRICTED_REACHIBILITY_OF_SERVICES/interface_192_168_122_1.txt


*** Test Cases ***
Run Nmap Scans and Validate Port Reachability
    [Documentation]    Runs nmap scans on two interfaces, saves the output, and validates port reachability.
    Run Nmap And Save Results    ${INTERFACE_1}    ${ALLOWED_INTERFACE_FILE}
    Run Nmap And Save Results    ${INTERFACE_2}    ${RESTRICTED_INTERFACE_FILE}
    ${result}=    Validate Ports
    Log    ${result}
    Should Contain    ${result}    PASS    Ports are correctly restricted

*** Keywords ***
Run Nmap And Save Results
    [Arguments]    ${interface_ip}    ${output_file}
    ${command}=    Set Variable    echo ${PASSWORD_Testmachine} | sudo -S -p "" nmap -sT -p ${EXPECTED_PORTS_NUMBER} ${interface_ip}
    Run Process    ${command}    shell=True    stdout=${output_file}    stderr=stderr

