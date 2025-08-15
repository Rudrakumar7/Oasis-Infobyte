________________________________________
Common Network Security Threats: DoS/DDoS, Man-in-the-Middle (MITM), and Spoofing
Author: Rudra kumar
Date: August 10, 2025
Environment: Kali Linux (research/writing), GitHub for deliverables
________________________________________
Executive Summary
Organizations face three broad, high-impact network attack classes:
•	DoS/DDoS overwhelm services at the network/transport (L3/L4) or application layer (L7), causing outages and financial loss.
•	MITM silently intercepts and/or alters traffic between parties, often via local-network tricks (ARP/DNS spoofing), rogue Wi-Fi, or TLS interception/misconfiguration.
•	Spoofing underpins many other attacks by forging identities at different layers (IP, ARP, DNS) to bypass trust boundaries.
This report explains how each attack works, notable real-world incidents, and concrete mitigations you can implement today.
________________________________________
1) Denial of Service (DoS) & Distributed DoS (DDoS)
How it works
DoS/DDoS aim to exhaust bandwidth, CPU, memory, sockets, or application resources.
Common vectors:
•	L3/L4: SYN/UDP floods; reflection & amplification (e.g., DNS/NTP).
•	L7 (HTTP/HTTPS): Application request floods and protocol abuses—recently, HTTP/2 “Rapid Reset” (CVE-2023-44487) enabled record-breaking request-rate floods by rapidly opening and resetting streams in bulk. (CISA, The Cloudflare Blog)
Real-world cases
•	HTTP/2 Rapid Reset (Aug–Oct 2023): Public clouds reported unprecedented L7 attacks; Google observed ~398 million requests/second, Cloudflare ~201M rps, AWS ~155M rps. (Google Cloud, The Cloudflare Blog, Qualys)
•	Vendor guidance and mitigations were issued (protocol & server-side hardening). (Microsoft Security Response Center)
Impact
•	Service outages, SLA penalties, revenue loss, reputational harm; smaller organizations suffer most when attacks hit the application edge where per-request costs are highest. (See vendor post-mortems and advisories around Rapid Reset.) (The Cloudflare Blog, WIRED)
Mitigations
•	Upstream absorption & scrubbing: Always-on CDN/WAF with automatic anomaly detection; rate-limit and challenge suspicious clients. (The Cloudflare Blog)
•	Protocol hardening & patching: Apply fixes for CVE-2023-44487 and vendor recommendations (e.g., stream-concurrency limits, cancellation handling). (Microsoft Security Response Center)
•	Architectural resilience: Anycast distribution, horizontal auto-scaling, circuit breakers/shed load for non-critical endpoints. (Discussed in cloud/vendor analyses of Rapid Reset.) (Google Cloud)
•	Reduce amplifiers: Disable/refuse open reflectors; tighten server timeouts; prefer connection reuse limits under stress. (The Cloudflare Blog)
________________________________________
2) Man-in-the-Middle (MITM)
How it works
An attacker wedges between two endpoints to eavesdrop, inject, or modify traffic without detection. Frequent techniques:
•	Local-LAN MITM: ARP spoofing/poisoning corrupts IP-to-MAC mappings so traffic routes via the attacker. Dynamic ARP Inspection (DAI) on switches can validate ARP against known IP/MAC bindings and drop forged packets. (Cisco, Cisco Meraki Documentation)
•	DNS spoofing: Redirect clients to attacker-controlled hosts by poisoning a resolver’s cache (see §3).
•	Wi-Fi MITM: “Evil twin” APs, captive portals, or weak WLAN configs.
•	TLS interception/downgrade: Installing a rogue root CA or exploiting deprecated protocols lets attackers proxy HTTPS.
Real-world cases
•	Lenovo “Superfish” (2014–2015): Consumer laptops shipped with adware that installed a compromised root CA, enabling silent HTTPS interception—classic TLS MITM risk. (CISA)
Impact
•	Credential/session theft, data tampering and fraud, compliance violations (PII/PCI).
Mitigations
•	TLS done right: Enforce TLS 1.2/1.3, disable SSLv3/TLS 1.0/1.1, use strong ciphers; enable HSTS to prevent HTTP downgrade; consider pinning for high-risk apps. (OWASP Cheat Sheet Series)
•	LAN controls: Enable DAI and DHCP snooping; segment with VLANs; prefer SSH over Telnet; MFA and short session lifetimes. (Cisco, Cisco Meraki Documentation)
•	Endpoint/browser hygiene: Remove untrusted root CAs; keep OS/browsers updated (Superfish-style incidents show the risk). (CISA)
•	Untrusted networks: WPA2-Enterprise/WPA3; require VPN on public Wi-Fi. (General best practices reflected across OWASP/TLS guidance.) (OWASP Cheat Sheet Series)
________________________________________
3) Spoofing (IP, ARP, DNS)
How it works
“Spoofing” = forging identity at different layers:
•	IP spoofing: Faking source IP addresses (used in reflection/amplification DDoS).
•	ARP spoofing: Maps attacker’s MAC to a victim’s IP to intercept traffic on a LAN (enabler for MITM). DAI prevents forged ARP frames on capable switches. (Cisco)
•	DNS cache poisoning: Inserts false DNS records into recursive resolvers, silently redirecting users.
Real-world case: Kaminsky DNS cache poisoning (2008)
The “Kaminsky bug” exploited insufficient randomness in DNS transaction IDs/source ports to poison caches across multiple implementations; remediation included source-port randomization and accelerated push toward DNSSEC. (CERT Coordination Center, CVE)
Mitigations
•	For IP spoofing: Ingress/egress filtering (BCP-38/84) on ISP/enterprise edges; remove reflection vectors.
•	For ARP spoofing: DAI + DHCP snooping; static ARP for crown-jewel hosts; strict L2 segmentation. (Cisco)
•	For DNS poisoning: Patch resolvers, enable DNSSEC validation to cryptographically detect tampered data; monitor resolver behavior. (ICANN, NIST Publications)
________________________________________
Cross-Cutting Detection & Monitoring
•	Edge telemetry: Per-path rate, error codes, handshake failures; correlate spikes with CDN/WAF logs to identify L7 floods (esp. HTTP/2 anomalies). (The Cloudflare Blog)
•	Network controls: Switch logs for DAI/DHCP-snooping violations; ARP anomaly alerts. (Cisco Meraki Documentation)
•	DNS security: Validate resolvers (DNSSEC on), alert on sudden NS/TTL changes or upstream shifts (Kaminsky-style patterns). (ICANN)
•	Endpoint posture: Inventory & audit root CAs; detect SSL inspection/malware indicators (Superfish-like). (CISA)
________________________________________
Practical Hardening Checklist
•	Patch/protect HTTP/2 stacks (CVE-2023-44487), apply vendor mitigations; enforce sensible stream concurrency and cancellation handling. (Microsoft Security Response Center)
•	CDN/WAF & rate-limits enabled; scripted “brownout”/shed load paths for L7 spikes. (The Cloudflare Blog)
•	TLS 1.2/1.3 only, strong ciphers; HSTS on public sites; evaluate pinning for key clients. (OWASP Cheat Sheet Series)
•	Switch security: Turn on DAI, DHCP snooping, port security; segment high-value assets. (Cisco)
•	DNS hygiene: Keep resolvers patched; DNSSEC validation; randomize source ports/transaction IDs. (NIST Publications, ICANN)
•	User security on Wi-Fi: Enforce WPA2-Enterprise/WPA3; VPN on untrusted networks. (OWASP Cheat Sheet Series)
•	Certificate trust: Monitor/remove rogue CAs; avoid TLS interception unless strictly controlled and pinned. (CISA)
________________________________________
References (selected)
•	HTTP/2 Rapid Reset (CVE-2023-44487): Google Cloud incident/analysis; Cloudflare technical breakdown and zero-day disclosure; Microsoft MSRC guidance; CISA alert. (Google Cloud, The Cloudflare Blog, Microsoft Security Response Center, CISA)
•	Superfish MITM risk: CISA advisory; Lenovo advisories/reporting; contemporaneous coverage. (CISA, WIRED)
•	ARP spoofing defenses: Cisco/Meraki docs on Dynamic ARP Inspection. (Cisco, Cisco Meraki Documentation)
•	DNS cache poisoning & DNSSEC: CERT VU#800113; NIST SP 800-81r2; ICANN DNSSEC overview; MITRE CVE-2008-1447. (CERT Coordination Center, NIST Publications, ICANN, CVE)
________________________________________

