#!/bin/sh
# T4_GPN_PTN_ETREE_011.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#测试目的：E-TREE的功能-VLAN动作验证
#1-AC VLAN动作验证  
#2-8fx作为ac端口 ，AC vlan动作验证(未覆盖)
#3-PW VLAN动作验证
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
##AC VLAN动作验证###
##AC VLAN动作为不变
#   <1>配置NE1到NE2/NE3/NE4的evp-tree业务,NNI口以tag方式加入vlanIF,PW和AC的VLAN动作均为不变
#   <2>向NE1根端口发送带有untag tag100（TPID为0x8100）tag100（TPID为0x9100）tag100（TPID为0x8100） 的3条数据流，观察NE2、NE4的叶子端口接收结果
#   预期结果：只可接收到带有tag100（TPID为0x8100）数据流
#   <3>镜像NE1的NNI端口egress方向报文
#   预期结果：为带VLAN TAG标签并打上两层mpls标签报文，外层lsp标签17，内层pw标签1000
##AC VLAN动作为删除
#   <4>在不删除vpls的情况下，删除NE2设备的汇聚业务（AC），查看配置删除成功，NE2的业务中断；重新添加ac，更改为AC的VLAN动作为删除，(pw为root ac为leaf)其他配置信息保持不变
#   <5>向NE1的root端口发送带有tag100（TPID为0x8100）并匹配数据流，观察NE2/NE3/NE4的叶子端口接收结果
#   预期结果：NE2接收到untag数据流；NE4接收到tag100的数据流；
#   <6>镜像NE1两个NNI端口egree方向的数据流
#   预期结果：业务流都是带tag100的标签的
##AC VLAN动作为修改
#   <7>在不删除vpls的情况下，删除NE4设备的汇聚业务（AC），更改AC的VLAN动作为修改（修改为 VID=80），其他配置信息保持不变
#   <8>向NE1的root端口发送带有VID 100（TPID为0x8100）并匹配规则数据流，观察NE2/NE3/NE4的叶子端口接收结果，
#   预期结果：NE2接收到untag的数据流；NE4端口接收到vid80的数据流；
#   <8>镜像NE1两个NNI端口egree方向的数据流
#   预期结果：业务流都是带tag100的标签的
##AC VLAN动作为添加
#   <9>删除NE2设备的专网业务（AC），更改NE2AC的VLAN动作为添加（添加VID=100），匹配TPID为9100，(pw为root ac为leaf)其他配置信息保持不变
#   <10>向NE1的root端口发送带有VID 100（TPID为0x8100）并匹配规则数据流，观察NE2/NE3/NE4的叶子端口接收结果，
#   预期结果：NE3可接收到带有双层标签的数据流（外层200，内层100）；NE2接收到untag的数据流;NE4收到tag80的数据流；
#   <11>镜像NE1两个NNI端口egree方向的数据流
#   预期结果：业务流都是带tag100的标签的
#   <12>NE2、NE3、NE4设备在配置ac动作后，SW/NMS倒换10次（软/硬倒换），ac动作均正确生效
#   <13>保存配置，重启设备，查看配置仍正确且动作生效
#2、搭建Test Case 2测试环境
##8fx作为ac端口 ，ac vlan动作验证
#   <14>删除NE1与NE2的E-tree业务（vpls和ac），查看配置，业务成功删除
#   <15>重新配置NE1到NE2的Evp-Tree业务，NE1的ac端口为4ge口，NE2的ac端口为8fx端口，开启mpls使能，其余配置不变
#   <16>配置NE2的ac端口VLAN动作为不变，NE1的UNI端口发送tag100（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果
#   预期结果：可接收到带有tag100的数据流
#   <17>配置NE2的ac端口VLAN动作为添加（只能添加vlan id为4078-4085），向NE1的UNI端口发送tag100（TPID为0x8100）的数据流，观察NE2的UNI端口接收结果
#   预期结果：可接收到tag100的数据流；添加为其他vlan，业务不通
#   <18>配置NE2的ac端口VLAN动作为修改（只能修改为4078-4085），向NE1的UNI端口发送tag 100（TPID为0x8100）的数据流，观察NE2的UNI端口接收结果
#   预期结果：可接收到untag数据流；修改为其他vlan，业务不通
#   <19>当NE1的AC口为8fx口，重复步骤16-18的操作
#   <20>由于NE1的ac端口也为8fx端口，业务vlan已经带上了vlan4078的标签，需在PW上做VLAN删除处理，删除vlan4078，最后NE2上8fx端口接收到的数据流与16-18的一致
#3、搭建Test Case 3测试环境
##PW VLAN动作验证###
##PW VLAN动作为不变
#   <1>删除4台设备的所配置汇聚业务（vpls、AC）和伪线，删除成功，系统无异常
#   <2>再次配置4台设备的E-Tree业务，PW和AC的VLAN动作均为不变，ac绑定的vlan为100
#   <3>向NE1的root端口发送带有VID 100（TPID为0x8100）并匹配规则数据流，观察NE2、NE4的叶子端口接收结果
#   预期结果：NE2、NE3、NE4可接收到tag100的数据流；
#   <4>镜像NE1两个NNI端口egree方向的数据流
#   预期结果：业务流都是带tag100的标签的
##PW VLAN动作为删除
#   <5>删除NE1设备的汇聚业务（vpls）和伪线（PW1），更改PW1的VLAN动作为删除，(pw为none ac为none)其他配置信息保持不变
#   <6>向NE1的root端口发送带有VID 100（TPID为0x8100）并匹配规则数据流，观察NE2、NE3、NE4的叶子端口接收结果
#   预期结果：NE2收到untag的数据流，Ne3、NE4收到tag100的数据流
#   <7>镜像NE1两个NNI端口egree方向的数据流
#   预期结果：承载pw1的nni口出方向的业务流都是不带标签的，承载pw2、pw3的nni口出方向的业务流带tag100的标签
##PW VLAN动作为修改
#   <8>删除NE1设备的汇聚业务（vpls）和伪线（PW2），更改PW2的VLAN动作为修改（修改为 VID=80），其他配置信息保持不变
#   <9>向NE1的root端口发送带有VID 100（TPID为0x8100）并匹配规则数据流，观察NE2、NE3、NE4的叶子端口接收结果
#   预期结果：NE2收到untag的数据流，NE4收到tag80的数据流，NE3收到tag100的数据流
#   <10>镜像NE1两个NNI端口egree方向的数据流，\
#   预期结果：承载pw1的nni口出方向的业务流都是不带标签的，承载pw2的nni口出方向的业务流带tag80的标签，承载pw3的nni口出方向的业务流带tag100的标签
##PW VLAN动作为添加
#   <11>删除NE1设备的汇聚业务（vpls）和伪线（PW3），更改PW3的VLAN动作为添加（添加VID=200），更改AC的匹配TPID为0x9100，其他配置信息保持不变
#   <12>向NE1的root端口发送带有VID 100（TPID为0x8100）并匹配规则数据流，观察NE2、NE3、NE4的叶子端口接收结果
#   预期结果：NE3收到双层标签的数据流（外层200，内层100），NE2收到untag的数据流，NE4收到tag80的数据流
#   <13>镜像NE1两个NNI端口egree方向的数据流
#   预期结果：承载pw3的nni口出方向的业务流都带两层标签（外层200，内层100），承载pw2的nni口出方向的业务流带tag80的标签，承载pw1的nni口出方向的业务流不带标签，
#   <14>NE1设备在配置pw动作后，SW/NMS倒换10次（软/硬倒换），pw动作均正确生效
#   <15>保存配置，重启设备，查看配置仍正确且动作生效
#   <16>在用户侧端口接入模式为“端口+运营商VLAN+客户VLAN”下，分别验证PW/AC的VLAN动作删除、添加、修改、不变均生效
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_011_LOG.txt" a]
        set stdout $fd_log
        chan configure $fd_log -blocking 0 -buffering none;#非阻塞模式 按行flush
        log_file log\\GPN_PTN_011_LOG.txt
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_011_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#非阻塞模式 按行flush
        
        file mkdir "debug"
        set fd_debug [open debug\\GPN_PTN_011_DEBUG.txt a]
        exp_internal -f debug\\GPN_PTN_011_DEBUG.txt 0
        chan configure $fd_debug -blocking 0 -buffering none;#非阻塞模式 按行flush
        
	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl
        ###数据流设置
        array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
        array set dataArr2 {-srcMac "00:00:00:00:00:0c" -dstMac "00:00:00:00:00:cc" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "100" -pri "000"}
        array set dataArr3 {-srcMac "00:00:00:00:00:F2" -dstMac "00:00:00:00:F2:F2" -srcIp "192.85.1.3" -dstIp "192.0.0.3" -vid "100" -pri "000" -type "9100"}
        array set dataArr4 {-srcMac "00:00:00:00:00:26" -dstMac "00:00:00:00:F3:F3" -srcIp "192.85.1.4" -dstIp "192.0.0.4" -vid1 "800" -pri1 "000" -vid2 "500" -pri2 "000"}
        array set dataArr5 {-srcMac "00:00:00:00:00:dd" -dstMac "00:00:00:00:00:0d" -srcIp "192.85.1.5" -dstIp "192.0.0.5" -vid "100" -pri "000"}
        array set dataArr6 {-srcMac "00:00:00:00:04:05" -dstMac "00:00:00:00:01:05" -srcIp "192.85.1.6" -dstIp "192.0.0.6" -vid1 "800" -pri1 "000" -vid2 "500" -pri2 "000"}
        array set dataArr7 {-srcMac "00:00:00:00:00:0d" -dstMac "00:00:00:00:00:dd" -srcIp "192.85.1.7" -dstIp "192.0.0.7" -vid "100" -pri "000"}
        array set dataArr8 {-srcMac "00:00:00:00:01:05" -dstMac "00:00:00:00:04:05" -srcIp "192.85.1.8" -dstIp "192.0.0.8" -vid1 "800" -pri1 "000" -vid2 "500" -pri2 "000"}
        ###设置定制信息参数
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        ###设置发生器参数
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
	set rateL0 91000000;#收发数据流取值最小值范围
	set rateR0 106000000;#收发数据流取值最大值范围
	
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
	regsub {/} $GPNTestEth5 {_} GPNTestEth5_cap
	regsub {/} $GPNTestEth6 {_} GPNTestEth6_cap
	
	########################################################################################################
	#函数功能：用户接入模式为PORT+SVLAN+CVLAN的AC和PW的动作
	#输入参数:       ifAc ：VLAN动作类型 AC/PW =1 ac动作    =0 pw动作
	#               动作类型 ：add/nochange/delete/modify
	#               lStream ：发送的数据流
	#返回值：flag =0 业务验证正确   =1业务验证有误
	#作者：吴军妮 
	########################################################################################################
	proc SvlanCvlanActiveChange {fileId ifAc action caseId rateL rateR} {
		global gpnIp1
		global gpnIp2
		global gpnIp3
		global gpnIp4
		global GPNTestEth1
		global GPNTestEth2
		global GPNTestEth3
		global GPNTestEth4
		set flag 0
		
		incr capId
		#分析单层vlan报文
		SendAndStat_ptn006 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
			$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $::anaFliFrameCfg1 $caseId
		#分析只匹配smac的报文
		SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
			$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $::anaFliFrameCfg0 $caseId
		#分析双层vlan报文
		SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
			$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt2 GPNPort2Cnt2 GPNPort3Cnt2 GPNPort4Cnt2 6 $::anaFliFrameCfg6 $caseId
		#分析untag报文
		SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
			$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 7 $::anaFliFrameCfg7 $caseId
		if {[string match $action "add"]} {
			#分析3层报文
			SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
				$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
				$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt3 GPNPort2Cnt3 GPNPort3Cnt3 GPNPort4Cnt3 1 $::anaFliFrameCfg4 $caseId
		}
				
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		#NE1的接收
		if {($ifAc == 0) && [string match $action "add"]} {
			if {$GPNPort1Cnt3(cnt24) < $rateL || $GPNPort1Cnt3(cnt24) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE1($gpnIp1)$GPNTestEth1\
					收到tag=800 800 500的数据流的速率为$GPNPort1Cnt3(cnt24)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE1($gpnIp1)$GPNTestEth1\
					收到tag=800 800 500的数据流的速率为$GPNPort1Cnt3(cnt24)，在$rateL-$rateR\范围内" $fileId
			}
		} else {
			if {$GPNPort1Cnt2(cnt42) < $rateL || $GPNPort1Cnt2(cnt42) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE1($gpnIp1)$GPNTestEth1\
					收到外层tag=800内层tag=500的数据流的速率为$GPNPort1Cnt2(cnt42)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE1($gpnIp1)$GPNTestEth1\
					收到外层tag=800内层tag=500的数据流的速率为$GPNPort1Cnt2(cnt42)，在$rateL-$rateR\范围内" $fileId
			}
		}
		#NE2接收
		if {[string match $action "nochange"]} {
			if {$GPNPort2Cnt2(cnt12) < $rateL || $GPNPort2Cnt2(cnt12) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE2($gpnIp2)$GPNTestEth2\
					收到外层tag=800内层tag=500的数据流的速率为$GPNPort2Cnt2(cnt12)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE2($gpnIp2)$GPNTestEth2\
					收到外层tag=800内层tag=500的数据流的速率为$GPNPort2Cnt2(cnt12)，在$rateL-$rateR\范围内" $fileId
			}
			if {$GPNPort2Cnt2(cnt10) < $rateL || $GPNPort2Cnt2(cnt10) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播，NE2($gpnIp2)$GPNTestEth2\
					收到外层tag=800内层tag=500的数据流的速率为$GPNPort2Cnt2(cnt10)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播，NE2($gpnIp2)$GPNTestEth2\
					收到外层tag=800内层tag=500的数据流的速率为$GPNPort2Cnt2(cnt10)，在$rateL-$rateR\范围内" $fileId
			}
		} else {
			if {$GPNPort2Cnt1(cnt50) < $rateL || $GPNPort2Cnt1(cnt50) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE2($gpnIp2)$GPNTestEth2\
					收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt50)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE2($gpnIp2)$GPNTestEth2\
					收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt50)，在$rateL-$rateR\范围内" $fileId
			}
			if {$GPNPort2Cnt1(cnt71) < $rateL || $GPNPort2Cnt1(cnt71) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播，NE2($gpnIp2)$GPNTestEth2\
					收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt71)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播，NE2($gpnIp2)$GPNTestEth2\
					收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt71)，在$rateL-$rateR\范围内" $fileId
			}
		}
		
		#NE3的接收
		if {$GPNPort3Cnt0(cnt50) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE1($gpnIp1)$GPNTestEth1\发送的数据流\
				NE3($gpnIp3)$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt50)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE1($gpnIp1)$GPNTestEth1\发送的数据流\
				NE3($gpnIp3)$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt50)" $fileId
		}
		if {$GPNPort3Cnt0(cnt51) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE2($gpnIp2)$GPNTestEth2\发送的数据流\
				NE3($gpnIp3)$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt51)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE2($gpnIp2)$GPNTestEth2\发送的数据流\
				NE3($gpnIp3)$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt51)" $fileId
		}
		if { [string match $action "add"] || [string match $action "modify"]} {
			if {$GPNPort3Cnt2(cnt2) < $rateL || $GPNPort3Cnt2(cnt2) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播，NE3($gpnIp3)$GPNTestEth3\
					收到外层tag=1000内层tag=500的数据流的速率为$GPNPort3Cnt2(cnt2)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播，NE3($gpnIp3)$GPNTestEth3\
					收到外层tag=1000内层tag=500的数据流的速率为$GPNPort3Cnt2(cnt2)，在$rateL-$rateR\范围内" $fileId
			}
		} else {
			if {$GPNPort3Cnt2(cnt10) < $rateL || $GPNPort3Cnt2(cnt10) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播，NE3($gpnIp3)$GPNTestEth3\
					收到外层tag=800内层tag=500的数据流的速率为$GPNPort3Cnt2(cnt10)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播，NE3($gpnIp3)$GPNTestEth3\
					收到外层tag=800内层tag=500的数据流的速率为$GPNPort3Cnt2(cnt10)，在$rateL-$rateR\范围内" $fileId
			}
		}
		
		#NE4的接收
		if {$GPNPort4Cnt0(cnt50) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE1($gpnIp1)$GPNTestEth1\发送的数据流\
				NE4($gpnIp4)$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt50)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE1($gpnIp1)$GPNTestEth1\发送的数据流\
				NE4($gpnIp4)$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt50)" $fileId
		}
		if {$GPNPort4Cnt0(cnt51) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE2($gpnIp2)$GPNTestEth2\发送的数据流\
				NE4($gpnIp4)$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt51)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发外层tag=800内层tag=500的已知单播，NE2($gpnIp2)$GPNTestEth2\发送的数据流\
				NE4($gpnIp4)$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt51)" $fileId
		}
		if {($ifAc==1) && [string match $action "add"]} {
			if {$GPNPort4Cnt3(cnt24) < $rateL || $GPNPort4Cnt3(cnt24) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播，NE4($gpnIp4)$GPNTestEth3\
					收到tag=800 800 500的数据流的速率为$GPNPort4Cnt3(cnt24)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播，NE4($gpnIp4)$GPNTestEth3\
				收到tag=800 800 500的数据流的速率为$GPNPort4Cnt3(cnt24))，在$rateL-$rateR\范围内" $fileId
			}
		} else {
			if {$GPNPort4Cnt2(cnt10) < $rateL || $GPNPort4Cnt2(cnt10) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播，NE4($gpnIp4)$GPNTestEth4\
					收到外层tag=800内层tag=500的数据流的速率为$GPNPort4Cnt2(cnt10)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播，NE4($gpnIp4)$GPNTestEth4\
					收到外层tag=800内层tag=500的数据流的速率为$GPNPort4Cnt2(cnt10)，在$rateL-$rateR\范围内" $fileId
			}
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
	
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "创建测试工程...\n"
	set hPtnProject [stc::create project]
	set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3 \"media $GPNEth3Media\" \
		$GPNStcPort4 \"media $GPNEth4Media\" $GPNStcPort5 \"media $GPNEth5Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4 hGPNPort5
	
        ###创建测试流量
        gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort1 hGPNPort1Stream1
        gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort1 hGPNPort1Stream2
        gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort1 hGPNPort1Stream7
        gwd::STC_Create_VlanTypeStream $fileId dataArr3 $hGPNPort1 hGPNPort1Stream3
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr4 $hGPNPort1 hGPNPort1Stream4
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr8 $hGPNPort1 hGPNPort1Stream8
        gwd::STC_Create_VlanStream $fileId dataArr5 $hGPNPort2 hGPNPort2Stream5
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr6 $hGPNPort2 hGPNPort2Stream6
        set hStreamList "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream3 $hGPNPort1Stream4 $hGPNPort1Stream7 $hGPNPort1Stream8 $hGPNPort2Stream5 $hGPNPort2Stream6"
        set hStreamList1 "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream3"
        set hStreamList2 "$hGPNPort1Stream7 $hGPNPort2Stream5"
        set hStreamList3 "$hGPNPort1Stream4 $hGPNPort1Stream8 $hGPNPort2Stream6"
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
	
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort5 txInfoArr hGPNPort5TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort5 rxInfoArr1 hGPNPort5RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort5 rxInfoArr2 hGPNPort5RxInfo2
        ###配置流的速率 10%，Mbps
	stc::perform streamBlockActivate \
		-streamBlockList "$hStreamList" \
		-activate "false"
        foreach stream $hStreamList {
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
        set hGPNPortAnaFrameCfgFilList "$hGPNPort1AnaFrameCfgFil $hGPNPort2AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil"
        foreach hCfgFil $hGPNPortAnaFrameCfgFilList {
        	gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $anaFliFrameCfg2
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
                set hGPNPortCapList "$hGPNPort1Cap $hGPNPort2Cap $hGPNPort3Cap $hGPNPort4Cap"
                set hGPNPortCapAnalyzerList "$hGPNPort1CapAnalyzer $hGPNPort2CapAnalyzer $hGPNPort3CapAnalyzer $hGPNPort4CapAnalyzer"
        }
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-TREE AC PW动作测试基础配置开始...\n"
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
	set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
	set lMatchType "$matchType1 $matchType2 $matchType3 $matchType4"
	set lDutType "$Gpn_type1 $Gpn_type2 $Gpn_type3 $Gpn_type4"
	set lIp "$gpnIp1 $gpnIp2 $gpnIp3 $gpnIp4"
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-TREE AC PW动作测试基础配置失败，测试结束" \
		"E-TREE AC PW动作测试基础配置成功，继续后面的测试" "GPN_PTN_011"
        puts $fileId ""
        puts $fileId "===E-TREE AC PW动作测试基础配置结束..."
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 ETREE功能：用户侧接入模式为”端口+运营商VLAN，AC VLAN动作验证测试\n"
	##AC VLAN动作为不变
	#   <1>配置NE1到NE2/NE3/NE4的evp-tree业务,NNI口以tag方式加入vlanIF,PW和AC的VLAN动作均为不变
	#   <2>向NE1根端口发送带有untag tag100（TPID为0x8100）tag100（TPID为0x9100） 的3条数据流，观察NE2、NE4的叶子端口接收结果
	#   预期结果：只可接收到带有tag100（TPID为0x8100）数据流
	#   <3>镜像NE1的NNI端口egress方向报文
	#   预期结果：为带VLAN TAG标签并打上两层mpls标签报文，外层lsp标签17，内层pw标签1000
	##AC VLAN动作为删除
	#   <4>在不删除vpls的情况下，删除NE2设备的汇聚业务（AC），查看配置删除成功，NE2的业务中断；重新添加ac，更改为AC的VLAN动作为删除，(pw为root ac为leaf)其他配置信息保持不变
	#   <5>向NE1的root端口发送带有tag100（TPID为0x8100）并匹配数据流，观察NE2/NE3/NE4的叶子端口接收结果
	#   预期结果：NE2接收到untag数据流；NE4接收到tag100的数据流；
	#   <6>镜像NE1两个NNI端口egree方向的数据流
	#   预期结果：业务流都是带tag100的标签的
	##AC VLAN动作为修改
	#   <7>在不删除vpls的情况下，删除NE4设备的汇聚业务（AC），更改AC的VLAN动作为修改（修改为 VID=80），其他配置信息保持不变
	#   <8>向NE1的root端口发送带有VID 100（TPID为0x8100）并匹配规则数据流，观察NE2/NE3/NE4的叶子端口接收结果，
	#   预期结果：NE2接收到untag的数据流；NE4端口接收到vid80的数据流；
	#   <8>镜像NE1两个NNI端口egree方向的数据流
	#   预期结果：业务流都是带tag100的标签的
	##AC VLAN动作为添加
	#   <9>删除NE2设备的专网业务（AC），更改NE2AC的VLAN动作为添加（添加VID=100），匹配TPID为9100，(pw为root ac为leaf)其他配置信息保持不变
	#   <10>向NE1的root端口发送带有VID 100（TPID为0x8100）并匹配规则数据流，观察NE2/NE3/NE4的叶子端口接收结果，
	#   预期结果：NE3可接收到带有双层标签的数据流（外层200，内层100）；NE2接收到untag的数据流;NE4收到tag80的数据流；
	#   <11>镜像NE1两个NNI端口egree方向的数据流
	#   预期结果：业务流都是带tag100的标签的
	#   <12>NE2、NE3、NE4设备在配置ac动作后，SW/NMS倒换10次（软/硬倒换），ac动作均正确生效
	#   <13>保存配置，重启设备，查看配置仍正确且动作生效
        ###二三层接口配置参数
	set flag1_case1 0
	set flag2_case1 0
	set flag3_case1 0
	set flag4_case1 0
	set flag5_case1 0
	set flag6_case1 0
	set flag7_case1 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC模式为port+vlan动作为nochange，测试业务  测试开始=====\n"
        if {[string match "L2" $Worklevel]} {
                set interface3 v100
                set interface4 v500
                set interface5 v800
                set interface6 v100
                set interface7 v500
                set interface8 v800
                set interface9 v100
                set interface10 v500
                set interface11 v800
                set interface12 v100
                set interface13 v500
                set interface14 v800
                set interface15 v4
                set interface16 v7
                set interface17 v4
                set interface18 v5
                set interface19 v5
                set interface20 v7
        } else {
        	set interface3 $GPNTestEth1.100
        	set interface4 $GPNTestEth1.500
        	set interface5 $GPNTestEth1.800
        	set interface6 $GPNTestEth2.100
        	set interface7 $GPNTestEth2.500
        	set interface8 $GPNTestEth2.800
        	set interface9 $GPNTestEth3.100
        	set interface10 $GPNTestEth3.500
        	set interface11 $GPNTestEth3.800
        	set interface12 $GPNTestEth4.100
        	set interface13 $GPNTestEth4.500
        	set interface14 $GPNTestEth4.800
        	set interface15 $GPNPort5.4
        	set interface16 $GPNPort12.7
        	set interface17 $GPNPort6.4
        	set interface18 $GPNPort7.5
        	set interface19 $GPNPort8.5
        	set interface20 $GPNPort11.7
        }
	set id 1
	foreach {port1 port2} $Portlist telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 {vid1 vid2} $Vlanlist {Ip1 Ip2} $Iplist \
			matchType $lMatchType role $RoleList {
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
		PTN_UNI_AddInter $telnet $matchType $Gpn_type $fileId $Worklevel "100" $eth
		gwd::GWVpls_AddInfo $telnet $matchType $Gpn_type $fileId "vpls$id" $id "etree" "flood" "false" "false" "false" "true" "2000" "" ""
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac100" "vpls$id" "" $eth "100" "0" $role "nochange" "1" "0" "0" "0x8100" "evc2"
		incr id
	}
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface15 $ip621 "17" "17" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $interface16 $ip641 "18" "18" "normal" "4"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $address614
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $interface15 $ip621 "20" "21" "normal" "3"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $address613
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "3000" "3000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface17 $ip612 "17" "17" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface18 $ip632 "21" "22" "0" 23 "normal"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface17 $ip612 "23" "20" "0" 21 "normal"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $interface19 $ip623 "22" "23" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $address631
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "3000" "3000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	
	gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $interface20 $ip614 "18" "18" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $address641
	gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "2000" "2000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	stc::perform streamBlockActivate \
		-streamBlockList "$hStreamList1 $hStreamList2" \
		-activate "true"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 1 "nochange" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag1_case1 1
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC模式为port+vlan动作为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC模式为port+vlan动作为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC模式为port+vlan动作为nochange，测试业务  测试结束=====\n"
	incr $tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2的为delete其它为nochange，测试业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac100"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac100" "vpls2" "" $GPNTestEth2 "100" "0" "leaf" "delete" "1" "0" "0" "0x8100" "evc2"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 1 "delete" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag2_case1 1
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2的为delete其它为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2的为delete其它为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2的为delete其它为nochange，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify其它为nochange，测试业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac100"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac100" "vpls3" "" $GPNTestEth3 "100" "0" "leaf" "modify" "800" "0" "0" "0x8100" "evc2"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 1 "modify" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag3_case1 1
	}
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify其它为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify其它为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify其它为nochange，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，测试业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac100"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "2000" "2000" "" "nochange" "root" 1 0 "0x8100" "0x9100" "1"
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac100" "vpls4" "" $GPNTestEth4 "100" "0" "leaf" "add" "800" "0" "0" "0x8100" "evc2"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag4_case1 1
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA4（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复NMS倒换后测试业务  测试开始=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitch $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitch $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitch $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[PTN_EtreeActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag5_case1 1
		}
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA5（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复NMS倒换后测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复NMS倒换后测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复NMS倒换后测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复SW倒换后测试业务  测试开始=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[PTN_EtreeActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag6_case1 1
		}
	}
	puts $fileId ""
	if {$flag6_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA6（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复SW倒换后测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复SW倒换后测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复SW倒换后测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复保存设备重启后测试业务  测试开始=====\n"
	for {set j 1} {$j<$cntdh} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_SaveCfg $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_SaveCfg $telnet4 $matchType4 $Gpn_type4 $fileId
		gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
		set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
		set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
		incr capId
		if {[PTN_EtreeActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag7_case1 1
		}
	}
	puts $fileId ""
	if {$flag7_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA7（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复保存设备重启后测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复保存设备重启后测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复保存设备重启后测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
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
	puts $fileId "Test Case 1 ETREE功能：用户侧接入模式为”端口+运营商VLAN，AC VLAN动作验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2  ETREE功能：用户侧接入模式为”端口+运营商VLAN，PW VLAN动作验证测试\n"
	##PW VLAN动作为不变
	#   <1>删除4台设备的所配置汇聚业务（vpls、AC）和伪线，删除成功，系统无异常
	#   <2>再次配置4台设备的E-Tree业务，PW和AC的VLAN动作均为不变，ac绑定的vlan为100
	#   <3>向NE1的root端口发送带有VID 100（TPID为0x8100）并匹配规则数据流，观察NE2、NE4的叶子端口接收结果
	#   预期结果：NE2、NE3、NE4可接收到tag100的数据流；
	#   <4>镜像NE1两个NNI端口egree方向的数据流
	#   预期结果：业务流都是带tag100的标签的
	##PW VLAN动作为删除
	#   <5>删除NE1设备的汇聚业务（vpls）和伪线（PW1），更改PW1的VLAN动作为删除，(pw为none ac为none)其他配置信息保持不变
	#   <6>向NE1的root端口发送带有VID 100（TPID为0x8100）并匹配规则数据流，观察NE2、NE3、NE4的叶子端口接收结果
	#   预期结果：NE2收到untag的数据流，Ne3、NE4收到tag100的数据流
	#   <7>镜像NE1两个NNI端口egree方向的数据流
	#   预期结果：承载pw1的nni口出方向的业务流都是不带标签的，承载pw2、pw3的nni口出方向的业务流带tag100的标签
	##PW VLAN动作为修改
	#   <8>删除NE1设备的汇聚业务（vpls）和伪线（PW2），更改PW2的VLAN动作为修改（修改为 VID=80），其他配置信息保持不变
	#   <9>向NE1的root端口发送带有VID 100（TPID为0x8100）并匹配规则数据流，观察NE2、NE3、NE4的叶子端口接收结果
	#   预期结果：NE2收到untag的数据流，NE4收到tag80的数据流，NE3收到tag100的数据流
	#   <10>镜像NE1两个NNI端口egree方向的数据流
	#   预期结果：承载pw1的nni口出方向的业务流都是不带标签的，承载pw2的nni口出方向的业务流带tag80的标签，承载pw3的nni口出方向的业务流带tag100的标签
	##PW VLAN动作为添加
	#   <11>删除NE1设备的汇聚业务（vpls）和伪线（PW3），更改PW3的VLAN动作为添加（添加VID=200），更改AC的匹配TPID为0x9100，其他配置信息保持不变
	#   <12>向NE1的root端口发送带有VID 100（TPID为0x8100）并匹配规则数据流，观察NE2、NE3、NE4的叶子端口接收结果
	#   预期结果：NE3收到双层标签的数据流（外层200，内层100），NE2收到untag的数据流，NE4收到tag80的数据流
	#   <13>镜像NE1两个NNI端口egree方向的数据流
	#   预期结果：承载pw3的nni口出方向的业务流都带两层标签（外层200，内层100），承载pw2的nni口出方向的业务流带tag80的标签，承载pw1的nni口出方向的业务流不带标签，
	#   <14>NE1设备在配置pw动作后，SW/NMS倒换10次（软/硬倒换），pw动作均正确生效
	#   <15>保存配置，重启设备，查看配置仍正确且动作生效
	#   <16>在用户侧端口接入模式为“端口+运营商VLAN+客户VLAN”下，分别验证PW/AC的VLAN动作删除、添加、修改、不变均生效
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0
	set flag5_case2 0
	set flag6_case2 0
	set flag7_case2 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、用户接入模式为port+vlan 所有设备PW动作为nochange，测试业务  测试开始=====\n"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "2000" "2000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	set id 1
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType role $RoleList {
		gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac100"
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac100" "vpls$id" "" $eth "100" "0" $role "nochange" "1" "0" "0" "0x8100" "evc2"
		incr id
	}
	incr capId
	if {[PTN_EtreeActiveChange $fileId 0 "nochange" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag1_case2 1
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA8（结论）NE1的AC是root  NE2-NE4的AC是leaf、用户接入模式为port+vlan 所有设备PW动作为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8（结论）NE1的AC是root  NE2-NE4的AC是leaf、用户接入模式为port+vlan 所有设备PW动作为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、用户接入模式为port+vlan 所有设备PW动作为nochange，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete其它为nochange，测试业务  测试开始=====\n"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 0 "delete" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag2_case2 1
	}
	puts $fileId ""
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA9（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete其它为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete其它为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete其它为nochange，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify其它为nochange，测试业务  测试开始=====\n"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "3000" "3000" "" "modify" "none" 800 0 "0x8100" "0x8100" "3"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 0 "modify" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag3_case2 1
	}
	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB1（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify其它为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify其它为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify其它为nochange，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，测试业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac100"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "add" "root" 800 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac100" "vpls2" "" $GPNTestEth2 "100" "0" "leaf" "nochange" "1" "0" "0" "0x9100" "evc2"
	incr capId
	if {[PTN_EtreeActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag4_case2 1
	}
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB2（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复NMS倒换后测试业务  测试开始=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitch $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitch $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitch $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[PTN_EtreeActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag5_case2 1
		}
	}
	puts $fileId ""
	if {$flag5_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB3（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复NMS倒换后测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复NMS倒换后测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复NMS倒换后测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复SW倒换后测试业务  测试开始=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[PTN_EtreeActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag6_case2 1
		}
	}
	puts $fileId ""
	if {$flag6_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB4（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复SW倒换后测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复SW倒换后测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复SW倒换后测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复保存设备重启后测试业务  测试开始=====\n"
	for {set j 1} {$j<$cntdh} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_SaveCfg $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_SaveCfg $telnet4 $matchType4 $Gpn_type4 $fileId
		gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
		set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
		set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
		incr capId
		if {[PTN_EtreeActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag7_case2 1
		}
	}
	puts $fileId ""
	if {$flag7_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB5（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复保存设备重启后测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复保存设备重启后测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复保存设备重启后测试业务  测试结束=====\n"
	incr $tcId
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
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
	puts $fileId "Test Case 2 ETREE功能：用户侧接入模式为”端口+运营商VLAN，PW VLAN动作验证测试   测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3  ETREE功能：用户侧接入模式为PORT+SVLAN+CVLAN，AC VLAN动作验证测试\n"
	set flag1_case3 0
	set flag2_case3 0
	set flag3_case3 0
	set flag4_case3 0
	set flag5_case3 0
	set flag6_case3 0
	set flag7_case3 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC模式为port+svlan+cvlan动作为nochange，测试业务  测试开始=====\n"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "3000" "3000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	
	set id 1
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType role $RoleList {
		gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac100"
		PTN_UNI_AddInter $telnet $matchType $Gpn_type $fileId $Worklevel "800" $eth
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac800" "vpls$id" "" $eth "800" "500" $role "nochange" "1" "0" "0" "0x8100" "evc2"
		incr id
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hStreamList1 $hStreamList2" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hStreamList3" \
		-activate "true"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 1 "nochange" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag1_case3 1
	}
	puts $fileId ""
	if {$flag1_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB6（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC模式为port+svlan+cvlan动作为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC模式为port+svlan+cvlan动作为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC模式为port+svlan+cvlan动作为nochange，测试业务  测试结束=====\n"
	incr $tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2的为delete其它为nochange，测试业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "500" "leaf" "delete" "1" "0" "0" "0x8100" "evc2"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 1 "delete" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag2_case3 1
	}
	puts $fileId ""
	if {$flag2_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB7（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2的为delete其它为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2的为delete其它为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2的为delete其它为nochange，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify其它为nochange，测试业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac800" "vpls3" "" $GPNTestEth3 "800" "500" "leaf" "modify" "1000" "0" "0" "0x8100" "evc2"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 1 "modify" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag3_case3 1
	}
	puts $fileId ""
	if {$flag3_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB8（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify其它为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify其它为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify其它为nochange，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，测试业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "2000" "2000" "" "nochange" "root" 1 0 "0x8100" "0x9100" "1"
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac800" "vpls4" "" $GPNTestEth4 "800" "500" "leaf" "add" "800" "0" "0" "0x8100" "evc2"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag4_case3 1
	}
	puts $fileId ""
	if {$flag4_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB9（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复NMS倒换后测试业务  测试开始=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitch $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitch $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitch $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[SvlanCvlanActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag5_case3 1
		}
	}
	puts $fileId ""
	if {$flag5_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC1（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复NMS倒换后测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复NMS倒换后测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复NMS倒换后测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复SW倒换后测试业务  测试开始=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[SvlanCvlanActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag6_case3 1
		}
	}
	puts $fileId ""
	if {$flag6_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC2（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复SW倒换后测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复SW倒换后测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复SW倒换后测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复保存设备重启后测试业务  测试开始=====\n"
	for {set j 1} {$j<$cntdh} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_SaveCfg $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_SaveCfg $telnet4 $matchType4 $Gpn_type4 $fileId
		gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
		set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
		set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
		incr capId
		if {[SvlanCvlanActiveChange $fileId 1 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag7_case3 1
		}
	}
	puts $fileId ""
	if {$flag7_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC3（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复保存设备重启后测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复保存设备重启后测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复保存设备重启后测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase3 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 3测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 3测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 3  ETREE功能：用户侧接入模式为PORT+SVLAN+CVLAN，AC VLAN动作验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4  ETREE功能：用户侧接入模式为PORT+SVLAN+CVLAN，PW VLAN动作验证测试\n"
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set flag5_case4 0
	set flag6_case4 0
	set flag7_case4 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan 所有设备PW动作为nochange，测试业务  测试开始=====\n"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "2000" "2000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	set id 1
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType role $RoleList {
		gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac800"
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac800" "vpls$id" "" $eth "800" "500" $role "nochange" "1" "0" "0" "0x8100" "evc2"
		incr id
	}
	incr capId
	if {[SvlanCvlanActiveChange $fileId 0 "nochange" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag1_case4 1
	}
	puts $fileId ""
	if {$flag1_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC4（结论）NE1的AC是root  NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan 所有设备PW动作为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4（结论）NE1的AC是root  NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan 所有设备PW动作为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan 所有设备PW动作为nochange，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、NE1的PW12动作为delete其它为nochange，测试业务  测试开始=====\n"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 0 "delete" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag2_case4 1
	}
	puts $fileId ""
	if {$flag2_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC5（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、NE1的PW12动作为delete其它为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、NE1的PW12动作为delete其它为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、NE1的PW12动作为delete其它为nochange，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、NE1的PW12动作为delete PW13为modify其它为nochange，测试业务  测试开始=====\n"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "3000" "3000" "" "modify" "none" 1000 0 "0x8100" "0x8100" "3"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 0 "modify" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag3_case4 1
	}
	puts $fileId ""
	if {$flag3_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC6（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、NE1的PW12动作为delete PW13为modify其它为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、NE1的PW12动作为delete PW13为modify其它为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、NE1的PW12动作为delete PW13为modify其它为nochange，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，测试业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "add" "root" 800 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "500" "leaf" "nochange" "1" "0" "0" "0x9100" "evc2"
	incr capId
	if {[SvlanCvlanActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
		set flag4_case4 1
	}
	puts $fileId ""
	if {$flag4_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC7（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复NMS倒换后测试业务  测试开始=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitch $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitch $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitch $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[SvlanCvlanActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag5_case4 1
		}
	}
	puts $fileId ""
	if {$flag5_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC8（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复NMS倒换后测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复NMS倒换后测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复NMS倒换后测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复SW倒换后测试业务  测试开始=====\n"
	set testFlag1 0
	set testFlag2 0
	set testFlag3 0
	set testFlag4 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {[gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag1 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag2 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet3 $matchType3 $Gpn_type3 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag3 1
		}
		if {[gwd::GWCard_AddSwitchSw $telnet4 $matchType4 $Gpn_type4 $fileId]} {
			gwd::GWpublic_print "OK" "$matchType1\只有一个SW盘，测试跳过" $fileId
			set testFlag4 1
		}
		if {($testFlag1 == 1) && ($testFlag2 == 1) && ($testFlag3 == 1) && ($testFlag4 == 1)} {
			break
		}
		after $rebootTime
		if {$testFlag1 == 0} {
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		}
		if {$testFlag2 == 0} {
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		}
		if {$testFlag3 == 0} {
			set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 2 2 $telnet3]
		}
		if {$testFlag4 == 0} {
			set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 3 3 $telnet4]
		}
		incr capId
		if {[SvlanCvlanActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag6_case4 1
		}
	}
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC9（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复SW倒换后测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC9（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复SW倒换后测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复SW倒换后测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复保存设备重启后测试业务  测试开始=====\n"
	for {set j 1} {$j<$cntdh} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_SaveCfg $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId
		gwd::GWpublic_SaveCfg $telnet4 $matchType4 $Gpn_type4 $fileId
		gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
		set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
		set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
		incr capId
		if {[SvlanCvlanActiveChange $fileId 0 "add" "GPN_PTN_011-$capId" $rateL $rateR]} {
			set flag7_case4 1
		}
	}
	puts $fileId ""
	if {$flag7_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FD1（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复保存设备重启后测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD1（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复保存设备重启后测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复保存设备重启后测试业务  测试结束=====\n"
	incr $tcId
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_011_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_011" lFailFileTmp]
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
	puts $fileId "Test Case 4 ETREE功能：用户侧接入模式为PORT+SVLAN+CVLAN，PW VLAN动作验证测试   测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===恢复初始化配置...\n"
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"] 
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort5.4 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort12.7 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.100 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.800  $matchType1 $Gpn_type1 $telnet1]
	
	lappend flagDel [gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls2"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"] 
	lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort7.5 $ip632 "21" "22" "0" 23 "normal"]
	lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort6.4 $ip612 "23" "20" "0" 21 "normal"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort6.4 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort7.5 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth2.100 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth2.800 $matchType2 $Gpn_type2 $telnet2]
	
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort8.5 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort9.6 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.100 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.800 $matchType3 $Gpn_type3 $telnet3]
	
	lappend flagDel [gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls4"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"] 
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort10.6 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort11.7 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth4.100 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth4.800 $matchType4 $Gpn_type4 $telnet4]
	
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
		foreach port $portList44 {
			lappend flagDel [gwd::GWL2_AddPort $telnet4 $matchType4 $Gpn_type4 $fileId $port "enable" "disable"]
		}
	}

	if {[string match "L2" $Worklevel]}  {
        	foreach {port1 port2} $Portlist telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType {
        		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port1 "none"]
        		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port2 "none"]
        	}
	}
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "测试结束后配置恢复" "测试结束后配置恢复" "GPN_PTN_011"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "测试过程中所有配置文件都上传成功" "GPN_PTN_011"
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_011测试目的：E-TREE的AC PW动作测试\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1==1 || $flagCase2==1 || $flagCase3==1 || $flagCase4==1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_011测试结果" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4测试结果" $fileId
	gwd::GWpublic_print [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}] "测试结束后配置恢复" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式为port+vlan动作为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2的为delete其它为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify其它为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，测试业务" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复NMS倒换后测试业务" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复SW倒换后测试业务" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag7_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+vlan、AC动作：NE2为delete NE3为modify NE4为add，反复保存设备重启后测试业务" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、用户接入模式为port+vlan 所有设备PW动作为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete其它为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FB1 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify其它为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复NMS倒换后测试业务" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复SW倒换后测试业务" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag7_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+vlan、NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复保存设备重启后测试业务" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC模式为port+svlan+cvlan动作为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag2_case3 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2的为delete其它为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag3_case3 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify其它为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag4_case3 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，测试业务" $fileId
	gwd::GWpublic_print "== FC1 == [expr {($flag5_case3 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复NMS倒换后测试业务" $fileId
	gwd::GWpublic_print "== FC2 == [expr {($flag6_case3 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复SW倒换后测试业务" $fileId
	gwd::GWpublic_print "== FC3 == [expr {($flag7_case3 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC模式：port+svlan+cvlan、AC动作：NE2为delete NE3为modify NE4为add，反复保存设备重启后测试业务" $fileId
	gwd::GWpublic_print "== FC4 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan 所有设备PW动作为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FC5 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、NE1的PW12动作为delete其它为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FC6 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、NE1的PW12动作为delete PW13为modify其它为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FC7 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，测试业务" $fileId
	gwd::GWpublic_print "== FC8 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复NMS倒换后测试业务" $fileId
	gwd::GWpublic_print "== FC9 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复SW倒换后测试业务" $fileId
	gwd::GWpublic_print "== FD1 == [expr {($flag7_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、用户接入模式为port+svlan+cvlan、PW动作：NE1的PW12动作为delete PW13为modify NE2的PW21为add 其它为nochange，反复保存设备重启后测试业务" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "（结论）测试结束后配置恢复" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "（结论）测试过程中配置文件的上传" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "运行异常：错误为$err" "" "GPN_PTN_011"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_011_REPORT.txt" "report\\NOK_GPN_PTN_011_REPORT.txt"
	file rename "log\\GPN_PTN_011_LOG.txt" "log\\NOK_GPN_PTN_011_LOG.txt"
} else {
	file rename "report\\GPN_PTN_011_REPORT.txt" "report\\OK_GPN_PTN_011_REPORT.txt"
	file rename "log\\GPN_PTN_011_LOG.txt" "log\\OK_GPN_PTN_011_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}

