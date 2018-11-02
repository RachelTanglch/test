#!/bin/sh
# T2_GPN_PTN_ELINE_005.tcl \
exec tclsh "$0" ${1+"$@"}
#测试名称：ptn005
#-----------------------------------------------------------------------------------------------------------------------------------
#测试目的：E-LINE业务健壮性测试
#1-绑定静态ARP容量测试             
#2-1个LSP承载多个PW测试              
#3-1个LSP仅承载一个PW测试        
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
###绑定静态ARP容量测试
###1个LSP仅承载一个PW测试
#   <1>1台76设备，创建E-LINE业务，NNI端口以tag方式加入到不同的业务VLAN中
#   <2>每条业务均绑定静态ARP且绑定MAC均不同,（一个LSP上仅承载一个PW，一个LSP承载在一个VLANIF上）
#   <3>隧道节点类型为PE，用户侧端口接入模式设为“端口+运营商VLAN”
#   <4>业务创建成功，系统无异常，从用户侧端口发送匹配业务流量，从NNI端口抓取MPLS报文，查看报文中SMAC、DMAC、LSP标签、PW标签均正确
#   <5>记录下系统可绑定多少个静态ARP且绑定MAC
#   <6>导出配置文件，可成功导出，系统无异常；查看导出的配置文件正确，无乱码
#   <7>shutdown和undo shutdown设备的NNI/UNI端口50次，业务均恢复正常 ，每条业务彼此无干扰
#   <8>复位设备的NNI/UNI所在板卡50次，业务均恢复正常 ，每条业务彼此无干扰
#   <9>保存配置，设备正常启动，业务均正常转发
#   <10>在NE1和NE2设备上均再创建500条业务的OAM和500条业务的QOS，系统无异常，且500条业务的OAM和500条业务的QOS功能均生效
#   <11>保存NE1和NE2设备配置，重启NE1和NE2设备，设备正常启动，业务正常转发
#   <12>在该条件下，设备运行24小时，业务正常转发，业务不丢包，系统CPU利用正常，系统可正常管理，系统无异常
#   <13>清空配置，重启设备,设备正常启动，启动后无任何配置信息
#2、搭建Test Case 2测试环境
###1个LSP承载多个PW测试  
#   <1>两台76，NE1--NE2，在NE1端口1与NE2端口2间创建多条ELINE业务（均承载在一个LSP上）
#   <2>NE1和NE2隧道节点类型为PE
#   <3>每条业务都绑定静态ARP 映射，创建完毕，发送业务流量查看每条业务均正常转发，系统无异常
#   <4>记录下系统1个LSP上可承载多少个PW(系统目前一条LSP可承载4092个PW)
#   <5>两台设备保存配置，导出配置文件，可成功导出，系统无异常；查看导出的配置文件正确，无乱码
#   <6>使能每条业务LSP/PW/AC性能统计，系统无异常，性能统计功能生效，统计值正确
#   <7>shutdown和undo shutdownNE1设备的NNI/UNI端口50次，业务均恢复正常 ，每条业务彼此无干扰
#   <8>复位设备的NNI/UNI所在板卡50次，业务均恢复正常 ，每条业务彼此无干扰
#   <9>进行NE1设备的SW/NMS倒换50次（软倒换），业务均正常恢复，每条业务彼此无干扰，查看标签转发表项正确
#   <10>保存NE1和NE2设备配置，重启NE1和NE2设备（软复位）50次，每次操作后系统正常启动，业务恢复正常且彼此无干扰，标签转发表项正确
#   <11>清空NE1和NE2设备配置，重启NE1和NE2设备，待设备起来后查看配置信息空
#   <12>将各自导出的配置文件导入，重启设备，待设备起来后查看配置信息无丢失均正确，发流验证业务均正常转发
#   <13>清空NE1和NE2设备配置，重启NE1和NE2设备
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
        close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_005_LOG.txt" a]
        set stdout $fd_log
        chan configure $stdout -blocking 0 -buffering none;#非阻塞模式 按行flush
        log_file log\\GPN_PTN_005_LOG.txt
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_005_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#非阻塞模式 按行flush
        
        file mkdir "debug"
        set fd_debug [open debug\\GPN_PTN_005_DEBUG.txt a]
        exp_internal -f debug\\GPN_PTN_005_DEBUG.txt 0
        chan configure $fd_debug -blocking 0 -buffering none;#非阻塞模式 按行flush
	
	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl
	
        array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1" -vid "1000" -pri "000" -stepValue "1" -recycleCount "6" -EnableStream "TRUE"}
        array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "500" -pri "000" -stepValue "1" -recycleCount "6" -EnableStream "TRUE"}
        array set dataArr3 {-srcMac "00:00:00:00:00:03" -dstMac "00:00:00:00:00:33" -srcIp "192.85.1.3" -dstIp "192.0.0.3" -vid "600" -pri "000" -stepValue "1" -recycleCount "6" -EnableStream "TRUE"}
        array set dataArr4 {-srcMac "00:00:00:00:00:11" -dstMac "00:00:00:00:00:01" -srcIp "192.0.0.1" -dstIp "192.85.1.1" -vid "1000" -pri "000" -stepValue "1" -recycleCount "6" -EnableStream "TRUE"}
	array set dataArr5 {-srcMac "00:00:00:00:00:11" -dstMac "00:00:00:00:00:33" -srcIp "192.85.1.10" -dstIp "192.0.0.10" -vid "10" -pri "000"}
	array set dataArr6 {-srcMac "00:00:00:00:00:33" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.11" -dstIp "192.0.0.11" -vid "10" -pri "000"}
        #设置定制信息参数
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        
        #设置发生器参数
        set GenCfg {-SchedulingMode RATE_BASED}
        
        #设置过滤分析器参数
        #####smac和vld
        set anaFliFrameCfg1 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><vlans name="anon_13224"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        set anaFliFrameCfg0 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        #####匹配mpls报文中的dmac和vid
        set anaFliFrameCfg5 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</dstMac><vlans name="anon_4679"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
        #####匹配mpls报文中lsp和pw两层标签
        set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}

	
	set flagResult 0
	set flagCase1 0   ;#Test case 1标志位 
	set flagCase2 0   ;#Test case 2标志位
	
	set lFailFile ""
	set FLAGF 0
	
	set tcId 0
	set capId 0
	set cfgId 0

	regsub {/} $GPNTestEth2 {_} GPNTestEth2_cap
	regsub {/} $GPNTestEth3 {_} GPNTestEth3_cap
	regsub {/} $GPNTestEth4 {_} GPNTestEth4_cap
	#为测试结论预留空行
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
        			gwd::GWpublic_print NOK "在$matchType\上删除vlan，失败。命令参数有误" $fileId
        			send -i $spawn_id "\r"
        		}
        		-re {does not exist} {
        			set errorTmp 1
        			gwd::GWpublic_print NOK "在$matchType\上删除vlan，失败。删除的vid不存在" $fileId
        			send -i $spawn_id "\r"
        		}
        		-re {Connot del} {
        			set errorTmp 1
        			gwd::GWpublic_print NOK "在$matchType\上删除vlan，失败。vlan中承载有业务，不能删除" $fileId
        		}
        		-re "$matchType\\(config\\)#" {
        			send -i $spawn_id "\r"
        			gwd::GWpublic_print OK "在$matchType\上删除vlan$vid，成功" $fileId
        		}
        		-timeout 60
        	}
        	return $errorTmp
        }
        #函数功能：Case1中，ARP满配后验证业务
        #输入参数：fileId:报告输出的文件标识符	 
        #	  rateL rateR:收到数据包的取值范围
        #	  capFileName:抓包文件的名称
        #返回值：flag:"0"表示所有业务都正常。 "1"有不正常的业务
        proc GPN005Case1_checkFlow {fileId rateL rateR capFileName} {
        	global GPNTestEth2
        	global GPNPort5
        	global newGPNMac
        	set flag 0
        	sendAndStat51 aGPNPort2Cnt2 aGPNPort2Cnt1 "$capFileName-p$::GPNTestEth2_cap\($::gpnIp1\).pcap"
        	parray aGPNPort2Cnt2
        	parray aGPNPort2Cnt1
		gwd::GWpublic_print "  " "抓包文件为$capFileName-p$::GPNTestEth2_cap\($::gpnIp1\).pcap" $fileId
        	if {$aGPNPort2Cnt2(cnt1) < $rateL || $aGPNPort2Cnt2(cnt1) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1000的数据流，$GPNTestEth2\收到mpls0=1000 mpls1=1600的数据包的个数为$aGPNPort2Cnt2(cnt1)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1000的数据流，$GPNTestEth2\收到mpls0=1000 mpls1=1600的数据包的个数为$aGPNPort2Cnt2(cnt1)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort2Cnt2(cnt2) < $rateL || $aGPNPort2Cnt2(cnt2) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1001的数据流，$GPNTestEth2\收到mpls0=1001 mpls1=1601的数据包的个数为$aGPNPort2Cnt2(cnt2)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1001的数据流，$GPNTestEth2\收到mpls0=1001 mpls1=1601的数据包的个数为$aGPNPort2Cnt2(cnt2)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort2Cnt2(cnt3) < $rateL || $aGPNPort2Cnt2(cnt3) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1002的数据流，$GPNTestEth2\收到mpls0=1002 mpls1=1602的数据包的个数为$aGPNPort2Cnt2(cnt3)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1002的数据流，$GPNTestEth2\收到mpls0=1002 mpls1=1602的数据包的个数为$aGPNPort2Cnt2(cnt3)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort2Cnt2(cnt4) < $rateL || $aGPNPort2Cnt2(cnt4) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1003的数据流，$GPNTestEth2\收到mpls0=1003 mpls1=1603的数据包的个数为$aGPNPort2Cnt2(cnt4)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1003的数据流，$GPNTestEth2\收到mpls0=1003 mpls1=1603的数据包的个数为$aGPNPort2Cnt2(cnt4)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort2Cnt2(cnt5) < $rateL || $aGPNPort2Cnt2(cnt5) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1004的数据流，$GPNTestEth2\收到mpls0=1004 mpls1=1604的数据包的个数为$aGPNPort2Cnt2(cnt5)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1004的数据流，$GPNTestEth2\收到mpls0=1004 mpls1=1604的数据包的个数为$aGPNPort2Cnt2(cnt5)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort2Cnt2(cnt6) < $rateL || $aGPNPort2Cnt2(cnt6) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1005的数据流，$GPNTestEth2\收到mpls0=1005 mpls1=1605的数据包的个数为$aGPNPort2Cnt2(cnt6)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1005的数据流，$GPNTestEth2\收到mpls0=1005 mpls1=1605的数据包的个数为$aGPNPort2Cnt2(cnt6)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt2) < $rateL || $aGPNPort2Cnt1(cnt2) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1000的数据流，$GPNTestEth2\收到vid=402 dmac=$newGPNMac\的数据包的个数为$aGPNPort2Cnt2(cnt1)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1000的数据流，$GPNTestEth2\收到vid=402 dmac=$newGPNMac\的数据包的个数为$aGPNPort2Cnt2(cnt1)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt3) < $rateL || $aGPNPort2Cnt1(cnt3) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1001的数据流，$GPNTestEth2\收到vid=403 dmac=$newGPNMac\的数据包的个数为$aGPNPort2Cnt2(cnt2)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1001的数据流，$GPNTestEth2\收到vid=403 dmac=$newGPNMac\的数据包的个数为$aGPNPort2Cnt2(cnt2)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt4) < $rateL || $aGPNPort2Cnt1(cnt4) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1002的数据流，$GPNTestEth2\收到vid=404 dmac=$newGPNMac\的数据包的个数为$aGPNPort2Cnt2(cnt3)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1002的数据流，$GPNTestEth2\收到vid=404 dmac=$newGPNMac\的数据包的个数为$aGPNPort2Cnt2(cnt3)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt5) < $rateL || $aGPNPort2Cnt1(cnt5) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1003的数据流，$GPNTestEth2\收到vid=405 dmac=$newGPNMac\的数据包的个数为$aGPNPort2Cnt2(cnt4)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1003的数据流，$GPNTestEth2\收到vid=405 dmac=$newGPNMac\的数据包的个数为$aGPNPort2Cnt2(cnt4)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt6) < $rateL || $aGPNPort2Cnt1(cnt6) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1004的数据流，收到vid=406 dmac=$newGPNMac\的数据包的个数为$aGPNPort2Cnt2(cnt5)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1004的数据流，收到vid=406 dmac=$newGPNMac\的数据包的个数为$aGPNPort2Cnt2(cnt5)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt7) < $rateL || $aGPNPort2Cnt1(cnt7) > $rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1005的数据流，收到vid=407 dmac=$newGPNMac\的数据包的个数为$aGPNPort2Cnt2(cnt6)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth2\镜像$GPNPort5\(nni口)出口，UNI侧发送tag1005的数据流，收到vid=407 dmac=$newGPNMac\的数据包的个数为$aGPNPort2Cnt2(cnt6)，在$rateL-$rateR\范围内" $fileId
        	}
        	return $flag
        }	
	
        #函数功能：Case1中，ARP满配后验证业务
        #输入参数：fileId:报告输出的文件标识符	 
        #	  rateL rateR:收到数据包的取值范围
        #	  caseId:抓包文件的名称的后缀
        #返回值：flag:"0"表示所有业务都正常。 "1"有不正常的业务
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
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($::gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($::gpnIp3\).pcap" $fileId
        	if {$aGPNPort4Cnt1(cnt1) < $rateL1 || $aGPNPort4Cnt1(cnt1) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth3\发送tag=$startVid\的数据流，NE3($::gpnIp3)$GPNTestEth4\收到tag=$startVid\的数据包的个数为$aGPNPort4Cnt1(cnt1)，没在$rateL1-$rateR1\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth3\发送tag=$startVid\的数据流，NE3($::gpnIp3)$GPNTestEth4\收到tag=$startVid\的数据包的个数为$aGPNPort4Cnt1(cnt1)，在$rateL1-$rateR1\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt8) < $rateL1 || $aGPNPort4Cnt1(cnt8) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth3\发送tag=[expr $startVid + 1]的数据流，NE3($::gpnIp3)$GPNTestEth4\收到tag=[expr $startVid + 1]的数据包的个数为$aGPNPort4Cnt1(cnt1)，没在$rateL1-$rateR1\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth3\发送tag=[expr $startVid + 1]的数据流，NE3($::gpnIp3)$GPNTestEth4\收到tag=[expr $startVid + 1]的数据包的个数为$aGPNPort4Cnt1(cnt1)，在$rateL1-$rateR1\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt9) < $rateL1 || $aGPNPort4Cnt1(cnt9) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth3\发送tag=[expr $startVid + 2]的数据流，NE3($::gpnIp3)$GPNTestEth4\收到tag=[expr $startVid + 2]的数据包的个数为$aGPNPort4Cnt1(cnt1)，没在$rateL1-$rateR1\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth3\发送tag=[expr $startVid + 2]的数据流，NE3($::gpnIp3)$GPNTestEth4\收到tag=[expr $startVid + 2]的数据包的个数为$aGPNPort4Cnt1(cnt1)，在$rateL1-$rateR1\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt10) < $rateL1 || $aGPNPort4Cnt1(cnt10) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth3\发送tag=[expr $startVid + 3]的数据流，NE3($::gpnIp3)$GPNTestEth4\收到tag=[expr $startVid + 3]的数据包的个数为$aGPNPort4Cnt1(cnt1)，没在$rateL1-$rateR1\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth3\发送tag=[expr $startVid + 3]的数据流，NE3($::gpnIp3)$GPNTestEth4\收到tag=[expr $startVid + 3]的数据包的个数为$aGPNPort4Cnt1(cnt1)，在$rateL1-$rateR1\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt11) < $rateL1 || $aGPNPort4Cnt1(cnt11) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth3\发送tag=[expr $startVid + 4]的数据流，NE3($::gpnIp3)$GPNTestEth4\收到tag=[expr $startVid + 4]的数据包的个数为$aGPNPort4Cnt1(cnt1)，没在$rateL1-$rateR1\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth3\发送tag=[expr $startVid + 4]的数据流，NE3($::gpnIp3)$GPNTestEth4\收到tag=[expr $startVid + 4]的数据包的个数为$aGPNPort4Cnt1(cnt1)，在$rateL1-$rateR1\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt12) < $rateL1 || $aGPNPort4Cnt1(cnt12) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$GPNTestEth3\发送tag=[expr $startVid + 5]的数据流，NE3($::gpnIp3)$GPNTestEth4\收到tag=[expr $startVid + 5]的数据包的个数为$aGPNPort4Cnt1(cnt1)，没在$rateL1-$rateR1\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$GPNTestEth3\发送tag=[expr $startVid + 5]的数据流，NE3($::gpnIp3)$GPNTestEth4\收到tag=[expr $startVid + 5]的数据包的个数为$aGPNPort4Cnt1(cnt1)，在$rateL1-$rateR1\范围内" $fileId
        	}
        	if {$aGPNPort3Cnt1(cnt13) < $rateL1 || $aGPNPort3Cnt1(cnt13) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$GPNTestEth4\发送tag=$startVid\的数据流，NE1($::gpnIp1)$GPNTestEth3\收到tag=$startVid\的数据包的个数为$aGPNPort3Cnt1(cnt13)，没在$rateL1-$rateR1\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$GPNTestEth4\发送tag=$startVid\的数据流，NE1($::gpnIp1)$GPNTestEth3\收到tag=$startVid\的数据包的个数为$aGPNPort3Cnt1(cnt13)，在$rateL1-$rateR1\范围内" $fileId
        	}
        	if {$aGPNPort3Cnt1(cnt14) < $rateL1 || $aGPNPort3Cnt1(cnt14) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$GPNTestEth4\发送tag=[expr $startVid + 1]的数据流，NE1($::gpnIp1)$GPNTestEth3\收到tag=[expr $startVid + 1]的数据包的个数为$aGPNPort3Cnt1(cnt14)，没在$rateL1-$rateR1\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$GPNTestEth4\发送tag=[expr $startVid + 1]的数据流，NE1($::gpnIp1)$GPNTestEth3\收到tag=[expr $startVid + 1]的数据包的个数为$aGPNPort3Cnt1(cnt14)，在$rateL1-$rateR1\范围内" $fileId
        	}
        	if {$aGPNPort3Cnt1(cnt15) < $rateL1 || $aGPNPort3Cnt1(cnt15) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$GPNTestEth4\发送tag=[expr $startVid + 2]的数据流，NE1($::gpnIp1)$GPNTestEth3\收到tag=[expr $startVid + 2]的数据包的个数为$aGPNPort3Cnt1(cnt15)，没在$rateL1-$rateR1\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$GPNTestEth4\发送tag=[expr $startVid + 2]的数据流，NE1($::gpnIp1)$GPNTestEth3\收到tag=[expr $startVid + 2]的数据包的个数为$aGPNPort3Cnt1(cnt15)，在$rateL1-$rateR1\范围内" $fileId
        	}
        	if {$aGPNPort3Cnt1(cnt16) < $rateL1 || $aGPNPort3Cnt1(cnt16) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$GPNTestEth4\发送tag=[expr $startVid + 3]的数据流，NE1($::gpnIp1)$GPNTestEth3\收到tag=[expr $startVid + 3]的数据包的个数为$aGPNPort3Cnt1(cnt16)，没在$rateL1-$rateR1\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$GPNTestEth4\发送tag=[expr $startVid + 3]的数据流，NE1($::gpnIp1)$GPNTestEth3\收到tag=[expr $startVid + 3]的数据包的个数为$aGPNPort3Cnt1(cnt16)，在$rateL1-$rateR1\范围内" $fileId
        	}
        	if {$aGPNPort3Cnt1(cnt17) < $rateL1 || $aGPNPort3Cnt1(cnt17) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$GPNTestEth4\发送tag=[expr $startVid + 4]的数据流，NE1($::gpnIp1)$GPNTestEth3\收到tag=[expr $startVid + 4]的数据包的个数为$aGPNPort3Cnt1(cnt17)，没在$rateL1-$rateR1\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$GPNTestEth4\发送tag=[expr $startVid + 4]的数据流，NE1($::gpnIp1)$GPNTestEth3\收到tag=[expr $startVid + 4]的数据包的个数为$aGPNPort3Cnt1(cnt17)，在$rateL1-$rateR1\范围内" $fileId
        	}
        	if {$aGPNPort3Cnt1(cnt18) < $rateL1 || $aGPNPort3Cnt1(cnt18) > $rateR1} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$GPNTestEth4\发送tag=[expr $startVid + 5]的数据流，NE1($::gpnIp1)$GPNTestEth3\收到tag=[expr $startVid + 5]的数据包的个数为$aGPNPort3Cnt1(cnt18)，没在$rateL1-$rateR1\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$GPNTestEth4\发送tag=[expr $startVid + 5]的数据流，NE1($::gpnIp1)$GPNTestEth3\收到tag=[expr $startVid + 5]的数据包的个数为$aGPNPort3Cnt1(cnt18)，在$rateL1-$rateR1\范围内" $fileId
        	}
        	return $flag
        }
		
        puts $fileId "登录被测设备...\n"
        puts $fileId "\n=====登录被测设备1====\n"
        set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
        puts $fileId "\n=====登录被测设备3====\n"
        set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	
        #用于导出被测设备用到的变量------
        set lSpawn_id "$telnet1 $telnet3"
        set lMatchType "$matchType1 $matchType3"
        set lDutType "$Gpn_type1 $Gpn_type3"
        set lIp "$gpnIp1 $gpnIp3"
        #------用于导出被测设备用到的变量
        puts $fileId "\n**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "创建测试工程...\n"
        set hPtnProject [stc::create project]
        set lPortAttribute "$GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3 \"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\""
        	
        gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
        lassign $hPortList hGPNPort2 hGPNPort3 hGPNPort4	
        
        #创建测试流量
        gwd::STC_Create_VlanModiferStream $fileId dataArr1 $hGPNPort3 hGPNPort3Stream1
        gwd::STC_Create_VlanModiferStream $fileId dataArr2 $hGPNPort3 hGPNPort3Stream2
        gwd::STC_Create_VlanModiferStream $fileId dataArr3 $hGPNPort4 hGPNPort4Stream3
        gwd::STC_Create_VlanModiferStream $fileId dataArr4 $hGPNPort4 hGPNPort4Stream4
	gwd::STC_Create_VlanStream $fileId dataArr5 $hGPNPort3 hGPNPort3Stream5
	gwd::STC_Create_VlanStream $fileId dataArr6 $hGPNPort4 hGPNPort4Stream6
        stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort3Stream1 $hGPNPort3Stream2 $hGPNPort4Stream3 $hGPNPort4Stream4 $hGPNPort3Stream5 $hGPNPort4Stream6" \
		-activate "false"
        	
        ##获取发生器和分析器指针
        gwd::Get_Generator $hGPNPort2 hGPNPort2Gen
        gwd::Get_Analyzer $hGPNPort2 hGPNPort2Ana
        gwd::Get_Generator $hGPNPort3 hGPNPort3Gen
        gwd::Get_Analyzer $hGPNPort3 hGPNPort3Ana
        gwd::Get_Generator $hGPNPort4 hGPNPort4Gen
        gwd::Get_Analyzer $hGPNPort4 hGPNPort4Ana
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
        stc::config [stc::get $hGPNPort3Stream1 -AffiliationStreamBlockLoadProfile-targets] -load 300 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream2 -AffiliationStreamBlockLoadProfile-targets] -load 300 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream3 -AffiliationStreamBlockLoadProfile-targets] -load 300 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream4 -AffiliationStreamBlockLoadProfile-targets] -load 300 -LoadUnit MEGABITS_PER_SECOND
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
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===ELINE容量测试基础配置开始...\n"
	set cfgFlag 0
        ###二三层接口配置参数
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
        ###NE1的配置	
        set portList11 "$GPNTestEth2 $GPNTestEth3 $GPNPort5"
        foreach port $portList11 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
		}
        }
        set rebootSlotList1 [gwd::GWpulic_getWorkCardList $portList11]
        send_log "\n获取设备1业务板卡槽位号$rebootSlotList1\n"
        set mslot1 [gwd::GWpulic_getWorkCardList $managePort1]
        send_log "\n获取设备1管理口所在板卡槽位号$mslot1\n"
        lappend cfgFlag [gwd::GWpublic_GetSysMac $telnet1 $matchType1 $Gpn_type1 $fileId GPNMac1]	
        ###NE3的配置
        set portList33 "$GPNPort6 $GPNTestEth4"
        foreach port $portList33 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "disable" "enable"]
		}
        }
        set rebootSlotList3 [gwd::GWpulic_getWorkCardList $portList33]
        send_log "\n获取设备3业务板卡槽位号$rebootSlotList3\n"
        lappend cfgFlag [gwd::GWpublic_GetSysMac $telnet3 $matchType3 $Gpn_type3 $fileId GPNMac3]
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "ELINE容量测试基础配置失败，测试结束" \
        	"ELINE容量测试基础配置成功，继续后面的测试" "GPN_PTN_005"
        puts $fileId ""
        puts $fileId "===ELINE容量测试基础配置结束..."
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 绑定静态ARP容量测试\n"
        ###绑定静态ARP容量测试
        ##1个LSP仅承载一个PW测试   
        #   <1>1台76设备，创建E-LINE业务，NNI端口以tag方式加入到不同的业务VLAN中
        #   <2>每条业务均绑定静态ARP且绑定MAC均不同,（一个LSP上仅承载一个PW，一个LSP承载在一个VLANIF上）
        #   <3>隧道节点类型为PE，用户侧端口接入模式设为“端口+运营商VLAN”
        #   <4>业务创建成功，系统无异常，从用户侧端口发送匹配业务流量，从NNI端口抓取MPLS报文，查看报文中SMAC、DMAC、LSP标签、PW标签均正确
        #   <5>记录下系统可绑定多少个静态ARP且绑定MAC
        #   <6>导出配置文件，可成功导出，系统无异常；查看导出的配置文件正确，无乱码
        #   <7>shutdown和undo shutdown设备的NNI/UNI端口50次，业务均恢复正常 ，每条业务彼此无干扰
        #   <8>复位设备的NNI/UNI所在板卡50次，业务均恢复正常 ，每条业务彼此无干扰
        #   <9>保存配置，设备正常启动，业务均正常转发
        #   <10>在NE1和NE2设备上均再创建500条业务的OAM和500条业务的QOS，系统无异常，且500条业务的OAM和500条业务的QOS功能均生效
        #   <11>保存NE1和NE2设备配置，重启NE1和NE2设备，设备正常启动，业务正常转发
        #   <12>在该条件下，设备运行24小时，业务正常转发，业务不丢包，系统CPU利用正常，系统可正常管理，系统无异常
        #   <13>清空配置，重启设备,设备正常启动，启动后无任何配置信息
        set flag1_case1 0
        set flag2_case1 0
        set flag3_case1 0
        set flag4_case1 0
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====测试NE1($gpnIp1)和NE3($gpnIp3)设备的静态ARP容量并发流验证   测试开始=====\n"
        regexp -nocase {([0-9|a-f]{2})([0-9|a-f]{2})\.([0-9|a-f]{2})([0-9|a-f]{2})\.([0-9|a-f]{2})([0-9|a-f]{2})} $GPNMac3 match a b c d e f
        set newGPNMac $a:$b:$c:$d:$e:$f
        puts "newGPNMac:$newGPNMac"
        ####NE1设备Arp容量测试
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
					gwd::GWpublic_print "NOK" "$matchType1\配置v$vid，失败" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet1 $matchType1 $Gpn_type1 $fd_log $vid "port" $GPNPort5 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\在v$vid\中添加端口$GPNPort5，失败" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_CfgVlanIp $telnet1 $matchType1 $Gpn_type1 $fd_log $vid "192.$ipTmp.$ip.$ipcnt" 24]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\在v$vid\中添加ip192.$ipTmp.$ip.$ipcnt，失败" $fileId
					break
				}
			}
			
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernet" $GPNPort5 $vid]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\配置接口$GPNPort5.$vid，失败" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWL3port_AddIP $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernet" $GPNPort5 $vid "192.$ipTmp.$ip.$ipcnt" 24]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\配置接口$GPNPort5.$vid\中添加ip192.$ipTmp.$ip.$ipcnt，失败" $fileId
					break
				}
			}
		}
		set createCnt 3 
		while {[PTN_AddInterArp $fd_log $Worklevel $interface01 "192.$ipTmp.$ip.[expr $ipcnt+1]" $GPNMac3 $GPNPort5 $matchType1 $Gpn_type1 $telnet1]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp11 1
				gwd::GWpublic_print "NOK" "$matchType1\在$interface01\中绑定ip:192.$ipTmp.$ip.[expr $ipcnt+1]\且绑定mac:$GPNMac3" $fileId
				break
			}
		}
					
		set createCnt 3 
		while {[gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp$cnt1" $interface01 "192.$ipTmp.$ip.[expr $ipcnt+1]" $in $out "normal" $cnt1]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp12 1
				gwd::GWpublic_print "NOK" "$matchType1\配置隧道lsp$cnt1，失败" $fileId
				break
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp$cnt1" "10.1.1.3"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				gwd::GWpublic_print "NOK" "$matchType1\配置隧道lsp$cnt1\地址为10.1.1.3，失败" $fileId
				break
			}
		}
		
		set createCnt 3 
		while {[gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp$cnt1"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				gwd::GWpublic_print "NOK" "$matchType1\激活隧道lsp$cnt1，失败" $fileId
				break
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fd_log "pw$cnt2" "l2transport" $cnt2 "" "10.1.1.3" $local $remote $cnt1 "nochange" "" 1 0 "0x8100" "0x8100" ""]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp13 1
				gwd::GWpublic_print "NOK" "$matchType1\配置伪线pw$cnt2，失败" $fileId
				break
			}
		}
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet1 $matchType1 $Gpn_type1 $fd_log $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\配置v$cnt3，失败" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet1 $matchType1 $Gpn_type1 $fd_log $cnt3 "port" $GPNTestEth3 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\在v$cnt3\添加端口$GPNTestEth3，失败" $fileId
					break
				}
			}
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernet" $GPNTestEth3 $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\配置接口$GPNTestEth3.$cnt3，失败" $fileId
					break
				}
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fd_log "ac$cnt3" "" $GPNTestEth3 $cnt3 0 "nochange" 1 0 0 "0x8100"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp14 1
				gwd::GWpublic_print "NOK" "$matchType1\配置ac$cnt3，失败" $fileId
				break
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fd_log "ac$cnt3" "pw$cnt2" "eline$cnt2"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				gwd::GWpublic_print "NOK" "$matchType1\配置ac$cnt3\绑定pw$cnt2，失败" $fileId
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
        
        ##NE3设备Arp容量测试
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
					gwd::GWpublic_print "NOK" "$matchType3\配置v$vid，失败" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet3 $matchType3 $Gpn_type3 $fd_log $vid "port" $GPNPort6 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\在v$vid\中添加端口$GPNPort6，失败" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_CfgVlanIp $telnet3 $matchType3 $Gpn_type3 $fd_log $vid "192.$ipTmp.$ip.[expr $ipcnt+1]" 24]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\在v$vid\中添加ip192.$ipTmp.$ip.[expr $ipcnt+1]，失败" $fileId
					break
				}
			}
			
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet3 $matchType3 $Gpn_type3 $fd_log "ethernet" $GPNPort6 $vid]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\配置接口$GPNPort6.$vid，失败" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWL3port_AddIP $telnet3 $matchType3 $Gpn_type3 $fd_log "ethernet" $GPNPort6 $vid "192.$ipTmp.$ip.[expr $ipcnt+1]" 24]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\配置接口$GPNPort6.$vid\中添加ip192.$ipTmp.$ip.[expr $ipcnt+1]，失败" $fileId
					break
				}
			}
			
		}
		
		set createCnt 3 
		while {[PTN_AddInterArp $fd_log $Worklevel $interface03 "192.$ipTmp.$ip.$ipcnt" $GPNMac1 $GPNPort6 $matchType3 $Gpn_type3 $telnet3]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp31 1
				gwd::GWpublic_print "NOK" "$matchType3\在$interface03\中绑定ip:192.$ipTmp.$ip.$ipcnt\且绑定mac:$GPNMac1" $fileId
				break
			}
		}
					
		set createCnt 3 
		while {[gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fd_log "lsp$cnt1" $interface03 "192.$ipTmp.$ip.$ipcnt" $out $in "normal" $cnt1]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp32 1
				gwd::GWpublic_print "NOK" "$matchType3\配置隧道lsp$cnt1，失败" $fileId
				break
			}
		}
		
		set createCnt 3 
		while {[gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fd_log "lsp$cnt1" "10.1.1.1"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				gwd::GWpublic_print "NOK" "$matchType3\配置隧道lsp$cnt1\地址为10.1.1.1，失败" $fileId
				break
			}
		}
		
		set createCnt 3 
		while {[gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fd_log "lsp$cnt1"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				gwd::GWpublic_print "NOK" "$matchType3\激活隧道lsp$cnt1，失败" $fileId
				break
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fd_log "pw$cnt2" "l2transport" $cnt2 "" "10.1.1.1" $remote $local $cnt1 "nochange" "" 1 0 "0x8100" "0x8100" ""]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp33 1
				gwd::GWpublic_print "NOK" "$matchType3\配置伪线pw$cnt2，失败" $fileId
				break
			}
		}
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet3 $matchType3 $Gpn_type3 $fd_log $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\配置v$cnt3，失败" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet3 $matchType3 $Gpn_type3 $fd_log $cnt3 "port" $GPNTestEth4 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\在v$cnt3\添加端口$GPNTestEth4，失败" $fileId
					break
				}
			}
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet3 $matchType3 $Gpn_type3 $fd_log "ethernet" $GPNTestEth4 $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\配置接口$GPNTestEth4.$cnt3，失败" $fileId
					break
				}
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fd_log "ac$cnt3" "" $GPNTestEth4 $cnt3 0 "nochange" 1 0 0 "0x8100"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp34 1
				gwd::GWpublic_print "NOK" "$matchType3\配置ac$cnt3，失败" $fileId
				break
			}
		}
		set createCnt 3 
		while {[gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fd_log "ac$cnt3" "pw$cnt2" "eline$cnt2"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				gwd::GWpublic_print "NOK" "$matchType3\配置ac$cnt3\绑定pw$cnt2，失败" $fileId
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
        puts $fileId "NE1($gpnIp1)绑定静态arp容量为：$ARPnum1"
        puts $fileId "NE3($gpnIp3)绑定静态arp容量为：$ARPnum3"
        if {$flag1_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA1（结论）测试NE1($gpnIp1)和NE3($gpnIp3)设备的静态ARP容量并发流验证" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA1（结论）测试NE1($gpnIp1)和NE3($gpnIp3)设备的静态ARP容量并发流验证" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====测试NE1($gpnIp1)和NE3($gpnIp3)设备的静态ARP容量并发流验证  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复shut/undoshut UNI和NNI端口后检查业务是否能恢复   测试开始=====\n"
        ###反复undo shutdown/shutdown端口
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
        		gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown设备的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "反复shutdown/undo shutdown设备的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
        	}
        }
	#端口shutdown undoshut 大概率会引起telnet的中断，所以重新登录，并且在重新登录前杀死前一个telnet的
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
        	gwd::GWpublic_print "NOK" "FA2（结论）反复shut/undoshut UNI和NNI端口后检查业务恢复的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA2（结论）反复shut/undoshut UNI和NNI端口后检查业务恢复的测试" $fileId
        }
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复shut/undoshut UNI和NNI端口后检查业务是否能恢复  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复重启业务端口所在板卡后检查业务是否能恢复   测试开始=====\n"
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
        			puts $fileId "$Gpn_type1\的这个板卡不支持重启操作"
        		}
        	}
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
        	send_log "\n resource3:$resource3"
        	send_log "\n resource4:$resource4"
        	if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
                	set flag3_case1	1
                	gwd::GWpublic_print "NOK" "重启板卡$slot\之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "重启板卡$slot\之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
        	}
        }
	#端口shutdown undoshut 大概率会引起telnet的中断，所以重新登录，并且在重新登录前杀死前一个telnet的
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
        	gwd::GWpublic_print "NOK" "FA3（结论）反复重启业务端口所在板卡后检查业务恢复的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA3（结论）反复重启业务端口所在板卡后检查业务恢复的测试" $fileId
        }	
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复重启业务端口所在板卡后检查业务是否能恢复  测试结束=====\n"
        gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====重启被测设备NE1($gpnIp1)后检查业务是否能恢复  测试开始=====\n"
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
	#端口shutdown undoshut 大概率会引起telnet的中断，所以重新登录，并且在重新登录前杀死前一个telnet的
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
                gwd::GWpublic_print "NOK" "FA4（结论）重启被测设备NE1($gpnIp1)后检查业务恢复的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA4（结论）重启被测设备NE1($gpnIp1)后检查业务恢复的测试" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====重启被测设备NE1($gpnIp1)后检查业务是否能恢复  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
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
        puts $fileId "Test Case 1 $porttype3\端口ELine业务AC动作测试结束\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 1个LSP承载多个PW的测试\n"
        ###1个LSP承载多个PW测试  
        #   <1>两台76，NE1--NE2，在NE1端口1与NE2端口2间创建多条ELINE业务（均承载在一个LSP上）
        #   <2>NE1和NE2隧道节点类型为PE
        #   <3>每条业务都绑定静态ARP 映射，创建完毕，发送业务流量查看每条业务均正常转发，系统无异常
        #   <4>记录下系统1个LSP上可承载多少个PW(系统目前一条LSP可承载4092个PW)
        #   <5>两台设备保存配置，导出配置文件，可成功导出，系统无异常；查看导出的配置文件正确，无乱码
        #   <6>使能每条业务LSP/PW/AC性能统计，系统无异常，性能统计功能生效，统计值正确
        #   <7>shutdown和undo shutdownNE1设备的NNI/UNI端口50次，业务均恢复正常 ，每条业务彼此无干扰
        #   <8>复位设备的NNI/UNI所在板卡50次，业务均恢复正常 ，每条业务彼此无干扰
        #   <9>进行NE1设备的SW/NMS倒换50次（软倒换），业务均正常恢复，每条业务彼此无干扰，查看标签转发表项正确
        #   <10>保存NE1和NE2设备配置，重启NE1和NE2设备（软复位）50次，每次操作后系统正常启动，业务恢复正常且彼此无干扰，标签转发表项正确
        #   <11>清空NE1和NE2设备配置，重启NE1和NE2设备，待设备起来后查看配置信息空
        #   <12>将各自导出的配置文件导入，重启设备，待设备起来后查看配置信息无丢失均正确，发流验证业务均正常转发
        #   <13>清空NE1和NE2设备配置，重启NE1和NE2设备
	puts $fileId "======================================================================================\n"	
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====测试一条lsp绑定PW的容量  测试开始=====\n"
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0
	set flag5_case2 0
	set flag6_case2 0
	set flag7_case2 0
	set flag8_case2 0
	after 900000    ;#等待10分钟，case1最后运行的保存并上传配置设备内部需要的时间长，有时会对下面设备文件的下载产生影响（下载完成后保存备份才完成）
	set createCnt 3
	while {[gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fileId 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
			"NE1.txt" ""]} {
		incr createCnt -1
		if {$createCnt == 0} {
			gwd::GWpublic_print "NOK" "$matchType1\连续3次下载NE1.txt文件都失败或下载中出现了设备的自动保存" $fileId
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
			gwd::GWpublic_print "NOK" "$matchType3\连续3次下载NE3.txt文件都失败或下载中出现了设备的自动保存" $fileId
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
				gwd::GWpublic_print "NOK" "$matchType1\配置伪线pw$cnt2，失败" $fileId
				break
			}
		}
		
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet1 $matchType1 $Gpn_type1 $fd_log $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\配置v$cnt3，失败" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet1 $matchType1 $Gpn_type1 $fd_log $cnt3 "port" $GPNTestEth3 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\在v$cnt3\中添加端口$GPNTestEth3，失败" $fileId
					break
				}
			}
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernet" $GPNTestEth3 $cnt3]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType1\配置接口$GPNTestEth3.$cnt3，失败" $fileId
					break
				}
			}
		}
		
		set createCnt 3 
		while {[gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fd_log "ac$cnt3" "" $GPNTestEth3 $cnt3 0 "nochange" 1 0 0 "0x8100"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp2 1
				gwd::GWpublic_print "NOK" "$matchType1\配置ac$cnt3，失败" $fileId
				break
			}
		} 
				
		set createCnt 3 
		while {[gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fd_log "ac$cnt3" "pw$cnt2" "eline$cnt3"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp3 1
				gwd::GWpublic_print "NOK" "$matchType1\配置ac$cnt3\绑定pw$cnt2，失败" $fileId
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
        
        ###配置设备NE3
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
				gwd::GWpublic_print "NOK" "$matchType3\配置伪线pw$cnt4，失败" $fileId
				break
			}
		}
		if {[string match "L2" $Worklevel]} {
			set createCnt 3 
			while {[gwd::GWpublic_Addvlan $telnet3 $matchType3 $Gpn_type3 $fd_log $cnt5]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\配置v$cnt5，失败" $fileId
					break
				}
			}
			set createCnt 3 
			while {[gwd::GWpublic_Addporttovlan $telnet3 $matchType3 $Gpn_type3 $fd_log $cnt5 "port" $GPNTestEth4 "tagged"]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\在v$cnt5\添加端口$GPNTestEth4，失败" $fileId
					break
				}
			}
		} else {
			set createCnt 3 
			while {[gwd::GWL3Inter_AddL3 $telnet3 $matchType3 $Gpn_type3 $fd_log "ethernet" $GPNTestEth4 $cnt5]} {
				incr createCnt -1
				if {$createCnt == 0} {
					gwd::GWpublic_print "NOK" "$matchType3\配置接口$GPNTestEth4.$cnt5，失败" $fileId
					break
				}
			}
		}
				
		set createCnt 3 
		while {[gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fd_log "ac$cnt5" "" $GPNTestEth4 $cnt5 0 "nochange" 1 0 0 "0x8100"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp5 1
				gwd::GWpublic_print "NOK" "$matchType3\配置ac$cnt5，失败" $fileId
				break
			}
		} 
		
		set createCnt 3 
		while {[gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fd_log "ac$cnt5" "pw$cnt4" "eline$cnt5"]} {
			incr createCnt -1
			if {$createCnt == 0} {
				set retTmp6 1
				gwd::GWpublic_print "NOK" "$matchType3\配置ac$cnt5\绑定pw$cnt4，失败" $fileId
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
	#上传Dev1和dev3的配置，为后面配置恢复测试做准备------
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
	#------上传Dev1和dev3的配置，为后面配置恢复测试做准备
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
	set startVid [expr $minPwCnt + 10 - 1 -5];#测试最后6个vlan的数据转发
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
        puts $fileId "NE1($gpnIp1)一条lsp绑定PW的容量为：$PWnum1"
        puts $fileId "NE3($gpnIp3)一条lsp绑定PW的容量为：$PWnum3"
        if {$flag1_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA5（结论）测试NE1($gpnIp1)和NE3($gpnIp3))一条lsp绑定PW的容量并发流验证" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA5（结论）测试NE1($gpnIp1)和NE3($gpnIp3))一条lsp绑定PW的容量并发流验证" $fileId
        }
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====测试一条lsp绑定PW的容量  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复shut/undoshut UNI和NNI端口后检查业务是否能恢复  测试开始=====\n"
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
        		gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
        	}
        }
	#端口shutdown undoshut 大概率会引起telnet的中断，所以重新登录，并且在重新登录前杀死前一个telnet的
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
        	gwd::GWpublic_print "NOK" "FA6（结论）反复shut/undoshut UNI和NNI端口后检查业务恢复的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA6（结论）反复shut/undoshut UNI和NNI端口后检查业务恢复的测试" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复shut/undoshut UNI和NNI端口后检查业务是否能恢复  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复重启业务端口所在板卡后检查业务是否能恢复  测试开始=====\n"
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
                		puts $fileId "$Gpn_type1\的$slot\这个板卡不支持重启操作"
                	}
        	}
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
        	send_log "\n resource3:$resource3"
        	send_log "\n resource4:$resource4"
        	if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
        		set flag3_case2	1
        		gwd::GWpublic_print "NOK" "重启板卡$slot\之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "重启板卡$slot\之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
        	}
        }
	#端口shutdown undoshut 大概率会引起telnet的中断，所以重新登录，并且在重新登录前杀死前一个telnet的
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
        	gwd::GWpublic_print "NOK" "FA7（结论）反复重启业务端口所在板卡后检查业务恢复的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA7（结论）反复重启业务端口所在板卡后检查业务恢复的测试" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复重启业务端口所在板卡后检查业务是否能恢复  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复重启被测设备NE1($gpnIp1)后检查业务是否能恢复  测试开始=====\n"
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
	#端口shutdown undoshut 大概率会引起telnet的中断，所以重新登录，并且在重新登录前杀死前一个telnet的
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
        	gwd::GWpublic_print "NOK" "FA8（结论）重启被测设备NE1($gpnIp1)后检查业务恢复的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA8（结论）重启被测设备NE1($gpnIp1)后检查业务恢复的测试" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复重启被测设备NE1($gpnIp1)后检查业务是否能恢复  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====设备NE3($gpnIp3)反复进行NMS主备倒换后测试业务恢复和系统内存  测试开始=====\n"
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
        			gwd::GWpublic_print "NOK" "VC=2 的pwOutLabel应为501实为[dict get $result 2 pwOutLabel] \
        					lspOutLabel应为+2500实为[dict get $result 2 lspOutLabel]，NE3($gpnIp3)第$j\次进行NMS主备倒换转发表项异常" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "VC=2 的pwOutLabel应为501实为[dict get $result 2 pwOutLabel] \
        					lspOutLabel应为+2500实为[dict get $result 2 lspOutLabel]，NE3($gpnIp3)第$j\次进行NMS主备倒换转发表项正常" $fileId
        		}
        	} else {
        		puts $fileId "$matchType3\不支持NMS主备倒换或者只有一块NMS，测试跳过"
        	}
        }
        gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource6
        send_log "\n resource5:$resource5"
        send_log "\n resource6:$resource6"
        if {$resource6 > [expr $resource5 + $resource5 * $errRate]} {
        	set flag5_case2	1
        	gwd::GWpublic_print "NOK" "设备NE3($gpnIp3)反复进行NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "设备NE3($gpnIp3)反复进行NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
        }
	#端口shutdown undoshut 大概率会引起telnet的中断，所以重新登录，并且在重新登录前杀死前一个telnet的
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
        	gwd::GWpublic_print "NOK" "FA9（结论）设备NE3($gpnIp3)反复进行NMS主备倒换后测试业务恢复和系统内存" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA9（结论）设备NE3($gpnIp3)反复进行NMS主备倒换后测试业务恢复和系统内存" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====设备NE3($gpnIp3)反复进行NMS主备倒换后测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====设备NE3($gpnIp3)反复进行SW主备倒换后测试业务恢复和系统内存  测试开始=====\n"
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
        			gwd::GWpublic_print "NOK" "VC=2 的pwOutLabel应为501实为[dict get $result 2 pwOutLabel] \
        					lspOutLabel应为+2500实为[dict get $result 2 lspOutLabel]，NE3($gpnIp3)第$j\次进行SW主备倒换转发表项异常" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "VC=2 的pwOutLabel应为501实为[dict get $result 2 pwOutLabel] \
        					lspOutLabel应为+2500实为[dict get $result 2 lspOutLabel]，NE3($gpnIp3)第$j\次进行SW主备倒换转发表项正常" $fileId
        		}
        	} else {
        		puts $fileId "$Gpn_type3\不支持SW主备倒换或者只有一块SW，测试跳过"
        	}
        }
        gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource8
        send_log "\n resource7:$resource7"
        send_log "\n resource8:$resource8"
        if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
        	set flag6_case2	1
        	gwd::GWpublic_print "NOK" "设备NE3($gpnIp3)反复进行NMS主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "设备NE3($gpnIp3)反复进行NMS主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
        }
	#端口shutdown undoshut 大概率会引起telnet的中断，所以重新登录，并且在重新登录前杀死前一个telnet的
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
        	gwd::GWpublic_print "NOK" "FB1（结论）设备NE3($gpnIp3)反复进行SW主备倒换后检查业务恢复的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB1（结论）设备NE3($gpnIp3)反复进行SW主备倒换后检查业务恢复的测试" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====设备NE3($gpnIp3)反复进行SW主备倒换后测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复重启被测设备NE3($gpnIp3)后测试业务恢复  测试开始=====\n"
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
        	gwd::GWpublic_print "NOK" "FB2（结论）反复重启被测设备NE3($gpnIp3)后测试业务恢复" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB2（结论）反复重启被测设备NE3($gpnIp3)后测试业务恢复" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复重启被测设备NE3($gpnIp3)后测试业务恢复  测试结束=====\n"
        gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1) NE3($gpnIp3)删除配置、保存配置、下载配置后检查业务是否能恢复  测试开始=====\n"
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
			gwd::GWpublic_print "NOK" "需要下载的配置文件GPN_PTN_005_case2_dev1.txt在前面的测试中上传失败，此项测试无法进行" $fileId
		}
		if {$downFlag3 == 1} {
			gwd::GWpublic_print "NOK" "需要下载的配置文件GPN_PTN_005_case2_dev3.txt在前面的测试中上传失败，此项测试无法进行" $fileId
		}
	}

        puts $fileId ""
        if {$flag8_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FB3（结论）NE1($gpnIp1) NE3($gpnIp3)删除配置、保存配置、下载配置后检查业务恢复" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB3（结论）NE1($gpnIp1) NE3($gpnIp3)删除配置、保存配置、下载配置后检查业务恢复" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1) NE3($gpnIp3)删除配置、保存配置、下载配置后检查业务是否能恢复  测试结束=====\n"
        gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_005_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_005" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        if {$flagCase2 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 2测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 2测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 2 测试一条lsp绑定PW的容量  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===恢复初始化配置...\n"
	set flagDel 0
	lappend flagDel [gwd::GWmanage_ftpDownload $telnet3 $matchType3 $Gpn_type3 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] \
		[dict get $ftp passWord] "NE3.txt" ""]
	lappend flagDel [gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId]
	lappend flagDel [gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] \
        	[dict get $ftp passWord] "NE1.txt" ""]
	lappend flagDel [gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId]
        after $rebootTime
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "测试结束后配置恢复" "测试结束后配置恢复" "GPN_PTN_005"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "测试过程中所有配置文件都上传成功" "GPN_PTN_005"
	
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_005测试目的：E-LINE业务容量测试\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1==1 || $flagCase2==1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_005测试结果" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2测试结果" $fileId
	puts $fileId ""
	puts $fileId ""
        gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "测试NE1($gpnIp1)和NE3($gpnIp3)设备的静态ARP容量并发流验证" $fileId
        gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "反复shut/undoshut UNI和NNI端口后检查业务恢复的测试" $fileId
        gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "反复重启业务端口所在板卡后检查业务恢复的测试" $fileId
        gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "重启被测设备NE1($gpnIp1)后检查业务恢复的测试" $fileId
        gwd::GWpublic_print "== FA5 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "测试NE1($gpnIp1)和NE3($gpnIp3))一条lsp绑定PW的容量并发流验证" $fileId
        gwd::GWpublic_print "== FA6 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "反复shut/undoshut UNI和NNI端口后检查业务恢复的测试" $fileId
        gwd::GWpublic_print "== FA7 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "反复重启业务端口所在板卡后检查业务恢复的测试" $fileId
        gwd::GWpublic_print "== FA8 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "重启被测设备NE1($gpnIp1)后检查业务恢复的测试" $fileId
        gwd::GWpublic_print "== FA9 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "设备NE3($gpnIp3)反复进行NMS主备倒换后检查业务恢复的测试" $fileId
        gwd::GWpublic_print "== FB1 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "设备NE3($gpnIp3)反复进行SW主备倒换后检查业务恢复的测试" $fileId
        gwd::GWpublic_print "== FB2 == [expr {($flag7_case2 == 1) ? "NOK" : "OK"}]" "重启被测设备NE3($gpnIp3)后检查业务恢复的测试" $fileId
        gwd::GWpublic_print "== FB3 == [expr {($flag8_case2 == 1) ? "NOK" : "OK"}]" "重启被测设备NE3($gpnIp3)后检查业务恢复的测试" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "（结论）测试结束后配置恢复" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "（结论）测试过程中配置文件的上传" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "运行异常：错误为$err" "" "GPN_PTN_005"
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
