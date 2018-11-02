#!/bin/sh
# T2_GPN_PTN_ELINE_002.tcl \
exec tclsh "$0" ${1+"$@"}
#�������ƣ�ptn002_1
#-----------------------------------------------------------------------------------------------------------------------------------
#����Ŀ�ģ�E-LINE�Ĺ���
#1-E-LINEҵ������֤  
#2-LSP��ǩ����������֤
#4-MS-PW������֤	                     	           
#---------------------------------------------------------------------------------------------------------------------------------
#�ű�����������
#1�����ղ������˴���Ի���:��GPN�Ĺ���˿ڣ�U/D����PC��������Internet������GPN��2��������
#   ��STC�˿ڣ� 9/9����9/10��
#2����GPN��������� ���ã���������vlan vid=4000���ڸ�vlan�����ù���IP����untagged��ʽ��ӹ���˿ڣ�U/D��
#-----------------------------------------------------------------------------------------------------------------------------------
#���Թ��̣�
##E-LINEҵ������֤  
#1���Test Case 1���Ի���
#   <1>��̨�豸NNI�˿�(GE�˿�)��tag��ʽ���뵽VLANIF 100��
#   <2>�û��ࣨGE�˿ڣ�����ģʽΪ�˿�ģʽ
#   <3>����LSP1
#      ����NE1��7600����LSP1���ǩ100������ǩ200��PW1���ر�ǩ1000��Զ�̱�ǩ2000
#      ����NE3��7600����LSP1���ǩ300������ǩ400��PW1���ر�ǩ2000��Զ�̱�ǩ1000  
#      ����NE2��7600S����SW���ǩ200������ǩ300
#   <4>NE1��NE3�û�������undo vlan check
#   <5>����PW1/AC1
#   <6>��NE1�Ķ˿�1����untag/tagҵ���������۲�NE3�Ķ˿�3�Ľ��ս��
#   Ԥ�ڽ����NE3�Ķ˿�3����������untag/tagҵ��������˫����untag/tagҵ�������
#   <7>ʹ��NE1��LSP1/PW1/AC1����ͳ�ƣ�ϵͳ���쳣������ͳ�ƹ�����Ч��ͳ��ֵ��ȷ
#   <8>ʹ��NE1�豸PW1�Ŀ����֣�������NE1��NNI�˿�egress������
#   Ԥ�ڽ����������Ϊ��VLAN TAG��ǩ����������mpls��ǩ���ģ����lsp��ǩ200���ڲ�pw��ǩ2000
#             LSP�ֶ��е�TTLֵΪ255��PW�ֶ��е�TTLֵΪ255��PW�ֶ��к���4�ֽڿ�����
#   <9>undo shutdown��shutdown NE1�豸��NNI/UNI�˿�50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
#   <10>����NE1�豸��NNI/UNI�˿����ڰ忨50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
#   <11>NE1�豸����SW/NMS����50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 ���鿴��ǩת��������ȷ����̨�豸��������
#   <12>��������NE1�豸��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ�������ϵͳ���쳣���鿴��ǩת��������ȷ����̨�豸�������� 
#2���Test Case 2���Ի���
#   <1>ɾ��NE1��NE3�豸��ר��ҵ��AC����ɾ���ɹ���ҵ���жϣ�ϵͳ���쳣
#   <2>���´���NE1��NE3�豸��AC�ڵ�ר��ҵ��AC),����α�ߣ�PW���������ģ�����������ģʽ��Ϊ���˿�+��Ӫ��VLAN��
#   <3>�û������ָ����vlan��
#   <4>��NE1��NE3�Ͼ����������VLAN��vlan 1000����������˿�
#   <5>��NE1�Ķ˿�1����tag1000��tag2000ҵ���������۲�NE3�Ķ˿�3�Ľ��ս��
#   Ԥ�ڽ�����ٴδ�������ģʽΪ���˿�+��Ӫ��VLAN����ר��ҵ�񣬳ɹ�������ϵͳ���쳣
#             NE3�Ķ˿�3ֻ�ɽ���tag1000ҵ��������˫����ҵ������
#   <6>ɾ��֮ǰ����ģʽ��Ϊ���˿�+��Ӫ��VLAN����AC
#   <7>��NE1��NE3�豸�ϴ���AC����ģʽ��Ϊ���˿�+��Ӫ��VLAN+�ͻ�VLAN��
#      ��Ӫ��VLANΪ vlan 3000���ͻ�VLANΪvlan 300
#   <8>��NE1��NE3�豸���ٴ���һ���µ�E-LINEҵ��(��֮ǰ��ҵ����ͬһ��LSP)����AC����ģʽ��Ϊ���˿�+��Ӫ��VLAN+�ͻ�VLAN��
#      ��Ӫ��VLANΪ vlan 1000���ͻ�VLANΪvlan 100
#   Ԥ�ڽ����ҵ��ɹ�������ϵͳ���쳣����֮ǰ��ҵ�����κθ���
#   <9>��NE1��UNI�˿ڷ���untag��tag100��tag1000�� ˫��tag����1000 ��100��ҵ���������۲�NE3��UNI�˿ڵĽ��ս��
#   Ԥ�ڽ����NE3��UNI�˿�ֻ�ɽ��յ�˫��tag����1000 ��100��ҵ����������֮ǰ��ҵ���޸��ţ�˫����ҵ������
#   <10>undo shutdown��shutdown NE3�豸��NNI/UNI�˿�50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
#   <11>����NE3�豸��NNI/UNI�˿����ڰ忨50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
#   <12>NE3�豸����SW/NMS����50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 ���鿴��ǩת��������ȷ����̨�豸��������
#   <13>��������NE3�豸��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ�������ϵͳ���쳣���鿴��ǩת��������ȷ����̨�豸�������� 
#3���Test Case 3���Ի���
#   <1>��NNI�˿ڸ���Ϊ10GE�˿ڣ������������䣬�ظ����ϲ���
#   <2>��UNI�˿ڸ���ΪFE/10GE�˿ڣ�NNI�˿ڸ���ΪGE/10GE�˿ڣ������������䣬�ظ����ϲ���
#   <3>��FE�˿�����ELINEҵ��ʱ���迪���ð忨��MPLSҵ��ģʽ��mpls enable <slot>��
##LSP��ǩ����������֤
#4���Test Case 4���Ի���
#   <1>���´���һ��NE1��NE3��E-LINEҵ��NNI�˿�(GE�˿�)��֮ǰ������ҵ���NNI�˿���ͬ����NNI�˿ڸ��ã�
#      ֻ����tag��ʽ���뵽����VLANIF 200�У��û��ࣨGE�˿ڣ�����ģʽΪ�˿�ģʽ�������´���LSP��PW��AC
#   <2>����NE1��LSP10���ǩ16������ǩ17��PW10���ر�ǩ20��Զ�̱�ǩ21
#      ����NE3��LSP10���ǩ18������ǩ19��PW10���ر�ǩ21��Զ�̱�ǩ20 
#      NE2��SW���ã����ǩ17������ǩ18 ��mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000> <1-65535> [normal|ring]��
#      Ԥ�ڽ����ҵ�����óɹ�����֮ǰ��E-LINEҵ����Ӱ�죬ϵͳ���쳣
#   <3>NE1��NE3�û�������undo vlan check
#   <4>����PW1/AC1
#   <5>��NE1�Ķ˿�1����untag/tagҵ���������۲�NE3�Ķ˿�3�Ľ��ս��
#   Ԥ�ڽ����NE3�Ķ˿�3����������untag/tagҵ��������˫����untag/tagҵ�����������֮ǰ��ҵ���޸���
#   <6>����NE1��NNI�˿�egress������
#   Ԥ�ڽ����������Ϊ��VLAN TAG��ǩ����������mpls��ǩ���ģ����lsp��ǩ17���ڲ�pw��ǩ21
#             LSP�ֶ��е�TTLֵΪ255��PW�ֶ��е�TTLֵΪ255��PW�ֶ��к���4�ֽڿ�����
#   <7>����NE2��NNI�˿�egress����ͬ������ץ�������ǩ������ǩ����Ϊ18���ڲ��ǩ21��LSP�ֶ��е�TTLֵ��1��PW�ֶ��е�TTLֵ��Ϊ255
#   <8>undo shutdown��shutdown NE1��NE2�豸��NNI/UNI�˿�50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
#   <9>����NE1��NE2�豸��NNI/UNI�˿����ڰ忨50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
#   <10>NE1��NE2�豸����SW/NMS����50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 ���鿴��ǩת��������ȷ
#   <11>��������NE1��NE2�豸��50�Σ�ÿ�β�����ϵͳ����������ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣���鿴��ǩת��������ȷ
##MS-PW������֤
#5���Test Case 5���Ի���
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
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
  	close stdout
  	file mkdir "log"
  	set fd_log [open "log\\GPN_PTN_002_1_LOG.txt" a]
  	set stdout $fd_log
  	chan configure $stdout -blocking 0 -buffering none;#������ģʽ ����flush
	log_file log\\GPN_PTN_002_1_LOG.txt
	
  	file mkdir "report"
  	set fileId [open "report\\GPN_PTN_002_1_REPORT.txt" a+]
	chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_002_1_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_002_1_DEBUG.txt 0
	chan configure $fd_debug -blocking 0 -buffering none;#������ģʽ ����flush
  	
        source test\\PTN_VarSet.tcl
        source test\\PTN_Mode_Function.tcl
	
	array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
	array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "100" -pri "000"}
	array set dataArr3 {-srcMac "00:00:00:00:00:03" -dstMac "00:00:00:00:00:33" -srcIp "192.85.1.3" -dstIp "192.0.0.3"}
	array set dataArr4 {-srcMac "00:00:00:00:00:04" -dstMac "00:00:00:00:00:44" -srcIp "192.85.1.4" -dstIp "192.0.0.4" -vid "100" -pri "000"}
	array set dataArr5 {-srcMac "00:00:00:00:00:05" -dstMac "00:00:00:00:00:55" -srcIp "192.85.1.5" -dstIp "192.0.0.5" -vid "1000" -pri "000"}
	array set dataArr6 {-srcMac "00:00:00:00:00:06" -dstMac "00:00:00:00:00:66" -srcIp "192.85.1.6" -dstIp "192.0.0.6" -vid "2000" -pri "000"}
	array set dataArr7 {-srcMac "00:00:00:00:00:07" -dstMac "00:00:00:00:00:77" -srcIp "192.85.1.7" -dstIp "192.0.0.7" -vid "300" -pri "000"}
	array set dataArr8 {-srcMac "00:00:00:00:00:08" -dstMac "00:00:00:00:00:88" -srcIp "192.85.1.8" -dstIp "192.0.0.8" -vid "3000" -pri "000"}
	array set dataArr9 {-srcMac "00:00:00:00:00:09" -dstMac "00:00:00:00:00:99" -srcIp "192.85.1.9" -dstIp "192.0.0.9" -vid1 "3000" -pri1 "000" -vid2 "300" -pri2 "000"}
	array set dataArr10 {-srcMac "00:00:00:00:00:0a" -dstMac "00:00:00:00:00:aa" -srcIp "192.85.1.10" -dstIp "192.0.0.10" -vid1 "1000" -pri1 "000" -vid2 "100" -pri2 "000"}
	array set dataArr11 {-srcMac "00:00:00:00:00:0b" -dstMac "00:00:00:00:00:bb" -srcIp "192.85.1.11" -dstIp "192.0.0.11"}
	array set dataArr12 {-srcMac "00:00:00:00:00:0c" -dstMac "00:00:00:00:00:cc" -srcIp "192.85.1.12" -dstIp "192.0.0.12" -vid "500" -pri "000"}
	array set dataArr13 {-srcMac "00:00:00:00:00:0d" -dstMac "00:00:00:00:00:dd" -srcIp "192.85.1.13" -dstIp "192.0.0.13"}
        array set dataArr14 {-srcMac "00:00:00:00:00:0e" -dstMac "00:00:00:00:00:ee" -srcIp "192.85.1.14" -dstIp "192.0.0.14" -vid "500" -pri "000"}
        array set dataArr15 {-srcMac "00:00:00:00:00:15" -dstMac "00:00:00:00:15:15" -srcIp "192.85.1.15" -dstIp "192.0.0.15" -vid "100" -pri "000" -etherType "8847" -pattern "000c90ff003e91ff"}
        array set dataArr16 {-srcMac "00:00:00:00:00:16" -dstMac "00:00:00:00:16:16" -srcIp "192.85.1.16" -dstIp "192.0.0.16" -vid "100" -pri "000" -etherType "8847" -pattern "001910ff007d11ff"}
	###���ö�����Ϣ����
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        
        #���÷���������
        set GenCfg {-SchedulingMode RATE_BASED}
        
        #���ù��˷���������
	###smac��vid
        set anaFliFrameCfg1 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><vlans name="anon_13224"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        ###smac
        set anaFliFrameCfg0 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        ###mpls�����е������ǩ
        set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
        ###mpls�����еĴ���vid��Experimental Bits (bits)/Bottom of stack (bit)
        set anaFliFrameCfg3 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4647"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><exp override="true"  filterMinValue="0" filterMaxValue="111">111</exp></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><sBit override="true"  filterMinValue="0" filterMaxValue="1">1</sBit></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
        ###ƥ������vid
        set anaFliFrameCfg4 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5580"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	
	set rateL 95000000;#�շ�������ȡֵ��Сֵ��Χ
	set rateR 105000000;#�շ�������ȡֵ���ֵ��Χ
	set rateL1 100000000 
	set rateR1 125000000 

	set flagCase1 0   ;#Test case 1��־λ 
	set flagCase2 0   ;#Test case 2��־λ
	set flagCase3 0   ;#Test case 3��־λ 
	set flagCase4 0   ;#Test case 4��־λ
	set flagCase5 0   ;#Test case 5��־λ 
	
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
	#Ϊ���Խ���Ԥ������
	for {set i 0} {$i < 80} {incr i} {
	    puts $fileId "                                                                                                                                                                                                                "	
	}
	
	proc Test_Case1 {printWord rateL rateR id} {
		global gpnIp1
		global gpnIp3
		global GPNTestEth3
		global GPNTestEth4
		global anaFliFrameCfg1
		global fileId
		
		set  flag 0
		gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
		sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 $id
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$id-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$id-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
		parray aGPNPort3Cnt1
		parray aGPNPort3Cnt2
		parray aGPNPort4Cnt1
		parray aGPNPort4Cnt2
		if {$aGPNPort4Cnt1(cnt1) < $rateL || $aGPNPort4Cnt1(cnt1) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($gpnIp1)$GPNTestEth3\����untag������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������Ϊ$aGPNPort4Cnt1(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($gpnIp1)$GPNTestEth3\����untag������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������Ϊ$aGPNPort4Cnt1(cnt1)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$aGPNPort4Cnt1(cnt2)< $rateL || $aGPNPort4Cnt1(cnt2)> $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($gpnIp1)$GPNTestEth3\����tag=100������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������Ϊ$aGPNPort4Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($gpnIp1)$GPNTestEth3\����tag=100������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������Ϊ$aGPNPort4Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$aGPNPort4Cnt1(cnt15) < $rateL || $aGPNPort4Cnt1(cnt15) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($gpnIp1)$GPNTestEth3\����tag=100��mpls������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������Ϊ$aGPNPort4Cnt1(cnt15)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($gpnIp1)$GPNTestEth3\����tag=100��mpls������ʱ��NE3($gpnIp3)$GPNTestEth4\�յ�������������Ϊ$aGPNPort4Cnt1(cnt15)����$rateL-$rateR\��Χ��" $fileId
		}
		return $flag
	}
	########################################################################################################
	#�������ܣ��������������õ����Խ��
	#�������: capFlag��=1ץ��   =0��ץ��
	#	lGenPort�������������Ķ˿�Gen handle�б�
	#	  lAnaPort�������������Ķ˿�ana handle�б�
	#         lPort��ץ���˿��б�
	#         lCapPara��ץ���˿���ز����б�cap capAna ip���˿������豸��ip��
	#	  vlanCnt�����������õ�vlan���� 0������vlan 1������vlan   =2��˫��vlan
	#	  capFlag���Ƿ�ץ������ȫ�ֱ���cap_enable=1�ĵ������capFlag������Ч  =1ץ��    =0��ץ��
	#��������� aGPNCnt1 aGPNCnt2 aGPNCnt3����lAnaPort�˿����Ӧ	  
	#����ֵ�� ��
	########################################################################################################
	proc SendAndStat_ptn002_1 {capFlag lGenPort lAnaPort lPort lCapPara lAnaFrameCfgFil aGPNCnt1 aGPNCnt2 aGPNCnt3 vlanCnt caseId} {
		upvar $aGPNCnt1 aTmpCnt1
		upvar $aGPNCnt2 aTmpCnt2
		upvar $aGPNCnt3 aTmpCnt3
		array set aTmpCnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0 \
			    cnt11 0 cnt12 0 cnt13 0 cnt14 0 cnt15 0 cnt16 0 cnt17 0 cnt18 0 cnt19 0 cnt20 0 cnt21 0} 
		array set aTmpCnt2 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0 \
			    cnt11 0 cnt12 0 cnt13 0 cnt14 0 cnt15 0 cnt16 0 cnt17 0 cnt18 0 cnt19 0 cnt20 0 cnt21 0} 
		array set aTmpCnt3 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0 \
			    cnt11 0 cnt12 0 cnt13 0 cnt14 0 cnt15 0 cnt16 0 cnt17 0 cnt18 0 cnt19 0 cnt20 0 cnt21 0}
		if {$vlanCnt == 0} {
			set matchPara 0
			foreach anaFrameCfgFil $lAnaFrameCfgFil {
				gwd::Cfg_AnalyzerFrameCfgFilter $anaFrameCfgFil $::anaFliFrameCfg0
			}
		} elseif {$vlanCnt == 1} {
			set matchPara 1
			foreach anaFrameCfgFil $lAnaFrameCfgFil {
				gwd::Cfg_AnalyzerFrameCfgFilter $anaFrameCfgFil $::anaFliFrameCfg1
			}
		} elseif {$vlanCnt == 2} {
			set matchPara 1
			foreach anaFrameCfgFil $lAnaFrameCfgFil {
				gwd::Cfg_AnalyzerFrameCfgFilter $anaFrameCfgFil $::anaFliFrameCfg4
			}
		}
		if {($::cap_enable == 1) && ($capFlag == 1)} {
			foreach {cap capAna ip} $lCapPara {
				gwd::Start_CapAllData ::capArr $cap $capAna
			}
		}
		
		gwd::Start_SendFlow $lGenPort  $lAnaPort
		after 10000
		if {($::cap_enable == 1) && ($capFlag == 1)} {
			foreach {cap capAna ip} $lCapPara port $lPort {
				regsub {/} $port {_} port_cap
				gwd::Stop_CapData $cap 1 "$caseId-p$port_cap\($ip\).pcap"
			}  
		}
		set i 1
		foreach hAnaPort $lAnaPort {
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt1 $matchPara $hAnaPort aTmpCnt$i]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 1 1 1 1 0 0
				after 5000
			}
			incr i
		}
		gwd::Stop_SendFlow $lGenPort $lAnaPort
	}
	proc Test_Case2 {printWord rateL rateR caseId} {
		global gpnIp1
		global gpnIp3
		global GPNTestEth3
		global GPNTestEth4
		
		global fileId
		
		set  flag 0
		sendAndStat2 aGPNPort3Cnt4 aGPNPort4Cnt4 aGPNPort3Cnt41 aGPNPort4Cnt41 aGPNPort3Cnt40 aGPNPort4Cnt40 $caseId
		parray aGPNPort3Cnt4
		parray aGPNPort4Cnt4
		parray aGPNPort3Cnt41
		parray aGPNPort4Cnt41
		parray aGPNPort3Cnt40
		parray aGPNPort4Cnt40
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
		if {$aGPNPort4Cnt40(cnt10) ==0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW1:vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\�������tag=1000�ڲ�tag=100\
				����������NE3($gpnIp3) $GPNTestEth4\�յ����ݰ�������Ϊ0" $fileId
		} else {
                	if {$aGPNPort4Cnt4(cnt10) > $rateR || $aGPNPort4Cnt4(cnt10) < $rateL} {
                		set flag 1
                		gwd::GWpublic_print "NOK" "$printWord PW1:vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\�������tag=1000�ڲ�tag=100\
                			����������NE3($gpnIp3) $GPNTestEth4\�յ����tag=1000�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
                	} else {
                		gwd::GWpublic_print "OK" "$printWord PW1:vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\�������tag=1000�ڲ�tag=100\
                			����������NE3($gpnIp3) $GPNTestEth4\�յ����tag=1000�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt10)����$rateL-$rateR\��Χ��" $fileId
                	}
		}
		if {$aGPNPort4Cnt40(cnt9) == 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2:������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\�������tag=3000�ڲ�tag=300\
				����������NE3($gpnIp3) $GPNTestEth4\�յ����ݰ�������Ϊ0" $fileId
		} else {
                	if {$aGPNPort4Cnt4(cnt9) > $rateR || $aGPNPort4Cnt4(cnt9) < $rateL} {
                		set flag 1
                		gwd::GWpublic_print "NOK" "$printWord PW2:������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\�������tag=3000�ڲ�tag=300\
                			����������NE3($gpnIp3) $GPNTestEth4\�յ����tag=3000�ڲ�tag=300�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt9)��û��$rateL-$rateR\��Χ��" $fileId
                	} else {
                		gwd::GWpublic_print "OK" "$printWord PW2:������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\�������tag=3000�ڲ�tag=300\
                			����������NE3($gpnIp3) $GPNTestEth4\�յ����tag=3000�ڲ�tag=300�����ݰ�����Ϊ$aGPNPort4Cnt4(cnt9)����$rateL-$rateR\��Χ��" $fileId
                	}
		}
		if {$aGPNPort3Cnt40(cnt10) == 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW1:vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\�������tag=1000�ڲ�tag=100\
				����������NE1($gpnIp1) $GPNTestEth3\�յ����ݰ�������Ϊ0" $fileId
		} else {
                	if {$aGPNPort3Cnt4(cnt10) > $rateR || $aGPNPort3Cnt4(cnt10) < $rateL} {
                		set flag 1
                		gwd::GWpublic_print "NOK" "$printWord PW1:vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\�������tag=1000�ڲ�tag=100\
                			����������NE1($gpnIp1) $GPNTestEth3\�յ����tag=1000�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort3Cnt4(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
                	} else {
                		gwd::GWpublic_print "OK" "$printWord PW1:vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\�������tag=1000�ڲ�tag=100\
                			����������NE1($gpnIp1) $GPNTestEth3\�յ����tag=1000�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort3Cnt4(cnt10)����$rateL-$rateR\��Χ��" $fileId
                	}
		}
		if {$aGPNPort3Cnt40(cnt9) == 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2:������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\�������tag=3000�ڲ�tag=300\
				����������NE1($gpnIp1) $GPNTestEth3\�յ����ݰ�������Ϊ0" $fileId
		} else {
                	if {$aGPNPort3Cnt4(cnt9) > $rateR || $aGPNPort3Cnt4(cnt9) < $rateL} {
                		set flag 1
                		gwd::GWpublic_print "NOK" "$printWord PW2:������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\�������tag=3000�ڲ�tag=300\
                			����������NE1($gpnIp1) $GPNTestEth3\�յ����tag=3000�ڲ�tag=300�����ݰ�����Ϊ$aGPNPort3Cnt4(cnt9)��û��$rateL-$rateR\��Χ��" $fileId
                	} else {
                		gwd::GWpublic_print "OK" "$printWord PW2:������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\�������tag=3000�ڲ�tag=300\
                			����������NE1($gpnIp1) $GPNTestEth3\�յ����tag=3000�ڲ�tag=300�����ݰ�����Ϊ$aGPNPort3Cnt4(cnt9)����$rateL-$rateR\��Χ��" $fileId
                	}
		}
		if {$aGPNPort4Cnt40(cnt1) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\����untag��������NE3($gpnIp3) \
				$GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt40(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\����untag��������NE3($gpnIp3) \
				$GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt40(cnt1)" $fileId
		}
		if {$aGPNPort4Cnt40(cnt7) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\����tag=300��������NE3($gpnIp3) \
			$GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt40(cnt7)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\����tag=300��������NE3($gpnIp3) \
				$GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt40(cnt7)" $fileId
		}
		if {$aGPNPort4Cnt40(cnt8) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\����tag=3000��������NE3($gpnIp3) \
			$GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt40(cnt8)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\����tag=3000��������NE3($gpnIp3) \
				$GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt40(cnt8)" $fileId
		}
		if {$aGPNPort3Cnt40(cnt3) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\����untag��������\
				NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt40(cnt3)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\����untag��������\
				NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt40(cnt3)" $fileId
		}
		if {$aGPNPort3Cnt40(cnt7) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\����tag=300��������\
				NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt40(cnt7)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\����tag=300��������\
				NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt40(cnt7)" $fileId
		}
		if {$aGPNPort3Cnt40(cnt8) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\����tag=3000��������\
				NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt40(cnt8)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\����tag=3000��������\
				NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt40(cnt8)" $fileId
		}
		return $flag
	}
	
	proc Test_Case4 {printWord rateL rateR caseId} {
		global gpnIp1
		global gpnIp3
		global GPNTestEth2
		global GPNTestEth3
		global GPNTestEth4
		global hGPNPort2Gen
		global hGPNPort3Gen
		global hGPNPort4Gen
		global hGPNPort2Ana
		global hGPNPort3Ana
		global hGPNPort4Ana
		global hGPNPort2Cap
		global hGPNPort3Cap
		global hGPNPort4Cap
		global hGPNPort2CapAnalyzer
		global hGPNPort3CapAnalyzer
		global hGPNPort4CapAnalyzer
		global hGPNPort2AnaFrameCfgFil
		global hGPNPort3AnaFrameCfgFil
		global hGPNPort4AnaFrameCfgFil
		global fileId
		
		set  flag 0
		
		SendAndStat_ptn002_1 1 "$hGPNPort2Gen $hGPNPort3Gen $hGPNPort4Gen" "$hGPNPort2Ana $hGPNPort3Ana $hGPNPort4Ana" "$GPNTestEth2 $GPNTestEth3 $GPNTestEth4" \
        		"$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp1 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
        		"$hGPNPort2AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" aGPNPort2Cnt0 aGPNPort3Cnt0 aGPNPort4Cnt0 0 $caseId
        	SendAndStat_ptn002_1 0 "$hGPNPort2Gen $hGPNPort3Gen $hGPNPort4Gen" "$hGPNPort2Ana $hGPNPort3Ana $hGPNPort4Ana" "$GPNTestEth2 $GPNTestEth3 $GPNTestEth4" \
        		"$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp1 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
        		"$hGPNPort2AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" aGPNPort2Cnt1 aGPNPort3Cnt1 aGPNPort4Cnt1 1 $caseId
        	SendAndStat_ptn002_1 0 "$hGPNPort2Gen $hGPNPort3Gen $hGPNPort4Gen" "$hGPNPort2Ana $hGPNPort3Ana $hGPNPort4Ana" "$GPNTestEth2 $GPNTestEth3 $GPNTestEth4" \
        		"$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp1 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
        		"$hGPNPort2AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" aGPNPort2Cnt2 aGPNPort3Cnt2 aGPNPort4Cnt2 2 $caseId
        	parray aGPNPort2Cnt0
        	parray aGPNPort3Cnt0
        	parray aGPNPort4Cnt0
        	parray aGPNPort2Cnt1
        	parray aGPNPort3Cnt1
        	parray aGPNPort4Cnt1
        	parray aGPNPort2Cnt2
        	parray aGPNPort3Cnt2
        	parray aGPNPort4Cnt2
        	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp1\).pcap" $fileId
        	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
        	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        	if {$aGPNPort4Cnt0(cnt10) ==0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp1 PW1:vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\�������tag=1000�ڲ�tag=100\
        			����������NE3($gpnIp3) $GPNTestEth4\�յ����ݰ�������Ϊ0" $fileId
        	} else {
        		if {$aGPNPort4Cnt2(cnt10) > $rateR || $aGPNPort4Cnt2(cnt10) < $rateL} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord Lsp1 PW1:vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\�������tag=1000�ڲ�tag=100\
        				����������NE3($gpnIp3) $GPNTestEth4\�յ����tag=1000�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt2(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord Lsp1 PW1:vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\�������tag=1000�ڲ�tag=100\
        				����������NE3($gpnIp3) $GPNTestEth4\�յ����tag=1000�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt2(cnt10)����$rateL-$rateR\��Χ��" $fileId
        		}
        	}
        	if {$aGPNPort4Cnt0(cnt9) == 0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2:������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\�������tag=3000�ڲ�tag=300\
        			����������NE3($gpnIp3) $GPNTestEth4\�յ����ݰ�������Ϊ0" $fileId
        	} else {
        		if {$aGPNPort4Cnt2(cnt9) > $rateR || $aGPNPort4Cnt2(cnt9) < $rateL} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2:������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\�������tag=3000�ڲ�tag=300\
        				����������NE3($gpnIp3) $GPNTestEth4\�յ����tag=3000�ڲ�tag=300�����ݰ�����Ϊ$aGPNPort4Cnt2(cnt9)��û��$rateL-$rateR\��Χ��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord Lsp1 PW2:������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\�������tag=3000�ڲ�tag=300\
        				����������NE3($gpnIp3) $GPNTestEth4\�յ����tag=3000�ڲ�tag=300�����ݰ�����Ϊ$aGPNPort4Cnt2(cnt9)����$rateL-$rateR\��Χ��" $fileId
        		}
        	}
        	if {$aGPNPort3Cnt0(cnt10) == 0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp1 PW1:vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\�������tag=1000�ڲ�tag=100\
        			����������NE1($gpnIp1) $GPNTestEth3\�յ����ݰ�������Ϊ0" $fileId
        	} else {
        		if {$aGPNPort3Cnt2(cnt10) > $rateR || $aGPNPort3Cnt2(cnt10) < $rateL} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord Lsp1 PW1:vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\�������tag=1000�ڲ�tag=100\
        				����������NE1($gpnIp1) $GPNTestEth3\�յ����tag=1000�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort3Cnt2(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord Lsp1 PW1:vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\�������tag=1000�ڲ�tag=100\
        				����������NE1($gpnIp1) $GPNTestEth3\�յ����tag=1000�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort3Cnt2(cnt10)����$rateL-$rateR\��Χ��" $fileId
        		}
        	}
        	if {$aGPNPort3Cnt0(cnt9) == 0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2:������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\�������tag=3000�ڲ�tag=300\
        			����������NE1($gpnIp1) $GPNTestEth3\�յ����ݰ�������Ϊ0" $fileId
        	} else {
        		if {$aGPNPort3Cnt2(cnt9) > $rateR || $aGPNPort3Cnt2(cnt9) < $rateL} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2:������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\�������tag=3000�ڲ�tag=300\
        				����������NE1($gpnIp1) $GPNTestEth3\�յ����tag=3000�ڲ�tag=300�����ݰ�����Ϊ$aGPNPort3Cnt2(cnt9)��û��$rateL-$rateR\��Χ��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord Lsp1 PW2:������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\�������tag=3000�ڲ�tag=300\
        				����������NE1($gpnIp1) $GPNTestEth3\�յ����tag=3000�ڲ�tag=300�����ݰ�����Ϊ$aGPNPort3Cnt2(cnt9)����$rateL-$rateR\��Χ��" $fileId
        		}
        	}
		if {$printWord == ""} {
			if {$aGPNPort4Cnt0(cnt7) !=0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\����tag=300��������NE3($gpnIp3) \
				$GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt0(cnt7)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord Lsp1 PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\����tag=300��������NE3($gpnIp3) \
					$GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt0(cnt7)" $fileId
			}
			if {$aGPNPort4Cnt0(cnt8) !=0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\����tag=3000��������NE3($gpnIp3) \
				$GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt0(cnt8)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord Lsp1 PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE1($gpnIp1) $GPNTestEth3\����tag=3000��������NE3($gpnIp3) \
					$GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt0(cnt8)" $fileId
			}
			
			if {$aGPNPort3Cnt0(cnt7) !=0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\����tag=300��������\
					NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt0(cnt7)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord Lsp1 PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\����tag=300��������\
					NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt0(cnt7)" $fileId
			}
			if {$aGPNPort3Cnt0(cnt8) !=0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\����tag=3000��������\
					NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt0(cnt8)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord Lsp1 PW2��������vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)��NE3($gpnIp3) $GPNTestEth4\����tag=3000��������\
					NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt0(cnt8)" $fileId
			}
			
		}
        	if {$aGPNPort4Cnt1(cnt11) !=0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp10 PW10��������vctype(NE1:PORT----NE3:PORT+VLAN)��NE1($gpnIp1) $GPNTestEth2\����untag��������\
        			NE3($gpnIp3) $GPNTestEth4\����tag=500�����ݰ�����ӦΪ0ʵΪ$aGPNPort4Cnt1(cnt11)" $fileId
        	} else {
        		if {$aGPNPort4Cnt0(cnt11) > $rateR || $aGPNPort4Cnt0(cnt11) < $rateL} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord Lsp10 PW10��������vctype(NE1:PORT----NE3:PORT+VLAN)��NE1($gpnIp1) $GPNTestEth2\����untag����������\
        				NE3($gpnIp3) $GPNTestEth4\�յ�untag�����ݰ�����Ϊ$aGPNPort4Cnt0(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord Lsp10 PW10��������vctype(NE1:PORT----NE3:PORT+VLAN)��NE1($gpnIp1) $GPNTestEth2\����untag����������\
        				NE3($gpnIp3) $GPNTestEth4\�յ�untag�����ݰ�����Ϊ$aGPNPort4Cnt0(cnt11)����$rateL-$rateR\��Χ��" $fileId
        		}
        	}
        	if {$aGPNPort4Cnt1(cnt12) > $rateR || $aGPNPort4Cnt1(cnt12) < $rateL} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp10 PW10��������vctype(NE1:PORT----NE3:PORT+VLAN)��NE1($gpnIp1) $GPNTestEth2\����tag=500����������\
        			NE3($gpnIp3) $GPNTestEth4\�յ�tag=500�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt12)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord Lsp10 PW10��������vctype(NE1:PORT----NE3:PORT+VLAN)��NE1($gpnIp1) $GPNTestEth2\����tag=500����������\
        			NE3($gpnIp3) $GPNTestEth4\�յ�tag=500�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt12)����$rateL-$rateR\��Χ��" $fileId
        	}
        	
        	if {$aGPNPort2Cnt0(cnt13) !=0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp10 PW10��������vctype(NE1:PORT----NE3:PORT+VLAN)��NE3($gpnIp3) $GPNTestEth4\����untag��������\
        			NE1($gpnIp1) $GPNTestEth2\�������ݰ�������ӦΪ0ʵΪ$aGPNPort2Cnt0(cnt13)" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord Lsp10 PW10��������vctype(NE1:PORT----NE3:PORT+VLAN)��NE3($gpnIp3) $GPNTestEth4\����untag��������\
        			NE1($gpnIp1) $GPNTestEth2\�������ݰ�������ӦΪ0ʵΪ$aGPNPort2Cnt0(cnt13)" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt14) > $rateR || $aGPNPort2Cnt1(cnt14) < $rateL} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp10 PW10��������vctype(NE1:PORT----NE3:PORT+VLAN)��NE3($gpnIp3) $GPNTestEth4\����tag=500��������\
        			NE1($gpnIp1) $GPNTestEth2\�յ�tag=500�����ݰ�����Ϊ$aGPNPort2Cnt1(cnt14)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord Lsp10 PW10��������vctype(NE1:PORT----NE3:PORT+VLAN)��NE3($gpnIp3) $GPNTestEth4\����tag=500��������\
        			NE1($gpnIp1) $GPNTestEth2\�յ�tag=500�����ݰ�����Ϊ$aGPNPort2Cnt1(cnt14)����$rateL-$rateR\��Χ��" $fileId
        	}
		return $flag
	}
	proc Test_Case5 {printWord rateL rateR caseId} {
		global gpnIp1
		global gpnIp3
		global GPNTestEth3
		global GPNTestEth4
		global hGPNPort3Gen
		global hGPNPort4Gen
		global hGPNPort3Ana
		global hGPNPort4Ana
		global hGPNPort3Cap
		global hGPNPort4Cap
		global hGPNPort3CapAnalyzer
		global hGPNPort4CapAnalyzer
		global hGPNPort3AnaFrameCfgFil
		global hGPNPort4AnaFrameCfgFil
		global fileId
			
		set  flag 0
		
		SendAndStat_ptn002_1 1 "$hGPNPort3Gen $hGPNPort4Gen" "$hGPNPort3Ana $hGPNPort4Ana" "$GPNTestEth3 $GPNTestEth4" \
			"$hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
			"$hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" aGPNPort3Cnt0 aGPNPort4Cnt0 aTmpCnt 0 $caseId
		SendAndStat_ptn002_1 0 "$hGPNPort3Gen $hGPNPort4Gen" "$hGPNPort3Ana $hGPNPort4Ana" "$GPNTestEth3 $GPNTestEth4" \
			"$hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
			"$hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" aGPNPort3Cnt1 aGPNPort4Cnt1 aTmpCnt 1 $caseId
		parray aGPNPort3Cnt0
		parray aGPNPort4Cnt0
		parray aGPNPort3Cnt1
		parray aGPNPort4Cnt1
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
		
		if {$aGPNPort4Cnt1(cnt1) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord (NE1:PORT----NE3:PORT+VLAN)��NE1($gpnIp1) $GPNTestEth3\����untag����������\
				NE3($gpnIp3) $GPNTestEth4\�յ�tag=100�����ݰ�����ӦΪ0��ʵΪ$aGPNPort4Cnt1(cnt1)" $fileId
		} else {
			if {$aGPNPort4Cnt0(cnt1) > $rateR || $aGPNPort4Cnt0(cnt1) < $rateL} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord (NE1:PORT----NE3:PORT+VLAN)��NE1($gpnIp1) $GPNTestEth3\����untag����������\
					NE3($gpnIp3) $GPNTestEth4\�յ�untag�����ݰ�����Ϊ$aGPNPort4Cnt0(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord (NE1:PORT----NE3:PORT+VLAN)��NE1($gpnIp1) $GPNTestEth3\����untag����������\
					NE3($gpnIp3) $GPNTestEth4\�յ�untag�����ݰ�����Ϊ$aGPNPort4Cnt0(cnt1)����$rateL-$rateR\��Χ��" $fileId
			}
		}
		if {$aGPNPort4Cnt1(cnt2) > $rateR || $aGPNPort4Cnt1(cnt2) < $rateL} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord (NE1:PORT----NE3:PORT+VLAN)��NE1($gpnIp1) $GPNTestEth3\����tag=100����������\
				NE3($gpnIp3) $GPNTestEth4\�յ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord (NE1:PORT----NE3:PORT+VLAN)��NE1($gpnIp1) $GPNTestEth3\����tag=100����������\
				NE3($gpnIp3) $GPNTestEth4\�յ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$aGPNPort3Cnt0(cnt13) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord (NE1:PORT----NE3:PORT+VLAN)��NE3($gpnIp3) $GPNTestEth4\����untag��������\
				NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt0(cnt13)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord (NE1:PORT----NE3:PORT+VLAN)��NE3($gpnIp3) $GPNTestEth4\����untag��������\
				NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt0(cnt13)" $fileId
		}
		if {$aGPNPort3Cnt1(cnt14) > $rateR || $aGPNPort3Cnt1(cnt14) < $rateL} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord (NE1:PORT----NE3:PORT+VLAN)��NE3($gpnIp3) $GPNTestEth4\����tag=500��������\
				NE1($gpnIp1) $GPNTestEth3\�յ�tag=500�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt14)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord (NE1:PORT----NE3:PORT+VLAN)��NE3($gpnIp3) $GPNTestEth4\����tag=500��������\
				NE1($gpnIp1) $GPNTestEth3\�յ�tag=500�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt14)����$rateL-$rateR\��Χ��" $fileId
		}
		return $flag
	}
	puts $fileId "��¼�����豸...\n"
	puts $fileId "\n=====��¼�����豸1====\n"
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	puts $fileId "\n=====��¼�����豸2====\n"
	set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
	puts $fileId "\n=====��¼�����豸3====\n"
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	#���ڵ��������豸�õ��ı���------
	set lSpawn_id "$telnet1 $telnet2 $telnet3"
	set lMatchType "$matchType1 $matchType2 $matchType3"
	set lDutType "$Gpn_type1 $Gpn_type2 $Gpn_type3"
	set lIp "$gpnIp1 $gpnIp2 $gpnIp3"
	#------���ڵ��������豸�õ��ı���
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "�������Թ���...\n"
	set hPtnProject [stc::create project]
	set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3\
			\"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4	
        #������������
        gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort3 hGPNPort3Stream1
        gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort3 hGPNPort3Stream2
        gwd::STC_Create_VlanMplsCustomStream $fileId dataArr15 $hGPNPort3 hGPNPort3Stream15
        gwd::STC_Create_VlanMplsCustomStream $fileId dataArr16 $hGPNPort4 hGPNPort4Stream16
        gwd::STC_Create_Stream $fileId dataArr3 $hGPNPort4 hGPNPort4Stream3
        gwd::STC_Create_VlanStream $fileId dataArr4 $hGPNPort4 hGPNPort4Stream4
        gwd::STC_Create_Stream $fileId dataArr11 $hGPNPort2 hGPNPort2Stream11
        gwd::STC_Create_VlanStream $fileId dataArr12 $hGPNPort2 hGPNPort2Stream12
        gwd::STC_Create_Stream $fileId dataArr13 $hGPNPort4 hGPNPort4Stream13
        gwd::STC_Create_VlanStream $fileId dataArr14 $hGPNPort4 hGPNPort4Stream14
        gwd::STC_Create_VlanStream $fileId dataArr5 $hGPNPort3 hGPNPort3Stream5
        gwd::STC_Create_VlanStream $fileId dataArr6 $hGPNPort3 hGPNPort3Stream6
        gwd::STC_Create_VlanStream $fileId dataArr5 $hGPNPort4 hGPNPort4Stream5
        gwd::STC_Create_VlanStream $fileId dataArr6 $hGPNPort4 hGPNPort4Stream6
        
        gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort3 hGPNPort3Stream7
        gwd::STC_Create_VlanStream $fileId dataArr8 $hGPNPort3 hGPNPort3Stream8
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr9 $hGPNPort3 hGPNPort3Stream9
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr10 $hGPNPort3 hGPNPort3Stream10
        gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort4 hGPNPort4Stream7
        gwd::STC_Create_VlanStream $fileId dataArr8 $hGPNPort4 hGPNPort4Stream8
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr9 $hGPNPort4 hGPNPort4Stream9
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr10 $hGPNPort4 hGPNPort4Stream10
	
	set lHStream "$hGPNPort3Stream1 $hGPNPort3Stream2 $hGPNPort4Stream3 $hGPNPort4Stream4 $hGPNPort2Stream11 $hGPNPort2Stream12 $hGPNPort4Stream13\
			$hGPNPort4Stream14 $hGPNPort3Stream5 $hGPNPort3Stream6 $hGPNPort4Stream5 $hGPNPort4Stream6 $hGPNPort3Stream7 $hGPNPort3Stream8\
			$hGPNPort3Stream9 $hGPNPort4Stream7 $hGPNPort4Stream8 $hGPNPort4Stream9 $hGPNPort3Stream10 $hGPNPort4Stream10 $hGPNPort3Stream15\
			$hGPNPort4Stream16"
	stc::perform streamBlockActivate -streamBlockList $lHStream -activate "false"
	
        ##��ȡ�������ͷ�����ָ��
        gwd::Get_Generator $hGPNPort1 hGPNPort1Gen
        gwd::Get_Analyzer $hGPNPort1 hGPNPort1Ana
        gwd::Get_Generator $hGPNPort2 hGPNPort2Gen
        gwd::Get_Analyzer $hGPNPort2 hGPNPort2Ana
        gwd::Get_Generator $hGPNPort3 hGPNPort3Gen
        gwd::Get_Analyzer $hGPNPort3 hGPNPort3Ana
        gwd::Get_Generator $hGPNPort4 hGPNPort4Gen
        gwd::Get_Analyzer $hGPNPort4 hGPNPort4Ana
	set hGPNPortAnaList "$hGPNPort1Ana $hGPNPort2Ana $hGPNPort3Ana $hGPNPort4Ana"
	set hGPNPortGenList "$hGPNPort1Gen $hGPNPort2Gen $hGPNPort3Gen $hGPNPort4Gen"
	stc::config $hGPNPort1Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort2Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort3Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort4Ana -FilterOnStreamId "FALSE"
        ##�����շ���Ϣ
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
        
        #������������ 10%��Mbps
	foreach hStream $lHStream {
		stc::config [stc::get $hStream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
	}
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
        #���������ù�������Ĭ�Ϲ���tag
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort1Ana hGPNPort1AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg1
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort2Ana hGPNPort2AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort3Ana hGPNPort3AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1	
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
	if {$cap_enable} {
                #��ȡ������capture������ص�ָ��
                gwd::Get_Capture $hGPNPort1 hGPNPort1Cap
                gwd::Get_Capture $hGPNPort2 hGPNPort2Cap
                gwd::Get_Capture $hGPNPort3 hGPNPort3Cap
                gwd::Get_Capture $hGPNPort4 hGPNPort4Cap
                gwd::Create_FilterAnalyzer $hGPNPort1Cap hGPNPort1CapFilter hGPNPort1CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort2Cap hGPNPort2CapFilter hGPNPort2CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort3Cap hGPNPort3CapFilter hGPNPort3CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort4Cap hGPNPort4CapFilter hGPNPort4CapAnalyzer
                array set capArr {capMode "REGULAR_MODE" capSource "Tx_Rx_MODE"}	
        }
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-LINE������֤ LSP PW�������Ի������ÿ�ʼ...\n"
        set portList11 "$GPNPort5 $GPNTestEth3"
	foreach port $portList11 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
		}
	}
        set rebootSlotlist1 [gwd::GWpulic_getWorkCardList $portList11]
	gwd::GWpublic_print "OK" "��ȡ�豸NE1($gpnIp1)ҵ��忨��λ��$rebootSlotlist1" $fileId
        set mslot1 [gwd::GWpulic_getWorkCardList $managePort1]
	gwd::GWpublic_print "OK" "��ȡ�豸NE1($gpnIp1)��������ڲ�λ��$mslot1" $fileId
	lappend cfgFlag [gwd::GWpublic_GetSysMac $telnet1 $matchType1 $Gpn_type1 $fileId gpnMac1]
	regexp -nocase {([0-9|a-f]{2})([0-9|a-f]{2})\.([0-9|a-f]{2})([0-9|a-f]{2})\.([0-9|a-f]{2})([0-9|a-f]{2})} $gpnMac1 match a b c d e f
	set dev_sysmac1 $a:$b:$c:$d:$e:$f
	
              
        set portlist2 "$GPNPort6 $GPNPort7"
        set portList2 "$GPNTestEth1"
        set portList22 [concat $portlist2 $portList2]
	foreach port $portList22 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "disable" "enable"
		}
		
	}
        set rebootSlotlist2 [gwd::GWpulic_getWorkCardList $portlist2]
	gwd::GWpublic_print "OK" "��ȡ�豸NE2($gpnIp2)ҵ��忨��λ��$rebootSlotlist2" $fileId
        set mslot2 [gwd::GWpulic_getWorkCardList $managePort2]
	gwd::GWpublic_print "OK" "��ȡ�豸NE2($gpnIp2)��������ڲ�λ��$mslot2" $fileId
	lappend cfgFlag [gwd::GWpublic_GetSysMac $telnet2 $matchType2 $Gpn_type2 $fileId gpnMac2]
	regexp -nocase {([0-9|a-f]{2})([0-9|a-f]{2})\.([0-9|a-f]{2})([0-9|a-f]{2})\.([0-9|a-f]{2})([0-9|a-f]{2})} $gpnMac2 match a b c d e f
	set dev_sysmac2 $a:$b:$c:$d:$e:$f
	
        set portlist3 "$GPNPort8"
        set portList3 "$GPNTestEth4"
        set portList33 [concat $portlist3 $portList3]
	foreach port $portList33 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "disable" "enable"]
		}
	}
        set rebootSlotlist3 [concat [gwd::GWpulic_getWorkCardList $portlist3] [gwd::GWpulic_getWorkCardList $portList3]]
        gwd::GWpublic_print "OK" "��ȡ�豸NE3($gpnIp3)ҵ��忨�������忨��λ��Ϊ��$rebootSlotlist3" $fileId
        set mslot3 [gwd::GWpulic_getWorkCardList $managePort3]
	gwd::GWpublic_print "OK" "��ȡ�豸NE3($gpnIp3)��������ڰ汾��λ��$mslot3" $fileId
	lappend cfgFlag [gwd::GWpublic_GetSysMac $telnet3 $matchType3 $Gpn_type3 $fileId gpnMac3]
	#Ŀ�ģ�ӦΪ�в��Ե㣺����NNI��mpls���ļ�鱨���е�vid��mac������NNI��tag��ʽ���뵽vlan�У���������untag���ĵ�lspת�����ԣ�\
		���԰����е�NNI��untag��һ�������в����õ���vlan4091��
	if {[string match "L2" $Worklevel]} {
		lappend cfgFlag [gwd::GWpublic_Addvlan $telnet1 $matchType1 $Gpn_type1 $fileId 4091]
		lappend cfgFlag [gwd::GWpublic_Addporttovlan $telnet1 $matchType1 $Gpn_type1 $fileId 4091 "port" $GPNPort5 "untagged"]
		lappend cfgFlag [gwd::GWpublic_Addvlan $telnet2 $matchType2 $Gpn_type2 $fileId 4091]
		lappend cfgFlag [gwd::GWpublic_Addporttovlan $telnet2 $matchType2 $Gpn_type2 $fileId 4091 "port" $GPNPort6 "untagged"]
		lappend cfgFlag [gwd::GWpublic_Addporttovlan $telnet2 $matchType2 $Gpn_type2 $fileId 4091 "port" $GPNPort7 "untagged"]
		lappend cfgFlag [gwd::GWpublic_Addvlan $telnet3 $matchType3 $Gpn_type3 $fileId 4091]
		lappend cfgFlag [gwd::GWpublic_Addporttovlan $telnet3 $matchType3 $Gpn_type3 $fileId 4091 "port" $GPNPort8 "untagged"]              
	} else {    
		lappend cfgFlag [gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fileId "ethernet" $GPNPort5 4091]
		lappend cfgFlag [gwd::GWL3Inter_AddL3 $telnet2 $matchType2 $Gpn_type2 $fileId "ethernet" $GPNPort6 4091]
		lappend cfgFlag [gwd::GWL3Inter_AddL3 $telnet2 $matchType2 $Gpn_type2 $fileId "ethernet" $GPNPort7 4091]
		lappend cfgFlag [gwd::GWL3Inter_AddL3 $telnet3 $matchType3 $Gpn_type3 $fileId "ethernet" $GPNPort8 4091]
	}
        ###������ӿ����ò���
	if {[string match "L2" $Worklevel]} {
        	set interface1 v100
        	set interface14 v100
        	set interface15 v200
        	set interface16 v200
        	set interface17 v300
        	set interface18 v300
        	set interface19 v400
        	set interface20 v400
        	set interface21 v1000
        	set interface22 v3000
        	set interface23 v1000
        	set interface24 v3000
        	set interface31 v100
        	set interface32 v500
		set interface33 v300
		set interface34 v300
		set interface35 v2000
        } else {
        	set interface1 $GPNPort5.100
        	set interface14 $GPNPort6.100
        	set interface15 $GPNPort7.200
        	set interface16 $GPNPort8.200
        	set interface17 $GPNPort5.300
        	set interface18 $GPNPort6.300
        	set interface19 $GPNPort7.400
        	set interface20 $GPNPort8.400
        	set interface21 $GPNTestEth3.1000
        	set interface22 $GPNTestEth3.3000
        	set interface23 $GPNTestEth4.1000
        	set interface24 $GPNTestEth4.3000
        	set interface31 $GPNTestEth4.100
        	set interface32 $GPNTestEth4.500
		set interface33 $GPNTestEth3.300
		set interface34 $GPNTestEth1.300
		set interface35 $GPNTestEth4.2000
        }
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-LINE������֤ LSP PW�������Ի�������ʧ�ܣ����Խ���" \
		"E-LINE������֤ LSP PW�������Ի������óɹ�����������Ĳ���" "GPN_PTN_002_1"
        puts $fileId ""
        puts $fileId "===E-LINE������֤ LSP PW�������Ի������ý���..."
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_013" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 ����E-LINEҵ��ҵ������֤�����������������忨����������������ҵ��ָ�����\n"
        #   <1>��̨�豸NNI�˿�(GE�˿�)��tag��ʽ���뵽VLANIF 100��
        #   <2>�û��ࣨGE�˿ڣ�����ģʽΪ�˿�ģʽ
        #   <3>����LSP1
        #      ����NE1��7600����LSP1���ǩ100������ǩ200��PW1���ر�ǩ1000��Զ�̱�ǩ2000
        #      ����NE3��7600����LSP1���ǩ300������ǩ400��PW1���ر�ǩ2000��Զ�̱�ǩ1000  
        #      ����NE2��7600S����SW(����swap)
        #   <4>NE1��NE3�û�������undo vlan check
        #   <5>����PW1/AC1
        #   <6>��NE1�Ķ˿�1����untag/tagҵ���������۲�NE3�Ķ˿�3�Ľ��ս��
        #   Ԥ�ڽ����NE3�Ķ˿�3����������untag/tagҵ��������˫����untag/tagҵ�������
        #   <7>ʹ��NE1��LSP1/PW1/AC1����ͳ�ƣ�ϵͳ���쳣������ͳ�ƹ�����Ч��ͳ��ֵ��ȷ
        #   <8>ʹ��NE1�豸PW1�Ŀ����֣�������NE1��NNI�˿�egress������
        #   Ԥ�ڽ����������Ϊ��VLAN TAG��ǩ����������mpls��ǩ���ģ����lsp��ǩ200���ڲ�pw��ǩ2000
        #             LSP�ֶ��е�TTLֵΪ255��PW�ֶ��е�TTLֵΪ255��PW�ֶ��к���4�ֽڿ�����
        #   <9>undo shutdown��shutdown NE1�豸��NNI/UNI�˿�50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
        #   <10>����NE1�豸��NNI/UNI�˿����ڰ忨50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
        #   <11>NE1�豸����SW/NMS����50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 ���鿴��ǩת��������ȷ����̨�豸��������
        #   <12>��������NE1�豸��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ�������ϵͳ���쳣���鿴��ǩת��������ȷ����̨�豸�������� 
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
        
        set ip1 192.1.1.1
        set ip2 192.1.1.2
        set ip3 192.1.2.3
        set ip4 192.1.2.4
        set address1 10.1.1.1
        set address2 10.1.1.2
        set address3 10.1.1.3
        #######========vctypeΪtaggedģʽ(NE1:PORT----NE3:PORT+VLAN)����==========#########
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedģʽ(NE1:PORT----NE3:PORT+VLAN)����ҵ��  ���Կ�ʼ=====\n"
        set vctype "tagged"
        ###�����豸NE1
	if {[string match "L2" $Worklevel]} {
        	gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "enable"
		gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "enable"
		gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort7 "enable"
		gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "enable"
	}
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface1 $ip1 $GPNPort5 $matchType1 $Gpn_type1 $telnet1
        gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $interface1 $ip2 "100" "200" "normal" "1"
        gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $address1
        gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"
        gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"
	gwd::GWPw_AddPwVcType $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "2000" "1" "add" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "" $GPNTestEth3 0 0 "delete" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "pw1" "eline11"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3 "disable"
	}
        ###�����豸NE2
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface14 $ip2 $GPNPort6 $matchType2 $Gpn_type2 $telnet2
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface15 $ip3 $GPNPort7 $matchType2 $Gpn_type2 $telnet2
        gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface15 $ip4 "200" "300" "0" 2 "normal"
        gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface14 $ip1 "400" "100" "0" 3 "normal"
        ###�����豸NE3
        PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface16 $ip4 $GPNPort8 $matchType3 $Gpn_type3 $telnet3
        gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" $interface16 $ip3 "300" "400" "normal" "4"
        gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" $address3
        gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"
        gwd::GWpublic_showTunnelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"
	gwd::GWPw_AddPwVcType $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address3 "2000" "1000" "4" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "100" $GPNTestEth4
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 100 0 "modify" 100 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline31"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
	incr capId
        sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	if {$aGPNPort4Cnt1(cnt1) < $rateL || $aGPNPort4Cnt1(cnt1) > $rateR} {
  		set flag1_case1 1
		gwd::GWpublic_print "NOK" "vctypeΪtaggedʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������NE3($gpnIp3) $GPNTestEth4\����tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtaggedʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������NE3($gpnIp3) $GPNTestEth4\����tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt1)����$rateL-$rateR\��Χ��" $fileId
	}
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg4
	incr capId
        sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
        if {$aGPNPort4Cnt1(cnt17)< $rateL || $aGPNPort4Cnt1(cnt17) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "vctypeΪtaggedʱ��NE1($gpnIp1) $GPNTestEth3\����tag=100��������NE3($gpnIp3) $GPNTestEth4\�յ����tag=100�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt17)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtaggedʱ��NE1($gpnIp1) $GPNTestEth3\����tag=100��������NE3($gpnIp3) $GPNTestEth4\�յ����tag=100�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt17)����$rateL-$rateR\��Χ��" $fileId
	}
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
	incr capId
        sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	if {$aGPNPort4Cnt1(cnt1) < $rateL || $aGPNPort4Cnt1(cnt1) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "vctypeΪtaggedʱ��NE1($gpnIp1) $GPNTestEth3\ͬʱ����untag��tag=100��������NE3($gpnIp3) $GPNTestEth4\����tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtaggedʱ��NE1($gpnIp1) $GPNTestEth3\ͬʱ����untag��tag=100��������NE3($gpnIp3) $GPNTestEth4\����tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt1)����$rateL-$rateR\��Χ��" $fileId
	}
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg4
	incr capId
	sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	parray aGPNPort4Cnt1
	parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt1(cnt17)< $rateL || $aGPNPort4Cnt1(cnt17)> $rateR || $aGPNPort4Cnt2(cnt2)< $rateL || $aGPNPort4Cnt2(cnt2)> $rateR} {
        	set flag1_case1 1
        	gwd::GWpublic_print "NOK" "vctypeΪtaggedʱ��NE1($gpnIp1) $GPNTestEth3\ͬʱ����untag��tag=100��������NE3($gpnIp3) $GPNTestEth4\�յ����tag=100�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt17)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtaggedʱ��NE1($gpnIp1) $GPNTestEth3\ͬʱ����untag��tag=100��������NE3($gpnIp3) $GPNTestEth4\�յ����tag=100�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt17)����$rateL-$rateR\��Χ��" $fileId
	}
        gwd::Cfg_StreamActive $hGPNPort4Stream3 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream4 "TRUE"
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
	incr capId
	sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt3 aGPNPort4Cnt4 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        parray aGPNPort3Cnt1
        parray aGPNPort3Cnt2
        parray aGPNPort4Cnt3
        parray aGPNPort4Cnt4
	if {$aGPNPort4Cnt3(cnt1) < $rateL || $aGPNPort4Cnt3(cnt1) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "vctypeΪtaggedʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������NE3($gpnIp3) $GPNTestEth4\����tag=100�����ݰ�����Ϊ$aGPNPort4Cnt3(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtaggedʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������NE3($gpnIp3) $GPNTestEth4\����tag=100�����ݰ�����Ϊ$aGPNPort4Cnt3(cnt1)����$rateL-$rateR\��Χ��" $fileId
	}
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg4
	incr capId
	sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort4Cnt1(cnt17)< $rateL || $aGPNPort4Cnt1(cnt17) > $rateR} {
		set flag1_case1 1
		  gwd::GWpublic_print "NOK" "vctypeΪtaggedʱ��NE1($gpnIp1) $GPNTestEth3\����tag=100��������NE3($gpnIp3) $GPNTestEth4\�յ����tag=100�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt17)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		  gwd::GWpublic_print "OK" "vctypeΪtaggedʱ��NE1($gpnIp1) $GPNTestEth3\����tag=100��������NE3($gpnIp3) $GPNTestEth4\�յ����tag=100�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt17)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aGPNPort3Cnt2(cnt3) != 0} {
        	set flag1_case1 1
        	gwd::GWpublic_print "NOK" "vctypeΪtaggedʱ��NE3($gpnIp3) $GPNTestEth4\����untag��������NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt2(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtaggedʱ��NE3($gpnIp3) $GPNTestEth4\����untag��������NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt2(cnt3)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt4) != 0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "vctypeΪtaggedʱ��NE3($gpnIp3) $GPNTestEth4\����tag=100����������NE1($gpnIp1) $GPNTestEth3\����tag=100�����ݰ�����ӦΪ0ʵΪaGPNPort3Cnt1(cnt4)" $fileId
	} else {
		if {$aGPNPort3Cnt2(cnt4) < $rateL || $aGPNPort3Cnt2(cnt4) > $rateR} {
			set flag1_case1 1
			gwd::GWpublic_print "NOK" "vctypeΪtaggedʱ��NE3($gpnIp3) $GPNTestEth4\����tag=100��������NE1($gpnIp1) $GPNTestEth3\����untag���ݰ�����Ϊ$aGPNPort3Cnt2(cnt4)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctypeΪtaggedʱ��NE3($gpnIp3) $GPNTestEth4\����tag=100��������NE1($gpnIp1) $GPNTestEth3\����untag���ݰ�����Ϊ$aGPNPort3Cnt2(cnt4)����$rateL-$rateR\��Χ��" $fileId
		}
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1�����ۣ�vctypeΪtaggedģʽ(NE1:PORT----NE3:PORT+VLAN)����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1�����ۣ�vctypeΪtaggedģʽ(NE1:PORT----NE3:PORT+VLAN)����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedģʽ(NE1:PORT----NE3:PORT+VLAN)����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtagged����overlay����  ���Կ�ʼ=====\n"
	gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort4Stream3 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort4Stream4 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream15 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream16 "TRUE"
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg4
	
	incr capId
        sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        parray aGPNPort3Cnt1
        parray aGPNPort3Cnt2
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	if {$aGPNPort3Cnt1(cnt16) != 0} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged δʹ��overlayʱ��NE3($gpnIp3) $GPNTestEth4\����tag=100��mpls��������NE1($gpnIp1) $GPNTestEth3\����tag=100��mpls���ݰ�����ӦΪ0ʵΪaGPNPort3Cnt1(cnt16)" $fileId
	} else {
		if {$aGPNPort3Cnt2(cnt16) < $rateL || $aGPNPort3Cnt2(cnt16) > $rateR} {
			set flag2_case1 1
			gwd::GWpublic_print "NOK" "vctypeΪtagged δʹ��overlayʱ��NE3($gpnIp3) $GPNTestEth4\����tag=100��mpls��������NE1($gpnIp1) $GPNTestEth3\����untag���ݰ�����Ϊ$aGPNPort3Cnt2(cnt16)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctypeΪtagged δʹ��overlayʱ��NE3($gpnIp3) $GPNTestEth4\����tag=100��mpls��������NE1($gpnIp1) $GPNTestEth3\����untag���ݰ�����Ϊ$aGPNPort3Cnt2(cnt16)����$rateL-$rateR\��Χ��" $fileId
		}
	} 
	if {$aGPNPort4Cnt1(cnt17) < $rateL || $aGPNPort4Cnt1(cnt17) > $rateR || $aGPNPort4Cnt2(cnt15) < $rateL || $aGPNPort4Cnt2(cnt15) > $rateR} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged δʹ��overlayʱ��NE1($gpnIp1) $GPNTestEth3\����tag=100��mpls��������NE3($gpnIp3) $GPNTestEth4\�������tag=100�ڲ�tag=100���ݰ�����Ϊ$aGPNPort4Cnt1(cnt17)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtagged δʹ��overlayʱ��NE1($gpnIp1) $GPNTestEth3\����tag=100��mpls��������NE3($gpnIp3) $GPNTestEth4\�������tag=100�ڲ�tag=100���ݰ�����Ϊ$aGPNPort4Cnt1(cnt17)����$rateL-$rateR\��Χ��" $fileId
	}
       	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg4
        gwd::GWpublic_addOverLay $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3 "enable"
        gwd::GWpublic_addOverLay $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "enable"
        
	incr capId
        sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        parray aGPNPort3Cnt1
        parray aGPNPort3Cnt2
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	if {$aGPNPort3Cnt1(cnt16) != 0} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged ʹ��overlayʱ��NE3($gpnIp3) $GPNTestEth4\����tag=100��mpls��������NE1($gpnIp1) $GPNTestEth3\����tag=100��mpls���ݰ�����ӦΪ0ʵΪaGPNPort3Cnt1(cnt16)" $fileId
	} else {
		if {$aGPNPort3Cnt2(cnt16) < $rateL || $aGPNPort3Cnt2(cnt16) > $rateR} {
			set flag2_case1 1
			gwd::GWpublic_print "NOK" "vctypeΪtagged ʹ��overlayʱ��NE3($gpnIp3) $GPNTestEth4\����tag=100��mpls��������NE1($gpnIp1) $GPNTestEth3\����untag���ݰ�����Ϊ$aGPNPort3Cnt2(cnt16)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctypeΪtagged ʹ��overlayʱ��NE3($gpnIp3) $GPNTestEth4\����tag=100��mpls��������NE1($gpnIp1) $GPNTestEth3\����untag���ݰ�����Ϊ$aGPNPort3Cnt2(cnt16)����$rateL-$rateR\��Χ��" $fileId
		}
	} 
	if {$aGPNPort4Cnt1(cnt17) < $rateL || $aGPNPort4Cnt1(cnt17) > $rateR || $aGPNPort4Cnt2(cnt15) < $rateL || $aGPNPort4Cnt2(cnt15) > $rateR} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged ʹ��overlayʱ��NE1($gpnIp1) $GPNTestEth3\����tag=100��mpls��������NE3($gpnIp3) $GPNTestEth4\�������tag=100�ڲ�tag=100���ݰ�����Ϊ$aGPNPort4Cnt1(cnt17)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtagged ʹ��overlayʱ��NE1($gpnIp1) $GPNTestEth3\����tag=100��mpls��������NE3($gpnIp3) $GPNTestEth4\�������tag=100�ڲ�tag=100���ݰ�����Ϊ$aGPNPort4Cnt1(cnt17)����$rateL-$rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2�����ۣ�vctypeΪtaggedʱ����overlay����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2�����ۣ�vctypeΪtaggedʱ����overlay����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtagged����overlay����  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtagged����ͳ�ƹ���  ���Կ�ʼ=====\n"
        ###�����豸NE1
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "enable"
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "enable"
        gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "enable"
        gwd::Cfg_StreamActive $hGPNPort4Stream16 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort3Stream15 "FALSE"
       
	if {[PTN_EVP_State $telnet1 $matchType1 $Gpn_type1 $fileId "$hGPNPort3Stream2 $hGPNPort4Stream4" \
			$GPNTestEth3 "lsp1" "pw1" "ac1" $hGPNPort3Ana $hGPNPort3Gen]} {
		set flag3_case1 1
	}
	
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3�����ۣ�vctypeΪtagged lsp pw ac����ͳ�ƹ��ܲ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3�����ۣ�vctypeΪtagged lsp pw ac����ͳ�ƹ��ܲ���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtagged����ͳ�ƹ���  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedʱ�豸��ӵ�mpls��ǩ�Ƿ���ȷ  ���Կ�ʼ=====\n"
	gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2 aMirror
        if {$::cap_enable} {
            	gwd::Start_CapAllData ::capArr $hGPNPort2Cap $hGPNPort2CapAnalyzer 
            	gwd::Start_CapAllData ::capArr $hGPNPort4Cap $hGPNPort4CapAnalyzer
        }
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg2
        gwd::Start_SendFlow "$hGPNPort3Gen"  "$hGPNPort2Ana"
        after $sendTime
	incr capId
        if {$cap_enable} {
            	gwd::Stop_CapData $hGPNPort2Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap"
            	gwd::Stop_CapData $hGPNPort4Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3).pcap"
        }
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3).pcap" $fileId
        foreach i "aTmpGPNPort2Cnt2 aTmpGPNPort2Cnt3" {
          array set $i {cnt1 0 cnt2 0} 
        }
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 2 $hGPNPort2Ana aTmpGPNPort2Cnt2]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 0 0 0
		after 5000
	}
       
        parray aTmpGPNPort2Cnt2
        gwd::Stop_SendFlow "$hGPNPort3Gen"  "$hGPNPort2Ana"
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg3
        gwd::Start_SendFlow "$hGPNPort3Gen"  "$hGPNPort2Ana"
        after $sendTime
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 3 $hGPNPort2Ana aTmpGPNPort2Cnt3]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 0 0 0
		after 5000
	}
        parray aTmpGPNPort2Cnt3
        if {$aTmpGPNPort2Cnt2(cnt1) < $rateL1 || $aTmpGPNPort2Cnt2(cnt1) > $rateR1} {
        	set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)����untag������ʱ��������˫���ǩ�쳣" $fileId
        } else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)����untag������ʱ��������˫���ǩ����" $fileId
        }
        if {$aTmpGPNPort2Cnt3(cnt1) < $rateL1 || $aTmpGPNPort2Cnt3(cnt1)> $rateR1} {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)����untag������ʱ��������vid��stack�쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)����untag������ʱ��������vid��stack����" $fileId
	}
        gwd::Stop_SendFlow "$hGPNPort3Gen"  "$hGPNPort2Ana"
	gwd::Cfg_StreamActive $hGPNPort3Stream1 "false"
	gwd::Cfg_StreamActive $hGPNPort3Stream2 "true"
	if {$::cap_enable} {
        	gwd::Start_CapAllData ::capArr $hGPNPort2Cap $hGPNPort2CapAnalyzer 
        	gwd::Start_CapAllData ::capArr $hGPNPort4Cap $hGPNPort4CapAnalyzer
	}
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg2
	gwd::Start_SendFlow "$hGPNPort3Gen"  "$hGPNPort2Ana"
	after $sendTime
	incr capId
	if {$cap_enable} {
        	gwd::Stop_CapData $hGPNPort2Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap"
        	gwd::Stop_CapData $hGPNPort4Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3).pcap"
	}
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3).pcap" $fileId
	foreach i "aTmpGPNPort2Cnt2 aTmpGPNPort2Cnt3" {
	  array set $i {cnt1 0 cnt2 0} 
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 2 $hGPNPort2Ana aTmpGPNPort2Cnt2]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 0 0 0
		after 5000
	}
	parray aTmpGPNPort2Cnt2
	gwd::Stop_SendFlow "$hGPNPort3Gen"  "$hGPNPort2Ana"
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg3
	gwd::Start_SendFlow "$hGPNPort3Gen"  "$hGPNPort2Ana"
	after $sendTime
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 3 $hGPNPort2Ana aTmpGPNPort2Cnt3]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 0 0 0
		after 5000
	}
	parray aTmpGPNPort2Cnt3
	if {$aTmpGPNPort2Cnt2(cnt1) < $rateL1 || $aTmpGPNPort2Cnt2(cnt1) > $rateR1} {
		set flag4_case1 1
		
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)����tag������ʱ��������˫���ǩ�쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)����tag������ʱ��������˫���ǩ����" $fileId
	}
	if {$aTmpGPNPort2Cnt3(cnt1) < $rateL1 || $aTmpGPNPort2Cnt3(cnt1)> $rateR1} {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)����tag������ʱ��������vid��stack�쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)����tag������ʱ��������vid��stack����" $fileId
	}
	gwd::Stop_SendFlow "$hGPNPort3Gen"  "$hGPNPort2Ana"	
	
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA4�����ۣ�vctypeΪtaggedʱ�豸��ӵ�mpls��ǩ" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4�����ۣ�vctypeΪtaggedʱ�豸��ӵ�mpls��ǩ" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedʱ�豸��ӵ�mpls��ǩ�Ƿ���ȷ  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��龭��LSP����ǰ��LSP��PW��TTLֵ  ���Կ�ʼ=====\n"
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg0
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg0

	set hfilter16BitFilAna1 [stc::create Analyzer16BitFilter \
	 	-under $hGPNPort1Ana \
		-StartOfRange "61440" \
		-EndOfRange "65280" \
	 	-FilterName "LSP-TTL" \
	 	-Offset 21]
	set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter \
	 	-under $hGPNPort1Ana \
		-StartOfRange "61440" \
		-EndOfRange "65280" \
	 	-FilterName "PW-TTL" \
	 	-Offset 25]
	set hfilter16BitFilAna3 [stc::create Analyzer16BitFilter \
	 	-under $hGPNPort2Ana \
		-StartOfRange "61440" \
		-EndOfRange "65280" \
	 	-FilterName "LSP-TTL" \
	 	-Offset 21]
	set hfilter16BitFilAna4 [stc::create Analyzer16BitFilter \
	 	-under $hGPNPort2Ana \
		-StartOfRange "61440" \
		-EndOfRange "65280" \
	 	-FilterName "PW-TTL" \
	 	-Offset 25]
	array set aMirror "dir1 egress port1 $GPNPort7 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth1 aMirror
	if {$::cap_enable} {
		    gwd::Start_CapAllData ::capArr $hGPNPort2Cap $hGPNPort2CapAnalyzer 
		    gwd::Start_CapAllData ::capArr $hGPNPort1Cap $hGPNPort1CapAnalyzer
	}	
	gwd::Start_SendFlow "$hGPNPort3Gen"  "$hGPNPort1Ana $hGPNPort2Ana"
	after 10000
	incr capId
	if {$cap_enable} {
		    gwd::Stop_CapData $hGPNPort2Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap"
		    gwd::Stop_CapData $hGPNPort1Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2).pcap"
	}
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2).pcap" $fileId
	foreach i "aTmpGPNPort1Cnt1 aTmpGPNPort2Cnt1" {
	  array set $i {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0} 
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 2 $hGPNPort1Ana aTmpGPNPort1Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 0 0 0 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 2 $hGPNPort2Ana aTmpGPNPort2Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 0 0 0
		after 5000
	}
	gwd::Stop_SendFlow "$hGPNPort3Gen"  "$hGPNPort1Ana $hGPNPort2Ana"
	if {$aTmpGPNPort2Cnt1(cnt7) == 0} {
		set flag10_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=100����������NE1($gpnIp1)$GPNTestEth2\����NE1��NE2��NE1 NNI��$GPNPort5\��egress����\
			LSP-TTL��ֵ����FF����PW-TTL��ֵ����FF" $fileId
	} else {
		if {$aTmpGPNPort2Cnt1(cnt7) < $rateL1 || $aTmpGPNPort2Cnt1(cnt7) > $rateR1} {
			set flag10_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=100����������NE1($gpnIp1)$GPNTestEth2\����NE1��NE2��NE1 NNI��$GPNPort5\��egress����LSP-TTL��PW-TTL��ֵ����FF\
				��������Ϊ$aTmpGPNPort2Cnt1(cnt7)��û��$rateL1-$rateR1\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=100����������NE1($gpnIp1)$GPNTestEth2\����NE1��NE2��NE1 NNI��$GPNPort5\��egress����LSP-TTL��PW-TTL��ֵ����FF\
				����Ϊ$aTmpGPNPort2Cnt1(cnt7)����$rateL1-$rateR1\��Χ��" $fileId
		}
	}
	if {$aTmpGPNPort1Cnt1(cnt8) == 0} {
		set flag10_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=100����������NE2($gpnIp2)$GPNTestEth1\����NE2��NE3��NE2 NNI��$GPNPort7\��egress���򣬾���NE2��LSP������\
			LSP-TTL��ֵ����FE����PW-TTL��ֵ����FF" $fileId
	} else {
		if {$aTmpGPNPort1Cnt1(cnt8) < $rateL1 || $aTmpGPNPort1Cnt1(cnt8) > $rateR1} {
			set flag10_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\����tag=100����������NE2($gpnIp2)$GPNTestEth1\����NE2��NE3��NE2 NNI��$GPNPort7\��egress���򣬾���NE2��LSP������\
				LSP-TTL��FE PW-TTL��ֵ��FF����������Ϊ$aTmpGPNPort1Cnt1(cnt8)��û��$rateL1-$rateR1\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\����tag=100����������NE2($gpnIp2)$GPNTestEth1\����NE2��NE3��NE2 NNI��$GPNPort7\��egress���򣬾���NE2��LSP������\
				LSP-TTL��FE PW-TTL��ֵ��FF������Ϊ$aTmpGPNPort1Cnt1(cnt8)����$rateL1-$rateR1\��Χ��" $fileId
		}
	}
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2
	gwd::GWpublic_DelPortMirror $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth1
	puts $fileId ""
	if {$flag10_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FE6�����ۣ���龭��LSP����ǰ��LSP��PW��TTLֵ�Ĳ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE6�����ۣ���龭��LSP����ǰ��LSP��PW��TTLֵ�Ĳ���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��龭��LSP����ǰ��LSP��PW��TTLֵ  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedʱ����shutdown/undoshutdown�˿ں�ҵ���Ƿ��ָܻ�  ���Կ�ʼ=====\n"
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	stc::delete $hfilter16BitFilAna3
	stc::delete $hfilter16BitFilAna4
	gwd::Cfg_StreamActive $hGPNPort3Stream1 "true"
	gwd::Cfg_StreamActive $hGPNPort3Stream15 "true"
        ##����undo shutdown/shutdown�˿�
        foreach eth $portList11 {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
          		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
          		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
          		after $WaiteTime
			incr capId
			if {[Test_Case1 "��$j\��undo shutdown/shutdown NE1($gpnIp1)��$eth\�˿�" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag5_case1 1
			}
        	}
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag5_case1	1
			gwd::GWpublic_print "NOK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
		}
        }
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA5�����ۣ�vctypeΪtaggedʱ����shutdown/undoshutdown�˿ں�ҵ��ָ���ϵͳ�ڴ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5�����ۣ�vctypeΪtaggedʱ����shutdown/undoshutdown�˿ں�ҵ��ָ���ϵͳ�ڴ����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedʱ����shutdown/undoshutdown�˿ں�ҵ���Ƿ��ָܻ�  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedʱ��������ҵ��˿����ڰ忨��ҵ���Ƿ��ָܻ�  ���Կ�ʼ=====\n"
        ###���������˿����ڰ忨
        foreach slot $rebootSlotlist1 {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource3
		set testFlag 0 ;#=1 �忨��֧��������������������
          	for {set j 1} {$j<=$cnt} {incr j} {
          		if {![gwd::GWCard_AddReboot $telnet1 $matchType1 $Gpn_type1 $fileId $slot]} {
                  		after $rebootBoardTime
                  		if {[string match $mslot1 $slot]} {
        				set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
					set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
                   		}
				incr capId
        			if {[Test_Case1 "��$j\������NE1($gpnIp1)$slot\��λ�忨��" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
        				set flag6_case1 1
        			}
         		} else {
				gwd::GWpublic_print "OK" $fileId "$matchType1\��֧�ְ忨������������������" $fileId
				set testFlag 1
				 break
         		}
        	}
		if {$testFlag == 0} {
			gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
			send_log "\n resource3:$resource3"
			send_log "\n resource4:$resource4"
			if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
				set flag6_case1	1
				gwd::GWpublic_print "NOK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
			} 
		}       	
        }
	puts $fileId ""
	if {$flag6_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA6�����ۣ�vctypeΪtaggedʱ��������ҵ��˿����ڰ忨��ҵ��ָ���ϵͳ�ڴ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6�����ۣ�vctypeΪtaggedʱ��������ҵ��˿����ڰ忨��ҵ��ָ���ϵͳ�ڴ����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedʱ��������ҵ��˿����ڰ忨��ҵ���Ƿ��ָܻ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedʱ��������NMS����������ҵ���Ƿ��ָܻ�  ���Կ�ʼ=====\n"
        ###��������NMS��������
	set testFlag 0 ;#=1 ��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_Case1 "��$j\��NE1($gpnIp1)����NMS����������" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag7_case1 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "1" result
			if {![string match [dict get $result 1 pwOutLabel] 1000] || ![string match [dict get $result 1 lspOutLabel] +200]} {
				set flag7_case1 1
				gwd::GWpublic_print "NOK" "VC=1 ��pwOutLabelΪ[dict get $result 1 pwOutLabel] \
						lspOutLabelΪ[dict get $result 1 lspOutLabel]��NE1($gpnIp1)��$j\�ν���NMS��������ת�������쳣" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=1 ��pwOutLabelΪ[dict get $result 1 pwOutLabel] \
						lspOutLabelΪ[dict get $result 1 lspOutLabel]��NE1($gpnIp1)��$j\�ν���NMS��������ת����������" $fileId
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
			set flag7_case1	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
                } else {
                	gwd::GWpublic_print "OK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
                }
	}
	puts $fileId ""
	if {$flag7_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA7�����ۣ�vctypeΪtaggedʱ����NMS����������ҵ��ָ���mplsת�����ϵͳ�ڴ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7�����ۣ�vctypeΪtaggedʱ����NMS����������ҵ��ָ���mplsת�����ϵͳ�ڴ����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedʱ��������NMS����������ҵ���Ƿ��ָܻ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedʱ��������SW����������ҵ���Ƿ��ָܻ�  ���Կ�ʼ=====\n"
        ##��������SW��������
	set testFlag 0 ;#=1 ��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_Case1 "��$j\��NE1($gpnIp1)����SW����������" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag8_case1 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "1" result
			if {![string match [dict get $result 1 pwOutLabel] 1000] || ![string match [dict get $result 1 lspOutLabel] +200]} {
				set flag8_case1 1
				gwd::GWpublic_print "NOK" "VC=1 ��pwOutLabelΪ[dict get $result 1 pwOutLabel] \
						lspOutLabelΪ[dict get $result 1 lspOutLabel]��NE1($gpnIp1)��$j\�ν���SW��������ת�������쳣" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=1 ��pwOutLabelΪ[dict get $result 1 pwOutLabel] \
						lspOutLabelΪ[dict get $result 1 lspOutLabel]��NE1($gpnIp1)��$j\�ν���SW��������ת����������" $fileId
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
			set flag8_case1	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag8_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA8�����ۣ�vctypeΪtaggedʱ����SW����������ҵ��ָ���mplsת�����ϵͳ�ڴ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8�����ۣ�vctypeΪtaggedʱ����SW����������ҵ��ָ���mplsת�����ϵͳ�ڴ����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedʱ��������SW����������ҵ���Ƿ��ָܻ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedʱ�������б����豸������ҵ���Ƿ��ָܻ�  ���Կ�ʼ=====\n"
      
        ##���������豸����
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
        for {set j 1} {$j<=$cnt} {incr j} {
          	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
          	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
          	after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[Test_Case1 "��$j\��NE1($gpnIp1)�豸��������������" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
			set flag9_case1 1
		}
		gwd::GWpublic_QueryMPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "1" result
		if {![string match [dict get $result 1 pwOutLabel] 1000] || ![string match [dict get $result 1 lspOutLabel] +200]} {
			set flag9_case1 1
			gwd::GWpublic_print "NOK" "VC=1 ��pwOutLabelΪ[dict get $result 1 pwOutLabel] \
					lspOutLabelΪ[dict get $result 1 lspOutLabel]��NE1($gpnIp1)��$j\�α����豸����ת�������쳣" $fileId
		} else {
			gwd::GWpublic_print "OK" "VC=1 ��pwOutLabelΪ[dict get $result 1 pwOutLabel] \
					lspOutLabelΪ[dict get $result 1 lspOutLabel]��NE1($gpnIp1)��$j\�α����豸����ת����������" $fileId
		}
        }
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
        if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag9_case1	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag9_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA9�����ۣ�vctypeΪtaggedʱ�������б����豸������ҵ��ָ���mplsת�����ϵͳ�ڴ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9�����ۣ�vctypeΪtaggedʱ�������б����豸������ҵ��ָ���mplsת�����ϵͳ�ڴ����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedʱ�������б����豸������ҵ���Ƿ��ָܻ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
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
	puts $fileId "Test Case 1 ����E-LINEҵ��ҵ������֤�����������������忨����������������ҵ��ָ����Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 �´���E-LINEҵ�񣬽�����ģʽ��Ϊ���˿�+��Ӫ��VLAN��ʱ���ܼ�ҵ��ָ�����\n"
        #   <1>ɾ��NE1��NE3�豸��ר��ҵ��AC����ɾ���ɹ���ҵ���жϣ�ϵͳ���쳣
        #   <2>���´���NE1��NE3�豸��AC�ڵ�ר��ҵ��AC),����α�ߣ�PW���������ģ�����������ģʽ��Ϊ���˿�+��Ӫ��VLAN��
        #   <3>�û������ָ����vlan��
        #   <4>��NE1��NE3�Ͼ����������VLAN��vlan 1000����������˿�
        #   <5>��NE1�Ķ˿�1����tag1000��tag2000ҵ���������۲�NE3�Ķ˿�3�Ľ��ս��
        #   Ԥ�ڽ�����ٴδ�������ģʽΪ���˿�+��Ӫ��VLAN����ר��ҵ�񣬳ɹ�������ϵͳ���쳣
        #             NE3�Ķ˿�3ֻ�ɽ���tag1000ҵ��������˫����ҵ������
        #   <6>ɾ��֮ǰ����ģʽ��Ϊ���˿�+��Ӫ��VLAN����AC
        #   <7>��NE1��NE3�豸�ϴ���AC����ģʽ��Ϊ���˿�+��Ӫ��VLAN+�ͻ�VLAN��
        #      ��Ӫ��VLANΪ vlan 3000���ͻ�VLANΪvlan 300
        #   <8>��NE1��NE3�豸���ٴ���һ���µ�E-LINEҵ��(��֮ǰ��ҵ����ͬһ��LSP)����AC����ģʽ��Ϊ���˿�+��Ӫ��VLAN+�ͻ�VLAN��
        #      ��Ӫ��VLANΪ vlan 1000���ͻ�VLANΪvlan 100
        #   Ԥ�ڽ����ҵ��ɹ�������ϵͳ���쳣����֮ǰ��ҵ�����κθ���
        #   <9>��NE1��UNI�˿ڷ���untag��tag300��tag3000�� ˫��tag����3000 ��300��ҵ���������۲�NE3��UNI�˿ڵĽ��ս��
        #   Ԥ�ڽ����NE3��UNI�˿�ֻ�ɽ��յ�˫��tag����3000 ��300��ҵ����������֮ǰ��ҵ���޸��ţ�˫����ҵ������
        #   <10>undo shutdown��shutdown NE3�豸��NNI/UNI�˿�50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
        #   <11>����NE3�豸��NNI/UNI�˿����ڰ忨50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
        #   <12>NE3�豸����SW/NMS����50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 ���鿴��ǩת��������ȷ����̨�豸��������
        #   <13>��������NE3�豸��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ�������ϵͳ���쳣���鿴��ǩת��������ȷ����̨�豸�������� 
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
	gwd::GWpublic_addOverLay $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3 "disable"
	gwd::GWpublic_addOverLay $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "disable"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)����ҵ��  ���Կ�ʼ=====\n"
        ###�����豸NE1
        gwd::Cfg_StreamActive $hGPNPort3Stream15 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream5 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream6 "TRUE"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3 "enable"
	}
        PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "1000" $GPNTestEth3
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "2000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        if {[gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "" $GPNTestEth3 1000 0 "modify" 1000 0 0 "0x8100"]} {
        	set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtaggedģʽ�ٴδ�������ģʽΪ���˿�+��Ӫ��VLAN����ר��ҵ�񣬴���ʧ��" $fileId
        }
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "pw1" "eline12"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        ###�����豸NE3
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
	PTN_DelInterVid $fileId $Worklevel $interface31 $matchType3 $Gpn_type3 $telnet3
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "1000" $GPNTestEth4
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000" "" $GPNTestEth4 1000 0 "modify" 1000 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000" "pw1" "eline32"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"
	incr capId
	SendAndStat_ptn002_1 1 $hGPNPort3Gen $hGPNPort4Ana "$GPNTestEth4" "$hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
			$hGPNPort4AnaFrameCfgFil aTmpGPNPort4Cnt91 aTmpGPNPortCnt aGPNCnt3 1 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aTmpGPNPort4Cnt91(cnt5) < $rateL || $aTmpGPNPort4Cnt91(cnt5) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000����������\
				NE3($gpnIp3) $GPNTestEth4\����tag=1000������������Ϊ$aTmpGPNPort4Cnt91(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtagged(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000����������\
				NE3($gpnIp3) $GPNTestEth4\����tag=1000������������Ϊ$aTmpGPNPort4Cnt91(cnt5)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aTmpGPNPort4Cnt91(cnt6) !=0} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=2000����������\
				NE3($gpnIp3) $GPNTestEth4\����tag=2000������������ӦΪ0ʵΪ$aTmpGPNPort4Cnt91(cnt6)" $fileId
	}        
        gwd::Cfg_StreamActive $hGPNPort4Stream5 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream6 "TRUE"
	incr capId
	SendAndStat_ptn002_1 1 "$hGPNPort3Gen $hGPNPort4Gen" "$hGPNPort3Ana $hGPNPort4Ana" "$GPNTestEth3 $GPNTestEth4" \
		"$hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
		"$hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil"  aTmpGPNPort3Cnt81 aTmpGPNPort4Cnt71 aGPNCnt3 1 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aTmpGPNPort4Cnt71(cnt5) < $rateL || $aTmpGPNPort4Cnt71(cnt5) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000����������\
				NE3($gpnIp3) $GPNTestEth4\����tag=1000������������Ϊ$aTmpGPNPort4Cnt71(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtagged(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000����������\
				NE3($gpnIp3) $GPNTestEth4\����tag=1000������������Ϊ$aTmpGPNPort4Cnt71(cnt5)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aTmpGPNPort4Cnt71(cnt6) !=0} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=2000����������\
				NE3($gpnIp3) $GPNTestEth4\����tag=2000������������ӦΪ0ʵΪ$aTmpGPNPort4Cnt71(cnt6)" $fileId
	}
	if {$aTmpGPNPort3Cnt81(cnt5) < $rateL || $aTmpGPNPort3Cnt81(cnt5) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000����������\
				NE1($gpnIp1) $GPNTestEth3\����tag=1000������������Ϊ$aTmpGPNPort3Cnt81(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtagged(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000����������\
				NE1($gpnIp1) $GPNTestEth3\����tag=1000������������Ϊ$aTmpGPNPort3Cnt81(cnt5)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aTmpGPNPort3Cnt81(cnt6) !=0} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=2000����������\
				NE1($gpnIp1) $GPNTestEth3\����tag=2000������������ӦΪ0ʵΪ$aTmpGPNPort3Cnt81(cnt6)" $fileId
	}
	#pw ping ��traceroute------
	gwd::GWpublic_addPwPing $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" pingResult
	if {[dict get $pingResult sucRate]==100.00} {
		gwd::GWpublic_print "OK" "vctypeΪtaggedģʽ����NE1��PING PW1�ĳɹ���ӦΪ100.00%Ϊ[dict get $pingResult sucRate]%" $fileId
	} else {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtaggedģʽ����NE1��PING PW1�ĳɹ���ӦΪ100.00%Ϊ[dict get $pingResult sucRate]%" $fileId
	}
	if {[string match [dict get $pingResult replyIp] "192.1.2.4"]} {
		gwd::GWpublic_print "OK" "vctypeΪtaggedģʽ����NE1��PING PW1��reply from ��ipӦΪ192.1.2.4ʵΪ[dict get $pingResult replyIp]" $fileId
	} else {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtaggedģʽ����NE1��PING PW1��reply from ��ipӦΪ192.1.2.4ʵΪ[dict get $pingResult replyIp]" $fileId
	}
	gwd::GWpublic_addPwTrace $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
	set expectTrace {2 {replier "192.1.2.4" traceTime "<1ms" type "Egress" downstream "--" ret "success"}}
	if {[Check_Tracertroute "" $expectTrace $result]} {
		set flag1_case2 1 
		gwd::GWpublic_print "NOK" "vctypeΪtaggedģʽ����NE1($gpnIp1)��tracertroute pw1�鿴���ĵ�NE3($gpnIp3)������ÿһ�������쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtaggedģʽ����NE1($gpnIp1)��tracertroute pw1�鿴���ĵ�NE3($gpnIp3)������ÿһ����������" $fileId
	}
	#------pw ping ��traceroute
	#lsp ping ��traceroute------
	gwd::GWpublic_addLspPing $telnet1 $matchType1 $Gpn_type1 $fileId "10.1.1.1/32" "generic" pingResult
	if {[dict get $pingResult sucRate]==100.00} {
		gwd::GWpublic_print "OK" "vctypeΪtaggedģʽ����NE1��ping mpls lsp ip 10.1.1.1/32 generic�ĳɹ���ӦΪ100.00%Ϊ[dict get $pingResult sucRate]%" $fileId
	} else {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtaggedģʽ����NE1��ping mpls lsp ip 10.1.1.1/32 generic�ĳɹ���ӦΪ100.00%Ϊ[dict get $pingResult sucRate]%" $fileId
	}
	if {[string match [dict get $pingResult replyIp] "192.1.2.4"]} {
		gwd::GWpublic_print "OK" "vctypeΪtaggedģʽ����NE1��ping mpls lsp ip 10.1.1.1/32 generic��reply from ��ipӦΪ192.1.2.4ʵΪ[dict get $pingResult replyIp]" $fileId
	} else {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtaggedģʽ����NE1��ping mpls lsp ip 10.1.1.1/32 generic��reply from ��ipӦΪ192.1.2.4ʵΪ[dict get $pingResult replyIp]" $fileId
	}
	gwd::GWpublic_addLspTrace $telnet1 $matchType1 $Gpn_type1 $fileId "10.1.1.1/32" "generic" result
	if {[string match "fail" $result]} {
		set flag1_case2 1 
		gwd::GWpublic_print "NOK" "vctypeΪtaggedģʽ����NE1($gpnIp1)��tracertroute lsp ip 10.1.1.1/32 generic�鿴���ĵ�NE3($gpnIp3)������ÿһ������û�з���success" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtaggedģʽ����NE1($gpnIp1)��tracertroute lsp ip 10.1.1.1/32 generic�鿴���ĵ�NE3($gpnIp3)������ÿһ�����Է���success" $fileId
	}
	#------lsp ping ��traceroute
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB1�����ۣ�vctypeΪtaggedģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1�����ۣ�vctypeΪtaggedģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedģʽ(NE1:PORT----NE3:PORT)����ҵ��  ���Կ�ʼ=====\n"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3 "disable"
	}
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "2000" "1" "add" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "" $GPNTestEth3 0 0 "delete" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "pw1" "eline13"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "disable"
	}
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address3 "2000" "1000" "4" "add" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 0 0 "delete" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline33"
	incr capId	
	SendAndStat_ptn002_1 1 "$hGPNPort3Gen $hGPNPort4Gen" "$hGPNPort3Ana $hGPNPort4Ana" "$GPNTestEth3 $GPNTestEth4" \
		"$hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
		"$hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" aTmpGPNPort3Cnt1 aTmpGPNPort4Cnt1 aGPNCnt3 1 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aTmpGPNPort4Cnt1(cnt5) < $rateL || $aTmpGPNPort4Cnt1(cnt5) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000����������\
        			NE3($gpnIp3) $GPNTestEth4\����tag=1000������������Ϊ$aTmpGPNPort4Cnt1(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctypeΪtagged(NE1:PORT----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000����������\
        			NE3($gpnIp3) $GPNTestEth4\����tag=1000������������Ϊ$aTmpGPNPort4Cnt1(cnt5)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$aTmpGPNPort4Cnt1(cnt6) < $rateL || $aTmpGPNPort4Cnt1(cnt6) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=2000����������\
        			NE3($gpnIp3) $GPNTestEth4\����tag=2000������������Ϊ$aTmpGPNPort4Cnt1(cnt6)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctypeΪtagged(NE1:PORT----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=2000����������\
        			NE3($gpnIp3) $GPNTestEth4\����tag=2000������������Ϊ$aTmpGPNPort4Cnt1(cnt6)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$aTmpGPNPort3Cnt1(cnt5) < $rateL || $aTmpGPNPort3Cnt1(cnt5) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000����������\
        			NE1($gpnIp1) $GPNTestEth3\����tag=1000������������Ϊ$aTmpGPNPort3Cnt1(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctypeΪtagged(NE1:PORT----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000����������\
        			NE1($gpnIp1) $GPNTestEth3\����tag=1000������������Ϊ$aTmpGPNPort3Cnt1(cnt5)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$aTmpGPNPort3Cnt1(cnt6) < $rateL || $aTmpGPNPort3Cnt1(cnt6) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=2000����������\
        			NE1($gpnIp1) $GPNTestEth3\����tag=2000������������Ϊ$aTmpGPNPort3Cnt1(cnt6)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctypeΪtagged(NE1:PORT----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=2000����������\
        			NE1($gpnIp1) $GPNTestEth3\����tag=2000������������Ϊ$aTmpGPNPort3Cnt1(cnt6)����$rateL-$rateR\��Χ��" $fileId
        }
	puts $fileId ""
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB2�����ۣ�vctypeΪtaggedģʽ(NE1:PORT----NE3:PORT)����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2�����ۣ�vctypeΪtaggedģʽ(NE1:PORT----NE3:PORT)����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedģʽ(NE1:PORT----NE3:PORT)����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)����ҵ��  ���Կ�ʼ=====\n"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3 "enable"
	}
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "2000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "" $GPNTestEth3 1000 0 "modify" 1000 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "pw1" "eline14"
	
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "enable"
	}
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address3 "2000" "1000" "4" "nochange" "" 1 0 "0x8100" "0x8100" ""
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "2000" $GPNTestEth4
	gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac2000" "" $GPNTestEth4 2000 0 "modify" 2000 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac2000" "pw1" "eline34"
	incr capId
	SendAndStat_ptn002_1 1 "$hGPNPort3Gen $hGPNPort4Gen" "$hGPNPort3Ana $hGPNPort4Ana" "$GPNTestEth3 $GPNTestEth4" \
		"$hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
		"$hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" aTmpGPNPort3Cnt1 aTmpGPNPort4Cnt1 aGPNCnt3 1 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aTmpGPNPort4Cnt1(cnt19) !=0} {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "vctypeΪtagged(PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000����������\
        			NE3($gpnIp3) $GPNTestEth4\����tag=1000������������ӦΪ0ʵΪΪ$aTmpGPNPort4Cnt1(cnt19)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctypeΪtagged(PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000����������\
        			NE3($gpnIp3) $GPNTestEth4\����tag=1000������������ӦΪ0ʵΪΪ$aTmpGPNPort4Cnt1(cnt19)" $fileId
        }
        if {$aTmpGPNPort4Cnt1(cnt20) < $rateL || $aTmpGPNPort4Cnt1(cnt20) > $rateR} {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "vctypeΪtagged(PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=2000����������\
        			NE3($gpnIp3) $GPNTestEth4\����tag=2000������������Ϊ$aTmpGPNPort4Cnt1(cnt20)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctypeΪtagged(PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=2000����������\
        			NE3($gpnIp3) $GPNTestEth4\����tag=2000������������Ϊ$aTmpGPNPort4Cnt1(cnt20)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$aTmpGPNPort3Cnt1(cnt19) < $rateL || $aTmpGPNPort3Cnt1(cnt19) > $rateR} {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "vctypeΪtagged(PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000����������\
        			NE1($gpnIp1) $GPNTestEth3\����tag=1000������������Ϊ$aTmpGPNPort3Cnt1(cnt19)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctypeΪtagged(PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000����������\
        			NE1($gpnIp1) $GPNTestEth3\����tag=1000������������Ϊ$aTmpGPNPort3Cnt1(cnt19)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$aTmpGPNPort3Cnt1(cnt20) !=0} {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "vctypeΪtagged(PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=2000����������\
        			NE1($gpnIp1) $GPNTestEth3\����tag=2000������������ӦΪ0ʵΪΪ$aTmpGPNPort3Cnt1(cnt20)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctypeΪtagged(PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=2000����������\
        			NE1($gpnIp1) $GPNTestEth3\����tag=2000������������ӦΪ0ʵΪΪ$aTmpGPNPort3Cnt1(cnt20)" $fileId
        }
	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB3�����ۣ�vctypeΪtaggedģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3�����ۣ�vctypeΪtaggedģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)����ҵ��  ���Կ�ʼ=====\n"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "2000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "" $GPNTestEth3 1000 100 "modify" 1000 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "pw1" "eline15"
        
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac2000"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac2000"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address3 "2000" "1000" "4" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000" "" $GPNTestEth4 1000 100 "modify" 1000 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000" "pw1" "eline35"
        gwd::Cfg_StreamActive $hGPNPort3Stream10 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream10 "TRUE"
	incr capId
	SendAndStat_ptn002_1 1 "$hGPNPort3Gen $hGPNPort4Gen" "$hGPNPort3Ana $hGPNPort4Ana" "$GPNTestEth3 $GPNTestEth4" \
		"$hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
		"$hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" aTmpGPNPort3Cnt4 aTmpGPNPort4Cnt4 aGPNCnt3 1 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aTmpGPNPort4Cnt4(cnt5) !=0} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000����������\
		        	NE3($gpnIp3) $GPNTestEth4\����tag=1000������������ӦΪ0ʵΪ$aTmpGPNPort4Cnt4(cnt5)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000����������\
				NE3($gpnIp3) $GPNTestEth4\����tag=1000������������ӦΪ0ʵΪ$aTmpGPNPort4Cnt4(cnt5)" $fileId
	}
	if {$aTmpGPNPort4Cnt4(cnt6) !=0} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=2000����������\
				NE3($gpnIp3) $GPNTestEth4\����tag=2000������������ӦΪ0ʵΪ$aTmpGPNPort4Cnt4(cnt6)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=2000����������\
				NE3($gpnIp3) $GPNTestEth4\����tag=2000������������ӦΪ0ʵΪ$aTmpGPNPort4Cnt4(cnt6)" $fileId
	}
	if {$aTmpGPNPort3Cnt4(cnt5) !=0} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000����������\
				NE1($gpnIp1) $GPNTestEth3\����tag=1000������������ӦΪ0ʵΪ$aTmpGPNPort3Cnt4(cnt5)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000����������\
				NE1($gpnIp1) $GPNTestEth3\����tag=1000������������ӦΪ0ʵΪ$aTmpGPNPort3Cnt4(cnt5)" $fileId
	}
	if {$aTmpGPNPort3Cnt4(cnt6) !=0} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=2000����������\
				NE1($gpnIp1) $GPNTestEth3\����tag=2000������������ӦΪ0ʵΪ$aTmpGPNPort3Cnt4(cnt6)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctypeΪtagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=2000����������\
        			NE1($gpnIp1) $GPNTestEth3\����tag=2000������������ӦΪ0ʵΪ$aTmpGPNPort3Cnt4(cnt6)" $fileId
        }

        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $anaFliFrameCfg4
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $anaFliFrameCfg4
	incr capId
	SendAndStat_ptn002_1 1 "$hGPNPort3Gen $hGPNPort4Gen" "$hGPNPort3Ana $hGPNPort4Ana" "$GPNTestEth3 $GPNTestEth4" \
			"$hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
			"$hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" aTmpGPNPort3Cnt4 aTmpGPNPort4Cnt4 aGPNCnt3 2 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aTmpGPNPort4Cnt4(cnt10) < $rateL || $aTmpGPNPort4Cnt4(cnt10) > $rateR} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\�������tag=1000 �ڲ�tag=100\
			����������NE3($gpnIp3) $GPNTestEth4\�������tag=1000 �ڲ�tag=100������������Ϊ$aTmpGPNPort4Cnt4(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\�������tag=1000 �ڲ�tag=100\
			����������NE3($gpnIp3) $GPNTestEth4\�������tag=1000 �ڲ�tag=100������������Ϊ$aTmpGPNPort4Cnt4(cnt10)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aTmpGPNPort3Cnt4(cnt10) < $rateL || $aTmpGPNPort3Cnt4(cnt10) > $rateR} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪtagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\�������tag=1000 �ڲ�tag=100\
			����������NE1($gpnIp1) $GPNTestEth3\�������tag=1000 �ڲ�tag=100������������Ϊ$aTmpGPNPort3Cnt4(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪtagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\�������tag=1000 �ڲ�tag=100\
			����������NE1($gpnIp1) $GPNTestEth3\�������tag=1000 �ڲ�tag=100������������Ϊ$aTmpGPNPort3Cnt4(cnt10)����$rateL-$rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB4�����ۣ�vctypeΪtaggedģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4�����ۣ�vctypeΪtaggedģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪtaggedģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪrawģʽ(NE1:PORT----NE3:PORT)����ҵ��  ���Կ�ʼ=====\n"	
        #######========vctypeΪrawģʽ����==========#########
        set vctype "raw"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3 "disable"
	}
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "2000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "" $GPNTestEth3 0 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "pw1" "eline16"
        
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "disable"
	}
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address3 "2000" "1000" "4" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 0 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline36"
        gwd::Cfg_StreamActive $hGPNPort3Stream5 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream6 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort4Stream5 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort4Stream6 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream10 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort4Stream10 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream3 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream4 "TRUE"
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
	incr capId
        sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
        parray aGPNPort3Cnt1
        parray aGPNPort3Cnt2
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort4Cnt1(cnt1) != 0} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������NE3($gpnIp3) $GPNTestEth4\���յ�\
			tag=100�����ݰ�����ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt1)" $fileId
	} else {
		if {$aGPNPort4Cnt2(cnt1) < $rateL || $aGPNPort4Cnt2(cnt1) > $rateR} {
			set flag5_case2 1
			gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������NE3($gpnIp3) $GPNTestEth4\���յ�\
				untag�����ݰ�����Ϊ$aGPNPort4Cnt2(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������NE3($gpnIp3) $GPNTestEth4\���յ�\
				untag�����ݰ�����Ϊ$aGPNPort4Cnt2(cnt1)����$rateL-$rateR\��Χ��" $fileId
		}
	}
	if {$aGPNPort4Cnt1(cnt2) < $rateL || $aGPNPort4Cnt1(cnt2) > $rateR} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=100��������NE3($gpnIp3) $GPNTestEth4\���յ�\
			tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=100��������NE3($gpnIp3) $GPNTestEth4\���յ�\
			tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
        }
	if {$aGPNPort3Cnt1(cnt3) != 0} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����untag��������NE1($gpnIp1) $GPNTestEth3\���յ�\
			untag�����ݰ�����ӦΪ0ʵΪ$aGPNPort3Cnt1(cnt3)" $fileId
	} else {
		if {$aGPNPort3Cnt2(cnt3) < $rateL || $aGPNPort3Cnt2(cnt3) > $rateR} {
			set flag5_case2 1
			gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����untag��������NE1($gpnIp1) $GPNTestEth3\���յ�\
				untag�����ݰ�����Ϊ$aGPNPort3Cnt2(cnt3)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����untag��������NE1($gpnIp1) $GPNTestEth3\���յ�\
				untag�����ݰ�����Ϊ$aGPNPort3Cnt2(cnt3)����$rateL-$rateR\��Χ��" $fileId
		}
	}
	if {$aGPNPort3Cnt1(cnt4) < $rateL || $aGPNPort3Cnt1(cnt4) > $rateR} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=100��������NE1($gpnIp1) $GPNTestEth3\���յ�\
			tag=100�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt4)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=100��������NE1($gpnIp1) $GPNTestEth3\���յ�\
			tag=100�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt4)����$rateL-$rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag5_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB5�����ۣ�vctypeΪrawģʽ(NE1:PORT----NE3:PORT)����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5�����ۣ�vctypeΪrawģʽ(NE1:PORT----NE3:PORT)����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪrawģʽ(NE1:PORT----NE3:PORT)����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)����ҵ��  ���Կ�ʼ=====\n"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3 "enable"
	}
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "2000" "1" "delete" "" 1000 0 "0x8100" "0x8100" ""
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "" $GPNTestEth3 1000 0 "add" 1000 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "pw1" "eline17"
	
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "enable"
	}
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address3 "2000" "1000" "4" "delete" "" 1000 0 "0x8100" "0x8100" ""
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000" "" $GPNTestEth4 1000 0 "add" 1000 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000" "pw1" "eline37"
	
	gwd::Cfg_StreamActive $hGPNPort3Stream5 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream5 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort4Stream4 "FALSE"
	
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
	incr capId
        sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
        parray aGPNPort3Cnt1
        parray aGPNPort3Cnt2
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort4Cnt2(cnt1) != 0} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������NE3($gpnIp3) $GPNTestEth4\���յ�\
			untag�����ݰ�����ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������NE3($gpnIp3) $GPNTestEth4\���յ�\
			untag�����ݰ�����ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt1)" $fileId
	}
	if {$aGPNPort4Cnt1(cnt5) < $rateL || $aGPNPort4Cnt1(cnt5) > $rateR} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000��������NE3($gpnIp3) $GPNTestEth4\���յ�\
			tag=1000�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000��������NE3($gpnIp3) $GPNTestEth4\���յ�\
			tag=1000�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt5)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aGPNPort3Cnt2(cnt3) != 0} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����untag��������NE1($gpnIp1) $GPNTestEth3\���յ�\
			untag�����ݰ�����ӦΪ0ʵΪ$aGPNPort3Cnt2(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����untag��������NE1($gpnIp1) $GPNTestEth3\���յ�\
			untag�����ݰ�����ӦΪ0ʵΪ$aGPNPort3Cnt2(cnt3)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt5) < $rateL || $aGPNPort3Cnt1(cnt5) > $rateR} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000��������NE1($gpnIp1) $GPNTestEth3\���յ�\
			tag=1000�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000��������NE1($gpnIp1) $GPNTestEth3\���յ�\
			tag=1000�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt5)����$rateL-$rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag6_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB6�����ۣ�vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6�����ۣ�vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����PW12����)����ҵ��  ���Կ�ʼ=====\n"
        gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface1 $ip2 "101" "201" "normal" "9"
        gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address1
        gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWPw_AddPwVcType $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" $vctype
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "l2transport" "7" "" $address1 "1001" "2001" "9" "delete" "" 300 0 "0x8100" "0x8100" ""
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "300" $GPNTestEth3
	gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac300" "" $GPNTestEth3 300 0 "add" 300 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac300" "pw12" "eline18"
        
        gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp12" $interface14 $ip1 "201" "101" "normal" "10"
        gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp12" $address2
        gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp12"
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw12" $vctype
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw12" "l2transport" "8" "" $address2 "2001" "1001" "10" "delete" "" 300 0 "0x8100" "0x8100" ""
        PTN_UNI_AddInter $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel "300" $GPNTestEth1
        gwd::GWpublic_CfgAc $telnet2 $matchType2 $Gpn_type2 $fileId "ac300" "" $GPNTestEth1 300 0 "add" 300 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet2 $matchType2 $Gpn_type2 $fileId "ac300" "pw12" "eline38"
        gwd::GWpublic_addPwLoop $telnet2 $matchType2 $Gpn_type2 $fileId "pw12"
        gwd::Cfg_StreamActive $hGPNPort3Stream7 "TRUE"
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg1
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
        if {$::cap_enable} {
        	gwd::Start_CapAllData ::capArr $hGPNPort1Cap $hGPNPort1CapAnalyzer 
        	gwd::Start_CapAllData ::capArr $hGPNPort3Cap $hGPNPort3CapAnalyzer
        	gwd::Start_CapAllData ::capArr $hGPNPort4Cap $hGPNPort4CapAnalyzer
        }
        gwd::Start_SendFlow "$hGPNPort3Gen $hGPNPort4Gen"  "$hGPNPort1Ana $hGPNPort3Ana $hGPNPort4Ana"
        after $sendTime
	incr capId
        if {$cap_enable} {
        	gwd::Stop_CapData $hGPNPort1Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2\).pcap"
        	gwd::Stop_CapData $hGPNPort3Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap"
        	gwd::Stop_CapData $hGPNPort4Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap"
        }
        foreach i "aGPNPort1Cnt1 aGPNPort3Cnt1 aGPNPort4Cnt1" {
          	array set $i {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0}
        } 
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 1 $hGPNPort1Ana aGPNPort1Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 0 0 0 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 1 $hGPNPort3Ana aGPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 0 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 1 $hGPNPort4Ana aGPNPort4Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 0 1 0 0
		after 5000
	}
        parray aGPNPort1Cnt1
        parray aGPNPort3Cnt1
        parray aGPNPort4Cnt1
        gwd::Stop_SendFlow "$hGPNPort3Gen $hGPNPort4Gen"  "$hGPNPort1Ana $hGPNPort3Ana $hGPNPort4Ana"
	
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort1Cnt1(cnt7)!=0} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����pw12����)ʱ��pw12��ҵ��NE1($gpnIp1) $GPNTestEth3\����tag=300��������\
			NE2($gpnIp2) $GPNTestEth1\���յ�tag=300�����ݰ�����ӦΪ0ʵΪ$aGPNPort1Cnt1(cnt7)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt7)>$rateR|| $aGPNPort3Cnt1(cnt7)<$rateL} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����pw12����)ʱ��pw12��ҵ��NE1($gpnIp1) $GPNTestEth3\����tag=300��������\
			NE1($gpnIp1) $GPNTestEth3\���յ�tag=300�Ļ������ݰ�����Ϊ$aGPNPort3Cnt1(cnt7)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����pw12����)ʱ��pw12��ҵ��NE1($gpnIp1) $GPNTestEth3\����tag=300��������\
			NE1($gpnIp1) $GPNTestEth3\���յ�tag=300�Ļ������ݰ�����Ϊ$aGPNPort3Cnt1(cnt7)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aGPNPort4Cnt1(cnt5) < $rateL || $aGPNPort4Cnt1(cnt5) > $rateR} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����pw12����)ʱ��pw1��ҵ��NE1($gpnIp1) $GPNTestEth3\����tag=1000��������\
			NE3($gpnIp3) $GPNTestEth4\���յ�tag=1000�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����pw12����)ʱ��pw1��ҵ��NE1($gpnIp1) $GPNTestEth3\����tag=1000��������\
			NE3($gpnIp3) $GPNTestEth4\���յ�tag=1000�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt5)����$rateL-$rateR\��Χ�ڣ�����pw12���ص�Ӱ��" $fileId
	}
	if {$aGPNPort3Cnt1(cnt5) < $rateL || $aGPNPort3Cnt1(cnt5) > $rateR} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����pw12����)ʱ��pw1��ҵ��NE3($gpnIp3) $GPNTestEth4\����tag=1000��������\
			NE1($gpnIp1) $GPNTestEth3\���յ�tag=1000�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����pw12����)ʱ��pw1��ҵ��NE3($gpnIp3) $GPNTestEth4\����tag=1000��������\
			NE1($gpnIp1) $GPNTestEth3\���յ�tag=1000�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt5)����$rateL-$rateR\��Χ�ڣ�����pw12���ص�Ӱ��" $fileId
	}
	#NE1����NNI�ڵĳ��뱨��
	array set aMirror "dir1 ingress port1 $GPNPort5 dir2 egress port2 $GPNPort5"
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2 aMirror
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1
	
        if {$::cap_enable} {
        	gwd::Start_CapAllData ::capArr $hGPNPort2Cap $hGPNPort2CapAnalyzer 
        }
        gwd::Start_SendFlow "$hGPNPort3Gen $hGPNPort4Gen"  "$hGPNPort2Ana"
        after 10000
	incr capId
        if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort2Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth2_cap\($gpnIp1\).pcap"
        }
       
        array set aGPNPort2Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0} 
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 6 $hGPNPort2Ana aGPNPort2Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 0 0 0
		after 5000
	}
        parray aGPNPort2Cnt1
        gwd::Stop_SendFlow "$hGPNPort3Gen"  "$hGPNPort2Ana"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth2_cap\($gpnIp1\).pcap" $fileId
	if {$aGPNPort2Cnt1(cnt3) < $rateL1 || $aGPNPort2Cnt1(cnt3) > $rateR1} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����pw12����)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000��������\
			NE1($gpnIp1)$GPNTestEth2_cap\����NNI�ڳ������mpls��ͷsmac=$dev_sysmac1 tag=100�����ݰ�����Ϊ$aGPNPort2Cnt1(cnt3)��û��$rateL1-$rateR1\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����pw12����)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000��������\
			NE1($gpnIp1)$GPNTestEth2_cap\����NNI�ڳ������mpls��ͷsmac=$dev_sysmac1 tag=100�����ݰ�����Ϊ$aGPNPort2Cnt1(cnt3)����$rateL1-$rateR1\��Χ��" $fileId
	}
	if {$aGPNPort2Cnt1(cnt4) < $rateL1 || $aGPNPort2Cnt1(cnt4) > $rateR1} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����pw12����)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000��������\
			NE1($gpnIp1)$GPNTestEth2_cap\����NNI������յ�mpls��ͷsmac=$dev_sysmac2 tag=100�����ݰ�����Ϊ$aGPNPort2Cnt1(cnt4)��û��$rateL1-$rateR1\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����pw12����)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000��������\
			NE1($gpnIp1)$GPNTestEth2_cap\����NNI������յ�mpls��ͷsmac=$dev_sysmac2 tag=100�����ݰ�����Ϊ$aGPNPort2Cnt1(cnt4)����$rateL1-$rateR1\��Χ��" $fileId
	}
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2
	
	#pw ping ��traceroute------	
	gwd::GWpublic_addPwPing $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" pingResult
	if {[dict get $pingResult sucRate]==100.00} {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ����NE1��PING PW1�ĳɹ���ӦΪ100.00%Ϊ[dict get $pingResult sucRate]%" $fileId
	} else {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ����NE1��PING PW1�ĳɹ���ӦΪ100.00%Ϊ[dict get $pingResult sucRate]%" $fileId
	}
	if {[string match [dict get $pingResult replyIp] "192.1.2.4"]} {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ����NE1��PING PW1��reply from ��ipӦΪ192.1.2.4ʵΪ[dict get $pingResult replyIp]" $fileId
	} else {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ����NE1��PING PW1��reply from ��ipӦΪ192.1.2.4ʵΪ[dict get $pingResult replyIp]" $fileId
	}
	gwd::GWpublic_addPwTrace $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
	set expectTrace {2 {replier "192.1.2.4" traceTime "<1ms" type "Egress" downstream "--" ret "success"}}
	if {[Check_Tracertroute "" $expectTrace $result]} {
		set flag7_case2 1 
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ����NE1($gpnIp1)��tracertroute pw1�鿴���ĵ�NE3($gpnIp3)������ÿһ�������쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ����NE1($gpnIp1)��tracertroute pw1�鿴���ĵ�NE3($gpnIp3)������ÿһ����������" $fileId
	}
	#------pw ping ��traceroute
	#lsp ping ��traceroute------
	gwd::GWpublic_addLspPing $telnet1 $matchType1 $Gpn_type1 $fileId "10.1.1.1/32" "generic" pingResult
	if {[dict get $pingResult sucRate]==100.00} {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ����NE1��ping mpls lsp ip 10.1.1.1/32 generic�ĳɹ���ӦΪ100.00%Ϊ[dict get $pingResult sucRate]%" $fileId
	} else {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ����NE1��ping mpls lsp ip 10.1.1.1/32 generic�ĳɹ���ӦΪ100.00%Ϊ[dict get $pingResult sucRate]%" $fileId
	}
	if {[string match [dict get $pingResult replyIp] "192.1.2.4"]} {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ����NE1��ping mpls lsp ip 10.1.1.1/32 generic��reply from ��ipӦΪ192.1.2.4ʵΪ[dict get $pingResult replyIp]" $fileId
	} else {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ����NE1��ping mpls lsp ip 10.1.1.1/32 generic��reply from ��ipӦΪ192.1.2.4ʵΪ[dict get $pingResult replyIp]" $fileId
	}
	gwd::GWpublic_addLspTrace $telnet1 $matchType1 $Gpn_type1 $fileId "10.1.1.1/32" "generic" result
	if {[string match "fail" $result]} {
		set flag7_case2 1 
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ����NE1($gpnIp1)��tracertroute lsp ip 10.1.1.1/32 generic�鿴���ĵ�NE3($gpnIp3)������ÿһ������û�з���success" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ����NE1($gpnIp1)��tracertroute lsp ip 10.1.1.1/32 generic�鿴���ĵ�NE3($gpnIp3)������ÿһ�����Է���success" $fileId
	}
	#------lsp ping ��traceroute
	puts $fileId ""
	if {$flag7_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB7�����ۣ�vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����PW12����)����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7�����ۣ�vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����PW12����)����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����PW12����)����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)����ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac300"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac300"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	PTN_DelInterVid $fileId $Worklevel $interface33 $matchType1 $Gpn_type1 $telnet1
	
	gwd::GWAc_DelActPw $telnet2 $matchType2 $Gpn_type2 $fileId "ac300"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac300"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw12"
	gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp12"
	PTN_DelInterVid $fileId $Worklevel $interface34 $matchType2 $Gpn_type2 $telnet2
	
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "disable"
	}
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address3 "2000" "1000" "4" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 0 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline38"
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
	incr capId
        sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
        parray aGPNPort3Cnt1
        parray aGPNPort3Cnt2
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort3Cnt1(cnt21) < $rateL || $aGPNPort3Cnt1(cnt21) > $rateR} {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����untag��������\
			NE1($gpnIp1) $GPNTestEth3\���յ�tag=1000�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����untag��������\
			NE1($gpnIp1) $GPNTestEth3\���յ�tag=1000�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt5)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aGPNPort4Cnt2(cnt1) !=0} {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������\
			NE3($gpnIp3) $GPNTestEth4\�������ݰ�����ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������\
			NE3($gpnIp3) $GPNTestEth4\�������ݰ�����ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt1)" $fileId
	}
	if {$aGPNPort4Cnt1(cnt5) != 0} {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000��������\
			NE3($gpnIp3) $GPNTestEth4\����tag=1000���ݰ�����ӦΪ0ʵΪ$aGPNPort4Cnt1(cnt5)" $fileId
	} else {
		if {$aGPNPort4Cnt2(cnt5) < $rateL || $aGPNPort4Cnt2(cnt5) > $rateR} {
			set flag8_case2 1
			gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000��������\
				NE3($gpnIp3) $GPNTestEth4\����untag���ݰ�����Ϊ$aGPNPort4Cnt2(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000��������\
				NE3($gpnIp3) $GPNTestEth4\����untag���ݰ�����Ϊ$aGPNPort4Cnt2(cnt5)����$rateL-$rateR\��Χ��" $fileId
		}
	}
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg4
	incr capId
	sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	parray aGPNPort3Cnt1
	parray aGPNPort3Cnt2
	parray aGPNPort4Cnt1
	parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort3Cnt2(cnt5) == 0} {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000��������\
			NE1($gpnIp1) $GPNTestEth3\���յ����ݰ�����Ϊ0" $fileId
	} else {
		if {$aGPNPort3Cnt1(cnt18) < $rateL || $aGPNPort3Cnt1(cnt18) > $rateR} {
			set flag8_case2 1
			gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000��������\
				NE1($gpnIp1) $GPNTestEth3\���յ����tag=1000�ڲ�tag=1000�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt18)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000��������\
				NE1($gpnIp1) $GPNTestEth3\���յ����tag=1000�ڲ�tag=1000�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt18)����$rateL-$rateR\��Χ��" $fileId
		}
	}
	puts $fileId ""
	if {$flag8_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB8�����ۣ�vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8�����ۣ�vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪrawģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)����ҵ��  ���Կ�ʼ=====\n"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "enable"
	}
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address3 "2000" "1000" "4" "delete" "" 2000 0 "0x8100" "0x8100" ""
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac2000" "" $GPNTestEth4 2000 0 "add" 2000 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac2000" "pw1" "eline39"
        gwd::Cfg_StreamActive $hGPNPort4Stream6 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream5 "false"
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
	incr capId
        sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
        parray aGPNPort3Cnt1
        parray aGPNPort3Cnt2
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort4Cnt2(cnt1) !=0} {
		set flag9_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������\
			NE3($gpnIp3) $GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������\
			NE3($gpnIp3) $GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt1)" $fileId
	}
	if {$aGPNPort4Cnt1(cnt20) < $rateL || $aGPNPort4Cnt1(cnt20) > $rateR} {
		set flag9_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000��������\
			NE3($gpnIp3) $GPNTestEth4\�յ�tag=2000�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt20)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000��������\
			NE3($gpnIp3) $GPNTestEth4\�յ�tag=2000�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt20)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$aGPNPort3Cnt2(cnt3) !=0} {
		set flag9_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE3($gpnIp3) $GPNTestEth4\����untag��������\
			NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt2(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE3($gpnIp3) $GPNTestEth4\����untag��������\
			NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt2(cnt3)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt19) < $rateL || $aGPNPort3Cnt1(cnt19) > $rateR} {
		set flag9_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=2000��������\
			NE1($gpnIp1) $GPNTestEth3\�յ�tag=1000�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt19)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=2000��������\
			NE1($gpnIp1) $GPNTestEth3\�յ�tag=1000�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt19)����$rateL-$rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag9_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB9�����ۣ�vctypeΪrawģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9�����ۣ�vctypeΪrawģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪrawģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)����ҵ��  ���Կ�ʼ=====\n"
        ###ɾ������ģʽΪ���˿�+��Ӫ��VLAN����ac,�ٴδ�������ģʽΪ���˿�+��Ӫ��VLAN+�ͻ�VLAN����ר��ҵ��
        ###����7600-1
        ###�����豸NE1
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "2000" "1" "delete" "" 1000 0 "0x8100" "0x8100" ""
        if {[gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "" $GPNTestEth3 1000 100 "add" 1000 0 0 "0x8100"]} {
        	set flag10_case2 1
		gwd::gwd::GWpublic_print "NOK" "rawģʽ�ٴδ�������ģʽΪ���˿�+��Ӫ��VLAN+�ͻ�VLAN����ר��ҵ�񣬴���ʧ��" $fileId
        }
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "pw1" "eline110"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        ###����7600-3
        ###�����豸NE3
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac2000"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac2000"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address3 "2000" "1000" "4" "delete" "" 1000 0 "0x8100" "0x8100" ""
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000" "" $GPNTestEth4 1000 100 "add" 1000 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000" "pw1" "eline310"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"
	gwd::Cfg_StreamActive $hGPNPort4Stream6 "false"
	gwd::Cfg_StreamActive $hGPNPort4Stream5 "true"
	gwd::Cfg_StreamActive $hGPNPort3Stream2 "true"
	gwd::Cfg_StreamActive $hGPNPort4Stream4 "true"
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg0
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg0
	incr capId
	SendAndStat_ptn002_1 1 "$hGPNPort3Gen $hGPNPort4Gen" "$hGPNPort3Ana $hGPNPort4Ana" "$GPNTestEth3 $GPNTestEth4" \
			"$hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
			"$hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" aGPNPort3Cnt2 aGPNPort4Cnt2 aGPNCnt3 0 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1) !=0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������\
			NE3($gpnIp3) $GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����untag��������\
			NE3($gpnIp3) $GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt1)" $fileId
	}
	if {$aGPNPort4Cnt2(cnt2) !=0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=100��������\
			NE3($gpnIp3) $GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=100��������\
			NE3($gpnIp3) $GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt2)" $fileId
	}
	if {$aGPNPort4Cnt2(cnt5) !=0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000��������\
			NE3($gpnIp3) $GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt5)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\����tag=1000��������\
			NE3($gpnIp3) $GPNTestEth4\�������ݰ�������ӦΪ0ʵΪ$aGPNPort4Cnt2(cnt5)" $fileId
	}
	if {$aGPNPort3Cnt2(cnt3) !=0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����untag��������\
			NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt2(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����untag��������\
			NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt2(cnt3)" $fileId
	}
	if {$aGPNPort3Cnt2(cnt4) !=0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=100��������\
			NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt2(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=100��������\
			NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt2(cnt4)" $fileId
	}
	if {$aGPNPort3Cnt2(cnt5) !=0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000��������\
			NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt2(cnt5)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\����tag=1000��������\
			NE1($gpnIp1) $GPNTestEth3\�������ݰ�������ӦΪ0ʵΪ$aGPNPort3Cnt2(cnt5)" $fileId
	}
	gwd::Cfg_StreamActive $hGPNPort3Stream1 "false"
	gwd::Cfg_StreamActive $hGPNPort3Stream2 "false"
	gwd::Cfg_StreamActive $hGPNPort4Stream3 "false"
	gwd::Cfg_StreamActive $hGPNPort4Stream4 "false"
	gwd::Cfg_StreamActive $hGPNPort3Stream5 "false"
	gwd::Cfg_StreamActive $hGPNPort4Stream5 "false"
        gwd::Cfg_StreamActive $hGPNPort3Stream10 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream10 "TRUE"
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg4
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg4
	incr capId
	sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
        parray aGPNPort3Cnt1
        parray aGPNPort3Cnt2
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort4Cnt2(cnt10) == 0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\�������tag=1000�ڲ�tag=100\
			����������NE3($gpnIp3) $GPNTestEth4\�������ݰ�������Ϊ0" $fileId
	} else {
		if {$aGPNPort4Cnt1(cnt10) > $rateR || $aGPNPort4Cnt1(cnt10) < $rateL} {
			set flag10_case2 1
			gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\�������tag=1000�ڲ�tag=100\
				����������NE3($gpnIp3) $GPNTestEth4\�յ����tag=1000�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE1($gpnIp1) $GPNTestEth3\�������tag=1000�ڲ�tag=100\
				����������NE3($gpnIp3) $GPNTestEth4\�յ����tag=1000�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort4Cnt1(cnt10)����$rateL-$rateR\��Χ��" $fileId
		}
	}
	if {$aGPNPort3Cnt2(cnt10) == 0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\�������tag=1000�ڲ�tag=100\
			����������NE1($gpnIp1) $GPNTestEth3\�������ݰ�������Ϊ0" $fileId
	} else {
		if {$aGPNPort3Cnt1(cnt10) > $rateR || $aGPNPort3Cnt1(cnt10) < $rateL} {
			set flag10_case2 1
			gwd::GWpublic_print "NOK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\�������tag=1000�ڲ�tag=100\
				����������NE1($gpnIp1) $GPNTestEth3\�յ����tag=1000�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)ʱ��NE3($gpnIp3) $GPNTestEth4\�������tag=1000�ڲ�tag=100\
				����������NE1($gpnIp1) $GPNTestEth3\�յ����tag=1000�ڲ�tag=100�����ݰ�����Ϊ$aGPNPort3Cnt1(cnt10)����$rateL-$rateR\��Χ��" $fileId
		}
	}
	puts $fileId ""
	if {$flag10_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC1�����ۣ�vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1�����ۣ�vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����֮ǰ��PW1��vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)���½�һ��������vctype��PW2����ҵ��  ���Կ�ʼ=====\n"
        #######========�ָ�vctypeģʽ����==========#########
        ##����ͬһ��lsp����e-line����
        ##����7600-1
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "l2transport" "3" "" $address1 "3000" "4000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" result
        PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "3000" $GPNTestEth3
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac3000" "" $GPNTestEth3 3000 300 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac3000" "pw2" "eline112"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac3000"
        ##����7600-3
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw2" "l2transport" "4" "" $address3 "4000" "3000" "4" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw2" result
        PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "3000" $GPNTestEth4
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac3000" "" $GPNTestEth4 3000 300 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac3000" "pw2" "eline312"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac3000"
	
	gwd::Cfg_StreamActive $hGPNPort3Stream9 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream9 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort3Stream7 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort3Stream8 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream3 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream7 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream8 "TRUE"
	incr capId
	if {[Test_Case2 "" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
		set flag11_case2 1
	}
	puts $fileId ""
	if {$flag11_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC2�����ۣ�����֮ǰ��PW1��vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)���½�һ��������vctype��PW2����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2�����ۣ�����֮ǰ��PW1��vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)���½�һ��������vctype��PW2����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����֮ǰ��PW1��vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)���½�һ��������vctype��PW2����ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW���ã�����shutdown/undo shutdown NE3($gpnIp3)UNI��NNI�ں����ҵ��ָ�  ���Կ�ʼ=====\n"
	##����undo shutdown/shutdown�˿�
        foreach eth $portList33 {
		gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
          		gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $eth "shutdown"
          		gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $eth "undo shutdown"
        		after $WaiteTime
			incr capId
			if {[Test_Case2 "��$j\��undo shutdown/shutdown NE3($gpnIp3)��$eth\�˿�" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag12_case2 1
			}
        	}
		gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag12_case2 1
			gwd::GWpublic_print "NOK" "����shutdown/undo shutdown NE3($gpnIp3)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "����shutdown/undo shutdown NE3($gpnIp3)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
		}
        }
	puts $fileId ""
	if {$flag12_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC3�����ۣ�����PW���ã�����shutdown/undo shutdown NE3($gpnIp3)UNI��NNI�ں����ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3�����ۣ�����PW���ã�����shutdown/undo shutdown NE3($gpnIp3)UNI��NNI�ں����ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW���ã�����shutdown/undo shutdown NE3($gpnIp3)UNI��NNI�ں����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW���ã��������� NE3($gpnIp3)UNI��NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
        ###���������˿����ڰ忨
        foreach slot $rebootSlotlist3 {
		gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource3
		set testFlag 0
        	for {set j 1} {$j<=$cnt} {incr j} {
          		if {![gwd::GWCard_AddReboot $telnet3 $matchType3 $Gpn_type3 $fileId $slot]} {
          			after $rebootBoardTime
          			if {[string match $mslot3 $slot]} {
					 set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
					 set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
           			}
				incr capId
				if {[Test_Case2 "��$j\������NE3($gpnIp3)$slot\��λ�忨" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
					set flag13_case2 1
				}
				  
         		} else {
				set testFlag 1
				gwd::GWpublic_print "OK" " NE3($gpnIp3)$slot\��λ�忨��֧�ְ忨������������������" $fileId
				break
         		}
        	}
		if {$testFlag == 0} {
			gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource4
			send_log "\n resource3:$resource3"
			send_log "\n resource4:$resource4"
			if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
				set flag13_case2 1
				gwd::GWpublic_print "NOK" "��������NE3($gpnIp3)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "��������NE3($gpnIp3)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
			}
		}
        }
	puts $fileId ""
	if {$flag13_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC4�����ۣ�����PW���ã��������� NE3($gpnIp3)UNI��NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4�����ۣ�����PW���ã��������� NE3($gpnIp3)UNI��NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW���ã��������� NE3($gpnIp3)UNI��NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW���ã� NE3($gpnIp3)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
        ##��������NMS��������
	gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource5
        for {set j 1} {$j<$cntdh} {incr j} {
		set testFlag 0
        	if {![gwd::GWCard_AddSwitch $telnet3 $matchType3 $Gpn_type3 $fileId]} {
                	after $rebootTime
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
			incr capId
			if {[Test_Case2 "��$j\�� NE3($gpnIp3)����NMS��������" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag14_case2 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet3 $matchType3 $Gpn_type3 $fileId "4" result
			if {![string match [dict get $result 4 pwOutLabel] 4000] || ![string match [dict get $result 4 lspOutLabel] +400]} {
				set flag14_case2 1
				gwd::GWpublic_print "NOK" "VC=4 ��pwOutLabelΪ[dict get $result 4 pwOutLabel] \
						lspOutLabelΪ[dict get $result 4 lspOutLabel]��NE3($gpnIp3)��$j\�ν���NMS��������ת�������쳣" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=4 ��pwOutLabelΪ[dict get $result 4 pwOutLabel] \
						lspOutLabelΪ[dict get $result 4 lspOutLabel]��NE3($gpnIp3)��$j\�ν���NMS��������ת����������" $fileId
			}
        	} else {
			set testFlag 1 
			gwd::GWpublic_print "OK" "NE3($gpnIp3)��֧��NMS������������ֻ��һ��NMS�忨����������" $fileId
			break
        	}
        }
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource6
		send_log "\n resource5:$resource5"
		send_log "\n resource6:$resource6"
		if {$resource6 > [expr $resource5 + $resource5 * $errRate]} {
			set flag14_case2 1
			gwd::GWpublic_print "NOK" "NE3($gpnIp3)��������NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($gpnIp3)��������NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag14_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC5�����ۣ�����PW���ã� NE3($gpnIp3)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5�����ۣ�����PW���ã� NE3($gpnIp3)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW���ã� NE3($gpnIp3)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW���ã� NE3($gpnIp3)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
        ##��������SW��������
	gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource7
        for {set j 1} {$j<$cntdh} {incr j} {
		set testFlag 0 
        	if {![gwd::GWCard_AddSwitchSw $telnet3 $matchType3 $Gpn_type3 $fileId]} {
                	after $rebootTime
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
			incr capId
			if {[Test_Case2 "��$j\�� NE3($gpnIp3)����SW��������" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag15_case2 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet3 $matchType3 $Gpn_type3 $fileId "4" result
			if {![string match [dict get $result 4 pwOutLabel] 4000] || ![string match [dict get $result 4 lspOutLabel] +400]} {
				set flag15_case2 1
				gwd::GWpublic_print "NOK" "VC=4 ��pwOutLabelΪ[dict get $result 4 pwOutLabel] \
						lspOutLabelΪ[dict get $result 4 lspOutLabel]��NE3($gpnIp3)��$j\�ν���SW��������ת�������쳣" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=4 ��pwOutLabelΪ[dict get $result 4 pwOutLabel] \
						lspOutLabelΪ[dict get $result 4 lspOutLabel]��NE3($gpnIp3)��$j\�ν���SW��������ת����������" $fileId
			}
        	} else {
			set testFlag 1 
			gwd::GWpublic_print "OK" "NE3($gpnIp3)��֧��SW������������ֻ��һ��SW�忨����������" $fileId
			break
        	}
        }
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource8
		send_log "\n resource7:$resource7"
		send_log "\n resource8:$resource8"
		if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
			set flag15_case2 1
			gwd::GWpublic_print "NOK" "NE3($gpnIp3)��������SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($gpnIp3)��������SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag15_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC6�����ۣ�����PW���ã� NE3($gpnIp3)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6�����ۣ�����PW���ã� NE3($gpnIp3)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW���ã� NE3($gpnIp3)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW���ã� NE3($gpnIp3)���������豸��������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
        ##���������豸����
	gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource9
        for {set j 1} {$j<=$cnt} {incr j} {
        	
          	gwd::GWpublic_SaveCfg $telnet3 $matchType3 $Gpn_type3 $fileId
          	gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
          	after $rebootTime
		set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		incr capId
		if {[Test_Case2 "��$j\�� NE3($gpnIp3)���б�������" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
			set flag16_case2 1
		}
		gwd::GWpublic_QueryMPLSForwardTable $telnet3 $matchType3 $Gpn_type3 $fileId "4" result
		if {![string match [dict get $result 4 pwOutLabel] 4000] || ![string match [dict get $result 4 lspOutLabel] +400]} {
			set flag16_case2 1
			gwd::GWpublic_print "NOK" "VC=4 ��pwOutLabelΪ[dict get $result 4 pwOutLabel] \
					lspOutLabelΪ[dict get $result 4 lspOutLabel]��NE3($gpnIp3)��$j\�α����豸����ת�������쳣" $fileId
		} else {
			gwd::GWpublic_print "OK" "VC=4 ��pwOutLabelΪ[dict get $result 4 pwOutLabel] \
					lspOutLabelΪ[dict get $result 4 lspOutLabel]��NE3($gpnIp3)��$j\�α����豸����ת����������" $fileId
		}
        }
	gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag16_case2 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)��������SW��������֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)��������SW��������֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag16_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC7�����ۣ�����PW���ã� NE3($gpnIp3)���������豸��������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7�����ۣ�����PW���ã� NE3($gpnIp3)���������豸��������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����PW���ã� NE3($gpnIp3)���������豸��������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
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
	puts $fileId "Test Case 2 �´���E-LINEҵ�񣬽�����ģʽ��Ϊ���˿�+��Ӫ��VLAN��ʱ���ܼ�ҵ��ָ����� ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 FE�˿�ΪUNI�ڵĲ���\n"
        #   <1>��NNI�˿ڸ���Ϊ10GE�˿ڣ������������䣬�ظ����ϲ���
        #   <2>��UNI�˿ڸ���ΪFE/10GE�˿ڣ�NNI�˿ڸ���ΪGE/10GE�˿ڣ������������䣬�ظ����ϲ���
        #   <3>��FE�˿�����ELINEҵ��ʱ���迪���ð忨��MPLSҵ��ģʽ��mpls enable <slot>��
        puts $fileId "FE�˿�ΪUNI�ڵĲ���û�и��ǣ�����"
        puts $fileId ""
	puts $fileId ""
	puts $fileId "Test Case 3 FE�˿�ΪUNI�ڵĲ��� ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 �´���E-LINEҵ��NNI�˿ڸ���ʱ���ܼ�ҵ��ָ�����\n"
        #   <1>���´���һ��NE1��NE3��E-LINEҵ��NNI�˿�(GE�˿�)��֮ǰ������ҵ���NNI�˿���ͬ����NNI�˿ڸ��ã�
        #      ֻ����tag��ʽ���뵽����VLANIF 200�У��û��ࣨGE�˿ڣ�����ģʽΪ�˿�ģʽ�������´���LSP��PW��AC
        #   <2>����NE1��LSP10���ǩ16������ǩ17��PW10���ر�ǩ20��Զ�̱�ǩ21
        #      ����NE3��LSP10���ǩ18������ǩ19��PW10���ر�ǩ21��Զ�̱�ǩ20 
        #      NE2��SW���ã�˫���ǩ ��mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000> <1-65535> [normal|ring]��
        #      Ԥ�ڽ����ҵ�����óɹ�����֮ǰ��E-LINEҵ����Ӱ�죬ϵͳ���쳣
        #   <3>NE1��NE3�û�������undo vlan check
        #   <4>����PW1/AC1
        #   <5>��NE1�Ķ˿�1����untag/tagҵ���������۲�NE3�Ķ˿�3�Ľ��ս��
        #   Ԥ�ڽ����NE3�Ķ˿�3����������untag/tagҵ��������˫����untag/tagҵ�����������֮ǰ��ҵ���޸���
        #   <6>����NE1��NNI�˿�egress������
        #   Ԥ�ڽ����������Ϊ��VLAN TAG��ǩ����������mpls��ǩ���ģ����lsp��ǩ17���ڲ�pw��ǩ21
        #             LSP�ֶ��е�TTLֵΪ255��PW�ֶ��е�TTLֵΪ255��PW�ֶ��к���4�ֽڿ�����
        #   <7>����NE2��NNI�˿�egress����ͬ������ץ�������ǩ������ǩ����Ϊ18���ڲ��ǩ21��LSP�ֶ��е�TTLֵ��1��PW�ֶ��е�TTLֵ��Ϊ255
        #   <8>undo shutdown��shutdown NE1��NE2�豸��NNI/UNI�˿�50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
        #   <9>����NE1��NE2�豸��NNI/UNI�˿����ڰ忨50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
        #   <10>NE1��NE2�豸����SW/NMS����50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 ���鿴��ǩת��������ȷ
        #   <11>��������NE1��NE2�豸��50�Σ�ÿ�β�����ϵͳ����������ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣���鿴��ǩת��������ȷ
        set flag1_case4 0
        set flag2_case4 0
        set flag3_case4 0
        set flag4_case4 0
        set flag5_case4 0
        set flag6_case4 0
        set flag7_case4 0
        set flag8_case4 0
        
        set ip1 192.1.3.1
        set ip2 192.1.3.2
        set ip3 192.1.4.3
        set ip4 192.1.4.4
        set address1 10.1.2.1
        set address2 10.1.2.2
        set address3 10.1.2.3
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�´���E-LINEҵ��NNI�˿ڸ��ò���ҵ��  ���Կ�ʼ=====\n"
        ###����7600-1
        PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface17 $ip1 $GPNPort5 $matchType1 $Gpn_type1 $telnet1
        gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp10" $interface17 $ip2 "16" "17" "normal" "5"
        gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp10" $address1
        gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp10"
        gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp10"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw10" "l2transport" "5" "" $address1 "21" "20" "5" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw10" result
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2 "disable"
	}
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac10" "" $GPNTestEth2 0 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac10" "pw10" "eline15"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac10"
        ###����7600-2
        PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface18 $ip2 $GPNPort6 $matchType2 $Gpn_type2 $telnet2
        PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface19 $ip3 $GPNPort7 $matchType2 $Gpn_type2 $telnet2
        gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface19 $ip4 "17" "18" "0" 6 "normal"
        gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface18 $ip1 "19" "16" "0" 7 "normal"
        ##����7600-3
        PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface20 $ip4 $GPNPort8 $matchType3 $Gpn_type3 $telnet3
        gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp10" $interface20 $ip3 "18" "19" "normal" "8"
        gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp10" $address3
        gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp10"
        gwd::GWpublic_showTunnelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp10"
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw10" "l2transport" "6" "" $address3 "20" "21" "8" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw10" result
        PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "500" $GPNTestEth4
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac10" "" $GPNTestEth4 500 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac10" "pw10" "eline35"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac10"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort4Stream3 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort2Stream11 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort2Stream12 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream13 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream14 "TRUE"
	incr capId
	if {[Test_Case4 "" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
		set flag1_case4 1
	}
	puts $fileId ""
	if {$flag1_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC8�����ۣ�����ELineҵ��NNI�ڸ��ò���ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8�����ۣ�����ELineҵ��NNI�ڸ��ò���ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�´���E-LINEҵ��NNI�˿ڸ��ò���ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����E-LINEҵ�� �����´���E-LINEҵ��Ķ˿�����ͳ��  ���Կ�ʼ=====\n"
        ###�����豸NE1
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp10" "enable"
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw10" "enable"
        gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac10" "enable"
        gwd::Cfg_StreamActive $hGPNPort3Stream7 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream8 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort3Stream9 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort3Stream10 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort4Stream7 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort4Stream8 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort4Stream9 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort4Stream10 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort4Stream13 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort4Stream14 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort2Stream11 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort2Stream12 "FALSE"
	if {[PTN_EVP_State $telnet1 $matchType1 $Gpn_type1 $fileId "$hGPNPort4Stream14 $hGPNPort2Stream11 $hGPNPort2Stream12" \
				$GPNTestEth2 "lsp10" "pw10" "ac10" $hGPNPort2Ana $hGPNPort2Gen]} {
		set flag2_case4 1
	}
	puts $fileId ""
	if {$flag2_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC9�����ۣ��´���E-LINEҵ��NNI�ڸ��á��˿�$GPNTestEth2 lsp10 pw10 ac10 ����ͳ�ƹ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC9�����ۣ��´���E-LINEҵ��NNI�ڸ��á��˿�$GPNTestEth2 lsp10 pw10 ac10 ����ͳ�ƹ���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����E-LINEҵ�� �����´���E-LINEҵ��Ķ˿�����ͳ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�����´���E-LINEҵ��NNI����ӵ�mpls��ǩ��vlan�Ƿ���ȷ  ���Կ�ʼ=====\n"
        gwd::Cfg_StreamActive $hGPNPort2Stream12 "TRUE"
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3 aMirror
        
        if {$::cap_enable} {
            	gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
        }
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg2
        gwd::Start_SendFlow "$::hGPNPort2Gen"  "$::hGPNPort3Ana"
        after $sendTime
	incr capId
        if {$::cap_enable} {
            	gwd::Stop_CapData $::hGPNPort3Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap"
        }
        foreach i "aTmpGPNPort3Cnt2 aTmpGPNPort3Cnt3" {
          	array set $i {cnt3 0 cnt4 0} 
        }
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 2 $::hGPNPort3Ana aTmpGPNPort3Cnt2]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 0 0 0
		after 5000
	}
        parray aTmpGPNPort3Cnt2
        gwd::Stop_SendFlow "$::hGPNPort2Gen"  "$::hGPNPort1Ana"
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg3
        gwd::Start_SendFlow "$::hGPNPort2Gen"  "$::hGPNPort4Ana"
        after $sendTime
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 3 $::hGPNPort3Ana aTmpGPNPort3Cnt3]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 0 0 0
		after 5000
	}
        parray aTmpGPNPort3Cnt3
	gwd::Stop_SendFlow "$::hGPNPort2Gen"  "$::hGPNPort4Ana"
	
	gwd::GWpublic_print "  " "GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
        if {$aTmpGPNPort3Cnt2(cnt3) < $rateL1 || $aTmpGPNPort3Cnt2(cnt3) > $rateR1} {
        	set flag3_case4 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3����NNI��NE1($gpnIp1)$GPNPort5\���ݣ��˿��յ������ݴ��ϵ�˫��mpls��ǩ����ȷ" $fileId
        } else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3����NNI��NE1($gpnIp1)$GPNPort5\���ݣ��˿��յ������ݴ��ϵ�˫��mpls��ǩ��ȷ" $fileId
        }
	
        if {$aTmpGPNPort3Cnt3(cnt3) < $rateL1 || $aTmpGPNPort3Cnt3(cnt3)> $rateR1} {
		set flag3_case4 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3����NNI��NE1($gpnIp1)$GPNPort5\���ݣ��˿��յ������ݴ��ϵ�vid��ǩ����ȷ" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3����NNI��NE1($gpnIp1)$GPNPort5\���ݣ��˿��յ������ݴ��ϵ�vid��ǩ��ȷ" $fileId
	}
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3
        ##����NE2 NNI������
        ###�����豸NE2
	array set aMirror "dir1 egress port1 $GPNPort7 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth1 aMirror
        if {$::cap_enable} {
            	gwd::Start_CapAllData ::capArr $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
        }
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort1AnaFrameCfgFil $::anaFliFrameCfg2
        gwd::Start_SendFlow "$::hGPNPort2Gen"  "$::hGPNPort1Ana"
        after $sendTime
	incr capId
        if {$::cap_enable} {
		gwd::Stop_CapData $::hGPNPort1Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2\).pcap"
        }
        foreach i "aTmpGPNPort1Cnt2 aTmpGPNPort1Cnt3" {
          array set $i {cnt5 0 cnt6 0} 
        }
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 2 $::hGPNPort1Ana aTmpGPNPort1Cnt2]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 0 0 0 0 0
		after 5000
	}
        parray aTmpGPNPort1Cnt2
        gwd::Stop_SendFlow "$::hGPNPort2Gen"  "$::hGPNPort1Ana"
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort1AnaFrameCfgFil $::anaFliFrameCfg3
        gwd::Start_SendFlow "$::hGPNPort2Gen"  "$::hGPNPort1Ana"
        after $sendTime
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 3 $::hGPNPort1Ana aTmpGPNPort1Cnt3]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 0 0 0 0 0
		after 5000
	}
        parray aTmpGPNPort1Cnt3
	gwd::Stop_SendFlow "$::hGPNPort2Gen"  "$::hGPNPort1Ana"
	
	gwd::GWpublic_print "  " "GPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2\).pcap" $fileId
        if {$aTmpGPNPort1Cnt2(cnt5) < $rateL1 || $aTmpGPNPort1Cnt2(cnt5) > $rateR1} {
		set flag3_case4 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1����NNI��NE2($gpnIp2)$GPNPort7\���ݣ��˿��յ������ݴ��ϵ�˫��mpls��ǩ����ȷ" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1����NNI��NE2($gpnIp2)$GPNPort7\���ݣ��˿��յ������ݴ��ϵ�˫��mpls��ǩ��ȷ" $fileId
	}
        if {$aTmpGPNPort1Cnt3(cnt5) < $rateL1 || $aTmpGPNPort1Cnt3(cnt5)> $rateR1} {
		set flag3_case4 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1����NNI��NE1($gpnIp2)$GPNPort7\���ݣ��˿��յ������ݴ��ϵ�vid��ǩ����ȷ" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1����NNI��NE1($gpnIp2)$GPNPort7\���ݣ��˿��յ������ݴ��ϵ�vid��ǩ��ȷ" $fileId
	}
	gwd::GWpublic_DelPortMirror $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth1
	puts $fileId ""
	if {$flag3_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD1�����ۣ������´���E-LINEҵ��NNI����ӵ�mpls��ǩ��vlan" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD1�����ۣ������´���E-LINEҵ��NNI����ӵ�mpls��ǩ��vlan" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�����´���E-LINEҵ��NNI����ӵ�mpls��ǩ��vlan�Ƿ���ȷ  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����shutdown/undoshutdownNE2($gpnIp2)��NNI�ڣ�����ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Կ�ʼ=====\n"
	gwd::Cfg_StreamActive $hGPNPort2Stream11 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort2Stream12 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream13 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream14 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort3Stream9 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream9 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort3Stream10 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream10 "TRUE"
	stc::perform saveasxml -fileName "test.xml"
        ###����undo shutdown/shutdown�˿�
        foreach eth $portlist2 {
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
                        gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $eth "shutdown"
                        gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $eth "undo shutdown"
                       	after $WaiteTime
			incr capId
			if {[Test_Case4 "��$j\��undo shutdown/shutdown NE2($gpnIp2)��$eth\�˿�" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag4_case4 1
			}
                }
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag4_case4 1
			gwd::GWpublic_print "NOK" "����shutdown/undo shutdown NE2($gpnIp2)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "����shutdown/undo shutdown NE2($gpnIp2)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
		}
        }
	puts $fileId ""
	if {$flag4_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD2�����ۣ�����shutdown/undoshutdownNE2($gpnIp2)��NNI�ڣ�����ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD2�����ۣ�����shutdown/undoshutdownNE2($gpnIp2)��NNI�ڣ�����ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����shutdown/undoshutdownNE2($gpnIp2)��NNI�ڣ�����ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��������NE1($gpnIp1)NNI/UNI�����ڰ忨������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Կ�ʼ=====\n"
        ###���������˿����ڰ忨
        ###�����豸NE1
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
				if {[Test_Case4 "��$j\������NE1($gpnIp1)�豸NNI/UNI�����ڰ忨$slot" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
					set flag5_case4 1
				}
         		} else {
				set testFlag 1
				  gwd::GWpublic_print "OK" "$matchType1\��$slot\��λ�İ忨��֧��������������������" $fileId
         		}
        	}
		if {$testFlag == 0} {
			gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
			send_log "\n resource3:$resource3"
			send_log "\n resource4:$resource4"
			if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
				set flag5_case4	1
				gwd::GWpublic_print "NOK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
			} 
		}
        }
	puts $fileId ""
	if {$flag5_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD3�����ۣ���������NE1($gpnIp1)NNI/UNI�����ڰ忨������ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD3�����ۣ���������NE1($gpnIp1)NNI/UNI�����ڰ忨������ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��������NE1($gpnIp1)NNI/UNI�����ڰ忨������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������NMS��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Կ�ʼ=====\n"
        ###��������NMS��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_Case4 "��$j\��NE1($gpnIp1)����NMS��������" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag6_case4 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "5" result
			if {![string match [dict get $result 5 pwOutLabel] 21] || ![string match [dict get $result 5 lspOutLabel] +17]} {
				set flag6_case4 1
				gwd::GWpublic_print "NOK" "VC=5 ��pwOutLabelΪ[dict get $result 5 pwOutLabel] \
						lspOutLabelΪ[dict get $result 5 lspOutLabel]��NE1($gpnIp1)��$j\�ν���NMS��������ת�������쳣" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=5 ��pwOutLabelΪ[dict get $result 5 pwOutLabel] \
						lspOutLabelΪ[dict get $result 5 lspOutLabel]��NE1($gpnIp1)��$j\�ν���NMS��������ת����������" $fileId
			}
        	} else {
			set testFlag 1
			gwd::GWpublic_print "OK" "$matchType1\��֧��NMS����������ֻ��һ��NMS�忨����������" $fileId
			break
        	}
        }
	if {$testFlag == 0} {
	        gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource6
	        send_log "\n resource5:$resource5"
	        send_log "\n resource6:$resource6"
	        if {$resource6 > [expr $resource5 + $resource5 * $errRate]} {
			set flag6_case4	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
	        }
	}
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD4�����ۣ�NE1($gpnIp1)��������NMS��������������ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD4�����ۣ�NE1($gpnIp1)��������NMS��������������ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������NMS��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������SW��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Կ�ʼ=====\n"
        ##��������SW��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	set testFlag 0
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_Case4 "��$j\��NE1($gpnIp1)����SW��������" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag7_case4 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "5" result
			if {![string match [dict get $result 5 pwOutLabel] 21] || ![string match [dict get $result 5 lspOutLabel] +17]} {
				set flag7_case4 1
				gwd::GWpublic_print "NOK" "VC=5 ��pwOutLabelΪ[dict get $result 5 pwOutLabel] \
						lspOutLabelΪ[dict get $result 5 lspOutLabel]��NE1($gpnIp1)��$j\�ν���SW��������ת�������쳣" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=5 ��pwOutLabelΪ[dict get $result 5 pwOutLabel] \
						lspOutLabelΪ[dict get $result 5 lspOutLabel]��NE1($gpnIp1)��$j\�ν���SW��������ת����������" $fileId
			}
        	} else {
			set testFlag 1
			gwd::GWpublic_print "OK" "$matchType1\��֧��SW����������ֻ��һ��SW�忨����������" $fileId
			break
        	}
        }
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource8
		send_log "\n resource7:$resource7"
		send_log "\n resource8:$resource8"
		if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
			set flag7_case4	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag7_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD5�����ۣ�NE1($gpnIp1)��������SW��������������ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD5�����ۣ�NE1($gpnIp1)��������SW��������������ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������SW��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)���������豸����������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Կ�ʼ=====\n"
        ###�����豸NE2
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource9
        for {set j 1} {$j<=$cnt} {incr j} {
          	gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
          	gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
          	after $rebootTime
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		incr capId
		if {[Test_Case4 "��$j\��NE2($gpnIp2)�����豸����" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
			set flag8_case4 1
		}
		gwd::GWpublic_QueryMPLSForwardTable $telnet2 $matchType2 $Gpn_type2 $fileId "" result1
		set table ""
		foreach {tmp x y z a} [regexp -all -inline -line {(\d+)\s+(\d+)\s+--\s+(v\d+|eth\d+/\d+\.\d+)\s+([\d+|\.]+)} $result1] {
			lappend table $z "localLable $x remoteLable $y nextHop $a"
		}
		if {[string match "L2" $Worklevel]} {
			set matchPara1 v100
			set matchPara2 v200
			set matchPara3 v300
			set matchPara4 v400
		} else {
			set matchPara1 eth7/1.100
			set matchPara2 eth9/2.200
			set matchPara3 eth7/1.300
			set matchPara4 eth9/2.400
			
		}
		if {[dict exists $table $matchPara1]} {
			if {([dict get $table $matchPara1 localLable] == 400) && ([dict get $table $matchPara1 remoteLable] == 100) && ([string match [dict get $table $matchPara1 nextHop] "192.1.1.1"])} {
				gwd::GWpublic_print "OK" "ת������localLable=400 outgoingLable=100 outgoingInterface=$matchPara1 nextHop=192.1.1.1 ����" $fileId
			} else {
				set flag8_case4 1 
				gwd::GWpublic_print "NOK" "δ�ҵ�ת������localLable=400 outgoingLable=100 outgoingInterface=$matchPara1 nextHop=192.1.1.1" $fileId
			}
		} else {
			set flag8_case4 1
			gwd::GWpublic_print "NOK" "δ�ҵ�ת������localLable=400 outgoingLable=100 outgoingInterface=$matchPara1 nextHop=192.1.1.1" $fileId
		}
		
		if {[dict exists $table $matchPara2]} {
			if {([dict get $table $matchPara2 localLable] == 200) && ([dict get $table $matchPara2 remoteLable] == 300) && ([string match [dict get $table $matchPara2 nextHop] "192.1.2.4"])} {
				gwd::GWpublic_print "OK" "ת������localLable=200 outgoingLable=300 outgoingInterface=$matchPara2 nextHop=192.1.2.4 ����" $fileId
			} else {
				set flag8_case4 1
				gwd::GWpublic_print "NOK" "δ�ҵ�ת������localLable=200 outgoingLable=300 outgoingInterface=$matchPara2 nextHop=192.1.2.4" $fileId
			}
		} else {
			set flag8_case4 1
			gwd::GWpublic_print "NOK" "δ�ҵ�ת������localLable=200 outgoingLable=300 outgoingInterface=$matchPara2 nextHop=192.1.2.4 " $fileId
		}
		if {[dict exists $table $matchPara3]} {
			if {([dict get $table $matchPara3 localLable] == 19) && ([dict get $table $matchPara3 remoteLable] == 16) && ([string match [dict get $table $matchPara3 nextHop] "192.1.3.1"])} {
				gwd::GWpublic_print "OK" "ת������localLable=19 outgoingLable=16 outgoingInterface=$matchPara3 nextHop=192.1.3.1 ����" $fileId
			} else {
				set flag8_case4 1
				gwd::GWpublic_print "NOK" "δ�ҵ�ת������localLable=19 outgoingLable=16 outgoingInterface=$matchPara3 nextHop=192.1.3.1" $fileId
			}
		} else {
			set flag8_case4 1
			gwd::GWpublic_print "NOK" "δ�ҵ�ת������localLable=19 outgoingLable=16 outgoingInterface=$matchPara3 nextHop=192.1.3.1" $fileId
		}
		if {[dict exists $table $matchPara4]} {
			if {([dict get $table $matchPara4 localLable] == 17) && ([dict get $table $matchPara4 remoteLable] == 18) && ([string match [dict get $table $matchPara4 nextHop] "192.1.4.4"])} {
				gwd::GWpublic_print "OK" "ת������localLable=17 outgoingLable=18 outgoingInterface=$matchPara4 nextHop=192.1.4.4����" $fileId
			} else {
				set flag8_case4 1
				gwd::GWpublic_print "NOK" "δ�ҵ�ת������localLable=17 outgoingLable=18 outgoingInterface=$matchPara4 nextHop=192.1.4.4" $fileId
			}
		} else {
			set flag8_case4 1
			gwd::GWpublic_print "NOK" "δ�ҵ�ת������localLable=17 outgoingLable=18 outgoingInterface=$matchPara4 nextHop=192.1.4.4" $fileId
		}
        }
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag8_case4	1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag8_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD6�����ۣ�NE2($gpnIp2)���������豸����������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD6�����ۣ�NE2($gpnIp2)���������豸����������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)���������豸����������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
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
	puts $fileId "Test Case 4 �´���E-LINEҵ��NNI�˿ڸ���ʱ���ܼ�ҵ��ָ����� ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 �´���E-LINEҵ��MS-PWҵ����Լ�ҵ��ָ�����\n"
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
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�´���E-LINEҵ��MS-PWҵ�����  ���Կ�ʼ=====\n"
	set flag1_case5 0
	set flag2_case5 0
	set flag3_case5 0
	set flag4_case5 0
	set flag5_case5 0
	set flag6_case5 0
	set flag7_case5 0
	set flag8_case5 0
	
	gwd::Cfg_StreamActive $hGPNPort2Stream11 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort2Stream12 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort4Stream13 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort4Stream14 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort3Stream9 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort4Stream9 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort3Stream10 "FALSE"
	gwd::Cfg_StreamActive $hGPNPort4Stream10 "FALSE"
        ###############################################ɾ��7600S����##############################################################################
        set ip1 192.1.1.1
        set ip4 192.1.2.4
        gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort7.200 $ip4 "200" "300" "0" 2 "normal"
        gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort6.100 $ip1 "400" "100" "0" 3 "normal"
        set ip1 192.1.3.1
        set ip4 192.1.4.4
        gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort7.400 $ip4 "17" "18" "0" 6 "normal"
        gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort6.300 $ip1 "19" "16" "0" 7 "normal"
        PTN_DelInterVid $fileId $Worklevel $interface15 $matchType2 $Gpn_type2 $telnet2
        PTN_DelInterVid $fileId $Worklevel $interface18 $matchType2 $Gpn_type2 $telnet2
        ###############################################ɾ��7600-1����#############################################################################
        #####ɾ��AC
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac10"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac10"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac3000"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac3000"
        ####����AC
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "" $GPNTestEth3 0 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "pw1" "eline16"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
        ###ɾ��PW
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw10"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw10"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"
        ###ɾ��LSP
        gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp10"
        PTN_DelInterVid $fileId $Worklevel $interface17 $matchType1 $Gpn_type1 $telnet1
        PTN_DelInterVid $fileId $Worklevel $interface21 $matchType1 $Gpn_type1 $telnet1
        PTN_DelInterVid $fileId $Worklevel $interface22 $matchType1 $Gpn_type1 $telnet1
        ###################################################ɾ��7600-3����######################################################################
        #####ɾ��AC
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac3000"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac3000"
        ####ɾ��PW
        gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw2"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw2"
        gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
        ###ɾ��LSP
        gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"
        PTN_DelInterVid $fileId $Worklevel $interface16 $matchType3 $Gpn_type3 $telnet3
        PTN_DelInterVid $fileId $Worklevel $interface23 $matchType3 $Gpn_type3 $telnet3
        PTN_DelInterVid $fileId $Worklevel $interface24 $matchType3 $Gpn_type3 $telnet3
        ###�����豸NE2
        set ip1 192.1.1.1
        set ip2 192.1.1.2
        set ip3 192.1.4.3
        set ip4 192.1.4.4
        set address1 10.1.3.1
        set address2 10.1.3.2
        set address3 10.1.3.3
        #############################################����PE2�豸��LSP PW#################################################################### 
        gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp1" $interface14 $ip1 "200" "100" "normal" "3"
        gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp1" $address1
        gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp1"
        gwd::GWpublic_showTunnelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp1"
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw1" "l2transport" "2" "" $address1 "2000" "1000" "3" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "pw1" result
        gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp10" $interface19 $ip4 "19" "18" "normal" "7"
        gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp10" $address2
        gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp10"
        gwd::GWpublic_showTunnelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "lsp10"
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw10" "l2transport" "5" "" $address2 "21" "20" "7" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "pw10" result
        gwd::GWPw_AddMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw1" "pw10"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream13 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream14 "TRUE"
	if {[string match "L2" $Worklevel]} {
        	gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3 "disable"
        	gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "enable"
	}
	incr capId
	if {[Test_Case5 "" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
		set flag1_case5 1
	}
	puts $fileId ""
	if {$flag1_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD7�����ۣ��´���E-LINEҵ��MS-PWҵ�����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD7�����ۣ��´���E-LINEҵ��MS-PWҵ�����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�´���E-LINEҵ��MS-PWҵ�����  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)$GPNTestEth1\����$GPNPort6����ں�$GPNPort7\�ĳ��ڲ���MPLS��ǩ��VLAN  ���Կ�ʼ=====\n"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort4Stream13 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort4Stream14 "FALSE"
	array set aMirror "dir1 ingress port1 $GPNPort6 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth1 aMirror
        
        if {$::cap_enable} {
            	gwd::Start_CapAllData ::capArr $::hGPNPort1Cap $::hGPNPort1CapAnalyzer 
        }
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort1AnaFrameCfgFil $::anaFliFrameCfg2
        gwd::Start_SendFlow "$hGPNPort3Gen"  "$hGPNPort1Ana"
        after $sendTime
	incr capId
        if {$::cap_enable} {
            	gwd::Stop_CapData $::hGPNPort1Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2\).pcap"
        }
        foreach i "aTmpGPNPort1Cnt2 aTmpGPNPort1Cnt3" {
          	array set $i {cnt1 0 cnt2 0} 
        }
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 2 $::hGPNPort1Ana aTmpGPNPort1Cnt2]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 0 0 0 0 0
		after 5000
	}
        parray aTmpGPNPort1Cnt2
        gwd::Stop_SendFlow "$hGPNPort3Gen"  "$hGPNPort1Ana"
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort1AnaFrameCfgFil $::anaFliFrameCfg3
        gwd::Start_SendFlow "$hGPNPort3Gen"  "$hGPNPort1Ana"
        after $sendTime
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 3 $::hGPNPort1Ana aTmpGPNPort1Cnt3]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 0 0 0 0 0
		after 5000
	}
        parray aTmpGPNPort1Cnt3
	gwd::Stop_SendFlow "$hGPNPort3Gen"  "$hGPNPort1Ana"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2\).pcap" $fileId
        if {$aTmpGPNPort1Cnt2(cnt1) < $rateL1 || $aTmpGPNPort1Cnt2(cnt1) > $rateR1 || $aTmpGPNPort1Cnt2(cnt2) < $rateL1 || $aTmpGPNPort1Cnt2(cnt2) > $rateR1} {
        	set flag2_case5 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1����NNI��NE2($gpnIp2)$GPNPort6\������ݣ��˿��յ������ݴ��ϵ�˫��mpls��ǩ����ȷ" $fileId
        } else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1����NNI��NE2($gpnIp2)$GPNPort6\������ݣ��˿��յ������ݴ��ϵ�˫��mpls��ǩ��ȷ" $fileId
        }
        if {$aTmpGPNPort1Cnt3(cnt1) < $rateL1 || $aTmpGPNPort1Cnt3(cnt1)> $rateR1 || $aTmpGPNPort1Cnt3(cnt2) < $rateL1 || $aTmpGPNPort1Cnt3(cnt2)> $rateR1} {
		set flag2_case5 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1����NNI��NE2($gpnIp2)$GPNPort6\������ݣ��˿��յ������ݴ���vlan��ǩ����ȷ" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1����NNI��NE2($gpnIp2)$GPNPort6\������ݣ��˿��յ������ݴ���vlan��ǩ��ȷ" $fileId
	}
        
	gwd::GWpublic_DelPortMirror $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth1
	array set aMirror "dir1 egress port1 $GPNPort7 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth1 aMirror
       
        if {$::cap_enable} {
            	gwd::Start_CapAllData ::capArr $::hGPNPort1Cap $::hGPNPort1CapAnalyzer 
            	gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
        }
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort1AnaFrameCfgFil $::anaFliFrameCfg2
        gwd::Start_SendFlow "$hGPNPort3Gen"  "$hGPNPort1Ana"
        after $sendTime
	incr capId
        if {$::cap_enable} {
		gwd::Stop_CapData $::hGPNPort1Cap 1 "GPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2\).pcap"
        }
        foreach i "aTmpGPNPort1Cnt21 aTmpGPNPort1Cnt31" {
          	array set $i {cnt5 0 cnt6 0}
        }
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 2 $::hGPNPort1Ana aTmpGPNPort1Cnt21]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 0 0 0 0 0
		after 5000
	}
        parray aTmpGPNPort1Cnt21
        gwd::Stop_SendFlow "$hGPNPort3Gen"  "$hGPNPort1Ana"
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort1AnaFrameCfgFil $::anaFliFrameCfg3
        gwd::Start_SendFlow "$hGPNPort3Gen"  "$hGPNPort1Ana"
        after $sendTime
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 3 $::hGPNPort1Ana aTmpGPNPort1Cnt31]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 0 0 0 0 0
		after 5000
	}
        parray aTmpGPNPort1Cnt31
	gwd::Stop_SendFlow "$hGPNPort3Gen"  "$hGPNPort1Ana"
	gwd::GWpublic_DelPortMirror $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth1
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2\).pcap" $fileId
        if {$aTmpGPNPort1Cnt21(cnt5) < $rateL1 || $aTmpGPNPort1Cnt21(cnt5) > $rateR1 || $aTmpGPNPort1Cnt21(cnt6) < $rateL1 || $aTmpGPNPort1Cnt21(cnt6) > $rateR1} {
		set flag2_case5 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1����NNI��NE2($gpnIp2)$GPNPort7\�������ݣ��˿��յ������ݴ��ϵ�˫��mpls��ǩ����ȷ" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1����NNI��NE2($gpnIp2)$GPNPort7\�������ݣ��˿��յ������ݴ��ϵ�˫��mpls��ǩ��ȷ" $fileId
	}
        if {$aTmpGPNPort1Cnt31(cnt5) < $rateL1 || $aTmpGPNPort1Cnt31(cnt5)> $rateR1 || $aTmpGPNPort1Cnt31(cnt6) < $rateL1 || $aTmpGPNPort1Cnt31(cnt6)> $rateR1} {
		set flag2_case5 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1����NNI��NE2($gpnIp2)$GPNPort7\�������ݣ��˿��յ������ݴ��ϵ�vlan��ǩ����ȷ" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1����NNI��NE2($gpnIp2)$GPNPort7\�������ݣ��˿��յ������ݴ��ϵ�vlan��ǩ��ȷ" $fileId
	}
	puts $fileId ""
	if {$flag2_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD8�����ۣ�NE2($gpnIp2)$GPNTestEth1\����$GPNPort6����ں�$GPNPort7\�ĳ��ڲ���MPLS��ǩ��VLAN" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD8�����ۣ�NE2($gpnIp2)$GPNTestEth1\����$GPNPort6����ں�$GPNPort7\�ĳ��ڲ���MPLS��ǩ��VLAN" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)$GPNTestEth1\����$GPNPort6����ں�$GPNPort7\�ĳ��ڲ���MPLS��ǩ��VLAN  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�´���E-LINEҵ��MS-PWҵ���lsp pw����ͳ�Ʋ���  ���Կ�ʼ=====\n"
        gwd::GWpublic_addLspStat $telnet2 $matchType2 $Gpn_type2 $fileId "lsp1" "enable"
        gwd::GWpublic_addPwStatEn $telnet2 $matchType2 $Gpn_type2 $fileId "pw1" "enable"
        gwd::GWpublic_addLspStat $telnet2 $matchType2 $Gpn_type2 $fileId "lsp10" "enable"
        gwd::GWpublic_addPwStatEn $telnet2 $matchType2 $Gpn_type2 $fileId "pw10" "enable"
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort1AnaFrameCfgFil $::anaFliFrameCfg1
	gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream4 "TRUE"
	stc::perform ResultsClearViewCommand -ResultList "[stc::get $hGPNPort1Ana -children-AnalyzerPortResults] \
		[stc::get $hGPNPort1Gen -children-GeneratorPortResults]\
		[stc::get $hGPNPort3Ana -children-AnalyzerPortResults] \
		[stc::get $hGPNPort3Gen -children-GeneratorPortResults]"	
	
	gwd::GWpublic_getMplsStat $telnet2 $matchType2 $Gpn_type2 $fileId "lsp tunnel" "lsp1" GPNLsp1Stat1
	gwd::GWpublic_getMplsStat $telnet2 $matchType2 $Gpn_type2 $fileId "pw" "pw1" GPNPw1Stat1
	gwd::GWpublic_getMplsStat $telnet2 $matchType2 $Gpn_type2 $fileId "lsp tunnel" "lsp10" GPNLsp10Stat1
	gwd::GWpublic_getMplsStat $telnet2 $matchType2 $Gpn_type2 $fileId "pw" "pw10" GPNPw10Stat1
	
	gwd::Start_SendFlow  $::hGPNPortGenList  $::hGPNPortAnaList
	after 60000
	gwd::Stop_SendFlow  $::hGPNPortGenList  $::hGPNPortAnaList
	after 20000
	gwd::Cfg_StreamActive $hGPNPort4Stream4 "false"
	set rx1Cnt [stc::get $hGPNPort3Ana.AnalyzerPortResults -SigFrameCount]
	set tx1Cnt [stc::get $hGPNPort3Gen.GeneratorPortResults -GeneratorSigFrameCount]
	set rx10Cnt [stc::get $hGPNPort4Ana.AnalyzerPortResults -SigFrameCount]
	set tx10Cnt [stc::get $hGPNPort4Gen.GeneratorPortResults -GeneratorSigFrameCount]
	
	gwd::GWpublic_getMplsStat $telnet2 $matchType2 $Gpn_type2 $fileId "lsp tunnel" "lsp1" GPNLsp1Stat2
	gwd::GWpublic_getMplsStat $telnet2 $matchType2 $Gpn_type2 $fileId "pw" "pw1" GPNPw1Stat2
	gwd::GWpublic_getMplsStat $telnet2 $matchType2 $Gpn_type2 $fileId "lsp tunnel" "lsp10" GPNLsp10Stat2
	gwd::GWpublic_getMplsStat $telnet2 $matchType2 $Gpn_type2 $fileId "pw" "pw10" GPNPw10Stat2
	
	set Lsp1FrameIn [expr $GPNLsp1Stat2(-inTotalPkts)-$GPNLsp1Stat1(-inTotalPkts)]
	set Pw1FrameIn [expr $GPNPw1Stat2(-inTotalPkts)-$GPNPw1Stat1(-inTotalPkts)]
	set Lsp1FrameOut [expr $GPNLsp1Stat2(-outTotalPkts)-$GPNLsp1Stat1(-outTotalPkts)]
	set Pw1FrameOut [expr $GPNPw1Stat2(-outTotalPkts)-$GPNPw1Stat1(-outTotalPkts)]
	
	set Lsp10FrameIn [expr $GPNLsp10Stat2(-inTotalPkts)-$GPNLsp10Stat1(-inTotalPkts)]
	set Pw10FrameIn [expr $GPNPw10Stat2(-inTotalPkts)-$GPNPw10Stat1(-inTotalPkts)]
	set Lsp10FrameOut [expr $GPNLsp10Stat2(-outTotalPkts)-$GPNLsp10Stat1(-outTotalPkts)]
	set Pw10FrameOut [expr $GPNPw10Stat2(-outTotalPkts)-$GPNPw10Stat1(-outTotalPkts)]
	
	
	gwd::GWpublic_print [expr {($Lsp1FrameIn == $rx1Cnt) ? "OK" : "NOK"}] "$matchType2\��lsp1��inTotalPktsͳ�Ʒ���������ǰΪ$GPNLsp1Stat1(-inTotalPkts)\
		������������Ϊ$GPNLsp1Stat2(-inTotalPkts)����ֵӦΪ$rx1Cnt\ʵΪ$Lsp1FrameIn" $fileId
	gwd::GWpublic_print [expr {($Pw1FrameIn == $rx1Cnt) ? "OK" : "NOK"}] "$matchType2\��pw1��inTotalPktsͳ�Ʒ���������ǰΪ$GPNPw1Stat1(-inTotalPkts)\
		������������Ϊ$GPNPw1Stat2(-inTotalPkts)����ֵӦΪ$rx1Cnt\ʵΪ$Pw1FrameIn" $fileId
	gwd::GWpublic_print [expr {($Lsp1FrameOut == $tx1Cnt) ? "OK" : "NOK"}] "$matchType2\��lsp1��outTotalPktsͳ�Ʒ���������ǰΪ$GPNLsp1Stat1(-outTotalPkts)\
		������������Ϊ$GPNLsp1Stat2(-outTotalPkts)����ֵӦΪ$tx1Cnt\ʵΪ$Lsp1FrameOut" $fileId
	gwd::GWpublic_print [expr {($Pw1FrameOut == $tx1Cnt) ? "OK" : "NOK"}] "$matchType2\��pw1��outTotalPktsͳ�Ʒ���������ǰΪ$GPNPw1Stat1(-outTotalPkts)\
		������������Ϊ$GPNPw1Stat2(-outTotalPkts)����ֵӦΪ$tx1Cnt\ʵΪ$Pw1FrameOut" $fileId
		
	gwd::GWpublic_print [expr {($Lsp10FrameIn == $rx10Cnt) ? "OK" : "NOK"}] "$matchType2\��lsp10��inTotalPktsͳ�Ʒ���������ǰΪ$GPNLsp10Stat1(-inTotalPkts)\
        	������������Ϊ$GPNLsp10Stat2(-inTotalPkts)����ֵӦΪ$rx10Cnt\ʵΪ$Lsp10FrameIn" $fileId
        gwd::GWpublic_print [expr {($Pw10FrameIn == $rx10Cnt) ? "OK" : "NOK"}] "$matchType2\��pw10��inTotalPktsͳ�Ʒ���������ǰΪ$GPNPw10Stat1(-inTotalPkts)\
        	������������Ϊ$GPNPw10Stat2(-inTotalPkts)����ֵӦΪ$rx10Cnt\ʵΪ$Pw10FrameIn" $fileId
        gwd::GWpublic_print [expr {($Lsp10FrameOut == $tx10Cnt) ? "OK" : "NOK"}] "$matchType2\��lsp10��outTotalPktsͳ�Ʒ���������ǰΪ$GPNLsp10Stat1(-outTotalPkts)\
        	������������Ϊ$GPNLsp10Stat2(-outTotalPkts)����ֵӦΪ$tx10Cnt\ʵΪ$Lsp10FrameOut" $fileId
        gwd::GWpublic_print [expr {($Pw10FrameOut == $tx10Cnt) ? "OK" : "NOK"}] "$matchType2\��pw10��outTotalPktsͳ�Ʒ���������ǰΪ$GPNPw10Stat1(-outTotalPkts)\
        	������������Ϊ$GPNPw10Stat2(-outTotalPkts)����ֵӦΪ$tx10Cnt\ʵΪ$Pw10FrameOut" $fileId
		
	if {$Lsp1FrameIn != $rx1Cnt || $Pw1FrameIn != $rx1Cnt || $Lsp1FrameOut != $tx1Cnt || $Pw1FrameOut != $tx1Cnt\
		|| $Lsp10FrameIn != $rx10Cnt || $Pw10FrameIn != $rx10Cnt || $Lsp10FrameOut != $tx10Cnt || $Pw10FrameOut != $tx10Cnt} {
		set flag3_case5 1
	}
	
	puts $fileId ""
	if {$flag3_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD9�����ۣ��´���E-LINEҵ��MS-PWҵ���lsp pw����ͳ�Ʋ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD9�����ۣ��´���E-LINEҵ��MS-PWҵ���lsp pw����ͳ�Ʋ���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�´���E-LINEҵ��MS-PWҵ���lsp pw����ͳ�Ʋ���  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����shutdown/undoshutdown NE2($gpnIp2)��NNI�ڣ�����ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Կ�ʼ=====\n"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream13 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream14 "TRUE"
        ###����undo shutdown/shutdown�˿�
        foreach eth $portlist2 {
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
                  	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $eth "shutdown"
                  	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $eth "undo shutdown"
                  	after $WaiteTime
			incr capId
			if {[Test_Case5 "��$j\��undo shutdown/shutdown NE2($gpnIp2)��$eth\�˿�" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag4_case5 1
			}
        	}
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag4_case5 1
			gwd::GWpublic_print "NOK" "����shutdown/undo shutdown NE2($gpnIp2)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "����shutdown/undo shutdown NE2($gpnIp2)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
		}
        }
	puts $fileId ""
	if {$flag4_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE1�����ۣ�����shutdown/undoshutdownNE2($gpnIp2)��NNI�ڣ�����ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE1�����ۣ�����shutdown/undoshutdownNE2($gpnIp2)��NNI�ڣ�����ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����shutdown/undoshutdownNE2($gpnIp2)��NNI�ڣ�����ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��������NE2($gpnIp2)NNI�����ڰ忨������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Կ�ʼ=====\n"
        ###���������˿����ڰ忨
        foreach slot $rebootSlotlist2 {
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource3
          	set testFlag 0
          	for {set j 1} {$j<=$cnt} {incr j} {
          		if {![gwd::GWCard_AddReboot $telnet2 $matchType2 $Gpn_type2 $fileId $slot]} {
          			after $rebootBoardTime
				after 60000
          			if {[string match $mslot2 $slot]} {
					set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
					set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
           			}
				incr capId
				if {[Test_Case5 "��$j\������NE2($gpnIp2)$slot\��λ�忨" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
					set flag5_case5 1
				}
         		} else {
				set testFlag 1 
				gwd::GWpublic_print "OK" "NE2($gpnIp2)$slot\��λ�忨��֧�ְ忨������������������" $fileId
				break
         		}
        	}
		if {$testFlag == 0} {
			gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource4
			send_log "\n resource3:$resource3"
			send_log "\n resource4:$resource4"
			if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
				set flag5_case5	1
				gwd::GWpublic_print "NOK" "��������NE2($gpnIp2)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "��������NE2($gpnIp2)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
			} 
		}
        }
	puts $fileId ""
	if {$flag5_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE2�����ۣ���������NE2($gpnIp2)NNI�����ڰ忨������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE2�����ۣ���������NE2($gpnIp2)NNI�����ڰ忨������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��������NE2($gpnIp2)NNI�����ڰ忨������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)��������NMS��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Կ�ʼ=====\n"
        ###��������NMS��������
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource5
	set testFlag 0
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitch $telnet2 $matchType2 $Gpn_type2 $fileId]} {
                  	after $rebootTime
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
			incr capId
			if {[Test_Case5 "��$j\��NE2($gpnIp2)����NMS��������" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag6_case5 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet2 $matchType2 $Gpn_type2 $fileId "2" result
			if {![string match [dict get $result 2 pwOutLabel] 2000] || ![string match [dict get $result 2 lspOutLabel] +100]} {
				set flag6_case5 1
				gwd::GWpublic_print "NOK" "VC=2 ��pwOutLabelΪ[dict get $result 2 pwOutLabel] \
						lspOutLabelΪ[dict get $result 2 lspOutLabel]��NE2($gpnIp2)��$j\�ν���NMS��������ת�������쳣" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=2 ��pwOutLabelΪ[dict get $result 2 pwOutLabel] \
						lspOutLabelΪ[dict get $result 2 lspOutLabel]��NE2($gpnIp2)��$j\�ν���NMS��������ת����������" $fileId
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet2 $matchType2 $Gpn_type2 $fileId "5" result
			if {![string match [dict get $result 5 pwOutLabel] 21] || ![string match [dict get $result 5 lspOutLabel] +18]} {
				set flag6_case5 1
				gwd::GWpublic_print "NOK" "VC=5 ��pwOutLabelΪ[dict get $result 5 pwOutLabel] \
						lspOutLabelΪ[dict get $result 5 lspOutLabel]��NE2($gpnIp2)��$j\�ν���NMS��������ת�������쳣" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=5 ��pwOutLabelΪ[dict get $result 5 pwOutLabel] \
						lspOutLabelΪ[dict get $result 5 lspOutLabel]��NE2($gpnIp2)��$j\�ν���NMS��������ת����������" $fileId
			}
			
        	} else {
			set testFlag 1 
			gwd::GWpublic_print "OK" "NE2($gpnIp2)��֧��NMS������������ֻ��һ��NMS�忨����������" $fileId
			break
        	}
        }
	if {$testFlag == 0} {
	        gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource6
	        send_log "\n resource5:$resource5"
	        send_log "\n resource6:$resource6"
	        if {$resource6 > [expr $resource5 + $resource5 * $errRate]} {
			set flag6_case5	1
			gwd::GWpublic_print "NOK" "NE2($gpnIp2)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE2($gpnIp2)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
	        }
	}
	puts $fileId ""
	if {$flag6_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE3�����ۣ�NE2($gpnIp2)��������NMS��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE3�����ۣ�NE2($gpnIp2)��������NMS��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)��������NMS��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)��������SW��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Կ�ʼ=====\n"
        ##��������SW��������
	set testFlag 0
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource7
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitchSw $telnet2 $matchType2 $Gpn_type2 $fileId]} {
          		after $rebootTime
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
			incr capId
			if {[Test_Case5 "��$j\��NE2($gpnIp2)����SW��������" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag7_case5 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet2 $matchType2 $Gpn_type2 $fileId "2" result
			if {![string match [dict get $result 2 pwOutLabel] 2000] || ![string match [dict get $result 2 lspOutLabel] +100]} {
				set flag7_case5 1
				gwd::GWpublic_print "NOK" "VC=2 ��pwOutLabelΪ[dict get $result 2 pwOutLabel] \
						lspOutLabelΪ[dict get $result 2 lspOutLabel]��NE2($gpnIp2)��$j\�ν���SW��������ת�������쳣" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=2 ��pwOutLabelΪ[dict get $result 2 pwOutLabel] \
						lspOutLabelΪ[dict get $result 2 lspOutLabel]��NE2($gpnIp2)��$j\�ν���SW��������ת����������" $fileId
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet2 $matchType2 $Gpn_type2 $fileId "5" result
			if {![string match [dict get $result 5 pwOutLabel] 21] || ![string match [dict get $result 5 lspOutLabel] +18]} {
				set flag7_case5 1
				gwd::GWpublic_print "NOK" "VC=5 ��pwOutLabelΪ[dict get $result 5 pwOutLabel] \
						lspOutLabelΪ[dict get $result 5 lspOutLabel]��NE2($gpnIp2)��$j\�ν���SW��������ת�������쳣" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=5 ��pwOutLabelΪ[dict get $result 5 pwOutLabel] \
						lspOutLabelΪ[dict get $result 5 lspOutLabel]��NE2($gpnIp2)��$j\�ν���SW��������ת����������" $fileId
			}
        	} else {
			set testFlag 1 
			gwd::GWpublic_print "OK" "NE2($gpnIp2)��֧��SW������������ֻ��һ��NMS�忨����������" $fileId
			break
        	}
        }
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource8
		send_log "\n resource7:$resource7"
		send_log "\n resource8:$resource8"
		if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
			set flag7_case5	1
			gwd::GWpublic_print "NOK" "NE2($gpnIp2)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($gpnIp2)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag7_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE4�����ۣ�NE2($gpnIp2)��������SW��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE4�����ۣ�NE2($gpnIp2)��������SW��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)��������SW��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)���������豸����������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Կ�ʼ=====\n"
        ##���������豸����
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource9
        for {set j 1} {$j<=$cnt} {incr j} {
          	gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
          	gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
          	after $rebootTime
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		incr capId
		if {[Test_Case5 "��$j\��NE2($gpnIp2)�����豸����" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
			set flag8_case5 1
		}
		gwd::GWpublic_QueryMPLSForwardTable $telnet2 $matchType2 $Gpn_type2 $fileId "2" result
		if {![string match [dict get $result 2 pwOutLabel] 2000] || ![string match [dict get $result 2 lspOutLabel] +100]} {
			set flag8_case5 1
			gwd::GWpublic_print "NOK" "VC=2 ��pwOutLabelΪ[dict get $result 2 pwOutLabel] \
					lspOutLabelΪ[dict get $result 2 lspOutLabel]��NE2($gpnIp2)��$j\�α����豸����ת�������쳣" $fileId
		} else {
			gwd::GWpublic_print "OK" "VC=2 ��pwOutLabelΪ[dict get $result 2 pwOutLabel] \
					lspOutLabelΪ[dict get $result 2 lspOutLabel]��NE2($gpnIp2)��$j\�α����豸����ת����������" $fileId
		}
		gwd::GWpublic_QueryMPLSForwardTable $telnet2 $matchType2 $Gpn_type2 $fileId "5" result
		if {![string match [dict get $result 5 pwOutLabel] 21] || ![string match [dict get $result 5 lspOutLabel] +18]} {
			set flag8_case5 1
			gwd::GWpublic_print "NOK" "VC=5 ��pwOutLabelΪ[dict get $result 5 pwOutLabel] \
					lspOutLabelΪ[dict get $result 5 lspOutLabel]��NE2($gpnIp2)��$j\�α����豸����ת�������쳣" $fileId
		} else {
			gwd::GWpublic_print "OK" "VC=5 ��pwOutLabelΪ[dict get $result 5 pwOutLabel] \
					lspOutLabelΪ[dict get $result 5 lspOutLabel]��NE2($gpnIp2)��$j\�α����豸����ת����������" $fileId
		}
        }
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag8_case5	1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag8_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE5�����ۣ�NE2($gpnIp2)���������豸����������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE5�����ۣ�NE2($gpnIp2)���������豸����������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)���������豸����������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
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
	puts $fileId "Test Case 5 �´���E-LINEҵ��MS-PWҵ����Լ�ҵ��ָ����Բ��Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===�ָ���ʼ������...\n"
        lappend flagDel [gwd::GWPw_DelMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw1" "pw10"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet2 $matchType2 $Gpn_type2 $fileId "pw10"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw10"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet2 $matchType2 $Gpn_type2 $fileId "pw1"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw1"]
        lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp10"]
        lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp1"]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface14 $matchType2 $Gpn_type2 $telnet2]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface19 $matchType2 $Gpn_type2 $telnet2]
	
        lappend flagDel [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"]
        lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"]
        lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface1 $matchType1 $Gpn_type1 $telnet1]

        lappend flagDel [gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac10"]
        lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac10"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw10"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw10"]
        lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp10"]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface20 $matchType3 $Gpn_type3 $telnet3]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface32 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface35 $matchType3 $Gpn_type3 $telnet3]
        
	if {[string match "L2" $Worklevel]} {
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort7 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2 "enable"]
		lappend flagDel [gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3 "enable"]
		lappend flagDel [gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "enable"]
	}
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
        } 
        
	if {[string match "L2" $Worklevel]} {
		lappend flagDel [gwd::GWL2Inter_DelVlan $telnet1 $matchType1 $Gpn_type1 $fileId 4091]
		lappend flagDel [gwd::GWL2Inter_DelVlan $telnet2 $matchType2 $Gpn_type2 $fileId 4091]
		lappend flagDel [gwd::GWL2Inter_DelVlan $telnet3 $matchType3 $Gpn_type3 $fileId 4091]  
	} else {
		lappend flagDel [gwd::GWL3Inter_DelL3 $telnet1 $matchType1 $Gpn_type1 $fileId "ethernet" $GPNPort5 4091]
		lappend flagDel [gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "ethernet" $GPNPort6 4091]
		lappend flagDel [gwd::GWL3Inter_DelL3 $telnet2 $matchType2 $Gpn_type2 $fileId "ethernet" $GPNPort7 4091]
		lappend flagDel [gwd::GWL3Inter_DelL3 $telnet3 $matchType3 $Gpn_type3 $fileId "ethernet" $GPNPort8 4091]
	}
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_002_1"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_002_1"
	chan seek $fileId 0
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "T3_GPN_PTN_ELINE_002_1����Ŀ�ģ�E-LINE������֤ LSP PW��������\n "
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1 == 1 || $flagCase2 == 1 || $flagCase3 == 1 || $flagCase4 == 1 || $flagCase5 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_002_1���Խ��" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5���Խ��" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪtaggedģʽ(NE1:PORT----NE3:PORT+VLAN)����ҵ��" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪtaggedʱ����overlay����" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪtagged����ͳ�ƹ���" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪtaggedʱ�豸��ӵ�mpls��ǩ" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪtaggedʱ����shutdown/undoshutdown�˿ں�ҵ��ָ���ϵͳ�ڴ����" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪtaggedʱ��������ҵ��˿����ڰ忨��ҵ��ָ���ϵͳ�ڴ����" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag7_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪtaggedʱ����NMS����������ҵ��ָ���mplsת�����ϵͳ�ڴ����" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag8_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪtaggedʱ����SW����������ҵ��ָ���mplsת�����ϵͳ�ڴ����" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag9_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪtaggedʱ�������б����豸������ҵ��ָ���mplsת�����ϵͳ�ڴ����" $fileId
	gwd::GWpublic_print "== FB1 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪtaggedģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)����ҵ��" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪtaggedģʽ(NE1:PORT----NE3:PORT)����ҵ��" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪtaggedģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)����ҵ��" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪtaggedģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)����ҵ��" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪrawģʽ(NE1:PORT----NE3:PORT)����ҵ��" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN)����ҵ��" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag7_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT+VLAN NE2����PW12����)����ҵ��" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag8_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪrawģʽ(NE1:PORT+VLAN----NE3:PORT)����ҵ��" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag9_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪrawģʽ(NE1:PORT+VLAN1----NE3:PORT+VLAN2)����ҵ��" $fileId
	gwd::GWpublic_print "== FC1 == [expr {($flag10_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)����ҵ��" $fileId
	gwd::GWpublic_print "== FC2 == [expr {($flag11_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����֮ǰ��PW1��vctypeΪrawģʽ(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)���½�һ��������vctype��PW2����ҵ��" $fileId
	gwd::GWpublic_print "== FC3 == [expr {($flag12_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����PW���ã�����shutdown/undo shutdown NE3($gpnIp3)UNI��NNI�ں����ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC4 == [expr {($flag13_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����PW���ã��������� NE3($gpnIp3)UNI��NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC5 == [expr {($flag14_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����PW���ã� NE3($gpnIp3)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC6 == [expr {($flag15_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����PW���ã� NE3($gpnIp3)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC7 == [expr {($flag16_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����PW���ã� NE3($gpnIp3)���������豸��������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC8 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�����ELineҵ��NNI�ڸ��ò���ҵ��" $fileId
	gwd::GWpublic_print "== FC9 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ��´���E-LINEҵ��Ķ˿�����ͳ�ƹ�����ȷ" $fileId
	gwd::GWpublic_print "== FD1 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ������´���E-LINEҵ��NNI����ӵ�mpls��ǩ��vlan" $fileId
	gwd::GWpublic_print "== FD2 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�����shutdown/undoshutdownNE2($gpnIp2)��NNI�ڣ�����ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FD3 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ���������NE1($gpnIp1)NNI/UNI�����ڰ忨������ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FD4 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)��������NMS��������������ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FD5 == [expr {($flag7_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)��������SW��������������ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FD6 == [expr {($flag8_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE2($gpnIp2)���������豸����������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FD7 == [expr {($flag1_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ��´���E-LINEҵ��MS-PWҵ�����" $fileId
	gwd::GWpublic_print "== FD8 == [expr {($flag2_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE2($gpnIp2)$GPNTestEth1\����$GPNPort6����ں�$GPNPort7\�ĳ��ڲ���MPLS��ǩ��VLAN" $fileId
	gwd::GWpublic_print "== FD9 == [expr {($flag3_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ��´���E-LINEҵ��MS-PWҵ����Զ˿�����ͳ��" $fileId
	gwd::GWpublic_print "== FE1 == [expr {($flag4_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�����shutdown/undoshutdownNE2($gpnIp2)��NNI�ڣ�����ҵ��ָ��Ͷ�ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FE2 == [expr {($flag5_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ���������NE2($gpnIp2)NNI�����ڰ忨������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��" $fileId
	gwd::GWpublic_print "== FE3 == [expr {($flag6_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE2($gpnIp2)��������NMS��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��" $fileId
	gwd::GWpublic_print "== FE4 == [expr {($flag7_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE2($gpnIp2)��������SW��������������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��" $fileId
	gwd::GWpublic_print "== FE5 == [expr {($flag8_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE2($gpnIp2)���������豸����������ҵ��ָ��Ͷ�ϵͳ�ڴ��Ӱ��" $fileId
	gwd::GWpublic_print "== FE6 == [expr {($flag10_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ���龭��LSP����ǰ��LSP��PW��TTLֵ�Ĳ���" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_002_1"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_002_1_REPORT.txt" "report\\NOK_GPN_PTN_002_1_REPORT.txt"
	file rename "log\\GPN_PTN_002_1_LOG.txt" "log\\NOK_GPN_PTN_002_1_LOG.txt"
} else {
	file rename "report\\GPN_PTN_002_1_REPORT.txt" "report\\OK_GPN_PTN_002_1_REPORT.txt"
	file rename "log\\GPN_PTN_002_1_LOG.txt" "log\\OK_GPN_PTN_002_1_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}
