*** Settings ***
Library    SSHLibrary
Library    Process
Library    OperatingSystem
Resource        ../../resources/variables.robot

*** Test Cases ***
    # Check proxy ARP status
Check Proxy Status
    Open Connection    ${HOST}
    Login              ${USERNAME}    ${PASSWORD}
    ${PROXY_STATUS}=   Execute Command  ${PROXY_STATUS_COMMAND}
    Log                ${PROXY_STATUS}
    Should Be Equal As Numbers    ${PROXY_STATUS}    0    # Expecting 0 for disabled


Run ARPING Command and Evaluate Output
    [Documentation]    Führt das ARPING-Kommando direkt mit dem festgelegten Interface von testmachine aus und überprüft die Ausgabe.

    ${output}=         Run Process     echo ${PASSWORD_Testmachine} | sudo -S arping -c 10 -U -I ${INTERFACE_Testmachine} ${HOST}    shell=True    stdout=True    stderr=True
    Log                ${output.stdout}
    Log                ${output.stderr}

    # Überprüfung der Ausgabe
    ${found}=          Evaluate    "100% unanswered" in """${output.stdout}""" or "100% unanswered" in """${output.stderr}"""
    Should Be True     ${found}    "Expected 100% unanswered packets, but some responses were received."


