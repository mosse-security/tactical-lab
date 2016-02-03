| Objective | Command |
| --------- | ------- |
| Look at event logs | eventvwr |
| Examine network configuration | arp -a,netstat -nr |
| List network connections and related details | netstat -nao,netstat -vb,net session, net use |
| List users and groups | lusrmgr,net users,net localgroup administrators, net group administrators |
| Look at scheduled jobs | schtasks |
| Look at auto-start programs | msconfig |
| List processes | taskmgr,wmic process list full |
| List services | net start,tasklist /svc |
| Check DNS settings and the host file | ipconfing /all,more %SystemRoot%System32Driversetchosts,ipconfig /displaydns |
| Verify integrity of OS files | sigverif |
| Research recently-modified files | dir /a/o-d/p %SystemRoot%System32 |