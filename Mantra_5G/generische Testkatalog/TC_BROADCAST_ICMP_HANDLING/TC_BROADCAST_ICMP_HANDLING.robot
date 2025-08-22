*** Settings ***
Library    OperatingSystem
Library    Collections
Library    SSHLibrary
Library    Process
Library    os
Resource        ../../resources/variables.robot

*** Test Cases ***
List ICMP ECHO Message
    [Documentation]  ICMP ECHO
    [Tags]  pingtest
    Open Connection    ${HOST}    port=${PORT}
    Login    ${USERNAME}    ${PASSWORD}
    ${icmp_configuration}=  Execute Command  ${check_icmp-echo}
    Log     ${icmp_configuration}
    Should Be Equal As Numbers    ${icmp_configuration}    1    # Expecting 0 for disabled

Ping

    [Documentation]    Führt das PING-Kommando direkt mit dem festgelegten Interface von testmachine aus und überprüft die Ausgabe.

    ${ping_output}=         Run Process     ping -c 5 10.57.0.255   shell=True    stdout=True    stderr=True
    Log                ${ping_output.stdout}
    Log                ${ping_output.stderr}

    # Überprüfung der Ausgabe
    ${found}=          Evaluate    "100% packet loss" in """${ping_output.stdout}""" or "100% packet unanswered" in """${ping_output.stderr}"""
    Should Be True     ${found}    "Expected 100% packet loss, but some responses were received."

Run ICMP Timestamp
    [Documentation]    Führt das ICMP Timestamp-Kommando direkt mit dem festgelegten Interface von testmachine aus und überprüft die Ausgabe.

    ${ICMP_output}=    Run Process     echo ${PASSWORD_Testmachine} | sudo -S hping3 --icmp-ts -c 10 10.57.0.255    shell=True    stdout=True    stderr=True
    Log                ${ICMP_output.stdout}
    Log                ${ICMP_output.stderr}

    # Überprüfung der Ausgabe
    ${found}=          Evaluate    "100% packet loss" in """${ICMP_output.stdout}""" or "100% unanswered" in """${ICMP_output.stderr}"""
    Should Be True     ${found}    "Expected 100% packet loss, but some responses were received."





