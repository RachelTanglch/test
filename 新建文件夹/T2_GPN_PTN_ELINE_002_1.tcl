#!/bin/sh
# T2_GPN_PTN_ELINE_002.tcl \
exec tclsh "$0" ${1+"$@"}
#测试名称：ptn002_1
#-----------------------------------------------------------------------------------------------------------------------------------
#测试目的：E-LINE的功能
#1-E-LINE业务功能验证  
#2-LSP标签交换功能验证
#4-MS-PW功能验证	                     	           
#---------------------------------------------------------------------------------------------------------------------------------
#脚本运行条件：
#1、按照测试拓扑搭建测试环境:将GPN的管理端口（U/D）和PC的网口与Internet相连，GPN的2个上联口
#   与STC端口（ 9/9）（9/10）
#2、在GPN上清空所有 配置，建立管理vlan vid=4000，在该vlan上设置管理IP，并untagged方式添加管理端口（U/D）
#-----------------------------------------------------------------------------------------------------------------------------------
#测试过程：
##E-LINE业务功能验证  
#1、搭建Test Case 1测试环境
#   <1>三台设备NNI端口(GE端口)以tag方式加入到VLANIF 100中
#   <2>用户侧（GE端口）接入模式为端口模式
#   <3>创建LSP1
#      配置NE1（7600）的LSP1入标签100，出标签200；PW1本地标签1000，远程标签2000
#      配置NE3（7600）的LSP1入标签300，出标签400；PW1本地标签2000，远程标签1000  
#      配置NE2（7600S）的SW入标签200，出标签300
#   <4>NE1和NE3用户测配置undo vlan check
#   <5>创建PW1/AC1
#   <6>向NE1的端口1发送untag/tag业务流量，观察NE3的端口3的接收结果
#   预期结果：NE3的端口3可正常接收untag/tag业务流量；双向发送untag/tag业务均正常
#   <7>使能NE1的LSP1/PW1/AC1性能统计，系统无异常，性能统计功能生效，统计值正确
#   <8>使能NE1设备PW1的控制字，并镜像NE1的NNI端口egress方向报文
#   预期结果：镜像报文为带VLAN TAG标签并打上两层mpls标签报文，外层lsp标签200，内层pw标签2000
#             LSP字段中的TTL值为255，PW字段中的TTL值为255，PW字段中含有4字节控制字
#   <9>undo shutdown和shutdown NE1设备的NNI/UNI端口50次，每次操作后业务恢复正常，系统无异常 
#   <10>重启NE1设备的NNI/UNI端口所在板卡50次，每次操作后业务恢复正常，系统无异常 
#   <11>NE1设备进行SW/NMS倒换50次，每次操作后业务恢复正常，系统无异常 ，查看标签转发表项正确，三台设备管理正常
#   <12>保存重启NE1设备的50次，每次操作后系统正常启动，业务恢复正常，系统无异常，查看标签转发表项正确，三台设备管理正常 
#2、搭建Test Case 2测试环境
#   <1>删除NE1和NE3设备的专线业务（AC），删除成功，业务中断，系统无异常
#   <2>重新创建NE1和NE3设备的AC节点专线业务（AC),承载伪线（PW）不做更改，均仅将接入模式设为“端口+运营商VLAN”
#   <3>用户侧加入指定的vlan中
#   <4>在NE1和NE3上均创建所需的VLAN（vlan 1000），并加入端口
#   <5>向NE1的端口1发送tag1000、tag2000业务流量，观察NE3的端口3的接收结果
#   预期结果：再次创建接入模式为“端口+运营商VLAN”的专线业务，成功创建，系统无异常
#             NE3的端口3只可接收tag1000业务流量；双向发流业务正常
#   <6>删除之前接入模式设为“端口+运营商VLAN”的AC
#   <7>在NE1和NE3设备上创建AC接入模式设为“端口+运营商VLAN+客户VLAN”
#      运营商VLAN为 vlan 3000，客户VLAN为vlan 300
#   <8>在NE1和NE3设备上再创建一条新的E-LINE业务(与之前的业务共用同一条LSP)，且AC接入模式设为“端口+运营商VLAN+客户VLAN”
#      运营商VLAN为 vlan 1000，客户VLAN为vlan 100
#   预期结果：业务成功创建，系统无异常，对之前的业务无任何干扰
#   <9>向NE1的UNI端口发送untag、tag100、tag1000、 双层tag（外1000 内100）业务流量，观察NE3的UNI端口的接收结果
#   预期结果：NE3的UNI端口只可接收到双层tag（外1000 内100）业务流量，对之前的业务无干扰，双向发流业务正常
#   <10>undo shutdown和shutdown NE3设备的NNI/UNI端口50次，每次操作后业务恢复正常，系统无异常 
#   <11>重启NE3设备的NNI/UNI端口所在板卡50次，每次操作后业务恢复正常，系统无异常 
#   <12>NE3设备进行SW/NMS倒换50次，每次操作后业务恢复正常，系统无异常 ，查看标签转发表项正确，三台设备管理正常
#   <13>保存重启NE3设备的50次，每次操作后系统正常启动，业务恢复正常，系统无异常，查看标签转发表项正确，三台设备管理正常 
#3、搭建Test Case 3测试环境
#   <1>将NNI端口更改为10GE端口，其他条件不变，重复以上步骤
#   <2>将UNI端口更改为FE/10GE端口，NNI端口更改为GE/10GE端口，其他条件不变，重复以上步骤
#   <3>用FE端口配置ELINE业务时，需开启该板卡的MPLS业务模式（mpls enable <slot>）
##LSP标签交换功能验证
#4、搭建Test Case 4测试环境
#   <1>重新创建一条NE1到NE3的E-LINE业务，NNI端口(GE端口)和之前所创建业务的NNI端口相同（即NNI端口复用）
#      只是以tag方式加入到其他VLANIF 200中，用户侧（GE端口）接入模式为端口模式，故需新创建LSP、PW、AC
#   <2>配置NE1的LSP10入标签16，出标签17；PW10本地标签20，远程标签21
#      配置NE3的LSP10入标签18，出标签19；PW10本地标签21，远程标签20 
#      NE2的SW配置：入标签17，出标签18 （mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000> <1-65535> [normal|ring]）
#      预期结果：业务配置成功，对之前的E-LINE业务无影响，系统无异常
#   <3>NE1和NE3用户测配置undo vlan check
#   <4>创建PW1/AC1
#   <5>向NE1的端口1发送untag/tag业务流量，观察NE3的端口3的接收结果
#   预期结果：NE3的端口3可正常接收untag/tag业务流量；双向发送untag/tag业务均正常，对之前的业务无干扰
#   <6>镜像NE1的NNI端口egress方向报文
#   预期结果：镜像报文为带VLAN TAG标签并打上两层mpls标签报文，外层lsp标签17，内层pw标签21
#             LSP字段中的TTL值为255，PW字段中的TTL值为255，PW字段中含有4字节控制字
#   <7>镜像NE2的NNI端口egress方向，同样可以抓到两层标签，外层标签交换为18，内层标签21，LSP字段中的TTL值减1，PW字段中的TTL值仍为255
#   <8>undo shutdown和shutdown NE1和NE2设备的NNI/UNI端口50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
#   <9>重启NE1和NE2设备的NNI/UNI端口所在板卡50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
#   <10>NE1和NE2设备进行SW/NMS倒换50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 ，查看标签转发表项正确
#   <11>保存重启NE1和NE2设备的50次，每次操作后系统正常启动，每条业务恢复正常且彼此无干扰，系统无异常，查看标签转发表项正确
##MS-PW功能验证
#5、搭建Test Case 5测试环境
#   <1>NNI端口tag方式加入VLAN业务接口；在NE1和NE3之间创建一条E-LINEL业务，在NE2上配置MS-PW
#   <2>向NE1设备的AC端口发送业务流
#   预期结果:NE3设备AC端口应接收对应业务流,双向发流业务正常转发
#   <3>NE1和NE3用户测配置undo vlan check
#   <4>镜像NE2设备的NNI端口egress方向和ingress方向，验证MS-PW标签交换功能
#   预期结果:NE2节点能够对NE1发出的报文进行LSP和PW的标签的替换，报文各个字段均正确
#           比较NE2设备的NNI端口egress方向和ingress方向报文，出方向报文中LSP字段中的TTL值减1，PW字段也中的TTL值减1
#   <5>在NE2设备配置LSP/PW QOS，系统无异常，功能并生效
#   <6>在NE2设备使能LSP/PW性能统计，系统无异常，性能统计功能并生效，统计值正确
#   <7>undo shutdown和shutdown NE2设备的NNI端口50次，系统无异常，业务可恢复 
#   <8>重启NE1和NE2设备的NNI端口所在板卡50次，系统无异常，业务可恢复
#   <9>NE2设备进行SW/NMS倒换50次，系统无异常，业务可恢复，查看标签转发表项正确
#   <10>保存重启NE2设备50次，设备正常启动，配置不丢失，业务正常转发
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
  	close stdout
  	file mkdir "log"
  	set fd_log [open "log\\GPN_PTN_002_1_LOG.txt" a]
  	set stdout $fd_log
  	chan configure $stdout -blocking 0 -buffering none;#非阻塞模式 按行flush
	log_file log\\GPN_PTN_002_1_LOG.txt
	
  	file mkdir "report"
  	set fileId [open "report\\GPN_PTN_002_1_REPORT.txt" a+]
	chan configure $fileId -blocking 0 -buffering none;#非阻塞模式 按行flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_002_1_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_002_1_DEBUG.txt 0
	chan configure $fd_debug -blocking 0 -buffering none;#非阻塞模式 按行flush
  	
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
	###设置定制信息参数
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        
        #设置发生器参数
        set GenCfg {-SchedulingMode RATE_BASED}
        
        #设置过滤分析器参数
	###smac和vid
        set anaFliFrameCfg1 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><vlans name="anon_13224"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        ###smac
        set anaFliFrameCfg0 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        ###mpls报文中的两层标签
        set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
        ###mpls报文中的带的vid和Experimental Bits (bits)/Bottom of stack (bit)
        set anaFliFrameCfg3 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4647"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><exp override="true"  filterMinValue="0" filterMaxValue="111">111</exp></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><sBit override="true"  filterMinValue="0" filterMaxValue="1">1</sBit></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
        ###匹配两层vid
        set anaFliFrameCfg4 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5580"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	
	set rateL 95000000;#收发数据流取值最小值范围
	set rateR 105000000;#收发数据流取值最大值范围
	set rateL1 100000000 
	set rateR1 125000000 

	set flagCase1 0   ;#Test case 1标志位 
	set flagCase2 0   ;#Test case 2标志位
	set flagCase3 0   ;#Test case 3标志位 
	set flagCase4 0   ;#Test case 4标志位
	set flagCase5 0   ;#Test case 5标志位 
	
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
		gwd::GWpublic_print "  " "抓包文件为$id-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$id-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
		parray aGPNPort3Cnt1
		parray aGPNPort3Cnt2
		parray aGPNPort4Cnt1
		parray aGPNPort4Cnt2
		if {$aGPNPort4Cnt1(cnt1) < $rateL || $aGPNPort4Cnt1(cnt1) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($gpnIp1)$GPNTestEth3\发送untag数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率为$aGPNPort4Cnt1(cnt1)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($gpnIp1)$GPNTestEth3\发送untag数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率为$aGPNPort4Cnt1(cnt1)，在$rateL-$rateR\范围内" $fileId
		}
		if {$aGPNPort4Cnt1(cnt2)< $rateL || $aGPNPort4Cnt1(cnt2)> $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($gpnIp1)$GPNTestEth3\发送tag=100数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率为$aGPNPort4Cnt1(cnt2)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($gpnIp1)$GPNTestEth3\发送tag=100数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率为$aGPNPort4Cnt1(cnt2)，在$rateL-$rateR\范围内" $fileId
		}
		if {$aGPNPort4Cnt1(cnt15) < $rateL || $aGPNPort4Cnt1(cnt15) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($gpnIp1)$GPNTestEth3\发送tag=100的mpls数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率为$aGPNPort4Cnt1(cnt15)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($gpnIp1)$GPNTestEth3\发送tag=100的mpls数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率为$aGPNPort4Cnt1(cnt15)，在$rateL-$rateR\范围内" $fileId
		}
		return $flag
	}
	########################################################################################################
	#函数功能：发送数据流，得到测试结果
	#输入参数: capFlag：=1抓包   =0不抓包
	#	lGenPort：发送数据流的端口Gen handle列表
	#	  lAnaPort：接收数据流的端口ana handle列表
	#         lPort：抓包端口列表
	#         lCapPara：抓包端口相关参数列表cap capAna ip（端口所在设备的ip）
	#	  vlanCnt：分析器设置的vlan层数 0：不带vlan 1：单层vlan   =2：双层vlan
	#	  capFlag：是否抓包，在全局变量cap_enable=1的的情况下capFlag参数生效  =1抓包    =0不抓包
	#输出参数： aGPNCnt1 aGPNCnt2 aGPNCnt3：与lAnaPort端口相对应	  
	#返回值： 无
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
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
		if {$aGPNPort4Cnt40(cnt10) ==0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW1:vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送外层tag=1000内层tag=100\
				的数据流，NE3($gpnIp3) $GPNTestEth4\收到数据包的速率为0" $fileId
		} else {
                	if {$aGPNPort4Cnt4(cnt10) > $rateR || $aGPNPort4Cnt4(cnt10) < $rateL} {
                		set flag 1
                		gwd::GWpublic_print "NOK" "$printWord PW1:vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送外层tag=1000内层tag=100\
                			的数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=1000内层tag=100的数据包速率为$aGPNPort4Cnt4(cnt10)，没在$rateL-$rateR\范围内" $fileId
                	} else {
                		gwd::GWpublic_print "OK" "$printWord PW1:vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送外层tag=1000内层tag=100\
                			的数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=1000内层tag=100的数据包速率为$aGPNPort4Cnt4(cnt10)，在$rateL-$rateR\范围内" $fileId
                	}
		}
		if {$aGPNPort4Cnt40(cnt9) == 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2:不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送外层tag=3000内层tag=300\
				的数据流，NE3($gpnIp3) $GPNTestEth4\收到数据包的速率为0" $fileId
		} else {
                	if {$aGPNPort4Cnt4(cnt9) > $rateR || $aGPNPort4Cnt4(cnt9) < $rateL} {
                		set flag 1
                		gwd::GWpublic_print "NOK" "$printWord PW2:不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送外层tag=3000内层tag=300\
                			的数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=3000内层tag=300的数据包速率为$aGPNPort4Cnt4(cnt9)，没在$rateL-$rateR\范围内" $fileId
                	} else {
                		gwd::GWpublic_print "OK" "$printWord PW2:不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送外层tag=3000内层tag=300\
                			的数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=3000内层tag=300的数据包速率为$aGPNPort4Cnt4(cnt9)，在$rateL-$rateR\范围内" $fileId
                	}
		}
		if {$aGPNPort3Cnt40(cnt10) == 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW1:vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送外层tag=1000内层tag=100\
				的数据流，NE1($gpnIp1) $GPNTestEth3\收到数据包的速率为0" $fileId
		} else {
                	if {$aGPNPort3Cnt4(cnt10) > $rateR || $aGPNPort3Cnt4(cnt10) < $rateL} {
                		set flag 1
                		gwd::GWpublic_print "NOK" "$printWord PW1:vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送外层tag=1000内层tag=100\
                			的数据流，NE1($gpnIp1) $GPNTestEth3\收到外层tag=1000内层tag=100的数据包速率为$aGPNPort3Cnt4(cnt10)，没在$rateL-$rateR\范围内" $fileId
                	} else {
                		gwd::GWpublic_print "OK" "$printWord PW1:vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送外层tag=1000内层tag=100\
                			的数据流，NE1($gpnIp1) $GPNTestEth3\收到外层tag=1000内层tag=100的数据包速率为$aGPNPort3Cnt4(cnt10)，在$rateL-$rateR\范围内" $fileId
                	}
		}
		if {$aGPNPort3Cnt40(cnt9) == 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2:不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送外层tag=3000内层tag=300\
				的数据流，NE1($gpnIp1) $GPNTestEth3\收到数据包的速率为0" $fileId
		} else {
                	if {$aGPNPort3Cnt4(cnt9) > $rateR || $aGPNPort3Cnt4(cnt9) < $rateL} {
                		set flag 1
                		gwd::GWpublic_print "NOK" "$printWord PW2:不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送外层tag=3000内层tag=300\
                			的数据流，NE1($gpnIp1) $GPNTestEth3\收到外层tag=3000内层tag=300的数据包速率为$aGPNPort3Cnt4(cnt9)，没在$rateL-$rateR\范围内" $fileId
                	} else {
                		gwd::GWpublic_print "OK" "$printWord PW2:不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送外层tag=3000内层tag=300\
                			的数据流，NE1($gpnIp1) $GPNTestEth3\收到外层tag=3000内层tag=300的数据包速率为$aGPNPort3Cnt4(cnt9)，在$rateL-$rateR\范围内" $fileId
                	}
		}
		if {$aGPNPort4Cnt40(cnt1) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，NE3($gpnIp3) \
				$GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt40(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，NE3($gpnIp3) \
				$GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt40(cnt1)" $fileId
		}
		if {$aGPNPort4Cnt40(cnt7) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送tag=300数据流，NE3($gpnIp3) \
			$GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt40(cnt7)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送tag=300数据流，NE3($gpnIp3) \
				$GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt40(cnt7)" $fileId
		}
		if {$aGPNPort4Cnt40(cnt8) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送tag=3000数据流，NE3($gpnIp3) \
			$GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt40(cnt8)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送tag=3000数据流，NE3($gpnIp3) \
				$GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt40(cnt8)" $fileId
		}
		if {$aGPNPort3Cnt40(cnt3) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt40(cnt3)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt40(cnt3)" $fileId
		}
		if {$aGPNPort3Cnt40(cnt7) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送tag=300数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt40(cnt7)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送tag=300数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt40(cnt7)" $fileId
		}
		if {$aGPNPort3Cnt40(cnt8) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送tag=3000数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt40(cnt8)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送tag=3000数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt40(cnt8)" $fileId
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
        	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($gpnIp1\).pcap" $fileId
        	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
        	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        	if {$aGPNPort4Cnt0(cnt10) ==0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp1 PW1:vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送外层tag=1000内层tag=100\
        			的数据流，NE3($gpnIp3) $GPNTestEth4\收到数据包的速率为0" $fileId
        	} else {
        		if {$aGPNPort4Cnt2(cnt10) > $rateR || $aGPNPort4Cnt2(cnt10) < $rateL} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord Lsp1 PW1:vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送外层tag=1000内层tag=100\
        				的数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=1000内层tag=100的数据包速率为$aGPNPort4Cnt2(cnt10)，没在$rateL-$rateR\范围内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord Lsp1 PW1:vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送外层tag=1000内层tag=100\
        				的数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=1000内层tag=100的数据包速率为$aGPNPort4Cnt2(cnt10)，在$rateL-$rateR\范围内" $fileId
        		}
        	}
        	if {$aGPNPort4Cnt0(cnt9) == 0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2:不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送外层tag=3000内层tag=300\
        			的数据流，NE3($gpnIp3) $GPNTestEth4\收到数据包的速率为0" $fileId
        	} else {
        		if {$aGPNPort4Cnt2(cnt9) > $rateR || $aGPNPort4Cnt2(cnt9) < $rateL} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2:不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送外层tag=3000内层tag=300\
        				的数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=3000内层tag=300的数据包速率为$aGPNPort4Cnt2(cnt9)，没在$rateL-$rateR\范围内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord Lsp1 PW2:不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送外层tag=3000内层tag=300\
        				的数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=3000内层tag=300的数据包速率为$aGPNPort4Cnt2(cnt9)，在$rateL-$rateR\范围内" $fileId
        		}
        	}
        	if {$aGPNPort3Cnt0(cnt10) == 0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp1 PW1:vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送外层tag=1000内层tag=100\
        			的数据流，NE1($gpnIp1) $GPNTestEth3\收到数据包的速率为0" $fileId
        	} else {
        		if {$aGPNPort3Cnt2(cnt10) > $rateR || $aGPNPort3Cnt2(cnt10) < $rateL} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord Lsp1 PW1:vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送外层tag=1000内层tag=100\
        				的数据流，NE1($gpnIp1) $GPNTestEth3\收到外层tag=1000内层tag=100的数据包速率为$aGPNPort3Cnt2(cnt10)，没在$rateL-$rateR\范围内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord Lsp1 PW1:vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送外层tag=1000内层tag=100\
        				的数据流，NE1($gpnIp1) $GPNTestEth3\收到外层tag=1000内层tag=100的数据包速率为$aGPNPort3Cnt2(cnt10)，在$rateL-$rateR\范围内" $fileId
        		}
        	}
        	if {$aGPNPort3Cnt0(cnt9) == 0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2:不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送外层tag=3000内层tag=300\
        			的数据流，NE1($gpnIp1) $GPNTestEth3\收到数据包的速率为0" $fileId
        	} else {
        		if {$aGPNPort3Cnt2(cnt9) > $rateR || $aGPNPort3Cnt2(cnt9) < $rateL} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2:不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送外层tag=3000内层tag=300\
        				的数据流，NE1($gpnIp1) $GPNTestEth3\收到外层tag=3000内层tag=300的数据包速率为$aGPNPort3Cnt2(cnt9)，没在$rateL-$rateR\范围内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord Lsp1 PW2:不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送外层tag=3000内层tag=300\
        				的数据流，NE1($gpnIp1) $GPNTestEth3\收到外层tag=3000内层tag=300的数据包速率为$aGPNPort3Cnt2(cnt9)，在$rateL-$rateR\范围内" $fileId
        		}
        	}
		if {$printWord == ""} {
			if {$aGPNPort4Cnt0(cnt7) !=0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送tag=300数据流，NE3($gpnIp3) \
				$GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt0(cnt7)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord Lsp1 PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送tag=300数据流，NE3($gpnIp3) \
					$GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt0(cnt7)" $fileId
			}
			if {$aGPNPort4Cnt0(cnt8) !=0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送tag=3000数据流，NE3($gpnIp3) \
				$GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt0(cnt8)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord Lsp1 PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE1($gpnIp1) $GPNTestEth3\发送tag=3000数据流，NE3($gpnIp3) \
					$GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt0(cnt8)" $fileId
			}
			
			if {$aGPNPort3Cnt0(cnt7) !=0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送tag=300数据流，\
					NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt0(cnt7)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord Lsp1 PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送tag=300数据流，\
					NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt0(cnt7)" $fileId
			}
			if {$aGPNPort3Cnt0(cnt8) !=0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord Lsp1 PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送tag=3000数据流，\
					NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt0(cnt8)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord Lsp1 PW2：不配置vctype(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，NE3($gpnIp3) $GPNTestEth4\发送tag=3000数据流，\
					NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt0(cnt8)" $fileId
			}
			
		}
        	if {$aGPNPort4Cnt1(cnt11) !=0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp10 PW10：不配置vctype(NE1:PORT----NE3:PORT+VLAN)，NE1($gpnIp1) $GPNTestEth2\发送untag数据流，\
        			NE3($gpnIp3) $GPNTestEth4\接收tag=500的数据包速率应为0实为$aGPNPort4Cnt1(cnt11)" $fileId
        	} else {
        		if {$aGPNPort4Cnt0(cnt11) > $rateR || $aGPNPort4Cnt0(cnt11) < $rateL} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord Lsp10 PW10：不配置vctype(NE1:PORT----NE3:PORT+VLAN)，NE1($gpnIp1) $GPNTestEth2\发送untag的数据流，\
        				NE3($gpnIp3) $GPNTestEth4\收到untag的数据包速率为$aGPNPort4Cnt0(cnt11)，没在$rateL-$rateR\范围内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord Lsp10 PW10：不配置vctype(NE1:PORT----NE3:PORT+VLAN)，NE1($gpnIp1) $GPNTestEth2\发送untag的数据流，\
        				NE3($gpnIp3) $GPNTestEth4\收到untag的数据包速率为$aGPNPort4Cnt0(cnt11)，在$rateL-$rateR\范围内" $fileId
        		}
        	}
        	if {$aGPNPort4Cnt1(cnt12) > $rateR || $aGPNPort4Cnt1(cnt12) < $rateL} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp10 PW10：不配置vctype(NE1:PORT----NE3:PORT+VLAN)，NE1($gpnIp1) $GPNTestEth2\发送tag=500的数据流，\
        			NE3($gpnIp3) $GPNTestEth4\收到tag=500的数据包速率为$aGPNPort4Cnt1(cnt12)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord Lsp10 PW10：不配置vctype(NE1:PORT----NE3:PORT+VLAN)，NE1($gpnIp1) $GPNTestEth2\发送tag=500的数据流，\
        			NE3($gpnIp3) $GPNTestEth4\收到tag=500的数据包速率为$aGPNPort4Cnt1(cnt12)，在$rateL-$rateR\范围内" $fileId
        	}
        	
        	if {$aGPNPort2Cnt0(cnt13) !=0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp10 PW10：不配置vctype(NE1:PORT----NE3:PORT+VLAN)，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，\
        			NE1($gpnIp1) $GPNTestEth2\接收数据包的速率应为0实为$aGPNPort2Cnt0(cnt13)" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord Lsp10 PW10：不配置vctype(NE1:PORT----NE3:PORT+VLAN)，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，\
        			NE1($gpnIp1) $GPNTestEth2\接收数据包的速率应为0实为$aGPNPort2Cnt0(cnt13)" $fileId
        	}
        	if {$aGPNPort2Cnt1(cnt14) > $rateR || $aGPNPort2Cnt1(cnt14) < $rateL} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord Lsp10 PW10：不配置vctype(NE1:PORT----NE3:PORT+VLAN)，NE3($gpnIp3) $GPNTestEth4\发送tag=500数据流，\
        			NE1($gpnIp1) $GPNTestEth2\收到tag=500的数据包速率为$aGPNPort2Cnt1(cnt14)，没在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord Lsp10 PW10：不配置vctype(NE1:PORT----NE3:PORT+VLAN)，NE3($gpnIp3) $GPNTestEth4\发送tag=500数据流，\
        			NE1($gpnIp1) $GPNTestEth2\收到tag=500的数据包速率为$aGPNPort2Cnt1(cnt14)，在$rateL-$rateR\范围内" $fileId
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
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
		
		if {$aGPNPort4Cnt1(cnt1) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord (NE1:PORT----NE3:PORT+VLAN)，NE1($gpnIp1) $GPNTestEth3\发送untag的数据流，\
				NE3($gpnIp3) $GPNTestEth4\收到tag=100的数据包速率应为0，实为$aGPNPort4Cnt1(cnt1)" $fileId
		} else {
			if {$aGPNPort4Cnt0(cnt1) > $rateR || $aGPNPort4Cnt0(cnt1) < $rateL} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord (NE1:PORT----NE3:PORT+VLAN)，NE1($gpnIp1) $GPNTestEth3\发送untag的数据流，\
					NE3($gpnIp3) $GPNTestEth4\收到untag的数据包速率为$aGPNPort4Cnt0(cnt1)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord (NE1:PORT----NE3:PORT+VLAN)，NE1($gpnIp1) $GPNTestEth3\发送untag的数据流，\
					NE3($gpnIp3) $GPNTestEth4\收到untag的数据包速率为$aGPNPort4Cnt0(cnt1)，在$rateL-$rateR\范围内" $fileId
			}
		}
		if {$aGPNPort4Cnt1(cnt2) > $rateR || $aGPNPort4Cnt1(cnt2) < $rateL} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord (NE1:PORT----NE3:PORT+VLAN)，NE1($gpnIp1) $GPNTestEth3\发送tag=100的数据流，\
				NE3($gpnIp3) $GPNTestEth4\收到tag=100的数据包速率为$aGPNPort4Cnt1(cnt2)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord (NE1:PORT----NE3:PORT+VLAN)，NE1($gpnIp1) $GPNTestEth3\发送tag=100的数据流，\
				NE3($gpnIp3) $GPNTestEth4\收到tag=100的数据包速率为$aGPNPort4Cnt1(cnt2)，在$rateL-$rateR\范围内" $fileId
		}
		if {$aGPNPort3Cnt0(cnt13) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord (NE1:PORT----NE3:PORT+VLAN)，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt0(cnt13)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord (NE1:PORT----NE3:PORT+VLAN)，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt0(cnt13)" $fileId
		}
		if {$aGPNPort3Cnt1(cnt14) > $rateR || $aGPNPort3Cnt1(cnt14) < $rateL} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord (NE1:PORT----NE3:PORT+VLAN)，NE3($gpnIp3) $GPNTestEth4\发送tag=500数据流，\
				NE1($gpnIp1) $GPNTestEth3\收到tag=500的数据包速率为$aGPNPort3Cnt1(cnt14)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord (NE1:PORT----NE3:PORT+VLAN)，NE3($gpnIp3) $GPNTestEth4\发送tag=500数据流，\
				NE1($gpnIp1) $GPNTestEth3\收到tag=500的数据包速率为$aGPNPort3Cnt1(cnt14)，在$rateL-$rateR\范围内" $fileId
		}
		return $flag
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
	set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3\
			\"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4	
        #创建测试流量
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
	
        ##获取发生器和分析器指针
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
        ##定制收发信息
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
        
        #配置流的速率 10%，Mbps
	foreach hStream $lHStream {
		stc::config [stc::get $hStream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
	}
        stc::apply 
        #获取发生器配置指针
        gwd::Get_GeneratorCfgObj $hGPNPort1Gen hGPNPort1GenCfg
        gwd::Cfg_GeneratorCfgObj $hGPNPort1GenCfg $GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort2Gen hGPNPort2GenCfg
        gwd::Cfg_GeneratorCfgObj $hGPNPort2GenCfg $GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort3Gen hGPNPort3GenCfg
        gwd::Cfg_GeneratorCfgObj $hGPNPort3GenCfg $GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort4Gen hGPNPort4GenCfg
        gwd::Cfg_GeneratorCfgObj $hGPNPort4GenCfg $GenCfg
        #创建并配置过滤器，默认过滤tag
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort1Ana hGPNPort1AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg1
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort2Ana hGPNPort2AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort3Ana hGPNPort3AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1	
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
	if {$cap_enable} {
                #获取和配置capture对象相关的指针
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
	puts $fileId "===E-LINE功能验证 LSP PW交换测试基础配置开始...\n"
        set portList11 "$GPNPort5 $GPNTestEth3"
	foreach port $portList11 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
		}
	}
        set rebootSlotlist1 [gwd::GWpulic_getWorkCardList $portList11]
	gwd::GWpublic_print "OK" "获取设备NE1($gpnIp1)业务板卡槽位号$rebootSlotlist1" $fileId
        set mslot1 [gwd::GWpulic_getWorkCardList $managePort1]
	gwd::GWpublic_print "OK" "获取设备NE1($gpnIp1)管理口所在槽位号$mslot1" $fileId
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
	gwd::GWpublic_print "OK" "获取设备NE2($gpnIp2)业务板卡槽位号$rebootSlotlist2" $fileId
        set mslot2 [gwd::GWpulic_getWorkCardList $managePort2]
	gwd::GWpublic_print "OK" "获取设备NE2($gpnIp2)管理口所在槽位号$mslot2" $fileId
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
        gwd::GWpublic_print "OK" "获取设备NE3($gpnIp3)业务板卡和上联板卡槽位号为：$rebootSlotlist3" $fileId
        set mslot3 [gwd::GWpulic_getWorkCardList $managePort3]
	gwd::GWpublic_print "OK" "获取设备NE3($gpnIp3)管理口所在版本槽位号$mslot3" $fileId
	lappend cfgFlag [gwd::GWpublic_GetSysMac $telnet3 $matchType3 $Gpn_type3 $fileId gpnMac3]
	#目的：应为有测试点：镜像NNI口mpls报文检查报文中的vid和mac，所以NNI口tag方式加入到vlan中，但是又有untag报文的lsp转发测试，\
		所以把所有的NNI口untag到一个测试中不会用到的vlan4091中
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
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-LINE功能验证 LSP PW交换测试基础配置失败，测试结束" \
		"E-LINE功能验证 LSP PW交换测试基础配置成功，继续后面的测试" "GPN_PTN_002_1"
        puts $fileId ""
        puts $fileId "===E-LINE功能验证 LSP PW交换测试基础配置结束..."
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_013" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 创建E-LINE业务，业务功能验证及反复倒换、重启板卡、保存重启操作后业务恢复测试\n"
        #   <1>三台设备NNI端口(GE端口)以tag方式加入到VLANIF 100中
        #   <2>用户侧（GE端口）接入模式为端口模式
        #   <3>创建LSP1
        #      配置NE1（7600）的LSP1入标签100，出标签200；PW1本地标签1000，远程标签2000
        #      配置NE3（7600）的LSP1入标签300，出标签400；PW1本地标签2000，远程标签1000  
        #      配置NE2（7600S）的SW(两条swap)
        #   <4>NE1和NE3用户测配置undo vlan check
        #   <5>创建PW1/AC1
        #   <6>向NE1的端口1发送untag/tag业务流量，观察NE3的端口3的接收结果
        #   预期结果：NE3的端口3可正常接收untag/tag业务流量；双向发送untag/tag业务均正常
        #   <7>使能NE1的LSP1/PW1/AC1性能统计，系统无异常，性能统计功能生效，统计值正确
        #   <8>使能NE1设备PW1的控制字，并镜像NE1的NNI端口egress方向报文
        #   预期结果：镜像报文为带VLAN TAG标签并打上两层mpls标签报文，外层lsp标签200，内层pw标签2000
        #             LSP字段中的TTL值为255，PW字段中的TTL值为255，PW字段中含有4字节控制字
        #   <9>undo shutdown和shutdown NE1设备的NNI/UNI端口50次，每次操作后业务恢复正常，系统无异常 
        #   <10>重启NE1设备的NNI/UNI端口所在板卡50次，每次操作后业务恢复正常，系统无异常 
        #   <11>NE1设备进行SW/NMS倒换50次，每次操作后业务恢复正常，系统无异常 ，查看标签转发表项正确，三台设备管理正常
        #   <12>保存重启NE1设备的50次，每次操作后系统正常启动，业务恢复正常，系统无异常，查看标签转发表项正确，三台设备管理正常 
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
        #######========vctype为tagged模式(NE1:PORT----NE3:PORT+VLAN)测试==========#########
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged模式(NE1:PORT----NE3:PORT+VLAN)测试业务  测试开始=====\n"
        set vctype "tagged"
        ###配置设备NE1
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
        ###配置设备NE2
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface14 $ip2 $GPNPort6 $matchType2 $Gpn_type2 $telnet2
	PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface15 $ip3 $GPNPort7 $matchType2 $Gpn_type2 $telnet2
        gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface15 $ip4 "200" "300" "0" 2 "normal"
        gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface14 $ip1 "400" "100" "0" 3 "normal"
        ###配置设备NE3
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	if {$aGPNPort4Cnt1(cnt1) < $rateL || $aGPNPort4Cnt1(cnt1) > $rateR} {
  		set flag1_case1 1
		gwd::GWpublic_print "NOK" "vctype为tagged时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，NE3($gpnIp3) $GPNTestEth4\接收tag=100的数据包速率为$aGPNPort4Cnt1(cnt1)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，NE3($gpnIp3) $GPNTestEth4\接收tag=100的数据包速率为$aGPNPort4Cnt1(cnt1)，在$rateL-$rateR\范围内" $fileId
	}
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg4
	incr capId
        sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
        if {$aGPNPort4Cnt1(cnt17)< $rateL || $aGPNPort4Cnt1(cnt17) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "vctype为tagged时，NE1($gpnIp1) $GPNTestEth3\发送tag=100数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=100内层tag=100的数据包速率为$aGPNPort4Cnt1(cnt17)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged时，NE1($gpnIp1) $GPNTestEth3\发送tag=100数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=100内层tag=100的数据包速率为$aGPNPort4Cnt1(cnt17)，在$rateL-$rateR\范围内" $fileId
	}
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
	incr capId
        sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	if {$aGPNPort4Cnt1(cnt1) < $rateL || $aGPNPort4Cnt1(cnt1) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "vctype为tagged时，NE1($gpnIp1) $GPNTestEth3\同时发送untag和tag=100数据流，NE3($gpnIp3) $GPNTestEth4\接收tag=100的数据包速率为$aGPNPort4Cnt1(cnt1)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged时，NE1($gpnIp1) $GPNTestEth3\同时发送untag和tag=100数据流，NE3($gpnIp3) $GPNTestEth4\接收tag=100的数据包速率为$aGPNPort4Cnt1(cnt1)，在$rateL-$rateR\范围内" $fileId
	}
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg4
	incr capId
	sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	parray aGPNPort4Cnt1
	parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt1(cnt17)< $rateL || $aGPNPort4Cnt1(cnt17)> $rateR || $aGPNPort4Cnt2(cnt2)< $rateL || $aGPNPort4Cnt2(cnt2)> $rateR} {
        	set flag1_case1 1
        	gwd::GWpublic_print "NOK" "vctype为tagged时，NE1($gpnIp1) $GPNTestEth3\同时发送untag和tag=100数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=100内层tag=100的数据包速率为$aGPNPort4Cnt1(cnt17)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged时，NE1($gpnIp1) $GPNTestEth3\同时发送untag和tag=100数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=100内层tag=100的数据包速率为$aGPNPort4Cnt1(cnt17)，在$rateL-$rateR\范围内" $fileId
	}
        gwd::Cfg_StreamActive $hGPNPort4Stream3 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream4 "TRUE"
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg1
	incr capId
	sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt3 aGPNPort4Cnt4 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        parray aGPNPort3Cnt1
        parray aGPNPort3Cnt2
        parray aGPNPort4Cnt3
        parray aGPNPort4Cnt4
	if {$aGPNPort4Cnt3(cnt1) < $rateL || $aGPNPort4Cnt3(cnt1) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "vctype为tagged时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，NE3($gpnIp3) $GPNTestEth4\接收tag=100的数据包速率为$aGPNPort4Cnt3(cnt1)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，NE3($gpnIp3) $GPNTestEth4\接收tag=100的数据包速率为$aGPNPort4Cnt3(cnt1)，在$rateL-$rateR\范围内" $fileId
	}
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg4
	incr capId
	sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort4Cnt1(cnt17)< $rateL || $aGPNPort4Cnt1(cnt17) > $rateR} {
		set flag1_case1 1
		  gwd::GWpublic_print "NOK" "vctype为tagged时，NE1($gpnIp1) $GPNTestEth3\发送tag=100数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=100内层tag=100的数据包速率为$aGPNPort4Cnt1(cnt17)，没在$rateL-$rateR\范围内" $fileId
	} else {
		  gwd::GWpublic_print "OK" "vctype为tagged时，NE1($gpnIp1) $GPNTestEth3\发送tag=100数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=100内层tag=100的数据包速率为$aGPNPort4Cnt1(cnt17)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aGPNPort3Cnt2(cnt3) != 0} {
        	set flag1_case1 1
        	gwd::GWpublic_print "NOK" "vctype为tagged时，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt2(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged时，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt2(cnt3)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt4) != 0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "vctype为tagged时，NE3($gpnIp3) $GPNTestEth4\发送tag=100的数据流，NE1($gpnIp1) $GPNTestEth3\接收tag=100的数据包速率应为0实为aGPNPort3Cnt1(cnt4)" $fileId
	} else {
		if {$aGPNPort3Cnt2(cnt4) < $rateL || $aGPNPort3Cnt2(cnt4) > $rateR} {
			set flag1_case1 1
			gwd::GWpublic_print "NOK" "vctype为tagged时，NE3($gpnIp3) $GPNTestEth4\发送tag=100数据流，NE1($gpnIp1) $GPNTestEth3\接收untag数据包速率为$aGPNPort3Cnt2(cnt4)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctype为tagged时，NE3($gpnIp3) $GPNTestEth4\发送tag=100数据流，NE1($gpnIp1) $GPNTestEth3\接收untag数据包速率为$aGPNPort3Cnt2(cnt4)，在$rateL-$rateR\范围内" $fileId
		}
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1（结论）vctype为tagged模式(NE1:PORT----NE3:PORT+VLAN)测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1（结论）vctype为tagged模式(NE1:PORT----NE3:PORT+VLAN)测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged模式(NE1:PORT----NE3:PORT+VLAN)测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged测试overlay功能  测试开始=====\n"
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        parray aGPNPort3Cnt1
        parray aGPNPort3Cnt2
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	if {$aGPNPort3Cnt1(cnt16) != 0} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "vctype为tagged 未使能overlay时，NE3($gpnIp3) $GPNTestEth4\发送tag=100的mpls数据流，NE1($gpnIp1) $GPNTestEth3\接收tag=100的mpls数据包速率应为0实为aGPNPort3Cnt1(cnt16)" $fileId
	} else {
		if {$aGPNPort3Cnt2(cnt16) < $rateL || $aGPNPort3Cnt2(cnt16) > $rateR} {
			set flag2_case1 1
			gwd::GWpublic_print "NOK" "vctype为tagged 未使能overlay时，NE3($gpnIp3) $GPNTestEth4\发送tag=100的mpls数据流，NE1($gpnIp1) $GPNTestEth3\接收untag数据包速率为$aGPNPort3Cnt2(cnt16)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctype为tagged 未使能overlay时，NE3($gpnIp3) $GPNTestEth4\发送tag=100的mpls数据流，NE1($gpnIp1) $GPNTestEth3\接收untag数据包速率为$aGPNPort3Cnt2(cnt16)，在$rateL-$rateR\范围内" $fileId
		}
	} 
	if {$aGPNPort4Cnt1(cnt17) < $rateL || $aGPNPort4Cnt1(cnt17) > $rateR || $aGPNPort4Cnt2(cnt15) < $rateL || $aGPNPort4Cnt2(cnt15) > $rateR} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "vctype为tagged 未使能overlay时，NE1($gpnIp1) $GPNTestEth3\发送tag=100的mpls数据流，NE3($gpnIp3) $GPNTestEth4\接收外层tag=100内层tag=100数据包速率为$aGPNPort4Cnt1(cnt17)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged 未使能overlay时，NE1($gpnIp1) $GPNTestEth3\发送tag=100的mpls数据流，NE3($gpnIp3) $GPNTestEth4\接收外层tag=100内层tag=100数据包速率为$aGPNPort4Cnt1(cnt17)，在$rateL-$rateR\范围内" $fileId
	}
       	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg1
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort4AnaFrameCfgFil $anaFliFrameCfg4
        gwd::GWpublic_addOverLay $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3 "enable"
        gwd::GWpublic_addOverLay $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "enable"
        
	incr capId
        sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        parray aGPNPort3Cnt1
        parray aGPNPort3Cnt2
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	if {$aGPNPort3Cnt1(cnt16) != 0} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "vctype为tagged 使能overlay时，NE3($gpnIp3) $GPNTestEth4\发送tag=100的mpls数据流，NE1($gpnIp1) $GPNTestEth3\接收tag=100的mpls数据包速率应为0实为aGPNPort3Cnt1(cnt16)" $fileId
	} else {
		if {$aGPNPort3Cnt2(cnt16) < $rateL || $aGPNPort3Cnt2(cnt16) > $rateR} {
			set flag2_case1 1
			gwd::GWpublic_print "NOK" "vctype为tagged 使能overlay时，NE3($gpnIp3) $GPNTestEth4\发送tag=100的mpls数据流，NE1($gpnIp1) $GPNTestEth3\接收untag数据包速率为$aGPNPort3Cnt2(cnt16)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctype为tagged 使能overlay时，NE3($gpnIp3) $GPNTestEth4\发送tag=100的mpls数据流，NE1($gpnIp1) $GPNTestEth3\接收untag数据包速率为$aGPNPort3Cnt2(cnt16)，在$rateL-$rateR\范围内" $fileId
		}
	} 
	if {$aGPNPort4Cnt1(cnt17) < $rateL || $aGPNPort4Cnt1(cnt17) > $rateR || $aGPNPort4Cnt2(cnt15) < $rateL || $aGPNPort4Cnt2(cnt15) > $rateR} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "vctype为tagged 使能overlay时，NE1($gpnIp1) $GPNTestEth3\发送tag=100的mpls数据流，NE3($gpnIp3) $GPNTestEth4\接收外层tag=100内层tag=100数据包速率为$aGPNPort4Cnt1(cnt17)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged 使能overlay时，NE1($gpnIp1) $GPNTestEth3\发送tag=100的mpls数据流，NE3($gpnIp3) $GPNTestEth4\接收外层tag=100内层tag=100数据包速率为$aGPNPort4Cnt1(cnt17)，在$rateL-$rateR\范围内" $fileId
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2（结论）vctype为tagged时测试overlay功能" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2（结论）vctype为tagged时测试overlay功能" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged测试overlay功能  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged性能统计功能  测试开始=====\n"
        ###配置设备NE1
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
		gwd::GWpublic_print "NOK" "FA3（结论）vctype为tagged lsp pw ac性能统计功能测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3（结论）vctype为tagged lsp pw ac性能统计功能测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged性能统计功能  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged时设备添加的mpls标签是否正确  测试开始=====\n"
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3).pcap" $fileId
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
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)发送untag数据流时，镜像报文双层标签异常" $fileId
        } else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)发送untag数据流时，镜像报文双层标签正常" $fileId
        }
        if {$aTmpGPNPort2Cnt3(cnt1) < $rateL1 || $aTmpGPNPort2Cnt3(cnt1)> $rateR1} {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)发送untag数据流时，镜像报文vid和stack异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)发送untag数据流时，镜像报文vid和stack正常" $fileId
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3).pcap" $fileId
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
		
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)发送tag数据流时，镜像报文双层标签异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)发送tag数据流时，镜像报文双层标签正常" $fileId
	}
	if {$aTmpGPNPort2Cnt3(cnt1) < $rateL1 || $aTmpGPNPort2Cnt3(cnt1)> $rateR1} {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)发送tag数据流时，镜像报文vid和stack异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)发送tag数据流时，镜像报文vid和stack正常" $fileId
	}
	gwd::Stop_SendFlow "$hGPNPort3Gen"  "$hGPNPort2Ana"	
	
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA4（结论）vctype为tagged时设备添加的mpls标签" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4（结论）vctype为tagged时设备添加的mpls标签" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged时设备添加的mpls标签是否正确  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====检查经过LSP交换前后LSP和PW的TTL值  测试开始=====\n"
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth2_cap\($gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2).pcap" $fileId
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
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100的数据流，NE1($gpnIp1)$GPNTestEth2\镜像NE1到NE2的NE1 NNI口$GPNPort5\的egress方向，\
			LSP-TTL的值不是FF或者PW-TTL的值不是FF" $fileId
	} else {
		if {$aTmpGPNPort2Cnt1(cnt7) < $rateL1 || $aTmpGPNPort2Cnt1(cnt7) > $rateR1} {
			set flag10_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100的数据流，NE1($gpnIp1)$GPNTestEth2\镜像NE1到NE2的NE1 NNI口$GPNPort5\的egress方向，LSP-TTL和PW-TTL的值都是FF\
				但是速率为$aTmpGPNPort2Cnt1(cnt7)，没在$rateL1-$rateR1\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100的数据流，NE1($gpnIp1)$GPNTestEth2\镜像NE1到NE2的NE1 NNI口$GPNPort5\的egress方向，LSP-TTL和PW-TTL的值都是FF\
				速率为$aTmpGPNPort2Cnt1(cnt7)，在$rateL1-$rateR1\范围内" $fileId
		}
	}
	if {$aTmpGPNPort1Cnt1(cnt8) == 0} {
		set flag10_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100的数据流，NE2($gpnIp2)$GPNTestEth1\镜像NE2到NE3的NE2 NNI口$GPNPort7\的egress方向，经过NE2的LSP交换后\
			LSP-TTL的值不是FE或者PW-TTL的值不是FF" $fileId
	} else {
		if {$aTmpGPNPort1Cnt1(cnt8) < $rateL1 || $aTmpGPNPort1Cnt1(cnt8) > $rateR1} {
			set flag10_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100的数据流，NE2($gpnIp2)$GPNTestEth1\镜像NE2到NE3的NE2 NNI口$GPNPort7\的egress方向，经过NE2的LSP交换后，\
				LSP-TTL是FE PW-TTL的值是FF，但是速率为$aTmpGPNPort1Cnt1(cnt8)，没在$rateL1-$rateR1\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100的数据流，NE2($gpnIp2)$GPNTestEth1\镜像NE2到NE3的NE2 NNI口$GPNPort7\的egress方向，经过NE2的LSP交换后，\
				LSP-TTL是FE PW-TTL的值是FF，速率为$aTmpGPNPort1Cnt1(cnt8)，在$rateL1-$rateR1\范围内" $fileId
		}
	}
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2
	gwd::GWpublic_DelPortMirror $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth1
	puts $fileId ""
	if {$flag10_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FE6（结论）检查经过LSP交换前后LSP和PW的TTL值的测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE6（结论）检查经过LSP交换前后LSP和PW的TTL值的测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====检查经过LSP交换前后LSP和PW的TTL值  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged时反复shutdown/undoshutdown端口后业务是否能恢复  测试开始=====\n"
	stc::delete $hfilter16BitFilAna1
	stc::delete $hfilter16BitFilAna2
	stc::delete $hfilter16BitFilAna3
	stc::delete $hfilter16BitFilAna4
	gwd::Cfg_StreamActive $hGPNPort3Stream1 "true"
	gwd::Cfg_StreamActive $hGPNPort3Stream15 "true"
        ##反复undo shutdown/shutdown端口
        foreach eth $portList11 {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
          		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
          		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
          		after $WaiteTime
			incr capId
			if {[Test_Case1 "第$j\次undo shutdown/shutdown NE1($gpnIp1)的$eth\端口" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag5_case1 1
			}
        	}
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag5_case1	1
			gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
		}
        }
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA5（结论）vctype为tagged时反复shutdown/undoshutdown端口后业务恢复和系统内存测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5（结论）vctype为tagged时反复shutdown/undoshutdown端口后业务恢复和系统内存测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged时反复shutdown/undoshutdown端口后业务是否能恢复  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged时反复重启业务端口所在板卡后业务是否能恢复  测试开始=====\n"
        ###反复重启端口所在板卡
        foreach slot $rebootSlotlist1 {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource3
		set testFlag 0 ;#=1 板卡不支持重启操作，测试跳过
          	for {set j 1} {$j<=$cnt} {incr j} {
          		if {![gwd::GWCard_AddReboot $telnet1 $matchType1 $Gpn_type1 $fileId $slot]} {
                  		after $rebootBoardTime
                  		if {[string match $mslot1 $slot]} {
        				set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
					set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
                   		}
				incr capId
        			if {[Test_Case1 "第$j\次重启NE1($gpnIp1)$slot\槽位板卡后" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
        				set flag6_case1 1
        			}
         		} else {
				gwd::GWpublic_print "OK" $fileId "$matchType1\不支持板卡重启操作，测试跳过" $fileId
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
				gwd::GWpublic_print "NOK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
			} else {
				gwd::GWpublic_print "OK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
			} 
		}       	
        }
	puts $fileId ""
	if {$flag6_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA6（结论）vctype为tagged时反复重启业务端口所在板卡后业务恢复和系统内存测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6（结论）vctype为tagged时反复重启业务端口所在板卡后业务恢复和系统内存测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged时反复重启业务端口所在板卡后业务是否能恢复  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged时反复进行NMS主备倒换后业务是否能恢复  测试开始=====\n"
        ###反复进行NMS主备倒换
	set testFlag 0 ;#=1 测试跳过
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_Case1 "第$j\次NE1($gpnIp1)进行NMS主备倒换后" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag7_case1 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "1" result
			if {![string match [dict get $result 1 pwOutLabel] 1000] || ![string match [dict get $result 1 lspOutLabel] +200]} {
				set flag7_case1 1
				gwd::GWpublic_print "NOK" "VC=1 的pwOutLabel为[dict get $result 1 pwOutLabel] \
						lspOutLabel为[dict get $result 1 lspOutLabel]，NE1($gpnIp1)第$j\次进行NMS主备倒换转发表项异常" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=1 的pwOutLabel为[dict get $result 1 pwOutLabel] \
						lspOutLabel为[dict get $result 1 lspOutLabel]，NE1($gpnIp1)第$j\次进行NMS主备倒换转发表项正常" $fileId
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
			set flag7_case1	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
                } else {
                	gwd::GWpublic_print "OK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
                }
	}
	puts $fileId ""
	if {$flag7_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA7（结论）vctype为tagged时反复NMS主备倒换后业务恢复、mpls转发表项、系统内存测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7（结论）vctype为tagged时反复NMS主备倒换后业务恢复、mpls转发表项、系统内存测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged时反复进行NMS主备倒换后业务是否能恢复  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged时反复进行SW主备倒换后业务是否能恢复  测试开始=====\n"
        ##反复进行SW主备倒换
	set testFlag 0 ;#=1 测试跳过
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_Case1 "第$j\次NE1($gpnIp1)进行SW主备倒换后" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag8_case1 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "1" result
			if {![string match [dict get $result 1 pwOutLabel] 1000] || ![string match [dict get $result 1 lspOutLabel] +200]} {
				set flag8_case1 1
				gwd::GWpublic_print "NOK" "VC=1 的pwOutLabel为[dict get $result 1 pwOutLabel] \
						lspOutLabel为[dict get $result 1 lspOutLabel]，NE1($gpnIp1)第$j\次进行SW主备倒换转发表项异常" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=1 的pwOutLabel为[dict get $result 1 pwOutLabel] \
						lspOutLabel为[dict get $result 1 lspOutLabel]，NE1($gpnIp1)第$j\次进行SW主备倒换转发表项正常" $fileId
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
			set flag8_case1	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag8_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA8（结论）vctype为tagged时反复SW主备倒换后业务恢复、mpls转发表项、系统内存测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8（结论）vctype为tagged时反复SW主备倒换后业务恢复、mpls转发表项、系统内存测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged时反复进行SW主备倒换后业务是否能恢复  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged时反复进行保存设备重启后业务是否能恢复  测试开始=====\n"
      
        ##反复保存设备重启
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
        for {set j 1} {$j<=$cnt} {incr j} {
          	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
          	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
          	after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[Test_Case1 "第$j\次NE1($gpnIp1)设备保存配置重启后" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
			set flag9_case1 1
		}
		gwd::GWpublic_QueryMPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "1" result
		if {![string match [dict get $result 1 pwOutLabel] 1000] || ![string match [dict get $result 1 lspOutLabel] +200]} {
			set flag9_case1 1
			gwd::GWpublic_print "NOK" "VC=1 的pwOutLabel为[dict get $result 1 pwOutLabel] \
					lspOutLabel为[dict get $result 1 lspOutLabel]，NE1($gpnIp1)第$j\次保存设备重启转发表项异常" $fileId
		} else {
			gwd::GWpublic_print "OK" "VC=1 的pwOutLabel为[dict get $result 1 pwOutLabel] \
					lspOutLabel为[dict get $result 1 lspOutLabel]，NE1($gpnIp1)第$j\次保存设备重启转发表项正常" $fileId
		}
        }
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
        if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag9_case1	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag9_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA9（结论）vctype为tagged时反复进行保存设备重启后业务恢复、mpls转发表项、系统内存测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9（结论）vctype为tagged时反复进行保存设备重启后业务恢复、mpls转发表项、系统内存测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged时反复进行保存设备重启后业务是否能恢复  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
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
	puts $fileId "Test Case 1 创建E-LINE业务，业务功能验证及反复倒换、重启板卡、保存重启操作后业务恢复测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 新创建E-LINE业务，将接入模式设为“端口+运营商VLAN”时功能及业务恢复测试\n"
        #   <1>删除NE1和NE3设备的专线业务（AC），删除成功，业务中断，系统无异常
        #   <2>重新创建NE1和NE3设备的AC节点专线业务（AC),承载伪线（PW）不做更改，均仅将接入模式设为“端口+运营商VLAN”
        #   <3>用户侧加入指定的vlan中
        #   <4>在NE1和NE3上均创建所需的VLAN（vlan 1000），并加入端口
        #   <5>向NE1的端口1发送tag1000、tag2000业务流量，观察NE3的端口3的接收结果
        #   预期结果：再次创建接入模式为“端口+运营商VLAN”的专线业务，成功创建，系统无异常
        #             NE3的端口3只可接收tag1000业务流量；双向发流业务正常
        #   <6>删除之前接入模式设为“端口+运营商VLAN”的AC
        #   <7>在NE1和NE3设备上创建AC接入模式设为“端口+运营商VLAN+客户VLAN”
        #      运营商VLAN为 vlan 3000，客户VLAN为vlan 300
        #   <8>在NE1和NE3设备上再创建一条新的E-LINE业务(与之前的业务共用同一条LSP)，且AC接入模式设为“端口+运营商VLAN+客户VLAN”
        #      运营商VLAN为 vlan 1000，客户VLAN为vlan 100
        #   预期结果：业务成功创建，系统无异常，对之前的业务无任何干扰
        #   <9>向NE1的UNI端口发送untag、tag300、tag3000、 双层tag（外3000 内300）业务流量，观察NE3的UNI端口的接收结果
        #   预期结果：NE3的UNI端口只可接收到双层tag（外3000 内300）业务流量，对之前的业务无干扰，双向发流业务正常
        #   <10>undo shutdown和shutdown NE3设备的NNI/UNI端口50次，每次操作后业务恢复正常，系统无异常 
        #   <11>重启NE3设备的NNI/UNI端口所在板卡50次，每次操作后业务恢复正常，系统无异常 
        #   <12>NE3设备进行SW/NMS倒换50次，每次操作后业务恢复正常，系统无异常 ，查看标签转发表项正确，三台设备管理正常
        #   <13>保存重启NE3设备的50次，每次操作后系统正常启动，业务恢复正常，系统无异常，查看标签转发表项正确，三台设备管理正常 
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
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged模式(NE1:PORT+VLAN----NE3:PORT+VLAN)测试业务  测试开始=====\n"
        ###配置设备NE1
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
		gwd::GWpublic_print "NOK" "vctype为tagged模式再次创建接入模式为“端口+运营商VLAN”的专线业务，创建失败" $fileId
        }
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "pw1" "eline12"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        ###配置设备NE3
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aTmpGPNPort4Cnt91(cnt5) < $rateL || $aTmpGPNPort4Cnt91(cnt5) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000的数据流，\
				NE3($gpnIp3) $GPNTestEth4\接收tag=1000的数据流速率为$aTmpGPNPort4Cnt91(cnt5)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000的数据流，\
				NE3($gpnIp3) $GPNTestEth4\接收tag=1000的数据流速率为$aTmpGPNPort4Cnt91(cnt5)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aTmpGPNPort4Cnt91(cnt6) !=0} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=2000的数据流，\
				NE3($gpnIp3) $GPNTestEth4\接收tag=2000的数据流速率应为0实为$aTmpGPNPort4Cnt91(cnt6)" $fileId
	}        
        gwd::Cfg_StreamActive $hGPNPort4Stream5 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream6 "TRUE"
	incr capId
	SendAndStat_ptn002_1 1 "$hGPNPort3Gen $hGPNPort4Gen" "$hGPNPort3Ana $hGPNPort4Ana" "$GPNTestEth3 $GPNTestEth4" \
		"$hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
		"$hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil"  aTmpGPNPort3Cnt81 aTmpGPNPort4Cnt71 aGPNCnt3 1 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aTmpGPNPort4Cnt71(cnt5) < $rateL || $aTmpGPNPort4Cnt71(cnt5) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000的数据流，\
				NE3($gpnIp3) $GPNTestEth4\接收tag=1000的数据流速率为$aTmpGPNPort4Cnt71(cnt5)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000的数据流，\
				NE3($gpnIp3) $GPNTestEth4\接收tag=1000的数据流速率为$aTmpGPNPort4Cnt71(cnt5)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aTmpGPNPort4Cnt71(cnt6) !=0} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=2000的数据流，\
				NE3($gpnIp3) $GPNTestEth4\接收tag=2000的数据流速率应为0实为$aTmpGPNPort4Cnt71(cnt6)" $fileId
	}
	if {$aTmpGPNPort3Cnt81(cnt5) < $rateL || $aTmpGPNPort3Cnt81(cnt5) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000的数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收tag=1000的数据流速率为$aTmpGPNPort3Cnt81(cnt5)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000的数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收tag=1000的数据流速率为$aTmpGPNPort3Cnt81(cnt5)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aTmpGPNPort3Cnt81(cnt6) !=0} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE3($gpnIp3) $GPNTestEth4\发送tag=2000的数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收tag=2000的数据流速率应为0实为$aTmpGPNPort3Cnt81(cnt6)" $fileId
	}
	#pw ping 和traceroute------
	gwd::GWpublic_addPwPing $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" pingResult
	if {[dict get $pingResult sucRate]==100.00} {
		gwd::GWpublic_print "OK" "vctype为tagged模式，在NE1上PING PW1的成功率应为100.00%为[dict get $pingResult sucRate]%" $fileId
	} else {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged模式，在NE1上PING PW1的成功率应为100.00%为[dict get $pingResult sucRate]%" $fileId
	}
	if {[string match [dict get $pingResult replyIp] "192.1.2.4"]} {
		gwd::GWpublic_print "OK" "vctype为tagged模式，在NE1上PING PW1的reply from 的ip应为192.1.2.4实为[dict get $pingResult replyIp]" $fileId
	} else {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged模式，在NE1上PING PW1的reply from 的ip应为192.1.2.4实为[dict get $pingResult replyIp]" $fileId
	}
	gwd::GWpublic_addPwTrace $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
	set expectTrace {2 {replier "192.1.2.4" traceTime "<1ms" type "Egress" downstream "--" ret "success"}}
	if {[Check_Tracertroute "" $expectTrace $result]} {
		set flag1_case2 1 
		gwd::GWpublic_print "NOK" "vctype为tagged模式，在NE1($gpnIp1)上tracertroute pw1查看报文到NE3($gpnIp3)经过的每一跳测试异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged模式，在NE1($gpnIp1)上tracertroute pw1查看报文到NE3($gpnIp3)经过的每一跳测试正常" $fileId
	}
	#------pw ping 和traceroute
	#lsp ping 和traceroute------
	gwd::GWpublic_addLspPing $telnet1 $matchType1 $Gpn_type1 $fileId "10.1.1.1/32" "generic" pingResult
	if {[dict get $pingResult sucRate]==100.00} {
		gwd::GWpublic_print "OK" "vctype为tagged模式，在NE1上ping mpls lsp ip 10.1.1.1/32 generic的成功率应为100.00%为[dict get $pingResult sucRate]%" $fileId
	} else {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged模式，在NE1上ping mpls lsp ip 10.1.1.1/32 generic的成功率应为100.00%为[dict get $pingResult sucRate]%" $fileId
	}
	if {[string match [dict get $pingResult replyIp] "192.1.2.4"]} {
		gwd::GWpublic_print "OK" "vctype为tagged模式，在NE1上ping mpls lsp ip 10.1.1.1/32 generic的reply from 的ip应为192.1.2.4实为[dict get $pingResult replyIp]" $fileId
	} else {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged模式，在NE1上ping mpls lsp ip 10.1.1.1/32 generic的reply from 的ip应为192.1.2.4实为[dict get $pingResult replyIp]" $fileId
	}
	gwd::GWpublic_addLspTrace $telnet1 $matchType1 $Gpn_type1 $fileId "10.1.1.1/32" "generic" result
	if {[string match "fail" $result]} {
		set flag1_case2 1 
		gwd::GWpublic_print "NOK" "vctype为tagged模式，在NE1($gpnIp1)上tracertroute lsp ip 10.1.1.1/32 generic查看报文到NE3($gpnIp3)经过的每一跳测试没有返回success" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged模式，在NE1($gpnIp1)上tracertroute lsp ip 10.1.1.1/32 generic查看报文到NE3($gpnIp3)经过的每一跳测试返回success" $fileId
	}
	#------lsp ping 和traceroute
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB1（结论）vctype为tagged模式(NE1:PORT+VLAN----NE3:PORT+VLAN)测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1（结论）vctype为tagged模式(NE1:PORT+VLAN----NE3:PORT+VLAN)测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged模式(NE1:PORT+VLAN----NE3:PORT+VLAN)测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged模式(NE1:PORT----NE3:PORT)测试业务  测试开始=====\n"
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aTmpGPNPort4Cnt1(cnt5) < $rateL || $aTmpGPNPort4Cnt1(cnt5) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000的数据流，\
        			NE3($gpnIp3) $GPNTestEth4\接收tag=1000的数据流速率为$aTmpGPNPort4Cnt1(cnt5)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctype为tagged(NE1:PORT----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000的数据流，\
        			NE3($gpnIp3) $GPNTestEth4\接收tag=1000的数据流速率为$aTmpGPNPort4Cnt1(cnt5)，在$rateL-$rateR\范围内" $fileId
        }
        if {$aTmpGPNPort4Cnt1(cnt6) < $rateL || $aTmpGPNPort4Cnt1(cnt6) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送tag=2000的数据流，\
        			NE3($gpnIp3) $GPNTestEth4\接收tag=2000的数据流速率为$aTmpGPNPort4Cnt1(cnt6)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctype为tagged(NE1:PORT----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送tag=2000的数据流，\
        			NE3($gpnIp3) $GPNTestEth4\接收tag=2000的数据流速率为$aTmpGPNPort4Cnt1(cnt6)，在$rateL-$rateR\范围内" $fileId
        }
        if {$aTmpGPNPort3Cnt1(cnt5) < $rateL || $aTmpGPNPort3Cnt1(cnt5) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000的数据流，\
        			NE1($gpnIp1) $GPNTestEth3\接收tag=1000的数据流速率为$aTmpGPNPort3Cnt1(cnt5)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctype为tagged(NE1:PORT----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000的数据流，\
        			NE1($gpnIp1) $GPNTestEth3\接收tag=1000的数据流速率为$aTmpGPNPort3Cnt1(cnt5)，在$rateL-$rateR\范围内" $fileId
        }
        if {$aTmpGPNPort3Cnt1(cnt6) < $rateL || $aTmpGPNPort3Cnt1(cnt6) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送tag=2000的数据流，\
        			NE1($gpnIp1) $GPNTestEth3\接收tag=2000的数据流速率为$aTmpGPNPort3Cnt1(cnt6)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctype为tagged(NE1:PORT----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送tag=2000的数据流，\
        			NE1($gpnIp1) $GPNTestEth3\接收tag=2000的数据流速率为$aTmpGPNPort3Cnt1(cnt6)，在$rateL-$rateR\范围内" $fileId
        }
	puts $fileId ""
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB2（结论）vctype为tagged模式(NE1:PORT----NE3:PORT)测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2（结论）vctype为tagged模式(NE1:PORT----NE3:PORT)测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged模式(NE1:PORT----NE3:PORT)测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)测试业务  测试开始=====\n"
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aTmpGPNPort4Cnt1(cnt19) !=0} {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "vctype为tagged(PORT+VLAN1----NE3:PORT+VLAN2)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000的数据流，\
        			NE3($gpnIp3) $GPNTestEth4\接收tag=1000的数据流速率应为0实为为$aTmpGPNPort4Cnt1(cnt19)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctype为tagged(PORT+VLAN1----NE3:PORT+VLAN2)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000的数据流，\
        			NE3($gpnIp3) $GPNTestEth4\接收tag=1000的数据流速率应为0实为为$aTmpGPNPort4Cnt1(cnt19)" $fileId
        }
        if {$aTmpGPNPort4Cnt1(cnt20) < $rateL || $aTmpGPNPort4Cnt1(cnt20) > $rateR} {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "vctype为tagged(PORT+VLAN1----NE3:PORT+VLAN2)时，NE1($gpnIp1) $GPNTestEth3\发送tag=2000的数据流，\
        			NE3($gpnIp3) $GPNTestEth4\接收tag=2000的数据流速率为$aTmpGPNPort4Cnt1(cnt20)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctype为tagged(PORT+VLAN1----NE3:PORT+VLAN2)时，NE1($gpnIp1) $GPNTestEth3\发送tag=2000的数据流，\
        			NE3($gpnIp3) $GPNTestEth4\接收tag=2000的数据流速率为$aTmpGPNPort4Cnt1(cnt20)，在$rateL-$rateR\范围内" $fileId
        }
        if {$aTmpGPNPort3Cnt1(cnt19) < $rateL || $aTmpGPNPort3Cnt1(cnt19) > $rateR} {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "vctype为tagged(PORT+VLAN1----NE3:PORT+VLAN2)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000的数据流，\
        			NE1($gpnIp1) $GPNTestEth3\接收tag=1000的数据流速率为$aTmpGPNPort3Cnt1(cnt19)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctype为tagged(PORT+VLAN1----NE3:PORT+VLAN2)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000的数据流，\
        			NE1($gpnIp1) $GPNTestEth3\接收tag=1000的数据流速率为$aTmpGPNPort3Cnt1(cnt19)，在$rateL-$rateR\范围内" $fileId
        }
        if {$aTmpGPNPort3Cnt1(cnt20) !=0} {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "vctype为tagged(PORT+VLAN1----NE3:PORT+VLAN2)时，NE3($gpnIp3) $GPNTestEth4\发送tag=2000的数据流，\
        			NE1($gpnIp1) $GPNTestEth3\接收tag=2000的数据流速率应为0实为为$aTmpGPNPort3Cnt1(cnt20)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctype为tagged(PORT+VLAN1----NE3:PORT+VLAN2)时，NE3($gpnIp3) $GPNTestEth4\发送tag=2000的数据流，\
        			NE1($gpnIp1) $GPNTestEth3\接收tag=2000的数据流速率应为0实为为$aTmpGPNPort3Cnt1(cnt20)" $fileId
        }
	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB3（结论）vctype为tagged模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3（结论）vctype为tagged模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)测试业务  测试开始=====\n"
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aTmpGPNPort4Cnt4(cnt5) !=0} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000的数据流，\
		        	NE3($gpnIp3) $GPNTestEth4\接收tag=1000的数据流速率应为0实为$aTmpGPNPort4Cnt4(cnt5)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000的数据流，\
				NE3($gpnIp3) $GPNTestEth4\接收tag=1000的数据流速率应为0实为$aTmpGPNPort4Cnt4(cnt5)" $fileId
	}
	if {$aTmpGPNPort4Cnt4(cnt6) !=0} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=2000的数据流，\
				NE3($gpnIp3) $GPNTestEth4\接收tag=2000的数据流速率应为0实为$aTmpGPNPort4Cnt4(cnt6)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=2000的数据流，\
				NE3($gpnIp3) $GPNTestEth4\接收tag=2000的数据流速率应为0实为$aTmpGPNPort4Cnt4(cnt6)" $fileId
	}
	if {$aTmpGPNPort3Cnt4(cnt5) !=0} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000的数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收tag=1000的数据流速率应为0实为$aTmpGPNPort3Cnt4(cnt5)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000的数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收tag=1000的数据流速率应为0实为$aTmpGPNPort3Cnt4(cnt5)" $fileId
	}
	if {$aTmpGPNPort3Cnt4(cnt6) !=0} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送tag=2000的数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收tag=2000的数据流速率应为0实为$aTmpGPNPort3Cnt4(cnt6)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctype为tagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送tag=2000的数据流，\
        			NE1($gpnIp1) $GPNTestEth3\接收tag=2000的数据流速率应为0实为$aTmpGPNPort3Cnt4(cnt6)" $fileId
        }

        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $anaFliFrameCfg4
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $anaFliFrameCfg4
	incr capId
	SendAndStat_ptn002_1 1 "$hGPNPort3Gen $hGPNPort4Gen" "$hGPNPort3Ana $hGPNPort4Ana" "$GPNTestEth3 $GPNTestEth4" \
			"$hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp3" \
			"$hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" aTmpGPNPort3Cnt4 aTmpGPNPort4Cnt4 aGPNCnt3 2 "GPN_PTN_002_1_$capId"
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aTmpGPNPort4Cnt4(cnt10) < $rateL || $aTmpGPNPort4Cnt4(cnt10) > $rateR} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送外层tag=1000 内层tag=100\
			的数据流，NE3($gpnIp3) $GPNTestEth4\接收外层tag=1000 内层tag=100的数据流速率为$aTmpGPNPort4Cnt4(cnt10)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送外层tag=1000 内层tag=100\
			的数据流，NE3($gpnIp3) $GPNTestEth4\接收外层tag=1000 内层tag=100的数据流速率为$aTmpGPNPort4Cnt4(cnt10)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aTmpGPNPort3Cnt4(cnt10) < $rateL || $aTmpGPNPort3Cnt4(cnt10) > $rateR} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "vctype为tagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送外层tag=1000 内层tag=100\
			的数据流，NE1($gpnIp1) $GPNTestEth3\接收外层tag=1000 内层tag=100的数据流速率为$aTmpGPNPort3Cnt4(cnt10)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为tagged(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送外层tag=1000 内层tag=100\
			的数据流，NE1($gpnIp1) $GPNTestEth3\接收外层tag=1000 内层tag=100的数据流速率为$aTmpGPNPort3Cnt4(cnt10)，在$rateL-$rateR\范围内" $fileId
	}
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB4（结论）vctype为tagged模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4（结论）vctype为tagged模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为tagged模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为raw模式(NE1:PORT----NE3:PORT)测试业务  测试开始=====\n"	
        #######========vctype为raw模式测试==========#########
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort4Cnt1(cnt1) != 0} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，NE3($gpnIp3) $GPNTestEth4\接收到\
			tag=100的数据包速率应为0实为$aGPNPort4Cnt2(cnt1)" $fileId
	} else {
		if {$aGPNPort4Cnt2(cnt1) < $rateL || $aGPNPort4Cnt2(cnt1) > $rateR} {
			set flag5_case2 1
			gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，NE3($gpnIp3) $GPNTestEth4\接收到\
				untag的数据包速率为$aGPNPort4Cnt2(cnt1)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，NE3($gpnIp3) $GPNTestEth4\接收到\
				untag的数据包速率为$aGPNPort4Cnt2(cnt1)，在$rateL-$rateR\范围内" $fileId
		}
	}
	if {$aGPNPort4Cnt1(cnt2) < $rateL || $aGPNPort4Cnt1(cnt2) > $rateR} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送tag=100数据流，NE3($gpnIp3) $GPNTestEth4\接收到\
			tag=100的数据包速率为$aGPNPort4Cnt1(cnt2)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送tag=100数据流，NE3($gpnIp3) $GPNTestEth4\接收到\
			tag=100的数据包速率为$aGPNPort4Cnt1(cnt2)，在$rateL-$rateR\范围内" $fileId
        }
	if {$aGPNPort3Cnt1(cnt3) != 0} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，NE1($gpnIp1) $GPNTestEth3\接收到\
			untag的数据包速率应为0实为$aGPNPort3Cnt1(cnt3)" $fileId
	} else {
		if {$aGPNPort3Cnt2(cnt3) < $rateL || $aGPNPort3Cnt2(cnt3) > $rateR} {
			set flag5_case2 1
			gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，NE1($gpnIp1) $GPNTestEth3\接收到\
				untag的数据包速率为$aGPNPort3Cnt2(cnt3)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，NE1($gpnIp1) $GPNTestEth3\接收到\
				untag的数据包速率为$aGPNPort3Cnt2(cnt3)，在$rateL-$rateR\范围内" $fileId
		}
	}
	if {$aGPNPort3Cnt1(cnt4) < $rateL || $aGPNPort3Cnt1(cnt4) > $rateR} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送tag=100数据流，NE1($gpnIp1) $GPNTestEth3\接收到\
			tag=100的数据包速率为$aGPNPort3Cnt1(cnt4)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送tag=100数据流，NE1($gpnIp1) $GPNTestEth3\接收到\
			tag=100的数据包速率为$aGPNPort3Cnt1(cnt4)，在$rateL-$rateR\范围内" $fileId
	}
	puts $fileId ""
	if {$flag5_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB5（结论）vctype为raw模式(NE1:PORT----NE3:PORT)测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5（结论）vctype为raw模式(NE1:PORT----NE3:PORT)测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为raw模式(NE1:PORT----NE3:PORT)测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN)测试业务  测试开始=====\n"
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort4Cnt2(cnt1) != 0} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，NE3($gpnIp3) $GPNTestEth4\接收到\
			untag的数据包速率应为0实为$aGPNPort4Cnt2(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，NE3($gpnIp3) $GPNTestEth4\接收到\
			untag的数据包速率应为0实为$aGPNPort4Cnt2(cnt1)" $fileId
	}
	if {$aGPNPort4Cnt1(cnt5) < $rateL || $aGPNPort4Cnt1(cnt5) > $rateR} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000数据流，NE3($gpnIp3) $GPNTestEth4\接收到\
			tag=1000的数据包速率为$aGPNPort4Cnt1(cnt5)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000数据流，NE3($gpnIp3) $GPNTestEth4\接收到\
			tag=1000的数据包速率为$aGPNPort4Cnt1(cnt5)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aGPNPort3Cnt2(cnt3) != 0} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，NE1($gpnIp1) $GPNTestEth3\接收到\
			untag的数据包速率应为0实为$aGPNPort3Cnt2(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，NE1($gpnIp1) $GPNTestEth3\接收到\
			untag的数据包速率应为0实为$aGPNPort3Cnt2(cnt3)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt5) < $rateL || $aGPNPort3Cnt1(cnt5) > $rateR} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000数据流，NE1($gpnIp1) $GPNTestEth3\接收到\
			tag=1000的数据包速率为$aGPNPort3Cnt1(cnt5)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000数据流，NE1($gpnIp1) $GPNTestEth3\接收到\
			tag=1000的数据包速率为$aGPNPort3Cnt1(cnt5)，在$rateL-$rateR\范围内" $fileId
	}
	puts $fileId ""
	if {$flag6_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB6（结论）vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN)测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6（结论）vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN)测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN)测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置PW12环回)测试业务  测试开始=====\n"
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
	
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort1Cnt1(cnt7)!=0} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置pw12环回)时，pw12的业务：NE1($gpnIp1) $GPNTestEth3\发送tag=300数据流，\
			NE2($gpnIp2) $GPNTestEth1\接收到tag=300的数据包速率应为0实为$aGPNPort1Cnt1(cnt7)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt7)>$rateR|| $aGPNPort3Cnt1(cnt7)<$rateL} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置pw12环回)时，pw12的业务：NE1($gpnIp1) $GPNTestEth3\发送tag=300数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收到tag=300的环回数据包速率为$aGPNPort3Cnt1(cnt7)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置pw12环回)时，pw12的业务：NE1($gpnIp1) $GPNTestEth3\发送tag=300数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收到tag=300的环回数据包速率为$aGPNPort3Cnt1(cnt7)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aGPNPort4Cnt1(cnt5) < $rateL || $aGPNPort4Cnt1(cnt5) > $rateR} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置pw12环回)时，pw1的业务：NE1($gpnIp1) $GPNTestEth3\发送tag=1000数据流，\
			NE3($gpnIp3) $GPNTestEth4\接收到tag=1000的数据包速率为$aGPNPort4Cnt1(cnt5)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置pw12环回)时，pw1的业务：NE1($gpnIp1) $GPNTestEth3\发送tag=1000数据流，\
			NE3($gpnIp3) $GPNTestEth4\接收到tag=1000的数据包速率为$aGPNPort4Cnt1(cnt5)，在$rateL-$rateR\范围内，不受pw12环回的影响" $fileId
	}
	if {$aGPNPort3Cnt1(cnt5) < $rateL || $aGPNPort3Cnt1(cnt5) > $rateR} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置pw12环回)时，pw1的业务：NE3($gpnIp3) $GPNTestEth4\发送tag=1000数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收到tag=1000的数据包速率为$aGPNPort3Cnt1(cnt5)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置pw12环回)时，pw1的业务：NE3($gpnIp3) $GPNTestEth4\发送tag=1000数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收到tag=1000的数据包速率为$aGPNPort3Cnt1(cnt5)，在$rateL-$rateR\范围内，不受pw12环回的影响" $fileId
	}
	#NE1镜像NNI口的出入报文
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth2_cap\($gpnIp1\).pcap" $fileId
	if {$aGPNPort2Cnt1(cnt3) < $rateL1 || $aGPNPort2Cnt1(cnt3) > $rateR1} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置pw12环回)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000数据流，\
			NE1($gpnIp1)$GPNTestEth2_cap\镜像NNI口出口添加mpls包头smac=$dev_sysmac1 tag=100的数据包速率为$aGPNPort2Cnt1(cnt3)，没在$rateL1-$rateR1\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置pw12环回)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000数据流，\
			NE1($gpnIp1)$GPNTestEth2_cap\镜像NNI口出口添加mpls包头smac=$dev_sysmac1 tag=100的数据包速率为$aGPNPort2Cnt1(cnt3)，在$rateL1-$rateR1\范围内" $fileId
	}
	if {$aGPNPort2Cnt1(cnt4) < $rateL1 || $aGPNPort2Cnt1(cnt4) > $rateR1} {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置pw12环回)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000数据流，\
			NE1($gpnIp1)$GPNTestEth2_cap\镜像NNI口入口收到mpls包头smac=$dev_sysmac2 tag=100的数据包速率为$aGPNPort2Cnt1(cnt4)，没在$rateL1-$rateR1\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置pw12环回)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000数据流，\
			NE1($gpnIp1)$GPNTestEth2_cap\镜像NNI口入口收到mpls包头smac=$dev_sysmac2 tag=100的数据包速率为$aGPNPort2Cnt1(cnt4)，在$rateL1-$rateR1\范围内" $fileId
	}
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2
	
	#pw ping 和traceroute------	
	gwd::GWpublic_addPwPing $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" pingResult
	if {[dict get $pingResult sucRate]==100.00} {
		gwd::GWpublic_print "OK" "vctype为raw模式，在NE1上PING PW1的成功率应为100.00%为[dict get $pingResult sucRate]%" $fileId
	} else {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式，在NE1上PING PW1的成功率应为100.00%为[dict get $pingResult sucRate]%" $fileId
	}
	if {[string match [dict get $pingResult replyIp] "192.1.2.4"]} {
		gwd::GWpublic_print "OK" "vctype为raw模式，在NE1上PING PW1的reply from 的ip应为192.1.2.4实为[dict get $pingResult replyIp]" $fileId
	} else {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式，在NE1上PING PW1的reply from 的ip应为192.1.2.4实为[dict get $pingResult replyIp]" $fileId
	}
	gwd::GWpublic_addPwTrace $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
	set expectTrace {2 {replier "192.1.2.4" traceTime "<1ms" type "Egress" downstream "--" ret "success"}}
	if {[Check_Tracertroute "" $expectTrace $result]} {
		set flag7_case2 1 
		gwd::GWpublic_print "NOK" "vctype为raw模式，在NE1($gpnIp1)上tracertroute pw1查看报文到NE3($gpnIp3)经过的每一跳测试异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式，在NE1($gpnIp1)上tracertroute pw1查看报文到NE3($gpnIp3)经过的每一跳测试正常" $fileId
	}
	#------pw ping 和traceroute
	#lsp ping 和traceroute------
	gwd::GWpublic_addLspPing $telnet1 $matchType1 $Gpn_type1 $fileId "10.1.1.1/32" "generic" pingResult
	if {[dict get $pingResult sucRate]==100.00} {
		gwd::GWpublic_print "OK" "vctype为raw模式，在NE1上ping mpls lsp ip 10.1.1.1/32 generic的成功率应为100.00%为[dict get $pingResult sucRate]%" $fileId
	} else {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式，在NE1上ping mpls lsp ip 10.1.1.1/32 generic的成功率应为100.00%为[dict get $pingResult sucRate]%" $fileId
	}
	if {[string match [dict get $pingResult replyIp] "192.1.2.4"]} {
		gwd::GWpublic_print "OK" "vctype为raw模式，在NE1上ping mpls lsp ip 10.1.1.1/32 generic的reply from 的ip应为192.1.2.4实为[dict get $pingResult replyIp]" $fileId
	} else {
		set flag7_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式，在NE1上ping mpls lsp ip 10.1.1.1/32 generic的reply from 的ip应为192.1.2.4实为[dict get $pingResult replyIp]" $fileId
	}
	gwd::GWpublic_addLspTrace $telnet1 $matchType1 $Gpn_type1 $fileId "10.1.1.1/32" "generic" result
	if {[string match "fail" $result]} {
		set flag7_case2 1 
		gwd::GWpublic_print "NOK" "vctype为raw模式，在NE1($gpnIp1)上tracertroute lsp ip 10.1.1.1/32 generic查看报文到NE3($gpnIp3)经过的每一跳测试没有返回success" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式，在NE1($gpnIp1)上tracertroute lsp ip 10.1.1.1/32 generic查看报文到NE3($gpnIp3)经过的每一跳测试返回success" $fileId
	}
	#------lsp ping 和traceroute
	puts $fileId ""
	if {$flag7_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB7（结论）vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置PW12环回)测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7（结论）vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置PW12环回)测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置PW12环回)测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)测试业务  测试开始=====\n"
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort3Cnt1(cnt21) < $rateL || $aGPNPort3Cnt1(cnt21) > $rateR} {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收到tag=1000的数据包速率为$aGPNPort3Cnt1(cnt5)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收到tag=1000的数据包速率为$aGPNPort3Cnt1(cnt5)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aGPNPort4Cnt2(cnt1) !=0} {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，\
			NE3($gpnIp3) $GPNTestEth4\接收数据包速率应为0实为$aGPNPort4Cnt2(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，\
			NE3($gpnIp3) $GPNTestEth4\接收数据包速率应为0实为$aGPNPort4Cnt2(cnt1)" $fileId
	}
	if {$aGPNPort4Cnt1(cnt5) != 0} {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000数据流，\
			NE3($gpnIp3) $GPNTestEth4\接收tag=1000数据包速率应为0实为$aGPNPort4Cnt1(cnt5)" $fileId
	} else {
		if {$aGPNPort4Cnt2(cnt5) < $rateL || $aGPNPort4Cnt2(cnt5) > $rateR} {
			set flag8_case2 1
			gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000数据流，\
				NE3($gpnIp3) $GPNTestEth4\接收untag数据包速率为$aGPNPort4Cnt2(cnt5)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000数据流，\
				NE3($gpnIp3) $GPNTestEth4\接收untag数据包速率为$aGPNPort4Cnt2(cnt5)，在$rateL-$rateR\范围内" $fileId
		}
	}
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort3AnaFrameCfgFil $anaFliFrameCfg4
	incr capId
	sendAndStat21 aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_1_$capId"
	parray aGPNPort3Cnt1
	parray aGPNPort3Cnt2
	parray aGPNPort4Cnt1
	parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort3Cnt2(cnt5) == 0} {
		set flag8_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收到数据包速率为0" $fileId
	} else {
		if {$aGPNPort3Cnt1(cnt18) < $rateL || $aGPNPort3Cnt1(cnt18) > $rateR} {
			set flag8_case2 1
			gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收到外层tag=1000内层tag=1000的数据包速率为$aGPNPort3Cnt1(cnt18)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000数据流，\
				NE1($gpnIp1) $GPNTestEth3\接收到外层tag=1000内层tag=1000的数据包速率为$aGPNPort3Cnt1(cnt18)，在$rateL-$rateR\范围内" $fileId
		}
	}
	puts $fileId ""
	if {$flag8_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB8（结论）vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8（结论）vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为raw模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)测试业务  测试开始=====\n"
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort4Cnt2(cnt1) !=0} {
		set flag9_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，\
			NE3($gpnIp3) $GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt2(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，\
			NE3($gpnIp3) $GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt2(cnt1)" $fileId
	}
	if {$aGPNPort4Cnt1(cnt20) < $rateL || $aGPNPort4Cnt1(cnt20) > $rateR} {
		set flag9_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000数据流，\
			NE3($gpnIp3) $GPNTestEth4\收到tag=2000的数据包速率为$aGPNPort4Cnt1(cnt20)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000数据流，\
			NE3($gpnIp3) $GPNTestEth4\收到tag=2000的数据包速率为$aGPNPort4Cnt1(cnt20)，在$rateL-$rateR\范围内" $fileId
	}
	if {$aGPNPort3Cnt2(cnt3) !=0} {
		set flag9_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)时，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt2(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)时，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt2(cnt3)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt19) < $rateL || $aGPNPort3Cnt1(cnt19) > $rateR} {
		set flag9_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)时，NE3($gpnIp3) $GPNTestEth4\发送tag=2000数据流，\
			NE1($gpnIp1) $GPNTestEth3\收到tag=1000的数据包速率为$aGPNPort3Cnt1(cnt19)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)时，NE3($gpnIp3) $GPNTestEth4\发送tag=2000数据流，\
			NE1($gpnIp1) $GPNTestEth3\收到tag=1000的数据包速率为$aGPNPort3Cnt1(cnt19)，在$rateL-$rateR\范围内" $fileId
	}
	puts $fileId ""
	if {$flag9_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB9（结论）vctype为raw模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9（结论）vctype为raw模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为raw模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)测试业务  测试开始=====\n"
        ###删除接入模式为“端口+运营商VLAN”的ac,再次创建接入模式为“端口+运营商VLAN+客户VLAN”的专线业务
        ###配置7600-1
        ###配置设备NE1
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
	gwd::GWPw_AddPwVcType $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" $vctype
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "2000" "1" "delete" "" 1000 0 "0x8100" "0x8100" ""
        if {[gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "" $GPNTestEth3 1000 100 "add" 1000 0 0 "0x8100"]} {
        	set flag10_case2 1
		gwd::gwd::GWpublic_print "NOK" "raw模式再次创建接入模式为“端口+运营商VLAN+客户VLAN”的专线业务，创建失败" $fileId
        }
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "pw1" "eline110"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        ###配置7600-3
        ###配置设备NE3
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1) !=0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，\
			NE3($gpnIp3) $GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt2(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送untag数据流，\
			NE3($gpnIp3) $GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt2(cnt1)" $fileId
	}
	if {$aGPNPort4Cnt2(cnt2) !=0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=100数据流，\
			NE3($gpnIp3) $GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt2(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=100数据流，\
			NE3($gpnIp3) $GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt2(cnt2)" $fileId
	}
	if {$aGPNPort4Cnt2(cnt5) !=0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000数据流，\
			NE3($gpnIp3) $GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt2(cnt5)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送tag=1000数据流，\
			NE3($gpnIp3) $GPNTestEth4\接收数据包的速率应为0实为$aGPNPort4Cnt2(cnt5)" $fileId
	}
	if {$aGPNPort3Cnt2(cnt3) !=0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt2(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送untag数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt2(cnt3)" $fileId
	}
	if {$aGPNPort3Cnt2(cnt4) !=0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送tag=100数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt2(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送tag=100数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt2(cnt4)" $fileId
	}
	if {$aGPNPort3Cnt2(cnt5) !=0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt2(cnt5)" $fileId
	} else {
		gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送tag=1000数据流，\
			NE1($gpnIp1) $GPNTestEth3\接收数据包的速率应为0实为$aGPNPort3Cnt2(cnt5)" $fileId
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
	if {$aGPNPort4Cnt2(cnt10) == 0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送外层tag=1000内层tag=100\
			的数据流，NE3($gpnIp3) $GPNTestEth4\接收数据包的速率为0" $fileId
	} else {
		if {$aGPNPort4Cnt1(cnt10) > $rateR || $aGPNPort4Cnt1(cnt10) < $rateL} {
			set flag10_case2 1
			gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送外层tag=1000内层tag=100\
				的数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=1000内层tag=100的数据包速率为$aGPNPort4Cnt1(cnt10)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE1($gpnIp1) $GPNTestEth3\发送外层tag=1000内层tag=100\
				的数据流，NE3($gpnIp3) $GPNTestEth4\收到外层tag=1000内层tag=100的数据包速率为$aGPNPort4Cnt1(cnt10)，在$rateL-$rateR\范围内" $fileId
		}
	}
	if {$aGPNPort3Cnt2(cnt10) == 0} {
		set flag10_case2 1
		gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送外层tag=1000内层tag=100\
			的数据流，NE1($gpnIp1) $GPNTestEth3\接收数据包的速率为0" $fileId
	} else {
		if {$aGPNPort3Cnt1(cnt10) > $rateR || $aGPNPort3Cnt1(cnt10) < $rateL} {
			set flag10_case2 1
			gwd::GWpublic_print "NOK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送外层tag=1000内层tag=100\
				的数据流，NE1($gpnIp1) $GPNTestEth3\收到外层tag=1000内层tag=100的数据包速率为$aGPNPort3Cnt1(cnt10)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)时，NE3($gpnIp3) $GPNTestEth4\发送外层tag=1000内层tag=100\
				的数据流，NE1($gpnIp1) $GPNTestEth3\收到外层tag=1000内层tag=100的数据包速率为$aGPNPort3Cnt1(cnt10)，在$rateL-$rateR\范围内" $fileId
		}
	}
	puts $fileId ""
	if {$flag10_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC1（结论）vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1（结论）vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====保留之前的PW1：vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，新建一条不配置vctype的PW2测试业务  测试开始=====\n"
        #######========恢复vctype模式测试==========#########
        ##共用同一条lsp的新e-line创建
        ##配置7600-1
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "l2transport" "3" "" $address1 "3000" "4000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" result
        PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "3000" $GPNTestEth3
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac3000" "" $GPNTestEth3 3000 300 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac3000" "pw2" "eline112"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac3000"
        ##配置7600-3
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
		gwd::GWpublic_print "NOK" "FC2（结论）保留之前的PW1：vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，新建一条不配置vctype的PW2测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2（结论）保留之前的PW1：vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，新建一条不配置vctype的PW2测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====保留之前的PW1：vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，新建一条不配置vctype的PW2测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====两条PW配置，反复shutdown/undo shutdown NE3($gpnIp3)UNI和NNI口后测试业务恢复  测试开始=====\n"
	##反复undo shutdown/shutdown端口
        foreach eth $portList33 {
		gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
          		gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $eth "shutdown"
          		gwd::GWpublic_CfgPortState $telnet3 $matchType3 $Gpn_type3 $fileId $eth "undo shutdown"
        		after $WaiteTime
			incr capId
			if {[Test_Case2 "第$j\次undo shutdown/shutdown NE3($gpnIp3)的$eth\端口" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag12_case2 1
			}
        	}
		gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag12_case2 1
			gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown NE3($gpnIp3)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "反复shutdown/undo shutdown NE3($gpnIp3)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
		}
        }
	puts $fileId ""
	if {$flag12_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC3（结论）两条PW配置，反复shutdown/undo shutdown NE3($gpnIp3)UNI和NNI口后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3（结论）两条PW配置，反复shutdown/undo shutdown NE3($gpnIp3)UNI和NNI口后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====两条PW配置，反复shutdown/undo shutdown NE3($gpnIp3)UNI和NNI口后测试业务恢复和系统内存  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====两条PW配置，反复重启 NE3($gpnIp3)UNI和NNI口所在板卡后测试业务恢复和系统内存  测试开始=====\n"
        ###反复重启端口所在板卡
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
				if {[Test_Case2 "第$j\次重启NE3($gpnIp3)$slot\槽位板卡" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
					set flag13_case2 1
				}
				  
         		} else {
				set testFlag 1
				gwd::GWpublic_print "OK" " NE3($gpnIp3)$slot\槽位板卡不支持板卡重启操作，测试跳过" $fileId
				break
         		}
        	}
		if {$testFlag == 0} {
			gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource4
			send_log "\n resource3:$resource3"
			send_log "\n resource4:$resource4"
			if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
				set flag13_case2 1
				gwd::GWpublic_print "NOK" "反复重启NE3($gpnIp3)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
			} else {
				gwd::GWpublic_print "OK" "反复重启NE3($gpnIp3)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
			}
		}
        }
	puts $fileId ""
	if {$flag13_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC4（结论）两条PW配置，反复重启 NE3($gpnIp3)UNI和NNI口所在板卡后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4（结论）两条PW配置，反复重启 NE3($gpnIp3)UNI和NNI口所在板卡后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====两条PW配置，反复重启 NE3($gpnIp3)UNI和NNI口所在板卡后测试业务恢复和系统内存  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====两条PW配置， NE3($gpnIp3)反复进行NMS主备倒换测试业务恢复和系统内存  测试开始=====\n"
        ##反复进行NMS主备倒换
	gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource5
        for {set j 1} {$j<$cntdh} {incr j} {
		set testFlag 0
        	if {![gwd::GWCard_AddSwitch $telnet3 $matchType3 $Gpn_type3 $fileId]} {
                	after $rebootTime
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
			incr capId
			if {[Test_Case2 "第$j\次 NE3($gpnIp3)进行NMS主备倒换" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag14_case2 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet3 $matchType3 $Gpn_type3 $fileId "4" result
			if {![string match [dict get $result 4 pwOutLabel] 4000] || ![string match [dict get $result 4 lspOutLabel] +400]} {
				set flag14_case2 1
				gwd::GWpublic_print "NOK" "VC=4 的pwOutLabel为[dict get $result 4 pwOutLabel] \
						lspOutLabel为[dict get $result 4 lspOutLabel]，NE3($gpnIp3)第$j\次进行NMS主备倒换转发表项异常" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=4 的pwOutLabel为[dict get $result 4 pwOutLabel] \
						lspOutLabel为[dict get $result 4 lspOutLabel]，NE3($gpnIp3)第$j\次进行NMS主备倒换转发表项正常" $fileId
			}
        	} else {
			set testFlag 1 
			gwd::GWpublic_print "OK" "NE3($gpnIp3)不支持NMS主备倒换或者只有一块NMS板卡，测试跳过" $fileId
			break
        	}
        }
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource6
		send_log "\n resource5:$resource5"
		send_log "\n resource6:$resource6"
		if {$resource6 > [expr $resource5 + $resource5 * $errRate]} {
			set flag14_case2 1
			gwd::GWpublic_print "NOK" "NE3($gpnIp3)反复进行NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($gpnIp3)反复进行NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag14_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC5（结论）两条PW配置， NE3($gpnIp3)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5（结论）两条PW配置， NE3($gpnIp3)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====两条PW配置， NE3($gpnIp3)反复进行NMS主备倒换测试业务恢复和系统内存  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====两条PW配置， NE3($gpnIp3)反复进行SW主备倒换测试业务恢复和系统内存  测试开始=====\n"
        ##反复进行SW主备倒换
	gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource7
        for {set j 1} {$j<$cntdh} {incr j} {
		set testFlag 0 
        	if {![gwd::GWCard_AddSwitchSw $telnet3 $matchType3 $Gpn_type3 $fileId]} {
                	after $rebootTime
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
			incr capId
			if {[Test_Case2 "第$j\次 NE3($gpnIp3)进行SW主备倒换" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag15_case2 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet3 $matchType3 $Gpn_type3 $fileId "4" result
			if {![string match [dict get $result 4 pwOutLabel] 4000] || ![string match [dict get $result 4 lspOutLabel] +400]} {
				set flag15_case2 1
				gwd::GWpublic_print "NOK" "VC=4 的pwOutLabel为[dict get $result 4 pwOutLabel] \
						lspOutLabel为[dict get $result 4 lspOutLabel]，NE3($gpnIp3)第$j\次进行SW主备倒换转发表项异常" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=4 的pwOutLabel为[dict get $result 4 pwOutLabel] \
						lspOutLabel为[dict get $result 4 lspOutLabel]，NE3($gpnIp3)第$j\次进行SW主备倒换转发表项正常" $fileId
			}
        	} else {
			set testFlag 1 
			gwd::GWpublic_print "OK" "NE3($gpnIp3)不支持SW主备倒换或者只有一块SW板卡，测试跳过" $fileId
			break
        	}
        }
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource8
		send_log "\n resource7:$resource7"
		send_log "\n resource8:$resource8"
		if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
			set flag15_case2 1
			gwd::GWpublic_print "NOK" "NE3($gpnIp3)反复进行SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($gpnIp3)反复进行SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag15_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC6（结论）两条PW配置， NE3($gpnIp3)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6（结论）两条PW配置， NE3($gpnIp3)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====两条PW配置， NE3($gpnIp3)反复进行SW主备倒换测试业务恢复和系统内存  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====两条PW配置， NE3($gpnIp3)反复保存设备重启测试业务恢复和系统内存  测试开始=====\n"
        ##反复保存设备重启
	gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource9
        for {set j 1} {$j<=$cnt} {incr j} {
        	
          	gwd::GWpublic_SaveCfg $telnet3 $matchType3 $Gpn_type3 $fileId
          	gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
          	after $rebootTime
		set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		incr capId
		if {[Test_Case2 "第$j\次 NE3($gpnIp3)进行保存重启" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
			set flag16_case2 1
		}
		gwd::GWpublic_QueryMPLSForwardTable $telnet3 $matchType3 $Gpn_type3 $fileId "4" result
		if {![string match [dict get $result 4 pwOutLabel] 4000] || ![string match [dict get $result 4 lspOutLabel] +400]} {
			set flag16_case2 1
			gwd::GWpublic_print "NOK" "VC=4 的pwOutLabel为[dict get $result 4 pwOutLabel] \
					lspOutLabel为[dict get $result 4 lspOutLabel]，NE3($gpnIp3)第$j\次保存设备重启转发表项异常" $fileId
		} else {
			gwd::GWpublic_print "OK" "VC=4 的pwOutLabel为[dict get $result 4 pwOutLabel] \
					lspOutLabel为[dict get $result 4 lspOutLabel]，NE3($gpnIp3)第$j\次保存设备重启转发表项正常" $fileId
		}
        }
	gwd::GWpublic_Getresource $telnet3 $matchType3 $Gpn_type3 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag16_case2 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)反复进行SW主备倒换之前系统内存为$resource9\，之后系统内存为$resource10。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)反复进行SW主备倒换之前系统内存为$resource9\，之后系统内存为$resource10。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag16_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC7（结论）两条PW配置， NE3($gpnIp3)反复保存设备重启测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7（结论）两条PW配置， NE3($gpnIp3)反复保存设备重启测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====两条PW配置， NE3($gpnIp3)反复保存设备重启测试业务恢复和系统内存  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
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
	puts $fileId "Test Case 2 新创建E-LINE业务，将接入模式设为“端口+运营商VLAN”时功能及业务恢复测试 测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 FE端口为UNI口的测试\n"
        #   <1>将NNI端口更改为10GE端口，其他条件不变，重复以上步骤
        #   <2>将UNI端口更改为FE/10GE端口，NNI端口更改为GE/10GE端口，其他条件不变，重复以上步骤
        #   <3>用FE端口配置ELINE业务时，需开启该板卡的MPLS业务模式（mpls enable <slot>）
        puts $fileId "FE端口为UNI口的测试没有覆盖，跳过"
        puts $fileId ""
	puts $fileId ""
	puts $fileId "Test Case 3 FE端口为UNI口的测试 测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 新创建E-LINE业务，NNI端口复用时功能及业务恢复测试\n"
        #   <1>重新创建一条NE1到NE3的E-LINE业务，NNI端口(GE端口)和之前所创建业务的NNI端口相同（即NNI端口复用）
        #      只是以tag方式加入到其他VLANIF 200中，用户侧（GE端口）接入模式为端口模式，故需新创建LSP、PW、AC
        #   <2>配置NE1的LSP10入标签16，出标签17；PW10本地标签20，远程标签21
        #      配置NE3的LSP10入标签18，出标签19；PW10本地标签21，远程标签20 
        #      NE2的SW配置：双层标签 （mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000> <1-65535> [normal|ring]）
        #      预期结果：业务配置成功，对之前的E-LINE业务无影响，系统无异常
        #   <3>NE1和NE3用户测配置undo vlan check
        #   <4>创建PW1/AC1
        #   <5>向NE1的端口1发送untag/tag业务流量，观察NE3的端口3的接收结果
        #   预期结果：NE3的端口3可正常接收untag/tag业务流量；双向发送untag/tag业务均正常，对之前的业务无干扰
        #   <6>镜像NE1的NNI端口egress方向报文
        #   预期结果：镜像报文为带VLAN TAG标签并打上两层mpls标签报文，外层lsp标签17，内层pw标签21
        #             LSP字段中的TTL值为255，PW字段中的TTL值为255，PW字段中含有4字节控制字
        #   <7>镜像NE2的NNI端口egress方向，同样可以抓到两层标签，外层标签交换为18，内层标签21，LSP字段中的TTL值减1，PW字段中的TTL值仍为255
        #   <8>undo shutdown和shutdown NE1和NE2设备的NNI/UNI端口50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
        #   <9>重启NE1和NE2设备的NNI/UNI端口所在板卡50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
        #   <10>NE1和NE2设备进行SW/NMS倒换50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 ，查看标签转发表项正确
        #   <11>保存重启NE1和NE2设备的50次，每次操作后系统正常启动，每条业务恢复正常且彼此无干扰，系统无异常，查看标签转发表项正确
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
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新创建E-LINE业务，NNI端口复用测试业务  测试开始=====\n"
        ###配置7600-1
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
        ###配置7600-2
        PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface18 $ip2 $GPNPort6 $matchType2 $Gpn_type2 $telnet2
        PTN_NNI_AddInterIp_tag $fileId $Worklevel $interface19 $ip3 $GPNPort7 $matchType2 $Gpn_type2 $telnet2
        gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface19 $ip4 "17" "18" "0" 6 "normal"
        gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface18 $ip1 "19" "16" "0" 7 "normal"
        ##配置7600-3
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
		gwd::GWpublic_print "NOK" "FC8（结论）两条ELine业务，NNI口复用测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8（结论）两条ELine业务，NNI口复用测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新创建E-LINE业务，NNI端口复用测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====两条E-LINE业务， 测试新创建E-LINE业务的端口性能统计  测试开始=====\n"
        ###配置设备NE1
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
		gwd::GWpublic_print "NOK" "FC9（结论）新创建E-LINE业务，NNI口复用。端口$GPNTestEth2 lsp10 pw10 ac10 性能统计功能" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC9（结论）新创建E-LINE业务，NNI口复用。端口$GPNTestEth2 lsp10 pw10 ac10 性能统计功能" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====两条E-LINE业务， 测试新创建E-LINE业务的端口性能统计  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====测试新创建E-LINE业务NNI口添加的mpls标签和vlan是否正确  测试开始=====\n"
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
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3镜像NNI口NE1($gpnIp1)$GPNPort5\数据，端口收到的数据打上的双层mpls标签不正确" $fileId
        } else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3镜像NNI口NE1($gpnIp1)$GPNPort5\数据，端口收到的数据打上的双层mpls标签正确" $fileId
        }
	
        if {$aTmpGPNPort3Cnt3(cnt3) < $rateL1 || $aTmpGPNPort3Cnt3(cnt3)> $rateR1} {
		set flag3_case4 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3镜像NNI口NE1($gpnIp1)$GPNPort5\数据，端口收到的数据打上的vid标签不正确" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3镜像NNI口NE1($gpnIp1)$GPNPort5\数据，端口收到的数据打上的vid标签正确" $fileId
	}
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth3
        ##镜像NE2 NNI口数据
        ###配置设备NE2
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
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1镜像NNI口NE2($gpnIp2)$GPNPort7\数据，端口收到的数据打上的双层mpls标签不正确" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1镜像NNI口NE2($gpnIp2)$GPNPort7\数据，端口收到的数据打上的双层mpls标签正确" $fileId
	}
        if {$aTmpGPNPort1Cnt3(cnt5) < $rateL1 || $aTmpGPNPort1Cnt3(cnt5)> $rateR1} {
		set flag3_case4 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1镜像NNI口NE1($gpnIp2)$GPNPort7\数据，端口收到的数据打上的vid标签不正确" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1镜像NNI口NE1($gpnIp2)$GPNPort7\数据，端口收到的数据打上的vid标签正确" $fileId
	}
	gwd::GWpublic_DelPortMirror $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth1
	puts $fileId ""
	if {$flag3_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD1（结论）测试新创建E-LINE业务NNI口添加的mpls标签和vlan" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD1（结论）测试新创建E-LINE业务NNI口添加的mpls标签和vlan" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====测试新创建E-LINE业务NNI口添加的mpls标签和vlan是否正确  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复shutdown/undoshutdownNE2($gpnIp2)的NNI口，测试业务恢复和对系统内存的影响  测试开始=====\n"
	gwd::Cfg_StreamActive $hGPNPort2Stream11 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort2Stream12 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream13 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream14 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort3Stream9 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream9 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort3Stream10 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream10 "TRUE"
	stc::perform saveasxml -fileName "test.xml"
        ###反复undo shutdown/shutdown端口
        foreach eth $portlist2 {
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
                        gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $eth "shutdown"
                        gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $eth "undo shutdown"
                       	after $WaiteTime
			incr capId
			if {[Test_Case4 "第$j\次undo shutdown/shutdown NE2($gpnIp2)的$eth\端口" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag4_case4 1
			}
                }
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag4_case4 1
			gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown NE2($gpnIp2)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "反复shutdown/undo shutdown NE2($gpnIp2)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
		}
        }
	puts $fileId ""
	if {$flag4_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD2（结论）反复shutdown/undoshutdownNE2($gpnIp2)的NNI口，测试业务恢复和对系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD2（结论）反复shutdown/undoshutdownNE2($gpnIp2)的NNI口，测试业务恢复和对系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复shutdown/undoshutdownNE2($gpnIp2)的NNI口，测试业务恢复和对系统内存的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复重启NE1($gpnIp1)NNI/UNI口所在板卡，测试业务恢复和对系统内存的影响  测试开始=====\n"
        ###反复重启端口所在板卡
        ###配置设备NE1
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
				if {[Test_Case4 "第$j\次重启NE1($gpnIp1)设备NNI/UNI口所在板卡$slot" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
					set flag5_case4 1
				}
         		} else {
				set testFlag 1
				  gwd::GWpublic_print "OK" "$matchType1\的$slot\槽位的板卡不支持重启操作，测试跳过" $fileId
         		}
        	}
		if {$testFlag == 0} {
			gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
			send_log "\n resource3:$resource3"
			send_log "\n resource4:$resource4"
			if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
				set flag5_case4	1
				gwd::GWpublic_print "NOK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
			} else {
				gwd::GWpublic_print "OK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
			} 
		}
        }
	puts $fileId ""
	if {$flag5_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD3（结论）反复重启NE1($gpnIp1)NNI/UNI口所在板卡，测试业务恢复和对系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD3（结论）反复重启NE1($gpnIp1)NNI/UNI口所在板卡，测试业务恢复和对系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复重启NE1($gpnIp1)NNI/UNI口所在板卡，测试业务恢复和对系统内存的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行NMS主备倒换，测试业务恢复和对系统内存的影响  测试开始=====\n"
        ###反复进行NMS主备倒换
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_Case4 "第$j\次NE1($gpnIp1)进行NMS主备倒换" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag6_case4 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "5" result
			if {![string match [dict get $result 5 pwOutLabel] 21] || ![string match [dict get $result 5 lspOutLabel] +17]} {
				set flag6_case4 1
				gwd::GWpublic_print "NOK" "VC=5 的pwOutLabel为[dict get $result 5 pwOutLabel] \
						lspOutLabel为[dict get $result 5 lspOutLabel]，NE1($gpnIp1)第$j\次进行NMS主备倒换转发表项异常" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=5 的pwOutLabel为[dict get $result 5 pwOutLabel] \
						lspOutLabel为[dict get $result 5 lspOutLabel]，NE1($gpnIp1)第$j\次进行NMS主备倒换转发表项正常" $fileId
			}
        	} else {
			set testFlag 1
			gwd::GWpublic_print "OK" "$matchType1\不支持NMS主备倒换或只有一块NMS板卡，测试跳过" $fileId
			break
        	}
        }
	if {$testFlag == 0} {
	        gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource6
	        send_log "\n resource5:$resource5"
	        send_log "\n resource6:$resource6"
	        if {$resource6 > [expr $resource5 + $resource5 * $errRate]} {
			set flag6_case4	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
	        }
	}
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD4（结论）NE1($gpnIp1)反复进行NMS主备倒换，测试业务恢复和对系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD4（结论）NE1($gpnIp1)反复进行NMS主备倒换，测试业务恢复和对系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行NMS主备倒换，测试业务恢复和对系统内存的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行SW主备倒换，测试业务恢复和对系统内存的影响  测试开始=====\n"
        ##反复进行SW主备倒换
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	set testFlag 0
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[Test_Case4 "第$j\次NE1($gpnIp1)进行SW主备倒换" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag7_case4 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "5" result
			if {![string match [dict get $result 5 pwOutLabel] 21] || ![string match [dict get $result 5 lspOutLabel] +17]} {
				set flag7_case4 1
				gwd::GWpublic_print "NOK" "VC=5 的pwOutLabel为[dict get $result 5 pwOutLabel] \
						lspOutLabel为[dict get $result 5 lspOutLabel]，NE1($gpnIp1)第$j\次进行SW主备倒换转发表项异常" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=5 的pwOutLabel为[dict get $result 5 pwOutLabel] \
						lspOutLabel为[dict get $result 5 lspOutLabel]，NE1($gpnIp1)第$j\次进行SW主备倒换转发表项正常" $fileId
			}
        	} else {
			set testFlag 1
			gwd::GWpublic_print "OK" "$matchType1\不支持SW主备倒换或只有一块SW板卡，测试跳过" $fileId
			break
        	}
        }
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource8
		send_log "\n resource7:$resource7"
		send_log "\n resource8:$resource8"
		if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
			set flag7_case4	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag7_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD5（结论）NE1($gpnIp1)反复进行SW主备倒换，测试业务恢复和对系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD5（结论）NE1($gpnIp1)反复进行SW主备倒换，测试业务恢复和对系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行SW主备倒换，测试业务恢复和对系统内存的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)反复保存设备重启，测试业务恢复和对系统内存的影响  测试开始=====\n"
        ###配置设备NE2
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource9
        for {set j 1} {$j<=$cnt} {incr j} {
          	gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
          	gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
          	after $rebootTime
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		incr capId
		if {[Test_Case4 "第$j\次NE2($gpnIp2)保存设备重启" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
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
				gwd::GWpublic_print "OK" "转发表项localLable=400 outgoingLable=100 outgoingInterface=$matchPara1 nextHop=192.1.1.1 存在" $fileId
			} else {
				set flag8_case4 1 
				gwd::GWpublic_print "NOK" "未找到转发表项localLable=400 outgoingLable=100 outgoingInterface=$matchPara1 nextHop=192.1.1.1" $fileId
			}
		} else {
			set flag8_case4 1
			gwd::GWpublic_print "NOK" "未找到转发表项localLable=400 outgoingLable=100 outgoingInterface=$matchPara1 nextHop=192.1.1.1" $fileId
		}
		
		if {[dict exists $table $matchPara2]} {
			if {([dict get $table $matchPara2 localLable] == 200) && ([dict get $table $matchPara2 remoteLable] == 300) && ([string match [dict get $table $matchPara2 nextHop] "192.1.2.4"])} {
				gwd::GWpublic_print "OK" "转发表项localLable=200 outgoingLable=300 outgoingInterface=$matchPara2 nextHop=192.1.2.4 存在" $fileId
			} else {
				set flag8_case4 1
				gwd::GWpublic_print "NOK" "未找到转发表项localLable=200 outgoingLable=300 outgoingInterface=$matchPara2 nextHop=192.1.2.4" $fileId
			}
		} else {
			set flag8_case4 1
			gwd::GWpublic_print "NOK" "未找到转发表项localLable=200 outgoingLable=300 outgoingInterface=$matchPara2 nextHop=192.1.2.4 " $fileId
		}
		if {[dict exists $table $matchPara3]} {
			if {([dict get $table $matchPara3 localLable] == 19) && ([dict get $table $matchPara3 remoteLable] == 16) && ([string match [dict get $table $matchPara3 nextHop] "192.1.3.1"])} {
				gwd::GWpublic_print "OK" "转发表项localLable=19 outgoingLable=16 outgoingInterface=$matchPara3 nextHop=192.1.3.1 存在" $fileId
			} else {
				set flag8_case4 1
				gwd::GWpublic_print "NOK" "未找到转发表项localLable=19 outgoingLable=16 outgoingInterface=$matchPara3 nextHop=192.1.3.1" $fileId
			}
		} else {
			set flag8_case4 1
			gwd::GWpublic_print "NOK" "未找到转发表项localLable=19 outgoingLable=16 outgoingInterface=$matchPara3 nextHop=192.1.3.1" $fileId
		}
		if {[dict exists $table $matchPara4]} {
			if {([dict get $table $matchPara4 localLable] == 17) && ([dict get $table $matchPara4 remoteLable] == 18) && ([string match [dict get $table $matchPara4 nextHop] "192.1.4.4"])} {
				gwd::GWpublic_print "OK" "转发表项localLable=17 outgoingLable=18 outgoingInterface=$matchPara4 nextHop=192.1.4.4存在" $fileId
			} else {
				set flag8_case4 1
				gwd::GWpublic_print "NOK" "未找到转发表项localLable=17 outgoingLable=18 outgoingInterface=$matchPara4 nextHop=192.1.4.4" $fileId
			}
		} else {
			set flag8_case4 1
			gwd::GWpublic_print "NOK" "未找到转发表项localLable=17 outgoingLable=18 outgoingInterface=$matchPara4 nextHop=192.1.4.4" $fileId
		}
        }
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag8_case4	1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag8_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD6（结论）NE2($gpnIp2)反复保存设备重启，测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD6（结论）NE2($gpnIp2)反复保存设备重启，测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)反复保存设备重启，测试业务恢复和对系统内存的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
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
	puts $fileId "Test Case 4 新创建E-LINE业务，NNI端口复用时功能及业务恢复测试 测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 新创建E-LINE业务，MS-PW业务测试及业务恢复测试\n"
        #   <1>NNI端口tag方式加入VLAN业务接口；在NE1和NE3之间创建一条E-LINEL业务，在NE2上配置MS-PW
        #   <2>向NE1设备的AC端口发送业务流
        #   预期结果:NE3设备AC端口应接收对应业务流,双向发流业务正常转发
        #   <3>NE1和NE3用户测配置undo vlan check
        #   <4>镜像NE2设备的NNI端口egress方向和ingress方向，验证MS-PW标签交换功能
        #   预期结果:NE2节点能够对NE1发出的报文进行LSP和PW的标签的替换，报文各个字段均正确
        #           比较NE2设备的NNI端口egress方向和ingress方向报文，出方向报文中LSP字段中的TTL值减1，PW字段也中的TTL值减1
        #   <5>在NE2设备配置LSP/PW QOS，系统无异常，功能并生效
        #   <6>在NE2设备使能LSP/PW性能统计，系统无异常，性能统计功能并生效，统计值正确
        #   <7>undo shutdown和shutdown NE2设备的NNI端口50次，系统无异常，业务可恢复 
        #   <8>重启NE1和NE2设备的NNI端口所在板卡50次，系统无异常，业务可恢复
        #   <9>NE2设备进行SW/NMS倒换50次，系统无异常，业务可恢复，查看标签转发表项正确
        #   <10>保存重启NE2设备50次，设备正常启动，配置不丢失，业务正常转发	
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新创建E-LINE业务，MS-PW业务测试  测试开始=====\n"
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
        ###############################################删除7600S配置##############################################################################
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
        ###############################################删除7600-1配置#############################################################################
        #####删除AC
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac10"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac10"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac3000"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac3000"
        ####配置AC
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "" $GPNTestEth3 0 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "pw1" "eline16"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
        ###删除PW
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw10"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw10"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"
        ###删除LSP
        gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp10"
        PTN_DelInterVid $fileId $Worklevel $interface17 $matchType1 $Gpn_type1 $telnet1
        PTN_DelInterVid $fileId $Worklevel $interface21 $matchType1 $Gpn_type1 $telnet1
        PTN_DelInterVid $fileId $Worklevel $interface22 $matchType1 $Gpn_type1 $telnet1
        ###################################################删除7600-3配置######################################################################
        #####删除AC
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1000"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac3000"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac3000"
        ####删除PW
        gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw2"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw2"
        gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
        ###删除LSP
        gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"
        PTN_DelInterVid $fileId $Worklevel $interface16 $matchType3 $Gpn_type3 $telnet3
        PTN_DelInterVid $fileId $Worklevel $interface23 $matchType3 $Gpn_type3 $telnet3
        PTN_DelInterVid $fileId $Worklevel $interface24 $matchType3 $Gpn_type3 $telnet3
        ###配置设备NE2
        set ip1 192.1.1.1
        set ip2 192.1.1.2
        set ip3 192.1.4.3
        set ip4 192.1.4.4
        set address1 10.1.3.1
        set address2 10.1.3.2
        set address3 10.1.3.3
        #############################################配置PE2设备的LSP PW#################################################################### 
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
		gwd::GWpublic_print "NOK" "FD7（结论）新创建E-LINE业务，MS-PW业务测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD7（结论）新创建E-LINE业务，MS-PW业务测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新创建E-LINE业务，MS-PW业务测试  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)$GPNTestEth1\镜像$GPNPort6的入口和$GPNPort7\的出口测试MPLS标签和VLAN  测试开始=====\n"
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2\).pcap" $fileId
        if {$aTmpGPNPort1Cnt2(cnt1) < $rateL1 || $aTmpGPNPort1Cnt2(cnt1) > $rateR1 || $aTmpGPNPort1Cnt2(cnt2) < $rateL1 || $aTmpGPNPort1Cnt2(cnt2) > $rateR1} {
        	set flag2_case5 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1镜像NNI口NE2($gpnIp2)$GPNPort6\入口数据，端口收到的数据打上的双层mpls标签不正确" $fileId
        } else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1镜像NNI口NE2($gpnIp2)$GPNPort6\入口数据，端口收到的数据打上的双层mpls标签正确" $fileId
        }
        if {$aTmpGPNPort1Cnt3(cnt1) < $rateL1 || $aTmpGPNPort1Cnt3(cnt1)> $rateR1 || $aTmpGPNPort1Cnt3(cnt2) < $rateL1 || $aTmpGPNPort1Cnt3(cnt2)> $rateR1} {
		set flag2_case5 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1镜像NNI口NE2($gpnIp2)$GPNPort6\入口数据，端口收到的数据打上vlan标签不正确" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1镜像NNI口NE2($gpnIp2)$GPNPort6\入口数据，端口收到的数据打上vlan标签正确" $fileId
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_1_$capId-p$GPNTestEth1_cap\($gpnIp2\).pcap" $fileId
        if {$aTmpGPNPort1Cnt21(cnt5) < $rateL1 || $aTmpGPNPort1Cnt21(cnt5) > $rateR1 || $aTmpGPNPort1Cnt21(cnt6) < $rateL1 || $aTmpGPNPort1Cnt21(cnt6) > $rateR1} {
		set flag2_case5 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1镜像NNI口NE2($gpnIp2)$GPNPort7\出口数据，端口收到的数据打上的双层mpls标签不正确" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1镜像NNI口NE2($gpnIp2)$GPNPort7\出口数据，端口收到的数据打上的双层mpls标签正确" $fileId
	}
        if {$aTmpGPNPort1Cnt31(cnt5) < $rateL1 || $aTmpGPNPort1Cnt31(cnt5)> $rateR1 || $aTmpGPNPort1Cnt31(cnt6) < $rateL1 || $aTmpGPNPort1Cnt31(cnt6)> $rateR1} {
		set flag2_case5 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth1镜像NNI口NE2($gpnIp2)$GPNPort7\出口数据，端口收到的数据打上的vlan标签不正确" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth1镜像NNI口NE2($gpnIp2)$GPNPort7\出口数据，端口收到的数据打上的vlan标签正确" $fileId
	}
	puts $fileId ""
	if {$flag2_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD8（结论）NE2($gpnIp2)$GPNTestEth1\镜像$GPNPort6的入口和$GPNPort7\的出口测试MPLS标签和VLAN" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD8（结论）NE2($gpnIp2)$GPNTestEth1\镜像$GPNPort6的入口和$GPNPort7\的出口测试MPLS标签和VLAN" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)$GPNTestEth1\镜像$GPNPort6的入口和$GPNPort7\的出口测试MPLS标签和VLAN  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新创建E-LINE业务，MS-PW业务的lsp pw性能统计测试  测试开始=====\n"
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
	
	
	gwd::GWpublic_print [expr {($Lsp1FrameIn == $rx1Cnt) ? "OK" : "NOK"}] "$matchType2\的lsp1的inTotalPkts统计发送数据流前为$GPNLsp1Stat1(-inTotalPkts)\
		发送数据流后为$GPNLsp1Stat2(-inTotalPkts)，差值应为$rx1Cnt\实为$Lsp1FrameIn" $fileId
	gwd::GWpublic_print [expr {($Pw1FrameIn == $rx1Cnt) ? "OK" : "NOK"}] "$matchType2\的pw1的inTotalPkts统计发送数据流前为$GPNPw1Stat1(-inTotalPkts)\
		发送数据流后为$GPNPw1Stat2(-inTotalPkts)，差值应为$rx1Cnt\实为$Pw1FrameIn" $fileId
	gwd::GWpublic_print [expr {($Lsp1FrameOut == $tx1Cnt) ? "OK" : "NOK"}] "$matchType2\的lsp1的outTotalPkts统计发送数据流前为$GPNLsp1Stat1(-outTotalPkts)\
		发送数据流后为$GPNLsp1Stat2(-outTotalPkts)，差值应为$tx1Cnt\实为$Lsp1FrameOut" $fileId
	gwd::GWpublic_print [expr {($Pw1FrameOut == $tx1Cnt) ? "OK" : "NOK"}] "$matchType2\的pw1的outTotalPkts统计发送数据流前为$GPNPw1Stat1(-outTotalPkts)\
		发送数据流后为$GPNPw1Stat2(-outTotalPkts)，差值应为$tx1Cnt\实为$Pw1FrameOut" $fileId
		
	gwd::GWpublic_print [expr {($Lsp10FrameIn == $rx10Cnt) ? "OK" : "NOK"}] "$matchType2\的lsp10的inTotalPkts统计发送数据流前为$GPNLsp10Stat1(-inTotalPkts)\
        	发送数据流后为$GPNLsp10Stat2(-inTotalPkts)，差值应为$rx10Cnt\实为$Lsp10FrameIn" $fileId
        gwd::GWpublic_print [expr {($Pw10FrameIn == $rx10Cnt) ? "OK" : "NOK"}] "$matchType2\的pw10的inTotalPkts统计发送数据流前为$GPNPw10Stat1(-inTotalPkts)\
        	发送数据流后为$GPNPw10Stat2(-inTotalPkts)，差值应为$rx10Cnt\实为$Pw10FrameIn" $fileId
        gwd::GWpublic_print [expr {($Lsp10FrameOut == $tx10Cnt) ? "OK" : "NOK"}] "$matchType2\的lsp10的outTotalPkts统计发送数据流前为$GPNLsp10Stat1(-outTotalPkts)\
        	发送数据流后为$GPNLsp10Stat2(-outTotalPkts)，差值应为$tx10Cnt\实为$Lsp10FrameOut" $fileId
        gwd::GWpublic_print [expr {($Pw10FrameOut == $tx10Cnt) ? "OK" : "NOK"}] "$matchType2\的pw10的outTotalPkts统计发送数据流前为$GPNPw10Stat1(-outTotalPkts)\
        	发送数据流后为$GPNPw10Stat2(-outTotalPkts)，差值应为$tx10Cnt\实为$Pw10FrameOut" $fileId
		
	if {$Lsp1FrameIn != $rx1Cnt || $Pw1FrameIn != $rx1Cnt || $Lsp1FrameOut != $tx1Cnt || $Pw1FrameOut != $tx1Cnt\
		|| $Lsp10FrameIn != $rx10Cnt || $Pw10FrameIn != $rx10Cnt || $Lsp10FrameOut != $tx10Cnt || $Pw10FrameOut != $tx10Cnt} {
		set flag3_case5 1
	}
	
	puts $fileId ""
	if {$flag3_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD9（结论）新创建E-LINE业务，MS-PW业务的lsp pw性能统计测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD9（结论）新创建E-LINE业务，MS-PW业务的lsp pw性能统计测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新创建E-LINE业务，MS-PW业务的lsp pw性能统计测试  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复shutdown/undoshutdown NE2($gpnIp2)的NNI口，测试业务恢复和对系统内存的影响  测试开始=====\n"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream13 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream14 "TRUE"
        ###反复undo shutdown/shutdown端口
        foreach eth $portlist2 {
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
                  	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $eth "shutdown"
                  	gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $eth "undo shutdown"
                  	after $WaiteTime
			incr capId
			if {[Test_Case5 "第$j\次undo shutdown/shutdown NE2($gpnIp2)的$eth\端口" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag4_case5 1
			}
        	}
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag4_case5 1
			gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown NE2($gpnIp2)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "反复shutdown/undo shutdown NE2($gpnIp2)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
		}
        }
	puts $fileId ""
	if {$flag4_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE1（结论）反复shutdown/undoshutdownNE2($gpnIp2)的NNI口，测试业务恢复和对系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE1（结论）反复shutdown/undoshutdownNE2($gpnIp2)的NNI口，测试业务恢复和对系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复shutdown/undoshutdownNE2($gpnIp2)的NNI口，测试业务恢复和对系统内存的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复重启NE2($gpnIp2)NNI口所在板卡，测试业务恢复和对系统内存的影响  测试开始=====\n"
        ###反复重启端口所在板卡
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
				if {[Test_Case5 "第$j\次重启NE2($gpnIp2)$slot\槽位板卡" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
					set flag5_case5 1
				}
         		} else {
				set testFlag 1 
				gwd::GWpublic_print "OK" "NE2($gpnIp2)$slot\槽位板卡不支持板卡重启操作，测试跳过" $fileId
				break
         		}
        	}
		if {$testFlag == 0} {
			gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource4
			send_log "\n resource3:$resource3"
			send_log "\n resource4:$resource4"
			if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
				set flag5_case5	1
				gwd::GWpublic_print "NOK" "反复重启NE2($gpnIp2)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
			} else {
				gwd::GWpublic_print "OK" "反复重启NE2($gpnIp2)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
			} 
		}
        }
	puts $fileId ""
	if {$flag5_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE2（结论）反复重启NE2($gpnIp2)NNI口所在板卡，测试业务恢复和对系统内存的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE2（结论）反复重启NE2($gpnIp2)NNI口所在板卡，测试业务恢复和对系统内存的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====反复重启NE2($gpnIp2)NNI口所在板卡，测试业务恢复和对系统内存的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)反复进行NMS主备倒换，测试业务恢复和对系统内存的影响  测试开始=====\n"
        ###反复进行NMS主备倒换
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource5
	set testFlag 0
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitch $telnet2 $matchType2 $Gpn_type2 $fileId]} {
                  	after $rebootTime
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
			incr capId
			if {[Test_Case5 "第$j\次NE2($gpnIp2)进行NMS主备倒换" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag6_case5 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet2 $matchType2 $Gpn_type2 $fileId "2" result
			if {![string match [dict get $result 2 pwOutLabel] 2000] || ![string match [dict get $result 2 lspOutLabel] +100]} {
				set flag6_case5 1
				gwd::GWpublic_print "NOK" "VC=2 的pwOutLabel为[dict get $result 2 pwOutLabel] \
						lspOutLabel为[dict get $result 2 lspOutLabel]，NE2($gpnIp2)第$j\次进行NMS主备倒换转发表项异常" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=2 的pwOutLabel为[dict get $result 2 pwOutLabel] \
						lspOutLabel为[dict get $result 2 lspOutLabel]，NE2($gpnIp2)第$j\次进行NMS主备倒换转发表项正常" $fileId
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet2 $matchType2 $Gpn_type2 $fileId "5" result
			if {![string match [dict get $result 5 pwOutLabel] 21] || ![string match [dict get $result 5 lspOutLabel] +18]} {
				set flag6_case5 1
				gwd::GWpublic_print "NOK" "VC=5 的pwOutLabel为[dict get $result 5 pwOutLabel] \
						lspOutLabel为[dict get $result 5 lspOutLabel]，NE2($gpnIp2)第$j\次进行NMS主备倒换转发表项异常" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=5 的pwOutLabel为[dict get $result 5 pwOutLabel] \
						lspOutLabel为[dict get $result 5 lspOutLabel]，NE2($gpnIp2)第$j\次进行NMS主备倒换转发表项正常" $fileId
			}
			
        	} else {
			set testFlag 1 
			gwd::GWpublic_print "OK" "NE2($gpnIp2)不支持NMS主备倒换或者只有一块NMS板卡，测试跳过" $fileId
			break
        	}
        }
	if {$testFlag == 0} {
	        gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource6
	        send_log "\n resource5:$resource5"
	        send_log "\n resource6:$resource6"
	        if {$resource6 > [expr $resource5 + $resource5 * $errRate]} {
			set flag6_case5	1
			gwd::GWpublic_print "NOK" "NE2($gpnIp2)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
	        } else {
	        	gwd::GWpublic_print "OK" "NE2($gpnIp2)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
	        }
	}
	puts $fileId ""
	if {$flag6_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE3（结论）NE2($gpnIp2)反复进行NMS主备倒换，测试业务恢复和对系统内存的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE3（结论）NE2($gpnIp2)反复进行NMS主备倒换，测试业务恢复和对系统内存的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)反复进行NMS主备倒换，测试业务恢复和对系统内存的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)反复进行SW主备倒换，测试业务恢复和对系统内存的影响  测试开始=====\n"
        ##反复进行SW主备倒换
	set testFlag 0
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource7
        for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitchSw $telnet2 $matchType2 $Gpn_type2 $fileId]} {
          		after $rebootTime
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
			incr capId
			if {[Test_Case5 "第$j\次NE2($gpnIp2)进行SW主备倒换" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
				set flag7_case5 1
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet2 $matchType2 $Gpn_type2 $fileId "2" result
			if {![string match [dict get $result 2 pwOutLabel] 2000] || ![string match [dict get $result 2 lspOutLabel] +100]} {
				set flag7_case5 1
				gwd::GWpublic_print "NOK" "VC=2 的pwOutLabel为[dict get $result 2 pwOutLabel] \
						lspOutLabel为[dict get $result 2 lspOutLabel]，NE2($gpnIp2)第$j\次进行SW主备倒换转发表项异常" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=2 的pwOutLabel为[dict get $result 2 pwOutLabel] \
						lspOutLabel为[dict get $result 2 lspOutLabel]，NE2($gpnIp2)第$j\次进行SW主备倒换转发表项正常" $fileId
			}
			gwd::GWpublic_QueryMPLSForwardTable $telnet2 $matchType2 $Gpn_type2 $fileId "5" result
			if {![string match [dict get $result 5 pwOutLabel] 21] || ![string match [dict get $result 5 lspOutLabel] +18]} {
				set flag7_case5 1
				gwd::GWpublic_print "NOK" "VC=5 的pwOutLabel为[dict get $result 5 pwOutLabel] \
						lspOutLabel为[dict get $result 5 lspOutLabel]，NE2($gpnIp2)第$j\次进行SW主备倒换转发表项异常" $fileId
			} else {
				gwd::GWpublic_print "OK" "VC=5 的pwOutLabel为[dict get $result 5 pwOutLabel] \
						lspOutLabel为[dict get $result 5 lspOutLabel]，NE2($gpnIp2)第$j\次进行SW主备倒换转发表项正常" $fileId
			}
        	} else {
			set testFlag 1 
			gwd::GWpublic_print "OK" "NE2($gpnIp2)不支持SW主备倒换或者只有一块NMS板卡，测试跳过" $fileId
			break
        	}
        }
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource8
		send_log "\n resource7:$resource7"
		send_log "\n resource8:$resource8"
		if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
			set flag7_case5	1
			gwd::GWpublic_print "NOK" "NE2($gpnIp2)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($gpnIp2)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag7_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE4（结论）NE2($gpnIp2)反复进行SW主备倒换，测试业务恢复和对系统内存的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE4（结论）NE2($gpnIp2)反复进行SW主备倒换，测试业务恢复和对系统内存的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)反复进行SW主备倒换，测试业务恢复和对系统内存的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)反复保存设备重启，测试业务恢复和对系统内存的影响  测试开始=====\n"
        ##反复保存设备重启
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource9
        for {set j 1} {$j<=$cnt} {incr j} {
          	gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
          	gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
          	after $rebootTime
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		incr capId
		if {[Test_Case5 "第$j\次NE2($gpnIp2)保存设备重启" $rateL $rateR "GPN_PTN_002_1_$capId"]} {
			set flag8_case5 1
		}
		gwd::GWpublic_QueryMPLSForwardTable $telnet2 $matchType2 $Gpn_type2 $fileId "2" result
		if {![string match [dict get $result 2 pwOutLabel] 2000] || ![string match [dict get $result 2 lspOutLabel] +100]} {
			set flag8_case5 1
			gwd::GWpublic_print "NOK" "VC=2 的pwOutLabel为[dict get $result 2 pwOutLabel] \
					lspOutLabel为[dict get $result 2 lspOutLabel]，NE2($gpnIp2)第$j\次保存设备重启转发表项异常" $fileId
		} else {
			gwd::GWpublic_print "OK" "VC=2 的pwOutLabel为[dict get $result 2 pwOutLabel] \
					lspOutLabel为[dict get $result 2 lspOutLabel]，NE2($gpnIp2)第$j\次保存设备重启转发表项正常" $fileId
		}
		gwd::GWpublic_QueryMPLSForwardTable $telnet2 $matchType2 $Gpn_type2 $fileId "5" result
		if {![string match [dict get $result 5 pwOutLabel] 21] || ![string match [dict get $result 5 lspOutLabel] +18]} {
			set flag8_case5 1
			gwd::GWpublic_print "NOK" "VC=5 的pwOutLabel为[dict get $result 5 pwOutLabel] \
					lspOutLabel为[dict get $result 5 lspOutLabel]，NE2($gpnIp2)第$j\次保存设备重启转发表项异常" $fileId
		} else {
			gwd::GWpublic_print "OK" "VC=5 的pwOutLabel为[dict get $result 5 pwOutLabel] \
					lspOutLabel为[dict get $result 5 lspOutLabel]，NE2($gpnIp2)第$j\次保存设备重启转发表项正常" $fileId
		}
        }
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag8_case5	1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag8_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FE5（结论）NE2($gpnIp2)反复保存设备重启，测试业务恢复和对系统内存的影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE5（结论）NE2($gpnIp2)反复保存设备重启，测试业务恢复和对系统内存的影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE2($gpnIp2)反复保存设备重启，测试业务恢复和对系统内存的影响  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_1_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_1" lFailFileTmp]
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
	puts $fileId "Test Case 5 新创建E-LINE业务，MS-PW业务测试及业务恢复测试测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===恢复初始化配置...\n"
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
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "测试结束后配置恢复" "测试结束后配置恢复" "GPN_PTN_002_1"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "测试过程中所有配置文件都上传成功" "GPN_PTN_002_1"
	chan seek $fileId 0
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "T3_GPN_PTN_ELINE_002_1测试目的：E-LINE功能验证 LSP PW交换测试\n "
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1 == 1 || $flagCase2 == 1 || $flagCase3 == 1 || $flagCase4 == 1 || $flagCase5 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_002_1测试结果" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5测试结果" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "（结论）vctype为tagged模式(NE1:PORT----NE3:PORT+VLAN)测试业务" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "（结论）vctype为tagged时测试overlay功能" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "（结论）vctype为tagged性能统计功能" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "（结论）vctype为tagged时设备添加的mpls标签" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "（结论）vctype为tagged时反复shutdown/undoshutdown端口后业务恢复和系统内存测试" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "（结论）vctype为tagged时反复重启业务端口所在板卡后业务恢复和系统内存测试" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag7_case1 == 1) ? "NOK" : "OK"}]" "（结论）vctype为tagged时反复NMS主备倒换后业务恢复、mpls转发表项、系统内存测试" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag8_case1 == 1) ? "NOK" : "OK"}]" "（结论）vctype为tagged时反复SW主备倒换后业务恢复、mpls转发表项、系统内存测试" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag9_case1 == 1) ? "NOK" : "OK"}]" "（结论）vctype为tagged时反复进行保存设备重启后业务恢复、mpls转发表项、系统内存测试" $fileId
	gwd::GWpublic_print "== FB1 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "（结论）vctype为tagged模式(NE1:PORT+VLAN----NE3:PORT+VLAN)测试业务" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "（结论）vctype为tagged模式(NE1:PORT----NE3:PORT)测试业务" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "（结论）vctype为tagged模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)测试业务" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "（结论）vctype为tagged模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)测试业务" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "（结论）vctype为raw模式(NE1:PORT----NE3:PORT)测试业务" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "（结论）vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN)测试业务" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag7_case2 == 1) ? "NOK" : "OK"}]" "（结论）vctype为raw模式(NE1:PORT+VLAN----NE3:PORT+VLAN NE2配置PW12环回)测试业务" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag8_case2 == 1) ? "NOK" : "OK"}]" "（结论）vctype为raw模式(NE1:PORT+VLAN----NE3:PORT)测试业务" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag9_case2 == 1) ? "NOK" : "OK"}]" "（结论）vctype为raw模式(NE1:PORT+VLAN1----NE3:PORT+VLAN2)测试业务" $fileId
	gwd::GWpublic_print "== FC1 == [expr {($flag10_case2 == 1) ? "NOK" : "OK"}]" "（结论）vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)测试业务" $fileId
	gwd::GWpublic_print "== FC2 == [expr {($flag11_case2 == 1) ? "NOK" : "OK"}]" "（结论）保留之前的PW1：vctype为raw模式(NE1:PORT+SVLAN+CVLAN----NE3:PORT+SVLAN+CVLAN)，新建一条不配置vctype的PW2测试业务" $fileId
	gwd::GWpublic_print "== FC3 == [expr {($flag12_case2 == 1) ? "NOK" : "OK"}]" "（结论）两条PW配置，反复shutdown/undo shutdown NE3($gpnIp3)UNI和NNI口后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FC4 == [expr {($flag13_case2 == 1) ? "NOK" : "OK"}]" "（结论）两条PW配置，反复重启 NE3($gpnIp3)UNI和NNI口所在板卡后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FC5 == [expr {($flag14_case2 == 1) ? "NOK" : "OK"}]" "（结论）两条PW配置， NE3($gpnIp3)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FC6 == [expr {($flag15_case2 == 1) ? "NOK" : "OK"}]" "（结论）两条PW配置， NE3($gpnIp3)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FC7 == [expr {($flag16_case2 == 1) ? "NOK" : "OK"}]" "（结论）两条PW配置， NE3($gpnIp3)反复保存设备重启测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FC8 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "（结论）两条ELine业务，NNI口复用测试业务" $fileId
	gwd::GWpublic_print "== FC9 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "（结论）新创建E-LINE业务的端口性能统计功能正确" $fileId
	gwd::GWpublic_print "== FD1 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "（结论）测试新创建E-LINE业务NNI口添加的mpls标签和vlan" $fileId
	gwd::GWpublic_print "== FD2 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "（结论）反复shutdown/undoshutdownNE2($gpnIp2)的NNI口，测试业务恢复和对系统内存" $fileId
	gwd::GWpublic_print "== FD3 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "（结论）反复重启NE1($gpnIp1)NNI/UNI口所在板卡，测试业务恢复和对系统内存" $fileId
	gwd::GWpublic_print "== FD4 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)反复进行NMS主备倒换，测试业务恢复和对系统内存" $fileId
	gwd::GWpublic_print "== FD5 == [expr {($flag7_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)反复进行SW主备倒换，测试业务恢复和对系统内存" $fileId
	gwd::GWpublic_print "== FD6 == [expr {($flag8_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE2($gpnIp2)反复保存设备重启，测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FD7 == [expr {($flag1_case5 == 1) ? "NOK" : "OK"}]" "（结论）新创建E-LINE业务，MS-PW业务测试" $fileId
	gwd::GWpublic_print "== FD8 == [expr {($flag2_case5 == 1) ? "NOK" : "OK"}]" "（结论）NE2($gpnIp2)$GPNTestEth1\镜像$GPNPort6的入口和$GPNPort7\的出口测试MPLS标签和VLAN" $fileId
	gwd::GWpublic_print "== FD9 == [expr {($flag3_case5 == 1) ? "NOK" : "OK"}]" "（结论）新创建E-LINE业务，MS-PW业务测试端口性能统计" $fileId
	gwd::GWpublic_print "== FE1 == [expr {($flag4_case5 == 1) ? "NOK" : "OK"}]" "（结论）反复shutdown/undoshutdownNE2($gpnIp2)的NNI口，测试业务恢复和对系统内存" $fileId
	gwd::GWpublic_print "== FE2 == [expr {($flag5_case5 == 1) ? "NOK" : "OK"}]" "（结论）反复重启NE2($gpnIp2)NNI口所在板卡，测试业务恢复和对系统内存的影响" $fileId
	gwd::GWpublic_print "== FE3 == [expr {($flag6_case5 == 1) ? "NOK" : "OK"}]" "（结论）NE2($gpnIp2)反复进行NMS主备倒换，测试业务恢复和对系统内存的影响" $fileId
	gwd::GWpublic_print "== FE4 == [expr {($flag7_case5 == 1) ? "NOK" : "OK"}]" "（结论）NE2($gpnIp2)反复进行SW主备倒换，测试业务恢复和对系统内存的影响" $fileId
	gwd::GWpublic_print "== FE5 == [expr {($flag8_case5 == 1) ? "NOK" : "OK"}]" "（结论）NE2($gpnIp2)反复保存设备重启，测试业务恢复和对系统内存的影响" $fileId
	gwd::GWpublic_print "== FE6 == [expr {($flag10_case1 == 1) ? "NOK" : "OK"}]" "（结论）检查经过LSP交换前后LSP和PW的TTL值的测试" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "（结论）测试结束后配置恢复" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "（结论）测试过程中配置文件的上传" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "运行异常：错误为$err" "" "GPN_PTN_002_1"
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
