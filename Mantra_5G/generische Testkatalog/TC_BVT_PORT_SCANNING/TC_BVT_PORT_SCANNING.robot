*** Settings ***
Library    OperatingSystem
Library    Process
Library    BuiltIn
Library    String
Library    Collections
Resource        ../../resources/variables.robot

*** Test Cases ***
Run Nmap Command, Save Output, and Verify Ports Status
    [Documentation]    Run nmap command, save the output to a file, and verify that only specific ports are open.
    ${result}=    Run Process    bash    -c    ${nmap_COMMAND}    stdout=STRING    stderr=STRING
    Log    ${result.stdout}
    Write Nmap Output to File    ${result.stdout}
    Verify Expected Ports In File

*** Keywords ***
Write Nmap Output to File
    [Arguments]    ${content}
    Log    Saving nmap output to file: ${OUTPUT_FILE}
    Create File    ${OUTPUT_FILE}    ${content}

Verify Expected Ports In File
    [Documentation]    Check if specified ports and services are found in the file and no others are present.
    ${file_content}=   Get File    ${OUTPUT_FILE}
    Log    File content read for verification:\n${file_content}
    ${ports_found}=    Evaluate    [line.split() for line in '''${file_content}'''.splitlines() if "open" in line]
    Log    Found open ports and services:\n${ports_found}

    FOR    ${port}    IN    @{ports_found}
        ${port_line}=    Evaluate    ' '.join(${port})
        Should Contain    ${EXPECTED_PORTS}    ${port_line}
    END

    Log    All expected ports and services are correctly listed.
