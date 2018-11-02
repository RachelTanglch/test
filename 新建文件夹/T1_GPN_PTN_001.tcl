#!/bin/sh
# T1_GPN_PTN_001.tcl \
exec tclsh "$0" ${1+"$@"}
#�������ƣ�ptn001
#-----------------------------------------------------------------------------------------------------------------------------------
#����Ŀ�ģ�E-LINE/E-LAN/E-TREEҵ�񴴽����޸ġ�ɾ���ͱ���
#1-ҵ�񴴽�   
#2-ҵ���޸�
#3-ҵ�񱣴��ɾ��
#4-ҵ��Ԥ���ã�δʵ�֣�
#-----------------------------------------------------------------------------------------------------------------------------------
#�����������Ͷ���������7600/SΪ����                                                                                                                             
#                                                                              
#                                    ___________                               
#                                   |   4GE/ge  |
#  _______                          |   8fx     |    
# |       |                         |           |
# |  PC   |_______Internet���� ______|           |
# |_______|                         |           |       
#    /__\                           |GPN(7600/S)|                  
#                        TC1����������������|           |            
#                                   |___________|           
#                                          
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
#   <1>����PW���ڵĶ˿�ΪNNI�ڣ�AC���ڵĿ�ΪUNI��
#   <2>����vlan������˿ں�Ip
#   <3>����lsp
#   <4>���ò���ȷ�Ľӿ�vlan name��ϵͳ����ʾ������ʧ��
#   <5>������һ��ipΪ���ؽӿڵĵ�ַ��ϵͳ����ʾ������ʧ��
#   <6>���ò���ȷ��in/out label��ϵͳ����ʾ������ʧ��
#   <7>���ò���ȷ��lsp id��ϵͳ����ʾ������ʧ��
#   <8>û������destination IPʱ����undo shutdown��ϵͳ����ʾ���ܼ���
#   <9>undo shutdown�������������Ϣ��ϵͳ����ʾ������ʧ��
#   <10>undo shutdown������������ͳ��ʹ��/��ֹ��ϵͳ���쳣
#2���Test Case 2���Ի���
#   <1>����pw
#   <2>���ò���ȷ��L2 vc id��ϵͳ����ʾ������ʧ��
#   <3>���ò���ȷdestination adress��ϵͳ����ʾ������ʧ��
#   <4>���ò���ȷ��remote/local label��ϵͳ����ʾ������ʧ��
#   <5>���ò���ȷ��lsp id��ϵͳ����ʾ������ʧ��
#   <6>û������hqosʹ��ʱ���д�����Ϣ���ã�ϵͳ����ʾ��������
#   <7>�����������Ϣʱpir����cirʱ��ϵͳ����ʾ
#   <8>����������ͳ��ʹ��/��ֹ��ϵͳ���쳣
#   <9>����������ֽ�ֹ/ʹ�ܣ�ϵͳ���쳣
#3���Test Case 3���Ի���
#   <1>����ac
#   <2>����ģʽΪ���˿�+��Ӫ��vlan��ʱ���ö˿�û�м���Ļ��ߴ���vlan idʱ��ϵͳ����ʾ������ʧ��
#   <3>���ò���ȷ��pw name��ϵͳ����ʾ������ʧ��
#   <4>�����������Ϣʱpir����cirʱ��ϵͳ����ʾ
#   <5>����������ͳ��ʹ��/��ֹ��ϵͳ���쳣
#   <6>û��ɾ��ac��pw�İ󶨹�ϵ��ɾ��acʱ��ϵͳ����ʾ����ɾ��
#   <7>ɾ����ac��pw�İ󶨹�ϵ��û��ɾ��ac��ɾ����Ӫ��vlan��ϵͳ����ʾ��ɾ��ʧ��
#4���Test Case 4���Ի���
#   <1>�ٴ���һ����E-LINEҵ��������ӦLSP��PW��AC���ɳɹ�������������֤��֮ǰ��������E-LINEҵ����Ӱ��
#   <2>���Ѵ����õ�LSP/PW /AC�Ĵ�����Ϣ�����޸ģ��޸ĳɹ���ϵͳ���쳣
#   <3>�鿴ϵͳ���Ѵ��ڵ�E-LINEҵ�񣬱������ã������豸���豸�����������������޶�ʧ
#   <4>ɾ��E-LINEҵ��ʱ�����Ƚ�AC��PW�󶨹�ϵɾ�����ٰ���˳��ɾ��ac pw lsp 
#   <5>ɾ��һ��E-LINEҵ��Ӱ����һ��
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
	file mkdir "log"
	set fd_log [open "log\\GPN_PTN_001_LOG.txt" a]
	set stdout $fd_log
	chan configure $fd_log -blocking 0 -buffering none;#������ģʽ ����flush
	log_file log\\GPN_PTN_001_LOG.txt
	
	file mkdir "report"
	set fileId [open "report\\GPN_PTN_001_REPORT.txt" a+]
	chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_001_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_001_DEBUG.txt 0
	chan configure $fd_debug -blocking 0 -buffering none;#������ģʽ ����flush

	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl
	
	set flagResult 0
	set flagCase1 0   ;#Test case 1��־λ 
	set flagCase2 0   ;#Test case 2��־λ
	set flagCase3 0   ;#Test case 3��־λ 
	set flagCase4 0   ;#Test case 4��־λ
	set flagCase5 0   ;#Test case 5��־λ 
	
	set lFailFile ""
	set FLAGF 0
	
	set tcId 0
	set capId 0
	set cfgId 0
	#Ϊ���Խ���Ԥ������
	for {set i 0} {$i < 80} {incr i} {
	    puts $fileId "                                                                                                                                                                                                                "	
	}
	
	puts $fileId "��¼�����豸...\n"
	puts $fileId "\n=====��¼�����豸1====\n"
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]

	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-LINE/E-LAN/E-TREEҵ�񴴽����޸ġ�ɾ���ͱ�����Ի������ÿ�ʼ...\n"
	set cfgFlag 0
	lassign $lDev1TestPort testPort1 testPort2 testPort3 testPort4 testPort5 testPort6
        foreach port $lDev1TestPort {
        	if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
        	}
        }
        ###�˿�Ϊ������ӿ����ò���
        if {[string match "L2" $Worklevel]} {
        	set interface1 v100
        	set interface2 v500
        	set interface3 v300
        	set interface4 v110
        	set interface5 v310
        	set interface6 v200
        	set interface7 v400
        	set interface8 v11
        	set interface9 v12
        } else {
        	set interface1 $testPort1.100
        	set interface2 $testPort1.500
        	set interface3 $testPort3.300
        	set interface4 $testPort2.110
        	set interface5 $testPort4.310
        	set interface6 $testPort6.200
        	set interface7 $testPort5.400
        	set interface8 $testPort5.11
        	set interface9 $testPort5.12
        }
	#���ڵ��������豸�õ��ı���------
	set lSpawn_id "$telnet1"
	set lMatchType "$matchType1"
	set lDutType "$Gpn_type1"
	set lIp "$gpnIp1"
	#------���ڵ��������豸�õ��ı���
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-LINE/E-LAN/E-TREEҵ�񴴽����޸ġ�ɾ���ͱ�����Ի�������ʧ�ܣ����Խ���" \
		"E-LINE/E-LAN/E-TREEҵ�񴴽����޸ġ�ɾ���ͱ�����Ի������óɹ�����������Ĳ���" "GPN_PTN_001"
	puts $fileId ""
	puts $fileId "===E-LINE/E-LAN/E-TREEҵ�񴴽����޸ġ�ɾ���ͱ�����Ի������ý���..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId ""
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 lsp�Ĳ����Ϸ��Բ���\n"
        #   <1>����PW���ڵĶ˿�ΪNNI�ڣ�AC���ڵĿ�ΪUNI��
        #   <2>����vlan������˿ں�Ip
        #   <3>����lsp
        #   <4>���ò���ȷ�Ľӿ�vlan name��ϵͳ����ʾ������ʧ��
        #   <5>������һ��ipΪ���ؽӿڵĵ�ַ��ϵͳ����ʾ������ʧ��
        #   <6>���ò���ȷ��in/out label��ϵͳ����ʾ������ʧ��
        #   <7>���ò���ȷ��lsp id��ϵͳ����ʾ������ʧ��
        #   <8>û������destination IPʱ����undo shutdown��ϵͳ����ʾ���ܼ���
        #   <9>undo shutdown�������������Ϣ��ϵͳ����ʾ������ʧ��
        #   <10>undo shutdown������������ͳ��ʹ��/��ֹ��ϵͳ���쳣
	set flag1_case1 0
	set flag2_case1 0
	set flag3_case1 0
	set flag4_case1 0
	set flag5_case1 0
	set flag6_case1 0
	
	
        set ip 192.1.1.1 ;#����ip
        set ip2 192.1.1.2;#��һ��ip
        set ip3 192.4.1.1;#����ip
        set ip4 192.4.1.2;#��һ��ip
        set ip13 192.4.3.2
        set ip14 192.4.4.2
        set ip31 192.4.3.1
        set ip41 192.4.4.1
        set address 10.1.1.1
        set address2 10.1.1.2
        set address3 10.4.1.1
        set address13 10.4.3.3
        set address14 10.4.4.4
        set bandwidth 50000
        set bandwidth3 50000
        set cirwidth 50000
        set cirwidth3 50000
        set pirwidth 80000
        set pirwidth3 80000
        set pirwidth5 40000
	if {[string match "L2" $Worklevel]} {
        	gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort1 "enable"	
	}
        PTN_NNI_AddInterIp $fileId $Worklevel $interface1 $ip $testPort1 $matchType1 $Gpn_type1 $telnet1
        ###���ó����������ƺͷǷ���lsp���ƣ���֤�Ƿ񴴽�ʧ��
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����lspʱ���ò�����Ҫ���lsp���֣���֤�Ƿ񴴽�ʧ��  ���Կ�ʼ=====\n"
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lspabcdefghijklmnopqrstuvwxyw_12"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����lsp����lspabcdefghijklmnopqrstuvwxyw_12 ���ȳ��������ֽڣ������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lspabcdefghijklmnopqrstuvwxyw_12"
	} else {
		gwd::GWpublic_print "OK" "����lspʱ����lsp����lspabcdefghijklmnopqrstuvwxyw_12 ���ȳ��������ֽڣ�����ʧ��" $fileId
	}	
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "@#awefaweflsp"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�@#awefaweflsp�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "@#awefaweflsp"
	} else {
		gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�@#awefaweflsp������ʧ��" $fileId
	}
	
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernetlsp1"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�ethernetlsp1�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "ethernetlsp1"
	} else {
		gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�ethernetlsp1������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "trunklsp2"]} {
        	set flag1_case1 1
        	gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�trunklsp2�������ɹ�" $fileId	
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "trunklsp2"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�trunklsp2������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "e1lspa"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�e1lspa�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "e1lspa"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�e1lspa������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "vlaniflspb"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�vlaniflspb�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "vlaniflspb"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�vlaniflspb������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "trunklspc"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�trunklspc�������ɹ�" $fileId	
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "trunklspc"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�trunklspc������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "e1lspd"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�e1lspd�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "e1lspd"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�e1lspd������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "loopback0lspe"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�loopback0lspe�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "loopback0lspe"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�loopback0lspe������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "loopback9lspf"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�loopback9lspf�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "loopback9lspf"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�loopback9lspf������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "Null0lspg"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�Null0lspg�������ɹ�" $fileId	
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "Null0lspg"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�Null0lspg������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "Null9lsph"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�Null9lsph�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "Null9lsph"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�Null9lsph������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp/1"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�lsp/1�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp/1"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�lsp/1������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log {lsp\\}]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�lsp\\�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId {lsp\\}
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�lsp\\������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp:3"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�lsp:3�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp:3"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�lsp:3������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp*4"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�lsp*4�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp*4"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�lsp*4������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp<7"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�lsp<7�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp<7"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�lsp<7������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp>8"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�lsp>8�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp>8"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�lsp>8������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp'9"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�lsp'9�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp'9"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�lsp'9������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp|10"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�lsp|10�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp|10"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�lsp|10������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp%11"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�lsp%11�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp%11"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�lsp%11������ʧ��" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp a12"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����Ƿ�lsp���֣�lsp a12�������ɹ�" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp a12"
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����Ƿ�lsp���֣�lsp a12������ʧ��" $fileId
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1�����ۣ�����lspʱ���ò�����Ҫ���lsp���֣������ɹ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1�����ۣ�����lspʱ���ò�����Ҫ���lsp���֣�����ʧ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����lspʱ���ò�����Ҫ���lsp���֣���֤�Ƿ񴴽�ʧ��  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����lspʱ���ò���ȷ�Ľӿ�Vlan����һ��ip����֤�Ƿ�����ʧ��  ���Կ�ʼ=====\n"
	###���ò���ȷ�Ľӿ�Vlan����һ��ip�����ǩ������ǩ��lspid�ܷ�ɹ�����lsp
        if {![gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" $interface2 $ip2 "20" "30" "normal" 1]} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ��������vlan�ӿڣ����óɹ�" $fileId	
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ��������vlan�ӿڣ�����ʧ��" $fileId
	}
        if {![gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" $interface1 "255.255.255.255" "20" "30" "normal" 1]} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����������һ��ip�����óɹ�" $fileId	
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����������һ��ip������ʧ��" $fileId
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2�����ۣ�����lspʱ���ô���Ľӿ�Vlan����һ��ip�����óɹ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2�����ۣ�����lspʱ���ô���Ľӿ�Vlan����һ��ip������ʧ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����lspʱ���ô���Ľӿ�Vlan����һ��ip����֤�Ƿ�����ʧ��  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����lspʱ���ô�������ǩ������ǩ��lspId����֤�Ƿ�����ʧ��  ���Կ�ʼ=====\n"
        if {![gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" $interface1 $ip2 "10" "30" "normal" 1]} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ����������ڱ�ǩ�����óɹ�" $fileId	
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ����������ڱ�ǩ������ʧ��" $fileId
	}
        if {![gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" $interface1 $ip2 "20" "15" "normal" 1]} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ�������ĳ��ڱ�ǩ�����óɹ�" $fileId	
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ�������ĳ��ڱ�ǩ������ʧ��" $fileId
	}
        if {![gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" $interface1 $ip2 "20" "30" "normal" 65536]} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "����lspʱ��������lspId�����óɹ�" $fileId	
	} else {
	       gwd::GWpublic_print "OK" "����lspʱ��������lspId������ʧ��" $fileId
	}
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3�����ۣ�����lspʱ���ô�������ǩ������ǩ��lspId�����óɹ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3�����ۣ�����lspʱ���ô�������ǩ������ǩ��lspId������ʧ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����lspʱ���ô�������ǩ������ǩ��lspId����֤�Ƿ�����ʧ��  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����������lspʱ�����������ö���ȷ����֤�Ƿ����óɹ�  ���Կ�ʼ=====\n"
        if {[gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $interface1 $ip2 "20" "30" "normal" 1]} {
        	set flag4_case1 1
		gwd::GWpublic_print "NOK" "����������lspʱ�����������ö���ȷ������ʧ��" $fileId	
	} else {
	       gwd::GWpublic_print "OK" "����������lspʱ�����������ö���ȷ�����óɹ�" $fileId
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA4�����ۣ�����������lspʱ�����������ö���ȷ������ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4�����ۣ�����������lspʱ�����������ö���ȷ�����óɹ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����������lspʱ�����������ö���ȷ����֤�Ƿ����óɹ�  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====lsp�ļ������  ���Կ�ʼ=====\n"
        ###lsp�ļ������	
        if {![gwd::GWStaLsp_AddLspEn $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" "undo shutdown"]} {
        	set flag5_case1 1
		gwd::GWpublic_print "NOK" "û������Ŀ����Ԫʱ����lsp�����óɹ�" $fileId
        } else {
		gwd::GWpublic_print "OK" "û������Ŀ����Ԫʱ����lsp������ʧ��" $fileId	
        }
	
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $address
        if {[gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]} {
		set flag5_case1 1
		gwd::GWpublic_print "NOK" "������Ŀ����Ԫʱ����lsp������ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "������Ŀ����Ԫʱ����lsp�����óɹ�" $fileId
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA5�����ۣ�lsp�ļ������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5�����ۣ�lsp�ļ������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====lsp�ļ������  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====lsp�Ĵ��������ͳ�����ò���  ���Կ�ʼ=====\n"
	gwd::GWStaLsp_AddLspEn $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "undo shutdown"
        if {![gwd::GWpublic_addBandwidth $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" $bandwidth]} {
		set flag6_case1 1
		gwd::GWpublic_print "NOK" "����lsp�����ô�����Ϣ�����óɹ�" $fileId	
	} else {
		gwd::GWpublic_print "OK" "����lsp�����ô�����Ϣ������ʧ��" $fileId
	}
	gwd::GWStaLsp_AddLspEn $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "shutdown"
	if {[gwd::GWpublic_addBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $bandwidth]} {
		set flag6_case1 1
		gwd::GWpublic_print "NOK" "shutdown lsp�����ô�����Ϣ������ʧ��" $fileId
			
	} else {
		gwd::GWpublic_print "OK" "shutdown lsp�����ô�����Ϣ�����óɹ�" $fileId
		
	}
	
	gwd::GWStaLsp_AddLspEn $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "undo shutdown"
        if {[gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "enable"]} {
		set flag6_case1 1
		gwd::GWpublic_print "NOK" "����lsp��ʹ������ͳ�ƣ�����ʧ��" $fileId	
	} else {
		gwd::GWpublic_print "OK" "����lsp��ʹ������ͳ�ƣ����óɹ�" $fileId
	}
        if {[gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "disable"]} {
		set flag6_case1 1
		gwd::GWpublic_print "NOK" "����lsp��ȥʹ������ͳ�ƣ�����ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "����lsp��ȥʹ������ͳ�ƣ����óɹ�" $fileId	
	}	
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "enable"
        gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"
	puts $fileId ""
	if {$flag6_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA6�����ۣ�lsp�Ĵ��������ͳ�����ò���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6�����ۣ�lsp�Ĵ��������ͳ�����ò���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====lsp�Ĵ��������ͳ�����ò���  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
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
        puts $fileId "Test Case 1 lsp�Ĳ����Ϸ��Բ���  ���Խ���\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 ����pw��������������\n"
	#   <1>����pw
	#   <2>���ò���ȷ��L2 vc id��ϵͳ����ʾ������ʧ��
	#   <3>���ò���ȷdestination adress��ϵͳ����ʾ������ʧ��
	#   <4>���ò���ȷ��remote/local label��ϵͳ����ʾ������ʧ��
	#   <5>���ò���ȷ��lsp id��ϵͳ����ʾ������ʧ��
	#   <6>û������hqosʹ��ʱ���д�����Ϣ���ã�ϵͳ����ʾ���ܼ���
	#   <7>�����������Ϣʱpir����cirʱ��ϵͳ����ʾ
	#   <8>����������ͳ��ʹ��/��ֹ��ϵͳ���쳣
	#   <9>����������ֽ�ֹ/ʹ�ܣ�ϵͳ���쳣
	###���ó����������ƺͷǷ���pw���ƣ���֤�Ƿ񴴽�ʧ��
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0
	set flag5_case2 0
	set flag6_case2 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ���ò�����Ҫ���pw���֣���֤�Ƿ񴴽�ʧ��  ���Կ�ʼ=====\n"
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pwabcdefghijklmnopqrstuvwxyw_123"]
        if {$ret == 2} {
		gwd::GWpublic_print "OK" "����pwʱ����pw����pwabcdefghijklmnopqrstuvwxyw_123���ȳ��������ֽڣ�����ʧ��" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pwabcdefghijklmnopqrstuvwxyw_123"
			gwd::GWpublic_print "NOK" "����pwʱ����pw����pwabcdefghijklmnopqrstuvwxyw_123���ȳ��������ֽڣ������ɹ�" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "����pwʱ����pw����pwabcdefghijklmnopqrstuvwxyw_123���ȳ��������ֽڣ�����ʧ�ܵ���ϵͳ��ʾ����" $fileId	
		}
	}
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "@#awefawefpw"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�@#awefawefpw������ʧ��" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "@#awefawefpw"
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�@#awefawefpw�������ɹ�" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�@#awefawefpw������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
		}
	}
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernetpw1"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�ethernetpw1������ʧ��" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "ethernetpw1"
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�ethernetpw1�������ɹ�" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�ethernetpw1������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
		}
	}
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "trunkpw2"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�trunkpw2������ʧ��" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "trunkpw2"
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�trunkpw2�������ɹ�" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�trunkpw2������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
		}
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "e1pwa"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�e1pwa������ʧ��" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "e1pwa"
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�e1pwa�������ɹ�" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�e1pwa������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
		}
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "vlanifpwb"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�vlanifpwb������ʧ��" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "vlanifpwb"
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�vlanifpwb�������ɹ�" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�vlanifpwb������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
		}
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "trunkpwc"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�trunkpwc������ʧ��" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "trunkpwc"
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�trunkpwc�������ɹ�" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�trunkpwc������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
		}
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "e1pwd"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�e1pwd������ʧ��" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "e1pwd"
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�e1pwd�������ɹ�" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�e1pwd������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
		}
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "loopback0pwe"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�loopback0pwe������ʧ��" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "loopback0pwe"
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�loopback0pwe�������ɹ�" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�loopback0pwe������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
		}
	}
        
        set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "loopback9pwf"]
        if {$ret == 3} {
               gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�loopback9pwf������ʧ��" $fileId
        } else {
               set flag1_case2 1
               if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "loopback9pwf"
        	       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�loopback9pwf�������ɹ�" $fileId	
               } else {
        	       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�loopback9pwf������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
               }
        }
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "Null0pwg"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�Null0pwg������ʧ��" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "Null0pwg"
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�Null0pwg�������ɹ�" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�Null0pwg������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
	       }
	}
        
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "Null9pwh"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�Null9pwh������ʧ��" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "Null9pwh"
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�Null9pwh�������ɹ�" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�Null9pwh������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw/1"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�pw/1������ʧ��" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw/1"
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw/1�������ɹ�" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw/1������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log {pw\\}]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�pw\\������ʧ��" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId {pw\\}
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw\\�������ɹ�" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw\\������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
	       }
	}
       
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw:3"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�pw:3������ʧ��" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw:3"
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw:3�������ɹ�" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw:3������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw*4"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�pw*4������ʧ��" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw*4"
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw*4�������ɹ�" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw*4������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw<7"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�pw<7������ʧ��" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw<7"
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw<7�������ɹ�" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw<7������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw>8"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�pw>8������ʧ��" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw>8"
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw>8�������ɹ�" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw>8������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw'9"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�pw'9������ʧ��" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw'9"
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw'9�������ɹ�" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw'9������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw|10"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�pw|10������ʧ��" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw|10"
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw|10�������ɹ�" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw|10������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw%11"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�pw%11������ʧ��" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw%11"
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw%11�������ɹ�" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw%11������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw a12"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "����pwʱ����Ƿ�pw���֣�pw a12������ʧ��" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw a12"
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw a12�������ɹ�" $fileId
	       } else {
		       gwd::GWpublic_print "NOK" "����pwʱ����Ƿ�pw���֣�pw a12������ʧ�ܵ���ϵͳ��ʾ����" $fileId	
	       }
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA7�����ۣ�����pwʱ���ò�����Ҫ���pw���֣������ɹ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7�����ۣ�����pwʱ���ò�����Ҫ���pw���֣�����ʧ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ���ò�����Ҫ���pw���֣���֤�Ƿ񴴽�ʧ��  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ���ô����Vcid��Ŀ����Ԫ�����ر�ǩ��Զ�̱�ǩ��lspId����֤�Ƿ�����ʧ��  ���Կ�ʼ=====\n"
        if {![gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fd_log "pw1" "l2transport" "2147483647" "" $address "40" "50" "1" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "����pwʱ���벻��ȷ�ľ�̬pw id��2147483647�������ɹ�" $fileId	
	} else {
		gwd::GWpublic_print "OK" "����pwʱ���벻��ȷ�ľ�̬pw id��2147483647������ʧ��" $fileId
	}
        if {![gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fd_log "pw1" "l2transport" "1" "" "255.255.255.256" "40" "50" "1" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "����pwʱ���벻��ȷ��destination adress��255.255.255.256�������ɹ�" $fileId	
	} else {
		gwd::GWpublic_print "OK" "����pwʱ���벻��ȷ��destination adress��255.255.255.256������ʧ��" $fileId
	}
        if {![gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fd_log "pw1" "l2transport" "1" "" $address "10" "50" "1" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "����pwʱ���벻��ȷ��Remote label��10�������ɹ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "����pwʱ���벻��ȷ��Remote label��10������ʧ��" $fileId		
	}
        if {![gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fd_log "pw1" "l2transport" "1" "" $address "40" "10" "1" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "����pwʱ���벻��ȷ��Local label��10�������ɹ�" $fileId	
	} else {
		gwd::GWpublic_print "OK" "����pwʱ���벻��ȷ��Local label��10������ʧ��" $fileId
	}
        if {![gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fd_log "pw1" "l2transport" "1" "" $address "40" "50" "20" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "����pwʱ���벻���ڵ�lsp id��20�������ɹ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "����pwʱ���벻���ڵ�lsp id��20������ʧ��" $fileId	
	}
        if {[gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address "40" "50" "1" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "����pwʱ��������в�������ȷ������ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "����pwʱ��������в�������ȷ�������ɹ�" $fileId
	}
	puts $fileId ""
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA8�����ۣ�����pwʱ���ô���Ĳ��������óɹ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8�����ۣ�����pwʱ���ô���Ĳ���������ʧ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ���ô����Vcid��Ŀ����Ԫ�����ر�ǩ��Զ�̱�ǩ��lspId����֤�Ƿ�����ʧ��  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���ô����pw��̬��ǩ�Ͷ�̬��ǩ�ķ�Χ����֤�Ƿ�����ʧ��  ���Կ�ʼ=====\n"
        if {[gwd::GWpublic_addPwLabelRange $telnet1 $matchType1 $Gpn_type1 $fd_log "15" "39" "2048" "1048575"] != 2} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "����pw�ı�ǩ��Χʱ��̬��ǩ����СֵС����С���ֵ�����óɹ�����ʾ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "����pw�ı�ǩ��Χʱ��̬��ǩ����СֵС����С���ֵ������ʧ������ʾ��ȷ" $fileId
	}
        if {[gwd::GWpublic_addPwLabelRange $telnet1 $matchType1 $Gpn_type1 $fd_log "16" "1048576" "2048" "1048575"] != 3} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "����pw�ı�ǩ��Χʱ��̬��ǩ�����ֵ���������ֵ�����óɹ�����ʾ����" $fileId	
	} else {
		gwd::GWpublic_print "OK" "����pw�ı�ǩ��Χʱ��̬��ǩ�����ֵ���������ֵ������ʧ������ʾ��ȷ" $fileId	
	}
        if {[gwd::GWpublic_addPwLabelRange $telnet1 $matchType1 $Gpn_type1 $fd_log "16" "2049" "2048" "1048575"] != 4} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "����pw�ı�ǩ��Χʱ��̬��ǩ�ķ�Χ�붯̬��ǩ�ķ�Χ�г�ͻ�����óɹ�����ʾ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "����pw�ı�ǩ��Χʱ��̬��ǩ�ķ�Χ�붯̬��ǩ�ķ�Χ�г�ͻ������ʧ������ʾ��ȷ" $fileId	
	}
        if {[gwd::GWpublic_addPwLabelRange $telnet1 $matchType1 $Gpn_type1 $fileId "16" "2017" "2048" "1048575"] != 0} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "����pw�ı�ǩ��Χʱ��̬��ǩ�ķ�Χ�붯̬��ǩ����ȷ������ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "����pw�ı�ǩ��Χʱ��̬��ǩ�ķ�Χ�붯̬��ǩ����ȷ�����óɹ�" $fileId
	}
	#�����޸ı�ǩ��Χ�豣�����������Ч�����Խ��б��������������ٲ�ѯ�����ò���
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
        gwd::GWpublic_getPwLabelRange $telnet1 $matchType1 $Gpn_type1 $fileId lresult
	puts "lresult:$lresult"
        if {([dict get $lresult static min] != 16) || ([dict get $lresult static max] != 2017) || ([dict get $lresult dynamic min] != 2048) \
        	|| ([dict get $lresult dynamic max] != 1048575)} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "pw��̬��ǩ����Сֵ����ֵΪ16��ѯֵΪ[dict get $lresult static min]���ֵ����ֵΪ2017��ѯֵΪ[dict get $lresult static max]��\
			��̬��ǩ����Сֵ����ֵΪ2048��ѯֵΪ[dict get $lresult dynamic min]���ֵ����ֵΪ1048575��ѯֵΪ[dict get $lresult dynamic max]" $fileId
	} else {
		gwd::GWpublic_print "OK" "pw��̬��ǩ����СֵӦΪ16ʵΪ[dict get $lresult static min]���ֵӦΪ2017ʵΪ[dict get $lresult static max]��\
			��̬��ǩ����СֵӦΪ2048ʵΪ[dict get $lresult dynamic min]���ֵӦΪ1048575ʵΪ[dict get $lresult dynamic max]" $fileId
	}
	
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        if {[gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address "1000" "1001" "1" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "������ȷ�ľ�̬�����������pw������ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "������ȷ�ľ�̬�����������pw�����óɹ�" $fileId
	}
	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA9�����ۣ�pw��̬��ǩ�Ͷ�̬��ǩ��Χ�����ò���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9�����ۣ�pw��̬��ǩ�Ͷ�̬��ǩ��Χ�����ò���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���ô����pw��̬��ǩ�Ͷ�̬��ǩ�ķ�Χ����֤�Ƿ�����ʧ��  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====pw��������ò���  ���Կ�ʼ=====\n"
        if {![gwd::GWpublic_addPwBandwidth $telnet1 $matchType1 $Gpn_type1 $fd_log "pw1" $cirwidth $pirwidth]} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "û��ʹ��HQOSʱ����PW�������óɹ�" $fileId	
	} else {
		gwd::GWpublic_print "OK" "û��ʹ��HQOSʱ����PW��������ʧ��" $fileId
	}
        gwd::GWpublic_cfgPwHqosEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "enable"
        if {[gwd::GWpublic_addPwBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" $cirwidth $pirwidth]} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "ʹ��HQOSʱ����PW��������ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "ʹ��HQOSʱ����PW�������óɹ�" $fileId	
	}
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB1�����ۣ�pw��������ò���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1�����ۣ�pw��������ò���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====pw��������ò���  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ʹ��/ȥʹ��pw����ͳ�Ƶ����ò���  ���Կ�ʼ=====\n"
        if {[gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "enable"]} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "ʹ��PW����ͳ�ƣ�����ʧ��" $fileId	
	} else {
		gwd::GWpublic_print "OK" "ʹ��PW����ͳ�ƣ����óɹ�" $fileId	
	}
        if {[gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "disable"]} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "ȥʹ��PW����ͳ�ƣ�����ʧ��" $fileId	
	} else {
		gwd::GWpublic_print "OK" "ȥʹ��PW����ͳ�ƣ����óɹ�" $fileId
	}
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "enable"
	puts $fileId ""
	if {$flag5_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB2�����ۣ�ʹ��/ȥʹ��pw����ͳ�Ƶ����ò���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2�����ۣ�ʹ��/ȥʹ��pw����ͳ�Ƶ����ò���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ʹ��/ȥʹ��pw����ͳ�Ƶ����ò���  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ʹ��/ȥʹ��pw�����ֵ����ò���  ���Կ�ʼ=====\n"
        if {[gwd::GWpublic_addPwWordEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "disable"]} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "ʹ��PW�����֣�����ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "ʹ��PW�����֣����óɹ�" $fileId	
	}
        if {[gwd::GWpublic_addPwWordEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "enable"]} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "ȥʹ��PW�����֣�����ʧ��" $fileId	
	} else {
		gwd::GWpublic_print "OK" "ȥʹ��PW�����֣����óɹ�" $fileId
	}
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
	puts $fileId ""
	if {$flag6_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB3�����ۣ�ʹ��/ȥʹ��pw�����ֵ����ò���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3�����ۣ�ʹ��/ȥʹ��pw�����ֵ����ò���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ʹ��/ȥʹ��pw�����ֵ����ò���  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
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
	puts $fileId "Test Case 2 ����pw��������������  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 ����ac��������������\n"
        #   <1>����ac
        #   <2>����ģʽΪ���˿�+��Ӫ��vlan��ʱ���ö˿�û�м���Ļ��ߴ���vlan idʱ��ϵͳ����ʾ������ʧ��
        #   <3>���ò���ȷ��pw name��ϵͳ����ʾ������ʧ��
        #   <4>�����������Ϣʱpir����cirʱ��ϵͳ����ʾ
        #   <5>����������ͳ��ʹ��/��ֹ��ϵͳ���쳣
        #   <6>û��ɾ��ac��pw�İ󶨹�ϵ��ɾ��acʱ��ϵͳ����ʾ����ɾ��
        #   <7>ɾ����ac��pw�İ󶨹�ϵ��û��ɾ��ac��ɾ����Ӫ��vlan��ϵͳ����ʾ��ɾ��ʧ��
	set flag1_case3 0
	set flag2_case3 0
	set flag3_case3 0
	set flag4_case3 0
	set flag5_case3 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ���ò�����Ҫ���ac���֣���֤�Ƿ񴴽�ʧ��  ���Կ�ʼ=====\n"
        PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "200" $testPort6
        
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "acabcdefghijklmnopqrstuvwxyw_123"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����ac����acabcdefghijklmnopqrstuvwxyw_123 ���ȳ��������ֽڣ������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "acabcdefghijklmnopqrstuvwxyw_123"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����ac����lspabcdefghijklmnopqrstuvwxyw_12 ���ȳ��������ֽڣ�����ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "@#awefawefac"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�@#awefawefac�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "@#awefawefac"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�@#awefawefac������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernetac1"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�ethernetac1�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ethernetac1"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�ethernetac1������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "trunkac2"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�trunkac2�������ɹ�" $fileId	
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "trunkac2"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�trunkac2������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "e1aca"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�e1aca�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "e1aca"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�e1aca������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "vlanifacb"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�vlanifacb�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "vlanifacb"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�vlanifacb������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "trunkacc"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�trunkacc�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "trunkacc"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�trunkacc������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "e1acd"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�e1acd�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "e1acd"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�e1acd������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "loopback0ace"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�loopback0ace�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "loopback0ace"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�loopback0ace������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "loopback9acf"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�loopback9acf�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "loopback9acf"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�loopback9acf������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "Null0acg"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�Null0acg�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "Null0acg"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�Null0acg������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "Null9ach"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�Null9ach�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "Null9ach"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�Null9ach������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac/1"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�ac/1�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac/1"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�ac/1������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log {ac\\}]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�ac\\�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId {ac\\}
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�ac\\������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac:3"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�ac:3�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac:3"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�ac:3������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac*4"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�ac*4�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac*4"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�ac*4������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac<7"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�ac<7�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac<7"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�ac<7������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac>8"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�ac>8�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac>8"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�ac>8������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac'9"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�ac'9�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac'9"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�ac'9������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac|10"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�ac|10�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac|10"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�ac|10������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac%11"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�ac%11�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac%11"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�ac%11������ʧ��" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac a12"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "����acʱ����Ƿ�ac���֣�ac a12�������ɹ�" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac a12"
	} else {
		gwd::GWpublic_print "OK" "����acʱ����Ƿ�ac���֣�ac a12������ʧ��" $fileId
	}
	puts $fileId ""
	if {$flag1_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB4�����ۣ�����acʱ���ò�����Ҫ���ac���֣������ɹ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4�����ۣ�����acʱ���ò�����Ҫ���ac���֣�����ʧ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ���ò�����Ҫ���ac���֣���֤�Ƿ񴴽�ʧ��  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱʹ�õĶ˿ںź�vlan��������  ���Կ�ʼ=====\n"
        if {[gwd::GWAc_AddInfo $telnet1 $matchType1 $Gpn_type1 $fd_log "ac200" "" $testPort5  200 0 "nochange" 1 0 0 "0x8100"]} {
		gwd::GWpublic_print "OK" "����acʱ���벻��ȷ�Ķ˿ںţ�����ʧ��" $fileId	
	} else {
		set flag2_case3 1
		gwd::GWpublic_print "NOK" "����acʱ���벻��ȷ�Ķ˿ںţ����óɹ�" $fileId
	}
        if {[gwd::GWAc_AddInfo $telnet1 $matchType1 $Gpn_type1 $fd_log "ac200" "" $testPort6  100 0 "nochange" 1 0 0 "0x8100"]} {
		gwd::GWpublic_print "OK" "����acʱ���벻��ȷ����Ӫ��vlan������ʧ��" $fileId	
	} else {
		set flag2_case3 1
		gwd::GWpublic_print "NOK" "����acʱ���벻��ȷ����Ӫ��vlan�����óɹ�" $fileId
	}
        ###������ȷ�Ķ˿ڻ���vid
        if {[gwd::GWAc_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac200" "" $testPort6  200 0 "nochange" 1 0 0 "0x8100"]} {
		set flag2_case3 1
		gwd::GWpublic_print "NOK" "����acʱ������ȷ�Ķ˿ںź�vlan������ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "����acʱ������ȷ�Ķ˿ںź�vlan�����óɹ�" $fileId	
	}
	puts $fileId ""
	if {$flag2_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB5�����ۣ�����acʱʹ�õĶ˿ںź�vlan��������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5�����ۣ�����acʱʹ�õĶ˿ںź�vlan��������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱʹ�õĶ˿ںź�vlan��������  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ac��pw�Ĳ���  ���Կ�ʼ=====\n"
        if {[gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fd_log "ac200" "pw2" "eline"]} {
		gwd::GWpublic_print "OK" "ac�󶨵�pw�����ڣ���ʧ��" $fileId	
	} else {
		set flag3_case3 1
		gwd::GWpublic_print "NOK" "ac�󶨵�pw�����ڣ��󶨳ɹ�" $fileId
	}
        if {[gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac200" "pw1" "eline"]} {
		set flag3_case3 1
		gwd::GWpublic_print "NOK" "ac��pw�Ĳ�������ȷ����ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "ac��pw�Ĳ�������ȷ���󶨳ɹ�" $fileId	
	}
	puts $fileId ""
	if {$flag3_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB6�����ۣ�ac��pw�Ĳ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6�����ۣ�ac��pw�Ĳ���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ac��pw�Ĳ���  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ac���ô���Ͷ˿�ͳ�ƵĲ���  ���Կ�ʼ=====\n"
        ###����ac������Ϣ�Ͷ˿�ͳ�� 
        if {[gwd::GWpublic_addAcBandwidth $telnet1 $matchType1 $Gpn_type1 $fd_log "ac200" $cirwidth $pirwidth5]} {
		gwd::GWpublic_print "OK" "����ac����ʱpirֵС��cirֵ������ʧ��" $fileId	
	} else {
		set flag4_case3 1
		gwd::GWpublic_print "NOK" "����ac����ʱpirֵС��cirֵ�����óɹ�" $fileId
	}
        if {[gwd::GWpublic_addAcBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "ac200" $cirwidth $pirwidth]} {
		set flag4_case3 1
		gwd::GWpublic_print "NOK" "����ac����ʱpir��cir����ȷ������ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "����ac����ʱpir��cir����ȷ�����óɹ�" $fileId	
	}
        if {[gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac200" "enable"]} {
		set flag4_case3 1
		gwd::GWpublic_print "NOK" "ʹ��ac����ͳ�ƣ�����ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "ʹ��ac����ͳ�ƣ����óɹ�" $fileId	
	}
        if {[gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac200" "disable"]} {
		set flag4_case3 1
		gwd::GWpublic_print "NOK" "ȥʹ��ac����ͳ�ƣ�����ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "ȥʹ��ac����ͳ�ƣ����óɹ�" $fileId
	}
	puts $fileId ""
	if {$flag4_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB7�����ۣ�ac���ô���Ͷ˿�ͳ�ƵĲ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7�����ۣ�ac���ô���Ͷ˿�ͳ�ƵĲ���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ac���ô���Ͷ˿�ͳ�ƵĲ���  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ��ac����󶨵Ĳ���  ���Կ�ʼ=====\n"
        if {[gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac200"]} {
		gwd::GWpublic_print "OK" "û��ɾ��ac��ʱɾ��ac��ɾ��ʧ��" $fileId
	} else {
		set flag5_case3 1
		gwd::GWpublic_print "NOK" "û��ɾ��ac��ʱɾ��ac��ɾ���ɹ�" $fileId	
	}
	gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac200"
	set ret [PTN_DelInterVid $fd_log $Worklevel $interface6 $matchType1 $Gpn_type1 $telnet1]
	if {[string match "L2" $Worklevel]} {
		if {$ret == 0} {
			set flag5_case3 1
			gwd::GWpublic_print "NOK" "����ӿ���û��ɾ��ac������¿���ɾ��vlan200" $fileId
			
		} else {
			gwd::GWpublic_print "OK" "����ӿ���û��ɾ��ac������²�����ɾ��vlan200" $fileId	
		}
	} else {
		if {$ret == 1} {
			set flag5_case3 1
			gwd::GWpublic_print "NOK" "����ӿ���û��ɾ��ac������²�����ɾ���ӽӿ�$interface6" $fileId
		} else {
			gwd::GWpublic_print "OK" "����ӿ���û��ɾ��ac������¿���ɾ���ӽӿ�$interface6" $fileId
		}
		PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "200" $testPort6
	}
	set ret [PTN_DelInterVid_new $fileId $Worklevel $testPort1.100 $matchType1 $Gpn_type1 $telnet1]
	if {[string match "L2" $Worklevel]} {
		if {$ret == 0} {
			set flag5_case3 1
			gwd::GWpublic_print "NOK" "����ӿ���û��ɾ��lsp������¿���ɾ������lsp��vlan v100" $fileId
			
		} else {
			gwd::GWpublic_print "OK" "����ӿ���û��ɾ��lsp������²�����ɾ������lsp��vlan v100" $fileId	
		}
	} else {
		if {$ret == 1} {
			set flag5_case3 1
			gwd::GWpublic_print "NOK" "����ӿ���û��ɾ��lsp������¿���ɾ������lsp���ӽӿ�$testPort1" $fileId
		} else {
			gwd::GWpublic_print "OK" "����ӿ���û��ɾ��lsp������²�����ɾ������lsp���ӽӿ�$testPort1" $fileId
		}
		PTN_NNI_AddInterIp $fileId $Worklevel $interface1 $ip $testPort1 $matchType1 $Gpn_type1 $telnet1
	}
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac200" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac200"
	puts $fileId ""
	if {$flag5_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB8�����ۣ�ɾ��ac����󶨵Ĳ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8�����ۣ�ɾ��ac����󶨵Ĳ���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ��ac����󶨵Ĳ���  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
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
	puts $fileId "Test Case 3 ����ac��������������  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 �½�E-LINEҵ�񣬲�������E-LINEҵ���Ƿ���Ӱ��\n"
        #   <1>�ٴ���һ����E-LINEҵ��������ӦLSP��PW��AC���ɳɹ�������������֤��֮ǰ��������E-LINEҵ����Ӱ��
        #   <2>���Ѵ����õ�LSP/PW/AC�Ĵ�����Ϣ�����޸ģ��޸ĳɹ���ϵͳ���쳣
        #   <3>�鿴ϵͳ���Ѵ��ڵ�E-LINEҵ�񣬱������ã������豸���豸�����������������޶�ʧ
        #   <4>ɾ��E-LINEҵ��ʱ�����Ƚ�AC��PW�󶨹�ϵɾ�����ٰ���˳��ɾ��ac pw lsp 
        #   <5>ɾ��һ��E-LINEҵ��Ӱ����һ��
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set flag5_case4 0
	set flag6_case4 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====������һ��E-LINEҵ��Ļ������½�lsp�����½�lsp�������� ���Կ�ʼ=====\n"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort3 "enable"
	}
	lappend flag1_case4 [PTN_NNI_AddInterIp $fileId $Worklevel $interface3 $ip3 $testPort3 $matchType1 $Gpn_type1 $telnet1]
        #####����LSP����ѯ
        lappend flag1_case4 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" $interface3 $ip4 "200" "300" "normal" "2"]
	lappend flag1_case4 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" $address3]
	lappend flag1_case4 [gwd::GWpublic_addBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" $bandwidth3]
	lappend flag1_case4 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"]
	lappend flag1_case4 [gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" "enable"]
	lappend flag1_case4 [gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag1_case4]} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB9�����ۣ�������һ��E-LINEҵ��Ļ������½�lsp�����½�lsp��������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9�����ۣ�������һ��E-LINEҵ��Ļ������½�lsp�����½�lsp��������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====������һ��E-LINEҵ��Ļ������½�lsp�����½�lsp��������  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====������һ��E-LINEҵ��Ļ������½�pw�����½�pw��������  ���Կ�ʼ=====\n"
        lappend flag2_case4 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "l2transport" "2" "" $address3 "400" "500" "2" "nochange" "" 1 0 "0x8100" "0x8100" ""]
        lappend flag2_case4 [gwd::GWpublic_cfgPwHqosEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "enable"]
        lappend flag2_case4 [gwd::GWpublic_addPwBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" $cirwidth3 $pirwidth3]
        lappend flag2_case4 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "enable"]
        lappend flag2_case4 [gwd::GWpublic_addPwWordEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "disable"]
        lappend flag2_case4 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" result]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag2_case4]} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC1�����ۣ�������һ��E-LINEҵ��Ļ������½�pw�����½�pw��������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1�����ۣ�������һ��E-LINEҵ��Ļ������½�pw�����½�pw��������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====������һ��E-LINEҵ��Ļ������½�pw�����½�pw��������  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====������һ��E-LINEҵ��Ļ������½�ac�����½�ac��������  ���Կ�ʼ=====\n"
        lappend flag3_case4 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "400" $testPort5]
        lappend flag3_case4 [gwd::GWAc_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac400" "" $testPort5  400 0 "nochange" 1 0 0 "0x8100"]
        lappend flag3_case4 [gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac400" "pw2" "eline2"]
        lappend flag3_case4 [gwd::GWpublic_addAcBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "ac400" $cirwidth3 $pirwidth3]
        lappend flag3_case4 [gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac400" "enable"]
        lappend flag3_case4 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac400"]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag3_case4]} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC2�����ۣ�������һ��E-LINEҵ��Ļ������½�ac�����½�ac��������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2�����ۣ�������һ��E-LINEҵ��Ļ������½�ac�����½�ac��������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====������һ��E-LINEҵ��Ļ������½�ac�����½�ac��������  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�޸��½�E-LINEҵ���lsp��pw��ac�Ĵ��������ͳ�Ʋ��鿴�޸ĺ����Ϣ  ���Կ�ʼ=====\n"
        lappend flag4_case4 [gwd::GWStaLsp_AddLspEn $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" "shutdown"]
        lappend flag4_case4 [gwd::GWpublic_addBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" "60000"]
        lappend flag4_case4 [gwd::GWStaLsp_AddLspEn $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" "undo shutdown"]
        lappend flag4_case4 [gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" "disable"]
        lappend flag4_case4 [gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"]
        
        lappend flag4_case4 [gwd::GWpublic_addPwBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "60000" "90000"]
        lappend flag4_case4 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "disable"]
        lappend flag4_case4 [gwd::GWpublic_addPwWordEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "enable"]
        lappend flag4_case4 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" result]
        
        lappend flag4_case4 [gwd::GWpublic_addAcBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "ac400" "60000" "90000"]
        lappend flag4_case4 [gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac400" "disable"]
        lappend flag4_case4 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac400"]
        lappend flag4_case4 [gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag4_case4]} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC3�����ۣ��޸��½�E-LINEҵ���lsp��pw��ac�Ĵ��������ͳ�Ʋ��鿴�޸ĺ����Ϣ" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3�����ۣ��޸��½�E-LINEҵ���lsp��pw��ac�Ĵ��������ͳ�Ʋ��鿴�޸ĺ����Ϣ" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�޸��½�E-LINEҵ���lsp��pw��ac�Ĵ��������ͳ�Ʋ��鿴�޸ĺ����Ϣ  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�����豸�����󣬲�������E-LINEҵ���Ƿ����仯  ���Կ�ʼ=====\n"
	#������ǰ���lsp pw ac���ݲ�����ֵ
	set lsp1_con "null"
	set pw1_con "null"
	set ac200_con "null"
	set lsp2_con "null"
	set pw2_con "null"
	set ac400_con "null"
	
	set lsp1_con1 ""
	set pw1_con1 ""
	set ac200_con1 ""
	set lsp2_con1 ""
	set pw2_con1 ""
	set ac400_con1 ""
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]} {
		incr showMpls -1
	}
	regexp {interface lsp tunnel lsp1.*?exit} $result lsp1_con
	regexp {interface pw pw1.*?exit} $result pw1_con
	regexp {interface ac ac200.*?exit} $result ac200_con
	regexp {interface lsp tunnel lsp2.*?exit} $result lsp2_con
	regexp {interface pw pw2.*?exit} $result pw2_con
	regexp {interface ac ac400.*?exit} $result ac400_con
	
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1] 
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]} {
		incr showMpls -1
	}
	regexp {interface lsp tunnel lsp1.*?exit} $result1 lsp1_con1
	regexp {interface pw pw1.*?exit} $result1 pw1_con1
	regexp {interface ac ac200.*?exit} $result1 ac200_con1
	regexp {interface lsp tunnel lsp2.*?exit} $result1 lsp2_con1
	regexp {interface pw pw2.*?exit} $result1 pw2_con1
	regexp {interface ac ac400.*?exit} $result1 ac400_con1
	if {[string match $lsp1_con $lsp1_con1]} {
		gwd::GWpublic_print "OK" "��������ǰ��lsp1������û�з����仯" $fileId
	} else {
		set flag5_case4 1
		gwd::GWpublic_print "NOK" "��������ǰ��lsp1�����ݷ����仯" $fileId
	}
	if {[string match $pw1_con $pw1_con1]} {
		gwd::GWpublic_print "OK" "��������ǰ��pw1������û�з����仯" $fileId
	} else {
		set flag5_case4 1
		gwd::GWpublic_print "NOK" "��������ǰ��pw1�����ݷ����仯" $fileId
	}
	if {[string match $ac200_con $ac200_con1]} {
		gwd::GWpublic_print "OK" "��������ǰ��ac200������û�з����仯" $fileId
	} else {
		set flag5_case4 1
		gwd::GWpublic_print "NOK" "��������ǰ��ac200�����ݷ����仯" $fileId
	}
	if {[string match $lsp2_con $lsp2_con1]} {
		gwd::GWpublic_print "OK" "��������ǰ��lsp2������û�з����仯" $fileId
	} else {
		set flag5_case4 1
		gwd::GWpublic_print "NOK" "��������ǰ��lsp2�����ݷ����仯" $fileId
	}
	if {[string match $pw2_con $pw2_con1]} {
		gwd::GWpublic_print "OK" "��������ǰ��pw2������û�з����仯" $fileId
	} else {
		set flag5_case4 1
		gwd::GWpublic_print "NOK" "��������ǰ��pw2�����ݷ����仯" $fileId
	}
	if {[string match $ac400_con $ac400_con1]} {
		gwd::GWpublic_print "OK" "��������ǰ��ac400������û�з����仯" $fileId
	} else {
		set flag5_case4 1
		gwd::GWpublic_print "NOK" "��������ǰ��ac400�����ݷ����仯" $fileId
	}
	puts $fileId ""
	if {[regexp {[^0\s]} $flag5_case4]} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC4�����ۣ������豸�����󣬲�������E-LINEҵ������÷����仯" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4�����ۣ������豸�����󣬲�������E-LINEҵ�������û�з����仯" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�����豸�����󣬲�������E-LINEҵ���Ƿ����仯  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts "lsp1_con   $lsp1_con  \n\n"
	puts "pw1_con    $pw1_con   \n\n"
	puts "ac200_con  $ac200_con \n\n"
	puts "lsp2_con   $lsp2_con  \n\n"
	puts "pw2_con    $pw2_con   \n\n"
	puts "ac400_con  $ac400_con \n\n"
	puts "lsp1_con1  $lsp1_con1 \n\n"
	puts "pw1_con1   $pw1_con1  \n\n"
	puts "ac200_con1 $ac200_con1\n\n"
	puts "lsp2_con1  $lsp2_con1 \n\n"
	puts "pw2_con1   $pw2_con1  \n\n"
	puts "ac400_con1 $ac400_con1\n\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ���ڶ���ELINEҵ������ã������Ƿ���ɾ���ɹ����Ե�һ��ҵ����Ӱ��  ���Կ�ʼ=====\n"
	set lsp1_con "null"
	set pw1_con "null"
	set ac200_con "null"
	set lsp2_con "null"
	set pw2_con "null"
	set ac400_con "null"
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]} {
		incr showMpls -1
	}
	regexp {interface lsp tunnel lsp1.*?exit} $result lsp1_con
	regexp {interface pw pw1.*?exit} $result pw1_con
	regexp {interface ac ac200.*?exit} $result ac200_con
	regexp {interface lsp tunnel lsp2.*?exit} $result lsp2_con
	regexp {interface pw pw2.*?exit} $result pw2_con
	regexp {interface ac ac400.*?exit} $result ac400_con
	lappend flag6_case4 [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac400"]
	lappend flag6_case4 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac400"]
	lappend flag6_case4 [gwd::GWpublic_addPwBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" 0 0]
	lappend flag6_case4 [gwd::GWpublic_cfgPwHqosEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "disable"]
	lappend flag6_case4 [gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"]
	lappend flag6_case4 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"]
	lappend flag6_case4 [gwd::GWpublic_delLspStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"]
	lappend flag6_case4 [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"]
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]} {
		incr showMpls -1
	}
	set lsp1_con1 ""
	set pw1_con1 ""
	set ac200_con1 ""
	set lsp2_con1 ""
	set pw2_con1 ""
	set ac400_con1 ""
	regexp {interface lsp tunnel lsp1.*?exit} $result1 lsp1_con1
	regexp {interface pw pw1.*?exit} $result1 pw1_con1
	regexp {interface ac ac200.*?exit} $result1 ac200_con1
	regexp {interface lsp tunnel lsp2.*?exit} $result1 lsp2_con1
	regexp {interface pw pw2.*?exit} $result1 pw2_con1
	regexp {interface ac ac400.*?exit} $result1 ac400_con1
	if {$lsp2_con1 != ""} {
		set flag6_case4 1
		gwd::GWpublic_print "NOK" "ɾ��lsp2��鿴mpls����Ϣ��lsp2��������Ȼ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "ɾ��lsp2��鿴mpls����Ϣ��lsp2�����ñ�ɾ��" $fileId
	}
	if {$pw2_con1 != ""} {
		set flag6_case4 1
		gwd::GWpublic_print "NOK" "ɾ��pw2��鿴mpls����Ϣ��pw2��������Ȼ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "ɾ��pw2��鿴mpls����Ϣ��pw2�����ñ�ɾ��" $fileId
	}
	if {$ac400_con1 != ""} {
		set flag6_case4 1
		gwd::GWpublic_print "NOK" "ɾ��ac400��鿴mpls����Ϣ��ac400��������Ȼ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "ɾ��ac400��鿴mpls����Ϣ��ac400�����ñ�ɾ��" $fileId
	}
	if {[string match $lsp1_con $lsp1_con1]} {
		gwd::GWpublic_print "OK" "ɾ���ڶ���ELINEҵ���lsp1������û�з����仯" $fileId
	} else {
		set flag6_case4 1
		gwd::GWpublic_print "NOK" "ɾ���ڶ���ELINEҵ���lsp1�����ݷ����仯" $fileId
	}
	if {[string match $pw1_con $pw1_con1]} {
		gwd::GWpublic_print "OK" "ɾ���ڶ���ELINEҵ���pw1������û�з����仯" $fileId
	} else {
		set flag6_case4 1
		gwd::GWpublic_print "NOK" "ɾ���ڶ���ELINEҵ���pw1�����ݷ����仯" $fileId
	}
	if {[string match $ac200_con $ac200_con1]} {
		gwd::GWpublic_print "OK" "ɾ���ڶ���ELINEҵ���ac200������û�з����仯" $fileId
	} else {
		set flag6_case4 1
		gwd::GWpublic_print "NOK" "ɾ���ڶ���ELINEҵ���ac200�����ݷ����仯" $fileId
	}
	puts $fileId ""
	if {[regexp {[^0\s]} $flag6_case4]} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC5�����ۣ�ɾ���ڶ���ELINEҵ������ã�ɾ��ʧ�ܻ�Ե�һ��ҵ����Ӱ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5�����ۣ�ɾ���ڶ���ELINEҵ������ã�ɾ���ɹ����Ե�һ��ҵ����Ӱ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ���ڶ���ELINEҵ������ã������Ƿ���ɾ���ɹ����Ե�һ��ҵ����Ӱ��  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
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
	puts $fileId "Test Case 4 �½�E-LINEҵ�񣬲�������E-LINEҵ���Ƿ���Ӱ��  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 ����E-LAN��E-TREEҵ����֤�Ƿ���Ӱ��\n"
        #   <1>�ٴ���һ����E-LINEҵ��������ӦLSP��PW��AC���ɳɹ�������������֤��֮ǰ��������E-LINEҵ����Ӱ��
        #   <2>���Ѵ����õ�LSP/PW/AC�Ĵ�����Ϣ�����޸ģ��޸ĳɹ���ϵͳ���쳣
        #   <3>�鿴ϵͳ���Ѵ��ڵ�E-LINEҵ�񣬱������ã������豸���豸�����������������޶�ʧ
        #   <4>ɾ��E-LINEҵ��ʱ�����Ƚ�AC��PW�󶨹�ϵɾ�����ٰ���˳��ɾ��ac pw lsp 
        #   <5>ɾ��һ��E-LINEҵ��Ӱ����һ��
	set flag1_case5 0
	set flag2_case5 0
	set flag3_case5 0
	set flag4_case5 0
	set flag5_case5 0
	set flag6_case5 0
	set flag7_case5 0
	set flag8_case5 0
	
        #ɾ��֮ǰ��һ��Eline------
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac200"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac200"
        gwd::GWpublic_addPwBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" 0 0
        gwd::GWpublic_cfgPwHqosEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "disable"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWpublic_delLspStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"
        gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"
        gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result
	#------ɾ��֮ǰ��һ��Eline
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�޸�vpls�����ò�����������  ���Կ�ʼ=====\n"
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "false" "false" "false" "true" "2000" "" ""
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	if {[gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "false" "false" "false" "true" "2500" "" ""]} {
		set flag1_case5 1
		gwd::GWpublic_print "NOK" "�޸�vpls������mac��ַѧϰ�����Ĳ������޸�ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "�޸�vpls������mac��ַѧϰ�����Ĳ������޸ĳɹ�" $fileId
	}
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	if {[gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "true" "false" "false" "true" "2000" "" ""]} {
		set flag1_case5 1
		gwd::GWpublic_print "NOK" "�޸�vpls�����й㲥ת�����Ʋ������޸�ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "�޸�vpls�����й㲥ת�����Ʋ������޸ĳɹ�" $fileId
	}
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	if {[gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "false" "true" "false" "true" "2000" "" ""]} {
		set flag1_case5 1
		gwd::GWpublic_print "NOK" "�޸�vpls�������鲥ת�����Ʋ������޸�ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "�޸�vpls�������鲥ת�����Ʋ������޸ĳɹ�" $fileId
	}
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	if {[gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "false" "false" "true" "true" "2000" "" ""]} {
		set flag1_case5 1
		gwd::GWpublic_print "NOK" "�޸�vpls������δ֪����ת�����Ʋ������޸�ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "�޸�vpls������δ֪����ת�����Ʋ������޸ĳɹ�" $fileId
	}
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	if {[gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "false" "false" "false" "false" "2000" "" ""]} {
		set flag1_case5 1
		gwd::GWpublic_print "NOK" "�޸�vpls������mac��ַѧϰ���Ʋ������޸�ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "�޸�vpls������mac��ַѧϰ���Ʋ������޸ĳɹ�" $fileId
	}
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	if {[gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "discard" "false" "false" "false" "true" "2000" "" ""]} {
		set flag1_case5 1
		gwd::GWpublic_print "NOK" "�޸�vpls�����е�mac��ַת����full�Ժ������������Ŀ��Ʋ������޸�ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "�޸�vpls�����е�mac��ַת����full�Ժ������������Ŀ��Ʋ������޸ĳɹ�" $fileId
	}
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	
	puts $fileId ""
	if {[regexp {[^0\s]} $flag1_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC6�����ۣ��޸�vpls�����ò�������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6�����ۣ��޸�vpls�����ò�������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�޸�vpls�����ò�������  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�½�ELANҵ�񣬲����Ƿ��ܴ����ɹ�  ���Կ�ʼ=====\n"
        lappend flag2_case5 [PTN_NNI_AddInterIp $fileId $Worklevel $interface4 $ip13 $testPort2 $matchType1 $Gpn_type1 $telnet1]
        lappend flag2_case5 [PTN_NNI_AddInterIp $fileId $Worklevel $interface5 $ip14 $testPort4 $matchType1 $Gpn_type1 $telnet1]
	if {[string match "L2" $Worklevel]} {
		lappend flag2_case5 [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort2 "enable"]
        	lappend flag2_case5 [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort4 "enable"]
	}
        lappend flag2_case5 [gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "false" "false" "false" "true" "2000" "" ""]
        lappend flag2_case5 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3" $interface4 $ip31 "200" "200" "normal" "5"]
        lappend flag2_case5 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3" $address13]
        lappend flag2_case5 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3"]
        lappend flag2_case5 [gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3"]
        lappend flag2_case5 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6" $interface5 $ip41 "500" "600" "normal" "6"]
        lappend flag2_case5 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6" $address14]
        lappend flag2_case5 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6"]
        lappend flag2_case5 [gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6"]
        lappend flag2_case5 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" "vpls" "vpls1" "peer" $address13 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "5"]
        lappend flag2_case5 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw6" "vpls" "vpls1" "peer" $address14 "1000" "1100" "" "nochange" "none" 1 0 "0x8100" "0x8100" "6"]
        lappend flag2_case5 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" result]
        lappend flag2_case5 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw6" result]
        lappend flag2_case5 [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "ethernet" $testPort5 "0" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"]
        lappend flag2_case5 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag2_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC7�����ۣ��½�ELANҵ�񣬴���ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7�����ۣ��½�ELANҵ�񣬴����ɹ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�½�ELANҵ�񣬲����Ƿ��ܴ����ɹ�  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���ɾ��ELANҵ��ac�Ĳ���  ���Կ�ʼ=====\n"
        if {[gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"]} {
        	set flag3_case5 1
        	gwd::GWpublic_print "NOK" "��ɾ��vpls��ɾ��acʧ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "��ɾ��vpls��ɾ��ac�ɹ�" $fileId
        }
        if {[gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "ethernet" $testPort5 "0" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"]} {
        	set flag3_case5 1
        	gwd::GWpublic_print "NOK" "ɾ��ac���������ac�����ʧ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ɾ��ac���������ac����ӳɹ�" $fileId
        }
	puts $fileId ""
	if {[regexp {[^0\s]} $flag3_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC8�����ۣ����ɾ��ELANҵ��ac�Ĳ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8�����ۣ����ɾ��ELANҵ��ac�Ĳ���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���ɾ��ELANҵ��ac�Ĳ���  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ��ac������acΪport+vlanģʽ  ���Կ�ʼ=====\n"
	lappend flag4_case5 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"]
	lappend flag4_case5 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "11" $testPort5]
	lappend flag4_case5 [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac11" "vpls1" "ethernet" $testPort5 "11" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag4_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC9�����ۣ�ɾ��ac������acΪport+vlanģʽ" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC9�����ۣ�ɾ��ac������acΪport+vlanģʽ" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ��ac������acΪport+vlanģʽ  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���Ա���������ELANҵ��������Ƿ�ı�  ���Կ�ʼ=====\n"
	set vpls1_con "null"
	set lsp3_con "null"
	set lsp6_con "null"
	set pw3_con "null"
	set pw6_con "null"
	set ac11_con "null"
	
	set vpls1_con1 ""
	set lsp3_con1 ""
	set lsp6_con1 ""
	set pw3_con1 ""
	set pw6_con1 ""
	set ac11_con1 "" 
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]} {
		incr showMpls -1
	}
	regexp -line {mpls static vpls domain vpls1.+} $result vpls1_con
	regexp {interface lsp tunnel lsp3.*?exit} $result lsp3_con
	regexp {interface lsp tunnel lsp6.*?exit} $result lsp6_con
	regexp {interface pw pw3.*?exit} $result pw3_con
	regexp {interface pw pw6.*?exit} $result pw6_con
	regexp {interface ac ac11.*?exit} $result ac11_con
		
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]} {
		incr showMpls -1
	}
	regexp -line {mpls static vpls domain vpls1.+} $result vpls1_con1
	regexp {interface lsp tunnel lsp3.*?exit} $result lsp3_con1
	regexp {interface lsp tunnel lsp6.*?exit} $result lsp6_con1
	regexp {interface pw pw3.*?exit} $result pw3_con1
	regexp {interface pw pw6.*?exit} $result pw6_con1
	regexp {interface ac ac11.*?exit} $result ac11_con1
	if {[string match $vpls1_con $vpls1_con1]} {
		gwd::GWpublic_print "OK" "��������ǰ��vpls1������û�з����仯" $fileId
	} else {
		set flag5_case5 1
		gwd::GWpublic_print "NOK" "��������ǰ��vpls1�����ݷ����仯" $fileId
	}
	if {[string match $lsp3_con $lsp3_con1]} {
		gwd::GWpublic_print "OK" "��������ǰ��lsp3������û�з����仯" $fileId
	} else {
		set flag5_case5 1
		gwd::GWpublic_print "NOK" "��������ǰ��lsp3�����ݷ����仯" $fileId
	}
	if {[string match $lsp6_con $lsp6_con1]} {
		gwd::GWpublic_print "OK" "��������ǰ��lsp6������û�з����仯" $fileId
	} else {
		set flag5_case5 1
		gwd::GWpublic_print "NOK" "��������ǰ��lsp6�����ݷ����仯" $fileId
	}
	
	if {[string match $pw3_con $pw3_con1]} {
		gwd::GWpublic_print "OK" "��������ǰ��pw3������û�з����仯" $fileId
	} else {
		set flag5_case5 1
		gwd::GWpublic_print "NOK" "��������ǰ��pw3�����ݷ����仯" $fileId
	}
	if {[string match $pw6_con $pw6_con1]} {
		gwd::GWpublic_print "OK" "��������ǰ��pw6������û�з����仯" $fileId
	} else {
		set flag5_case5 1
		gwd::GWpublic_print "NOK" "��������ǰ��pw6�����ݷ����仯" $fileId
	}
	if {[string match $ac11_con $ac11_con1]} {
		gwd::GWpublic_print "OK" "��������ǰ��ac1������û�з����仯" $fileId
	} else {
		set flag5_case5 1
		gwd::GWpublic_print "NOK" "��������ǰ��ac1�����ݷ����仯" $fileId
	}
	puts $fileId ""
	if {[regexp {[^0\s]} $flag5_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD1�����ۣ�����������ELANҵ������û�ı�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD1�����ۣ�����������ELANҵ�������û�иı�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���Ա���������ELANҵ��������Ƿ�ı�  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ�����õ�ɾ��  ���Կ�ʼ=====\n"
        lappend flag6_case5 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac11"]
        lappend flag6_case5 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"]
        lappend flag6_case5 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw6"]
        lappend flag6_case5 [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3"]
        lappend flag6_case5 [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6"]
        lappend flag6_case5 [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"]
	set vpls1_con1 ""
	set lsp3_con1 ""
	set lsp6_con1 ""
	set pw3_con1 ""
	set pw6_con1 ""
	set ac11_con1 ""
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]} {
		incr showMpls -1
	}
	regexp -line {mpls static vpls domain vpls1.+} $result vpls1_con1
	regexp {interface lsp tunnel lsp3.*?exit} $result lsp3_con1
	regexp {interface lsp tunnel lsp6.*?exit} $result lsp6_con1
	regexp {interface pw pw3.*?exit} $result pw3_con1
	regexp {interface pw pw6.*?exit} $result pw6_con1
	regexp {interface ac ac11.*?exit} $result ac11_con1
	if {$vpls1_con1 != ""} {
		set flag6_case5 1
		gwd::GWpublic_print "NOK" "ɾ��vpls1��鿴mpls����Ϣ��vpls1��������Ȼ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "ɾ��vpls1��鿴mpls����Ϣ��vpls1�����ñ�ɾ��" $fileId
	}
	if {$lsp3_con1 != ""} {
		set flag6_case5 1
		gwd::GWpublic_print "NOK" "ɾ��lsp3��鿴mpls����Ϣ��lsp3��������Ȼ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "ɾ��lsp3��鿴mpls����Ϣ��lsp3�����ñ�ɾ��" $fileId
	}
	if {$lsp6_con1 != ""} {
		set flag6_case5 1
		gwd::GWpublic_print "NOK" "ɾ��lsp6��鿴mpls����Ϣ��lsp6��������Ȼ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "ɾ��lsp6��鿴mpls����Ϣ��lsp6�����ñ�ɾ��" $fileId
	}
	if {$pw3_con1 != ""} {
		set flag6_case5 1
		gwd::GWpublic_print "NOK" "ɾ��pw3��鿴mpls����Ϣ��pw3��������Ȼ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "ɾ��pw3��鿴mpls����Ϣ��pw3�����ñ�ɾ��" $fileId
	}
	if {$pw6_con1 != ""} {
		set flag6_case5 1
		gwd::GWpublic_print "NOK" "ɾ��pw6��鿴mpls����Ϣ��pw6��������Ȼ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "ɾ��pw6��鿴mpls����Ϣ��pw6�����ñ�ɾ��" $fileId
	}
	if {$ac11_con1 != ""} {
		set flag6_case5 1
		gwd::GWpublic_print "NOK" "ɾ��ac1��鿴mpls����Ϣ��ac1��������Ȼ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "ɾ��ac1��鿴mpls����Ϣ��ac1�����ñ�ɾ��" $fileId
	}
	puts $fileId ""
	if {[regexp {[^0\s]} $flag6_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD2�����ۣ�ELANҵ�����õ�ɾ������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD2�����ۣ�ELANҵ�����õ�ɾ������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELANҵ�����õ�ɾ��  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�½�ETREEҵ�񣬲����Ƿ��ܴ����ɹ�  ���Կ�ʼ=====\n"
	lappend flag7_case5 [gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls2" "2" "etree" "flood" "false" "false" "false" "true" "3000" "" ""]
	lappend flag7_case5 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp4" $interface4 $ip31 "200" "200" "normal" "4"]
	lappend flag7_case5 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp4" $address13]
	lappend flag7_case5 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp4"]
	lappend flag7_case5 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw4" "vpls" "vpls2" "peer" $address13 "20" "20" "" "nochange" "root" 1 0 "0x8100" "0x8100" "4"] 
	lappend flag7_case5 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "12" $testPort5]
	lappend flag7_case5 [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac12" "vpls2" "ethernet" $testPort5 "12" "0" "leaf" "add" "12" "0" "0" "0x8100" "evc2"]
	
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]} {
		incr showMpls -1
	}
	puts $fileId ""
	if {[regexp {[^0\s]} $flag7_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD3�����ۣ��½�ETREEҵ�񣬴���ʧ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD3�����ۣ��½�ETREEҵ�񣬴����ɹ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====�½�ETREEҵ�񣬲����Ƿ��ܴ����ɹ�  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ��ETREEҵ�񣬲����Ƿ���ɾ���ɹ�  ���Կ�ʼ=====\n"
	lappend flag8_case5 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac12"]
	lappend flag8_case5 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw4"]
	lappend flag8_case5 [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp4"]
	lappend flag8_case5 [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls2"]
	set vpls2_con1 ""
	set lsp4_con1 ""
	set pw4_con1 ""
	set ac12_con1 ""
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]} {
		incr showMpls -1
	}
	regexp -line {mpls static vpls domain vpls2.+} $result vpls2_con1
	regexp {interface lsp tunnel lsp4.*?exit} $result lsp4_con1
	regexp {interface pw pw4.*?exit} $result pw4_con1
	regexp {interface ac ac12.*?exit} $result ac12_con1
	if {$vpls2_con1 != ""} {
		set flag8_case5 1
		gwd::GWpublic_print "NOK" "ɾ��vpls2��鿴mpls����Ϣ��vpls2��������Ȼ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "ɾ��vpls2��鿴mpls����Ϣ��vpls2�����ñ�ɾ��" $fileId
	}
	if {$lsp4_con1 != ""} {
		set flag8_case5 1
		gwd::GWpublic_print "NOK" "ɾ��lsp4��鿴mpls����Ϣ��lsp4��������Ȼ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "ɾ��lsp4��鿴mpls����Ϣ��lsp4�����ñ�ɾ��" $fileId
	}
	if {$pw4_con1 != ""} {
		set flag8_case5 1
		gwd::GWpublic_print "NOK" "ɾ��pw4��鿴mpls����Ϣ��pw4��������Ȼ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "ɾ��pw4��鿴mpls����Ϣ��pw4�����ñ�ɾ��" $fileId
	}
	if {$ac12_con1 != ""} {
		set flag8_case5 1
		gwd::GWpublic_print "NOK" "ɾ��ac12��鿴mpls����Ϣ��ac12��������Ȼ����" $fileId
	} else {
		gwd::GWpublic_print "OK" "ɾ��ac12��鿴mpls����Ϣ��ac12�����ñ�ɾ��" $fileId
	}
	
	puts $fileId ""
	if {[regexp {[^0\s]} $flag8_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD4�����ۣ�ETREEҵ�����õ�ɾ������" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD4�����ۣ�ETREEҵ�����õ�ɾ������" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ��ETREEҵ�񣬲����Ƿ���ɾ���ɹ�  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
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
	puts $fileId "Test Case 5 ����E-LAN��E-TREEҵ����֤�Ƿ���Ӱ��\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===�ָ���ʼ������...\n"
	if {[string match "L2" $Worklevel]} {
                lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort1 "none"]
                lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort3 "none"]
                lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort2 "none"]
                lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort4 "none"]
	}
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface8 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface9 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface1 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface4 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface6 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface3 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface5 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface7 $matchType1 $Gpn_type1 $telnet1]
	foreach port $lDev1TestPort {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend flagDel [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "enable" "disable"]
		}
	}
	lappend flagDel [gwd::GWpublic_addPwLabelRange $telnet1 $matchType1 $Gpn_type1 $fileId "16" "2047" "2048" "1048575"]
	#�޸ı�ǩ��Χ�豣���������޸Ĳ���Ч
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_001"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_001"
	
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_001����Ŀ�ģ�E-LINE/E-LAN/E-TREEҵ�񴴽����޸ġ�ɾ���ͱ������\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1 == 1 || $flagCase2 == 1 || $flagCase3 == 1 || $flagCase4 == 1 || $flagCase5 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_001���Խ��" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5���Խ��" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����lspʱ���ò�����Ҫ���lsp���֣�����[expr {($flag1_case1 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����lspʱ���ô���Ľӿ�Vlan����һ��ip������[expr {($flag2_case1 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����lspʱ���ô�������ǩ������ǩ��lspId������[expr {($flag3_case1 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����������lspʱ�����������ö���ȷ������[expr {($flag4_case1 == 1) ? "ʧ��" : "�ɹ�"}]" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�lsp�ļ������" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�lsp�Ĵ��������ͳ�����ò���" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����pwʱ���ò�����Ҫ���pw���֣�����[expr {($flag1_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����pwʱ���ô���Ĳ���������[expr {($flag2_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�pw��̬��ǩ�Ͷ�̬��ǩ��Χ�����ò���" $fileId
	gwd::GWpublic_print "== FB1 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�pw��������ò���" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�ʹ��/ȥʹ��pw����ͳ�Ƶ����ò���" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�ʹ��/ȥʹ��pw�����ֵ����ò���" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�����acʱ���ò�����Ҫ���ac���֣�����[expr {($flag1_case3 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag2_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�����acʱʹ�õĶ˿ںź�vlan��������" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag3_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�ac��pw�Ĳ���" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag4_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�ac���ô���Ͷ˿�ͳ�ƵĲ���" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag5_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�ɾ��ac����󶨵Ĳ���" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�������һ��E-LINEҵ��Ļ������½�lsp�����½�lsp��������" $fileId
	gwd::GWpublic_print "== FC1 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�������һ��E-LINEҵ��Ļ������½�pw�����½�pw��������" $fileId
	gwd::GWpublic_print "== FC2 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�������һ��E-LINEҵ��Ļ������½�ac�����½�ac��������" $fileId
	gwd::GWpublic_print "== FC3 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ��޸��½�E-LINEҵ���lsp��pw��ac�Ĵ��������ͳ�Ʋ��鿴�޸ĺ����Ϣ" $fileId
	gwd::GWpublic_print "== FC4 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ������豸�����󣬲�������E-LINEҵ�������[expr {($flag5_case4 == 1) ? "" : "û��"}]�����仯" $fileId
	gwd::GWpublic_print "== FC5 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�ɾ���ڶ���ELINEҵ������ã�ɾ��ʧ�ܻ�Ե�һ��ҵ��[expr {($flag6_case4 == 1) ? "��" : "û��"}]Ӱ��" $fileId
	gwd::GWpublic_print "== FC6 == [expr {($flag1_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ��޸�vpls�����ò�������" $fileId
	gwd::GWpublic_print "== FC7 == [expr {($flag2_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ��½�ELANҵ�񣬴���[expr {($flag2_case5 == 1) ? "ʧ��" : "�ɹ�"}]" $fileId
	gwd::GWpublic_print "== FC8 == [expr {($flag3_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ����ɾ��ELANҵ��ac�Ĳ���" $fileId
	gwd::GWpublic_print "== FC9 == [expr {($flag4_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�ɾ��ac������acΪport+vlanģʽ" $fileId
	gwd::GWpublic_print "== FD1 == [expr {($flag5_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�����������ELANҵ�������[expr {($flag2_case5 == 1) ? "��" : "û��"}]�ı�" $fileId
	gwd::GWpublic_print "== FD2 == [expr {($flag6_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�ELANҵ�����õ�ɾ������" $fileId
	gwd::GWpublic_print "== FD3 == [expr {($flag7_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ��½�ETREEҵ�񣬴���[expr {($flag7_case5 == 1) ? "ʧ��" : "�ɹ�"}]" $fileId
	gwd::GWpublic_print "== FD4 == [expr {($flag8_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�ETREEҵ�����õ�ɾ������" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_001"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_001_REPORT.txt" "report\\NOK_GPN_PTN_001_REPORT.txt"
	file rename "log\\GPN_PTN_001_LOG.txt" "log\\NOK_GPN_PTN_001_LOG.txt"
} else {
	file rename "report\\GPN_PTN_001_REPORT.txt" "report\\OK_GPN_PTN_001_REPORT.txt"
	file rename "log\\GPN_PTN_001_LOG.txt" "log\\OK_GPN_PTN_001_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}
