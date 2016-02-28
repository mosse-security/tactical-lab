# Tactical Lab

> A curated list of tools, papers and techniques for Windows exploitation and incident response.

Created by [Mosse Security](https://github.com/mosse-security "Mossé Security").

## Table of Contents

- [Tactical Exploitation](#tactical-exploitation)
	- [Getting In](#getting-in)
	- [Web Backdoors](#web-backdoors)
	- [Malware Prototyping](#malware-prototyping)
	- [Host Reconnaissance](#host-reconnaissance)
	- [Network Reconnaissance](#network-reconnaissance)
	- [Privilege Escalation](#privilege-escalation)
	- [Persistence](#persistence)
	- [Lateral Movement](#lateral-movement)
	- [Mimikatz](#mimikatz)
	- [Exfiltration](#exfiltration)
	- [Miscellaneous](#miscellaneous)

- [Tactical Response](#tactical-response)
	- [Event Logs](#event-logs)
	- [DNS Logs](#dns-logs)
	- [Web Logs](#web-logs)
	- [System Survey](#system-survey)
	- [Memory Analysis](#memory-analysis)
	- [Threat Intelligence](#threat-intelligence)
- [Tactical Defence](#tactical-defence)
	- [Mimikatz Defence](#mimikatz-defence)
- [Courses](#courses)

## Tactical Exploitation

### Getting In

- [The Harvester](https://github.com/laramies/theHarvester) - Information gathering tool utilizing public sources to gain information on a company/organization
- [The Art of Human Hacking](https://sin.thecthulhu.com/library/security/social_engineering/The_Art_of_Human_Hacking.pdf)
- [Social Engineering Toolkit Guide](https://www.linuxvoice.com/issues/011/set.pdf)
- [Ettercap](https://github.com/Ettercap/ettercap) - Suite of Man-In-The-Middle attacks
- [Ettercap Tutorial](http://www.thegeekstuff.com/2012/05/ettercap-tutorial/)
- [SPF SpeedPhishing Framework](https://github.com/tatanus/SPF) - Python tool for quick phishing exercises
- [SeeS](https://github.com/galkan/sees/) - Phishing email domain spoofer
- [Generate-Macro](https://github.com/enigma0x3/Generate-Macro) - Malicious Microsoft Office doc generator
- [Gitrob](https://github.com/michenriksen/gitrob) - GitHub organizations reconnaissance tool, hunts for sensitive data
- [Weevely3](https://github.com/epinna/weevely3) - Web shell
- [QuasiBot](https://github.com/Smaash/quasibot) - Web shell manager
- [Phishing Frenzy](https://github.com/pentestgeek/phishing-frenzy) - Ruby on Rails Phishing Framework
- [PhEmail](https://github.com/Dionach/PhEmail) - Python email phishing automator
- [Social Engineer Toolkit](https://github.com/trustedsec/social-engineer-toolkit) - Social engineering framework with multiple attack vectors
- [Beginning with the Social Engineering Toolkit](http://www.social-engineer.org/framework/se-tools/computer-based/social-engineer-toolkit-set/)
- [THC Hydra](https://github.com/vanhauser-thc/thc-hydra) - Login bruteforcer

### Web Backdoors

- [PhpSploit](https://github.com/nil0x42/phpsploit) - Stealth post-exploitation framework with a focus on privilege escalation

### Malware Prototyping

- [DBD Durandal's Backdoor](https://github.com/gitdurandal/dbd) - Portable Netcat clone with various features
- [Pupy](https://github.com/n1nj4sec/pupy) - RAT, uses reflective dll injection on windows platforms
- [The Backdoor Factory](https://github.com/secretsquirrel/the-backdoor-factory) - Patch binaries with shellcode without affecting binary execution
- [Dragon](https://github.com/Shellntel/backdoors) - Listens on a magic port, can be used to download binaries from source IP connecting to the port
- [File Joiner](https://code.google.com/archive/p/advanced-file-joiner/) - Merges two files into one
- [Empire](https://github.com/PowerShellEmpire/Empire) - PowerShell post-exploitation agent
- [Veil Evasion](https://github.com/Veil-Framework/Veil-Evasion) - Payload generator with a focus on AV evasion
- [Gcat](https://github.com/byt3bl33d3r/gcat) - Backdoor that uses Gmail for C&C
- [PowerBreach](https://github.com/PowerShellEmpire/PowerTools/tree/master/PowerBreach)
= [PowerPick](https://github.com/PowerShellEmpire/PowerTools/tree/master/PowerPick)

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

- [Scanning and Enumeration](http://booksite.elsevier.com/samplechapters/9781597496278/Chapter_3.pdf)
- [Hunting for Sensitive Data with Veil](https://www.veil-framework.com/hunting-sensitive-data-veil-framework/)
- [Post Exploitation Redux](http://www.counterhack.net/talks/Post%20Exploitation%20Redux%20-%20Skoudis&StrandSMALL.pdf)
- [Lanmap2](https://github.com/rflynn/lanmap2) - Builds database and visualizations of LAN structure from passively sifted information
- [IVRE](https://github.com/cea-sec/ivre) - Network reconnaissance framework
- [Networkenum](https://github.com/maksaraswat/networkenum/) - Network enumerator that uses the Scapy framework
- [NMAP Network Scanning](https://nmap.org/book/man-performance.html) - Modifying NMAP's timings
- [PowerView](https://github.com/PowerShellEmpire/PowerTools/tree/master/PowerView)

### Privilege Escalation

- [All Roads Lead to System](https://labs.mwrinfosecurity.com/system/assets/760/original/Windows_Services_-_All_roads_lead_to_SYSTEM.pdf)
- [Encyclopaedia Of Windows Privilege Escalation](https://www.insomniasec.com/downloads/publications/WindowsPrivEsc.ppt) - Most common privilege escalation techniques up to 2011.
- [PowerUp](https://github.com/HarmJ0y/PowerUp) - Powershell privilege escalation tool.
- [Group Policy Hijacking](https://labs.mwrinfosecurity.com/blog/2015/04/02/how-to-own-any-windows-network-with-group-policy-hijacking-attacks/) - Group policy hijacking example and description

### Persistence

- [Using WMI to Build a Backdoor](https://www.blackhat.com/docs/us-15/materials/us-15-Graeber-Abusing-Windows-Management-Instrumentation-WMI-To-Build-A-Persistent%20Asynchronous-And-Fileless-Backdoor.pdf)
- [Many Ways of Malware Persistence](http://jumpespjump.blogspot.com.au/2015/05/many-ways-of-malware-persistence-that.html) 
- [Triggers as a Windows Persistence Mechanism](http://trustedsignal.blogspot.com/2014/02/triggers-as-windows-persistence.html)
- [Persistence Wiki](https://attack.mitre.org/wiki/Persistence)

### Lateral Movement

- [Veil Catapult](https://github.com/Veil-Framework/Veil-Catapult) - Payload delivery tool
- [WMIOps](https://github.com/ChrisTruncer/WMIOps) - Using WMI for a variety of local and remote functions
- [PAExec](https://github.com/poweradminllc/PAExec) - Remote execution tool
- [Pivoter](https://github.com/trustedsec/pivoter) - Proxy tool to assist with lateral movement
- [VPN Pivoting](http://blog.cobaltstrike.com/2014/10/14/how-vpn-pivoting-works-with-source-code/)
- [Making the Lateral Move](http://blog.varonis.com/penetration-testing-explained-part-iv-making-the-lateral-move/)

### Mimikatz

- [Mimikatz](https://github.com/gentilkiwi/mimikatz) - Official Mimikatz source code repository.
- [Dumping Passwords](http://carnal0wnage.attackresearch.com/2013/10/dumping-domains-worth-of-passwords-with.html)
- [Mimikatz Unofficial Guide](https://adsecurity.org/?page_id=1821)
- [Golden Ticket Walkthrough](http://www.beneaththewaves.net/Projects/Mimikatz_20_-_Golden_Ticket_Walkthrough.html)
- [Pass the Hash](http://blog.cobaltstrike.com/2015/05/21/how-to-pass-the-hash-with-mimikatz/)

### Exfiltration

- [Post Exploitation Operations with Cloud Synchronization Services](https://media.blackhat.com/us-13/US-13-Williams-Post-Exploitation-Operations-with-Cloud-Synchronization-Services-WP.pdf)
- [Threat Actors and Stealing Data](http://about-threats.trendmicro.com/cloud-content/us/ent-primers/pdf/how_do_threat_actors_steal_your_data.pdf)
- [Firecat](https://github.com/BishopFox/firecat) - Tool to create reverse TCP tunnels
- [Advanced Data Exfiltration](http://www.iamit.org/blog/2012/01/advanced-data-exfiltration/) - Data exfiltration techniques including through VoIP
- [Dnscat2](https://github.com/iagox86/dnscat2) - DNS tunnel with encryption and a focus on C&C
- [Tunna](https://github.com/SECFORCE/Tunna) - Tunnels TCP communication over HTTP
- [ICMPTX](https://github.com/jakkarth/icmptx) - Tunnels IP over ICMP
- [DNSteal](https://github.com/m57/dnsteal) - Tunnels data over DNS
- [Egress Assess](https://github.com/ChrisTruncer/Egress-Assess) - Tunnel data over FTP, HTTP, HTTPS
- [Using Egress Assess](https://www.christophertruncer.com/egress-assess-testing-egress-data-detection-capabilities/) 
- [Egress Assess and Owning Data Exfiltration](http://www.slideshare.net/CTruncer/egressassess-and-owning-data-exfiltration)
- [Exfiltrating Data Via Video](http://www.darkreading.com/attacks-breaches/in-plain-sight-how-cyber-criminals-exfiltrate-data-via-video-/a/d-id/1316725)
- [Network Tunneling Techniques]

### Miscellaneous

- [Nishang](https://github.com/samratashok/nishang) - Framework which enables the usage of PowerShell for red teaming
- [Zarp](https://github.com/hatRiot/zarp) - Network attack tool
- [CrackMapExec](https://github.com/byt3bl33d3r/CrackMapExec) - Variety of pentesting functions for Windows/Active Directory environments
- [Ostinato](https://github.com/pstavirs/ostinato) - Packet/Traffic generator and analyzer

## Tactical Response

### Event Logs

- [Investigating Powershell: Command and Script Logging](http://www.crowdstrike.com/blog/investigating-powershell-command-and-script-logging/)
- [A Forensic Analysis of APT Lateral Movement in Windows](https://www.first.org/resources/papers/conference2014/a-forensic-analysis-of-apt-lateral-movement-in-windows-environment.pptx)
- [Spotting the Adversary with Windows Event Log Monitoring](https://www.nsa.gov/ia/_files/app/spotting_the_adversary_with_windows_event_log_monitoring.pdf)
- [EVTXtract](https://github.com/williballenthin/EVTXtract) - Tool to recover and reconstruct fragments of EVTX log files from raw binary data, including unallocated space
- [Process Forest](https://github.com/williballenthin/process-forest) - Tool to reconstruct the historical process heirarchies from event logs


### DNS Logs

- [DNS Traffic Monitoring1](http://www.securityskeptic.com/DNS_Monitoring20140130.pdf)
- [Using Log Correlation Engine to Monitor DNS](http://static.tenable.com/prod_docs/LCE_DNS.pdf)
- [DNS Traffic Monitoring2](http://mastersicurezza.di.uniroma1.it/mastersicurezza/images/materiali/Convegni/dns_monitoringdeftcon2015.pdf) 
- [Monitor DNS Traffic & You Just Might Catch A RAT](http://www.darkreading.com/attacks-breaches/monitor-dns-traffic-and-you-just-might-catch-a-rat/a/d-id/1269593)

### Web Logs

- [Web Server Log Analysis](http://forensicmethods.com/webshell-log-analysis)
- [Apache Scalp](https://code.google.com/archive/p/apache-scalp/)

### System Survey

- [Cheat Sheet]
- [Identifying Lateral Movement]
- [Lateral Movement Detection](http://sysforensics.org/2014/01/lateral-movement/)
- [Monitoring Behaviors on Endpoints](https://conf.splunk.com/session/2014/conf2014_MikeKemmerer_Mitre_Security.pdf)
### Memory Analysis

- [Detect Malware with Memory Forensics](http://www.deer-run.com/~hal/Detect_Malware_w_Memory_Forensics.pdf)
- [Hunting Malware with Memory Analysis](https://www.solutionary.com/resource-center/blog/2012/12/hunting-malware-with-memory-analysis/)
- [Introduction to Windows Memory Analysis](https://www.youtube.com/watch?v=SjDH_vTuefM)
- [Volatility](http://www.volatilityfoundation.org/)
- [Volatility Documentation Project](https://github.com/volatilityfoundation/volatility/wiki/Volatility-Documentation-Project)
- [Volatility Cheat Sheet]

### Threat Intelligence

- [The Diamond Model of Intrustion Analysis](https://www.threatconnect.com/wp-content/uploads/ThreatConnect-The-Diamond-Model-of-Intrusion-Analysis.pdf)
- [Leveraging Threat Intelligence in Incident Respponse/Management]
- [APT Notes](https://github.com/kbandla/APTnotes) - Various public documents, whitepapers and articles about APT campaigns.
- [APT Notes Extension](https://aptnotes.malwareconfig.com/) - An extension of the work done by @kbandla to collate a repository of public Cyber Security APT Reports.
- [DML Model for Threat Intelligence](https://www.novainfosec.com/2016/02/12/the-dml-model/)
- [F3EAD for Offensive Response](https://www.academia.edu/12339861/The_Cyber_Kill_Chain_Employing_F3EAD_For_Offensive_Response_Actions_-_Counter_Russia_China_Iran_Terrorist_Organizations)

#### Information Feeds

- [Threat Intelligence Review](http://threatintelligencereview.com/)	
- [Emerging Threats Rulesets](http://rules.emergingthreats.net/)
- [Malware Domains](http://www.malwaredomains.com/)
- [Malcode Malware Domains](http://malc0de.com/bl/)
- [Palevo Tracker](https://palevotracker.abuse.ch/blocklists.php)
- [Zeus Tracker](https://zeustracker.abuse.ch/blocklist.php)
- [SSL Blacklist](https://sslbl.abuse.ch/)
- [Binary Defense](http://www.binarydefense.com/banlist.txt)

## Courses

- [The Offensive Techniques](http://www.mosse-security.com/short-courses/the-offensive-techniques-windows-edition.html)
- [Tactical Incident Response](http://www.mosse-security.com/short-courses/tactical-incident-response.html)
- [Applied Reverse Engineering](http://www.mosse-security.com/short-courses/applied-reverse-engineering.html)