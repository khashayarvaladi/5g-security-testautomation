# 5g-security-testautomation
# 5G Security Test Automation System

## 📌 Overview
This repository contains an **automated test system for 5G security test cases** based on **3GPP standards**.  
The system is developed with **Robot Framework** and can be used to validate **generic 5G security features** as well as **specific test cases for 5G Network Functions (AMF, SMF, etc.)**.



---

## 🎥 Demo Video
Watch the demo of the 5G Security Test Automation System here:  

[![Watch the video](https://img.youtube.com/vi/PIVQZYvvRKA/0.jpg)](https://youtu.be/PIVQZYvvRKA)

---

## ⚙️ Features
- ✅ Automated execution of 5G security test cases  
- ✅ Based on **3GPP specifications (TS 33.117, TS 33.512, TS 33.515, …)**  
- ✅ Test coverage for:
  - Generic 5G security requirements  
  - AMF & SMF specific security tests  
- ✅ Robot Framework integration with custom keywords  
- ✅ Packet capture and analysis with `tshark`  

---

## 🛠️ Installation

### Requirements
- Python 3.10+
- [Robot Framework](https://robotframework.org/)
- Tshark (Wireshark CLI)
- Open5GS (for 5G Core)  
- UERANSIM (for gNB & UE simulation)  
- Amarisoft Callbox Mini (for generic test cases, optional)  

### Setup
Clone this repository:
```bash
git clone https://github.com/khashayarvaladi/5g-security-testautomation.git
cd 5g-security-testautomation



pip install -r requirements.txt

📖 References

3GPP TS 33.117 – Catalogue of General Security Assurance Requirements

3GPP TS 33.512 – Security Assurance Specification for the AMF

3GPP TS 33.515 – Security Assurance Specification for the SMF


👤 Author

Khashayar Valadi
Master’s Thesis Project – Hochschule Merseburg
Exceeding Solutions GmbH – 5G MANTRA Project

