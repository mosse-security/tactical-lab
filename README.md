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

- [Phishing Frenzy](https://github.com/pentestgeek/phishing-frenzy)
- [PhEmail](https://github.com/Dionach/PhEmail)
- [Windows Exploit Suggester](https://github.com/GDSSecurity/Windows-Exploit-Suggester)
- [Social Engineer Toolkit](https://github.com/trustedsec/social-engineer-toolkit)
- [SQL Map](https://github.com/sqlmapproject/sqlmap)
- [THC Hydra](https://github.com/vanhauser-thc/thc-hydra)

### Malware Prototyping

- [Ettercap](https://github.com/Ettercap/ettercap)
- [File Joiner](https://code.google.com/archive/p/advanced-file-joiner/)
- [Perl Dictionary Attack](https://code.google.com/archive/p/perl-https-dictionary-attack/)
- [Firecat](https://github.com/BishopFox/firecat)
- [Empire](https://github.com/PowerShellEmpire/Empire)
- [Veil Evasion](https://github.com/Veil-Framework/Veil-Evasion)
- [Gcat](https://github.com/byt3bl33d3r/gcat)

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

- [NetRipper](https://github.com/NytroRST/NetRipper)
- [File Server Triage](http://www.harmj0y.net/blog/redteaming/file-server-triage-on-red-team-engagements/)

### Network Reconnaissance

- [PowerTools](https://github.com/PowerShellEmpire/PowerTools)
- [Networkenum](https://github.com/maksaraswat/networkenum/)
- [DNS Reconnaissance with NMAP](https://isc.sans.edu/forums/diary/DNS+Reconnaissance+using+nmap/20349/)
- [Nessus for Host Discovery](https://www.tenable.com/blog/using-nessus-for-host-discovery)
- [NMAP Network Scanning](https://nmap.org/book/man-performance.html)

### Privilege Escalation

- [Encyclopaedia Of Windows Privilege Escalation](https://www.insomniasec.com/downloads/publications/WindowsPrivEsc.ppt) - Most common privilege escalation techniques up to 2011.
- [PowerUp](https://github.com/HarmJ0y/PowerUp) - Powershell privilege escalation tool.
- [Potato](https://github.com/foxglovesec/Potato)
- [Group Policy Hijacking](https://labs.mwrinfosecurity.com/blog/2015/04/02/how-to-own-any-windows-network-with-group-policy-hijacking-attacks/)

### Persistence

- [Many Ways of Malware Persistence](http://jumpespjump.blogspot.com.au/2015/05/many-ways-of-malware-persistence-that.html)
- [Stealthy Malware Persistence](https://isc.sans.edu/forums/diary/Wipe+the+drive+Stealthy+Malware+Persistence+Mechanism+Part+1/15394/)
- [Triggers as a Windows Persistence Mechanism](http://trustedsignal.blogspot.com/2014/02/triggers-as-windows-persistence.html)
- [Persistence Wiki](https://attack.mitre.org/wiki/Persistence)

### Lateral Movement

- [Veil Catapult](https://github.com/Veil-Framework/Veil-Catapult)
- [WMIOps](https://github.com/ChrisTruncer/WMIOps)
- [PAExec](https://github.com/poweradminllc/PAExec)
- [Pivoter](https://github.com/trustedsec/pivoter)
- [VPN Pivoting](http://blog.cobaltstrike.com/2014/10/14/how-vpn-pivoting-works-with-source-code/)

### Mimikatz

- [Mimikatz](https://github.com/gentilkiwi/mimikatz) - Official Mimikatz source code repository.
- [Dumping Passwords](http://carnal0wnage.attackresearch.com/2013/10/dumping-domains-worth-of-passwords-with.html)
- [Mimikatz Unofficial Guide](https://adsecurity.org/?page_id=1821)
- [Golden Ticket Walkthrough](http://www.beneaththewaves.net/Projects/Mimikatz_20_-_Golden_Ticket_Walkthrough.html)
- [Pass the Hash](http://blog.cobaltstrike.com/2015/05/21/how-to-pass-the-hash-with-mimikatz/)

### Exfiltration

- [DNSteal](https://github.com/m57/dnsteal)

### Miscellaneous

- [Ostinato](https://github.com/pstavirs/ostinato)

## Tactical Response

### Event Logs

### DNS Logs

### Web Logs

- [Log Analysis Guide](http://resources.infosecinstitute.com/log-analysis-web-attacks-beginners-guide/)
- [Apache Scalp](https://code.google.com/archive/p/apache-scalp/)

### System Survey

### Memory Analysis

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