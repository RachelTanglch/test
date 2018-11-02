#!/bin/sh
# T4_GPN_PTN_ELAN_009.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#测试目的：1.E-LAN的稳定性     2.E-LAN业务容量及健壮性测试
#1-报文攻击
#2-内存泄露测试 
#1-vpls域mac地址容量测试               
#2-1个VSI承载多个PW测试
#3-一个VSI承载多少AC                  
#4-1系统中承载多少VSI 
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
#   <1>4台设备，NE1--NE2--NE3-NE4按照上述拓扑，搭建E-LAN业务
#   <2>向NE1设备发送ARP攻击报文，速率100Mbps，业务数据应该不受影响，管理通道正常
#   <3>向NE1设备发送速率100Mbps业务报文，系统CPU利用率正常，管理通道正常
#   <4>发送100M广播报文，系统CPU利用率正常，管理通道正常
#   <5>发送不同波长的报文，系统CPU利用率正常，管理通道正常
#   <6>发送满带宽的流量，系统CPU利用率正常，管理通道正常
#2、搭建Test Case 2测试环境
#   <1>创建1条E-LAN业务， 配置相应的LSP、PW、AC，再删除该条业务，系统正常
#   <2>用脚本反复添加删除E-LAN实例500次，业务及管理正常，内存没有泄漏，系统无异常
#3、搭建Test Case 3测试环境
#vpls域mac地址容量测试 
#   <1>在NE1的vsi中配置mac地址学习数量为最大容量（系统支持最大可配数量为32000）
#   <2>向NE1的uni口发送源mac递增的相应数量固定报文数
#   预期结果:查看NE2、NE3的UNI口学习的报文数，与NE1发送的报文数一致
#            在底层查看mac地址学习数量，VSI下最大学习到的MAC地址数与设置值一致；
#1个VSI承载多个PW测试  
#   <3>四台76，按照上述拓扑，NE1设备通过带外上网管，NE2、NE3、NE4设备带内上网管,四台设备长ping网管地址
#   <4>在NE1的UNI口发送满带宽业务流量（不同波长报文、多种报文、少量arp报文），NE2接收正常无丢包，系统无异常，记录下系统1个VSI上可承载多少个PW?
#   预期结果:NE1、NE2保存配置，查看各项表项（LSP、PW、AC条目数都正常）显示均正确；配置文件可成功导出，系统无异常；查看导出的配置文件正确，无乱码
#   <5>使能每条业务LSP、PW性能统计，系统无异常，性能统计功能生效，统计值正确
#   <6>shutdown和undo shutdown NE1设备的NNI/UNI端口光纤50次，业务均恢复正常 ，每条业务彼此无干扰，DCN正常
#   <7>进行NE1设备的SW/NMS倒换50次（软/硬倒换），业务均正常恢复，每条业务彼此无干扰，DCN正常，查看标签转发表项正确
#   <8>复位NE1设备的NNI/UNI所在板卡50次，业务均恢复正常 ，每条业务彼此无干扰，DCN正常
#   <9>保存NE1和NE2设备配置，掉电重启NE1和NE2设备（软复位和硬复位）50次，每次操作后系统正常启动，业务恢复正常且彼此无干扰，标签转发表项正确，DCN正常
#   <10>清空NE1和NE2设备配置，重启NE1和NE2设备，待设备起来后查看配置信息空，将各自导出的配置文件导入，重启设备，
#       待设备起来后查看配置信息无丢失均正确，发流验证业务均正常转发，DCN正常
#   <11>清空NE1和NE2设备配置，重启NE1和NE2设备
#1个VSI承载多少AC
#   <12>四台76，按照上述拓扑，NE1设备通过带外上网管，NE2、NE3、NE4设备带内上网管,四台设备长ping网管地址
#   <13>在NE1、NE2之间建立一条EPLAN业务，一个vpls域、一个LSP，一个PW
#   <14>NE1、NE2的多个UNI口加入不同vlan，创建多个ac
#   <15>向NE1的一个UNI口发送相应vlan业务流量，NE2接收正常无丢包，NE1的其他端口也能收到系统无异常，记录下系统1个VSI上可承载多少个AC
#   预期结果:NE1、NE2保存配置，均上载网管查看各项表项（LSP、PW、AC条目数都正常）显示均正确；配置文件可成功导出，系统无异常；查看导出的配置文件正确，无乱码
#   <16>shutdown和undo shutdownNE1设备的NNI/UNI端口光纤50次，业务均恢复正常 ，每条业务彼此无干扰，DCN正常
#   <17>复位NE1设备的NNI/UNI所在板卡50次，业务均恢复正常 ，每条业务彼此无干扰，DCN正常
#   <18>进行NE1设备的SW/NMS倒换50次（软/硬倒换），业务均正常恢复，每条业务彼此无干扰，DCN正常，查看标签转发表项正确
#   <19>保存NE1和NE2设备配置，掉电重启NE1和NE2设备（软复位和硬复位）50次，每次操作后系统正常启动，业务恢复正常且彼此无干扰，标签转发表项正确，DCN正常
#   <20>清空NE1和NE2设备配置，重启NE1和NE2设备
#系统承载多少VSI
#   <21>四台76组网，组网拓扑见拓扑图1，NE1--NE2--NE3--NE4两两相连，NE1设备通过带外上网管,NE2和NE3、NE4设备通过带内上网管，
#       或4台设备以DCN管理，三台设备彼此之间的NNI端口通过以太网接口形式相连，NNI端口以untag方式加入到VLANIF中,四台设备长ping网管地址
#   <22>创建NE1到NE2、NE3、NE4之间的EVP-LAN业务，NE2既为PE又为p设备，用户侧接入模式为端口+运营商VLAN模式
#   <23>NE1到NE2、NE3、NE4之间各创建一条lsp，一个vpls与承载三条PW，一个AC
#   <24>向NE1的UNI口发送满带宽业务流量（不同波长报文、多种报文、少量arp报文），NE2、NE3、NE4接收流量正常，系统无异常，记录系统中可创建多少的VPLS域
#   预期结果:保存NE1和NE2设备配置，查看各项表项（LSP，PW，AC条目数都正常）显示均正确；配置文件可成功导出，系统无异常；查看导出的配置文件正确，无乱码，DCN正常
#   <25>shutdown和undo shutdownNE1设备的NNI/UNI端口光纤50次，业务均恢复正常 ，每条业务彼此无干扰，DCN正常
#   <26>复位NE1设备的NNI/UNI所在板卡50次，业务均恢复正常 ，每条业务彼此无干扰，DCN正常
#   <27>进行NE1设备的SW/NMS倒换50次（软/硬倒换），业务均正常恢复，每条业务彼此无干扰，DCN正常查看标签转发表项正确
#   <28>保存NE1和NE2、NE3设备配置，掉电重启NE1和NE2、NE3设备（软复位和硬复位）50次，每次操作后系统正常启动，业务恢复正常且彼此无干扰，标签转发表项正确，DCN正常
#   <29>清空NE1和NE2设备配置，重启NE1和NE2设备，待设备起来后查看配置信息空，将各自导出的配置文件导入，重启设备，
#       待设备起来后查看配置信息无丢失均正确，发流验证业务均正常转发，DCN正常
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_009_LOG.txt" a]
        set stdout $fd_log
        chan configure $fd_log -blocking 0 -buffering none;#非阻塞模式 按行flush
        log_file log\\GPN_PTN_009_LOG.txt
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_009_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#非阻塞模式 按行flush
        
        file mkdir "debug"
        set fd_debug [open debug\\GPN_PTN_009_DEBUG.txt a]
        exp_internal -f debug\\GPN_PTN_009_DEBUG.txt 0
        chan configure $fd_debug -blocking 0 -buffering none;#非阻塞模式 按行flush
    
	  source test\\PTN_VarSet.tcl
	  source test\\PTN_Mode_Function.tcl

        ###数据流设置
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
       	
	set rateL 95000000;#收发数据流取值最小值范围
	set rateR 105000000;#收发数据流取值最大值范围
	set rateL1 100000000 
	set rateR1 125000000
	
	set flagCase1 0   ;#Test case 1标志位 
	set flagCase2 0   ;#Test case 2标志位
	set flagCase3 0   ;#Test case 3标志位 
	set flagCase4 0   ;#Test case 4标志位 
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
	
	########################################################################################################
	#函数功能：一个vsi满配ac，发流验证配置
	#输入参数:printWord:report中打印的测试说明
	#expStartVid2 expEndVid2 = 0时将expStartVid1 expEndVid1赋值给expStartVid2 expEndVid2
	#输出参数：无
	#返回值： flag
	########################################################################################################
	proc Test_acCapacity {printWord expectList1 expectList2 caseId} {
		global fileId
		set flag 0
		set resultList1 ""
		set resultList2 ""
		send_log "\n time1:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		#将流量变小，使所有vlan中的数据流形成已知单播------
		foreach stream $::hGPNPortStreamList4 {
			stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 0.5 -LoadUnit MEGABITS_PER_SECOND
		}
		gwd::Start_SendFlow "$::hGPNPort1Gen $::hGPNPort4Gen"  "$::hGPNPort1Ana $::hGPNPort4Ana"
		after 20000
		gwd::Stop_SendFlow "$::hGPNPort1Gen $::hGPNPort4Gen"  "$::hGPNPort1Ana $::hGPNPort4Ana"
		#------将流量变小，使所有vlan中的数据流形成已知单播
		foreach stream $::hGPNPortStreamList4 {
			stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
		}
		send_log "\n time2:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		###开始抓包
		if {$::cap_enable} {
			gwd::Start_CapAllData ::capArr $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
			gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
		}
		gwd::Start_SendFlow "$::hGPNPort1Gen $::hGPNPort4Gen"  "$::hGPNPort1Ana $::hGPNPort4Ana"
		after 30000
		send_log "\n time3:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		###停止抓包
		if {$::cap_enable} {
			gwd::Stop_CapData $::hGPNPort1Cap 1 "$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap"
			gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap"
		}
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap" $fileId
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
					gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)vlan$key\的smac应为$value\实为[dict get $resultList1 $key]" $::fd_log
				} else {
					set flag_vid1 1
					set flag 1
					gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)vlan$key\的smac应为$value\实为[dict get $resultList1 $key]" $::fileId
				}
			} else {
				set flag_vid1 1
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)没有收到vlan$key\的数据流" $::fileId
			}
			
		}
		if {$flag_vid1 == 0} {
			gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)所有vlan中的数据接收都正确" $::fileId
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
					gwd::GWpublic_print "OK" "$printWord\NE4($::gpnIp4)vlan$key\的smac应为$value\实为[dict get $resultList2 $key]" $::fd_log
				} else {
					set flag_vid2 1
					set flag 1
					gwd::GWpublic_print "NOK" "$printWord\NE4($::gpnIp4)vlan$key\的smac应为$value\实为[dict get $resultList2 $key]" $::fileId
				}
			} else {
				set flag_vid2 1
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($::gpnIp4)没有收到vlan$key\的数据流" $::fileId
			}
			
		}
		if {$flag_vid2 == 0} {
			gwd::GWpublic_print "OK" "$printWord\NE4($::gpnIp4)所有vlan中的数据接收都正确" $::fileId
		}
		gwd::Stop_SendFlow "$::hGPNPort1Gen $::hGPNPort4Gen"  "$::hGPNPort1Ana $::hGPNPort4Ana"
		send_log "\n time8:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
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
			\"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4

        ###创建测试流量
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
        ###获取发生器和分析器指针
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
	
        ###配置流的速率 10%，Mbps
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList $hGPNPortStreamList1 $hGPNPortStreamList2 $hGPNPortStreamList4 $hGPNPort1Stream17" \
		-activate "false"
	
        foreach stream $hGPNPortStreamList $hGPNPortStreamList1 $hGPNPortStreamList2 $hGPNPortStreamList4 $hGPNPort1Stream17 {
        	stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        }
	stc::config $hGPNPort1Stream4 -FixedFrameLength "512"
        stc::apply 
        ###获取发生器配置指针
        gwd::Get_GeneratorCfgObj $hGPNPort1Gen hGPNPort1GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort2Gen hGPNPort2GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort3Gen hGPNPort3GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort4Gen hGPNPort4GenCfg
        set hGPNPortGenCfgList "$hGPNPort1GenCfg $hGPNPort2GenCfg $hGPNPort3GenCfg $hGPNPort4GenCfg"
        foreach hGenCfg $hGPNPortGenCfgList {
        	gwd::Cfg_GeneratorCfgObj $hGenCfg $GenCfg
        }
        ###创建并配置过滤器，默认过滤tag
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort1Ana hGPNPort1AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort2Ana hGPNPort2AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort3Ana hGPNPort3AnaFrameCfgFil	
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
        set hGPNPortAnaFrameCfgFilList "$hGPNPort1AnaFrameCfgFil $hGPNPort2AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil"
        foreach hCfgFil $hGPNPortAnaFrameCfgFilList {
        	gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $anaFliFrameCfg1
        }
       
        if {$cap_enable} {
                ###获取和配置capture对象相关的指针
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
	puts $fileId "===E-LAN容量及稳定性测试基础配置开始...\n"
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
	gwd::GWpublic_print "OK" "获取设备NE1($gpnIp1)业务板卡槽位号$rebootSlotlist1" $fileId
        set mslot1 [gwd::GWpulic_getWorkCardList $managePort1]
	gwd::GWpublic_print "OK" "获取设备1管理口所在板卡槽位号$mslot1" $fileId

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
        
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-LAN容量及稳定性测试基础配置失败，测试结束" \
	"E-LAN容量及稳定性测试基础配置成功，继续后面的测试" "GPN_PTN_009"
        puts $fileId ""
        puts $fileId "===E-LAN容量及稳定性测试基础配置结束..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 报文攻击测试\n"
        #   <1>4台设备，NE1--NE2--NE3-NE4按照上述拓扑，搭建E-LAN业务
        #   <2>向NE1设备发送ARP攻击报文，速率100Mbps，业务数据应该不受影响，管理通道正常
        #   <3>向NE1设备发送速率100Mbps业务报文，系统CPU利用率正常，管理通道正常
        #   <4>发送100M广播报文，系统CPU利用率正常，管理通道正常
        #   <5>发送不同波长的报文，系统CPU利用率正常，管理通道正常
        #   <6>发送满带宽的流量，系统CPU利用率正常，管理通道正常
	set flag1_case1 0
	set flag2_case1 0
	set flag3_case1 0
	set flag4_case1 0
	set flag5_case1 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====向NE1($gpnIp1)发送100M的ELAN业务报文，测试对ELAN业务和系统CPU利用率的影响  测试开始=====\n"
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
		###配置VLANIF接口
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
	
	####配置NE2
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
	
	#####配置NE3
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
	
	#####配置NE4
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
	if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 0 "向NE1($gpnIp1)发送100M的ELAN业务报文" $anaFliFrameCfg1 "GPN_PTN_009_$capId" \
	 	$rateL $rateR $rateL $rateR]} {
		set flag1_case1 1
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA1（结论）向NE1($gpnIp1)发送100M的ELAN业务报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1（结论）向NE1($gpnIp1)发送100M的ELAN业务报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====向NE1($gpnIp1)发送100M的ELAN业务报文，测试对ELAN业务和系统CPU利用率的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====向NE1($gpnIp1)发送100M的ARP攻击报文，测试对ELAN业务和系统CPU利用率的影响  测试开始=====\n"	
        stc::perform streamBlockActivate \
        	-streamBlockList "$hGPNPort1Stream1" \
        	-activate "true"
	incr capId
	if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 0 "向NE1($gpnIp1)发送100M的ARP攻击报文" $anaFliFrameCfg1 "GPN_PTN_009_$capId" \
		 $rateL $rateR $rateL $rateR]} {
		set flag2_case1 1
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA2（结论）向NE1($gpnIp1)发送100M的ARP攻击报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2（结论）向NE1($gpnIp1)发送100M的ARP攻击报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====向NE1($gpnIp1)发送100M的ARP攻击报文，测试对ELAN业务和系统CPU利用率的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====向NE1($gpnIp1)发送100M的广播报文，测试对ELAN业务和系统CPU利用率的影响  测试开始=====\n"	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream1" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream3" \
		-activate "true"
	incr capId
	if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 0 "向NE1($gpnIp1)发送100M的广播报文" $anaFliFrameCfg1 "GPN_PTN_009_$capId" \
		 $rateL $rateR $rateL $rateR]} {
		set flag3_case1 1
	}
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA3（结论）向NE1($gpnIp1)发送100M的广播报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3（结论）向NE1($gpnIp1)发送100M的广播报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====向NE1($gpnIp1)发送100M的广播报文，测试对ELAN业务和系统CPU利用率的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====向NE1($gpnIp1)发送速率100Mbps帧长度512的报文，测试对ELAN业务和系统CPU利用率的影响  测试开始=====\n"
		stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream3" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream4" \
		-activate "true"
	incr capId
	if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 0 "向NE1($gpnIp1)发送100M的帧长度512的报文" $anaFliFrameCfg1 "GPN_PTN_009_$capId" \
		 $rateL $rateR $rateL $rateR]} {
		set flag4_case1 1
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA4（结论）向NE1($gpnIp1)发送速率100Mbps帧长度512的报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4（结论）向NE1($gpnIp1)发送速率100Mbps帧长度512的报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====向NE1($gpnIp1)发送速率100Mbps帧长度512的报文，测试对ELAN业务和系统CPU利用率的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====向NE1($gpnIp1)发送满带宽的数据报文，测试对ELAN业务和系统CPU利用率的影响  测试开始=====\n"	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream4" \
		-activate "false"
	stc::config [stc::get $hGPNPort1Stream5 -AffiliationStreamBlockLoadProfile-targets] -load 800 -LoadUnit MEGABITS_PER_SECOND
	stc::apply
	incr capId
	if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 0 "向NE1($gpnIp1)发送满带宽的数据报文" $anaFliFrameCfg1 "GPN_PTN_009_$capId" \
		 $rateL $rateR 760000000 840000000]} {
		set flag5_case1 1
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA5（结论）向NE1($gpnIp1)发送满带宽的数据报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5（结论）向NE1($gpnIp1)发送满带宽的数据报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====向NE1($gpnIp1)发送满带宽的数据报文，测试对ELAN业务和系统CPU利用率的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase1 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 1测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 1测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 1 报文攻击测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 内存泄漏测试\n"
	#   <1>创建1条E-LAN业务， 配置相应的LSP、PW、AC，再删除该条业务，系统正常
	#   <2>用脚本反复添加删除E-LAN实例500次，业务及管理正常，内存没有泄漏，系统无异常
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
		#检查数据转发
		incr capId
		if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 2 "第$i\次添加新建ELAN业务后" $anaFliFrameCfg1 "GPN_PTN_009_$capId" $rateL $rateR $rateL $rateR]} {
			set flag1_case2 1
		}
        	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac500"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw012"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw013"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw014"
        	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls10"
		incr capId
		if {[PTN_Stability $telnet1 $matchType1 $Gpn_type1 $fileId 1 "第$i\次删除新建ELAN业务后" $anaFliFrameCfg1 "GPN_PTN_009_$capId" $rateL $rateR $rateL $rateR]} {
			set flag1_case2 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
	send_log "\n resource1:$resource1"
	send_log "\n resource2:$resource2"
	if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "反复添加删除ELAN业务之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "反复添加删除ELAN业务之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		 gwd::GWpublic_print "NOK" "FA6（结论）反复添加删除ELAN业务，对已存在ELAN业务和系统内存有影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6（结论）反复添加删除ELAN业务，对已存在ELAN业务和系统内存无影响" $fileId
	}
	puts $fileId ""
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase2 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 2测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 2测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 2 内存泄漏测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 E-LAN业务容量及健壮性测试-1个VSI承载多个PW AC测试\n"
        #vpls域mac地址容量测试 
        #   <1>在NE1的vsi中配置mac地址学习数量为最大容量（系统支持最大可配数量为32000）
        #   <2>向NE1的uni口发送源mac递增的相应数量固定报文数
        #   预期结果:查看NE2、NE3的UNI口学习的报文数，与NE1发送的报文数一致
        #            在底层查看mac地址学习数量，VSI下最大学习到的MAC地址数与设置值一致；
        #1个VSI承载多个PW测试  
        #   <3>四台76，按照上述拓扑，NE1设备通过带外上网管，NE2、NE3、NE4设备带内上网管,四台设备长ping网管地址
        #   <4>在NE1的UNI口发送满带宽业务流量（不同波长报文、多种报文、少量arp报文），NE2接收正常无丢包，系统无异常，记录下系统1个VSI上可承载多少个PW?
        #   预期结果:NE1、NE2保存配置，查看各项表项（LSP、PW、AC条目数都正常）显示均正确；配置文件可成功导出，系统无异常；查看导出的配置文件正确，无乱码
        #   <5>使能每条业务LSP、PW性能统计，系统无异常，性能统计功能生效，统计值正确
        #   <6>shutdown和undo shutdown NE1设备的NNI/UNI端口光纤50次，业务均恢复正常 ，每条业务彼此无干扰，DCN正常
        #   <7>进行NE1设备的SW/NMS倒换50次（软/硬倒换），业务均正常恢复，每条业务彼此无干扰，DCN正常，查看标签转发表项正确
        #   <8>复位NE1设备的NNI/UNI所在板卡50次，业务均恢复正常 ，每条业务彼此无干扰，DCN正常
        #   <9>保存NE1和NE2设备配置，掉电重启NE1和NE2设备（软复位和硬复位）50次，每次操作后系统正常启动，业务恢复正常且彼此无干扰，标签转发表项正确，DCN正常
        #   <10>清空NE1和NE2设备配置，重启NE1和NE2设备，待设备起来后查看配置信息空，将各自导出的配置文件导入，重启设备，
        #       待设备起来后查看配置信息无丢失均正确，发流验证业务均正常转发，DCN正常
        #   <11>清空NE1和NE2设备配置，重启NE1和NE2设备
        #1个VSI承载多少AC
        #   <12>四台76，按照上述拓扑，NE1设备通过带外上网管，NE2、NE3、NE4设备带内上网管,四台设备长ping网管地址
        #   <13>在NE1、NE2之间建立一条EPLAN业务，一个vpls域、一个LSP，一个PW
        #   <14>NE1、NE2的多个UNI口加入不同vlan，创建多个ac
        #   <15>向NE1的一个UNI口发送相应vlan业务流量，NE2接收正常无丢包，NE1的其他端口也能收到系统无异常，记录下系统1个VSI上可承载多少个AC
        #   预期结果:NE1、NE2保存配置，均上载网管查看各项表项（LSP、PW、AC条目数都正常）显示均正确；配置文件可成功导出，系统无异常；查看导出的配置文件正确，无乱码
        #   <16>shutdown和undo shutdownNE1设备的NNI/UNI端口光纤50次，业务均恢复正常 ，每条业务彼此无干扰，DCN正常
        #   <17>复位NE1设备的NNI/UNI所在板卡50次，业务均恢复正常 ，每条业务彼此无干扰，DCN正常
        #   <18>进行NE1设备的SW/NMS倒换50次（软/硬倒换），业务均正常恢复，每条业务彼此无干扰，DCN正常，查看标签转发表项正确
        #   <19>保存NE1和NE2设备配置，掉电重启NE1和NE2设备（软复位和硬复位）50次，每次操作后系统正常启动，业务恢复正常且彼此无干扰，标签转发表项正确，DCN正常
        #   <20>清空NE1和NE2设备配置，重启NE1和NE2设备
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
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域mac地址容量测试  测试开始=====\n"	
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
        	gwd::GWpublic_print "NOK" "连续3次查询NE1($gpnIp1)vpls10上学习到的mac地址个数都失败" $fileId
        } else {
		if {$forwardCnt_ac == 32000} {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)vpls10上学习到的mac地址个数应为32000实为$forwardCnt_ac" $fileId
		} else {
			set flag1_case3 1 
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)vpls10上学习到的mac地址个数应为32000实为$forwardCnt_ac" $fileId
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
		gwd::GWpublic_print "NOK" "连续3次查询NE2($gpnIp2)vpls20上学习到的mac地址个数都失败" $fileId
	} else {
		if {$forwardCnt_pw1 == 32000} {
			gwd::GWpublic_print "OK" "NE2($gpnIp2)vpls20上学习到的mac地址个数应为32000实为$forwardCnt_pw1" $fileId
		} else {
			set flag1_case3 1 
			gwd::GWpublic_print "NOK" "NE2($gpnIp2)vpls20上学习到的mac地址个数应为32000实为$forwardCnt_pw1" $fileId
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
		gwd::GWpublic_print "NOK" "连续3次查询NE3($gpnIp3)vpls30上学习到的mac地址个数都失败" $fileId
	} else {
		if {$forwardCnt_pw2 == 32000} {
			gwd::GWpublic_print "OK" "NE3($gpnIp3)vpls30上学习到的mac地址个数应为32000实为$forwardCnt_pw2" $fileId
		} else {
			set flag1_case3 1 
			gwd::GWpublic_print "NOK" "NE3($gpnIp3)vpls30上学习到的mac地址个数应为32000实为$forwardCnt_pw2" $fileId
		}
	}
	gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	puts $fileId ""
	if {$flag1_case3 == 1} {
		set flagCase3 1
		 gwd::GWpublic_print "NOK" "FA7（结论）vpls域mac地址容量测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7（结论）vpls域mac地址容量测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域mac地址容量测试  测试结束=====\n"
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
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI承载PW AC的容量测试  测试开始=====\n"
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
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)一个VSI承载PW的容量为$ne1PWnum\，比标称值1024少" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)一个VSI承载PW的容量为$ne1PWnum\，满足要求" $fileId
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
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)一个VSI承载PW的容量为$ne4PWnum\，比标称值1024少" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)一个VSI承载PW的容量为$ne4PWnum\，满足要求" $fileId
	}
	##########################################################################################################
	###暂时不发流验证pw的容量--------------
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
            #		gwd::GWpublic_print "NOK" "发流验证pw的容量" $fileId
            #	}
	###--------------暂时不发流验证pw的容量
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
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)一个VSI承载AC的容量为$ne1ACnum\，比标称值1024少" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)一个VSI承载AC的容量为$ne1ACnum\，满足要求" $fileId
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
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)一个VSI承载AC的容量为$ne4ACnum\，比标称值1024少" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)一个VSI承载AC的容量为$ne4ACnum\，满足要求" $fileId
	}
	puts $fileId ""
	if {$flag2_case3 == 1} {
		set flagCase3 1
		 gwd::GWpublic_print "NOK" "FA8（结论）一个VSI承载PW AC的容量测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8（结论）一个VSI承载PW AC的容量测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI承载PW AC的容量测试  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI满配AC，发流验证配置是否生效  测试开始=====\n"
	
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
		 gwd::GWpublic_print "NOK" "FA9（结论）一个VSI满配AC，发流验证配置" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9（结论）一个VSI满配AC，发流验证配置" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI满配AC，发流验证配置是否生效  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI满配AC，NE1($gpnIp1)反复shutdown/undo shutdown业务端口测试业务恢复和系统内存  测试开始=====\n"
	incr capId
        foreach eth "$GPNPort12 $GPNTestEth1" {
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
        		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
        		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
        		after $WaiteTime
			after 120000
			incr capId
        		if {[Test_acCapacity "第$j\次shutdown/undo shutdown NE1($gpnIp1)的$eth\端口后" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
        		  set  flag4_case3 1
        		}
        	}
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
        	send_log "\n resource1:$resource1"
        	send_log "\n resource2:$resource2"
        	if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
        		set flag4_case3 1
        		gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
        	}
        }
	puts $fileId ""
	if {$flag4_case3 == 1} {
		set flagCase3 1
		 gwd::GWpublic_print "NOK" "FB1（结论）一个VSI满配AC，NE1($gpnIp1)反复shutdown/undo shutdown业务端口测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1（结论）一个VSI满配AC，NE1($gpnIp1)反复shutdown/undo shutdown业务端口测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI满配AC，NE1($gpnIp1)反复shutdown/undo shutdown业务端口测试业务恢复和系统内存  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI满配AC，NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存  测试开始=====\n"
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
                		if {[Test_acCapacity "第$j\次重启NE1($gpnIp1)$slot\槽位板卡" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
                		      set  flag5_case3 1
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
		  	      set flag5_case3 1
		  	      gwd::GWpublic_print "NOK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
		        } else {
		  	      gwd::GWpublic_print "OK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
		        }
	        }
	}
	puts $fileId ""
	if {$flag5_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB2（结论）一个VSI满配AC，NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2（结论）一个VSI满配AC，NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI满配AC，NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI满配AC，NE1($gpnIp1)反复进行NMS主备倒换，测试业务恢复和系统内存  测试开始=====\n"
        ###反复进行NMS主备倒换
        gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
        for {set j 1} {$j<$cntdh} {incr j} {
                if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after [expr 2*$rebootTime]
                	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
                	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
                	if {[Test_acCapacity "第$j\次 NE1($gpnIp1)进行NMS主备倒换后" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
                		set  flag6_case3 1
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
                	set flag6_case3	1
                	gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
                } else {
                	gwd::GWpublic_print "OK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
                }
        }
        puts $fileId ""
        if {$flag6_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB3（结论）一个VSI满配AC，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB3（结论）一个VSI满配AC，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI满配AC，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI满配AC，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存，测试业务恢复和系统内存  测试开始=====\n"
	set testFlag 0 ;#=1 测试跳过
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			after 120000
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_acCapacity "第$j\次 NE1($gpnIp1)进行SW主备倒换后" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
				set  flag7_case3 1
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
			set flag7_case3	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag7_case3 == 1} {
		set flagCase3 1
		 gwd::GWpublic_print "NOK" "FB4（结论）一个VSI满配AC，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4（结论）一个VSI满配AC，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI满配AC，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI满配AC，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存，测试业务恢复和系统内存  测试开始=====\n" 
	##反复保存设备重启
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		after 60000
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after [expr 2*$rebootTime]
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[Test_acCapacity "第$j\次 NE1($gpnIp1)进行保存设备重启后" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
			set  flag8_case3 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag8_case3	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag8_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB5（结论）一个VSI满配AC，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5（结论）一个VSI满配AC，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一个VSI满配AC，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存，测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====清空配置重启，下载一个VSI满配PW和AC的配置并重启设备后验证业务  测试开始=====\n" 
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
	if {[Test_acCapacity "下载满配的配置并重启设备后" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
		set  flag9_case3 1
	}
	puts $fileId ""
	if {$flag9_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB6（结论）清空配置重启，下载一个VSI满配PW和AC的配置并重启设备后验证业" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6（结论）清空配置重启，下载一个VSI满配PW和AC的配置并重启设备后验证业" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====清空配置重启，下载一个VSI满配PW和AC的配置并重启设备后验证业  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase3 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 3测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 3测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 3 E-LAN业务容量及健壮性测试-1个VSI承载多个PW AC测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 E-LAN业务健壮性测试-系统承载多个vsi测试\n"
        #系统承载多少VSI
        #   <21>四台76组网，组网拓扑见拓扑图1，NE1--NE2--NE3--NE4两两相连，NE1设备通过带外上网管,NE2和NE3、NE4设备通过带内上网管，
        #       或4台设备以DCN管理，三台设备彼此之间的NNI端口通过以太网接口形式相连，NNI端口以untag方式加入到VLANIF中,四台设备长ping网管地址
        #   <22>创建NE1到NE2、NE3、NE4之间的EVP-LAN业务，NE2既为PE又为p设备，用户侧接入模式为端口+运营商VLAN模式
        #   <23>NE1到NE2、NE3、NE4之间各创建一条lsp，一个vpls与承载三条PW，一个AC
        #   <24>向NE1的UNI口发送满带宽业务流量（不同波长报文、多种报文、少量arp报文），NE2、NE3、NE4接收流量正常，系统无异常，记录系统中可创建多少的VPLS域
        #   预期结果:保存NE1和NE2设备配置，查看各项表项（LSP，PW，AC条目数都正常）显示均正确；配置文件可成功导出，系统无异常；查看导出的配置文件正确，无乱码，DCN正常
        #   <25>shutdown和undo shutdownNE1设备的NNI/UNI端口光纤50次，业务均恢复正常 ，每条业务彼此无干扰，DCN正常
        #   <26>复位NE1设备的NNI/UNI所在板卡50次，业务均恢复正常 ，每条业务彼此无干扰，DCN正常
        #   <27>进行NE1设备的SW/NMS倒换50次（软/硬倒换），业务均正常恢复，每条业务彼此无干扰，DCN正常查看标签转发表项正确
        #   <28>保存NE1和NE2、NE3设备配置，掉电重启NE1和NE2、NE3设备（软复位和硬复位）50次，每次操作后系统正常启动，业务恢复正常且彼此无干扰，标签转发表项正确，DCN正常
        #   <29>清空NE1和NE2设备配置，重启NE1和NE2设备，待设备起来后查看配置信息空，将各自导出的配置文件导入，重启设备，
        #       待设备起来后查看配置信息无丢失均正确，发流验证业务均正常转发，DCN正常
        ####导入NE1和NE4设备的lsp配置文件
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set flag5_case4 0
	set flag6_case4 0
	set flag7_case4 0
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====系统承载vsi的容量测试  测试开始=====\n"
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
	
	#NE4的配置
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
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)系统承载vsi的容量为$VPLSnum1\，比标称值$VsiNum\少" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)系统承载vsi的容量为$VPLSnum1\，满足要求" $fileId
	}
	if {$VPLSnum4 < $VsiNum} {
		set flag1_case4 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)系统承载vsi的容量为$VPLSnum4\，比标称值$VsiNum\少" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)系统承载vsi的容量为$VPLSnum4\，满足要求" $fileId
	}
	puts $fileId ""
	if {$flag1_case4 == 1} {
		set flagCase3 1
		 gwd::GWpublic_print "NOK" "FB7（结论）系统承载vsi的容量测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7（结论）系统承载vsi的容量测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====系统承载vsi的容量测试  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI满配，反复shutdown/undo shutdown业务端口测试业务恢复和系统内存  测试开始=====\n"
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
			if {[Test_acCapacity "第$j\次shutdown/undo shutdown NE1($gpnIp1)的$eth\端口后" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
				set  flag2_case4 1
			}
		}
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag2_case4 1
			gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag2_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FB8（结论）NE1($gpnIp1)VSI满配，反复shutdown/undo shutdown业务端口测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8（结论）NE1($gpnIp1)VSI满配，反复shutdown/undo shutdown业务端口测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI满配，反复shutdown/undo shutdown业务端口测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI满配，反复重启NNI口所在板卡后，测试业务恢复和系统内存  测试开始=====\n"
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
				if {[Test_acCapacity "第$j\次重启NE1($gpnIp1)$slot\槽位板卡" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
				      set  flag3_case4 1
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
				set flag3_case4 1
				gwd::GWpublic_print "NOK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
			} else {
				gwd::GWpublic_print "OK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
			}
		}
#	}
	puts $fileId ""
	if {$flag3_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB9（结论）NE1($gpnIp1)VSI满配，反复重启NNI口所在板卡后，测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9（结论）NE1($gpnIp1)VSI满配，反复重启NNI口所在板卡后，测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI满配，反复重启NNI口所在板卡后，测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI满配，反复进行NMS主备倒换，测试业务恢复和系统内存  测试开始=====\n"
	###反复进行NMS主备倒换
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after [expr 2*$rebootTime]
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_acCapacity "第$j\次 NE1($gpnIp1)进行NMS主备倒换后" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
				set  flag4_case4 1
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
			set flag4_case4	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag4_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC1（结论）NE1($gpnIp1)VSI满配，反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1（结论）NE1($gpnIp1)VSI满配，反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI满配，反复进行NMS主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI满配，反复进行SW主备倒换测试业务恢复和系统内存，测试业务恢复和系统内存  测试开始=====\n"
	set testFlag 0 ;#=1 测试跳过
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			after 300000
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_acCapacity "第$j\次 NE1($gpnIp1)进行SW主备倒换后" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
				set  flag5_case4 1
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
			set flag5_case4	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag5_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FC2（结论）NE1($gpnIp1)VSI满配，反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2（结论）NE1($gpnIp1)VSI满配，反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI满配，反复进行SW主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI满配，反复进行保存设备重启后测试业务恢复和系统内存，测试业务恢复和系统内存  测试开始=====\n" 
	##反复保存设备重启
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		after 60000
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after [expr 2*$rebootTime]
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[Test_acCapacity "第$j\次 NE1($gpnIp1)进行保存设备重启后" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
			set  flag6_case4 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag6_case4	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC3（结论）NE1($gpnIp1)VSI满配，反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3（结论）NE1($gpnIp1)VSI满配，反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)VSI满配，反复进行保存设备重启后测试业务恢复和系统内存，测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====清空配置重启，下载VSI满配的配置并重启设备后验证业务  测试开始=====\n" 
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
	if {[Test_acCapacity "下载VSI满配的配置并重启设备后" $expectList1 $expectList2 "GPN_PTN_009_$capId"]} {
		set  flag7_case4 1
	}
	puts $fileId ""
	if {$flag7_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC4（结论）清空配置重启，下载VSI满配的配置并重启设备后验证业" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4（结论）清空配置重启，下载VSI满配的配置并重启设备后验证业" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====清空配置重启，下载VSI满配的配置并重启设备后验证业  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_009_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
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
	puts $fileId "Test Case 4 E-LAN业务健壮性测试-系统承载多个vsi测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 E-LAN业务健壮性测试-系统承载多个vsi测试\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===恢复初始化配置...\n"
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
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "测试结束后配置恢复" "测试结束后配置恢复" "GPN_PTN_009"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "测试过程中所有配置文件都上传成功" "GPN_PTN_009"
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_009测试目的：E-LAN容量及稳定性测试\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1==1 || $flagCase2==1 || $flagCase3==1 || $flagCase4==1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_009测试结果" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4测试结果" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "（结论）向NE1($gpnIp1)发送100M的ELAN业务报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "（结论）向NE1($gpnIp1)发送100M的ARP攻击报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "（结论）向NE1($gpnIp1)发送100M的广播报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "（结论）向NE1($gpnIp1)发送速率100Mbps帧长度512的报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "（结论）向NE1($gpnIp1)发送满带宽的数据报文，测试对ELAN业务和系统CPU利用率的影响" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "（结论）反复添加删除ELAN业务，对ELAN业务和系统内存[expr {($flag1_case2 == 1) ? "有" : "无"}]有影响" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "（结论）vpls域mac地址容量测试" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag2_case3 == 1) ? "NOK" : "OK"}]" "（结论）一个VSI承载PW AC的容量测试" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag3_case3 == 1) ? "NOK" : "OK"}]" "（结论）一个VSI满配AC，发流验证配置" $fileId
	gwd::GWpublic_print "== FB1 == [expr {($flag4_case3 == 1) ? "NOK" : "OK"}]" "（结论）一个VSI满配AC，NE1($gpnIp1)反复shutdown/undo shutdown业务端口测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag5_case3 == 1) ? "NOK" : "OK"}]" "（结论）一个VSI满配AC，NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag6_case3 == 1) ? "NOK" : "OK"}]" "（结论）一个VSI满配AC，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag7_case3 == 1) ? "NOK" : "OK"}]" "（结论）一个VSI满配AC，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag8_case3 == 1) ? "NOK" : "OK"}]" "（结论）一个VSI满配AC，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag9_case3 == 1) ? "NOK" : "OK"}]" "（结论）清空配置重启，下载一个VSI满配PW和AC的配置并重启设备后验证业" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "（结论）系统承载vsi的容量测试" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)VSI满配，反复shutdown/undo shutdown业务端口测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)VSI满配，反复重启NNI口所在板卡后，测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FC1 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)VSI满配，反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FC2 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)VSI满配，反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FC3 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)VSI满配，反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FC4 == [expr {($flag7_case4 == 1) ? "NOK" : "OK"}]" "（结论）清空配置重启，下载VSI满配的配置并重启设备后验证业" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "（结论）测试结束后配置恢复" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "（结论）测试过程中配置文件的上传" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "运行异常：错误为$err" "" "GPN_PTN_009"
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
