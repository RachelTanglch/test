#!/bin/sh
# T4_GPN_ELAN_ETREE_014.tcl \
exec tclsh "$0" ${1+"$@"}
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_015_LOG.txt" a]
        set stdout $fd_log
        chan configure $fd_log -blocking 0 -buffering none;#������ģʽ ����flush
        log_file log\\GPN_PTN_015_LOG.txt
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_015_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
        
        file mkdir "debug"
        set fd_debug [open debug\\GPN_PTN_015_DEBUG.txt a]
        exp_internal -f debug\\GPN_PTN_015_DEBUG.txt 0
        chan configure $fd_debug -blocking 0 -buffering none;#������ģʽ ����flush
        
	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl

	###����������
        array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
        array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "50" -pri "000"}
        array set dataArr3 {-srcMac "00:00:00:00:00:03" -dstMac "00:00:00:00:00:33" -srcIp "192.85.1.3" -dstIp "192.0.0.3" -vid "50" -pri "000" -type "9100"}
        array set dataArr4 {-srcMac "00:00:00:00:00:04" -dstMac "00:00:00:00:00:44" -srcIp "192.85.1.4" -dstIp "192.0.0.4" -vid "100" -pri "000"}
	array set dataArr5 {-srcMac "00:00:00:00:00:05" -dstMac "00:00:00:00:00:55" -srcIp "192.85.1.5" -dstIp "192.0.0.5" -vid1 "80" -pri1 "000" -vid2 "500" -pri2 "000"}
	array set dataArr6 {-srcMac "00:00:00:00:00:06" -dstMac "00:00:00:00:00:66" -srcIp "192.85.1.6" -dstIp "192.0.0.6" -vid "60" -pri "000"}
	array set dataArr7 {-srcMac "00:00:00:00:00:22" -dstMac "00:00:00:00:00:02" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "50" -pri "000"}
	array set dataArr8 {-srcMac "00:00:00:00:00:07" -dstMac "00:00:00:00:00:77" -srcIp "192.85.1.5" -dstIp "192.0.0.5" -vid1 "80" -pri1 "000" -vid2 "500" -pri2 "000"}
	array set dataArr9 {-srcMac "00:00:00:00:00:11" -dstMac "00:00:00:00:00:01" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
        ###���ö�����Ϣ����
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
        array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        #���÷���������
        set GenCfg {-SchedulingMode RATE_BASED}
	###���ù��˷���������
	##ƥ��smc
	set anaFliFrameCfg0 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	##ƥ��smc��vid��EtherType
	set anaFliFrameCfg1 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType><vlans name="anon_2561"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	##ƥ������vid
	set anaFliFrameCfg4 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5580"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	##mpls�����е�smac�� vid
	set anaFliFrameCfg51 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5699"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu></pdus></config></frame>}
	##mpls�����е������ǩ
	set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
	##mpls�����еĴ���vid��Experimental Bits (bits)/Bottom of stack (bit)
	set anaFliFrameCfg3 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4647"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><exp override="true"  filterMinValue="0" filterMaxValue="111">111</exp></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><sBit override="true"  filterMinValue="0" filterMaxValue="1">1</sBit></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
	##ƥ��smac��vid1��vid2��ethtype
	set anaFliFrameCfg6 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType><vlans name="anon_2516"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	##ƥ��smac��ethtype
	set anaFliFrameCfg7 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	
	set rateL 95000000;#�շ�������ȡֵ��Сֵ��Χ
	set rateR 105000000;#�շ�������ȡֵ���ֵ��Χ
	set rateL1 100000000 
	set rateR1 125000000
	
	set flagResult 0
	set flagCase1 0   ;#Test case 1��־λ 
	set flagCase2 0   ;#Test case 2��־λ
	
	set lFailFile ""
	set FLAGF 0
	
	set tcId 0
	set capId 0
	set cfgId 0
	#Ϊ���Խ���Ԥ������
	for {set i 0} {$i < 80} {incr i} {
	    puts $fileId "                                                                                                                                                                                                                "	
	}
	
	regsub {/} $GPNTestEth1 {_} GPNTestEth1_cap
	regsub {/} $GPNTestEth2 {_} GPNTestEth2_cap
	regsub {/} $GPNTestEth3 {_} GPNTestEth3_cap
	regsub {/} $GPNTestEth4 {_} GPNTestEth4_cap
	regsub {/} $GPNTestEth5 {_} GPNTestEth5_cap
	
	proc TestGPNEth1_repeat {printWord caseId fileId rateL rateR para} {
		set flag 0
		
		global gpnIp1
		global gpnIp3
		global gpnIp4
		global GPNTestEth1
		global GPNTestEth2
		global GPNTestEth3
		global GPNTestEth4
		global GPNTestEth5
				
		#NE1��GPNTestEth1 AC1����untag tag=50(tpid=8100) tag=50(tpid=9100) tag=60(tpid=8100)��������
		SendAndStat_ptn014 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
			$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 GPNPort5Cnt1\
			1 $::anaFliFrameCfg1 "$caseId"
		SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
			$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 GPNPort5Cnt7\
			7 $::anaFliFrameCfg7 "$caseId"
		SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
			$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 GPNPort5Cnt0\
			0 $::anaFliFrameCfg0 "$caseId"
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
		#NE1 AC2/AC4�Ľ���
		if {$GPNPort1Cnt0(cnt1) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\��AC2/AC4�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\��AC2/AC4�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt1)" $fileId
		}
		if {$GPNPort1Cnt1(cnt9) < $rateL || $GPNPort1Cnt1(cnt9) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\��AC2�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt9)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\��AC2�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt9)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt1(cnt8) < $rateL || $GPNPort1Cnt1(cnt8) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\��AC4�յ�tag=80��������������Ϊ$GPNPort1Cnt1(cnt8)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\��AC4�յ�tag=80��������������Ϊ$GPNPort1Cnt1(cnt8)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt0(cnt3) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\��AC2/AC4�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt3)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\��AC2/AC4�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt3)" $fileId
		}
		if {$GPNPort1Cnt0(cnt6) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=60��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\��AC2/AC4�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt6)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=60��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\��AC2/AC4�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt6)" $fileId
		}
		
		#NE3 ��GPNTestEth2����
		if {$GPNPort2Cnt0(cnt1) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
		}
		if {$GPNPort2Cnt7(cnt2) < $rateL || $GPNPort2Cnt7(cnt2) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt2)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt0(cnt3) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt3)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt3)" $fileId
		}
		if {$GPNPort2Cnt0(cnt6) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=60��δ֪������������NE3($gpnIp3)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt6)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=60��δ֪������������NE3($gpnIp3)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt6)" $fileId
		}
		#NE3 ��GPNTestEth3 AC1/AC3����
		if {$GPNPort3Cnt0(cnt1) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\��AC1/AC3�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\��AC1/AC3�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
		}
		if {$GPNPort3Cnt1(cnt2) < $rateL || $GPNPort3Cnt1(cnt2) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\��AC1�յ�tag=50��������������Ϊ$GPNPort3Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\��AC1�յ�tag=50��������������Ϊ$GPNPort3Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt1(cnt8) < $rateL || $GPNPort3Cnt1(cnt8) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\��AC3�յ�tag=80��������������Ϊ$GPNPort3Cnt1(cnt8)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\��AC3�յ�tag=80��������������Ϊ$GPNPort3Cnt1(cnt8)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt0(cnt3) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\��AC1/AC3�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt3)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\��AC1/AC3�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt3)" $fileId
		}
		if {$para == 0} {
			if {$GPNPort3Cnt0(cnt6) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=60��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\��AC1/AC3�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt6)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=60��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\��AC1/AC3�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt6)" $fileId
			}
		} else {
			if {$GPNPort3Cnt1(cnt7) < $rateL || $GPNPort3Cnt1(cnt7) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=60��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\��AC3�յ�tag=60��������������Ϊ$GPNPort3Cnt1(cnt7)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=60��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\��AC3�յ�tag=60��������������Ϊ$GPNPort3Cnt1(cnt7)����$rateL-$rateR\��Χ��" $fileId
			}
		}
		#NE4 GPNTestEth4 �Ľ���
		if {$GPNPort4Cnt0(cnt1) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
		}
		if {$GPNPort4Cnt7(cnt2) < $rateL || $GPNPort4Cnt7(cnt2) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt7(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt7(cnt2)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt0(cnt3) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt3)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt3)" $fileId
		}
		if {$GPNPort4Cnt0(cnt6) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=60��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt6)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=60��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt6)" $fileId
		}
		#NE1 GPNTestEth5 �Ľ���
		if {$GPNPort5Cnt0(cnt1) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth5\�յ�������������ӦΪ0ʵΪ$GPNPort5Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth5\�յ�������������ӦΪ0ʵΪ$GPNPort5Cnt0(cnt1)" $fileId
		}
		if {$GPNPort5Cnt7(cnt2) < $rateL || $GPNPort5Cnt7(cnt2) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth5\�յ�untag��������������Ϊ$GPNPort5Cnt7(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth5\�յ�untag��������������Ϊ$GPNPort5Cnt7(cnt2)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort5Cnt0(cnt3) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth5\�յ�������������ӦΪ0ʵΪ$GPNPort5Cnt0(cnt3)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth5\�յ�������������ӦΪ0ʵΪ$GPNPort5Cnt0(cnt3)" $fileId
		}
		if {$GPNPort5Cnt0(cnt6) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=60��δ֪������������NE1($gpnIp1)\
				$GPNTestEth5\�յ�������������ӦΪ0ʵΪ$GPNPort5Cnt0(cnt6)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=60��δ֪������������NE1($gpnIp1)\
				$GPNTestEth5\�յ�������������ӦΪ0ʵΪ$GPNPort5Cnt0(cnt6)" $fileId
		}
		return $flag
	}
	
	proc TestGPNEth5_repeat {caseId1 caseId2 fileId rateL rateR} {
		set flag 0
		
		global gpnIp1
		global gpnIp3
		global gpnIp4
		global GPNTestEth1
		global GPNTestEth2
		global GPNTestEth3
		global GPNTestEth4
		global GPNTestEth5
		
		#NE1��GPNTestEth5 ����untag tag=50(tpid=8100)��������
		SendAndStat_ptn014 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
			$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 GPNPort5Cnt1\
			1 $::anaFliFrameCfg1 $caseId1
		SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
			$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt6 GPNPort2Cnt6 GPNPort3Cnt6 GPNPort4Cnt6 GPNPort5Cnt6\
			6 $::anaFliFrameCfg6 $caseId1
		SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
			$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 GPNPort5Cnt7\
			7 $::anaFliFrameCfg7 $caseId1
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId1-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId1-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId1-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId1-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId1-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
		#NE1 GPNTestEth1�Ľ���
		if {$GPNPort1Cnt1(cnt1) < $rateL || $GPNPort1Cnt1(cnt1) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=50��������������Ϊ$GPNPort1Cnt1(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=50��������������Ϊ$GPNPort1Cnt1(cnt1)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt1(cnt10) < $rateL || $GPNPort1Cnt1(cnt10) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=80��������������Ϊ$GPNPort1Cnt1(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=80��������������Ϊ$GPNPort1Cnt1(cnt10)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt1(cnt11) < $rateL || $GPNPort1Cnt1(cnt11) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt11)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt6(cnt1) < $rateL || $GPNPort1Cnt6(cnt1) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\��tag=50(tpid=8100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ��ڲ�tag=50���tag=50��������������Ϊ$GPNPort1Cnt6(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\��tag=50(tpid=8100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ��ڲ�tag=50���tag=50��������������Ϊ$GPNPort1Cnt6(cnt1)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt6(cnt2) < $rateL || $GPNPort1Cnt6(cnt2) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\��tag=50(tpid=8100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ��ڲ�tag=50���tag=80��������������Ϊ$GPNPort1Cnt6(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\��tag=50(tpid=8100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ��ڲ�tag=50���tag=80��������������Ϊ$GPNPort1Cnt6(cnt2)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt6(cnt3) < $rateL || $GPNPort1Cnt6(cnt3) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\��tag=50(tpid=8100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ��ڲ�tag=50���tag=100��������������Ϊ$GPNPort1Cnt6(cnt3)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\��tag=50(tpid=8100)��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ��ڲ�tag=50���tag=100��������������Ϊ$GPNPort1Cnt6(cnt3)����$rateL-$rateR\��Χ��" $fileId
		}
		#NE3 GPNTestEth2�Ľ���
		if {$GPNPort2Cnt7(cnt1) < $rateL || $GPNPort2Cnt7(cnt1) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt1)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt1(cnt2) < $rateL || $GPNPort2Cnt1(cnt2) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=8100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth2\�յ�tag=50��������������Ϊ$GPNPort2Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=8100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth2\�յ�tag=50��������������Ϊ$GPNPort2Cnt7(cnt2)����$rateL-$rateR\��Χ��" $fileId
		}
		#NE3 GPNTestEth3�Ľ���
		if {$GPNPort3Cnt1(cnt1) < $rateL || $GPNPort3Cnt1(cnt1) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=50��������������Ϊ$GPNPort3Cnt1(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=50��������������Ϊ$GPNPort3Cnt1(cnt1)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt1(cnt10) < $rateL || $GPNPort3Cnt1(cnt10) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=80��������������Ϊ$GPNPort3Cnt1(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=80��������������Ϊ$GPNPort3Cnt1(cnt10)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt6(cnt1) < $rateL || $GPNPort3Cnt6(cnt1) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=8100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ��ڲ�tag=50���tag=50��������������Ϊ$GPNPort3Cnt6(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=8100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ��ڲ�tag=50���tag=50��������������Ϊ$GPNPort3Cnt6(cnt1)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt6(cnt2) < $rateL || $GPNPort3Cnt6(cnt2) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=8100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ��ڲ�tag=50���tag=80��������������Ϊ$GPNPort3Cnt6(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=8100)��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ��ڲ�tag=50���tag=80��������������Ϊ$GPNPort3Cnt6(cnt2)����$rateL-$rateR\��Χ��" $fileId
		}
		#NE4 GPNTestEth4�Ľ���
		if {$GPNPort4Cnt7(cnt1) < $rateL || $GPNPort4Cnt7(cnt1) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt7(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����untag��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt7(cnt1)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt1(cnt2) < $rateL || $GPNPort4Cnt1(cnt2) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=8100)��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�tag=50��������������Ϊ$GPNPort4Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=8100)��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�tag=50��������������Ϊ$GPNPort4Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
		}
		stc::perform streamBlockActivate \
			-streamBlockList "$::hGPNPort5Stream1 $::hGPNPort5Stream2" \
			-activate "false"
		stc::perform streamBlockActivate \
			-streamBlockList "$::hGPNPort5Stream3 $::hGPNPort5Stream4" \
			-activate "true"
		stc::apply
		
		gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort2AnaFrameCfgFil $::anaFliFrameCfg7
		set ::hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $::hGPNPort2Ana -FilterName "custom-vlanId" -Offset 14]
		set ::hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $::hGPNPort2Ana -FilterName "custom-etherType" -Offset 16]
		
		gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg7
		set ::hfilter16BitFilAna3 [stc::create Analyzer16BitFilter -under $::hGPNPort4Ana -FilterName "custom-vlanId" -Offset 14]
		set ::hfilter16BitFilAna4 [stc::create Analyzer16BitFilter -under $::hGPNPort4Ana -FilterName "custom-etherType" -Offset 16]
		
		gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort1AnaFrameCfgFil $::anaFliFrameCfg1
		set ::hfilter16BitFilAna5 [stc::create Analyzer16BitFilter -under $::hGPNPort1Ana -FilterName "custom-InnerVid" -Offset 18]
		gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg1
		set ::hfilter16BitFilAna6 [stc::create Analyzer16BitFilter -under $::hGPNPort3Ana -FilterName "custom-InnerVid" -Offset 18]
		
		stc::apply
		Recustomization 1 1 1 1 1 0
		gwd::Start_SendFlow "$::hGPNPort5Gen"  "$::hGPNPort1Ana $::hGPNPort2Ana $::hGPNPort3Ana $::hGPNPort4Ana"
		after 5000
		gwd::Stop_SendFlow "$::hGPNPort5Gen"  "$::hGPNPort1Ana $::hGPNPort2Ana $::hGPNPort3Ana $::hGPNPort4Ana"
		after 2000
		Recustomization 1 1 1 1 1 0
		if {$::cap_enable} {
			gwd::Start_CapAllData ::capArr $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
			gwd::Start_CapAllData ::capArr $::hGPNPort2Cap $::hGPNPort2CapAnalyzer
			gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
			gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
		}
		gwd::Start_SendFlow "$::hGPNPort5Gen"  "$::hGPNPort1Ana $::hGPNPort2Ana $::hGPNPort3Ana $::hGPNPort4Ana"
		after 10000
		incr capId
		if {$::cap_enable} {
			gwd::Stop_CapData $::hGPNPort1Cap 1 "$caseId2-p$::GPNTestEth1_cap\($gpnIp1\).pcap"
			gwd::Stop_CapData $::hGPNPort2Cap 1 "$caseId2-p$::GPNTestEth2_cap\($gpnIp3\).pcap"
			gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId2-p$::GPNTestEth3_cap\($gpnIp3\).pcap"
			gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId2-p$::GPNTestEth4_cap\($gpnIp4\).pcap"
		}
		array set GPNPort1Cnt4 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0}
		array set GPNPort2Cnt4 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0}
		array set GPNPort3Cnt4 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0}
		array set GPNPort4Cnt4 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt14 4 $::hGPNPort1Ana GPNPort1Cnt4]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 1 1 1 1 1 0
			after 5000
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt14 4 $::hGPNPort2Ana GPNPort2Cnt4]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 1 1 1 1 1 0
			after 5000
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt14 4 $::hGPNPort3Ana GPNPort3Cnt4]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 1 1 1 1 1 0
			after 5000
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt14 4 $::hGPNPort4Ana GPNPort4Cnt4]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 1 1 1 1 1 0
			after 5000
		}
		gwd::Stop_SendFlow "$::hGPNPort5Gen"  "$::hGPNPort1Ana $::hGPNPort2Ana $::hGPNPort3Ana $::hGPNPort4Ana"
		
	        gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId2-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	        gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId2-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
	        gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId2-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	        gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId2-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	        #NE1 GPNTestEth1�Ľ���
	        if {$GPNPort1Cnt4(cnt6) < $rateL || $GPNPort1Cnt4(cnt6) > $rateR} {
	        	set flag 1
	        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE1($gpnIp1)\
	        		$GPNTestEth1\�յ��ڲ�tag=100���tag=50��������������Ϊ$GPNPort1Cnt4(cnt6)��û��$rateL-$rateR\��Χ��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ��ڲ�tag=100���tag=50��������������Ϊ$GPNPort1Cnt4(cnt6)����$rateL-$rateR\��Χ��" $fileId
	        }
		if {$GPNPort1Cnt4(cnt7) < $rateL || $GPNPort1Cnt4(cnt7) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ��ڲ�tag=100���tag=80��������������Ϊ$GPNPort1Cnt4(cnt7)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ��ڲ�tag=100���tag=80��������������Ϊ$GPNPort1Cnt4(cnt7)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt4(cnt8) < $rateL || $GPNPort1Cnt4(cnt8) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ��ڲ�tag=100���tag=100��������������Ϊ$GPNPort1Cnt4(cnt8)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ��ڲ�tag=100���tag=100��������������Ϊ$GPNPort1Cnt4(cnt8)����$rateL-$rateR\��Χ��" $fileId
		}
	        if {$GPNPort1Cnt4(cnt3) < $rateL || $GPNPort1Cnt4(cnt3) > $rateR} {
	        	set flag 1
	        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\��tag=50(tpid=9100)��δ֪������������NE1($gpnIp1)\
	        		$GPNTestEth1\�յ��ڲ�tag=50���tag=50��������������Ϊ$GPNPort1Cnt4(cnt3)��û��$rateL-$rateR\��Χ��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\��tag=50(tpid=9100)��δ֪������������NE1($gpnIp1)\
	        		$GPNTestEth1\�յ��ڲ�tag=50���tag=50��������������Ϊ$GPNPort1Cnt4(cnt3)����$rateL-$rateR\��Χ��" $fileId
	        }
	        if {$GPNPort1Cnt4(cnt4) < $rateL || $GPNPort1Cnt4(cnt4) > $rateR} {
	        	set flag 1
	        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\��tag=50(tpid=9100)��δ֪������������NE1($gpnIp1)\
	        		$GPNTestEth1\�յ��ڲ�tag=50���tag=80��������������Ϊ$GPNPort1Cnt4(cnt4)��û��$rateL-$rateR\��Χ��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\��tag=50(tpid=9100)��δ֪������������NE1($gpnIp1)\
	        		$GPNTestEth1\�յ��ڲ�tag=50���tag=80��������������Ϊ$GPNPort1Cnt4(cnt4)����$rateL-$rateR\��Χ��" $fileId
	        }
	        if {$GPNPort1Cnt4(cnt5) < $rateL || $GPNPort1Cnt4(cnt5) > $rateR} {
	        	set flag 1
	        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\��tag=50(tpid=9100)��δ֪������������NE1($gpnIp1)\
	        		$GPNTestEth1\�յ��ڲ�tag=50���tag=100��������������Ϊ$GPNPort1Cnt4(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\��tag=50(tpid=9100)��δ֪������������NE1($gpnIp1)\
	        		$GPNTestEth1\�յ��ڲ�tag=50���tag=100��������������Ϊ$GPNPort1Cnt4(cnt5)����$rateL-$rateR\��Χ��" $fileId
	        }
	        #NE3 GPNTestEth2�Ľ���
	        if {$GPNPort2Cnt4(cnt2) < $rateL || $GPNPort2Cnt4(cnt2) > $rateR} {
	        	set flag 1
	        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE3($gpnIp3)\
	        		$GPNTestEth2\�յ�tag=100��������������Ϊ$GPNPort2Cnt4(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE3($gpnIp3)\
	        		$GPNTestEth2\�յ�tag=100��������������Ϊ$GPNPort2Cnt4(cnt2)����$rateL-$rateR\��Χ��" $fileId
	        }
	        if {$GPNPort2Cnt4(cnt1) < $rateL || $GPNPort2Cnt4(cnt1) > $rateR} {
	        	set flag 1
	        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=9100)��δ֪������������NE3($gpnIp3)\
	        		$GPNTestEth2\�յ�tag=50��������������Ϊ$GPNPort2Cnt4(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=9100)��δ֪������������NE3($gpnIp3)\
	        		$GPNTestEth2\�յ�tag=50��������������Ϊ$GPNPort2Cnt4(cnt1)����$rateL-$rateR\��Χ��" $fileId
	        }
	        #NE3 GPNTestEth3�Ľ���
	        if {$GPNPort3Cnt4(cnt6) < $rateL || $GPNPort3Cnt4(cnt6) > $rateR} {
	        	set flag 1
	        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE3($gpnIp3)\
	        		$GPNTestEth3\�յ��ڲ�tag=100���tag=50��������������Ϊ$GPNPort3Cnt4(cnt6)��û��$rateL-$rateR\��Χ��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE3($gpnIp3)\
	        		$GPNTestEth3\�յ��ڲ�tag=100���tag=50��������������Ϊ$GPNPort3Cnt4(cnt6)����$rateL-$rateR\��Χ��" $fileId
	        }
	        if {$GPNPort3Cnt4(cnt7) < $rateL || $GPNPort3Cnt4(cnt7) > $rateR} {
	        	set flag 1
	        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE3($gpnIp3)\
	        		$GPNTestEth3\�յ��ڲ�tag=100���tag=80��������������Ϊ$GPNPort3Cnt4(cnt7)��û��$rateL-$rateR\��Χ��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE3($gpnIp3)\
	        		$GPNTestEth3\�յ��ڲ�tag=100���tag=80��������������Ϊ$GPNPort3Cnt4(cnt7)����$rateL-$rateR\��Χ��" $fileId
	        }
	        if {$GPNPort3Cnt4(cnt3) < $rateL || $GPNPort3Cnt4(cnt3) > $rateR} {
	        	set flag 1
	        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=9100)��δ֪������������NE3($gpnIp3)\
	        		$GPNTestEth3\�յ��ڲ�tag=50���tag=50��������������Ϊ$GPNPort3Cnt4(cnt3)��û��$rateL-$rateR\��Χ��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=9100)��δ֪������������NE3($gpnIp3)\
	        		$GPNTestEth3\�յ��ڲ�tag=50���tag=50��������������Ϊ$GPNPort3Cnt4(cnt3)����$rateL-$rateR\��Χ��" $fileId
	        }
	        if {$GPNPort3Cnt4(cnt4) < $rateL || $GPNPort3Cnt4(cnt4) > $rateR} {
	        	set flag 1
	        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=9100)��δ֪������������NE3($gpnIp3)\
	        		$GPNTestEth3\�յ��ڲ�tag=50���tag=80��������������Ϊ$GPNPort3Cnt4(cnt4)��û��$rateL-$rateR\��Χ��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=9100)��δ֪������������NE3($gpnIp3)\
	        		$GPNTestEth3\�յ��ڲ�tag=50���tag=80��������������Ϊ$GPNPort3Cnt4(cnt4)����$rateL-$rateR\��Χ��" $fileId
	        }
	        #NE4 GPNTestEth4�Ľ���
	        if {$GPNPort4Cnt4(cnt2) < $rateL || $GPNPort4Cnt4(cnt2) > $rateR} {
	        	set flag 1
	        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE4($gpnIp4)\
	        		$GPNTestEth4\�յ�tag=100��������������Ϊ$GPNPort4Cnt4(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=100��δ֪������������NE4($gpnIp4)\
	        		$GPNTestEth4\�յ�tag=100��������������Ϊ$GPNPort4Cnt4(cnt2)����$rateL-$rateR\��Χ��" $fileId
	        }
	        if {$GPNPort4Cnt4(cnt1) < $rateL || $GPNPort4Cnt4(cnt1) > $rateR} {
	        	set flag 1
	        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=9100)��δ֪������������NE4($gpnIp4)\
	        		$GPNTestEth4\�յ�tag=50��������������Ϊ$GPNPort4Cnt4(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����tag=50(tpid=9100)��δ֪������������NE4($gpnIp4)\
	        		$GPNTestEth4\�յ�tag=50��������������Ϊ$GPNPort4Cnt4(cnt1)����$rateL-$rateR\��Χ��" $fileId
	        }
		return $flag
	}

	puts $fileId "��¼�����豸...\n"
	puts $fileId "\n=====��¼�����豸1====\n"
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"]} {
		
	}
	puts $fileId "\n=====��¼�����豸2====\n"
	set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
	puts $fileId "\n=====��¼�����豸3====\n"
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	puts $fileId "\n=====��¼�����豸4====\n"
	set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]

	#���ڵ��������豸�õ��ı���------
	set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
	set lMatchType "$matchType1 $matchType2 $matchType3 $matchType4"
	set lDutType "$Gpn_type1 $Gpn_type2 $Gpn_type3 $Gpn_type4"
	set lIp "$gpnIp1 $gpnIp2 $gpnIp3 $gpnIp4"
	#------���ڵ��������豸�õ��ı���
	
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "�������Թ���...\n"
	set hPtnProject [stc::create project]
	set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3 \"media $GPNEth3Media\" \
		$GPNStcPort4 \"media $GPNEth4Media\" $GPNStcPort5 \"media $GPNEth5Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4 hGPNPort5
	
	###������������
	gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort1 hGPNPort1Stream1
	gwd::STC_Create_Stream $fileId dataArr9 $hGPNPort4 hGPNPort4Stream3
	gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort1 hGPNPort1Stream2
	gwd::STC_Create_VlanTypeStream $fileId dataArr3 $hGPNPort1 hGPNPort1Stream3
	gwd::STC_Create_VlanStream $fileId dataArr4 $hGPNPort1 hGPNPort1Stream4
	gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort5 hGPNPort5Stream1
	gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort5 hGPNPort5Stream2
	gwd::STC_Create_VlanTypeStream $fileId dataArr3 $hGPNPort5 hGPNPort5Stream3
	gwd::STC_Create_VlanStream $fileId dataArr4 $hGPNPort5 hGPNPort5Stream4
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr5 $hGPNPort1 hGPNPort1Stream5
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr8 $hGPNPort3 hGPNPort3Stream8
	gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort4 hGPNPort4Stream1
	gwd::STC_Create_VlanStream $fileId dataArr6 $hGPNPort1 hGPNPort1Stream6
	gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort3 hGPNPort3Stream7
	gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort4 hGPNPort4Stream2
	set hGPNPortStreamList "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream3 $hGPNPort1Stream4 $hGPNPort5Stream1 $hGPNPort5Stream2 $hGPNPort4Stream3\
		$hGPNPort5Stream3 $hGPNPort5Stream4 $hGPNPort1Stream5 $hGPNPort3Stream8 $hGPNPort4Stream1 $hGPNPort1Stream6 $hGPNPort3Stream7 $hGPNPort4Stream2"
	set hGPNPortStreamList1 "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream3 $hGPNPort1Stream6"
	set hGPNPortStreamList2 "$hGPNPort5Stream1 $hGPNPort5Stream2 $hGPNPort5Stream3 $hGPNPort5Stream4"
	set hGPNPortStreamList3 "$hGPNPort1Stream5 $hGPNPort3Stream8"
	###��ȡ�������ͷ�����ָ��
	gwd::Get_Generator $hGPNPort1 hGPNPort1Gen
	gwd::Get_Analyzer $hGPNPort1 hGPNPort1Ana
	gwd::Get_Generator $hGPNPort2 hGPNPort2Gen
	gwd::Get_Analyzer $hGPNPort2 hGPNPort2Ana
	gwd::Get_Generator $hGPNPort3 hGPNPort3Gen
	gwd::Get_Analyzer $hGPNPort3 hGPNPort3Ana
	gwd::Get_Generator $hGPNPort4 hGPNPort4Gen
	gwd::Get_Analyzer $hGPNPort4 hGPNPort4Ana
	gwd::Get_Generator $hGPNPort5 hGPNPort5Gen
	gwd::Get_Analyzer $hGPNPort5 hGPNPort5Ana
	set hGPNPortGenList "$hGPNPort1Gen $hGPNPort2Gen $hGPNPort3Gen $hGPNPort4Gen $hGPNPort5Gen"
	set hGPNPortAnaList "$hGPNPort1Ana $hGPNPort2Ana $hGPNPort3Ana $hGPNPort4Ana $hGPNPort5Ana"
	stc::config $hGPNPort1Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort2Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort3Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort4Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort5Ana -FilterOnStreamId "FALSE"
	###�����շ���Ϣ
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort1 txInfoArr hGPNPort1TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort1 rxInfoArr1 hGPNPort1RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort1 rxInfoArr2 hGPNPort1RxInfo2
	
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort2 txInfoArr hGPNPort2TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort2 rxInfoArr1 hGPNPort2RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort2 rxInfoArr2 hGPNPort2RxInfo2
	
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort3 txInfoArr hGPNPort3TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort3 rxInfoArr1 hGPNPort3RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort3 rxInfoArr2 hGPNPort3RxInfo2
	
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort4 txInfoArr hGPNPort4TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort4 rxInfoArr1 hGPNPort4RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort4 rxInfoArr2 hGPNPort4RxInfo2
	
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort5 txInfoArr hGPNPort5TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort5 rxInfoArr1 hGPNPort5RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort5 rxInfoArr2 hGPNPort5RxInfo2
	
	###������������ 10%��Mbps
	foreach stream $hGPNPortStreamList {
		stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
		gwd::Cfg_StreamActive $stream "FALSE"
	}
	stc::apply 
	###��ȡ����������ָ��
	gwd::Get_GeneratorCfgObj $hGPNPort1Gen hGPNPort1GenCfg
	gwd::Get_GeneratorCfgObj $hGPNPort2Gen hGPNPort2GenCfg
	gwd::Get_GeneratorCfgObj $hGPNPort3Gen hGPNPort3GenCfg
	gwd::Get_GeneratorCfgObj $hGPNPort4Gen hGPNPort4GenCfg
	gwd::Get_GeneratorCfgObj $hGPNPort5Gen hGPNPort5GenCfg
	set hGPNPortGenCfgList "$hGPNPort1GenCfg $hGPNPort2GenCfg $hGPNPort3GenCfg $hGPNPort4GenCfg $hGPNPort5GenCfg"
	foreach hGenCfg $hGPNPortGenCfgList {
		gwd::Cfg_GeneratorCfgObj $hGenCfg $GenCfg
	}
	###���������ù�������Ĭ�Ϲ���tag
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort1Ana hGPNPort1AnaFrameCfgFil
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort2Ana hGPNPort2AnaFrameCfgFil
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort3Ana hGPNPort3AnaFrameCfgFil	
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort5Ana hGPNPort5AnaFrameCfgFil
	set hGPNPortAnaFrameCfgFilList "$hGPNPort1AnaFrameCfgFil $hGPNPort2AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil $hGPNPort5AnaFrameCfgFil"
	foreach hCfgFil $hGPNPortAnaFrameCfgFilList {
		gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $anaFliFrameCfg1
	}
	if {$cap_enable} {
		###��ȡ������capture������ص�ָ��
		gwd::Get_Capture $hGPNPort1 hGPNPort1Cap
		gwd::Get_Capture $hGPNPort2 hGPNPort2Cap
		gwd::Get_Capture $hGPNPort3 hGPNPort3Cap
		gwd::Get_Capture $hGPNPort4 hGPNPort4Cap
		gwd::Get_Capture $hGPNPort5 hGPNPort5Cap
		gwd::Create_FilterAnalyzer $hGPNPort1Cap hGPNPort1CapFilter hGPNPort1CapAnalyzer
		gwd::Create_FilterAnalyzer $hGPNPort2Cap hGPNPort2CapFilter hGPNPort2CapAnalyzer
		gwd::Create_FilterAnalyzer $hGPNPort3Cap hGPNPort3CapFilter hGPNPort3CapAnalyzer
		gwd::Create_FilterAnalyzer $hGPNPort4Cap hGPNPort4CapFilter hGPNPort4CapAnalyzer
		gwd::Create_FilterAnalyzer $hGPNPort5Cap hGPNPort5CapFilter hGPNPort5CapAnalyzer
		array set capArr {capMode "REGULAR_MODE" capSource "Tx_Rx_MODE"}
		set hGPNPortCapList "$hGPNPort1Cap $hGPNPort2Cap $hGPNPort3Cap $hGPNPort4Cap $hGPNPort5Cap"
		set hGPNPortCapAnalyzerList "$hGPNPort1CapAnalyzer $hGPNPort2CapAnalyzer $hGPNPort3CapAnalyzer $hGPNPort4CapAnalyzer $hGPNPort5CapAnalyzer"
	}
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-LAN raw��taggedģʽ���Ի������ÿ�ʼ...\n"
	set cfgFlag 0
	lappend cfgFlag [gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"]
	lappend cfgFlag [gwd::GWpublic_GetSysMac $telnet1 $matchType1 $Gpn_type1 $fileId gpnMac1]
	set portlist1 "$GPNPort5 $GPNPort12"
	set portList1 "$GPNTestEth1 $GPNTestEth5"
	set portList11 [concat $portlist1 $portList1]
	foreach port $portList11 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
		}
	 }
	set rebootSlotlist1 [gwd::GWpulic_getWorkCardList $portlist1]
	gwd::GWpublic_print "OK" "��ȡ�豸NE1($gpnIp1)ҵ��忨��λ��$rebootSlotlist1" $fileId
	set rebootSlotList1 [gwd::GWpulic_getWorkCardList $portList1]
	gwd::GWpublic_print "OK" "��ȡ�豸NE1($gpnIp1)�����忨��λ��$rebootSlotList1" $fileId
	set mslot1 [gwd::GWpulic_getWorkCardList $managePort1]
	gwd::GWpublic_print "OK" "��ȡ�豸NE1($gpnIp1)��������ڰ忨��λ��$mslot1" $fileId
 
	lappend cfgFlag [gwd::GWpublic_GetSysMac $telnet2 $matchType2 $Gpn_type2 $fileId gpnMac2]
	set portlist2 "$GPNPort6 $GPNPort7"
	set portList2 ""
	set portList22 [concat $portlist2 $portList2]
	foreach port $portList22 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "disable" "enable"]
		}
	}
	set rebootSlotlist2 [gwd::GWpulic_getWorkCardList $portlist2]
	gwd::GWpublic_print "OK" "��ȡ�豸NE2($gpnIp2)ҵ��忨��λ��$rebootSlotlist2" $fileId
	set mslot2 [gwd::GWpulic_getWorkCardList $managePort2]
	gwd::GWpublic_print "OK" "��ȡ�豸NE2($gpnIp2)��������ڰ忨��λ��$mslot2" $fileId

	set portlist3 "$GPNPort8 $GPNPort9"
	set portList3 "$GPNTestEth2 $GPNTestEth3"
	set portList33 [concat $portlist3 $portList3]
	foreach port $portList33 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "disable" "enable"]
		}
	}
	set rebootSlotlist3 [gwd::GWpulic_getWorkCardList $portlist3]
	gwd::GWpublic_print "OK" "��ȡ�豸NE3($gpnIp3)ҵ��忨��λ��$rebootSlotlist3" $fileId
	set rebootSlotList3 [gwd::GWpulic_getWorkCardList $portList3]
	gwd::GWpublic_print "OK" "��ȡ�豸NE3($gpnIp3)�����忨��λ��$rebootSlotList3" $fileId
	set mslot3 [gwd::GWpulic_getWorkCardList $managePort3]
	gwd::GWpublic_print "OK" "��ȡ�豸NE3($gpnIp3)��������ڰ忨��λ��$mslot3" $fileId
	
	set portlist4 "$GPNPort10 $GPNPort11"
	set portList4 "$GPNTestEth4"
	set portList44 [concat $portlist4 $portList4]
	foreach port $portList44 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet4 $matchType4 $Gpn_type4 $fileId $port "disable" "enable"]
		}
	}
        ###������ӿ����ò���
        if {[string match "L2" $Worklevel]} {
		set interface3 v4
        	set interface4 v4
        	set interface5 v5
        	set interface6 v5
        	set interface7 v6
        	set interface8 v6
        	set interface9 v7
        	set interface10 v7
        } else {
        	set interface3 $GPNPort5.4
        	set interface4 $GPNPort6.4
        	set interface5 $GPNPort7.5
        	set interface6 $GPNPort8.5
        	set interface7 $GPNPort9.6
        	set interface8 $GPNPort10.6
        	set interface9 $GPNPort11.7
        	set interface10 $GPNPort12.7
        }
	set Portlist "$GPNPort5 $GPNPort12 $GPNPort6 $GPNPort7 $GPNPort8 $GPNPort9 $GPNPort10 $GPNPort11"
	set Portlist0 "$GPNTestEth1 $GPNTestEth2 $GPNTestEth3 $GPNTestEth4 $GPNTestEth5"
	set Iplist "$ip612 $ip614 $ip621 $ip623 $ip632 $ip634 $ip643 $ip641"
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-LAN raw��taggedģʽ���Ի�������ʧ�ܣ����Խ���" \
		"E-LAN raw��taggedģʽ���Ի������óɹ�����������Ĳ���" "GPN_PTN_015"
	puts $fileId ""
	puts $fileId "===E-LAN raw��taggedģʽ���Ի������ý���..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId ""
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 ELANҵ��VC-TYPE RAWģʽ������֤\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)��$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
			NE4($gpnIp4)��$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth1\������������֤����ת��  ���Կ�ʼ=====\n"
	set flag1_case1 0
	set flag2_case1 0
	set flag3_case1 0
	set flag4_case1 0
	set flag5_case1 0
	set flag6_case1 0
	set flag7_case1 0
	set flag8_case1 0
	set flag9_case1 0
	set flag10_case1 0
	set flag11_case1 0
	set flag12_case1 0
	set flag13_case1 0
	set flag14_case1 0
	set flag15_case1 0
	set flag16_case1 0
	set flag17_case1 0
	set flag18_case1 0
	
        
	foreach {port1 port2} $Portlist telnet $lSpawn_id Gpn_type $lDutType {vid1 vid2} $Vlanlist {Ip1 Ip2} $Iplist matchType $lMatchType {
		###������ӿ����ò���
		if {[string match "L2" $Worklevel]} {
			set interface1 v$vid1
			set interface2 v$vid2
		} else {
			set interface1 $port1.$vid1
			set interface2 $port2.$vid2
		}
		###����NNI������
		if {[string match "L2" $Worklevel]}  {
			gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port1 "enable"
			gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port2 "enable"
		}
		PTN_NNI_AddInterIp $fileId $Worklevel $interface1 $Ip1 $port1 $matchType $Gpn_type $telnet
		PTN_NNI_AddInterIp $fileId $Worklevel $interface2 $Ip2 $port2 $matchType $Gpn_type $telnet
	}
	
	###����undo vlan check
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 "disable"
		gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth2 "disable"
		gwd::GWpublic_CfgVlanCheck $telnet4 $matchType4 $Gpn_type4 $fileId $GPNTestEth4 "disable"
	}
	###����dev1
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" 1 "elan" "flood" "false" "false" "false" "true" "2000" "" "raw"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface3 $ip621 "100" "100" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $interface10 $ip641 "400" "400" "normal" "4"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $address614
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "1004" "1004" "" "delete" "none" 1 0 "0x8100" "0x8100" "4"
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "50" $GPNTestEth1
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "100" $GPNTestEth1
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "80" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "modify" "50" "0" "0" "0x8100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac2" "vpls1" "" $GPNTestEth1 "100" "0" "none" "modify" "100" "0" "0" "0x9100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac3" "vpls1" "" $GPNTestEth5 "0" "0" "none" "delete" "1" "0" "0" "0x8100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac4" "vpls1" "" $GPNTestEth1 "80" "500" "none" "modify" "80" "0" "0" "0x8100" "evc2"
		
	###����dev3
	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3" 3 "elan" "flood" "false" "false" "false" "true" "2000" "" "raw"
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $interface6 $ip623 "200" "200" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $address632
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "2000" "2000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "50" $GPNTestEth3
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "80" $GPNTestEth3
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "vpls3" "" $GPNTestEth3 "50" "0" "none" "modify" "50" "0" "0" "0x8100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac2" "vpls3" "" $GPNTestEth2 "0" "0" "none" "delete" "1" "0" "0" "0x8100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac3" "vpls3" "" $GPNTestEth3 "80" "500" "none" "modify" "80" "0" "0" "0x8100" "evc2"
	
	###����dev2
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface4 $ip612 "100" "100" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $interface5 $ip632 "200" "200" "normal" "3"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $address623
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "raw"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "l2transport" "1" "" $address621 "1000" "1000" "1" "delete" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "raw"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "l2transport" "3" "" $address623 "2000" "2000" "3" "delete" "" 1 0 "0x8100" "0x8100" ""
	###����MS-PW����
	gwd::GWPw_AddMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "pw23"

	###����dev4
	gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $interface9 $ip614 "400" "400" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $address641
	gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"
	gwd::GWPw_AddPwVcType $telnet4 $matchType4 $Gpn_type4  $fileId "pw41" "raw"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "l2transport" "4" "" $address641 "1004" "1004" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_CfgAc $telnet4 $matchType4 $Gpn_type4 $fileId "ac1" "" $GPNTestEth4 0 0 "nochange" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet4 $matchType4 $Gpn_type4 $fileId "ac1" "pw41" "eline14"
	#��GPNTestEth5��Ĭ��vlan���óɺ�GPNTestEth1��ͬ����ֹvlanת��Ӱ��mplsת���Ĳ���
	if {[string match "L2" $Worklevel]} {  
                gwd::GWpublic_Addvlan $telnet1 $matchType1 $Gpn_type1 $fileId 2000
                gwd::GWpublic_Addporttovlan $telnet1 $matchType1 $Gpn_type1 $fileId 2000 "port" $GPNTestEth5 "untagged"
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "true"
	incr capId
	if {[TestGPNEth1_repeat "" GPN_PTN_015_$capId $fileId $rateL $rateR 0]} {
		set flag1_case1 1
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1�����ۣ�vplsΪelanҵ��rawģʽ NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
					NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth1\������������֤����ת��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1�����ۣ�vplsΪelanҵ��rawģʽNE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
					NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth1\������������֤����ת��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)��$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
				NE4($gpnIp4)��$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth1\������������֤����ת��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����NE1($gpnIp1)��NE3($gpnIp3)��NE1 NNI��$GPNPort5\��egress���򣬼��ҵ��vlan��tag��ǩ�Ƿ�ȥ��  ���Կ�ʼ=====\n"
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "true"
	
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "VLAN TAG" -Offset 42]
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 5000
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
	}
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_015_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_015_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort5Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	if {$GPNPort5Cnt1(cnt1) == 0} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��AC1��NE3($gpnIp3)$GPNTestEth3\��AC1����tag=50����֪����������������NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩû�б�ȥ��" $fileId
	} else {
		if {$GPNPort5Cnt1(cnt1) < $rateL1 || $GPNPort5Cnt1(cnt1) > $rateR1} {
			set flag2_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��AC1��NE3($gpnIp3)$GPNTestEth3\��AC1����tag=50����֪����������������NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩ��ȥ��\
				��������ΪGPNPort5Cnt1(cnt1)��û��$rateL1-$rateR1\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��AC1��NE3($gpnIp3)$GPNTestEth3\��AC1����tag=50����֪����������������NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩ��ȥ��\
				����Ϊ$GPNPort5Cnt1(cnt1)����$rateL1-$rateR1\��Χ��" $fileId
		}
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2�����ۣ�vplsΪelanҵ��rawģʽ����NE1��NE3($gpnIp3)��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩû�б�ȥ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2�����ۣ�vplsΪelanҵ��rawģʽ����NE1��NE3($gpnIp3)��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩ��ȥ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����NE1($gpnIp1)��NE3($gpnIp3)��NE1 NNI��$GPNPort5\��egress���򣬼��ҵ��vlan��tag��ǩ�Ƿ�ȥ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
				NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth5\������������֤����ת��  ���Կ�ʼ=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	
	stc::delete $hfilter16BitFilAna2
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort5Stream1 $hGPNPort5Stream2" \
		-activate "true"
	stc::apply
	#ͨ���˿�up down�Ĳ�����վ�����ѧϰ��mac��ַ
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "undo shutdown"
	incr capId
	if {[TestGPNEth5_repeat "GPN_PTN_015_$capId" "GPN_PTN_015_[expr $capId + 1]" $fileId $rateL $rateR]} {
		set flag3_case1 1
	}
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3�����ۣ�vplsΪelanҵ��rawģʽ NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
					NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth5\������������֤����ת��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3�����ۣ�vplsΪelanҵ��rawģʽNE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
					NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth5\������������֤����ת��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
				NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth5\������������֤����ת��  ���Խ���=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList2" \
		-activate "true"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����NE1($gpnIp1)��NE4($gpnIp4)��NE1 NNI��$GPNPort12\��egress���򣬼��ҵ��vlan��tag��ǩ�Ƿ�ȥ��  ���Կ�ʼ=====\n"
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	stc::delete $hfilter16BitFilAna3
	stc::delete $hfilter16BitFilAna4
	stc::delete $hfilter16BitFilAna5
	stc::delete $hfilter16BitFilAna6
	array set aMirror "dir1 egress port1 $GPNPort12 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList2" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort4Stream2" \
		-activate "true"
	
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	set hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "VLAN TAG" -Offset 42]
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort4Gen"  $hGPNPort5Ana
	after 5000
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort4Gen"  $hGPNPort5Ana
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
	}
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort4Gen"  $hGPNPort5Ana
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_015_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_015_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort5Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort4Gen"  $hGPNPort5Ana
	if {$GPNPort5Cnt1(cnt1) == 0} {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE4($gpnIp4)$GPNTestEth4\����tag=50����֪����������������NE1��NE4��NE1 NNI��$GPNPort12\��egress����ҵ��vlan��tag��ǩû�б�ȥ��" $fileId
	} else {
		if {$GPNPort5Cnt1(cnt1) < $rateL1 || $GPNPort5Cnt1(cnt1) > $rateR1} {
			set flag4_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE4($gpnIp4)$GPNTestEth4\����tag=50����֪����������������NE1��NE4��NE1 NNI��$GPNPort12\��egress����ҵ��vlan��tag��ǩ��ȥ��\
				��������ΪGPNPort5Cnt1(cnt1)��û��$rateL1-$rateR1\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE4($gpnIp4)$GPNTestEth4\����tag=50����֪����������������NE1��NE4��NE1 NNI��$GPNPort12\��egress����ҵ��vlan��tag��ǩ��ȥ��\
				����Ϊ$GPNPort5Cnt1(cnt1)����$rateL1-$rateR1\��Χ��" $fileId
		}
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA4�����ۣ�vplsΪelanҵ��rawģʽ����NE1($gpnIp1)��NE4($gpnIp4)��NE1 NNI��$GPNPort12\��egress����ҵ��vlan��tag��ǩû�б�ȥ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4�����ۣ�vplsΪelanҵ��rawģʽ����NE1($gpnIp1)��NE4($gpnIp4)��NE1 NNI��$GPNPort12\��egress����ҵ��vlan��tag��ǩ��ȥ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����NE1($gpnIp1)��NE4($gpnIp4)��NE1 NNI��$GPNPort12\��egress���򣬼��ҵ��vlan��tag��ǩ�Ƿ�ȥ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)$GPNTestEth1\ΪPORT+SVLAN+CVLAN��NE3($gpnIp3)$GPNTestEth3\ΪPORT+SVLAN+CVLAN��������������֤����ת��  ���Կ�ʼ=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::delete $hfilter16BitFilAna1
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort5Stream2 $hGPNPort4Stream2" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList3" \
		-activate "true"
	
	#ͨ���˿�up down�Ĳ�����վ�����ѧϰ��mac��ַ
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort11 "shutdown"
	gwd::GWpublic_CfgPortState $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort11 "undo shutdown"
	#NE1 GPNTestEth1�� NE3 GPNTestEth3�����ڲ�500���80��δ֪����
	SendAndStat_ptn014 1 "$::hGPNPort1Gen $::hGPNPort3Gen" "$::hGPNPort1Ana $::hGPNPort3Ana" "$GPNTestEth1 $GPNTestEth3" "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3" "$hGPNPort1AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil" GPNPort1Cnt6 GPNPort3Cnt6 aTmp1 aTmp2 aTmp3\
		6 $::anaFliFrameCfg6 "GPN_PTN_015_$capId"
		
	if {$GPNPort3Cnt6(cnt10) < $rateL || $GPNPort3Cnt6(cnt10) > $rateR} {
		set flag5_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\�����ڲ�tag=500���tag=80��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ��ڲ�tag=500���tag=80��������������Ϊ$GPNPort3Cnt6(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\�����ڲ�tag=500���tag=80��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ��ڲ�tag=500���tag=80��������������Ϊ$GPNPort3Cnt6(cnt10)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt6(cnt11) < $rateL || $GPNPort1Cnt6(cnt11) > $rateR} {
		set flag5_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\�����ڲ�tag=500���tag=80��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ��ڲ�tag=500���tag=80��������������Ϊ$GPNPort1Cnt6(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\�����ڲ�tag=500���tag=80��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ��ڲ�tag=500���tag=80��������������Ϊ$GPNPort1Cnt6(cnt11)����$rateL-$rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA5�����ۣ�vplsΪelanҵ��rawģʽNE1($gpnIp1)$GPNTestEth1\ΪPORT+SVLAN+CVLAN��NE3($gpnIp3)$GPNTestEth3\ΪPORT+SVLAN+CVLAN��������������֤����ת��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5�����ۣ�vplsΪelanҵ��rawģʽNE1($gpnIp1)$GPNTestEth1\ΪPORT+SVLAN+CVLAN��NE3($gpnIp3)$GPNTestEth3\ΪPORT+SVLAN+CVLAN��������������֤����ת��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)$GPNTestEth1\ΪPORT+SVLAN+CVLAN��NE3($gpnIp3)$GPNTestEth3\ΪPORT+SVLAN+CVLAN��������������֤����ת��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE4($gpnIp4)��vpwsҵ�� $GPNTestEth4\ΪPORTģʽ��NE1($gpnIp1)��vplsҵ��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORTģʽ��NE4($gpnIp4)��$GPNTestEth4\������������֤����ת��  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList3" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort4Stream1" \
		-activate "true"
	SendAndStat_ptn014 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 GPNPort5Cnt1\
		1 $::anaFliFrameCfg1 "GPN_PTN_015_$capId"
	SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
        	$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
        	$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 GPNPort5Cnt7\
        	7 $::anaFliFrameCfg7 "GPN_PTN_015_$capId"
	#NE1 GPNTestEth1�Ľ���
	if {$GPNPort1Cnt1(cnt1) < $rateL || $GPNPort1Cnt1(cnt1) > $rateR} {
        	set flag6_case1 1
        	gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=50��������������Ϊ$GPNPort1Cnt1(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=50��������������Ϊ$GPNPort1Cnt1(cnt1)����$rateL-$rateR\��Χ��" $fileId
	} 
	if {$GPNPort1Cnt1(cnt10) < $rateL || $GPNPort1Cnt1(cnt10) > $rateR} {
		set flag6_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=80��������������Ϊ$GPNPort1Cnt1(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=80��������������Ϊ$GPNPort1Cnt1(cnt10)����$rateL-$rateR\��Χ��" $fileId
	} 
	if {$GPNPort1Cnt1(cnt11) < $rateL || $GPNPort1Cnt1(cnt11) > $rateR} {
		set flag6_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt11)����$rateL-$rateR\��Χ��" $fileId
	}
	#NE1 GPNTestEth5�Ľ���
	if {$GPNPort5Cnt7(cnt1) < $rateL || $GPNPort5Cnt7(cnt1) > $rateR} {
		set flag6_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth5\�յ�untag��������������Ϊ$GPNPort5Cnt7(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth5\�յ�untag��������������Ϊ$GPNPort5Cnt7(cnt1)����$rateL-$rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag6_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA6�����ۣ�NE4($gpnIp4)��vpwsҵ��rawģʽ $GPNTestEth4\ΪPORTģʽ��NE1($gpnIp1)��vplsҵ��rawģʽ$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORTģʽ��NE4��$GPNTestEth4\������������֤����ת��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6�����ۣ�NE4($gpnIp4)��vpwsҵ��rawģʽ $GPNTestEth4\ΪPORTģʽ��NE1($gpnIp1)��vplsҵ��rawģʽ$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORTģʽ��NE4��$GPNTestEth4\������������֤����ת��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE4($gpnIp4)��vpwsҵ�� $GPNTestEth4\ΪPORTģʽ��NE1($gpnIp1)��vplsҵ��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORTģʽ��NE4($gpnIp4)��$GPNTestEth4\������������֤����ת��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw����Ϊmodify��nochange��add����֤ϵͳ�Ƿ���ʾ�������޸�Ϊdelete  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	set ret [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "modify" "none" 1 0 "0x8100" "0x8100" "2"]
	if {$ret == 0} {
		set flag7_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw12 VLAN����Ϊmodify�����óɹ�����ʾ" $fileId
	} elseif {$ret == 2} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw12 VLAN����Ϊmodify����ʾ�������޸�Ϊdelete" $fileId
	} else {
		set flag7_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw12 VLAN����Ϊmodify������ʧ����ϵͳ��ʾ����" $fileId
	}
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	
	set ret [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"]
	if {$ret == 0} {
		set flag7_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw12 VLAN����Ϊnochange�����óɹ�����ʾ" $fileId
	} elseif {$ret == 2} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw12 VLAN����Ϊnochange����ʾ�������޸�Ϊdelete" $fileId
	} else {
		set flag7_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw12 VLAN����Ϊnochange������ʧ����ϵͳ��ʾ����" $fileId
	}
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	
	set ret [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1 0 "0x8100" "0x8100" "2"]
	if {$ret == 0} {
		set flag7_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw12 VLAN����Ϊadd�����óɹ�����ʾ" $fileId
	} elseif {$ret == 2} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw12 VLAN����Ϊadd����ʾ�������޸�Ϊdelete" $fileId
	} else {
		set flag7_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw12 VLAN����Ϊadd������ʧ����ϵͳ��ʾ����" $fileId
	}
	puts $fileId ""
	if {$flag7_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA7�����ۣ�NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw����Ϊmodify��nochange��add��ϵͳ�޴�����ʾ����ʾ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7�����ۣ�NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw����Ϊmodify��nochange��add��ϵͳ��ʾ�������޸�Ϊdelete" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw����Ϊmodify��nochange��add����֤ϵͳ�Ƿ���ʾ�������޸�Ϊdelete  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add����֤ϵͳ�Ƿ���ʾ�������޸�Ϊmodify  ���Կ�ʼ=====\n"
	set ret [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "delete" "50" "0" "0" "0x8100" "evc2"]
	if {$ret == 0} {
		set flag8_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊdelete�����óɹ�����ʾ" $fileId
	} elseif {$ret == 2} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊdelete����ʾ�������޸�Ϊmodify" $fileId
	} else {
		set flag8_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊdelete������ʧ����ϵͳ��ʾ����" $fileId
	}
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	
	set ret [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "nochange" "50" "0" "0" "0x8100" "evc2"]
	if {$ret == 0} {
		set flag8_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊnochange�����óɹ�����ʾ" $fileId
	} elseif {$ret == 2} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊnochange����ʾ�������޸�Ϊmodify" $fileId
	} else {
		set flag8_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊnochange������ʧ����ϵͳ��ʾ����" $fileId
	}
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	
	set ret [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "add" "50" "0" "0" "0x8100" "evc2"]
	if {$ret == 0} {
		set flag8_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊadd�����óɹ�����ʾ" $fileId
	} elseif {$ret == 2} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊadd����ʾ�������޸�Ϊmodify" $fileId
	} else {
		set flag8_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊadd������ʧ����ϵͳ��ʾ����" $fileId
	}
	puts $fileId ""
	if {$flag8_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA8�����ۣ�NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add��ϵͳ�޴�����ʾ����ʾ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8�����ۣ�NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add��ϵͳ��ʾ�������޸�Ϊmodify" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add����֤ϵͳ�Ƿ���ʾ�������޸�Ϊmodify  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬷�����֤�����Ƿ���Ч  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort4Stream1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "true"
	if {($flag7_case1 == 0) && ($flag8_case1 == 0)} {
		incr capId
		if {[TestGPNEth1_repeat "" GPN_PTN_015_$capId $fileId $rateL $rateR 0]} {
			set flag9_case1 1
		}
	} else {
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "modify" "50" "0" "0" "0x8100" "evc2"
		if {$flag7_case1 == 1} {
			set flag9_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������pw����Ϊmodify��nochange��add��ϵͳû���Զ��޸Ķ���Ϊdelete����������޷�����" $fileId
		} elseif {$flag8_case1 == 1} {
			set flag9_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add��ϵͳû���Զ��޸Ķ���Ϊmodify����������޷�����" $fileId	
		}
	}
	puts $fileId ""
	if {$flag9_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA9�����ۣ�NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬷�����֤����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9�����ۣ�NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬷�����֤����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬷�����֤�����Ƿ���Ч  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬾���NE1��NE3��NE1 NNI��$GPNPort5\��egress���򣬼��ҵ��vlan��tag��ǩ�Ƿ�ȥ��  ���Կ�ʼ=====\n"
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "VLAN TAG" -Offset 42]
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "true"
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 5000
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 2000
	Recustomization 1 1 1 1 1 0
	if {($flag7_case1 == 0) && ($flag8_case1 == 0)} {
		if {$cap_enable} {
			gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
		}
		gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
		after 10000
		incr capId
		if {$cap_enable} {
			gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_015_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
		}
		gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_015_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
		array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 1 1 1 1 1 0
			after 5000
		}
		
		parray GPNPort5Cnt1
		gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
		if {$GPNPort5Cnt1(cnt1) == 0} {
			set flag10_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��AC1��NE3($gpnIp3)$GPNTestEth3\��AC1����tag=50����֪����������������NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩû�б�ȥ��" $fileId
		} else {
			if {$GPNPort5Cnt1(cnt1) < $rateL1 || $GPNPort5Cnt1(cnt1) > $rateR1} {
				set flag10_case1 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��AC1��NE3($gpnIp3)$GPNTestEth3\��AC1����tag=50����֪����������������NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩ��ȥ��\
					��������ΪGPNPort5Cnt1(cnt1)��û��$rateL1-$rateR1\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��AC1��NE3($gpnIp3)$GPNTestEth3\��AC1����tag=50����֪����������������NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩ��ȥ��\
					����Ϊ$GPNPort5Cnt1(cnt1)����$rateL1-$rateR1\��Χ��" $fileId
			}
		}
	} else {
		if {$flag7_case1 == 1} {
			set flag10_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������pw����Ϊmodify��nochange��add��ϵͳû���Զ��޸Ķ���Ϊdelete����������޷�����" $fileId
		} elseif {$flag8_case1 == 1} {
			set flag10_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add��ϵͳû���Զ��޸Ķ���Ϊmodify����������޷�����" $fileId	
		}
	}
	puts $fileId ""
	if {$flag10_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB1�����ۣ�NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬾���NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩû�б�ȥ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1�����ۣ�NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬾���NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩ��ȥ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬾���NE1��NE3��NE1 NNI��$GPNPort5\��egress���򣬼��ҵ��vlan��tag��ǩ�Ƿ�ȥ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)֮��������һ��ҵ����NE3��pw�����û��أ����Ի����������Ͷ�����ҵ���Ӱ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::delete $hfilter16BitFilAna2
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "undo shutdown"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream6" \
		-activate "true"
	stc::apply
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "modify" "50" "0" "0" "0x8100" "evc2"
	###NE1-NE3֮��������һ��ҵ�񣬹���ͬһ��lsp
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11" 11 "elan" "flood" "false" "false" "false" "true" "2000" "" "raw"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121" "vpls" "vpls11" "peer" $address612 "1001" "1001" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "60" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac5" "vpls11" "" $GPNTestEth1 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "l2transport" "11" "" $address621 "1001" "1001" "1" "delete" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231" "l2transport" "31" "" $address623 "2001" "2001" "3" "delete" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWPw_AddMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"

	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33" 33 "elan" "flood" "false" "false" "false" "true" "2000" "" "raw"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321" "vpls" "vpls33" "peer" $address632 "2001" "2001" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "60" $GPNTestEth3
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac5" "vpls33" "" $GPNTestEth3 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	
	gwd::GWpublic_addPwLoop $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	#����GPNTestEth1��û���յ�NE3���ص�����------
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg1
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$hGPNPort1Gen"  $hGPNPort1Ana
	after 5000
	gwd::Stop_SendFlow "$hGPNPort1Gen"  $hGPNPort1Ana
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort1Cap $hGPNPort1CapAnalyzer
	}
	gwd::Start_SendFlow "$hGPNPort1Gen"  $hGPNPort1Ana
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort1Cap 1 "GPN_PTN_015_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_015_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort1Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 1 $hGPNPort1Ana GPNPort1Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort1Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen"  $hGPNPort1Ana
	if {$GPNPort1Cnt1(cnt7) < $rateL || $GPNPort1Cnt1(cnt7) > $rateR} {
        	set flag11_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=60��δ֪������������NE3($gpnIp3)��pw��������\
			NE1 $GPNTestEth1\�յ�tag=60��������������Ϊ$GPNPort1Cnt1(cnt7)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=60��δ֪������������NE3($gpnIp3)��pw��������\
			NE1 $GPNTestEth1\�յ�tag=60��������������Ϊ$GPNPort1Cnt1(cnt7)����$rateL-$rateR\��Χ��" $fileId
	}
	#------����GPNTestEth1��û���յ�NE3���ص�����
	#���Ի������ݵ�mac��ַ��û�б�����------
	array set aMirror "dir1 ingress port1 $GPNPort5 dir2 egress port2 $GPNPort5"
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg51
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$hGPNPort1Gen"  "$hGPNPort5Ana"
	after 5000
	gwd::Stop_SendFlow "$hGPNPort1Gen"  "$hGPNPort5Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer 
	}
	gwd::Start_SendFlow "$hGPNPort1Gen"  "$hGPNPort5Ana"
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_015_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap"
	}
	array set aGPNPort5Cnt1 {cnt3 0 cnt4 0} 
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 2 $hGPNPort5Ana aGPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray aGPNPort5Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen"  "$hGPNPort5Ana"
	if {$aGPNPort5Cnt1(cnt3) < $rateL1 || $aGPNPort5Cnt1(cnt3) > $rateR1} {
		set flag11_case1 1
		gwd::GWpublic_print "NOK" "vplsΪelanҵ��rawģʽ��NE3�������ݻ��أ���NE1���ͱ��ģ�����NE1 NNI�ĳ������ģ�macû�б�����" $fileId
	} else {
		gwd::GWpublic_print "OK" "vplsΪelanҵ��rawģʽ��NE3�������ݻ��أ���NE1���ͱ��ģ�����NE1 NNI�ĳ������ģ�mac������" $fileId
	}
	if {$aGPNPort5Cnt1(cnt4) < $rateL1 || $aGPNPort5Cnt1(cnt4) > $rateR1} {
		set flag11_case1 1
		gwd::GWpublic_print "NOK" "vplsΪelanҵ��rawģʽ��NE3�������ݻ��أ���NE1���ͱ��ģ�����NE1 NNI���뷽���ģ�macû�б�����" $fileId
	} else {
		gwd::GWpublic_print "OK" "vplsΪelanҵ��rawģʽ��NE3�������ݻ��أ���NE1���ͱ��ģ�����NE1 NNI���뷽���ģ�mac������" $fileId
	}
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	#------���Ի������ݵ�mac��ַ��û�б�����
	#������ҵ���Ӱ��------
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "true"
	incr capId
	if {[TestGPNEth1_repeat "" GPN_PTN_015_$capId $fileId $rateL $rateR 0]} {
		set flag11_case1 1
	}
	#------������ҵ���Ӱ��
	puts $fileId ""
	if {$flag11_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB2�����ۣ�vplsΪelanҵ��rawģʽNE1($gpnIp1)-NE3($gpnIp3)֮��������һ��ҵ����NE3��pw�����û��أ����Ի����������Ͷ�����ҵ���Ӱ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2�����ۣ�vplsΪelanҵ��rawģʽNE1($gpnIp1)-NE3($gpnIp3)֮��������һ��ҵ����NE3��pw�����û��أ����Ի����������Ͷ�����ҵ���Ӱ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)֮��������һ��ҵ����NE3��pw�����û��أ����Ի����������Ͷ�����ҵ���Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��ping pw12  ���Կ�ʼ=====\n"
	gwd::GWpublic_delPwLoop $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	gwd::GWpublic_addPwPing $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" value
	if {![dict get $value sucRate]==100.00} {
		set flag12_case1 1 
		gwd::GWpublic_print "NOK"  "vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��ping pw12 pingͨ���Ԥ��Ϊ100.00% ʵΪ[dict get $value sucRate]%" $fileId
	} else {
		gwd::GWpublic_print "OK"  "vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��ping pw12 pingͨ���Ԥ��Ϊ100.00% ʵΪ[dict get $value sucRate]%" $fileId
	}
	if {[string match [dict get $value replyIp] "20.6.5.2"]} {
		gwd::GWpublic_print "OK" "vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��ping pw12��reply from ��ipӦΪ20.6.5.2ʵΪ[dict get $value replyIp]" $fileId
	} else {
		set flag12_case1 1
		gwd::GWpublic_print "NOK" "vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��ping pw12��reply from ��ipӦΪ20.6.5.2ʵΪ[dict get $value replyIp]" $fileId
	}
	puts $fileId ""
	if {$flag12_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB3�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��ping pw12 pingͨ���Ԥ��Ϊ100.00% ʵΪ[dict get $value sucRate]%" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��ping pw12 pingͨ���Ԥ��Ϊ100.00% ʵΪ[dict get $value sucRate]%" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��ping pw12  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ����NE1($gpnIp1)ʹ��tracertroute�鿴���Ĵ�NE1��NE3������ÿһ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_addPwTrace $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" result
	set expectTrace {0 {replier "null" traceTime "null" type "Ingress" downstream "20.6.4.2/ 1000 100" ret "null"} 1 {replier "20.6.4.2" traceTime "<1ms" type "Transit" downstream "20.6.5.2/ 2000 200" ret "transit router"} 2 {replier "20.6.5.2" traceTime "<1ms" type "Egress" downstream "--" ret "success"}}
	set flag13_case1 [Check_Tracertroute "" $expectTrace $result]
	if {$flag13_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB4�����ۣ�vplsΪelanҵ��rawģʽ����NE1($gpnIp1)ʹ��tracertroute�鿴���Ĵ�NE1��NE3������ÿһ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4�����ۣ�vplsΪelanҵ��rawģʽ����NE1($gpnIp1)ʹ��tracertroute�鿴���Ĵ�NE1��NE3������ÿһ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ����NE1($gpnIp1)ʹ��tracertroute�鿴���Ĵ�NE1��NE3������ÿһ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	foreach slot $rebootSlotlist1 {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource3
		set testFlag 0
		  for {set j 1} {$j<=$cnt} {incr j} {
			  if {![gwd::GWCard_AddReboot $telnet1 $matchType1 $Gpn_type1 $fileId $slot]} {
				after $rebootBoardTime
				if {[string match $mslot1 $slot]} {
					set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
					set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
				}
				incr capId
				if {[TestGPNEth1_repeat "��$j\������NE1($gpnIp1)$slot\��λ�忨" "GPN_PTN_015_$capId" $fileId $rateL $rateR 1]} {
					set  flag14_case1 1
				}
			} else {
				set testFlag 1
				gwd::GWpublic_print "OK" " NE1($gpnIp1)$slot\��λ�忨��֧�ְ忨������������������" $fileId
				break
			}
		}
		if {$testFlag == 0} {
			gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
			send_log "\n resource3:$resource3"
			send_log "\n resource4:$resource4"
			if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
				set flag14_case1 1
				gwd::GWpublic_print "NOK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
			}
		}
	}
	puts $fileId ""
	if {$flag14_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FB5�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	set expectTable "0000.0000.0002 ac1"
	set expectTable1 "0000.0000.0006 ac5"
	###��������NMS��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestGPNEth1_repeat "��$j\�� NE1($gpnIp1)����NMS����������" "GPN_PTN_015_$capId" $fileId $rateL $rateR 1]} {
				set  flag15_case1 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable $expectTable]} {
				set flag15_case1 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls11" dTable1
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable1 $expectTable1]} {
				set flag15_case1 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag 1
			break
		}
	}
	if {$testFlag == 0} {
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource6
	send_log "\n resource5:$resource5"
	send_log "\n resource6:$resource6"
	if {$resource6 > [expr $resource5 + $resource5 * $errRate]} {
		set flag15_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
	}
	}
	puts $fileId ""
	if {$flag15_case1 == 1} {
	set flagCase1 1
	 gwd::GWpublic_print "NOK" "FB6�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
	gwd::GWpublic_print "OK" "FB6�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	##��������SW��������
	set testFlag 0 ;#=1 ��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestGPNEth1_repeat "��$j\�� NE1($gpnIp1)����SW����������" "GPN_PTN_015_$capId" $fileId $rateL $rateR 1]} {
				set  flag16_case1 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����SW����������" $dTable $expectTable]} {
				set flag16_case1 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls11" dTable1
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable1 $expectTable1]} {
				set flag16_case1 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag 1 ;#=1 ��������
			break
		}
	}
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource8
		send_log "\n resource7:$resource7"
		send_log "\n resource8:$resource8"
		if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
			set flag16_case1	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag16_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FB7�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	##���������豸����
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[TestGPNEth1_repeat "��$j\�� NE1($gpnIp1)���б����豸������" "GPN_PTN_015_$capId" $fileId $rateL $rateR 1]} {
			set  flag17_case1 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
		if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)���б����豸������" $dTable $expectTable]} {
			set flag17_case1 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls11" dTable1
		if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable1 $expectTable1]} {
			set flag17_case1 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag17_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag17_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB8�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ��NE1($gpnIp1)$GPNTestEth5\ΪPORT����NE1��$GPNTestEth5\�ڷ���Э�鱨��  ���Կ�ʼ=====\n" 
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "false"
	set hProtocalStream1 [stc::create "StreamBlock" \
		-under $hGPNPort5 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:02</dstMac><etherType override="true" >8809</etherType><vlans name="anon_4503"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="proto1" pdu="custom:Custom"><pattern>0300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000</pattern></pdu></pdus></config></frame>} \
		-Name {EFM} ]
	
	set hProtocalStream2 [stc::create "StreamBlock" \
		-under $hGPNPort5 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:30</dstMac><etherType override="true" >8902</etherType><vlans name="anon_4508"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><checksum>14740</checksum><tosDiffserv name="anon_4511"><tos name="anon_4512"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {CFM} ]
	
	set hProtocalStream3 [stc::create "StreamBlock" \
		-under $hGPNPort5 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:0E</dstMac><etherType override="true" >88CC</etherType><vlans name="anon_4517"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><checksum>14740</checksum><tosDiffserv name="anon_4520"><tos name="anon_4521"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {LLDP} ]
	
	set hProtocalStream4 [stc::create "StreamBlock" \
		-under $hGPNPort5 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:02</dstMac><etherType override="true" >8809</etherType><vlans name="anon_4526"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="proto1" pdu="custom:Custom"><pattern>0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000</pattern></pdu></pdus></config></frame>} \
		-Name {LACP} ]
	
	set hProtocalStream5 [stc::create "StreamBlock" \
		-under $hGPNPort5 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:CD:00:00:01</dstMac><etherType override="true" >8903</etherType><vlans name="anon_4531"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><checksum>14740</checksum><tosDiffserv name="anon_4534"><tos name="anon_4535"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {MRPS} ]
	
	set hProtocalStream6 [stc::create "StreamBlock" \
		-under $hGPNPort5 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:02</dstMac><vlans name="anon_4540"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><protocol override="true" >17</protocol><checksum>14976</checksum><tosDiffserv name="anon_4543"><tos name="anon_4544"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {LDP} ]
	
	set hProtocalStream7 [stc::create "StreamBlock" \
		-under $hGPNPort5 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:14</dstMac><vlans name="anon_4549"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><checksum>14740</checksum><tosDiffserv name="anon_4552"><tos name="anon_4553"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {ISIS} ]
	
	set hProtocalStream8 [stc::create "StreamBlock" \
		-under $hGPNPort5 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:05</dstMac><vlans name="anon_4558"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><protocol override="true" >89</protocol><checksum>14904</checksum><tosDiffserv name="anon_4561"><tos name="anon_4562"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {OSPF} ]
	
	set hProtocalStream9 [stc::create "StreamBlock" \
		-under $hGPNPort5 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:09</dstMac><vlans name="anon_4567"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><protocol override="true" >17</protocol><checksum>14976</checksum><tosDiffserv name="anon_4570"><tos name="anon_4571"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {RIP} ]
	foreach stream "$hProtocalStream1 $hProtocalStream2 $hProtocalStream3 $hProtocalStream4 $hProtocalStream5 $hProtocalStream6 $hProtocalStream7 $hProtocalStream8 $hProtocalStream9" {
		stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 2 -LoadUnit MEGABITS_PER_SECOND
	}
	
	stc::perform streamBlockActivate \
		-streamBlockList "$hProtocalStream1 $hProtocalStream2 $hProtocalStream3 $hProtocalStream4 $hProtocalStream5 $hProtocalStream6 $hProtocalStream7 $hProtocalStream8 $hProtocalStream9" \
		-activate "false"
	stc::apply

	foreach stream "$hProtocalStream1 $hProtocalStream2 $hProtocalStream3 $hProtocalStream4 $hProtocalStream5 $hProtocalStream6 $hProtocalStream7 \
		$hProtocalStream8 $hProtocalStream9" printStr "EFM CFM LLDP LACP MRPS LDP ISIS OSPF RIP" {
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "true"
		stc::perform ResultsClearViewCommand -ResultList "[stc::get $hGPNPort2Ana -children-AnalyzerPortResults] [stc::get $hGPNPort5Gen -children-GeneratorPortResults]"
		gwd::Start_SendFlow $hGPNPort5Gen $hGPNPort2Ana
		after 20000
		gwd::Stop_SendFlow $hGPNPort5Gen $hGPNPort2Ana
		after 2000
		set rxCnt [stc::get $hGPNPort2Ana.AnalyzerPortResults -SigFrameCount]
		set txCnt [stc::get $hGPNPort5Gen.GeneratorPortResults -GeneratorSigFrameCount]
		if {[string match "EFM" $printStr] || [string match "LACP" $printStr]} {
			if {$rxCnt != 0} {
				set flag18_case1 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����$printStr\��Э�鱨������Ϊ2M ������$txCnt\��������Ӧ�����ˣ�NE3($gpnIp3)$GPNTestEth2\����ӦΪ0��ʵΪ$rxCnt\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����$printStr\��Э�鱨������Ϊ2M ������$txCnt\��������Ӧ�����ˣ�NE3($gpnIp3)$GPNTestEth2\����ӦΪ0��ʵΪ$rxCnt\��" $fileId
			}
		} else {
			if {$rxCnt != $txCnt} {
				set flag18_case1 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����$printStr\��Э�鱨������Ϊ2M ������$txCnt\����NE3($gpnIp3)$GPNTestEth2\����$rxCnt\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����$printStr\��Э�鱨������Ϊ2M ������$txCnt\����NE3($gpnIp3)$GPNTestEth2\����$rxCnt\��" $fileId
			}
		}
		
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "false"
	}
	puts $fileId ""
	if {$flag18_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB9�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)$GPNTestEth5\ΪPORT����NE1��$GPNTestEth5\�ڷ���Э�鱨��NE3($gpnIp3)$GPNTestEth2\�ڽ����ж���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)$GPNTestEth5\ΪPORT����NE1��$GPNTestEth5\�ڷ���Э�鱨��NE3($gpnIp3)$GPNTestEth2\�ڽ����޶���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��rawģʽ��NE1($gpnIp1)$GPNTestEth5\ΪPORT����NE1��$GPNTestEth5\�ڷ���Э�鱨��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase1 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 1���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 1���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 1 ELANҵ��VC-TYPE RAWģʽ������֤  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 ELANҵ��VC-TYPE TAGGEDģʽ������֤����\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
		NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth1\������������֤����ת��  ���Կ�ʼ=====\n"
        set flag1_case2 0
        set flag2_case2 0
        set flag3_case2 0
        set flag4_case2 0
        set flag5_case2 0
        set flag6_case2 0
        set flag7_case2 0
        set flag8_case2 0
        set flag9_case2 0
        set flag10_case2 0
        set flag11_case2 0
        set flag12_case2 0
        set flag13_case2 0
        set flag14_case2 0
        set flag15_case2 0
        set flag16_case2 0
        set flag17_case2 0
        set flag18_case2 0
	
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac2"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac3"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac4"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac5"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11"
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" 1 "elan" "flood" "false" "false" "false" "true" "2000" "" "tagged"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "1004" "1004" "" "add" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "modify" "50" "0" "0" "0x8100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac2" "vpls1" "" $GPNTestEth1 "100" "0" "none" "modify" "100" "0" "0" "0x9100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac3" "vpls1" "" $GPNTestEth5 "0" "0" "none" "delete" "1" "0" "0" "0x8100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac4" "vpls1" "" $GPNTestEth1 "80" "500" "none" "modify" "80" "0" "0" "0x8100" "evc2"
	
	gwd::GWPw_DelMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "pw23"
	gwd::GWPw_DelMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231"
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2  $fileId "pw21" "tagged"
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2  $fileId "pw23" "tagged"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "l2transport" "1" "" $address621 "1000" "1000" "1" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "l2transport" "3" "" $address623 "2000" "2000" "3" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWPw_AddMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "pw23"
	
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac2"
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac3"
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac5"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3"
	gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33"
	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3" 3 "elan" "flood" "false" "false" "false" "true" "2000" "" "tagged"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "2000" "2000" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "vpls3" "" $GPNTestEth3 "50" "0" "none" "modify" "50" "0" "0" "0x8100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac2" "vpls3" "" $GPNTestEth2 "0" "0" "none" "delete" "1" "0" "0" "0x8100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac3" "vpls3" "" $GPNTestEth3 "80" "500" "none" "modify" "80" "0" "0" "0x8100" "evc2"

	gwd::GWAc_DelActPw $telnet4 $matchType4 $Gpn_type4 $fileId "ac1"
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac1"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWPw_AddPwVcType $telnet4 $matchType4 $Gpn_type4  $fileId "pw41" "tagged"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "l2transport" "4" "" $address641 "1004" "1004" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_CfgAc $telnet4 $matchType4 $Gpn_type4 $fileId "ac1" "" $GPNTestEth4 0 0 "delete" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet4 $matchType4 $Gpn_type4 $fileId "ac1" "pw41" "eline14"
	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "true"
	incr capId
	if {[TestGPNEth1_repeat "" GPN_PTN_015_$capId $fileId $rateL $rateR 0]} {
		set flag2_case1 1
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC1�����ۣ�vplsΪelanҵ��taggedģʽ NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
					NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth1\������������֤����ת��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1�����ۣ�vplsΪelanҵ��taggedģʽNE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
					NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth1\������������֤����ת��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN $GPNTestEth2\ΪPORT��\
				NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth1\������������֤����ת��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1(PORT+VLAN)--NE3(PORT+VLAN)����NE1($gpnIp1)��NE3($gpnIp3)��NE1 NNI��$GPNPort5\��egress���򣬼��ҵ��vlan��tag��ǩ�Ƿ�ȥ��  ���Կ�ʼ=====\n"
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "true"
	
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "VLAN TAG" -Offset 44]
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 5000
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
	}
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_015_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_015_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort5Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	if {$GPNPort5Cnt1(cnt2) == 0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��AC1��NE3($gpnIp3)$GPNTestEth3\��AC1����tag=50����֪����������������NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩ��ȥ��" $fileId
	} else {
		if {$GPNPort5Cnt1(cnt2) < $rateL1 || $GPNPort5Cnt1(cnt2) > $rateR1} {
			set flag2_case2 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��AC1��NE3($gpnIp3)$GPNTestEth3\��AC1����tag=50����֪����������������NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩû�б�ȥ��\
				��������ΪGPNPort5Cnt1(cnt2)��û��$rateL1-$rateR1\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��AC1��NE3($gpnIp3)$GPNTestEth3\��AC1����tag=50����֪����������������NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩû�б�ȥ��\
				����Ϊ$GPNPort5Cnt1(cnt2)����$rateL1-$rateR1\��Χ��" $fileId
		}
	}
	puts $fileId ""
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC2�����ۣ�vplsΪelanҵ��taggedģʽNE1(PORT+VLAN)--NE3(PORT+VLAN)����NE1��NE3($gpnIp3)��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩ��ȥ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2�����ۣ�vplsΪelanҵ��taggedģʽNE1(PORT+VLAN)--NE3(PORT+VLAN)����NE1��NE3($gpnIp3)��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩ����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1(PORT+VLAN)--NE3(PORT+VLAN)����NE1($gpnIp1)��NE3($gpnIp3)��NE1 NNI��$GPNPort5\��egress���򣬼��ҵ��vlan��tag��ǩ�Ƿ�ȥ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
		NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth5\������������֤����ת��  ���Կ�ʼ=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5

	stc::delete $hfilter16BitFilAna2
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort5Stream1 $hGPNPort5Stream2" \
		-activate "true"
	stc::apply
	#ͨ���˿�up down�Ĳ�����վ�����ѧϰ��mac��ַ
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "undo shutdown"
	
	incr capId
	if {[TestGPNEth5_repeat "GPN_PTN_015_$capId" "GPN_PTN_015_[expr $capId + 1]" $fileId $rateL $rateR]} {
		set flag3_case2 1
	}
	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FC3�����ۣ�vplsΪelanҵ��taggedģʽ NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
					NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth5\������������֤����ת��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3�����ۣ�vplsΪelanҵ��taggedģʽNE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
					NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth5\������������֤����ת��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\
				NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth5\������������֤����ת��  ���Խ���=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList2" \
		-activate "true"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1(PORT)--NE4(PORT)����NE1($gpnIp1)��NE4($gpnIp4)��NE1 NNI��$GPNPort12\��egress���򣬼��ҵ���������Ƿ������һ��tag��ǩ  ���Կ�ʼ=====\n"
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	stc::delete $hfilter16BitFilAna3
	stc::delete $hfilter16BitFilAna4
	stc::delete $hfilter16BitFilAna5
	stc::delete $hfilter16BitFilAna6
	array set aMirror "dir1 egress port1 $GPNPort12 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 aMirror
	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList2" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort5Stream1 $hGPNPort4Stream3" \
		-activate "true"
	
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg0
	set hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $hGPNPort1Ana -FilterName "VLAN TAG" -Offset 44]
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$hGPNPort5Gen $hGPNPort4Gen"  $hGPNPort1Ana
	after 5000
	gwd::Stop_SendFlow "$hGPNPort5Gen $hGPNPort4Gen"  $hGPNPort1Ana
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort1Cap $hGPNPort1CapAnalyzer
	}
	gwd::Start_SendFlow "$hGPNPort5Gen $hGPNPort4Gen"  $hGPNPort1Ana
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort1Cap 1 "GPN_PTN_015_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_015_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort1Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 3 $hGPNPort1Ana GPNPort1Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort1Cnt1
	gwd::Stop_SendFlow "$hGPNPort5Gen $hGPNPort4Gen"  $hGPNPort1Ana
	if {$GPNPort1Cnt1(cnt4) == 0} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\��NE4($gpnIp4)$GPNTestEth4\����untag����֪����������������NE1��NE4��NE1 NNI��$GPNPort12\��egress����û�д���ҵ��vlan tag=1�ı�ǩ" $fileId
	} else {
		if {$GPNPort1Cnt1(cnt4) < $rateL1 || $GPNPort1Cnt1(cnt4) > $rateR1} {
			set flag4_case2 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\��NE4($gpnIp4)$GPNTestEth4\����untag����֪����������������NE1��NE4��NE1 NNI��$GPNPort12\��egress���򣬴���ҵ��vlan tag=1�ı�ǩ\
				��������ΪGPNPort1Cnt1(cnt4)��û��$rateL1-$rateR1\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\��NE4($gpnIp4)$GPNTestEth4\����untag����֪����������������NE1��NE4��NE1 NNI��$GPNPort12\��egress���򣬴���ҵ��vlan tag=1�ı�ǩ\
				����Ϊ$GPNPort1Cnt1(cnt4)����$rateL1-$rateR1\��Χ��" $fileId
		}
	}
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC4�����ۣ�vplsΪelanҵ��taggedģʽ����NE1(PORT)--NE4(PORT)NE1($gpnIp1)��NE4($gpnIp4)��NE1 NNI��$GPNPort12\��egress���򣬷���untag������û�����tag=1�ı�ǩ" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4�����ۣ�vplsΪelanҵ��taggedģʽ����NE1(PORT)--NE4(PORT)NE1($gpnIp1)��NE4($gpnIp4)��NE1 NNI��$GPNPort12\��egress���򣬷���untag�����������tag=1�ı�ǩ" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1(PORT)--NE4(PORT)����NE1($gpnIp1)��NE4($gpnIp4)��NE1 NNI��$GPNPort12\��egress���򣬼��ҵ���������Ƿ������һ��tag��ǩ  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)$GPNTestEth1\ΪPORT+SVLAN+CVLAN��NE3($gpnIp3)$GPNTestEth3\ΪPORT+SVLAN+CVLAN��������������֤����ת��  ���Կ�ʼ=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1
	stc::delete $hfilter16BitFilAna1
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort5Stream1 $hGPNPort4Stream3" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList3" \
		-activate "true"
	#ͨ���˿�up down�Ĳ�����վ�����ѧϰ��mac��ַ
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort11 "shutdown"
	gwd::GWpublic_CfgPortState $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort11 "undo shutdown"
		
	#NE1 GPNTestEth1�� NE3 GPNTestEth3�����ڲ�500���80��δ֪����
	SendAndStat_ptn014 1 "$::hGPNPort1Gen $::hGPNPort3Gen" "$::hGPNPort1Ana $::hGPNPort3Ana" "$GPNTestEth1 $GPNTestEth3" "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3" "$hGPNPort1AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil" GPNPort1Cnt6 GPNPort3Cnt6 aTmp1 aTmp2 aTmp3\
		6 $::anaFliFrameCfg6 "GPN_PTN_015_$capId"
		
	if {$GPNPort3Cnt6(cnt10) < $rateL || $GPNPort3Cnt6(cnt10) > $rateR} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\�����ڲ�tag=500���tag=80��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ��ڲ�tag=500���tag=80��������������Ϊ$GPNPort3Cnt6(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\�����ڲ�tag=500���tag=80��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ��ڲ�tag=500���tag=80��������������Ϊ$GPNPort3Cnt6(cnt10)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt6(cnt11) < $rateL || $GPNPort1Cnt6(cnt11) > $rateR} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\�����ڲ�tag=500���tag=80��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ��ڲ�tag=500���tag=80��������������Ϊ$GPNPort1Cnt6(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\�����ڲ�tag=500���tag=80��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ��ڲ�tag=500���tag=80��������������Ϊ$GPNPort1Cnt6(cnt11)����$rateL-$rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag5_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC5�����ۣ�vplsΪelanҵ��taggedģʽNE1($gpnIp1)$GPNTestEth1\ΪPORT+SVLAN+CVLAN��NE3($gpnIp3)$GPNTestEth3\ΪPORT+SVLAN+CVLAN��������������֤����ת��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5�����ۣ�vplsΪelanҵ��taggedģʽNE1($gpnIp1)$GPNTestEth1\ΪPORT+SVLAN+CVLAN��NE3($gpnIp3)$GPNTestEth3\ΪPORT+SVLAN+CVLAN��������������֤����ת��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)$GPNTestEth1\ΪPORT+SVLAN+CVLAN��NE3($gpnIp3)$GPNTestEth3\ΪPORT+SVLAN+CVLAN��������������֤����ת��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE4($gpnIp4)��vpwsҵ�� $GPNTestEth4\ΪPORTģʽ��NE1($gpnIp1)��vplsҵ��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORTģʽ��NE4��$GPNTestEth4\������������֤����ת��  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList3" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort4Stream1" \
		-activate "true"
	SendAndStat_ptn014 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 GPNPort5Cnt1\
		1 $::anaFliFrameCfg1 "GPN_PTN_015_$capId"
	SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
        	$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
        	$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 GPNPort5Cnt7\
        	7 $::anaFliFrameCfg7 "GPN_PTN_015_$capId"
	#NE1 GPNTestEth1�Ľ���
	if {$GPNPort1Cnt1(cnt1) < $rateL || $GPNPort1Cnt1(cnt1) > $rateR} {
        	set flag6_case2 1
        	gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=50��������������Ϊ$GPNPort1Cnt1(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=50��������������Ϊ$GPNPort1Cnt1(cnt1)����$rateL-$rateR\��Χ��" $fileId
	} 
	if {$GPNPort1Cnt1(cnt10) < $rateL || $GPNPort1Cnt1(cnt10) > $rateR} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=80��������������Ϊ$GPNPort1Cnt1(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=80��������������Ϊ$GPNPort1Cnt1(cnt10)����$rateL-$rateR\��Χ��" $fileId
	} 
	if {$GPNPort1Cnt1(cnt11) < $rateL || $GPNPort1Cnt1(cnt11) > $rateR} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt11)����$rateL-$rateR\��Χ��" $fileId
	}
	#NE1 GPNTestEth5�Ľ���
	if {$GPNPort5Cnt7(cnt1) < $rateL || $GPNPort5Cnt7(cnt1) > $rateR} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth5\�յ�untag��������������Ϊ$GPNPort5Cnt7(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth5\�յ�untag��������������Ϊ$GPNPort5Cnt7(cnt1)����$rateL-$rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag6_case2 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FC6�����ۣ�NE4($gpnIp4)��vpwsҵ��taggedģʽ $GPNTestEth4\ΪPORTģʽ��NE1($gpnIp1)��vplsҵ��taggedģʽ$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORTģʽ��NE4��$GPNTestEth4\������������֤����ת��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6�����ۣ�NE4($gpnIp4)��vpwsҵ��taggedģʽ $GPNTestEth4\ΪPORTģʽ��NE1($gpnIp1)��vplsҵ��taggedģʽ$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORTģʽ��NE4��$GPNTestEth4\������������֤����ת��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE4($gpnIp4)��vpwsҵ�� $GPNTestEth4\ΪPORTģʽ��NE1($gpnIp1)��vplsҵ��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORTģʽ��NE4��$GPNTestEth4\������������֤����ת��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw����Ϊmodify��nochange��delete����֤ϵͳ�Ƿ���ʾ�������޸�Ϊadd  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	set ret [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "modify" "none" 1 0 "0x8100" "0x8100" "2"]
	if {$ret == 0} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw12 VLAN����Ϊmodify�����óɹ�����ʾ" $fileId
	} elseif {$ret == 3} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw12 VLAN����Ϊmodify����ʾ�������޸�Ϊadd" $fileId
	} else {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw12 VLAN����Ϊmodify������ʧ����ϵͳ��ʾ����" $fileId
	}
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	
	set ret [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"]
	if {$ret == 0} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw12 VLAN����Ϊnochange�����óɹ�����ʾ" $fileId
	} elseif {$ret == 3} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw12 VLAN����Ϊnochange����ʾ�������޸�Ϊadd" $fileId
	} else {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw12 VLAN����Ϊnochange������ʧ����ϵͳ��ʾ����" $fileId
	}
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	
	set ret [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"]
	if {$ret == 0} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw12 VLAN����Ϊdelete�����óɹ�����ʾ" $fileId
	} elseif {$ret == 3} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw12 VLAN����Ϊdelete����ʾ�������޸�Ϊadd" $fileId
	} else {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw12 VLAN����Ϊdelete������ʧ����ϵͳ��ʾ����" $fileId
	}
	puts $fileId ""
	if {$flag7_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC7�����ۣ�NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw����Ϊmodify��nochange��delete��ϵͳ�޴�����ʾ����ʾ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7�����ۣ�NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw����Ϊmodify��nochange��delete��ϵͳ��ʾ�������޸�Ϊadd" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw����Ϊmodify��nochange��delete����֤ϵͳ�Ƿ���ʾ�������޸�Ϊadd  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add����֤ϵͳ�Ƿ���ʾ�������޸�Ϊmodify  ���Կ�ʼ=====\n"
	set ret [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "delete" "50" "0" "0" "0x8100" "evc2"]
	if {$ret == 0} {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊdelete�����óɹ�����ʾ" $fileId
	} elseif {$ret == 2} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊdelete����ʾ�������޸�Ϊmodify" $fileId
	} else {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊdelete������ʧ����ϵͳ��ʾ����" $fileId
	}
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	
	set ret [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "nochange" "50" "0" "0" "0x8100" "evc2"]
	if {$ret == 0} {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊnochange�����óɹ�����ʾ" $fileId
	} elseif {$ret == 2} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊnochange����ʾ�������޸�Ϊmodify" $fileId
	} else {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊnochange������ʧ����ϵͳ��ʾ����" $fileId
	}
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	
	set ret [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "add" "50" "0" "0" "0x8100" "evc2"]
	if {$ret == 0} {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊadd�����óɹ�����ʾ" $fileId
	} elseif {$ret == 2} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊadd����ʾ�������޸�Ϊmodify" $fileId
	} else {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac1 VLAN����Ϊadd������ʧ����ϵͳ��ʾ����" $fileId
	}
	puts $fileId ""
	if {$flag8_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC8�����ۣ�NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add��ϵͳ�޴�����ʾ����ʾ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8�����ۣ�NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add��ϵͳ��ʾ�������޸�Ϊmodify" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add����֤ϵͳ�Ƿ���ʾ�������޸�Ϊmodify  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬷�����֤�����Ƿ���Ч  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort4Stream1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "true"
	if {($flag7_case2 == 0) && ($flag8_case2 == 0)} {
		incr capId
		if {[TestGPNEth1_repeat "" GPN_PTN_015_$capId $fileId $rateL $rateR 0]} {
			set flag9_case2 1
		}
	} else {
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "modify" "50" "0" "0" "0x8100" "evc2"
		if {$flag7_case2 == 1} {
			set flag9_case2 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������pw����Ϊmodify��nochange��delete��ϵͳû���Զ��޸Ķ���Ϊadd����������޷�����" $fileId
		} elseif {$flag8_case2 == 1} {
			set flag9_case2 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add��ϵͳû���Զ��޸Ķ���Ϊmodify����������޷�����" $fileId	
		}
	}
	puts $fileId ""
	if {$flag9_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC9�����ۣ�NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬷�����֤����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC9�����ۣ�NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬷�����֤����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬷�����֤�����Ƿ���Ч  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬾���NE1��NE3��NE1 NNI��$GPNPort5\��egress���򣬼��ҵ��vlan��tag��ǩ�Ƿ�ȥ��  ���Կ�ʼ=====\n"
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "VLAN TAG" -Offset 44]
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "true"
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 5000
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 2000
	Recustomization 1 1 1 1 1 0
	if {($flag7_case2 == 0) && ($flag8_case2 == 0)} {
		if {$cap_enable} {
			gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
		}
		gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
		after 10000
		incr capId
		if {$cap_enable} {
			gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_015_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
		}
		gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_015_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
		array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 1 1 1 1 1 0
			after 5000
		}
		
		
		parray GPNPort5Cnt1
		gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
		if {$GPNPort5Cnt1(cnt2) == 0} {
			set flag10_case2 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��AC1��NE3($gpnIp3)$GPNTestEth3\��AC1����tag=50����֪����������������NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩ��ȥ��" $fileId
		} else {
			if {$GPNPort5Cnt1(cnt2) < $rateL1 || $GPNPort5Cnt1(cnt2) > $rateR1} {
				set flag10_case2 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��AC1��NE3($gpnIp3)$GPNTestEth3\��AC1����tag=50����֪����������������NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩû�б�ȥ��\
					��������ΪGPNPort5Cnt1(cnt2)��û��$rateL1-$rateR1\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��AC1��NE3($gpnIp3)$GPNTestEth3\��AC1����tag=50����֪����������������NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩû�б�ȥ��\
					����Ϊ$GPNPort5Cnt1(cnt2)����$rateL1-$rateR1\��Χ��" $fileId
			}
		}
	} else {
		if {$flag7_case2 == 1} {
			set flag10_case2 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������pw����Ϊmodify��nochange��delete��ϵͳû���Զ��޸Ķ���Ϊadd����������޷�����" $fileId
		} elseif {$flag8_case2 == 1} {
			set flag10_case2 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add��ϵͳû���Զ��޸Ķ���Ϊmodify����������޷�����" $fileId	
		}
	}
	puts $fileId ""
	if {$flag10_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FD1�����ۣ�NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬾���NE1��NE3��NE1 NNI��$GPNPort5\��egress���򣬼��ҵ��vlan��tag��ǩ��ȥ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD1�����ۣ�NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬾���NE1��NE3��NE1 NNI��$GPNPort5\��egress���򣬼��ҵ��vlan��tag��ǩû�б仯" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬾���NE1��NE3��NE1 NNI��$GPNPort5\��egress���򣬼��ҵ��vlan��tag��ǩ�Ƿ�ȥ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)֮��������һ��ҵ����NE3��pw�����û��أ����Ի����������Ͷ�����ҵ���Ӱ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::delete $hfilter16BitFilAna2
	
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "undo shutdown"
	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream6" \
		-activate "true"
	stc::apply
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "modify" "50" "0" "0" "0x8100" "evc2"
	###NE1-NE3֮��������һ��ҵ�񣬹���ͬһ��lsp
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11" 11 "elan" "flood" "false" "false" "false" "true" "2000" "" "tagged"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121" "vpls" "vpls11" "peer" $address612 "1001" "1001" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "60" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac5" "vpls11" "" $GPNTestEth1 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "l2transport" "11" "" $address621 "1001" "1001" "1" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231" "l2transport" "31" "" $address623 "2001" "2001" "3" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWPw_AddMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"

	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33" 33 "elan" "flood" "false" "false" "false" "true" "2000" "" "tagged"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321" "vpls" "vpls33" "peer" $address632 "2001" "2001" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "60" $GPNTestEth3
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac5" "vpls33" "" $GPNTestEth3 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	
	gwd::GWpublic_addPwLoop $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	#����GPNTestEth1��û���յ�NE3���ص�����------
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg1
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$hGPNPort1Gen"  $hGPNPort1Ana
	after 5000
	gwd::Stop_SendFlow "$hGPNPort1Gen"  $hGPNPort1Ana
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort1Cap $hGPNPort1CapAnalyzer
	}
	gwd::Start_SendFlow "$hGPNPort1Gen"  $hGPNPort1Ana
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort1Cap 1 "GPN_PTN_015_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_015_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort1Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 1 $hGPNPort1Ana GPNPort1Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort1Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen"  $hGPNPort1Ana
	if {$GPNPort1Cnt1(cnt7) < $rateL || $GPNPort1Cnt1(cnt7) > $rateR} {
        	set flag11_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=60��δ֪������������NE3($gpnIp3)��pw��������\
			NE1 $GPNTestEth1\�յ�tag=60��������������Ϊ$GPNPort1Cnt1(cnt7)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=60��δ֪������������NE3($gpnIp3)��pw��������\
			NE1 $GPNTestEth1\�յ�tag=60��������������Ϊ$GPNPort1Cnt1(cnt7)����$rateL-$rateR\��Χ��" $fileId
	}
	#------����GPNTestEth1��û���յ�NE3���ص�����
	#���Ի������ݵ�mac��ַ��û�б�����------
	array set aMirror "dir1 ingress port1 $GPNPort5 dir2 egress port2 $GPNPort5"
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg51
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$hGPNPort1Gen"  "$hGPNPort5Ana"
	after 5000
	gwd::Stop_SendFlow "$hGPNPort1Gen"  "$hGPNPort5Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer 
	}
	gwd::Start_SendFlow "$hGPNPort1Gen"  "$hGPNPort5Ana"
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_015_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap"
	}
	array set aGPNPort5Cnt1 {cnt3 0 cnt4 0} 
	
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 2 $hGPNPort5Ana aGPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	parray aGPNPort5Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen"  "$hGPNPort5Ana"
	if {$aGPNPort5Cnt1(cnt3) < $rateL1 || $aGPNPort5Cnt1(cnt3) > $rateR1} {
		set flag11_case2 1
		gwd::GWpublic_print "NOK" "vplsΪelanҵ��taggedģʽ��NE3�������ݻ��أ���NE1���ͱ��ģ�����NE1 NNI�ĳ������ģ�macû�б�����" $fileId
	} else {
		gwd::GWpublic_print "OK" "vplsΪelanҵ��taggedģʽ��NE3�������ݻ��أ���NE1���ͱ��ģ�����NE1 NNI�ĳ������ģ�mac������" $fileId
	}
	if {$aGPNPort5Cnt1(cnt4) < $rateL1 || $aGPNPort5Cnt1(cnt4) > $rateR1} {
		set flag11_case2 1
		gwd::GWpublic_print "NOK" "vplsΪelanҵ��taggedģʽ��NE3�������ݻ��أ���NE1���ͱ��ģ�����NE1 NNI���뷽���ģ�macû�б�����" $fileId
	} else {
		gwd::GWpublic_print "OK" "vplsΪelanҵ��taggedģʽ��NE3�������ݻ��أ���NE1���ͱ��ģ�����NE1 NNI���뷽���ģ�mac������" $fileId
	}
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	#------���Ի������ݵ�mac��ַ��û�б�����
	#������ҵ���Ӱ��------
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "true"
	incr capId
	if {[TestGPNEth1_repeat "" GPN_PTN_015_$capId $fileId $rateL $rateR 0]} {
		set flag11_case2 1
	}
	#------������ҵ���Ӱ��
	puts $fileId ""
	if {$flag11_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FD2�����ۣ�vplsΪelanҵ��taggedģʽNE1($gpnIp1)-NE3($gpnIp3)֮��������һ��ҵ����NE3��pw�����û��أ����Ի����������Ͷ�����ҵ���Ӱ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD2�����ۣ�vplsΪelanҵ��taggedģʽNE1($gpnIp1)-NE3($gpnIp3)֮��������һ��ҵ����NE3��pw�����û��أ����Ի����������Ͷ�����ҵ���Ӱ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)֮��������һ��ҵ����NE3��pw�����û��أ����Ի����������Ͷ�����ҵ���Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��ping pw12  ���Կ�ʼ=====\n"
	gwd::GWpublic_delPwLoop $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	gwd::GWpublic_addPwPing $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" value
	if {![dict get $value sucRate]==100.00} {
		set flag12_case2 1 
		gwd::GWpublic_print "NOK"  "vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��ping pw12 pingͨ���Ԥ��Ϊ100.00% ʵΪ[dict get $value sucRate]%" $fileId
	} else {
		gwd::GWpublic_print "OK"  "vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��ping pw12 pingͨ���Ԥ��Ϊ100.00% ʵΪ[dict get $value sucRate]%" $fileId
	}
	if {[string match [dict get $value replyIp] "20.6.5.2"]} {
		gwd::GWpublic_print "OK" "vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��ping pw12��reply from ��ipӦΪ20.6.5.2ʵΪ[dict get $value replyIp]" $fileId
	} else {
		set flag12_case2 1
		gwd::GWpublic_print "NOK" "vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��ping pw12��reply from ��ipӦΪ20.6.5.2ʵΪ[dict get $value replyIp]" $fileId
	}
	puts $fileId ""
	if {$flag12_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FD3�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��ping pw12 pingͨ���Ԥ��Ϊ100.00% ʵΪ[dict get $value sucRate]%" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD3�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��ping pw12 pingͨ���Ԥ��Ϊ100.00% ʵΪ[dict get $value sucRate]%" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��ping pw12  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ����NE1($gpnIp1)ʹ��tracertroute�鿴���Ĵ�NE1��NE3������ÿһ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_addPwTrace $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" result
	set flag13_case2 [Check_Tracertroute "" $expectTrace $result]
	if {$flag13_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FD4�����ۣ�vplsΪelanҵ��taggedģʽ����NE1($gpnIp1)ʹ��tracertroute�鿴���Ĵ�NE1��NE3������ÿһ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD4�����ۣ�vplsΪelanҵ��taggedģʽ����NE1($gpnIp1)ʹ��tracertroute�鿴���Ĵ�NE1��NE3������ÿһ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ����NE1($gpnIp1)ʹ��tracertroute�鿴���Ĵ�NE1��NE3������ÿһ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	foreach slot $rebootSlotlist1 {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource3
		set testFlag 0
		  for {set j 1} {$j<=$cnt} {incr j} {
			  if {![gwd::GWCard_AddReboot $telnet1 $matchType1 $Gpn_type1 $fileId $slot]} {
				after $rebootBoardTime
				if {[string match $mslot1 $slot]} {
					set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
					set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
				}
				incr capId
				if {[TestGPNEth1_repeat "��$j\������NE1($gpnIp1)$slot\��λ�忨" "GPN_PTN_015_$capId" $fileId $rateL $rateR 1]} {
					set  flag14_case2 1
				}
			} else {
				set testFlag 1
				gwd::GWpublic_print "OK" " NE1($gpnIp1)$slot\��λ�忨��֧�ְ忨������������������" $fileId
				break
			}
		}
		if {$testFlag == 0} {
			gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
			send_log "\n resource3:$resource3"
			send_log "\n resource4:$resource4"
			if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
				set flag14_case2 1
				gwd::GWpublic_print "NOK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
			}
		}
	}
	puts $fileId ""
	if {$flag14_case2 == 1} {
		set flagCase2 1
		 gwd::GWpublic_print "NOK" "FD5�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD5�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	set expectTable "0000.0000.0002 ac1"
	set expectTable1 "0000.0000.0006 ac5"
	###��������NMS��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestGPNEth1_repeat "��$j\�� NE1($gpnIp1)����NMS����������" "GPN_PTN_015_$capId" $fileId $rateL $rateR 1]} {
				set  flag15_case2 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable $expectTable]} {
				set flag15_case2 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls11" dTable1
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable1 $expectTable1]} {
				set flag15_case2 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag 1
			break
		}
	}
	if {$testFlag == 0} {
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource6
	send_log "\n resource5:$resource5"
	send_log "\n resource6:$resource6"
	if {$resource6 > [expr $resource5 + $resource5 * $errRate]} {
		set flag15_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
	}
	}
	puts $fileId ""
	if {$flag15_case2 == 1} {
	set flagCase2 1
	 gwd::GWpublic_print "NOK" "FD6�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
	gwd::GWpublic_print "OK" "FD6�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	##��������SW��������
	set testFlag 0 ;#=1 ��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestGPNEth1_repeat "��$j\�� NE1($gpnIp1)����SW����������" "GPN_PTN_015_$capId" $fileId $rateL $rateR 1]} {
				set  flag16_case2 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����SW����������" $dTable $expectTable]} {
				set flag16_case2 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls11" dTable1
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable1 $expectTable1]} {
				set flag16_case2 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag 1 ;#=1 ��������
			break
		}
	}
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource8
		send_log "\n resource7:$resource7"
		send_log "\n resource8:$resource8"
		if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
			set flag16_case2	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag16_case2 == 1} {
		set flagCase2 1
		 gwd::GWpublic_print "NOK" "FD7�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD7�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	##���������豸����
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[TestGPNEth1_repeat "��$j\�� NE1($gpnIp1)���б����豸������" "GPN_PTN_015_$capId" $fileId $rateL $rateR 1]} {
			set  flag17_case2 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
		if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)���б����豸������" $dTable $expectTable]} {
			set flag17_case2 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls11" dTable1
		if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable1 $expectTable1]} {
			set flag17_case2 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag17_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag17_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FD8�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD8�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)$GPNTestEth5\ΪPORT����NE1��$GPNTestEth5\�ڷ���Э�鱨��  ���Կ�ʼ=====\n" 
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "false"

	foreach stream "$hProtocalStream1 $hProtocalStream2 $hProtocalStream3 $hProtocalStream4 $hProtocalStream5 $hProtocalStream6 $hProtocalStream7 \
		$hProtocalStream8 $hProtocalStream9" printStr "EFM CFM LLDP LACP MRPS LDP ISIS OSPF RIP" {
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "true"
		stc::perform ResultsClearViewCommand -ResultList "[stc::get $hGPNPort2Ana -children-AnalyzerPortResults] [stc::get $hGPNPort5Gen -children-GeneratorPortResults]"
		gwd::Start_SendFlow $hGPNPort5Gen $hGPNPort2Ana
		after 20000
		gwd::Stop_SendFlow $hGPNPort5Gen $hGPNPort2Ana
		after 2000
		set rxCnt [stc::get $hGPNPort2Ana.AnalyzerPortResults -SigFrameCount]
		set txCnt [stc::get $hGPNPort5Gen.GeneratorPortResults -GeneratorSigFrameCount]
		if {[string match "EFM" $printStr] || [string match "LACP" $printStr]} {
			if {$rxCnt != 0} {
				set flag18_case2 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����$printStr\��Э�鱨������Ϊ2M ������$txCnt\��������Ӧ�����ˣ�NE3($gpnIp3)$GPNTestEth2\����ӦΪ0��ʵ��Ϊ$rxCnt\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����$printStr\��Э�鱨������Ϊ2M ������$txCnt\��������Ӧ�����ˣ�NE3($gpnIp3)$GPNTestEth2\����ӦΪ0��ʵ��Ϊ$rxCnt\��" $fileId
			}
		} else {
			if {$rxCnt != $txCnt} {
				set flag18_case2 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth5\����$printStr\��Э�鱨������Ϊ2M ������$txCnt\����NE3($gpnIp3)$GPNTestEth2\����$rxCnt\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth5\����$printStr\��Э�鱨������Ϊ2M ������$txCnt\����NE3($gpnIp3)$GPNTestEth2\����$rxCnt\��" $fileId
			}
		}
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "false"
	}
	puts $fileId ""
	if {$flag18_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FD9�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)$GPNTestEth5\ΪPORT����NE1��$GPNTestEth5\�ڷ���Э�鱨��NE3($gpnIp3)$GPNTestEth2\�ڽ����ж���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD9�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)$GPNTestEth5\ΪPORT����NE1��$GPNTestEth5\�ڷ���Э�鱨��NE3($gpnIp3)$GPNTestEth2\�ڽ����޶���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)$GPNTestEth5\ΪPORT����NE1��$GPNTestEth5\�ڷ���Э�鱨��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_015_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_015" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase2 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 2���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 2���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 2 ELANҵ��VC-TYPE taggedģʽ������֤  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===�ָ���ʼ������...\n"
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"]
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac2"]
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac3"]
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac4"]
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac5"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.50 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.60 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.80 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.100 $matchType1 $Gpn_type1 $telnet1]
	if {[string match "L2" $Worklevel]} {
		lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth5.2000 $matchType1 $Gpn_type1 $telnet1]
	}
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort5.4 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort12.7 $matchType1 $Gpn_type1 $telnet1]
	
	lappend flagDel [gwd::GWPw_DelMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "pw23"]
	lappend flagDel [gwd::GWPw_DelMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort6.4 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort7.5 $matchType2 $Gpn_type2 $telnet2]
	
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac2"]
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac3"]
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac5"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.50 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.60 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.80 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort8.5 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort9.6 $matchType3 $Gpn_type3 $telnet3]	
	
	lappend flagDel [gwd::GWAc_DelActPw $telnet4 $matchType4 $Gpn_type4 $fileId "ac1"]
	lappend flagDel [gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac1"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort10.6 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort11.7 $matchType4 $Gpn_type4 $telnet4]

	if {[string match "L2" $Worklevel]} {
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort7 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort9 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort10 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort11 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 "enable"]
		lappend flagDel [gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth2 "enable"]
		lappend flagDel [gwd::GWpublic_CfgVlanCheck $telnet4 $matchType4 $Gpn_type4 $fileId $GPNTestEth4 "enable"]
	}
	
	if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
		foreach port1 $portList11 {
			lappend flagDel [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port1 "enable" "disable"]
		}
		foreach port2 $portList22 {
			lappend flagDel [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port2 "enable" "disable"]
		}
		foreach port3 $portList33 {
			lappend flagDel [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port3 "enable" "disable"]
		}
		foreach port4 $portList44 {
			lappend flagDel [gwd::GWL2_AddPort $telnet4 $matchType4 $Gpn_type4 $fileId $port4 "enable" "disable"]
		}
	} 
	
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_015"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_015"
	
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_015����Ŀ�ģ�E-LAN raw��taggedģʽ����\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1 == 1 || $flagCase2 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_015���Խ��" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2���Խ��" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��rawģʽ NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN \
		$GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth1\������������֤����ת��" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��rawģʽ����NE1��NE3($gpnIp3)��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩ[expr {($flag2_case1 == 1) ? "û��" : ""}]��ȥ��" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��rawģʽ NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN \
		$GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth5\������������֤����ת��" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��rawģʽ����NE1($gpnIp1)��NE4($gpnIp4)��NE1 NNI��$GPNPort12\��egress����ҵ��vlan��tag��ǩ[expr {($flag4_case1 == 1) ? "û��" : ""}]��ȥ��" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��rawģʽNE1($gpnIp1)$GPNTestEth1\ΪPORT+SVLAN+CVLAN��NE3($gpnIp3)$GPNTestEth3\ΪPORT+SVLAN+CVLAN��������������֤����ת��" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE4($gpnIp4)��vpwsҵ��rawģʽ $GPNTestEth4\ΪPORTģʽ��NE1($gpnIp1)��vplsҵ��rawģʽ$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORTģʽ��NE4��$GPNTestEth4\������������֤����ת��" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag7_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)vplsΪelanҵ��rawģʽ������pw����Ϊmodify��nochange��add��[expr {($flag7_case1 == 1) ? "ϵͳ�޴�����ʾ����ʾ����" : "ϵͳ��ʾ�������޸�Ϊdelete"}]" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag8_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add��[expr {($flag8_case1 == 1) ? "ϵͳ�޴�����ʾ����ʾ����" : "ϵͳ��ʾ�������޸�Ϊmodify"}]" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag9_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬷�����֤����" $fileId
	gwd::GWpublic_print "== FB1 == [expr {($flag10_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)vplsΪelanҵ��rawģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬾���NE1��NE3��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩ[expr {($flag10_case1 == 1) ? "û��" : ""}]��ȥ��" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag11_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��rawģʽNE1($gpnIp1)-NE3($gpnIp3)֮��������һ��ҵ����NE3��pw�����û��أ����Ի����������Ͷ�����ҵ���Ӱ��" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag12_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��ping pw12 pingͨ���Ԥ��Ϊ100% ʵΪ$value" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag13_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��rawģʽ����NE1($gpnIp1)ʹ��tracertroute�鿴���Ĵ�NE1��NE3������ÿһ��" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag14_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag15_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag16_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag17_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag18_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��rawģʽ��NE1($gpnIp1)$GPNTestEth5\ΪPORT+VLAN����NE1��$GPNTestEth5\�ڷ���Э�鱨��NE3($gpnIp3)$GPNTestEth2\�ڽ���[expr {($flag18_case1 == 1) ? "��" : "��"}]����" $fileId
	gwd::GWpublic_print "== FC1 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��taggedģʽ NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN \
        	$GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��\NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth1\������������֤����ת��" $fileId
        gwd::GWpublic_print "== FC2 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��taggedģʽNE1(PORT+VLAN)--NE3(PORT+VLAN)����NE1��NE3($gpnIp3)��NE1 NNI��$GPNPort5\��egress����ҵ��vlan��tag��ǩ[expr {($flag2_case1 == 1) ? "��ȥ��" : "����"}]" $fileId
        gwd::GWpublic_print "== FC3 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��taggedģʽ NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN \
        	$GPNTestEth5\ΪPORT��NE3($gpnIp3)$GPNTestEth3\ΪPORT+VLAN$GPNTestEth2\ΪPORT��NE4($gpnIp4)$GPNTestEth4\ΪPORT��NE1($gpnIp1)��$GPNTestEth5\������������֤����ת��" $fileId
        gwd::GWpublic_print "== FC4 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��taggedģʽ����NE1(PORT)--NE4(PORT)NE1($gpnIp1)��NE4($gpnIp4)��NE1 NNI��$GPNPort12\��egress���򣬷���untag������[expr {($flag4_case1 == 1) ? "û�����" : "�����"}]tag=1�ı�ǩ" $fileId
        gwd::GWpublic_print "== FC5 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��taggedģʽNE1($gpnIp1)$GPNTestEth1\ΪPORT+SVLAN+CVLAN��NE3($gpnIp3)$GPNTestEth3\ΪPORT+SVLAN+CVLAN��������������֤����ת��" $fileId
        gwd::GWpublic_print "== FC6 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE4($gpnIp4)��vpwsҵ��taggedģʽ $GPNTestEth4\ΪPORTģʽ��NE1($gpnIp1)��vplsҵ��taggedģʽ$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORTģʽ��NE4��$GPNTestEth4\������������֤����ת��" $fileId
        gwd::GWpublic_print "== FC7 == [expr {($flag7_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)vplsΪelanҵ��taggedģʽ������pw����Ϊmodify��nochange��delete��[expr {($flag7_case1 == 1) ? "ϵͳ�޴�����ʾ����ʾ����" : "ϵͳ��ʾ�������޸�Ϊadd"}]" $fileId
        gwd::GWpublic_print "== FC8 == [expr {($flag8_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac����Ϊdelete��nochange��add��[expr {($flag8_case1 == 1) ? "ϵͳ�޴�����ʾ����ʾ����" : "ϵͳ��ʾ�������޸�Ϊmodify"}]" $fileId
        gwd::GWpublic_print "== FC9 == [expr {($flag9_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬷�����֤����" $fileId
        gwd::GWpublic_print "== FD1 == [expr {($flag10_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)vplsΪelanҵ��taggedģʽ $GPNTestEth1\ΪPORT+VLAN������ac��pw��������ϵͳ�Զ��޸ĺ󣬾���NE1��NE3��NE1 NNI��$GPNPort5\��egress���򣬼��ҵ��vlan��tag��ǩ[expr {($flag10_case1 == 1) ? "��ȥ��" : "û�б仯"}]" $fileId
        gwd::GWpublic_print "== FD2 == [expr {($flag11_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��taggedģʽNE1($gpnIp1)-NE3($gpnIp3)֮��������һ��ҵ����NE3��pw�����û��أ����Ի����������Ͷ�����ҵ���Ӱ��" $fileId
        gwd::GWpublic_print "== FD3 == [expr {($flag12_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��ping pw12 pingͨ���Ԥ��Ϊ100% ʵΪ$value" $fileId
        gwd::GWpublic_print "== FD4 == [expr {($flag13_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��taggedģʽ����NE1($gpnIp1)ʹ��tracertroute�鿴���Ĵ�NE1��NE3������ÿһ��" $fileId
        gwd::GWpublic_print "== FD5 == [expr {($flag14_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FD6 == [expr {($flag15_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FD7 == [expr {($flag16_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FD8 == [expr {($flag17_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)��$GPNTestEth1\ΪPORT+VLAN $GPNTestEth5\ΪPORT��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FD9 == [expr {($flag18_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪelanҵ��taggedģʽ��NE1($gpnIp1)$GPNTestEth1\ΪPORT+VLAN����NE1��$GPNTestEth5\�ڷ���Э�鱨��NE3($gpnIp3)$GPNTestEth2\�ڽ���[expr {($flag18_case1 == 1) ? "��" : "��"}]����" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_015"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_015_REPORT.txt" "report\\NOK_GPN_PTN_015_REPORT.txt"
	file rename "log\\GPN_PTN_015_LOG.txt" "log\\NOK_GPN_PTN_015_LOG.txt"
} else {
	file rename "report\\GPN_PTN_015_REPORT.txt" "report\\OK_GPN_PTN_015_REPORT.txt"
	file rename "log\\GPN_PTN_015_LOG.txt" "log\\OK_GPN_PTN_015_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}


