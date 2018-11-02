#!/bin/sh
# T4_GPN_PTN_ETREE_011.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#����Ŀ�ģ�E-TREE�Ĺ���-VLAN������֤
#1-AC VLAN������֤  
#2-8fx��Ϊac�˿� ��AC vlan������֤(δ����)
#3-PW VLAN������֤
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
##AC VLAN������֤###
##AC VLAN����Ϊ����
#   <1>����NE1��NE2/NE3/NE4��evp-treeҵ��,NNI����tag��ʽ����vlanIF,PW��AC��VLAN������Ϊ����
#   <2>��NE1���˿ڷ��ʹ���untag tag100��TPIDΪ0x8100��tag100��TPIDΪ0x9100��tag100��TPIDΪ0x8100�� ��3�����������۲�NE2��NE4��Ҷ�Ӷ˿ڽ��ս��
#   Ԥ�ڽ����ֻ�ɽ��յ�����tag100��TPIDΪ0x8100��������
#   <3>����NE1��NNI�˿�egress������
#   Ԥ�ڽ����Ϊ��VLAN TAG��ǩ����������mpls��ǩ���ģ����lsp��ǩ17���ڲ�pw��ǩ1000
##AC VLAN����Ϊɾ��
#   <4>�ڲ�ɾ��vpls������£�ɾ��NE2�豸�Ļ��ҵ��AC�����鿴����ɾ���ɹ���NE2��ҵ���жϣ��������ac������ΪAC��VLAN����Ϊɾ����(pwΪroot acΪleaf)����������Ϣ���ֲ���
#   <5>��NE1��root�˿ڷ��ʹ���tag100��TPIDΪ0x8100����ƥ�����������۲�NE2/NE3/NE4��Ҷ�Ӷ˿ڽ��ս��
#   Ԥ�ڽ����NE2���յ�untag��������NE4���յ�tag100����������
#   <6>����NE1����NNI�˿�egree�����������
#   Ԥ�ڽ����ҵ�������Ǵ�tag100�ı�ǩ��
##AC VLAN����Ϊ�޸�
#   <7>�ڲ�ɾ��vpls������£�ɾ��NE4�豸�Ļ��ҵ��AC��������AC��VLAN����Ϊ�޸ģ��޸�Ϊ VID=80��������������Ϣ���ֲ���
#   <8>��NE1��root�˿ڷ��ʹ���VID 100��TPIDΪ0x8100����ƥ��������������۲�NE2/NE3/NE4��Ҷ�Ӷ˿ڽ��ս����
#   Ԥ�ڽ����NE2���յ�untag����������NE4�˿ڽ��յ�vid80����������
#   <8>����NE1����NNI�˿�egree�����������
#   Ԥ�ڽ����ҵ�������Ǵ�tag100�ı�ǩ��
##AC VLAN����Ϊ���
#   <9>ɾ��NE2�豸��ר��ҵ��AC��������NE2AC��VLAN����Ϊ��ӣ����VID=100����ƥ��TPIDΪ9100��(pwΪroot acΪleaf)����������Ϣ���ֲ���
#   <10>��NE1��root�˿ڷ��ʹ���VID 100��TPIDΪ0x8100����ƥ��������������۲�NE2/NE3/NE4��Ҷ�Ӷ˿ڽ��ս����
#   Ԥ�ڽ����NE3�ɽ��յ�����˫���ǩ�������������200���ڲ�100����NE2���յ�untag��������;NE4�յ�tag80����������
#   <11>����NE1����NNI�˿�egree�����������
#   Ԥ�ڽ����ҵ�������Ǵ�tag100�ı�ǩ��
#   <12>NE2��NE3��NE4�豸������ac������SW/NMS����10�Σ���/Ӳ��������ac��������ȷ��Ч
#   <13>�������ã������豸���鿴��������ȷ�Ҷ�����Ч
#2���Test Case 2���Ի���
##8fx��Ϊac�˿� ��ac vlan������֤
#   <14>ɾ��NE1��NE2��E-treeҵ��vpls��ac�����鿴���ã�ҵ��ɹ�ɾ��
#   <15>��������NE1��NE2��Evp-Treeҵ��NE1��ac�˿�Ϊ4ge�ڣ�NE2��ac�˿�Ϊ8fx�˿ڣ�����mplsʹ�ܣ��������ò���
#   <16>����NE2��ac�˿�VLAN����Ϊ���䣬NE1��UNI�˿ڷ���tag100��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս��
#   Ԥ�ڽ�����ɽ��յ�����tag100��������
#   <17>����NE2��ac�˿�VLAN����Ϊ��ӣ�ֻ�����vlan idΪ4078-4085������NE1��UNI�˿ڷ���tag100��TPIDΪ0x8100�������������۲�NE2��UNI�˿ڽ��ս��
#   Ԥ�ڽ�����ɽ��յ�tag100�������������Ϊ����vlan��ҵ��ͨ
#   <18>����NE2��ac�˿�VLAN����Ϊ�޸ģ�ֻ���޸�Ϊ4078-4085������NE1��UNI�˿ڷ���tag 100��TPIDΪ0x8100�������������۲�NE2��UNI�˿ڽ��ս��
#   Ԥ�ڽ�����ɽ��յ�untag���������޸�Ϊ����vlan��ҵ��ͨ
#   <19>��NE1��AC��Ϊ8fx�ڣ��ظ�����16-18�Ĳ���
#   <20>����NE1��ac�˿�ҲΪ8fx�˿ڣ�ҵ��vlan�Ѿ�������vlan4078�ı�ǩ������PW����VLANɾ������ɾ��vlan4078�����NE2��8fx�˿ڽ��յ�����������16-18��һ��
#3���Test Case 3���Ի���
##PW VLAN������֤###
##PW VLAN����Ϊ����
#   <1>ɾ��4̨�豸�������û��ҵ��vpls��AC����α�ߣ�ɾ���ɹ���ϵͳ���쳣
#   <2>�ٴ�����4̨�豸��E-Treeҵ��PW��AC��VLAN������Ϊ���䣬ac�󶨵�vlanΪ100
#   <3>��NE1��root�˿ڷ��ʹ���VID 100��TPIDΪ0x8100����ƥ��������������۲�NE2��NE4��Ҷ�Ӷ˿ڽ��ս��
#   Ԥ�ڽ����NE2��NE3��NE4�ɽ��յ�tag100����������
#   <4>����NE1����NNI�˿�egree�����������
#   Ԥ�ڽ����ҵ�������Ǵ�tag100�ı�ǩ��
##PW VLAN����Ϊɾ��
#   <5>ɾ��NE1�豸�Ļ��ҵ��vpls����α�ߣ�PW1��������PW1��VLAN����Ϊɾ����(pwΪnone acΪnone)����������Ϣ���ֲ���
#   <6>��NE1��root�˿ڷ��ʹ���VID 100��TPIDΪ0x8100����ƥ��������������۲�NE2��NE3��NE4��Ҷ�Ӷ˿ڽ��ս��
#   Ԥ�ڽ����NE2�յ�untag����������Ne3��NE4�յ�tag100��������
#   <7>����NE1����NNI�˿�egree�����������
#   Ԥ�ڽ��������pw1��nni�ڳ������ҵ�������ǲ�����ǩ�ģ�����pw2��pw3��nni�ڳ������ҵ������tag100�ı�ǩ
##PW VLAN����Ϊ�޸�
#   <8>ɾ��NE1�豸�Ļ��ҵ��vpls����α�ߣ�PW2��������PW2��VLAN����Ϊ�޸ģ��޸�Ϊ VID=80��������������Ϣ���ֲ���
#   <9>��NE1��root�˿ڷ��ʹ���VID 100��TPIDΪ0x8100����ƥ��������������۲�NE2��NE3��NE4��Ҷ�Ӷ˿ڽ��ս��
#   Ԥ�ڽ����NE2�յ�untag����������NE4�յ�tag80����������NE3�յ�tag100��������
#   <10>����NE1����NNI�˿�egree�������������\
#   Ԥ�ڽ��������pw1��nni�ڳ������ҵ�������ǲ�����ǩ�ģ�����pw2��nni�ڳ������ҵ������tag80�ı�ǩ������pw3��nni�ڳ������ҵ������tag100�ı�ǩ
##PW VLAN����Ϊ���
#   <11>ɾ��NE1�豸�Ļ��ҵ��vpls����α�ߣ�PW3��������PW3��VLAN����Ϊ��ӣ����VID=200��������AC��ƥ��TPIDΪ0x9100������������Ϣ���ֲ���
#   <12>��NE1��root�˿ڷ��ʹ���VID 100��TPIDΪ0x8100����ƥ��������������۲�NE2��NE3��NE4��Ҷ�Ӷ˿ڽ��ս��
#   Ԥ�ڽ����NE3�յ�˫���ǩ�������������200���ڲ�100����NE2�յ�untag����������NE4�յ�tag80��������
#   <13>����NE1����NNI�˿�egree�����������
#   Ԥ�ڽ��������pw3��nni�ڳ������ҵ�������������ǩ�����200���ڲ�100��������pw2��nni�ڳ������ҵ������tag80�ı�ǩ������pw1��nni�ڳ������ҵ����������ǩ��
#   <14>NE1�豸������pw������SW/NMS����10�Σ���/Ӳ��������pw��������ȷ��Ч
#   <15>�������ã������豸���鿴��������ȷ�Ҷ�����Ч
#   <16>���û���˿ڽ���ģʽΪ���˿�+��Ӫ��VLAN+�ͻ�VLAN���£��ֱ���֤PW/AC��VLAN����ɾ������ӡ��޸ġ��������Ч
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_011_LOG.txt" a]
        set stdout $fd_log
        chan configure $fd_log -blocking 0 -buffering none;#������ģʽ ����flush
        log_file log\\GPN_PTN_011_LOG.txt
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_011_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
        
        file mkdir "debug"
        set fd_debug [open debug\\GPN_PTN_011_DEBUG.txt a]
        exp_internal -f debug\\GPN_PTN_011_DEBUG.txt 0
        chan configure $fd_debug -blocking 0 -buffering none;#������ģʽ ����flush
        
	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl
        ###����������
        array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
        array set dataArr2 {-srcMac "00:00:00:00:00:0c" -dstMac "00:00:00:00:00:cc" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "100" -pri "000"}
        array set dataArr3 {-srcMac "00:00:00:00:00:F2" -dstMac "00:00:00:00:F2:F2" -srcIp "192.85.1.3" -dstIp "192.0.0.3" -vid "100" -pri "000" -type "9100"}
        array set dataArr4 {-srcMac "00:00:00:00:00:26" -dstMac "00:00:00:00:F3:F3" -srcIp "192.85.1.4" -dstIp "192.0.0.4" -vid1 "800" -pri1 "000" -vid2 "500" -pri2 "000"}
        array set dataArr5 {-srcMac "00:00:00:00:00:dd" -dstMac "00:00:00:00:00:0d" -srcIp "192.85.1.5" -dstIp "192.0.0.5" -vid "100" -pri "000"}
        array set dataArr6 {-srcMac "00:00:00:00:04:05" -dstMac "00:00:00:00:01:05" -srcIp "192.85.1.6" -dstIp "192.0.0.6" -vid1 "800" -pri1 "000" -vid2 "500" -pri2 "000"}
        array set dataArr7 {-srcMac "00:00:00:00:00:0d" -dstMac "00:00:00:00:00:dd" -srcIp "192.85.1.7" -dstIp "192.0.0.7" -vid "100" -pri "000"}
        array set dataArr8 {-srcMac "00:00:00:00:01:05" -dstMac "00:00:00:00:04:05" -srcIp "192.85.1.8" -dstIp "192.0.0.8" -vid1 "800" -pri1 "000" -vid2 "500" -pri2 "000"}
        ###���ö�����Ϣ����
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        ###���÷���������
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
	set rateL0 91000000;#�շ�������ȡֵ��Сֵ��Χ
	set rateR0 106000000;#�շ�������ȡֵ���ֵ��Χ
	
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
	regsub {/} $GPNTestEth5 {_} GPNTestEth5_cap
	regsub {/} $GPNTestEth6 {_} GPNTestEth6_cap
	
	########################################################################################################
	#�������ܣ��û�����ģʽΪPORT+SVLAN+CVLAN��AC��PW�Ķ���
	#�������:       ifAc ��VLAN�������� AC/PW =1 ac����    =0 pw����
	#               �������� ��add/nochange/delete/modify
	#               lStream �����͵�������
	#����ֵ��flag =0 ҵ����֤��ȷ   =1ҵ����֤����
	#���ߣ������ 
	########################################################################################################
	proc SvlanCvlanActiveChange {fileId ifAc action caseId rateL rateR} {
		global gpnIp1
		global gpnIp2
		global gpnIp3
		global gpnIp4
		global GPNTestEth1
		global GPNTestEth2
		global GPNTestEth3
		global GPNTestEth4
		set flag 0
		
		incr capId
		#��������vlan����
		SendAndStat_ptn006 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
			$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $::anaFliFrameCfg1 $caseId
		#����ֻƥ��smac�ı���
		SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
			$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $::anaFliFrameCfg0 $caseId
		#����˫��vlan����
		SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
			$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt2 GPNPort2Cnt2 GPNPort3Cnt2 GPNPort4Cnt2 6 $::anaFliFrameCfg6 $caseId
		#����untag����
		SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
			$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 7 $::anaFliFrameCfg7 $caseId
		if {[string match $action "add"]} {
			#����3�㱨��
			SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
				$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
				$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt3 GPNPort2Cnt3 GPNPort3Cnt3 GPNPort4Cnt3 1 $::anaFliFrameCfg4 $caseId
		}
				
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		#NE1�Ľ���
		if {($ifAc == 0) && [string match $action "add"]} {
			if {$GPNPort1Cnt3(cnt24) < $rateL || $GPNPort1Cnt3(cnt24) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE1($gpnIp1)$GPNTestEth1\
					�յ�tag=800 800 500��������������Ϊ$GPNPort1Cnt3(cnt24)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE1($gpnIp1)$GPNTestEth1\
					�յ�tag=800 800 500��������������Ϊ$GPNPort1Cnt3(cnt24)����$rateL-$rateR\��Χ��" $fileId
			}
		} else {
			if {$GPNPort1Cnt2(cnt42) < $rateL || $GPNPort1Cnt2(cnt42) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE1($gpnIp1)$GPNTestEth1\
					�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort1Cnt2(cnt42)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE1($gpnIp1)$GPNTestEth1\
					�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort1Cnt2(cnt42)����$rateL-$rateR\��Χ��" $fileId
			}
		}
		#NE2����
		if {[string match $action "nochange"]} {
			if {$GPNPort2Cnt2(cnt12) < $rateL || $GPNPort2Cnt2(cnt12) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE2($gpnIp2)$GPNTestEth2\
					�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort2Cnt2(cnt12)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE2($gpnIp2)$GPNTestEth2\
					�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort2Cnt2(cnt12)����$rateL-$rateR\��Χ��" $fileId
			}
			if {$GPNPort2Cnt2(cnt10) < $rateL || $GPNPort2Cnt2(cnt10) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������NE2($gpnIp2)$GPNTestEth2\
					�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort2Cnt2(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������NE2($gpnIp2)$GPNTestEth2\
					�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort2Cnt2(cnt10)����$rateL-$rateR\��Χ��" $fileId
			}
		} else {
			if {$GPNPort2Cnt1(cnt50) < $rateL || $GPNPort2Cnt1(cnt50) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE2($gpnIp2)$GPNTestEth2\
					�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt50)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE2($gpnIp2)$GPNTestEth2\
					�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt50)����$rateL-$rateR\��Χ��" $fileId
			}
			if {$GPNPort2Cnt1(cnt71) < $rateL || $GPNPort2Cnt1(cnt71) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������NE2($gpnIp2)$GPNTestEth2\
					�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt71)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������NE2($gpnIp2)$GPNTestEth2\
					�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt71)����$rateL-$rateR\��Χ��" $fileId
			}
		}
		
		#NE3�Ľ���
		if {$GPNPort3Cnt0(cnt50) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE1($gpnIp1)$GPNTestEth1\���͵�������\
				NE3($gpnIp3)$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt50)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE1($gpnIp1)$GPNTestEth1\���͵�������\
				NE3($gpnIp3)$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt50)" $fileId
		}
		if {$GPNPort3Cnt0(cnt51) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE2($gpnIp2)$GPNTestEth2\���͵�������\
				NE3($gpnIp3)$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt51)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE2($gpnIp2)$GPNTestEth2\���͵�������\
				NE3($gpnIp3)$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt51)" $fileId
		}
		if { [string match $action "add"] || [string match $action "modify"]} {
			if {$GPNPort3Cnt2(cnt2) < $rateL || $GPNPort3Cnt2(cnt2) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������NE3($gpnIp3)$GPNTestEth3\
					�յ����tag=1000�ڲ�tag=500��������������Ϊ$GPNPort3Cnt2(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������NE3($gpnIp3)$GPNTestEth3\
					�յ����tag=1000�ڲ�tag=500��������������Ϊ$GPNPort3Cnt2(cnt2)����$rateL-$rateR\��Χ��" $fileId
			}
		} else {
			if {$GPNPort3Cnt2(cnt10) < $rateL || $GPNPort3Cnt2(cnt10) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������NE3($gpnIp3)$GPNTestEth3\
					�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort3Cnt2(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������NE3($gpnIp3)$GPNTestEth3\
					�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort3Cnt2(cnt10)����$rateL-$rateR\��Χ��" $fileId
			}
		}
		
		#NE4�Ľ���
		if {$GPNPort4Cnt0(cnt50) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE1($gpnIp1)$GPNTestEth1\���͵�������\
				NE4($gpnIp4)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt50)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE1($gpnIp1)$GPNTestEth1\���͵�������\
				NE4($gpnIp4)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt50)" $fileId
		}
		if {$GPNPort4Cnt0(cnt51) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE2($gpnIp2)$GPNTestEth2\���͵�������\
				NE4($gpnIp4)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt51)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2�������tag=800�ڲ�tag=500����֪������NE2($gpnIp2)$GPNTestEth2\���͵�������\
				NE4($gpnIp4)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt51)" $fileId
		}
		if {($ifAc==1) && [string match $action "add"]} {
			if {$GPNPort4Cnt3(cnt24) < $rateL || $GPNPort4Cnt3(cnt24) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������NE4($gpnIp4)$GPNTestEth3\
					�յ�tag=800 800 500��������������Ϊ$GPNPort4Cnt3(cnt24)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������NE4($gpnIp4)$GPNTestEth3\
				�յ�tag=800 800 500��������������Ϊ$GPNPort4Cnt3(cnt24))����$rateL-$rateR\��Χ��" $fileId
			}
		} else {
			if {$GPNPort4Cnt2(cnt10) < $rateL || $GPNPort4Cnt2(cnt10) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������NE4($gpnIp4)$GPNTestEth4\
					�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort4Cnt2(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������NE4($gpnIp4)$GPNTestEth4\
					�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort4Cnt2(cnt10)����$rateL-$rateR\��Χ��" $fileId
			}
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
        gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort1 hGPNPort1Stream2
        gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort1 hGPNPort1Stream7
        gwd::STC_Create_VlanTypeStream $fileId dataArr3 $hGPNPort1 hGPNPort1Stream3
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr4 $hGPNPort1 hGPNPort1Stream4
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr8 $hGPNPort1 hGPNPort1Stream8
        gwd::STC_Create_VlanStream $fileId dataArr5 $hGPNPort2 hGPNPort2Stream5
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr6 $hGPNPort2 hGPNPort2Stream6
        set hStreamList "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream3 $hGPNPort1Stream4 $hGPNPort1Stream7 $hGPNPort1Stream8 $hGPNPort2Stream5 $hGPNPort2Stream6"
        set hStreamList1 "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream3"
        set hStreamList2 "$hGPNPort1Stream7 $hGPNPort2Stream5"
        set hStreamList3 "$hGPNPort1Stream4 $hGPNPort1Stream8 $hGPNPort2Stream6"
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
	
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort5 txInfoArr hGPNPort5TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort5 rxInfoArr1 hGPNPort5RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort5 rxInfoArr2 hGPNPort5RxInfo2
        ###������������ 10%��Mbps
	stc::perform streamBlockActivate \
		-streamBlockList "$hStreamList" \
		-activate "false"
        foreach stream $hStreamList {
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
        set hGPNPortAnaFrameCfgFilList "$hGPNPort1AnaFrameCfgFil $hGPNPort2AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil"
        foreach hCfgFil $hGPNPortAnaFrameCfgFilList {
        	gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $anaFliFrameCfg2
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
                set hGPNPortCapList "$hGPNPort1Cap $hGPNPort2Cap $hGPNPort3Cap $hGPNPort4Cap"
                set hGPNPortCapAnalyzerList "$hGPNPort1CapAnalyzer $hGPNPort2CapAnalyzer $hGPNPort3CapAnalyzer $hGPNPort4CapAnalyzer"
        }
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-TREE AC PW�������Ի������ÿ�ʼ...\n"
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
	set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
	set lMatchType "$matchType1 $matchType2 $matchType3 $matchType4"
	set lDutType "$Gpn_type1 $Gpn_type2 $Gpn_type3 $Gpn_type4"
	set lIp "$gpnIp1 $gpnIp2 $gpnIp3 $gpnIp4"
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-TREE AC PW�������Ի�������ʧ�ܣ����Խ���" \
		"E-TREE AC PW�������Ի������óɹ�����������Ĳ���" "GPN_PTN_011"
        puts $fileId ""
        puts $fileId "===E-TREE AC PW�������Ի������ý���..."
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 ETREE���ܣ��û������ģʽΪ���˿�+��Ӫ��VLAN��AC VLAN������֤����\n"
	##AC VLAN����Ϊ����
	#   <1>����NE1��NE2/NE3/NE4��evp-treeҵ��,NNI����tag��ʽ����vlanIF,PW��AC��VLAN������Ϊ����
	#   <2>��NE1���˿ڷ��ʹ���untag tag100��TPIDΪ0x8100��tag100��TPIDΪ0x9100�� ��3�����������۲�NE2��NE4��Ҷ�Ӷ˿ڽ��ս��
	#   Ԥ�ڽ����ֻ�ɽ��յ�����tag100��TPIDΪ0x8100��������
	#   <3>����NE1��NNI�˿�egress������
	#   Ԥ�ڽ����Ϊ��VLAN TAG��ǩ����������mpls��ǩ���ģ����lsp��ǩ17���ڲ�pw��ǩ1000
	##AC VLAN����Ϊɾ��
	#   <4>�ڲ�ɾ��vpls������£�ɾ��NE2�豸�Ļ��ҵ��AC�����鿴����ɾ���ɹ���NE2��ҵ���жϣ��������ac������ΪAC��VLAN����Ϊɾ����(pwΪroot acΪleaf)����������Ϣ���ֲ���
	#   <5>��NE1��root�˿ڷ��ʹ���tag100��TPIDΪ0x8100����ƥ�����������۲�NE2/NE3/NE4��Ҷ�Ӷ˿ڽ��ս��
	#   Ԥ�ڽ����NE2���յ�untag��������NE4���յ�tag100����������
	#   <6>����NE1����NNI�˿�egree�����������
	#   Ԥ�ڽ����ҵ�������Ǵ�tag100�ı�ǩ��
	##AC VLAN����Ϊ�޸�
	#   <7>�ڲ�ɾ��vpls������£�ɾ��NE4�豸�Ļ��ҵ��AC��������AC��VLAN����Ϊ�޸ģ��޸�Ϊ VID=80��������������Ϣ���ֲ���
	#   <8>��NE1��root�˿ڷ��ʹ���VID 100��TPIDΪ0x8100����ƥ��������������۲�NE2/NE3/NE4��Ҷ�Ӷ˿ڽ��ս����
	#   Ԥ�ڽ����NE2���յ�untag����������NE4�˿ڽ��յ�vid80����������
	#   <8>����NE1����NNI�˿�egree�����������
	#   Ԥ�ڽ����ҵ�������Ǵ�tag100�ı�ǩ��
	##AC VLAN����Ϊ���
	#   <9>ɾ��NE2�豸��ר��ҵ��AC��������NE2AC��VLAN����Ϊ��ӣ����VID=100����ƥ��TPIDΪ9100��(pwΪroot acΪleaf)����������Ϣ���ֲ���
	#   <10>��NE1��root�˿ڷ��ʹ���VID 100��TPIDΪ0x8100����ƥ��������������۲�NE2/NE3/NE4��Ҷ�Ӷ˿ڽ��ս����
	#   Ԥ�ڽ����NE3�ɽ��յ�����˫���ǩ�������������200���ڲ�100����NE2���յ�untag��������;NE4�յ�tag80����������
	#   <11>����NE1����NNI�˿�egree�����������
	#   Ԥ�ڽ����ҵ�������Ǵ�tag100�ı�ǩ��
	#   <12>NE2��NE3��NE4�豸������ac������SW/NMS����10�Σ���/Ӳ��������ac��������ȷ��Ч
	#   <13>�������ã������豸���鿴��������ȷ�Ҷ�����Ч
        ###������ӿ����ò���
	set flag1_case1 0
	set flag2_case1 0
	set flag3_case1 0
	set flag4_case1 0
	set flag5_case1 0
	set flag6_case1 0
	set flag7_case1 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACģʽΪport+vlan����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
        if {[string match "L2" $Worklevel]} {
                set interface3 v100
                set interface4 v500
                set interface5 v800
                set interface6 v100
                set interface7 v500
                set interface8 v800
                set interface9 v100
                set interface10 v500
                set interface11 v800
                set interface12 v100
                set interface13 v500
                set interface14 v800
                set interface15 v4
                set interface16 v7
                set interface17 v4
                set interface18 v5
                set interface19 v5
                set interface20 v7
        } else {
        	set interface3 $GPNTestEth1.100
        	set interface4 $GPNTestEth1.500
        	set interface5 $GPNTestEth1.800
        	set interface6 $GPNTestEth2.100
        	set interface7 $GPNTestEth2.500
        	set interface8 $GPNTestEth2.800
        	set interface9 $GPNTestEth3.100
        	set interface10 $GPNTestEth3.500
        	set interface11 $GPNTestEth3.800
        	set interface12 $GPNTestEth4.100
        	set interface13 $GPNTestEth4.500
        	set interface14 $GPNTestEth4.800
        	set interface15 $GPNPort5.4
        	set interface16 $GPNPort12.7
        	set interface17 $GPNPort6.4
        	set interface18 $GPNPort7.5
        	set interface19 $GPNPort8.5
        	set interface20 $GPNPort11.7
        }
	set id 1
	foreach {port1 port2} $Portlist telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 {vid1 vid2} $Vlanlist {Ip1 Ip2} $Iplist \
			matchType $lMatchType role $RoleList {
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
		PTN_UNI_AddInter $telnet $matchType $Gpn_type $fileId $Worklevel "100" $eth
		gwd::GWVpls_AddInfo $telnet $matchType $Gpn_type $fileId "vpls$id" $id "etree" "flood" "false" "false" "false" "true" "2000" "" ""
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac100" "vpls$id" "" $eth "100" "0" $role "nochange" "1" "0" "0" "0x8100" "evc2"
		incr id
	}
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface15 $ip621 "17" "17" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $interface16 $ip641 "18" "18" "normal" "4"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $address614
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $interface15 $ip621 "20" "21" "normal" "3"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $address613
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "3000" "3000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface17 $ip612 "17" "17" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface18 $ip632 "21" "22" "0" 23 "normal"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface17 $ip612 "23" "20" "0" 21 "normal"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $interface19 $ip623 "22" "23" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $address631
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "3000" "3000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	
	gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $interface20 $ip614 "18" "18" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $address641
	gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "2000" "2000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	stc::perform streamBlockActivate \
		-streamBlockList "$hStreamList1 $hStreamList2" \
		-activate "true"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 1 "nochange" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag1_case1 1
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACģʽΪport+vlan����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACģʽΪport+vlan����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACģʽΪport+vlan����Ϊnochange������ҵ��  ���Խ���=====\n"
	incr $tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2��Ϊdelete����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac100"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac100" "vpls2" "" $GPNTestEth2 "100" "0" "leaf" "delete" "1" "0" "0" "0x8100" "evc2"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 1 "delete" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag2_case1 1
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2��Ϊdelete����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2��Ϊdelete����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2��Ϊdelete����Ϊnochange������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac100"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac100" "vpls3" "" $GPNTestEth3 "100" "0" "leaf" "modify" "800" "0" "0" "0x8100" "evc2"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 1 "modify" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag3_case1 1
	}
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify����Ϊnochange������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac100"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "2000" "2000" "" "nochange" "root" 1 0 "0x8100" "0x9100" "1"
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac100" "vpls4" "" $GPNTestEth4 "100" "0" "leaf" "add" "800" "0" "0" "0x8100" "evc2"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag4_case1 1
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA4�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������NMS���������ҵ��  ���Կ�ʼ=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitch $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitch $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitch $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[PTN_EtreeActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag5_case1 1
		}
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA5�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������NMS���������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������NMS���������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������NMS���������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������SW���������ҵ��  ���Կ�ʼ=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[PTN_EtreeActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag6_case1 1
		}
	}
	puts $fileId ""
	if {$flag6_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA6�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������SW���������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������SW���������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������SW���������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd�����������豸���������ҵ��  ���Կ�ʼ=====\n"
	for {set j 1} {$j<$cntdh} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_SaveCfg $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_SaveCfg $telnet4 $matchType4 $Gpn_type4 $fileId
		gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
		set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
		set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
		incr capId
		if {[PTN_EtreeActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag7_case1 1
		}
	}
	puts $fileId ""
	if {$flag7_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA7�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd�����������豸���������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd�����������豸���������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd�����������豸���������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase1 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 1���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 1���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 1 ETREE���ܣ��û������ģʽΪ���˿�+��Ӫ��VLAN��AC VLAN������֤����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2  ETREE���ܣ��û������ģʽΪ���˿�+��Ӫ��VLAN��PW VLAN������֤����\n"
	##PW VLAN����Ϊ����
	#   <1>ɾ��4̨�豸�������û��ҵ��vpls��AC����α�ߣ�ɾ���ɹ���ϵͳ���쳣
	#   <2>�ٴ�����4̨�豸��E-Treeҵ��PW��AC��VLAN������Ϊ���䣬ac�󶨵�vlanΪ100
	#   <3>��NE1��root�˿ڷ��ʹ���VID 100��TPIDΪ0x8100����ƥ��������������۲�NE2��NE4��Ҷ�Ӷ˿ڽ��ս��
	#   Ԥ�ڽ����NE2��NE3��NE4�ɽ��յ�tag100����������
	#   <4>����NE1����NNI�˿�egree�����������
	#   Ԥ�ڽ����ҵ�������Ǵ�tag100�ı�ǩ��
	##PW VLAN����Ϊɾ��
	#   <5>ɾ��NE1�豸�Ļ��ҵ��vpls����α�ߣ�PW1��������PW1��VLAN����Ϊɾ����(pwΪnone acΪnone)����������Ϣ���ֲ���
	#   <6>��NE1��root�˿ڷ��ʹ���VID 100��TPIDΪ0x8100����ƥ��������������۲�NE2��NE3��NE4��Ҷ�Ӷ˿ڽ��ս��
	#   Ԥ�ڽ����NE2�յ�untag����������Ne3��NE4�յ�tag100��������
	#   <7>����NE1����NNI�˿�egree�����������
	#   Ԥ�ڽ��������pw1��nni�ڳ������ҵ�������ǲ�����ǩ�ģ�����pw2��pw3��nni�ڳ������ҵ������tag100�ı�ǩ
	##PW VLAN����Ϊ�޸�
	#   <8>ɾ��NE1�豸�Ļ��ҵ��vpls����α�ߣ�PW2��������PW2��VLAN����Ϊ�޸ģ��޸�Ϊ VID=80��������������Ϣ���ֲ���
	#   <9>��NE1��root�˿ڷ��ʹ���VID 100��TPIDΪ0x8100����ƥ��������������۲�NE2��NE3��NE4��Ҷ�Ӷ˿ڽ��ս��
	#   Ԥ�ڽ����NE2�յ�untag����������NE4�յ�tag80����������NE3�յ�tag100��������
	#   <10>����NE1����NNI�˿�egree�����������
	#   Ԥ�ڽ��������pw1��nni�ڳ������ҵ�������ǲ�����ǩ�ģ�����pw2��nni�ڳ������ҵ������tag80�ı�ǩ������pw3��nni�ڳ������ҵ������tag100�ı�ǩ
	##PW VLAN����Ϊ���
	#   <11>ɾ��NE1�豸�Ļ��ҵ��vpls����α�ߣ�PW3��������PW3��VLAN����Ϊ��ӣ����VID=200��������AC��ƥ��TPIDΪ0x9100������������Ϣ���ֲ���
	#   <12>��NE1��root�˿ڷ��ʹ���VID 100��TPIDΪ0x8100����ƥ��������������۲�NE2��NE3��NE4��Ҷ�Ӷ˿ڽ��ս��
	#   Ԥ�ڽ����NE3�յ�˫���ǩ�������������200���ڲ�100����NE2�յ�untag����������NE4�յ�tag80��������
	#   <13>����NE1����NNI�˿�egree�����������
	#   Ԥ�ڽ��������pw3��nni�ڳ������ҵ�������������ǩ�����200���ڲ�100��������pw2��nni�ڳ������ҵ������tag80�ı�ǩ������pw1��nni�ڳ������ҵ����������ǩ��
	#   <14>NE1�豸������pw������SW/NMS����10�Σ���/Ӳ��������pw��������ȷ��Ч
	#   <15>�������ã������豸���鿴��������ȷ�Ҷ�����Ч
	#   <16>���û���˿ڽ���ģʽΪ���˿�+��Ӫ��VLAN+�ͻ�VLAN���£��ֱ���֤PW/AC��VLAN����ɾ������ӡ��޸ġ��������Ч
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0
	set flag5_case2 0
	set flag6_case2 0
	set flag7_case2 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf���û�����ģʽΪport+vlan �����豸PW����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "2000" "2000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	set id 1
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType role $RoleList {
		gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac100"
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac100" "vpls$id" "" $eth "100" "0" $role "nochange" "1" "0" "0" "0x8100" "evc2"
		incr id
	}
	incr capId
	if {[PTN_EtreeActiveChange $fileId 0 "nochange" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag1_case2 1
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA8�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf���û�����ģʽΪport+vlan �����豸PW����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf���û�����ģʽΪport+vlan �����豸PW����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf���û�����ģʽΪport+vlan �����豸PW����Ϊnochange������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 0 "delete" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag2_case2 1
	}
	puts $fileId ""
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA9�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete����Ϊnochange������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "3000" "3000" "" "modify" "none" 800 0 "0x8100" "0x8100" "3"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 0 "modify" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag3_case2 1
	}
	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB1�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify����Ϊnochange������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac100"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "add" "root" 800 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac100" "vpls2" "" $GPNTestEth2 "100" "0" "leaf" "nochange" "1" "0" "0" "0x9100" "evc2"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag4_case2 1
	}
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB2�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������NMS���������ҵ��  ���Կ�ʼ=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitch $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitch $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitch $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[PTN_EtreeActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag5_case2 1
		}
	}
	puts $fileId ""
	if {$flag5_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB3�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������NMS���������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������NMS���������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������NMS���������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������SW���������ҵ��  ���Կ�ʼ=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[PTN_EtreeActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag6_case2 1
		}
	}
	puts $fileId ""
	if {$flag6_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB4�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������SW���������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������SW���������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������SW���������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange�����������豸���������ҵ��  ���Կ�ʼ=====\n"
	for {set j 1} {$j<$cntdh} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_SaveCfg $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_SaveCfg $telnet4 $matchType4 $Gpn_type4 $fileId
		gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
		set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
		set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
		incr capId
		if {[PTN_EtreeActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag7_case2 1
		}
	}
	puts $fileId ""
	if {$flag7_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB5�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange�����������豸���������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange�����������豸���������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange�����������豸���������ҵ��  ���Խ���=====\n"
	incr $tcId
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase2 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 2���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 2���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 2 ETREE���ܣ��û������ģʽΪ���˿�+��Ӫ��VLAN��PW VLAN������֤����   ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3  ETREE���ܣ��û������ģʽΪPORT+SVLAN+CVLAN��AC VLAN������֤����\n"
	set flag1_case3 0
	set flag2_case3 0
	set flag3_case3 0
	set flag4_case3 0
	set flag5_case3 0
	set flag6_case3 0
	set flag7_case3 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACģʽΪport+svlan+cvlan����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "3000" "3000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	
	set id 1
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType role $RoleList {
		gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac100"
		PTN_UNI_AddInter $telnet $matchType $Gpn_type $fileId $Worklevel "800" $eth
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac800" "vpls$id" "" $eth "800" "500" $role "nochange" "1" "0" "0" "0x8100" "evc2"
		incr id
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hStreamList1 $hStreamList2" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hStreamList3" \
		-activate "true"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 1 "nochange" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag1_case3 1
	}
	puts $fileId ""
	if {$flag1_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB6�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACģʽΪport+svlan+cvlan����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACģʽΪport+svlan+cvlan����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACģʽΪport+svlan+cvlan����Ϊnochange������ҵ��  ���Խ���=====\n"
	incr $tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2��Ϊdelete����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "500" "leaf" "delete" "1" "0" "0" "0x8100" "evc2"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 1 "delete" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag2_case3 1
	}
	puts $fileId ""
	if {$flag2_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB7�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2��Ϊdelete����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2��Ϊdelete����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2��Ϊdelete����Ϊnochange������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac800" "vpls3" "" $GPNTestEth3 "800" "500" "leaf" "modify" "1000" "0" "0" "0x8100" "evc2"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 1 "modify" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag3_case3 1
	}
	puts $fileId ""
	if {$flag3_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB8�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify����Ϊnochange������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "2000" "2000" "" "nochange" "root" 1 0 "0x8100" "0x9100" "1"
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac800" "vpls4" "" $GPNTestEth4 "800" "500" "leaf" "add" "800" "0" "0" "0x8100" "evc2"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag4_case3 1
	}
	puts $fileId ""
	if {$flag4_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB9�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������NMS���������ҵ��  ���Կ�ʼ=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitch $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitch $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitch $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[SvlanCvlanActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag5_case3 1
		}
	}
	puts $fileId ""
	if {$flag5_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC1�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������NMS���������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������NMS���������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������NMS���������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������SW���������ҵ��  ���Կ�ʼ=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[SvlanCvlanActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag6_case3 1
		}
	}
	puts $fileId ""
	if {$flag6_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC2�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������SW���������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������SW���������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������SW���������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd�����������豸���������ҵ��  ���Կ�ʼ=====\n"
	for {set j 1} {$j<$cntdh} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_SaveCfg $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_SaveCfg $telnet4 $matchType4 $Gpn_type4 $fileId
		gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
		set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
		set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
		incr capId
		if {[SvlanCvlanActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag7_case3 1
		}
	}
	puts $fileId ""
	if {$flag7_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC3�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd�����������豸���������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd�����������豸���������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd�����������豸���������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase3 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 3���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 3���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 3  ETREE���ܣ��û������ģʽΪPORT+SVLAN+CVLAN��AC VLAN������֤����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4  ETREE���ܣ��û������ģʽΪPORT+SVLAN+CVLAN��PW VLAN������֤����\n"
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set flag5_case4 0
	set flag6_case4 0
	set flag7_case4 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan �����豸PW����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "2000" "2000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	set id 1
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType role $RoleList {
		gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac800"
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac800" "vpls$id" "" $eth "800" "500" $role "nochange" "1" "0" "0" "0x8100" "evc2"
		incr id
	}
	incr capId
	if {[SvlanCvlanActiveChange $fileId 0 "nochange" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag1_case4 1
	}
	puts $fileId ""
	if {$flag1_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC4�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan �����豸PW����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan �����豸PW����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan �����豸PW����Ϊnochange������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��NE1��PW12����Ϊdelete����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 0 "delete" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag2_case4 1
	}
	puts $fileId ""
	if {$flag2_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC5�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��NE1��PW12����Ϊdelete����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��NE1��PW12����Ϊdelete����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��NE1��PW12����Ϊdelete����Ϊnochange������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��NE1��PW12����Ϊdelete PW13Ϊmodify����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "3000" "3000" "" "modify" "none" 1000 0 "0x8100" "0x8100" "3"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 0 "modify" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag3_case4 1
	}
	puts $fileId ""
	if {$flag3_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC6�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��NE1��PW12����Ϊdelete PW13Ϊmodify����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��NE1��PW12����Ϊdelete PW13Ϊmodify����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��NE1��PW12����Ϊdelete PW13Ϊmodify����Ϊnochange������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "add" "root" 800 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "500" "leaf" "nochange" "1" "0" "0" "0x9100" "evc2"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag4_case4 1
	}
	puts $fileId ""
	if {$flag4_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC7�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������NMS���������ҵ��  ���Կ�ʼ=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitch $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitch $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitch $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[SvlanCvlanActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag5_case4 1
		}
	}
	puts $fileId ""
	if {$flag5_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC8�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������NMS���������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������NMS���������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������NMS���������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������SW���������ҵ��  ���Կ�ʼ=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW�̣���������" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[SvlanCvlanActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag6_case4 1
		}
	}
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC9�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������SW���������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC9�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������SW���������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������SW���������ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange�����������豸���������ҵ��  ���Կ�ʼ=====\n"
	for {set j 1} {$j<$cntdh} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_SaveCfg $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_SaveCfg $telnet4 $matchType4 $Gpn_type4 $fileId
		gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
		set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
		set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
		incr capId
		if {[SvlanCvlanActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag7_case4 1
		}
	}
	puts $fileId ""
	if {$flag7_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD1�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange�����������豸���������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD1�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange�����������豸���������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange�����������豸���������ҵ��  ���Խ���=====\n"
	incr $tcId
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
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
	puts $fileId "Test Case 4 ETREE���ܣ��û������ģʽΪPORT+SVLAN+CVLAN��PW VLAN������֤����   ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===�ָ���ʼ������...\n"
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"] 
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort5.4 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort12.7 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.100 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.800  $matchType1 $Gpn_type1 $telnet1]
	
	lappend flagDel [gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls2"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"] 
	lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort7.5 $ip632 "21" "22" "0" 23 "normal"]
	lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort6.4 $ip612 "23" "20" "0" 21 "normal"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort6.4 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort7.5 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth2.100 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth2.800 $matchType2 $Gpn_type2 $telnet2]
	
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort8.5 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort9.6 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.100 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.800 $matchType3 $Gpn_type3 $telnet3]
	
	lappend flagDel [gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls4"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"] 
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort10.6 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort11.7 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth4.100 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth4.800 $matchType4 $Gpn_type4 $telnet4]
	
	if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
		foreach port $portList11 {
			lappend flagDel [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "enable" "disable"]
		}
		foreach port $portList22 {
			lappend flagDel [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "enable" "disable"]
		}
		foreach port $portList33 {
			lappend flagDel [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "enable" "disable"]
		}
		foreach port $portList44 {
			lappend flagDel [gwd::GWL2_AddPort $telnet4 $matchType4 $Gpn_type4 $fileId $port "enable" "disable"]
		}
	}

	if {[string match "L2" $Worklevel]}  {
        	foreach {port1 port2} $Portlist telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType {
        		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port1 "none"]
        		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port2 "none"]
        	}
	}
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_011"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_011"
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_011����Ŀ�ģ�E-TREE��AC PW��������\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1==1 || $flagCase2==1 || $flagCase3==1 || $flagCase4==1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_011���Խ��" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4���Խ��" $fileId
	gwd::GWpublic_print [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}] "���Խ��������ûָ�" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽΪport+vlan����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2��Ϊdelete����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������ҵ��" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������NMS���������ҵ��" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������SW���������ҵ��" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag7_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+vlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd�����������豸���������ҵ��" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf���û�����ģʽΪport+vlan �����豸PW����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FB1 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������NMS���������ҵ��" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������SW���������ҵ��" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag7_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+vlan��NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange�����������豸���������ҵ��" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACģʽΪport+svlan+cvlan����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag2_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2��Ϊdelete����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag3_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag4_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������ҵ��" $fileId
	gwd::GWpublic_print "== FC1 == [expr {($flag5_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������NMS���������ҵ��" $fileId
	gwd::GWpublic_print "== FC2 == [expr {($flag6_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd������SW���������ҵ��" $fileId
	gwd::GWpublic_print "== FC3 == [expr {($flag7_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACģʽ��port+svlan+cvlan��AC������NE2Ϊdelete NE3Ϊmodify NE4Ϊadd�����������豸���������ҵ��" $fileId
	gwd::GWpublic_print "== FC4 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan �����豸PW����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FC5 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��NE1��PW12����Ϊdelete����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FC6 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��NE1��PW12����Ϊdelete PW13Ϊmodify����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FC7 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������ҵ��" $fileId
	gwd::GWpublic_print "== FC8 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������NMS���������ҵ��" $fileId
	gwd::GWpublic_print "== FC9 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange������SW���������ҵ��" $fileId
	gwd::GWpublic_print "== FD1 == [expr {($flag7_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf���û�����ģʽΪport+svlan+cvlan��PW������NE1��PW12����Ϊdelete PW13Ϊmodify NE2��PW21Ϊadd ����Ϊnochange�����������豸���������ҵ��" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_011"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_011_REPORT.txt" "report\\NOK_GPN_PTN_011_REPORT.txt"
	file rename "log\\GPN_PTN_011_LOG.txt" "log\\NOK_GPN_PTN_011_LOG.txt"
} else {
	file rename "report\\GPN_PTN_011_REPORT.txt" "report\\OK_GPN_PTN_011_REPORT.txt"
	file rename "log\\GPN_PTN_011_LOG.txt" "log\\OK_GPN_PTN_011_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}

