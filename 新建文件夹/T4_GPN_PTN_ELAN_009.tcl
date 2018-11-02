#!/bin/sh
# T4_GPN_PTN_ELAN_009.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#����Ŀ�ģ�1.E-LAN���ȶ���     2.E-LANҵ����������׳�Բ���
#1-���Ĺ���
#2-�ڴ�й¶���� 
#1-vpls��mac��ַ��������               
#2-1��VSI���ض��PW����
#3-һ��VSI���ض���AC                  
#4-1ϵͳ�г��ض���VSI 
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
#   <1>4̨�豸��NE1--NE2--NE3-NE4�����������ˣ��E-LANҵ��
#   <2>��NE1�豸����ARP�������ģ�����100Mbps��ҵ������Ӧ�ò���Ӱ�죬����ͨ������
#   <3>��NE1�豸��������100Mbpsҵ���ģ�ϵͳCPU����������������ͨ������
#   <4>����100M�㲥���ģ�ϵͳCPU����������������ͨ������
#   <5>���Ͳ�ͬ�����ı��ģ�ϵͳCPU����������������ͨ������
#   <6>�����������������ϵͳCPU����������������ͨ������
#2���Test Case 2���Ի���
#   <1>����1��E-LANҵ�� ������Ӧ��LSP��PW��AC����ɾ������ҵ��ϵͳ����
#   <2>�ýű��������ɾ��E-LANʵ��500�Σ�ҵ�񼰹����������ڴ�û��й©��ϵͳ���쳣
#3���Test Case 3���Ի���
#vpls��mac��ַ�������� 
#   <1>��NE1��vsi������mac��ַѧϰ����Ϊ���������ϵͳ֧������������Ϊ32000��
#   <2>��NE1��uni�ڷ���Դmac��������Ӧ�����̶�������
#   Ԥ�ڽ��:�鿴NE2��NE3��UNI��ѧϰ�ı���������NE1���͵ı�����һ��
#            �ڵײ�鿴mac��ַѧϰ������VSI�����ѧϰ����MAC��ַ��������ֵһ�£�
#1��VSI���ض��PW����  
#   <3>��̨76�������������ˣ�NE1�豸ͨ�����������ܣ�NE2��NE3��NE4�豸����������,��̨�豸��ping���ܵ�ַ
#   <4>��NE1��UNI�ڷ���������ҵ����������ͬ�������ġ����ֱ��ġ�����arp���ģ���NE2���������޶�����ϵͳ���쳣����¼��ϵͳ1��VSI�Ͽɳ��ض��ٸ�PW?
#   Ԥ�ڽ��:NE1��NE2�������ã��鿴������LSP��PW��AC��Ŀ������������ʾ����ȷ�������ļ��ɳɹ�������ϵͳ���쳣���鿴�����������ļ���ȷ��������
#   <5>ʹ��ÿ��ҵ��LSP��PW����ͳ�ƣ�ϵͳ���쳣������ͳ�ƹ�����Ч��ͳ��ֵ��ȷ
#   <6>shutdown��undo shutdown NE1�豸��NNI/UNI�˿ڹ���50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸��ţ�DCN����
#   <7>����NE1�豸��SW/NMS����50�Σ���/Ӳ��������ҵ��������ָ���ÿ��ҵ��˴��޸��ţ�DCN�������鿴��ǩת��������ȷ
#   <8>��λNE1�豸��NNI/UNI���ڰ忨50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸��ţ�DCN����
#   <9>����NE1��NE2�豸���ã���������NE1��NE2�豸����λ��Ӳ��λ��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ������ұ˴��޸��ţ���ǩת��������ȷ��DCN����
#   <10>���NE1��NE2�豸���ã�����NE1��NE2�豸�����豸������鿴������Ϣ�գ������Ե����������ļ����룬�����豸��
#       ���豸������鿴������Ϣ�޶�ʧ����ȷ��������֤ҵ�������ת����DCN����
#   <11>���NE1��NE2�豸���ã�����NE1��NE2�豸
#1��VSI���ض���AC
#   <12>��̨76�������������ˣ�NE1�豸ͨ�����������ܣ�NE2��NE3��NE4�豸����������,��̨�豸��ping���ܵ�ַ
#   <13>��NE1��NE2֮�佨��һ��EPLANҵ��һ��vpls��һ��LSP��һ��PW
#   <14>NE1��NE2�Ķ��UNI�ڼ��벻ͬvlan���������ac
#   <15>��NE1��һ��UNI�ڷ�����Ӧvlanҵ��������NE2���������޶�����NE1�������˿�Ҳ���յ�ϵͳ���쳣����¼��ϵͳ1��VSI�Ͽɳ��ض��ٸ�AC
#   Ԥ�ڽ��:NE1��NE2�������ã����������ܲ鿴������LSP��PW��AC��Ŀ������������ʾ����ȷ�������ļ��ɳɹ�������ϵͳ���쳣���鿴�����������ļ���ȷ��������
#   <16>shutdown��undo shutdownNE1�豸��NNI/UNI�˿ڹ���50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸��ţ�DCN����
#   <17>��λNE1�豸��NNI/UNI���ڰ忨50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸��ţ�DCN����
#   <18>����NE1�豸��SW/NMS����50�Σ���/Ӳ��������ҵ��������ָ���ÿ��ҵ��˴��޸��ţ�DCN�������鿴��ǩת��������ȷ
#   <19>����NE1��NE2�豸���ã���������NE1��NE2�豸����λ��Ӳ��λ��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ������ұ˴��޸��ţ���ǩת��������ȷ��DCN����
#   <20>���NE1��NE2�豸���ã�����NE1��NE2�豸
#ϵͳ���ض���VSI
#   <21>��̨76�������������˼�����ͼ1��NE1--NE2--NE3--NE4����������NE1�豸ͨ������������,NE2��NE3��NE4�豸ͨ�����������ܣ�
#       ��4̨�豸��DCN������̨�豸�˴�֮���NNI�˿�ͨ����̫���ӿ���ʽ������NNI�˿���untag��ʽ���뵽VLANIF��,��̨�豸��ping���ܵ�ַ
#   <22>����NE1��NE2��NE3��NE4֮���EVP-LANҵ��NE2��ΪPE��Ϊp�豸���û������ģʽΪ�˿�+��Ӫ��VLANģʽ
#   <23>NE1��NE2��NE3��NE4֮�������һ��lsp��һ��vpls���������PW��һ��AC
#   <24>��NE1��UNI�ڷ���������ҵ����������ͬ�������ġ����ֱ��ġ�����arp���ģ���NE2��NE3��NE4��������������ϵͳ���쳣����¼ϵͳ�пɴ������ٵ�VPLS��
#   Ԥ�ڽ��:����NE1��NE2�豸���ã��鿴������LSP��PW��AC��Ŀ������������ʾ����ȷ�������ļ��ɳɹ�������ϵͳ���쳣���鿴�����������ļ���ȷ�������룬DCN����
#   <25>shutdown��undo shutdownNE1�豸��NNI/UNI�˿ڹ���50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸��ţ�DCN����
#   <26>��λNE1�豸��NNI/UNI���ڰ忨50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸��ţ�DCN����
#   <27>����NE1�豸��SW/NMS����50�Σ���/Ӳ��������ҵ��������ָ���ÿ��ҵ��˴��޸��ţ�DCN�����鿴��ǩת��������ȷ
#   <28>����NE1��NE2��NE3�豸���ã���������NE1��NE2��NE3�豸����λ��Ӳ��λ��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ������ұ˴��޸��ţ���ǩת��������ȷ��DCN����
#   <29>���NE1��NE2�豸���ã�����NE1��NE2�豸�����豸������鿴������Ϣ�գ������Ե����������ļ����룬�����豸��
#       ���豸������鿴������Ϣ�޶�ʧ����ȷ��������֤ҵ�������ת����DCN����
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_009_LOG.txt" a]
        set stdout $fd_log
        chan configure $fd_log -blocking 0 -buffering none;#������ģʽ ����flush
        log_file log\\GPN_PTN_009_LOG.txt
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_009_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
        
        file mkdir "debug"
        set fd_debug [open debug\\GPN_PTN_009_DEBUG.txt a]
        exp_internal -f debug\\GPN_PTN_009_DEBUG.txt 0
        chan configure $fd_debug -blocking 0 -buffering none;#������ģʽ ����flush
    
	  source test\\PTN_VarSet.tcl
	  source test\\PTN_Mode_Function.tcl

        ###����������
        array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "ff:ff:ff:ff:ff:ff" -operation "1" -senderHwAddr "00:00:00:00:00:01" -senderPAddr "192.10.10.1" -targetHwAddr "00:00:00:00:00:00" -targetPAddr "192.1.1.1"}
        array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "800" -pri "000"}
        array set dataArr3 {-srcMac "00:00:00:00:00:03" -dstMac "ff:ff:ff:ff:ff:ff" -srcIp "192.85.1.3" -dstIp "192.0.0.3" -vid "800" -pri "000"}
        array set dataArr4 {-srcMac "00:00:00:00:00:04" -dstMac "00:00:00:00:00:44" -srcIp "192.85.1.4" -dstIp "192.0.0.4" -vid "800" -pri "000"}
        array set dataArr5 {-srcMac "00:00:00:00:00:05" -dstMac "00:00:00:00:00:55" -srcIp "192.85.1.5" -dstIp "192.0.0.5" -vid "800" -pri "000"}
        array set dataArr6 {-srcMac "00:00:00:00:00:06" -dstMac "00:00:00:00:00:33" -srcIp "192.85.1.6" -dstIp "192.0.0.6" -vid "800" -pri "000"}
        array set dataArr7 {-srcMac "00:00:00:00:00:22" -dstMac "00:00:00:00:00:02" -srcIp "192.85.1.7" -dstIp "192.0.0.7" -vid "800" -pri "000"}
        array set dataArr8 {-srcMac "00:00:00:00:00:33" -dstMac "00:00:00:00:00:06" -srcIp "192.85.1.8" -dstIp "192.0.0.8" -vid "800" -pri "000"}
        array set dataArr10 {-srcMac "00:00:00:00:00:55" -dstMac "00:00:00:00:00:05" -srcIp "192.85.1.10" -dstIp "192.0.0.10" -vid "800" -pri "000"}
        array set dataArr11 {-srcMac "00:00:00:00:00:11" -dstMac "00:00:00:00:11:11" -srcIp "192.85.1.11" -dstIp "192.0.0.11" -vid "500" -pri "000"}
        array set dataArr12 {-srcMac "00:00:00:00:00:12" -dstMac "00:00:00:00:12:12" -srcIp "192.85.1.12" -dstIp "192.0.0.12" -vid "500" -pri "000"}
        array set dataArr13 {-srcMac "00:00:00:00:00:13" -dstMac "00:00:00:00:13:13" -srcIp "192.85.1.13" -dstIp "192.0.0.13" -vid "500" -pri "000"}
        array set dataArr14 {-srcMac "00:00:00:00:11:11" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.14" -dstIp "192.0.0.14" -vid "500" -pri "000"}
        array set dataArr15 {-srcMac "00:00:00:00:12:12" -dstMac "00:00:00:00:00:12" -srcIp "192.85.1.15" -dstIp "192.0.0.15" -vid "500" -pri "000"}
        array set dataArr16 {-srcMac "00:00:00:00:13:13" -dstMac "00:00:00:00:00:13" -srcIp "192.85.1.16" -dstIp "192.0.0.16" -vid "500" -pri "000"}
        array set dataArr17 {-srcMac "00:00:81:00:00:10" -dstMac "00:00:00:00:10:10" -vid "500" -pri "000" -stepValue "00:00:00:00:00:01" -recycleCount "32000" -EnableStream "FALSE"}
        array set dataArr18 {-srcMac "00:00:00:00:00:18" -dstMac "00:00:00:00:00:19" -srcIp "192.85.1.18" -dstIp "192.0.1.18" -vid "10" -pri "000" -stepValue "1" -recycleCount "1100" -EnableStream "FALSE"}
        array set dataArr19 {-srcMac "00:00:00:00:00:19" -dstMac "00:00:00:00:00:18" -srcIp "192.85.1.19" -dstIp "192.0.1.19" -vid "10" -pri "000" -stepValue "1" -recycleCount "1100" -EnableStream "FALSE"}
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
       	
	set rateL 95000000;#�շ�������ȡֵ��Сֵ��Χ
	set rateR 105000000;#�շ�������ȡֵ���ֵ��Χ
	set rateL1 100000000 
	set rateR1 125000000
	
	set flagCase1 0   ;#Test case 1��־λ 
	set flagCase2 0   ;#Test case 2��־λ
	set flagCase3 0   ;#Test case 3��־λ 
	set flagCase4 0   ;#Test case 4��־λ 
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
	
	########################################################################################################
	#�������ܣ�һ��vsi����ac��������֤����
	#�������:printWord:report�д�ӡ�Ĳ���˵��
	#expStartVid2 expEndVid2 = 0ʱ��expStartVid1 expEndVid1��ֵ��expStartVid2 expEndVid2
	#�����������
	#����ֵ�� flag
	########################################################################################################
	proc Test_acCapacity {printWord expectList1 expectList2 caseId} {
		global fileId
		set flag 0
		set resultList1 ""
		set resultList2 ""
		send_log "\n time1:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		#��������С��ʹ����vlan�е��������γ���֪����------
		foreach stream $::hGPNPortStreamList4 {
			stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 0.5 -LoadUnit MEGABITS_PER_SECOND
		}
		gwd::Start_SendFlow "$::hGPNPort1Gen $::hGPNPort4Gen"  "$::hGPNPort1Ana $::hGPNPort4Ana"
		after 20000
		gwd::Stop_SendFlow "$::hGPNPort1Gen $::hGPNPort4Gen"  "$::hGPNPort1Ana $::hGPNPort4Ana"
		#------��������С��ʹ����vlan�е��������γ���֪����
		foreach stream $::hGPNPortStreamList4 {
			stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
		}
		send_log "\n time2:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		###��ʼץ��
		if {$::cap_enable} {
			gwd::Start_CapAllData ::capArr $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
			gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
		}
		gwd::Start_SendFlow "$::hGPNPort1Gen $::hGPNPort4Gen"  "$::hGPNPort1Ana $::hGPNPort4Ana"
		after 30000
		send_log "\n time3:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		###ֹͣץ��
		if {$::cap_enable} {
			gwd::Stop_CapData $::hGPNPort1Cap 1 "$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap"
			gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap"
		}
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap" $fileId
		send_log "\n time4:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		set totalPage [stc::get $::hGPNPort1RxInfo1 -TotalPageCount]
		for {set pageNum 1} {$pageNum <= $totalPage} {incr pageNum} {
			stc::config $::hGPNPort1RxInfo1 -PageNumber $pageNum  
			stc::apply
			after 4000
			set lstRxResults [stc::get $::hGPNPort1RxInfo1 -ResultHandleList]
			foreach resultRx $lstRxResults {  
				array set aResults [stc::get $resultRx]
				gwd::Clear_ResultViewStat $resultRx
				   if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)]\
					&& $aResults(-L1BitRate) != 0} {
					    lappend resultList1 $aResults(-FilteredValue_1) $aResults(-FilteredValue_2)
				    } 
			}
		}
		send_log "\n resultList1:$resultList1"
		send_log "\n time5:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		set flag_vid1 0
		dict for {key value} $expectList1 {
			if {[dict exists $resultList1 $key]} {
				if {[string match [dict get $resultList1 $key] $value]} {
					gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)vlan$key\��smacӦΪ$value\ʵΪ[dict get $resultList1 $key]" $::fd_log
				} else {
					set flag_vid1 1
					set flag 1
					gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)vlan$key\��smacӦΪ$value\ʵΪ[dict get $resultList1 $key]" $::fileId
				}
			} else {
				set flag_vid1 1
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)û���յ�vlan$key\��������" $::fileId
			}
			
		}
		if {$flag_vid1 == 0} {
			gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)����vlan�е����ݽ��ն���ȷ" $::fileId
		}
		send_log "\n time6:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		set totalPage [stc::get $::hGPNPort4RxInfo1 -TotalPageCount]
		for {set pageNum 1} {$pageNum <= $totalPage} {incr pageNum} {
			stc::config $::hGPNPort4RxInfo1 -PageNumber $pageNum  
			stc::apply
			after 4000
			set lstRxResults [stc::get $::hGPNPort4RxInfo1 -ResultHandleList]
			foreach resultRx $lstRxResults {
				if {[catch {
					array set aResults [stc::get $resultRx]
					gwd::Clear_ResultViewStat $resultRx
				} err]} {
					send_log "\n filter_err:$err"
					continue
				}
				if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)]\
					&& $aResults(-L1BitRate) != 0} {
					lappend resultList2 $aResults(-FilteredValue_1) $aResults(-FilteredValue_2)
				}
			}
		}
		send_log "\n time7:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		send_log "\n resultList2:$resultList2"
		set flag_vid2 0
		dict for {key value} $expectList2 {
			if {[dict exists $resultList2 $key]} {
				if {[string match [dict get $resultList2 $key] $value]} {
					gwd::GWpublic_print "OK" "$printWord\NE4($::gpnIp4)vlan$key\��smacӦΪ$value\ʵΪ[dict get $resultList2 $key]" $::fd_log
				} else {
					set flag_vid2 1
					set flag 1
					gwd::GWpublic_print "NOK" "$printWord\NE4($::gpnIp4)vlan$key\��smacӦΪ$value\ʵΪ[dict get $resultList2 $key]" $::fileId
				}
			} else {
				set flag_vid2 1
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($::gpnIp4)û���յ�vlan$key\��������" $::fileId
			}
			
		}
		if {$flag_vid2 == 0} {
			gwd::GWpublic_print "OK" "$printWord\NE4($::gpnIp4)����vlan�е����ݽ��ն���ȷ" $::fileId
		}
		gwd::Stop_SendFlow "$::hGPNPort1Gen $::hGPNPort4Gen"  "$::hGPNPort1Ana $::hGPNPort4Ana"
		send_log "\n time8:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
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
			\"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4

        ###������������
        gwd::STC_Create_Stream_Arp $fileId dataArr1 $hGPNPort1 hGPNPort1Stream1
        gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort1 hGPNPort1Stream2
        gwd::STC_Create_VlanStream $fileId dataArr3 $hGPNPort1 hGPNPort1Stream3
        gwd::STC_Create_VlanStream $fileId dataArr4 $hGPNPort1 hGPNPort1Stream4
        gwd::STC_Create_VlanStream $fileId dataArr5 $hGPNPort1 hGPNPort1Stream5
        gwd::STC_Create_VlanStream $fileId dataArr6 $hGPNPort1 hGPNPort1Stream6
        gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort2 hGPNPort2Stream7
        gwd::STC_Create_VlanStream $fileId dataArr8 $hGPNPort3 hGPNPort3Stream8
        gwd::STC_Create_VlanStream $fileId dataArr10 $hGPNPort4 hGPNPort4Stream10
        gwd::STC_Create_VlanStream $fileId dataArr11 $hGPNPort1 hGPNPort1Stream11
        gwd::STC_Create_VlanStream $fileId dataArr12 $hGPNPort1 hGPNPort1Stream12
        gwd::STC_Create_VlanStream $fileId dataArr13 $hGPNPort1 hGPNPort1Stream13
        gwd::STC_Create_VlanStream $fileId dataArr14 $hGPNPort2 hGPNPort2Stream14
        gwd::STC_Create_VlanStream $fileId dataArr15 $hGPNPort3 hGPNPort3Stream15
        gwd::STC_Create_VlanStream $fileId dataArr16 $hGPNPort4 hGPNPort4Stream16
        gwd::STC_Create_VlanSmacModiferStream $fileId dataArr17 $hGPNPort1 hGPNPort1Stream17
	set hGPNPort1Stream18 [stc::create "StreamBlock" \
		-under $hGPNPort1 \
		-EqualRxPortDistribution "FALSE" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:00:00:01:00:01</dstMac><srcMac>00:00:01:00:00:01</srcMac><vlans name="anon_4733"><Vlan name="Vlan"><pri>000</pri><id>10</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><checksum>14740</checksum><tosDiffserv name="anon_4736"><tos name="anon_4737"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {dev1_ac} ]
	
	set RangeModifier2 [stc::create "RangeModifier" \
		-under $hGPNPort1Stream18 \
		-Mask {4095} \
		-StepValue {1} \
		-RecycleCount "1024" \
		-Data {10} \
		-OffsetReference {eth1.vlans.Vlan.id} \
		-Name {Modifier} ]
	
	set RangeModifier3 [stc::create "RangeModifier" \
		-under $hGPNPort1Stream18 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "1024" \
		-Data {00:00:01:00:00:01} \
		-Offset "2" \
		-OffsetReference {eth1.srcMac} \
		-Name {MAC Modifier} ]
	
	set RangeModifier4 [stc::create "RangeModifier" \
		-under $hGPNPort1Stream18 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "1024" \
		-Data {00:00:00:01:00:01} \
		-Offset "2" \
		-OffsetReference {eth1.dstMac} \
		-Name {MAC Modifier} ]
	
	
	set hGPNPort4Stream19 [stc::create "StreamBlock" \
		-under $hGPNPort4 \
		-EqualRxPortDistribution "FALSE" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:00:01:00:00:01</dstMac><srcMac>00:00:00:01:00:01</srcMac><vlans name="anon_4742"><Vlan name="Vlan"><pri>000</pri><id>10</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><checksum>14740</checksum><tosDiffserv name="anon_4745"><tos name="anon_4746"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {dev3_ac} ]
	
	set RangeModifier5 [stc::create "RangeModifier" \
		-under $hGPNPort4Stream19 \
		-Mask {4095} \
		-StepValue {1} \
		-RecycleCount "1024" \
		-Data {10} \
		-OffsetReference {eth1.vlans.Vlan.id} \
		-Name {Modifier} ]
	
	set RangeModifier6 [stc::create "RangeModifier" \
		-under $hGPNPort4Stream19 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "1024" \
		-Data {00:00:00:01:00:01} \
		-Offset "2" \
		-OffsetReference {eth1.srcMac} \
		-Name {MAC Modifier} ]
	
	set RangeModifier7 [stc::create "RangeModifier" \
		-under $hGPNPort4Stream19 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "1024" \
		-Data {00:00:01:00:00:01} \
		-Offset "2" \
		-OffsetReference {eth1.dstMac} \
		-Name {MAC Modifier} ]
	
        set hGPNPortStreamList "$hGPNPort1Stream1 $hGPNPort1Stream3 $hGPNPort1Stream4 $hGPNPort1Stream5"
        set hGPNPortStreamList1 "$hGPNPort1Stream2 $hGPNPort1Stream6 $hGPNPort2Stream7 $hGPNPort3Stream8 $hGPNPort1Stream5 $hGPNPort4Stream10"
        set hGPNPortStreamList2 "$hGPNPort1Stream11 $hGPNPort1Stream12 $hGPNPort1Stream13 $hGPNPort2Stream14 $hGPNPort3Stream15 $hGPNPort4Stream16"
        set hGPNPortStreamList4 "$hGPNPort1Stream18 $hGPNPort4Stream19"
        ###��ȡ�������ͷ�����ָ��
        gwd::Get_Generator $hGPNPort1 hGPNPort1Gen
        gwd::Get_Analyzer $hGPNPort1 hGPNPort1Ana
        gwd::Get_Generator $hGPNPort2 hGPNPort2Gen
        gwd::Get_Analyzer $hGPNPort2 hGPNPort2Ana
        gwd::Get_Generator $hGPNPort3 hGPNPort3Gen
        gwd::Get_Analyzer $hGPNPort3 hGPNPort3Ana
        gwd::Get_Generator $hGPNPort4 hGPNPort4Gen
        gwd::Get_Analyzer $hGPNPort4 hGPNPort4Ana
        set hGPNPortGenList "$hGPNPort1Gen $hGPNPort2Gen $hGPNPort3Gen $hGPNPort4Gen"
        set hGPNPortAnaList "$hGPNPort1Ana $hGPNPort2Ana $hGPNPort3Ana $hGPNPort4Ana"
	stc::config $hGPNPort1Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort2Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort3Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort4Ana -FilterOnStreamId "FALSE"
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
	
        ###������������ 10%��Mbps
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList $hGPNPortStreamList1 $hGPNPortStreamList2 $hGPNPortStreamList4 $hGPNPort1Stream17" \
		-activate "false"
	
        foreach stream $hGPNPortStreamList $hGPNPortStreamList1 $hGPNPortStreamList2 $hGPNPortStreamList4 $hGPNPort1Stream17 {
        	stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        }
	stc::config $hGPNPort1Stream4 -FixedFrameLength "512"
        stc::apply 
        ###��ȡ����������ָ��
        gwd::Get_GeneratorCfgObj $hGPNPort1Gen hGPNPort1GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort2Gen hGPNPort2GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort3Gen hGPNPort3GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort4Gen hGPNPort4GenCfg
        set hGPNPortGenCfgList "$hGPNPort1GenCfg $hGPNPort2GenCfg $hGPNPort3GenCfg $hGPNPort4GenCfg"
        foreach hGenCfg $hGPNPortGenCfgList {
        	gwd::Cfg_GeneratorCfgObj $hGenCfg $GenCfg
        }
        ###���������ù�������Ĭ�Ϲ���tag
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort1Ana hGPNPort1AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort2Ana hGPNPort2AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort3Ana hGPNPort3AnaFrameCfgFil	
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
        set hGPNPortAnaFrameCfgFilList "$hGPNPort1AnaFrameCfgFil $hGPNPort2AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil"
        foreach hCfgFil $hGPNPortAnaFrameCfgFilList {
        	gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $anaFliFrameCfg1
        }
       
        if {$cap_enable} {
                ###��ȡ������capture������ص�ָ��
                gwd::Get_Capture $hGPNPort1 hGPNPort1Cap
                gwd::Get_Capture $hGPNPort2 hGPNPort2Cap
                gwd::Get_Capture $hGPNPort3 hGPNPort3Cap
                gwd::Get_Capture $hGPNPort4 hGPNPort4Cap
                gwd::Create_FilterAnalyzer $hGPNPort1Cap hGPNPort1CapFilter hGPNPort1CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort2Cap hGPNPort2CapFilter hGPNPort2CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort3Cap hGPNPort3CapFilter hGPNPort3CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort4Cap hGPNPort4CapFilter hGPNPort4CapAnalyzer
                array set capArr {capMode "REGULAR_MODE" capSource "Tx_Rx_MODE"}
                set hGPNPortCapList "$hGPNPort1Cap $hGPNPort2Cap $hGPNPort3Cap $hGPNPort4Cap"
                set hGPNPortCapAnalyzerList "$hGPNPort1CapAnalyzer $hGPNPort2CapAnalyzer $hGPNPort3CapAnalyzer $hGPNPort4CapAnalyzer"
        }
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-LAN�������ȶ��Բ��Ի������ÿ�ʼ...\n"
	set cfgFlag 0
	lappend cfgFlag [gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"]
        set portlist1 "$GPNPort5 $GPNPort12"
        set portList1 "$GPNTestEth1"
        set portList11 [concat $portlist1 $portList1]
        foreach port $portList11 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
		}
        }
	set rebootSlotlist1 [gwd::GWpulic_getWorkCardList $portlist1]
	gwd::GWpublic_print "OK" "��ȡ�豸NE1($gpnIp1)ҵ��忨��λ��$rebootSlotlist1" $fileId
        set mslot1 [gwd::GWpulic_getWorkCardList $managePort1]
	gwd::GWpublic_print "OK" "��ȡ�豸1��������ڰ忨��λ��$mslot1" $fileId

        set portlist2 "$GPNPort6 $GPNPort7"
        set portList2 "$GPNTestEth2"
        set portList22 [concat $portlist2 $portList2]
        foreach port $portList22 {
                if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
                	lappend cfgFlag [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "disable" "enable"]
                }
        }
	set portlist3 "$GPNPort8 $GPNPort9"
	set portList3 "$GPNTestEth3"
	set portList33 [concat $portlist3 $portList3]
	foreach port $portList33 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "disable" "enable"]
		}
 	}
	
	set portlist4 "$GPNPort10 $GPNPort11"
	set portList4 "$GPNTestEth4"
	set portList44 [concat $portlist4 $portList4]
	foreach port $portList44 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet4 $matchType4 $Gpn_type4 $fileId $port "disable" "enable"]
		}
	}
	set Portlist "$GPNPort5 $GPNPort12 $GPNPort6 $GPNPort7 $GPNPort8 $GPNPort9 $GPNPort10 $GPNPort11"
	set Portlist0 "$GPNTestEth1 $GPNTestEth2 $GPNTestEth3 $GPNTestEth4"
	set Iplist "$ip612 $ip614 $ip621 $ip623 $ip632 $ip634 $ip643 $ip641"
        
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-LAN�������ȶ��Բ��Ի�������ʧ�ܣ����Խ���" \
	"E-LAN�������ȶ��Բ��Ի������óɹ�����������Ĳ���" "GPN_PTN_009"
        puts $fileId ""
        puts $fileId "===E-LAN�������ȶ��Բ��Ի������ý���..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 ���Ĺ�������\n"
        #   <1>4̨�豸��NE1--NE2--NE3-NE4�����������ˣ��E-LANҵ��
        #   <2>��NE1�豸����ARP�������ģ�����100Mbps��ҵ������Ӧ�ò���Ӱ�죬����ͨ������
        #   <3>��NE1�豸��������100Mbpsҵ���ģ�ϵͳCPU����������������ͨ������
        #   <4>����100M�㲥���ģ�ϵͳCPU����������������ͨ������
        #   <5>���Ͳ�ͬ�����ı��ģ�ϵͳCPU����������������ͨ������
        #   <6>�����������������ϵͳCPU����������������ͨ������
	set flag1_case1 0
	set flag2_case1 0
	set flag3_case1 0
	set flag4_case1 0
	set flag5_case1 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)����100M��ELANҵ���ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��  ���Կ�ʼ=====\n"
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
		###����VLANIF�ӿ�
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
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface3 $ip621 "20" "20" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $interface10 $ip641 "24" "24" "normal" "4"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $address614
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $interface3 $ip621 "23" "23" "normal" "3"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $address613
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "100" "100" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "400" "400" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "500" "500" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"	
	
	####����NE2
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface4 $ip612 "20" "20" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $interface5 $ip632 "26" "26" "normal" "3"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $address623
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $interface5 $ip632 "27" "27" "normal" "4"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $address624
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface5 $ip632 "23" "25" "0" 23 "normal"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface4 $ip612 "25" "23" "0" 21 "normal"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "100" "100" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "vpls" "vpls2" "peer" $address623 "200" "200" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24" "vpls" "vpls2" "peer" $address624 "600" "600" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	#####����NE3
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $interface6 $ip623 "26" "26" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $address632
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34" $interface7 $ip643 "28" "28" "normal" "4"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34" $address634
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34"
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $interface6 $ip623 "25" "25" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $address631
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
	gwd::GWpublic_createLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $interface6 $ip623 "29" "27" "0" 32 "normal"
	gwd::GWpublic_createLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $interface7 $ip643 "27" "29" "0" 34 "normal"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "200" "200" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw34" "vpls" "vpls3" "peer" $address634 "300" "300" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "500" "500" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac800" "vpls3" "" $GPNTestEth3 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	#####����NE4
	gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $interface9 $ip614 "24" "24" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $address641
	gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"
	gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43" $interface8 $ip634 "28" "28" "normal" "3"
	gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43" $address643
	gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43"
	gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42" $interface8 $ip634 "29" "29" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42" $address642
	gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "400" "400" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43" "vpls" "vpls4" "peer" $address643 "300" "300" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42" "vpls" "vpls4" "peer" $address642 "600" "600" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac800" "vpls4" "" $GPNTestEth4 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "true"
	incr capId
	if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 0 "��NE1($gpnIp1)����100M��ELANҵ����" $anaFliFrameCfg1 "GPN_PTN_009_$capId" \
	 	$rateL $rateR $rateL $rateR]} {
		set flag1_case1 1
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA1�����ۣ���NE1($gpnIp1)����100M��ELANҵ���ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1�����ۣ���NE1($gpnIp1)����100M��ELANҵ���ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)����100M��ELANҵ���ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)����100M��ARP�������ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��  ���Կ�ʼ=====\n"	
        stc::perform streamBlockActivate \
        	-streamBlockList "$hGPNPort1Stream1" \
        	-activate "true"
	incr capId
	if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 0 "��NE1($gpnIp1)����100M��ARP��������" $anaFliFrameCfg1 "GPN_PTN_009_$capId" \
		 $rateL $rateR $rateL $rateR]} {
		set flag2_case1 1
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA2�����ۣ���NE1($gpnIp1)����100M��ARP�������ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2�����ۣ���NE1($gpnIp1)����100M��ARP�������ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)����100M��ARP�������ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)����100M�Ĺ㲥���ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��  ���Կ�ʼ=====\n"	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream3" \
		-activate "true"
	incr capId
	if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 0 "��NE1($gpnIp1)����100M�Ĺ㲥����" $anaFliFrameCfg1 "GPN_PTN_009_$capId" \
		 $rateL $rateR $rateL $rateR]} {
		set flag3_case1 1
	}
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA3�����ۣ���NE1($gpnIp1)����100M�Ĺ㲥���ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3�����ۣ���NE1($gpnIp1)����100M�Ĺ㲥���ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)����100M�Ĺ㲥���ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��������100Mbps֡����512�ı��ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��  ���Կ�ʼ=====\n"
		stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream3" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream4" \
		-activate "true"
	incr capId
	if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 0 "��NE1($gpnIp1)����100M��֡����512�ı���" $anaFliFrameCfg1 "GPN_PTN_009_$capId" \
		 $rateL $rateR $rateL $rateR]} {
		set flag4_case1 1
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA4�����ۣ���NE1($gpnIp1)��������100Mbps֡����512�ı��ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4�����ۣ���NE1($gpnIp1)��������100Mbps֡����512�ı��ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��������100Mbps֡����512�ı��ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��������������ݱ��ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��  ���Կ�ʼ=====\n"	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream4" \
		-activate "false"
	stc::config [stc::get $hGPNPort1Stream5 -AffiliationStreamBlockLoadProfile-targets] -load 800 -LoadUnit MEGABITS_PER_SECOND
	stc::apply
	incr capId
	if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 0 "��NE1($gpnIp1)��������������ݱ���" $anaFliFrameCfg1 "GPN_PTN_009_$capId" \
		 $rateL $rateR 760000000 840000000]} {
		set flag5_case1 1
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA5�����ۣ���NE1($gpnIp1)��������������ݱ��ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5�����ۣ���NE1($gpnIp1)��������������ݱ��ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��������������ݱ��ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase1 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 1���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 1���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 1 ���Ĺ�������  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 �ڴ�й©����\n"
	#   <1>����1��E-LANҵ�� ������Ӧ��LSP��PW��AC����ɾ������ҵ��ϵͳ����
	#   <2>�ýű��������ɾ��E-LANʵ��500�Σ�ҵ�񼰹����������ڴ�û��й©��ϵͳ���쳣
	set flag1_case2 0
	
	stc::config [stc::get $hGPNPort1Stream5 -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList2" \
		-activate "true"
	foreach eth $Portlist0 telnet $lSpawn_id Gpn_type $lDutType matchType $lMatchType {
		PTN_UNI_AddInter $telnet $matchType $Gpn_type $fileId $Worklevel "500" $eth
	}
	gwd::GWVpls_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls20" 20 "elan" "flood" "false" "false" "false" "true" 32000 "" ""
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw021" "vpls" "vpls20" "peer" $address621 "102" "102" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw023" "vpls" "vpls20" "peer" $address623 "202" "202" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw024" "vpls" "vpls20" "peer" $address624 "62" "62" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac500" "vpls20" "" $GPNTestEth2 "500" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc3"
	
	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls30" 30 "elan" "flood" "false" "false" "false" "true" 32000 "" ""
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw032" "vpls" "vpls30" "peer" $address632 "202" "202" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw034" "vpls" "vpls30" "peer" $address634 "302" "302" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw031" "vpls" "vpls30" "peer" $address631 "52" "52" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac500" "vpls30" "" $GPNTestEth3 "500" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc3"
	
	gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40" 40 "elan" "flood" "false" "false" "false" "true" 32000 "" ""
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw041" "vpls" "vpls40" "peer" $address641 "402" "402" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw043" "vpls" "vpls40" "peer" $address643 "302" "302" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw042" "vpls" "vpls40" "peer" $address642 "62" "62" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac500" "vpls40" "" $GPNTestEth4 "500" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc3"
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
	for {set i 1} {$i<=$ptn009_case2_cnt} {incr i} {
        	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls10" 10 "elan" "flood" "false" "false" "false" "true" 32000 "" ""
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw012" "vpls" "vpls10" "peer" $::address612 "102" "102" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw014" "vpls" "vpls10" "peer" $::address614 "402" "402" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4" 
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw013" "vpls" "vpls10" "peer" $::address613 "52" "52" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
        	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac500" "vpls10" "" $::GPNTestEth1 "500" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc3"	
		#�������ת��
		incr capId
		if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 2 "��$i\������½�ELANҵ���" $anaFliFrameCfg1 "GPN_PTN_009_$capId" $rateL $rateR $rateL $rateR]} {
			set flag1_case2 1
		}
        	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac500"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw012"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw013"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw014"
        	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls10"
		incr capId
		if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 1 "��$i\��ɾ���½�ELANҵ���" $anaFliFrameCfg1 "GPN_PTN_009_$capId" $rateL $rateR $rateL $rateR]} {
			set flag1_case2 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
	send_log "\n resource1:$resource1"
	send_log "\n resource2:$resource2"
	if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "�������ɾ��ELANҵ��֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "�������ɾ��ELANҵ��֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		 gwd::GWpublic_print "NOK" "FA6�����ۣ��������ɾ��ELANҵ�񣬶��Ѵ���ELANҵ���ϵͳ�ڴ���Ӱ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6�����ۣ��������ɾ��ELANҵ�񣬶��Ѵ���ELANҵ���ϵͳ�ڴ���Ӱ��" $fileId
	}
	puts $fileId ""
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase2 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 2���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 2���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 2 �ڴ�й©����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 E-LANҵ����������׳�Բ���-1��VSI���ض��PW AC����\n"
        #vpls��mac��ַ�������� 
        #   <1>��NE1��vsi������mac��ַѧϰ����Ϊ���������ϵͳ֧������������Ϊ32000��
        #   <2>��NE1��uni�ڷ���Դmac��������Ӧ�����̶�������
        #   Ԥ�ڽ��:�鿴NE2��NE3��UNI��ѧϰ�ı���������NE1���͵ı�����һ��
        #            �ڵײ�鿴mac��ַѧϰ������VSI�����ѧϰ����MAC��ַ��������ֵһ�£�
        #1��VSI���ض��PW����  
        #   <3>��̨76�������������ˣ�NE1�豸ͨ�����������ܣ�NE2��NE3��NE4�豸����������,��̨�豸��ping���ܵ�ַ
        #   <4>��NE1��UNI�ڷ���������ҵ����������ͬ�������ġ����ֱ��ġ�����arp���ģ���NE2���������޶�����ϵͳ���쳣����¼��ϵͳ1��VSI�Ͽɳ��ض��ٸ�PW?
        #   Ԥ�ڽ��:NE1��NE2�������ã��鿴������LSP��PW��AC��Ŀ������������ʾ����ȷ�������ļ��ɳɹ�������ϵͳ���쳣���鿴�����������ļ���ȷ��������
        #   <5>ʹ��ÿ��ҵ��LSP��PW����ͳ�ƣ�ϵͳ���쳣������ͳ�ƹ�����Ч��ͳ��ֵ��ȷ
        #   <6>shutdown��undo shutdown NE1�豸��NNI/UNI�˿ڹ���50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸��ţ�DCN����
        #   <7>����NE1�豸��SW/NMS����50�Σ���/Ӳ��������ҵ��������ָ���ÿ��ҵ��˴��޸��ţ�DCN�������鿴��ǩת��������ȷ
        #   <8>��λNE1�豸��NNI/UNI���ڰ忨50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸��ţ�DCN����
        #   <9>����NE1��NE2�豸���ã���������NE1��NE2�豸����λ��Ӳ��λ��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ������ұ˴��޸��ţ���ǩת��������ȷ��DCN����
        #   <10>���NE1��NE2�豸���ã�����NE1��NE2�豸�����豸������鿴������Ϣ�գ������Ե����������ļ����룬�����豸��
        #       ���豸������鿴������Ϣ�޶�ʧ����ȷ��������֤ҵ�������ת����DCN����
        #   <11>���NE1��NE2�豸���ã�����NE1��NE2�豸
        #1��VSI���ض���AC
        #   <12>��̨76�������������ˣ�NE1�豸ͨ�����������ܣ�NE2��NE3��NE4�豸����������,��̨�豸��ping���ܵ�ַ
        #   <13>��NE1��NE2֮�佨��һ��EPLANҵ��һ��vpls��һ��LSP��һ��PW
        #   <14>NE1��NE2�Ķ��UNI�ڼ��벻ͬvlan���������ac
        #   <15>��NE1��һ��UNI�ڷ�����Ӧvlanҵ��������NE2���������޶�����NE1�������˿�Ҳ���յ�ϵͳ���쳣����¼��ϵͳ1��VSI�Ͽɳ��ض��ٸ�AC
        #   Ԥ�ڽ��:NE1��NE2�������ã����������ܲ鿴������LSP��PW��AC��Ŀ������������ʾ����ȷ�������ļ��ɳɹ�������ϵͳ���쳣���鿴�����������ļ���ȷ��������
        #   <16>shutdown��undo shutdownNE1�豸��NNI/UNI�˿ڹ���50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸��ţ�DCN����
        #   <17>��λNE1�豸��NNI/UNI���ڰ忨50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸��ţ�DCN����
        #   <18>����NE1�豸��SW/NMS����50�Σ���/Ӳ��������ҵ��������ָ���ÿ��ҵ��˴��޸��ţ�DCN�������鿴��ǩת��������ȷ
        #   <19>����NE1��NE2�豸���ã���������NE1��NE2�豸����λ��Ӳ��λ��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ������ұ˴��޸��ţ���ǩת��������ȷ��DCN����
        #   <20>���NE1��NE2�豸���ã�����NE1��NE2�豸
	set flag1_case3 0
	set flag2_case3 0
	set flag3_case3 0
	set flag4_case3 0
	set flag5_case3 0
	set flag6_case3 0
	set flag7_case3 0
	set flag8_case3 0
	set flag9_case3 0
	
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls��mac��ַ��������  ���Կ�ʼ=====\n"	
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls10" 10 "elan" "flood" "false" "false" "false" "true" 32000 "" ""
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw012" "vpls" "vpls10" "peer" $::address612 "102" "102" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw014" "vpls" "vpls10" "peer" $::address614 "402" "402" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4" 
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw013" "vpls" "vpls10" "peer" $::address613 "52" "52" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac500" "vpls10" "" $::GPNTestEth1 "500" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc3"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPortStreamList2" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream17" \
		-activate "true"
	gwd::Start_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	after 20000
	set forwardCnt_ac -1
	set getCnt 3
        while {[gwd::GWpublic_getForwardEntryCnt $telnet1 $matchType1 $Gpn_type1 $fileId vpls vpls10 "" "" "" forwardCnt_ac]} {
        	if {$getCnt == 0} {
        		break
        	}
        	incr getCnt -1
        }
        if {$forwardCnt_ac == -1} {
        	set flag1_case3 1
        	gwd::GWpublic_print "NOK" "����3�β�ѯNE1($gpnIp1)vpls10��ѧϰ����mac��ַ������ʧ��" $fileId
        } else {
		if {$forwardCnt_ac == 32000} {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls10��ѧϰ����mac��ַ����ӦΪ32000ʵΪ$forwardCnt_ac" $fileId
		} else {
			set flag1_case3 1 
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls10��ѧϰ����mac��ַ����ӦΪ32000ʵΪ$forwardCnt_ac" $fileId
		}
        }
	set forwardCnt_pw1 -1
	set getCnt 3
	while {[gwd::GWpublic_getForwardEntryCnt $telnet2 $matchType2 $Gpn_type2 $fileId vpls vpls20 "" "" "" forwardCnt_pw1]} {
		if {$getCnt == 0} {
			break
		}
		incr getCnt -1
	}
	if {$forwardCnt_pw1 == -1} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����3�β�ѯNE2($gpnIp2)vpls20��ѧϰ����mac��ַ������ʧ��" $fileId
	} else {
		if {$forwardCnt_pw1 == 32000} {
			gwd::GWpublic_print "OK" "NE2($gpnIp2)vpls20��ѧϰ����mac��ַ����ӦΪ32000ʵΪ$forwardCnt_pw1" $fileId
		} else {
			set flag1_case3 1 
			gwd::GWpublic_print "NOK" "NE2($gpnIp2)vpls20��ѧϰ����mac��ַ����ӦΪ32000ʵΪ$forwardCnt_pw1" $fileId
		}
	}
	set forwardCnt_pw2 -1
	set getCnt 3
	while {[gwd::GWpublic_getForwardEntryCnt $telnet3 $matchType3 $Gpn_type3 $fileId vpls vpls30 "" "" "" forwardCnt_pw2]} {
		if {$getCnt == 0} {
			break
		}
		incr getCnt -1
	}
	if {$forwardCnt_pw2 == -1} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����3�β�ѯNE3($gpnIp3)vpls30��ѧϰ����mac��ַ������ʧ��" $fileId
	} else {
		if {$forwardCnt_pw2 == 32000} {
			gwd::GWpublic_print "OK" "NE3($gpnIp3)vpls30��ѧϰ����mac��ַ����ӦΪ32000ʵΪ$forwardCnt_pw2" $fileId
		} else {
			set flag1_case3 1 
			gwd::GWpublic_print "NOK" "NE3($gpnIp3)vpls30��ѧϰ����mac��ַ����ӦΪ32000ʵΪ$forwardCnt_pw2" $fileId
		}
	}
	gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	puts $fileId ""
	if {$flag1_case3 == 1} {
		set flagCase3 1
		 gwd::GWpublic_print "NOK" "FA7�����ۣ�vpls��mac��ַ��������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7�����ۣ�vpls��mac��ַ��������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls��mac��ַ��������  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	stc::delete $hGPNPort1AnaFrameCfgFil
	stc::delete $hGPNPort2AnaFrameCfgFil
	stc::delete $hGPNPort3AnaFrameCfgFil
	stc::delete $hGPNPort4AnaFrameCfgFil
	stc::apply
	Recustomization 1 1 1 1 0 0
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort1Ana hGPNPort1AnaFrameCfgFil
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort2Ana hGPNPort2AnaFrameCfgFil
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort3Ana hGPNPort3AnaFrameCfgFil	
	gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
	foreach hCfgFil "$hGPNPort1AnaFrameCfgFil $hGPNPort2AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" {
		gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $anaFliFrameCfg1
	}
	stc::apply
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����PW AC����������  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac500"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw012"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw013"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw014"
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls10"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.500 $matchType1 $Gpn_type1 $telnet1
	PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.800 $matchType1 $Gpn_type1 $telnet1
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GW_AddUploadFile $telnet1 $matchType1 $Gpn_type1 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
			"config" "GPN_PTN_009_defaultCfg1.txt" "" "60"
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" 1 "elan" "flood" "false" "false" "false" "true" 2000 "" ""
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "800" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	set local 30
	set remote 30
	set retTmp 0
	for {set pw 1} {$pw<=$pwNum} {incr pw} {
		set createCnt 3 
		while {[gwd::GWStaPw_AddVplsPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw$pw" "vpls1" $address614 $local $remote none "nochange" 1 0 "0x8100" "0x8100" "4" $pw]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp 1
				break
			}
		}
		if {$retTmp == 0} {
			incr local 
			incr remote
		} else {
			break
		}
	}
	set ne1PWnum [expr $pw-1]

	if {$ne1PWnum < 1024} {
		set flag2_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)һ��VSI����PW������Ϊ$ne1PWnum\���ȱ��ֵ1024��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)һ��VSI����PW������Ϊ$ne1PWnum\������Ҫ��" $fileId
	}
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac500"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw042"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw043"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw041"
	gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40"
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43"
	gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls4"
	PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth4.500 $matchType4 $Gpn_type4 $telnet4
	PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth4.800 $matchType4 $Gpn_type4 $telnet4
	gwd::GWpublic_SaveCfg $telnet4 $matchType4 $Gpn_type4 $fileId
	gwd::GW_AddUploadFile $telnet4 $matchType4 $Gpn_type4 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
			"config" "GPN_PTN_009_defaultCfg4.txt" "" "60"
	gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls4" 1 "elan" "flood" "false" "false" "false" "true" 4500 "" ""
	PTN_UNI_AddInter $telnet4 $matchType4 $Gpn_type4 $fileId $Worklevel "800" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac800" "vpls4" "" $GPNTestEth4 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	set local 30
	set remote 30
	set retTmp 0
	for {set pw 1} {$pw<=$pwNum} {incr pw} {
		set createCnt 3 
		while {[gwd::GWStaPw_AddVplsPwInfo $telnet4 $matchType4 $Gpn_type4 $fileId "pw$pw" "vpls4" $address641 $local $remote none "nochange" 1 0 "0x8100" "0x8100" "1" $pw]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp 1
				break
			}
		}
		if {$retTmp == 0} {
			incr local 
			incr remote
		} else {
			break
		}
	}
	set ne4PWnum [expr $pw-1]

	if {$ne4PWnum < 1024} {
		set flag2_case3 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)һ��VSI����PW������Ϊ$ne4PWnum\���ȱ��ֵ1024��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)һ��VSI����PW������Ϊ$ne4PWnum\������Ҫ��" $fileId
	}
	##########################################################################################################
	###��ʱ��������֤pw������--------------
            #	stc::perform streamBlockActivate \
            #		-streamBlockList "$hGPNPort1Stream17" \
            #		-activate "false"
            #	stc::perform streamBlockActivate \
            #		-streamBlockList "$hGPNPort1Stream5" \
            #		-activate "true"
            #
            #	stc::config [stc::get $hGPNPort1Stream5 -AffiliationStreamBlockLoadProfile-targets] -load 0.5 -LoadUnit MEGABITS_PER_SECOND
            #	gwd::Start_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
            #	after 20000
            #	set l1Rate [stc::get $::hGPNPort4Ana.AnalyzerPortResults -L1BitRate]
            #	if {$l1Rate < 511000000 || $l1Rate > 513000000} {
            #		set flag2_case3 1
            #		gwd::GWpublic_print "NOK" "������֤pw������" $fileId
            #	}
	###--------------��ʱ��������֤pw������
	##########################################################################################################
	
	gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"GPN_PTN_009_defaultCfg1.txt" ""
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWmanage_ftpDownload $telnet4 $matchType4 $Gpn_type4 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"GPN_PTN_009_defaultCfg4.txt" ""
	gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" 1 "elan" "flood" "false" "false" "false" "true" 4500 "" ""
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "4000" "4000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls4" 1 "elan" "flood" "false" "false" "false" "true" 4500 "" ""
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "4000" "4000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	
	set cnt3 10
	set retTmp3 0
	set retTmp4 0
        for {set ac 1} {$ac<=$AcNum} {incr ac} {
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet1 $matchType1 $Gpn_type1 $fileId $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					set retTmp3 1
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet1 $matchType1 $Gpn_type1 $fileId $cnt3 "port" $GPNTestEth1 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					set retTmp3 1
					break
				}
			}
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fileId "ethernet" $GPNTestEth1 $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					set retTmp3 1
					break
				}
			}
		}
       			
		set createCnt 3 
		while {[gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac$cnt3" "vpls1" "" $GPNTestEth1 $cnt3 "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp4 1
				break
			}
		}  
 	 
		if {$retTmp3 == 0 && $retTmp4 == 0} {
                	incr cnt3
                }
		if {$retTmp4 == 1} {
			break
		}
	}
        set ne1ACnum [expr $cnt3-10]
	if {$ne1ACnum < 1024} {
		set flag2_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)һ��VSI����AC������Ϊ$ne1ACnum\���ȱ��ֵ1024��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)һ��VSI����AC������Ϊ$ne1ACnum\������Ҫ��" $fileId
	}

	set cnt3 10
	set retTmp3 0
	set retTmp4 0
        for {set ac 1} {$ac<=$AcNum} {incr ac} {
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet4 $matchType4 $Gpn_type4 $fileId $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					set retTmp3 1
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet4 $matchType4 $Gpn_type4 $fileId $cnt3 "port" $GPNTestEth4 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					set retTmp3 1
					break
				}
			}
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet4 $matchType4 $Gpn_type4 $fileId "ethernet" $GPNTestEth4 $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					set retTmp3 1
					break
				}
			}
		}
			       
		set createCnt 3 
		while {[gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac$cnt3" "vpls4" "" $GPNTestEth4 $cnt3 "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp4 1
				break
			}
		}  
		
		if {$retTmp3 == 0 && $retTmp4 == 0} {
			incr cnt3
		}
		if {$retTmp4 == 1} {
			break
		}
        }
        set ne4ACnum [expr $cnt3-10]
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GW_AddUploadFile $telnet1 $matchType1 $Gpn_type1 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"config" "GPN_PTN_009_acCntconfig1.txt" "" "120"
	gwd::GWpublic_SaveCfg $telnet4 $matchType4 $Gpn_type4 $fileId
	gwd::GW_AddUploadFile $telnet4 $matchType4 $Gpn_type4 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"config" "GPN_PTN_009_acCntconfig4.txt" "" "120"
	
	if {$ne4ACnum < 1024} {
		set flag2_case3 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)һ��VSI����AC������Ϊ$ne4ACnum\���ȱ��ֵ1024��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)һ��VSI����AC������Ϊ$ne4ACnum\������Ҫ��" $fileId
	}
	puts $fileId ""
	if {$flag2_case3 == 1} {
		set flagCase3 1
		 gwd::GWpublic_print "NOK" "FA8�����ۣ�һ��VSI����PW AC����������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8�����ۣ�һ��VSI����PW AC����������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����PW AC����������  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����AC��������֤�����Ƿ���Ч  ���Կ�ʼ=====\n"
	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream17" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList4" \
		-activate "true"
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg1
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1
		
	set acNum [expr {($ne4ACnum < $ne1ACnum) ? $ne4ACnum : $ne1ACnum}]
	set a 1
	set b 0
	set expStartVid1 10
	set expEndVid1 [expr $acNum+10-1]
	for {set i $expStartVid1} {$i<= $expEndVid1} {incr i} {
		if {$a==256} {
			incr b
			set a 0
		}
		lappend expectList1 $i 00:00:00:01:[format %02x $b]:[format %02x $a]
		lappend expectList2 $i 00:00:01:00:[format %02x $b]:[format %02x $a]
		incr a
	}
	send_log "\n case3 expectList1:$expectList1"
	send_log "\n case3 expectList2:$expectList2"
	incr capId
	if {[Test_acCapacity "" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
		set  flag3_case3 1
	}
	
	puts $fileId ""
	if {$flag3_case3 == 1} {
		set flagCase3 1
		 gwd::GWpublic_print "NOK" "FA9�����ۣ�һ��VSI����AC��������֤����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9�����ۣ�һ��VSI����AC��������֤����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����AC��������֤�����Ƿ���Ч  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����AC��NE1($gpnIp1)����shutdown/undo shutdownҵ��˿ڲ���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	incr capId
        foreach eth "$GPNPort12 $GPNTestEth1" {
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
        		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
        		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
        		after $WaiteTime
			after 120000
			incr capId
        		if {[Test_acCapacity "��$j\��shutdown/undo shutdown NE1($gpnIp1)��$eth\�˿ں�" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
        		  set  flag4_case3 1
        		}
        	}
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
        	send_log "\n resource1:$resource1"
        	send_log "\n resource2:$resource2"
        	if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
        		set flag4_case3 1
        		gwd::GWpublic_print "NOK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
        	}
        }
	puts $fileId ""
	if {$flag4_case3 == 1} {
		set flagCase3 1
		 gwd::GWpublic_print "NOK" "FB1�����ۣ�һ��VSI����AC��NE1($gpnIp1)����shutdown/undo shutdownҵ��˿ڲ���ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1�����ۣ�һ��VSI����AC��NE1($gpnIp1)����shutdown/undo shutdownҵ��˿ڲ���ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����AC��NE1($gpnIp1)����shutdown/undo shutdownҵ��˿ڲ���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����AC��NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	foreach slot $rebootSlotlist1 {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource3
		set testFlag 0
		for {set j 1} {$j<=$cnt} {incr j} {
			if {![gwd::GWCard_AddReboot $telnet1 $matchType1 $Gpn_type1 $fileId $slot]} {
        			after $rebootBoardTime
				after 120000
        			if {[string match $mslot1 $slot]} {
        			      set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
        			      set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
        			}
				incr capId
                		if {[Test_acCapacity "��$j\������NE1($gpnIp1)$slot\��λ�忨" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
                		      set  flag5_case3 1
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
		  	      set flag5_case3 1
		  	      gwd::GWpublic_print "NOK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
		        } else {
		  	      gwd::GWpublic_print "OK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
		        }
	        }
	}
	puts $fileId ""
	if {$flag5_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB2�����ۣ�һ��VSI����AC��NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2�����ۣ�һ��VSI����AC��NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����AC��NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����AC��NE1($gpnIp1)��������NMS��������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
        ###��������NMS��������
        gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
        for {set j 1} {$j<$cntdh} {incr j} {
                if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after [expr 2*$rebootTime]
                	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
                	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
                	if {[Test_acCapacity "��$j\�� NE1($gpnIp1)����NMS����������" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
                		set  flag6_case3 1
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
                	set flag6_case3	1
                	gwd::GWpublic_print "NOK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
                } else {
                	gwd::GWpublic_print "OK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
                }
        }
        puts $fileId ""
        if {$flag6_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB3�����ۣ�һ��VSI����AC��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB3�����ۣ�һ��VSI����AC��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����AC��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����AC��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ棬����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	set testFlag 0 ;#=1 ��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			after 120000
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_acCapacity "��$j\�� NE1($gpnIp1)����SW����������" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
				set  flag7_case3 1
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
			set flag7_case3	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag7_case3 == 1} {
		set flagCase3 1
		 gwd::GWpublic_print "NOK" "FB4�����ۣ�һ��VSI����AC��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4�����ۣ�һ��VSI����AC��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����AC��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����AC��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ棬����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	##���������豸����
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		after 60000
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after [expr 2*$rebootTime]
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[Test_acCapacity "��$j\�� NE1($gpnIp1)���б����豸������" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
			set  flag8_case3 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag8_case3	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag8_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB5�����ۣ�һ��VSI����AC��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5�����ۣ�һ��VSI����AC��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��VSI����AC��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ棬����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�����������������һ��VSI����PW��AC�����ò������豸����֤ҵ��  ���Կ�ʼ=====\n" 
	gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"NE1.txt" ""
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWmanage_ftpDownload $telnet4 $matchType4 $Gpn_type4 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"NE4.txt" ""
	gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
	after [expr 2*$rebootTime]
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]	
	gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
			"GPN_PTN_009_acCntconfig1.txt" ""
	gwd::GWmanage_ftpDownload $telnet4 $matchType4 $Gpn_type4 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
			"GPN_PTN_009_acCntconfig4.txt" ""
        gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
	after [expr 2*$rebootTime]
        set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
        set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
	incr capId
	if {[Test_acCapacity "������������ò������豸��" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
		set  flag9_case3 1
	}
	puts $fileId ""
	if {$flag9_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB6�����ۣ������������������һ��VSI����PW��AC�����ò������豸����֤ҵ" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6�����ۣ������������������һ��VSI����PW��AC�����ò������豸����֤ҵ" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�����������������һ��VSI����PW��AC�����ò������豸����֤ҵ  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase3 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 3���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 3���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 3 E-LANҵ����������׳�Բ���-1��VSI���ض��PW AC����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 E-LANҵ��׳�Բ���-ϵͳ���ض��vsi����\n"
        #ϵͳ���ض���VSI
        #   <21>��̨76�������������˼�����ͼ1��NE1--NE2--NE3--NE4����������NE1�豸ͨ������������,NE2��NE3��NE4�豸ͨ�����������ܣ�
        #       ��4̨�豸��DCN������̨�豸�˴�֮���NNI�˿�ͨ����̫���ӿ���ʽ������NNI�˿���untag��ʽ���뵽VLANIF��,��̨�豸��ping���ܵ�ַ
        #   <22>����NE1��NE2��NE3��NE4֮���EVP-LANҵ��NE2��ΪPE��Ϊp�豸���û������ģʽΪ�˿�+��Ӫ��VLANģʽ
        #   <23>NE1��NE2��NE3��NE4֮�������һ��lsp��һ��vpls���������PW��һ��AC
        #   <24>��NE1��UNI�ڷ���������ҵ����������ͬ�������ġ����ֱ��ġ�����arp���ģ���NE2��NE3��NE4��������������ϵͳ���쳣����¼ϵͳ�пɴ������ٵ�VPLS��
        #   Ԥ�ڽ��:����NE1��NE2�豸���ã��鿴������LSP��PW��AC��Ŀ������������ʾ����ȷ�������ļ��ɳɹ�������ϵͳ���쳣���鿴�����������ļ���ȷ�������룬DCN����
        #   <25>shutdown��undo shutdownNE1�豸��NNI/UNI�˿ڹ���50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸��ţ�DCN����
        #   <26>��λNE1�豸��NNI/UNI���ڰ忨50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸��ţ�DCN����
        #   <27>����NE1�豸��SW/NMS����50�Σ���/Ӳ��������ҵ��������ָ���ÿ��ҵ��˴��޸��ţ�DCN�����鿴��ǩת��������ȷ
        #   <28>����NE1��NE2��NE3�豸���ã���������NE1��NE2��NE3�豸����λ��Ӳ��λ��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ������ұ˴��޸��ţ���ǩת��������ȷ��DCN����
        #   <29>���NE1��NE2�豸���ã�����NE1��NE2�豸�����豸������鿴������Ϣ�գ������Ե����������ļ����룬�����豸��
        #       ���豸������鿴������Ϣ�޶�ʧ����ȷ��������֤ҵ�������ת����DCN����
        ####����NE1��NE4�豸��lsp�����ļ�
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set flag5_case4 0
	set flag6_case4 0
	set flag7_case4 0
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ����vsi����������  ���Կ�ʼ=====\n"
	gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"GPN_PTN_009_defaultCfg1.txt" ""
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWmanage_ftpDownload $telnet4 $matchType4 $Gpn_type4 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"GPN_PTN_009_defaultCfg4.txt" ""
	gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
	
	set idcnt1 10
	set cnt2 10
	set cnt3 10
	set local 50
	set remote 50
	set retTmp 0
	for {set vsi 1} {$vsi<=$VsiNum} {incr vsi} {
		set createCnt 3 
		while {[gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls$idcnt1" $idcnt1 "elan" "flood" "false" "false" "false" "true" "4500" "" ""]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp 1
				break
			}
		}
		set createCnt 3 
		while {[gwd::GWStaPw_AddVplsPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw$cnt2" "vpls$idcnt1" $address614 $local $remote  none "nochange" 1 0 "0x8100" "0x8100" 4 $cnt2]} {
			incr createCnt -1
			if {$createCnt == 0} {
				break
			}
		}
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet1 $matchType1 $Gpn_type1 $fileId $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet1 $matchType1 $Gpn_type1 $fileId $cnt3 "port" $GPNTestEth1 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					break
				}
			}
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fileId "ethernet" $GPNTestEth1 $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					break
				}
			}
		}
		set createCnt 3 
		while {[gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac$cnt3" "vpls$idcnt1" "" $GPNTestEth1 $cnt3 "0" "none" "nochange" "1" "0" "0" "0x9100" "evc$cnt3"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				break
			}
		}		
        	if {$retTmp == 0} {
                	incr idcnt1
                	incr cnt2
                	incr cnt3
                	incr local 
                	incr remote 
        	} else {
        		break  
        	}
	}
	set VPLSnum1 [expr $idcnt1-10]
	
	#NE4������
	set idcnt4 10
	set cnt2 10
	set cnt3 10
	set local 50
	set remote 50
	set retTmp 0
	for {set vsi 1} {$vsi<=$VsiNum} {incr vsi} {
		set createCnt 3 
		while {[gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls$idcnt4" $idcnt4 "elan" "flood" "false" "false" "false" "true" "4500" "" ""]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp 1
				break
			}
		}
		set createCnt 3 
		while {[gwd::GWStaPw_AddVplsPwInfo $telnet4 $matchType4 $Gpn_type4 $fileId "pw$cnt2" "vpls$idcnt4" $address641 $remote $local  none "nochange" 1 0 "0x8100" "0x8100" 1 $cnt2]} {
			incr createCnt -1
			if {$createCnt == 0} {
				break
			}
		}
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet4 $matchType4 $Gpn_type4 $fileId $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet4 $matchType4 $Gpn_type4 $fileId $cnt3 "port" $GPNTestEth4 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					break
				}
			}
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet4 $matchType4 $Gpn_type4 $fileId "ethernet" $GPNTestEth4 $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					break
				}
			}
		}
		set createCnt 3 
		while {[gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac$cnt3" "vpls$idcnt4" "" $GPNTestEth4 $cnt3 "0" "none" "nochange" "1" "0" "0" "0x9100" "evc$cnt3"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				break
			}
		}
                if {$retTmp == 0} {
                        incr idcnt4
                        incr cnt2
                        incr cnt3
                        incr local 
                        incr remote 
                } else {
			break  
                }
	}
	set VPLSnum4 [expr $idcnt4-10]	       
	
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GW_AddUploadFile $telnet1 $matchType1 $Gpn_type1 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"config" "GPN_PTN_009_vplscntconfig1.txt" "" "120"
	gwd::GWpublic_SaveCfg $telnet4 $matchType4 $Gpn_type4 $fileId
	gwd::GW_AddUploadFile $telnet4 $matchType4 $Gpn_type4 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"config" "GPN_PTN_009_vplscntconfig4.txt" "" "120"
	
	if {$VPLSnum1 < $VsiNum} {
		set flag1_case4 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)ϵͳ����vsi������Ϊ$VPLSnum1\���ȱ��ֵ$VsiNum\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)ϵͳ����vsi������Ϊ$VPLSnum1\������Ҫ��" $fileId
	}
	if {$VPLSnum4 < $VsiNum} {
		set flag1_case4 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)ϵͳ����vsi������Ϊ$VPLSnum4\���ȱ��ֵ$VsiNum\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)ϵͳ����vsi������Ϊ$VPLSnum4\������Ҫ��" $fileId
	}
	puts $fileId ""
	if {$flag1_case4 == 1} {
		set flagCase3 1
		 gwd::GWpublic_print "NOK" "FB7�����ۣ�ϵͳ����vsi����������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7�����ۣ�ϵͳ����vsi����������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ����vsi����������  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI���䣬����shutdown/undo shutdownҵ��˿ڲ���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	set VPLSnum [expr {($VPLSnum4 < $VPLSnum1) ? $VPLSnum4 : $VPLSnum1}]
	set a 1
	set b 0
	set expStartVid1 10
	set expEndVid1 [expr $VPLSnum+10-1]
	for {set i $expStartVid1} {$i<= $expEndVid1} {incr i} {
		if {$a==256} {
			incr b
			set a 0
		}
		lappend expectList1 $i 00:00:00:01:[format %02x $b]:[format %02x $a]
		lappend expectList2 $i 00:00:01:00:[format %02x $b]:[format %02x $a]
		incr a
	}
	send_log "\n case4 expectList1:$expectList1"
	send_log "\n case4 expectList2:$expectList2"
	Test_acCapacity "" $expectList1 $expectList2 "GPN_PTN_009_$capId"

	foreach eth "$GPNPort12 $GPNTestEth1" {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
		for {set j 1} {$j<=$cnt} {incr j} {
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "shutdown"
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "undo shutdown"
			after $WaiteTime
			after 300000
			incr capId
			if {[Test_acCapacity "��$j\��shutdown/undo shutdown NE1($gpnIp1)��$eth\�˿ں�" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
				set  flag2_case4 1
			}
		}
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag2_case4 1
			gwd::GWpublic_print "NOK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag2_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FB8�����ۣ�NE1($gpnIp1)VSI���䣬����shutdown/undo shutdownҵ��˿ڲ���ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8�����ۣ�NE1($gpnIp1)VSI���䣬����shutdown/undo shutdownҵ��˿ڲ���ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI���䣬����shutdown/undo shutdownҵ��˿ڲ���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI���䣬��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
#	foreach slot $rebootSlotlist1 {
		regexp {(\d+)/\d+} $GPNPort12 match slot
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource3
		set testFlag 0
		for {set j 1} {$j<=$cnt} {incr j} {
			if {![gwd::GWCard_AddReboot $telnet1 $matchType1 $Gpn_type1 $fileId $slot]} {
				after $rebootBoardTime
				after 300000
				if {[string match $mslot1 $slot]} {
				      set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
				      set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
				}
				incr capId
				if {[Test_acCapacity "��$j\������NE1($gpnIp1)$slot\��λ�忨" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
				      set  flag3_case4 1
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
				set flag3_case4 1
				gwd::GWpublic_print "NOK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
			}
		}
#	}
	puts $fileId ""
	if {$flag3_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB9�����ۣ�NE1($gpnIp1)VSI���䣬��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9�����ۣ�NE1($gpnIp1)VSI���䣬��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI���䣬��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI���䣬��������NMS��������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	###��������NMS��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after [expr 2*$rebootTime]
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_acCapacity "��$j\�� NE1($gpnIp1)����NMS����������" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
				set  flag4_case4 1
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
			set flag4_case4	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag4_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC1�����ۣ�NE1($gpnIp1)VSI���䣬��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1�����ۣ�NE1($gpnIp1)VSI���䣬��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI���䣬��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI���䣬��������SW������������ҵ��ָ���ϵͳ�ڴ棬����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	set testFlag 0 ;#=1 ��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			after 300000
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_acCapacity "��$j\�� NE1($gpnIp1)����SW����������" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
				set  flag5_case4 1
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
			set flag5_case4	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag5_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FC2�����ۣ�NE1($gpnIp1)VSI���䣬��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2�����ۣ�NE1($gpnIp1)VSI���䣬��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI���䣬��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI���䣬�������б����豸���������ҵ��ָ���ϵͳ�ڴ棬����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	##���������豸����
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		after 60000
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after [expr 2*$rebootTime]
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[Test_acCapacity "��$j\�� NE1($gpnIp1)���б����豸������" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
			set  flag6_case4 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag6_case4	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC3�����ۣ�NE1($gpnIp1)VSI���䣬�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3�����ۣ�NE1($gpnIp1)VSI���䣬�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI���䣬�������б����豸���������ҵ��ָ���ϵͳ�ڴ棬����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�����������������VSI��������ò������豸����֤ҵ��  ���Կ�ʼ=====\n" 
	gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"GPN_PTN_009_defaultCfg1.txt" ""
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWmanage_ftpDownload $telnet4 $matchType4 $Gpn_type4 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"GPN_PTN_009_defaultCfg4.txt" ""
	gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
	after [expr 2*$rebootTime]
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]	
	gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
			"GPN_PTN_009_vplscntconfig1.txt" ""
	gwd::GWmanage_ftpDownload $telnet4 $matchType4 $Gpn_type4 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
			"GPN_PTN_009_vplscntconfig4.txt" ""
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
	after [expr 2*$rebootTime]
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
	
	incr capId
	if {[Test_acCapacity "����VSI��������ò������豸��" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
		set  flag7_case4 1
	}
	puts $fileId ""
	if {$flag7_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC4�����ۣ������������������VSI��������ò������豸����֤ҵ" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4�����ۣ������������������VSI��������ò������豸����֤ҵ" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�����������������VSI��������ò������豸����֤ҵ  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
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
	puts $fileId "Test Case 4 E-LANҵ��׳�Բ���-ϵͳ���ض��vsi����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 E-LANҵ��׳�Բ���-ϵͳ���ض��vsi����\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===�ָ���ʼ������...\n"
	lappend flagDel [gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fileId 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"NE1.txt" ""]
	lappend flagDel [gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId]
	lappend flagDel [gwd::GWmanage_ftpDownload $telnet2 $matchType2 $Gpn_type2 $fileId $fileId 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"NE2.txt" ""]
	lappend flagDel [gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId]
	lappend flagDel [gwd::GWmanage_ftpDownload $telnet3 $matchType3 $Gpn_type3 $fileId $fileId 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"NE3.txt" ""]
	lappend flagDel [gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId]
	lappend flagDel [gwd::GWmanage_ftpDownload $telnet4 $matchType4 $Gpn_type4 $fileId $fileId 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"NE4.txt" ""]
	lappend flagDel [gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId]
	after $rebootTime
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_009"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_009"
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_009����Ŀ�ģ�E-LAN�������ȶ��Բ���\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1==1 || $flagCase2==1 || $flagCase3==1 || $flagCase4==1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_009���Խ��" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4���Խ��" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ���NE1($gpnIp1)����100M��ELANҵ���ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ���NE1($gpnIp1)����100M��ARP�������ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ���NE1($gpnIp1)����100M�Ĺ㲥���ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ���NE1($gpnIp1)��������100Mbps֡����512�ı��ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ���NE1($gpnIp1)��������������ݱ��ģ����Զ�ELANҵ���ϵͳCPU�����ʵ�Ӱ��" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ��������ɾ��ELANҵ�񣬶�ELANҵ���ϵͳ�ڴ�[expr {($flag1_case2 == 1) ? "��" : "��"}]��Ӱ��" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls��mac��ַ��������" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag2_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��VSI����PW AC����������" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag3_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��VSI����AC��������֤����" $fileId
	gwd::GWpublic_print "== FB1 == [expr {($flag4_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��VSI����AC��NE1($gpnIp1)����shutdown/undo shutdownҵ��˿ڲ���ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag5_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��VSI����AC��NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag6_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��VSI����AC��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag7_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��VSI����AC��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag8_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��VSI����AC��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag9_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ������������������һ��VSI����PW��AC�����ò������豸����֤ҵ" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�ϵͳ����vsi����������" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)VSI���䣬����shutdown/undo shutdownҵ��˿ڲ���ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)VSI���䣬��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC1 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)VSI���䣬��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC2 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)VSI���䣬��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC3 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)VSI���䣬�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC4 == [expr {($flag7_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ������������������VSI��������ò������豸����֤ҵ" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_009"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_009_REPORT.txt" "report\\NOK_GPN_PTN_009_REPORT.txt"
	file rename "log\\GPN_PTN_009_LOG.txt" "log\\NOK_GPN_PTN_009_LOG.txt"
} else {
	file rename "report\\GPN_PTN_009_REPORT.txt" "report\\OK_GPN_PTN_009_REPORT.txt"
	file rename "log\\GPN_PTN_009_LOG.txt" "log\\OK_GPN_PTN_009_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}
