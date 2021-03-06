#!/bin/sh
# T4_GPN_ELAN_ETREE_014.tcl \
exec tclsh "$0" ${1+"$@"}
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
	file mkdir "log"
	set fd_log [open "log\\GPN_PTN_014_2_LOG.txt" a]
	set stdout $fd_log
	chan configure $fd_log -blocking 0 -buffering none;#非阻塞模式 按行flush
	log_file log\\GPN_PTN_014_2_LOG.txt
	
	file mkdir "report"
	set fileId [open "report\\GPN_PTN_014_2_REPORT.txt" a+]
	chan configure $fileId -blocking 0 -buffering none;#非阻塞模式 按行flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_014_2_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_014_2_DEBUG.txt 0
	chan configure $fd_debug -blocking 0 -buffering none;#非阻塞模式 按行flush
    
	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl

	###数据流设置
	array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
	array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "50" -pri "000"}
	array set dataArr3 {-srcMac "00:00:00:00:00:03" -dstMac "00:00:00:00:00:33" -srcIp "192.85.1.3" -dstIp "192.0.0.3" -vid "50" -pri "000" -type "9100"}
	array set dataArr4 {-srcMac "00:00:00:00:00:04" -dstMac "00:00:00:00:00:44" -srcIp "192.85.1.4" -dstIp "192.0.0.4" -vid "100" -pri "000"}
	array set dataArr5 {-srcMac "00:00:00:00:00:05" -dstMac "00:00:00:00:00:55" -srcIp "192.85.1.5" -dstIp "192.0.0.5" -vid1 "80" -pri1 "000" -vid2 "500" -pri2 "000"}
	array set dataArr6 {-srcMac "00:00:00:00:00:06" -dstMac "00:00:00:00:00:66" -srcIp "192.85.1.6" -dstIp "192.0.0.6" -vid "60" -pri "000"}
	array set dataArr7 {-srcMac "00:00:00:00:00:22" -dstMac "00:00:00:00:00:02" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "50" -pri "000"}
	array set dataArr8 {-srcMac "00:00:00:00:00:55" -dstMac "00:00:00:00:00:05" -srcIp "192.85.1.5" -dstIp "192.0.0.5" -vid1 "80" -pri1 "000" -vid2 "500" -pri2 "000"}
	array set dataArr9 {-srcMac "00:00:00:00:00:11" -dstMac "00:00:00:00:00:01" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
	array set dataArr10 {-srcMac "00:00:00:00:00:22" -dstMac "00:00:00:00:00:02" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "80" -pri "000"}
	
	array set dataArr11 {-srcMac "00:00:00:00:03:01" -dstMac "00:00:00:00:03:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
	array set dataArr12 {-srcMac "00:00:00:00:03:02" -dstMac "00:00:00:00:03:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "80" -pri "000"}
	array set dataArr13 {-srcMac "00:00:00:00:03:03" -dstMac "00:00:00:00:03:33" -srcIp "192.85.1.3" -dstIp "192.0.0.3" -vid "80" -pri "000" -type "9100"}
	array set dataArr14 {-srcMac "00:00:00:00:03:04" -dstMac "00:00:00:00:03:44" -srcIp "192.85.1.4" -dstIp "192.0.0.4" -vid "100" -pri "000"}
	###设置定制信息参数
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
	##mpls报文中的smac和 vid
	set anaFliFrameCfg51 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5699"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu></pdus></config></frame>}
	##mpls报文中的两层标签
	set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
	##mpls报文中的带的vid和Experimental Bits (bits)/Bottom of stack (bit)
	set anaFliFrameCfg3 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4647"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><exp override="true"  filterMinValue="0" filterMaxValue="111">111</exp></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><sBit override="true"  filterMinValue="0" filterMaxValue="1">1</sBit></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
	##匹配smac、vid1、vid2、ethtype
	set anaFliFrameCfg6 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType><vlans name="anon_2516"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	##匹配smac、ethtype
	set anaFliFrameCfg7 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	
	set rateL 95000000;#收发数据流取值最小值范围
	set rateR 105000000;#收发数据流取值最大值范围
	set rateL1 100000000 
	set rateR1 125000000
	
	set flagResult 0
	set flagCase1 0   ;#Test case 1标志位 
	set flagCase2 0   ;#Test case 2标志位
	set flagCase3 0   ;#Test case 3标志位 
	set flagCase4 0   ;#Test case 4标志位
	set flagCase5 0   ;#Test case 5标志位 
	
	set lFailFile ""
	set FLAGF 0
	
	set tcId 0
	set capId 0
	set cfgId 0
	#为测试结论预留空行
	for {set i 0} {$i < 80} {incr i} {
	    puts $fileId "                                                                                                                                                                                                                "	
	}
	
	regsub {/} $GPNTestEth1 {_} GPNTestEth1_cap
	regsub {/} $GPNTestEth2 {_} GPNTestEth2_cap
	regsub {/} $GPNTestEth3 {_} GPNTestEth3_cap
	regsub {/} $GPNTestEth4 {_} GPNTestEth4_cap
	regsub {/} $GPNTestEth5 {_} GPNTestEth5_cap
		
	puts $fileId "登录被测设备...\n"
	puts $fileId "\n=====登录被测设备1====\n"
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"]} {
		
	}
	puts $fileId "\n=====登录被测设备2====\n"
	set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
	puts $fileId "\n=====登录被测设备3====\n"
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	puts $fileId "\n=====登录被测设备4====\n"
	set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]

	#用于导出被测设备用到的变量------
	set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
	set lMatchType "$matchType1 $matchType2 $matchType3 $matchType4"
	set lDutType "$Gpn_type1 $Gpn_type2 $Gpn_type3 $Gpn_type4"
	set lIp "$gpnIp1 $gpnIp2 $gpnIp3 $gpnIp4"
	#------用于导出被测设备用到的变量
	
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "创建测试工程...\n"
	set hPtnProject [stc::create project]
	set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3 \"media $GPNEth3Media\" \
		$GPNStcPort4 \"media $GPNEth4Media\" $GPNStcPort5 \"media $GPNEth5Media\" $GPNStcPort6 \"media $GPNEth6Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4 hGPNPort5 hGPNPort6
	
	###创建测试流量
	gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort1 hGPNPort1Stream1
	gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort1 hGPNPort1Stream2
	gwd::STC_Create_VlanTypeStream $fileId dataArr3 $hGPNPort1 hGPNPort1Stream3
	gwd::STC_Create_VlanStream $fileId dataArr4 $hGPNPort1 hGPNPort1Stream4
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr5 $hGPNPort1 hGPNPort1Stream5
	gwd::STC_Create_VlanStream $fileId dataArr6 $hGPNPort1 hGPNPort1Stream6
	
	gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort3 hGPNPort3Stream7
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr8 $hGPNPort3 hGPNPort3Stream8
	gwd::STC_Create_VlanStream $fileId dataArr10 $hGPNPort3 hGPNPort3Stream10
	gwd::STC_Create_Stream $fileId dataArr11 $hGPNPort3 hGPNPort3Stream11
	gwd::STC_Create_VlanStream $fileId dataArr12 $hGPNPort3 hGPNPort3Stream12
	gwd::STC_Create_VlanTypeStream $fileId dataArr13 $hGPNPort3 hGPNPort3Stream13
	gwd::STC_Create_VlanStream $fileId dataArr14 $hGPNPort3 hGPNPort3Stream14
	
	gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort4 hGPNPort4Stream1
	gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort4 hGPNPort4Stream2
	gwd::STC_Create_VlanTypeStream $fileId dataArr3 $hGPNPort4 hGPNPort4Stream3
	gwd::STC_Create_VlanStream $fileId dataArr4 $hGPNPort4 hGPNPort4Stream4
	gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort4 hGPNPort4Stream7
	gwd::STC_Create_Stream $fileId dataArr9 $hGPNPort4 hGPNPort4Stream9
	
	set hGPNPortStreamList "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream3 $hGPNPort1Stream4 $hGPNPort4Stream9\
		$hGPNPort1Stream5 $hGPNPort3Stream8 $hGPNPort4Stream1 $hGPNPort1Stream6 $hGPNPort3Stream7 $hGPNPort4Stream7\
		$hGPNPort4Stream2 $hGPNPort4Stream3 $hGPNPort4Stream4 $hGPNPort3Stream10"
	set hGPNPortStreamList1 "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream3 $hGPNPort1Stream4"
	set hGPNPortStreamList2 "$hGPNPort3Stream11 $hGPNPort3Stream12 $hGPNPort3Stream13 $hGPNPort3Stream14"
	set hGPNPortStreamList3 "$hGPNPort1Stream5 $hGPNPort3Stream8"
	set hGPNPortStreamList4 "$hGPNPort4Stream1 $hGPNPort4Stream2 $hGPNPort4Stream3 $hGPNPort4Stream4"
	###获取发生器和分析器指针
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
	set hGPNPortGenList "$hGPNPort1Gen $hGPNPort2Gen $hGPNPort3Gen $hGPNPort4Gen $hGPNPort5Gen"
	set hGPNPortAnaList "$hGPNPort1Ana $hGPNPort2Ana $hGPNPort3Ana $hGPNPort4Ana $hGPNPort5Ana"
	stc::config $hGPNPort1Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort2Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort3Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort4Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort5Ana -FilterOnStreamId "FALSE"
	###定制收发信息
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
	###配置流的速率 10%，Mbps
	foreach stream $hGPNPortStreamList {
		stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
		gwd::Cfg_StreamActive $stream "FALSE"
	}
	stc::apply 
	###获取发生器配置指针
	gwd::Get_GeneratorCfgObj $hGPNPort1Gen hGPNPort1GenCfg
	gwd::Get_GeneratorCfgObj $hGPNPort2Gen hGPNPort2GenCfg
	gwd::Get_GeneratorCfgObj $hGPNPort3Gen hGPNPort3GenCfg
	gwd::Get_GeneratorCfgObj $hGPNPort4Gen hGPNPort4GenCfg
	gwd::Get_GeneratorCfgObj $hGPNPort5Gen hGPNPort5GenCfg
	set hGPNPortGenCfgList "$hGPNPort1GenCfg $hGPNPort2GenCfg $hGPNPort3GenCfg $hGPNPort4GenCfg $hGPNPort5GenCfg"
	foreach hGenCfg $hGPNPortGenCfgList {
		gwd::Cfg_GeneratorCfgObj $hGenCfg $GenCfg
	}
	###创建并配置过滤器，默认过滤tag
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
		###获取和配置capture对象相关的指针
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
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-TREE TAG模式测试基础配置开始...\n"
	set cfgFlag 0
	lappend cfgFlag [gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"]
	lappend cfgFlag [gwd::GWpublic_GetSysMac $telnet1 $matchType1 $Gpn_type1 $fileId gpnMac1]
	set portlist1 "$GPNPort5 $GPNPort12"
	set portList1 "$GPNTestEth1 $GPNTestEth5"
	set portList11 [concat $portlist1 $portList1]
	foreach port $portList11 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
		}
	 }
	set rebootSlotlist1 [gwd::GWpulic_getWorkCardList $portlist1]
	gwd::GWpublic_print "OK" "获取设备NE1($gpnIp1)业务板卡槽位号$rebootSlotlist1" $fileId
	set rebootSlotList1 [gwd::GWpulic_getWorkCardList $portList1]
	gwd::GWpublic_print "OK" "获取设备NE1($gpnIp1)上联板卡槽位号$rebootSlotList1" $fileId
	set mslot1 [gwd::GWpulic_getWorkCardList $managePort1]
	gwd::GWpublic_print "OK" "获取设备NE1($gpnIp1)管理口所在板卡槽位号$mslot1" $fileId
 
	lappend cfgFlag [gwd::GWpublic_GetSysMac $telnet2 $matchType2 $Gpn_type2 $fileId gpnMac2]
	set portlist2 "$GPNPort6 $GPNPort7"
	set portList2 ""
	set portList22 [concat $portlist2 $portList2]
	foreach port $portList22 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "disable" "enable"]
		}
	}
	set rebootSlotlist2 [gwd::GWpulic_getWorkCardList $portlist2]
	gwd::GWpublic_print "OK" "获取设备NE2($gpnIp2)业务板卡槽位号$rebootSlotlist2" $fileId
	set mslot2 [gwd::GWpulic_getWorkCardList $managePort2]
	gwd::GWpublic_print "OK" "获取设备NE2($gpnIp2)管理口所在板卡槽位号$mslot2" $fileId

	set portlist3 "$GPNPort8 $GPNPort9"
	set portList3 "$GPNTestEth2 $GPNTestEth3"
	set portList33 [concat $portlist3 $portList3]
	foreach port $portList33 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "disable" "enable"]
		}
	}
	set rebootSlotlist3 [gwd::GWpulic_getWorkCardList $portlist3]
	gwd::GWpublic_print "OK" "获取设备NE3($gpnIp3)业务板卡槽位号$rebootSlotlist3" $fileId
	set rebootSlotList3 [gwd::GWpulic_getWorkCardList $portList3]
	gwd::GWpublic_print "OK" "获取设备NE3($gpnIp3)上联板卡槽位号$rebootSlotList3" $fileId
	set mslot3 [gwd::GWpulic_getWorkCardList $managePort3]
	gwd::GWpublic_print "OK" "获取设备NE3($gpnIp3)管理口所在板卡槽位号$mslot3" $fileId
	
	set portlist4 "$GPNPort10 $GPNPort11"
	set portList4 "$GPNTestEth4"
	set portList44 [concat $portlist4 $portList4]
	foreach port $portList44 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet4 $matchType4 $Gpn_type4 $fileId $port "disable" "enable"]
		}
	}
	###二三层接口配置参数
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
	set Portlist "$GPNPort5 $GPNPort12 $GPNPort6 $GPNPort7 $GPNPort8 $GPNPort9 $GPNPort10 $GPNPort11"
	set Portlist0 "$GPNTestEth1 $GPNTestEth2 $GPNTestEth3 $GPNTestEth4 $GPNTestEth5"
	set Iplist "$ip612 $ip614 $ip621 $ip623 $ip632 $ip634 $ip643 $ip641"
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-TREE tag和tagged模式测试基础配置失败，测试结束" \
		"E-TREE TAG模式测试基础配置成功，继续后面的测试" "GPN_PTN_014_2"
	puts $fileId ""
	puts $fileId "===E-TREE TAG模式测试基础配置结束..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId ""
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 ETREE业务TAG模式：(NE1($gpnIp1)$GPNTestEth1为PORT+VLAN----NE3($gpnIp3)$GPNTestEth3为PORT+VLAN)功能验证测试\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，(NE1($gpnIp1)$GPNTestEth1：PORT+VLAN----NE3($gpnIp3)$GPNTestEth3：PORT+VLAN)，NE1 $GPNTestEth1\发送数据流验证数据转发  测试开始=====\n"
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
	
	foreach {port1 port2} $Portlist telnet $lSpawn_id Gpn_type $lDutType {vid1 vid2} $Vlanlist {Ip1 Ip2} $Iplist matchType $lMatchType {
		###二三层接口配置参数
		if {[string match "L2" $Worklevel]} {
			set interface1 v$vid1
			set interface2 v$vid2
		} else {
			set interface1 $port1.$vid1
			set interface2 $port2.$vid2
		}
		###配置NNI口属性
		if {[string match "L2" $Worklevel]} {
			gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port1 "enable"
			gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port2 "enable"
		}
		PTN_NNI_AddInterIp $fileId $Worklevel $interface1 $Ip1 $port1 $matchType $Gpn_type $telnet
		PTN_NNI_AddInterIp $fileId $Worklevel $interface2 $Ip2 $port2 $matchType $Gpn_type $telnet
	}
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" 1 "etree" "flood" "false" "false" "false" "true" "2000" "evc2" "tag"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface3 $ip621 "100" "100" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $interface10 $ip641 "400" "400" "normal" "4"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $address614
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "1004" "1004" "" "add" "none" 1 0 "0x8100" "0x8100" "4"                                       
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "50" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "modify" "50" "0" "0" "0x8100" "evc2"

	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface4 $ip612 "100" "100" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $interface5 $ip632 "200" "200" "normal" "3"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $address623
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "tag"
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "tag"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "l2transport" "1" "" $address621 "1000" "1000" "1" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "l2transport" "3" "" $address623 "2000" "2000" "3" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWPw_AddMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "pw23"

	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3" 3 "etree" "flood" "false" "false" "false" "true" "2000" "evc2" "tag"
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $interface6 $ip623 "200" "200" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $address632
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "2000" "2000" "" "add" "root" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "50" $GPNTestEth3
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "vpls3" "" $GPNTestEth3 "50" "0" "leaf" "modify" "50" "0" "0" "0x8100" "evc2"	
	
	gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $interface9 $ip614 "400" "400" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $address641
	gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"
	gwd::GWPw_AddPwVcType $telnet4 $matchType4 $Gpn_type4  $fileId "pw41" "tag"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "l2transport" "4" "" $address641 "1004" "1004" "1" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_CfgAc $telnet4 $matchType4 $Gpn_type4 $fileId "ac1" "" $GPNTestEth4 0 0 "delete" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet4 $matchType4 $Gpn_type4 $fileId "ac1" "pw41" "eline14"
	##配置undo vlan check
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet4 $matchType4 $Gpn_type4 $fileId $GPNTestEth4 "disable"
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "true"
	incr capId
	if {[PortVlan_portVlan_repeat_014 "" "GPN_PTN_014_2_$capId" $fileId $rateL $rateR]} {
		set flag1_case1 1
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1（结论）vpls为etree业务tag模式，(NE1($gpnIp1)$GPNTestEth1：PORT+VLAN----NE3($gpnIp3)$GPNTestEth3：PORT+VLAN)，NE1 $GPNTestEth1\发送数据流验证数据转发" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1（结论）vpls为etree业务tag模式，(NE1($gpnIp1)$GPNTestEth1：PORT+VLAN----NE3($gpnIp3)$GPNTestEth3：PORT+VLAN)，NE1 $GPNTestEth1\发送数据流验证数据转发" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)：$GPNTestEth1\为PORT+VLAN $GPNTestEth5\为PORT、NE3($gpnIp3)：$GPNTestEth3\为PORT+VLAN$GPNTestEth2\为PORT、\
				NE4($gpnIp4)：$GPNTestEth4\为PORT；NE1($gpnIp1)的$GPNTestEth1\发送数据流验证数据转发  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====镜像NE1($gpnIp1)到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，检查业务vlan的tag标签是否变化  测试开始=====\n"
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "true"
	
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	set hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vlanId" -Offset 44]
	set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-etherType" -Offset 46]
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
	}
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort5Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	if {$GPNPort5Cnt1(cnt5) == 0} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签有变化" $fileId
	} else {
		if {$GPNPort5Cnt1(cnt5) < $rateL1 || $GPNPort5Cnt1(cnt5) > $rateR1} {
			set flag2_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化\
				但是速率为GPNPort5Cnt1(cnt5)，没在$rateL1-$rateR1\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化\
				速率为$GPNPort5Cnt1(cnt5)，在$rateL1-$rateR1\范围内" $fileId
		}
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2（结论）vpls为etree业务tag模式，镜像NE1到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签有变化" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2（结论）vpls为etree业务tag模式，镜像NE1到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====镜像NE1($gpnIp1)到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，检查业务vlan的tag标签是否被去掉  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1为PORT+VLAN；NE4($gpnIp4)vpws业务tag模式，$GPNTestEth4\为PORT；NE4的$GPNTestEth4\发送untag数据流验证数据转发  测试开始=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	#通过端口up down的操作清空镜像中学习到mac地址
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "undo shutdown"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort4Stream1" \
		-activate "true"
	#NE4 GPNTestEth4发送untag的未知单播
	incr capId
	SendAndStat_ptn014 1 "$::hGPNPort4Gen" "$::hGPNPort1Ana $::hGPNPort3Ana" "$GPNTestEth1 $GPNTestEth3" "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3" "$hGPNPort1AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil" GPNPort1Cnt1 GPNPort3Cnt1 aTmp1 aTmp2 aTmp3\
		1 $::anaFliFrameCfg1 "GPN_PTN_014_2_$capId"
	SendAndStat_ptn014 0 "$::hGPNPort4Gen" "$::hGPNPort1Ana $::hGPNPort3Ana" "$GPNTestEth1 $GPNTestEth3" "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3" "$hGPNPort1AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil" GPNPort1Cnt0 GPNPort3Cnt0 aTmp1 aTmp2 aTmp3\
		0 $::anaFliFrameCfg0 "GPN_PTN_014_2_$capId"
	if {$GPNPort1Cnt1(cnt1) < $rateL || $GPNPort1Cnt1(cnt1) > $rateR} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=50的数据流的速率为$GPNPort1Cnt1(cnt1)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=50的数据流的速率为$GPNPort1Cnt1(cnt1)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt0(cnt1) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE3($gpnIp3)\
		$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)，在$rateL-$rateR\范围内" $fileId
	}
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1为PORT+VLAN；NE4($gpnIp4)vpws业务tag模式，$GPNTestEth4\为PORT；NE4的$GPNTestEth4\发送untag数据流验证数据转发" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1为PORT+VLAN；NE4($gpnIp4)vpws业务tag模式，$GPNTestEth4\为PORT；NE4的$GPNTestEth4\发送untag数据流验证数据转发" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1为PORT+VLAN；NE4($gpnIp4)vpws业务tag模式，$GPNTestEth4\为PORT；NE4的$GPNTestEth4\发送untag数据流验证数据转发  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，配置pw动作为modify、nochange、delete，验证系统是否提示动作被修改为add  测试开始=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	set ret [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "modify" "none" 50 0 "0x8100" "0x8100" "2"]
	if {$ret == 0} {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为modify，配置成功无提示" $fileId
	} elseif {$ret == 3} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为modify，提示动作被修改为add" $fileId
	} else {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为modify，配置失败且系统提示错误" $fileId
	}
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	
	set ret [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"]
	if {$ret == 0} {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为nochange，配置成功无提示" $fileId
	} elseif {$ret == 3} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为nochange，提示动作被修改为add" $fileId
	} else {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为nochange，配置失败且系统提示错误" $fileId
	}
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	
	set ret [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"]
	if {$ret == 0} {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为delete，配置成功无提示" $fileId
	} elseif {$ret == 3} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为delete，提示动作被修改为add" $fileId
	} else {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为delete，配置失败且系统提示错误" $fileId
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA4（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，配置pw动作为modify、nochange、delete，系统无错误提示或提示错误" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，配置pw动作为modify、nochange、delete，系统提示动作被修改为add" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，配置pw动作为modify、nochange、delete，验证系统是否提示动作被修改为add  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac动作为delete、nochange、add，验证系统是否提示动作被修改为modify  测试开始=====\n"
	set ret [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "delete" "50" "0" "0" "0x8100" "evc2"]
	if {$ret == 0} {
		set flag5_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac1 VLAN动作为delete，配置成功无提示" $fileId
	} elseif {$ret == 2} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac1 VLAN动作为delete，提示动作被修改为modify" $fileId
	} else {
		set flag5_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac1 VLAN动作为delete，配置失败且系统提示错误" $fileId
	}
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	
	set ret [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "nochange" "50" "0" "0" "0x8100" "evc2"]
	if {$ret == 0} {
		set flag5_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac1 VLAN动作为nochange，配置成功无提示" $fileId
	} elseif {$ret == 2} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac1 VLAN动作为nochange，提示动作被修改为modify" $fileId
	} else {
		set flag5_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac1 VLAN动作为nochange，配置失败且系统提示错误" $fileId
	}
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	
	set ret [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "add" "50" "0" "0" "0x8100" "evc2"]
	if {$ret == 0} {
		set flag5_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac1 VLAN动作为add，配置成功无提示" $fileId
	} elseif {$ret == 2} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac1 VLAN动作为add，提示动作被修改为modify" $fileId
	} else {
		set flag5_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac1 VLAN动作为add，配置失败且系统提示错误" $fileId
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA5（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac动作为delete、nochange、add，系统无错误提示或提示错误" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac动作为delete、nochange、add，系统提示动作被修改为modify" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac动作为delete、nochange、add，验证系统是否提示动作被修改为modify  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac和pw动作错误系统自动修改后，发流验证配置是否生效  测试开始=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort4Stream1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "true"
	if {($flag4_case1 == 0) && ($flag5_case1 == 0)} {
		incr capId
		if {[PortVlan_portVlan_repeat_014 "" GPN_PTN_014_2_$capId $fileId $rateL $rateR]} {
			set flag6_case1 1
		}
	} else {
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "modify" "50" "0" "0" "0x8100" "evc2"
		if {$flag4_case1 == 1} {
			set flag6_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置pw动作为modify、nochange、delete，系统没有自动修改动作为add，该项测试无法进行" $fileId
		} elseif {$flag5_case1 == 1} {
			set flag6_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac动作为delete、nochange、add，系统没有自动修改动作为modify，该项测试无法进行" $fileId	
		}
	}
	puts $fileId ""
	if {$flag6_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA6（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac和pw动作错误系统自动修改后，发流验证配置" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac和pw动作错误系统自动修改后，发流验证配置" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac和pw动作错误系统自动修改后，发流验证配置是否生效  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac和pw动作错误系统自动修改后，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，检查业务vlan的tag标签是否有变化  测试开始=====\n"
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	set hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vlanId" -Offset 44]
	set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-etherType" -Offset 46]
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "true"
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	if {($flag4_case1 == 0) && ($flag5_case1 == 0)} {
		if {$cap_enable} {
			gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
		}
		gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
		after 10000
		incr capId
		if {$cap_enable} {
			gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
		}
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
		array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 1 1 1 1 1 0
			after 5000
		}
		
		parray GPNPort5Cnt1
		gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
		if {$GPNPort5Cnt1(cnt5) == 0} {
			set flag7_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签有变化" $fileId
		} else {
			if {$GPNPort5Cnt1(cnt5) < $rateL1 || $GPNPort5Cnt1(cnt5) > $rateR1} {
				set flag7_case1 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化\
					但是速率为GPNPort5Cnt1(cnt1)，没在$rateL1-$rateR1\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化\
					速率为$GPNPort5Cnt1(cnt1)，在$rateL1-$rateR1\范围内" $fileId
			}
		}
	} else {
		if {$flag4_case1 == 1} {
			set flag7_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置pw动作为modify、nochange、delete，系统没有自动修改动作为add，该项测试无法进行" $fileId
		} elseif {$flag5_case1 == 1} {
			set flag7_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac动作为delete、nochange、add，系统没有自动修改动作为modify，该项测试无法进行" $fileId	
		}
	}
	puts $fileId ""
	if {$flag7_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA7（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac和pw动作错误系统自动修改后，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签有变化" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac和pw动作错误系统自动修改后，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac和pw动作错误系统自动修改后，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，检查业务vlan的tag标签是否有变化  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响  测试开始=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream6" \
		-activate "true"
	stc::apply
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "modify" "50" "0" "0" "0x8100" "evc2"
	###NE1-NE3之间再配置一条业务，共用同一条lsp
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11" 11 "etree" "flood" "false" "false" "false" "true" "2000" "evc3" "tag"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121" "vpls" "vpls11" "peer" $address612 "1001" "1001" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "60" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac5" "vpls11" "" $GPNTestEth1 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "tag"
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw231" "tag"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "l2transport" "11" "" $address621 "1001" "1001" "1" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231" "l2transport" "31" "" $address623 "2001" "2001" "3" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWPw_AddMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"

	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33" 33 "etree" "flood" "false" "false" "false" "true" "2000" "evc3" "tag"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321" "vpls" "vpls33" "peer" $address632 "2001" "2001" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "60" $GPNTestEth3
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac5" "vpls33" "" $GPNTestEth3 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	
       #测试新增业务的环回
       if {[TestPWLoop $fileId $rateL $rateR]} {
	       set flag8_case1 1 
       }
	#对其他业务的影响------
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "true"
	incr capId
	if {[PortVlan_portVlan_repeat_014 "" GPN_PTN_014_2_$capId $fileId $rateL $rateR]} {
		set flag8_case1 1
	}
	#------对其他业务的影响
	puts $fileId ""
	if {$flag8_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA8（结论）vpls为etree业务tag模式、PORT+VLAN--PORT+VLAN，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8（结论）vpls为etree业务tag模式、PORT+VLAN--PORT+VLAN，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，NE1($gpnIp1)上ping pw12  测试开始=====\n"
	gwd::GWpublic_delPwLoop $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	gwd::GWpublic_addPwPing $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" value
	puts "value:$value"
	if {![dict get $value sucRate]==100.00} {
		set flag9_case1 1 
		gwd::GWpublic_print "NOK"  "vpls为etree业务tag模式，NE1($gpnIp1)上ping pw12 ping通结果预计为100.00% 实为[dict get $value sucRate]%" $fileId
	} else {
		gwd::GWpublic_print "OK"  "vpls为etree业务tag模式，NE1($gpnIp1)上ping pw12 ping通结果预计为100.00% 实为[dict get $value sucRate]%" $fileId
	}
	if {[string match [dict get $value replyIp] "20.6.5.2"]} {
		gwd::GWpublic_print "OK" "vpls为etree业务tag模式，NE1($gpnIp1)上ping pw12的reply from 的ip应为20.6.5.2实为[dict get $value replyIp]" $fileId
	} else {
		set flag9_case1 1
		gwd::GWpublic_print "NOK" "vpls为etree业务tag模式，NE1($gpnIp1)上ping pw12的reply from 的ip应为20.6.5.2实为[dict get $value replyIp]" $fileId
	}
	puts $fileId ""
	if {$flag9_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA9（结论）vpls为etree业务tag模式，NE1($gpnIp1)上ping pw12 的测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9（结论）vpls为etree业务tag模式，NE1($gpnIp1)上ping pw12 的测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，NE1($gpnIp1)上ping pw12  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，在NE1($gpnIp1)使用tracertroute查看报文从NE1到NE3经过的每一跳  测试开始=====\n"
	gwd::GWpublic_addPwTrace $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" result
	set expectTrace {0 {replier "null" traceTime "null" type "Ingress" downstream "20.6.4.2/ 1000 100" ret "null"} 1 {replier "20.6.4.2" traceTime "<1ms" type "Transit" downstream "20.6.5.2/ 2000 200" ret "transit router"} 2 {replier "20.6.5.2" traceTime "<1ms" type "Egress" downstream "--" ret "success"}}
	set flag10_case1 [Check_Tracertroute "" $expectTrace $result]
	if {$flag10_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB1（结论）vpls为etree业务tag模式，在NE1($gpnIp1)使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1（结论）vpls为etree业务tag模式，在NE1($gpnIp1)使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，在NE1($gpnIp1)使用tracertroute查看报文从NE1到NE3经过的每一跳  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+VLAN，向NE1的$GPNTestEth1\口发送协议报文  测试开始=====\n" 
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPort1Stream6" \
		-activate "false"
	set hProtocalStream1 [stc::create "StreamBlock" \
		-under $hGPNPort1 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:02</dstMac><etherType override="true" >8809</etherType><vlans name="anon_4503"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="proto1" pdu="custom:Custom"><pattern>0300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000</pattern></pdu></pdus></config></frame>} \
		-Name {EFM} ]
	
	set hProtocalStream2 [stc::create "StreamBlock" \
		-under $hGPNPort1 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:30</dstMac><etherType override="true" >8902</etherType><vlans name="anon_4508"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><checksum>14740</checksum><tosDiffserv name="anon_4511"><tos name="anon_4512"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {CFM} ]
	
	set hProtocalStream3 [stc::create "StreamBlock" \
		-under $hGPNPort1 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:0E</dstMac><etherType override="true" >88CC</etherType><vlans name="anon_4517"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><checksum>14740</checksum><tosDiffserv name="anon_4520"><tos name="anon_4521"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {LLDP} ]
	
	set hProtocalStream4 [stc::create "StreamBlock" \
		-under $hGPNPort1 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:02</dstMac><etherType override="true" >8809</etherType><vlans name="anon_4526"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="proto1" pdu="custom:Custom"><pattern>0100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000</pattern></pdu></pdus></config></frame>} \
		-Name {LACP} ]
	
	set hProtocalStream5 [stc::create "StreamBlock" \
		-under $hGPNPort1 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:CD:00:00:01</dstMac><etherType override="true" >8903</etherType><vlans name="anon_4531"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><checksum>14740</checksum><tosDiffserv name="anon_4534"><tos name="anon_4535"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {MRPS} ]
	
	set hProtocalStream6 [stc::create "StreamBlock" \
		-under $hGPNPort1 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:02</dstMac><vlans name="anon_4540"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><protocol override="true" >17</protocol><checksum>14976</checksum><tosDiffserv name="anon_4543"><tos name="anon_4544"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {LDP} ]
	
	set hProtocalStream7 [stc::create "StreamBlock" \
		-under $hGPNPort1 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:14</dstMac><vlans name="anon_4549"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><checksum>14740</checksum><tosDiffserv name="anon_4552"><tos name="anon_4553"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {ISIS} ]
	
	set hProtocalStream8 [stc::create "StreamBlock" \
		-under $hGPNPort1 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:05</dstMac><vlans name="anon_4558"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><protocol override="true" >89</protocol><checksum>14904</checksum><tosDiffserv name="anon_4561"><tos name="anon_4562"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {OSPF} ]
	
	set hProtocalStream9 [stc::create "StreamBlock" \
		-under $hGPNPort1 \
		-EqualRxPortDistribution "FALSE" \
		-MinFrameLength "64" \
		-MaxFrameLength "9000" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:09</dstMac><vlans name="anon_4567"><Vlan name="Vlan"><pri>000</pri><id>50</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><protocol override="true" >17</protocol><checksum>14976</checksum><tosDiffserv name="anon_4570"><tos name="anon_4571"></tos></tosDiffserv></pdu></pdus></config></frame>} \
		-Name {RIP} ]
	foreach stream "$hProtocalStream1 $hProtocalStream2 $hProtocalStream3 $hProtocalStream4 $hProtocalStream5 $hProtocalStream6 $hProtocalStream7 $hProtocalStream8 $hProtocalStream9" {
		stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 2 -LoadUnit MEGABITS_PER_SECOND
	}
	
	stc::perform streamBlockActivate \
		-streamBlockList "$hProtocalStream1 $hProtocalStream2 $hProtocalStream3 $hProtocalStream4 $hProtocalStream5 $hProtocalStream6 $hProtocalStream7 $hProtocalStream8 $hProtocalStream9" \
		-activate "false"
	stc::apply

	foreach stream "$hProtocalStream1 $hProtocalStream2 $hProtocalStream3 $hProtocalStream4 $hProtocalStream5 $hProtocalStream6 $hProtocalStream7 \
		$hProtocalStream8 $hProtocalStream9" printStr "EFM CFM LLDP LACP MRPS LDP ISIS OSPF RIP" {
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "true"
		stc::perform ResultsClearViewCommand -ResultList "[stc::get $hGPNPort3Ana -children-AnalyzerPortResults] [stc::get $hGPNPort1Gen -children-GeneratorPortResults]"
		gwd::Start_SendFlow $hGPNPort1Gen $hGPNPort3Ana
		after 20000
		gwd::Stop_SendFlow $hGPNPort1Gen $hGPNPort3Ana
		after 2000
		set rxCnt [stc::get $hGPNPort3Ana.AnalyzerPortResults -SigFrameCount]
		set txCnt [stc::get $hGPNPort1Gen.GeneratorPortResults -GeneratorSigFrameCount]
		if {[string match "EFM" $printStr] || [string match "LACP" $printStr]} {
			if {$rxCnt != 0} {
				set flag11_case1 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，报文应被过滤，NE3($gpnIp3)$GPNTestEth3\接收应为0个实为$rxCnt\个" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，报文应被过滤，NE3($gpnIp3)$GPNTestEth3\接收应为0个实为$rxCnt\个" $fileId
			}
		} else {
			if {$rxCnt != $txCnt} {
				set flag11_case1 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，NE3($gpnIp3)$GPNTestEth3\接收$rxCnt\个" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，NE3($gpnIp3)$GPNTestEth3\接收$rxCnt\个" $fileId
			}
		}
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "false"
	}
	puts $fileId ""
	if {$flag11_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB2（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+VLAN，向NE1的$GPNTestEth1\口发送协议报文NE3($gpnIp3)$GPNTestEth3\口接收有丢包" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+VLAN，向NE1的$GPNTestEth1\口发送协议报文NE3($gpnIp3)$GPNTestEth3\口接收无丢包" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+VLAN，向NE1的$GPNTestEth1\口发送协议报文  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase1 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 1测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 1测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 1 ETREE业务TAG模式：(NE1($gpnIp1)$GPNTestEth1为PORT+VLAN----NE3($gpnIp3)$GPNTestEth3为PORT+VLAN)功能验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 ETREE业务TAG模式：(NE1($gpnIp1)$GPNTestEth1为PORT----NE3($gpnIp3)$GPNTestEth3为PORT)功能验证测试\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，(NE1($gpnIp1)$GPNTestEth1：PORT----NE3($gpnIp3)$GPNTestEth3：PORT)，NE1 $GPNTestEth1\发送数据流验证数据转发  测试开始=====\n"
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
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac5"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121"
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "0" "0" "none" "delete" "1" "0" "0" "0x8100" "evc2"
	
	gwd::GWPw_DelMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231"
	
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac5"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "vpls3" "" $GPNTestEth3 "0" "0" "leaf" "delete" "1" "0" "0" "0x8100" "evc2"
	###配置undo vlan check
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "disable"
		gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "disable"
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "true"
	incr capId
	if {[Port_port_repeat_014 "" "GPN_PTN_014_2_$capId" $fileId $rateL $rateR]} {
		set flag1_case2 1
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB3（结论）vpls为etree业务tag模式，(NE1($gpnIp1)$GPNTestEth1：PORT----NE3($gpnIp3)$GPNTestEth3：PORT)，NE1 $GPNTestEth1\发送数据流验证数据转发" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3（结论）vpls为etree业务tag模式，(NE1($gpnIp1)$GPNTestEth1：PORT----NE3($gpnIp3)$GPNTestEth3：PORT)，NE1 $GPNTestEth1\发送数据流验证数据转发" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，(NE1($gpnIp1)$GPNTestEth1：PORT----NE3($gpnIp3)$GPNTestEth3：PORT)，NE1 $GPNTestEth1\发送数据流验证数据转发  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====镜像NE1($gpnIp1)到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，检查业务数据流是否会添加tag=1的标签  测试开始=====\n"
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	stc::delete $hfilter16BitFilAna3
	stc::delete $hfilter16BitFilAna4
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "true"
	
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	set hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vid0" -Offset 44]
	set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vid1" -Offset 48]
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
	}
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort5Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	if {$GPNPort5Cnt1(cnt6) == 0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务数据流没有添加tag=1的标签" $fileId
	} else {
		if {$GPNPort5Cnt1(cnt6) < $rateL1 || $GPNPort5Cnt1(cnt6) > $rateR1} {
			set flag2_case2 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务数据流添加了tag=1的标签\
				但是速率为GPNPort5Cnt1(cnt6)，没在$rateL1-$rateR1\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务数据流添加了tag=1的标签\
				速率为$GPNPort5Cnt1(cnt6)，在$rateL1-$rateR1\范围内" $fileId
		}
	}
	puts $fileId ""
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB4（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT)到NE3($gpnIp3)的NNI口$GPNPort5\的egress方向，业务数据流没有添加tag=1的标签" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT)到NE3($gpnIp3)的NNI口$GPNPort5\的egress方向，业务数据流添加了tag=1的标签" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====镜像NE1($gpnIp1)到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，检查业务数据流是否会添加tag=1的标签  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1为PORT；NE4($gpnIp4)vpws业务tag模式，$GPNTestEth4\为PORT；NE4的$GPNTestEth4\发送untag数据流验证数据转发  测试开始=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	#通过端口up down的操作清空镜像中学习到mac地址
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "undo shutdown"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort4Stream1" \
		-activate "true"
	#NE4 GPNTestEth4发送untag的未知单播
	incr capId
	SendAndStat_ptn014 1 "$::hGPNPort4Gen" "$::hGPNPort1Ana $::hGPNPort3Ana" "$GPNTestEth1 $GPNTestEth3" "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3" "$hGPNPort1AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil" GPNPort1Cnt7 GPNPort3Cnt7 aTmp1 aTmp2 aTmp3\
		7 $::anaFliFrameCfg7 "GPN_PTN_014_2_$capId"
	SendAndStat_ptn014 0 "$::hGPNPort4Gen" "$::hGPNPort1Ana $::hGPNPort3Ana" "$GPNTestEth1 $GPNTestEth3" "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3" "$hGPNPort1AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil" GPNPort1Cnt0 GPNPort3Cnt0 aTmp1 aTmp2 aTmp3\
		0 $::anaFliFrameCfg0 "GPN_PTN_014_2_$capId"
	if {$GPNPort1Cnt7(cnt1) < $rateL || $GPNPort1Cnt7(cnt1) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt1)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt1)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt0(cnt1) != 0} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE3($gpnIp3)\
		$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)，在$rateL-$rateR\范围内" $fileId
	}
	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB5（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1为PORT；NE4($gpnIp4)vpws业务tag模式，$GPNTestEth4\为PORT；NE4的$GPNTestEth4\发送untag数据流验证数据转发" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1为PORT；NE4($gpnIp4)vpws业务tag模式，$GPNTestEth4\为PORT；NE4的$GPNTestEth4\发送untag数据流验证数据转发" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1为PORT；NE4($gpnIp4)vpws业务tag模式，$GPNTestEth4\为PORT；NE4的$GPNTestEth4\发送untag数据流验证数据转发  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT，配置pw动作为modify、nochange、delete，验证系统是否提示动作被修改为add  测试开始=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	set ret [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "modify" "none" 1 0 "0x8100" "0x8100" "2"]
	if {$ret == 0} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为modify，配置成功无提示" $fileId
	} elseif {$ret == 3} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为modify，提示动作被修改为add" $fileId
	} else {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为modify，配置失败且系统提示错误" $fileId
	}
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	
	set ret [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"]
	if {$ret == 0} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为nochange，配置成功无提示" $fileId
	} elseif {$ret == 3} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为nochange，提示动作被修改为add" $fileId
	} else {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为nochange，配置失败且系统提示错误" $fileId
	}
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	
	set ret [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"]
	if {$ret == 0} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为delete，配置成功无提示" $fileId
	} elseif {$ret == 3} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为delete，提示动作被修改为add" $fileId
	} else {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式，配置pw12 VLAN动作为delete，配置失败且系统提示错误" $fileId
	}
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB6（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT，配置pw动作为modify、nochange、delete，系统无错误提示或提示错误" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT，配置pw动作为modify、nochange、delete，系统提示动作被修改为add" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT，配置pw动作为modify、nochange、add，验证系统是否提示动作被修改为delete  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac动作为modify、nochange、add，验证系统是否提示动作被修改为delete  测试开始=====\n"
	set ret [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "0" "0" "none" "modify" "1" "0" "0" "0x8100" "evc2"]
	if {$ret == 0} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac1 VLAN动作为modify，配置成功无提示" $fileId
	} elseif {$ret == 3} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac1 VLAN动作为modify，提示动作被修改为delete" $fileId
	} else {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac1 VLAN动作为modify，配置失败且系统提示错误" $fileId
	}
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	
	set ret [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "0" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"]
	if {$ret == 0} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac1 VLAN动作为nochange，配置成功无提示" $fileId
	} elseif {$ret == 3} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac1 VLAN动作为nochange，提示动作被修改为delete" $fileId
	} else {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac1 VLAN动作为nochange，配置失败且系统提示错误" $fileId
	}
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	
	set ret [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "0" "0" "none" "add" "1" "0" "0" "0x8100" "evc2"]
	if {$ret == 0} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac1 VLAN动作为add，配置成功无提示" $fileId
	} elseif {$ret == 3} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac1 VLAN动作为add，提示动作被修改为delete" $fileId
	} else {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac1 VLAN动作为add，配置失败且系统提示错误" $fileId
	}
	puts $fileId ""
	if {$flag5_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB7（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac动作为modify、nochange、add，系统无错误提示或提示错误" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac动作为modify、nochange、add，系统提示动作被修改为delete" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac动作为modify、nochange、add，验证系统是否提示动作被修改为delete  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac和pw动作错误系统自动修改后，发流验证配置是否生效  测试开始=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort4Stream1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "true"
	if {($flag4_case2 == 0) && ($flag5_case2 == 0)} {
		incr capId
		if {[Port_port_repeat_014 "" GPN_PTN_014_2_$capId $fileId $rateL $rateR]} {
			set flag6_case2 1
		}
	} else {
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "0" "0" "none" "delete" "1" "0" "0" "0x8100" "evc2"
		if {$flag4_case2 == 1} {
			set flag6_case2 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置pw动作为modify、nochange、delete，系统没有自动修改动作为add，该项测试无法进行" $fileId
		} elseif {$flag5_case2 == 1} {
			set flag6_case2 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac动作为modify、nochange、add，系统没有自动修改动作为delete，该项测试无法进行" $fileId	
		}
	}
	puts $fileId ""
	if {$flag6_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB8（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac和pw动作错误系统自动修改后，发流验证配置" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac和pw动作错误系统自动修改后，发流验证配置" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac和pw动作错误系统自动修改后，发流验证配置是否生效  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac和pw动作错误系统自动修改后，镜像NE1到NE3的NNI口$GPNPort5\的egress方向，检查业务数据流是否会添加tag=1的标签  测试开始=====\n"
	if {($flag4_case2 == 0) && ($flag5_case2 == 0)} {
		stc::delete $hfilter16BitFilAna1
		stc::delete $hfilter16BitFilAna2
		stc::delete $hfilter16BitFilAna3
		stc::delete $hfilter16BitFilAna4
	}
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	set hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vid0" -Offset 44]
	set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vid1" -Offset 48]
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "true"
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	if {($flag4_case2 == 0) && ($flag5_case2 == 0)} {
		if {$cap_enable} {
			gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
		}
		gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
		after 10000
		incr capId
		if {$cap_enable} {
			gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
		}
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
		array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 1 1 1 1 1 0
			after 5000
		}
		
		parray GPNPort5Cnt1
		gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
		if {$GPNPort5Cnt1(cnt6) == 0} {
			set flag7_case2 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务数据流没有添加tag=1的标签" $fileId
		} else {
			if {$GPNPort5Cnt1(cnt6) < $rateL1 || $GPNPort5Cnt1(cnt6) > $rateR1} {
				set flag7_case2 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务数据流添加了tag=1的标签\
					但是速率为GPNPort5Cnt1(cnt6)，没在$rateL1-$rateR1\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务数据流添加了tag=1的标签\
					速率为$GPNPort5Cnt1(cnt6)，在$rateL1-$rateR1\范围内" $fileId
			}
		}
	} else {
		if {$flag4_case2 == 1} {
			set flag7_case2 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置pw动作为modify、nochange、delete，系统没有自动修改动作为add，该项测试无法进行" $fileId
		} elseif {$flag5_case2 == 1} {
			set flag7_case2 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac动作为modify、nochange、add，系统没有自动修改动作为delete，该项测试无法进行" $fileId	
		}
	}
	puts $fileId ""
	if {$flag7_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB9（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac和pw动作错误系统自动修改后，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务数据流没有添加tag=1的标签" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac和pw动作错误系统自动修改后，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务数据流添加了tag=1的标签" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac和pw动作错误系统自动修改后，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，检查业务数据流是否会添加tag=1的标签  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响  测试开始=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream6" \
		-activate "true"
	stc::apply
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "0" "0" "none" "delete" "1" "0" "0" "0x8100" "evc2"
	###NE1-NE3之间再配置一条业务，共用同一条lsp
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11" 11 "etree" "flood" "false" "false" "false" "true" "2000" "evc3" "tag"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121" "vpls" "vpls11" "peer" $address612 "1001" "1001" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "60" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac5" "vpls11" "" $GPNTestEth1 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "tag"
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw231" "tag"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "l2transport" "11" "" $address621 "1001" "1001" "1" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231" "l2transport" "31" "" $address623 "2001" "2001" "3" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWPw_AddMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"

	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33" 33 "etree" "flood" "false" "false" "false" "true" "2000" "evc3" "tag"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321" "vpls" "vpls33" "peer" $address632 "2001" "2001" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "60" $GPNTestEth3
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac5" "vpls33" "" $GPNTestEth3 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	
       #测试新增业务的环回
       if {[TestPWLoop $fileId $rateL $rateR]} {
	       set flag8_case2 1 
       }
	#对其他业务的影响------
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "true"
	incr capId
	if {[Port_port_repeat_014 "" GPN_PTN_014_2_$capId $fileId $rateL $rateR]} {
		set flag8_case2 1
	}
	#------对其他业务的影响
	puts $fileId ""
	if {$flag8_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC1（结论）vpls为etree业务tag模式、PORT---PORT，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1（结论）vpls为etree业务tag模式、PORT---PORT，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式、AC为port，NE1($gpnIp1)上ping pw12  测试开始=====\n"
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	stc::delete $hfilter16BitFilAna3
	stc::delete $hfilter16BitFilAna4
	gwd::GWpublic_delPwLoop $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	gwd::GWpublic_addPwPing $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" value
	puts "value:$value"
	if {![dict get $value sucRate]==100.00} {
		set flag9_case2 1 
		gwd::GWpublic_print "NOK"  "vpls为etree业务tag模式、AC为port，NE1($gpnIp1)上ping pw12 ping通结果预计为100.00% 实为[dict get $value sucRate]%" $fileId
	} else {
		gwd::GWpublic_print "OK"  "vpls为etree业务tag模式、AC为port，NE1($gpnIp1)上ping pw12 ping通结果预计为100.00% 实为[dict get $value sucRate]%" $fileId
	}
	if {[string match [dict get $value replyIp] "20.6.5.2"]} {
		gwd::GWpublic_print "OK" "vpls为etree业务tag模式、AC为port，NE1($gpnIp1)上ping pw12的reply from 的ip应为20.6.5.2实为[dict get $value replyIp]" $fileId
	} else {
		set flag9_case2 1
		gwd::GWpublic_print "NOK" "vpls为etree业务tag模式、AC为port，NE1($gpnIp1)上ping pw12的reply from 的ip应为20.6.5.2实为[dict get $value replyIp]" $fileId
	}
	puts $fileId ""
	if {$flag9_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC2（结论）vpls为etree业务tag模式、AC为port，NE1($gpnIp1)上ping pw12 的测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2（结论）vpls为etree业务tag模式、AC为port，NE1($gpnIp1)上ping pw12 的测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式、AC为port，NE1($gpnIp1)上ping pw12  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式、AC为port，在NE1($gpnIp1)使用tracertroute查看报文从NE1到NE3经过的每一跳  测试开始=====\n"
	gwd::GWpublic_addPwTrace $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" result
	set flag10_case2 [Check_Tracertroute "" $expectTrace $result]
	if {$flag10_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC3（结论）vpls为etree业务tag模式、AC为port，在NE1($gpnIp1)使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3（结论）vpls为etree业务tag模式、AC为port，在NE1($gpnIp1)使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式、AC为port，在NE1($gpnIp1)使用tracertroute查看报文从NE1到NE3经过的每一跳  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT，向NE1的$GPNTestEth1\口发送协议报文  测试开始=====\n" 
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPort1Stream6" \
		-activate "false"
	foreach stream "$hProtocalStream1 $hProtocalStream2 $hProtocalStream3 $hProtocalStream4 $hProtocalStream5 $hProtocalStream6 $hProtocalStream7 \
		$hProtocalStream8 $hProtocalStream9" printStr "EFM CFM LLDP LACP MRPS LDP ISIS OSPF RIP" {
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "true"
		stc::perform ResultsClearViewCommand -ResultList "[stc::get $hGPNPort3Ana -children-AnalyzerPortResults] [stc::get $hGPNPort1Gen -children-GeneratorPortResults]"
		gwd::Start_SendFlow $hGPNPort1Gen $hGPNPort3Ana
		after 20000
		gwd::Stop_SendFlow $hGPNPort1Gen $hGPNPort3Ana
		after 2000
		set rxCnt [stc::get $hGPNPort3Ana.AnalyzerPortResults -SigFrameCount]
		set txCnt [stc::get $hGPNPort1Gen.GeneratorPortResults -GeneratorSigFrameCount]
		if {[string match "EFM" $printStr] || [string match "LACP" $printStr]} {
			if {$rxCnt != 0} {
				set flag11_case2 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，报文应被过滤，NE3($gpnIp3)$GPNTestEth3\接收应为0个实为$rxCnt\个" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，报文应被过滤，NE3($gpnIp3)$GPNTestEth3\接收应为0个实为$rxCnt\个" $fileId
			}
		} else {
			if {$rxCnt != $txCnt} {
				set flag11_case2 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，NE3($gpnIp3)$GPNTestEth3\接收$rxCnt\个" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，NE3($gpnIp3)$GPNTestEth3\接收$rxCnt\个" $fileId
			}
		}
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "false"
	}
	puts $fileId ""
	if {$flag11_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC4（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT，向NE1的$GPNTestEth1\口发送协议报文NE3($gpnIp3)$GPNTestEth3\口接收有丢包" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT，向NE1的$GPNTestEth1\口发送协议报文NE3($gpnIp3)$GPNTestEth3\口接收无丢包" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT，向NE1的$GPNTestEth1\口发送协议报文  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase2 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 2测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 2测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 2 ETREE业务TAG模式：(NE1($gpnIp1)$GPNTestEth1为PORT----NE3($gpnIp3)$GPNTestEth3为PORT)功能验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 ETREE业务TAG模式：(NE1($gpnIp1)$GPNTestEth1为PORT+VLAN----NE3($gpnIp3)$GPNTestEth3为PORT)功能验证测试\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+VLAN NE3的AC为PORT NE4的AC为PORT，NE1的$GPNTestEth1 NE4的$GPNTestEth4\发送数据流验证数据转发  测试开始=====\n"
	set flag1_case3 0
	set flag2_case3 0
	set flag3_case3 0
	set flag4_case3 0
	set flag5_case3 0
	set flag6_case3 0
	set flag7_case3 0
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac5"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121"
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "50" "0" "none" "modify" "50" "0" "0" "0x8100" "evc2"
	
	gwd::GWPw_DelMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231"
	
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac5"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33"
	
	##配置vlan check
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "enable"
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPortStreamList4" \
		-activate "true"
	incr capId
	if {[PortVlan_port_repeat_014 "" "GPN_PTN_014_2_$capId" $fileId $rateL $rateR]} {
		set flag1_case3 1
	}
	puts $fileId ""
	if {$flag1_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC5（结论）NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+VLAN NE3的AC为PORT NE4的AC为PORT，NE1的$GPNTestEth1 NE4的$GPNTestEth4\发送数据流验证数据转发" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5（结论）NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+VLAN NE3的AC为PORT NE4的AC为PORT，NE1的$GPNTestEth1 NE4的$GPNTestEth4\发送数据流验证数据转发" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+VLAN NE3的AC为PORT NE4的AC为PORT，NE1的$GPNTestEth1 NE4的$GPNTestEth4\发送数据流验证数据转发  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====镜像NE1($gpnIp1)到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，检查业务vlan的tag标签是否有变化  测试开始=====\n"
	stc::delete $hfilter16BitFilAna1
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPortStreamList4" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "true"
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	set hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vlanId" -Offset 44]
	set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-etherType" -Offset 46]
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
	}
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort5Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	if {$GPNPort5Cnt1(cnt5) == 0} {
		set flag2_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签有变化" $fileId
	} else {
		if {$GPNPort5Cnt1(cnt5) < $rateL1 || $GPNPort5Cnt1(cnt5) > $rateR1} {
			set flag2_case3 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化\
				但是速率为GPNPort5Cnt1(cnt5)，没在$rateL1-$rateR1\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发tag=50的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化\
				速率为$GPNPort5Cnt1(cnt5)，在$rateL1-$rateR1\范围内" $fileId
		}
	}
	puts $fileId ""
	if {$flag2_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC6（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT+VLAN)到NE3($gpnIp3)的NNI口$GPNPort5\的egress方向，业务vlan的tag标签有变化" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT+VLAN)到NE3($gpnIp3)的NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====镜像NE1($gpnIp1)到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，检查业务vlan的tag标签是否有变化  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，AC为PORT+VLAN；NE4($gpnIp4)vpws业务tag模式，AC为PORT；镜像NE1到NE4(AC为PORT)的NE1 NNI口$GPNPort12\的ingress方向，检查业务vlan的tag标签是否有变化  测试开始=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	#通过端口up down的操作清空镜像中学习到mac地址
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "undo shutdown"
	
	array set aMirror "dir1 ingress port1 $GPNPort12 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream7" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort4Stream7" \
		-activate "true"
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	if {[string match "L2" $Worklevel]} {
		set hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vid0" -Offset 40]
		set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vid1" -Offset 44]
	} else {
		set hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vid0" -Offset 44]
		set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vid1" -Offset 48]
	}
	
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
	}
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort4Gen"  $hGPNPort5Ana
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort5Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort4Gen"  $hGPNPort5Ana
	if {$GPNPort5Cnt1(cnt6) == 0} {
		set flag3_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE4($gpnIp4)$GPNTestEth4\的AC1互发tag=50的已知单播数据流，镜像NE1到NE4的NNI口$GPNPort12\的ingress方向，业务数据流没有添加tag=1的标签" $fileId
	} else {
		if {$GPNPort5Cnt1(cnt6) < $rateL1 || $GPNPort5Cnt1(cnt6) > $rateR1} {
			set flag3_case3 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE4($gpnIp4)$GPNTestEth4\的AC1互发tag=50的已知单播数据流，镜像NE1到NE4的NNI口$GPNPort12\的ingress方向，业务数据流添加了tag=1的标签\
				但是速率为GPNPort5Cnt1(cnt6)，没在$rateL1-$rateR1\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE4($gpnIp4)$GPNTestEth4\的AC1互发tag=50的已知单播数据流，镜像NE1到NE4的NNI口$GPNPort12\的ingress方向，业务数据流添加了tag=1的标签\
				速率为$GPNPort5Cnt1(cnt6)，在$rateL1-$rateR1\范围内" $fileId
		}
	}	
	puts $fileId ""
	if {$flag3_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC7（结论）vpls为etree业务tag模式，镜像NE1到NE4(AC为PORT)的NE1 NNI口$GPNPort12\的ingress方向，业务数据流没有添加tag=1的标签" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7（结论）vpls为etree业务tag模式，镜像NE1到NE4(AC为PORT)的NE1 NNI口$GPNPort12\的ingress方向，业务数据流添加了tag=1的标签" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，AC为PORT+VLAN；NE4($gpnIp4)vpws业务tag模式，AC为PORT；镜像NE1到NE4(AC为PORT)的NE1 NNI口$GPNPort12\的ingress方向，检查业务vlan的tag标签是否有变化  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响  测试开始=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	#通过端口up down的操作清空镜像中学习到mac地址
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort11 "shutdown"
	gwd::GWpublic_CfgPortState $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort11 "undo shutdown"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort4Stream7" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream6" \
		-activate "true"
	stc::apply
	###NE1-NE3之间再配置一条业务，共用同一条lsp
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11" 11 "etree" "flood" "false" "false" "false" "true" "2000" "evc3" "tag"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121" "vpls" "vpls11" "peer" $address612 "1001" "1001" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "60" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac5" "vpls11" "" $GPNTestEth1 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "tag"
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw231" "tag"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "l2transport" "11" "" $address621 "1001" "1001" "1" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231" "l2transport" "31" "" $address623 "2001" "2001" "3" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWPw_AddMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"

	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33" 33 "etree" "flood" "false" "false" "false" "true" "2000" "evc3" "tag"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321" "vpls" "vpls33" "peer" $address632 "2001" "2001" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "60" $GPNTestEth3
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac5" "vpls33" "" $GPNTestEth3 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	#测试新增业务的环回
	if {[TestPWLoop $fileId $rateL $rateR]} {
		set flag4_case3 1 
	}
	#对其他业务的影响------
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPortStreamList4" \
		-activate "true"
	incr capId
	if {[PortVlan_port_repeat_014 "" GPN_PTN_014_2_$capId $fileId $rateL $rateR]} {
		set flag4_case3 1
	}
	#------对其他业务的影响
	puts $fileId ""
	if {$flag4_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC8（结论）vpls为etree业务tag模式、PORT+VLAN---PORT，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8（结论）vpls为etree业务tag模式、PORT+VLAN---PORT，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，NE1上ping pw12  测试开始=====\n"
	stc::delete $hfilter16BitFilAna1
	gwd::GWpublic_delPwLoop $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	gwd::GWpublic_addPwPing $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" value
	puts "value:$value"
	if {![dict get $value sucRate]==100.00} {
		set flag5_case3 1 
		gwd::GWpublic_print "NOK"  "NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，NE1上ping pw12 ping通结果预计为100.00% 实为[dict get $value sucRate]%" $fileId
	} else {
		gwd::GWpublic_print "OK"  "NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，NE1上ping pw12 ping通结果预计为100.00% 实为[dict get $value sucRate]%" $fileId
	}
	if {[string match [dict get $value replyIp] "20.6.5.2"]} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，NE1($gpnIp1)上ping pw12的reply from 的ip应为20.6.5.2实为[dict get $value replyIp]" $fileId
	} else {
		set flag5_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，NE1($gpnIp1)上ping pw12的reply from 的ip应为20.6.5.2实为[dict get $value replyIp]" $fileId
	}
	puts $fileId ""
	if {$flag5_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC9（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，NE1上ping pw12 的测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC9（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，NE1上ping pw12 的测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，NE1上ping pw12  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳  测试开始=====\n"
	gwd::GWpublic_addPwTrace $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" result
	set flag6_case3 [Check_Tracertroute "" $expectTrace $result]
	if {$flag6_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FD1（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD1（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式、AC为port，在NE1($gpnIp1)使用tracertroute查看报文从NE1到NE3经过的每一跳  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+VLAN，向NE1的$GPNTestEth1\口发送协议报文  测试开始=====\n" 
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPortStreamList4 $hGPNPort1Stream6" \
		-activate "false"
	foreach stream "$hProtocalStream1 $hProtocalStream2 $hProtocalStream3 $hProtocalStream4 $hProtocalStream5 $hProtocalStream6 $hProtocalStream7 \
		$hProtocalStream8 $hProtocalStream9" printStr "EFM CFM LLDP LACP MRPS LDP ISIS OSPF RIP" {
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "true"
		stc::perform ResultsClearViewCommand -ResultList "[stc::get $hGPNPort3Ana -children-AnalyzerPortResults] [stc::get $hGPNPort1Gen -children-GeneratorPortResults]"
		gwd::Start_SendFlow $hGPNPort1Gen $hGPNPort3Ana
		after 20000
		gwd::Stop_SendFlow $hGPNPort1Gen $hGPNPort3Ana
		after 2000
		set rxCnt [stc::get $hGPNPort3Ana.AnalyzerPortResults -SigFrameCount]
		set txCnt [stc::get $hGPNPort1Gen.GeneratorPortResults -GeneratorSigFrameCount]
		if {[string match "EFM" $printStr] || [string match "LACP" $printStr]} {
			if {$rxCnt != 0} {
				set flag7_case3 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，报文应被过滤，NE3($gpnIp3)$GPNTestEth3\接收应为0个实为$rxCnt\个" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，报文应被过滤，NE3($gpnIp3)$GPNTestEth3\接收应为0个实为$rxCnt\个" $fileId
			}
		} else {
			if {$rxCnt != $txCnt} {
				set flag7_case3 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，NE3($gpnIp3)$GPNTestEth3\接收$rxCnt\个" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，NE3($gpnIp3)$GPNTestEth3\接收$rxCnt\个" $fileId
			}
		}
		
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "false"
	}
	puts $fileId ""
	if {$flag7_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FD2（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+VLAN，向NE1的$GPNTestEth1\口发送协议报文NE3($gpnIp3)$GPNTestEth3\口接收有丢包" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD2（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+VLAN，向NE1的$GPNTestEth1\口发送协议报文NE3($gpnIp3)$GPNTestEth3\口接收无丢包" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+VLAN，向NE1的$GPNTestEth1\口发送协议报文  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase3 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 3测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 3测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 3 ETREE业务TAG模式：(NE1($gpnIp1)$GPNTestEth1为PORT+VLAN----NE3($gpnIp3)$GPNTestEth3为PORT)功能验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 ETREE业务TAG模式：(NE1($gpnIp1)$GPNTestEth1为PORT+V1----NE3($gpnIp3)$GPNTestEth3为PORT+V2)功能验证测试\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+V1 NE3的AC为PORT+V2 NE4的AC为PORT，NE1的$GPNTestEth1 NE3的$GPNTestEth3\发送数据流验证数据转发  测试开始=====\n"
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set flag5_case4 0
	set flag6_case4 0
	set flag7_case4 0
	
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac5"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121"
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11"
		
	gwd::GWPw_DelMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231"
	
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac5"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33"
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "80" $GPNTestEth3
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "2000" "2000" "" "add" "root" 1 0 "0x9100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "vpls3" "" $GPNTestEth3 "80" "0" "leaf" "modify" "80" "0" "0" "0x9100" "evc2"
	##配置vlan check
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "enable"
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPortStreamList2" \
		-activate "true"
	incr capId
	if {[PortVlan1_portVlan2_tag_repeat_014 "" "GPN_PTN_014_2_$capId" $fileId $rateL $rateR]} {
		set flag1_case4 1
	}
	puts $fileId ""
	if {$flag1_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD3（结论）NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+V1 NE3的AC为PORT+V2 NE4的AC为PORT，NE1的$GPNTestEth1 NE3的$GPNTestEth3\发送数据流验证数据转发" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD3（结论）NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+V1 NE3的AC为PORT+V2 NE4的AC为PORT，NE1的$GPNTestEth1 NE3的$GPNTestEth3\发送数据流验证数据转发" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+V1 NE3的AC为PORT+V2 NE4的AC为PORT，NE1的$GPNTestEth1\发送数据流验证数据转发  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====镜像NE1($gpnIp1)到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，检查业务vlan的tag标签是否有变化  测试开始=====\n"
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPortStreamList2" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream10" \
		-activate "true"
	
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	set hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vlanId" -Offset 44]
	set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-etherType" -Offset 46]
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
	}
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort5Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	if {$GPNPort5Cnt1(cnt5) == 0} {
		set flag2_case4 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签有变化" $fileId
	} else {
		if {$GPNPort5Cnt1(cnt5) < $rateL1 || $GPNPort5Cnt1(cnt5) > $rateR1} {
			set flag2_case4 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化\
				但是速率为GPNPort5Cnt1(cnt5)，没在$rateL1-$rateR1\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化\
				速率为$GPNPort5Cnt1(cnt5)，在$rateL1-$rateR1\范围内" $fileId
		}
	}
	puts $fileId ""
	if {$flag2_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD4（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT+V1)到NE3($gpnIp3)的NNI口$GPNPort5\的egress方向，业务vlan的tag标签有变化" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD4（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT+V1)到NE3($gpnIp3)的NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====镜像NE1($gpnIp1)到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，检查业务vlan的tag标签是否有变化  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====镜像NE1($gpnIp1)到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的ingress方向，检查业务vlan的tag标签是否有变化  测试开始=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	array set aMirror "dir1 ingress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
		
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	if {[string match "L2" $Worklevel]} {
		set hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vlanId" -Offset 40]
		set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-etherType" -Offset 38]
	} else {
		set hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-vlanId" -Offset 44]
		set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "customer-etherType" -Offset 42]
	}
	
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
	}
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort5Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	if {$GPNPort5Cnt1(cnt7) == 0} {
		set flag7_case4 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的ingress方向，业务vlan的tag标签变化错误" $fileId
	} else {
		if {$GPNPort5Cnt1(cnt7) < $rateL1 || $GPNPort5Cnt1(cnt7) > $rateR1} {
			set flag7_case4 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的ingress方向，业务数据流添加tpid=9100 vid=1的一层标签\
				但是速率为GPNPort5Cnt1(cnt7)，没在$rateL1-$rateR1\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的ingress方向，业务数据流添加tpid=9100 vid=1的一层标签\
				速率为$GPNPort5Cnt1(cnt7)，在$rateL1-$rateR1\范围内" $fileId
		}
	}
	puts $fileId ""
	if {$flag7_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FF1（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT+V1)到NE3($gpnIp3)的NNI口$GPNPort5\的ingress方向，业务数据流的tag标签变化错误" $fileId
	} else {
		gwd::GWpublic_print "OK" "FF1（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT+V1)到NE3($gpnIp3)的NNI口$GPNPort5\的ingress方向，业务数据流添加tpid=9100 vid=1的一层标签" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====镜像NE1($gpnIp1)到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，检查业务vlan的tag标签是否有变化  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响  测试开始=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	#通过端口up down的操作清空镜像中学习到mac地址
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "undo shutdown"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort3Stream10" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream6" \
		-activate "true"
	stc::apply
	###NE1-NE3之间再配置一条业务，共用同一条lsp
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11" 11 "etree" "flood" "false" "false" "false" "true" "2000" "evc3" "tag"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121" "vpls" "vpls11" "peer" $address612 "1001" "1001" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "60" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac5" "vpls11" "" $GPNTestEth1 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "tag"
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw231" "tag"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "l2transport" "11" "" $address621 "1001" "1001" "1" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231" "l2transport" "31" "" $address623 "2001" "2001" "3" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWPw_AddMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"

	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33" 33 "etree" "flood" "false" "false" "false" "true" "2000" "evc3" "tag"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321" "vpls" "vpls33" "peer" $address632 "2001" "2001" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "60" $GPNTestEth3
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac5" "vpls33" "" $GPNTestEth3 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	#测试新增业务的环回
	if {[TestPWLoop $fileId $rateL $rateR]} {
		set flag3_case4 1 
	}
	#对其他业务的影响------
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPortStreamList2" \
		-activate "true"
	incr capId
	if {[PortVlan1_portVlan2_tag_repeat_014 "" GPN_PTN_014_2_$capId $fileId $rateL $rateR]} {
		set flag3_case4 1
	}
	#------对其他业务的影响
	puts $fileId ""
	if {$flag3_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD5（结论）vpls为etree业务tag模式、PORT+V1---PORT+V2，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD5（结论）vpls为etree业务tag模式、PORT+V1---PORT+V2，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1上ping pw12  测试开始=====\n"
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	gwd::GWpublic_delPwLoop $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	gwd::GWpublic_addPwPing $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" value
	puts "value:$value"
	if {![dict get $value sucRate]==100.00} {
		set flag4_case4 1 
		gwd::GWpublic_print "NOK"  "NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1上ping pw12 ping通结果预计为100.00% 实为[dict get $value sucRate]%" $fileId
	} else {
		gwd::GWpublic_print "OK"  "NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1上ping pw12 ping通结果预计为100.00% 实为[dict get $value sucRate]%" $fileId
	}
	if {[string match [dict get $value replyIp] "20.6.5.2"]} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1($gpnIp1)上ping pw12的reply from 的ip应为20.6.5.2实为[dict get $value replyIp]" $fileId
	} else {
		set flag4_case4 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1($gpnIp1)上ping pw12的reply from 的ip应为20.6.5.2实为[dict get $value replyIp]" $fileId
	}
	puts $fileId ""
	if {$flag4_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD6（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1上ping pw12 的测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD6（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1上ping pw12 的测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1上ping pw12  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳  测试开始=====\n"
	gwd::GWpublic_addPwTrace $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" result
	set flag5_case4 [Check_Tracertroute "" $expectTrace $result]
	if {$flag5_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD7（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD7（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+V1，向NE1的$GPNTestEth1\口发送协议报文  测试开始=====\n" 
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPortStreamList2 $hGPNPort1Stream6" \
		-activate "false"
	foreach stream "$hProtocalStream1 $hProtocalStream2 $hProtocalStream3 $hProtocalStream4 $hProtocalStream5 $hProtocalStream6 $hProtocalStream7 \
		$hProtocalStream8 $hProtocalStream9" printStr "EFM CFM LLDP LACP MRPS LDP ISIS OSPF RIP" {
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "true"
		stc::perform ResultsClearViewCommand -ResultList "[stc::get $hGPNPort3Ana -children-AnalyzerPortResults] [stc::get $hGPNPort1Gen -children-GeneratorPortResults]"
		gwd::Start_SendFlow $hGPNPort1Gen $hGPNPort3Ana
		after 20000
		gwd::Stop_SendFlow $hGPNPort1Gen $hGPNPort3Ana
		after 2000
		set rxCnt [stc::get $hGPNPort3Ana.AnalyzerPortResults -SigFrameCount]
		set txCnt [stc::get $hGPNPort1Gen.GeneratorPortResults -GeneratorSigFrameCount]
		if {[string match "EFM" $printStr] || [string match "LACP" $printStr]} {
			if {$rxCnt != 0} {
				set flag6_case4 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，报文应被过滤，NE3($gpnIp3)$GPNTestEth3\接收应为0个实为$rxCnt\个" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，报文应被过滤，NE3($gpnIp3)$GPNTestEth3\接收应为0个实为$rxCnt\个" $fileId
			}
		} else {
			if {$rxCnt != $txCnt} {
				set flag6_case4 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，NE3($gpnIp3)$GPNTestEth3\接收$rxCnt\个" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，NE3($gpnIp3)$GPNTestEth3\接收$rxCnt\个" $fileId
			}
		}
		
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "false"
	}
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD8（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\:PORT+V1--NE3($gpnIp3)$GPNTestEth3\:PORT+V2，向NE1的$GPNTestEth1\口发送协议报文NE3的$GPNTestEth3\口接收有丢包" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD8（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\:PORT+V1--NE3($gpnIp3)$GPNTestEth3\:PORT+V2，向NE1的$GPNTestEth1\口发送协议报文NE3的$GPNTestEth3\口接收无丢包" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+VLAN，向NE1的$GPNTestEth1\口发送协议报文  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase4 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 4测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 4测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 4 ETREE业务TAG模式：(NE1($gpnIp1)$GPNTestEth1为PORT+V1----NE3($gpnIp3)$GPNTestEth3为PORT+V2)功能验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 ETREE业务TAG模式：(NE1($gpnIp1)$GPNTestEth1为PORT+SVLAN+CVLAN----NE3($gpnIp3)$GPNTestEth3为PPORT+SVLAN+CVLAN)功能验证测试\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+SVLAN+CVLAN NE3的AC为PORT+SVLAN+CVLAN NE4的AC为PORT，NE1的$GPNTestEth1\发送数据流验证数据转发  测试开始=====\n"
	set flag1_case5 0
	set flag2_case5 0
	set flag3_case5 0
	set flag4_case5 0
	set flag5_case5 0
	set flag6_case5 0
	set flag7_case5 0
	set flag8_case5 0
	set flag9_case5 0
	set flag10_case5 0
		
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac5"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121"
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "1004" "1004" "" "add" "none" 1 0 "0x8100" "0x8100" "4"
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "80" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "80" "500" "root" "modify" "80" "0" "0" "0x8100" "evc2"
	
	gwd::GWPw_DelMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231"
	
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac5"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "2000" "2000" "" "add" "root" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "vpls3" "" $GPNTestEth3 "80" "500" "leaf" "modify" "80" "0" "0" "0x8100" "evc2"
	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPort1Stream5" \
		-activate "true"
	incr capId
	if {[PortSVlanCvlan_portSVlanCvlan_repeat_014 "" "GPN_PTN_014_2_$capId" $fileId $rateL $rateR]} {
		set flag1_case5 1
	}
	puts $fileId ""
	if {$flag1_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD9（结论）NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+SVLAN+CLVAN NE3的AC为PORT+SVLAN+CLVAN NE4的AC为PORT，NE1的$GPNTestEth1\发送数据流验证数据转发" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD9（结论）NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+SVLAN+CLVAN NE3的AC为PORT+SVLAN+CLVAN NE4的AC为PORT，NE1的$GPNTestEth1\发送数据流验证数据转发" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+SVLAN+CVLAN NE3的AC为PORT+SVLAN+CVLAN NE4的AC为PORT，NE1的$GPNTestEth1\发送数据流验证数据转发  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====镜像NE1($gpnIp1)到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，检查业务vlan的tag标签是否有变化  测试开始=====\n"
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream5 $hGPNPort3Stream8" \
		-activate "true"
	
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg0
	set hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $hGPNPort5Ana -FilterName "VLAN TAG" -Offset 50]
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	if {$cap_enable} {
		gwd::Start_CapAllData ::capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
	}
	gwd::Start_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	after 10000
	incr capId
	if {$cap_enable} {
		gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_014_2_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort5Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 3 $hGPNPort5Ana GPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort5Cnt1
	gwd::Stop_SendFlow "$hGPNPort1Gen $hGPNPort3Gen"  $hGPNPort5Ana
	if {$GPNPort5Cnt1(cnt1) == 0} {
		set flag2_case5 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发外层tag=80内层tag=500的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签有变化" $fileId
	} else {
		if {$GPNPort5Cnt1(cnt1) < $rateL1 || $GPNPort5Cnt1(cnt1) > $rateR1} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发外层tag=80内层tag=500的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化\
				但是速率为GPNPort5Cnt1(cnt1)，没在$rateL1-$rateR1\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\的AC1和NE3($gpnIp3)$GPNTestEth3\的AC1互发外层tag=80内层tag=500的已知单播数据流，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化\
				速率为$GPNPort5Cnt1(cnt1)，在$rateL1-$rateR1\范围内" $fileId
		}
	}
	puts $fileId ""
	if {$flag2_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE1（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT+SVLAN+CLVAN)到NE3($gpnIp3)的NNI口$GPNPort5\的egress方向，业务vlan的tag标签有变化" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE1（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT+SVLAN+CLVAN)到NE3($gpnIp3)的NNI口$GPNPort5\的egress方向，业务vlan的tag标签没有变化" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====镜像NE1($gpnIp1)到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，检查业务vlan的tag标签是否有变化  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响  测试开始=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::delete $hfilter16BitFilAna2
	#通过端口up down的操作清空镜像中学习到mac地址
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "shutdown"
	gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "undo shutdown"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream5 $hGPNPort3Stream8" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream6" \
		-activate "true"
	stc::apply
	###NE1-NE3之间再配置一条业务，共用同一条lsp
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11" 11 "etree" "flood" "false" "false" "false" "true" "2000" "evc3" "tag"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121" "vpls" "vpls11" "peer" $address612 "1001" "1001" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "60" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac5" "vpls11" "" $GPNTestEth1 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "tag"
	gwd::GWPw_AddPwVcType $telnet2 $matchType2 $Gpn_type2 $fileId "pw231" "tag"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "l2transport" "11" "" $address621 "1001" "1001" "1" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231" "l2transport" "31" "" $address623 "2001" "2001" "3" "add" "" 1 0 "0x8100" "0x8100" ""
	gwd::GWPw_AddMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"

	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33" 33 "etree" "flood" "false" "false" "false" "true" "2000" "evc3" "tag"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321" "vpls" "vpls33" "peer" $address632 "2001" "2001" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "60" $GPNTestEth3
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac5" "vpls33" "" $GPNTestEth3 "60" "0" "none" "modify" "60" "0" "0" "0x8100" "evc3"
	#测试新增业务的环回
	if {[TestPWLoop $fileId $rateL $rateR]} {
		set flag3_case5 1 
	}
	#对其他业务的影响------
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPort1Stream5" \
		-activate "true"
	incr capId
	if {[PortSVlanCvlan_portSVlanCvlan_repeat_014 "" GPN_PTN_014_2_$capId $fileId $rateL $rateR]} {
		set flag3_case5 1
	}
	#------对其他业务的影响
	puts $fileId ""
	if {$flag3_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE2（结论）vpls为etree业务tag模式、PORT+SVLAN+CVLAN---PORT+SVLAN+CVLAN，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE2（结论）vpls为etree业务tag模式、PORT+SVLAN+CVLAN---PORT+SVLAN+CVLAN，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1上ping pw12  测试开始=====\n"
	gwd::GWpublic_delPwLoop $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"
	gwd::GWpublic_addPwPing $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" value
	puts "value:$value"
	if {![dict get $value sucRate]==100.00} {
		set flag4_case5 1 
		gwd::GWpublic_print "NOK"  "NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1上ping pw12 ping通结果预计为100.00% 实为[dict get $value sucRate]%" $fileId
	} else {
		gwd::GWpublic_print "OK"  "NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1上ping pw12 ping通结果预计为100.00% 实为[dict get $value sucRate]%" $fileId
	}
	if {[string match [dict get $value replyIp] "20.6.5.2"]} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1($gpnIp1)上ping pw12的reply from 的ip应为20.6.5.2实为[dict get $value replyIp]" $fileId
	} else {
		set flag4_case5 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1($gpnIp1)上ping pw12的reply from 的ip应为20.6.5.2实为[dict get $value replyIp]" $fileId
	}
	puts $fileId ""
	if {$flag4_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE3（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1上ping pw12 的测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE3（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1上ping pw12 的测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1上ping pw12  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳  测试开始=====\n"
	gwd::GWpublic_addPwTrace $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" result
	set flag5_case5 [Check_Tracertroute "" $expectTrace $result]
	
	if {$flag5_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE4（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE4（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+SVLAN+CVLAN，向NE1的$GPNTestEth1\口发送协议报文  测试开始=====\n" 
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPort1Stream5 $hGPNPort1Stream6" \
		-activate "false"
	foreach stream "$hProtocalStream1 $hProtocalStream2 $hProtocalStream3 $hProtocalStream4 $hProtocalStream5 $hProtocalStream6 $hProtocalStream7 \
		$hProtocalStream8 $hProtocalStream9" printStr "EFM CFM LLDP LACP MRPS LDP ISIS OSPF RIP" {
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "true"
		stc::config $stream.ethernet:EthernetII.vlans.Vlan -id 80
		set hVlanContainer [stc::get $stream.ethernet:EthernetII -children-vlans]
		stc::create Vlan -under $hVlanContainer -id 500
		stc::apply
		stc::perform ResultsClearViewCommand -ResultList "[stc::get $hGPNPort3Ana -children-AnalyzerPortResults] [stc::get $hGPNPort1Gen -children-GeneratorPortResults]"
		gwd::Start_SendFlow $hGPNPort1Gen $hGPNPort3Ana
		after 20000
		gwd::Stop_SendFlow $hGPNPort1Gen $hGPNPort3Ana
		after 2000
		set rxCnt [stc::get $hGPNPort3Ana.AnalyzerPortResults -SigFrameCount]
		set txCnt [stc::get $hGPNPort1Gen.GeneratorPortResults -GeneratorSigFrameCount]
		if {[string match "EFM" $printStr] || [string match "LACP" $printStr]} {
			if {$rxCnt != 0} {
				set flag6_case5 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，报文应被过滤，NE3($gpnIp3)$GPNTestEth3\接收应为0个实为$rxCnt\个" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，报文应被过滤，NE3($gpnIp3)$GPNTestEth3\接收应为0个实为$rxCnt\个" $fileId
			}
		} else {
			if {$rxCnt != $txCnt} {
				set flag6_case5 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，NE3($gpnIp3)$GPNTestEth3\接收$rxCnt\个" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送$printStr\的协议报文速率为2M 共发送$txCnt\个，NE3($gpnIp3)$GPNTestEth3\接收$rxCnt\个" $fileId
			}
		}
		
		stc::perform streamBlockActivate \
			-streamBlockList "$stream" \
			-activate "false"
	}
	puts $fileId ""
	if {$flag6_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE5（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\:PORT+SVLAN+CVLAN--NE3($gpnIp3)$GPNTestEth3\:PORT+SVLAN+CVLAN，向NE1的$GPNTestEth1\口发送协议报文NE3的$GPNTestEth3\口接收有丢包" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE5（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\:PORT+SVLAN+CVLAN--NE3($gpnIp3)$GPNTestEth3\:PORT+SVLAN+CVLAN，向NE1的$GPNTestEth1\口发送协议报文NE3的$GPNTestEth3\口接收无丢包" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+SVLAN+CVLAN，向NE1的$GPNTestEth1\口发送协议报文  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复重启NNI口所在板卡后测试业务恢复和系统内存  测试开始=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList1 $hGPNPort1Stream5" \
		-activate "true"
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
				if {[PortSVlanCvlan_portSVlanCvlan_repeat_014 "第$j\次重启NE1($gpnIp1)$slot\槽位板卡" "GPN_PTN_014_2_$capId" $fileId $rateL $rateR]} {
					set  flag7_case5 1
				}
			} else {
				set testFlag 1
				gwd::GWpublic_print "OK" " NE1($gpnIp1)$slot\槽位板卡不支持板卡重启操作，测试跳过" $fileId
				break
			}
		}
		if {$testFlag == 0} {
			gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
			send_log "\n resource3:$resource3"
			send_log "\n resource4:$resource4"
			if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
				set flag7_case5 1
				gwd::GWpublic_print "NOK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
			} else {
				gwd::GWpublic_print "OK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
			}
		}
	}
	puts $fileId ""
	if {$flag7_case5 == 1} {
		set flagCase5 1
		 gwd::GWpublic_print "NOK" "FE6（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复重启NNI口所在板卡后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE6（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复重启NNI口所在板卡后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复重启NNI口所在板卡后测试业务恢复和系统内存  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行NMS主备倒换测试业务恢复和系统内存  测试开始=====\n" 
	set expectTable "0000.0000.0005 ac1"
	###反复进行NMS主备倒换
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PortSVlanCvlan_portSVlanCvlan_repeat_014 "第$j\次 NE1($gpnIp1)进行NMS主备倒换后" "GPN_PTN_014_2_$capId" $fileId $rateL $rateR]} {
				set  flag8_case5 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行NMS主备倒换后" $dTable $expectTable]} {
				set flag8_case5 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag 1
			break
		}
	}
	if {$testFlag == 0} {
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource6
	send_log "\n resource5:$resource5"
	send_log "\n resource6:$resource6"
	if {$resource6 > [expr $resource5 + $resource5 * $errRate]} {
		set flag8_case5 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
	}
	}
	puts $fileId ""
	if {$flag8_case5 == 1} {
	set flagCase5 1
	 gwd::GWpublic_print "NOK" "FE7（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	} else {
	gwd::GWpublic_print "OK" "FE7（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行NMS主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行SW主备倒换测试业务恢复和系统内存  测试开始=====\n" 
	##反复进行SW主备倒换
	set testFlag 0 ;#=1 测试跳过
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PortSVlanCvlan_portSVlanCvlan_repeat_014 "第$j\次 NE1($gpnIp1)进行SW主备倒换后" "GPN_PTN_014_2_$capId" $fileId $rateL $rateR]} {
				set  flag9_case5 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行SW主备倒换后" $dTable $expectTable]} {
				set flag9_case5 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\只有一个交换盘，测试跳过" $fileId
			set testFlag 1 ;#=1 测试跳过
			break
		}
	}
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource8
		send_log "\n resource7:$resource7"
		send_log "\n resource8:$resource8"
		if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
			set flag9_case5	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag9_case5 == 1} {
		set flagCase5 1
		 gwd::GWpublic_print "NOK" "FE8（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE8（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行SW主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行保存设备重启后测试业务恢复和系统内存  测试开始=====\n" 
	##反复保存设备重启
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[PortSVlanCvlan_portSVlanCvlan_repeat_014 "第$j\次 NE1($gpnIp1)进行保存设备重启后" "GPN_PTN_014_2_$capId" $fileId $rateL $rateR]} {
			set  flag10_case5 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
		if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行保存设备重启后" $dTable $expectTable]} {
			set flag10_case5 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag10_case5 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag10_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE9（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE9（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行保存设备重启后测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_014_2_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_014_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase5 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 5测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 5测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 5 ETREE业务TAG模式：(NE1($gpnIp1)$GPNTestEth1为PORT+SVLAN+CVLAN----NE3($gpnIp3)$GPNTestEth3为PORT+SVLAN+CVLAN)功能验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===恢复初始化配置...\n"
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"]
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac5"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw121"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.50 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.60 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.80 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort5.4 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort12.7 $matchType1 $Gpn_type1 $telnet1]

	lappend flagDel [gwd::GWPw_DelMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "pw23"]
	lappend flagDel [gwd::GWPw_DelMsPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211" "pw231"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw211"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw231"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort6.4 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort7.5 $matchType2 $Gpn_type2 $telnet2]
	
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac5"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw321"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls33"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.50 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.60 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.80 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort8.5 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort9.6 $matchType3 $Gpn_type3 $telnet3]

	lappend flagDel [gwd::GWAc_DelActPw $telnet4 $matchType4 $Gpn_type4 $fileId "ac1"]
	lappend flagDel [gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac1"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort10.6 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort11.7 $matchType4 $Gpn_type4 $telnet4]

	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet4 $matchType4 $Gpn_type4 $fileId $GPNTestEth4 "enable"
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort7 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort9 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort10 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort11 "none"]
	}
	
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
	
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "测试结束后配置恢复" "测试结束后配置恢复" "GPN_PTN_014_2"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "测试过程中所有配置文件都上传成功" "GPN_PTN_014_2"
	
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_014_2测试目的：ETREE业务TAG模式测试\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1==1 || $flagCase2==1 || $flagCase3==1 || $flagCase4==1 || $flagCase5==1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_014_2测试结果" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5测试结果" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，(NE1($gpnIp1)$GPNTestEth1：PORT+VLAN----NE3($gpnIp3)$GPNTestEth3：PORT+VLAN)，NE1 $GPNTestEth1\发送数据流验证数据转发" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，镜像NE1到NE3($gpnIp3)的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签[expr {($flag2_case1 == 1) ? "有" : "没有"}]变化" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1为PORT+VLAN；NE4($gpnIp4)vpws业务tag模式，$GPNTestEth4\为PORT；NE4的$GPNTestEth4\发送untag数据流验证数据转发" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，配置pw动作为modify、nochange、delete，[expr {($flag4_case1 == 1) ? "系统无错误提示或提示错误" : "系统提示动作被修改为add"}]" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac动作为delete、nochange、add，[expr {($flag5_case1 == 1) ? "系统无错误提示或提示错误" : "系统提示动作被修改为modify"}]" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac和pw动作错误系统自动修改后，发流验证配置" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag7_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac和pw动作错误系统自动修改后，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务vlan的tag标签[expr {($flag7_case1 == 1) ? "有" : "没有"}]变化" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag8_case1 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式、PORT+VLAN--PORT+VLAN，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag9_case1 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，NE1($gpnIp1)上ping pw12 的测试" $fileId
	gwd::GWpublic_print "== FB1 == [expr {($flag10_case1 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，在NE1($gpnIp1)使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag11_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+VLAN，向NE1的$GPNTestEth1\口发送协议报文NE3($gpnIp3)$GPNTestEth3\口接收[expr {($flag11_case1 == 1) ? "有" : "无"}]丢包" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，(NE1($gpnIp1)$GPNTestEth1：PORT----NE3($gpnIp3)$GPNTestEth3：PORT)，NE1 $GPNTestEth1\发送数据流验证数据转发" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT)到NE3($gpnIp3)的NNI口$GPNPort5\的egress方向，业务数据流[expr {($flag2_case2 == 1) ? "没有添加" : "添加了"}]tag=1的标签" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1为PORT；NE4($gpnIp4)vpws业务tag模式，$GPNTestEth4\为PORT；NE4的$GPNTestEth4\发送untag数据流验证数据转发" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT，配置pw动作为modify、nochange、delete，[expr {($flag4_case2 == 1) ? "系统无错误提示或提示错误" : "系统提示动作被修改为add"}]" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac动作为modify、nochange、add，[expr {($flag5_case2 == 1) ? "系统无错误提示或提示错误" : "系统提示动作被修改为delete"}]" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT+VLAN，配置ac和pw动作错误系统自动修改后，发流验证配置" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag7_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式 $GPNTestEth1\为PORT，配置ac和pw动作错误系统自动修改后，镜像NE1到NE3的NE1 NNI口$GPNPort5\的egress方向，业务数据流[expr {($flag7_case2 == 1) ? "没有添加" : "添加了"}]tag=1的标签" $fileId
	gwd::GWpublic_print "== FC1 == [expr {($flag8_case2 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式、PORT---PORT，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	gwd::GWpublic_print "== FC2 == [expr {($flag9_case2 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式、AC为port，NE1($gpnIp1)上ping pw12 的测试" $fileId
	gwd::GWpublic_print "== FC3 == [expr {($flag10_case2 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式、AC为port，在NE1($gpnIp1)使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	gwd::GWpublic_print "== FC4 == [expr {($flag11_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT，向NE1的$GPNTestEth1\口发送协议报文NE3($gpnIp3)$GPNTestEth3\口接收[expr {($flag11_case2 == 1) ? "有" : "无"}]丢包" $fileId
	gwd::GWpublic_print "== FC5 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+VLAN NE3的AC为PORT NE4的AC为PORT，NE1的$GPNTestEth1 NE4的$GPNTestEth4\发送数据流验证数据转发" $fileId
	gwd::GWpublic_print "== FC6 == [expr {($flag2_case3 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT+VLAN)到NE3($gpnIp3)的NNI口$GPNPort5\的egress方向，业务vlan的tag标签[expr {($flag2_case3 == 1) ? "有" : "没有"}]变化" $fileId
	gwd::GWpublic_print "== FC7 == [expr {($flag3_case3 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，镜像NE1到NE4(AC为PORT)的NE1 NNI口$GPNPort12\的ingress方向，业务数据流[expr {($flag3_case3 == 1) ? "没有添加" : "添加了"}]tag=1的标签" $fileId
	gwd::GWpublic_print "== FC8 == [expr {($flag4_case3 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式、PORT+VLAN---PORT，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	gwd::GWpublic_print "== FC9 == [expr {($flag5_case3 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，NE1上ping pw12 的测试" $fileId
	gwd::GWpublic_print "== FD1 == [expr {($flag6_case3 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+VLAN，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	gwd::GWpublic_print "== FD2 == [expr {($flag7_case3 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式，$GPNTestEth1\为PORT+VLAN，向NE1的$GPNTestEth1\口发送协议报文NE3($gpnIp3)$GPNTestEth3\口接收[expr {($flag7_case3 == 1) ? "有" : "无"}]丢包" $fileId
	gwd::GWpublic_print "== FD3 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+V1 NE3的AC为PORT+V2 NE4的AC为PORT，NE1的$GPNTestEth1 NE3的$GPNTestEth3\发送数据流验证数据转发" $fileId
	gwd::GWpublic_print "== FD4 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT+V1)到NE3($gpnIp3)的NNI口$GPNPort5\的egress方向，业务vlan的tag标签[expr {($flag2_case4 == 1) ? "有" : "没有"}]变化" $fileId
	gwd::GWpublic_print "== FF1 == [expr {($flag7_case4 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT+V1)到NE3($gpnIp3)的NNI口$GPNPort5\的ingress方向，业务数据流[expr {($flag7_case4 == 1) ? "没有" : ""}]添加tpid=9100 vid=1的一层标签" $fileId
	gwd::GWpublic_print "== FD5 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式、PORT+V1---PORT+V2，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	gwd::GWpublic_print "== FD6 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1上ping pw12 的测试" $fileId
	gwd::GWpublic_print "== FD7 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+V1，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	gwd::GWpublic_print "== FD8 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\:PORT+V1--NE3($gpnIp3)$GPNTestEth3\:PORT+V2，向NE1的$GPNTestEth1\口发送协议报文NE3的$GPNTestEth3\口接收[expr {($flag6_case4 == 1) ? "有" : "无"}]丢包" $fileId
	gwd::GWpublic_print "== FD9 == [expr {($flag1_case5 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)和NE3($gpnIp3)为vpls的etree业务tag模式、NE4($gpnIp4)为VPWS tag模式，NE1的AC为PORT+SVLAN+CLVAN NE3的AC为PORT+SVLAN+CLVAN NE4的AC为PORT，NE1的$GPNTestEth1\发送数据流验证数据转发" $fileId
	gwd::GWpublic_print "== FE1 == [expr {($flag2_case5 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，镜像NE1(AC为PORT+SVLAN+CLVAN)到NE3($gpnIp3)的NNI口$GPNPort5\的egress方向，业务vlan的tag标签[expr {($flag2_case5 == 1) ? "有" : "没有"}]变化" $fileId
	gwd::GWpublic_print "== FE2 == [expr {($flag3_case5 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式、PORT+SVLAN+CVLAN---PORT+SVLAN+CVLAN，NE1($gpnIp1)-NE3($gpnIp3)之间再配置一条业务并在NE3的pw上配置环回，测试环回数据流和对其它业务的影响" $fileId
	gwd::GWpublic_print "== FE3 == [expr {($flag4_case5 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1上ping pw12 的测试" $fileId
	gwd::GWpublic_print "== FE4 == [expr {($flag5_case5 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)vpls为etree业务tag模式、AC为PORT+SVLAN+CVLAN，NE1上使用tracertroute查看报文从NE1到NE3经过的每一跳" $fileId
	gwd::GWpublic_print "== FE5 == [expr {($flag6_case5 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\:PORT+SVLAN+CVLAN--NE3($gpnIp3)$GPNTestEth3\:PORT+SVLAN+CVLAN，向NE1的$GPNTestEth1\口发送协议报文NE3的$GPNTestEth3\口接收[expr {($flag6_case5 == 1) ? "有" : "无"}]丢包" $fileId
	gwd::GWpublic_print "== FE6 == [expr {($flag7_case5 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复重启NNI口所在板卡后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FE7 == [expr {($flag8_case5 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FE8 == [expr {($flag9_case5 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FE9 == [expr {($flag10_case5 == 1) ? "NOK" : "OK"}]" "（结论）vpls为etree业务tag模式，NE1($gpnIp1)$GPNTestEth1\为PORT+SVLAN+CVLAN，NE1反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "（结论）测试结束后配置恢复" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "（结论）测试过程中配置文件的上传" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "运行异常：错误为$err" "" "GPN_PTN_014_2"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_014_2_REPORT.txt" "report\\NOK_GPN_PTN_014_2_REPORT.txt"
	file rename "log\\GPN_PTN_014_2_LOG.txt" "log\\NOK_GPN_PTN_014_2_LOG.txt"
} else {
	file rename "report\\GPN_PTN_014_2_REPORT.txt" "report\\OK_GPN_PTN_014_2_REPORT.txt"
	file rename "log\\GPN_PTN_014_2_LOG.txt" "log\\OK_GPN_PTN_014_2_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}

