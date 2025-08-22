*** Settings ***
Library  SSHLibrary
Resource    ../../resources/variables.robot


*** Test Cases ***
Verify TOE Configuration
    Open Connection  ${HOST}  port=${PORT}
    Login  ${USERNAME}  ${PASSWORD}
    ${passwd_content}  Execute Command  cat /etc/passwd
    Log Many  ${passwd_content}  # Display the contents of /etc/passwd for verification

    # Extract the line for the root user
    ${root_line}  Evaluate  [line for line in '''${passwd_content}'''.splitlines() if line.startswith("root:")][0]

    # Extract UID and GID for the root user
    ${uid}  Evaluate  '''${root_line}'''.split(':')[2]
    ${gid}  Evaluate  '''${root_line}'''.split(':')[3]

    # Verify that both UID and GID are 0
    Should Be Equal As Numbers  ${uid}  0
    Should Be Equal As Numbers  ${gid}  0

    # Add more steps for additional verification or interaction with TOE

    Close All Connections
