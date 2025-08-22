*** Settings ***
Library           Process
Resource        ../../resources/variables.robot

*** Test Cases ***
Send SYN flood using hping3
    [Documentation]    Run SYN flood attack to the Call Box Mini and capture the output
    #${output}=         Run Process    bash    -c    "${FLOOD_ATTACK_COMMAND}"    shell=True    stdout=True    stderr=True
    ${output}=         Run Process     echo ${PASSWORD_Testmachine} | sudo -S timeout 6s hping3 -c 100 -d 120 -S -w 64 -p 80 --flood --rand-source ${HOST}    shell=True    stdout=True    stderr=True
    Log                ${output.stdout}
    Log                ${output.stderr}

    # Check for expected output
    # Überprüfung der Ausgabe
    ${found}=          Evaluate    "100% packet loss" in """${output.stdout}""" or "100% unanswered" in """${output.stderr}"""
    Should Be True     ${found}    "Expected 100% packet loss, but some responses were received."