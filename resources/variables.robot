*** Variables ***
#Allgemein für Testcases
${HOST}                 10.57.0.1        # Replace with your target IP address
${USERNAME}             root       # Replace with your SSH username
${PASSWORD}             toor       # Replace with your SSH password
${PORT}                 22
${PASSWORD_Testmachine}           toor  #password von testmachine(wegen sudo command es braucht password)
${INTERFACE_Testmachine}          enp2s0f1   # Interface von testmachine(ubuntu)


#TC_BROADCAST_ICMP_HANDLING
${PING_COMMAND}        ping -c 5 10.57.0.1
${check_icmp-echo}      cat /proc/sys/net/ipv4/icmp_echo_ignore_broadcasts
${ICMP_COMMAND}  sudo hping3 --icmp-ts -c 1 10.57.0.255


#TC_BVT_PORT_SCANNING
${nmap_COMMAND}        nmap 10.57.0.1
${OUTPUT_FILE}    /home/exceeding/Mantra_5G/generische Testkatalog/TC_BVT_PORT_SCANNING/PORTS_STATUS.txt
${EXPECTED_PORTS}     22/tcp open ssh   80/tcp open http   443/tcp open https   9000/tcp open cslistener   9001/tcp open tor-orport   9003/tcp open unknown

#TC_BVT_VULNERABILITY


#TC_IP_FORWARD_DISABLING
${IPFORWARD_STATUS_COMMAND}     cat /proc/sys/net/ipv4/ip_forward
${ARPING_COMMAND}           arping -c 10 -U -I eno1 10.57.0.1


#TC_NO_UNUSED_HTTP_METHODS
${http_command}    nmap -p 443 --script http-methods 10.57.0.1
${output_file_http}    /home/exceeding/Mantra_5G/generische Testkatalog/TC_NO_UNUSED_HTTP_METHODS/STRING.txt
${expected_methods}    GET    HEAD    POST


#TC_PROXY_ARP_DISABLING
${PROXY_STATUS_COMMAND}     cat /proc/sys/net/ipv4/conf/all/proxy_arp
${arping}         arping -c 10 -U -I eno1 10.57.0.1
#${icmpping}       ping -c 100 192.168.1.255


#TC_RESTRICTED_REACHIBILITY_OF_SERVICES
${INTERFACE_1}             10.57.0.1
${INTERFACE_2}             192.168.122.1
${EXPECTED_PORTS_NUMBER}          22,80,443,9000,9001,9003
${ALLOWED_INTERFACE_FILE}   generische\ Testkatalog/TC_RESTRICTED_REACHIBILITY_OF_SERVICES/interface_10_57_0_1.txt
${RESTRICTED_INTERFACE_FILE}   generische\ Testkatalog/TC_RESTRICTED_REACHIBILITY_OF_SERVICES/interface_192_168_122_1.txt

#TC_SYN_FOOD_PREVENTATION



#TC_UNIQUE_SYSTEM_ACCOUNT_IDENTIFICATION


#AMF & SMF Testcases Variable
#TC_NAS_INT_SELECTION_USE_AMF
#TC_UP_POLICY_PRECEDENCE_SMF

${GNB_COMMAND}        gnome-terminal -- bash -c "cd /home/exceeding/ueransim/UERANSIM/config && ../build/nr-gnb -c gnb1.yaml; exec bash"
${UE_COMMAND}         gnome-terminal -- bash -c "cd /home/exceeding/ueransim/UERANSIM/config && ../build/nr-ue -c ue1.yaml; exec bash"
${PCAP_PATH}          /home/exceeding/PCAP/nr_rrc_capture.pcap
${JSON_PATH}          /home/exceeding/PCAP/nr_rrc.json
${TSHARK_COMMAND}     gnome-terminal -- bash -c "tshark -i lo -f 'sctp and host 127.0.0.5 and port 38412' -w ${PCAP_PATH}; exec bash"
${TSHARK_COMMAND1}    gnome-terminal -- bash -c "tshark -r ${PCAP_PATH} -T json > ${JSON_PATH}; exec bash"
${STOP_GNB_CMD}       pkill -f nr-gnb
${STOP_UE_CMD}        pkill -f nr-ue
${STOP_TSHARK_CMD}    pkill tshark




