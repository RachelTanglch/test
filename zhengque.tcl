#!/bin/sh
# T2_GPN_PTN_ELINE_003.tcl \
exec tclsh "$0" ${1+"$@"}
#�������ƣ�ptn003
#-----------------------------------------------------------------------------------------------------------------------------------
#����Ŀ�ģ�E-LINE������ģ�黥����
#1-��trunk������   
#2-��QOS������          
#3-��OAM������
#4-��DCN����      
#5-��CESҵ�񻥲���     
#6-ELAN/ETREEҵ�񻥲���
#-----------------------------------------------------------------------------------------------------------------------------------
#�����������Ͷ���������7600/SΪ����                                                                                                                             
#                                                                              
#                                    ___________              ___________                               
#                                   |   4GE/ge  |____________| 4GE/ge    |
#  _______                          |   8fx     |____________| 8fx       |������������������������TC2     
# |       |                         |           |____________|           |  
# |  PC   |_______Internet���� ______|           |____________|           |
# |_______|                         |           |            |           |
#    /__\                           |GPN(7600/S)|            |           |       
#                        TC1����������������|           |            |           |
#                                   |___________|            |GPN(7600/S)|
#                                          Internet��������������������|___________| 
#                                                                         
#                                                                  				                     	           
#---------------------------------------------------------------------------------------------------------------------------------
#�ű�����������
#1�����ղ������˴���Ի���:��GPN�Ĺ���˿ڣ�U/D����PC��������Internet������GPN��2��������
#   ��STC�˿ڣ� 9/9����9/10��
#2����GPN��������� ���ã���������vlan vid=4000���ڸ�vlan�����ù���IP����untagged��ʽ��ӹ���˿ڣ�U/D��
#-----------------------------------------------------------------------------------------------------------------------------------
#���Թ��̣�
#1���Test Case 1���Ի���
##��TRUNK������
#   <1>��̨�豸NNI�˿�(GE�˿�)�˴�֮���NNI������Ϊtrunk
#   <2>����trunk���԰������˿ڣ���up
#   <3>����E-LINE����ҵ��
#   <4>NE1��NE3�û�������undo vlan check
#   <5>����TRUNK���ģʽΪ1:1
#   <6>���trunk���˿�50�Σ���¼��ҵ�񵹻��ͻָ�ʱ��
#   Ԥ�ڽ����ҵ�����������ͻָ���ʱ�䲻����50ms
#   <7>���trunk�Ӷ˿�50��
#   Ԥ�ڽ����ϵͳ���쳣��ҵ�񲻷����������޶���
#   <8>trunk��˿ڳ�Ա�����ˣ�ҵ���жϣ��ָ�trunk������һ���˿ڳ�Ա��ҵ��ɻָ�
#   <9>����trunk���ģʽΪ1+1���ظ����ϲ���
#   <10>����trunk���ģʽΪ���طֵ����ظ����ϲ���
#   <11>�������豸��trunk�и����һ��down�Ķ˿ڣ��˿���ӳɹ���ҵ���������Ӱ��
#   <12>�ٴ��������豸��trunk��ɾ����down�Ķ˿ڣ��˿�ɾ���ɹ���ҵ���������Ӱ��
#   <13>�������豸��trunk�и����һ��up�Ķ˿ڣ��˿���ӳɹ���ҵ���������Ӱ��
#   <14>�ٴ��������豸��trunk��ɾ����up�Ķ˿ڣ��˿�ɾ���ɹ���ҵ���������Ӱ��
#   <15>����trunk��˿ڳ�Ա��忨���ظ����ϲ���
#   <16>��UNI��Ķ˿�����Ϊturnk�˿ڣ�����ҵ�����ݣ�ҵ���������óɹ���ҵ������������ת��
#   <17>�����õ�trunk�ۺϷ�ʽΪ��̬���ظ����ϲ���
#2���Test Case 2���Ի���
###��QOS������       
#   <1>����һ��ACL����ԴmacΪA��������permit��ԴmacΪB��������deny���󶨵�AC/PW/LSP����֤ACL������Ч
#   <2>����QoS���٣���QoS���԰󶨵�AC/PW/LSP����֤���ٿ�����Ч
#   <3>�����AC���ʲ��ɳ���PW��PW���ʲ��ɳ���LSP������Υ����ϵͳ����Ӧ����ʾ
#   <4>����һ��PW ���е��Ȳ��������٣�ϵͳ���쳣���óɹ�
#   <5>���������������۲���յ���ͬ���ȼ����������Ķ��ٱ����Ƿ��������
#3���Test Case 3���Ի���
###��OAM������
#   <1>���öβ�/PW/LSP��0AM���ɳɹ����ã�ϵͳ���쳣����ҵ������ת����Ӱ��
#   <2>���öβ�/PW/LSP����Ӧ��CC���ܽ�ֹ/ʹ�ܣ����óɹ���ϵͳ���쳣����ҵ������ת����Ӱ��
#   <3>���öβ�/PW/LSP����Ӧ��CCʱ�������������óɹ���ϵͳ���쳣����ҵ������ת����Ӱ��
#   <4>����LB���ܣ�ϵͳ���쳣�����ɲ�ѯ���ؽ��
#4���Test Case 4���Ի���
###��DCN������
#   <1>2̨�豸��DCN�������ܣ�����һ̨Ϊ������Ԫ����һ̨Ϊ��������Ԫ
#   <2>2̨�豸����ping�����������豸�������������ܣ�ҵ������������ת����ϵͳ���쳣
#   <3>ɾ����������DCN���ã���E-LINEҵ����Ӱ��
#5���Test Case 4���Ի���
###��CES������
#   <1>��֮ǰ������E-LINEҵ����LSP����ֻ������PW����Ӧ��CESҵ��
#   <2>CESҵ�����óɹ���ϵͳ���쳣
#   <3>CESҵ���֮ǰ��E-LINEҵ������ת�����˴�֮���޸���
#   <4>��CESҵ���E-LINEҵ���õ�LSP�������٣�ϵͳ���쳣��CESҵ���E-LINEҵ�������ת��
#6���Test Case 6���Ի���
###ELAN/ETREE������
#   <1>3̨�豸ԭ��E-LINEҵ��Ļ����ϣ������µ�ҵ��ELAN/ETREE
#   <2>�µ�ҵ��ELAN/ETREEҵ��ɹ�������ϵͳ���쳣����֮ǰ��ҵ����Ӱ��
#   <3>ÿ��ҵ������ת�����˴�֮���޸��ţ�ϵͳ����������
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
	file mkdir "log"
	set fd_log [open "log\\GPN_PTN_003_LOG.txt" a]
	set stdout $fd_log
	log_file log\\GPN_PTN_003_LOG.txt
	chan configure $fd_log -blocking 0 -buffering none;#������ģʽ ����flush
	
	file mkdir "report"
	set fileId [open "report\\GPN_PTN_003_REPORT.txt" a+]
	chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_003_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_003_DEBUG.txt 0
	chan configure $fd_debug -blocking 0 -buffering none;#������ģʽ ����flush
	  
	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl
	set rateL 95000000;#�շ�������ȡֵ��Сֵ��Χ
	set rateR 105000000;#�շ�������ȡֵ���ֵ��Χ
    array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
    array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:01:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "50" -pri "000"}
    array set dataArr3 {-srcMac "00:00:00:00:00:03" -dstMac "00:00:00:00:00:33" -srcIp "192.85.1.3" -dstIp "192.0.0.3" -vid "1000" -pri "000"}
    array set dataArr4 {-srcMac "00:00:00:00:00:04" -dstMac "00:00:00:00:00:44" -srcIp "192.85.1.4" -dstIp "192.0.0.4"}
    array set dataArr5 {-srcMac "00:00:00:00:00:05" -dstMac "00:00:00:00:00:55" -srcIp "192.85.1.5" -dstIp "192.0.0.5" -vid "3000" -pri "000"}
    array set dataArr6 {-srcMac "00:00:00:00:00:06" -dstMac "00:00:00:00:00:66" -srcIp "192.85.1.6" -dstIp "192.0.0.6" -vid "1000" -pri "000"}
    array set dataArr7 {-srcMac "00:00:00:00:00:07" -dstMac "00:00:00:00:00:77" -srcIp "192.85.1.7" -dstIp "192.0.0.7" -vid "2000" -pri "000"}
    array set dataArr8 {-srcMac "00:00:00:00:00:08" -dstMac "00:00:00:00:00:88" -srcIp "192.85.1.8" -dstIp "192.0.0.8" -vid "50" -pri "111"}
    array set dataArr9 {-srcMac "00:00:00:00:00:09" -dstMac "00:00:00:00:00:99" -srcIp "192.85.1.9" -dstIp "192.0.0.9" -vid "50" -pri "110"}
    #���ö�����Ϣ����
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}

    #���÷���������
    set GenCfg {-SchedulingMode RATE_BASED}
    
    #���ù��˷���������
    set anaFliFrameCfg1 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><vlans name="anon_13224"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
    set anaFliFrameCfg0 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
    set anaFliFrameCfg4 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5580"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
    set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
    set anaFliFrameCfg3 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4647"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><exp override="true"  filterMinValue="0" filterMaxValue="111">111</exp></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><sBit override="true"  filterMinValue="0" filterMaxValue="1">1</sBit></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
    
    set flagCase1 0   ;#Test case 1��־λ 
    set flagCase2 0   ;#Test case 2��־λ
    set flagCase3 0   ;#Test case 3��־λ 
    set flagCase4 0   ;#Test case 4��־λ
    set flagCase5 0   ;#Test case 5��־λ 
    set flagCase6 0   ;#Test case 6��־λ 
	
	set flagResult 0
	
	set lFailFile ""
	set FLAGF 0
	
	set tcId 0
	set capId 0
	set cfgId 0
	
	regsub {/} $GPNTestEth1 {_} GPNTestEth1_cap
	regsub {/} $GPNTestEth2 {_} GPNTestEth2_cap
	regsub {/} $GPNTestEth3 {_} GPNTestEth3_cap
	regsub {/} $GPNTestEth4 {_} GPNTestEth4_cap
	regsub {/} $GPNTestEth5 {_} GPNTestEth5_cap
	#Ϊ���Խ���Ԥ������
	for {set i 0} {$i < 80} {incr i} {
	    puts $fileId "                                                                                                                                                                                                                "	
	}
		
	proc TestFlow {fileId caseId} {
		set flag 0
		set lport1 "$::hGPNPort1 $::hGPNPort2 $::hGPNPort3 $::hGPNPort4"
		stc::perform ResultsClearAll -PortList $lport1 
		gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
		if {$::cap_enable} {
			gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
			gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
		}
		after 10000
		if {$::cap_enable} {
			gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$::GPNTestEth3_cap\($::gpnIp1).pcap"	
			gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$::GPNTestEth4_cap\($::gpnIp3).pcap"
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 0 0 0
			after 5000
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 0 1 0 0
			after 5000
		}
		parray aGPNPort3Cnt1
		parray aGPNPort4Cnt1
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($::gpnIp1).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($::gpnIp3).pcap" $fileId
		if {$aGPNPort4Cnt1(cnt2) < $::rateL || $aGPNPort4Cnt1(cnt2) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth3\����tag=50����������NE3($::gpnIp3)\
				$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth3\����tag=50����������NE3($::gpnIp3)\
				$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$aGPNPort3Cnt1(cnt6) < $::rateL || $aGPNPort3Cnt1(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������NE1($::gpnIp1)\
				$::GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������NE1($::gpnIp1)\
				$::GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)����$::rateL-$::rateR\��Χ��" $fileId
		}
		gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
		return $flag
	}
	proc TestFlowUNI {fileId caseId} {
		set flag 0
		set lport1 "$::hGPNPort4 $::hGPNPort5"
		stc::perform ResultsClearAll -PortList $lport1 
		gwd::Start_SendFlow "$::hGPNPort4Gen $::hGPNPort5Gen"  "$::hGPNPort4Ana $::hGPNPort5Ana"
		if {$::cap_enable} {
			gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer 
			gwd::Start_CapAllData ::capArr $::hGPNPort5Cap $::hGPNPort5CapAnalyzer
		}
		after 10000
		if {$::cap_enable} {
			gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$::GPNTestEth4_cap\($::gpnIp1).pcap"	
			gwd::Stop_CapData $::hGPNPort5Cap 1 "$caseId-p$::GPNTestEth5_cap\($::gpnIp3).pcap"
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 0 0 0
			after 5000
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort5Ana aGPNPort5Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 0 1 0 0
			after 5000
		}
		parray aGPNPort4Cnt1
		parray aGPNPort5Cnt1
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($::gpnIp3).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth5_cap\($::gpnIp1).pcap" $fileId
		if {$aGPNPort4Cnt1(cnt2) < $::rateL || $aGPNPort4Cnt1(cnt2) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth5\����tag=50����������NE3($::gpnIp3)\
				$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth5\����tag=50����������NE3($::gpnIp3)\
				$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$aGPNPort5Cnt1(cnt6) < $::rateL || $aGPNPort5Cnt1(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������NE1($::gpnIp1)\
				$::GPNTestEth5\�յ�tag=1000��������������Ϊ$aGPNPort5Cnt1(cnt6)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������NE1($::gpnIp1)\
				$::GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort5Cnt1(cnt6)����$::rateL-$::rateR\��Χ��" $fileId
		}
		gwd::Stop_SendFlow "$::hGPNPort4Gen $::hGPNPort5Gen"  "$::hGPNPort4Ana $::hGPNPort5Ana"
		return $flag
	}
	puts $fileId "��¼�����豸...\n"
	puts $fileId "\n=====��¼�����豸1====\n"
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	# while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"]} {
		
	# }
	# while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "shutdown"]} {
		
	# }
	# while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "shutdown"]} {
			
	# }
	puts $fileId "\n=====��¼�����豸2====\n"
	set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
	puts $fileId "\n=====��¼�����豸3====\n"
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	puts $fileId "\n=====��¼�������豸4====\n"
	set telnet4 [gwd::H3Cpublic_login $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	#���ڵ��������豸�����ļ��õ��ı���------
	set lSpawn_id "$telnet1 $telnet2 $telnet3"
	set lMatchType "$matchType1 $matchType2 $matchType3"
	set lDutType "$Gpn_type1 $Gpn_type2 $Gpn_type3"
	set lIp "$gpnIp1 $gpnIp2 $gpnIp3"
	#------���ڵ��������豸�����ļ��õ��ı���
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "�������Թ���...\n"
	set hPtnProject [stc::create project]
	set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3\
			\"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\" $GPNStcPort5 \"media $GPNEth5Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4 hGPNPort5
    #������������
    gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort3 hGPNPort3Stream1
    gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort3 hGPNPort3Stream2
    gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort3 hGPNPort3Stream8
    set RangeModifier1 [stc::create "RangeModifier" \
	-under $hGPNPort3Stream8 \
	-Mask {00:00:FF:FF:FF:FF} \
	-StepValue {00:00:00:00:00:01} \
	-RecycleCount "100" \
	-Data {00:00:00:00:00:02} \
	-EnableStream "TRUE" \
	-Offset "2" \
	-OffsetReference {eth1.srcMac} \
	-Name {MAC Modifier} ]
	stc::apply
	gwd::STC_Create_VlanStream $fileId dataArr8 $hGPNPort3 hGPNPort3Stream27
	gwd::STC_Create_VlanStream $fileId dataArr9 $hGPNPort3 hGPNPort3Stream26
    gwd::STC_Create_VlanStream $fileId dataArr3 $hGPNPort2 hGPNPort2Stream3
    gwd::STC_Create_Stream $fileId dataArr4 $hGPNPort4 hGPNPort4Stream4
    gwd::STC_Create_VlanStream $fileId dataArr5 $hGPNPort4 hGPNPort4Stream5
    gwd::STC_Create_VlanStream $fileId dataArr6 $hGPNPort4 hGPNPort4Stream6
    gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort1 hGPNPort1Stream7
    gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort5 hGPNPort5Stream9
    gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort5 hGPNPort5Stream10
    set RangeModifier2 [stc::create "RangeModifier" \
	-under $hGPNPort5Stream10 \
	-Mask {00:00:FF:FF:FF:FF} \
	-StepValue {00:00:00:00:00:01} \
	-RecycleCount "100" \
	-Data {00:00:00:00:00:02} \
	-EnableStream "TRUE" \
	-Offset "2" \
	-OffsetReference {eth1.srcMac} \
	-Name {MAC Modifier} ]
	set lHStream "$hGPNPort3Stream1 $hGPNPort3Stream2 $hGPNPort2Stream3 $hGPNPort4Stream4\
					  $hGPNPort4Stream5 $hGPNPort4Stream6 $hGPNPort1Stream7 $hGPNPort3Stream8 $hGPNPort5Stream9 $hGPNPort5Stream10"
	set QosStream1 "$hGPNPort3Stream27"
	set QosStream2 "$hGPNPort3Stream26"
	stc::perform streamBlockActivate -streamBlockList $lHStream -activate "false"
	stc::perform streamBlockActivate -streamBlockList $QosStream1 -activate "false"
	stc::perform streamBlockActivate -streamBlockList $QosStream2 -activate "false"

    ##��ȡ�������ͷ�����ָ��
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
    ##�����շ���Ϣ
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
	#������������ 10%��Mbps
	foreach hStream $lHStream {
		stc::config [stc::get $hStream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
	}
	stc::config [stc::get $QosStream1 -AffiliationStreamBlockLoadProfile-targets] -load 40 -LoadUnit MEGABITS_PER_SECOND
	stc::config [stc::get $QosStream2 -AffiliationStreamBlockLoadProfile-targets] -load 20 -LoadUnit MEGABITS_PER_SECOND

	stc::apply 
	#��ȡ����������ָ��
	gwd::Get_GeneratorCfgObj $hGPNPort1Gen hGPNPort1GenCfg
	gwd::Cfg_GeneratorCfgObj $hGPNPort1GenCfg $GenCfg
	gwd::Get_GeneratorCfgObj $hGPNPort2Gen hGPNPort2GenCfg
	gwd::Cfg_GeneratorCfgObj $hGPNPort2GenCfg $GenCfg
	gwd::Get_GeneratorCfgObj $hGPNPort3Gen hGPNPort3GenCfg
	gwd::Cfg_GeneratorCfgObj $hGPNPort3GenCfg $GenCfg
	gwd::Get_GeneratorCfgObj $hGPNPort4Gen hGPNPort4GenCfg
	gwd::Cfg_GeneratorCfgObj $hGPNPort4GenCfg $GenCfg
	gwd::Get_GeneratorCfgObj $hGPNPort5Gen hGPNPort5GenCfg
	gwd::Cfg_GeneratorCfgObj $hGPNPort5GenCfg $GenCfg
	#���������ù�������Ĭ�Ϲ���tag
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort1Ana hGPNPort1AnaFrameCfgFil
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg1
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort2Ana hGPNPort2AnaFrameCfgFil
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort3Ana hGPNPort3AnaFrameCfgFil
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1	
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort5Ana hGPNPort5AnaFrameCfgFil
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg1
	if {$cap_enable} {
		#��ȡ������capture������ص�ָ��
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
	}
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-LINE������ģ�黥�����������ÿ�ʼ..."
	puts $fileId ""
	set cfgFlag 0
	set portList1 "$GPNPort5 $GPNPort7 $GPNPort9 $GPNPort14 $GPNTestEth2 $GPNTestEth3"
	foreach port $portList1 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
		}
	}
	set rebootSlotList1 [gwd::GWpulic_getWorkCardList $portList1]
	gwd::GWpublic_print "OK" "��ȡ�豸NE1($gpnIp1)ҵ��忨��λ��$rebootSlotList1" $fileId
	 
	set portList2 "$GPNPort12 $GPNPort13 $GPNTestEth1"
	foreach port $portList2 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "disable" "enable"]
		}
	}
	set rebootSlotList2 [gwd::GWpulic_getWorkCardList $portList2]
	gwd::GWpublic_print "OK" "��ȡ�豸NE2($gpnIp2)ҵ��忨��λ��$rebootSlotList2" $fileId

	set portList3 "$GPNPort6 $GPNPort8 $GPNPort10 $GPNPort11 $GPNTestEth4"
	foreach port $portList3 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "disable" "enable"]
		}
	}
	set rebootSlotList3 [gwd::GWpulic_getWorkCardList $portList3]
	gwd::GWpublic_print "OK" "��ȡ�豸NE3($gpnIp3)ҵ��忨��λ��$rebootSlotList3" $fileId
	
	###������ӿ����ò���
	if {[string match "L2" $Worklevel]} {
		set interface1 v100
		set interface14 v100
		set interface10 v10
		set interface11 v10
		set interface12 v50
		set interface23 v1000
		set interface24 v3000
		set interface25 v200
		set interface26 v200
		set interface27 v300
		set interface28 v300
		set interface29 v2000
		set interface30 v1000
		set interface2 v100
	} else {
		set interface1 $GPNPort5.100
		set interface14 $GPNPort6.100
		set interface10 $GPNPort6.10
		set interface11 $GPNPort5.10
		set interface12 $GPNTestEth3.50
		set interface23 $GPNTestEth4.1000
		set interface24 $GPNTestEth4.3000
		set interface25 $GPNPort11.200
		set interface26 $GPNPort12.200
		set interface27 $GPNPort13.300
		set interface28 $GPNPort14.300
		set interface29 $GPNTestEth1.2000
		set interface30 $GPNTestEth2.1000
		set interface2 $GPNTestEth2.100
	}
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "ELINE������ģ�黥�����Ļ�������ʧ�ܣ����Խ���" \
			"ELINE������ģ�黥�����Ļ������óɹ�����������Ĳ���" "GPN_PTN_003"
	puts $fileId ""
	puts $fileId "===ELINE������ģ�黥�����������ý���..."
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId ""
	# puts $fileId "**************************************************************************************\n"
	# puts $fileId "**************************************************************************************\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 E-LINE��TRUNK����������\n"
	##��TRUNK������
	#   <1>��̨�豸NNI�˿�(GE�˿�)�˴�֮���NNI������Ϊtrunk
	#   <2>����trunk���԰������˿ڣ���up
	#   <3>����E-LINE����ҵ��
	#   <4>NE1��NE3�û�������undo vlan check
	#   <5>����TRUNK���ģʽΪ1:1
	#   <6>���trunk���˿�50�Σ���¼��ҵ�񵹻��ͻָ�ʱ��
	#   Ԥ�ڽ����ҵ�����������ͻָ���ʱ�䲻����50ms
	#   <7>���trunk�Ӷ˿�50��
	#   Ԥ�ڽ����ϵͳ���쳣��ҵ�񲻷����������޶���
	#   <8>trunk��˿ڳ�Ա�����ˣ�ҵ���жϣ��ָ�trunk������һ���˿ڳ�Ա��ҵ��ɻָ�
	#   <9>����trunk���ģʽΪ1+1���ظ����ϲ���
	#   <10>����trunk���ģʽΪ���طֵ����ظ����ϲ���
	#   <11>�������豸��trunk�и����һ��down�Ķ˿ڣ��˿���ӳɹ���ҵ���������Ӱ��
	#   <12>�ٴ��������豸��trunk��ɾ����down�Ķ˿ڣ��˿�ɾ���ɹ���ҵ���������Ӱ��
	#   <13>�������豸��trunk�и����һ��up�Ķ˿ڣ��˿���ӳɹ���ҵ���������Ӱ��
	#   <14>�ٴ��������豸��trunk��ɾ����up�Ķ˿ڣ��˿�ɾ���ɹ���ҵ���������Ӱ��
	#   <15>����trunk��˿ڳ�Ա��忨���ظ����ϲ���
	#   <16>��UNI��Ķ˿�����Ϊturnk�˿ڣ�����ҵ�����ݣ�ҵ���������óɹ���ҵ������������ת��
	#   <17>�����õ�trunk�ۺϷ�ʽΪ��̬���ظ����ϲ���
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
	set flag1_case3 0
	set flag2_case3 0
	set flag3_case3 0
	set flag4_case3 0
	set flag5_case3 0
	set flag6_case3 0
	set flag7_case3 0
	set flag8_case3 0
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag5_case4 0
	set flag6_case4 0
	set ip1 192.1.1.1
	set ip2 192.1.1.2
	set address1 10.1.1.1
	set address2 10.1.1.2
	# gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"
	# gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "undo shutdown"

	# if {[string match "L2" $trunkLevel]} {
	# 	lappend flag1_case1 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "disable" "enable"]
	# 	lappend flag1_case1 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "disable" "enable"]
	# 	lappend flag1_case1 [gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNPort5 $GPNPort7"]
	# 	lappend flag1_case1 [gwd::GWL2Inter_AddVlanPort $telnet1 $matchType1 $Gpn_type1 $fileId "10" "trunk" "t1" "untagged"]
	# 	lappend flag1_case1 [gwd::GWpublic_CfgVlanIp $telnet1 $matchType1 $Gpn_type1 $fileId "10" $ip1 "24"]
	# 	lappend flag1_case1 [gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "vlan" "v10" $ip2 "100" "100" "normal" "1"]

	# 	lappend flag1_case1 [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort6 "disable" "enable"]
	# 	lappend flag1_case1 [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "disable" "enable"]
	# 	lappend flag1_case1 [gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" "$GPNPort6 $GPNPort8"]
	# 	lappend flag1_case1 [gwd::GWL2Inter_AddVlanPort $telnet3 $matchType3 $Gpn_type3 $fileId 10 "trunk" "t1" "untagged"]
	# 	lappend flag1_case1 [gwd::GWpublic_CfgVlanIp $telnet3 $matchType3 $Gpn_type3 $fileId "10" $ip2 "24"]
	# 	lappend flag1_case1 [gwd::GWStaLsp_AddLspInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" "vlan" "v10" $ip1 "100" "100" "normal" "2"]
	# } else {
	# 	lappend flag1_case1 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "disable" "disable"]
	# 	lappend flag1_case1 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "disable" "disable"]
	# 	lappend flag1_case1 [gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNPort5 $GPNPort7"]
	# 	lappend flag1_case1 [gwd::GWL3_AddInterDcn $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "enable"]
	# 	lappend flag1_case1 [gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "10"]
	# 	lappend flag1_case1 [gwd::GWL3port_AddIP $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "10" $ip1 "24"]
	# 	lappend flag1_case1 [gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "trunk" "t1.10" $ip2 "100" "100" "normal" "1"]
		
	# 	lappend flag1_case1 [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort6 "disable" "disable"]
	# 	lappend flag1_case1 [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "disable" "disable"]
	# 	lappend flag1_case1 [gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" "$GPNPort6 $GPNPort8"]
	# 	lappend flag1_case1 [gwd::GWL3_AddInterDcn $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t1" "enable"]
	# 	lappend flag1_case1 [gwd::GWL3Inter_AddL3 $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t1" "10"]
	# 	lappend flag1_case1 [gwd::GWL3port_AddIP $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t1" "10" $ip2 "24"]
	# 	lappend flag1_case1 [gwd::GWStaLsp_AddLspInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" "trunk" "t1.10" $ip1 "100" "100" "normal" "2"]
	# }
	# lappend flag1_case1 [gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "lag1:1"]
	# lappend flag1_case1 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $address1]
	# lappend flag1_case1 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]
	# lappend flag1_case1 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""]
	# lappend flag1_case1 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "50" $GPNTestEth3]
	# lappend flag1_case1 [gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 0 "nochange" 1 0 0 "0x8100"]
	# lappend flag1_case1 [gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"]

	# lappend flag1_case1 [gwd::GWpublic_addTrunkMode $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" "lag1:1"]
	# lappend flag1_case1 [gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" $address2]
	# lappend flag1_case1 [gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
	# lappend flag1_case1 [gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "nochange" "" 1 0 "0x8100" "0x8100" ""]
	# lappend flag1_case1 [gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 0 0 "nochange" 1 0 0 "0x8100"]
	# lappend flag1_case1 [gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline"]
	if {[string match "L2" $Worklevel]} {
		lappend flag1_case1 [gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "disable"]
	}
	lappend flag1_case1 [gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"]
	lappend flag1_case1 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "TRUE"]
   
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪlag1:1��trunk���Աͬ�忨������E-LINE��trunk������  ���Կ�ʼ=====\n"
	#dev1 ��dev3����down�˿��������trunk����------
	set downPort_dev1 1/1
	set downPort_dev3 1/1
	# gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "undo shutdown"
	gwd::GWmanage_GetPortInfo $telnet1 $matchType1 $Gpn_type1 $fileId KeyInfo
	regexp {(\d+)/\d+} $GPNPort5 match slot1
	regexp {(\d+)/\d+} $GPNPort9 match slot2
	dict for {key value} $KeyInfo {
		regexp {(\d+)/\d+} $key match slot
		if {($slot == $slot1) || ($slot == $slot2)} {
			if {[string match -nocase [dict get $value PhyStat] down] && [string match -nocase [dict get $value AdminStat] up]} {
				set downPort_dev1 $key
				break
			}
		}
	}
	gwd::GWmanage_GetPortInfo $telnet3 $matchType3 $Gpn_type3 $fileId KeyInfo
	regexp {(\d+)/\d+} $GPNPort8 match slot1
	regexp {(\d+)/\d+} $GPNPort10 match slot2
	dict for {key value} $KeyInfo {
		regexp {(\d+)/\d+} $key match slot
		if {($slot == $slot1) || ($slot == $slot2)} {
			if {[string match -nocase [dict get $value PhyStat] down] && [string match -nocase [dict get $value AdminStat] up]} {
				set downPort_dev3 $key
				break
			}
		}
	}
	###�õ�trunk���Ա�����˿ںʹӶ˿ڣ��˿ں�С�Ŀ������˿�------
	set port1 0
	set port2 0
	regexp {\d+/(\d+)} $GPNPort6 match port1
	regexp {\d+/(\d+)} $GPNPort8 match port2
	if {$port1 < $port2} {
		set masterPort1 $GPNPort6
	} else {
		set masterPort1 $GPNPort8
	}
	if {$port1 > $port2} {
		set slavePort1 $GPNPort6
	} else {
		set slavePort1 $GPNPort8
	}
	set port1 0
	set port2 0
	regexp {\d+/(\d+)} $GPNPort5 match port1
	regexp {\d+/(\d+)} $GPNPort7 match port2
	if {$port1 < $port2} {
		set masterPort2 $GPNPort5
	} else {
		set masterPort2 $GPNPort7
	}
	if {$port1 > $port2} {
		set slavePort2 $GPNPort5
	} else {
		set slavePort2 $GPNPort7
	}
	##------�õ�trunk���Ա�����˿ںʹӶ˿ڣ��˿ں�С�Ŀ������˿�
		    #####################################################lagģʽΪ1:1##################################################################
	#lappend flag1_case1 [Test_TrunkModeAdd $telnet3 $matchType3 $Gpn_type3 $fileId lag1:1 "t1" $masterPort1 $slavePort1 $ptn003_case1_cnt "GPN_PTN_003_FA1"]
	# puts $fileId ""
	# if {"1" in $flag1_case1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA1�����ۣ�trunkģʽΪlag1:1��trunk���Աͬ�忨������E-LINE��trunk������" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA1�����ۣ�trunkģʽΪlag1:1��trunk���Աͬ�忨������E-LINE��trunk������" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪlag1:1��trunk���Աͬ�忨������E-LINE��trunk������  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪlag1+1��trunk���Աͬ�忨������E-LINE��trunk������  ���Կ�ʼ=====\n"
	#######################################################lagģʽΪ1+1##################################################################
	# lappend flag2_case1 [gwd::GWpublic_addTrunkMode $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" "lag1+1"]
	# lappend flag2_case1 [gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "lag1+1"]
	#lappend flag2_case1 [Test_TrunkModeAdd $telnet1 $matchType1 $Gpn_type1 $fileId lag1+1 "t1" $masterPort2 $slavePort2 $ptn003_case1_cnt "GPN_PTN_003_FA2"]
	# puts $fileId ""
	# if {"1" in $flag2_case1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA2�����ۣ�trunkģʽΪlag1+1��trunk���Աͬ�忨������E-LINE��trunk������" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA2�����ۣ�trunkģʽΪlag1+1��trunk���Աͬ�忨������E-LINE��trunk������" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪlag1+1��trunk���Աͬ�忨������E-LINE��trunk������  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��trunk���Աͬ�忨������E-LINE��trunk������  ���Կ�ʼ=====\n"
	# ######################################################lagģʽΪsharing##################################################################
	# lappend flag3_case1 [gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "sharing"]
	# lappend flag3_case1 [gwd::GWpublic_addTrunkPolicy $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "srcmac-based"]
	# lappend flag3_case1 [gwd::GWpublic_addTrunkMode $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" "sharing"]
	# lappend flag3_case1 [gwd::GWpublic_addTrunkPolicy $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" "srcmac-based"]
	# lappend flag3_case1 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "FALSE"]
	# stc::apply
 # 	#lappend flag3_case1 [Test_TrunkSharing $telnet1 $matchType1 $Gpn_type1 $fileId sharing "t1" $masterPort2 $slavePort2 "false" "GPN_PTN_003_FA3_1"]
	# lappend flag3_case1 [gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"]
	# lappend flag3_case1 [gwd::Cfg_StreamActive $hGPNPort3Stream8 "TRUE"]
	# stc::apply
	# lappend flag3_case1 [Test_TrunkSharing $telnet1 $matchType1 $Gpn_type1 $fileId sharing "t1" $masterPort2 $slavePort2 "true" "GPN_PTN_003_FA3_2"]
	# lappend flag3_case1 [gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"]
	# lappend flag3_case1 [gwd::Cfg_StreamActive $hGPNPort3Stream8 "FALSE"]
	# puts $fileId ""
	# if {"1" in $flag3_case1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA3�����ۣ�trunkģʽΪsharing��trunk���Աͬ�忨������E-LINE��trunk������" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA3�����ۣ�trunkģʽΪsharing��trunk���Աͬ�忨������E-LINE��trunk������" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��trunk���Աͬ�忨������E-LINE��trunk������  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���down�˿�$downPort_dev1\
	# 				$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���down�˿�$downPort_dev3\����ҵ��  ���Կ�ʼ=====\n"
	# if {[string match "L3" $trunkLevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "disable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $downPort_dev3 "disable" "disable"
	# } elseif {[string match "L2" $trunkLevel]&&[string match "L3" $Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "disable" "enable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $downPort_dev3 "disable" "enable"
	# }
	# gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" $downPort_dev1
	# gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" $downPort_dev3
	# lappend flag4_case1 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "TRUE"]
	# lappend flag4_case1 [gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"]
	# lappend flag4_case1 [gwd::Cfg_StreamActive $hGPNPort3Stream8 "FALSE"]
	# stc::apply
	# incr capId
	# stc::delete $hGPNPort4AnaFrameCfgFil
	# gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
 #    gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
 #    stc::apply	
	# lappend flag4_case1 [TestFlow $fileId "GPN_PTN_003_$capId"]
	# incr id
	# puts $fileId ""
	# if {"1" in $flag4_case1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA4�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���down�˿�$downPort_dev1\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���down�˿�$downPort_dev3\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA4�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���down�˿�$downPort_dev1\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���down�˿�$downPort_dev3\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���down�˿�$downPort_dev1\
	# 						$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���down�˿�$downPort_dev3\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��down�˿�$downPort_dev1\
	# 				$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��down�˿�$downPort_dev3\����ҵ��  ���Կ�ʼ=====\n"
	# gwd::GWpublic_delPortFromTrunk $telnet1 $matchType1 $Gpn_type1 $fileId t1 $downPort_dev1
	# gwd::GWpublic_delPortFromTrunk $telnet3 $matchType3 $Gpn_type3 $fileId t1 $downPort_dev3
	# if {[string match "L3" $::Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "enable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $downPort_dev3 "enable" "disable"
	# }
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	# 	set flag5_case1 1
	# }
	# incr id
	# puts $fileId ""
	# if {$flag5_case1 == 1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA5�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��down�˿�$downPort_dev1\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��down�˿�$downPort_dev3\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA5�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��down�˿�$downPort_dev1\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��down�˿�$downPort_dev3\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��down�˿�$downPort_dev1\
	# 						$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��down�˿�$downPort_dev3\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���up�˿�$GPNPort9\
	# 						$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���up�˿�$GPNPort10\����ҵ��  ���Կ�ʼ=====\n"
	# if {[string match "L2" $::trunkLevel]&&[string match "L3" $::Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort10 "disable" "enable"
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "disable" "enable"
	# } elseif {[string match "L3" $::trunkLevel]} {
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort10 "disable" "disable"
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "disable" "disable"
	# }
	# gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" "$GPNPort10"
	# gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNPort9"
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	# 	set flag6_case1 1
	# }
	# incr id
	# puts $fileId ""
	# if {$flag6_case1 == 1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA6�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���up�˿�$GPNPort9\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���up�˿�$GPNPort10\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA6�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���up�˿�$GPNPort9\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���up�˿�$GPNPort10\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���up�˿�$GPNPort9\
	# 						$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���up�˿�$GPNPort10\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��up�˿�$GPNPort9\
	# 						$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��up�˿�$GPNPort10\����ҵ��  ���Կ�ʼ=====\n"
	# gwd::GWpublic_delPortFromTrunk $telnet1 $matchType1 $Gpn_type1 $fileId t1 $GPNPort9
	# gwd::GWpublic_delPortFromTrunk $telnet3 $matchType3 $Gpn_type3 $fileId t1 $GPNPort10
	# if {[string match "L3" $Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "enable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort10 "enable" "disable"
	# }
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	# 	set flag7_case1 1
	# }
	# incr id
	# puts $fileId ""
	# if {$flag7_case1 == 1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA7�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��up�˿�$GPNPort9\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��up�˿�$GPNPort10\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA7�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��up�˿�$GPNPort9\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��up�˿�$GPNPort10\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��up�˿�$GPNPort9\
	# 						$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��up�˿�$GPNPort10\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��trunk���Ա��忨������E-LINE��trunk������  ���Կ�ʼ=====\n"
	######################################################lagģʽΪsharing##################################################################
	###�õ�trunk���Ա�����˿ںʹӶ˿ڣ��˿ں�С�Ŀ������˿�------
	
	##------�õ�trunk���Ա�����˿ںʹӶ˿ڣ��˿ں�С�Ŀ������˿�
	# if {[string match "L2" $trunkLevel] && [string match "L3" $Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "disable" "enable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort10 "disable" "enable"
	# } elseif {[string match "L3" $trunkLevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "disable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort10 "disable" "disable"
	# }
	# gwd::GWpublic_delPortFromTrunk $telnet1 $matchType1 $Gpn_type1 $fileId t1 $GPNPort7
	# gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNPort9"
	# gwd::GWpublic_delPortFromTrunk $telnet3 $matchType3 $Gpn_type3 $fileId t1 $GPNPort8
	# gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" "$GPNPort10"
	# lappend flag8_case1 [GW_SetTrunkMaster $telnet1 $matchType1 $Gpn_type1 $fileId "t1" $GPNPort5]
	# lappend flag8_case1 [GW_SetTrunkMaster $telnet3 $matchType3 $Gpn_type3 $fileId "t1" $GPNPort6]
		set masterPort1 $GPNPort6
		set slavePort1 $GPNPort10
		set masterPort2 $GPNPort5
		set slavePort2 $GPNPort9
	# lappend flag8_case1 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "FALSE"]
	# lappend flag8_case1 [gwd::Cfg_StreamActive $hGPNPort3Stream8 "FALSE"]
	# stc::delete $hGPNPort4AnaFrameCfgFil
	# gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
 #    gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
	# stc::apply
	# lappend flag8_case1 [Test_TrunkSharing $telnet1 $matchType1 $Gpn_type1 $fileId sharing "t1" $masterPort2 $slavePort2 "false" "GPN_PTN_003_FA8_2"]
	# lappend flag8_case1 [gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"]
	# lappend flag8_case1 [gwd::Cfg_StreamActive $hGPNPort3Stream8 "TRUE"]
	# stc::apply
	# lappend flag8_case1 [Test_TrunkSharing $telnet1 $matchType1 $Gpn_type1 $fileId sharing "t1" $masterPort2 $slavePort2 "true" "GPN_PTN_003_FA8_2"]

	# puts $fileId ""
	# if {"1" in $flag8_case1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA8�����ۣ�trunkģʽΪsharing��trunk���Ա��忨������E-LINE��trunk������" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA8�����ۣ�trunkģʽΪsharing��trunk���Ա��忨������E-LINE��trunk������" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��trunk���Ա��忨������E-LINE��trunk������  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"

	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪlag1+1��trunk���Ա��忨������E-LINE��trunk������  ���Կ�ʼ=====\n"
	# lappend flag9_case1 [gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "lag1+1"]
	# lappend flag9_case1 [gwd::GWpublic_addTrunkMode $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" "lag1+1"]
	# lappend flag9_case1 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "TRUE"]
	# lappend flag9_case1 [gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"]
	# lappend flag9_case1 [gwd::Cfg_StreamActive $hGPNPort3Stream8 "FALSE"]
	# stc::delete $hGPNPort4AnaFrameCfgFil
	# gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
 #    gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
 #    stc::apply	
	# lappend flag9_case1 [Test_TrunkModeAdd $telnet1 $matchType1 $Gpn_type1 $fileId lag1+1 "t1" $masterPort2 $slavePort2 $ptn003_case1_cnt "GPN_PTN_003_FA9"]
	# puts $fileId ""
	# if {"1" in $flag9_case1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA9�����ۣ�trunkģʽΪlag1+1��trunk���Ա��忨������E-LINE��trunk������" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA9�����ۣ�trunkģʽΪlag1+1��trunk���Ա��忨������E-LINE��trunk������" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪlag1+1��trunk���Ա��忨������E-LINE��trunk������  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪlag1:1��trunk���Ա��忨������E-LINE��trunk������  ���Կ�ʼ=====\n"                
	# gwd::GWpublic_addTrunkMode $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" "lag1:1"
	# gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "lag1:1"
	# lappend flag10_case1 [Test_TrunkModeAdd $telnet1 $matchType1 $Gpn_type1 $fileId "lag1:1" "t1" $masterPort2 $slavePort2 $ptn003_case1_cnt "GPN_PTN_003_FA10"]
	# puts $fileId ""
	# if {"1" in $flag10_case1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA10�����ۣ�trunkģʽΪlag1:1��trunk���Ա��忨������E-LINE��trunk������" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA10�����ۣ�trunkģʽΪlag1:1��trunk���Ա��忨������E-LINE��trunk������" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪlag1:1��trunk���Ա��忨������E-LINE��trunk������  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���down�˿�$downPort_dev1\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���down�˿�$downPort_dev3\����ҵ��  ���Կ�ʼ=====\n"
	# gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "sharing"
	# gwd::GWpublic_addTrunkMode $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" "sharing"
	# if {[string match "L3" $trunkLevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "disable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $downPort_dev3 "disable" "disable"
	# } elseif {[string match "L2" $trunkLevel]&&[string match "L3" $Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "disable" "enable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $downPort_dev3 "disable" "enable"
	# }
	# gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" $downPort_dev3
	# gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" $downPort_dev1
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	#             	set flag11_case1 1
	#             }
	# incr id
	# puts $fileId ""
	# if {$flag11_case1 == 1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA11�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���down�˿�$downPort_dev1\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���down�˿�$downPort_dev3\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA11�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���down�˿�$downPort_dev1\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���down�˿�$downPort_dev3\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���down�˿�$downPort_dev1\
	# 		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���down�˿�$downPort_dev3\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��down�˿�$downPort_dev1\
	# 		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��down�˿�$downPort_dev3\����ҵ��  ���Կ�ʼ=====\n"
	# gwd::GWpublic_delPortFromTrunk $telnet1 $matchType1 $Gpn_type1 $fileId t1 $downPort_dev1
	# gwd::GWpublic_delPortFromTrunk $telnet3 $matchType3 $Gpn_type3 $fileId t1 $downPort_dev3
	# if {[string match "L3" $::Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "enable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $downPort_dev3 "enable" "disable"
	# }
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	# 	set flag12_case1 1
	# }
	# incr id
	# puts $fileId ""
	# if {$flag12_case1 == 1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA12�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��down�˿�$downPort_dev1\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��down�˿�$downPort_dev3\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA12�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��down�˿�$downPort_dev1\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��down�˿�$downPort_dev3\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��down�˿�$downPort_dev1\
	# 		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��down�˿�$downPort_dev3\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���up�˿�$GPNPort7\
	# 		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���up�˿�$GPNPort8\����ҵ��  ���Կ�ʼ=====\n"
	# if {[string match "L2" $::trunkLevel]&&[string match "L3" $::Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "disable" "enable"
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "disable" "enable"
	# } elseif {[string match "L3" $::trunkLevel]} {
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "disable" "disable"
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "disable" "disable"
	# }
	# gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "" $GPNPort8
	# gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" $GPNPort7
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	#             	set flag13_case1 1
	#             }
	# incr id
	# puts $fileId ""
	# if {$flag13_case1 == 1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA13�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���up�˿�$GPNPort7\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���up�˿�$GPNPort8\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA13�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���up�˿�$GPNPort7\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���up�˿�$GPNPort8\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���up�˿�$GPNPort7\
 #                		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���up�˿�$GPNPort8\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��up�˿�$GPNPort7\
	# 		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��up�˿�$GPNPort8\����ҵ��  ���Կ�ʼ=====\n"
	# gwd::GWpublic_delPortFromTrunk $telnet1 $matchType1 $Gpn_type1 $fileId t1 $GPNPort7
	# gwd::GWpublic_delPortFromTrunk $telnet3 $matchType3 $Gpn_type3 $fileId t1 $GPNPort8
	# if {[string match "L3" $Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "enable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "enable" "disable"
	# }
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	#             	set flag14_case1 1
	#             }
	# incr id
	# puts $fileId ""
	# if {$flag14_case1 == 1} {
	# 	set flagCase1 1
	# 	gwd::GWpublic_print "NOK" "FA14�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��up�˿�$GPNPort7\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��up�˿�$GPNPort8\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FA14�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��up�˿�$GPNPort7\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��up�˿�$GPNPort8\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��up�˿�$GPNPort7\
	# 		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��up�˿�$GPNPort8\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunk���Աͬ�忨������E-LINE��trunk������  ���Կ�ʼ=====\n"
	# gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "shutdown"
	# gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "undo shutdown"
	# if {[string match "L2" $trunkLevel]} {
	# 	lappend flag2_case1 [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
	# 	lappend flag2_case1 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"]
	# 	lappend flag2_case1 [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]
	# 	lappend flag2_case1 [gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
	# 	lappend flag2_case1 [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"]
	# 	lappend flag2_case1 [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
	# 	lappend flag2_case1 [gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static"]
	# 	lappend flag2_case1 [gwd::GWTrunk_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static"]
	# 	lappend flag2_case1 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "disable" "enable"]
	# 	lappend flag2_case1 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "disable" "enable"]
	# 	lappend flag2_case1 [gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "$GPNPort5 $GPNPort7"]
	# 	lappend flag2_case1 [gwd::GWL2Inter_AddVlanPort $telnet1 $matchType1 $Gpn_type1 $fileId "10" "trunk" "t1" "untagged"]
	# 	lappend flag2_case1 [gwd::GWpublic_CfgVlanIp $telnet1 $matchType1 $Gpn_type1 $fileId "10" $ip1 "24"]
	# 	lappend flag2_case1 [gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "vlan" "v10" $ip2 "100" "100" "normal" "1"]

	# 	lappend flag2_case1 [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort6 "disable" "enable"]
	# 	lappend flag2_case1 [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "disable" "enable"]
	# 	lappend flag2_case1 [gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" "$GPNPort6 $GPNPort8"]
	# 	lappend flag2_case1 [gwd::GWL2Inter_AddVlanPort $telnet3 $matchType3 $Gpn_type3 $fileId 10 "trunk" "t1" "untagged"]
	# 	lappend flag2_case1 [gwd::GWpublic_CfgVlanIp $telnet3 $matchType3 $Gpn_type3 $fileId "10" $ip2 "24"]
	# 	lappend flag2_case1 [gwd::GWStaLsp_AddLspInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" "vlan" "v10" $ip1 "100" "100" "normal" "2"]
	# } else {
	# 	lappend flag2_case1 [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
	# 	lappend flag2_case1 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"]
	# 	lappend flag2_case1 [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]
	# 	lappend flag2_case1 [gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "10"]
	# 	lappend flag2_case1 [gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4094"]
	# 	lappend flag2_case1 [gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" ""]
	# 	lappend flag2_case1 [gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
	# 	lappend flag2_case1 [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"]
	# 	lappend flag2_case1 [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
	# 	lappend flag2_case1 [gwd::GWL3Inter_DelL3 $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t1" "10"]
	# 	lappend flag2_case1 [gwd::GWL3Inter_DelL3 $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t1" "4094"]
	# 	lappend flag2_case1 [gwd::GWTrunk_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" ""]
	# 	lappend flag2_case1 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "disable" "disable"]
	# 	lappend flag2_case1 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "disable" "disable"]
	# 	lappend flag2_case1 [gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "$GPNPort5 $GPNPort7"]
	# 	lappend flag2_case1 [gwd::GWL3_AddInterDcn_reconfiguration $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "enable" "static"]
	# 	lappend flag2_case1 [gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "10"]
	# 	lappend flag2_case1 [gwd::GWL3port_AddIP $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "10" $ip1 "24"]
	# 	lappend flag2_case1 [gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "trunk" "t1.10" $ip2 "100" "100" "normal" "1"]
	# 	lappend flag2_case1 [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort6 "disable" "disable"]
	# 	lappend flag2_case1 [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "disable" "disable"]
	# 	lappend flag2_case1 [gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" "$GPNPort6 $GPNPort8"]
	# 	lappend flag2_case1 [gwd::GWL3_AddInterDcn_reconfiguration $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t1" "enable" "static"]
	# 	lappend flag2_case1 [gwd::GWL3Inter_AddL3 $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t1" "10"]
	# 	lappend flag2_case1 [gwd::GWL3port_AddIP $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t1" "10" $ip2 "24"]
	# 	lappend flag2_case1 [gwd::GWStaLsp_AddLspInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" "trunk" "t1.10" $ip1 "100" "100" "normal" "2"]
	# }
	# lappend flag2_case1 [gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "lag1:1"]
	# lappend flag2_case1 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $address1]
	# lappend flag2_case1 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]
	# lappend flag2_case1 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""]
	# lappend flag2_case1 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "50" $GPNTestEth3]
	# lappend flag2_case1 [gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"]

	# lappend flag2_case1 [gwd::GWpublic_addTrunkMode $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" "lag1:1"]
	# lappend flag2_case1 [gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" $address2]
	# lappend flag2_case1 [gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
	# lappend flag2_case1 [gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "nochange" "" 1 0 "0x8100" "0x8100" ""]
	# lappend flag2_case1 [gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline"]
	# set downPort_dev1 1/1
	set downPort_dev3 1/1
	gwd::GWmanage_GetPortInfo $telnet1 $matchType1 $Gpn_type1 $fileId KeyInfo
	regexp {(\d+)/\d+} $GPNPort5 match slot1
	regexp {(\d+)/\d+} $GPNPort9 match slot2
	dict for {key value} $KeyInfo {
		regexp {(\d+)/\d+} $key match slot
		if {($slot == $slot1) || ($slot == $slot2)} {
			if {[string match -nocase [dict get $value PhyStat] down] && [string match -nocase [dict get $value AdminStat] up]} {
				set downPort_dev1 $key
				break
			}
		}
	}
	gwd::GWmanage_GetPortInfo $telnet3 $matchType3 $Gpn_type3 $fileId KeyInfo
	regexp {(\d+)/\d+} $GPNPort8 match slot1
	regexp {(\d+)/\d+} $GPNPort10 match slot2
	dict for {key value} $KeyInfo {
		regexp {(\d+)/\d+} $key match slot
		if {($slot == $slot1) || ($slot == $slot2)} {
			if {[string match -nocase [dict get $value PhyStat] down] && [string match -nocase [dict get $value AdminStat] up]} {
				set downPort_dev3 $key
				break
			}
		}
	}
	###�õ�trunk���Ա�����˿ںʹӶ˿ڣ��˿ں�С�Ŀ������˿�------
	set port1 0
	set port2 0
	regexp {\d+/(\d+)} $GPNPort6 match port1
	regexp {\d+/(\d+)} $GPNPort8 match port2
	if {$port1 < $port2} {
		set masterPort1 $GPNPort6
	} else {
		set masterPort1 $GPNPort8
	}
	if {$port1 > $port2} {
		set slavePort1 $GPNPort6
	} else {
		set slavePort1 $GPNPort8
	}
	set port1 0
	set port2 0
	regexp {\d+/(\d+)} $GPNPort5 match port1
	regexp {\d+/(\d+)} $GPNPort7 match port2
	if {$port1 < $port2} {
		set masterPort2 $GPNPort5
	} else {
		set masterPort2 $GPNPort7
	}
	if {$port1 > $port2} {
		set slavePort2 $GPNPort5
	} else {
		set slavePort2 $GPNPort7
	}
	##------�õ�trunk���Ա�����˿ںʹӶ˿ڣ��˿ں�С�Ŀ������˿�
	            #####################################################lagģʽΪ1:1##################################################################
	# lappend flag1_case2 [Test_TrunkModeAdd $telnet3 $matchType3 $Gpn_type3 $fileId lag1:1 "t1" $masterPort1 $slavePort1 $ptn003_case1_cnt "GPN_PTN_003_FB1"]
	# puts $fileId ""
	# if {"1" in $flag1_case2} {
	# 	set flagCase2 1
	# 	gwd::GWpublic_print "NOK" "FB1�����ۣ�trunkģʽΪstatic��trunkģʽΪlag1:1��trunk���Աͬ�忨������E-LINE��trunk������" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FB1�����ۣ�trunkģʽΪstatic��trunkģʽΪlag1:1��trunk���Աͬ�忨������E-LINE��trunk������" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪlag1:1��trunk���Աͬ�忨������E-LINE��trunk������  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��trunk���Աͬ�忨������E-LINE��trunk������  ���Կ�ʼ=====\n"
	# ######################################################lagģʽΪsharing##################################################################
	# lappend flag3_case2 [gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "sharing"]
	# lappend flag3_case2 [gwd::GWpublic_addTrunkPolicy $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "srcmac-based"]
	# lappend flag3_case2 [gwd::GWpublic_addTrunkMode $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" "sharing"]
	# lappend flag3_case2 [gwd::GWpublic_addTrunkPolicy $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" "srcmac-based"]
	# lappend flag3_case2 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "FALSE"]
	# stc::apply
 # 	lappend flag3_case2 [Test_TrunkSharing $telnet1 $matchType1 $Gpn_type1 $fileId sharing "t1" $masterPort2 $slavePort2 "false" "GPN_PTN_003_FB2_1"]
 # 	lappend flag3_case2 [gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"]
	# lappend flag3_case2 [gwd::Cfg_StreamActive $hGPNPort3Stream8 "TRUE"]
	# stc::apply
	# lappend flag3_case2 [Test_TrunkSharing $telnet1 $matchType1 $Gpn_type1 $fileId sharing "t1" $masterPort2 $slavePort2 "true" "GPN_PTN_003_FB2_2"]
	# puts $fileId ""
	# if {"1" in $flag3_case2} {
	# 	set flagCase2 1
	# 	gwd::GWpublic_print "NOK" "FB2�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��trunk���Աͬ�忨������E-LINE��trunk������" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FB2�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��trunk���Աͬ�忨������E-LINE��trunk������" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��trunk���Աͬ�忨������E-LINE��trunk������  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���down�˿�$downPort_dev1\
	# 				$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���down�˿�$downPort_dev3\����ҵ��  ���Կ�ʼ=====\n"
	# if {[string match "L3" $trunkLevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "disable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $downPort_dev3 "disable" "disable"
	# } elseif {[string match "L2" $trunkLevel]&&[string match "L3" $Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "disable" "enable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $downPort_dev3 "disable" "enable"
	# }
	# gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" $downPort_dev1
	# gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" $downPort_dev3
	# lappend flag4_case2 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "TRUE"]
	# lappend flag4_case2 [gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"]
	# lappend flag4_case2 [gwd::Cfg_StreamActive $hGPNPort3Stream8 "FALSE"]
	# stc::apply
	# incr capId
	# stc::delete $hGPNPort4AnaFrameCfgFil
	# gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
 #    gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
 #    stc::apply
	# lappend flag4_case2 [TestFlow $fileId "GPN_PTN_003_$capId"]
	# incr id
	# puts $fileId ""
	# if {"1" in $flag4_case2} {
	# 	set flagCase2 1
	# 	gwd::GWpublic_print "NOK" "FB3�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���down�˿�$downPort_dev1\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���down�˿�$downPort_dev3\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FB3�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���down�˿�$downPort_dev1\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���down�˿�$downPort_dev3\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���down�˿�$downPort_dev1\
	# 						$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���down�˿�$downPort_dev3\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��down�˿�$downPort_dev1\
	# 				$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��down�˿�$downPort_dev3\����ҵ��  ���Կ�ʼ=====\n"
	# gwd::GWpublic_delPortFromTrunk $telnet1 $matchType1 $Gpn_type1 $fileId "t1 "static" $downPort_dev1
	# gwd::GWpublic_delPortFromTrunk $telnet3 $matchType3 $Gpn_type3 $fileId "t1 "static" $downPort_dev3
	# if {[string match "L3" $::Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "enable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $downPort_dev3 "enable" "disable"
	# }
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	# 	set flag5_case2 1
	# }
	# incr id
	# puts $fileId ""
	# if {$flag5_case2 == 1} {
	# 	set flagCase2 1
	# 	gwd::GWpublic_print "NOK" "FB4�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��down�˿�$downPort_dev1\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��down�˿�$downPort_dev3\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FB4�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��down�˿�$downPort_dev1\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��down�˿�$downPort_dev3\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��down�˿�$downPort_dev1\
	# 						$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��down�˿�$downPort_dev3\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���up�˿�$GPNPort9\
	# 						$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���up�˿�$GPNPort10\����ҵ��  ���Կ�ʼ=====\n"
	# if {[string match "L2" $::trunkLevel]&&[string match "L3" $::Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort10 "disable" "enable"
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "disable" "enable"
	# } elseif {[string match "L3" $::trunkLevel]} {
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort10 "disable" "disable"
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "disable" "disable"
	# }
	# gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" "$GPNPort10"
	# gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "$GPNPort9"
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	# 	set flag6_case2 1
	# }
	# incr id
	# puts $fileId ""
	# if {$flag6_case2 == 1} {
	# 	set flagCase2 1
	# 	gwd::GWpublic_print "NOK" "FB5�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���up�˿�$GPNPort9\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���up�˿�$GPNPort10\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FB5�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���up�˿�$GPNPort9\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���up�˿�$GPNPort10\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���up�˿�$GPNPort9\
	# 						$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���up�˿�$GPNPort10\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��up�˿�$GPNPort9\
	# 						$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��up�˿�$GPNPort10\����ҵ��  ���Կ�ʼ=====\n"
	# gwd::GWpublic_delPortFromTrunk $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" $GPNPort9
	# gwd::GWpublic_delPortFromTrunk $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" $GPNPort10
	# if {[string match "L3" $Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "enable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort10 "enable" "disable"
	# }
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	# 	set flag7_case2 1
	# }
	# incr id
	# puts $fileId ""
	# if {$flag7_case2 == 1} {
	# 	set flagCase2 1
	# 	gwd::GWpublic_print "NOK" "FB6�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��up�˿�$GPNPort9\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��up�˿�$GPNPort10\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FB6�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��up�˿�$GPNPort9\
	# 					$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��up�˿�$GPNPort10\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��up�˿�$GPNPort9\
	# 						$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��up�˿�$GPNPort10\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��trunk���Ա��忨������E-LINE��trunk������  ���Կ�ʼ=====\n"
	# ######################################################lagģʽΪsharing##################################################################
	# ###�õ�trunk���Ա�����˿ںʹӶ˿ڣ��˿ں�С�Ŀ������˿�------
	# gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "shutdown"
	# gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "undo shutdown"
	set port1 0
	set port2 0
	regexp {\d+/(\d+)} $GPNPort6 match port1
	regexp {\d+/(\d+)} $GPNPort10 match port2
	if {$port1 < $port2} {
		set masterPort1 $GPNPort6
	} else {
		set masterPort1 $GPNPort10
	}
	if {$port1 > $port2} {
		set slavePort1 $GPNPort6
	} else {
		set slavePort1 $GPNPort10
	}
	set port1 0
	set port2 0
	regexp {\d+/(\d+)} $GPNPort5 match port1
	regexp {\d+/(\d+)} $GPNPort9 match port2
	if {$port1 < $port2} {
		set masterPort2 $GPNPort5
	} else {
		set masterPort2 $GPNPort9
	}
	if {$port1 > $port2} {
		set slavePort2 $GPNPort5
	} else {
		set slavePort2 $GPNPort9
	}
	# ##------�õ�trunk���Ա�����˿ںʹӶ˿ڣ��˿ں�С�Ŀ������˿�
	# if {[string match "L2" $trunkLevel] && [string match "L3" $Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "disable" "enable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort10 "disable" "enable"
	# } elseif {[string match "L3" $trunkLevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "disable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort10 "disable" "disable"
	# }
	# gwd::GWpublic_delPortFromTrunkSta $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" $GPNPort7
	# gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "$GPNPort9"
	# gwd::GWpublic_delPortFromTrunkSta $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" $GPNPort8
	# gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" "$GPNPort10"
	# lappend flag8_case2 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "FALSE"]
	# stc::apply

	# lappend flag8_case2 [Test_TrunkSharing $telnet1 $matchType1 $Gpn_type1 $fileId sharing "t1" $masterPort2 $slavePort2 "false" "GPN_PTN_003_FB7_2"]
	# lappend flag8_case2 [gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"]
	# lappend flag8_case2 [gwd::Cfg_StreamActive $hGPNPort3Stream8 "TRUE"]
	# stc::apply
	# lappend flag8_case2 [Test_TrunkSharing $telnet1 $matchType1 $Gpn_type1 $fileId sharing "t1" $masterPort2 $slavePort2 "true" "GPN_PTN_003_FB7_2"]
	# puts $fileId ""
	# if {"1" in $flag8_case2} {
	# 	set flagCase2 1
	# 	gwd::GWpublic_print "NOK" "FB7�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��trunk���Ա��忨������E-LINE��trunk������" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FB7�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��trunk���Ա��忨������E-LINE��trunk������" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��trunk���Ա��忨������E-LINE��trunk������  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪlag1:1��trunk���Ա��忨������E-LINE��trunk������  ���Կ�ʼ=====\n"                
	# gwd::GWpublic_addTrunkMode $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" "lag1:1"
	# gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "lag1:1"
	# lappend flag10_case2 [gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"]
	# lappend flag10_case2 [gwd::Cfg_StreamActive $hGPNPort3Stream8 "FALSE"]
	# lappend flag8_case2 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "TRUE"]
	# stc::delete $hGPNPort4AnaFrameCfgFil
	# gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
 #    gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
 #    stc::apply
	#lappend flag10_case2 [Test_TrunkModeAdd $telnet1 $matchType1 $Gpn_type1 $fileId "lag1:1" "t1" $masterPort2 $slavePort2 $ptn003_case1_cnt "GPN_PTN_003_FB10"]
	# puts $fileId ""
	# if {"1" in $flag10_case2} {
	# 	set flagCase2 1
	# 	gwd::GWpublic_print "NOK" "FB8�����ۣ�trunkģʽΪstatic��trunkģʽΪlag1:1��trunk���Ա��忨������E-LINE��trunk������" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FB8�����ۣ�trunkģʽΪstatic��trunkģʽΪlag1:1��trunk���Ա��忨������E-LINE��trunk������" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪlag1:1��trunk���Ա��忨������E-LINE��trunk������  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���down�˿�$downPort_dev1\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���down�˿�$downPort_dev3\����ҵ��  ���Կ�ʼ=====\n"
	# gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "sharing"
	# gwd::GWpublic_addTrunkMode $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" "sharing"
	# if {[string match "L3" $trunkLevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "disable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $downPort_dev3 "disable" "disable"
	# } elseif {[string match "L2" $trunkLevel]&&[string match "L3" $Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "disable" "enable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $downPort_dev3 "disable" "enable"
	# }
	# gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" $downPort_dev3
	# gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" $downPort_dev1
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	#             	set flag11_case2 1
	#             }
	# incr id
	# puts $fileId ""
	# if {$flag11_case2 == 1} {
	# 	set flagCase2 1
	# 	gwd::GWpublic_print "NOK" "FB9�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���down�˿�$downPort_dev1\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���down�˿�$downPort_dev3\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FB9�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���down�˿�$downPort_dev1\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���down�˿�$downPort_dev3\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���down�˿�$downPort_dev1\
	# 		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���down�˿�$downPort_dev3\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��down�˿�$downPort_dev1\
	# 		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��down�˿�$downPort_dev3\����ҵ��  ���Կ�ʼ=====\n"
	# gwd::GWpublic_delPortFromTrunkSta $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" $downPort_dev1
	# gwd::GWpublic_delPortFromTrunkSta $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" $downPort_dev3
	# if {[string match "L3" $::Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "enable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $downPort_dev3 "enable" "disable"
	# }
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	# 	set flag12_case2 1
	# }
	# incr id
	# puts $fileId ""
	# if {$flag12_case2 == 1} {
	# 	set flagCase2 1
	# 	gwd::GWpublic_print "NOK" "FB10�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��down�˿�$downPort_dev1\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��down�˿�$downPort_dev3\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FB10�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��down�˿�$downPort_dev1\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��down�˿�$downPort_dev3\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��down�˿�$downPort_dev1\
	# 		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��down�˿�$downPort_dev3\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���up�˿�$GPNPort7\
	# 		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���up�˿�$GPNPort8\����ҵ��  ���Կ�ʼ=====\n"
	# if {[string match "L2" $::trunkLevel]&&[string match "L3" $::Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "disable" "enable"
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "disable" "enable"
	# } elseif {[string match "L3" $::trunkLevel]} {
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "disable" "disable"
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "disable" "disable"
	# }
	# gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" $GPNPort8
	# gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" $GPNPort7
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	#             	set flag13_case2 1
	#             }
	# incr id
	# puts $fileId ""
	# if {$flag13_case2 == 1} {
	# 	set flagCase2 1
	# 	gwd::GWpublic_print "NOK" "FB11�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���up�˿�$GPNPort7\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���up�˿�$GPNPort8\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FB11�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���up�˿�$GPNPort7\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���up�˿�$GPNPort8\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���up�˿�$GPNPort7\
 #                		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���up�˿�$GPNPort8\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��up�˿�$GPNPort7\
	# 		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��up�˿�$GPNPort8\����ҵ��  ���Կ�ʼ=====\n"
	# gwd::GWpublic_delPortFromTrunkSta $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" $GPNPort7
	# gwd::GWpublic_delPortFromTrunkSta $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static" $GPNPort8
	# if {[string match "L3" $Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "enable" "disable"
	# 	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "enable" "disable"
	# }
	# incr capId
	# if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
	#             	set flag14_case2 1
	#             }
	# incr id
	# puts $fileId ""
	# if {$flag14_case2 == 1} {
	# 	set flagCase2 1
	# 	gwd::GWpublic_print "NOK" "FB12�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��up�˿�$GPNPort7\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��up�˿�$GPNPort8\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FB12�����ۣ�trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��up�˿�$GPNPort7\
	# 			$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��up�˿�$GPNPort8\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��up�˿�$GPNPort7\
	# 		$matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��up�˿�$GPNPort8\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }

	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��AC��Ϊtrunk�ڲ���E-LINEҵ��  ���Կ�ʼ=====\n"
	#####################################################AC�˿�Ϊtrunk############################################
	# lappend flag1_case3 [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
	# lappend flag1_case3 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
	# lappend flag1_case3 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"]
	# lappend flag1_case3 [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]
	# lappend flag1_case3 [gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
	# lappend flag1_case3 [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
	# lappend flag1_case3 [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"]
	# lappend flag1_case3 [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
	
	# if {[string match "L2" $trunkLevel]} {
	# 	lappend flag1_case3 [gwd::GWpublic_Delvlan $telnet1 $matchType1 $Gpn_type1 $fileId "10"]
	# 	lappend flag1_case3 [gwd::GWpublic_Delvlan $telnet3 $matchType3 $Gpn_type3 $fileId "10"]
	# 	lappend flag1_case3 [gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static"]
	# 	lappend flag1_case3 [gwd::GWTrunk_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static"]
		
	# 	lappend flag1_case3 [gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNPort15,$GPNPort16"]
	# 	lappend flag1_case3 [gwd::GWL2Inter_AddVlanPort $telnet1 $matchType1 $Gpn_type1 $fileId "50" "trunk" "t1" "tagged"]
	# } else {
	# 	lappend flag1_case3 [gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "10"]
	# 	lappend flag1_case3 [gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4094"]
	# 	lappend flag1_case3 [gwd::GWL3Inter_DelL3 $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t1" "10"]
	# 	lappend flag1_case3 [gwd::GWL3Inter_DelL3 $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t1" "4094"]
	# 	lappend flag1_case3 [gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "ethernet" $GPNTestEth3 "50"]
	# 	lappend flag1_case3 [gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static"]
	# 	lappend flag1_case3 [gwd::GWTrunk_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t1" "static"]
	# 	lappend flag1_case3 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "enable" "disable"]
	# 	lappend flag1_case3 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "enable" "disable"]
	# 	lappend flag1_case3 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "enable" "disable"]
	# 	lappend flag1_case3 [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort6 "enable" "disable"]
	# 	lappend flag1_case3 [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "enable" "disable"]
	# 	lappend flag1_case3 [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort10 "enable" "disable"]
		
	# 	lappend flag1_case3 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort15 "disable" "disable"]
	# 	lappend flag1_case3 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort16 "disable" "disable"]
	# 	lappend flag1_case3 [gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNPort15,$GPNPort16"]
	# 	lappend flag1_case3 [gwd::GWL3_AddInterDcn $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "enable"]
	# 	lappend flag1_case3 [gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "50"]	

	# }
	# lappend flag1_case3 [PTN_NNI_AddInterIp $fileId $Worklevel $interface11 $ip1 $GPNPort5 $matchType1 $Gpn_type1 $telnet1]
	# lappend flag1_case3 [PTN_NNI_AddInterIp $fileId $Worklevel $interface10 $ip2 $GPNPort6 $matchType3 $Gpn_type3 $telnet3]
	# lappend flag1_case3 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $interface11 $ip2 "100" "100" "normal" "1"]
	# lappend flag1_case3 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $address1]
	# lappend flag1_case3 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]
	# lappend flag1_case3 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""]
	# lappend flag1_case3 [gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" "trunk t1" 50 0 "nochange" 1 0 0 "0x8100"]
	# lappend flag1_case3 [gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"]
	
	# lappend flag1_case3 [gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" $interface10 $ip1 "100" "100" "normal" "2"]
	# lappend flag1_case3 [gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" $address2]
	# lappend flag1_case3 [gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
	# lappend flag1_case3 [gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "nochange" "" 1 0 "0x8100" "0x8100" ""]
	# lappend flag1_case3 [gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 0 0 "nochange" 1 0 0 "0x8100"]
	# lappend flag1_case3 [gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline"]
	# set telnet4 [gwd::H3Cpublic_login $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	# lappend flag1_case3 [GW_SetTrunkMaster $telnet1 $matchType1 $Gpn_type1 $fileId "t1" $GPNPort15]
	#lappend flag1_case3 [gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "sharing"]
	# ###����vlan�ӿ�
	# lappend flag1_case3 [gwd::H3C_AddL2Vlan $telnet4 $matchType4 $Gpn_type4 $fileId "50"]
	# lappend flag1_case3 [gwd::H3C_AddL2Vlan $telnet4 $matchType4 $Gpn_type4 $fileId "1000"]
	# ##���û����豸��trunk����ת�������������е�vlan����ת��
	# lappend flag1_case3 [gwd::H3C_SetTrunkLinkType $telnet4 $matchType4 $Gpn_type4 $fileId "1" "trunk"]
	# lappend flag1_case3 [gwd::H3C_SetTrunkPermitVlan $telnet4 $matchType4 $Gpn_type4 $fileId "1" "all"]
	# lappend flag1_case3 [gwd::H3C_SetEthLinkType $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort17 "trunk"]
	# lappend flag1_case3 [gwd::H3CL2Inter_AddToVlan $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort17 "trunk" "all"]
	# lappend flag1_case3 [gwd::H3CL2Port_AddToTrunk $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort17 "1"]
	# lappend flag1_case3 [gwd::H3C_SetEthLinkType $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort18 "trunk"]
	# lappend flag1_case3 [gwd::H3CL2Inter_AddToVlan $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort18 "trunk" "all"]
 #    lappend flag1_case3 [gwd::H3CL2Port_AddToTrunk $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort18 "1"]
 #    ###���Ǳ�������Ŀ���Ϊtrunk����������vlanͨ��
 #    lappend flag1_case3 [gwd::H3C_SetEthLinkType $telnet4 $matchType4 $Gpn_type4 $fileId $GPNTestEth5 "trunk"]
 #    lappend flag1_case3 [gwd::H3CL2Inter_AddToVlan $telnet4 $matchType4 $Gpn_type4 $fileId $GPNTestEth5 "trunk" "all"]
	# lappend flag1_case3 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "FALSE"]
	set masterPort2 $GPNPort15
	set slavePort2 $GPNPort16
	# lappend flag1_case3 [gwd::Cfg_StreamActive $hGPNPort5Stream9 "TRUE"]
	# stc::apply
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
 # 	lappend flag1_case3 [Test_TrunkSharing $telnet1 $matchType1 $Gpn_type1 $fileId sharing "t1" $masterPort2 $slavePort2 "false" "GPN_PTN_003_FC1_1"]
 # 	lappend flag1_case3 [gwd::Cfg_StreamActive $hGPNPort5Stream9 "FALSE"]
	# lappend flag1_case3 [gwd::Cfg_StreamActive $hGPNPort5Stream10 "TRUE"]
	# stc::apply
	# lappend flag1_case3 [Test_TrunkSharing $telnet1 $matchType1 $Gpn_type1 $fileId sharing "t1" $masterPort2 $slavePort2 "true" "GPN_PTN_003_FC1_2"]
	# incr id
	# puts $fileId ""
	# if {"1" in $flag1_case3} {
	# 	set flagCase3 1
	# 	gwd::GWpublic_print "NOK" "FC1�����ۣ�trunkģʽΪsharing��AC��Ϊtrunk�ڲ���E-LINEҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FC1�����ۣ�trunkģʽΪsharing��AC��Ϊtrunk�ڲ���E-LINEҵ��" $fileId
	# }
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# if {[catch {
	# 			close -i $telnet4
	# 			} err] } {
	# 			puts $err
	# 		}
	# set telnet4 [gwd::H3Cpublic_login $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	# set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# set downPort_dev1 1/1
	# gwd::GWmanage_GetPortInfo $telnet1 $matchType1 $Gpn_type1 $fileId KeyInfo
	# regexp {(\d+)/\d+} $GPNPort15 match slot1
	# regexp {(\d+)/\d+} $GPNPort16 match slot2
	# dict for {key value} $KeyInfo {
	# 	regexp {(\d+)/\d+} $key match slot
	# 	if {($slot == $slot1) || ($slot == $slot2)} {
	# 		if {[string match -nocase [dict get $value PhyStat] down] && [string match -nocase [dict get $value AdminStat] up]} {
	# 			set downPort_dev1 $key
	# 			break
	# 		}
	# 	}
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���down�˿�$downPort_dev1\����ҵ��  ���Կ�ʼ=====\n"
	
	# if {[string match "L3" $trunkLevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "disable" "disable"
	# } elseif {[string match "L2" $trunkLevel]&&[string match "L3" $Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "disable" "enable"
	# }
	# gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" $downPort_dev1
	lappend flag2_case3 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "TRUE"]
	lappend flag2_case3 [gwd::Cfg_StreamActive $hGPNPort5Stream9 "TRUE"]
	#lappend flag2_case3 [gwd::Cfg_StreamActive $hGPNPort5Stream10 "FALSE"]
	stc::apply
	stc::delete $hGPNPort4AnaFrameCfgFil
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
    gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
    stc::apply
	# incr capId
	# lappend flag2_case3 [TestFlowUNI $fileId "GPN_PTN_003_$capId"]
	# incr id
	# puts $fileId ""
	# if {"1" in $flag2_case3} {
	# 	set flagCase3 1
	# 	gwd::GWpublic_print "NOK" "FC2�����ۣ�uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���down�˿�$downPort_dev1\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FC2�����ۣ�uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���down�˿�$downPort_dev1\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���down�˿�$downPort_dev1\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# if {[catch {
	# 			close -i $telnet4
	# 			} err] } {
	# 			puts $err
	# 		}
	# set telnet4 [gwd::H3Cpublic_login $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	# set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��down�˿�$downPort_dev1\����ҵ��  ���Կ�ʼ=====\n"
	# gwd::GWpublic_delPortFromTrunk $telnet1 $matchType1 $Gpn_type1 $fileId t1 $downPort_dev1
	# if {[string match "L3" $::Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "enable" "disable"
	# }
	# incr capId
	# if {[TestFlowUNI $fileId "GPN_PTN_003_$capId"]} {
	# 	set flag3_case3 1
	# }
	# incr id
	# puts $fileId ""
	# if {$flag3_case3 == 1} {
	# 	set flagCase3 1
	# 	gwd::GWpublic_print "NOK" "FC3�����ۣ�uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��down�˿�$downPort_dev1\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FC3�����ۣ�uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��down�˿�$downPort_dev1\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��down�˿�$downPort_dev1\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# if {[catch {
	# 			close -i $telnet4
	# 			} err] } {
	# 			puts $err
	# 		}
	# set telnet4 [gwd::H3Cpublic_login $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	# set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���up�˿�$GPNPort9\����ҵ��  ���Կ�ʼ=====\n"
	# if {[string match "L2" $::trunkLevel]&&[string match "L3" $::Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "disable" "enable"
	# } elseif {[string match "L3" $::trunkLevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "disable" "disable"
	# }
	# gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNPort9"
	# incr capId
	# if {[TestFlowUNI $fileId "GPN_PTN_003_$capId"]} {
	# 	set flag4_case3 1
	# }
	# incr id
	# puts $fileId ""
	# if {$flag4_case3 == 1} {
	# 	set flagCase3 1
	# 	gwd::GWpublic_print "NOK" "FC4�����ۣ�uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���up�˿�$GPNPort9\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FC4�����ۣ�uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���up�˿�$GPNPort9\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���up�˿�$GPNPort9\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��up�˿�$GPNPort9\����ҵ��  ���Կ�ʼ=====\n"
	# gwd::GWpublic_delPortFromTrunk $telnet1 $matchType1 $Gpn_type1 $fileId t1 $GPNPort9
	# if {[string match "L3" $Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "enable" "disable"
	# }
	# incr capId
	# if {[TestFlowUNI $fileId "GPN_PTN_003_$capId"]} {
	# 	set flag5_case3 1
	# }
	# incr id
	# puts $fileId ""
	# if {$flag5_case3 == 1} {
	# 	set flagCase3 1
	# 	gwd::GWpublic_print "NOK" "FC5�����ۣ�uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��up�˿�$GPNPort9\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FC5�����ۣ�uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��up�˿�$GPNPort9\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��up�˿�$GPNPort9\����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# if {[catch {
	# 			close -i $telnet4
	# 			} err] } {
	# 			puts $err
	# 		}
	# set telnet4 [gwd::H3Cpublic_login $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	# set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
