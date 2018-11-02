#!/bin/sh
# T4_GPN_PTN_ELAN_008.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#测试目的：E-LAN与其他模块互操作
#1-与FDB互操作  
#2-与trunk互操作
#3-与QOS互操作 
#4-与OAM互操作
#5-与DCN互操作
#6-与CES业务互操作
#7-与ELINE、ETREE业务互操作 
#8-与环路检测互操作                                           				                     	           
#---------------------------------------------------------------------------------------------------------------------------------
#脚本运行条件：
#1、按照测试拓扑搭建测试环境:将GPN的管理端口（U/D）和PC的网口与Internet相连，GPN的2个上联口
#   与STC端口（ 9/9）（9/10）
#2、在GPN上清空所有 配置，建立管理vlan vid=4000，在该vlan上设置管理IP，并untagged方式添加管理端口（U/D）
#-----------------------------------------------------------------------------------------------------------------------------------
#测试过程：
#1、搭建Test Case 1测试环境
##与FDB互操作   
#   <1>配置ELAN业务并发送数据流，查看mac地址表项 mac地址学习正确
#   预期结果：基于vpls域、PW、AC查询，均能正确查询
#   <2>停止发流，5min后mac地址老化
#   <3>再次发流，Mac重新学习
##与TRUNK互操作
#   <4>三台76清空配置 ，NE1--NE2--NE3两两互连，NE1设备通过带外上网管，NE2和NE3设备是带内上网管，彼此之间的NNI端口配置为trunk端口，其中trunk各自绑定2个端口，2个端口都是up
#   <5>配置E-LAN业务数据，业务数据配置成功
##trunk组的模式为sharing
#   <6>命令down/up trunk主端口50次，业务正常倒换和恢复，记录下业务倒换和恢复时间（不超过50ms）
#   <7>命令down/up trunk从端口50次，系统无异常，业务不发生倒换，无丢包
#   <8>trunk组端口成员均命令down，业务中断；恢复trunk组其中一个端口成员，业务可恢复
#   <9>更改trunk组的模式为1:1重复6-7步骤
#   <10> 从两端设备的trunk中各添加一个down的端口，端口添加成功，业务不受影响
#        再从这两端设备的trunk中删除该down的端口，端口删除成功，业务不受影响
#        再从两端设备的trunk中各添加一个up的端口，端口添加成功，业务不受影响
#        再从这两端设备的trunk中删除该up的端口，端口删除成功，业务不受影响
#   <11>配置trunk组端口成员跨板卡，重复6-10步
#   <12>将UNI侧的端口配置为turnk端口，配置业务数据，业务数据配置成功，业务数据流并正常转发
#   <13>所配置的trunk聚合方式为静态，重复6-12步
#2、搭建Test Case 2测试环境
##与QOS互操作
#   <14>配合二层qos，策略为限速，绑定到ac端口上，验证限速生效
#   <15>配置QoS限速，把QoS策略绑定到AC/PW/LSP，验证限速可以生效
#   预期结果：遵从AC速率不可超过PW，PW速率不可超过LSP，若有违背，系统有相应的提示
#   <16>配置一条PW 队列调度并配置限速，系统无异常配置成功，发送数据流量，观察接收到不同优先级的数据流的多少比例是符合配置
##与OAM互操作
#   <17>配置段层/PW/LSP层0AM，可成功配置，系统无异常，对业务数据转发无影响
#   <18>设置段层/PW/LSP层相应的CC功能禁止/使能，设置成功并系统无异常，对业务数据转发无影响
#   <19>设置段层/PW/LSP层相应的CC时间间隔参数，设置成功并系统无异常，对业务数据转发无影响
##与DCN互操作 
#   <20>4台设备用DCN进行网管，其中一台为网关网元，剩下三台为非网关网元
#   <21>4台设备发送ping包均正常，设备均可正常上网管
#   预期结果：业务数据流正常转发，系统无异常
#             删除所创建的DCN配置，对E-LAN业务无影响
##与CES业务互操作 
#   <22>与之前创建的E-LAN业务共用LSP，因只需配置PW和相应的CES业务
#   预期结果：CES业务配置成功，系统无异常
#            CES业务和之前的E-LAN业务正常转发
#   <24>彼此之间无干扰 在CES业务和E-LAN业务共用的LSP上做限速，系统无异常，CES业务和E-LAN业务可正常转发
#3、搭建Test Case 3测试环境
##与ELINE、ETREE业务互操作
#   <1>4台设备原有E-LAN业务的基础上，创建新的业务ELINE/ETREE
#   <2>其中NE1、NE2、NE4上创建ETREE业务，NE1为汇聚设备；NE3、NE4之间创建ELINE业务
#   预期结果:新的业务ELAN/ETREE业务成功创建，系统无异常，对之前的业务无影响
#            每条业务都正常转发，彼此之间无干扰，系统利用率正常
##与环路检测互操作
#   <3>打开环路检测，uni口下挂远端，业务从远端进入局端
#   <4>在远端制造环路
#   预期结果:告警正常上报，对业务无影响
#           在7600其他板卡上制造环路，告警正常上报对业务无影响
#   <5>配置两条ELAN业务，同一设备的两个UNI口制造环路
#   预期结果:告警正常上报，对另外两台设备业务没有影响
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_008_LOG.txt" a]
        set stdout $fd_log
        chan configure $fd_log -blocking 0 -buffering none;#非阻塞模式 按行flush
        log_file log\\GPN_PTN_008_LOG.txt
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_008_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#非阻塞模式 按行flush
        
        file mkdir "debug"
        set fd_debug [open debug\\GPN_PTN_008_DEBUG.txt a]
        exp_internal -f debug\\GPN_PTN_008_DEBUG.txt 0
        chan configure $fd_debug -blocking 0 -buffering none;#非阻塞模式 按行flush
          
	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl

        ###数据流设置
        array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "500" -pri "000"}
        array set dataArr7 {-srcMac "00:00:00:00:00:22" -dstMac "00:00:00:00:00:02" -srcIp "192.85.1.7" -dstIp "192.0.0.7" -vid "500" -pri "000"}
        array set dataArr12 {-srcMac "00:00:00:00:00:0c" -dstMac "00:00:00:00:00:cc" -srcIp "192.85.1.12" -dstIp "192.0.0.12" -vid "800" -pri "000"}
        array set dataArr13 {-srcMac "00:00:00:00:00:0d" -dstMac "00:00:00:00:00:dd" -srcIp "192.85.1.13" -dstIp "192.0.0.13" -vid "800" -pri "000"}
        array set dataArr20 {-srcMac "00:00:00:00:00:cc" -dstMac "00:00:00:00:00:0c" -srcIp "192.85.1.20" -dstIp "192.0.0.20" -vid "800" -pri "000"}
        array set dataArr17 {-srcMac "00:00:00:00:00:f3" -dstMac "00:00:00:00:01:01" -srcIp "192.85.1.17" -dstIp "192.0.0.17" -vid "800" -pri "000"}
        array set dataArr1 {-srcMac "00:00:00:00:00:f2" -dstMac "00:00:00:00:f2:f2" -srcIp "192.85.1.1" -dstIp "192.0.0.1" -vid "100" -pri "000"}
        array set dataArr21 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:f3:f3" -srcIp "192.85.1.21" -dstIp "192.0.0.21" -vid "102" -pri "000"}
        array set dataArr4 {-srcMac "00:00:00:00:00:04" -dstMac "00:00:00:00:00:44" -srcIp "192.85.1.4" -dstIp "192.0.0.4" -vid "104" -pri "000"}
        ###设置定制信息参数
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        ###设置发生器参数
        set GenCfg {-SchedulingMode RATE_BASED}
        ###设置过滤分析器参数
        ####匹配smc
        set anaFliFrameCfg0 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	##匹配smc、vid、EtherType
        set anaFliFrameCfg1 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType><vlans name="anon_2561"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        ##匹配两层vid
        set anaFliFrameCfg4 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5580"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        #####mpls报文中的smac和 vid
        #set anaFliFrameCfg51 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5699"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu></pdus></config></frame>}
        ##mpls报文中的两层标签
        set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
	##匹配smac、ethtype
	set anaFliFrameCfg7 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}

	set rateL 95000000;#收发数据流取值最小值范围
	set rateR 105000000;#收发数据流取值最大值范围
	set rateL1 100000000 
	set rateR1 125000000
	
	set flagCase1 0   ;#Test case 1标志位 
	set flagCase2 0   ;#Test case 2标志位
	set flagCase3 0   ;#Test case 3标志位 
	set flagCase4 0   ;#Test case 4标志位 
	set flagCase5 0   ;#Test case 5标志位
	set flagCase6 0   ;#Test case 6标志位
	set flagCase7 0   ;#Test case 7标志位
	set flagCase8 0   ;#Test case 8标志位
	set flagResult 0

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
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth5_cap\($::gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap" $fileId
		#elan 业务验证
		if {$GPNPort5Cnt1(cnt13) < $::rateL || $GPNPort5Cnt1(cnt13) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELAN业务：NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的数据流，NE1($::gpnIp1)\
				$::GPNTestEth5\收到tag=800的数据流的速率为$GPNPort5Cnt1(cnt13)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELAN业务：NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的数据流，NE1($::gpnIp1)\
				$::GPNTestEth5\收到tag=800的数据流的速率为$GPNPort5Cnt1(cnt13)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort5Cnt1(cnt23) < $::rateL || $GPNPort5Cnt1(cnt23) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELAN业务：NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE1($::gpnIp1)\
				$::GPNTestEth5\收到tag=800的数据流的速率为$GPNPort5Cnt1(cnt23)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELAN业务：NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE1($::gpnIp1)\
				$::GPNTestEth5\收到tag=800的数据流的速率为$GPNPort5Cnt1(cnt23)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort2Cnt1(cnt12) < $::rateL || $GPNPort2Cnt1(cnt12) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELAN业务：NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELAN业务：NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt12)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort2Cnt1(cnt23) < $::rateL || $GPNPort2Cnt1(cnt23) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELAN业务：NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt23)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELAN业务：NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt23)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort3Cnt1(cnt12) < $::rateL || $GPNPort3Cnt1(cnt12) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELAN业务：NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELAN业务：NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt12)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort3Cnt1(cnt13) < $::rateL || $GPNPort3Cnt1(cnt13) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELAN业务：NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt13)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELAN业务：NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt13)，在$::rateL-$::rateR\范围内" $fileId
		}
		#eline 业务验证
		if {$GPNPort3Cnt1(cnt22) < $::rateL || $GPNPort3Cnt1(cnt22) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELINE业务：NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt22)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "设备上配置有ELINE、ELAN、ETREE三种业务，ELINE业务：NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt22)，在$::rateL-$::rateR\范围内" $fileId
		}
		#etree 业务验证
		if {$GPNPort5Cnt0(cnt10) < $::rateL || $GPNPort5Cnt0(cnt10) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "设备上配置有ELINE、ELAN、ETREE三种业务，ETREE业务：NE2($::gpnIp2)$::GPNTestEth2\发送tag=102的数据流，NE1($::gpnIp1)\
				$::GPNTestEth5\收到untag的数据流的速率为$GPNPort5Cnt0(cnt10)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "设备上配置有ELINE、ELAN、ETREE三种业务，ETREE业务：NE2($::gpnIp2)$::GPNTestEth2\发送tag=102的数据流，NE1($::gpnIp1)\
				$::GPNTestEth5\收到untag的数据流的速率为$GPNPort5Cnt0(cnt10)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort5Cnt0(cnt41) < $::rateL || $GPNPort5Cnt0(cnt41) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "设备上配置有ELINE、ELAN、ETREE三种业务，ETREE业务：NE4($::gpnIp4)$::GPNTestEth4\发送tag=104的数据流，NE1($::gpnIp1)\
				$::GPNTestEth5\收到untag的数据流的速率为$GPNPort5Cnt0(cnt41)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "设备上配置有ELINE、ELAN、ETREE三种业务，ETREE业务：NE4($::gpnIp4)$::GPNTestEth4\发送tag=104的数据流，NE1($::gpnIp1)\
				$::GPNTestEth5\收到untag的数据流的速率为$GPNPort5Cnt0(cnt41)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort2Cnt1(cnt6) < $::rateL || $GPNPort2Cnt1(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "设备上配置有ELINE、ELAN、ETREE三种业务，ETREE业务：NE1($::gpnIp1)$::GPNTestEth5\发送tag=100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到tag=102的数据流的速率为$GPNPort2Cnt1(cnt6)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "设备上配置有ELINE、ELAN、ETREE三种业务，ETREE业务：NE1($::gpnIp1)$::GPNTestEth5\发送tag=100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到tag=102的数据流的速率为$GPNPort2Cnt1(cnt6)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort4Cnt1(cnt7) < $::rateL || $GPNPort4Cnt1(cnt7) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "设备上配置有ELINE、ELAN、ETREE三种业务，ETREE业务：NE1($::gpnIp1)$::GPNTestEth5\发送tag=100的数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到tag=104的数据流的速率为$GPNPort4Cnt1(cnt7)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "设备上配置有ELINE、ELAN、ETREE三种业务，ETREE业务：NE1($::gpnIp1)$::GPNTestEth5\发送tag=100的数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到tag=104的数据流的速率为$GPNPort4Cnt1(cnt7)，在$::rateL-$::rateR\范围内" $fileId
		}
		return $flag
	}
	
	puts $fileId "登录被测设备...\n"
	puts $fileId "\n=====登录被测设备1====\n"
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
	puts $fileId "\n=====登录被测设备2====\n"
	set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
	while {[gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort15 "shutdown"]} {
					
	}
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
	set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3\
			\"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\" $GPNStcPort5 \"media $GPNEth5Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4 hGPNPort5
	
        ###创建测试流量
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
       
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList \
		-activate "false"
        foreach stream $hGPNPortStreamList {
                stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
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
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-LAN与其他模块互操作基础配置开始...\n"
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
	gwd::GWpublic_print "OK" "获取设备NE1($gpnIp1)业务板卡槽位号$rebootSlotlist1" $fileId
	set rebootSlotList1 [gwd::GWpulic_getWorkCardList $portList1]
	gwd::GWpublic_print "OK" "获取设备NE1($gpnIp1)上联板卡槽位号$rebootSlotList1" $fileId

        set portlist2 "$GPNPort6 $GPNPort7 $GPNPort14 $GPNPort15 $GPNPort18"
        set portList2 "$GPNTestEth2"
        set portList22 [concat $portlist2 $portList2]
        foreach port $portList22 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "disable" "enable"]
        	}
	}        
        set rebootSlotlist2 [gwd::GWpulic_getWorkCardList $portlist2]
        gwd::GWpublic_print "OK" "获取设备NE2($gpnIp2)业务板卡槽位号$rebootSlotlist2" $fileId
        set rebootSlotList2 [gwd::GWpulic_getWorkCardList $portList2]
        gwd::GWpublic_print "OK" "获取设备NE2($gpnIp2)上联板卡槽位号$rebootSlotList2" $fileId
	
        set portlist3 "$GPNPort8 $GPNPort9 $GPNPort16"
        set portList3 "$GPNTestEth3"
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

        set portlist4 "$GPNPort10 $GPNPort11"
        set portList4 "$GPNTestEth4"
        set portList44 [concat $portlist4 $portList4]
        foreach port $portList44 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet4 $matchType4 $Gpn_type4 $fileId $port "disable" "enable"]
        	}
        }
        set rebootSlotlist4 [gwd::GWpulic_getWorkCardList $portlist4]
        gwd::GWpublic_print "OK" "获取设备NE4($gpnIp4)业务板卡槽位号$rebootSlotlist4" $fileId
        set rebootSlotList4 [gwd::GWpulic_getWorkCardList $portList4]
        gwd::GWpublic_print "OK" "获取设备NE4($gpnIp4)上联板卡槽位号$rebootSlotList4" $fileId
        
        set Portlist "$GPNPort5 $GPNPort12 $GPNPort6 $GPNPort7 $GPNPort8 $GPNPort9 $GPNPort10 $GPNPort11"
        set Portlist0 "$GPNTestEth5 $GPNTestEth2 $GPNTestEth3 $GPNTestEth4"
	set Iplist "$ip612 $ip614 $ip621 $ip623 $ip632 $ip634 $ip643 $ip641"
        
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-LAN与其他模块互操作的基础配置失败，测试结束" \
		"E-LAN与其他模块互操作的基础配置成功，继续后面的测试" "GPN_PTN_008"
        puts $fileId ""
        puts $fileId "===E-LAN与其他模块互操作基础配置结束..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 ELAN与FDB模块互操作\n"
        ##与FDB互操作   
        #   <1>配置ELAN业务并发送数据流，查看mac地址表项 mac地址学习正确
        #   预期结果：基于vpls域、PW、AC查询，均能正确查询
        #   <2>停止发流，5min后mac地址老化
        #   <3>再次发流，Mac重新学习
	set flag1_case1 0
	set flag2_case1 0
	set flag3_case1 0
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====创建ELAN业务后检查mac地址的学习  测试开始=====\n"
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
		###配置vpls
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
	####配置NE1
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
	
	####配置NE2
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

        #####配置NE3
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
        
        #####配置NE4
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
	if {[PTN_ElanAndFdb "NE1($gpnIp1)$GPNTestEth5\发送smac=0000.0000.000c的数据流，NE2($gpnIp2)$GPNTestEth2\发送smac=0000.0000.00cc的数据流。" $lExpect1 "vpls1" $lExpect2 "pw12" $lExpect3 "ac800" ""]} {
		set flag1_case1 1
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1（结论）创建ELAN业务后检查mac地址的学习" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1（结论）创建ELAN业务后检查mac地址的学习" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====创建ELAN业务后检查mac地址的学习  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====停止发送数据流等待老化时间后检查mac地址是否老化  测试开始=====\n"
	after 350000 ;#等待mac地址老化，默认老化时间为300，等待350
	gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
	if {$dTable != ""} {
		set flag2_case1 1
		dict for {key value} $dTable {
			gwd::GWpublic_print "NOK" "经过350s后[dict get $value portname]上的mac地址$key\没有老化" $fileId
		}
	} else {
		gwd::GWpublic_print "OK" "等待老化时间后查询vpls1上的mac地址，所有mac地址全部都老化" $fileId
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2（结论）停止发送数据流等待老化时间后mac没有老化" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2（结论）停止发送数据流等待老化时间后mac老化" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====停止发送数据流等待老化时间后检查mac地址是否老化  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====再次发送数据流检查mac地址是否能又能正常学习  测试开始=====\n"
	gwd::Start_SendFlow "$::hGPNPort5Gen $::hGPNPort2Gen"  "$::hGPNPort5Ana $::hGPNPort2Ana"
	after 10000
	gwd::Stop_SendFlow "$::hGPNPort5Gen $::hGPNPort2Gen"  "$::hGPNPort5Ana $::hGPNPort2Ana"
	if {[PTN_ElanAndFdb "mac地址老化后重新发送数据流，NE1($gpnIp1)$GPNTestEth5\发送smac=0000.0000.000c的数据流，NE2($gpnIp2)$GPNTestEth2\发送smac=0000.0000.00cc的数据流。" $lExpect1 "vpls1" $lExpect2 "pw12" $lExpect3 "ac800" ""]} {
		set flag3_case1 1
	}
	#在case1的测试中发送了已知单播流。为了不影响后面的流量测试，通过shut/undo shut端口的方法删除转发表项
	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "shutdown"
	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "shutdown"
	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "undo shutdown"
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3（结论）mac地址老化后重新发送数据流mac地址学习异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3（结论）mac地址老化后重新发送数据流mac地址学习正常" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====再次发送数据流检查mac地址是否能又能正常学习  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase1 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 1测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 1测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 1 ELAN与FDB模块互操作测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 ELAN与TRUNK模块互操作”\n"
	##与TRUNK互操作
	#   <4>三台76清空配置 ，NE1--NE2--NE3两两互连，NE1设备通过带外上网管，NE2和NE3设备是带内上网管，彼此之间的NNI端口配置为trunk端口，其中trunk各自绑定2个端口，2个端口都是up
	#   <5>配置E-LAN业务数据，业务数据配置成功
	##trunk组的模式为sharing
	#   <6>命令down/up trunk主端口50次，业务正常倒换和恢复，记录下业务倒换和恢复时间（不超过50ms）
	#   <7>命令down/up trunk从端口50次，系统无异常，业务不发生倒换，无丢包
	#   <8>trunk组端口成员均命令down，业务中断；恢复trunk组其中一个端口成员，业务可恢复
	#   <9>更改trunk组的模式为1:1重复6-7步骤
	#   <10> 从两端设备的trunk中各添加一个down的端口，端口添加成功，业务不受影响
	#        再从这两端设备的trunk中删除该down的端口，端口删除成功，业务不受影响
	#        再从两端设备的trunk中各添加一个up的端口，端口添加成功，业务不受影响
	#        再从这两端设备的trunk中删除该up的端口，端口删除成功，业务不受影响
	#   <11>配置trunk组端口成员跨板卡，重复6-10步
	#   <12>将UNI侧的端口配置为turnk端口，配置业务数据，业务数据配置成功，业务数据流并正常转发
	#   <13>所配置的trunk聚合方式为静态，重复6-12步
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0
	set flag5_case2 0
	set flag6_case2 0
	set flag7_case2 0

	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunk模式为sharing、trunk组成员同板卡，测试ELAN与trunk互操作  测试开始=====\n"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort15 "undo shutdown"
	#dev1 和dev2查找down端口用于添加trunk测试------
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
	#------dev1 和dev3查找down端口用于添加trunk测试
			
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
	

	#配置trunk组，并将trunk组添加到vlan/子接口------
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
	
	#------配置trunk组，并将trunk组添加到vlan/子接口
	#####配置NE1
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $address613
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "5000" "5000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	#####配置NE2
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $address623
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $address624
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"
	
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "vpls" "vpls2" "peer" $address623 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24" "vpls" "vpls2" "peer" $address624 "6000" "6000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	#####配置NE3
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
		gwd::GWpublic_print "NOK" "FA4（结论）trunk模式为sharing、trunk组成员同板卡，测试ELAN与trunk互操作" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4（结论）trunk模式为sharing、trunk组成员同板卡，测试ELAN与trunk互操作" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunk模式为sharing、trunk组成员同板卡，测试ELAN与trunk互操作  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunk模式为lag1:1、trunk组成员同板卡，测试ELAN与trunk互操作  测试开始=====\n"
	#######################################################lag模式为1+1##################################################################
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
		gwd::GWpublic_print "NOK" "FA5（结论）trunk模式为lag1:1、trunk组成员同板卡，测试ELAN与trunk互操作" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5（结论）trunk模式为lag1:1、trunk组成员同板卡，测试ELAN与trunk互操作" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunk模式为lag1:1、trunk组成员同板卡，测试ELAN与trunk互操作  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunk模式为lag1:1、trunk组成员跨板卡，测试ELAN与trunk互操作  测试开始=====\n"
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
		gwd::GWpublic_print "NOK" "FA6（结论）trunk模式为lag1:1、trunk组成员跨板卡，测试ELAN与trunk互操作" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6（结论）trunk模式为lag1:1、trunk组成员跨板卡，测试ELAN与trunk互操作" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunk模式为lag1:1、trunk组成员跨板卡，测试ELAN与trunk互操作  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunk模式为sharing、trunk组成员跨板卡，测试ELAN与trunk互操作  测试开始=====\n"
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
		gwd::GWpublic_print "NOK" "FA7（结论）trunk模式为sharing、trunk组成员跨板卡，测试ELAN与trunk互操作" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7（结论）trunk模式为sharing、trunk组成员跨板卡，测试ELAN与trunk互操作" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunk模式为sharing、trunk组成员跨板卡，测试ELAN与trunk互操作  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunk模式为static、trunk组成员同板卡，测试ELAN与trunk互操作  测试开始=====\n"
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
		gwd::GWpublic_print "NOK" "FA8（结论）trunk模式为static、trunk组成员同板卡，测试ELAN与trunk互操作" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8（结论）trunk模式为static、trunk组成员同板卡，测试ELAN与trunk互操作" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunk模式为static、trunk组成员同板卡，测试ELAN与trunk互操作  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunk模式为static、trunk组成员跨板卡，测试ELAN与trunk互操作  测试开始=====\n"
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
		gwd::GWpublic_print "NOK" "FA9（结论）trunk模式为static、trunk组成员跨板卡，测试ELAN与trunk互操作" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9（结论）trunk模式为static、trunk组成员跨板卡，测试ELAN与trunk互操作" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====trunk模式为static、trunk组成员跨板卡，测试ELAN与trunk互操作  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====UNI口配置为trunk口，测试ELAN与trunk互操作  测试开始=====\n"
	###删除trunk
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
	###配置NE1
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_008-$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_008-$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_008-$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	set trunkRate [expr $GPNPort5Cnt1(cnt19) + $GPNPort1Cnt1(cnt19)]
	if {$trunkRate < $::rateL || $trunkRate > $::rateR} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)UNI口配置为trunk口，NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE1($::gpnIp1)\
			t1($::GPNTestEth1 $::GPNTestEth5)\收到tag=800的数据流的速率为$trunkRate，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)UNI口配置为trunk口，NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE1($::gpnIp1)\
			t1($::GPNTestEth1 $::GPNTestEth5)\收到tag=800的数据流的速率为$trunkRate，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt1(cnt12) < $::rateL || $GPNPort3Cnt1(cnt12) > $::rateR} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)UNI口配置为trunk口，NE1($::gpnIp1)t1($::GPNTestEth1 $::GPNTestEth5)\发送tag=800的数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)UNI口配置为trunk口，NE1($::gpnIp1)t1($::GPNTestEth1 $::GPNTestEth5)\发送tag=800的数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt12)，在$::rateL-$::rateR\范围内" $fileId
	}
	puts $fileId ""
	if {$flag7_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB1（结论）trunk模式为sharing，UNI口为trunk口测试ELAN业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1（结论）trunk模式为sharing，UNI口为trunk口测试ELAN业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====UNI口配置为trunk口，测试ELAN与trunk互操作  测试结束=====\n"
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
		gwd::GWpublic_print "NOK" "TestCase 2测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 2测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 2 ELAN与TRUNK模块互操作测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 ELAN与QOS互操作测试\n"
	##与QOS互操作
	#   <14>配合二层qos，策略为限速，绑定到ac端口上，验证限速生效
	#   <15>配置QoS限速，把QoS策略绑定到AC/PW/LSP，验证限速可以生效
	#   预期结果：遵从AC速率不可超过PW，PW速率不可超过LSP，若有违背，系统有相应的提示
	#   <16>配置一条PW 队列调度并配置限速，系统无异常配置成功，发送数据流量，观察接收到不同优先级的数据流的多少比例是符合配置
	puts $fileId ""
	puts $fileId "该功能不完善，测试跳过"
        if {$flagCase3 == 1} {
        	gwd::GWpublic_print "NOK" "TestCase 3测试结论" $fileId
        } else {
        	gwd::GWpublic_print "OK" "TestCase 3测试结论" $fileId
        }
        puts $fileId ""
        puts $fileId "Test Case 3 ELAN与QOS互操作测试结束\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 ELAN与OAM互操作测试\n"
        ##与OAM互操作
        #   <17>配置段层/PW/LSP层0AM，可成功配置，系统无异常，对业务数据转发无影响
        #   <18>设置段层/PW/LSP层相应的CC功能禁止/使能，设置成功并系统无异常，对业务数据转发无影响
        #   <19>设置段层/PW/LSP层相应的CC时间间隔参数，设置成功并系统无异常，对业务数据转发无影响
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set flag5_case4 0
	set flag6_case4 0
	set flag7_case4 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置LSP的OAM后测试ELAN业务  测试开始=====\n"
        gwd::GWpublic_createMplsMeg $telnet3 $matchType3 $Gpn_type3 $fileId "meg13"
        gwd::GWpublic_addMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "lsp" "lsp31" "2" "3"
        gwd::GWpublic_createMplsMeg $telnet1 $matchType1 $Gpn_type1 $fileId "meg11"
        gwd::GWpublic_addMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "lsp" "lsp13" "3" "2"
	incr capId
        if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\和$matchType3\配置Lsp层OAM，"]} {
        	set flag1_case4 1
        }
	puts $fileId ""
	if {$flag1_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB2（结论）配置LSP的OAM后测试ELAN业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2（结论）配置LSP的OAM后测试ELAN业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置LSP的OAM后测试ELAN业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置PW的OAM后测试ELAN业务  测试开始=====\n"
        gwd::GWpublic_delMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "lsp"
        gwd::GWpublic_addMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "pw" "pw13" "5" "4"
        gwd::GWpublic_delMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "lsp"
        gwd::GWpublic_addMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "pw" "pw31" "4" "5"
	incr capId
        if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\和$matchType3\配置PW层OAM，"]} {
        	set flag2_case4 1
        }
	puts $fileId ""
	if {$flag2_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB3（结论）配置PW的OAM后测试ELAN业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3（结论）配置PW的OAM后测试ELAN业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置PW的OAM后测试ELAN业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置段层的OAM后测试ELAN业务  测试开始=====\n"
        gwd::GWpublic_delMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "pw"
        gwd::GWpublic_addMplsOam $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "segment" $GPNTestEth3 "7" "6"
        gwd::GWpublic_delMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "pw"
        gwd::GWpublic_addMplsOam $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "segment" $GPNTestEth5 "6" "7"
	incr capId
        if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\和$matchType3\配置段层OAM，"]} {
        	set flag3_case4 1
        }
	puts $fileId ""
	if {$flag3_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB4（结论）配置段层的OAM后测试ELAN业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4（结论）配置段层的OAM后测试ELAN业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置段层的OAM后测试ELAN业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置LSP/PW/段层CC使能后测试ELAN业务  测试开始=====\n"
	gwd::GWpublic_addMplsCc $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "enable"
	gwd::GWpublic_addMplsCc $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "enable"
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\和$matchType3\配置LSP/PW/段层CC使能后"]} {
		set flag4_case4 1
	}
	puts $fileId ""
	if {$flag4_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB5（结论）配置LSP/PW/段层CC使能后测试ELAN业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5（结论）配置LSP/PW/段层CC使能后测试ELAN业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置LSP/PW/段层CC使能后测试ELAN业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置LSP/PW/段层CC去使能后测试ELAN业务  测试开始=====\n"
	gwd::GWpublic_addMplsCc $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "disable"
	gwd::GWpublic_addMplsCc $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "disable"
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\和$matchType3\配置LSP/PW/段层CC去使能后"]} {
		set flag5_case4 1
	}
	puts $fileId ""
	if {$flag5_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB6（结论）配置LSP/PW/段层CC去使能后测试ELAN业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6（结论）配置LSP/PW/段层CC去使能后测试ELAN业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置LSP/PW/段层CC去使能后测试ELAN业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置LSP/PW/段层CC时间间隔后测试ELAN业务  测试开始=====\n"
	gwd::GWpublic_addMplsCcInt $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "100ms"
	gwd::GWpublic_addMplsCcInt $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "1s"
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\和$matchType3\配置LSP/PW/段层CC时间间隔后"]} {
		set flag6_case4 1
	}
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB7（结论）配置LSP/PW/段层CC时间间隔后测试ELAN业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7（结论）配置LSP/PW/段层CC时间间隔后测试ELAN业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置LSP/PW/段层CC时间间隔后测试ELAN业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置LSP/PW/段层LB后测试ELAN业务  测试开始=====\n"
	gwd::GWpublic_addMplsLb $telnet3 $matchType3 $Gpn_type3 $fileId "meg13" "mep" "255" "3"
	gwd::GWpublic_addMplsLb $telnet1 $matchType1 $Gpn_type1 $fileId "meg11" "mep" "255" "5"
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "$matchType1\和$matchType3\配置LSP/PW/段层LB后"]} {
		set flag7_case4 1
	}
	puts $fileId ""
	if {$flag7_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB8（结论）配置LSP/PW/段层LB后测试ELAN业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8（结论）配置LSP/PW/段层LB后测试ELAN业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置LSP/PW/段层LB后测试ELAN业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase4 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 4测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 4测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 4 ELAN与OAM模块互操作测试结束\n"
 	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 ELAN与DCN互操作测试\n"
	##与DCN互操作 
	#   <20>4台设备用DCN进行网管，其中一台为网关网元，剩下三台为非网关网元
	#   <21>4台设备发送ping包均正常，设备均可正常上网管
	#   预期结果：业务数据流正常转发，系统无异常
	#             删除所创建的DCN配置，对E-LAN业务无影响
	set flag1_case5 0
	set flag2_case5 0
	set flag3_case5 0
	gwd::GWpublic_delMplsMeg $telnet1 $matchType1 $Gpn_type1 $fileId "meg11"
	gwd::GWpublic_delMplsMeg $telnet3 $matchType3 $Gpn_type3 $fileId "meg13"
	if {[string match "L2" $Worklevel]}  {
		puts $fileId "======================================================================================\n"
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置DCN后测试ELAN业务  测试开始=====\n"
		set portlist1 "$GPNTestEth1 $GPNPort5 $GPNPort12"
		set portlist2 "$GPNPort6 $GPNPort7"
		set portlist3 "$GPNPort8 $GPNPort9"
		set portlist4 "$GPNPort10 $GPNPort11"
		set ip21 192.10.1.1
		set ip22 192.10.1.2
		set ip23 192.10.1.3
		set ip24 192.10.1.4
		set typelist1 "mgt ne-to-ne ne-to-ne";#DCN配置时NE1网关网元端口角色列表
		set typelist2 "ne-to-ne ne-to-ne";#DCN配置时NE2非网关网元端口角色列表
		set typelist3 "ne-to-ne ne-to-ne";#DCN配置时NE3非网关网元端口角色列表
		set typelist4 "ne-to-ne ne-to-ne";#DCN配置时NE4非网关网元端口角色列表
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
		if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "配置DCN后"]} {
			set flag1_case5 1
		}
		puts $fileId ""
		if {$flag1_case5 == 1} {
			set flagCase5 1
			gwd::GWpublic_print "NOK" "FB9（结论）配置DCN后测试ELAN业务" $fileId
		} else {
			gwd::GWpublic_print "OK" "FB9（结论）配置DCN后测试ELAN业务" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置DCN后测试ELAN业务  测试结束=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
		puts $fileId "======================================================================================\n"
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置DCN后，测试DCN功能  测试开始=====\n"
		gwd::GWpublic_cfgPing $telnet1 $matchType1 $Gpn_type1 $fileId $ip22 packageLoss1
		gwd::GWpublic_cfgPing $telnet2 $matchType2 $Gpn_type2 $fileId $ip21 packageLoss2
		if {$packageLoss1>20} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1) ping NE2($gpnIp2)设备丢包率为$packageLoss1，大于允许丢包率20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1) ping NE2($gpnIp2)设备丢包率为$packageLoss1，小于允许丢包率20%" $fileId	
		}
		if {$packageLoss2>20} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "NE2($gpnIp2) ping NE1($gpnIp1)丢包率为$packageLoss2，大于允许丢包率20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($gpnIp2) ping NE1($gpnIp1)丢包率为$packageLoss2，小于允许丢包率20%" $fileId	
		}
		gwd::GWpublic_cfgPing $telnet1 $matchType1 $Gpn_type1 $fileId $ip23 packageLoss1
		gwd::GWpublic_cfgPing $telnet3 $matchType3 $Gpn_type3 $fileId $ip21 packageLoss2
		if {$packageLoss1>20} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1) ping NE3($gpnIp3)设备丢包率为$packageLoss1，大于允许丢包率20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1) ping NE3($gpnIp3)设备丢包率为$packageLoss1，小于允许丢包率20%" $fileId	
		}
		if {$packageLoss2>20} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "NE3($gpnIp3) ping NE1($gpnIp1)丢包率为$packageLoss2，大于允许丢包率20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($gpnIp3) ping NE1($gpnIp1)丢包率为$packageLoss2，小于允许丢包率20%" $fileId	
		}
		gwd::GWpublic_cfgPing $telnet1 $matchType1 $Gpn_type1 $fileId $ip24 packageLoss1
		gwd::GWpublic_cfgPing $telnet4 $matchType4 $Gpn_type4 $fileId $ip21 packageLoss2
		if {$packageLoss1>20} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1) ping NE4($gpnIp4)设备丢包率为$packageLoss1，大于允许丢包率20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1) ping NE4($gpnIp4)设备丢包率为$packageLoss1，小于允许丢包率20%" $fileId	
		}
		if {$packageLoss2>20} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "NE4($gpnIp4) ping NE1($gpnIp1)丢包率为$packageLoss2，大于允许丢包率20%" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($gpnIp4) ping NE1($gpnIp1)丢包率为$packageLoss2，小于允许丢包率20%" $fileId	
		}
		#创建ping device，获取PingReport
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
			gwd::GWpublic_print "NOK" "网关设备NE1($gpnIp1)端口$GPNTestEth1\连接的TC模拟PC ping 网元设备NE2($gpnIp2)设备，共ping10个包ping通$sucPingCnt1\个包" $fileId
		} else {
			gwd::GWpublic_print "OK" "网关设备NE1($gpnIp1)端口$GPNTestEth1\连接的TC模拟PC ping 网元设备NE2($gpnIp2)设备，共ping10个包ping通$sucPingCnt1\个包" $fileId
		}
		stc::perform PingStartCommand -DeviceList $hEmulatedDevice1 -FrameCount 10 -PingIpv4DstAddr $ip23 
		after 60000 
		set sucPingCnt1 0
		set sucPingCnt1 [stc::get $hPingResult1 -SuccessfulPingCount]
		puts "ping $ip22  $sucPingCnt1"
		puts "sucPingCnt1: $sucPingCnt1"
		if {$sucPingCnt1 < 8} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "网关设备NE1($gpnIp1)端口$GPNTestEth1\连接的TC模拟PC ping 网元设备NE3($gpnIp3)设备，共ping10个包ping通$sucPingCnt1\个包" $fileId
		} else {
			gwd::GWpublic_print "OK" "网关设备NE1($gpnIp1)端口$GPNTestEth1\连接的TC模拟PC ping 网元设备NE3($gpnIp3)设备，共ping10个包ping通$sucPingCnt1\个包" $fileId
		}
		stc::perform PingStartCommand -DeviceList $hEmulatedDevice1 -FrameCount 10 -PingIpv4DstAddr $ip24 
		after 20000 
		set sucPingCnt1 0
		set sucPingCnt1 [stc::get $hPingResult1 -SuccessfulPingCount]
		puts "ping $ip22  $sucPingCnt1"
		puts "sucPingCnt1: $sucPingCnt1"
		if {$sucPingCnt1 < 8} {
			set flag2_case5 1
			gwd::GWpublic_print "NOK" "网关设备NE1($gpnIp1)端口$GPNTestEth1\连接的TC模拟PC ping 网元设备NE4($gpnIp4)设备，共ping10个包ping通$sucPingCnt1\个包" $fileId
		} else {
			gwd::GWpublic_print "OK" "网关设备NE1($gpnIp1)端口$GPNTestEth1\连接的TC模拟PC ping 网元设备NE4($gpnIp4)设备，共ping10个包ping通$sucPingCnt1\个包" $fileId
		}
		puts $fileId ""
		if {$flag2_case5 == 1} {
			set flagCase5 1
			gwd::GWpublic_print "NOK" "FC1（结论）配置DCN后测试DCN业务" $fileId
		} else {
			gwd::GWpublic_print "OK" "FC1（结论）配置DCN后测试DCN业务" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置DCN后，测试DCN功能  测试结束=====\n"
		incr tcId
		gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
		gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp
		puts $fileId "======================================================================================\n"
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除DCN后测试ELAN业务  测试结束=====\n"
		foreach dcnPort $portlist1 dcnType $typelist1 {
			gwd::GWpublic_delDCN $telnet1 $matchType1 $Gpn_type1 $fileId $dcnType $dcnPort
		}
		gwd::GWpublic_delDCN $telnet2 $matchType2 $Gpn_type2 $fileId "ne" $portlist2
		gwd::GWpublic_delDCN $telnet3 $matchType3 $Gpn_type3 $fileId "ne" $portlist3
		gwd::GWpublic_delDCN $telnet4 $matchType4 $Gpn_type4 $fileId "ne" $portlist4
		after 60000
		incr capId
		if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "删除DCN后"]} {
			set flag3_case5 1
		}
		puts $fileId ""
		if {$flag3_case5 == 1} {
			set flagCase5 1
			gwd::GWpublic_print "NOK" "FC2（结论）删除DCN后测试ELAN业务" $fileId
		} else {
			gwd::GWpublic_print "OK" "FC2（结论）删除DCN后测试ELAN业务" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除DCN后测试ELAN业务  测试结束=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
		puts $fileId "======================================================================================\n"
	} else {
		puts $fileId "\nDCN是二层功能，三层不需要测试\n"
	}
	if {$flagCase5 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 5测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 5测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 5 ELAN与DCN模块互操作测试结束\n"
	#由于DCN功能有问题，需要将NE1的UNI口shutdown然后undoshutdown后业务才能恢复，此处为了规避此问题防止后面测试受影响进行下面操作
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "undo shutdown"
	 puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 6 ELAN与CES互操作测试\n"
        ##与CES业务互操作 
        #   <22>与之前创建的E-LAN业务共用LSP，因只需配置PW和相应的CES业务
        #   预期结果：CES业务配置成功，系统无异常
        #            CES业务和之前的E-LAN业务正常转发
        #   <24>彼此之间无干扰 在CES业务和E-LAN业务共用的LSP上做限速，系统无异常，CES业务和E-LAN业务可正常转发
	puts $fileId "ELAN与CES模块互操作功能不完善，测试跳过"
	set flagCase6 1
	if {$flagCase6 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 6测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 6测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 6 ELAN与CES互操作测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 7 ELAN与ELINE、ETREE业务互操作\n"
        ##与ELINE、ETREE业务互操作
        #   <1>4台设备原有E-LAN业务的基础上，创建新的业务ELINE/ETREE
        #   <2>其中NE1、NE2、NE4上创建ETREE业务，NE1为汇聚设备；NE3、NE4之间创建ELINE业务
        #   预期结果:新的业务ELAN/ETREE业务成功创建，系统无异常，对之前的业务无影响
        #            每条业务都正常转发，彼此之间无干扰，系统利用率正常
	set flag1_case7 0
	set flag2_case7 0
	set flag3_case7 0
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList1 \
		-activate "true"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新建ELINE业务并测试当ELINE业务的PW ID与ELAN业务的VPLS ID有冲突时是否能创建成功  测试开始=====\n"
	##NE3-NE4之间创建ELINE业务
	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls4" 4 "elan" "flood" "false" "false" "false" "true" "2000" "" ""
	if {![gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw3400" "l2transport" "4" "" $address634 "101" "101" "4" "nochange" "" 1 0 "0x8100" "0x8100" ""]} {
		gwd::GWpublic_print "OK" "配置专线VCID与ELAN业务的VPLSID相同，配置成功无提示" $fileId
		gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw3400"
	} else {
		set flag1_case7 1
		gwd::GWpublic_print "NOK" "配置专线VCID与ELAN业务的VPLSID相同，配置失败有提示" $fileId
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
		gwd::GWpublic_print "NOK" "FC3（结论）ELAN VPLS的ID与专网PW的ID冲突测试及新建ELINE业务的配置测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3（结论）ELAN VPLS的ID与专网PW的ID冲突测试及新建ELINE业务的配置测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新建ELINE业务并测试当ELINE业务的PW ID与ELAN业务的VPLS ID有冲突时是否能创建成功  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新建ETREE业务并测试当ETREE业务的VPLS ID与ELINE业务的PW ID有冲突时是否能创建成功  测试开始=====\n"
	if {![gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls444" "43" "etree" "flood" "false" "false" "false" "true" "3000" "" ""]} {
		gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls444"
		gwd::GWpublic_print "OK" "配置ETREE业务的VPLSID与专线PWID相同，配置成功无提示" $fileId
	} else {
		set flag2_case7 1
		gwd::GWpublic_print "NOK" "配置ETREE业务的VPLSID与专线PWID相同，配置失败有提示" $fileId
	}
	if {![gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls44" "4" "etree" "flood" "false" "false" "false" "true" "3000" "" ""]} {
		set flag2_case7 1
		gwd::GWpublic_print "NOK" "配置ETREE业务的VPLSID与ELAN业务的VPLSID相同，配置成功无提示" $fileId
		gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls44"
	} else {
		gwd::GWpublic_print "OK" "配置ETREE业务的VPLSID与ELAN业务的VPLSID相同，配置失败有提示" $fileId
	}
	
	lappend flag2_case7 [gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls44" "44" "etree" "flood" "false" "false" "false" "true" "3000" "" ""]
	if {![gwd::GWStaPw_AddVplsPwInfo $telnet4 $matchType4 $Gpn_type4 $fileId "pw014" "vpls4" $address641 "801" "701" "root" "nochange" "1" "0" "0x8100" "0x9100" "1" "44"]} {
		gwd::GWpublic_print "OK" "配置专网业务的VCID与其它VPLS域中的vpls id相同，配置成功无提示" $fileId
		gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw014"
	} else {
		set flag2_case7 1
		gwd::GWpublic_print "NOK" "配置专网业务的VCID与其它VPLS域中的vpls id相同，配置失败有提示" $fileId
	}
	if {![gwd::GWStaPw_AddVplsPwInfo $telnet4 $matchType4 $Gpn_type4 $fileId "pw014" "vpls44" $address641 "801" "701" "root" "nochange" "1" "0" "0x8100" "0x9100" "1" "44"]} {
		gwd::GWpublic_print "OK" "配置专网业务的VCID与自己VPLS域中的vpls id相同，配置成功无提示" $fileId
	} else {
		set flag2_case7 1
		gwd::GWpublic_print "NOK" "配置专网业务的VCID与自己VPLS域中的vpls id相同，配置失败有提示" $fileId
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
		gwd::GWpublic_print "NOK" "FC4（结论）ETREE VPLS的ID与专网PW的ID冲突测试及新建ETREE业务的配置测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4（结论）ETREE VPLS的ID与专网PW的ID冲突测试及新建ETREE业务的配置测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新建ETREE业务并测试当ETREE业务的VPLS ID与ELINE业务的PW ID有冲突时是否能创建成功  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====发流验证ELAN、ELINE、ETREE业务  测试开始=====\n"
	incr capId
	if {[Test_elan_etree_eline $fileId "GPN_PTN_008_$capId"]} {
		set flag3_case7 1
	}
	puts $fileId ""
	if {$flag3_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FC5（结论）发流验证ELAN、ELINE、ETREE业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5（结论）发流验证ELAN、ELINE、ETREE业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====发流验证ELAN、ELINE、ETREE业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp
	
	puts $fileId "======================================================================================\n"
	if {$flagCase7 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 7测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 7测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 7 ELAN与ELINE、ETREE业务互操作测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 8 ELAN与 环路检测模块互操作\n"
	##与环路检测互操作
	#   <3>打开环路检测，uni口下挂远端，业务从远端进入局端
	#   <4>在远端制造环路
	#   预期结果:告警正常上报，对业务无影响
	#           在7600其他板卡上制造环路，告警正常上报对业务无影响
	#   <5>配置两条ELAN业务，同一设备的两个UNI口制造环路
	#   预期结果:告警正常上报，对另外两台设备业务没有影响
	set flag1_case8 0
	set flag2_case8 0
	set flag3_case8 0
        ####"=====删除NE3-NE4之间创建ELINE业务====="
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac500"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac500"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw340"
        gwd::GWAc_DelActPw $telnet4 $matchType4 $Gpn_type4 $fileId "ac500"
        gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac500"
        gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw430"
        #### "=====删除NE1-NE2-NE4之间创建ETREE业务====="
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
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====测试ELAN与环路检测模块互操作前发流验证ELAN业务  测试开始=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList1 \
		-activate "false"
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "测试ELAN与环路检测模块互操作前，"]} {
		set flag1_case8 1
	}
	puts $fileId ""
	if {$flag1_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FC6（结论）测试ELAN与环路检测模块互操作前发流验证ELAN业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6（结论）测试ELAN与环路检测模块互操作前发流验证ELAN业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====测试ELAN与环路检测模块互操作前发流验证ELAN业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====制造远端环路，检查环路是否能正常上报、业务是否正常  测试开始=====\n"
	####=========与环路检测互操作==========#############
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
		###配置NE1
		PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "100" $GPNPort19
		gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls10" "10" "elan" "flood" "false" "false" "false" "true" "3000" "" ""
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw013" "vpls" "vpls10" "peer" $address613 "502" "502" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac10" "vpls10" "ethernet" $GPNPort19 "100" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc3"
	}

	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream1 $hGPNPort3Stream4" \
		-activate "true"
	#远端环路检查环路是否能正常上报、业务是否正常
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
		gwd::GWpublic_print "NOK" "制造远端环路，show current alarm中没有环路告警信息" $fileId
		set flag2_case8 1
	} else {
		gwd::GWpublic_print "OK" "制造远端环路，show current alarm中有环路告警信息" $fileId
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
		gwd::GWpublic_print "NOK" "制造远端环路，show loop-detection status中没有环路告警信息" $fileId
		set flag2_case8 1
	} else {
		gwd::GWpublic_print "OK" "制造远端环路，show loop-detection status中有环路告警信息" $fileId
	}
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "远端环路后测试ELAN业务，"]} {
		set flag2_case8 1
	}
	puts $fileId ""
	if {$flag2_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FC7（结论）制造远端环路，检查环路上报并测试ELAN业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7（结论）制造远端环路，检查环路上报并测试ELAN业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====制造远端环路，检查环路是否能正常上报、业务是否正常  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====制造局端环路，检查环路是否能正常上报、业务是否正常  测试开始=====\n"
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
		gwd::GWpublic_print "NOK" "制造局端环路，show current alarm中没有环路告警信息" $fileId
		set flag3_case8 1
	} else {
		gwd::GWpublic_print "OK" "制造局端环路，show current alarm中有环路告警信息" $fileId
	}
	set alarmFlag 0
	foreach tmp $loopInfo {
		if {[regexp "eth-port \[$GPNPort23|$GPNPort24\]+ looped with.*eth-port \[$GPNPort23|$GPNPort24\]+ in vlan 1" $tmp]} {
			set alarmFlag 1
			break
		}	
	}
	if {$alarmFlag == 0} {
		gwd::GWpublic_print "NOK" "制造局端环路，show loop-detection status中没有环路告警信息" $fileId
		set flag3_case8 1
	} else {
		gwd::GWpublic_print "OK" "制造局端环路，show loop-detection status中有环路告警信息" $fileId
	}
	incr capId
	if {[PTN_TrunkStream_elan $fileId "GPN_PTN_008_$capId" "局端环路后测试ELAN业务，"]} {
		set flag3_case8 1
	}
	puts $fileId ""
	if {$flag3_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FC8（结论）制造局端环路，检查环路上报并测试ELAN业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8（结论）制造局端环路，检查环路上报并测试ELAN业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====制造局端环路，检查环路是否能正常上报、业务是否正常  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_008_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_008" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase8 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 8测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 8测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 8 ELAN与 环路检测模块互操作测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===恢复初始化配置...\n"
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

	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "测试结束后配置恢复" "测试结束后配置恢复" "GPN_PTN_008"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "测试过程中所有配置文件都上传成功" "GPN_PTN_008"
        chan seek $fileId 0
        puts $fileId "\n**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "GPN_PTN_008测试目的：ELAN业务与其它模块的互操作\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1 == 1 || $flagCase2 == 1 || $flagCase3 == 1 || $flagCase4 == 1 || $flagCase5 == 1 || $flagCase6 == 1\
		|| $flagCase7 == 1 || $flagCase8 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_008测试结果" $fileId
	puts $fileId ""
        gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase6 == 0) ? "OK" : "NOK"}] "Test Case 6测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase7 == 0) ? "OK" : "NOK"}] "Test Case 7测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase8 == 0) ? "OK" : "NOK"}] "Test Case 8测试结果" $fileId
        puts $fileId ""
        puts $fileId ""
        gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "（结论）创建ELAN业务后检查mac地址的学习" $fileId
        gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "（结论）停止发送数据流等待老化时间后mac[expr {($flag2_case1 == 1) ? "没有" : ""}]老化" $fileId
        gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "（结论）mac地址老化后重新发送数据流mac地址学习异常" $fileId
        gwd::GWpublic_print "== FA4 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "（结论）trunk模式为sharing、trunk组成员同板卡，测试ELAN与trunk互操作" $fileId
        gwd::GWpublic_print "== FA5 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "（结论）trunk模式为lag1:1、trunk组成员同板卡，测试ELAN与trunk互操作" $fileId
        gwd::GWpublic_print "== FA6 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "（结论）trunk模式为lag1:1、trunk组成员跨板卡，测试ELAN与trunk互操作" $fileId
        gwd::GWpublic_print "== FA7 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "（结论）trunk模式为sharing、trunk组成员跨板卡，测试ELAN与trunk互操作" $fileId
        gwd::GWpublic_print "== FA8 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "（结论）trunk模式为static、trunk组成员同板卡，测试ELAN与trunk互操作" $fileId
        gwd::GWpublic_print "== FA9 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "（结论）trunk模式为static、trunk组成员跨板卡，测试ELAN与trunk互操作" $fileId
        gwd::GWpublic_print "== FB1 == [expr {($flag7_case2 == 1) ? "NOK" : "OK"}]" "（结论）trunk模式为sharing，UNI口为trunk口测试E-LINE业务" $fileId
        gwd::GWpublic_print "== FB2 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "（结论）配置LSP的OAM后测试ELAN业务" $fileId
        gwd::GWpublic_print "== FB3 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "（结论）配置PW的OAM后测试ELAN业务" $fileId
        gwd::GWpublic_print "== FB4 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "（结论）配置段层的OAM后测试ELAN业务" $fileId
        gwd::GWpublic_print "== FB5 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "（结论）配置LSP/PW/段层CC使能后测试ELAN业务" $fileId
        gwd::GWpublic_print "== FB6 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "（结论）配置LSP/PW/段层CC去使能后测试ELAN业务" $fileId
        gwd::GWpublic_print "== FB7 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "（结论）配置LSP/PW/段层CC时间间隔后测试ELAN业务" $fileId
        gwd::GWpublic_print "== FB8 == [expr {($flag7_case4 == 1) ? "NOK" : "OK"}]" "（结论）配置LSP/PW/段层LB后测试ELAN业务" $fileId
        gwd::GWpublic_print "== FB9 == [expr {($flag1_case5 == 1) ? "NOK" : "OK"}]" "（结论）配置DCN后测试ELAN业务" $fileId
        gwd::GWpublic_print "== FC1 == [expr {($flag2_case5 == 1) ? "NOK" : "OK"}]" "（结论）配置DCN后测试DCN业务" $fileId
        gwd::GWpublic_print "== FC2 == [expr {($flag3_case5 == 1) ? "NOK" : "OK"}]" "（结论）删除DCN后测试ELAN业务" $fileId
        gwd::GWpublic_print "== FC3 == [expr {([regexp {[^0\s]} $flag1_case7]) ? "NOK" : "OK"}]" "（结论）ELAN VPLS的ID与专网PW的ID冲突测试及新建ELINE业务的配置测试" $fileId
        gwd::GWpublic_print "== FC4 == [expr {([regexp {[^0\s]} $flag2_case7]) ? "NOK" : "OK"}]" "（结论）ETREE VPLS的ID与专网PW的ID冲突测试及新建ETREE业务的配置测试" $fileId
        gwd::GWpublic_print "== FC5 == [expr {($flag3_case7 == 1) ? "NOK" : "OK"}]" "（结论）发流验证ELAN、ELINE、ETREE业务" $fileId
        gwd::GWpublic_print "== FC6 == [expr {($flag1_case8 == 1) ? "NOK" : "OK"}]" "（结论）测试ELAN与环路检测模块互操作前发流验证ELAN业务" $fileId
        gwd::GWpublic_print "== FC7 == [expr {($flag2_case8 == 1) ? "NOK" : "OK"}]" "（结论）制造远端环路，检查环路上报并测试ELAN业务" $fileId
	gwd::GWpublic_print "== FC8 == [expr {($flag3_case8 == 1) ? "NOK" : "OK"}]" "（结论）制造局端环路，检查环路上报并测试ELAN业务" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "（结论）测试结束后配置恢复" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "（结论）测试过程中配置文件的上传" $fileId
        puts $fileId ""
        puts $fileId "**************************************************************************************"
        puts $fileId ""
        puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "运行异常：错误为$err" "" "GPN_PTN_008"
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

