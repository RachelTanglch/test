#!/bin/sh
# T4_GPN_PTN_ELAN_008.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#����Ŀ�ģ�E-LAN������ģ�黥����
#1-��FDB������  
#2-��trunk������
#3-��QOS������ 
#4-��OAM������
#5-��DCN������
#6-��CESҵ�񻥲���
#7-��ELINE��ETREEҵ�񻥲��� 
#8-�뻷·��⻥����                                           				                     	           
#---------------------------------------------------------------------------------------------------------------------------------
#�ű�����������
#1�����ղ������˴���Ի���:��GPN�Ĺ���˿ڣ�U/D����PC��������Internet������GPN��2��������
#   ��STC�˿ڣ� 9/9����9/10��
#2����GPN��������� ���ã���������vlan vid=4000���ڸ�vlan�����ù���IP����untagged��ʽ��ӹ���˿ڣ�U/D��
#-----------------------------------------------------------------------------------------------------------------------------------
#���Թ��̣�
#1���Test Case 1���Ի���
##��FDB������   
#   <1>����ELANҵ�񲢷������������鿴mac��ַ���� mac��ַѧϰ��ȷ
#   Ԥ�ڽ��������vpls��PW��AC��ѯ��������ȷ��ѯ
#   <2>ֹͣ������5min��mac��ַ�ϻ�
#   <3>�ٴη�����Mac����ѧϰ
##��TRUNK������
#   <4>��̨76������� ��NE1--NE2--NE3����������NE1�豸ͨ�����������ܣ�NE2��NE3�豸�Ǵ��������ܣ��˴�֮���NNI�˿�����Ϊtrunk�˿ڣ�����trunk���԰�2���˿ڣ�2���˿ڶ���up
#   <5>����E-LANҵ�����ݣ�ҵ���������óɹ�
##trunk���ģʽΪsharing
#   <6>����down/up trunk���˿�50�Σ�ҵ�����������ͻָ�����¼��ҵ�񵹻��ͻָ�ʱ�䣨������50ms��
#   <7>����down/up trunk�Ӷ˿�50�Σ�ϵͳ���쳣��ҵ�񲻷����������޶���
#   <8>trunk��˿ڳ�Ա������down��ҵ���жϣ��ָ�trunk������һ���˿ڳ�Ա��ҵ��ɻָ�
#   <9>����trunk���ģʽΪ1:1�ظ�6-7����
#   <10> �������豸��trunk�и����һ��down�Ķ˿ڣ��˿���ӳɹ���ҵ����Ӱ��
#        �ٴ��������豸��trunk��ɾ����down�Ķ˿ڣ��˿�ɾ���ɹ���ҵ����Ӱ��
#        �ٴ������豸��trunk�и����һ��up�Ķ˿ڣ��˿���ӳɹ���ҵ����Ӱ��
#        �ٴ��������豸��trunk��ɾ����up�Ķ˿ڣ��˿�ɾ���ɹ���ҵ����Ӱ��
#   <11>����trunk��˿ڳ�Ա��忨���ظ�6-10��
#   <12>��UNI��Ķ˿�����Ϊturnk�˿ڣ�����ҵ�����ݣ�ҵ���������óɹ���ҵ��������������ת��
#   <13>�����õ�trunk�ۺϷ�ʽΪ��̬���ظ�6-12��
#2���Test Case 2���Ի���
##��QOS������
#   <14>��϶���qos������Ϊ���٣��󶨵�ac�˿��ϣ���֤������Ч
#   <15>����QoS���٣���QoS���԰󶨵�AC/PW/LSP����֤���ٿ�����Ч
#   Ԥ�ڽ�������AC���ʲ��ɳ���PW��PW���ʲ��ɳ���LSP������Υ����ϵͳ����Ӧ����ʾ
#   <16>����һ��PW ���е��Ȳ��������٣�ϵͳ���쳣���óɹ������������������۲���յ���ͬ���ȼ����������Ķ��ٱ����Ƿ�������
##��OAM������
#   <17>���öβ�/PW/LSP��0AM���ɳɹ����ã�ϵͳ���쳣����ҵ������ת����Ӱ��
#   <18>���öβ�/PW/LSP����Ӧ��CC���ܽ�ֹ/ʹ�ܣ����óɹ���ϵͳ���쳣����ҵ������ת����Ӱ��
#   <19>���öβ�/PW/LSP����Ӧ��CCʱ�������������óɹ���ϵͳ���쳣����ҵ������ת����Ӱ��
##��DCN������ 
#   <20>4̨�豸��DCN�������ܣ�����һ̨Ϊ������Ԫ��ʣ����̨Ϊ��������Ԫ
#   <21>4̨�豸����ping�����������豸��������������
#   Ԥ�ڽ����ҵ������������ת����ϵͳ���쳣
#             ɾ����������DCN���ã���E-LANҵ����Ӱ��
##��CESҵ�񻥲��� 
#   <22>��֮ǰ������E-LANҵ����LSP����ֻ������PW����Ӧ��CESҵ��
#   Ԥ�ڽ����CESҵ�����óɹ���ϵͳ���쳣
#            CESҵ���֮ǰ��E-LANҵ������ת��
#   <24>�˴�֮���޸��� ��CESҵ���E-LANҵ���õ�LSP�������٣�ϵͳ���쳣��CESҵ���E-LANҵ�������ת��
#3���Test Case 3���Ի���
##��ELINE��ETREEҵ�񻥲���
#   <1>4̨�豸ԭ��E-LANҵ��Ļ����ϣ������µ�ҵ��ELINE/ETREE
#   <2>����NE1��NE2��NE4�ϴ���ETREEҵ��NE1Ϊ����豸��NE3��NE4֮�䴴��ELINEҵ��
#   Ԥ�ڽ��:�µ�ҵ��ELAN/ETREEҵ��ɹ�������ϵͳ���쳣����֮ǰ��ҵ����Ӱ��
#            ÿ��ҵ������ת�����˴�֮���޸��ţ�ϵͳ����������
##�뻷·��⻥����
#   <3>�򿪻�·��⣬uni���¹�Զ�ˣ�ҵ���Զ�˽���ֶ�
#   <4>��Զ�����컷·
#   Ԥ�ڽ��:�澯�����ϱ�����ҵ����Ӱ��
#           ��7600�����忨�����컷·���澯�����ϱ���ҵ����Ӱ��
#   <5>��������ELANҵ��ͬһ�豸������UNI�����컷·
#   Ԥ�ڽ��:�澯�����ϱ�����������̨�豸ҵ��û��Ӱ��
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_008_LOG.txt" a]
        set stdout $fd_log
        chan configure $fd_log -blocking 0 -buffering none;#������ģʽ ����flush
        log_file log\\GPN_PTN_008_LOG.txt
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_008_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
        
        file mkdir "debug"
        set fd_debug [open debug\\GPN_PTN_008_DEBUG.txt a]
        exp_internal -f debug\\GPN_PTN_008_DEBUG.txt 0
        chan configure $fd_debug -blocking 0 -buffering none;#������ģʽ ����flush
          
	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl

        ###����������
        array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "500" -pri "000"}
        array set dataArr7 {-srcMac "00:00:00:00:00:22" -dstMac "00:00:00:00:00:02" -srcIp "192.85.1.7" -dstIp "192.0.0.7" -vid "500" -pri "000"}
        array set dataArr12 {-srcMac "00:00:00:00:00:0c" -dstMac "00:00:00:00:00:cc" -srcIp "192.85.1.12" -dstIp "192.0.0.12" -vid "800" -pri "000"}
        array set dataArr13 {-srcMac "00:00:00:00:00:0d" -dstMac "00:00:00:00:00:dd" -srcIp "192.85.1.13" -dstIp "192.0.0.13" -vid "800" -pri "000"}
        array set dataArr20 {-srcMac "00:00:00:00:00:cc" -dstMac "00:00:00:00:00:0c" -srcIp "192.85.1.20" -dstIp "192.0.0.20" -vid "800" -pri "000"}
        array set dataArr17 {-srcMac "00:00:00:00:00:f3" -dstMac "00:00:00:00:01:01" -srcIp "192.85.1.17" -dstIp "192.0.0.17" -vid "800" -pri "000"}
        array set dataArr1 {-srcMac "00:00:00:00:00:f2" -dstMac "00:00:00:00:f2:f2" -srcIp "192.85.1.1" -dstIp "192.0.0.1" -vid "100" -pri "000"}
        array set dataArr21 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:f3:f3" -srcIp "192.85.1.21" -dstIp "192.0.0.21" -vid "102" -pri "000"}
        array set dataArr4 {-srcMac "00:00:00:00:00:04" -dstMac "00:00:00:00:00:44" -srcIp "192.85.1.4" -dstIp "192.0.0.4" -vid "104" -pri "000"}
        ###���ö�����Ϣ����
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        ###���÷���������
        set GenCfg {-SchedulingMode RATE_BASED}
        ###���ù��˷���������
        ####ƥ��smc
        set anaFliFrameCfg0 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	##ƥ��smc��vid��EtherType
        set anaFliFrameCfg1 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType><vlans name="anon_2561"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        ##ƥ������vid
        set anaFliFrameCfg4 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5580"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        #####mpls�����е�smac�� vid
        #set anaFliFrameCfg51 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5699"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu></pdus></config></frame>}
        ##mpls�����е������ǩ
        set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
	##ƥ��smac��ethtype
	set anaFliFrameCfg7 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}

	set rateL 95000000;#�շ�������ȡֵ��Сֵ��Χ
	set rateR 105000000;#�շ�������ȡֵ���ֵ��Χ
	set rateL1 100000000 
	set rateR1 125000000
	
	set flagCase1 0   ;#Test case 1��־λ 
	set flagCase2 0   ;#Test case 2��־λ
	set flagCase3 0   ;#Test case 3��־λ 
	set flagCase4 0   ;#Test case 4��־λ 
	set flagCase5 0   ;#Test case 5��־λ
	set flagCase6 0   ;#Test case 6��־λ
	set flagCase7 0   ;#Test case 7��־λ
	set flagCase8 0   ;#Test case 8��־λ
	set flagResult 0

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
	
	proc Test_elan_etree_eline {fileId caseId} {
		set flag 0
		foreach hCfgFil $::hGPNPortAnaFrameCfgFilList {
			gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $::anaFliFrameCfg1
		}
		Recustomization 1 1 1 1 1 0
		gwd::Start_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
		after 5000
		gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
		after 2000
		Recustomization 1 1 1 1 1 0
		gwd::Start_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
		after 10000
		foreach i "GPNPort5Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 GPNPort5Cnt0" {
			array set $i {cnt12 0 cnt13 0 cnt23 0 cnt2 0 cnt22 0 cnt10 0 cnt41 0 cnt6 0 cnt7 0}
		}
		if {$::cap_enable} {
			gwd::Start_CapAllData ::capArr $::hGPNPort5Cap $::hGPNPort5CapAnalyzer
			gwd::Start_CapAllData ::capArr $::hGPNPort2Cap $::hGPNPort2CapAnalyzer
			gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
			gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort5Ana GPNPort5Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 0 0 1 0
			after 5000
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort2Ana GPNPort2Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 1 0 0 0 0
			after 5000
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort3Ana GPNPort3Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 0 0 0
			after 5000
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort4Ana GPNPort4Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 0 1 0 0
			after 5000
		}
		parray GPNPort5Cnt1
		parray GPNPort2Cnt1
		parray GPNPort3Cnt1
		if {$::cap_enable} {
			gwd::Stop_CapData $::hGPNPort5Cap 1 "$caseId-p$::GPNTestEth5_cap\($::gpnIp1\).pcap"	
			gwd::Stop_CapData $::hGPNPort2Cap 1 "$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap"
			gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap"
			gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap"
		}
		gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
		foreach hCfgFil $::hGPNPortAnaFrameCfgFilList {
			gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $::anaFliFrameCfg7
		}
		
		gwd::Start_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
		after 10000
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt4 7 $::hGPNPort5Ana GPNPort5Cnt0]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 0 0 1 0
			after 5000
		}
		parray GPNPort5Cnt0
		gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth5_cap\($::gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap" $fileId
		#elan ҵ����֤
		if {$GPNPort5Cnt1(cnt13) < $::rateL || $GPNPort5Cnt1(cnt13) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELANҵ��NE2($::gpnIp2)$::GPNTestEth2\����tag=800����������NE1($::gpnIp1)\
				$::GPNTestEth5\�յ�tag=800��������������Ϊ$GPNPort5Cnt1(cnt13)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELANҵ��NE2($::gpnIp2)$::GPNTestEth2\����tag=800����������NE1($::gpnIp1)\
				$::GPNTestEth5\�յ�tag=800��������������Ϊ$GPNPort5Cnt1(cnt13)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort5Cnt1(cnt23) < $::rateL || $GPNPort5Cnt1(cnt23) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELANҵ��NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE1($::gpnIp1)\
				$::GPNTestEth5\�յ�tag=800��������������Ϊ$GPNPort5Cnt1(cnt23)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELANҵ��NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE1($::gpnIp1)\
				$::GPNTestEth5\�յ�tag=800��������������Ϊ$GPNPort5Cnt1(cnt23)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt1(cnt12) < $::rateL || $GPNPort2Cnt1(cnt12) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELANҵ��NE1($::gpnIp1)$::GPNTestEth1\����tag=800����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELANҵ��NE1($::gpnIp1)$::GPNTestEth1\����tag=800����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt1(cnt23) < $::rateL || $GPNPort2Cnt1(cnt23) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELANҵ��NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt23)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELANҵ��NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt23)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt1(cnt12) < $::rateL || $GPNPort3Cnt1(cnt12) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELANҵ��NE1($::gpnIp1)$::GPNTestEth1\����tag=800����������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELANҵ��NE1($::gpnIp1)$::GPNTestEth1\����tag=800����������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt1(cnt13) < $::rateL || $GPNPort3Cnt1(cnt13) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELANҵ��NE2($::gpnIp2)$::GPNTestEth2\����tag=800����������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt13)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELANҵ��NE2($::gpnIp2)$::GPNTestEth2\����tag=800����������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt13)����$::rateL-$::rateR\��Χ��" $fileId
		}
		#eline ҵ����֤
		if {$GPNPort3Cnt1(cnt22) < $::rateL || $GPNPort3Cnt1(cnt22) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELINEҵ��NE4($::gpnIp4)$::GPNTestEth4\����tag=500����������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt22)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "�豸��������ELINE��ELAN��ETREE����ҵ��ELINEҵ��NE4($::gpnIp4)$::GPNTestEth4\����tag=500����������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt22)����$::rateL-$::rateR\��Χ��" $fileId
		}
		#etree ҵ����֤
		if {$GPNPort5Cnt0(cnt10) < $::rateL || $GPNPort5Cnt0(cnt10) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "�豸��������ELINE��ELAN��ETREE����ҵ��ETREEҵ��NE2($::gpnIp2)$::GPNTestEth2\����tag=102����������NE1($::gpnIp1)\
				$::GPNTestEth5\�յ�untag��������������Ϊ$GPNPort5Cnt0(cnt10)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "�豸��������ELINE��ELAN��ETREE����ҵ��ETREEҵ��NE2($::gpnIp2)$::GPNTestEth2\����tag=102����������NE1($::gpnIp1)\
				$::GPNTestEth5\�յ�untag��������������Ϊ$GPNPort5Cnt0(cnt10)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort5Cnt0(cnt41) < $::rateL || $GPNPort5Cnt0(cnt41) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "�豸��������ELINE��ELAN��ETREE����ҵ��ETREEҵ��NE4($::gpnIp4)$::GPNTestEth4\����tag=104����������NE1($::gpnIp1)\
				$::GPNTestEth5\�յ�untag��������������Ϊ$GPNPort5Cnt0(cnt41)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "�豸��������ELINE��ELAN��ETREE����ҵ��ETREEҵ��NE4($::gpnIp4)$::GPNTestEth4\����tag=104����������NE1($::gpnIp1)\
				$::GPNTestEth5\�յ�untag��������������Ϊ$GPNPort5Cnt0(cnt41)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt1(cnt6) < $::rateL || $GPNPort2Cnt1(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "�豸��������ELINE��ELAN��ETREE����ҵ��ETREEҵ��NE1($::gpnIp1)$::GPNTestEth5\����tag=100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�tag=102��������������Ϊ$GPNPort2Cnt1(cnt6)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "�豸��������ELINE��ELAN��ETREE����ҵ��ETREEҵ��NE1($::gpnIp1)$::GPNTestEth5\����tag=100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�tag=102��������������Ϊ$GPNPort2Cnt1(cnt6)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt1(cnt7) < $::rateL || $GPNPort4Cnt1(cnt7) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "�豸��������ELINE��ELAN��ETREE����ҵ��ETREEҵ��NE1($::gpnIp1)$::GPNTestEth5\����tag=100����������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�tag=104��������������Ϊ$GPNPort4Cnt1(cnt7)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "�豸��������ELINE��ELAN��ETREE����ҵ��ETREEҵ��NE1($::gpnIp1)$::GPNTestEth5\����tag=100����������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�tag=104��������������Ϊ$GPNPort4Cnt1(cnt7)����$::rateL-$::rateR\��Χ��" $fileId
		}
		return $flag
	}
	
	puts $fileId "��¼�����豸...\n"
	puts $fileId "\n=====��¼�����豸1====\n"
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"]} {
			
	}
	while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "shutdown"]} {
		
	}
	while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort17 "shutdown"]} {
			
	}
	while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort19 "shutdown"]} {
		
	}
	while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort23 "shutdown"]} {
			
	}
	puts $fileId "\n=====��¼�����豸2====\n"
	set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
	while {[gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort15 "shutdown"]} {
					
	}
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
	set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3\
			\"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\" $GPNStcPort5 \"media $GPNEth5Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4 hGPNPort5
	
        ###������������
        gwd::STC_Create_VlanStream $fileId dataArr12 $hGPNPort5 hGPNPort5Stream12
        gwd::STC_Create_VlanStream $fileId dataArr13 $hGPNPort2 hGPNPort2Stream13
        gwd::STC_Create_VlanStream $fileId dataArr20 $hGPNPort2 hGPNPort2Stream20
        gwd::STC_Create_VlanStream $fileId dataArr17 $hGPNPort3 hGPNPort3Stream17
        gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort3 hGPNPort3Stream2
        gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort4 hGPNPort4Stream7
        gwd::STC_Create_VlanStream $fileId dataArr1 $hGPNPort5 hGPNPort5Stream1
        gwd::STC_Create_VlanStream $fileId dataArr1 $hGPNPort1 hGPNPort1Stream1
        gwd::STC_Create_VlanStream $fileId dataArr21 $hGPNPort2 hGPNPort2Stream21
        gwd::STC_Create_VlanStream $fileId dataArr4 $hGPNPort4 hGPNPort4Stream4
        gwd::STC_Create_VlanStream $fileId dataArr4 $hGPNPort3 hGPNPort3Stream4
        set hGPNPortStreamList "$hGPNPort1Stream1 $hGPNPort5Stream12 $hGPNPort2Stream13 $hGPNPort2Stream20 $hGPNPort3Stream17 $hGPNPort3Stream2 $hGPNPort4Stream7\
        		        $hGPNPort5Stream1 $hGPNPort2Stream21 $hGPNPort4Stream4 $hGPNPort3Stream4"
        set hGPNPortStreamList1 "$hGPNPort3Stream2 $hGPNPort4Stream7 $hGPNPort5Stream1 $hGPNPort2Stream21 $hGPNPort4Stream4"
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
        set hGPNPortGenList "$hGPNPort5Gen $hGPNPort2Gen $hGPNPort3Gen $hGPNPort4Gen"
        set hGPNPortAnaList "$hGPNPort5Ana $hGPNPort2Ana $hGPNPort3Ana $hGPNPort4Ana"
        set hGPNPortGenList1 "$hGPNPort5Gen $hGPNPort2Gen $hGPNPort3Gen"
        set hGPNPortAnaList1 "$hGPNPort5Ana $hGPNPort2Ana $hGPNPort3Ana"
        set hGPNPortGenList2 "$hGPNPort5Gen $hGPNPort1Gen $hGPNPort2Gen $hGPNPort3Gen"
        set hGPNPortAnaList2 "$hGPNPort5Ana $hGPNPort1Ana $hGPNPort2Ana $hGPNPort3Ana"
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
       
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList \
		-activate "false"
        foreach stream $hGPNPortStreamList {
                stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
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
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-LAN������ģ�黥�����������ÿ�ʼ...\n"
	set cfgFlag 0
	lappend cfgFlag [gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"]
        set portlist1 "$GPNPort5 $GPNPort12 $GPNPort13 $GPNPort17 $GPNPort19 $GPNPort23"
        set portList1 "$GPNTestEth5"
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

        set portlist2 "$GPNPort6 $GPNPort7 $GPNPort14 $GPNPort15 $GPNPort18"
        set portList2 "$GPNTestEth2"
        set portList22 [concat $portlist2 $portList2]
        foreach port $portList22 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "disable" "enable"]
        	}
	}        
        set rebootSlotlist2 [gwd::GWpulic_getWorkCardList $portlist2]
        gwd::GWpublic_print "OK" "��ȡ�豸NE2($gpnIp2)ҵ��忨��λ��$rebootSlotlist2" $fileId
        set rebootSlotList2 [gwd::GWpulic_getWorkCardList $portList2]
        gwd::GWpublic_print "OK" "��ȡ�豸NE2($gpnIp2)�����忨��λ��$rebootSlotList2" $fileId
	
        set portlist3 "$GPNPort8 $GPNPort9 $GPNPort16"
        set portList3 "$GPNTestEth3"
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

        set portlist4 "$GPNPort10 $GPNPort11"
        set portList4 "$GPNTestEth4"
        set portList44 [concat $portlist4 $portList4]
        foreach port $portList44 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet4 $matchType4 $Gpn_type4 $fileId $port "disable" "enable"]
        	}
        }
        set rebootSlotlist4 [gwd::GWpulic_getWorkCardList $portlist4]
        gwd::GWpublic_print "OK" "��ȡ�豸NE4($gpnIp4)ҵ��忨��λ��$rebootSlotlist4" $fileId
        set rebootSlotList4 [gwd::GWpulic_getWorkCardList $portList4]
        gwd::GWpublic_print "OK" "��ȡ�豸NE4($gpnIp4)�����忨��λ��$rebootSlotList4" $fileId
        
        set Portlist "$GPNPort5 $GPNPort12 $GPNPort6 $GPNPort7 $GPNPort8 $GPNPort9 $GPNPort10 $GPNPort11"
        set Portlist0 "$GPNTestEth5 $GPNTestEth2 $GPNTestEth3 $GPNTestEth4"
	set Iplist "$ip612 $ip614 $ip621 $ip623 $ip632 $ip634 $ip643 $ip641"
        
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-LAN������ģ�黥�����Ļ�������ʧ�ܣ����Խ���" \
		"E-LAN������ģ�黥�����Ļ������óɹ�����������Ĳ���" "GPN_PTN_008"
        puts $fileId ""
        puts $fileId "===E-LAN������ģ�黥�����������ý���..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 ELAN��FDBģ�黥����\n"
        ##��FDB������   
        #   <1>����ELANҵ�񲢷������������鿴mac��ַ���� mac��ַѧϰ��ȷ
        #   Ԥ�ڽ��������vpls��PW��AC��ѯ��������ȷ��ѯ
        #   <2>ֹͣ������5min��mac��ַ�ϻ�
        #   <3>�ٴη�����Mac����ѧϰ
	set flag1_case1 0
	set flag2_case1 0
	set flag3_case1 0
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����ELANҵ�����mac��ַ��ѧϰ  ���Կ�ʼ=====\n"
	set id 1
	foreach telnet $lSpawn_id matchType $lMatchType Gpn_type $lDutType {port1 port2} $Portlist {vid1 vid2} $Vlanlist {Ip1 Ip2} $Iplist eth $Portlist0 {
		if {[string match "L2" $Worklevel]} {
			set interfaceA v$vid1
			set interfaceB v$vid2
		} else {
			set interfaceA $port1.$vid1
			set interfaceB $port2.$vid2
		}
		if {[string match "L2" $Worklevel]}  {
			gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port1 "enable"
			gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port2 "enable"
		}
		PTN_NNI_AddInterIp $fileId $Worklevel $interfaceA $Ip1 $port1 $matchType $Gpn_type $telnet
		PTN_NNI_AddInterIp $fileId $Worklevel $interfaceB $Ip2 $port2 $matchType $Gpn_type $telnet
		PTN_UNI_AddInter $telnet $matchType $Gpn_type $fileId $Worklevel "800" $eth
		###����vpls
		gwd::GWVpls_AddInfo $telnet $matchType $Gpn_type $fileId "vpls$id" $id "elan" "flood" "false" "false" "false" "true" "2000" "" ""
		incr id
	}
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
	####����NE1
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface3 $ip621 "100" "100" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $interface10 $ip641 "400" "400" "normal" "4"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $address614
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $interface3 $ip621 "500" "500" "normal" "3"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $address613
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "4000" "4000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "5000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth5 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"	
	
	####����NE2
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface4 $ip612 "100" "100" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $interface5 $ip632 "200" "200" "normal" "3"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $address623
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $interface5 $ip632 "700" "700" "normal" "4"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $address624
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface5 $ip632 "500" "600" "0" 23 "normal"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface4 $ip612 "600" "500" "0" 21 "normal"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "vpls" "vpls2" "peer" $address623 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24" "vpls" "vpls2" "peer" $address624 "6000" "6000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"

        #####����NE3
        gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $interface6 $ip623 "200" "200" "normal" "2"
        gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $address632
        gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
        gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34" $interface7 $ip643 "300" "300" "normal" "4"
        gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34" $address634
        gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34"
        gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $interface6 $ip623 "600" "600" "normal" "1"
        gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $address631
        gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
        gwd::GWpublic_createLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $interface6 $ip623 "800" "700" "0" 32 "normal"
        gwd::GWpublic_createLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $interface7 $ip643 "700" "800" "0" 34 "normal"
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw34" "vpls" "vpls3" "peer" $address634 "3000" "3000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "5000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
        gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac800" "vpls3" "" $GPNTestEth3 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
        
        #####����NE4
        gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $interface9 $ip614 "400" "400" "normal" "1"
        gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $address641
        gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"
        gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43" $interface8 $ip634 "300" "300" "normal" "3"
        gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43" $address643
        gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43"
        gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42" $interface8 $ip634 "800" "800" "normal" "2"
        gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42" $address642
        gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42"
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "4000" "4000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43" "vpls" "vpls4" "peer" $address643 "3000" "3000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42" "vpls" "vpls4" "peer" $address642 "6000" "6000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
        gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac800" "vpls4" "" $GPNTestEth4 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"

	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort5Stream12 $hGPNPort2Stream20" \
		-activate "true"
	gwd::Start_SendFlow "$::hGPNPort5Gen $::hGPNPort2Gen"  "$::hGPNPort5Ana $::hGPNPort2Ana"
	after 10000
	gwd::Stop_SendFlow "$::hGPNPort5Gen $::hGPNPort2Gen"  "$::hGPNPort5Ana $::hGPNPort2Ana"
	set lExpect1 {0000.0000.000C {vplsName vpls1 portname ac800 flag none drop none} \
			0000.0000.00CC {vplsName vpls1 portname pw12 flag none drop none}}
	set lExpect2 {0000.0000.00CC {vplsName vpls1 portname pw12 flag none drop none}}
	set lExpect3 {0000.0000.000C {vplsName vpls1 portname ac800 flag none drop none}}
	if {[PTN_ElanAndFdb "NE1($gpnIp1)$GPNTestEth5\����smac=0000.0000.000c����������NE2($gpnIp2)$GPNTestEth2\����smac=0000.0000.00cc����������" $lExpect1 "vpls1" $lExpect2 "pw12" $lExpect3 "ac800" ""]} {
		set flag1_case1 1
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1�����ۣ�����ELANҵ�����mac��ַ��ѧϰ" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1�����ۣ�����ELANҵ�����mac��ַ��ѧϰ" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����ELANҵ�����mac��ַ��ѧϰ  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ֹͣ�����������ȴ��ϻ�ʱ�����mac��ַ�Ƿ��ϻ�  ���Կ�ʼ=====\n"
	after 350000 ;#�ȴ�mac��ַ�ϻ���Ĭ���ϻ�ʱ��Ϊ300���ȴ�350
	gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
	if {$dTable != ""} {
		set flag2_case1 1
		dict for {key value} $dTable {
			gwd::GWpublic_print "NOK" "����350s��[dict get $value portname]�ϵ�mac��ַ$key\û���ϻ�" $fileId
		}
	} else {
		gwd::GWpublic_print "OK" "�ȴ��ϻ�ʱ����ѯvpls1�ϵ�mac��ַ������mac��ַȫ�����ϻ�" $fileId
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2�����ۣ�ֹͣ�����������ȴ��ϻ�ʱ���macû���ϻ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2�����ۣ�ֹͣ�����������ȴ��ϻ�ʱ���mac�ϻ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ֹͣ�����������ȴ��ϻ�ʱ�����mac��ַ�Ƿ��ϻ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�ٴη������������mac��ַ�Ƿ�����������ѧϰ  ���Կ�ʼ=====\n"
	gwd::Start_SendFlow "$::hGPNPort5Gen $::hGPNPort2Gen"  "$::hGPNPort5Ana $::hGPNPort2Ana"
	after 10000
	gwd::Stop_SendFlow "$::hGPNPort5Gen $::hGPNPort2Gen"  "$::hGPNPort5Ana $::hGPNPort2Ana"
	if {[PTN_ElanAndFdb "mac��ַ�ϻ������·�����������NE1($gpnIp1)$GPNTestEth5\����smac=0000.0000.000c����������NE2($gpnIp2)$GPNTestEth2\����smac=0000.0000.00cc����������" $lExpect1 "vpls1" $lExpect2 "pw12" $lExpect3 "ac800" ""]} {
		set flag3_case1 1
	}
	#��case1�Ĳ����з�������֪��������Ϊ�˲�Ӱ�������������ԣ�ͨ��shut/undo shut�˿ڵķ���ɾ��ת������
	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "shutdown"
	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "shutdown"
	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "undo shutdown"
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3�����ۣ�mac��ַ�ϻ������·���������mac��ַѧϰ�쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3�����ۣ�mac��ַ�ϻ������·���������mac��ַѧϰ����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�ٴη������������mac��ַ�Ƿ�����������ѧϰ  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase1 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 1���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 1���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 1 ELAN��FDBģ�黥�������Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 ELAN��TRUNKģ�黥������\n"
	##��TRUNK������
	#   <4>��̨76������� ��NE1--NE2--NE3����������NE1�豸ͨ�����������ܣ�NE2��NE3�豸�Ǵ��������ܣ��˴�֮���NNI�˿�����Ϊtrunk�˿ڣ�����trunk���԰�2���˿ڣ�2���˿ڶ���up
	#   <5>����E-LANҵ�����ݣ�ҵ���������óɹ�
	##trunk���ģʽΪsharing
	#   <6>����down/up trunk���˿�50�Σ�ҵ�����������ͻָ�����¼��ҵ�񵹻��ͻָ�ʱ�䣨������50ms��
	#   <7>����down/up trunk�Ӷ˿�50�Σ�ϵͳ���쳣��ҵ�񲻷����������޶���
	#   <8>trunk��˿ڳ�Ա������down��ҵ���жϣ��ָ�trunk������һ���˿ڳ�Ա��ҵ��ɻָ�
	#   <9>����trunk���ģʽΪ1:1�ظ�6-7����
	#   <10> �������豸��trunk�и����һ��down�Ķ˿ڣ��˿���ӳɹ���ҵ����Ӱ��
	#        �ٴ��������豸��trunk��ɾ����down�Ķ˿ڣ��˿�ɾ���ɹ���ҵ����Ӱ��
	#        �ٴ������豸��trunk�и����һ��up�Ķ˿ڣ��˿���ӳɹ���ҵ����Ӱ��
	#        �ٴ��������豸��trunk��ɾ����up�Ķ˿ڣ��˿�ɾ���ɹ���ҵ����Ӱ��
	#   <11>����trunk��˿ڳ�Ա��忨���ظ�6-10��
	#   <12>��UNI��Ķ˿�����Ϊturnk�˿ڣ�����ҵ�����ݣ�ҵ���������óɹ���ҵ��������������ת��
	#   <13>�����õ�trunk�ۺϷ�ʽΪ��̬���ظ�6-12��
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0
	set flag5_case2 0
	set flag6_case2 0
	set flag7_case2 0

	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��trunk���Աͬ�忨������ELAN��trunk������  ���Կ�ʼ=====\n"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort15 "undo shutdown"
	#dev1 ��dev2����down�˿��������trunk����------
	set downPort_dev1 1/1
	set downPort_dev2 1/1
	gwd::GWmanage_GetPortInfo $telnet1 $matchType1 $Gpn_type1 $fileId KeyInfo
	regexp {(\d+)/\d+} $GPNPort5 match slot1
	regexp {(\d+)/\d+} $GPNPort17 match slot2
	dict for {key value} $KeyInfo {
		regexp {(\d+)/\d+} $key match slot
		if {($slot == $slot1) || ($slot == $slot2)} {
			if {[string match -nocase [dict get $value PhyStat] down] && [string match -nocase [dict get $value AdminStat] up]\
				&& ![string match $GPNPort5 $key] && ![string match $GPNPort17 $key] && ![string match $GPNPort13 $key]} {
				set downPort_dev1 $key
				break
			}
		}
	}
	gwd::GWmanage_GetPortInfo $telnet2 $matchType2 $Gpn_type2 $fileId KeyInfo
	regexp {(\d+)/\d+} $GPNPort6 match slot1
	regexp {(\d+)/\d+} $GPNPort18 match slot2
	dict for {key value} $KeyInfo {
		regexp {(\d+)/\d+} $key match slot
		if {($slot == $slot1) || ($slot == $slot2)} {
			if {[string match -nocase [dict get $value PhyStat] down] && [string match -nocase [dict get $value AdminStat] up]\
				&& ![string match $GPNPort6 $key] && ![string match $GPNPort18 $key] && ![string match $GPNPort14 $key]} {
				set downPort_dev2 $key
				break
			}
		}
	}
	#------dev1 ��dev3����down�˿��������trunk����
			
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
	PTN_DelInterVid_new $fileId $Worklevel $GPNPort5.4 $matchType1 $Gpn_type1 $telnet1
	
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24"
	gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
	gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"
	gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort7.5 $ip632 "500" "600" "0" 23 "normal"
	gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort6.4 $ip612 "600" "500" "0" 21 "normal"
	PTN_DelInterVid_new $fileId $Worklevel $GPNPort6.4 $matchType2 $Gpn_type2 $telnet2
	PTN_DelInterVid_new $fileId $Worklevel $GPNPort7.5 $matchType2 $Gpn_type2 $telnet2
	
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"
	gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
	gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
	gwd::GWpublic_delLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $GPNPort8.5 $ip623 "800" "700" "0" 32 "normal"
	PTN_DelInterVid_new $fileId $Worklevel $GPNPort8.5 $matchType3 $Gpn_type3 $telnet3
	

	#����trunk�飬����trunk����ӵ�vlan/�ӽӿ�------
	if {[string match "L2" $trunkLevel]} {
		if {[string match "L3" $Worklevel]} {
			gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "disable" "enable"
			gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "disable" "enable"
			gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort17 "disable" "enable"
			gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "disable" "enable"
			gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort14 "disable" "enable"
			gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort18 "disable" "enable"
			gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort7 "disable" "enable"
			gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort15 "disable" "enable"
			gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "disable" "enable"
			gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort16 "disable" "enable"
		}
		gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNPort5 $GPNPort13"
		gwd::GWL2Inter_AddVlanPort $telnet1 $matchType1 $Gpn_type1 $fileId "4" "trunk" "t1" "untagged"
		gwd::GWpublic_CfgVlanIp $telnet1 $matchType1 $Gpn_type1 $fileId "4" $ip612 "24"
		gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" "vlan" "v4" $ip621 "100" "100" "normal" "2"
		gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" "vlan" "v4" $ip621 "500" "500" "normal" "3"
		
		gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "" "$GPNPort6 $GPNPort14"
		gwd::GWL2Inter_AddVlanPort $telnet2 $matchType2 $Gpn_type2 $fileId "4" "trunk" "t1" "untagged"
		gwd::GWpublic_CfgVlanIp $telnet2 $matchType2 $Gpn_type2 $fileId "4" $ip621 "24"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" "vlan" "v4" $ip612 "100" "100" "normal" "1"
	
		gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t2" "" "$GPNPort7 $GPNPort15"
		gwd::GWL2Inter_AddVlanPort $telnet2 $matchType2 $Gpn_type2 $fileId "5" "trunk" "t2" "untagged"
		gwd::GWpublic_CfgVlanIp $telnet2 $matchType2 $Gpn_type2 $fileId "5" $ip623 "24"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" "vlan" "v5" $ip632 "200" "200" "normal" "3"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" "vlan" "v5" $ip632 "700" "700" "normal" "4"
		
		gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t2" "" "$GPNPort8 $GPNPort16"
		gwd::GWL2Inter_AddVlanPort $telnet3 $matchType3 $Gpn_type3 $fileId "5" "trunk" "t2" "untagged"
		gwd::GWpublic_CfgVlanIp $telnet3 $matchType3 $Gpn_type3 $fileId "5" $ip632 "24"
		gwd::GWStaLsp_AddLspInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" "vlan" "v5" $ip623 "200" "200" "normal" "2"
		gwd::GWStaLsp_AddLspInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" "vlan" "v5" $ip623 "600" "600" "normal" "1"
	} else {
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "disable" "disable"
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "disable" "disable"
		gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNPort5 $GPNPort13"
		gwd::GWL3_AddInterDcn $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "enable"
		gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4"
		gwd::GWL3port_AddIP $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4" $ip612 "24"
		gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" "trunk" "t1.4" $ip621 "100" "100" "normal" "2"
		gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" "trunk" "t1.4" $ip621 "500" "500" "normal" "3"
		
		gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "disable" "disable"
		gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort14 "disable" "disable"
		gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "" "$GPNPort6 $GPNPort14"
		gwd::GWL3_AddInterDcn $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "enable"
		gwd::GWL3Inter_AddL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4"
		gwd::GWL3port_AddIP $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4" $ip621 "24"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" "trunk" "t1.4" $ip612 "100" "100" "normal" "1"
		
		gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort7 "disable" "disable"
		gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort15 "disable" "disable"
		gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t2" "" "$GPNPort7 $GPNPort15"
		gwd::GWL3_AddInterDcn $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2" "enable"
		gwd::GWL3Inter_AddL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2" "5"
		gwd::GWL3port_AddIP $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2" "5" $ip623 "24"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" "trunk" "t2.5" $ip632 "200" "200" "normal" "3"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" "trunk" "t2.5" $ip632 "700" "700" "normal" "4"
		
		gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "disable" "disable"
		gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort16 "disable" "disable"
		gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t2" "" "$GPNPort8 $GPNPort16"
		gwd::GWL3_AddInterDcn $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2" "enable"
		gwd::GWL3Inter_AddL3 $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2" "5"
		gwd::GWL3port_AddIP $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2" "5" $ip632 "24"
		gwd::GWStaLsp_AddLspInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" "trunk" "t2.5" $ip623 "200" "200" "normal" "2"
		gwd::GWStaLsp_AddLspInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" "trunk" "t2.5" $ip623 "600" "600" "normal" "1"
	}
	
	#------����trunk�飬����trunk����ӵ�vlan/�ӽӿ�
	#####����NE1
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $address613
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "5000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	#####����NE2
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $address623
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $address624
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"
	
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "vpls" "vpls2" "peer" $address623 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24" "vpls" "vpls2" "peer" $address624 "6000" "6000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	#####����NE3
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $address632
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $address631
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "5000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	if {[string match "L2" $trunkLevel]} {
		gwd::GWpublic_createLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "vlan" "v5" $ip632 "500" "600" "0" 23 "normal"
		gwd::GWpublic_createLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "vlan" "v4" $ip612 "600" "500" "0" 21 "normal"
		gwd::GWpublic_createLspSw_new $telnet3 $matchType3 $Gpn_type3 $fileId "vlan" "v5" $ip623 "800" "700" "0" 32 "normal"
	} else {
		gwd::GWpublic_createLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2.5" $ip632 "500" "600" "0" 23 "normal"
		gwd::GWpublic_createLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1.4" $ip612 "600" "500" "0" 21 "normal"	
		gwd::GWpublic_createLspSw_new $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2.5" $ip623 "800" "700" "0" 32 "normal"
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort2Stream20" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort2Stream13 $hGPNPort3Stream17" \
		-activate "true"
	incr capId
	if {[PTN_TrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "GPN_PTN_008" $capId "sharing" "t1" "$GPNPort5 $GPNPort13" $GPNPort17 $GPNPort18 "elan"]} {
		set flag1_case2 1
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA4�����ۣ�trunkģʽΪsharing��trunk���Աͬ�忨������ELAN��trunk������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4�����ۣ�trunkģʽΪsharing��trunk���Աͬ�忨������ELAN��trunk������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��trunk���Աͬ�忨������ELAN��trunk������  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪlag1:1��trunk���Աͬ�忨������ELAN��trunk������  ���Կ�ʼ=====\n"
	#######################################################lagģʽΪ1+1##################################################################
	gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "lag1:1"
	gwd::GWpublic_addTrunkMode $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "" "lag1:1"
	gwd::GWpublic_addTrunkMode $telnet2 $matchType2 $Gpn_type2 $fileId "t2" "" "lag1:1"
	gwd::GWpublic_addTrunkMode $telnet3 $matchType3 $Gpn_type3 $fileId "t2" "" "lag1:1"
	if {[PTN_TrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "GPN_PTN_008" $capId "lag1:1" "t1" "$GPNPort5 $GPNPort13" $GPNPort17 $GPNPort18 "elan"]} {
		set flag2_case2 1
	}
	puts $fileId ""
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA5�����ۣ�trunkģʽΪlag1:1��trunk���Աͬ�忨������ELAN��trunk������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5�����ۣ�trunkģʽΪlag1:1��trunk���Աͬ�忨������ELAN��trunk������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪlag1:1��trunk���Աͬ�忨������ELAN��trunk������  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪlag1:1��trunk���Ա��忨������ELAN��trunk������  ���Կ�ʼ=====\n"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort17 "undo shutdown"
	if {[string match "L2" $trunkLevel]} {
		gwd::GWpublic_delPortFromTrunk $telnet1 $matchType1 $Gpn_type1 $fileId t1 "all"
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort17 "disable" "enable"
		gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNPort5,$GPNPort17"
		gwd::GWpublic_delPortFromTrunk $telnet2 $matchType2 $Gpn_type2 $fileId t1 "all"
		gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort18 "disable" "enable"
		gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "" "$GPNPort6,$GPNPort18"
	} else {
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
		gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4"
		gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4094"
		gwd::GWpublic_delPortFromTrunk $telnet1 $matchType1 $Gpn_type1 $fileId t1 "all"
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort17 "disable" "disable"
		gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNPort5 $GPNPort17"
		gwd::GWL3_AddInterDcn $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "enable"
		gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4"
		gwd::GWL3port_AddIP $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4" $ip612 "24"
		gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" "trunk" "t1.4" $ip621 "100" "100" "normal" "2"
		gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
		gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
		gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" "trunk" "t1.4" $ip621 "500" "500" "normal" "3"
		gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $address613
		gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "5000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		
		gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
		gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
		gwd::GWpublic_delLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1.4" $ip612 "600" "500" "0" 21 "normal"
		gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4"
		gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4094"
		gwd::GWpublic_delPortFromTrunk $telnet2 $matchType2 $Gpn_type2 $fileId t1 "all"
		gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort18 "disable" "disable"
		gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "" "$GPNPort6 $GPNPort18"
		gwd::GWL3_AddInterDcn $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "enable"
		gwd::GWL3Inter_AddL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4"
		gwd::GWL3port_AddIP $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4" $ip621 "24"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" "trunk" "t1.4" $ip612 "100" "100" "normal" "1"
		gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
		gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
		gwd::GWpublic_createLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1.4" $ip612 "600" "500" "0" 21 "normal"
		gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	}
	
	if {[PTN_TrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "GPN_PTN_008" $capId "lag1:1" "t1" "$GPNPort5 $GPNPort17" $GPNPort13 $GPNPort14 "elan"]} {
		set flag3_case2 1
	}
	
	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA6�����ۣ�trunkģʽΪlag1:1��trunk���Ա��忨������ELAN��trunk������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6�����ۣ�trunkģʽΪlag1:1��trunk���Ա��忨������ELAN��trunk������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪlag1:1��trunk���Ա��忨������ELAN��trunk������  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��trunk���Ա��忨������ELAN��trunk������  ���Կ�ʼ=====\n"
	gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "sharing"
	gwd::GWpublic_addTrunkMode $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "" "sharing"
	gwd::GWpublic_addTrunkMode $telnet2 $matchType2 $Gpn_type2 $fileId "t2" "" "sharing"
	gwd::GWpublic_addTrunkMode $telnet3 $matchType3 $Gpn_type3 $fileId "t2" "" "sharing"
	if {[PTN_TrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "GPN_PTN_008" $capId "sharing" "t1" "$GPNPort5 $GPNPort17" $GPNPort13 $GPNPort14 "elan"]} {
		set flag4_case2 1
	}
	
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA7�����ۣ�trunkģʽΪsharing��trunk���Ա��忨������ELAN��trunk������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7�����ۣ�trunkģʽΪsharing��trunk���Ա��忨������ELAN��trunk������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪsharing��trunk���Ա��忨������ELAN��trunk������  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunk���Աͬ�忨������ELAN��trunk������  ���Կ�ʼ=====\n"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort17 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "undo shutdown"
	if {[string match "L2" $trunkLevel]} {
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
		gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23"
		gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
		gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24"
		gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
		gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
		gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"
		gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32"
		gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"
		gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
		gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
		gwd::GWpublic_delLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "vlan" "v4" $ip612 "600" "500" "0" 21 "normal"
		gwd::GWpublic_delLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "vlan" "v5" $ip632 "500" "600" "0" 23 "normal"
		gwd::GWpublic_delLspSw_new $telnet3 $matchType3 $Gpn_type3 $fileId "vlan" "v5" $ip623 "800" "700" "0" 32 "normal"
		gwd::GWL2Inter_DelVlan $telnet1 $matchType1 $Gpn_type1 $fileId "4"
		gwd::GWL2Inter_DelVlan $telnet2 $matchType2 $Gpn_type2 $fileId "4"
		gwd::GWL2Inter_DelVlan $telnet2 $matchType2 $Gpn_type2 $fileId "5"
		gwd::GWL2Inter_DelVlan $telnet3 $matchType3 $Gpn_type3 $fileId "5"
		gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" ""
		gwd::GWTrunk_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" ""
		gwd::GWTrunk_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t2" ""
		gwd::GWTrunk_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t2" ""
		
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "disable" "enable"
		gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort14 "disable" "enable"
		gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "$GPNPort5 $GPNPort13"
		gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "static" "$GPNPort6 $GPNPort14"
		gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t2" "static" "$GPNPort7 $GPNPort15"
		gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t2" "static" "$GPNPort8 $GPNPort16"
		gwd::GWL2Inter_AddVlanPort $telnet1 $matchType1 $Gpn_type1 $fileId "4" "trunk" "t1" "untagged"
		gwd::GWL2Inter_AddVlanPort $telnet2 $matchType2 $Gpn_type2 $fileId "4" "trunk" "t1" "untagged"
		gwd::GWL2Inter_AddVlanPort $telnet2 $matchType2 $Gpn_type2 $fileId "5" "trunk" "t2" "untagged"
		gwd::GWL2Inter_AddVlanPort $telnet3 $matchType3 $Gpn_type3 $fileId "5" "trunk" "t2" "untagged"
		gwd::GWpublic_CfgVlanIp $telnet1 $matchType1 $Gpn_type1 $fileId "4" $ip612 "24"
		gwd::GWpublic_CfgVlanIp $telnet2 $matchType2 $Gpn_type2 $fileId "4" $ip621 "24"
		gwd::GWpublic_CfgVlanIp $telnet2 $matchType2 $Gpn_type2 $fileId "5" $ip623 "24"
		gwd::GWpublic_CfgVlanIp $telnet3 $matchType3 $Gpn_type3 $fileId "5" $ip632 "24"
		
		gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" "vlan" "v4" $ip621 "100" "100" "normal" "2"
		gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" "vlan" "v4" $ip621 "500" "500" "normal" "3"
		gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
		gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
		gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $address613
		gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "5000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" "vlan" "v4" $ip612 "100" "100" "normal" "1"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" "vlan" "v5" $ip632 "200" "200" "normal" "3"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" "vlan" "v5" $ip632 "700" "700" "normal" "4"
		gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
		gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
		gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $address623
		gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
		gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $address624
		gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"
		gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
		gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "vpls" "vpls2" "peer" $address623 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24" "vpls" "vpls2" "peer" $address624 "6000" "6000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
		gwd::GWStaLsp_AddLspInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" "vlan" "v5" $ip623 "200" "200" "normal" "2"
		gwd::GWStaLsp_AddLspInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" "vlan" "v5" $ip623 "600" "600" "normal" "1"
		gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $address632
		gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
		gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $address631
		gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
		gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "5000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
		gwd::GWpublic_createLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "vlan" "v5" $ip632 "500" "600" "0" 23 "normal"
		gwd::GWpublic_createLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "vlan" "v4" $ip612 "600" "500" "0" 21 "normal"
		gwd::GWpublic_createLspSw_new $telnet3 $matchType3 $Gpn_type3 $fileId "vlan" "v5" $ip623 "800" "700" "0" 32 "normal"
	} else {
		after 120000
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
		gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4"
		gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4094"
		gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" ""
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "disable" "disable"
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "disable" "disable"
		gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "$GPNPort5 $GPNPort13"
		gwd::GWL3_AddInterDcn_reconfiguration $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "enable" "static"
		gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4"
		gwd::GWL3port_AddIP $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4" $ip612 "24"
		gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" "trunk" "t1.4" $ip621 "100" "100" "normal" "2"
		gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
		gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"		
		gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" "trunk" "t1.4" $ip621 "500" "500" "normal" "3"
		gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $address613
		gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "5000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		
		gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
		gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
		gwd::GWpublic_delLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1.4" $ip612 "600" "500" "0" 21 "normal"
		gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4"
		gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4094"
		gwd::GWTrunk_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" ""
		gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "disable" "disable"
		gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort14 "disable" "disable"
		gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "static" "$GPNPort6 $GPNPort14"
		gwd::GWL3_AddInterDcn_reconfiguration $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "enable" "static"
		gwd::GWL3Inter_AddL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4"
		gwd::GWL3port_AddIP $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4" $ip621 "24"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" "trunk" "t1.4" $ip612 "100" "100" "normal" "1"
		gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
		gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
		gwd::GWpublic_createLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1.4" $ip612 "600" "500" "0" 21 "normal"
		gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
		
		gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23"
		gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24"
		gwd::GWpublic_delLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2.5" $ip632 "500" "600" "0" 23 "normal"
		gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
		gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"
		gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2" "5"
		gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2" "4094"
		gwd::GWTrunk_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t2" ""
		gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t2" "static" "$GPNPort7 $GPNPort15"
		gwd::GWL3_AddInterDcn_reconfiguration $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2" "enable" "static"
		gwd::GWL3Inter_AddL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2" "5"
		gwd::GWL3port_AddIP $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2" "5" $ip623 "24"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" "trunk" "t2.5" $ip632 "200" "200" "normal" "3"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" "trunk" "t2.5" $ip632 "700" "700" "normal" "4"
		gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $address623
		gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
		gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $address624
		gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"
		gwd::GWpublic_createLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2.5" $ip632 "500" "600" "0" 23 "normal"
		gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "vpls" "vpls2" "peer" $address623 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24" "vpls" "vpls2" "peer" $address624 "6000" "6000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
		
		gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32"
		gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"
		gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
		gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
		gwd::GWpublic_delLspSw_new $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2.5" $ip623 "800" "700" "0" 32 "normal"
		gwd::GWL3Inter_DelL3 $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2" "5"
		gwd::GWL3Inter_DelL3 $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2" "4094"
		gwd::GWTrunk_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t2" ""
		gwd::GWTrunk_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t2" "static" "$GPNPort8 $GPNPort16"
		gwd::GWL3_AddInterDcn_reconfiguration $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2" "enable" "static"
		gwd::GWL3Inter_AddL3 $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2" "5"
		gwd::GWL3port_AddIP $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2" "5" $ip632 "24"
		gwd::GWStaLsp_AddLspInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" "trunk" "t2.5" $ip623 "200" "200" "normal" "2"
		gwd::GWStaLsp_AddLspInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" "trunk" "t2.5" $ip623 "600" "600" "normal" "1"
		gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $address632
		gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
		gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $address631
		gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
		gwd::GWpublic_createLspSw_new $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2.5" $ip623 "800" "700" "0" 32 "normal"
		gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "5000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	}
	
	
	if {[PTN_TrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "GPN_PTN_008" $capId "static" "t1" "$GPNPort5 $GPNPort13" $GPNPort17 $GPNPort18 "elan"]} {
		set flag5_case2 1
	}
	
	puts $fileId ""
	if {$flag5_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA8�����ۣ�trunkģʽΪstatic��trunk���Աͬ�忨������ELAN��trunk������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8�����ۣ�trunkģʽΪstatic��trunk���Աͬ�忨������ELAN��trunk������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunk���Աͬ�忨������ELAN��trunk������  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunk���Ա��忨������ELAN��trunk������  ���Կ�ʼ=====\n"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort17 "undo shutdown"
	if {[string match "L2" $trunkLevel]} {
		gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static"
		gwd::GWTrunk_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "static"
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort17 "disable" "enable"
		gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort18 "disable" "enable"
		gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "$GPNPort5 $GPNPort17"
		gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "static" "$GPNPort6 $GPNPort18"
		gwd::GWL2Inter_AddVlanPort $telnet1 $matchType1 $Gpn_type1 $fileId "4" "trunk" "t1" "untagged"
		gwd::GWL2Inter_AddVlanPort $telnet2 $matchType2 $Gpn_type2 $fileId "4" "trunk" "t1" "untagged"
	} else {
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
		gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4"
		gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4094"
		gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static"
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort17 "disable" "disable"
		gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static" "$GPNPort5 $GPNPort17"
		gwd::GWL3_AddInterDcn_reconfiguration $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "enable" "static"
		gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4"
		gwd::GWL3port_AddIP $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4" $ip612 "24"
		gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" "trunk" "t1.4" $ip621 "100" "100" "normal" "2"
		gwd::GWStaLsp_AddLspInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" "trunk" "t1.4" $ip621 "500" "500" "normal" "3"
		gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
		gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"		
		gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $address613
		gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "5000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		
		gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
		gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
		gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4"
		gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4094"
		gwd::GWTrunk_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "static"
		gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort18 "disable" "disable"
		gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "static" "$GPNPort6 $GPNPort18"
		gwd::GWL3_AddInterDcn_reconfiguration $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "enable" "static"
		gwd::GWL3Inter_AddL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4"
		gwd::GWL3port_AddIP $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4" $ip621 "24"
		gwd::GWStaLsp_AddLspInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" "trunk" "t1.4" $ip612 "100" "100" "normal" "1"
		gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
		gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
		gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	}
	
	if {[PTN_TrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "GPN_PTN_008" $capId "static" "t1" "$GPNPort5 $GPNPort17" $GPNPort13 $GPNPort14 "elan"]} {
		set flag6_case2 1
	}
	puts $fileId ""
	if {$flag6_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA9�����ۣ�trunkģʽΪstatic��trunk���Ա��忨������ELAN��trunk������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9�����ۣ�trunkģʽΪstatic��trunk���Ա��忨������ELAN��trunk������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunkģʽΪstatic��trunk���Ա��忨������ELAN��trunk������  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====UNI������Ϊtrunk�ڣ�����ELAN��trunk������  ���Կ�ʼ=====\n"
	###ɾ��trunk
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24"
	gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
	gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"
	gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
	gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
	if {[string match "L3" $trunkLevel]} {
		gwd::GWpublic_delLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1.4" $ip612 "600" "500" "0" 21 "normal"
		gwd::GWpublic_delLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2.5" $ip632 "500" "600" "0" 23 "normal"
		gwd::GWpublic_delLspSw_new $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2.5" $ip623 "800" "700" "0" 32 "normal"
		gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4"
		gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4094"
		gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4"
		gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t1" "4094"
		gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2" "5"
		gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "trunk" "t2" "4094"
		gwd::GWL3Inter_DelL3 $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2" "5"
		gwd::GWL3Inter_DelL3 $telnet3 $matchType3 $Gpn_type3 $fileId "trunk" "t2" "4094"
	} else {
		gwd::GWpublic_delLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "vlan" "v4" $ip612 "600" "500" "0" 21 "normal"
		gwd::GWpublic_delLspSw_new $telnet2 $matchType2 $Gpn_type2 $fileId "vlan" "v5" $ip632 "500" "600" "0" 23 "normal"
		gwd::GWpublic_delLspSw_new $telnet3 $matchType3 $Gpn_type3 $fileId "vlan" "v5" $ip623 "800" "700" "0" 32 "normal"
		gwd::GWpublic_Delvlan $telnet1 $matchType1 $Gpn_type1 $fileId "4"
		gwd::GWpublic_Delvlan $telnet2 $matchType2 $Gpn_type2 $fileId "4"
		gwd::GWpublic_Delvlan $telnet2 $matchType2 $Gpn_type2 $fileId "5"
		gwd::GWpublic_Delvlan $telnet3 $matchType3 $Gpn_type3 $fileId "5"
	}
	gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "static"
	gwd::GWTrunk_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "static"
	gwd::GWTrunk_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t2" "static"
	gwd::GWTrunk_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "t2" "static"
	
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort17 "shutdown"
	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort15 "shutdown"
	
	if {[string match "L3" $Worklevel]} {
        	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "enable" "disable"
        	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "enable" "disable"
        	gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort17 "enable" "disable"
        	gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "enable" "disable"
        	gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort14 "enable" "disable"
        	gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort18 "enable" "disable"
        	gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort7 "enable" "disable"
        	gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort15 "enable" "disable"
        	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "enable" "disable"
        	gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort16 "enable" "disable"
        }
        PTN_NNI_AddInterIp $fileId $Worklevel $interface3 $ip612 $GPNPort5 $matchType1 $Gpn_type1 $telnet1
        PTN_NNI_AddInterIp $fileId $Worklevel $interface4 $ip621 $GPNPort6 $matchType2 $Gpn_type2 $telnet2
        PTN_NNI_AddInterIp $fileId $Worklevel $interface5 $ip623 $GPNPort7 $matchType2 $Gpn_type2 $telnet2
        PTN_NNI_AddInterIp $fileId $Worklevel $interface6 $ip632 $GPNPort8 $matchType3 $Gpn_type3 $telnet3
        if {[string match "L2" $Worklevel]}  {
                gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "enable"
                gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "enable"
                gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort7 "enable"
                gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "enable"
        }
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface3 $ip621 "100" "100" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $interface3 $ip621 "500" "500" "normal" "3"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $address613
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "5000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface4 $ip612 "100" "100" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $interface5 $ip632 "200" "200" "normal" "3"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $address623
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $interface5 $ip632 "700" "700" "normal" "4"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $address624
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "vpls" "vpls2" "peer" $address623 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24" "vpls" "vpls2" "peer" $address624 "6000" "6000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $interface6 $ip623 "200" "200" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $address632
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $interface6 $ip623 "600" "600" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $address631
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "5000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface5 $ip632 "500" "600" "0" 23 "normal"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface4 $ip612 "600" "500" "0" 21 "normal"
	gwd::GWpublic_createLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $interface6 $ip623 "800" "700" "0" 32 "normal"		
	###����NE1
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	if {[string match "L2" $trunkLevel]} {
		if {[string match "L3" $Worklevel]} {
			gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "ethernet" $GPNTestEth5 "800"
		}
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "disable" "enable"
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 "disable" "enable"
		gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNTestEth1 $GPNTestEth5"
		gwd::GWL2Inter_AddVlanPort $telnet1 $matchType1 $Gpn_type1 $fileId "800" "trunk" "t1" "tagged"
	} else {
		gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "ethernet" $GPNTestEth5 "800"
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "disable" "disable"
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 "disable" "disable"
		gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNTestEth1 $GPNTestEth5"
		gwd::GWL3_AddInterDcn $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "enable"
		gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "800"
	}
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "trunk" "t1" "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	gwd::Start_SendFlow $hGPNPortGenList2  $hGPNPortAnaList2
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
		gwd::Start_CapAllData ::capArr $hGPNPort1Cap $hGPNPort1CapAnalyzer
		gwd::Start_CapAllData ::capArr $hGPNPort3Cap $hGPNPort3CapAnalyzer
	}
	after 10000
	foreach i "GPNPort5Cnt1 GPNPort1Cnt1 GPNPort3Cnt1" {
		array set $i {cnt12 0 drop12 0 rate12 0 cnt13 0 drop13 0 rate13 0 cnt19 0 drop19 0 rate19 0} 
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 3 $::hGPNPort5Ana GPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 0 0 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 3 $::hGPNPort1Ana GPNPort1Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 0 0 0 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 3 $::hGPNPort3Ana GPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 0 0 0
		after 5000
	}	
	incr capId
	if {$::cap_enable} {
		gwd::Stop_CapData $::hGPNPort5Cap 1 "GPN_PTN_008-$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"	
		gwd::Stop_CapData $::hGPNPort1Cap 1 "GPN_PTN_008-$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap"
		gwd::Stop_CapData $::hGPNPort3Cap 1 "GPN_PTN_008-$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap"
	}
	gwd::Stop_SendFlow $::hGPNPortGenList2  $::hGPNPortAnaList2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_008-$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_008-$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_008-$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	set trunkRate [expr $GPNPort5Cnt1(cnt19) + $GPNPort1Cnt1(cnt19)]
	if {$trunkRate < $::rateL || $trunkRate > $::rateR} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)UNI������Ϊtrunk�ڣ�NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE1($::gpnIp1)\
			t1($::GPNTestEth1 $::GPNTestEth5)\�յ�tag=800��������������Ϊ$trunkRate��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)UNI������Ϊtrunk�ڣ�NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE1($::gpnIp1)\
			t1($::GPNTestEth1 $::GPNTestEth5)\�յ�tag=800��������������Ϊ$trunkRate����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt1(cnt12) < $::rateL || $GPNPort3Cnt1(cnt12) > $::rateR} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)UNI������Ϊtrunk�ڣ�NE1($::gpnIp1)t1($::GPNTestEth1 $::GPNTestEth5)\����tag=800����������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)UNI������Ϊtrunk�ڣ�NE1($::gpnIp1)t1($::GPNTestEth1 $::GPNTestEth5)\����tag=800����������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag7_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB1�����ۣ�trunkģʽΪsharing��UNI��Ϊtrunk�ڲ���ELANҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1�����ۣ�trunkģʽΪsharing��UNI��Ϊtrunk�ڲ���ELANҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====UNI������Ϊtrunk�ڣ�����ELAN��trunk������  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	if {[string match "L3" $trunkLevel]} {
		gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "800"
		gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "trunk" "t1" "4094"
		
	} else {
		gwd::GWpublic_Delvlan $telnet1 $matchType1 $Gpn_type1 $fileId "800"
	}
	gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" ""
	if {[string match "L3" $Worklevel]} {
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "enable" "disable"
		gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 "enable" "disable"
	}
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "800" $GPNTestEth5
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "ethernet" $GPNTestEth5 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	puts $fileId "======================================================================================\n"
	if {$flagCase2 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 2���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 2���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 2 ELAN��TRUNKģ�黥�������Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 ELAN��QOS����������\n"
	##��QOS������
	#   <14>��϶���qos������Ϊ���٣��󶨵�ac�˿��ϣ���֤������Ч
	#   <15>����QoS���٣���QoS���԰󶨵�AC/PW/LSP����֤���ٿ�����Ч
	#   Ԥ�ڽ�������AC���ʲ��ɳ���PW��PW���ʲ��ɳ���LSP������Υ����ϵͳ����Ӧ����ʾ
	#   <16>����һ��PW ���е��Ȳ��������٣�ϵͳ���쳣���óɹ������������������۲���յ���ͬ���ȼ����������Ķ��ٱ����Ƿ�������
	puts $fileId ""
	puts $fileId "�ù��ܲ����ƣ���������"
        if {$flagCase3 == 1} {
        	gwd::GWpublic_print "NOK" "TestCase 3���Խ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "TestCase 3���Խ���" $fileId
        }
        puts $fileId ""
        puts $fileId "Test Case 3 ELAN��QOS���������Խ���\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 ELAN��OAM����������\n"
        ##��OAM������
        #   <17>���öβ�/PW/LSP��0AM���ɳɹ����ã�ϵͳ���쳣����ҵ������ת����Ӱ��
        #   <18>���öβ�/PW/LSP����Ӧ��CC���ܽ�ֹ/ʹ�ܣ����óɹ���ϵͳ���쳣����ҵ������ת����Ӱ��
        #   <19>���öβ�/PW/LSP����Ӧ��CCʱ�������������óɹ���ϵͳ���쳣����ҵ������ת����Ӱ��
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set flag5_case4 0
	set flag6_case4 0
	set flag7_case4 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP��OAM�����ELANҵ��  ���Կ�ʼ=====\n"
        gwd::GWpublic_createMplsMeg $telnet3 $matchType3 $Gpn_type3 $fileId "meg13"
        gwd::GWpublic_addMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "lsp" "lsp31" "2" "3"
        gwd::GWpublic_createMplsMeg $telnet1 $matchType1 $Gpn_type1 $fileId "meg11"
        gwd::GWpublic_addMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "lsp" "lsp13" "3" "2"
	incr capId
        if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\��$matchType3\����Lsp��OAM��"]} {
        	set flag1_case4 1
        }
	puts $fileId ""
	if {$flag1_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB2�����ۣ�����LSP��OAM�����ELANҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2�����ۣ�����LSP��OAM�����ELANҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP��OAM�����ELANҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW��OAM�����ELANҵ��  ���Կ�ʼ=====\n"
        gwd::GWpublic_delMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "lsp"
        gwd::GWpublic_addMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "pw" "pw13" "5" "4"
        gwd::GWpublic_delMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "lsp"
        gwd::GWpublic_addMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "pw" "pw31" "4" "5"
	incr capId
        if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\��$matchType3\����PW��OAM��"]} {
        	set flag2_case4 1
        }
	puts $fileId ""
	if {$flag2_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB3�����ۣ�����PW��OAM�����ELANҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3�����ۣ�����PW��OAM�����ELANҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW��OAM�����ELANҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���öβ��OAM�����ELANҵ��  ���Կ�ʼ=====\n"
        gwd::GWpublic_delMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "pw"
        gwd::GWpublic_addMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "segment" $GPNTestEth3 "7" "6"
        gwd::GWpublic_delMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "pw"
        gwd::GWpublic_addMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "segment" $GPNTestEth5 "6" "7"
	incr capId
        if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\��$matchType3\���öβ�OAM��"]} {
        	set flag3_case4 1
        }
	puts $fileId ""
	if {$flag3_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB4�����ۣ����öβ��OAM�����ELANҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4�����ۣ����öβ��OAM�����ELANҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���öβ��OAM�����ELANҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�CCʹ�ܺ����ELANҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_addMplsCc $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "enable"
	gwd::GWpublic_addMplsCc $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "enable"
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\��$matchType3\����LSP/PW/�β�CCʹ�ܺ�"]} {
		set flag4_case4 1
	}
	puts $fileId ""
	if {$flag4_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB5�����ۣ�����LSP/PW/�β�CCʹ�ܺ����ELANҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5�����ۣ�����LSP/PW/�β�CCʹ�ܺ����ELANҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�CCʹ�ܺ����ELANҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�CCȥʹ�ܺ����ELANҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_addMplsCc $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "disable"
	gwd::GWpublic_addMplsCc $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "disable"
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\��$matchType3\����LSP/PW/�β�CCȥʹ�ܺ�"]} {
		set flag5_case4 1
	}
	puts $fileId ""
	if {$flag5_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB6�����ۣ�����LSP/PW/�β�CCȥʹ�ܺ����ELANҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6�����ۣ�����LSP/PW/�β�CCȥʹ�ܺ����ELANҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�CCȥʹ�ܺ����ELANҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�CCʱ���������ELANҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_addMplsCcInt $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "100ms"
	gwd::GWpublic_addMplsCcInt $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "1s"
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\��$matchType3\����LSP/PW/�β�CCʱ������"]} {
		set flag6_case4 1
	}
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB7�����ۣ�����LSP/PW/�β�CCʱ���������ELANҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7�����ۣ�����LSP/PW/�β�CCʱ���������ELANҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�CCʱ���������ELANҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�LB�����ELANҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_addMplsLb $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "mep" "255" "3"
	gwd::GWpublic_addMplsLb $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "mep" "255" "5"
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\��$matchType3\����LSP/PW/�β�LB��"]} {
		set flag7_case4 1
	}
	puts $fileId ""
	if {$flag7_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB8�����ۣ�����LSP/PW/�β�LB�����ELANҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8�����ۣ�����LSP/PW/�β�LB�����ELANҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����LSP/PW/�β�LB�����ELANҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase4 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 4���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 4���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 4 ELAN��OAMģ�黥�������Խ���\n"
 	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 ELAN��DCN����������\n"
	##��DCN������ 
	#   <20>4̨�豸��DCN�������ܣ�����һ̨Ϊ������Ԫ��ʣ����̨Ϊ��������Ԫ
	#   <21>4̨�豸����ping�����������豸��������������
	#   Ԥ�ڽ����ҵ������������ת����ϵͳ���쳣
	#             ɾ����������DCN���ã���E-LANҵ����Ӱ��
	set flag1_case5 0
	set flag2_case5 0
	set flag3_case5 0
	gwd::GWpublic_delMplsMeg $telnet1 $matchType1 $Gpn_type1 $fileId "meg11"
	gwd::GWpublic_delMplsMeg $telnet3 $matchType3 $Gpn_type3 $fileId "meg13"
	if {[string match "L2" $Worklevel]}  {
		puts $fileId "======================================================================================\n"
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����DCN�����ELANҵ��  ���Կ�ʼ=====\n"
		set portlist1 "$GPNTestEth1 $GPNPort5 $GPNPort12"
		set portlist2 "$GPNPort6 $GPNPort7"
		set portlist3 "$GPNPort8 $GPNPort9"
		set portlist4 "$GPNPort10 $GPNPort11"
		set ip21 192.10.1.1
		set ip22 192.10.1.2
		set ip23 192.10.1.3
		set ip24 192.10.1.4
		set typelist1 "mgt ne-to-ne ne-to-ne";#DCN����ʱNE1������Ԫ�˿ڽ�ɫ�б�
		set typelist2 "ne-to-ne ne-to-ne";#DCN����ʱNE2��������Ԫ�˿ڽ�ɫ�б�
		set typelist3 "ne-to-ne ne-to-ne";#DCN����ʱNE3��������Ԫ�˿ڽ�ɫ�б�
		set typelist4 "ne-to-ne ne-to-ne";#DCN����ʱNE4��������Ԫ�˿ڽ�ɫ�б�
		gwd::GWpublic_addDCN $telnet1 $matchType1 $Gpn_type1 $fileId "gat" "4094" "253" $portlist1 $typelist1
		AddportAndIptovlan $telnet1 $matchType1 $Gpn_type1 $fileId "4094" "port" $GPNTestEth1 "untagged" $ip21 24
		
		gwd::GWpublic_addDCN $telnet2 $matchType2 $Gpn_type2 $fileId "ne" "4094" "253" $portlist2 $typelist2
		AddportAndIptovlan $telnet2 $matchType2 $Gpn_type2 $fileId "4094" "" "" "" $ip22 24
		
		gwd::GWpublic_addDCN $telnet3 $matchType3 $Gpn_type3 $fileId "ne" "4094" "253" $portlist3 $typelist3
		AddportAndIptovlan $telnet3 $matchType3 $Gpn_type3 $fileId "4094" "" "" "" $ip23 24
		
		gwd::GWpublic_addDCN $telnet4 $matchType4 $Gpn_type4 $fileId "ne" "4094" "253" $portlist4 $typelist4
		AddportAndIptovlan $telnet4 $matchType4 $Gpn_type4 $fileId "4094" "" "" "" $ip24 24
		after 20000
		incr capId
		if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "����DCN��"]} {
			set flag1_case5 1
		}
		puts $fileId ""
		if {$flag1_case5 == 1} {
			set flagCase5 1
			gwd::GWpublic_print "NOK" "FB9�����ۣ�����DCN�����ELANҵ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "FB9�����ۣ�����DCN�����ELANҵ��" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����DCN�����ELANҵ��  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
		puts $fileId "======================================================================================\n"
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����DCN�󣬲���DCN����  ���Կ�ʼ=====\n"
		gwd::GWpublic_cfgPing $telnet1 $matchType1 $Gpn_type1 $fileId $ip22 packageLoss1
		gwd::GWpublic_cfgPing $telnet2 $matchType2 $Gpn_type2 $fileId $ip21 packageLoss2
		if {$packageLoss1>20} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1) ping NE2($gpnIp2)�豸������Ϊ$packageLoss1��������������20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1) ping NE2($gpnIp2)�豸������Ϊ$packageLoss1��С����������20%" $fileId	
		}
		if {$packageLoss2>20} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "NE2($gpnIp2) ping NE1($gpnIp1)������Ϊ$packageLoss2��������������20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($gpnIp2) ping NE1($gpnIp1)������Ϊ$packageLoss2��С����������20%" $fileId	
		}
		gwd::GWpublic_cfgPing $telnet1 $matchType1 $Gpn_type1 $fileId $ip23 packageLoss1
		gwd::GWpublic_cfgPing $telnet3 $matchType3 $Gpn_type3 $fileId $ip21 packageLoss2
		if {$packageLoss1>20} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1) ping NE3($gpnIp3)�豸������Ϊ$packageLoss1��������������20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1) ping NE3($gpnIp3)�豸������Ϊ$packageLoss1��С����������20%" $fileId	
		}
		if {$packageLoss2>20} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "NE3($gpnIp3) ping NE1($gpnIp1)������Ϊ$packageLoss2��������������20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($gpnIp3) ping NE1($gpnIp1)������Ϊ$packageLoss2��С����������20%" $fileId	
		}
		gwd::GWpublic_cfgPing $telnet1 $matchType1 $Gpn_type1 $fileId $ip24 packageLoss1
		gwd::GWpublic_cfgPing $telnet4 $matchType4 $Gpn_type4 $fileId $ip21 packageLoss2
		if {$packageLoss1>20} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1) ping NE4($gpnIp4)�豸������Ϊ$packageLoss1��������������20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1) ping NE4($gpnIp4)�豸������Ϊ$packageLoss1��С����������20%" $fileId	
		}
		if {$packageLoss2>20} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "NE4($gpnIp4) ping NE1($gpnIp1)������Ϊ$packageLoss2��������������20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($gpnIp4) ping NE1($gpnIp1)������Ϊ$packageLoss2��С����������20%" $fileId	
		}
		#����ping device����ȡPingReport
		set hEmulatedDevice1 [gwd::Create_PingDevice $hPtnProject $hGPNPort1 "192.10.1.5" "192.10.1.254" "00:00:00:00:11:01"]
		set hPingResult1 [stc::get $hGPNPort1 -children-PingReport]
		stc::perform PingStartCommand -DeviceList $hEmulatedDevice1 -FrameCount 10 -PingIpv4DstAddr $ip22 
		after 20000 
		set sucPingCnt1 0
		set sucPingCnt1 [stc::get $hPingResult1 -SuccessfulPingCount]
		puts "ping $ip22  $sucPingCnt1"
		puts "sucPingCnt1: $sucPingCnt1"
		if {$sucPingCnt1 < 8} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "�����豸NE1($gpnIp1)�˿�$GPNTestEth1\���ӵ�TCģ��PC ping ��Ԫ�豸NE2($gpnIp2)�豸����ping10����pingͨ$sucPingCnt1\����" $fileId
		} else {
			gwd::GWpublic_print "OK" "�����豸NE1($gpnIp1)�˿�$GPNTestEth1\���ӵ�TCģ��PC ping ��Ԫ�豸NE2($gpnIp2)�豸����ping10����pingͨ$sucPingCnt1\����" $fileId
		}
		stc::perform PingStartCommand -DeviceList $hEmulatedDevice1 -FrameCount 10 -PingIpv4DstAddr $ip23 
		after 60000 
		set sucPingCnt1 0
		set sucPingCnt1 [stc::get $hPingResult1 -SuccessfulPingCount]
		puts "ping $ip22  $sucPingCnt1"
		puts "sucPingCnt1: $sucPingCnt1"
		if {$sucPingCnt1 < 8} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "�����豸NE1($gpnIp1)�˿�$GPNTestEth1\���ӵ�TCģ��PC ping ��Ԫ�豸NE3($gpnIp3)�豸����ping10����pingͨ$sucPingCnt1\����" $fileId
		} else {
			gwd::GWpublic_print "OK" "�����豸NE1($gpnIp1)�˿�$GPNTestEth1\���ӵ�TCģ��PC ping ��Ԫ�豸NE3($gpnIp3)�豸����ping10����pingͨ$sucPingCnt1\����" $fileId
		}
		stc::perform PingStartCommand -DeviceList $hEmulatedDevice1 -FrameCount 10 -PingIpv4DstAddr $ip24 
		after 20000 
		set sucPingCnt1 0
		set sucPingCnt1 [stc::get $hPingResult1 -SuccessfulPingCount]
		puts "ping $ip22  $sucPingCnt1"
		puts "sucPingCnt1: $sucPingCnt1"
		if {$sucPingCnt1 < 8} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "�����豸NE1($gpnIp1)�˿�$GPNTestEth1\���ӵ�TCģ��PC ping ��Ԫ�豸NE4($gpnIp4)�豸����ping10����pingͨ$sucPingCnt1\����" $fileId
		} else {
			gwd::GWpublic_print "OK" "�����豸NE1($gpnIp1)�˿�$GPNTestEth1\���ӵ�TCģ��PC ping ��Ԫ�豸NE4($gpnIp4)�豸����ping10����pingͨ$sucPingCnt1\����" $fileId
		}
		puts $fileId ""
		if {$flag2_case5 == 1} {
			set flagCase5 1
			gwd::GWpublic_print "NOK" "FC1�����ۣ�����DCN�����DCNҵ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "FC1�����ۣ�����DCN�����DCNҵ��" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����DCN�󣬲���DCN����  ���Խ���=====\n"
		incr tcId
		gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
		gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp
		puts $fileId "======================================================================================\n"
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ��DCN�����ELANҵ��  ���Խ���=====\n"
		foreach dcnPort $portlist1 dcnType $typelist1 {
			gwd::GWpublic_delDCN $telnet1 $matchType1 $Gpn_type1 $fileId $dcnType $dcnPort
		}
		gwd::GWpublic_delDCN $telnet2 $matchType2 $Gpn_type2 $fileId "ne" $portlist2
		gwd::GWpublic_delDCN $telnet3 $matchType3 $Gpn_type3 $fileId "ne" $portlist3
		gwd::GWpublic_delDCN $telnet4 $matchType4 $Gpn_type4 $fileId "ne" $portlist4
		after 60000
		incr capId
		if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "ɾ��DCN��"]} {
			set flag3_case5 1
		}
		puts $fileId ""
		if {$flag3_case5 == 1} {
			set flagCase5 1
			gwd::GWpublic_print "NOK" "FC2�����ۣ�ɾ��DCN�����ELANҵ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "FC2�����ۣ�ɾ��DCN�����ELANҵ��" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ��DCN�����ELANҵ��  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
		puts $fileId "======================================================================================\n"
	} else {
		puts $fileId "\nDCN�Ƕ��㹦�ܣ����㲻��Ҫ����\n"
	}
	if {$flagCase5 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 5���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 5���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 5 ELAN��DCNģ�黥�������Խ���\n"
	#����DCN���������⣬��Ҫ��NE1��UNI��shutdownȻ��undoshutdown��ҵ����ָܻ����˴�Ϊ�˹�ܴ������ֹ���������Ӱ������������
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "undo shutdown"
	 puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 6 ELAN��CES����������\n"
        ##��CESҵ�񻥲��� 
        #   <22>��֮ǰ������E-LANҵ����LSP����ֻ������PW����Ӧ��CESҵ��
        #   Ԥ�ڽ����CESҵ�����óɹ���ϵͳ���쳣
        #            CESҵ���֮ǰ��E-LANҵ������ת��
        #   <24>�˴�֮���޸��� ��CESҵ���E-LANҵ���õ�LSP�������٣�ϵͳ���쳣��CESҵ���E-LANҵ�������ת��
	puts $fileId "ELAN��CESģ�黥�������ܲ����ƣ���������"
	set flagCase6 1
	if {$flagCase6 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 6���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 6���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 6 ELAN��CES���������Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 7 ELAN��ELINE��ETREEҵ�񻥲���\n"
        ##��ELINE��ETREEҵ�񻥲���
        #   <1>4̨�豸ԭ��E-LANҵ��Ļ����ϣ������µ�ҵ��ELINE/ETREE
        #   <2>����NE1��NE2��NE4�ϴ���ETREEҵ��NE1Ϊ����豸��NE3��NE4֮�䴴��ELINEҵ��
        #   Ԥ�ڽ��:�µ�ҵ��ELAN/ETREEҵ��ɹ�������ϵͳ���쳣����֮ǰ��ҵ����Ӱ��
        #            ÿ��ҵ������ת�����˴�֮���޸��ţ�ϵͳ����������
	set flag1_case7 0
	set flag2_case7 0
	set flag3_case7 0
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList1 \
		-activate "true"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�½�ELINEҵ�񲢲��Ե�ELINEҵ���PW ID��ELANҵ���VPLS ID�г�ͻʱ�Ƿ��ܴ����ɹ�  ���Կ�ʼ=====\n"
	##NE3-NE4֮�䴴��ELINEҵ��
	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls4" 4 "elan" "flood" "false" "false" "false" "true" "2000" "" ""
	if {![gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw3400" "l2transport" "4" "" $address634 "101" "101" "4" "nochange" "" 1 0 "0x8100" "0x8100" ""]} {
		gwd::GWpublic_print "OK" "����ר��VCID��ELANҵ���VPLSID��ͬ�����óɹ�����ʾ" $fileId
		gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw3400"
	} else {
		set flag1_case7 1
		gwd::GWpublic_print "NOK" "����ר��VCID��ELANҵ���VPLSID��ͬ������ʧ������ʾ" $fileId
	}
	gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls4"
	lappend flag1_case7 [gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw340" "l2transport" "34" "" $address634 "101" "101" "4" "nochange" "" 1 0 "0x8100" "0x8100" ""]
	lappend flag1_case7 [PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "500" $GPNTestEth3]
	lappend flag1_case7 [gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac500" "" $GPNTestEth3 500 0 "nochange" 1 0 0 "0x8100"]
	lappend flag1_case7 [gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac500" "pw340" "eline"]
	lappend flag1_case7 [gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw430" "l2transport" "43" "" $address643 "101" "101" "3" "nochange" "" 1 0 "0x8100" "0x8100" ""]
	lappend flag1_case7 [PTN_UNI_AddInter $telnet4 $matchType4 $Gpn_type4 $fileId $Worklevel "500" $GPNTestEth4]
	lappend flag1_case7 [gwd::GWpublic_CfgAc $telnet4 $matchType4 $Gpn_type4 $fileId "ac500" "" $GPNTestEth4 500 0 "nochange" 1 0 0 "0x8100"]
	lappend flag1_case7 [gwd::GWpublic_CfgAcBind $telnet4 $matchType4 $Gpn_type4 $fileId "ac500" "pw430" "eline"]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag1_case7]} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FC3�����ۣ�ELAN VPLS��ID��ר��PW��ID��ͻ���Լ��½�ELINEҵ������ò���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3�����ۣ�ELAN VPLS��ID��ר��PW��ID��ͻ���Լ��½�ELINEҵ������ò���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�½�ELINEҵ�񲢲��Ե�ELINEҵ���PW ID��ELANҵ���VPLS ID�г�ͻʱ�Ƿ��ܴ����ɹ�  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�½�ETREEҵ�񲢲��Ե�ETREEҵ���VPLS ID��ELINEҵ���PW ID�г�ͻʱ�Ƿ��ܴ����ɹ�  ���Կ�ʼ=====\n"
	if {![gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls444" "43" "etree" "flood" "false" "false" "false" "true" "3000" "" ""]} {
		gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls444"
		gwd::GWpublic_print "OK" "����ETREEҵ���VPLSID��ר��PWID��ͬ�����óɹ�����ʾ" $fileId
	} else {
		set flag2_case7 1
		gwd::GWpublic_print "NOK" "����ETREEҵ���VPLSID��ר��PWID��ͬ������ʧ������ʾ" $fileId
	}
	if {![gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls44" "4" "etree" "flood" "false" "false" "false" "true" "3000" "" ""]} {
		set flag2_case7 1
		gwd::GWpublic_print "NOK" "����ETREEҵ���VPLSID��ELANҵ���VPLSID��ͬ�����óɹ�����ʾ" $fileId
		gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls44"
	} else {
		gwd::GWpublic_print "OK" "����ETREEҵ���VPLSID��ELANҵ���VPLSID��ͬ������ʧ������ʾ" $fileId
	}
	
	lappend flag2_case7 [gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls44" "44" "etree" "flood" "false" "false" "false" "true" "3000" "" ""]
	if {![gwd::GWStaPw_AddVplsPwInfo $telnet4 $matchType4 $Gpn_type4 $fileId "pw014" "vpls4" $address641 "801" "701" "root" "nochange" "1" "0" "0x8100" "0x9100" "1" "44"]} {
		gwd::GWpublic_print "OK" "����ר��ҵ���VCID������VPLS���е�vpls id��ͬ�����óɹ�����ʾ" $fileId
		gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw014"
	} else {
		set flag2_case7 1
		gwd::GWpublic_print "NOK" "����ר��ҵ���VCID������VPLS���е�vpls id��ͬ������ʧ������ʾ" $fileId
	}
	if {![gwd::GWStaPw_AddVplsPwInfo $telnet4 $matchType4 $Gpn_type4 $fileId "pw014" "vpls44" $address641 "801" "701" "root" "nochange" "1" "0" "0x8100" "0x9100" "1" "44"]} {
		gwd::GWpublic_print "OK" "����ר��ҵ���VCID���Լ�VPLS���е�vpls id��ͬ�����óɹ�����ʾ" $fileId
	} else {
		set flag2_case7 1
		gwd::GWpublic_print "NOK" "����ר��ҵ���VCID���Լ�VPLS���е�vpls id��ͬ������ʧ������ʾ" $fileId
	}
	
	lappend flag2_case7 [PTN_UNI_AddInter $telnet4 $matchType4 $Gpn_type4 $fileId $Worklevel "104" $GPNTestEth4]
	lappend flag2_case7 [gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac104" "vpls44" "ethernet" $GPNTestEth4 "104" "0" "leaf" "add" "104" "0" "0" "0x8100" "evc3"]
	lappend flag2_case7 [gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11" "11" "etree" "flood" "false" "false" "false" "true" "3000" "" ""]
	lappend flag2_case7 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw014" "vpls" "vpls11" "peer" $address614 "701" "801" "" "delete" "none" "100" "0" "0x8100" "0x8100" "4"]
	lappend flag2_case7 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw012" "vpls" "vpls11" "peer" $address612 "1001" "2001" "" "delete" "none" "100" "0" "0x8100" "0x8100" "2"]
	lappend flag2_case7 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "100" $GPNTestEth5]
	lappend flag2_case7 [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac100" "vpls11" "ethernet" $GPNTestEth5 "100" "0" "none" "delete" "100" "0" "0" "0x8100" "evc3"]
	lappend flag2_case7 [gwd::GWVpls_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls22" "22" "etree" "flood" "false" "false" "false" "true" "3000" "" ""]
	lappend flag2_case7 [gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw012" "vpls" "vpls22" "peer" $address621 "2001" "1001" "" "nochange" "root" "1" "0" "0x8100" "0x9100" "1"]
	lappend flag2_case7 [PTN_UNI_AddInter $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel "102" $GPNTestEth2]
	lappend flag2_case7 [gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac102" "vpls22" "ethernet" $GPNTestEth2 "102" "0" "leaf" "add" "102" "0" "0" "0x8100" "evc3"]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag2_case7]} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FC4�����ۣ�ETREE VPLS��ID��ר��PW��ID��ͻ���Լ��½�ETREEҵ������ò���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4�����ۣ�ETREE VPLS��ID��ר��PW��ID��ͻ���Լ��½�ETREEҵ������ò���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�½�ETREEҵ�񲢲��Ե�ETREEҵ���VPLS ID��ELINEҵ���PW ID�г�ͻʱ�Ƿ��ܴ����ɹ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====������֤ELAN��ELINE��ETREEҵ��  ���Կ�ʼ=====\n"
	incr capId
	if {[Test_elan_etree_eline $fileId "GPN_PTN_008_$capId"]} {
		set flag3_case7 1
	}
	puts $fileId ""
	if {$flag3_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FC5�����ۣ�������֤ELAN��ELINE��ETREEҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5�����ۣ�������֤ELAN��ELINE��ETREEҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====������֤ELAN��ELINE��ETREEҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp
	
	puts $fileId "======================================================================================\n"
	if {$flagCase7 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 7���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 7���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 7 ELAN��ELINE��ETREEҵ�񻥲������Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 8 ELAN�� ��·���ģ�黥����\n"
	##�뻷·��⻥����
	#   <3>�򿪻�·��⣬uni���¹�Զ�ˣ�ҵ���Զ�˽���ֶ�
	#   <4>��Զ�����컷·
	#   Ԥ�ڽ��:�澯�����ϱ�����ҵ����Ӱ��
	#           ��7600�����忨�����컷·���澯�����ϱ���ҵ����Ӱ��
	#   <5>��������ELANҵ��ͬһ�豸������UNI�����컷·
	#   Ԥ�ڽ��:�澯�����ϱ�����������̨�豸ҵ��û��Ӱ��
	set flag1_case8 0
	set flag2_case8 0
	set flag3_case8 0
        ####"=====ɾ��NE3-NE4֮�䴴��ELINEҵ��====="
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac500"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac500"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw340"
        gwd::GWAc_DelActPw $telnet4 $matchType4 $Gpn_type4 $fileId "ac500"
        gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac500"
        gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw430"
        #### "=====ɾ��NE1-NE2-NE4֮�䴴��ETREEҵ��====="
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac100"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw012"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw014"
        gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11"
        gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac102"
        gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw012"
        gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls22"
        gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac104"
        gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw014"
        gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls44"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����ELAN�뻷·���ģ�黥����ǰ������֤ELANҵ��  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList1 \
		-activate "false"
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "����ELAN�뻷·���ģ�黥����ǰ��"]} {
		set flag1_case8 1
	}
	puts $fileId ""
	if {$flag1_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FC6�����ۣ�����ELAN�뻷·���ģ�黥����ǰ������֤ELANҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6�����ۣ�����ELAN�뻷·���ģ�黥����ǰ������֤ELANҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����ELAN�뻷·���ģ�黥����ǰ������֤ELANҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����Զ�˻�·����黷·�Ƿ��������ϱ���ҵ���Ƿ�����  ���Կ�ʼ=====\n"
	####=========�뻷·��⻥����==========#############
	gwd::GWpublic_addLoopStatus $telnet1 $matchType1 $Gpn_type1 $fileId "enable"
	if {[string match "L2" $Worklevel]}  {
		gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort19 "disable"
	}
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort19 "undo shutdown"
	after 120000
        regexp {(\d+)/\d+} $GPNPort19 match loopSlot
	gwd::GWmanage_GetSlotInfo $telnet1 $matchType1 $Gpn_type1 $fileId $loopSlot loopSlotInfo
	set loopSlotType [dict get $loopSlotInfo $loopSlot InsertType]
	if {[string match "L2" $Worklevel] || ![regexp -nocase {(8fe|8fx)} $loopSlotType]} {
		###����NE1
		PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "100" $GPNPort19
		gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls10" "10" "elan" "flood" "false" "false" "false" "true" "3000" "" ""
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw013" "vpls" "vpls10" "peer" $address613 "502" "502" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac10" "vpls10" "ethernet" $GPNPort19 "100" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc3"
	}

	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream1 $hGPNPort3Stream4" \
		-activate "true"
	#Զ�˻�·��黷·�Ƿ��������ϱ���ҵ���Ƿ�����
	gwd::GWpublic_getCurAlarm $telnet1 $matchType1 $Gpn_type1 $fileId alarmInfo
	gwd::GWpublic_getLoopDetectInfo $telnet1 $matchType1 $Gpn_type1 $fileId loopInfo
	set alarmFlag 0
	foreach tmp $alarmInfo {
		if {[regexp "if-eth$GPNPort19 port loop alarm" $tmp]} {
			set alarmFlag 1
			break
		}	
	}
	if {$alarmFlag == 0} {
		gwd::GWpublic_print "NOK" "����Զ�˻�·��show current alarm��û�л�·�澯��Ϣ" $fileId
		set flag2_case8 1
	} else {
		gwd::GWpublic_print "OK" "����Զ�˻�·��show current alarm���л�·�澯��Ϣ" $fileId
	}
	set alarmFlag 0
	foreach tmp $loopInfo {
		if {[string match "L2" $Worklevel] || ![regexp -nocase {(8fe|8fx)} $loopSlotType]} {
			if {[regexp "looped with : .*eth-port $GPNPort19 in vlan 100" $tmp]} {
				set alarmFlag 1
				break
			}
		} else {
			if {[regexp "looped with : .*eth-port $GPNPort19 in vlan 1" $tmp]} {
				set alarmFlag 1
				break
			}
		}	
	}
	if {$alarmFlag == 0} {
		gwd::GWpublic_print "NOK" "����Զ�˻�·��show loop-detection status��û�л�·�澯��Ϣ" $fileId
		set flag2_case8 1
	} else {
		gwd::GWpublic_print "OK" "����Զ�˻�·��show loop-detection status���л�·�澯��Ϣ" $fileId
	}
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "Զ�˻�·�����ELANҵ��"]} {
		set flag2_case8 1
	}
	puts $fileId ""
	if {$flag2_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FC7�����ۣ�����Զ�˻�·����黷·�ϱ�������ELANҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7�����ۣ�����Զ�˻�·����黷·�ϱ�������ELANҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����Զ�˻�·����黷·�Ƿ��������ϱ���ҵ���Ƿ�����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����ֶ˻�·����黷·�Ƿ��������ϱ���ҵ���Ƿ�����  ���Կ�ʼ=====\n"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort19 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort23 "undo shutdown"
	after 120000
	gwd::GWpublic_getCurAlarm $telnet1 $matchType1 $Gpn_type1 $fileId alarmInfo
	gwd::GWpublic_getLoopDetectInfo $telnet1 $matchType1 $Gpn_type1 $fileId loopInfo
	set alarmFlag 0
	foreach tmp $alarmInfo {
		if {[regexp "if-eth$GPNPort23 port loop alarm" $tmp] || [regexp "if-eth$GPNPort24 port loop alarm" $tmp]} {
			set alarmFlag 1
			break
		}	
	}
	if {$alarmFlag == 0} {
		gwd::GWpublic_print "NOK" "����ֶ˻�·��show current alarm��û�л�·�澯��Ϣ" $fileId
		set flag3_case8 1
	} else {
		gwd::GWpublic_print "OK" "����ֶ˻�·��show current alarm���л�·�澯��Ϣ" $fileId
	}
	set alarmFlag 0
	foreach tmp $loopInfo {
		if {[regexp "eth-port \[$GPNPort23|$GPNPort24\]+ looped with.*eth-port \[$GPNPort23|$GPNPort24\]+ in vlan 1" $tmp]} {
			set alarmFlag 1
			break
		}	
	}
	if {$alarmFlag == 0} {
		gwd::GWpublic_print "NOK" "����ֶ˻�·��show loop-detection status��û�л�·�澯��Ϣ" $fileId
		set flag3_case8 1
	} else {
		gwd::GWpublic_print "OK" "����ֶ˻�·��show loop-detection status���л�·�澯��Ϣ" $fileId
	}
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "�ֶ˻�·�����ELANҵ��"]} {
		set flag3_case8 1
	}
	puts $fileId ""
	if {$flag3_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FC8�����ۣ�����ֶ˻�·����黷·�ϱ�������ELANҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8�����ۣ�����ֶ˻�·����黷·�ϱ�������ELANҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����ֶ˻�·����黷·�Ƿ��������ϱ���ҵ���Ƿ�����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase8 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 8���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 8���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 8 ELAN�� ��·���ģ�黥�������Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===�ָ���ʼ������...\n"
	lappend flagDel [gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort23 "shutdown"]
        lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"]
	if {[string match "L2" $Worklevel] || ![regexp -nocase {(8fe|8fx)} $loopSlotType]} {
		lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw013"]
		lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac10"]
		lappend flagDel [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls10"]
		lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort19.100 $matchType1 $Gpn_type1 $telnet1]
	}
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"]
        lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth5.800 $matchType1 $Gpn_type1 $telnet1]
	if {[string match -nocase "L3" $Worklevel] && [string match -nocase "IPRAN" $SoftVer]} {
		lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth5.100 $matchType1 $Gpn_type1 $telnet1]
	}
	
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort5.4 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort12.7 $matchType1 $Gpn_type1 $telnet1]
	
	lappend flagDel [gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls2"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"]
	lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort7.5 $ip632 "500" "600" "0" 23 "normal"]
	lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort6.4 $ip612 "600" "500" "0" 21 "normal"]
        lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth2.800 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth2.102 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort6.4 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort7.5 $matchType2 $Gpn_type2 $telnet2]
	
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw34"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3"]
	
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34"]
	lappend flagDel [gwd::GWpublic_delLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $GPNPort8.5 $ip623 "800" "700" "0" 32 "normal"]
	lappend flagDel [gwd::GWpublic_delLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $GPNPort9.6 $ip643 "700" "800" "0" 34 "normal"]
        lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.800 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.500 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort8.5 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort9.6 $matchType3 $Gpn_type3 $telnet3]
	
	lappend flagDel [gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls4"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43"]
        lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth4.800 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth4.500 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth4.104 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort10.6 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort11.7 $matchType4 $Gpn_type4 $telnet4]

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
        
	if {[string match "L2" $Worklevel]}  {
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "none"]
		if {[regexp -nocase {(8fe|8fx)} $loopSlotType]} {
			lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort19 "disable"]
		} else {
			lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort19 "none"]
		}
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort7 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort9 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort10 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort11 "none"]
	}

	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_008"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_008"
        chan seek $fileId 0
        puts $fileId "\n**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "GPN_PTN_008����Ŀ�ģ�ELANҵ��������ģ��Ļ�����\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1 == 1 || $flagCase2 == 1 || $flagCase3 == 1 || $flagCase4 == 1 || $flagCase5 == 1 || $flagCase6 == 1\
		|| $flagCase7 == 1 || $flagCase8 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_008���Խ��" $fileId
	puts $fileId ""
        gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase6 == 0) ? "OK" : "NOK"}] "Test Case 6���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase7 == 0) ? "OK" : "NOK"}] "Test Case 7���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase8 == 0) ? "OK" : "NOK"}] "Test Case 8���Խ��" $fileId
        puts $fileId ""
        puts $fileId ""
        gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����ELANҵ�����mac��ַ��ѧϰ" $fileId
        gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�ֹͣ�����������ȴ��ϻ�ʱ���mac[expr {($flag2_case1 == 1) ? "û��" : ""}]�ϻ�" $fileId
        gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�mac��ַ�ϻ������·���������mac��ַѧϰ�쳣" $fileId
        gwd::GWpublic_print "== FA4 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��trunk���Աͬ�忨������ELAN��trunk������" $fileId
        gwd::GWpublic_print "== FA5 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪlag1:1��trunk���Աͬ�忨������ELAN��trunk������" $fileId
        gwd::GWpublic_print "== FA6 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪlag1:1��trunk���Ա��忨������ELAN��trunk������" $fileId
        gwd::GWpublic_print "== FA7 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��trunk���Ա��忨������ELAN��trunk������" $fileId
        gwd::GWpublic_print "== FA8 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪstatic��trunk���Աͬ�忨������ELAN��trunk������" $fileId
        gwd::GWpublic_print "== FA9 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪstatic��trunk���Ա��忨������ELAN��trunk������" $fileId
        gwd::GWpublic_print "== FB1 == [expr {($flag7_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�trunkģʽΪsharing��UNI��Ϊtrunk�ڲ���E-LINEҵ��" $fileId
        gwd::GWpublic_print "== FB2 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�����LSP��OAM�����ELANҵ��" $fileId
        gwd::GWpublic_print "== FB3 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�����PW��OAM�����ELANҵ��" $fileId
        gwd::GWpublic_print "== FB4 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ����öβ��OAM�����ELANҵ��" $fileId
        gwd::GWpublic_print "== FB5 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�����LSP/PW/�β�CCʹ�ܺ����ELANҵ��" $fileId
        gwd::GWpublic_print "== FB6 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�����LSP/PW/�β�CCȥʹ�ܺ����ELANҵ��" $fileId
        gwd::GWpublic_print "== FB7 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�����LSP/PW/�β�CCʱ���������ELANҵ��" $fileId
        gwd::GWpublic_print "== FB8 == [expr {($flag7_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�����LSP/PW/�β�LB�����ELANҵ��" $fileId
        gwd::GWpublic_print "== FB9 == [expr {($flag1_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�����DCN�����ELANҵ��" $fileId
        gwd::GWpublic_print "== FC1 == [expr {($flag2_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�����DCN�����DCNҵ��" $fileId
        gwd::GWpublic_print "== FC2 == [expr {($flag3_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�ɾ��DCN�����ELANҵ��" $fileId
        gwd::GWpublic_print "== FC3 == [expr {([regexp {[^0\s]} $flag1_case7]) ? "NOK" : "OK"}]" "�����ۣ�ELAN VPLS��ID��ר��PW��ID��ͻ���Լ��½�ELINEҵ������ò���" $fileId
        gwd::GWpublic_print "== FC4 == [expr {([regexp {[^0\s]} $flag2_case7]) ? "NOK" : "OK"}]" "�����ۣ�ETREE VPLS��ID��ר��PW��ID��ͻ���Լ��½�ETREEҵ������ò���" $fileId
        gwd::GWpublic_print "== FC5 == [expr {($flag3_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�������֤ELAN��ELINE��ETREEҵ��" $fileId
        gwd::GWpublic_print "== FC6 == [expr {($flag1_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�����ELAN�뻷·���ģ�黥����ǰ������֤ELANҵ��" $fileId
        gwd::GWpublic_print "== FC7 == [expr {($flag2_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�����Զ�˻�·����黷·�ϱ�������ELANҵ��" $fileId
	gwd::GWpublic_print "== FC8 == [expr {($flag3_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�����ֶ˻�·����黷·�ϱ�������ELANҵ��" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
        puts $fileId ""
        puts $fileId "**************************************************************************************"
        puts $fileId ""
        puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_008"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_008_REPORT.txt" "report\\NOK_GPN_PTN_008_REPORT.txt"
	file rename "log\\GPN_PTN_008_LOG.txt" "log\\NOK_GPN_PTN_008_LOG.txt"
} else {
	file rename "report\\GPN_PTN_008_REPORT.txt" "report\\OK_GPN_PTN_008_REPORT.txt"
	file rename "log\\GPN_PTN_008_LOG.txt" "log\\OK_GPN_PTN_008_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}

