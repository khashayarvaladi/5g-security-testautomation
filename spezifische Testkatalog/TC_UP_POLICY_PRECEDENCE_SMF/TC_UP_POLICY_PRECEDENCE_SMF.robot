*** Settings ***
Library         Process
Library         OperatingSystem
Resource        ../../resources/variables.robot

*** Test Cases ***
Execute Commands, Capture Packets, and Convert to JSON
    [Documentation]    Run tshark, gNB, and UE commands in separate terminals, capture packets, stop processes, and convert to JSON.

    # Start tshark in a new terminal for packet capture
    ${tshark_output}=    Run Process    ${TSHARK_COMMAND}    shell=True
    Log                  Tshark started
    Sleep                5s  # Allow tshark to initialize

    # Start gNB in a new terminal
    ${gnb_output}=       Run Process    ${GNB_COMMAND}    shell=True
    Log                  gNB started
    Sleep                5s  # Delay before starting UE

    # Start UE in a new terminal
    ${ue_output}=        Run Process    ${UE_COMMAND}    shell=True
    Log                  UE started
    Sleep                10s    # Allow UE to run for 10 seconds

    # Stop UE after 10 seconds
    Stop UE Process
    Sleep                2s    # Short delay to ensure UE has fully stopped

    # Stop gNB after UE has stopped
    Stop GNB Process
    Sleep                2s    # Short delay to ensure gNB has fully stopped

    # Stop tshark after stopping gNB and UE
    Stop Tshark Process

    # Convert captured pcap to JSON if the file is not empty
    Check And Convert Pcap

    # Delay to ensure JSON file is fully written
    Sleep                5s

    # Run the Python script to validate JSON content
    Run Python Script


*** Keywords ***
Stop UE Process
    [Documentation]    Stop the UE process
    ${ue_stop}=         Run Process    ${STOP_UE_CMD}    shell=True
    Log                 UE stopped

Stop GNB Process
    [Documentation]    Stop the gNB process
    ${gnb_stop}=        Run Process    ${STOP_GNB_CMD}    shell=True
    Log                 gNB stopped

Stop Tshark Process
    [Documentation]    Stop the tshark process
    ${tshark_stop}=     Run Process    ${STOP_TSHARK_CMD}    shell=True
    Log                 Tshark stopped

Check And Convert Pcap
    [Documentation]    Convert the captured pcap file to JSON if it is not empty
    ${file_size}=       Get File Size    ${PCAP_PATH}
    Run Keyword If      ${file_size} > 0    Convert Pcap to Json
    Run Keyword If      ${file_size} == 0    Log    PCAP file is empty, skipping JSON conversion

Convert Pcap to Json
    [Documentation]    Convert the captured pcap file to a JSON file in a new terminal
    ${convert_output}=  Run Process    ${TSHARK_COMMAND1}    shell=True
    Log                 Pcap converted to JSON: ${convert_output}

*** Variables ***
${PYTHON_SCRIPT_PATH}   /home/exceeding/Mantra_5G/spezifische Testkatalog/TC_UP_POLICY_PRECEDENCE_SMF/Json.py

*** Keywords ***
Run Python Script
    [Documentation]    Run Python script to validate JSON content
    ${result}=    Run Process    python3    ${PYTHON_SCRIPT_PATH}    stdout=stdout.txt    stderr=stderr.txt
    ${output}=    Get File    stdout.txt
    ${error}=     Get File    stderr.txt
    Log           Output: ${output}
    Log           Errors: ${error}

    # Check if the process executed successfully
    Should Be Equal As Integers    ${result.rc}    0    The Python script did not execute successfully.

    # Validate the output against expected data
    Validate Status    ${output}

Validate Status
    [Arguments]    ${output}
    ${expected_messages}=    Create List
    ...                      ngap.integrityProtectionIndication: 0
    ...                      ngap.confidentialityProtectionIndication: 0
    ...                      ngap.maximumIntegrityProtectedDataRate_UL: 1

    FOR    ${message}    IN    @{expected_messages}
        Should Contain    ${output}    ${message}    ${message} not found in the output.
    END
    Log    All expected status messages found in the output.


