#!/bin/sh
# T4_GPN_PTN_ELAN_007.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#����Ŀ�ģ�ELAN��VLAN������֤
#1-AC VLAN������֤  
#2-PW VLAN������֤
#3-����ҵ����֤
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
#   <1>����NE1��NE2֮���һ��E-LANҵ��
#   <2>����NE1��LSP1���ǩ100������ǩ100��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100��
#      �û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ+��Ӫ��VLAN���˿�ģʽ����Ӫ��VLANΪ VLAN 50��
#      ����NE2��LSP1���ǩ100������ǩ100��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100��
#      �û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ+��Ӫ��VLAN���˿�ģʽ����Ӫ��VLANΪ VLAN 50��
#   <3>��NE1UNI�˿ڷ��ʹ���untag��tag50��TPIDΪ0x8100��tag50��TPIDΪ0x9100�� tag60 �������������۲�NE2��UNI�˿ڽ��ս��
#   Ԥ�ڽ����ֻ�ɽ��յ�����tag50��TPIDΪ0x8100��������
#   <4>��NE2��ac�ڷ���������������NE1�˿ڽ��ս��ͬ��
#   <5>����NE1��NNI�˿�egress�����ģ�ΪVLAN TAG=50��ǩ����������mpls��ǩ���ģ����lsp��ǩ100���ڲ�pw��ǩ1000
##AC VLAN����Ϊɾ��
#   <6>ɾ��NE2�豸��ר��ҵ��AC��������ΪNE2��AC��VLAN����Ϊɾ��������������Ϣ���ֲ��䣬mac����Ϊ����
#   <7>��NE1UNI���ʹ���tag50��TPIDΪ0x8100����ƥ�����������۲�NE2UNI�˿ڽ��ս����
#   Ԥ�ڽ�����ɽ��յ�untag����������NE1��UNI�˿ڷ���untag �� tag50��TPIDΪ0x9100�� tag100���������۲�NE2��NE3��UNI�˿ڽ��ս����δ�յ�������  
##AC VLAN����Ϊ�޸�
#   <8>ɾ��NE2�豸��ר��ҵ��AC��������NE2��AC��VLAN����Ϊ�޸ģ��޸�Ϊ VID=80��������������Ϣ���ֲ���
#   <9>��NE1��UNI�˿ڷ��ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս����
#   Ԥ�ڽ�����ɽ��յ�����VID 80����������NE1��UNI�˿ڷ���untag �� tag50��TPIDΪ0x9100�� tag100���������۲�NE2��UNI�˿ڽ��ս����δ�յ�������
##AC VLAN����Ϊ���
#   <10>ɾ��NE2�豸��ר��ҵ��AC��������NE2AC��VLAN����Ϊ��ӣ����VID=100����ƥ��TPIDΪ9100������������Ϣ���ֲ���
#   <11>��NE1��UNI�˿ڷ��ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս����
#   Ԥ�ڽ�����ɽ��յ�����˫���ǩ�������������100���ڲ�50������NE1��UNI�˿ڷ���untag ��tag50��TPIDΪ0x9100��tag100���������۲�NE2��NE3��UNI�˿ڽ��ս����δ�յ�������
#   <12>ɾ��NE1��NE2��ELAN ҵ�񣬲鿴�ײ㣬ҵ��ɹ�ɾ��
##8fx��Ϊac�˿� ��ac vlan������֤
#   <13>��������NE1��NE2��E-LANҵ��NE1��ac�˿�Ϊ4ge�ڣ�NE2��ac�˿�Ϊ8fx�˿ڣ�8fx�忨����ΪMPLSģʽ���������ò���
#   <14>����NE2��ac�˿�VLAN����Ϊ���䣬��NE1��UNI�˿ڷ���untag������VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս����
#   Ԥ�ڽ�����ɽ��յ�����untag��tag=50��������
#   <15>����NE2��ac�˿�VLAN����Ϊ��ӣ�ֻ�����4078-4085������NE1��UNI�˿ڷ���untag������VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս��
#   Ԥ�ڽ�����ɽ��յ�untag������vlan id=50�������������Ϊ����vlan��ҵ��ͨ
#   <16>����NE2��ac�˿�VLAN����Ϊ�޸ģ�ֻ���޸�Ϊ4078-4085������NE1��UNI�˿ڷ��ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս��
#   Ԥ�ڽ�����ɽ��յ�untag���������޸�Ϊ����vlan��ҵ��ͨ
#   <17>��NE1��AC��Ϊ8fx�ڣ��ظ����ϲ��裬ע�⣺NE1����PW����VLANɾ������
#2���Test Case 2���Ի���
##MS-PW������֤
#   <1>NNI�˿�tag��ʽ����VLANҵ��ӿڣ���NE1��NE3֮�䴴��һ��E-LINELҵ����NE2������MS-PW
#   <2>��NE1�豸��AC�˿ڷ���ҵ����
#   Ԥ�ڽ��:NE3�豸AC�˿�Ӧ���ն�Ӧҵ����,˫����ҵ������ת��
#   <3>NE1��NE3�û�������undo vlan check
#   <4>����NE2�豸��NNI�˿�egress�����ingress������֤MS-PW��ǩ��������
#   Ԥ�ڽ��:NE2�ڵ��ܹ���NE1�����ı��Ľ���LSP��PW�ı�ǩ���滻�����ĸ����ֶξ���ȷ
#           �Ƚ�NE2�豸��NNI�˿�egress�����ingress�����ģ�����������LSP�ֶ��е�TTLֵ��1��PW�ֶ�Ҳ�е�TTLֵ��1
#   <5>��NE2�豸����LSP/PW QOS��ϵͳ���쳣�����ܲ���Ч
#   <6>��NE2�豸ʹ��LSP/PW����ͳ�ƣ�ϵͳ���쳣������ͳ�ƹ��ܲ���Ч��ͳ��ֵ��ȷ
#   <7>undo shutdown��shutdown NE2�豸��NNI�˿�50�Σ�ϵͳ���쳣��ҵ��ɻָ� 
#   <8>����NE1��NE2�豸��NNI�˿����ڰ忨50�Σ�ϵͳ���쳣��ҵ��ɻָ�
#   <9>NE2�豸����SW/NMS����50�Σ�ϵͳ���쳣��ҵ��ɻָ����鿴��ǩת��������ȷ
#   <10>��������NE2�豸50�Σ��豸�������������ò���ʧ��ҵ������ת��
#2���Test Case 2���Ի���
##PW VLAN������֤###
##PW VLAN����Ϊ����
#   <1>ɾ��NE1��NE2�豸��������ר��ҵ��AC����α�ߣ�PW����ɾ���ɹ���ϵͳ���쳣
#   <2>����NE1��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100���û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ+��Ӫ��VLAN���˿�ģʽ����Ӫ��VLANΪ VLAN 50��
#      ����NE2��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100���û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ���˿�ģʽ��
#      NE1--NE3 ��NE2--NE3��lsp��pw��ac����ͬ�ϣ�ֻ�Ǳ�ǩ��ͬ
#   <3>��NE1��UNI�˿ڷ��ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս��
#   Ԥ�ڽ��:�ɽ��յ�����VID 50����������NE1��UNI�˿ڷ���untag ��tag50��TPIDΪ0x9100��tag100���������۲�NE2��UNI�˿ڽ��ս����δ�յ�������
##PW VLAN����Ϊɾ��
#   <4>ɾ��NE1�豸��ר��ҵ��AC����α�ߣ�PW��������PW��VLAN����Ϊɾ��������������Ϣ���ֲ���
#   <5>��NE1��UNI�˿ڷ��ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս�����ɽ��յ�untag��������
#      ��NE1��UNI�˿ڷ���untag ��tag50��TPIDΪ0x9100��tag100���������۲�NE2��NE3��UNI�˿ڽ��ս����δ�յ�������
##PW VLAN����Ϊ�޸�
#   <6>ɾ��NE1�豸��ר��ҵ��AC����α�ߣ�PW��������PW��VLAN����Ϊ�޸ģ��޸�Ϊ VID=80��������������Ϣ���ֲ���
#   <7>��NE1��UNI�˿ڷ��ʹ���VID 50��ƥ��������������۲�NE2��UNI�˿ڽ��ս�����ɽ��յ�����VID 80��������
#      ��NE1��UNI�˿ڷ���untag ��tag100���������۲�NE2��UNI�˿ڽ��ս����δ�յ�������
##PW VLAN����Ϊ���
#   <8>ɾ��NE1�豸��ר��ҵ��AC����α�ߣ�PW��������PW��VLAN����Ϊ��ӣ����VID=100��������AC��ƥ��TPIDΪ0x9100������������Ϣ���ֲ���
#   <9>��NE1��NI�˿ڷ��ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս�����ɽ��յ�����˫���ǩ�������������100���ڲ�50����
#      ��NE1��UNI�˿ڷ���untag ��tag50��TPIDΪ0x9100��tag100���������۲�NE2��UNI�˿ڽ��ս����δ�յ�������
#   <10>��NNI�˿ڸ���ΪLAG�ӿڣ�UNI�˿�ΪFE�˿�/GE�˿ڣ������������䣬�ظ����ϲ���
#   <11>���û���˿ڽ���ģʽΪ���˿�+��Ӫ��VLAN+�ͻ�VLAN���£��ֱ���֤PW/AC��VLAN����ɾ������ӡ��޸ġ��������Ч
#   <11>���4̨76�豸���ã�����4̨76�豸,���豸������鿴������
#3���Test Case 3���Ի���
##����ҵ����֤
#   <1>��̨�豸��NE1--NE2--NE3��������������EPLANҵ��1��vpls��Ϊvpls1��������������ҵ������
#   <2>���´���һ��EPLANҵ��2��vpls��Ϊvpls2��lsp��ҵ��1��lsp���ã�pw��UNI����������
#   Ԥ�ڽ��:������������ҵ��������ҵ��1��Ӱ��
#   <3>undo shutdown��shutdown NE1�豸��NNI�˿�50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
#   <4>����NE1�豸��NNI�˿����ڰ忨50�Σ�ϵͳ���쳣��ҵ��ɻָ�
#   <5>NE1�豸����SW/NMS����50�Σ�ϵͳ���쳣��ҵ��ɻָ����鿴��ǩת��������ȷ
#   <6>��������NE1�豸50�Σ��豸�������������ò���ʧ��ҵ������ת��
#   <7>����豸NE1��NE2��NE3����
#   <8>����һ��EVPLANҵ��1��vpls��Ϊvpls1��������������ҵ������
#   <9>��ҵ��1�Ļ�����������һ��EVPLANҵ��2��vpls��Ϊvpls2��UNI������һvlan��lsp���ã�pw��������
#   Ԥ�ڽ��:������������ҵ��������ҵ��1��Ӱ��
#   <10>undo shutdown��shutdown NE1�豸��NNI�˿�50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
#   <11>����NE1�豸��NNI�˿����ڰ忨50�Σ�ϵͳ���쳣��ҵ��ɻָ�
#   <12>NE1�豸����SW/NMS����50�Σ�ϵͳ���쳣��ҵ��ɻָ����鿴��ǩת��������ȷ
#   <13>��������NE1�豸50�Σ��豸�������������ò���ʧ��ҵ������ת��
#   <14>����豸������������������ʧ
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
        close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_007_LOG.txt" a]
	set stdout $fd_log
	chan configure $fd_log -blocking 0 -buffering none;#������ģʽ ����flush
	log_file log\\GPN_PTN_007_LOG.txt
	
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_007_REPORT.txt" a+]
	chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_007_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_007_DEBUG.txt 0
	chan configure $fd_debug -blocking 0 -buffering none;#������ģʽ ����flush
	  
	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl

	
        ###����������
        array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
        array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "500" -pri "000"}
        array set dataArr7 {-srcMac "00:00:00:00:00:22" -dstMac "00:00:00:00:00:02" -srcIp "192.85.1.7" -dstIp "192.0.0.7" -vid "500" -pri "000"}
        array set dataArr12 {-srcMac "00:00:00:00:00:0c" -dstMac "00:00:00:00:00:cc" -srcIp "192.85.1.12" -dstIp "192.0.0.12" -vid "800" -pri "000"}
        array set dataArr13 {-srcMac "00:00:00:00:00:0d" -dstMac "00:00:00:00:00:dd" -srcIp "192.85.1.13" -dstIp "192.0.0.13" -vid "800" -pri "000"}
	array set dataArr14 {-srcMac "00:00:00:00:00:08" -dstMac "00:00:00:00:00:88" -srcIp "192.85.1.14" -dstIp "192.0.0.14" -vid1 "800" -pri1 "000" -vid2 "100" -pri2 "000"}
	array set dataArr15 {-srcMac "00:00:00:00:00:09" -dstMac "00:00:00:00:00:99" -srcIp "192.85.1.15" -dstIp "192.0.0.15" -vid1 "800" -pri1 "000" -vid2 "100" -pri2 "000"}
        array set dataArr16 {-srcMac "00:00:00:00:00:0e" -dstMac "00:00:00:00:00:ee" -srcIp "192.85.1.16" -dstIp "192.0.0.16"}
        array set dataArr18 {-srcMac "00:00:00:00:00:F2" -dstMac "00:00:00:00:F2:F2" -srcIp "192.85.1.18" -dstIp "192.0.0.18" -vid "800" -pri "000" -type "9100"}
        array set dataArr19 {-srcMac "00:00:00:00:00:F3" -dstMac "00:00:00:00:F3:F3" -srcIp "192.85.1.19" -dstIp "192.0.0.19" -vid "800" -pri "000" -type "9100"}
        array set dataArr20 {-srcMac "00:00:00:00:00:cc" -dstMac "00:00:00:00:00:0c" -srcIp "192.85.1.20" -dstIp "192.0.0.20" -vid "800" -pri "000"}
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
        ##mpls�����е������ǩ
        set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
	##ƥ��smac��vid1��vid2��ethtype
	set anaFliFrameCfg6 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType><vlans name="anon_2516"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
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
	#���ڵ��������豸�����õ��ı���------
	set lSpawn_id "$telnet1 $telnet2"
	set lMatchType "$matchType1 $matchType2"
	set lDutType "$Gpn_type1 $Gpn_type2"
	set lIp "$gpnIp1 $gpnIp2"
	#------���ڵ��������豸�����õ��ı���
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "�������Թ���...\n"
	set hPtnProject [stc::create project]
	set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3\
			\"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\" $GPNStcPort5 \"media $GPNEth5Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4 hGPNPort5
	
        ###������������
        gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort1 hGPNPort1Stream1
        gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort1 hGPNPort1Stream2
        gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort2 hGPNPort2Stream7
        gwd::STC_Create_VlanStream $fileId dataArr12 $hGPNPort1 hGPNPort1Stream12
        gwd::STC_Create_VlanTypeStream $fileId dataArr18 $hGPNPort1 hGPNPort1Stream18
        gwd::STC_Create_Stream $fileId dataArr16 $hGPNPort2 hGPNPort2Stream16
        gwd::STC_Create_VlanStream $fileId dataArr13 $hGPNPort2 hGPNPort2Stream13
        gwd::STC_Create_VlanTypeStream $fileId dataArr19 $hGPNPort2 hGPNPort2Stream19
        gwd::STC_Create_VlanStream $fileId dataArr20 $hGPNPort2 hGPNPort2Stream20
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr14 $hGPNPort1 hGPNPort1Stream14
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr15 $hGPNPort2 hGPNPort2Stream15
        set hGPNPortStreamList11 "$hGPNPort1Stream1 $hGPNPort1Stream12 $hGPNPort1Stream18 $hGPNPort1Stream2"
        set hGPNPortStreamList12 "$hGPNPort2Stream16 $hGPNPort2Stream13 $hGPNPort2Stream19 $hGPNPort2Stream7"
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
	
	stc::config $hGPNPort1Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort2Ana -FilterOnStreamId "FALSE"
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
        
        ###������������ 100Mbps
        foreach stream11 "$hGPNPortStreamList11 $hGPNPortStreamList12 $hGPNPort2Stream20" {
        	stc::config [stc::get $stream11 -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        }
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList11 $hGPNPortStreamList12 $hGPNPort2Stream20 $hGPNPort1Stream14 $hGPNPort2Stream15" \
		-activate "false"
        stc::apply 
        ###��ȡ����������ָ��
        gwd::Get_GeneratorCfgObj $hGPNPort1Gen hGPNPort1GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort2Gen hGPNPort2GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort5Gen hGPNPort5GenCfg
        set hGPNPortGenCfgList "$hGPNPort1GenCfg $hGPNPort2GenCfg $hGPNPort5GenCfg"
        foreach hGenCfg $hGPNPortGenCfgList {
        	gwd::Cfg_GeneratorCfgObj $hGenCfg $GenCfg
        }
        ###���������ù�������Ĭ�Ϲ���tag
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort1Ana hGPNPort1AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort2Ana hGPNPort2AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort5Ana hGPNPort5AnaFrameCfgFil
        if {$cap_enable} {
                ###��ȡ������capture������ص�ָ��
                gwd::Get_Capture $hGPNPort1 hGPNPort1Cap
                gwd::Get_Capture $hGPNPort2 hGPNPort2Cap
                gwd::Get_Capture $hGPNPort5 hGPNPort5Cap
                gwd::Create_FilterAnalyzer $hGPNPort1Cap hGPNPort1CapFilter hGPNPort1CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort2Cap hGPNPort2CapFilter hGPNPort2CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort5Cap hGPNPort5CapFilter hGPNPort5CapAnalyzer
                array set capArr {capMode "REGULAR_MODE" capSource "Tx_Rx_MODE"}
        }
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-LAN AC PW�������Ի������ÿ�ʼ...\n"
	if {[string match "L2" $Worklevel]} {
		set interface3 v4
		set interface4 v4
		set interface5 v800
		set interface6 v800
	} else {
		set interface3 $GPNPort5.4
		set interface4 $GPNPort6.4
		set interface5 $GPNTestEth1.800
		set interface6 $GPNTestEth2.800
	
	}
	lappend cfgFlag [gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"]
	lappend cfgFlag [gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "shutdown"]
        set portList11 "$GPNPort5 $GPNPort13 $GPNTestEth1"
        foreach port $portList11 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
        	}
        }
        set portList22 "$GPNPort6 $GPNPort14 $GPNTestEth2"
        foreach port $portList22 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "disable" "enable"]
		}
	}
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "=E-LAN AC PW�������Ի�������ʧ�ܣ����Խ���" \
			"=E-LAN AC PW�������Ի������óɹ�����������Ĳ���" "GPN_PTN_007"
        puts $fileId ""
        puts $fileId "====E-LAN AC PW�������Ի������ý���..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 ELANҵ��AC VLAN������֤����\n"
        ##AC VLAN����Ϊ����
        #   <1>����NE1��NE2֮���һ��E-LANҵ��
        #   <2>����NE1��LSP1���ǩ100������ǩ100��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100��
        #      �û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ+��Ӫ��VLAN���˿�ģʽ����Ӫ��VLANΪ VLAN 800��
        #      ����NE2��LSP1���ǩ100������ǩ100��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100��
        #      �û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ+��Ӫ��VLAN���˿�ģʽ����Ӫ��VLANΪ VLAN 800��
        #   <3>��NE1UNI�˿ڷ��ʹ���untag��tag800��TPIDΪ0x8100��tag800��TPIDΪ0x9100�� tag500 �������������۲�NE2��UNI�˿ڽ��ս��
        #   Ԥ�ڽ����ֻ�ɽ��յ�����tag800��TPIDΪ0x8100��������
        #   <4>��NE2��ac�ڷ���������������NE1�˿ڽ��ս��ͬ��
        #   <5>����NE1��NNI�˿�egress�����ģ�ΪVLAN TAG=50��ǩ����������mpls��ǩ���ģ����lsp��ǩ100���ڲ�pw��ǩ1000
        ##AC VLAN����Ϊɾ��
        #   <6>ɾ��NE2�豸��ר��ҵ��AC��������ΪNE2��AC��VLAN����Ϊɾ��������������Ϣ���ֲ��䣬mac����Ϊ����
        #   <7>��NE1UNI���ʹ���tag800��TPIDΪ0x8100����ƥ�����������۲�NE2UNI�˿ڽ��ս����
        #   Ԥ�ڽ�����ɽ��յ�untag����������NE1��UNI�˿ڷ���untag �� tag800��TPIDΪ0x9100�� tag500���������۲�NE2��NE3��UNI�˿ڽ��ս����δ�յ�������  
        ##AC VLAN����Ϊ�޸�
        #   <8>ɾ��NE2�豸��ר��ҵ��AC��������NE2��AC��VLAN����Ϊ�޸ģ��޸�Ϊ VID=100��������������Ϣ���ֲ���
        #   <9>��NE1��UNI�˿ڷ��ʹ���VID 800��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս����
        #   Ԥ�ڽ�����ɽ��յ�����VID 100����������NE1��UNI�˿ڷ���untag �� tag800��TPIDΪ0x9100�� tag500���������۲�NE2��UNI�˿ڽ��ս����δ�յ�������
        ##AC VLAN����Ϊ���
        #   <10>ɾ��NE2�豸��ר��ҵ��AC��������NE2AC��VLAN����Ϊ��ӣ����VID=1000����ƥ��TPIDΪ9100������������Ϣ���ֲ���
        #   <11>��NE1��UNI�˿ڷ��ʹ���VID 800��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս����
        #   Ԥ�ڽ�����ɽ��յ�����˫���ǩ�������������1000���ڲ�800������NE1��UNI�˿ڷ���untag ��tag800��TPIDΪ0x9100��tag500���������۲�NE2��NE3��UNI�˿ڽ��ս����δ�յ�������
        #   <12>ɾ��NE1��NE2��ELAN ҵ�񣬲鿴�ײ㣬ҵ��ɹ�ɾ��
	set flag1_case1 0
	set flag2_case1 0
	set flag3_case1 0
	set flag4_case1 0
	set flag5_case1 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��AC VLAN����Ϊ������֤ҵ��  ���Կ�ʼ=====\n"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "enable"
		gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "enable"
	}
	PTN_NNI_AddInterIp $fileId $Worklevel $interface3 $ip612 $GPNPort5 $matchType1 $Gpn_type1 $telnet1
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "800" $GPNTestEth1
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface3 $ip621 "100" "100" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" 1 "elan" "discard" "false" "false" "false" "true" 2000 "" ""
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $::GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"	
	
	PTN_NNI_AddInterIp $fileId $Worklevel $interface4 $ip621 $GPNPort6 $matchType2 $Gpn_type2 $telnet2
	PTN_UNI_AddInter $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel "800" $GPNTestEth2
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface4 $ip612 "100" "100" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWVpls_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls2" 2 "elan" "discard" "false" "false" "false" "true" 2000 "" ""
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $::GPNTestEth2 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList11 \
		-activate "true"
	####NE1-NE2������������֤
	if {[PTN_ElanActiveChange "AC" 1 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case1-1"]} {
		set flag1_case1 1
	}
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList11 \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList12 \
		-activate "true"
	####NE2-NE1������������֤
	if {[PTN_ElanActiveChange "AC" 2 1 $hGPNPort2Gen $hGPNPort1Ana $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case1-2"]} {
		set flag1_case1 1
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1�����ۣ�ELANҵ��AC VLAN����Ϊ������֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1�����ۣ�ELANҵ��AC VLAN����Ϊ������֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��AC VLAN����Ϊ������֤ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��AC VLAN����Ϊ����NE1($gpnIp1)����NNI�ڵĳ��������MPLS����  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList12 \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList11 $hGPNPort2Stream20"\
		-activate "true"
	####����NE1��NNI���ڷ���
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	if {[PTN_ElanActiveChange "AC" 3 1 "$hGPNPort1Gen $hGPNPort2Gen" $hGPNPort5Ana $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg2 "GPN_PTN_007_case1-3"]} {
		set flag2_case1 1
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2�����ۣ�ELANҵ��AC VLAN����Ϊ����NE1($gpnIp1)����NNI�ڵĳ��������MPLS����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2�����ۣ�ELANҵ��AC VLAN����Ϊ����NE1($gpnIp1)����NNI�ڵĳ��������MPLS����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��AC VLAN����Ϊ����NE1($gpnIp1)����NNI�ڵĳ��������MPLS����  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��AC VLAN����Ϊɾ����֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPort2Stream20\
		-activate "false"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "delete" "800" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "AC" 4 7 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg7 "GPN_PTN_007_case1-4"]} {
		set flag3_case1 1
	}
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3�����ۣ�ELANҵ��AC VLAN����Ϊɾ����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3�����ۣ�ELANҵ��AC VLAN����Ϊɾ����֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��AC VLAN����Ϊɾ����֤ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��AC VLAN����Ϊ�޸���֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "modify" "100" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "AC" 5 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case1-5"]} {
		set flag4_case1 1
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA4�����ۣ�ELANҵ��AC VLAN����Ϊ�޸���֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4�����ۣ�ELANҵ��AC VLAN����Ϊ�޸���֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��AC VLAN����Ϊ�޸���֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��AC VLAN����Ϊ�����֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x9100" "1"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "add" "1000" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "AC" 6 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case1-6"]} {
		set flag5_case1 1
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA5�����ۣ�ELANҵ��AC VLAN����Ϊ�����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5�����ۣ�ELANҵ��AC VLAN����Ϊ�����֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��AC VLAN����Ϊ�����֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
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
	puts $fileId "Test Case 1 ELANҵ��AC VLAN������֤����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 ELANҵ��PW VLAN������֤����\n"
        ##PW VLAN����Ϊ����
        #   <1>ɾ��NE1��NE2�豸��������ר��ҵ��AC����α�ߣ�PW����ɾ���ɹ���ϵͳ���쳣
        #   <2>����NE1��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100���û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ+��Ӫ��VLAN���˿�ģʽ����Ӫ��VLANΪ VLAN 50��
        #      ����NE2��PW1���ر�ǩ1000��Զ�̱�ǩ1000��PW��AC��VLAN������Ϊ���䣬PW��AC��ƥ��TPIDΪ0x8100���û��ࣨGE�˿ڣ�����ģʽΪ���˿�ģʽ���˿�ģʽ��
        #      NE1--NE3 ��NE2--NE3��lsp��pw��ac����ͬ�ϣ�ֻ�Ǳ�ǩ��ͬ
        #   <3>��NE1��UNI�˿ڷ��ʹ���VID 800��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս��
        #   Ԥ�ڽ��:�ɽ��յ�����VID 800����������NE1��UNI�˿ڷ���untag ��tag800��TPIDΪ0x9100��tag500���������۲�NE2��UNI�˿ڽ��ս����δ�յ�������
        ##PW VLAN����Ϊɾ��
        #   <4>ɾ��NE1�豸��ר��ҵ��AC����α�ߣ�PW��������PW��VLAN����Ϊɾ��������������Ϣ���ֲ���
        #   <5>��NE1��UNI�˿ڷ��ʹ���VID 800��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս�����ɽ��յ�untag��������
        #      ��NE1��UNI�˿ڷ���untag ��tag800��TPIDΪ0x9100��tag500���������۲�NE2��NE3��UNI�˿ڽ��ս����δ�յ�������
        ##PW VLAN����Ϊ�޸�
        #   <6>ɾ��NE1�豸��ר��ҵ��AC����α�ߣ�PW��������PW��VLAN����Ϊ�޸ģ��޸�Ϊ VID=80��������������Ϣ���ֲ���
        #   <7>��NE1��UNI�˿ڷ��ʹ���VID 50��ƥ��������������۲�NE2��UNI�˿ڽ��ս�����ɽ��յ�����VID 80��������
        #      ��NE1��UNI�˿ڷ���untag ��tag100���������۲�NE2��UNI�˿ڽ��ս����δ�յ�������
        ##PW VLAN����Ϊ���
        #   <8>ɾ��NE1�豸��ר��ҵ��AC����α�ߣ�PW��������PW��VLAN����Ϊ��ӣ����VID=100��������AC��ƥ��TPIDΪ0x9100������������Ϣ���ֲ���
        #   <9>��NE1��NI�˿ڷ��ʹ���VID 50��TPIDΪ0x8100����ƥ��������������۲�NE2��UNI�˿ڽ��ս�����ɽ��յ�����˫���ǩ�������������100���ڲ�50����
        #      ��NE1��UNI�˿ڷ���untag ��tag50��TPIDΪ0x9100��tag100���������۲�NE2��UNI�˿ڽ��ս����δ�յ�������
        #   <10>��NNI�˿ڸ���ΪLAG�ӿڣ�UNI�˿�ΪFE�˿�/GE�˿ڣ������������䣬�ظ����ϲ���
        #   <11>���û���˿ڽ���ģʽΪ���˿�+��Ӫ��VLAN+�ͻ�VLAN���£��ֱ���֤PW/AC��VLAN����ɾ������ӡ��޸ġ��������Ч
        #   <11>���4̨76�豸���ã�����4̨76�豸,���豸������鿴������
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��PW VLAN����Ϊ������֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "0" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "PW" "1" 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case2-1"]} {
		set flag1_case2 1
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA6�����ۣ�ELANҵ��PW VLAN����Ϊ������֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6�����ۣ�ELANҵ��PW VLAN����Ϊ������֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��PW VLAN����Ϊ������֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��PW VLAN����Ϊɾ����֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 800 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "PW" "4" 7 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg7 "GPN_PTN_007_case2-2"]} {
		set flag2_case2 1
	}
	puts $fileId ""
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA7�����ۣ�ELANҵ��PW VLAN����Ϊɾ����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7�����ۣ�ELANҵ��PW VLAN����Ϊɾ����֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��PW VLAN����Ϊɾ����֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��PW VLAN����Ϊ�޸���֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "modify" "none" 100 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "PW" "5" 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case2-3"]} {
		set flag3_case2 1
	}
	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA8�����ۣ�ELANҵ��PW VLAN����Ϊ�޸���֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8�����ۣ�ELANҵ��PW VLAN����Ϊ�޸���֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��PW VLAN����Ϊ�޸���֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��PW VLAN����Ϊ�����֤ҵ��  ���Կ�ʼ=====\n"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1000 0 "0x8100" "0x8100" "2"
        gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"
	if {[PTN_ElanActiveChange "PW" "6" 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case2-4"]} {
		set flag4_case2 1
	}
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA9�����ۣ�ELANҵ��PW VLAN����Ϊ�����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9�����ۣ�ELANҵ��PW VLAN����Ϊ�����֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ��PW VLAN����Ϊ�����֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
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
	puts $fileId "Test Case 2 ELANҵ��PW VLAN������֤����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 ELANҵ��NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN������֤����\n"
	set flag1_case3 0
	set flag2_case3 0
	set flag3_case3 0
	set flag4_case3 0
	if {[string match "L2" $Worklevel]} {
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ������֤ҵ��  ���Կ�ʼ=====\n"
        	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "undo shutdown"
        	gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNPort5,$GPNPort13"
        	gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "lag1:1"
        	gwd::GWL2Inter_AddVlanPort $telnet1 $matchType1 $Gpn_type1 $fileId "4" "trunk" "t1" "untagged"
        	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
        	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
        	
        	gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "" "$GPNPort6,$GPNPort14"
        	gwd::GWpublic_addTrunkMode $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "" "lag1:1"
        	gwd::GWL2Inter_AddVlanPort $telnet2 $matchType2 $Gpn_type2 $fileId "4" "trunk" "t1" "untagged"
        	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
        	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
        	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
        	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $::GPNTestEth2 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
        	
        	####NE1-NE2������������֤
        	if {[PTN_ElanActiveChange "AC" 1 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case3-1"]} {
        		set flag1_case3 1
        	}
        	stc::perform streamBlockActivate \
        		-streamBlockList $hGPNPortStreamList11 \
        		-activate "false"
        	stc::perform streamBlockActivate \
        		-streamBlockList $hGPNPortStreamList12 \
        		-activate "true"
        	####NE2-NE1������������֤
        	if {[PTN_ElanActiveChange "AC" 2 1 $hGPNPort2Gen $hGPNPort1Ana $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case3-2"]} {
        		set flag1_case3 1
        	}
        	puts $fileId ""
        	if {$flag1_case3 == 1} {
        		set flagCase3 1
        		gwd::GWpublic_print "NOK" "FB1�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ������֤ҵ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB1�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ������֤ҵ��" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ������֤ҵ��  ���Խ���=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊɾ����֤ҵ��  ���Կ�ʼ=====\n"
        	stc::perform streamBlockActivate \
        		-streamBlockList $hGPNPortStreamList11 \
        		-activate "true"
        	stc::perform streamBlockActivate \
        		-streamBlockList $hGPNPortStreamList12 \
        		-activate "false"
        	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
        	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "delete" "800" "0" "0" "0x8100" "evc2"
        	if {[PTN_ElanActiveChange "AC" 4 7 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg7 "GPN_PTN_007_case3-3"]} {
        		set flag2_case3 1
        	}
        	puts $fileId ""
        	if {$flag2_case3 == 1} {
        		set flagCase3 1
        		gwd::GWpublic_print "NOK" "FB2�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊɾ����֤ҵ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB2�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊɾ����֤ҵ��" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊɾ����֤ҵ��  ���Խ���=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ�޸���֤ҵ��  ���Կ�ʼ=====\n"
        	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
        	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "modify" "100" "0" "0" "0x8100" "evc2"
        	if {[PTN_ElanActiveChange "AC" 5 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case3-4"]} {
        		set flag3_case3 1
        	}
        	puts $fileId ""
        	if {$flag3_case3 == 1} {
        		set flagCase3 1
        		gwd::GWpublic_print "NOK" "FB3�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ�޸���֤ҵ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB3�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ�޸���֤ҵ��" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ�޸���֤ҵ��  ���Խ���=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ�����֤ҵ��  ���Կ�ʼ=====\n"
        	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
        	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
        	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x9100" "1"
        	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "add" "1000" "0" "0" "0x8100" "evc2"
        	if {[PTN_ElanActiveChange "AC" 6 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case3-5"]} {
        		set flag4_case3 1
        	}
        	puts $fileId ""
        	if {$flag4_case3 == 1} {
        		set flagCase3 1
        		gwd::GWpublic_print "NOK" "FB4�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ�����֤ҵ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB4�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ�����֤ҵ��" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ�����֤ҵ��  ���Խ���=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
	} else {
		puts $fileId "�����豸û�й�����L2�㣬�����Թ�"
	}
	if {$flagCase3 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 3���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 3���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 3 ELANҵ��NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN������֤����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 ELANҵ��NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN������֤����\n"
	
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	if {[string match "L2" $Worklevel]} {
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ������֤ҵ��  ���Կ�ʼ=====\n"
        	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
        	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
        	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
        	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "0" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
        	if {[PTN_ElanActiveChange "PW" "1" 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case4-1"]} {
        		set flag1_case4 1
        	}
        	puts $fileId ""
        	if {$flag1_case4 == 1} {
        		set flagCase4 1
        		gwd::GWpublic_print "NOK" "FB5�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ������֤ҵ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB5�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ������֤ҵ��" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ������֤ҵ��  ���Խ���=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊɾ����֤ҵ��  ���Կ�ʼ=====\n"
        	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 800 0 "0x8100" "0x8100" "2"
        	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
        	if {[PTN_ElanActiveChange "PW" "4" 7 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg7 "GPN_PTN_007_case4-2"]} {
        		set flag2_case4 1
        	}
        	puts $fileId ""
        	if {$flag2_case4 == 1} {
        		set flagCase4 1
        		gwd::GWpublic_print "NOK" "FB6�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊɾ����֤ҵ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB6�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊɾ����֤ҵ��" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊɾ����֤ҵ��  ���Խ���=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ�޸���֤ҵ��  ���Կ�ʼ=====\n"
        	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "modify" "none" 100 0 "0x8100" "0x8100" "2"
        	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
        	if {[PTN_ElanActiveChange "PW" "5" 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case4-3"]} {
        		set flag3_case4 1
        	}
        	puts $fileId ""
        	if {$flag3_case4 == 1} {
        		set flagCase4 1
        		gwd::GWpublic_print "NOK" "FB7�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ�޸���֤ҵ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB7�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ�޸���֤ҵ��" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ�޸���֤ҵ��  ���Խ���=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ�����֤ҵ��  ���Կ�ʼ=====\n"
        	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1000 0 "0x8100" "0x8100" "2"
        	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"
        	if {[PTN_ElanActiveChange "PW" "6" 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case4-4"]} {
        		set flag4_case4 1
        	}
        	puts $fileId ""
        	if {$flag4_case4 == 1} {
        		set flagCase4 1
        		gwd::GWpublic_print "NOK" "FB8�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ�����֤ҵ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB8�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ�����֤ҵ��" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ�����֤ҵ��  ���Խ���=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
	} else {
		puts $fileId "�����豸û�й�����L2�㣬�����Թ�"
	}
	if {$flagCase4 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 4���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 4���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 4 ELANҵ��ELANҵ��NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN������֤����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 ELANҵ�񣺶˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN������֤����\n"
	set flag1_case5 0
	set flag2_case5 0
	set flag3_case5 0
	set flag4_case5 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ������֤ҵ��  ���Կ�ʼ=====\n"
	if {[string match "L2" $Worklevel]} {
                gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "shutdown"
                gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" ""
		gwd::GWL2Inter_AddVlanPort $telnet1 $matchType1 $Gpn_type1 $fileId 4 "port" $GPNPort5 "untagged"
		#GPNTestEth1 shutdown/undo shutdown��Ŀ����Ϊ�˹�ܣ�trunk������ɺ������shut/undo shut�ͻᵼ��ҵ��ͨ������
		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "shutdown"
		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "undo shutdown"
		gwd::GWTrunk_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" ""
		gwd::GWL2Inter_AddVlanPort $telnet2 $matchType2 $Gpn_type2 $fileId 4 "port" $GPNPort6 "untagged"
        }
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "100" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $::GPNTestEth2 "800" "100" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPort1Stream14 \
		-activate "true"
	####NE1-NE2������������֤
	if {[PTN_ElanActiveChange "AC" 7 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case5-1"]} {
		set flag1_case5 1
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList12 $hGPNPort2Stream15" \
		-activate "true"
	####NE2-NE1������������֤
	if {[PTN_ElanActiveChange "AC" 8 6 $hGPNPort2Gen $hGPNPort1Ana $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case5-2"]} {
		set flag1_case5 1
	}
	puts $fileId ""
	if {$flag1_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FB9�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ������֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ������֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ������֤ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊɾ����֤ҵ��  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList12 $hGPNPort2Stream15" \
		-activate "false"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "100" "none" "delete" "800" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "AC" 9 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case5-3"]} {
		set flag2_case5 1
	}
	puts $fileId ""
	if {$flag2_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC1�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊɾ����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊɾ����֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊɾ����֤ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ�޸���֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "100" "none" "modify" "1000" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "AC" 10 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case5-4"]} {
		set flag3_case5 1
	}
	puts $fileId ""
	if {$flag3_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC2�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ�޸���֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ�޸���֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ�޸���֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ�����֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x9100" "1"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "100" "none" "add" "1000" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "AC" 11 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg4 "GPN_PTN_007_case5-5"]} {
		set flag4_case5 1
	}
	puts $fileId ""
	if {$flag4_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC3�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ�����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ�����֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ�����֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase5 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 5���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 5���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 5 ELANҵ�񣺶˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN������֤����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 6 ELANҵ�񣺶˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN������֤����\n"
	set flag1_case6 0
	set flag2_case6 0
	set flag3_case6 0
	set flag4_case6 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ������֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "100" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "0" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "PW" "7" 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case6-1"]} {
		set flag1_case6 1
	}
	puts $fileId ""
	if {$flag1_case6 == 1} {
		set flagCase6 1
		gwd::GWpublic_print "NOK" "FC4�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ������֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ������֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ������֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊɾ����֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 800 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "100" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "PW" "9" 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case6-2"]} {
		set flag2_case6 1
	}
	puts $fileId ""
	if {$flag2_case6 == 1} {
		set flagCase6 1
		gwd::GWpublic_print "NOK" "FC5�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊɾ����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊɾ����֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊɾ����֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ�޸���֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "modify" "none" 1000 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "100" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "PW" "10" 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case6-3"]} {
		set flag3_case6 1
	}
	puts $fileId ""
	if {$flag3_case6 == 1} {
		set flagCase6 1
		gwd::GWpublic_print "NOK" "FC6�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ�޸���֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ�޸���֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ�޸���֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ�����֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1000 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "100" "none" "nochange" "1" "0" "0" "0x9100" "evc2"
	if {[PTN_ElanActiveChange "PW" "11" 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg4 "GPN_PTN_007_case6-4"]} {
		set flag4_case6 1
	}
	puts $fileId ""
	if {$flag4_case6 == 1} {
		set flagCase6 1
		gwd::GWpublic_print "NOK" "FC7�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ�����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ�����֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ�����֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
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
	puts $fileId "Test Case 6 ELANҵ�񣺶˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN������֤����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 7 ELANҵ�񣺶���ҵ����֤����\n"
        #   <1>��̨�豸��NE1--NE2--NE3��������������EPLANҵ��1��vpls��Ϊvpls1��������������ҵ������
        #   <2>���´���һ��EPLANҵ��2��vpls��Ϊvpls2��lsp��ҵ��1��lsp���ã�pw��UNI����������
        #   Ԥ�ڽ��:������������ҵ��������ҵ��1��Ӱ��
        #   <3>undo shutdown��shutdown NE1�豸��NNI�˿�50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
        #   <4>����NE1�豸��NNI�˿����ڰ忨50�Σ�ϵͳ���쳣��ҵ��ɻָ�
        #   <5>NE1�豸����SW/NMS����50�Σ�ϵͳ���쳣��ҵ��ɻָ����鿴��ǩת��������ȷ
        #   <6>��������NE1�豸50�Σ��豸�������������ò���ʧ��ҵ������ת��
        #   <7>����豸NE1��NE2��NE3����
        #   <8>����һ��EVPLANҵ��1��vpls��Ϊvpls1��������������ҵ������
        #   <9>��ҵ��1�Ļ�����������һ��EVPLANҵ��2��vpls��Ϊvpls2��UNI������һvlan��lsp���ã�pw��������
        #   Ԥ�ڽ��:������������ҵ��������ҵ��1��Ӱ��
        #   <10>undo shutdown��shutdown NE1�豸��NNI�˿�50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
        #   <11>����NE1�豸��NNI�˿����ڰ忨50�Σ�ϵͳ���쳣��ҵ��ɻָ�
        #   <12>NE1�豸����SW/NMS����50�Σ�ϵͳ���쳣��ҵ��ɻָ����鿴��ǩת��������ȷ
        #   <13>��������NE1�豸50�Σ��豸�������������ò���ʧ��ҵ������ת��
        #   <14>����豸������������������ʧ
        puts $fileId "����ҵ����֤����GPN_PTN_006����case5���Խ�������ٵ�������"
        puts $fileId ""
        puts $fileId "Test Case 7 ELANҵ�񣺶���ҵ����֤����  ���Խ���\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===�ָ���ʼ������...\n"
	if {[string match "L2" $Worklevel]} {
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "none"]
	}
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface3 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface5 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "undo shutdown"]
	
	lappend flagDel [gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls2"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"] 
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface4 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface6 $matchType2 $Gpn_type2 $telnet2]
	
	if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
		foreach port $portList22 {
			lappend flagDel [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "enable" "disable"]
		}
		foreach port $portList11 {
			lappend flagDel [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "enable" "disable"]
		}
	}
	
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_007"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_007"
	chan seek $fileId 0
        puts $fileId "\n**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "GPN_PTN_007����Ŀ�ģ�E-LANҵ��AC PW��������\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1 == 1 || $flagCase2 == 1 || $flagCase3 == 1 || $flagCase4 == 1 || $flagCase5 == 1 || $flagCase6 == 1\
		|| $flagCase7 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_007���Խ��" $fileId
	puts $fileId ""
        gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase6 == 0) ? "OK" : "NOK"}] "Test Case 6���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase7 == 0) ? "OK" : "NOK"}] "Test Case 7���Խ��" $fileId
        
        puts $fileId ""
        puts $fileId ""
        gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�ELANҵ��AC VLAN����Ϊ������֤ҵ��" $fileId
        gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�ELANҵ��AC VLAN����Ϊ����NE1($gpnIp1)����NNI�ڵĳ��������MPLS����" $fileId
        gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�ELANҵ��AC VLAN����Ϊɾ����֤ҵ��" $fileId
        gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�ELANҵ��AC VLAN����Ϊ�޸���֤ҵ��" $fileId
        gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�ELANҵ��AC VLAN����Ϊ�����֤ҵ��" $fileId
        gwd::GWpublic_print "== FA6 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�ELANҵ��PW VLAN����Ϊ������֤ҵ��" $fileId
        gwd::GWpublic_print "== FA7 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�ELANҵ��PW VLAN����Ϊɾ����֤ҵ��" $fileId
        gwd::GWpublic_print "== FA8 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�ELANҵ��PW VLAN����Ϊ�޸���֤ҵ��" $fileId
        gwd::GWpublic_print "== FA9 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�ELANҵ��PW VLAN����Ϊ�����֤ҵ��" $fileId
        gwd::GWpublic_print "== FB1 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ������֤ҵ��" $fileId
        gwd::GWpublic_print "== FB2 == [expr {($flag2_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊɾ����֤ҵ��" $fileId
        gwd::GWpublic_print "== FB3 == [expr {($flag3_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ�޸���֤ҵ��" $fileId
        gwd::GWpublic_print "== FB4 == [expr {($flag4_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��AC VLAN����Ϊ�����֤ҵ��" $fileId
        gwd::GWpublic_print "== FB5 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ������֤ҵ��" $fileId
        gwd::GWpublic_print "== FB6 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊɾ����֤ҵ��" $fileId
        gwd::GWpublic_print "== FB7 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ�޸���֤ҵ��" $fileId
        gwd::GWpublic_print "== FB8 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NNI��ΪLAG�˿ڡ��˿�ģʽΪPORT+VLAN��PW VLAN����Ϊ�����֤ҵ��" $fileId
        gwd::GWpublic_print "== FB9 == [expr {($flag1_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ������֤ҵ��" $fileId
        gwd::GWpublic_print "== FC1 == [expr {($flag2_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊɾ����֤ҵ��" $fileId
        gwd::GWpublic_print "== FC2 == [expr {($flag3_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ�޸���֤ҵ��" $fileId
        gwd::GWpublic_print "== FC3 == [expr {($flag4_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��AC VLAN����Ϊ�����֤ҵ��" $fileId
        gwd::GWpublic_print "== FC4 == [expr {($flag1_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ������֤ҵ��" $fileId
        gwd::GWpublic_print "== FC5 == [expr {($flag2_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊɾ����֤ҵ��" $fileId
        gwd::GWpublic_print "== FC6 == [expr {($flag3_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ�޸���֤ҵ��" $fileId
        gwd::GWpublic_print "== FC7 == [expr {($flag4_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ��˿�ģʽΪPORT+SVLAN+CVLAN��PW VLAN����Ϊ�����֤ҵ��" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
        puts $fileId ""
        puts $fileId "**************************************************************************************"
        puts $fileId ""
        puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_007"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_007_REPORT.txt" "report\\NOK_GPN_PTN_007_REPORT.txt"
	file rename "log\\GPN_PTN_007_LOG.txt" "log\\NOK_GPN_PTN_007_LOG.txt"
} else {
	file rename "report\\GPN_PTN_007_REPORT.txt" "report\\OK_GPN_PTN_007_REPORT.txt"
	file rename "log\\GPN_PTN_007_LOG.txt" "log\\OK_GPN_PTN_007_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}