# 	puts $fileId ""
# 	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪsharing��AC��Ϊtrunk�ڲ���E-LINEҵ��  ���Խ���=====\n"
# 	puts $fileId "======================================================================================\n"
# 	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪlag1:1,����E-LINE��trunk������  ���Կ�ʼ=====\n"
# 	lappend flag6_case3 [gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "lag1:1"]
# 	lappend flag6_case3 [gwd::H3CL2Port_DelToTrunk $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort17 "1"]
# 	lappend flag6_case3 [gwd::H3CL2Port_DelToTrunk $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort18 "1"]
# 	lappend flag6_case3 [gwd::H3C_AddL3Trunk $telnet4 $matchType4 $Gpn_type4 $fileId "1" "dynamic"]
# 	lappend flag6_case3 [gwd::H3CL2Port_AddToTrunk $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort17 "1"]
# 	lappend flag6_case3 [gwd::H3CL2Port_AddToTrunk $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort18 "1"]
# 	lappend flag6_case3 [Test_TrunkModeAddUNI $telnet1 $matchType1 $Gpn_type1 $fileId lag1:1 "t1" $masterPort2 $slavePort2 1 "GPN_PTN_003_FC6"]
# 	incr id
# 	puts $fileId ""
# 	if {$flag6_case3 == 1} {
# 		set flagCase3 1
# 		gwd::GWpublic_print "NOK" "FC6�����ۣ�uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪlag1:1������E-LINE��trunk������" $fileId
# 	} else {
# 		gwd::GWpublic_print "OK" "FC6�����ۣ�uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪlag1:1������E-LINE��trunk������" $fileId
# 	}
# 	puts $fileId ""
# 	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪlag1:1��trunk���Ա��忨������E-LINE��trunk������  ���Խ���=====\n"
# 	incr tcId
# 	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
# 	incr cfgId
# 	if {[catch {
# 				close -i $telnet4
# 				} err] } {
# 				puts $err
# 			}
# 	set telnet4 [gwd::H3Cpublic_login $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
# 	set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
# 	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
# 	if {$lFailFileTmp != ""} {
# 		set lFailFile [concat $lFailFile $lFailFileTmp]
# 	}
# 	puts $fileId ""
# 	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni�ӿ�ʹ���ֹ�trunk��trunkģʽΪlag1:1��trunk���Ա��忨������E-LINE��trunk������  ���Խ���=====\n"
# 	############################################ɾ��trunkģ������##########################################################################
# 	puts $fileId "======================================================================================\n"
# 	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni������trunkģʽΪstatic������E-LINE��trunk������  ���Կ�ʼ=====\n"
# 	if {[string match "L2" $trunkLevel]} {
# 		lappend flag1_case4 [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
# 		lappend flag1_case4 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
# 		lappend flag1_case4 [gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" ""]
# 		lappend flag1_case4 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 "disable" "enable"]
# 		lappend flag1_case4 [gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "$GPNPort15,$GPNPort16"]
# 		lappend flag1_case4 [gwd::GWL2Inter_AddVlanPort $telnet1 $matchType1 $Gpn_type1 $fileId "50" "trunk" "t1" "untagged"]
# 		lappend flag1_case4 [gwd::GWpublic_CfgVlanIp $telnet1 $matchType1 $Gpn_type1 $fileId "50" $ip1 "24"]
# 	} else {
# 		lappend flag1_case4 [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
# 		lappend flag1_case4 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
# 		lappend flag1_case4 [gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "50"]
# 		lappend flag1_case4 [gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4094"]
# 		lappend flag1_case4 [gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" ""]
# 		lappend flag1_case4 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort15 "disable" "disable"]
# 		lappend flag1_case4 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort16 "disable" "disable"]
# 		lappend flag1_case4 [gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "$GPNPort15,$GPNPort16"]
# 		lappend flag1_case4 [gwd::GWL3_AddInterDcn_reconfiguration $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "enable" "static"]
# 		lappend flag1_case3 [gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "50"]	
# 	}
# 	lappend flag1_case4 [gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "lag1:1"]
# 	lappend flag1_case4 [gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" "trunk t1" 50 0 "nochange" 1 0 0 "0x8100"]
# 	lappend flag1_case4 [gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"]
# 	set downPort_dev1 1/1
# 	gwd::GWmanage_GetPortInfo $telnet1 $matchType1 $Gpn_type1 $fileId KeyInfo
# 	regexp {(\d+)/\d+} $GPNPort15 match slot1
# 	regexp {(\d+)/\d+} $GPNPort16 match slot2
# 	dict for {key value} $KeyInfo {
# 		regexp {(\d+)/\d+} $key match slot
# 		if {($slot == $slot1) || ($slot == $slot2)} {
# 			if {[string match -nocase [dict get $value PhyStat] down] && [string match -nocase [dict get $value AdminStat] up]} {
# 				set downPort_dev1 $key
# 				break
# 			}
# 		}
# 	}
# 	##------�õ�trunk���Ա�����˿ںʹӶ˿ڣ��˿ں�С�Ŀ������˿�
# 	            #####################################################lagģʽΪ1:1##################################################################
# 	lappend flag1_case4 [Test_TrunkModeAddUNI $telnet1 $matchType1 $Gpn_type1 $fileId lag1:1 "t1" $masterPort2 $slavePort2 $ptn003_case1_cnt "GPN_PTN_003_FD1"]
# 	puts $fileId ""
# 	if {"1" in $flag1_case4} {
# 		set flagCase4 1
# 		gwd::GWpublic_print "NOK" "FD1�����ۣ�uni������trunkģʽΪstatic��trunkģʽΪlag1:1������E-LINE��trunk������" $fileId
# 	} else {
# 		gwd::GWpublic_print "OK" "FD1�����ۣ�uni������trunkģʽΪstatic��trunkģʽΪlag1:1������E-LINE��trunk������" $fileId
# 	}
# 	puts $fileId ""
# 	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni������trunkģʽΪstatic��trunkģʽΪlag1:1��trunk���Աͬ�忨������E-LINE��trunk������  ���Խ���=====\n"
# 	incr tcId
# 	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
# 	incr cfgId
# 	if {[catch {
# 				close -i $telnet4
# 				} err] } {
# 				puts $err
# 			}
# 	set telnet4 [gwd::H3Cpublic_login $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
# 	set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
# 	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
# 	if {$lFailFileTmp != ""} {
# 		set lFailFile [concat $lFailFile $lFailFileTmp]
# 	}
# 	puts $fileId "======================================================================================\n"
# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====uni������trunkģʽΪstatic��trunkģʽΪsharing������E-LINE��trunk������  ���Կ�ʼ=====\n"
# 	######################################################lagģʽΪsharing##################################################################
# 	lappend flag2_case4 [gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "sharing"]
# 	lappend flag2_case4 [gwd::GWpublic_addTrunkPolicy $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "srcmac-based"]
# 	lappend flag2_case4 [gwd::H3CL2Port_DelToTrunk $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort17 "1"]
# 	lappend flag2_case4 [gwd::H3CL2Port_DelToTrunk $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort18 "1"]
# 	lappend flag2_case4 [gwd::H3C_DelL3Trunk $telnet4 $matchType4 $Gpn_type4 $fileId "1"]
	# lappend flag2_case4 [gwd::H3CL2Port_AddToTrunk $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort17 "1"]
	# lappend flag2_case4 [gwd::H3CL2Port_AddToTrunk $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort18 "1"]
	# lappend flag2_case4 [gwd::HW_SetLinkASharingMode $telnet4 $matchType4 $Gpn_type4 $fileId "source-mac"]
	# lappend flag2_case4 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "FALSE"]
	# stc::apply
 # 	lappend flag2_case4 [Test_TrunkSharing $telnet1 $matchType1 $Gpn_type1 $fileId sharing "t1" $masterPort2 $slavePort2 "false" "GPN_PTN_003_FD2_1"]
 # 	lappend flag2_case4 [gwd::Cfg_StreamActive $hGPNPort5Stream9 "FALSE"]
	# lappend flag2_case4 [gwd::Cfg_StreamActive $hGPNPort5Stream10 "TRUE"]
	# stc::apply
	# lappend flag2_case4 [Test_TrunkSharing $telnet1 $matchType1 $Gpn_type1 $fileId sharing "t1" $masterPort2 $slavePort2 "true" "GPN_PTN_003_FD2_2"]

	# puts $fileId ""
	# if {"1" in $flag2_case4} {
	# 	set flagCase4 1
	# 	gwd::GWpublic_print "NOK" "FD2�����ۣ�trunkģʽΪsharing������E-LINE��trunk������" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FD2�����ۣ�trunkģʽΪsharing������E-LINE��trunk������" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing������E-LINE��trunk������  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# if {[catch {
	# 			close -i $telnet4
	# 			} err] } {
	# 			puts $err
	# 		}
	# set telnet4 [gwd::H3Cpublic_login $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	# set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	# puts $fileId "======================================================================================\n"
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���down�˿�$downPort_dev1\����ҵ��  ���Կ�ʼ=====\n"
	# if {[string match "L3" $trunkLevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "disable" "disable"
	# } elseif {[string match "L2" $trunkLevel]&&[string match "L3" $Worklevel]} {
	# 	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "disable" "enable"
	# }
	# gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" $downPort_dev1
	# lappend flag3_case4 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "TRUE"]
	# lappend flag3_case4 [gwd::Cfg_StreamActive $hGPNPort5Stream9 "TRUE"]
	# lappend flag3_case4 [gwd::Cfg_StreamActive $hGPNPort5Stream10 "FALSE"]
	# stc::apply
	# stc::delete $hGPNPort4AnaFrameCfgFil
	# gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
 #    gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
 #    stc::apply
	# incr capId
	# lappend flag3_case4 [TestFlowUNI $fileId "GPN_PTN_003_$capId"]
	# incr id
	# puts $fileId ""
	# if {"1" in $flag3_case4} {
	# 	set flagCase4 1
	# 	gwd::GWpublic_print "NOK" "FD3�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���down�˿�$downPort_dev1\����ҵ��" $fileId
	# } else {
	# 	gwd::GWpublic_print "OK" "FD3�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���down�˿�$downPort_dev1\����ҵ��" $fileId
	# }
	# puts $fileId ""
	# gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���down�˿�$downPort_dev1\����ҵ��  ���Խ���=====\n"
	# incr tcId
	# gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	# incr cfgId
	# if {[catch {
	# 			close -i $telnet4
	# 			} err] } {
	# 			puts $err
	# 		}
	# set telnet4 [gwd::H3Cpublic_login $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	# set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
	# lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	# if {$lFailFileTmp != ""} {
	# 	set lFailFile [concat $lFailFile $lFailFileTmp]
	# }
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��down�˿�$downPort_dev1\
					����ҵ��  ���Կ�ʼ=====\n"
	lappend flag4_case4 [gwd::GWpublic_delPortFromTrunkSta $telnet1 $matchType1 $Gpn_type1 $fileId t1 "static" $downPort_dev1]
	if {[string match "L3" $::Worklevel]} {
		lappend flag4_case4 [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $downPort_dev1 "enable" "disable"]
	}
	incr capId
	if {[TestFlowUNI $fileId "GPN_PTN_003_$capId"]} {
		lappend flag4_case4 1
	}
	incr id
	puts $fileId ""
	if {"1" in $flag4_case4} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD4�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��down�˿�$downPort_dev1\
						����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD4�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��down�˿�$downPort_dev1\
						����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��down�˿�$downPort_dev1\
							����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	if {[catch {
				close -i $telnet4
				} err] } {
				puts $err
			}
	set telnet4 [gwd::H3Cpublic_login $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���up�˿�$GPNPort9\
							����ҵ��  ���Կ�ʼ=====\n"
	if {[string match "L2" $::trunkLevel]&&[string match "L3" $::Worklevel]} {
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "disable" "enable"
	} elseif {[string match "L3" $::trunkLevel]} {
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "disable" "disable"
	}
	gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "$GPNPort9"
	incr capId
	if {[TestFlowUNI $fileId "GPN_PTN_003_$capId"]} {
		set flag5_case4 1
	}
	incr id
	puts $fileId ""
	if {$flag5_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD5�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���up�˿�$GPNPort9\
						����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD5�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���up�˿�$GPNPort9\
						����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨���up�˿�$GPNPort9\
							����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	if {[catch {
				close -i $telnet4
				} err] } {
				puts $err
			}
	set telnet4 [gwd::H3Cpublic_login $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��up�˿�$GPNPort9\
							����ҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_delPortFromTrunk $telnet1 $matchType1 $Gpn_type1 $fileId t1 "static" $GPNPort9
	if {[string match "L3" $Worklevel]} {
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "enable" "disable"
	}
	incr capId
	if {[TestFlowUNI $fileId "GPN_PTN_003_$capId"]} {
		set flag6_case4 1
	}
	incr id
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD6�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��up�˿�$GPNPort9\
						����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD6�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��up�˿�$GPNPort9\
						����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort15,$GPNPort16\��ͬ�忨ɾ��up�˿�$GPNPort9\
							����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	if {[catch {
				close -i $telnet4
				} err] } {
				puts $err
			}
	set telnet4 [gwd::H3Cpublic_login $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"

	gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
	if {[string match "L3" $trunkLevel]} {
		gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "50"
		gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4094"
	}
	gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static"
	if {[string match "L3" $Worklevel]} {
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2 "enable" "disable"
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3 "enable" "disable"
	}
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "50" $GPNTestEth3
	gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 0 "nochange" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"
	puts $fileId "======================================================================================\n"
	if {$flagCase1 == 1 || $flagCase2 == 1 || $flagCase3 == 1 || $flagCase4 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 1���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 1���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 1 E-LINE��TRUNK���������Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 E-LINE��QOS����������\n"
    puts $fileId ""

    ###��QOS������       
    #   <1>����QoS���٣���QoS���԰󶨵�AC/PW/LSP����֤���ٿ�����Ч,�����AC���ʲ��ɳ���PW��PW���ʲ��ɳ���LSP������Υ����ϵͳ����Ӧ����ʾ
    #   <2>ne1--ne2 ��ne1��nni������fifo���ȣ�pw���ó�pq���ȣ���ne1��uni�ڴ���40m���ȼ�Ϊ7�Լ�20m���ȼ�Ϊ5��ҵ����,��ne2���ܵ�60m������
    #   <3>��ne2��nni�뷽������50m,ne2���յ�40m���ȼ�Ϊ7��10m���ȼ�Ϊ5��������,nniȡ�����٣�ne2���ܵ�60m������
    
    if {[string match -nocase $Gpn_type1 "7600"] || [string match -nocase $Gpn_type1 "76"]} {
        set flagCase5 1

        gwd::GWpublic_print "NOK" "76�豸�ݲ�֧��QOS���ԣ���������" $fileId
    } else {
    	spawn_id matchType dutType fileId AcName dir cir cbs pir pbs otherPara
    	lappend flag1_case5 [gwd::GWpublic_addAcHqosEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "egress" "enable"]
    	lappend flag1_case5 [gwd::GWpublic_addACRate $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "egress" "20000" "1000" "" "" ""]
    	lappend flag1_case5 [gwd::GWpublic_addACRate $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "ingress" "10000" "1000" "" "" ""]
    	
    	lappend flag1_case5 [gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"]
		lappend flag1_case5 [gwd::Cfg_StreamActive $hGPNPort4Stream6 "FALSE"]
		lappend flag1_case5 [gwd::Cfg_StreamActive $QosStream1 "TRUE"]
    	lappend flag1_case5 [GW_SetLspRate $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "egress" "50000" resultlsp]
    	GW_SetPwRate $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "egress" "60000" resultpw1
    	if {[]} {

    	}
    	lappend flag1_case5 [GW_SetPwRate $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "egress" "40000" resultpw2]
    	GW_SetAcRate $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "egress" "60000" resultac1
    	if {[]} {

    	}
    	


    }
    if {$flagCase5 == 1} {
        gwd::GWpublic_print "NOK" "TestCase 2���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 2���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 2 E-LINE��QOS���������Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 E-LINE��OAM����������\n"
	###��OAM������
	#   <1>���öβ�/PW/LSP��0AM���ɳɹ����ã�ϵͳ���쳣����ҵ������ת����Ӱ��
	#   <2>���öβ�/PW/LSP����Ӧ��CC���ܽ�ֹ/ʹ�ܣ����óɹ���ϵͳ���쳣����ҵ������ת����Ӱ��
	#   <3>���öβ�/PW/LSP����Ӧ��CCʱ�������������óɹ���ϵͳ���쳣����ҵ������ת����Ӱ��
	#   <4>����LB���ܣ�ϵͳ���쳣�����ɲ�ѯ���ؽ��
	set flag1_case3 0
	set flag2_case3 0
	set flag3_case3 0
	set flag4_case3 0
	set flag5_case3 0
	set flag6_case3 0
	set flag7_case3 0
	set flag8_case3 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����OAMǰ����E-LINEҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "shutdown"
	gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream6 "TRUE"
	incr capId
	if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
		set flag1_case3 1
	}
	puts $fileId ""
	if {$flag1_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB7�����ۣ�����OAMǰ����E-LINEҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7�����ۣ�����OAMǰ����E-LINEҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����OAMǰ����E-LINEҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP��OAM�����E-LINEҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_createMplsMeg $telnet3 $matchType3 $Gpn_type3 $fileId "meg13"
	gwd::GWpublic_addMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "lsp" "lsp1" "2" "3"
	gwd::GWpublic_createMplsMeg $telnet1 $matchType1 $Gpn_type1 $fileId "meg11"
	gwd::GWpublic_addMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "lsp" "lsp1" "3" "2"
	incr capId
	if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
		set flag2_case3 1
	}
	puts $fileId ""
	if {$flag2_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB8�����ۣ�����LSP��OAM�����E-LINEҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8�����ۣ�����LSP��OAM�����E-LINEҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP��OAM�����E-LINEҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW��OAM�����E-LINEҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_delMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "lsp"
	gwd::GWpublic_addMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "pw" "pw1" "5" "4"
	gwd::GWpublic_delMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "lsp"
	gwd::GWpublic_addMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "pw" "pw1" "4" "5"
	incr capId
	if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
		set flag3_case3 1
	}
	puts $fileId ""
	if {$flag3_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB9�����ۣ�����PW��OAM�����E-LINEҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9�����ۣ�����PW��OAM�����E-LINEҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW��OAM�����E-LINEҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���öβ��OAM�����E-LINEҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_delMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "pw"
	gwd::GWpublic_addMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "segment" $GPNTestEth4 "7" "6"
	gwd::GWpublic_delMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "pw"
	gwd::GWpublic_addMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "segment" $GPNTestEth3 "6" "7"
	incr capId
	if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
		set flag4_case3 1
	}
	puts $fileId ""
	if {$flag4_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC1�����ۣ����öβ��OAM�����E-LINEҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1�����ۣ����öβ��OAM�����E-LINEҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���öβ��OAM�����E-LINEҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�CCʹ�ܺ����E-LINEҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_addMplsCc $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "enable"
	gwd::GWpublic_addMplsCc $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "enable"
	incr capId
	if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
		set flag5_case3 1
	}
	puts $fileId ""
	if {$flag5_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC2�����ۣ�����LSP/PW/�β�CCʹ�ܺ����E-LINEҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2�����ۣ�����LSP/PW/�β�CCʹ�ܺ����E-LINEҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�CCʹ�ܺ����E-LINEҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�CC��ֹ�����E-LINEҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_addMplsCc $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "disable"
	gwd::GWpublic_addMplsCc $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "disable"
	incr capId
	if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
		set flag6_case3 1
	}
	puts $fileId ""
	if {$flag6_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC3�����ۣ�����LSP/PW/�β�CC��ֹ�����E-LINEҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3�����ۣ�����LSP/PW/�β�CC��ֹ�����E-LINEҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�CC��ֹ�����E-LINEҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�CCʱ���������E-LINEҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_addMplsCcInt $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "100ms"
	gwd::GWpublic_addMplsCcInt $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "1s"
	incr capId
	if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
		set flag7_case3 1
	}
	puts $fileId ""
	if {$flag7_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC4�����ۣ�����LSP/PW/�β�CCʱ���������E-LINEҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4�����ۣ�����LSP/PW/�β�CCʱ���������E-LINEҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�CCʱ���������E-LINEҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�LB�����E-LINEҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_addMplsLb $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "mep" "255" "3"
	gwd::GWpublic_addMplsLb $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "mep" "255" "5"
	incr capId
	if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
		set flag8_case3 1
	}
	puts $fileId ""
	if {$flag8_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC5�����ۣ�����LSP/PW/�β�LB�����E-LINEҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5�����ۣ�����LSP/PW/�β�LB�����E-LINEҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�LB�����E-LINEҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	gwd::GWpublic_delMplsMeg $telnet1 $matchType1 $Gpn_type1 $fileId "meg11"
	gwd::GWpublic_delMplsMeg $telnet3 $matchType3 $Gpn_type3 $fileId "meg13"
	puts $fileId "======================================================================================\n"
	if {$flagCase3 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 3���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 3���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 3 E-LINE��OAM���������Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 E-LINE��DCN����������\n"
	###��DCN������
	#   <1>2̨�豸��DCN�������ܣ�����һ̨Ϊ������Ԫ����һ̨Ϊ��������Ԫ
	#   <2>2̨�豸����ping�����������豸�������������ܣ�ҵ������������ת����ϵͳ���쳣
	#   <3>ɾ����������DCN���ã���E-LINEҵ����Ӱ��
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set ip11 192.2.1.1
	set ip12 192.2.1.2
	if {[string match "L2" $Worklevel]}  {
		puts $fileId "======================================================================================\n"
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����DCN�����E-LINEҵ��  ���Կ�ʼ=====\n"
		gwd::GWpublic_addDCN $telnet1 $matchType1 $Gpn_type1 $fileId "gat" "100" "253"  "$GPNTestEth2 $GPNPort5" "mgt ne-to-ne"
		AddportAndIptovlan $telnet1 $matchType1 $Gpn_type1 $fileId "100" "port" $GPNTestEth2 "untagged" $ip11 24
		gwd::GWpublic_addDCN $telnet3 $matchType3 $Gpn_type3 $fileId "ne" "100" "253" $GPNPort6 "ne-to-ne"
		AddportAndIptovlan $telnet3 $matchType3 $Gpn_type3 $fileId "100" "port" $GPNPort6 "tagged" $ip12 24
		incr capId
		if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
			set flag1_case4 1
		}
		puts $fileId ""
		if {$flag1_case4 == 1} {
			set flagCase4 1
			gwd::GWpublic_print "NOK" "FC6�����ۣ�����DCN�����E-LINEҵ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "FC6�����ۣ�����DCN�����E-LINEҵ��" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����DCN�����E-LINEҵ��  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
		puts $fileId "======================================================================================\n"
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����E-LINEҵ��󣬲���DCN����  ���Կ�ʼ=====\n"
		gwd::GWpublic_cfgPing $telnet3 $matchType3 $Gpn_type3 $fileId $ip11 packageLoss
		if {$packageLoss>20} {
			set flag2_case4 1
			gwd::GWpublic_print "NOK" "����NE3($gpnIp3)�豸 ping������Ԫ�豸NE1($gpnIp1)������Ϊ$packageLoss��������������20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "����NE3($gpnIp3)�豸 ping������Ԫ�豸NE1($gpnIp1)������Ϊ$packageLoss��С����������20%" $fileId	
		}
		gwd::GWpublic_cfgPing $telnet1 $matchType1 $Gpn_type1 $fileId $ip12 packageLoss
		if {$packageLoss>20} {
			set flag2_case4 1
			gwd::GWpublic_print "NOK" "������Ԫ�豸NE1($gpnIp1)ping����NE3($gpnIp3)�豸������Ϊ$packageLoss��������������20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "������Ԫ�豸NE1($gpnIp1)ping����NE3($gpnIp3)�豸������Ϊ$packageLoss��С����������20%" $fileId	
		}
		#����ping device����ȡPingReport
		set hEmulatedDevice1 [gwd::Create_PingDevice $hPtnProject $hGPNPort2 "192.2.1.3" "192.2.1.254" "00:00:00:00:11:01"]
		set hPingResult1 [stc::get $hGPNPort2 -children-PingReport]
		stc::perform PingStartCommand -DeviceList $hEmulatedDevice1 -FrameCount 10 -PingIpv4DstAddr $ip12 
		after 20000 
		set sucPingCnt1 0
		set sucPingCnt1 [stc::get $hPingResult1 -SuccessfulPingCount]
		puts "ping $ip12  $sucPingCnt1"
		puts "sucPingCnt1: $sucPingCnt1"
		if {$sucPingCnt1 < 8} {
			set flag2_case4 1
			gwd::GWpublic_print "NOK" "�����豸NE1($gpnIp1)�˿�GPNTestEth2\���ӵ�TCģ��PC ping ��Ԫ�豸NE3($gpnIp3)�豸����ping10����pingͨ$sucPingCnt1\����" $fileId
		} else {
			gwd::GWpublic_print "OK" "�����豸NE1($gpnIp1)�˿�GPNTestEth2\���ӵ�TCģ��PC ping ��Ԫ�豸NE3($gpnIp3)�豸����ping10����pingͨ$sucPingCnt1\����" $fileId
		}
		puts $fileId ""
		if {$flag2_case4 == 1} {
			set flagCase4 1
			gwd::GWpublic_print "NOK" "FC7�����ۣ�����E-LINEҵ��󣬲���DCN����" $fileId
		} else {
			gwd::GWpublic_print "OK" "FC7�����ۣ�����E-LINEҵ��󣬲���DCN����" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����E-LINEҵ��󣬲���DCN����  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
		gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp
		puts $fileId "======================================================================================\n"
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����DCN���ܺ��ٲ���E-LINEҵ��  ���Կ�ʼ=====\n"
		incr capId
		if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
			set flag3_case4 1
		}
		puts $fileId ""
		if {$flag3_case4 == 1} {
			set flagCase4 1
			gwd::GWpublic_print "NOK" "FC8�����ۣ�����DCN���ܺ��ٲ���E-LINEҵ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "FC8�����ۣ�����DCN���ܺ��ٲ���E-LINEҵ��" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����DCN���ܺ��ٲ���E-LINEҵ��  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
		gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp
		puts $fileId "======================================================================================\n"
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ��DCN�����ú����E-LINEҵ��  ���Կ�ʼ=====\n"
		gwd::GWpublic_delDCN $telnet1 $matchType1 $Gpn_type1 $fileId "ne" "$GPNTestEth2 $GPNPort5"
		gwd::GWpublic_delDCN $telnet3 $matchType3 $Gpn_type3 $fileId "ne" $GPNPort6
		incr capId
		if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
			set flag4_case4 1
		}
		puts $fileId ""
		if {$flag4_case4 == 1} {
			set flagCase4 1
			gwd::GWpublic_print "NOK" "FC9�����ۣ�ɾ��DCN�����ú����E-LINEҵ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "FC9�����ۣ�ɾ��DCN�����ú����E-LINEҵ��" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ��DCN�����ú����E-LINEҵ��  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
		puts $fileId "======================================================================================\n"
		
	} else {
		puts $fileId "DCN�Ƕ��㹦�ܣ����㲻��Ҫ����\n"
	}
	if {$flagCase4 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 4���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 4���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 4 E-LINE��DCN���������Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 E-LINE��CES����������\n"
	##��CES������
	#   <1>��֮ǰ������E-LINEҵ����LSP����ֻ������PW����Ӧ��CESҵ��
	#   <2>CESҵ�����óɹ���ϵͳ���쳣
	#   <3>CESҵ���֮ǰ��E-LINEҵ������ת�����˴�֮���޸���
	#   <4>��CESҵ���E-LINEҵ���õ�LSP�������٣�ϵͳ���쳣��CESҵ���E-LINEҵ�������ת��
	####ɾ��AC��PW
	puts $fileId "�ݲ����ǣ���������"
	gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
	#gwd::GPN_CfgCES "GPN_PTN_003" $fileId "ces3" "pdh" "1/1" "pw1" "256" "true" "true" "8" "false" "2" "10" "adaptive" "satop" "ef" $telnet3 $Gpn_type3
	gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
	#gwd::GPN_CfgCES "GPN_PTN_003" $fileId "ces1" "pdh" "1/1" "pw1" "256" "true" "true" "8" "false" "2" "10" "adaptive" "satop" "ef" $telnet1 $Gpn_type1
	if {$flagCase5 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 5���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 5���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 5 E-LINE��CES���������Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 6 E-LINE��ELAN/ETREE����������\n"
	###ELAN/ETREE������
	#   <1>3̨�豸ԭ��E-LINEҵ��Ļ����ϣ������µ�ҵ��ELAN/ETREE
	#   <2>�µ�ҵ��ELAN/ETREEҵ��ɹ�������ϵͳ���쳣����֮ǰ��ҵ����Ӱ��
	#   <3>ÿ��ҵ������ת�����˴�֮���޸��ţ�ϵͳ����������
	set flag1_case6 0
	set flag2_case6 0
	set flag3_case6 0
	set address11 10.2.1.1
	set address12 10.2.2.2
	set address13 10.2.1.3
	set address14 10.2.3.4
	set address15 10.2.2.5
	set address16 10.2.3.6
	set ip31 192.3.1.1
	set ip32 192.3.2.2
	set ip33 192.3.1.3
	set ip34 192.3.3.1
	set ip35 192.3.2.3
	set ip36 192.3.3.3
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====������ǰ����E-LINEҵ��  ���Կ�ʼ=====\n"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "enable"
	}
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "1000" $GPNTestEth4
	gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 1000 0 "nochange" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline"
	gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 0 "nochange" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"
	incr capId
	if {[TestFlow $fileId "GPN_PTN_003_$capId"]} {
		set flag1_case6 1
	}
	puts $fileId ""
	if {$flag1_case6 == 1} {
		set flagCase6 1
		gwd::GWpublic_print "NOK" "FD1�����ۣ�������ǰ����E-LINEҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD1�����ۣ�������ǰ����E-LINEҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====������ǰ����E-LINEҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls��ID��PW��ID��ͻ����  ���Կ�ʼ=====\n"
	##############################################����e-lanҵ��###################################################################
	##############################################����7600-3######################################################################
	gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource1
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface14 $ip31 $GPNPort6 $matchType3 $Gpn_type3 $telnet3
	PTN_NNI_AddInterIp $fileId $Worklevel $interface25 $ip32 $GPNPort11 $matchType3 $Gpn_type3 $telnet3
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort6 "enable"
		gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort11 "enable"
	}
	###����vpls
	if {![gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3" "2" "elan" "flood" "false" "false" "false" "true" "2000" "" ""]} {
		gwd::GWpublic_print "OK" "����elanҵ���VPLSID��ר��PWID��ͬ�����óɹ�����ʾ" $fileId
	} else {
		set flag2_case6 1
		gwd::GWpublic_print "NOK" "����elanҵ���VPLSID��ר��PWID��ͬ������ʧ������ʾ" $fileId
		gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3"
		gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3" "3" "elan" "flood" "false" "false" "false" "true" "2000" "" ""
	}
	###����lsp
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp3" $interface14 $ip33 "200" "200" "normal" "3"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp3" $address11
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp3"
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp4" $interface25 $ip35 "300" "400" "normal" "4"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp4" $address12
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp4"
	##����pw
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw3" "vpls" "vpls3" "peer" $address11 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw4" "vpls" "vpls3" "peer" $address12 "3000" "4000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	##����ac
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "3000" $GPNTestEth4
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac3" "vpls3" "" $GPNTestEth4 "3000" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"
	############################################����7600-1#######################################################
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface1 $ip33 $GPNPort5 $matchType1 $Gpn_type1 $telnet1
	PTN_NNI_AddInterIp $fileId $Worklevel $interface28 $ip34 $GPNPort14 $matchType1 $Gpn_type1 $telnet1
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "enable"
		       gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort14 "enable"
	}
	##����vpls
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "2" "elan" "flood" "false" "false" "false" "true" "2000" "" ""
	if {![gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw11" "l2transport" "2" "" $address1 "1001" "1001" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""]} {
		gwd::GWpublic_print "OK" "����ר��PWID��elanҵ���VPLSID��ͬ�����óɹ�����ʾ" $fileId
	} else {
		set flag2_case6 1
		gwd::GWpublic_print "NOK" "����ר��PWID��elanҵ���VPLSID��ͬ������ʧ������ʾ" $fileId
	}
	
	puts $fileId ""
	if {$flag2_case6 == 1} {
		set flagCase6 1
		gwd::GWpublic_print "NOK" "FD2�����ۣ�vpls��ID��PW��ID��ͻ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD2�����ۣ�vpls��ID��PW��ID��ͻ����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls��ID��PW��ID��ͻ����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���豸������ELINEҵ�����������һ��ELANҵ�񣬲�������ҵ���໥�Ƿ���Ӱ��  ���Կ�ʼ=====\n"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw11"
	##����lsp
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3" $interface1 $ip31 "200" "200" "normal" "5"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3" $address13
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3"
	gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6" $interface28 $ip36 "500" "600" "normal" "6"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6" $address14
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6"
	gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6"
	##����pw
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" "vpls" "vpls1" "peer" $address13 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "5"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw6" "vpls" "vpls1" "peer" $address14 "5000" "6000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "6"
	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" result
	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw6" result
	###����ac
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "1000" $GPNTestEth2
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth2 "1000" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"
	#############################################����7600-2#######################################################
	PTN_NNI_AddInterIp $fileId $Worklevel $interface26 $ip35 $GPNPort12 $matchType2 $Gpn_type2 $telnet2
	PTN_NNI_AddInterIp $fileId $Worklevel $interface27 $ip36 $GPNPort13 $matchType2 $Gpn_type2 $telnet2
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort12 "enable"
		gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort13 "enable"
	}
	###����vpls
	gwd::GWVpls_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls2" "3" "elan" "flood" "false" "false" "false" "true" "2000" "" ""
	###����lsp
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp4" $interface26 $ip32 "400" "300" "normal" "7"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp4" $address15
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp4"
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp6" $interface27 $ip34 "600" "500" "normal" "8"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp6" $address16
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp6"
	###����pw
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw4" "vpls" "vpls2" "peer" $address15 "4000" "3000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "7"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw6" "vpls" "vpls2" "peer" $address16 "6000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "8"
	###����ac
	PTN_UNI_AddInter $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel "2000" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac2" "vpls2" "" $GPNTestEth1 "2000" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"
	gwd::Cfg_StreamActive $hGPNPort4Stream5 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort2Stream3 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort1Stream7 "TRUE"
	foreach i "aGPNPort1Cnt1 aGPNPort2Cnt1 aGPNPort3Cnt1 aGPNPort4Cnt1" {
	  array set $i {cnt2 0 drop2 0 rate2 0 cnt3 0 cnt5 0 cnt6 0 drop6 0 rate6 0 cnt7 0} 
	}
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort2Gen $hGPNPort3Gen $hGPNPort4Gen"  "$hGPNPort1Ana $hGPNPort2Ana $hGPNPort3Ana $hGPNPort4Ana"
	if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort1Cap $hGPNPort1CapAnalyzer
		gwd::Start_CapAllData ::capArr $hGPNPort2Cap $hGPNPort2CapAnalyzer
		gwd::Start_CapAllData ::capArr $hGPNPort3Cap $hGPNPort3CapAnalyzer 
		gwd::Start_CapAllData ::capArr $hGPNPort4Cap $hGPNPort4CapAnalyzer
	}
	after 10000
	incr capId
	if {$::cap_enable} {
		gwd::Stop_CapData $hGPNPort1Cap 1 "GPN_PTN_003_$capId-p$GPNTestEth1_cap\($gpnIp2\).pcap"	
		gwd::Stop_CapData $hGPNPort2Cap 1 "GPN_PTN_003_$capId-p$GPNTestEth2_cap\($gpnIp1\).pcap"
		gwd::Stop_CapData $hGPNPort3Cap 1 "GPN_PTN_003_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap"	
		gwd::Stop_CapData $hGPNPort4Cap 1 "GPN_PTN_003_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap"
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt3 1 $hGPNPort1Ana aGPNPort1Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 0 0 0 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt3 1 $hGPNPort2Ana aGPNPort2Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 0 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt3 1 $hGPNPort3Ana aGPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 0 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt3 1 $hGPNPort4Ana aGPNPort4Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 0 1 0 0
		after 5000
	}
	parray aGPNPort1Cnt1
	parray aGPNPort2Cnt1
	parray aGPNPort3Cnt1
	parray aGPNPort4Cnt1
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_003_$capId-p$GPNTestEth1_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_003_$capId-p$GPNTestEth2_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_003_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_003_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort4Cnt1(cnt2) < $rateL || $aGPNPort4Cnt1(cnt2) > $rateR} {
		set flag3_case6 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50����������NE3($gpnIp3)\
			$GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50����������NE3($gpnIp3)\
			$GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aGPNPort4Cnt1(cnt3) < $rateL || $aGPNPort4Cnt1(cnt3) > $rateR} {
		set flag3_case6 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth2\����tag=1000����������NE3($gpnIp3)\
			$GPNTestEth4\�յ�tag=1000��������������Ϊ$aGPNPort4Cnt1(cnt3)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth2\����tag=1000����������NE3($gpnIp3)\
			$GPNTestEth4\�յ�tag=1000��������������Ϊ$aGPNPort4Cnt1(cnt3)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aGPNPort4Cnt1(cnt7) < $rateL || $aGPNPort4Cnt1(cnt7) > $rateR} {
		set flag3_case6 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1\����tag=2000����������NE3($gpnIp3)\
			$GPNTestEth4\�յ�tag=2000��������������Ϊ$aGPNPort4Cnt1(cnt7)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1\����tag=2000����������NE3($gpnIp3)\
			$GPNTestEth4\�յ�tag=2000��������������Ϊ$aGPNPort4Cnt1(cnt7)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aGPNPort3Cnt1(cnt6) < $rateL || $aGPNPort3Cnt1(cnt6) > $rateR} {
		set flag3_case6 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth4\����tag=1000����������NE1($gpnIp1)\
			$GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth4\����tag=1000����������NE1($gpnIp1)\
			$GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aGPNPort2Cnt1(cnt5) < $rateL || $aGPNPort2Cnt1(cnt5) > $rateR} {
		set flag3_case6 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth4\����tag=3000����������NE1($gpnIp1)\
			$GPNTestEth2\�յ�tag=3000��������������Ϊ$aGPNPort2Cnt1(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth4\����tag=3000����������NE1($gpnIp1)\
			$GPNTestEth2\�յ�tag=3000��������������Ϊ$aGPNPort2Cnt1(cnt5)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aGPNPort2Cnt1(cnt7) < $rateL || $aGPNPort2Cnt1(cnt7) > $rateR} {
		set flag3_case6 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1\����tag=2000����������NE1($gpnIp1)\
			$GPNTestEth2\�յ�tag=2000��������������Ϊ$aGPNPort2Cnt1(cnt7)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1\����tag=2000����������NE1($gpnIp1)\
			$GPNTestEth2\�յ�tag=2000��������������Ϊ$aGPNPort2Cnt1(cnt7)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aGPNPort1Cnt1(cnt3) < $rateL || $aGPNPort1Cnt1(cnt3) > $rateR} {
		set flag3_case6 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth2\����tag=1000����������NE2($gpnIp2)\
			$GPNTestEth1\�յ�tag=1000��������������Ϊ$aGPNPort1Cnt1(cnt3)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth2\����tag=1000����������NE2($gpnIp2)\
			$GPNTestEth1\�յ�tag=1000��������������Ϊ$aGPNPort1Cnt1(cnt3)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aGPNPort1Cnt1(cnt5) < $rateL || $aGPNPort1Cnt1(cnt5) > $rateR} {
		set flag3_case6 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth4\����tag=3000����������NE2($gpnIp2)\
			$GPNTestEth1\�յ�tag=3000��������������Ϊ$aGPNPort1Cnt1(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth4\����tag=3000����������NE2($gpnIp2)\
			$GPNTestEth1\�յ�tag=3000��������������Ϊ$aGPNPort1Cnt1(cnt5)����$rateL-$rateR\��Χ��" $fileId
	}
	gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource2
	send_log "\n resource1:$resource1"
	send_log "\n resource2:$resource2"
	if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
		gwd::GWpublic_print "NOK" "�½�ELANҵ��֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
		set flag3_case6	1
	} else {	
		gwd::GWpublic_print "OK" "�½�ELANҵ��֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
	}
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort2Gen $hGPNPort3Gen $hGPNPort4Gen"  "$hGPNPort1Ana $hGPNPort2Ana $hGPNPort3Ana $hGPNPort4Ana"
	puts $fileId ""
	if {$flag3_case6 == 1} {
		set flagCase6 1
		gwd::GWpublic_print "NOK" "FD3�����ۣ����豸������ELINEҵ�����������һ��ELANҵ�񣬲�������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD3�����ۣ����豸������ELINEҵ�����������һ��ELANҵ�񣬲�������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���豸������ELINEҵ�����������һ��ELANҵ�񣬲�������ҵ���໥�Ƿ���Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_003_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_003" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase6 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 6���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 6���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 6 E-LINE��ELAN/ETREE���������Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===�ָ���ʼ������...\n"
	lappend flagDel [gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac3"]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface23 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface24 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw3"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw4"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp3"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp4"]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface10 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface14 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface25 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3"]
	
	lappend flagDel [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface12 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface30 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw6"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6"]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface11 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface1 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface28 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"]
	
	lappend flagDel [gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac2"]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface29 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw4"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw6"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp4"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp6"]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface26 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface27 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls2"]
	
	if {[string match "L2" $Worklevel]} {
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort6 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort11 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort14 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort12 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort13 "none"]
	}
	
	foreach port1 $portList1 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend flagDel [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port1 "enable" "disable"]
		}
	} 
	foreach port2 $portList2 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend flagDel [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port2 "enable" "disable"]
		}
	 }
	foreach port3 $portList3 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend flagDel [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port3 "enable" "disable"]
		}
	}
	lappend flagDel [gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort7 "undo shutdown"]
	lappend flagDel [gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort9 "undo shutdown"]
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_003"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_003"
	
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_003����Ŀ�ģ�E-LINE������ģ�黥����\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1 == 1 || $flagCase2 == 1 || $flagCase3 == 1 || $flagCase4 == 1 || $flagCase5 == 1 || $flagCase6 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_003���Խ��" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase6 == 0) ? "OK" : "NOK"}] "Test Case 6���Խ��" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪlag1:1��trunk���Աͬ�忨������E-LINE��trunk������" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪlag1+1��trunk���Աͬ�忨������E-LINE��trunk������" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��trunk���Աͬ�忨������E-LINE��trunk������" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���\
					down�˿�$downPort_dev1	$matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���down�˿�$downPort_dev3\����ҵ��" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��\
					down�˿�$downPort_dev1 $matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��down�˿�$downPort_dev3\����ҵ��" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨���\
					up�˿�$GPNPort9 $matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨���up�˿�$GPNPort10\����ҵ��" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag7_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort7\��ͬ�忨ɾ��\
					up�˿�$GPNPort9 $matchType3 t1��Ա$GPNPort6,$GPNPort8\��ͬ�忨ɾ��up�˿�$GPNPort10\����ҵ��" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag8_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��trunk���Ա��忨������E-LINE��trunk������" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag9_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪlag1+1��trunk���Ա��忨������E-LINE��trunk������" $fileId
	gwd::GWpublic_print "== FA10 == [expr {($flag10_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪlag1:1��trunk���Ա��忨������E-LINE��trunk������" $fileId
	gwd::GWpublic_print "== FA11 == [expr {($flag11_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���\
					down�˿�$downPort_dev1 $matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���down�˿�$downPort_dev3\����ҵ��" $fileId
	gwd::GWpublic_print "== FA12 == [expr {($flag12_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��\
					down�˿�$downPort_dev1 $matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��down�˿�$downPort_dev3\����ҵ��" $fileId
	gwd::GWpublic_print "== FA13 == [expr {($flag13_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨���\
					up�˿�$GPNPort7 $matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨���up�˿�$GPNPort8\����ҵ��" $fileId
	gwd::GWpublic_print "== FA14 == [expr {($flag14_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��$matchType1 t1��Ա$GPNPort5,$GPNPort9\�ڿ�忨ɾ��\
					up�˿�$GPNPort7 $matchType3 t1��Ա$GPNPort6,$GPNPort10\�ڿ�忨ɾ��up�˿�$GPNPort8\����ҵ��" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag15_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��AC��Ϊtrunk�ڲ���E-LINEҵ��" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�����OAMǰ����E-LINEҵ��" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag2_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�����LSP��OAM�����E-LINEҵ��" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag3_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�����PW��OAM�����E-LINEҵ��" $fileId
	gwd::GWpublic_print "== FC1 == [expr {($flag4_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ����öβ��OAM�����E-LINEҵ��" $fileId
	gwd::GWpublic_print "== FC2 == [expr {($flag5_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�����LSP/PW/�β�CCʹ�ܺ����E-LINEҵ��" $fileId
	gwd::GWpublic_print "== FC3 == [expr {($flag6_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�����LSP/PW/�β�CC��ֹ�����E-LINEҵ��" $fileId
	gwd::GWpublic_print "== FC4 == [expr {($flag7_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�����LSP/PW/�β�CCʱ���������E-LINEҵ��" $fileId
	gwd::GWpublic_print "== FC5 == [expr {($flag8_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�����LSP/PW/�β�LB�����E-LINEҵ��" $fileId
	gwd::GWpublic_print "== FC6 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�����DCN�����E-LINEҵ��" $fileId
	gwd::GWpublic_print "== FC7 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�����E-LINEҵ��󣬲���DCN����" $fileId
	gwd::GWpublic_print "== FC8 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�����DCN���ܺ��ٲ���E-LINEҵ��" $fileId
	gwd::GWpublic_print "== FC9 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�ɾ��DCN�����ú����E-LINEҵ��" $fileId
	gwd::GWpublic_print "== FD1 == [expr {($flag1_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ�������ǰ����E-LINEҵ��" $fileId
	gwd::GWpublic_print "== FD2 == [expr {($flag2_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls��ID��PW��ID��ͻ����" $fileId
	gwd::GWpublic_print "== FD3 == [expr {($flag3_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ����豸������ELINEҵ�����������һ��ELANҵ�񣬲�������ҵ��" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_003"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_003_REPORT.txt" "report\\NOK_GPN_PTN_003_REPORT.txt"
	file rename "log\\GPN_PTN_003_LOG.txt" "log\\NOK_GPN_PTN_003_LOG.txt"
} else {
	file rename "report\\GPN_PTN_003_REPORT.txt" "report\\OK_GPN_PTN_003_REPORT.txt"
	file rename "log\\GPN_PTN_003_LOG.txt" "log\\OK_GPN_PTN_003_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}

