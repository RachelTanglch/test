#!/bin/sh
# T2_GPN_PTN_ELINE_005.tcl \
exec tclsh "$0" ${1+"$@"}
#�������ƣ�ptn005
#-----------------------------------------------------------------------------------------------------------------------------------
#����Ŀ�ģ�E-LINEҵ��׳�Բ���
#1-�󶨾�̬ARP��������             
#2-1��LSP���ض��PW����              
#3-1��LSP������һ��PW����        
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
###�󶨾�̬ARP��������
###1��LSP������һ��PW����
#   <1>1̨76�豸������E-LINEҵ��NNI�˿���tag��ʽ���뵽��ͬ��ҵ��VLAN��
#   <2>ÿ��ҵ����󶨾�̬ARP�Ұ�MAC����ͬ,��һ��LSP�Ͻ�����һ��PW��һ��LSP������һ��VLANIF�ϣ�
#   <3>����ڵ�����ΪPE���û���˿ڽ���ģʽ��Ϊ���˿�+��Ӫ��VLAN��
#   <4>ҵ�񴴽��ɹ���ϵͳ���쳣�����û���˿ڷ���ƥ��ҵ����������NNI�˿�ץȡMPLS���ģ��鿴������SMAC��DMAC��LSP��ǩ��PW��ǩ����ȷ
#   <5>��¼��ϵͳ�ɰ󶨶��ٸ���̬ARP�Ұ�MAC
#   <6>���������ļ����ɳɹ�������ϵͳ���쳣���鿴�����������ļ���ȷ��������
#   <7>shutdown��undo shutdown�豸��NNI/UNI�˿�50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸���
#   <8>��λ�豸��NNI/UNI���ڰ忨50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸���
#   <9>�������ã��豸����������ҵ�������ת��
#   <10>��NE1��NE2�豸�Ͼ��ٴ���500��ҵ���OAM��500��ҵ���QOS��ϵͳ���쳣����500��ҵ���OAM��500��ҵ���QOS���ܾ���Ч
#   <11>����NE1��NE2�豸���ã�����NE1��NE2�豸���豸����������ҵ������ת��
#   <12>�ڸ������£��豸����24Сʱ��ҵ������ת����ҵ�񲻶�����ϵͳCPU����������ϵͳ����������ϵͳ���쳣
#   <13>������ã������豸,�豸�������������������κ�������Ϣ
#2���Test Case 2���Ի���
###1��LSP���ض��PW����  
#   <1>��̨76��NE1--NE2����NE1�˿�1��NE2�˿�2�䴴������ELINEҵ�񣨾�������һ��LSP�ϣ�
#   <2>NE1��NE2����ڵ�����ΪPE
#   <3>ÿ��ҵ�񶼰󶨾�̬ARP ӳ�䣬������ϣ�����ҵ�������鿴ÿ��ҵ�������ת����ϵͳ���쳣
#   <4>��¼��ϵͳ1��LSP�Ͽɳ��ض��ٸ�PW(ϵͳĿǰһ��LSP�ɳ���4092��PW)
#   <5>��̨�豸�������ã����������ļ����ɳɹ�������ϵͳ���쳣���鿴�����������ļ���ȷ��������
#   <6>ʹ��ÿ��ҵ��LSP/PW/AC����ͳ�ƣ�ϵͳ���쳣������ͳ�ƹ�����Ч��ͳ��ֵ��ȷ
#   <7>shutdown��undo shutdownNE1�豸��NNI/UNI�˿�50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸���
#   <8>��λ�豸��NNI/UNI���ڰ忨50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸���
#   <9>����NE1�豸��SW/NMS����50�Σ���������ҵ��������ָ���ÿ��ҵ��˴��޸��ţ��鿴��ǩת��������ȷ
#   <10>����NE1��NE2�豸���ã�����NE1��NE2�豸����λ��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ������ұ˴��޸��ţ���ǩת��������ȷ
#   <11>���NE1��NE2�豸���ã�����NE1��NE2�豸�����豸������鿴������Ϣ��
#   <12>�����Ե����������ļ����룬�����豸�����豸������鿴������Ϣ�޶�ʧ����ȷ��������֤ҵ�������ת��
#   <13>���NE1��NE2�豸���ã�����NE1��NE2�豸
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
        close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_005_LOG.txt" a]
        set stdout $fd_log
        chan configure $stdout -blocking 0 -buffering none;#������ģʽ ����flush
        log_file log\\GPN_PTN_005_LOG.txt
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_005_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
        
        file mkdir "debug"
        set fd_debug [open debug\\GPN_PTN_005_DEBUG.txt a]
        exp_internal -f debug\\GPN_PTN_005_DEBUG.txt 0
        chan configure $fd_debug -blocking 0 -buffering none;#������ģʽ ����flush
	
	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl
	
        array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1" -vid "1000" -pri "000" -stepValue "1" -recycleCount "6" -EnableStream "TRUE"}
        array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "500" -pri "000" -stepValue "1" -recycleCount "6" -EnableStream "TRUE"}
        array set dataArr3 {-srcMac "00:00:00:00:00:03" -dstMac "00:00:00:00:00:33" -srcIp "192.85.1.3" -dstIp "192.0.0.3" -vid "600" -pri "000" -stepValue "1" -recycleCount "6" -EnableStream "TRUE"}
        array set dataArr4 {-srcMac "00:00:00:00:00:11" -dstMac "00:00:00:00:00:01" -srcIp "192.0.0.1" -dstIp "192.85.1.1" -vid "1000" -pri "000" -stepValue "1" -recycleCount "6" -EnableStream "TRUE"}
	array set dataArr5 {-srcMac "00:00:00:00:00:11" -dstMac "00:00:00:00:00:33" -srcIp "192.85.1.10" -dstIp "192.0.0.10" -vid "10" -pri "000"}
	array set dataArr6 {-srcMac "00:00:00:00:00:33" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.11" -dstIp "192.0.0.11" -vid "10" -pri "000"}
        #���ö�����Ϣ����
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        
        #���÷���������
        set GenCfg {-SchedulingMode RATE_BASED}
        
        #���ù��˷���������
        #####smac��vld
        set anaFliFrameCfg1 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><vlans name="anon_13224"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        set anaFliFrameCfg0 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        #####ƥ��mpls�����е�dmac��vid
        set anaFliFrameCfg5 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</dstMac><vlans name="anon_4679"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
        #####ƥ��mpls������lsp��pw�����ǩ
        set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}

	
	set flagResult 0
	set flagCase1 0   ;#Test case 1��־λ 
	set flagCase2 0   ;#Test case 2��־λ
	
	set lFailFile ""
	set FLAGF 0
	
	set tcId 0
	set capId 0
	set cfgId 0

	regsub {/} $GPNTestEth2 {_} GPNTestEth2_cap
	regsub {/} $GPNTestEth3 {_} GPNTestEth3_cap
	regsub {/} $GPNTestEth4 {_} GPNTestEth4_cap
	#Ϊ���Խ���Ԥ������
	for {set i 0} {$i < 80} {incr i} {
	    puts $fileId "                                                                                                                                                                                                                "	
	}

        proc Delvlan {spawn_id matchType dutType fileId vid} {
        	set errorTmp 0
        	send -i $spawn_id "\r"
        	expect {
        		-i $spawn_id
        		-re "$matchType\\(config\\)#" {
        			send -i $spawn_id "\r"
        		}
        		-timeout 5
        		timeout {
        			gwd::GWpublic_toConfig $spawn_id $matchType
        		}
        	}
        	expect {
        		-i $spawn_id
        		-re "$matchType\\(config\\)#" {
        			send -i $spawn_id "undo vlan $vid\r"
        		}
        	}
        	expect {
        		-i $spawn_id
        		-re {Unknown command} {
        			set errorTmp 1
        			gwd::GWpublic_print NOK "��$matchType\��ɾ��vlan��ʧ�ܡ������������" $fileId
        			send -i $spawn_id "\r"
        		}
        		-re {does not exist} {
        			set errorTmp 1
        			gwd::GWpublic_print NOK "��$matchType\��ɾ��vlan��ʧ�ܡ�ɾ����vid������" $fileId
        			send -i $spawn_id "\r"
        		}
        		-re {Connot del} {
        			set errorTmp 1
        			gwd::GWpublic_print NOK "��$matchType\��ɾ��vlan��ʧ�ܡ�vlan�г�����ҵ�񣬲���ɾ��" $fileId
        		}
        		-re "$matchType\\(config\\)#" {
        			send -i $spawn_id "\r"
        			gwd::GWpublic_print OK "��$matchType\��ɾ��vlan$vid���ɹ�" $fileId
        		}
        		-timeout 60
        	}
        	return $errorTmp
        }
        #�������ܣ�Case1�У�ARP�������֤ҵ��
        #���������fileId:����������ļ���ʶ��	 
        #	  rateL rateR:�յ����ݰ���ȡֵ��Χ
        #	  capFileName:ץ���ļ�������
        #����ֵ��flag:"0"��ʾ����ҵ�������� "1"�в�������ҵ��
        proc GPN005Case1_checkFlow {fileId rateL rateR capFileName} {
        	global GPNTestEth2
        	global GPNPort5
        	global newGPNMac
        	set flag 0
        	sendAndStat51 aGPNPort2Cnt2 aGPNPort2Cnt1 "$capFileName-p$::GPNTestEth2_cap\($::gpnIp1\).pcap"
        	parray aGPNPort2Cnt2
        	parray aGPNPort2Cnt1
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$capFileName-p$::GPNTestEth2_cap\($::gpnIp1\).pcap" $fileId
        	if {$aGPNPort2Cnt2(cnt1) < $rateL || $aGPNPort2Cnt2(cnt1) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1000����������$GPNTestEth2\�յ�mpls0=1000 mpls1=1600�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1000����������$GPNTestEth2\�յ�mpls0=1000 mpls1=1600�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt1)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort2Cnt2(cnt2) < $rateL || $aGPNPort2Cnt2(cnt2) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1001����������$GPNTestEth2\�յ�mpls0=1001 mpls1=1601�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1001����������$GPNTestEth2\�յ�mpls0=1001 mpls1=1601�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt2)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort2Cnt2(cnt3) < $rateL || $aGPNPort2Cnt2(cnt3) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1002����������$GPNTestEth2\�յ�mpls0=1002 mpls1=1602�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt3)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1002����������$GPNTestEth2\�յ�mpls0=1002 mpls1=1602�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt3)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort2Cnt2(cnt4) < $rateL || $aGPNPort2Cnt2(cnt4) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1003����������$GPNTestEth2\�յ�mpls0=1003 mpls1=1603�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt4)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1003����������$GPNTestEth2\�յ�mpls0=1003 mpls1=1603�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt4)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort2Cnt2(cnt5) < $rateL || $aGPNPort2Cnt2(cnt5) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1004����������$GPNTestEth2\�յ�mpls0=1004 mpls1=1604�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1004����������$GPNTestEth2\�յ�mpls0=1004 mpls1=1604�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt5)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort2Cnt2(cnt6) < $rateL || $aGPNPort2Cnt2(cnt6) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1005����������$GPNTestEth2\�յ�mpls0=1005 mpls1=1605�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt6)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1005����������$GPNTestEth2\�յ�mpls0=1005 mpls1=1605�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt6)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt2) < $rateL || $aGPNPort2Cnt1(cnt2) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1000����������$GPNTestEth2\�յ�vid=402 dmac=$newGPNMac\�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1000����������$GPNTestEth2\�յ�vid=402 dmac=$newGPNMac\�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt1)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt3) < $rateL || $aGPNPort2Cnt1(cnt3) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1001����������$GPNTestEth2\�յ�vid=403 dmac=$newGPNMac\�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1001����������$GPNTestEth2\�յ�vid=403 dmac=$newGPNMac\�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt2)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt4) < $rateL || $aGPNPort2Cnt1(cnt4) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1002����������$GPNTestEth2\�յ�vid=404 dmac=$newGPNMac\�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt3)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1002����������$GPNTestEth2\�յ�vid=404 dmac=$newGPNMac\�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt3)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt5) < $rateL || $aGPNPort2Cnt1(cnt5) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1003����������$GPNTestEth2\�յ�vid=405 dmac=$newGPNMac\�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt4)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1003����������$GPNTestEth2\�յ�vid=405 dmac=$newGPNMac\�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt4)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt6) < $rateL || $aGPNPort2Cnt1(cnt6) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1004�����������յ�vid=406 dmac=$newGPNMac\�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt5)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1004�����������յ�vid=406 dmac=$newGPNMac\�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt5)����$rateL-$rateR\��Χ��" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt7) < $rateL || $aGPNPort2Cnt1(cnt7) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1005�����������յ�vid=407 dmac=$newGPNMac\�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt6)��û��$rateL-$rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\����$GPNPort5\(nni��)���ڣ�UNI�෢��tag1005�����������յ�vid=407 dmac=$newGPNMac\�����ݰ��ĸ���Ϊ$aGPNPort2Cnt2(cnt6)����$rateL-$rateR\��Χ��" $fileId
        	}
        	return $flag
        }	
	
        #�������ܣ�Case1�У�ARP�������֤ҵ��
        #���������fileId:����������ļ���ʶ��	 
        #	  rateL rateR:�յ����ݰ���ȡֵ��Χ
        #	  caseId:ץ���ļ������Ƶĺ�׺
        #����ֵ��flag:"0"��ʾ����ҵ�������� "1"�в�������ҵ��
        proc GPN005Case2_checkFlow {fileId rateL1 rateR1 caseId} {
        	set flag 0
        	global GPNTestEth3
        	global GPNTestEth4
		global startVid
		foreach i "aGPNPort4Cnt1 aGPNPort3Cnt1" {
		  array set $i {cnt1 0 cnt8 0 cnt9 0 cnt10 0 cnt11 0 cnt12 0 cnt13 0 cnt14 0 cnt15 0 cnt16 0 cnt17 0 cnt18 0} 
		}
		gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg1
		gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg1
		if {$::cap_enable} {
		    gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer 
		    gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
		}
		gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
		after 10000
		if {$::cap_enable} {
		    gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$::GPNTestEth4_cap\($::gpnIp3\).pcap"
		    gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$::GPNTestEth3_cap\($::gpnIp1\).pcap"
		}
		set lstRxResults [stc::get $::hGPNPort3RxInfo1 -ResultHandleList]
		foreach resultRx $lstRxResults {  
			array set aResults [stc::get $resultRx]
			gwd::Clear_ResultViewStat $resultRx
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  $aResults(-FilteredValue_1) == $startVid && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
				set aGPNPort3Cnt1(cnt13)  $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  $aResults(-FilteredValue_1) == [expr $startVid + 1] && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
				set aGPNPort3Cnt1(cnt14)  $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  $aResults(-FilteredValue_1) == [expr $startVid + 2] && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
				set aGPNPort3Cnt1(cnt15)  $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  $aResults(-FilteredValue_1) == [expr $startVid + 3] && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
				set aGPNPort3Cnt1(cnt16)  $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  $aResults(-FilteredValue_1) == [expr $startVid + 4] && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
				set aGPNPort3Cnt1(cnt17)  $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  $aResults(-FilteredValue_1) == [expr $startVid + 5] && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
				set aGPNPort3Cnt1(cnt18)  $aResults(-L1BitRate)
			} 
		}
		set lstRxResults [stc::get $::hGPNPort4RxInfo1 -ResultHandleList]
		foreach resultRx $lstRxResults {  
			array set aResults [stc::get $resultRx]
			gwd::Clear_ResultViewStat $resultRx
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  $aResults(-FilteredValue_1) == $startVid && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
				set aGPNPort4Cnt1(cnt1)  $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  $aResults(-FilteredValue_1) == [expr $startVid + 1] && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
				set aGPNPort4Cnt1(cnt8)  $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  $aResults(-FilteredValue_1) == [expr $startVid + 2] && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
				set aGPNPort4Cnt1(cnt9)  $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  $aResults(-FilteredValue_1) == [expr $startVid + 3] && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
				set aGPNPort4Cnt1(cnt10)  $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  $aResults(-FilteredValue_1) == [expr $startVid + 4] && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
				set aGPNPort4Cnt1(cnt11)  $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  $aResults(-FilteredValue_1) == [expr $startVid + 5] && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
				set aGPNPort4Cnt1(cnt12)  $aResults(-L1BitRate)
			}
		}
        	
        	parray aGPNPort3Cnt1
        	parray aGPNPort4Cnt1
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($::gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($::gpnIp3\).pcap" $fileId
        	if {$aGPNPort4Cnt1(cnt1) < $rateL1 || $aGPNPort4Cnt1(cnt1) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth3\����tag=$startVid\����������NE3($::gpnIp3)$GPNTestEth4\�յ�tag=$startVid\�����ݰ��ĸ���Ϊ$aGPNPort4Cnt1(cnt1)��û��$rateL1-$rateR1\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth3\����tag=$startVid\����������NE3($::gpnIp3)$GPNTestEth4\�յ�tag=$startVid\�����ݰ��ĸ���Ϊ$aGPNPort4Cnt1(cnt1)����$rateL1-$rateR1\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt8) < $rateL1 || $aGPNPort4Cnt1(cnt8) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth3\����tag=[expr $startVid + 1]����������NE3($::gpnIp3)$GPNTestEth4\�յ�tag=[expr $startVid + 1]�����ݰ��ĸ���Ϊ$aGPNPort4Cnt1(cnt1)��û��$rateL1-$rateR1\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth3\����tag=[expr $startVid + 1]����������NE3($::gpnIp3)$GPNTestEth4\�յ�tag=[expr $startVid + 1]�����ݰ��ĸ���Ϊ$aGPNPort4Cnt1(cnt1)����$rateL1-$rateR1\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt9) < $rateL1 || $aGPNPort4Cnt1(cnt9) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth3\����tag=[expr $startVid + 2]����������NE3($::gpnIp3)$GPNTestEth4\�յ�tag=[expr $startVid + 2]�����ݰ��ĸ���Ϊ$aGPNPort4Cnt1(cnt1)��û��$rateL1-$rateR1\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth3\����tag=[expr $startVid + 2]����������NE3($::gpnIp3)$GPNTestEth4\�յ�tag=[expr $startVid + 2]�����ݰ��ĸ���Ϊ$aGPNPort4Cnt1(cnt1)����$rateL1-$rateR1\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt10) < $rateL1 || $aGPNPort4Cnt1(cnt10) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth3\����tag=[expr $startVid + 3]����������NE3($::gpnIp3)$GPNTestEth4\�յ�tag=[expr $startVid + 3]�����ݰ��ĸ���Ϊ$aGPNPort4Cnt1(cnt1)��û��$rateL1-$rateR1\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth3\����tag=[expr $startVid + 3]����������NE3($::gpnIp3)$GPNTestEth4\�յ�tag=[expr $startVid + 3]�����ݰ��ĸ���Ϊ$aGPNPort4Cnt1(cnt1)����$rateL1-$rateR1\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt11) < $rateL1 || $aGPNPort4Cnt1(cnt11) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth3\����tag=[expr $startVid + 4]����������NE3($::gpnIp3)$GPNTestEth4\�յ�tag=[expr $startVid + 4]�����ݰ��ĸ���Ϊ$aGPNPort4Cnt1(cnt1)��û��$rateL1-$rateR1\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth3\����tag=[expr $startVid + 4]����������NE3($::gpnIp3)$GPNTestEth4\�յ�tag=[expr $startVid + 4]�����ݰ��ĸ���Ϊ$aGPNPort4Cnt1(cnt1)����$rateL1-$rateR1\��Χ��" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt12) < $rateL1 || $aGPNPort4Cnt1(cnt12) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth3\����tag=[expr $startVid + 5]����������NE3($::gpnIp3)$GPNTestEth4\�յ�tag=[expr $startVid + 5]�����ݰ��ĸ���Ϊ$aGPNPort4Cnt1(cnt1)��û��$rateL1-$rateR1\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth3\����tag=[expr $startVid + 5]����������NE3($::gpnIp3)$GPNTestEth4\�յ�tag=[expr $startVid + 5]�����ݰ��ĸ���Ϊ$aGPNPort4Cnt1(cnt1)����$rateL1-$rateR1\��Χ��" $fileId
        	}
        	if {$aGPNPort3Cnt1(cnt13) < $rateL1 || $aGPNPort3Cnt1(cnt13) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$GPNTestEth4\����tag=$startVid\����������NE1($::gpnIp1)$GPNTestEth3\�յ�tag=$startVid\�����ݰ��ĸ���Ϊ$aGPNPort3Cnt1(cnt13)��û��$rateL1-$rateR1\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$GPNTestEth4\����tag=$startVid\����������NE1($::gpnIp1)$GPNTestEth3\�յ�tag=$startVid\�����ݰ��ĸ���Ϊ$aGPNPort3Cnt1(cnt13)����$rateL1-$rateR1\��Χ��" $fileId
        	}
        	if {$aGPNPort3Cnt1(cnt14) < $rateL1 || $aGPNPort3Cnt1(cnt14) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$GPNTestEth4\����tag=[expr $startVid + 1]����������NE1($::gpnIp1)$GPNTestEth3\�յ�tag=[expr $startVid + 1]�����ݰ��ĸ���Ϊ$aGPNPort3Cnt1(cnt14)��û��$rateL1-$rateR1\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$GPNTestEth4\����tag=[expr $startVid + 1]����������NE1($::gpnIp1)$GPNTestEth3\�յ�tag=[expr $startVid + 1]�����ݰ��ĸ���Ϊ$aGPNPort3Cnt1(cnt14)����$rateL1-$rateR1\��Χ��" $fileId
        	}
        	if {$aGPNPort3Cnt1(cnt15) < $rateL1 || $aGPNPort3Cnt1(cnt15) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$GPNTestEth4\����tag=[expr $startVid + 2]����������NE1($::gpnIp1)$GPNTestEth3\�յ�tag=[expr $startVid + 2]�����ݰ��ĸ���Ϊ$aGPNPort3Cnt1(cnt15)��û��$rateL1-$rateR1\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$GPNTestEth4\����tag=[expr $startVid + 2]����������NE1($::gpnIp1)$GPNTestEth3\�յ�tag=[expr $startVid + 2]�����ݰ��ĸ���Ϊ$aGPNPort3Cnt1(cnt15)����$rateL1-$rateR1\��Χ��" $fileId
        	}
        	if {$aGPNPort3Cnt1(cnt16) < $rateL1 || $aGPNPort3Cnt1(cnt16) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$GPNTestEth4\����tag=[expr $startVid + 3]����������NE1($::gpnIp1)$GPNTestEth3\�յ�tag=[expr $startVid + 3]�����ݰ��ĸ���Ϊ$aGPNPort3Cnt1(cnt16)��û��$rateL1-$rateR1\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$GPNTestEth4\����tag=[expr $startVid + 3]����������NE1($::gpnIp1)$GPNTestEth3\�յ�tag=[expr $startVid + 3]�����ݰ��ĸ���Ϊ$aGPNPort3Cnt1(cnt16)����$rateL1-$rateR1\��Χ��" $fileId
        	}
        	if {$aGPNPort3Cnt1(cnt17) < $rateL1 || $aGPNPort3Cnt1(cnt17) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$GPNTestEth4\����tag=[expr $startVid + 4]����������NE1($::gpnIp1)$GPNTestEth3\�յ�tag=[expr $startVid + 4]�����ݰ��ĸ���Ϊ$aGPNPort3Cnt1(cnt17)��û��$rateL1-$rateR1\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$GPNTestEth4\����tag=[expr $startVid + 4]����������NE1($::gpnIp1)$GPNTestEth3\�յ�tag=[expr $startVid + 4]�����ݰ��ĸ���Ϊ$aGPNPort3Cnt1(cnt17)����$rateL1-$rateR1\��Χ��" $fileId
        	}
        	if {$aGPNPort3Cnt1(cnt18) < $rateL1 || $aGPNPort3Cnt1(cnt18) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$GPNTestEth4\����tag=[expr $startVid + 5]����������NE1($::gpnIp1)$GPNTestEth3\�յ�tag=[expr $startVid + 5]�����ݰ��ĸ���Ϊ$aGPNPort3Cnt1(cnt18)��û��$rateL1-$rateR1\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$GPNTestEth4\����tag=[expr $startVid + 5]����������NE1($::gpnIp1)$GPNTestEth3\�յ�tag=[expr $startVid + 5]�����ݰ��ĸ���Ϊ$aGPNPort3Cnt1(cnt18)����$rateL1-$rateR1\��Χ��" $fileId
        	}
        	return $flag
        }
		
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
        gwd::STC_Create_VlanModiferStream $fileId dataArr1 $hGPNPort3 hGPNPort3Stream1
        gwd::STC_Create_VlanModiferStream $fileId dataArr2 $hGPNPort3 hGPNPort3Stream2
        gwd::STC_Create_VlanModiferStream $fileId dataArr3 $hGPNPort4 hGPNPort4Stream3
        gwd::STC_Create_VlanModiferStream $fileId dataArr4 $hGPNPort4 hGPNPort4Stream4
	gwd::STC_Create_VlanStream $fileId dataArr5 $hGPNPort3 hGPNPort3Stream5
	gwd::STC_Create_VlanStream $fileId dataArr6 $hGPNPort4 hGPNPort4Stream6
        stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort3Stream1 $hGPNPort3Stream2 $hGPNPort4Stream3 $hGPNPort4Stream4 $hGPNPort3Stream5 $hGPNPort4Stream6" \
		-activate "false"
        	
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
        stc::config [stc::get $hGPNPort3Stream1 -AffiliationStreamBlockLoadProfile-targets] -load 300 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream2 -AffiliationStreamBlockLoadProfile-targets] -load 300 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream3 -AffiliationStreamBlockLoadProfile-targets] -load 300 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream4 -AffiliationStreamBlockLoadProfile-targets] -load 300 -LoadUnit MEGABITS_PER_SECOND
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
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===ELINE�������Ի������ÿ�ʼ...\n"
	set cfgFlag 0
        ###������ӿ����ò���
        if {[string match "L2" $Worklevel]} {
        	set interface1 v4001
        	set interface14 v4001
        } else {
        	set interface1 $GPNPort5.4001
        	set interface14 $GPNPort6.4001
        }
        set rateL "58000000"
        set rateR "62000000"
        set rateL1 "48000000"
        set rateR1 "52000000"
        ###NE1������	
        set portList11 "$GPNTestEth2 $GPNTestEth3 $GPNPort5"
        foreach port $portList11 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
		}
        }
        set rebootSlotList1 [gwd::GWpulic_getWorkCardList $portList11]
        send_log "\n��ȡ�豸1ҵ��忨��λ��$rebootSlotList1\n"
        set mslot1 [gwd::GWpulic_getWorkCardList $managePort1]
        send_log "\n��ȡ�豸1��������ڰ忨��λ��$mslot1\n"
        lappend cfgFlag [gwd::GWpublic_GetSysMac $telnet1 $matchType1 $Gpn_type1 $fileId GPNMac1]	
        ###NE3������
        set portList33 "$GPNPort6 $GPNTestEth4"
        foreach port $portList33 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "disable" "enable"]
		}
        }
        set rebootSlotList3 [gwd::GWpulic_getWorkCardList $portList33]
        send_log "\n��ȡ�豸3ҵ��忨��λ��$rebootSlotList3\n"
        lappend cfgFlag [gwd::GWpublic_GetSysMac $telnet3 $matchType3 $Gpn_type3 $fileId GPNMac3]
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "ELINE�������Ի�������ʧ�ܣ����Խ���" \
        	"ELINE�������Ի������óɹ�����������Ĳ���" "GPN_PTN_005"
        puts $fileId ""
        puts $fileId "===ELINE�������Ի������ý���..."
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 �󶨾�̬ARP��������\n"
        ###�󶨾�̬ARP��������
        ##1��LSP������һ��PW����   
        #   <1>1̨76�豸������E-LINEҵ��NNI�˿���tag��ʽ���뵽��ͬ��ҵ��VLAN��
        #   <2>ÿ��ҵ����󶨾�̬ARP�Ұ�MAC����ͬ,��һ��LSP�Ͻ�����һ��PW��һ��LSP������һ��VLANIF�ϣ�
        #   <3>����ڵ�����ΪPE���û���˿ڽ���ģʽ��Ϊ���˿�+��Ӫ��VLAN��
        #   <4>ҵ�񴴽��ɹ���ϵͳ���쳣�����û���˿ڷ���ƥ��ҵ����������NNI�˿�ץȡMPLS���ģ��鿴������SMAC��DMAC��LSP��ǩ��PW��ǩ����ȷ
        #   <5>��¼��ϵͳ�ɰ󶨶��ٸ���̬ARP�Ұ�MAC
        #   <6>���������ļ����ɳɹ�������ϵͳ���쳣���鿴�����������ļ���ȷ��������
        #   <7>shutdown��undo shutdown�豸��NNI/UNI�˿�50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸���
        #   <8>��λ�豸��NNI/UNI���ڰ忨50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸���
        #   <9>�������ã��豸����������ҵ�������ת��
        #   <10>��NE1��NE2�豸�Ͼ��ٴ���500��ҵ���OAM��500��ҵ���QOS��ϵͳ���쳣����500��ҵ���OAM��500��ҵ���QOS���ܾ���Ч
        #   <11>����NE1��NE2�豸���ã�����NE1��NE2�豸���豸����������ҵ������ת��
        #   <12>�ڸ������£��豸����24Сʱ��ҵ������ת����ҵ�񲻶�����ϵͳCPU����������ϵͳ����������ϵͳ���쳣
        #   <13>������ã������豸,�豸�������������������κ�������Ϣ
        set flag1_case1 0
        set flag2_case1 0
        set flag3_case1 0
        set flag4_case1 0
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����NE1($gpnIp1)��NE3($gpnIp3)�豸�ľ�̬ARP������������֤   ���Կ�ʼ=====\n"
        regexp -nocase {([0-9|a-f]{2})([0-9|a-f]{2})\.([0-9|a-f]{2})([0-9|a-f]{2})\.([0-9|a-f]{2})([0-9|a-f]{2})} $GPNMac3 match a b c d e f
        set newGPNMac $a:$b:$c:$d:$e:$f
        puts "newGPNMac:$newGPNMac"
        ####NE1�豸Arp��������
	if {[string match "L2" $Worklevel]} {
        	gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "enable"
	}
        set vid 2
        set cnt1 1
        set cnt2 1
        set cnt3 600
        set in 20
        set out 600
        set local 1200
        set remote 1800 
        set ip 1
        set ipcnt 1
        set ipTmp 0
	set retTmp11 0
	set retTmp12 0
	set retTmp13 0
	set retTmp14 0
         for {set arpnum 1} {$arpnum<=512} {incr arpnum} {
        	if {$ip==254 || $ipcnt==254} {
        		set ip 1
        		set ipcnt 1
        		incr ipTmp
        	}
        	if {[string match "L2" $Worklevel]}  {
        		set interface01 v$vid
        	} else {
        		set interface01 $GPNPort5.$vid
        	}
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet1 $matchType1 $Gpn_type1 $fd_log $vid]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\����v$vid��ʧ��" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet1 $matchType1 $Gpn_type1 $fd_log $vid "port" $GPNPort5 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\��v$vid\����Ӷ˿�$GPNPort5��ʧ��" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_CfgVlanIp $telnet1 $matchType1 $Gpn_type1 $fd_log $vid "192.$ipTmp.$ip.$ipcnt" 24]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\��v$vid\�����ip192.$ipTmp.$ip.$ipcnt��ʧ��" $fileId
					break
				}
			}
			
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernet" $GPNPort5 $vid]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\���ýӿ�$GPNPort5.$vid��ʧ��" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWL3port_AddIP $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernet" $GPNPort5 $vid "192.$ipTmp.$ip.$ipcnt" 24]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\���ýӿ�$GPNPort5.$vid\�����ip192.$ipTmp.$ip.$ipcnt��ʧ��" $fileId
					break
				}
			}
		}
		set createCnt 3 
		while {[PTN_AddInterArp $fd_log $Worklevel $interface01 "192.$ipTmp.$ip.[expr $ipcnt+1]" $GPNMac3 $GPNPort5 $matchType1 $Gpn_type1 $telnet1]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp11 1
				gwd::GWpublic_print "NOK" "$matchType1\��$interface01\�а�ip:192.$ipTmp.$ip.[expr $ipcnt+1]\�Ұ�mac:$GPNMac3" $fileId
				break
			}
		}
					
		set createCnt 3 
		while {[gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp$cnt1" $interface01 "192.$ipTmp.$ip.[expr $ipcnt+1]" $in $out "normal" $cnt1]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp12 1
				gwd::GWpublic_print "NOK" "$matchType1\�������lsp$cnt1��ʧ��" $fileId
				break
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp$cnt1" "10.1.1.3"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				gwd::GWpublic_print "NOK" "$matchType1\�������lsp$cnt1\��ַΪ10.1.1.3��ʧ��" $fileId
				break
			}
		}
		
		set createCnt 3 
		while {[gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp$cnt1"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				gwd::GWpublic_print "NOK" "$matchType1\�������lsp$cnt1��ʧ��" $fileId
				break
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fd_log "pw$cnt2" "l2transport" $cnt2 "" "10.1.1.3" $local $remote $cnt1 "nochange" "" 1 0 "0x8100" "0x8100" ""]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp13 1
				gwd::GWpublic_print "NOK" "$matchType1\����α��pw$cnt2��ʧ��" $fileId
				break
			}
		}
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet1 $matchType1 $Gpn_type1 $fd_log $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\����v$cnt3��ʧ��" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet1 $matchType1 $Gpn_type1 $fd_log $cnt3 "port" $GPNTestEth3 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\��v$cnt3\��Ӷ˿�$GPNTestEth3��ʧ��" $fileId
					break
				}
			}
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernet" $GPNTestEth3 $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\���ýӿ�$GPNTestEth3.$cnt3��ʧ��" $fileId
					break
				}
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fd_log "ac$cnt3" "" $GPNTestEth3 $cnt3 0 "nochange" 1 0 0 "0x8100"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp14 1
				gwd::GWpublic_print "NOK" "$matchType1\����ac$cnt3��ʧ��" $fileId
				break
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fd_log "ac$cnt3" "pw$cnt2" "eline$cnt2"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				gwd::GWpublic_print "NOK" "$matchType1\����ac$cnt3\��pw$cnt2��ʧ��" $fileId
				break
			}
		}
        	if {$retTmp11 == 0 && $retTmp12 == 0 && $retTmp13 == 0 && $retTmp14 == 0} {
                	incr vid
                	incr cnt1
                	incr cnt2
                	incr cnt3
                	incr in 
                	incr out
                	incr local 
                	incr remote  
                	incr ipcnt 
                	incr ip
        	} else {
        		break
        	}	
        }
        set ARPnum1 [expr 253*$ipTmp+$ip-1]
        
        ##NE3�豸Arp��������
	if {[string match "L2" $Worklevel]} {
        	gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort6 "enable"
	}
        set vid 2
        set cnt1 1
        set cnt2 1
        set cnt3 600
        set in 20
        set out 600
        set local 1200
        set remote 1800
        set ip 1
        set ipcnt 1
        set ipTmp 0
	set retTmp31 0
	set retTmp32 0
	set retTmp33 0
	set retTmp34 0
        for {set arpnum 1} {$arpnum<=512} {incr arpnum} {
                if {$ip==254 || $ipcnt==254} {
                        set ip 1
                        set ipcnt 1
                        incr ipTmp
                }
                if {[string match "L2" $Worklevel]}  {
                	set interface03 v$vid
                } else {
                	set interface03 $GPNPort6.$vid
                }
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet3 $matchType3 $Gpn_type3 $fd_log $vid]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\����v$vid��ʧ��" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet3 $matchType3 $Gpn_type3 $fd_log $vid "port" $GPNPort6 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\��v$vid\����Ӷ˿�$GPNPort6��ʧ��" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_CfgVlanIp $telnet3 $matchType3 $Gpn_type3 $fd_log $vid "192.$ipTmp.$ip.[expr $ipcnt+1]" 24]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\��v$vid\�����ip192.$ipTmp.$ip.[expr $ipcnt+1]��ʧ��" $fileId
					break
				}
			}
			
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet3 $matchType3 $Gpn_type3 $fd_log "ethernet" $GPNPort6 $vid]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\���ýӿ�$GPNPort6.$vid��ʧ��" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWL3port_AddIP $telnet3 $matchType3 $Gpn_type3 $fd_log "ethernet" $GPNPort6 $vid "192.$ipTmp.$ip.[expr $ipcnt+1]" 24]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\���ýӿ�$GPNPort6.$vid\�����ip192.$ipTmp.$ip.[expr $ipcnt+1]��ʧ��" $fileId
					break
				}
			}
			
		}
		
		set createCnt 3 
		while {[PTN_AddInterArp $fd_log $Worklevel $interface03 "192.$ipTmp.$ip.$ipcnt" $GPNMac1 $GPNPort6 $matchType3 $Gpn_type3 $telnet3]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp31 1
				gwd::GWpublic_print "NOK" "$matchType3\��$interface03\�а�ip:192.$ipTmp.$ip.$ipcnt\�Ұ�mac:$GPNMac1" $fileId
				break
			}
		}
					
		set createCnt 3 
		while {[gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fd_log "lsp$cnt1" $interface03 "192.$ipTmp.$ip.$ipcnt" $out $in "normal" $cnt1]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp32 1
				gwd::GWpublic_print "NOK" "$matchType3\�������lsp$cnt1��ʧ��" $fileId
				break
			}
		}
		
		set createCnt 3 
		while {[gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fd_log "lsp$cnt1" "10.1.1.1"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				gwd::GWpublic_print "NOK" "$matchType3\�������lsp$cnt1\��ַΪ10.1.1.1��ʧ��" $fileId
				break
			}
		}
		
		set createCnt 3 
		while {[gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fd_log "lsp$cnt1"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				gwd::GWpublic_print "NOK" "$matchType3\�������lsp$cnt1��ʧ��" $fileId
				break
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fd_log "pw$cnt2" "l2transport" $cnt2 "" "10.1.1.1" $remote $local $cnt1 "nochange" "" 1 0 "0x8100" "0x8100" ""]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp33 1
				gwd::GWpublic_print "NOK" "$matchType3\����α��pw$cnt2��ʧ��" $fileId
				break
			}
		}
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet3 $matchType3 $Gpn_type3 $fd_log $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\����v$cnt3��ʧ��" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet3 $matchType3 $Gpn_type3 $fd_log $cnt3 "port" $GPNTestEth4 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\��v$cnt3\��Ӷ˿�$GPNTestEth4��ʧ��" $fileId
					break
				}
			}
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet3 $matchType3 $Gpn_type3 $fd_log "ethernet" $GPNTestEth4 $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\���ýӿ�$GPNTestEth4.$cnt3��ʧ��" $fileId
					break
				}
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fd_log "ac$cnt3" "" $GPNTestEth4 $cnt3 0 "nochange" 1 0 0 "0x8100"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp34 1
				gwd::GWpublic_print "NOK" "$matchType3\����ac$cnt3��ʧ��" $fileId
				break
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fd_log "ac$cnt3" "pw$cnt2" "eline$cnt2"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				gwd::GWpublic_print "NOK" "$matchType3\����ac$cnt3\��pw$cnt2��ʧ��" $fileId
				break
			}
		}
                if {$retTmp31 == 0 && $retTmp32 == 0 && $retTmp33 == 0 && $retTmp34 == 0} {
                        incr vid
                        incr cnt1
                        incr cnt2
                        incr cnt3
                        incr in 
                        incr out
                        incr local 
                        incr remote  
                        incr ipcnt 
                        incr ip
                } else {
                	break
                }	
        }
        set ARPnum3 [expr 253*$ipTmp+$ip-1]
        array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
        gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2 aMirror
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream4 "TRUE"
	incr capId
        set flag1_case1 [GPN005Case1_checkFlow $fileId $rateL $rateR "GPN_PTN_005_$capId"]
        puts $fileId ""
        puts $fileId "NE1($gpnIp1)�󶨾�̬arp����Ϊ��$ARPnum1"
        puts $fileId "NE3($gpnIp3)�󶨾�̬arp����Ϊ��$ARPnum3"
        if {$flag1_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA1�����ۣ�����NE1($gpnIp1)��NE3($gpnIp3)�豸�ľ�̬ARP������������֤" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA1�����ۣ�����NE1($gpnIp1)��NE3($gpnIp3)�豸�ľ�̬ARP������������֤" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����NE1($gpnIp1)��NE3($gpnIp3)�豸�ľ�̬ARP������������֤  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����shut/undoshut UNI��NNI�˿ں���ҵ���Ƿ��ָܻ�   ���Կ�ʼ=====\n"
        ###����undo shutdown/shutdown�˿�
        foreach eth $portList11 {
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
        		gwd::GWPort_AddAdminState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
        		if {[catch {
        			close -i $telnet1
        		} err]} {
        			puts "close err"
        		}
        		after 600000
        		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
        		gwd::GWPort_AddAdminState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
        		if {[catch {
        			close -i $telnet1
        		} err]} {
        			puts "close err"
        		}
        		after 600000
        		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
        	}
		incr capId
        	if {[GPN005Case1_checkFlow $fileId $rateL $rateR "GPN_PTN_005_$capId"]} {
        		set flag2_case1 1
        	}
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
        	send_log "\n resource1:$resource1"
        	send_log "\n resource2:$resource2"
        	if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
        		set flag2_case1	1
        		gwd::GWpublic_print "NOK" "����shutdown/undo shutdown�豸�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "����shutdown/undo shutdown�豸�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
        	}
        }
	#�˿�shutdown undoshut ����ʻ�����telnet���жϣ��������µ�¼�����������µ�¼ǰɱ��ǰһ��telnet��
	if {[catch {
		close -i $telnet3
	} err]} {
		puts "close $telnet3 err"
	}
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet3]
        puts $fileId ""
        if {$flag2_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA2�����ۣ�����shut/undoshut UNI��NNI�˿ں���ҵ��ָ��Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA2�����ۣ�����shut/undoshut UNI��NNI�˿ں���ҵ��ָ��Ĳ���" $fileId
        }
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����shut/undoshut UNI��NNI�˿ں���ҵ���Ƿ��ָܻ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��������ҵ��˿����ڰ忨����ҵ���Ƿ��ָܻ�   ���Կ�ʼ=====\n"
        foreach slot $rebootSlotList1 {
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource3
          	for {set j 1} {$j<=$cnt} {incr j} {
          		if {![gwd::GWCard_AddReboot $telnet1 $matchType1 $Gpn_type1 $fileId $slot]} {
         			after $rebootBoardTime
        			if {[catch {
        				close -i $telnet1
        			} err]} {
        			  puts "close err"
        			}
        			after 900000
        			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
				set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
				incr capId
        	  		if {[GPN005Case1_checkFlow $fileId $rateL $rateR "GPN_PTN_005_$capId"]} {
        				set flag3_case1 1
        			}
        		} else {
        			puts $fileId "$Gpn_type1\������忨��֧����������"
        		}
        	}
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
        	send_log "\n resource3:$resource3"
        	send_log "\n resource4:$resource4"
        	if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
                	set flag3_case1	1
                	gwd::GWpublic_print "NOK" "�����忨$slot\֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "�����忨$slot\֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
        	}
        }
	#�˿�shutdown undoshut ����ʻ�����telnet���жϣ��������µ�¼�����������µ�¼ǰɱ��ǰһ��telnet��
	if {[catch {
		close -i $telnet3
	} err]} {
		puts "close $telnet3 err"
	}
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet3]
        puts $fileId ""
        if {$flag3_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA3�����ۣ���������ҵ��˿����ڰ忨����ҵ��ָ��Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA3�����ۣ���������ҵ��˿����ڰ忨����ҵ��ָ��Ĳ���" $fileId
        }	
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��������ҵ��˿����ڰ忨����ҵ���Ƿ��ָܻ�  ���Խ���=====\n"
        gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���������豸NE1($gpnIp1)����ҵ���Ƿ��ָܻ�  ���Կ�ʼ=====\n"
        gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
        gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
        
        after [expr 2*$rebootTime]
        after 600000
        set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
        set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
        gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2 aMirror
	incr capId
        if {[GPN005Case1_checkFlow $fileId $rateL $rateR "GPN_PTN_005_$capId"]} {
        	set flag4_case1 1
        }
	#�˿�shutdown undoshut ����ʻ�����telnet���жϣ��������µ�¼�����������µ�¼ǰɱ��ǰһ��telnet��
	if {[catch {
		close -i $telnet3
	} err]} {
		puts "close $telnet3 err"
	}
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet3]
        puts $fileId ""
        if {$flag4_case1 == 1} {
                set flagCase1 1
                gwd::GWpublic_print "NOK" "FA4�����ۣ����������豸NE1($gpnIp1)����ҵ��ָ��Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA4�����ۣ����������豸NE1($gpnIp1)����ҵ��ָ��Ĳ���" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���������豸NE1($gpnIp1)����ҵ���Ƿ��ָܻ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
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
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 1��LSP���ض��PW�Ĳ���\n"
        ###1��LSP���ض��PW����  
        #   <1>��̨76��NE1--NE2����NE1�˿�1��NE2�˿�2�䴴������ELINEҵ�񣨾�������һ��LSP�ϣ�
        #   <2>NE1��NE2����ڵ�����ΪPE
        #   <3>ÿ��ҵ�񶼰󶨾�̬ARP ӳ�䣬������ϣ�����ҵ�������鿴ÿ��ҵ�������ת����ϵͳ���쳣
        #   <4>��¼��ϵͳ1��LSP�Ͽɳ��ض��ٸ�PW(ϵͳĿǰһ��LSP�ɳ���4092��PW)
        #   <5>��̨�豸�������ã����������ļ����ɳɹ�������ϵͳ���쳣���鿴�����������ļ���ȷ��������
        #   <6>ʹ��ÿ��ҵ��LSP/PW/AC����ͳ�ƣ�ϵͳ���쳣������ͳ�ƹ�����Ч��ͳ��ֵ��ȷ
        #   <7>shutdown��undo shutdownNE1�豸��NNI/UNI�˿�50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸���
        #   <8>��λ�豸��NNI/UNI���ڰ忨50�Σ�ҵ����ָ����� ��ÿ��ҵ��˴��޸���
        #   <9>����NE1�豸��SW/NMS����50�Σ���������ҵ��������ָ���ÿ��ҵ��˴��޸��ţ��鿴��ǩת��������ȷ
        #   <10>����NE1��NE2�豸���ã�����NE1��NE2�豸����λ��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ������ұ˴��޸��ţ���ǩת��������ȷ
        #   <11>���NE1��NE2�豸���ã�����NE1��NE2�豸�����豸������鿴������Ϣ��
        #   <12>�����Ե����������ļ����룬�����豸�����豸������鿴������Ϣ�޶�ʧ����ȷ��������֤ҵ�������ת��
        #   <13>���NE1��NE2�豸���ã�����NE1��NE2�豸
	puts $fileId "======================================================================================\n"	
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����һ��lsp��PW������  ���Կ�ʼ=====\n"
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0
	set flag5_case2 0
	set flag6_case2 0
	set flag7_case2 0
	set flag8_case2 0
	after 900000    ;#�ȴ�10���ӣ�case1������еı��沢�ϴ������豸�ڲ���Ҫ��ʱ�䳤����ʱ��������豸�ļ������ز���Ӱ�죨������ɺ󱣴汸�ݲ���ɣ�
	set createCnt 3
	while {[gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fileId 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
			"NE1.txt" ""]} {
		incr createCnt -1
		if {$createCnt == 0} {
			gwd::GWpublic_print "NOK" "$matchType1\����3������NE1.txt�ļ���ʧ�ܻ������г������豸���Զ�����" $fileId
			break
		}	
	}
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after 600000
	if {[catch {
		close -i $telnet3
	} err]} {
		puts "close $telnet3 err"
	}
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	set createCnt 3
	while {[gwd::GWmanage_ftpDownload $telnet3 $matchType3 $Gpn_type3 $fileId $fileId 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
			"NE3.txt" ""]} {
		incr createCnt -1
		if {$createCnt == 0} {
			gwd::GWpublic_print "NOK" "$matchType3\����3������NE3.txt�ļ���ʧ�ܻ������г������豸���Զ�����" $fileId
			break
		}	
	}
	gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet3]

        PTN_NNI_AddInterIp $fileId $Worklevel $interface1 "192.1.1.1" $GPNPort5 $matchType1 $Gpn_type1 $telnet1
        gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $interface1 "192.1.1.2" "2500" "3000" "normal" 1
        gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "10.1.1.1"
        gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"
        gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"
        set cnt2 1
        set cnt3 10
        set local 20
        set remote 500
	set retTmp1 0
	set retTmp2 0
	set retTmp3 0
        for {set ac 1} {$ac<=$AcNum} {incr ac} {
		set createCnt 3 
		while {[gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fd_log "pw$cnt2" "l2transport" $cnt2 "" "10.1.1.1" $local $remote 1 "nochange" "" 1 0 "0x8100" "0x8100" ""]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp1 1
				gwd::GWpublic_print "NOK" "$matchType1\����α��pw$cnt2��ʧ��" $fileId
				break
			}
		}
		
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet1 $matchType1 $Gpn_type1 $fd_log $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\����v$cnt3��ʧ��" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet1 $matchType1 $Gpn_type1 $fd_log $cnt3 "port" $GPNTestEth3 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\��v$cnt3\����Ӷ˿�$GPNTestEth3��ʧ��" $fileId
					break
				}
			}
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernet" $GPNTestEth3 $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\���ýӿ�$GPNTestEth3.$cnt3��ʧ��" $fileId
					break
				}
			}
		}
		
		set createCnt 3 
		while {[gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fd_log "ac$cnt3" "" $GPNTestEth3 $cnt3 0 "nochange" 1 0 0 "0x8100"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp2 1
				gwd::GWpublic_print "NOK" "$matchType1\����ac$cnt3��ʧ��" $fileId
				break
			}
		} 
				
		set createCnt 3 
		while {[gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fd_log "ac$cnt3" "pw$cnt2" "eline$cnt3"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp3 1
				gwd::GWpublic_print "NOK" "$matchType1\����ac$cnt3\��pw$cnt2��ʧ��" $fileId
				break
			}
		}
		
        	if {$retTmp1 == 0 && $retTmp2 == 0 && $retTmp3 == 0} {
                        incr cnt2
                        incr cnt3
                        incr local 
                        incr remote
        	} elseif {$retTmp1 == 1 || $retTmp2 == 1 || $retTmp3 == 1} {
        		break  
        	}
        }
        set PWnum1 [expr $cnt2-1]
        
        ###�����豸NE3
	if {[string match "L2" $Worklevel]} {
        	gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort6 "enable"
	}
        PTN_NNI_AddInterIp $fileId $Worklevel $interface14 "192.1.1.2" $GPNPort6 $matchType3 $Gpn_type3 $telnet3
        gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2" $interface14 "192.1.1.1" "3000" "2500" "normal" 2
        gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2" "10.1.1.2"
        gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2"
        gwd::GWpublic_showTunnelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2"
        set cnt4 1
        set cnt5 10
        set local 20
        set remote 500
	set retTmp4 0
	set retTmp5 0
	set retTmp6 0
        for {set ac 1} {$ac<=$AcNum} {incr ac} {
		set createCnt 3 
		while {[gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fd_log "pw$cnt4" "l2transport" $cnt4 "" "10.1.1.2" $remote $local 2 "nochange" "" 1 0 "0x8100" "0x8100" ""]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp4 1
				gwd::GWpublic_print "NOK" "$matchType3\����α��pw$cnt4��ʧ��" $fileId
				break
			}
		}
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet3 $matchType3 $Gpn_type3 $fd_log $cnt5]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\����v$cnt5��ʧ��" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet3 $matchType3 $Gpn_type3 $fd_log $cnt5 "port" $GPNTestEth4 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\��v$cnt5\��Ӷ˿�$GPNTestEth4��ʧ��" $fileId
					break
				}
			}
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet3 $matchType3 $Gpn_type3 $fd_log "ethernet" $GPNTestEth4 $cnt5]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\���ýӿ�$GPNTestEth4.$cnt5��ʧ��" $fileId
					break
				}
			}
		}
				
		set createCnt 3 
		while {[gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fd_log "ac$cnt5" "" $GPNTestEth4 $cnt5 0 "nochange" 1 0 0 "0x8100"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp5 1
				gwd::GWpublic_print "NOK" "$matchType3\����ac$cnt5��ʧ��" $fileId
				break
			}
		} 
		
		set createCnt 3 
		while {[gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fd_log "ac$cnt5" "pw$cnt4" "eline$cnt5"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp6 1
				gwd::GWpublic_print "NOK" "$matchType3\����ac$cnt5\��pw$cnt4��ʧ��" $fileId
				break
			}
		}
		
        	if {$retTmp4 == 0 && $retTmp5 == 0 && $retTmp6 == 0} {
                        incr cnt4
                        incr cnt5
                        incr local 
                        incr remote  
                } elseif {$retTmp4 == 1 || $retTmp5 == 1 || $retTmp6 == 1} {
                	break  
                }
        }
        set PWnum3 [expr $cnt4-1]
	#�ϴ�Dev1��dev3�����ã�Ϊ�������ûָ�������׼��------
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_SaveCfg $telnet3 $matchType3 $Gpn_type3 $fileId
	set downFlag1 0
	set downFlag3 0
	set downCnt 3
	while {[gwd::GW_AddUploadFile $telnet1 $matchType1 $Gpn_type1 $fileId [dict get $ftp ip] [dict get $ftp userName] \
			[dict get $ftp passWord] "config" "GPN_PTN_005_case2_dev1.txt" "" "60"]} {
		incr downCnt -1
		if {$downCnt == 0} {
			set downFlag1 1
		}
	}
	set downCnt 3
	while {[gwd::GW_AddUploadFile $telnet3 $matchType3 $Gpn_type3 $fileId [dict get $ftp ip] [dict get $ftp userName] \
			[dict get $ftp passWord] "config" "GPN_PTN_005_case2_dev3.txt" "" "60"]} {
		incr downCnt -1
		if {$downCnt == 0} {
			set downFlag3 1
		}
	}
	#------�ϴ�Dev1��dev3�����ã�Ϊ�������ûָ�������׼��
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "enable"
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "enable"
        gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac10" "enable"
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg1
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort4Stream4 "FALSE"
      	set hGPNPortGenList "$hGPNPort3Gen $hGPNPort4Gen"
	set hGPNPortAnaList "$hGPNPort3Ana $hGPNPort4Ana"
	if {[PTN_EVP_State $telnet1 $matchType1 $Gpn_type1 $fileId "$hGPNPort3Stream5 $hGPNPort4Stream6" $GPNTestEth3 "lsp1" "pw1" "ac10" $hGPNPort3Ana $hGPNPort3Gen]} {
		set flag1_case2 1
	}
	gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream3 "TRUE"
	
	set minPwCnt [expr {($PWnum3 < $PWnum1) ? $PWnum3 : $PWnum1}]
	set startVid [expr $minPwCnt + 10 - 1 -5];#�������6��vlan������ת��
	stc::config $hGPNPort3Stream2.ethernet:EthernetII.vlans.Vlan -id $startVid
	stc::config $hGPNPort4Stream3.ethernet:EthernetII.vlans.Vlan -id $startVid
	stc::config $hGPNPort3Stream2.RangeModifier -Data $startVid
	stc::config $hGPNPort4Stream3.RangeModifier -Data $startVid
	stc::apply
	incr capId
	if {[GPN005Case2_checkFlow $fileId $rateL1 $rateR1 "GPN_PTN_005_$capId"]} {
		set flag1_case2 1
	}
        
        puts $fileId ""
        puts $fileId "NE1($gpnIp1)һ��lsp��PW������Ϊ��$PWnum1"
        puts $fileId "NE3($gpnIp3)һ��lsp��PW������Ϊ��$PWnum3"
        if {$flag1_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA5�����ۣ�����NE1($gpnIp1)��NE3($gpnIp3))һ��lsp��PW��������������֤" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA5�����ۣ�����NE1($gpnIp1)��NE3($gpnIp3))һ��lsp��PW��������������֤" $fileId
        }
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����һ��lsp��PW������  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����shut/undoshut UNI��NNI�˿ں���ҵ���Ƿ��ָܻ�  ���Կ�ʼ=====\n"
        foreach eth $portList11 {
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
        		gwd::GWPort_AddAdminState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
			if {[catch {
				close -i $telnet1
			} err]} {
				puts "close err"
			}
			after 600000
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
        		gwd::GWPort_AddAdminState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
			if {[catch {
				close -i $telnet1
			} err]} {
				puts "close err"
			}
			after 600000
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
        	}
		incr capId
        	if {[GPN005Case2_checkFlow $fileId $rateL1 $rateR1 "GPN_PTN_005_$capId"]} {
        		set flag2_case2 1
        	}
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
        	send_log "\n resource1:$resource1"
        	send_log "\n resource2:$resource2"
        	if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
        		set flag2_case2	1
        		gwd::GWpublic_print "NOK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
        	}
        }
	#�˿�shutdown undoshut ����ʻ�����telnet���жϣ��������µ�¼�����������µ�¼ǰɱ��ǰһ��telnet��
	if {[catch {
		close -i $telnet3
	} err]} {
		puts "close $telnet3 err"
	}
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet3]
        puts $fileId ""
        if {$flag2_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA6�����ۣ�����shut/undoshut UNI��NNI�˿ں���ҵ��ָ��Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA6�����ۣ�����shut/undoshut UNI��NNI�˿ں���ҵ��ָ��Ĳ���" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����shut/undoshut UNI��NNI�˿ں���ҵ���Ƿ��ָܻ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��������ҵ��˿����ڰ忨����ҵ���Ƿ��ָܻ�  ���Կ�ʼ=====\n"
        foreach slot $rebootSlotList1 {
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource3
          	sendAndStat52 aGPNPort4Cnt1 aGPNPort3Cnt1  $slot
          	parray aGPNPort3Cnt1
          	parray aGPNPort4Cnt1
          	for {set j 1} {$j<=$cnt} {incr j} {
        		if {![gwd::GWCard_AddReboot $telnet1 $matchType1 $Gpn_type1 $fileId $slot]} {
                		after $rebootBoardTime
				if {[catch {
					close -i $telnet1
				} err]} {
					puts "close err"
				}
				after 600000
				set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
				set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
				incr capId
                		if {[GPN005Case2_checkFlow $fileId $rateL1 $rateR1 "GPN_PTN_005_$capId"]} {
                			set flag3_case2 1
                		}
                	} else {
                		puts $fileId "$Gpn_type1\��$slot\����忨��֧����������"
                	}
        	}
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
        	send_log "\n resource3:$resource3"
        	send_log "\n resource4:$resource4"
        	if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
        		set flag3_case2	1
        		gwd::GWpublic_print "NOK" "�����忨$slot\֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "�����忨$slot\֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
        	}
        }
	#�˿�shutdown undoshut ����ʻ�����telnet���жϣ��������µ�¼�����������µ�¼ǰɱ��ǰһ��telnet��
	if {[catch {
		close -i $telnet3
	} err]} {
		puts "close $telnet3 err"
	}
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet3]
        puts $fileId ""
        if {$flag3_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA7�����ۣ���������ҵ��˿����ڰ忨����ҵ��ָ��Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA7�����ۣ���������ҵ��˿����ڰ忨����ҵ��ָ��Ĳ���" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��������ҵ��˿����ڰ忨����ҵ���Ƿ��ָܻ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�������������豸NE1($gpnIp1)����ҵ���Ƿ��ָܻ�  ���Կ�ʼ=====\n"
        for {set j 1} {$j<=$cnt} {incr j} {
        	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
        	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
        	after [expr 2*$rebootTime]
        	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
        	if {[GPN005Case2_checkFlow $fileId $rateL1 $rateR1 "GPN_PTN_005_$capId"]} {
        		set flag4_case2 1
        	}
        }
	#�˿�shutdown undoshut ����ʻ�����telnet���жϣ��������µ�¼�����������µ�¼ǰɱ��ǰһ��telnet��
	if {[catch {
		close -i $telnet3
	} err]} {
		puts "close $telnet3 err"
	}
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet3]
        puts $fileId ""
        if {$flag4_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA8�����ۣ����������豸NE1($gpnIp1)����ҵ��ָ��Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA8�����ۣ����������豸NE1($gpnIp1)����ҵ��ָ��Ĳ���" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�������������豸NE1($gpnIp1)����ҵ���Ƿ��ָܻ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�豸NE3($gpnIp3)��������NMS�������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
        gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource5
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitch $telnet3 $matchType3 $Gpn_type3 $fileId]} {
        		after [expr 2*$rebootTime]
        		set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet3]
			incr capId
        		if {[GPN005Case2_checkFlow $fileId $rateL1 $rateR1 "GPN_PTN_005_$capId"]} {
        			set flag5_case2 1
        		}
        		gwd::GWpublic_QueryMPLSForwardTable $telnet3 $matchType3 $Gpn_type3 $fileId "2" result
        		if {![string match [dict get $result 2 pwOutLabel] 501] || ![string match [dict get $result 2 lspOutLabel] +2500]} {
        			set flag5_case2 1
        			gwd::GWpublic_print "NOK" "VC=2 ��pwOutLabelӦΪ501ʵΪ[dict get $result 2 pwOutLabel] \
        					lspOutLabelӦΪ+2500ʵΪ[dict get $result 2 lspOutLabel]��NE3($gpnIp3)��$j\�ν���NMS��������ת�������쳣" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "VC=2 ��pwOutLabelӦΪ501ʵΪ[dict get $result 2 pwOutLabel] \
        					lspOutLabelӦΪ+2500ʵΪ[dict get $result 2 lspOutLabel]��NE3($gpnIp3)��$j\�ν���NMS��������ת����������" $fileId
        		}
        	} else {
        		puts $fileId "$matchType3\��֧��NMS������������ֻ��һ��NMS����������"
        	}
        }
        gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource6
        send_log "\n resource5:$resource5"
        send_log "\n resource6:$resource6"
        if {$resource6 > [expr $resource5 + $resource5 * $errRate]} {
        	set flag5_case2	1
        	gwd::GWpublic_print "NOK" "�豸NE3($gpnIp3)��������NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "�豸NE3($gpnIp3)��������NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
        }
	#�˿�shutdown undoshut ����ʻ�����telnet���жϣ��������µ�¼�����������µ�¼ǰɱ��ǰһ��telnet��
	if {[catch {
		close -i $telnet1
	} err]} {
		puts "close $telnet1 err"
	}
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
        puts $fileId ""
        if {$flag5_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA9�����ۣ��豸NE3($gpnIp3)��������NMS�������������ҵ��ָ���ϵͳ�ڴ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA9�����ۣ��豸NE3($gpnIp3)��������NMS�������������ҵ��ָ���ϵͳ�ڴ�" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�豸NE3($gpnIp3)��������NMS�������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�豸NE3($gpnIp3)��������SW�������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
        gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource7
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitchSw $telnet3 $matchType3 $Gpn_type3 $fileId]} {
        		after [expr 2*$rebootTime]
        		set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet3]
			incr capId
        		if {[GPN005Case2_checkFlow $fileId $rateL1 $rateR1 "GPN_PTN_005_$capId"]} {
        			set flag6_case2 1
        		}
        		gwd::GWpublic_QueryMPLSForwardTable $telnet3 $matchType3 $Gpn_type3 $fileId "2" result
        		if {![string match [dict get $result 2 pwOutLabel] 501] || ![string match [dict get $result 2 lspOutLabel] +2500]} {
        			set flag6_case2 1
        			gwd::GWpublic_print "NOK" "VC=2 ��pwOutLabelӦΪ501ʵΪ[dict get $result 2 pwOutLabel] \
        					lspOutLabelӦΪ+2500ʵΪ[dict get $result 2 lspOutLabel]��NE3($gpnIp3)��$j\�ν���SW��������ת�������쳣" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "VC=2 ��pwOutLabelӦΪ501ʵΪ[dict get $result 2 pwOutLabel] \
        					lspOutLabelӦΪ+2500ʵΪ[dict get $result 2 lspOutLabel]��NE3($gpnIp3)��$j\�ν���SW��������ת����������" $fileId
        		}
        	} else {
        		puts $fileId "$Gpn_type3\��֧��SW������������ֻ��һ��SW����������"
        	}
        }
        gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource8
        send_log "\n resource7:$resource7"
        send_log "\n resource8:$resource8"
        if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
        	set flag6_case2	1
        	gwd::GWpublic_print "NOK" "�豸NE3($gpnIp3)��������NMS��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "�豸NE3($gpnIp3)��������NMS��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
        }
	#�˿�shutdown undoshut ����ʻ�����telnet���жϣ��������µ�¼�����������µ�¼ǰɱ��ǰһ��telnet��
	if {[catch {
		close -i $telnet1
	} err]} {
		puts "close $telnet1 err"
	}
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
        puts $fileId ""
        if {$flag6_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FB1�����ۣ��豸NE3($gpnIp3)��������SW������������ҵ��ָ��Ĳ���" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB1�����ۣ��豸NE3($gpnIp3)��������SW������������ҵ��ָ��Ĳ���" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�豸NE3($gpnIp3)��������SW�������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�������������豸NE3($gpnIp3)�����ҵ��ָ�  ���Կ�ʼ=====\n"
        for {set j 1} {$j<=$cnt} {incr j} {
        	gwd::GWpublic_SaveCfg $telnet3 $matchType3 $Gpn_type3 $fileId
        	gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
        	after [expr 2*$rebootTime]
        	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet3]
		incr capId
        	if {[GPN005Case2_checkFlow $fileId $rateL1 $rateR1 "GPN_PTN_005_$capId"]} {
        		set flag7_case2 1
        	}
        }
	if {[catch {
		close -i $telnet1
	} err]} {
		puts "close $telnet1 err"
	}
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
        puts $fileId ""
        if {$flag7_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FB2�����ۣ��������������豸NE3($gpnIp3)�����ҵ��ָ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB2�����ۣ��������������豸NE3($gpnIp3)�����ҵ��ָ�" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�������������豸NE3($gpnIp3)�����ҵ��ָ�  ���Խ���=====\n"
        gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1) NE3($gpnIp3)ɾ�����á��������á��������ú���ҵ���Ƿ��ָܻ�  ���Կ�ʼ=====\n"
	if {($downFlag1 == 0) && ($downFlag3 == 0)} {
		gwd::GWmanage_ftpDownload $telnet3 $matchType3 $Gpn_type3 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] \
			[dict get $ftp passWord] "NE3.txt" ""
        	gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
		after 600000
		if {[catch {
			close -i $telnet1
		} err]} {
			puts "close $telnet1 err"
		}
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
        	gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] \
        		[dict get $ftp passWord] "NE1.txt" ""
        	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
        	after $rebootTime
        	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
        	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		gwd::GWmanage_ftpDownload $telnet3 $matchType3 $Gpn_type3 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] \
			[dict get $ftp passWord] "GPN_PTN_005_case2_dev3.txt" ""
		gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
		after 600000
		if {[catch {
			close -i $telnet1
		} err]} {
			puts "close $telnet1 err"
		}
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] \
			[dict get $ftp passWord] "GPN_PTN_005_case2_dev1.txt" ""
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after [expr 2*$rebootTime]
		set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet3]
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		set flag8_case2 [GPN005Case2_checkFlow $fileId $rateL1 $rateR1 "GPN_PTN_005_$capId"]
	} else {
		set flag8_case2 1
		if {$downFlag1 == 1} {
			gwd::GWpublic_print "NOK" "��Ҫ���ص������ļ�GPN_PTN_005_case2_dev1.txt��ǰ��Ĳ������ϴ�ʧ�ܣ���������޷�����" $fileId
		}
		if {$downFlag3 == 1} {
			gwd::GWpublic_print "NOK" "��Ҫ���ص������ļ�GPN_PTN_005_case2_dev3.txt��ǰ��Ĳ������ϴ�ʧ�ܣ���������޷�����" $fileId
		}
	}

        puts $fileId ""
        if {$flag8_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FB3�����ۣ�NE1($gpnIp1) NE3($gpnIp3)ɾ�����á��������á��������ú���ҵ��ָ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB3�����ۣ�NE1($gpnIp1) NE3($gpnIp3)ɾ�����á��������á��������ú���ҵ��ָ�" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1) NE3($gpnIp3)ɾ�����á��������á��������ú���ҵ���Ƿ��ָܻ�  ���Խ���=====\n"
        gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
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
	puts $fileId "Test Case 2 ����һ��lsp��PW������  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===�ָ���ʼ������...\n"
	set flagDel 0
	lappend flagDel [gwd::GWmanage_ftpDownload $telnet3 $matchType3 $Gpn_type3 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] \
		[dict get $ftp passWord] "NE3.txt" ""]
	lappend flagDel [gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId]
	lappend flagDel [gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] \
        	[dict get $ftp passWord] "NE1.txt" ""]
	lappend flagDel [gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId]
        after $rebootTime
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_005"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_005"
	
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_005����Ŀ�ģ�E-LINEҵ����������\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1==1 || $flagCase2==1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_005���Խ��" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2���Խ��" $fileId
	puts $fileId ""
	puts $fileId ""
        gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "����NE1($gpnIp1)��NE3($gpnIp3)�豸�ľ�̬ARP������������֤" $fileId
        gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "����shut/undoshut UNI��NNI�˿ں���ҵ��ָ��Ĳ���" $fileId
        gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "��������ҵ��˿����ڰ忨����ҵ��ָ��Ĳ���" $fileId
        gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "���������豸NE1($gpnIp1)����ҵ��ָ��Ĳ���" $fileId
        gwd::GWpublic_print "== FA5 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "����NE1($gpnIp1)��NE3($gpnIp3))һ��lsp��PW��������������֤" $fileId
        gwd::GWpublic_print "== FA6 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "����shut/undoshut UNI��NNI�˿ں���ҵ��ָ��Ĳ���" $fileId
        gwd::GWpublic_print "== FA7 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "��������ҵ��˿����ڰ忨����ҵ��ָ��Ĳ���" $fileId
        gwd::GWpublic_print "== FA8 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "���������豸NE1($gpnIp1)����ҵ��ָ��Ĳ���" $fileId
        gwd::GWpublic_print "== FA9 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "�豸NE3($gpnIp3)��������NMS������������ҵ��ָ��Ĳ���" $fileId
        gwd::GWpublic_print "== FB1 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "�豸NE3($gpnIp3)��������SW������������ҵ��ָ��Ĳ���" $fileId
        gwd::GWpublic_print "== FB2 == [expr {($flag7_case2 == 1) ? "NOK" : "OK"}]" "���������豸NE3($gpnIp3)����ҵ��ָ��Ĳ���" $fileId
        gwd::GWpublic_print "== FB3 == [expr {($flag8_case2 == 1) ? "NOK" : "OK"}]" "���������豸NE3($gpnIp3)����ҵ��ָ��Ĳ���" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_005"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_005_REPORT.txt" "report\\NOK_GPN_PTN_005_REPORT.txt"
	file rename "log\\GPN_PTN_005_LOG.txt" "log\\NOK_GPN_PTN_005_LOG.txt"
} else {
	file rename "report\\GPN_PTN_005_REPORT.txt" "report\\OK_GPN_PTN_005_REPORT.txt"
	file rename "log\\GPN_PTN_005_LOG.txt" "log\\OK_GPN_PTN_005_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}
