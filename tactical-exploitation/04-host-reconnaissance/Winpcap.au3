; Winpcap autoit3 UDF - V1.2c
; Copyleft GPL3 Nicolas Ricquemaque 2009-2011

; *********************** Initialisation functions **************************

Func _PcapSetup()	; return WinPCAP version as full text or -1 if winpcap is not installed, and opens dll
	If Not FileExists(@SystemDir & "\wpcap.dll") Then return -1
	global $Pcap_dll=DllOpen ( @SystemDir & "\wpcap.dll" )
	global $Pcap_errbuf = DLLStructCreate("char[256]")
	Global $Pcap_ptrhdr=0
	Global $Pcap_ptrpkt=0
	Global $Pcap_statV		; Total volume captured
	Global $Pcap_statN		; Total number of packets captured
	Global $Pcap_starttime	; Start time of Capture
	global $Pcap_timebias = (2^32 - RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\TimeZoneInformation", "ActiveTimeBias")) * 60
	Local $v = DllCall($Pcap_dll, "str:cdecl", "pcap_lib_version")
	if (@error > 0) Then return -1	
	return $v[0]
EndFunc


Func _PcapFree()		; free resources opened by _PcapSetup
	DllClose($Pcap_dll)
EndFunc

; *********************** Information functions **************************

Func _PcapGetLastError($pcap=0)  	; returns text from last pcap error
	If NOT IsPtr($pcap) Then return DllStructGetData($Pcap_errbuf,1)
	Local $v = DllCall($Pcap_dll, "str:cdecl", "pcap_geterr","ptr",$pcap)
	return DllStructGetData($Pcap_errbuf,1)&$v[0]
EndFunc


Func _PcapGetDeviceList() ; returns 2D array with pcap devices (name;desc;mac;ipv4_addr;ipv4_netmask;ipv4_broadaddr;ipv6_addr;ipv6_netmask;ipv6_broadaddr;flags) or -1 if error
	Local $alldevs=DLLStructCreate("ptr")
	Local $r=DllCall($Pcap_dll, "int:cdecl", "pcap_findalldevs_ex", "str", "rpcap://", "ptr", 0, "ptr", DllStructGetPtr($alldevs), "ptr", DllStructGetPtr($Pcap_errbuf))
	if (@error > 0) Then return -1
	if $r[0]=-1 Then return -1
	Local $next=DllStructGetData($alldevs,1)
	Local $list[1][14]
	Local $i=0;
	while ($next<>0)
		Local $pcap_if = DllStructCreate("ptr next;ptr name;ptr desc;ptr addresses;uint flags",$next)
		Local $len_name = DllCall("kernel32.dll", "int", "lstrlen", "ptr", DllStructGetData($pcap_if,2))  
		Local $len_desc = DllCall("kernel32.dll", "int", "lstrlen", "ptr", DllStructGetData($pcap_if,3)) 	
		$list[$i][0]=DllStructGetData(DllStructCreate("char["&($len_name[0]+1)&"]",DllStructGetData($pcap_if,2)),1)	
		$list[$i][1]=DllStructGetData(DllStructCreate("char["&($len_desc[0]+1)&"]",DllStructGetData($pcap_if,3)),1)	
		Local $next_addr=DllStructGetData($pcap_if,"addresses")
		
		; retrieve mac address
		Local $device=StringTrimLeft($list[$i][0],8)
		Local $snames = DllStructCreate("char Name["&(StringLen($device)+1)&"]")
		DllStructSetData($snames,1,$device)
		Local $handle=DllCall("packet.dll", "ptr:cdecl", "PacketOpenAdapter", "ptr", DllStructGetPtr($snames))	
		If IsPtr($handle[0]) Then
			Local $packetoiddata = DllStructCreate("ulong oid;ulong length;ubyte data[6]")
			DllStructSetData($packetoiddata,1,0x01010102)  ; OID_802_3_CURRENT_ADDRESS
			DllStructSetData($packetoiddata,2,6)
			Local $status=DllCall("packet.dll", "byte:cdecl", "PacketRequest", "ptr", $handle[0],"byte",0,"ptr",DllStructGetPtr($packetoiddata))
			If $status[0] Then
				Local $mac=DllStructGetData($packetoiddata,3)
				$list[$i][6]=StringMid($mac,3,2)&":"&StringMid($mac,5,2)&":"&StringMid($mac,7,2)&":"&StringMid($mac,9,2)&":"&StringMid($mac,11,2)&":"&StringMid($mac,13,2)
			EndIf		
			Local $nettype = DllStructCreate("uint type;uint64 speed")
			$status=DllCall("packet.dll", "byte:cdecl", "PacketGetNetType", "ptr", $handle[0], "ptr", DllStructGetPtr($nettype)) 
			If $status[0] Then
				$list[$i][5]=DllStructGetData($nettype,2)
			EndIf
			DllCall("packet.dll", "none:cdecl", "PacketCloseAdapter", "ptr", $handle[0])
		EndIf
		
		; retrieve lintypes
		Local $pcap=_PcapStartCapture($list[$i][0],"host 1.2.3.4",0,32)
		If IsPtr($pcap) Then
			Local $types=_PcapGetLinkType($pcap)
			If IsArray($types) Then
				$list[$i][2]=$types[0]
				$list[$i][3]=$types[1]
				$list[$i][4]=$types[2]
			EndIf
			_PcapStopCapture($pcap)
		EndIf
		
		; retrieve ip addresses
		while $next_addr<>0
			Local $pcap_addr = DllStructCreate("ptr next;ptr addr;ptr netmask;ptr broadaddr;ptr dst",$next_addr)			
			Local $j,$addr
			For $j=2 to 4
				$addr=_PcapSock2addr(DllStructGetData($pcap_addr,$j))
				If StringLen($addr)>15 Then 
					$list[$i][$j+8]=$addr
				ElseIf StringLen($addr)>6 Then 
					$list[$i][$j+5]=$addr
				EndIf
			Next
			$next_addr=DllStructGetData($pcap_addr,1)
		Wend
		
		$list[$i][13]=DllStructGetData($pcap_if,5)
		$next=DllStructGetData($pcap_if,1)
		$i+=1
		if $next<>0 Then Redim $list[$i+1][14]	
	Wend
	DllCall($Pcap_dll, "none:cdecl", "pcap_freealldevs", "ptr", DllStructGetData($alldevs,1))
	return $list
EndFunc


Func _PcapGetLinkType($pcap) ; returns a array with LinkType for opened capture $pcap. [0]: int value of link type, [1] name of linktype, [2] description of linktype
	If NOT IsPtr($pcap) Then return -1
	Local $type[3]
	Local $t=DllCall($Pcap_dll, "int:cdecl", "pcap_datalink", "ptr", $pcap)
	$type[0]=$t[0]
	Local $name=DllCall($Pcap_dll, "str:cdecl", "pcap_datalink_val_to_name", "int", $t[0])
	$type[1]=$name[0]
	Local $desc=DllCall($Pcap_dll, "str:cdecl", "pcap_datalink_val_to_description", "int", $t[0])
	$type[2]=$desc[0]
	return $type
EndFunc


Func _PcapListLinkTypes($pcap) ; returns a 2D array with possible LinkTypes for opened capture $pcap. For each one: [0]: int value of link type, [1] name of linktype, [2] description of linktype
	If NOT IsPtr($pcap) Then return -1
	Local $ptr=DLLStructCreate("ptr")
	Local $n=DllCall($Pcap_dll, "int:cdecl", "pcap_list_datalinks", "ptr", $pcap,"ptr",DllStructGetPtr($ptr))
	if $n[0]<1 then return -1
	Local $dlts=DLLStructCreate("int["&$n[0]&"]",DllStructGetData($ptr,1))
	Local $i,$name,$desc
	Local $types[$n[0]][3]
	For $i=0 to $n[0]-1
		$types[$i][0]=DllStructGetData($dlts,1,$i+1)
		$name=DllCall($Pcap_dll, "str:cdecl", "pcap_datalink_val_to_name", "int", $types[$i][0])
		$types[$i][1]=$name[0]
		$desc=DllCall($Pcap_dll, "str:cdecl", "pcap_datalink_val_to_description", "int", $types[$i][0])
		$types[$i][2]=$desc[0]
	Next
	return $types
EndFunc


Func _PcapSetLinkType($pcap,$dlt)
	If NOT IsPtr($pcap) Then return -1
	Local $n=DllCall($Pcap_dll, "int:cdecl", "pcap_set_datalink", "ptr", $pcap,"int",$dlt)
	return $n[0]
EndFunc


Func _PcapGetStats($pcap) ; returns array [0]=received packets [1]=droped packets by driver [2]=dropped packets by if [3]=captured packets [4]=Captured volume in bytes [5]=time in ms since beginning
If NOT IsPtr($pcap) Then return -1
Local $statsize=DLLStructCreate("int")
Local $s=DllCall($Pcap_dll, "ptr:cdecl", "pcap_stats_ex", "ptr", $pcap, "ptr", DllStructGetPtr($statsize))
If $s[0]=0 Then return -1
Local $stats=DLLStructCreate("uint recv;uint drop;uint ifdrop;uint capt",$s[0])
Local $ps[6][2]
$ps[0][0]=DllStructGetData($stats,1)
$ps[0][1]="Packets received by Interface"
$ps[1][0]=DllStructGetData($stats,2)
$ps[1][1]="Packets dropped by WinPcap"
$ps[2][0]=DllStructGetData($stats,3)
$ps[2][1]="Packets dropped by Interface"
$ps[3][0]=DllStructGetData($stats,4)
$ps[3][1]="Packets captured"
$ps[4][0]=$PCap_statV
$ps[4][1]="Bytes in packets captured"
$ps[5][0]=int(TimerDiff($Pcap_starttime))
$ps[5][1]="mS since capture start"
return $ps
EndFunc

; *********************** Capture functions **************************

Func _PcapStartCapture($DeviceName,$filter="",$promiscuous=0,$PacketLen=65536,$buffersize=0,$realtime=1)	; start a capture in non-blocking mode on device $DeviceName with optional parameters: $PacketLen, $promiscuous, $filter. Returns -1 on failure or pcap handler
	Local $handle=DllCall($Pcap_dll, "ptr:cdecl", "pcap_open", "str", $DeviceName, "int", $PacketLen, "int",$promiscuous,"int",1000,"ptr",0,"ptr", DllStructGetPtr($Pcap_errbuf) )
	if (@error > 0) Then return -1
	if ($handle[0] = 0) Then return -1
	DllCall($Pcap_dll, "int:cdecl", "pcap_setnonblock", "ptr", $handle[0], "int", 1, "ptr", DllStructGetPtr($Pcap_errbuf))
	if ($filter<>"") Then
		Local $fcode=DLLStructCreate("UINT;ptr")
		Local $comp=DllCall($Pcap_dll, "int:cdecl", "pcap_compile", "ptr", $handle[0], "ptr", DllStructGetPtr($fcode), "str", $filter,"int", 1, "int",0)
		if ($comp[0]=-1) Then
			Local $v = DllCall($Pcap_dll, "str:cdecl", "pcap_geterr","ptr",$handle[0])
			DLLStructSetData($Pcap_errbuf,1,"Filter: "&$v[0])
			_PcapStopCapture($handle[0])
			return -1
		EndIf
		Local $set=DllCall($Pcap_dll, "int:cdecl", "pcap_setfilter", "ptr", $handle[0], "ptr", DllStructGetPtr($fcode))
		if ($set[0]=-1) Then
			Local $v = DllCall($Pcap_dll, "str:cdecl", "pcap_geterr","ptr",$handle[0])
			DLLStructSetData($Pcap_errbuf,1,"Filter: "&$v[0])
			_PcapStopCapture($handle[0])
			return -1
		DllCall($Pcap_dll, "none:cdecl", "pcap_freecode", "ptr", $fcode) 
		EndIf	
	EndIf
	If $buffersize>0 Then DllCall($Pcap_dll, "int:cdecl", "pcap_setbuff", "ptr", $handle[0], "int", $buffersize)   
	If $realtime Then DllCall($Pcap_dll, "int:cdecl", "pcap_setmintocopy", "ptr", $handle[0], "int", 1)
	$Pcap_statV=0
	$Pcap_statN=0
	$Pcap_starttime=TimerInit()
	return $handle[0]
EndFunc	


Func _PcapStopCapture($pcap)	; stop capture started with _PcapStartCapture
	If NOT IsPtr($pcap) Then return
	DllCall($Pcap_dll, "none:cdecl", "pcap_close", "ptr", $pcap)   	
EndFunc


Func _PcapGetPacket($pcap) ; return 0: timeout, -1:error, -2:EOF in file or if successfull array[0]=time [1]=captured len [2]=packet len [3]=packet data
	If NOT IsPtr($pcap) Then return -1
	$Pcap_ptrhdr=DllStructCreate ("ptr")	
	$Pcap_ptrpkt=DllStructCreate ("ptr")
	Local $pk[4]		
	Local $res = DllCall($Pcap_dll, "int:cdecl", "pcap_next_ex","ptr",$pcap, "ptr",DllStructGetPtr($Pcap_ptrhdr),"ptr",DllStructGetPtr($Pcap_ptrpkt))
	If ($res[0]<>1) Then return $res[0]
	Local $pkthdr=DllStructCreate ( "int s;int us;int caplen;int len",DllStructGetData($Pcap_ptrhdr,1))
	Local $packet=DLLStructCreate("ubyte["&DllStructGetData($pkthdr,3)&"]",DllStructGetData($Pcap_ptrpkt,1))	 	
	Local $time_t=Mod(DllStructGetData($pkthdr,1)+$Pcap_timebias,86400)	
	$pk[0]=StringFormat ("%02d:%02d:%02d.%06d",int($time_t/3600),int(Mod($time_t,3600)/60),Mod($time_t,60),DllStructGetData($pkthdr,2))	
	$pk[1]=DllStructGetData($pkthdr,3)
	$pk[2]=DllStructGetData($pkthdr,4)
	$pk[3]=DllStructGetData($packet,1)
	; stats
	$Pcap_statV+=$pk[2]
	$Pcap_statN+=1
	return $pk
EndFunc


Func _PcapSendPacket($pcap,$data) ; data in Binary Format
	If NOT IsPtr($pcap) Then return -1
	Local $databuffer=DllStructCreate ("ubyte["&BinaryLen($data)&"]")
	DLLStructSetData($databuffer,1,$data)
	Local $r=DllCall($Pcap_dll, "int:cdecl", "pcap_sendpacket","ptr",$pcap, "ptr",DllStructGetPtr($databuffer),"int",BinaryLen($data))
	return $r[0]
EndFunc
	
	
Func _PcapDispatchToFunc($pcap,$func) ; call $func with an data array as parameters as many times as there are packets in buffer, then returns the number of packets read or -1 (error) or -2 (break received)
	If NOT IsPtr($pcap) Then return -1
	Local $CallBack = DLLCallbackRegister ("_PcapHandler", "none:cdecl", "str;ptr;ptr") 
	If $CallBack=0 Then return -1
	Local $r=DllCall($Pcap_dll, "int:cdecl", "pcap_dispatch", "ptr", $pcap, "int",-1, "ptr", DllCallbackGetPtr($CallBack), "str", $func)
	DllCallbackFree ( $CallBack )
	return $r[0]
EndFunc	

		
Func _PcapHandler($user,$hdr,$data)
	Local $pk[4]
	Local $pkthdr=DllStructCreate ( "int s;int us;int caplen;int len",$hdr)
	Local $packet=DLLStructCreate("ubyte["&DllStructGetData($pkthdr,3)&"]",$data)	 	
	Local $time_t=Mod(DllStructGetData($pkthdr,1)+$Pcap_timebias,86400)	
	$pk[0]=StringFormat ("%02d:%02d:%02d.%06d",int($time_t/3600),int(Mod($time_t,3600)/60),Mod($time_t,60),DllStructGetData($pkthdr,2))	
	$pk[1]=DllStructGetData($pkthdr,3)
	$pk[2]=DllStructGetData($pkthdr,4)
	$pk[3]=DllStructGetData($packet,1)
	; stats
	$Pcap_statV+=$pk[2]
	$Pcap_statN+=1
	call($user,$pk)
EndFunc


Func _PcapIsPacketReady($pcap)
	If NOT IsPtr($pcap) Then return -1
	Local $handle=DllCall($Pcap_dll, "ptr:cdecl", "pcap_getevent", "ptr", $pcap)
	Local $state = DllCall("kernel32.dll", "dword", "WaitForSingleObject", "ptr", $handle[0],"dword",0)
	return $state[0]=0
EndFunc


; *********************** Save to file functions **************************

Func _PcapSaveToFile($pcap,$filename)	; Open a file to save packets in pcap format
	If NOT IsPtr($pcap) Then return -1
	Local $save=DllCall($Pcap_dll, "ptr:cdecl", "pcap_dump_open", "ptr", $pcap, "str", $filename)
	if $save[0]=0 then return -1
	return $save[0]
EndFunc


Func _PcapWriteLastPacket($handle) ; Write the last received packet to file opened by _PcapSaveToFile 
	if NOT IsPtr($handle) Then return -1
	DllCall($Pcap_dll, "none:cdecl", "pcap_dump", "ptr", $handle, "ptr", DllStructGetData($Pcap_ptrhdr,1), "ptr", DllStructGetData($Pcap_ptrpkt,1))
EndFunc


Func _PcapStopCaptureFile($handle) ; Close capture file opened by _PcapSaveToFile
	if NOT IsPtr($handle) Then return -1
	DllCall($Pcap_dll, "none:cdecl", "pcap_dump_close", "ptr", $handle)
EndFunc

; *********************** Utility functions **************************

Func _PcapSock2addr ($sockaddr_ptr)  	; internat function to convert a sockaddr structure into an string containing an IP address
	If ($sockaddr_ptr=0) Then return ""
	Local $sockaddr = DllStructCreate("ushort family;char data[14]",$sockaddr_ptr)
	Local $family=DllStructGetData($sockaddr,1)
	If ($family = 2) Then ; AF_INET = IPv4
		Local $sockaddr_in = DllStructCreate("short family;ushort port;ubyte addr[4];char zero[8]",$sockaddr_ptr)
		return DllStructGetData($sockaddr_in,3,1)&"."&DllStructGetData($sockaddr_in,3,2)&"."&DllStructGetData($sockaddr_in,3,3)&"."&DllStructGetData($sockaddr_in,3,4)
	EndIf
	If ($family = 23) Then ; AF_INET6 = IPv6
		Local $sockaddr_in6 = DllStructCreate("ushort family;ushort port;uint flow;ubyte addr[16];uint scope",$sockaddr_ptr)
		Local $bin=DllStructGetData($sockaddr_in6,4)
		Local $i,$ipv6
		For $i=0 to 7
			$ipv6&=StringMid($bin,3+$i*4,4)&":"
		Next
		return StringTrimRight($ipv6,1)
	EndIf	
	return ""
EndFunc

; Extract a $bytes bytes value from a $data binary string, starting from offset $offset (1 for first byte)
Func _PcapBinaryGetVal($data,$offset,$bytes) 
	Local $val32=Dec(StringMid($data, 3+($offset-1)*2 ,$bytes*2))
	If $val32<0 Then return 2^32+$val32
	return $val32
EndFunc	


; Sets (replaces) a $bytes (up to 8) bytes value $value inside a $data binary string, starting at offset $offset (1 for first byte)
; User should make sure before calling this function that $data contains at least $offset+$bytes binary bytes !
Func _PcapBinarySetVal(Byref $data,$offset,$value,$bytes) 
	$data=StringReplace($data,3+($offset-1)*2,hex($value,$bytes*2))
EndFunc	


; $data is the packet data as a binary string
; $ipoffset is offset to the ip header; 14 bytes by default for an ethernet frame
; one should check before calling this function that data actualy contains an IP packet !
Func _PcapIpCheckSum ($data,$ipoffset=14)
	Local $iplen=BitAnd(_PcapBinaryGetVal($data,$ipoffset+1,1),0xF)*4
	Local $sum=0,$i
	For $i=1 To $iplen step 2
		$sum+=BitAnd(0xFFFF,_PcapBinaryGetVal($data,$ipoffset+$i,2))
	Next
	$sum-=_PcapBinaryGetVal($data,$ipoffset+11,2)
	While $sum>0xFFFF
		$sum = BitAnd($sum,0xFFFF)+BitShift($sum,16)
	Wend
	return BitXOR($sum,0xFFFF)
EndFunc


; $data is the packet data as a binary string
; $ipoffset is offset to the ip header; 14 bytes by default for an ethernet frame
; one should check before calling this function that data actualy contains an ICMP packet !
Func _PcapIcmpCheckSum ($data,$ipoffset=14)
	Local $iplen=BitAnd(_PcapBinaryGetVal($data,$ipoffset+1,1),0xF)*4
	Local $len=_PcapBinaryGetVal($data,$ipoffset+3,2)-$iplen  ; ip len - ip header len
	Local $sum=0,$i
	For $i=1 To BitAnd($len,0xFFFE) step 2
		$sum+=BitAnd(0xFFFF,_PcapBinaryGetVal($data,$ipoffset+$iplen+$i,2))
	Next
	If BitAnd($len,1) Then 
		$sum+=BitAnd(0xFF00,BitShift(_PcapBinaryGetVal($data,$ipoffset+$iplen+$len,1),-8))
	EndIf	
	$sum-=_PcapBinaryGetVal($data,$ipoffset+$iplen+3,2)
	While $sum>0xFFFF
		$sum = BitAnd($sum,0xFFFF)+BitShift($sum,16)
	Wend
	return BitXOR($sum,0xFFFF)
EndFunc


; $data is the packet data as a binary string
; $ipoffset is offset to the ip header; 14 bytes by default for an ethernet frame
; one should check before calling this function that data actualy contains a TCP packet !
Func _PcapTcpCheckSum ($data,$ipoffset=14)
	Local $iplen=BitAnd(_PcapBinaryGetVal($data,$ipoffset+1,1),0xF)*4
	Local $len=_PcapBinaryGetVal($data,$ipoffset+3,2)-$iplen  ; ip len - ip header len
	Local $sum=0,$i
	For $i=1 To BitAnd($len,0xFFFE) step 2
		$sum+=BitAnd(0xFFFF,_PcapBinaryGetVal($data,$ipoffset+$iplen+$i,2))
	Next
	If BitAnd($len,1) Then 
		$sum+=BitAnd(0xFF00,BitShift(_PcapBinaryGetVal($data,$ipoffset+$iplen+$len,1),-8))
	EndIf	
	$sum+=_PcapBinaryGetVal($data,$ipoffset+13,2)+_PcapBinaryGetVal($data,$ipoffset+15,2)+_PcapBinaryGetVal($data,$ipoffset+17,2)+_PcapBinaryGetVal($data,$ipoffset+19,2)+$len+6-_PcapBinaryGetVal($data,$ipoffset+$iplen+17,2)	; tcp pseudo header
	While $sum>0xFFFF
		$sum = BitAnd($sum,0xFFFF)+BitShift($sum,16)
	Wend
	return BitXOR($sum,0xFFFF)
EndFunc


; $data is the packet data as a binary string
; $ipoffset is offset to the ip header; 14 bytes by default for an ethernet frame
; one should check before calling this function that data actualy contains a UDP packet !
; Also, if the packet UDP value is set to 0x0000, no need to call this function, it means the CRC is not used in this packet.
Func _PcapUdpCheckSum ($data,$ipoffset=14)
	Local $iplen=BitAnd(_PcapBinaryGetVal($data,$ipoffset+1,1),0xF)*4
	Local $len=_PcapBinaryGetVal($data,$ipoffset+3,2)-$iplen  ; ip len - ip header len
	Local $sum=0,$i
	For $i=1 To BitAnd($len,0xFFFE) step 2
		$sum+=BitAnd(0xFFFF,_PcapBinaryGetVal($data,$ipoffset+$iplen+$i,2))
	Next
	If BitAnd($len,1) Then 
		$sum+=BitAnd(0xFF00,BitShift(_PcapBinaryGetVal($data,$ipoffset+$iplen+$len,1),-8))
	EndIf	
	$sum+=_PcapBinaryGetVal($data,$ipoffset+13,2)+_PcapBinaryGetVal($data,$ipoffset+15,2)+_PcapBinaryGetVal($data,$ipoffset+17,2)+_PcapBinaryGetVal($data,$ipoffset+19,2)+$len+17-_PcapBinaryGetVal($data,$ipoffset+$iplen+7,2)	; udp pseudo header
	While $sum>0xFFFF
		$sum = BitAnd($sum,0xFFFF)+BitShift($sum,16)
	Wend
	Local $crc=BitXOR($sum,0xFFFF)
	If $crc=0x0000 Then return 0xFFFF
	return $crc
EndFunc


Func _PcapCleanDeviceName($fullname) ; returns a cleaner device name without 'Network adapter ' etc if any
	Local $name=StringRegExp($fullname,"^Network adapter '(.*)' on",1)
	If @error=0 Then return StringStripWS($name[0],7)
	return StringStripWS($fullname,7)
EndFunc

