class PortValidationLibrary:
    EXPECTED_PORTS = ["22/tcp", "80/tcp", "443/tcp", "9000/tcp", "9001/tcp", "9003/tcp"]

    def __init__(self, allowed_file, restricted_file):
        self.allowed_file = allowed_file
        self.restricted_file = restricted_file

    def load_ports(self, filename):
        """Loads the content of the specified file."""
        with open(filename, 'r') as file:
            return file.read()

    def validate_ports(self):
        """Validates that expected ports are only in the allowed interface file and not in the restricted one."""
        # Load nmap scan results from each file
        allowed_content = self.load_ports(self.allowed_file)
        restricted_content = self.load_ports(self.restricted_file)

        # Check each expected port
        for port in self.EXPECTED_PORTS:
            if port in restricted_content and port in allowed_content:
                # Fail if the port is found in both interfaces
                return f"FAIL: Port {port} is open on both interfaces ({self.allowed_file} and {self.restricted_file})"
            elif port in restricted_content:
                # Fail if the port is found only in the restricted interface
                return f"FAIL: Port {port} found in restricted interface ({self.restricted_file})"
            elif port not in allowed_content:
                # Warn if the port is missing from the allowed interface
                print(f"WARNING: Port {port} missing from allowed interface ({self.allowed_file})")

        # If all checks pass
        return "PASS: All ports restricted as expected."
