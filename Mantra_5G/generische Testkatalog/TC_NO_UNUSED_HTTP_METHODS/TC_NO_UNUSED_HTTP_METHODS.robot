*** Settings ***
Library    OperatingSystem
Library    Process
Library    BuiltIn
Library    String
Resource   ../../resources/variables.robot

*** Test Cases ***
Run Nmap Command, Save Output, and Verify Methods from File
    [Documentation]    Run nmap command, save the output to a file, and verify supported HTTP methods.
    ${result}=    Run Process    bash    -c    ${http_command}    stdout=STRING    stderr=STRING
    Log    ${result.stdout}
    Write Nmap Output to File    ${result.stdout}
    ${file_content}=    Get File    ${output_file_http}
    Check Supported HTTP Methods in File    ${file_content}

*** Keywords ***
Write Nmap Output to File
    [Arguments]    ${content}
    Log    Saving nmap output to file: ${output_file_http}
    Create File    ${output_file_http}    ${content}

Check Supported HTTP Methods in File
    [Arguments]    ${file_content}
    Log    Checking supported HTTP methods in file content.
    ${methods}=    Evaluate    re.findall(r'Supported Methods: (.*)', '''${file_content}''')    re
    Log    Found methods: ${methods}
    Should Not Be Empty    ${methods}    Supported HTTP methods not found in file content.
    ${method_list}=    Evaluate    '''${methods[0]}'''.split()
    Log    Methods in list: ${method_list}
    FOR    ${method}    IN    @{method_list}
        Log    Checking method: ${method}
        Should Contain    ${expected_methods}    ${method}    Unsupported method found: ${method}
    END
    Log    All methods are valid: ${method_list}

