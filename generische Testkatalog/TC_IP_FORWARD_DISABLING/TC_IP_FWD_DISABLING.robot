*** Settings ***
Library    SSHLibrary
Library    Process
Library    OperatingSystem
Resource        ../../resources/variables.robot

*** Test Cases ***
Check IP_Forward Status via SSH
    [Documentation]    Überprüfen Sie den Proxy-ARP-Status über SSH.
    Open Connection    ${HOST}
    Login              ${USERNAME}    ${PASSWORD}
    ${IPFORWARD_STATUS}=   Execute Command  ${IPFORWARD_STATUS_COMMAND}
    Log                ${IPFORWARD_STATUS}
    Should Be Equal As Numbers    ${IPFORWARD_STATUS}    0    # Erwarten 0 für deaktiviert
    Close Connection

Run ARPING Command and Evaluate Output
    [Documentation]    Führt das ARPING-Kommando direkt mit dem festgelegten Interface von testmachine aus und überprüft die Ausgabe.

    ${output}=         Run Process     echo ${PASSWORD_Testmachine} | sudo -S arping -c 10 -U -I ${INTERFACE_Testmachine} ${HOST}    shell=True    stdout=True    stderr=True
    Log                ${output.stdout}
    Log                ${output.stderr}

    # Überprüfung der Ausgabe
    ${found}=          Evaluate    "100% unanswered" in """${output.stdout}""" or "100% unanswered" in """${output.stderr}"""
    Should Be True     ${found}    "Expected 100% unanswered packets, but some responses were received."

