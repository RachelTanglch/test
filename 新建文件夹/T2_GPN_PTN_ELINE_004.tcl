#!/bin/sh
# T2_GPN_PTN_ELINE_004.tcl \
exec tclsh "$0" ${1+"$@"}
#测试名称：ptn004
#-----------------------------------------------------------------------------------------------------------------------------------
#测试目的：E-LINE的稳定性
#1-报文攻击  
#2-内存泄露         
#-----------------------------------------------------------------------------------------------------------------------------------
#测试拓扑类型二：（仅以7600/S为例）                                                                                                                             
#                                                                              
#                                    ___________              ___________                               
#                                   |   4GE/ge  |____________| 4GE/ge    |
#  _______                          |   8fx     |____________| 8fx       |————————————TC2     
# |       |                         |           |____________|           |  
# |  PC   |_______Internet连接 ______|           |____________|           |
# |_______|                         |           |            |           |
#    /__\                           |GPN(7600/S)|            |           |       
#                        TC1————————|           |            |           |
#                                   |___________|            |GPN(7600/S)|
#                                          Internet——————————|___________| 
#                                                                         
#                                                                  				                     	           
#---------------------------------------------------------------------------------------------------------------------------------
#脚本运行条件：
#1、按照测试拓扑搭建测试环境:将GPN的管理端口（U/D）和PC的网口与Internet相连，GPN的2个上联口
#   与STC端口（ 9/9）（9/10）
#2、在GPN上清空所有 配置，建立管理vlan vid=4000，在该vlan上设置管理IP，并untagged方式添加管理端口（U/D）
#-----------------------------------------------------------------------------------------------------------------------------------
#测试过程：
#1、搭建Test Case 1测试环境
#   <1>3台设备，NE1--NE2--NE3，搭建E-LINE业务
#   <2>向NE1设备发送ARP攻击报文，速率100Mbps，业务数据应该不受影响，管理通道正常
#   <3>向NE1设备发送速率100Mbps业务报文，系统CPU利用率正常，管理通道正常
#2、搭建Test Case 2测试环境
#   <1>创建1条E-LINE业务， 配置相应的LSP、PW、AC，再删除该条业务，系统正常
#   <2>反复添加删除E-LINE实例500次，业务及管理正常，内存没有泄漏，系统无异常
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
        close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_004_LOG.txt" a]
        set stdout $fd_log
	log_file log\\GPN_PTN_004_LOG.txt
        chan configure $stdout -blocking 0 -buffering none;#非阻塞模式 按行flush
	
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_004_REPORT.txt" a+]
	chan configure $fileId -blocking 0 -buffering none;#非阻塞模式 按行flush
	
	file mkdir "debug"
	set fd_debug [open "debug\\GPN_PTN_004_DEBUG.txt" a]
	chan configure $fd_debug -blocking 0 -buffering none;#非阻塞模式 按行flush

	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl
	
        array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
        array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "500" -pri "000"}
        array set dataArr3 {-srcMac "00:00:00:00:00:03" -dstMac "00:00:00:00:00:33" -srcIp "192.85.1.3" -dstIp "192.0.0.3"}
        array set dataArr4 {-srcMac "00:00:00:00:00:04" -dstMac "00:00:00:00:00:44" -srcIp "192.85.1.4" -dstIp "192.0.0.4" -vid "500" -pri "000"}
        array set dataArr5 {-srcMac "00:00:00:00:00:05" -dstMac "ff:ff:ff:ff:ff:ff" -operation "1" -senderHwAddr "00:00:00:00:00:05" -senderPAddr "192.10.10.1" -targetHwAddr "00:00:00:00:00:00" -targetPAddr "192.1.1.1"}
        array set dataArr8 {-srcMac "00:00:00:00:00:08" -dstMac "00:00:00:00:00:88" -srcIp "192.85.1.8" -dstIp "192.0.0.8" -vid1 "1000" -pri1 "000" -vid2 "100" -pri2 "000"}
        array set dataArr9 {-srcMac "00:00:00:00:00:09" -dstMac "00:00:00:00:00:99" -srcIp "192.85.1.9" -dstIp "192.0.0.9" -vid1 "1000" -pri1 "000" -vid2 "100" -pri2 "000"}
        array set dataArr10 {-srcMac "00:00:00:00:00:0a" -dstMac "00:00:00:00:00:aa" -srcIp "192.85.1.10" -dstIp "192.0.0.10" -vid "800" -pri "000"}
        array set dataArr11 {-srcMac "00:00:00:00:00:0b" -dstMac "00:00:00:00:00:bb" -srcIp "192.85.1.11" -dstIp "192.0.0.11" -vid "800" -pri "000"}
        array set dataArr12 {-srcMac "00:00:00:00:00:0c" -dstMac "00:00:00:00:00:cc" -srcIp "192.85.1.12" -dstIp "192.0.0.12"}
        array set dataArr13 {-srcMac "00:00:00:00:00:0d" -dstMac "00:00:00:00:00:dd" -srcIp "192.85.1.13" -dstIp "192.0.0.13"}
        #设置定制信息参数
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        
        #设置发生器参数
        set GenCfg {-SchedulingMode RATE_BASED}
        
	###设置过滤分析器参数
	##匹配smc
	set anaFliFrameCfg0 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	##匹配smc、vid、EtherType
	set anaFliFrameCfg1 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType><vlans name="anon_2561"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	##匹配两层vid
	set anaFliFrameCfg4 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5580"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	
	set flagCase1 0   ;#Test case 1标志位 
	set flagCase2 0   ;#Test case 2标志位
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
	#为测试结论预留空行
	for {set i 0} {$i < 80} {incr i} {
	    puts $fileId "                                                                                                                                                                                                                "	
	}
	puts $fileId "登录被测设备...\n"
	puts $fileId "\n=====登录被测设备1====\n"
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	puts $fileId "\n=====登录被测设备2====\n"
	set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
	puts $fileId "\n=====登录被测设备3====\n"
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	#用于导出被测设备用到的变量------
	set lSpawn_id "$telnet1 $telnet2 $telnet3"
	set lMatchType "$matchType1 $matchType2 $matchType3"
	set lDutType "$Gpn_type1 $Gpn_type2 $Gpn_type3"
	set lIp "$gpnIp1 $gpnIp2 $gpnIp3"
	#------用于导出被测设备用到的变量
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "创建测试工程...\n"
	set hPtnProject [stc::create project]
	set lPortAttribute "$GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3 \"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort2 hGPNPort3 hGPNPort4
        #创建测试流量
        gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort3 hGPNPort3Stream1
        gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort3 hGPNPort3Stream2
        gwd::STC_Create_Stream $fileId dataArr3 $hGPNPort4 hGPNPort4Stream3
        gwd::STC_Create_VlanStream $fileId dataArr4 $hGPNPort4 hGPNPort4Stream4
        gwd::STC_Create_Stream_Arp $fileId dataArr5 $hGPNPort3 hGPNPort3Stream5
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr8 $hGPNPort3 hGPNPort3Stream8
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr9 $hGPNPort4 hGPNPort4Stream9
        gwd::STC_Create_VlanStream $fileId dataArr10 $hGPNPort2 hGPNPort2Stream10
        gwd::STC_Create_VlanStream $fileId dataArr11 $hGPNPort4 hGPNPort4Stream11
        gwd::STC_Create_Stream $fileId dataArr12 $hGPNPort2 hGPNPort2Stream12
        gwd::STC_Create_Stream $fileId dataArr13 $hGPNPort4 hGPNPort4Stream13
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort3Stream1 $hGPNPort3Stream2 $hGPNPort4Stream3 $hGPNPort4Stream4 $hGPNPort3Stream5 $hGPNPort3Stream8\
				$hGPNPort4Stream9 $hGPNPort2Stream10 $hGPNPort4Stream11 $hGPNPort2Stream12 $hGPNPort4Stream13" \
		-activate "false"

        ##获取发生器和分析器指针
        gwd::Get_Generator $hGPNPort2 hGPNPort2Gen
        gwd::Get_Analyzer $hGPNPort2 hGPNPort2Ana
        gwd::Get_Generator $hGPNPort3 hGPNPort3Gen
        gwd::Get_Analyzer $hGPNPort3 hGPNPort3Ana
        gwd::Get_Generator $hGPNPort4 hGPNPort4Gen
        gwd::Get_Analyzer $hGPNPort4 hGPNPort4Ana
	
	stc::config $hGPNPort2Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort3Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort4Ana -FilterOnStreamId "FALSE"
        ##定制收发信息
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort2 txInfoArr hGPNPort2TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort2 rxInfoArr1 hGPNPort2RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort2 rxInfoArr2 hGPNPort2RxInfo2
	
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort3 txInfoArr hGPNPort3TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort3 rxInfoArr1 hGPNPort3RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort3 rxInfoArr2 hGPNPort3RxInfo2
	
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort4 txInfoArr hGPNPort4TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort4 rxInfoArr1 hGPNPort4RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort4 rxInfoArr2 hGPNPort4RxInfo2

        #配置流的速率 10%，Mbps
        stc::config [stc::get $hGPNPort3Stream1 -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream2 -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream3 -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream4 -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream5 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream8 -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream9 -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort2Stream10 -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream11 -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort2Stream12 -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream13 -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        stc::apply
        #获取发生器配置指针
        gwd::Get_GeneratorCfgObj $hGPNPort2Gen hGPNPort2GenCfg
        gwd::Cfg_GeneratorCfgObj $hGPNPort2GenCfg $GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort3Gen hGPNPort3GenCfg
        gwd::Cfg_GeneratorCfgObj $hGPNPort3GenCfg $GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort4Gen hGPNPort4GenCfg
        gwd::Cfg_GeneratorCfgObj $hGPNPort4GenCfg $GenCfg
        #创建并配置过滤器，默认过滤tag
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort2Ana hGPNPort2AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort3Ana hGPNPort3AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1	
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
        if {$cap_enable} {
                #获取和配置capture对象相关的指针
                gwd::Get_Capture $hGPNPort2 hGPNPort2Cap
                gwd::Get_Capture $hGPNPort3 hGPNPort3Cap
                gwd::Get_Capture $hGPNPort4 hGPNPort4Cap
                gwd::Create_FilterAnalyzer $hGPNPort2Cap hGPNPort2CapFilter hGPNPort2CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort3Cap hGPNPort3CapFilter hGPNPort3CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort4Cap hGPNPort4CapFilter hGPNPort4CapAnalyzer
                array set capArr {capMode "REGULAR_MODE" capSource "Tx_Rx_MODE"}	
        }
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_004_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-LINE报文攻击内存泄露测试基础配置开始...\n"
	set cfgFlag 0
        set portList1 "$GPNPort5 $GPNTestEth2 $GPNTestEth3"
        foreach port $portList1 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
		}
        }
        set rebootSlotList1 [gwd::GWpulic_getWorkCardList $portList1]
        send_log "\n获取设备1业务板卡槽位号$rebootSlotList1\n"
	
        set portList2 "$GPNPort6 $GPNPort7"
        foreach port $portList2 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "disable" "enable"]
		}
        }
        set rebootSlotList2 [gwd::GWpulic_getWorkCardList $portList2]
        send_log "\n获取设备2业务板卡槽位号$rebootSlotList2\n"
	
        set portList3 "$GPNPort8 $GPNTestEth4"
        foreach port $portList3 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "disable" "enable"]
		}
        }
        set rebootSlotList3 [gwd::GWpulic_getWorkCardList $portList3]
	send_log "\n获取设备3业务板卡槽位号$rebootSlotList3\n"
        ###二三层接口配置参数
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
        	set interface23 v1000
        	set interface32 v500
        	set interface33 v500
        	set interface34 v800
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
        	set interface23 $GPNTestEth4.1000
        	set interface32 $GPNTestEth4.500
        	set interface33 $GPNTestEth3.500
        	set interface34 $GPNTestEth4.800
        }
	set ip1 192.1.1.1
	set ip2 192.1.1.2
	set ip3 192.1.2.3
	set ip4 192.1.2.4
	set address1 10.1.1.1
	set address2 10.1.1.2
	set address3 10.1.1.3
	set ip11 192.1.3.1
	set ip12 192.1.3.2
	set ip13 192.1.4.3
	set ip14 192.1.4.4
	set address11 10.1.2.1
	set address12 10.1.2.2
	set address13 10.1.2.3
	set rateL 95000000;#收发数据流取值最小值范围
	set rateR 105000000;#收发数据流取值最大值范围
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-LINE报文攻击内存泄露测试基础配置失败，测试结束" \
		"E-LINE报文攻击内存泄露测试基础配置成功，继续后面的测试" "GPN_PTN_004"
        puts $fileId ""
        puts $fileId "===E-LINE报文攻击内存泄露测试基础配置结束..."
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_004" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 E-LINE 报文攻击的测试\n"	
        #   <1>3台设备，NE1--NE2--NE3，搭建E-LINE业务
        #   <2>向NE1设备发送ARP攻击报文，速率100Mbps，业务数据应该不受影响，管理通道正常
        #   <3>向NE1设备发送速率100Mbps业务报文，系统CPU利用率正常，管理通道正常
	set flag1_case1 0
        set flag2_case1 0
        set flag3_case1 0
        puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)和NE3($gpnIp3)双向对发业务报文  测试开始=====\n"
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
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "2000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""	
	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "500" $GPNTestEth3
	gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "" $GPNTestEth3 500 0 "nochange" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "pw1" "eline11"
	gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "l2transport" "3" "" $address1 "3000" "4000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" result
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "1000" $GPNTestEth3
	gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "" $GPNTestEth3 1000 100 "nochange" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "pw2" "eline12"
	gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2 "disable"
	}
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface17 $ip11 $GPNPort5 $matchType1 $Gpn_type1 $telnet1
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" $interface17 $ip12 "21" "22" "normal" "5"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" $address11
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"
	gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" "l2transport" "5" "" $address11 "20" "30" "5" "nochange" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" result
	gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac3" "" $GPNTestEth2 0 0 "nochange" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac3" "pw3" "eline13"
	gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac3"
	
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface14 $ip2 $GPNPort6 $matchType2 $Gpn_type2 $telnet2
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface15 $ip3 $GPNPort7 $matchType2 $Gpn_type2 $telnet2
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface15 $ip4 "200" "300" "0" 2 "normal"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface14 $ip1 "400" "100" "0" 3 "normal"
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface18 $ip12 $GPNPort6 $matchType2 $Gpn_type2 $telnet2
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface19 $ip13 $GPNPort7 $matchType2 $Gpn_type2 $telnet2
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface19 $ip14 "22" "23" "0" 6 "normal"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface18 $ip11 "24" "21" "0" 7 "normal"
	
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface16 $ip4 $GPNPort8 $matchType3 $Gpn_type3 $telnet3
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" $interface16 $ip3 "300" "400" "normal" "4"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" $address3
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"
	gwd::GWpublic_showTunnelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address3 "2000" "1000" "4" "nochange" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "500" $GPNTestEth4
	gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 500 0 "nochange" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline31"
	gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw2" "l2transport" "4" "" $address3 "4000" "3000" "4" "nochange" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw2" result
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "1000" $GPNTestEth4
	gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000" "" $GPNTestEth4 1000 100 "nochange" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000" "pw2" "eline32"
	gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface20 $ip14 $GPNPort8 $matchType3 $Gpn_type3 $telnet3
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2" $interface20 $ip13 "23" "24" "normal" "8"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2" $address13
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2"
	gwd::GWpublic_showTunnelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw3" "l2transport" "6" "" $address13 "30" "20" "8" "nochange" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw3" result
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "800" $GPNTestEth4
	gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac3" "" $GPNTestEth4 800 0 "nochange" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac3" "pw3" "eline33"
	gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac3"
	
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream4 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort2Stream10 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream11 "TRUE"
        foreach i "aGPNPort3Cnt1 aGPNPort4Cnt1 aGPNPort2Cnt1 aGPNPort3Cnt11 aGPNPort4Cnt11 aGPNPort2Cnt11" {
		array set $i {cnt2 0 cnt4 0 cnt10 0 cnt11 0} 
        }
	if {$::cap_enable} {
        	gwd::Start_CapAllData ::capArr $hGPNPort2Cap $hGPNPort2CapAnalyzer
        	gwd::Start_CapAllData ::capArr $hGPNPort3Cap $hGPNPort3CapAnalyzer 
        	gwd::Start_CapAllData ::capArr $hGPNPort4Cap $hGPNPort4CapAnalyzer
	}
        gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen $::hGPNPort2Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana $::hGPNPort2Ana"
        after 10000
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 0 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 0 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort2Ana aGPNPort2Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 0 0 0
		after 5000
	}
	incr capId
	if {$cap_enable} {
        	gwd::Stop_CapData $hGPNPort2Cap 1 "GPN_PTN_004_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap"
		gwd::Stop_CapData $hGPNPort3Cap 1 "GPN_PTN_004_$capId-p$GPNTestEth3_cap\($gpnIp1).pcap"
        	gwd::Stop_CapData $hGPNPort4Cap 1 "GPN_PTN_004_$capId-p$GPNTestEth4_cap\($gpnIp3).pcap"
	}
	gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen $::hGPNPort2Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana $::hGPNPort2Ana"
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth3_cap\($gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth4_cap\($gpnIp3).pcap" $fileId
	if {$aGPNPort4Cnt1(cnt10) < $rateL || $aGPNPort4Cnt1(cnt10) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1 $GPNTestEth2\发送tag=800的数据流，NE3 $GPNTestEth4\收到tag=800的数据包的个数为$aGPNPort4Cnt1(cnt10)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1 $GPNTestEth2\发送tag=800的数据流，NE3 $GPNTestEth4\收到tag=800的数据包的个数为$aGPNPort4Cnt1(cnt10)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aGPNPort4Cnt1(cnt2)< $rateL || $aGPNPort4Cnt1(cnt2)> $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1 $GPNTestEth3\发送tag=500的数据流，NE3 $GPNTestEth4\收到tag=500的数据包的个数为$aGPNPort4Cnt1(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1 $GPNTestEth3\发送tag=500的数据流，NE3 $GPNTestEth4\收到tag=500的数据包的个数为$aGPNPort4Cnt1(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aGPNPort2Cnt1(cnt11)< $rateL || $aGPNPort2Cnt1(cnt11)> $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE3 $GPNTestEth4\发送tag=800的数据流，NE1 $GPNTestEth2\收到tag=800的数据包的个数为$aGPNPort2Cnt1(cnt11)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3 $GPNTestEth4\发送tag=800的数据流，NE1 $GPNTestEth2\收到tag=800的数据包的个数为$aGPNPort2Cnt1(cnt11)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aGPNPort3Cnt1(cnt4) < $rateL || $aGPNPort3Cnt1(cnt4) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE3 $GPNTestEth4\发送tag=500的数据流，NE1 $GPNTestEth3\收到tag=500的数据包的个数为$aGPNPort3Cnt1(cnt4)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3 $GPNTestEth4\发送tag=500的数据流，NE1 $GPNTestEth3\收到tag=500的数据包的个数为$aGPNPort3Cnt1(cnt4)，在$rateL-$rateR\范围内" $fileId
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1（结论）NE1($gpnIp1)和NE3($gpnIp3)双向对发业务报文的测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1（结论）NE1($gpnIp1)和NE3($gpnIp3)双向对发业务报文的测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)和NE3($gpnIp3)双向对发业务报文  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_004_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_004" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====向NE1($gpnIp1)设备发送ARP攻击报文双向对发业务是否受影响  测试开始=====\n"
        gwd::Cfg_StreamActive $hGPNPort3Stream5 "TRUE"
	if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort2Cap $hGPNPort2CapAnalyzer
		gwd::Start_CapAllData ::capArr $hGPNPort3Cap $hGPNPort3CapAnalyzer 
		gwd::Start_CapAllData ::capArr $hGPNPort4Cap $hGPNPort4CapAnalyzer
	}
        gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen $::hGPNPort2Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana $::hGPNPort2Ana"
        after $sendTime
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort3Ana aGPNPort3Cnt11]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 0 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort4Ana aGPNPort4Cnt11]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 0 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort2Ana aGPNPort2Cnt11]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 0 0 0
		after 5000
	}
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort2Cap 1 "GPN_PTN_004_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap"
		gwd::Stop_CapData $hGPNPort3Cap 1 "GPN_PTN_004_$capId-p$GPNTestEth3_cap\($gpnIp1).pcap"
		gwd::Stop_CapData $hGPNPort4Cap 1 "GPN_PTN_004_$capId-p$GPNTestEth4_cap\($gpnIp3).pcap"
	}
	gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen $::hGPNPort2Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana $::hGPNPort2Ana"
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth3_cap\($gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth4_cap\($gpnIp3).pcap" $fileId
	if {$aGPNPort4Cnt11(cnt10) < $rateL || $aGPNPort4Cnt11(cnt10) > $rateR} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE1 $GPNTestEth2\发送tag=800的数据流，NE3 $GPNTestEth4\收到tag=800的数据包的个数为$aGPNPort4Cnt11(cnt10)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE1 $GPNTestEth2\发送tag=800的数据流，NE3 $GPNTestEth4\收到tag=800的数据包的个数为$aGPNPort4Cnt11(cnt10)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aGPNPort4Cnt11(cnt2)< $rateL || $aGPNPort4Cnt11(cnt2)> $rateR} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE1 $GPNTestEth3\发送tag=500的数据流，NE3 $GPNTestEth4\收到tag=500的数据包的个数为$aGPNPort4Cnt11(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE1 $GPNTestEth3\发送tag=500的数据流，NE3 $GPNTestEth4\收到tag=500的数据包的个数为$aGPNPort4Cnt11(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aGPNPort2Cnt11(cnt11)< $rateL || $aGPNPort2Cnt11(cnt11)> $rateR} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE3 $GPNTestEth4\发送tag=800的数据流，NE1 $GPNTestEth2\收到tag=800的数据包的个数为$aGPNPort2Cnt11(cnt11)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE3 $GPNTestEth4\发送tag=800的数据流，NE1 $GPNTestEth2\收到tag=800的数据包的个数为$aGPNPort2Cnt11(cnt11)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aGPNPort3Cnt11(cnt4) < $rateL || $aGPNPort3Cnt11(cnt4) > $rateR} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE3 $GPNTestEth4\发送tag=500的数据流，NE1 $GPNTestEth3\收到tag=500的数据包的个数为$aGPNPort3Cnt11(cnt4)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE3 $GPNTestEth4\发送tag=500的数据流，NE1 $GPNTestEth3\收到tag=500的数据包的个数为$aGPNPort3Cnt11(cnt4)，在$rateL-$rateR\范围内" $fileId
	}
        gwd::Cfg_StreamActive $hGPNPort3Stream5 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort4Stream4 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream8 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream9 "TRUE"
        set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
        gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
        gwd::Cfg_StreamActive $hGPNPort3Stream5 "TRUE"
	incr capId
        sendAndStat41 "GPN_PTN_004_$capId" aGPNPort3Cnt4 aGPNPort3Cnt2 aGPNPort4Cnt4 aGPNPort4Cnt2 aGPNPort2Cnt1 aGPNPort4Cnt1
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth3_cap\($gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth4_cap\($gpnIp3).pcap" $fileId
        if {$aGPNPort3Cnt4(cnt8) < $rateL || $aGPNPort3Cnt4(cnt8) > $rateR ||$aGPNPort3Cnt2(cnt9) < $rateL || $aGPNPort3Cnt2(cnt9) > $rateR} {
        	set flag2_case1 1
        	gwd::GWpublic_print "NOK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE3 $GPNTestEth4\发送tag=1000/100的双层数据流，NE1 $GPNTestEth3\收到tag=1000/100双层数据包的个数为$aGPNPort3Cnt4(cnt8)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE3 $GPNTestEth4\发送tag=1000/100的双层数据流，NE1 $GPNTestEth3\收到tag=1000/100双层数据包的个数为$aGPNPort3Cnt4(cnt8)，在$rateL-$rateR\范围内" $fileId
        }
        if {$aGPNPort4Cnt4(cnt8)< $rateL || $aGPNPort4Cnt4(cnt8)> $rateR || $aGPNPort4Cnt2(cnt8)< $rateL || $aGPNPort4Cnt2(cnt8)> $rateR} {
        	set flag2_case1 1
        	gwd::GWpublic_print "NOK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE1 $GPNTestEth3\发送tag=1000/100的双层数据流，NE3 $GPNTestEth4\收到tag=1000/100双层数据包的个数为$aGPNPort4Cnt4(cnt8)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE1 $GPNTestEth3\发送tag=1000/100的双层数据流，NE3 $GPNTestEth4\收到tag=1000/100双层数据包的个数为$aGPNPort4Cnt4(cnt8)，在$rateL-$rateR\范围内" $fileId
        }
        if {$aGPNPort2Cnt1(cnt11) < $rateL || $aGPNPort2Cnt1(cnt11) > $rateR} {
        	set flag2_case1 1
        	gwd::GWpublic_print "NOK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE3 $GPNTestEth4\发送tag=800的单层数据流，NE1 $GPNTestEth2\收到tag=800的数据包个数为$aGPNPort2Cnt1(cnt11)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE3 $GPNTestEth4\发送tag=800的单层数据流，NE1 $GPNTestEth2\收到tag=800的数据包个数为$aGPNPort2Cnt1(cnt11)，在$rateL-$rateR\范围内" $fileId
        }
        if {$aGPNPort4Cnt1(cnt10)< $rateL || $aGPNPort4Cnt1(cnt10)> $rateR} {
        	set flag2_case1 1
        	gwd::GWpublic_print "NOK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE1 $GPNTestEth2\发送tag=800的单层数据流，NE3 $GPNTestEth4\收到tag=800的数据包个数为$aGPNPort4Cnt1(cnt10)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE1 $GPNTestEth2\发送tag=800的单层数据流，NE3 $GPNTestEth4\收到tag=800的数据包个数为$aGPNPort4Cnt1(cnt10)，在$rateL-$rateR\范围内" $fileId
        }
	gwd::Cfg_StreamActive $hGPNPort3Stream5 "FALSE"
        set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
        gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
        send_log "\n resource1:$resource1"
        send_log "\n resource2:$resource2"
        if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
        	set flag3_case1	1
        	gwd::GWpublic_print "NOK" "发送ARP攻击报文和业务报文之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "发送ARP攻击报文和业务报文之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
        }
        gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen $::hGPNPort2Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana $::hGPNPort2Ana"
        
        puts $fileId ""
        if {$flag2_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA2（结论）向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE1($gpnIp1)和NE3($gpnIp3)双向对发业务报文的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA2（结论）向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE1($gpnIp1)和NE3($gpnIp3)双向对发业务报文的测试" $fileId
        }
        if {$flag3_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA3（结论）在发送ARP和业务报文前与发送后相比，系统内存有变化" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA3（结论）在发送ARP和业务报文前与发送后相比，系统内存无变化" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====向NE1($gpnIp1)设备发送ARP攻击报文双向对发业务是否受影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_004_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_004" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
        puts $fileId "======================================================================================\n"
	if {$flagCase1 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 1测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 1测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 1 E-LINE 报文攻击的测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 反复增删E-LINE实例，系统管理业务测试\n"
        #   <1>创建1条E-LINE业务， 配置相应的LSP、PW、AC，再删除该条业务，系统正常
        #   <2>反复添加删除E-LINE实例500次，业务及管理正常，内存没有泄漏，系统无异常
        set flag1_case2 0
        set flag2_case2 0
        set flag3_case2 0
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource3
        
	for {set i 1} {$i<=$ptn004_case2_cnt} {incr i} {
		#删除一条ELINE实例后测试------
                gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac3"
                gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac3"
                gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"
                gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"
                gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"
                gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort7.400 $ip14 "22" "23" "0" 6 "normal"
                gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort6.300 $ip11 "24" "21" "0" 7 "normal"
                gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac3"
                gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac3"
                gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw3"
                gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw3"
                gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2"
		incr capId
                sendAndStat41 "GPN_PTN_004_$capId" aGPNPort3Cnt4 aGPNPort3Cnt2 aGPNPort4Cnt4 aGPNPort4Cnt2 aGPNPort2Cnt1 aGPNPort4Cnt1
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth3_cap\($gpnIp1).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth4_cap\($gpnIp3).pcap" $fileId
		if {$aGPNPort3Cnt4(cnt8) < $rateL || $aGPNPort3Cnt4(cnt8) > $rateR ||$aGPNPort3Cnt2(cnt9) < $rateL || $aGPNPort3Cnt2(cnt9) > $rateR} {
			set flag1_case2 1
			gwd::GWpublic_print "NOK" "第$i\次删除一条ELINE业务，另一条业务：NE3 $GPNTestEth4\发送tag=1000/100的双层数据流，NE1 $GPNTestEth3\收到tag=1000/100双层数据包的个数为$aGPNPort3Cnt4(cnt8)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "第$i\次删除一条ELINE业务，另一条业务：NE3 $GPNTestEth4\发送tag=1000/100的双层数据流，NE1 $GPNTestEth3\收到tag=1000/100双层数据包的个数为$aGPNPort3Cnt4(cnt8)，在$rateL-$rateR\范围内" $fileId
		}
		if {$aGPNPort4Cnt4(cnt8)< $rateL || $aGPNPort4Cnt4(cnt8)> $rateR || $aGPNPort4Cnt2(cnt8)< $rateL || $aGPNPort4Cnt2(cnt8)> $rateR} {
			set flag1_case2 1
			gwd::GWpublic_print "NOK" "第$i\次删除一条ELINE业务，另一条业务：NE1 $GPNTestEth3\发送tag=1000/100的双层数据流，NE3 $GPNTestEth4\收到tag=1000/100双层数据包的个数为$aGPNPort4Cnt4(cnt8)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "第$i\次删除一条ELINE业务，另一条业务：NE1 $GPNTestEth3\发送tag=1000/100的双层数据流，NE3 $GPNTestEth4\收到tag=1000/100双层数据包的个数为$aGPNPort4Cnt4(cnt8)，在$rateL-$rateR\范围内" $fileId
		}
		if {$aGPNPort2Cnt1(cnt11)!=0} {
			set flag1_case2 1
			gwd::GWpublic_print "NOK" "第$i\次删除一条ELINE业务，此条ELINE业务：NE3 $GPNTestEth4\发送tag=800的单层数据流，NE1 $GPNTestEth2\收到tag=800的数据包个数为$aGPNPort2Cnt1(cnt11)" $fileId
		} else {
			gwd::GWpublic_print "OK" "第$i\次删除一条ELINE业务，此条ELINE业务：NE3 $GPNTestEth4\发送tag=800的单层数据流，NE1 $GPNTestEth2\不能收到" $fileId
		}
		if {$aGPNPort4Cnt1(cnt10)!=0} {
			set flag1_case2 1
			gwd::GWpublic_print "NOK" "第$i\次删除一条ELINE业务，此条ELINE业务：NE1 $GPNTestEth2\发送tag=800的单层数据流，NE3 $GPNTestEth4\收到tag=800的数据包个数为$aGPNPort4Cnt1(cnt10)" $fileId
		} else {
			gwd::GWpublic_print "OK" "第$i\次删除一条ELINE业务，此条ELINE业务：NE1 $GPNTestEth2\发送tag=800的单层数据流，NE3 $GPNTestEth4\不能收到" $fileId
		}
                gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen $::hGPNPort2Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana $::hGPNPort2Ana"
		#------删除一条ELINE实例后测试
		#添加一条ELINE实例后测试------
                gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2" $interface20 $ip13 "23" "24" "normal" "8"
                gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2" $address13
                gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2"
                gwd::GWpublic_showTunnelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2"
                gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw3" "l2transport" "6" "" $address13 "30" "20" "8" "nochange" "" 1 0 "0x8100" "0x8100" ""
                gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw3" result
                gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac3" "" $GPNTestEth4 800 0 "nochange" 1 0 0 "0x8100"
                gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac3" "pw3" "eline34"
                gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac3"
                gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface19 $ip14 "22" "23" "0" 6 "normal"
                gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface18 $ip11 "24" "21" "0" 7 "normal"
                gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" $interface17 $ip12 "21" "22" "normal" "5"
                gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" $address11
                gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"
                gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"
                gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" "l2transport" "5" "" $address11 "20" "30" "5" "nochange" "" 1 0 "0x8100" "0x8100" ""
                gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" result
                gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac3" "" $GPNTestEth2 0 0 "nochange" 1 0 0 "0x8100"
                gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac3" "pw3" "eline14"
                gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac3"
		incr capId
                sendAndStat41 "GPN_PTN_004_$capId" aGPNPort3Cnt4 aGPNPort3Cnt2 aGPNPort4Cnt4 aGPNPort4Cnt2 aGPNPort2Cnt1 aGPNPort4Cnt1
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth3_cap\($gpnIp1).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_004_$capId-p$GPNTestEth4_cap\($gpnIp3).pcap" $fileId
		if {$aGPNPort3Cnt4(cnt8) < $rateL || $aGPNPort3Cnt4(cnt8) > $rateR ||$aGPNPort3Cnt2(cnt9) < $rateL || $aGPNPort3Cnt2(cnt9) > $rateR} {
			set flag1_case2 1
			gwd::GWpublic_print "NOK" "第$i\次恢复被删除的ELINE业务，NE3 $GPNTestEth4\发送tag=1000/100的双层数据流，NE1 $GPNTestEth3\收到tag=1000/100双层数据包的个数为$aGPNPort3Cnt4(cnt8)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "第$i\次恢复被删除的ELINE业务，NE3 $GPNTestEth4\发送tag=1000/100的双层数据流，NE1 $GPNTestEth3\收到tag=1000/100双层数据包的个数为$aGPNPort3Cnt4(cnt8)，在$rateL-$rateR\范围内" $fileId
		}
		if {$aGPNPort4Cnt4(cnt8)< $rateL || $aGPNPort4Cnt4(cnt8)> $rateR || $aGPNPort4Cnt2(cnt8)< $rateL || $aGPNPort4Cnt2(cnt8)> $rateR} {
			set flag1_case2 1
			gwd::GWpublic_print "NOK" "第$i\次恢复被删除的ELINE业务，NE1 $GPNTestEth3\发送tag=1000/100的双层数据流，NE3 $GPNTestEth4\收到tag=1000/100双层数据包的个数为$aGPNPort4Cnt4(cnt8)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "第$i\次恢复被删除的ELINE业务，NE1 $GPNTestEth3\发送tag=1000/100的双层数据流，NE3 $GPNTestEth4\收到tag=1000/100双层数据包的个数为$aGPNPort4Cnt4(cnt8)，在$rateL-$rateR\范围内" $fileId
		}
		if {$aGPNPort2Cnt1(cnt11) < $rateL || $aGPNPort2Cnt1(cnt11) > $rateR} {
			set flag1_case2 1
			gwd::GWpublic_print "NOK" "第$i\次恢复被删除的ELINE业务，NE3 $GPNTestEth4\发送tag=800的单层数据流，NE1 $GPNTestEth2\收到tag=800的数据包个数为$aGPNPort2Cnt1(cnt11)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "第$i\次恢复被删除的ELINE业务，NE3 $GPNTestEth4\发送tag=800的单层数据流，NE1 $GPNTestEth2\收到tag=800的数据包个数为$aGPNPort2Cnt1(cnt11)，在$rateL-$rateR\范围内" $fileId
		}
		if {$aGPNPort4Cnt1(cnt10)< $rateL || $aGPNPort4Cnt1(cnt10)> $rateR} {
			set flag1_case2 1
			gwd::GWpublic_print "NOK" "第$i\次恢复被删除的ELINE业务，NE1 $GPNTestEth2\发送tag=800的单层数据流，NE3 $GPNTestEth4\收到tag=800的数据包个数为$aGPNPort4Cnt1(cnt10)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "第$i\次恢复被删除的ELINE业务，NE1 $GPNTestEth2\发送tag=800的单层数据流，NE3 $GPNTestEth4\收到tag=800的数据包个数为$aGPNPort4Cnt1(cnt10)，在$rateL-$rateR\范围内" $fileId
		}
		gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen $::hGPNPort2Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana $::hGPNPort2Ana"
		#------添加一条ELINE实例后测试
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
	send_log "\n resource3:$resource3"
	send_log "\n resource4:$resource4"
	if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
		set flag2_case2	1
		gwd::GWpublic_print "NOK" "反复增删E-LINE实例之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "反复增删E-LINE实例之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA4（结论）反复增删E-LINE实例，NE1($gpnIp1)和NE3($gpnIp3)双向对发业务的测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4（结论）反复增删E-LINE实例，NE1($gpnIp1)和NE3($gpnIp3)双向对发业务的测试" $fileId
	}
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA5（结论）反复增删E-LINE实例之前与之后相比，系统内存有变化" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5（结论）反复增删E-LINE实例之前与之后相比，系统内存无变化" $fileId
	}
	puts $fileId ""
	puts $fileId "======================================================================================\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_004_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_004" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "Test Case 2 反复增删E-LINE实例，系统管理业务测试结束\n"
	if {$flagCase2 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 2测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 2测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===恢复初始化配置...\n"
        lappend flagDel [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"]
        lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"]
        lappend flagDel [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"]
        lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"]
        lappend flagDel [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac3"]
        lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac3"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"]
        lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]
        lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface1 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface17 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface33 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface21 $matchType1 $Gpn_type1 $telnet1]
	
	lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort7.200 $ip4 "200" "300" "0" 2 "normal"]
        lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort6.100 $ip1 "400" "100" "0" 3 "normal"]
        lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort7.400 $ip14 "22" "23" "0" 6 "normal"]
        lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort6.300 $ip11 "24" "21" "0" 7 "normal"]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface14 $matchType2 $Gpn_type2 $telnet2]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface15 $matchType2 $Gpn_type2 $telnet2]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface18 $matchType2 $Gpn_type2 $telnet2]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface19 $matchType2 $Gpn_type2 $telnet2]
	
        lappend flagDel [gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
        lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
        lappend flagDel [gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"]
        lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"]
        lappend flagDel [gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac3"]
        lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac3"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw2"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw2"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw3"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw3"]
        lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
        lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp2"]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface16 $matchType3 $Gpn_type3 $telnet3]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface20 $matchType3 $Gpn_type3 $telnet3]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface32 $matchType3 $Gpn_type3 $telnet3]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface34 $matchType3 $Gpn_type3 $telnet3]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface23 $matchType3 $Gpn_type3 $telnet3]
	
	if {[string match "L2" $Worklevel]} {
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort7 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2 "enable"]
	}
	if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        	foreach port $portList1 {
			lappend flagDel [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "enable" "disable"]
		}
		foreach port $portList2 {
			lappend flagDel [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "enable" "disable"]
		}
		foreach port $portList3 {
			lappend flagDel [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "enable" "disable"]
		}
        } 
        
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "测试结束后配置恢复" "测试结束后配置恢复" "GPN_PTN_004"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "测试过程中所有配置文件都上传成功" "GPN_PTN_004"
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_004 测试目的：E-LINE报文攻击内存泄露测试\n "
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1 == 1 || $flagCase2 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_004测试结果" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2测试结果" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "NE1($gpnIp1)和NE3($gpnIp3)双向对发业务报文的测试" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "向NE1($gpnIp1)设备发送ARP攻击报文的情况下，NE1($gpnIp1)和NE3($gpnIp3)双向对发业务报文的测试" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "在发送ARP和业务报文前与发送后相比，系统内存有变化" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "反复增删E-LINE实例，NE1($gpnIp1)和NE3($gpnIp3)双向对发业务的测试" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "反复增删E-LINE实例之前与之后相比，系统内存有变化" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "（结论）测试结束后配置恢复" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "（结论）测试过程中配置文件的上传" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "运行异常：错误为$err" "" "GPN_PTN_004"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
        file rename "report\\GPN_PTN_004_REPORT.txt" "report\\NOK_GPN_PTN_004_REPORT.txt"
        file rename "log\\GPN_PTN_004_LOG.txt" "log\\NOK_GPN_PTN_004_LOG.txt"
} else {
        file rename "report\\GPN_PTN_004_REPORT.txt" "report\\OK_GPN_PTN_004_REPORT.txt"
        file rename "log\\GPN_PTN_004_LOG.txt" "log\\OK_GPN_PTN_004_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}
