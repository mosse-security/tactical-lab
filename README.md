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
- [Burp Suite](https://portswigger.net/burp/)
- [Dirbuster](https://github.com/digination/dirbuster-ng)
- [Social Engineer Toolkit](https://github.com/trustedsec/social-engineer-toolkit)
- [SQL Map](https://github.com/sqlmapproject/sqlmap)
- [THC Hydra](https://github.com/vanhauser-thc/thc-hydra)
### Malware Prototyping
- [DNSteal](https://github.com/m57/dnsteal)
- [Windows Exploit Suggester](https://github.com/GDSSecurity/Windows-Exploit-Suggester)
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

### Host Reconnaissance
- [WMIOps](https://github.com/ChrisTruncer/WMIOps)
- [NetRipper](https://github.com/NytroRST/NetRipper)

### Network Reconnaissance
- [Veil](https://github.com/Veil-Framework/Veil/)
- [Networkenum](https://github.com/maksaraswat/networkenum/)
- [Ostinato](https://github.com/pstavirs/ostinato)
- [AD](https://www.autoitscript.com/forum/files/file/355-ad-active-directory-udf/)
### Privilege Escalation
- [Encyclopaedia Of Windows Privilege Escalation](https://www.insomniasec.com/downloads/publications/WindowsPrivEsc.ppt) - Most common privilege escalation techniques up to 2011.
- [PowerUp](https://github.com/HarmJ0y/PowerUp) - Powershell privilege escalation tool.
- [Potato](https://github.com/foxglovesec/Potato)
### Persistence

### Lateral Movement
- [PAExec](https://github.com/poweradminllc/PAExec)
- [Pivoter](https://github.com/trustedsec/pivoter)

### Mimikatz

- [Mimikatz](https://github.com/gentilkiwi/mimikatz) - Official Mimikatz source code repository.
- [Empire](https://github.com/PowerShellEmpire/Empire)
## Tactical Response

### Event Logs

### DNS Logs

### Web Logs

### System Survey

### Memory Analysis

### Threat Intelligence

- [APT Notes](https://github.com/kbandla/APTnotes) - Various public documents, whitepapers and articles about APT campaigns.
- [APT Notes Extension](https://aptnotes.malwareconfig.com/) - An extension of the work done by @kbandla to collate a repository of public Cyber Security APT Reports.

## Courses

- [The Offensive Techniques](http://www.mosse-security.com/short-courses/the-offensive-techniques-windows-edition.html)
- [Tactical Incident Response](http://www.mosse-security.com/short-courses/tactical-incident-response.html)
- [Applied Reverse Engineering](http://www.mosse-security.com/short-courses/applied-reverse-engineering.html)