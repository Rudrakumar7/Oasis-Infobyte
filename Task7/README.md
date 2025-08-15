
 Vulnerability Scanning with Nikto
 1. Introduction
Nikto is an open-source web server scanner that checks for known vulnerabilities, outdated software, misconfigurations, and potentially dangerous files.  
It is a fast and efficient way to identify common weaknesses in a web server.
2. Objective
The objective of this task is to perform a vulnerability scan on a target web server using **Nikto**, analyze the results, and document potential issues along with their recommended fixes.
## 3. Tools Required
- **Nikto** (available in Kali Linux or installable on Linux systems)
- A target web server such as **DVWA** running locally or a test server you have permission to scan.
⚠️ **Legal Notice**: Only scan systems that you own or have explicit permission to test.
## 4. Installation
Nikto is usually pre-installed in Kali Linux.  
If not installed, run:
```bash
sudo apt update
sudo apt install nikto -y
________________________________________
5. Steps to Perform the Scan
Step 1: Verify Nikto Installation
nikto -Help
Step 2: Run a Scan
For DVWA running locally:
nikto -h http://127.0.0.1/dvwa
For an authorized remote target:
nikto -h http://testphp.vulnweb.com
Step 3: Save Scan Results
nikto -h http://127.0.0.1/dvwa -o nikto_scan_results.txt
________________________________________
6. Sample Output (nikto_scan_results.txt)
- Nikto v2.5.0
---------------------------------------------------------------------------
+ Target IP:          127.0.0.1
+ Target Hostname:    localhost
+ Target Port:        80
+ Start Time:         2025-08-15 15:20:41
---------------------------------------------------------------------------
+ Server: Apache/2.4.57 (Debian)
+ The anti-clickjacking X-Frame-Options header is not present.
+ The X-XSS-Protection header is not defined.
+ Allowed HTTP Methods: GET, HEAD, POST, OPTIONS
+ OSVDB-3233: /icons/: Directory indexing found.
+ OSVDB-3092: /server-status: This reveals sensitive information about the server.
---------------------------------------------------------------------------
+ Scan completed at 2025-08-15 15:21:12 (31 seconds).
________________________________________
7. Analysis of Findings
Finding	Risk	Recommendation
Missing X-Frame-Options	Possible clickjacking	Add X-Frame-Options: SAMEORIGIN header.
Missing X-XSS-Protection	Possible XSS attack	Add X-XSS-Protection: 1; mode=block.
Directory indexing enabled	Unauthorized file listing	Disable directory listing in Apache config.
/server-status accessible	Information disclosure	Restrict access using .htaccess or firewall rules.
________________________________________
8. Conclusion
Nikto is a great starting point for vulnerability assessment.
While it does not exploit vulnerabilities, it identifies weaknesses that should be addressed to improve web server security.
________________________________________


