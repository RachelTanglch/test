#!/bin/sh
# GPN_PTN_002_2.tcl \
exec tclsh "$0" ${1+"$@"}
#�������ƣ�ptn002_2
#-----------------------------------------------------------------------------------------------------------------------------------
#����Ŀ�ģ�E-LINE�Ĺ���
#3-PW/AC vlan������֤
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
#   <1>��̨�豸������NNI�˿�(GE�˿�)ͨ����̫���ӿ���ʽ������NNI�˿�(GE�˿�)��untag��ʽ���뵽VLANIF��
##AC VLAN����Ϊ����
#   <2>����NE1��A�˿ڵ�NE2��B�˿�֮��һ��E-LINEҵ��
#      ����NE1��LSP1���ǩ100������ǩ100��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100���û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ+��Ӫ��VLAN���˿�ģʽ����Ӫ��VLANΪ VLAN 50��
#      ����NE2��LSP1���ǩ100������ǩ100��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100���û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ���˿�ģʽ��
#   <3>NE1��NE2�û�������undo vlan check
#   <4>��NE1�˿�A���ʹ���untag/tag50��TPIDΪ0x8100��/tag50��TPIDΪ0x9100��/tag60 �������������۲�NE2�Ķ˿�B���ս��
#   Ԥ�ڽ����ֻ�ɽ��յ�����tag50��TPIDΪ0x8100��������
#   <5>����NE1��NNI�˿�egress������
#   Ԥ�ڽ����������Ϊ����VLAN TAG��ǩ����������mpls��ǩ���ģ����lsp��ǩ100���ڲ�pw��ǩ1000
##AC VLAN����Ϊɾ��
#   <6>ɾ��NE2�豸��ר��ҵ��AC��������ΪAC��VLAN����Ϊɾ��������������Ϣ���ֲ���
#   <7>��NE1�˿�A���ʹ���tag50��TPIDΪ0x8100����ƥ�����������۲�NE2�Ķ˿�B���ս����
#   Ԥ�ڽ����B�ɽ��յ�untag����������NE1�˿�A����untag/tag50��TPIDΪ0x9100��/tag100���������۲�NE2�Ķ˿�B���ս����δ�յ�������
##AC VLAN����Ϊ�޸�
#   <8>ɾ��NE2�豸��ר��ҵ��AC��������AC��VLAN����Ϊ�޸ģ��޸�Ϊ VID=80��������������Ϣ���ֲ��� 
#   <9>��NE1�˿�A���ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2�Ķ˿�B���ս����
#   Ԥ�ڽ����B�ɽ��յ�����VID 80����������NE1�˿�A����untag/tag50��TPIDΪ0x9100��/ tag100���������۲�NE2�Ķ˿�B���ս����δ�յ�������
##AC VLAN����Ϊ���
#   <10>ɾ��NE2�豸��ר��ҵ��AC����α�ߣ�PW1��������PW1��ƥ��TPIDΪ0x9100������AC��VLAN����Ϊ��ӣ����VID=100������������Ϣ���ֲ���
#   <11>��NE1�˿�A���ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2�Ķ˿�B���ս��;
#   Ԥ�ڽ����B�ɽ��յ�����˫���ǩ�������������100���ڲ�50������NE1�˿�A����untag/tag50��TPIDΪ0x9100��/tag100���������۲�NE2�Ķ˿�B���ܽ����δ�յ�������
#2���Test Case 2���Ի���
##PW VLAN����Ϊ����
#   <1>ɾ��NE1��NE2�豸��������ר��ҵ��AC����α�ߣ�PW1����ɾ���ɹ���ϵͳ���쳣
#   <2>����NE1��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100���û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ+��Ӫ��VLAN���˿�ģʽ����Ӫ��VLANΪ VLAN 50��
#      ����NE2��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100���û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ���˿�ģʽ��
#   <3>NE1��NE2�û�������undo vlan check
#   <4>��NE1�˿�A���ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2�Ķ˿�B���ս��;
#   Ԥ�ڽ����B�ɽ��յ�����VID 50����������NE1�˿�A����untag/tag50��TPIDΪ0x9100��/tag100���������۲�NE2�Ķ˿�B���ܽ����δ�յ�������
##PW VLAN����Ϊɾ��
#   <5>ɾ��NE1�豸��ר��ҵ��AC����α�ߣ�PW1��������PW1��VLAN����Ϊɾ��������������Ϣ���ֲ���
#   <6>��NE1�˿�A���ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2�Ķ˿�B���ܽ��
#   Ԥ�ڽ����B�ɽ��յ�untag����������NE1�˿�A����untag/tag50��TPIDΪ0x9100��/tag100���������۲�NE2�Ķ˿�B���ܽ����δ�յ�������
##PW VLAN����Ϊ�޸�
#   <7>ɾ��NE1�豸��ר��ҵ��AC����α�ߣ�PW1��������PW1��VLAN����Ϊ�޸ģ��޸�Ϊ VID=80��������������Ϣ���ֲ��� 
#   <8>��NE1�˿�A���ʹ���VID 50��ƥ��������������۲�NE2�Ķ˿�B���ܽ��;
#   Ԥ�ڽ����B�ɽ��յ�����VID 80����������NE1�˿�A����untag ��tag100���������۲�NE2�Ķ˿�B���ܽ����δ�յ�������
##PW VLAN����Ϊ���
#   <9>ɾ��NE1�豸��ר��ҵ��AC����α�ߣ�PW1��������PW1��VLAN����Ϊ��ӣ����VID=100��������AC��ƥ��TPIDΪ0x9100������������Ϣ���ֲ���
#   <10>��NE1�˿�A���ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2�Ķ˿�B���ܽ��
#   Ԥ�ڽ����B�ɽ��յ�����˫���ǩ�������������100���ڲ�50������NE1�˿�A����untag/tag50��TPIDΪ0x9100��/tag100���������۲�NE2�Ķ˿�B���ܽ����δ�յ�������
#3���Test Case 3���Ի���
#   <1>��UNI�˿ڸ���ΪFE�˿ڣ������������䣬�ظ����ϲ���
#   <2>��NNI�˿ڸ���Ϊ10GE�˿ڣ�UNI�˿�ΪFE/GE�˿ڣ������������䣬�ظ����ϲ���
#   <3>��NNI�˿ڸ���ΪLAG�ӿڣ�UNI�˿�ΪFE/GE�˿ڣ������������䣬�ظ����ϲ���
#   <4>���û���˿ڽ���ģʽΪ���˿�+��Ӫ��VLAN+�ͻ�VLAN���£��ֱ���֤PW/AC��VLAN����ɾ������ӡ��޸ġ��������Ч
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
        close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_002_2_LOG.txt" a]
        set stdout $fd_log
        log_file log\\GPN_PTN_002_2_LOG.txt
        chan configure $stdout -blocking 0 -buffering none;#������ģʽ ����flush
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_002_2_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
        
        file mkdir "debug"
        set fd_debug [open debug\\GPN_PTN_002_2_DEBUG.txt a]
        exp_internal -f debug\\GPN_PTN_002_2_DEBUG.txt 0
        chan configure $fd_debug -blocking 0 -buffering none;#������ģʽ ����flush
        
        source test\\PTN_VarSet.tcl
        source test\\PTN_Mode_Function.tcl

        array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
        array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "50" -pri "000"}
        array set dataArr3 {-srcMac "00:00:00:00:00:03" -dstMac "00:00:00:00:00:33" -srcIp "192.85.1.3" -dstIp "192.0.0.3" -vid "50" -pri "000" -type "9100"}
        array set dataArr4 {-srcMac "00:00:00:00:00:04" -dstMac "00:00:00:00:00:44" -srcIp "192.85.1.4" -dstIp "192.0.0.4" -vid "60" -pri "000"}
        array set dataArr5 {-srcMac "00:00:00:00:00:05" -dstMac "00:00:00:00:00:55" -srcIp "192.85.1.5" -dstIp "192.0.0.5"}
        array set dataArr6 {-srcMac "00:00:00:00:00:06" -dstMac "00:00:00:00:00:66" -srcIp "192.85.1.6" -dstIp "192.0.0.6" -vid "50" -pri "000"}
        array set dataArr7 {-srcMac "00:00:00:00:00:07" -dstMac "00:00:00:00:00:77" -srcIp "192.85.1.7" -dstIp "192.0.0.7" -vid "50" -pri "000" -type "9100"}
        array set dataArr8 {-srcMac "00:00:00:00:00:08" -dstMac "00:00:00:00:00:88" -srcIp "192.85.1.8" -dstIp "192.0.0.8" -vid "60" -pri "000"}
        array set dataArr9 {-srcMac "00:00:00:00:00:09" -dstMac "00:00:00:00:00:99" -srcIp "192.85.1.9" -dstIp "192.0.0.9" -vid "100" -pri "000"}
        array set dataArr10 {-srcMac "00:00:00:00:00:0a" -dstMac "00:00:00:00:00:aa" -srcIp "192.85.1.10" -dstIp "192.0.0.10" -vid1 "50" -pri1 "000" -vid2 "30" -pri2 "000"}
        array set dataArr11 {-srcMac "00:00:00:00:00:0b" -dstMac "00:00:00:00:00:bb" -srcIp "192.85.1.11" -dstIp "192.0.0.11" -vid1 "50" -pri1 "000" -type1 "9100" -vid2 "30" -pri2 "000" -type2 "9100"}
        array set dataArr12 {-srcMac "00:00:00:00:00:0c" -dstMac "00:00:00:00:00:cc" -srcIp "192.85.1.12" -dstIp "192.0.0.12" -vid1 "50" -pri1 "000" -vid2 "20" -pri2 "000"}
        #���ö�����Ϣ����
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        
        #���÷���������
        set GenCfg {-SchedulingMode RATE_BASED}
        
        #���ù��˷���������
        #Vlan0-ID smac
        set anaFliFrameCfg1 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><vlans name="anon_13224"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        
        #smac
        set anaFliFrameCfg0 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        
        #Vlan0-ID Vlan1-ID
        set anaFliFrameCfg4 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5580"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        
        #Mpls0-Label  Mpls1-Label
        set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
        
        #Vlan0-ID   Mpls0-Exp   Mpls1-s
        set anaFliFrameCfg3 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4647"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><exp override="true"  filterMinValue="0" filterMaxValue="111">111</exp></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><sBit override="true"  filterMinValue="0" filterMaxValue="1">1</sBit></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}

        set rateL 9500000;#�շ�������ȡֵ��Сֵ��Χ
        set rateR 10500000;#�շ�������ȡֵ���ֵ��Χ
        set rateL1 10000000 
        set rateR1 12500000
        
        set flagResult 0
        set flagCase1 0   ;#Test case 1��־λ 
        set flagCase2 0   ;#Test case 2��־λ
        set flagCase3 0   ;#Test case 3��־λ 
        set lFailFile ""
        set FLAGF 0
        
        set tcId 0
        set capId 0
        set cfgId 0
	#Ϊ���Խ���Ԥ������
	for {set i 0} {$i < 80} {incr i} {
	    puts $fileId "                                                                                                                                                                                                                "	
	}
	regsub {/} $GPNTestEth2 {_} GPNTestEth2_cap
	regsub {/} $GPNTestEth3 {_} GPNTestEth3_cap
	regsub {/} $GPNTestEth4 {_} GPNTestEth4_cap
	
	
        puts $fileId "��¼�����豸...\n"
        puts $fileId "\n=====��¼�����豸1====\n"
        set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
        puts $fileId "\n=====��¼�����豸3====\n"
        set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	#���ڵ��������豸�õ��ı���------
	set lSpawn_id "$telnet1 $telnet3"
	set lMatchType "$matchType1 $matchType3"
	set lDutType "$Gpn_type1 $Gpn_type3"
	set lIp "$gpnIp1 $gpnIp3"
	#------���ڵ��������豸�õ��ı���
        puts $fileId "\n**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "�������Թ���...\n"
        set hPtnProject [stc::create project]
        set lPortAttribute "$GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3 \"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\""
        	
        gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
        lassign $hPortList hGPNPort2 hGPNPort3 hGPNPort4
	
        #������������
        gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort3 hGPNPort3Stream1
        gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort3 hGPNPort3Stream2
        gwd::STC_Create_VlanTypeStream $fileId dataArr3 $hGPNPort3 hGPNPort3Stream3
        gwd::STC_Create_VlanStream $fileId dataArr4 $hGPNPort3 hGPNPort3Stream4
        gwd::STC_Create_Stream $fileId dataArr5 $hGPNPort4 hGPNPort4Stream5
        gwd::STC_Create_VlanStream $fileId dataArr6 $hGPNPort4 hGPNPort4Stream6
        gwd::STC_Create_VlanTypeStream $fileId dataArr7 $hGPNPort4 hGPNPort4Stream7
        gwd::STC_Create_VlanStream $fileId dataArr8 $hGPNPort4 hGPNPort4Stream8
        gwd::STC_Create_VlanStream $fileId dataArr9 $hGPNPort3 hGPNPort3Stream9
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr10 $hGPNPort3 hGPNPort3Stream10
        gwd::STC_Create_DoubleVlanType_Stream $fileId dataArr11 $hGPNPort3 hGPNPort3Stream11
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr12 $hGPNPort3 hGPNPort3Stream12
        set lHStream "$hGPNPort3Stream1 $hGPNPort3Stream2 $hGPNPort3Stream3 $hGPNPort3Stream4 $hGPNPort4Stream5 $hGPNPort4Stream6\
        	$hGPNPort4Stream7 $hGPNPort4Stream8 $hGPNPort3Stream9 $hGPNPort3Stream10 $hGPNPort3Stream11 $hGPNPort3Stream12"
        stc::perform streamBlockActivate -streamBlockList $lHStream -activate "false"

        ##��ȡ�������ͷ�����ָ��
        gwd::Get_Generator $hGPNPort2 hGPNPort2Gen
        gwd::Get_Analyzer $hGPNPort2 hGPNPort2Ana
        gwd::Get_Generator $hGPNPort3 hGPNPort3Gen
        gwd::Get_Analyzer $hGPNPort3 hGPNPort3Ana
        gwd::Get_Generator $hGPNPort4 hGPNPort4Gen
        gwd::Get_Analyzer $hGPNPort4 hGPNPort4Ana
        ##�����շ���Ϣ
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort2 txInfoArr hGPNPort2TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort2 rxInfoArr1 hGPNPort2RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort2 rxInfoArr2 hGPNPort2RxInfo2
	
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort3 txInfoArr hGPNPort3TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort3 rxInfoArr1 hGPNPort3RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort3 rxInfoArr2 hGPNPort3RxInfo2
	
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort4 txInfoArr hGPNPort4TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort4 rxInfoArr1 hGPNPort4RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort4 rxInfoArr2 hGPNPort4RxInfo2
        #������������ 10%��Mbps
        stc::config [stc::get $hGPNPort3Stream1 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream2 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream3 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream4 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream5 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream6 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream7 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream8 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream9 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream10 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream11 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream12 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::apply 
        #��ȡ����������ָ��
        gwd::Get_GeneratorCfgObj $hGPNPort2Gen hGPNPort2GenCfg
        gwd::Cfg_GeneratorCfgObj $hGPNPort2GenCfg $GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort3Gen hGPNPort3GenCfg
        gwd::Cfg_GeneratorCfgObj $hGPNPort3GenCfg $GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort4Gen hGPNPort4GenCfg
        gwd::Cfg_GeneratorCfgObj $hGPNPort4GenCfg $GenCfg
        #���������ù�������Ĭ�Ϲ���tag
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort2Ana hGPNPort2AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort3Ana hGPNPort3AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1	
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
        if {$cap_enable} {
          	#��ȡ������capture������ص�ָ��
          	gwd::Get_Capture $hGPNPort2 hGPNPort2Cap
          	gwd::Get_Capture $hGPNPort3 hGPNPort3Cap
          	gwd::Get_Capture $hGPNPort4 hGPNPort4Cap
          	gwd::Create_FilterAnalyzer $hGPNPort2Cap hGPNPort2CapFilter hGPNPort2CapAnalyzer
          	gwd::Create_FilterAnalyzer $hGPNPort3Cap hGPNPort3CapFilter hGPNPort3CapAnalyzer
          	gwd::Create_FilterAnalyzer $hGPNPort4Cap hGPNPort4CapFilter hGPNPort4CapAnalyzer
          	array set capArr {capMode "REGULAR_MODE" capSource "Tx_Rx_MODE"}	
        }
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===ELINEҵ��AC PW�������Ի������ÿ�ʼ...\n"
	set cfgFlag 0
        ##������ӿ����ò���
        if {[string match "L2" $Worklevel]} {
        	set interface10 v10
        	set interface11 v10
        	set interface12 v50
        	set interface13 v1001
        } else {
        	set interface10 $GPNPort6.10
        	set interface11 $GPNPort5.10
        	set interface12 $GPNTestEth3.50
        	set interface13 $GPNTestEth3.1001
        }
        set ip1 192.1.1.1
        set ip2 192.1.1.2
        set address1 10.1.1.1
        set address2 10.1.1.2

	set portList1 "$GPNPort5 $GPNTestEth2 $GPNTestEth3"
	foreach port $portList1 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
		}
	}
	set rebootSlotList1 [gwd::GWpulic_getWorkCardList $portList1]
	gwd::GWpublic_print "OK" "��ȡ�豸NE1($gpnIp1)ҵ��忨��λ��$rebootSlotList1" $fileId
	if {[string match "L2" $Worklevel]} {
        	lappend cfgFlag [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "enable"]
	}
        lappend cfgFlag [PTN_NNI_AddInterIp $fileId $Worklevel $interface11 $ip1 $GPNPort5 $matchType1 $Gpn_type1 $telnet1]
        lappend cfgFlag [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "50" $GPNTestEth3]  
        lappend cfgFlag [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "1001" $GPNTestEth3]
        lappend cfgFlag [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $interface11 $ip2 "100" "100" "normal" "1"] 
        lappend cfgFlag [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $address1]
        lappend cfgFlag [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]
        lappend cfgFlag [gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]

	set portList3 "$GPNPort6 $GPNTestEth4"
	foreach port $portList3 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "disable" "enable"]
		}
	}
	set rebootSlotList3 [gwd::GWpulic_getWorkCardList $portList3]
	gwd::GWpublic_print "OK" "��ȡ�豸NE3($gpnIp3)ҵ��忨��λ��$rebootSlotList3" $fileId
	if {[string match "L2" $Worklevel]} {
		lappend cfgFlag [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort6 "enable"]
        	lappend cfgFlag [gwd::GWpublic_CfgVlanCheck  $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "disable"]
	}
        lappend cfgFlag [PTN_NNI_AddInterIp $fileId $Worklevel $interface10 $ip2 $GPNPort6 $matchType3 $Gpn_type3 $telnet3]
        lappend cfgFlag [gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" $interface10 $ip1 "100" "100" "normal" "2"]
        lappend cfgFlag [gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" $address2]
        lappend cfgFlag [gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
        lappend cfgFlag [gwd::GWpublic_showTunnelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "ELINEҵ��AC PW�������Ի�������ʧ�ܣ����Խ���" \
		"ELINEҵ��AC PW�������Ի������óɹ�����������Ĳ���" "GPN_PTN_002_2"
	puts $fileId ""
	puts $fileId "===ELINEҵ��AC PW�������Ի������ý���..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId ""
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 $porttype4\�˿�ELineҵ��AC��������\n"
        #   <1>��̨�豸������NNI�˿�(GE�˿�)ͨ����̫���ӿ���ʽ������NNI�˿�(GE�˿�)��untag��ʽ���뵽VLANIF��
        ##AC VLAN����Ϊ����
        #   <2>����NE1��A�˿ڵ�NE2��B�˿�֮��һ��E-LINEҵ��
        #      ����NE1��LSP1���ǩ100������ǩ100��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100���û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ+��Ӫ��VLAN���˿�ģʽ����Ӫ��VLANΪ VLAN 50��
        #      ����NE2��LSP1���ǩ100������ǩ100��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100���û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ���˿�ģʽ��
        #   <3>NE2�û�������undo vlan check
        #   <4>��NE1�˿�A���ʹ���untag/tag50��TPIDΪ0x8100��/tag50��TPIDΪ0x9100��/tag60 �������������۲�NE2�Ķ˿�B���ս��
        #   Ԥ�ڽ����ֻ�ɽ��յ�����tag50��TPIDΪ0x8100��������
        #   <5>����NE1��NNI�˿�egress������
        #   Ԥ�ڽ����������Ϊ����VLAN TAG��ǩ����������mpls��ǩ���ģ����lsp��ǩ100���ڲ�pw��ǩ1000
        ##AC VLAN����Ϊɾ��
        #   <6>ɾ��NE2�豸��ר��ҵ��AC��������ΪAC��VLAN����Ϊɾ��������������Ϣ���ֲ���
        #   <7>��NE1�˿�A���ʹ���tag50��TPIDΪ0x8100����ƥ�����������۲�NE2�Ķ˿�B���ս����
        #   Ԥ�ڽ����B�ɽ��յ�untag����������NE1�˿�A����untag/tag50��TPIDΪ0x9100��/tag100���������۲�NE2�Ķ˿�B���ս����δ�յ�������
        ##AC VLAN����Ϊ�޸�
        #   <8>ɾ��NE2�豸��ר��ҵ��AC��������AC��VLAN����Ϊ�޸ģ��޸�Ϊ VID=80��������������Ϣ���ֲ��� 
        #   <9>��NE1�˿�A���ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2�Ķ˿�B���ս����
        #   Ԥ�ڽ����B�ɽ��յ�����VID 80����������NE1�˿�A����untag/tag50��TPIDΪ0x9100��/ tag100���������۲�NE2�Ķ˿�B���ս����δ�յ�������
        ##AC VLAN����Ϊ���
        #   <10>ɾ��NE2�豸��ר��ҵ��AC����α�ߣ�PW1��������PW1��ƥ��TPIDΪ0x9100������AC��VLAN����Ϊ��ӣ����VID=100������������Ϣ���ֲ���
        #   <11>��NE1�˿�A���ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2�Ķ˿�B���ս��;
        #   Ԥ�ڽ����B�ɽ��յ�����˫���ǩ�������������100���ڲ�50������NE1�˿�A����untag/tag50��TPIDΪ0x9100��/tag100���������۲�NE2�Ķ˿�B���ܽ����δ�յ�������
        set flag1_case1 0
        set flag2_case1 0
        set flag3_case1 0
        set flag4_case1 0
        set flag5_case1 0
        set flag6_case1 0
        set flag7_case1 0
        set flag8_case1 0
        set flag9_case1 0
        puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN��������Ĳ��Կ�ʼ=====\n"
        if {[string match "8FX" $porttype3]} {
        	gwd::GWpublic_addMplsEn $telnet1 $matchType1 $Gpn_type1 $fileId "enable" $slot3
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "delete" "" 1 0 "0x8100" "0x9100" ""
        } else {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        }
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"

        if {[string match "8FX" $porttype4]} {
                gwd::GWpublic_addMplsEn $telnet3 $matchType3 $Gpn_type3 $fileId "enable" $slot4
                gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "delete" "" 1 0 "0x8100" "0x9100" ""
                gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
        } else {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "nochange" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
        }
	gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 0 0 "nochange" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline"
	gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort3Stream1 $hGPNPort3Stream2 $hGPNPort3Stream3 $hGPNPort3Stream4 $hGPNPort4Stream8" \
		-activate "true"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt2(cnt1)!=0} {
        		set flag1_case1 1
        		gwd::GWpublic_print NOK "Dev3�յ�smac=00:00:00:00:00:01 untag��������" $fileId
        	} else {
        		gwd::GWpublic_print OK "Dev3û���յ�smac=00:00:00:00:00:01 untag��������" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt2) < $rateL || $aGPNPort4Cnt1(cnt2) > $rateR} {
        		set flag1_case1 1
        		gwd::GWpublic_print NOK "NE1����tag50(tpid=0x8100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\�յ�tag50(tpid=0x8100)������������Ϊ$aGPNPort4Cnt1(cnt2)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print OK "NE1����tag50(tpid=0x8100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\�յ�tag50(tpid=0x8100)������������Ϊ$aGPNPort4Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt3)!=0} {
        		set flag1_case1 1
        		gwd::GWpublic_print NOK "Dev3�յ�smac=00:00:00:00:00:03 untag��������" $fileId
        	} else {
        		gwd::GWpublic_print OK "Dev3û���յ�smac=00:00:00:00:00:03 untag��������" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt4)!=0} {
        		set flag1_case1 1
        		gwd::GWpublic_print NOK "Dev3�յ�smac=00:00:00:00:00:04 untag��������" $fileId
        	} else {
        		gwd::GWpublic_print OK "Dev3û���յ�smac=00:00:00:00:00:04 untag��������" $fileId
        	}
        } else {
        	if {$aGPNPort4Cnt2(cnt1)!=0} {
        		set flag1_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����smac=00:00:00:00:00:01 untag������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$aGPNPort4Cnt1(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����smac=00:00:00:00:00:01 untag������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$aGPNPort4Cnt1(cnt1)" $fileId
		}
        	if {$aGPNPort4Cnt1(cnt2) < $rateL || $aGPNPort4Cnt1(cnt2) > $rateR} {
        		set flag1_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����smac=00:00:00:00:00:03 vid=50 tpid=8100������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������Ϊ$aGPNPort4Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����smac=00:00:00:00:00:03 vid=50 tpid=8100������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������Ϊ$aGPNPort4Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
		}
        	if {$aGPNPort4Cnt1(cnt3)!=0} {
        		set flag1_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����smac=00:00:00:00:00:03 vid=50 tpid=9100������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$aGPNPort4Cnt1(cnt3)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����smac=00:00:00:00:00:03 vid=50 tpid=9100������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$aGPNPort4Cnt1(cnt3)" $fileId
		}
        	if {$aGPNPort4Cnt1(cnt4)!=0} {
        		set flag1_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����smac=00:00:00:00:00:04 vid=60������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$aGPNPort4Cnt1(cnt4)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����smac=00:00:00:00:00:04 vid=60������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$aGPNPort4Cnt1(cnt4)" $fileId
		}
        	        		
        }
        if {$aGPNPort3Cnt1(cnt8) < $rateL || $aGPNPort3Cnt1(cnt8) > $rateR} {
        	set flag2_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth4\����smac=00:00:00:00:00:08 vid=60������ʱ��NE1($gpnIp1)$GPNTestEth3\�յ�������vid=60������Ϊ$aGPNPort3Cnt1(cnt8)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth4\����smac=00:00:00:00:00:08 vid=60������ʱ��NE1($gpnIp1)$GPNTestEth3\�յ�������vid=60������Ϊ$aGPNPort3Cnt1(cnt8)����$rateL-$rateR\��Χ��" $fileId
	}
                	
        ##�����豸NE1
        array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
        gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2 aMirror
        foreach i "aTmpGPNPort2Cnt11 aTmpGPNPort2Cnt12" {
          	array set $i {cnt1 0 cnt2 0} 
        }
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort2AnaFrameCfgFil $::anaFliFrameCfg2
        if {$::cap_enable} {
            	gwd::Start_CapAllData ::capArr $::hGPNPort2Cap $::hGPNPort2CapAnalyzer 
            	gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
        }
        gwd::Start_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort2Ana $::hGPNPort4Ana"
        after 10000
	incr capId
        if {$::cap_enable} {
          	gwd::Stop_CapData $::hGPNPort2Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth2_cap\($gpnIp1\).pcap"	
          	gwd::Stop_CapData $::hGPNPort4Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp1\).pcap"
        }
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt 2 $::hGPNPort2Ana aTmpGPNPort2Cnt11]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 0 0 0
		after 5000
	}
        
        parray aTmpGPNPort2Cnt11
        gwd::Stop_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort2Ana $::hGPNPort4Ana"
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort2AnaFrameCfgFil $::anaFliFrameCfg3
        gwd::Start_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort2Ana $::hGPNPort4Ana"
        after 10000
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt 3 $::hGPNPort2Ana aTmpGPNPort2Cnt12]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 0 0 0
		after 5000
	}
        
        parray aTmpGPNPort2Cnt12
       gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth2_cap\($gpnIp1\).pcap" $fileId
       gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aTmpGPNPort2Cnt11(cnt1)< $rateL1 || $aTmpGPNPort2Cnt11(cnt1) > $rateR1} {
        	set flag3_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth2\�յ�mpls0_lable=100  mpls1_lable=1000�����ݰ�����Ϊ$aTmpGPNPort2Cnt11(cnt1)��û����$rateL1-$rateR1\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth2\�յ�mpls0_lable=100  mpls1_lable=1000�����ݰ�����Ϊ$aTmpGPNPort2Cnt11(cnt1)����$rateL1-$rateR1\��Χ��" $fileId
        }
        if {$aTmpGPNPort2Cnt11(cnt2)!=0} {
        	set flag3_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth2\���յ�mpls0_lable=1000  mpls1_lable=100�����ݰ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth2\�����յ�mpls0_lable=1000  mpls1_lable=100�����ݰ�" $fileId
        }
        
        if {$aTmpGPNPort2Cnt12(cnt1)< $rateL1 || $aTmpGPNPort2Cnt12(cnt1) > $rateR1} {
        	set flag3_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth2\�յ�vid=10  mpls0_exp=000  mpls1_s=1�����ݰ�����Ϊ$aTmpGPNPort2Cnt11(cnt1)��û����$rateL1-$rateR1\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth2\�յ�vid=10  mpls0_exp=000  mpls1_s=1�����ݰ�����Ϊ$aTmpGPNPort2Cnt11(cnt1)����$rateL1-$rateR1\��Χ��" $fileId
        }
        if {$aTmpGPNPort2Cnt12(cnt2)!=0} {
        	set flag3_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth2\���յ�vid=10  mpls0_exp=000  mpls1_s=0�����ݰ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth2\�����յ�vid=10  mpls0_exp=000  mpls1_s=1�����ݰ�" $fileId
        }
        
        gwd::Stop_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort2Ana $::hGPNPort4Ana"
        gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2
        puts $fileId ""
        if {$flag1_case1 == 1 || $flag2_case1 == 1 || $flag3_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA1�����ۣ�AC VLAN��������Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA1�����ۣ�AC VLAN��������Ĳ���" $fileId
        }
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN��������Ĳ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN����ɾ�����Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac11" "" $GPNTestEth4 0 0 "delete" 50 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac11" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac11"
	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort3Stream1 $hGPNPort3Stream3 $hGPNPort3Stream4 $hGPNPort4Stream8" \
		-activate "false"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        	set flag4_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�untag������������Ϊ$aGPNPort4Cnt2(cnt2)��û����$rateL-$rateR\��Χ��" $fileId
        } else {
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag4_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=50������������ӦΪ0ʵΪ$aGPNPort4Cnt1(cnt2)" $fileId
        	} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�untag������������Ϊ$aGPNPort4Cnt2(cnt2)����$rateL-$rateR\��Χ��" $fileId
        	}
        }
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort3Stream2" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort3Stream1 $hGPNPort3Stream3 $hGPNPort3Stream9" \
		-activate "true"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1)!=0} {
        	set flag4_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����untag����������NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����untag����������NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        }
        if {$aGPNPort4Cnt1(cnt3) !=0} {
        	set flag4_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ9100)����������NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ9100)����������NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        }
        if {$aGPNPort4Cnt1(cnt9)!=0} {
        	set flag4_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=100����������NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=100����������NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        }
        puts $fileId ""
        if {$flag4_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA2�����ۣ�AC VLAN����ɾ���Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA2�����ۣ�AC VLAN����ɾ���Ĳ���" $fileId
        }
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN����ɾ�����Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN�����޸Ĳ��Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac11"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac11"
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac12" "" $GPNTestEth4 0 0 "modify" 80 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac12" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac12"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag5_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�untag������������Ϊ$aGPNPort4Cnt2(cnt2)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�untag������������Ϊ$aGPNPort4Cnt2(cnt2)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt11)!=0} {
        		set flag5_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=80(TPIDΪ8100)�����ݰ�" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt2) !=0} {
        		set flag5_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=50(TPIDΪ8100)�����ݰ�" $fileId
        	}
        } else {
        	if {$aGPNPort4Cnt1(cnt11) < $rateL || $aGPNPort4Cnt1(cnt11) > $rateR} {
        		set flag5_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=80(TPIDΪ8100)�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt11)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=80(TPIDΪ8100)�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt11)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag5_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=50(TPIDΪ8100)������������ӦΪ0ʵΪ$aGPNPort4Cnt1(cnt2)" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=50(TPIDΪ8100)������������ӦΪ0ʵΪ$aGPNPort4Cnt1(cnt2)" $fileId
        	}
        }
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1)!=0} {
        	set flag5_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����untag����������NE3($gpnIp3)$GPNTestEth4\�յ�untag��������ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt1)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����untag����������NE3($gpnIp3)$GPNTestEth4\�յ�untag��������ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt1)" $fileId
        }
        if {$aGPNPort4Cnt1(cnt3) !=0 } {
        	set flag5_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ9100)����������NE3($gpnIp3)$GPNTestEth4\���յ�������" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ9100)����������NE3($gpnIp3)$GPNTestEth4\�����յ�������" $fileId
        }
        if {$aGPNPort4Cnt1(cnt9)!=0} {
        	set flag5_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=100(TPIDΪ8100)����������NE3($gpnIp3)$GPNTestEth4\���յ�������" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=100(TPIDΪ8100)����������NE3($gpnIp3)$GPNTestEth4\�����յ�������" $fileId
        }
        puts $fileId ""
        if {$flag5_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA3�����ۣ�AC VLAN�����޸ĵĲ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA3�����ۣ�AC VLAN�����޸ĵĲ���" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN�����޸Ĳ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN������Ӳ��Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac12"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac12"
        gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
        if {[string match "8FX" $porttype3]} {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" "l2transport" "3" "" $address2 "1000" "1000" "2" "delete" "" 1 0 "0x8100" "0x9100" ""
        	
        } else {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" "l2transport" "3" "" $address2 "1000" "1000" "2" "nochange" "" 1 0 "0x8100" "0x9100" ""
        }
        gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" result
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac13" "" $GPNTestEth4 0 0 "add" 100 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac13" "pw12" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac13"
        stc::perform streamBlockActivate \
        	-streamBlockList "$hGPNPort3Stream1 $hGPNPort3Stream3 $hGPNPort3Stream9" \
        	-activate "false"
        stc::perform streamBlockActivate \
        	-streamBlockList "$hGPNPort3Stream2" \
        	-activate "true"
        
        foreach i "aTmpGPNPort4Cnt11" {
          	array set $i {cnt2 0 cnt12 0}
        }
        if {![string match "8FX" $porttype4]} {
        	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg4
        	if {$::cap_enable} {
            		gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
        	}
        	gwd::Start_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort4Ana"
        	after 10000
		incr capId
        	if {$::cap_enable} {
          		gwd::Stop_CapData $::hGPNPort4Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap"
        	}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt 1 $::hGPNPort4Ana aTmpGPNPort4Cnt11]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 0 1 0 0
			after 5000
		}
        	
        	parray aTmpGPNPort4Cnt11
		gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        	if {$aTmpGPNPort4Cnt11(cnt12) < $rateL || $aTmpGPNPort4Cnt11(cnt12) > $rateR} {
        		set flag6_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag1=100 tag2=50��˫�����ݰ�����Ϊ$aTmpGPNPort4Cnt11(cnt12)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag1=100 tag2=50��˫�����ݰ�����Ϊ$aTmpGPNPort4Cnt11(cnt12)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if { $aTmpGPNPort4Cnt11(cnt2)!=0} {
        		set flag6_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=50(TPIDΪ8100)�ĵ������ݰ�" $fileId
        	}
        } else {
        	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg0
        	if {$::cap_enable} {
        		    gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
        	}
        	gwd::Start_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort4Ana"
        	after 10000
		incr capId
        	if {$::cap_enable} {
        		  gwd::Stop_CapData $::hGPNPort4Cap 0 "GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap"
        	}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt 0 $::hGPNPort4Ana aTmpGPNPort4Cnt11]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 0 1 0 0
			after 5000
		}
        	
        	parray aTmpGPNPort4Cnt11
		gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        	if {$aTmpGPNPort4Cnt2(cnt2) < $rateL || $aTmpGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag6_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�untag���ݰ�����Ϊ$aTmpGPNPort4Cnt2(cnt2)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�untag���ݰ�����Ϊ$aTmpGPNPort4Cnt2(cnt2)����$rateL-$rateR\��Χ��" $fileId
        	}
        }	
        gwd::Stop_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort4Ana"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1)!=0} {
        	set flag6_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����untag����������NE3($gpnIp3)$GPNTestEth4\���յ�������" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����untag����������NE3($gpnIp3)$GPNTestEth4\�����յ�������" $fileId
        }
        if {$aGPNPort4Cnt1(cnt3) !=0} {
        	set flag6_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ9100)����������NE3($gpnIp3)$GPNTestEth4\���յ�������" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ9100)����������NE3($gpnIp3)$GPNTestEth4\�����յ�������" $fileId
        }
        if {$aGPNPort4Cnt1(cnt9)!=0} {
        	set flag6_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=100(TPIDΪ8100)����������NE3($gpnIp3)$GPNTestEth4\���յ�������" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=100(TPIDΪ8100)����������NE3($gpnIp3)$GPNTestEth4\�����յ�������" $fileId
        }
        puts $fileId ""
        if {$flag6_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA4�����ۣ�AC VLAN������ӵĲ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA4�����ۣ�AC VLAN������ӵĲ���" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN������Ӳ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
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
	puts $fileId "Test Case 1 $porttype3\�˿�ELineҵ��AC�������Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 $porttype4\�˿�ELineҵ��PW VLAN������֤\n"
        #   <1>ɾ��NE1��NE2�豸��������ר��ҵ��AC����α�ߣ�PW1����ɾ���ɹ���ϵͳ���쳣
        #   <2>����NE1��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100���û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ+��Ӫ��VLAN���˿�ģʽ����Ӫ��VLANΪ VLAN 50��
        #      ����NE2��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100���û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ���˿�ģʽ��
        #   <3>NE1��NE2�û�������undo vlan check
        #   <4>��NE1�˿�A���ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2�Ķ˿�B���ս��;
        #   Ԥ�ڽ����B�ɽ��յ�����VID 50����������NE1�˿�A����untag/tag50��TPIDΪ0x9100��/tag100���������۲�NE2�Ķ˿�B���ܽ����δ�յ�������
        ##PW VLAN����Ϊɾ��
        #   <5>ɾ��NE1�豸��ר��ҵ��AC����α�ߣ�PW1��������PW1��VLAN����Ϊɾ��������������Ϣ���ֲ���
        #   <6>��NE1�˿�A���ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2�Ķ˿�B���ܽ��
        #   Ԥ�ڽ����B�ɽ��յ�untag����������NE1�˿�A����untag/tag50��TPIDΪ0x9100��/tag100���������۲�NE2�Ķ˿�B���ܽ����δ�յ�������
        ##PW VLAN����Ϊ�޸�
        #   <7>ɾ��NE1�豸��ר��ҵ��AC����α�ߣ�PW1��������PW1��VLAN����Ϊ�޸ģ��޸�Ϊ VID=80��������������Ϣ���ֲ��� 
        #   <8>��NE1�˿�A���ʹ���VID 50��ƥ��������������۲�NE2�Ķ˿�B���ܽ��;
        #   Ԥ�ڽ����B�ɽ��յ�����VID 80����������NE1�˿�A����untag ��tag100���������۲�NE2�Ķ˿�B���ܽ����δ�յ�������
        ##PW VLAN����Ϊ���
        #   <9>ɾ��NE1�豸��ר��ҵ��AC����α�ߣ�PW1��������PW1��VLAN����Ϊ��ӣ����VID=100��������AC��ƥ��TPIDΪ0x9100������������Ϣ���ֲ���
        #   <10>��NE1�˿�A���ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2�Ķ˿�B���ܽ��
        #   Ԥ�ڽ����B�ɽ��յ�����˫���ǩ�������������100���ڲ�50������NE1�˿�A����untag/tag50��TPIDΪ0x9100��/tag100���������۲�NE2�Ķ˿�B���ܽ����δ�յ�������
        set flag1_case2 0
        set flag2_case2 0
        set flag3_case2 0
        set flag4_case2 0

	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN��������Ĳ��Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac13"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac13"
        gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw12"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw12"
        if {[string match "8FX" $porttype4]} {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "delete" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
        } else {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "nochange" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
        }
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 0 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        ###�����豸NE1
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        if {[string match "8FX" $porttype3]} {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "delete" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
        } else {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
        }
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream4 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream8 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt2(cnt1)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����untag����������NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����untag����������NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPID=8100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�tag=50(TPID=8100)�����ݰ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPID=8100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�tag=50(TPID=8100)�����ݰ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPID=8100)����������NE3($gpnIp3)$GPNTestEth4\�յ�untag�����ݰ�����Ϊ$aGPNPort4Cnt2(cnt2)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPID=8100)����������NE3($gpnIp3)$GPNTestEth4\�յ�untag�����ݰ�����Ϊ$aGPNPort4Cnt2(cnt2)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt3)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPID=9100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPID=9100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt4)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=60(TPID=8100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=60(TPID=8100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	array set aTmpGPNPort3Cnt11 {cnt17 0} 
        	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg4
        	if {$::cap_enable} {
        		gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
        	}
        	gwd::Start_SendFlow "$::hGPNPort4Gen"  "$::hGPNPort3Ana"
        	after 10000
		incr capId
        	if {$::cap_enable} {
        		gwd::Stop_CapData $::hGPNPort3Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap"
        	}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt 1 $::hGPNPort3Ana aTmpGPNPort3Cnt11]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 0 0 0
			after 5000
		}
        	
        	parray aTmpGPNPort3Cnt11
		gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
        	if {$aTmpGPNPort3Cnt11(cnt17) < $rateL || $aTmpGPNPort3Cnt11(cnt17) > $rateR} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth4\����tag=60(TPID=8100)����������NE1($gpnIp1)$GPNTestEth3\�յ�vid1=$vid8fx vid2=60�����ݰ�����Ϊ$aTmpGPNPort3Cnt11(cnt17)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth4\����tag=60(TPID=8100)����������NE1($gpnIp1)$GPNTestEth3\�յ�vid1=$vid8fx vid2=60�����ݰ�����Ϊ$aTmpGPNPort3Cnt11(cnt17)����$rateL-$rateR\��Χ��" $fileId
        	}
        	gwd::Stop_SendFlow "$::hGPNPort4Gen"  "$::hGPNPort3Ana"
        } else {
        	if {$aGPNPort4Cnt2(cnt1)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����untag����������NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����untag����������NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        		
        	if {$aGPNPort4Cnt1(cnt2) < $rateL || $aGPNPort4Cnt1(cnt2) > $rateR} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPID=8100)����������NE3($gpnIp3)$GPNTestEth4\�յ�tag=50(TPID=8100)�����ݰ�����Ϊ$aGPNPort4Cnt2(cnt2)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPID=8100)����������NE3($gpnIp3)$GPNTestEth4\�յ�tag=50(TPID=8100)�����ݰ�����Ϊ$aGPNPort4Cnt2(cnt2)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt3)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPID=9100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPID=9100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt4)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=60(TPID=8100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=60(TPID=8100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        }
        puts $fileId ""
        if {$flag1_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA5�����ۣ�PW VLAN��������Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA5�����ۣ�PW VLAN��������Ĳ���" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN��������Ĳ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN����ɾ�����Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "l2transport" "2" "" $address1 "1000" "1000" "1" "delete" "" 50 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" result
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw2" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream4 "FALSE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag2_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=50(TPIDΪ8100)�����ݰ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�����յ�tag=50(TPIDΪ8100)�����ݰ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag2_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�untag���ݰ�����Ϊ$aGPNPort4Cnt2(cnt2)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�untag���ݰ�����Ϊ$aGPNPort4Cnt2(cnt2)����$rateL-$rateR\��Χ��" $fileId
        	}
        	
        	if {$aGPNPort3Cnt1(cnt8) < $rateL || $aGPNPort3Cnt1(cnt8) > $rateR} {
        		set flag2_case2 1
        		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth4\����tag=60(TPIDΪ8100)��NE1($gpnIp1)$GPNTestEth3\�յ�untag���ݰ�����Ϊ$aGPNPort3Cnt1(cnt8)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth4\����tag=60(TPIDΪ8100)��NE1($gpnIp1)$GPNTestEth3\�յ�untag���ݰ�����Ϊ$aGPNPort3Cnt1(cnt8)����$rateL-$rateR\��Χ��" $fileId
        	}
        } else {
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag2_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=50(TPIDΪ8100)�����ݰ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�����յ�tag=50(TPIDΪ8100)�����ݰ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag2_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�untag���ݰ�����Ϊ$aGPNPort4Cnt2(cnt2)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�untag���ݰ�����Ϊ$aGPNPort4Cnt2(cnt2)����$rateL-$rateR\��Χ��" $fileId
        	}
        }
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1) != 0} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����untag�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����untag�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        }
        if {$aGPNPort4Cnt1(cnt3) !=0} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ9100)��NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ9100)��NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        }
        if {$aGPNPort4Cnt1(cnt9)!=0} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=100(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=100(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        }
        puts $fileId ""
        if {$flag2_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA6�����ۣ�PW VLANɾ���Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA6�����ۣ�PW VLANɾ���Ĳ���" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN����ɾ���Ĳ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN�����޸Ĳ��Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" "l2transport" "3" "" $address1 "1000" "1000" "1" "modify" "" 80 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" result
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw3" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag3_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�untag���ݰ�����Ϊ$aGPNPort4Cnt2(cnt2)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�untag���ݰ�����Ϊ$aGPNPort4Cnt2(cnt2)����$rateL-$rateR\��Χ��" $fileId
        	}
        	array set aTmpGPNPort3Cnt11 {cnt18 0} 
        	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg4
        	if {$::cap_enable} {
        		gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
        	}
        	gwd::Start_SendFlow "$::hGPNPort4Gen"  "$::hGPNPort3Ana"
        	after 10000
        	if {$::cap_enable} {
        		gwd::Stop_CapData $::hGPNPort3Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap"
        	}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt 1 $::hGPNPort3Ana aTmpGPNPort3Cnt11]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 0 0 0
			after 5000
		}
        	
        	parray aTmpGPNPort3Cnt11
		gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
        	if {$aTmpGPNPort3Cnt11(cnt17) < $rateL || $aTmpGPNPort3Cnt11(cnt17) > $rateR} {
        		set flag3_case2 1
        		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth4\����tag=60(TPID=8100)����������NE1($gpnIp1)$GPNTestEth3\�յ�vid1=$vid8fx vid2=60�����ݰ�����Ϊ$aTmpGPNPort3Cnt11(cnt17)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth4\����tag=60(TPID=8100)����������NE1($gpnIp1)$GPNTestEth3\�յ�vid1=$vid8fx vid2=60�����ݰ�����Ϊ$aTmpGPNPort3Cnt11(cnt17)����$rateL-$rateR\��Χ��" $fileId
        	}
        	gwd::Stop_SendFlow "$::hGPNPort4Gen"  "$::hGPNPort3Ana"
        } else {
        	if {$aGPNPort4Cnt1(cnt11) < $rateL || $aGPNPort4Cnt1(cnt11) > $rateR} {
        		set flag3_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=80(TPIDΪ8100)���ݰ�����Ϊ$aGPNPort4Cnt1(cnt11)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=80(TPIDΪ8100)���ݰ�����Ϊ$aGPNPort4Cnt1(cnt11)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag3_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\���յ�tag=50(TPIDΪ8100)�����ݰ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�����յ�tag=50(TPIDΪ8100)�����ݰ�" $fileId
        	}
        }
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1)!=0} {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����untag�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����untag�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        }
        if { $aGPNPort4Cnt1(cnt3) !=0 } {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(tpid=0x9100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(tpid=0x9100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        }
        if {$aGPNPort4Cnt1(cnt9)!=0} {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=100(tpid=0x8100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=100(tpid=0x8100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        }
        puts $fileId ""
        if {$flag3_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA7�����ۣ�PW VLAN�޸ĵĲ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA7�����ۣ�PW VLAN�޸ĵĲ���" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN�����޸ĵĲ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN������Ӳ��Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw4" "l2transport" "4" "" $address1 "1000" "1000" "1" "add" "" 100 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw4" result
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 0 "nochange" 1 0 0 "0x9100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw4" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
        foreach i "aTmpGPNPort3Cnt12 aTmpGPNPort4Cnt12" {
          	array set $i {cnt2 0 cnt12 0 cnt19 0} 
        }
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg4
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg4
        if {$::cap_enable} {
            	gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
        	gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
        }
        gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
        after 10000
	incr capId
        if {$::cap_enable} {
          	gwd::Stop_CapData $::hGPNPort3Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap"
        	gwd::Stop_CapData $::hGPNPort4Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap"
        } 
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt 1 $::hGPNPort3Ana aTmpGPNPort3Cnt12]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt 1 $::hGPNPort4Ana aTmpGPNPort4Cnt12]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
        parray aTmpGPNPort3Cnt12
        parray aTmpGPNPort4Cnt12
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag4_case2 1
        		puts -nonewline $fileId [format "%-47s" "PW������ӣ�NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ��������쳣"] 
        		puts $fileId "NOK"
        	}
        	if {$aGPNPort3Cnt12(cnt19) < $rateL || $aGPNPort3Cnt12(cnt19) > $rateR} {
        		set flag4_case2 1
        		puts -nonewline $fileId [format "%-47s" "PW������ӣ�NE3($gpnIp3)$GPNTestEth4\����tag=60(TPIDΪ8100)��NE1($gpnIp1)$GPNTestEth3\�յ��������쳣"] 
        		puts $fileId "NOK"
        	}
        } else {
        	if {$aTmpGPNPort4Cnt12(cnt12) < $rateL || $aTmpGPNPort4Cnt12(cnt12) > $rateR} {
        		set flag4_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=50(TPIDΪ8100)tag=100(TPIDΪ8100)���ݰ�����Ϊ$aTmpGPNPort4Cnt12(cnt12)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�յ�tag=50(TPIDΪ8100)tag=100(TPIDΪ8100)���ݰ�����Ϊ$aTmpGPNPort4Cnt12(cnt12)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aTmpGPNPort4Cnt12(cnt2)!=0} {
        		set flag4_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\���յ�tag=50(TPIDΪ8100)���ݰ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(TPIDΪ8100)��NE3($gpnIp3)$GPNTestEth4\�����յ�tag=50(TPIDΪ8100)���ݰ�" $fileId
        	}
        }
        gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1)!=0} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����untag�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����untag�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        }
        if {$aGPNPort4Cnt1(cnt3) !=0} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(tpid=0x9100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=50(tpid=0x9100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        }
        if {$aGPNPort4Cnt1(cnt9)!=0} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=100(tpid=0x8100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=100(tpid=0x8100)�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        }
        puts $fileId ""
        if {$flag4_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA8�����ۣ�PW VLAN��ӵĲ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA8�����ۣ�PW VLAN��ӵĲ���" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN������ӵĲ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
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
	puts $fileId "Test Case 2 $porttype4\�˿�ELineҵ��PW�������Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 ���û���˿ڽ���ģʽΪ���˿�+��Ӫ��VLAN+�ͻ�VLAN���£�VLAN������֤\n"
        #   <1>��UNI�˿ڸ���ΪFE�˿ڣ������������䣬�ظ����ϲ���
        #   <2>��NNI�˿ڸ���Ϊ10GE�˿ڣ�UNI�˿�ΪFE/GE�˿ڣ������������䣬�ظ����ϲ���
        #   <3>��NNI�˿ڸ���ΪLAG�ӿڣ�UNI�˿�ΪFE/GE�˿ڣ������������䣬�ظ����ϲ���
        #   <4>���û���˿ڽ���ģʽΪ���˿�+��Ӫ��VLAN+�ͻ�VLAN���£��ֱ���֤PW/AC��VLAN����ɾ������ӡ��޸ġ��������Ч
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN��������Ĳ��Կ�ʼ=====\n"
        gwd::Cfg_StreamActive $hGPNPort4Stream8 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "FALSE"
        set flag1_case3 0
        set flag2_case3 0
        set flag3_case3 0
        set flag4_case3 0
        set flag5_case3 0
        set flag6_case3 0
        set flag7_case3 0
        set flag8_case3 0
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw4"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw4"
        if {[string match "8FX" $porttype4]} {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "delete" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
        } else {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
        }
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 30 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        ####NE1($gpnIp1)$GPNTestEth3\����tag=50,���vlan50���ڲ�30��TPID=8100��,���vlan50���ڲ�30��TPID=9100��,���vlan50���ڲ�20��TPID=8100������������
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream10 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream11 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream12 "TRUE"
        incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	
        } else {
        	if {$aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR || $aGPNPort4Cnt4(cnt13) < $rateL || $aGPNPort4Cnt4(cnt13) > $rateR} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100����NE3($gpnIp3)$GPNTestEth4\�յ����vlan50���ڲ�30��TPID=8100�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt13)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100����NE3($gpnIp3)$GPNTestEth4\�յ����vlan50���ڲ�30��TPID=8100�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt13)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�vlan50�������ݰ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�vlan50�������ݰ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	
        	if {$aGPNPort4Cnt4(cnt14)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ����vlan50���ڲ�20��TPID=8100�����ݰ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ����vlan50���ڲ�20��TPID=8100�����ݰ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        }
        puts $fileId ""
        if {$flag1_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FA9�����ۣ�AC VLAN����Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA9�����ۣ�AC VLAN����Ĳ���" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN��������Ĳ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN����ɾ�����Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac11" "" $GPNTestEth4 0 0 "delete" 50 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac11" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac11"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	
        } else {
        	if {$aGPNPort4Cnt4(cnt10)!=0} {
        		set flag2_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ����vlan50���ڲ�30��TPID=8100�����ݰ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ����vlan50���ڲ�30��TPID=8100�����ݰ�" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt15) < $rateL || $aGPNPort4Cnt1(cnt15) > $rateR} {
        		set flag2_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�յ�����tag=30�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt15)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�յ�����tag=30�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt15)����$rateL-$rateR\��Χ��" $fileId
        	}	
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0 } {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        }
        puts $fileId ""
        if {$flag2_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB1�����ۣ�AC VLANɾ���Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB1�����ۣ�AC VLANɾ���Ĳ���" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN����ɾ���Ĳ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN�����޸Ĳ��Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac11"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac11"
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac12" "" $GPNTestEth4 0 0 "modify" 80 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac12" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac12"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt1(cnt15)!=0 || $aGPNPort4Cnt4(cnt16) !=0 || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR\
        		|| $aGPNPort4Cnt1(cnt2)!=0 || $aGPNPort4Cnt2(cnt2)!=0  || $aGPNPort4Cnt4(cnt13)!=0 || $aGPNPort4Cnt2(cnt13)!=0 || $aGPNPort4Cnt4(cnt14)!=0 || $aGPNPort4Cnt2(cnt14)!=0
        	} {
        		set flag3_case3 1
        		puts -nonewline $fileId [format "%-45s" "ac�����޸ģ�NE1($gpnIp1)$GPNTestEth3\����������������NE3($gpnIp3)$GPNTestEth4\�յ��������쳣"] 
        		puts $fileId "NOK"
        	}
        	
        } else {
        	if {$aGPNPort4Cnt4(cnt16) < $rateL || $aGPNPort4Cnt4(cnt16) > $rateR || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR} {
        		set flag3_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�յ����vlan80���ڲ�30�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt16)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�յ����vlan80���ڲ�30�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt16)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag3_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0 } {
        		set flag3_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag3_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        }
        puts $fileId ""
        if {$flag3_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB2�����ۣ�AC VLAN�޸ĵĲ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB2�����ۣ�AC VLAN�޸ĵĲ���" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN�����޸ĵĲ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN������Ӳ��Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac12"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac12"
        gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
        if {![string match "8FX" $porttype4]} {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" "l2transport" "3" "" $address2 "1000" "1000" "2" "nochange" "" 1 0 "0x8100" "0x9100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" result
        } else {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" "l2transport" "3" "" $address2 "1000" "1000" "2" "delete" "" 1 0 "0x8100" "0x9100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" result
        }
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac13" "" $GPNTestEth4 0 0 "add" 100 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac13" "pw12" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac13"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt4(cnt16) !=0 || $aGPNPort4Cnt4(cnt12) !=0 || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR\
        		|| $aGPNPort4Cnt1(cnt2)!=0 || $aGPNPort4Cnt2(cnt2)!=0  || $aGPNPort4Cnt4(cnt13)!=0 || $aGPNPort4Cnt2(cnt13)!=0 || $aGPNPort4Cnt4(cnt14)!=0 || $aGPNPort4Cnt2(cnt14)!=0
        	} {
        		set flag4_case3 1
        		puts -nonewline $fileId [format "%-45s" "ac������ӣ�NE1($gpnIp1)$GPNTestEth3\����������������NE3($gpnIp3)$GPNTestEth4\�յ��������쳣"] 
        		puts $fileId "NOK"
        	}
        	
        } else {
        	if {$aGPNPort4Cnt4(cnt12) < $rateL || $aGPNPort4Cnt4(cnt12) > $rateR || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR} {
        		set flag4_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�յ����vlan100���ڲ�50 30�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt12)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�յ����vlan100���ڲ�50 30�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt12)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag4_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0 } {
        		set flag4_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag4_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        }
        puts $fileId ""
        if {$flag4_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB3�����ۣ�AC VLAN��ӵĲ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB3�����ۣ�AC VLAN��ӵĲ���" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN������ӵĲ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN����������Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac13"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac13"
        gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw12"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw12"
        if {![string match "8FX" $porttype4]} {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "nochange" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
        } else {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "delete" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
        }
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 0 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" 
        ###�����豸NE1
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        if {![string match "8FX" $porttype4]} {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
        } else {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "delete" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
        }
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 30 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt4(cnt10) !=0 || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR\
        		|| $aGPNPort4Cnt1(cnt2)!=0 || $aGPNPort4Cnt2(cnt2)!=0 || $aGPNPort4Cnt2(cnt13)!=0 || $aGPNPort4Cnt4(cnt14)!=0 || $aGPNPort4Cnt2(cnt14)!=0
        	} {
        		set flag5_case3 1
        		puts -nonewline $fileId [format "%-47s" "PW�������䣬NE1����������������NE3($gpnIp3)$GPNTestEth4\�յ��������쳣"] 
        		puts $fileId "NOK"
        	}
        	 
        } else {
        	if {$aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR || $aGPNPort4Cnt4(cnt10) < $rateL || $aGPNPort4Cnt4(cnt10) > $rateR} {
        		set flag5_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100����NE3($gpnIp3)$GPNTestEth4\�յ����vlan50���ڲ�30��TPID=8100�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt10)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100����NE3($gpnIp3)$GPNTestEth4\�յ����vlan50���ڲ�30��TPID=8100�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt10)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag5_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0} {
        		set flag5_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag5_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        }
        puts $fileId ""
        if {$flag5_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB4�����ۣ�PW VLAN����Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB4�����ۣ�PW VLAN����Ĳ���" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN��������Ĳ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN����ɾ�����Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "l2transport" "2" "" $address1 "1000" "1000" "1" "delete" "" 50 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" result
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 30 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw2" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt4(cnt10)!=0 || $aGPNPort4Cnt1(cnt15) !=0 || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR\
        		|| $aGPNPort4Cnt1(cnt2)!=0 || $aGPNPort4Cnt2(cnt2)!=0  || $aGPNPort4Cnt4(cnt13)!=0 || $aGPNPort4Cnt2(cnt13)!=0 || $aGPNPort4Cnt4(cnt14)!=0 || $aGPNPort4Cnt2(cnt14)!=0
        		} {
        			set flag6_case3 1
        			puts -nonewline $fileId [format "%-45s" "PW����ɾ����NE1($gpnIp1)$GPNTestEth3\����������������NE3($gpnIp3)$GPNTestEth4\�յ��������쳣"] 
        			puts $fileId "NOK"
        		}
        } else {
        	if {$aGPNPort4Cnt1(cnt15) < $rateL || $aGPNPort4Cnt1(cnt15) > $rateR} {
        		set flag6_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100����NE3($gpnIp3)$GPNTestEth4\�յ�����vlan30�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt15)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100����NE3($gpnIp3)$GPNTestEth4\�յ�����vlan30�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt15)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag6_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0} {
        		set flag6_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag6_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        }
        puts $fileId ""
        if {$flag6_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB5�����ۣ�PW VLANɾ���Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB5�����ۣ�PW VLANɾ���Ĳ���" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN����ɾ���Ĳ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN�����޸Ĳ��Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" "l2transport" "3" "" $address1 "1000" "1000" "1" "modify" "" 80 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" result
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 30 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw3" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt1(cnt15)!=0 || $aGPNPort4Cnt4(cnt16) !=0 || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR\
        		|| $aGPNPort4Cnt1(cnt2)!=0 || $aGPNPort4Cnt2(cnt2)!=0  || $aGPNPort4Cnt4(cnt13)!=0 || $aGPNPort4Cnt2(cnt13)!=0 || $aGPNPort4Cnt4(cnt14)!=0 || $aGPNPort4Cnt2(cnt14)!=0
        		} {
        			set flag7_case3 1
        			puts -nonewline $fileId [format "%-45s" "PW�����޸ģ�NE1($gpnIp1)$GPNTestEth3\����������������NE3($gpnIp3)$GPNTestEth4\�յ��������쳣"] 
        			puts $fileId "NOK"
        		}
        } else {
        	if {$aGPNPort4Cnt4(cnt16) < $rateL || $aGPNPort4Cnt4(cnt16) > $rateR || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR} {
        		set flag7_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100����NE3($gpnIp3)$GPNTestEth4\�յ����vlan80���ڲ�30�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt16)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100����NE3($gpnIp3)$GPNTestEth4\�յ����vlan80���ڲ�30�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt16)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag7_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0} {
        		set flag7_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag7_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        }
        puts $fileId ""
        if {$flag7_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB6�����ۣ�PW VLAN�޸ĵĲ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB6�����ۣ�PW VLAN�޸ĵĲ���" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN�����޸ĵĲ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN������Ӳ��Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw4" "l2transport" "4" "" $address1 "1000" "1000" "1" "add" "" 100 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw4" result
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 30 "nochange" 1 0 0 "0x9100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw4" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt4(cnt16)!=0 ||$aGPNPort4Cnt4(cnt12) !=0 || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR\
        		 || $aGPNPort4Cnt1(cnt2)!=0 || $aGPNPort4Cnt2(cnt2)!=0  || $aGPNPort4Cnt4(cnt13)!=0 || $aGPNPort4Cnt2(cnt13)!=0 || $aGPNPort4Cnt4(cnt14)!=0 || $aGPNPort4Cnt2(cnt14)!=0
        	} {
        		set flag8_case3 1
        		puts -nonewline $fileId [format "%-45s" "PW������ӣ�NE1($gpnIp1)$GPNTestEth3\����������������NE3($gpnIp3)$GPNTestEth4\�յ��������쳣"] 
        		puts $fileId "NOK"
        	}
        } else {
        	if {$aGPNPort4Cnt4(cnt12) < $rateL || $aGPNPort4Cnt4(cnt12) > $rateR || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR} {
        		set flag8_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�յ����vlan100���ڲ�50 30�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt12)��û����$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�յ����vlan100���ڲ�50 30�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt12)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag8_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����vlan50�������ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0 } {
        		set flag8_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�30��TPID=9100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag8_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\���յ�" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\�������vlan50���ڲ�20��TPID=8100�����ݰ���NE3($gpnIp3)$GPNTestEth4\�����յ�" $fileId
        	}
        }
        puts $fileId ""
        if {$flag8_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB7�����ۣ�PW VLAN��ӵĲ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB7�����ۣ�PW VLAN��ӵĲ���" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN������ӵĲ��Խ���=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
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
	puts $fileId "Test Case 3 ���û���˿ڽ���ģʽΪ���˿�+��Ӫ��VLAN+�ͻ�VLAN���£�VLAN������֤  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===�ָ���ʼ������...\n"
        lappend flagDel [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
        lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw4"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw4"]
        lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface11 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface12 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface13 $matchType1 $Gpn_type1 $telnet1]
        
        lappend flagDel [gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
        lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"]
        lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface10 $matchType3 $Gpn_type3 $telnet3]
	
	if {[string match "L2" $Worklevel]} {
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort6 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanCheck  $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "enable"]
	}
	if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        	foreach port1 $portList1 {
			lappend flagDel [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port1 "enable" "disable"]
        	}
		foreach port3 $portList3 {
			lappend flagDel [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port3 "enable" "disable"]
		}
        } 
        
        if {[string match "8FX" $porttype3]} {
		lappend flagDel [gwd::GWpublic_addMplsEn $telnet1 $matchType1 $Gpn_type1 $fileId "disable" $slot3]
		lappend flagDel [gwd::GWL2Inter_DelVlan $telnet1 $matchType1 $Gpn_type1 $fileId "4078-4085"]
        }
        if {[string match "8FX" $porttype4]} {
		lappend flagDel [gwd::GWpublic_addMplsEn $telnet3 $matchType3 $Gpn_type3 $fileId "disable" $slot4]
		lappend flagDel [gwd::GWL2Inter_DelVlan $telnet3 $matchType3 $Gpn_type3 $fileId "4078-4085"]
        }
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_002_2"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_002_2"
	
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_002_2����Ŀ�ģ�E-LINE PW/AC vlan������֤\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1==1 || $flagCase2==1 || $flagCase3==1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_002_2���Խ��" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3���Խ��" $fileId
	puts $fileId ""
	puts $fileId ""
        gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1 || $flag2_case1 == 1 || $flag3_case1 == 1) ? "NOK" : "OK"}]" "AC VLAN��������Ĳ���" $fileId
        gwd::GWpublic_print "== FA2 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+�ͻ�VLAN��AC VLAN����ɾ���Ĳ���" $fileId
        gwd::GWpublic_print "== FA3 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+�ͻ�VLAN��AC VLAN�����޸ĵĲ���" $fileId
        gwd::GWpublic_print "== FA4 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+�ͻ�VLAN��AC VLAN������ӵĲ���" $fileId
        gwd::GWpublic_print "== FA5 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+�ͻ�VLAN��PW VLAN��������Ĳ���" $fileId
        gwd::GWpublic_print "== FA6 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+�ͻ�VLAN��PW VLAN����ɾ���Ĳ���" $fileId
        gwd::GWpublic_print "== FA7 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+�ͻ�VLAN��PW VLAN�����޸ĵĲ���" $fileId
        gwd::GWpublic_print "== FA8 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+�ͻ�VLAN��PW VLAN������ӵĲ���" $fileId
        gwd::GWpublic_print "== FA9 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+��Ӫ��VLAN+�ͻ�VLAN��AC VLAN��������Ĳ���" $fileId
        gwd::GWpublic_print "== FB1 == [expr {($flag2_case3 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+��Ӫ��VLAN+�ͻ�VLAN��AC VLAN����ɾ���Ĳ���" $fileId
        gwd::GWpublic_print "== FB2 == [expr {($flag3_case3 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+��Ӫ��VLAN+�ͻ�VLAN��AC VLAN�����޸ĵĲ���" $fileId
        gwd::GWpublic_print "== FB3 == [expr {($flag4_case3 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+��Ӫ��VLAN+�ͻ�VLAN��AC VLAN������ӵĲ���" $fileId
        gwd::GWpublic_print "== FB4 == [expr {($flag5_case3 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+��Ӫ��VLAN+�ͻ�VLAN��PW VLAN��������Ĳ���" $fileId
        gwd::GWpublic_print "== FB5 == [expr {($flag6_case3 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+��Ӫ��VLAN+�ͻ�VLAN��PW VLAN����ɾ���Ĳ���" $fileId
        gwd::GWpublic_print "== FB6 == [expr {($flag7_case3 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+��Ӫ��VLAN+�ͻ�VLAN��PW VLAN�����޸ĵĲ���" $fileId
        gwd::GWpublic_print "== FB7 == [expr {($flag8_case3 == 1) ? "NOK" : "OK"}]" "�˿ڽ���ģʽΪ�˿�+��Ӫ��VLAN+�ͻ�VLAN��PW VLAN������ӵĲ���" $fileId
        gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
        gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
        puts $fileId ""
        puts $fileId "**************************************************************************************"
        puts $fileId ""
        puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_002_2"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_002_2_REPORT.txt" "report\\NOK_GPN_PTN_002_2_REPORT.txt"
	file rename "log\\GPN_PTN_002_2_LOG.txt" "log\\NOK_GPN_PTN_002_2_LOG.txt"
} else {
	file rename "report\\GPN_PTN_002_2_REPORT.txt" "report\\OK_GPN_PTN_002_2_REPORT.txt"
	file rename "log\\GPN_PTN_002_2_LOG.txt" "log\\OK_GPN_PTN_002_2_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}
	
