# Tactical Lab

> A curated list of tools, papers and techniques for Windows exploitation and incident response.

Created by [Mosse Security](https://github.com/mosse-security "Mossé Security").

## Table of Contents

- [Tactical Exploitation](#tactical-exploitation)
	- [Getting In](#getting-in)
	- [Malware Prototyping](#malware-prototyping)
	- [Host Reconnaissance](#host-reconnaissance)
	- [Network Reconnaissance](#network-reconnaissance)
	- [Privilege Escalation](#privilege-escalation)
	- [Persistence](#persistence)
	- [Lateral Movement](#lateral-movement)
	- [Mimikatz](#mimikatz)
	- [Exfiltration](#exfiltration)

- [Tactical Response](#tactical-response)
	- [Event Logs](#event-logs)
	- [DNS Logs](#dns-logs)
	- [Web Logs](#web-logs)
	- [System Survey](#system-survey)
	- [Memory Analysis](#memory-analysis)
	- [Threat Intelligence](#threat-intelligence)
- [Courses](#courses)

## Tactical Exploitation

### Getting In

- [Social Engineering Toolkit Guide](https://www.linuxvoice.com/issues/011/set.pdf)
- [Social Engineering Techniques pt.1](http://resources.infosecinstitute.com/phishing-and-social-engineering-techniques/)
- [Social Engineering Techniques pt.2](http://resources.infosecinstitute.com/phishing-and-social-engineering-techniques-2-0/)
- [Social Engineering Techniques pt.3](http://resources.infosecinstitute.com/phishing-and-social-engineering-techniques-3-0/)
- [Ettercap](https://github.com/Ettercap/ettercap) - Suite of Man-In-The-Middle attacks
- [SPF SpeedPhishing Framework](https://github.com/tatanus/SPF) - Python tool for quick phishing exercises
- [SeeS](https://github.com/galkan/sees/) - Phishing email domain spoofer
- [Generate-Macro](https://github.com/enigma0x3/Generate-Macro) - Malicious Microsoft Office doc generator
- [Origama](https://code.google.com/archive/p/origami-pdf/) - Malicious PDF generator
- [Mana](https://github.com/sensepost/mana) - Rogue AP and MitM toolkit
- [Man in the Middle Framework](https://github.com/byt3bl33d3r/MITMf) - Framework for Man-In-The-Middle attacks
- [Gitrob](https://github.com/michenriksen/gitrob) - GitHub organizations reconnaissance tool, hunts for sensitive data
- [Weevely3](https://github.com/epinna/weevely3) - Web shell
- [QuasiBot](https://github.com/Smaash/quasibot) - Web shell manager
- [Phishing Frenzy](https://github.com/pentestgeek/phishing-frenzy) - Ruby on Rails Phishing Framework
- [PhEmail](https://github.com/Dionach/PhEmail) - Python email phishing automator
- [Windows Exploit Suggester](https://github.com/GDSSecurity/Windows-Exploit-Suggester) - Compares a targets patch levels to detect missing patches
- [Social Engineer Toolkit](https://github.com/trustedsec/social-engineer-toolkit) - Social engineering framework with multiple attack vectors
- [SQL Map](https://github.com/sqlmapproject/sqlmap) - Automatic SQL injection tool
- [NoSQL Map](https://github.com/tcstool/NoSQLMap) - Automatic NoSQL database auditor and exploiter
- [THC Hydra](https://github.com/vanhauser-thc/thc-hydra) - Login bruteforcer

### Malware Prototyping

- [Throwback](https://github.com/silentbreaksec/Throwback) - HTTP/S beaconing implant
- [ThrowbackLP](https://github.com/silentbreaksec/ThrowbackLP) - Listening post for Throwback HTTP/S beaconing implant
- [The Backdoor Factory](https://github.com/secretsquirrel/the-backdoor-factory) - Patch binaries with shellcode without affecting binary execution
- [Dragon](https://github.com/Shellntel/backdoors) - Listens on a magic port, can be used to download binaries from source IP connecting to the port
- [File Joiner](https://code.google.com/archive/p/advanced-file-joiner/) - Merges two files into one
- [Perl Dictionary Attack](https://code.google.com/archive/p/perl-https-dictionary-attack/) - SSL protected login bruteforcer
- [Firecat](https://github.com/BishopFox/firecat) - Tool to create reverse TCP tunnels
- [Empire](https://github.com/PowerShellEmpire/Empire) - PowerShell post-exploitation agent
- [Veil Evasion](https://github.com/Veil-Framework/Veil-Evasion) - Payload generator with a focus on AV evasion
- [Gcat](https://github.com/byt3bl33d3r/gcat) - Backdoor that uses Gmail for C&C

Autoit Resources:
- [Windows Firewall](https://www.autoitscript.com/forum/topic/145158-windows-firewall-udf/)
	- Enable or Disable the Windows Firewall
	- Add or Remove Authorized Applications to the Exclusions list
	- Add or Delete Ports from the Exclusions list.
	- Enable or Disable the use of Exceptions
	- Enable or Disable Notifications of blocked applications
	- Enable or Disable Existing Ports
	- List all Applications in the Exclusions List
	- List all Ports in the Exclusions List
	- List Properties of the current Firewall Configuration
	- Restore the Windows Firewall to its default configuration
- [ZIP](https://www.autoitscript.com/forum/topic/73425-zipau3-udf-in-pure-autoit/)
	- Create Zip File
	- Add file to Zip Archive
	- Add folder to Zip Archive
	- Add folder's content to Zip Archive
	- Extract all files from Zip Archive
	- Extract file from Zip Archive
	- Count items in zip
	- Count All items in the Zip Archive Including SubDirectories
	- List items in zip
	- Search a File in the Zip Archive
	- Search in each File of the Zip Archive

- [AD](https://www.autoitscript.com/forum/files/file/355-ad-active-directory-udf/)

### Host Reconnaissance

- [Netview](https://github.com/mubix/netview) - Enumeration tool for shares,sessions,users and more
- [Pass Hunt](https://github.com/Dionach/PassHunt) - Search drives for documents containing passwords
- [Enum Shares](https://github.com/dejanlevaja/enum_shares) - Enumerates shared folders
- [NetRipper](https://github.com/NytroRST/NetRipper) - Network traffic sniffer
- [File Server Triage](http://www.harmj0y.net/blog/redteaming/file-server-triage-on-red-team-engagements/) - Information regarding file server data pilfering

### Network Reconnaissance

- [Lanmap2](https://github.com/rflynn/lanmap2) - Builds database and visualizations of LAN structure from passively sifted information
- [IVRE](https://github.com/cea-sec/ivre) - Network reconnaissance framework
- [Flashlight](https://github.com/galkan/flashlight) - Automated network information gathering tool
- [Find DNS](https://packetstormsecurity.com/files/132449/Find-DNS-Scanner.html) - DNS server enumerator
- [PowerTools](https://github.com/PowerShellEmpire/PowerTools) - Collection of PowerShell projects with a focus on offensive operations
- [Networkenum](https://github.com/maksaraswat/networkenum/) - Network enumerator that uses the Scapy framework
- [DNS Reconnaissance with NMAP](https://isc.sans.edu/forums/diary/DNS+Reconnaissance+using+nmap/20349/) - Using NMAP to gather DNS information
- [Nessus for Host Discovery](https://www.tenable.com/blog/using-nessus-for-host-discovery) - Using Nessus for low impact host enumeration
- [NMAP Network Scanning](https://nmap.org/book/man-performance.html) - Modifying NMAP's timings

### Privilege Escalation

- [PhpSploit](https://github.com/nil0x42/phpsploit) - Stealth post-exploitation framework with a focus on privilege escalation
- [Encyclopaedia Of Windows Privilege Escalation](https://www.insomniasec.com/downloads/publications/WindowsPrivEsc.ppt) - Most common privilege escalation techniques up to 2011.
- [PowerUp](https://github.com/HarmJ0y/PowerUp) - Powershell privilege escalation tool.
- [Potato](https://github.com/foxglovesec/Potato) - Privilege escalation through NTLM relay and NBNS spoofing
- [Group Policy Hijacking](https://labs.mwrinfosecurity.com/blog/2015/04/02/how-to-own-any-windows-network-with-group-policy-hijacking-attacks/) - Group policy hijacking example and description

### Persistence

- [Many Ways of Malware Persistence](http://jumpespjump.blogspot.com.au/2015/05/many-ways-of-malware-persistence-that.html) 
- [Stealthy Malware Persistence](https://isc.sans.edu/forums/diary/Wipe+the+drive+Stealthy+Malware+Persistence+Mechanism+Part+1/15394/)
- [Triggers as a Windows Persistence Mechanism](http://trustedsignal.blogspot.com/2014/02/triggers-as-windows-persistence.html)
- [Persistence Wiki](https://attack.mitre.org/wiki/Persistence)

### Lateral Movement

- [Veil Catapult](https://github.com/Veil-Framework/Veil-Catapult) - Payload delivery tool
- [WMIOps](https://github.com/ChrisTruncer/WMIOps) - Using WMI for a variety of local and remote functions
- [PAExec](https://github.com/poweradminllc/PAExec) - Remote execution tool
- [Pivoter](https://github.com/trustedsec/pivoter) - Proxy tool to assist with lateral movement
- [VPN Pivoting](http://blog.cobaltstrike.com/2014/10/14/how-vpn-pivoting-works-with-source-code/)

### Mimikatz

- [Mimikatz](https://github.com/gentilkiwi/mimikatz) - Official Mimikatz source code repository.
- [Dumping Passwords](http://carnal0wnage.attackresearch.com/2013/10/dumping-domains-worth-of-passwords-with.html)
- [Mimikatz Unofficial Guide](https://adsecurity.org/?page_id=1821)
- [Golden Ticket Walkthrough](http://www.beneaththewaves.net/Projects/Mimikatz_20_-_Golden_Ticket_Walkthrough.html)
- [Pass the Hash](http://blog.cobaltstrike.com/2015/05/21/how-to-pass-the-hash-with-mimikatz/)

### Exfiltration

- [Dnscat2](https://github.com/iagox86/dnscat2) - DNS tunnel with encryption and a focus on C&C
- [Tunna](https://github.com/SECFORCE/Tunna) - Tunnels TCP communication over HTTP
- [ICMPTX](https://github.com/jakkarth/icmptx) - Tunnels IP over ICMP
- [DNSteal](https://github.com/m57/dnsteal) - Tunnels data over DNS

### Miscellaneous

- [The Harvester](https://github.com/laramies/theHarvester) - Information gathering tool utilizing public sources to gain information on a company/organization
- [Intersect](https://github.com/deadbits/Intersect-2.5) - Post-Exploitation framework
- [Nishang](https://github.com/samratashok/nishang) - Framework which enables the usage of PowerShell for red teaming
- [Zarp](https://github.com/hatRiot/zarp) - Network attack tool
- [Pupy](https://github.com/n1nj4sec/pupy) - RAT, uses reflective dll injection on windows platforms
- [Vulnerability Research](https://github.com/praveendhac/VulnerabilityResearch) - Collection of scripts, fuzzers, exploits and more
- [P0wned Shell](https://github.com/Cn33liz/p0wnedShell) - Post-exploitation powershell toolkit
- [DBD Durandal's Backdoor](https://github.com/gitdurandal/dbd) - Portable Netcat clone with various features
- [CrackMapExec](https://github.com/byt3bl33d3r/CrackMapExec) - Variety of pentesting functions for Windows/Active Directory environments
- [Ostinato](https://github.com/pstavirs/ostinato) - Packet/Traffic generator and analyzer

## Tactical Response

### Event Logs

- [EVTXtract](https://github.com/williballenthin/EVTXtract) - Tool to recover and reconstruct fragments of EVTX log files from raw binary data, including unallocated space
- [Process Forest](https://github.com/williballenthin/process-forest) - Tool to reconstruct the historical process heirarchies from event logs

### DNS Logs

### Web Logs

- [Web Server Log Analysis](http://forensicmethods.com/webshell-log-analysis)
- [Log Analysis Guide](http://resources.infosecinstitute.com/log-analysis-web-attacks-beginners-guide/)
- [Apache Scalp](https://code.google.com/archive/p/apache-scalp/)

### System Survey

### Memory Analysis

- [Introduction to Windows Memory Analysis](https://www.youtube.com/watch?v=SjDH_vTuefM)
- [Volatility](https://github.com/volatilityfoundation/volatility)

### Threat Intelligence

- [APT Notes](https://github.com/kbandla/APTnotes) - Various public documents, whitepapers and articles about APT campaigns.
- [APT Notes Extension](https://aptnotes.malwareconfig.com/) - An extension of the work done by @kbandla to collate a repository of public Cyber Security APT Reports.
- [Threat Intelligence Reports](https://www.fireeye.com/current-threats/threat-intelligence-reports.html)
- [Malware Domains](http://www.malwaredomains.com/)
- [Recorded Future](https://www.recordedfuture.com/)
- [Threat Intelligence Review](http://threatintelligencereview.com/)	
- [Binary Defense](http://www.binarydefense.com/banlist.txt)
- [Malcode Malware Domains](http://malc0de.com/bl/)
- [Palevo Tracker](https://palevotracker.abuse.ch/blocklists.php)
- [Zeus Tracker](https://zeustracker.abuse.ch/blocklist.php)
- [SSL Blacklist](https://sslbl.abuse.ch/)
- [Emerging Threats Rulesets](http://rules.emergingthreats.net/)

## Courses

- [The Offensive Techniques](http://www.mosse-security.com/short-courses/the-offensive-techniques-windows-edition.html)
- [Tactical Incident Response](http://www.mosse-security.com/short-courses/tactical-incident-response.html)
- [Applied Reverse Engineering](http://www.mosse-security.com/short-courses/applied-reverse-engineering.html)