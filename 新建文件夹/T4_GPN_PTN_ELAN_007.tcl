#!/bin/sh
# T4_GPN_PTN_ELAN_007.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#测试目的：ELAN的VLAN动作验证
#1-AC VLAN动作验证  
#2-PW VLAN动作验证
#3-多域业务验证
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
#   <1>创建NE1到NE2之间的一条E-LAN业务
#   <2>配置NE1的LSP1入标签100，出标签100；PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，
#      用户侧（GE端口）接入模式为“端口模式+运营商VLAN”端口模式，运营商VLAN为 VLAN 50；
#      配置NE2的LSP1入标签100，出标签100；PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，
#      用户侧（GE端口）接入模式为“端口模式+运营商VLAN”端口模式，运营商VLAN为 VLAN 50；
#   <3>向NE1UNI端口发送带有untag、tag50（TPID为0x8100）tag50（TPID为0x9100） tag60 四条数据流，观察NE2的UNI端口接收结果
#   预期结果：只可接收到带有tag50（TPID为0x8100）数据流
#   <4>向NE2的ac口发送以上数据流，NE1端口接收结果同上
#   <5>镜像NE1的NNI端口egress方向报文，为VLAN TAG=50标签并打上两层mpls标签报文，外层lsp标签100，内层pw标签1000
##AC VLAN动作为删除
#   <6>删除NE2设备的专网业务（AC），更改为NE2的AC的VLAN动作为删除，其他配置信息保持不变，mac规则为丢弃
#   <7>向NE1UNI发送带有tag50（TPID为0x8100）并匹配数据流，观察NE2UNI端口接收结果，
#   预期结果：可接收到untag数据流；向NE1的UNI端口发送untag 、 tag50（TPID为0x9100） tag100数据流，观察NE2、NE3的UNI端口接收结果，未收到数据流  
##AC VLAN动作为修改
#   <8>删除NE2设备的专网业务（AC），更改NE2的AC的VLAN动作为修改（修改为 VID=80），其他配置信息保持不变
#   <9>向NE1的UNI端口发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果，
#   预期结果：可接收到带有VID 80数据流；向NE1的UNI端口发送untag 、 tag50（TPID为0x9100） tag100数据流，观察NE2的UNI端口接收结果，未收到数据流
##AC VLAN动作为添加
#   <10>删除NE2设备的专网业务（AC），更改NE2AC的VLAN动作为添加（添加VID=100），匹配TPID为9100，其他配置信息保持不变
#   <11>向NE1的UNI端口发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果，
#   预期结果：可接收到带有双层标签的数据流（外层100，内层50）；向NE1的UNI端口发送untag 、tag50（TPID为0x9100）tag100数据流，观察NE2、NE3的UNI端口接收结果，未收到数据流
#   <12>删除NE1、NE2的ELAN 业务，查看底层，业务成功删除
##8fx作为ac端口 ，ac vlan动作验证
#   <13>重新配置NE1到NE2的E-LAN业务，NE1的ac端口为4ge口，NE2的ac端口为8fx端口，8fx板卡配置为MPLS模式，其余配置不变
#   <14>配置NE2的ac端口VLAN动作为不变，向NE1的UNI端口发送untag、带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果，
#   预期结果：可接收到带有untag、tag=50的数据流
#   <15>配置NE2的ac端口VLAN动作为添加（只能添加4078-4085），向NE1的UNI端口发送untag、带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果
#   预期结果：可接收到untag、带有vlan id=50的数据流；添加为其他vlan，业务不通
#   <16>配置NE2的ac端口VLAN动作为修改（只能修改为4078-4085），向NE1的UNI端口发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果
#   预期结果：可接收到untag数据流；修改为其他vlan，业务不通
#   <17>当NE1的AC口为8fx口，重复以上步骤，注意：NE1需在PW上做VLAN删除处理
#2、搭建Test Case 2测试环境
##MS-PW功能验证
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
#2、搭建Test Case 2测试环境
##PW VLAN动作验证###
##PW VLAN动作为不变
#   <1>删除NE1和NE2设备的所配置专网业务（AC）和伪线（PW），删除成功，系统无异常
#   <2>配置NE1的PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，用户侧（GE端口）接入模式为“端口模式+运营商VLAN”端口模式，运营商VLAN为 VLAN 50；
#      配置NE2的PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，用户侧（GE端口）接入模式为“端口模式”端口模式，
#      NE1--NE3 、NE2--NE3的lsp、pw、ac配置同上，只是标签不同
#   <3>向NE1的UNI端口发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果
#   预期结果:可接收到带有VID 50数据流；向NE1的UNI端口发送untag 、tag50（TPID为0x9100）tag100数据流，观察NE2的UNI端口接收结果，未收到数据流
##PW VLAN动作为删除
#   <4>删除NE1设备的专网业务（AC）和伪线（PW），更改PW的VLAN动作为删除，其他配置信息保持不变
#   <5>向NE1的UNI端口发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果，可接收到untag数据流；
#      向NE1的UNI端口发送untag 、tag50（TPID为0x9100）tag100数据流，观察NE2、NE3的UNI端口接收结果，未收到数据流
##PW VLAN动作为修改
#   <6>删除NE1设备的专网业务（AC）和伪线（PW），更改PW的VLAN动作为修改（修改为 VID=80），其他配置信息保持不变
#   <7>向NE1的UNI端口发送带有VID 50并匹配规则数据流，观察NE2的UNI端口接收结果，可接收到带有VID 80数据流；
#      向NE1的UNI端口发送untag 、tag100数据流，观察NE2的UNI端口接收结果，未收到数据流
##PW VLAN动作为添加
#   <8>删除NE1设备的专网业务（AC）和伪线（PW），更改PW的VLAN动作为添加（添加VID=100），更改AC的匹配TPID为0x9100，其他配置信息保持不变
#   <9>向NE1的NI端口发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果，可接收到带有双层标签的数据流（外层100，内层50）；
#      向NE1的UNI端口发送untag 、tag50（TPID为0x9100）tag100数据流，观察NE2的UNI端口接收结果，未收到数据流
#   <10>将NNI端口更改为LAG接口，UNI端口为FE端口/GE端口，其他条件不变，重复以上步骤
#   <11>在用户侧端口接入模式为“端口+运营商VLAN+客户VLAN”下，分别验证PW/AC的VLAN动作删除、添加、修改、不变均生效
#   <11>清空4台76设备配置，重启4台76设备,等设备起来后查看无配置
#3、搭建Test Case 3测试环境
##多域业务验证
#   <1>三台设备，NE1--NE2--NE3两两互连，建立EPLAN业务1，vpls域为vpls1，互发数据流，业务正常
#   <2>重新创建一条EPLAN业务2，vpls域为vpls2，lsp与业务1的lsp公用，pw和UNI口另外配置
#   预期结果:发送数据流，业务正常且业务1无影响
#   <3>undo shutdown和shutdown NE1设备的NNI端口50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
#   <4>重启NE1设备的NNI端口所在板卡50次，系统无异常，业务可恢复
#   <5>NE1设备进行SW/NMS倒换50次，系统无异常，业务可恢复，查看标签转发表项正确
#   <6>保存重启NE1设备50次，设备正常启动，配置不丢失，业务正常转发
#   <7>清空设备NE1、NE2、NE3重启
#   <8>配置一条EVPLAN业务1，vpls域为vpls1，发送数据流，业务正常
#   <9>在业务1的基础上再配置一条EVPLAN业务2，vpls域为vpls2，UNI加入另一vlan，lsp公用，pw另外配置
#   预期结果:发送数据流，业务正常且业务1无影响
#   <10>undo shutdown和shutdown NE1设备的NNI端口50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
#   <11>重启NE1设备的NNI端口所在板卡50次，系统无异常，业务可恢复
#   <12>NE1设备进行SW/NMS倒换50次，系统无异常，业务可恢复，查看标签转发表项正确
#   <13>保存重启NE1设备50次，设备正常启动，配置不丢失，业务正常转发
#   <14>清空设备重启，重启后配置消失
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
        close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_007_LOG.txt" a]
	set stdout $fd_log
	chan configure $fd_log -blocking 0 -buffering none;#非阻塞模式 按行flush
	log_file log\\GPN_PTN_007_LOG.txt
	
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_007_REPORT.txt" a+]
	chan configure $fileId -blocking 0 -buffering none;#非阻塞模式 按行flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_007_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_007_DEBUG.txt 0
	chan configure $fd_debug -blocking 0 -buffering none;#非阻塞模式 按行flush
	  
	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl

	
        ###数据流设置
        array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
        array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "500" -pri "000"}
        array set dataArr7 {-srcMac "00:00:00:00:00:22" -dstMac "00:00:00:00:00:02" -srcIp "192.85.1.7" -dstIp "192.0.0.7" -vid "500" -pri "000"}
        array set dataArr12 {-srcMac "00:00:00:00:00:0c" -dstMac "00:00:00:00:00:cc" -srcIp "192.85.1.12" -dstIp "192.0.0.12" -vid "800" -pri "000"}
        array set dataArr13 {-srcMac "00:00:00:00:00:0d" -dstMac "00:00:00:00:00:dd" -srcIp "192.85.1.13" -dstIp "192.0.0.13" -vid "800" -pri "000"}
	array set dataArr14 {-srcMac "00:00:00:00:00:08" -dstMac "00:00:00:00:00:88" -srcIp "192.85.1.14" -dstIp "192.0.0.14" -vid1 "800" -pri1 "000" -vid2 "100" -pri2 "000"}
	array set dataArr15 {-srcMac "00:00:00:00:00:09" -dstMac "00:00:00:00:00:99" -srcIp "192.85.1.15" -dstIp "192.0.0.15" -vid1 "800" -pri1 "000" -vid2 "100" -pri2 "000"}
        array set dataArr16 {-srcMac "00:00:00:00:00:0e" -dstMac "00:00:00:00:00:ee" -srcIp "192.85.1.16" -dstIp "192.0.0.16"}
        array set dataArr18 {-srcMac "00:00:00:00:00:F2" -dstMac "00:00:00:00:F2:F2" -srcIp "192.85.1.18" -dstIp "192.0.0.18" -vid "800" -pri "000" -type "9100"}
        array set dataArr19 {-srcMac "00:00:00:00:00:F3" -dstMac "00:00:00:00:F3:F3" -srcIp "192.85.1.19" -dstIp "192.0.0.19" -vid "800" -pri "000" -type "9100"}
        array set dataArr20 {-srcMac "00:00:00:00:00:cc" -dstMac "00:00:00:00:00:0c" -srcIp "192.85.1.20" -dstIp "192.0.0.20" -vid "800" -pri "000"}
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
        ##mpls报文中的两层标签
        set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
	##匹配smac、vid1、vid2、ethtype
	set anaFliFrameCfg6 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType><vlans name="anon_2516"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
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
	#用于导出被测设备配置用到的变量------
	set lSpawn_id "$telnet1 $telnet2"
	set lMatchType "$matchType1 $matchType2"
	set lDutType "$Gpn_type1 $Gpn_type2"
	set lIp "$gpnIp1 $gpnIp2"
	#------用于导出被测设备配置用到的变量
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "创建测试工程...\n"
	set hPtnProject [stc::create project]
	set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3\
			\"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\" $GPNStcPort5 \"media $GPNEth5Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4 hGPNPort5
	
        ###创建测试流量
        gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort1 hGPNPort1Stream1
        gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort1 hGPNPort1Stream2
        gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort2 hGPNPort2Stream7
        gwd::STC_Create_VlanStream $fileId dataArr12 $hGPNPort1 hGPNPort1Stream12
        gwd::STC_Create_VlanTypeStream $fileId dataArr18 $hGPNPort1 hGPNPort1Stream18
        gwd::STC_Create_Stream $fileId dataArr16 $hGPNPort2 hGPNPort2Stream16
        gwd::STC_Create_VlanStream $fileId dataArr13 $hGPNPort2 hGPNPort2Stream13
        gwd::STC_Create_VlanTypeStream $fileId dataArr19 $hGPNPort2 hGPNPort2Stream19
        gwd::STC_Create_VlanStream $fileId dataArr20 $hGPNPort2 hGPNPort2Stream20
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr14 $hGPNPort1 hGPNPort1Stream14
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr15 $hGPNPort2 hGPNPort2Stream15
        set hGPNPortStreamList11 "$hGPNPort1Stream1 $hGPNPort1Stream12 $hGPNPort1Stream18 $hGPNPort1Stream2"
        set hGPNPortStreamList12 "$hGPNPort2Stream16 $hGPNPort2Stream13 $hGPNPort2Stream19 $hGPNPort2Stream7"
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
	
	stc::config $hGPNPort1Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort2Ana -FilterOnStreamId "FALSE"
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
        
        ###配置流的速率 100Mbps
        foreach stream11 "$hGPNPortStreamList11 $hGPNPortStreamList12 $hGPNPort2Stream20" {
        	stc::config [stc::get $stream11 -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        }
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList11 $hGPNPortStreamList12 $hGPNPort2Stream20 $hGPNPort1Stream14 $hGPNPort2Stream15" \
		-activate "false"
        stc::apply 
        ###获取发生器配置指针
        gwd::Get_GeneratorCfgObj $hGPNPort1Gen hGPNPort1GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort2Gen hGPNPort2GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort5Gen hGPNPort5GenCfg
        set hGPNPortGenCfgList "$hGPNPort1GenCfg $hGPNPort2GenCfg $hGPNPort5GenCfg"
        foreach hGenCfg $hGPNPortGenCfgList {
        	gwd::Cfg_GeneratorCfgObj $hGenCfg $GenCfg
        }
        ###创建并配置过滤器，默认过滤tag
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort1Ana hGPNPort1AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort2Ana hGPNPort2AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort5Ana hGPNPort5AnaFrameCfgFil
        if {$cap_enable} {
                ###获取和配置capture对象相关的指针
                gwd::Get_Capture $hGPNPort1 hGPNPort1Cap
                gwd::Get_Capture $hGPNPort2 hGPNPort2Cap
                gwd::Get_Capture $hGPNPort5 hGPNPort5Cap
                gwd::Create_FilterAnalyzer $hGPNPort1Cap hGPNPort1CapFilter hGPNPort1CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort2Cap hGPNPort2CapFilter hGPNPort2CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort5Cap hGPNPort5CapFilter hGPNPort5CapAnalyzer
                array set capArr {capMode "REGULAR_MODE" capSource "Tx_Rx_MODE"}
        }
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-LAN AC PW动作测试基础配置开始...\n"
	if {[string match "L2" $Worklevel]} {
		set interface3 v4
		set interface4 v4
		set interface5 v800
		set interface6 v800
	} else {
		set interface3 $GPNPort5.4
		set interface4 $GPNPort6.4
		set interface5 $GPNTestEth1.800
		set interface6 $GPNTestEth2.800
	
	}
	lappend cfgFlag [gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"]
	lappend cfgFlag [gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "shutdown"]
        set portList11 "$GPNPort5 $GPNPort13 $GPNTestEth1"
        foreach port $portList11 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
        	}
        }
        set portList22 "$GPNPort6 $GPNPort14 $GPNTestEth2"
        foreach port $portList22 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "disable" "enable"]
		}
	}
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "=E-LAN AC PW动作测试基础配置失败，测试结束" \
			"=E-LAN AC PW动作测试基础配置成功，继续后面的测试" "GPN_PTN_007"
        puts $fileId ""
        puts $fileId "====E-LAN AC PW动作测试基础配置结束..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 ELAN业务：AC VLAN动作验证测试\n"
        ##AC VLAN动作为不变
        #   <1>创建NE1到NE2之间的一条E-LAN业务
        #   <2>配置NE1的LSP1入标签100，出标签100；PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，
        #      用户侧（GE端口）接入模式为“端口模式+运营商VLAN”端口模式，运营商VLAN为 VLAN 800；
        #      配置NE2的LSP1入标签100，出标签100；PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，
        #      用户侧（GE端口）接入模式为“端口模式+运营商VLAN”端口模式，运营商VLAN为 VLAN 800；
        #   <3>向NE1UNI端口发送带有untag、tag800（TPID为0x8100）tag800（TPID为0x9100） tag500 四条数据流，观察NE2的UNI端口接收结果
        #   预期结果：只可接收到带有tag800（TPID为0x8100）数据流
        #   <4>向NE2的ac口发送以上数据流，NE1端口接收结果同上
        #   <5>镜像NE1的NNI端口egress方向报文，为VLAN TAG=50标签并打上两层mpls标签报文，外层lsp标签100，内层pw标签1000
        ##AC VLAN动作为删除
        #   <6>删除NE2设备的专网业务（AC），更改为NE2的AC的VLAN动作为删除，其他配置信息保持不变，mac规则为丢弃
        #   <7>向NE1UNI发送带有tag800（TPID为0x8100）并匹配数据流，观察NE2UNI端口接收结果，
        #   预期结果：可接收到untag数据流；向NE1的UNI端口发送untag 、 tag800（TPID为0x9100） tag500数据流，观察NE2、NE3的UNI端口接收结果，未收到数据流  
        ##AC VLAN动作为修改
        #   <8>删除NE2设备的专网业务（AC），更改NE2的AC的VLAN动作为修改（修改为 VID=100），其他配置信息保持不变
        #   <9>向NE1的UNI端口发送带有VID 800（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果，
        #   预期结果：可接收到带有VID 100数据流；向NE1的UNI端口发送untag 、 tag800（TPID为0x9100） tag500数据流，观察NE2的UNI端口接收结果，未收到数据流
        ##AC VLAN动作为添加
        #   <10>删除NE2设备的专网业务（AC），更改NE2AC的VLAN动作为添加（添加VID=1000），匹配TPID为9100，其他配置信息保持不变
        #   <11>向NE1的UNI端口发送带有VID 800（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果，
        #   预期结果：可接收到带有双层标签的数据流（外层1000，内层800）；向NE1的UNI端口发送untag 、tag800（TPID为0x9100）tag500数据流，观察NE2、NE3的UNI端口接收结果，未收到数据流
        #   <12>删除NE1、NE2的ELAN 业务，查看底层，业务成功删除
	set flag1_case1 0
	set flag2_case1 0
	set flag3_case1 0
	set flag4_case1 0
	set flag5_case1 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：AC VLAN动作为不变验证业务  测试开始=====\n"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "enable"
		gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "enable"
	}
	PTN_NNI_AddInterIp $fileId $Worklevel $interface3 $ip612 $GPNPort5 $matchType1 $Gpn_type1 $telnet1
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "800" $GPNTestEth1
	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface3 $ip621 "100" "100" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
	gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" 1 "elan" "discard" "false" "false" "false" "true" 2000 "" ""
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $::GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"	
	
	PTN_NNI_AddInterIp $fileId $Worklevel $interface4 $ip621 $GPNPort6 $matchType2 $Gpn_type2 $telnet2
	PTN_UNI_AddInter $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel "800" $GPNTestEth2
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface4 $ip612 "100" "100" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWVpls_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls2" 2 "elan" "discard" "false" "false" "false" "true" 2000 "" ""
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $::GPNTestEth2 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList11 \
		-activate "true"
	####NE1-NE2方向数据流验证
	if {[PTN_ElanActiveChange "AC" 1 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case1-1"]} {
		set flag1_case1 1
	}
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList11 \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList12 \
		-activate "true"
	####NE2-NE1方向数据流验证
	if {[PTN_ElanActiveChange "AC" 2 1 $hGPNPort2Gen $hGPNPort1Ana $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case1-2"]} {
		set flag1_case1 1
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1（结论）ELAN业务：AC VLAN动作为不变验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1（结论）ELAN业务：AC VLAN动作为不变验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：AC VLAN动作为不变验证业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：AC VLAN动作为不变NE1($gpnIp1)镜像NNI口的出方向测试MPLS报文  测试开始=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList12 \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList11 $hGPNPort2Stream20"\
		-activate "true"
	####镜像NE1的NNI出口方向
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	if {[PTN_ElanActiveChange "AC" 3 1 "$hGPNPort1Gen $hGPNPort2Gen" $hGPNPort5Ana $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg2 "GPN_PTN_007_case1-3"]} {
		set flag2_case1 1
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2（结论）ELAN业务：AC VLAN动作为不变NE1($gpnIp1)镜像NNI口的出方向测试MPLS报文" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2（结论）ELAN业务：AC VLAN动作为不变NE1($gpnIp1)镜像NNI口的出方向测试MPLS报文" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：AC VLAN动作为不变NE1($gpnIp1)镜像NNI口的出方向测试MPLS报文  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：AC VLAN动作为删除验证业务  测试开始=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPort2Stream20\
		-activate "false"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "delete" "800" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "AC" 4 7 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg7 "GPN_PTN_007_case1-4"]} {
		set flag3_case1 1
	}
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3（结论）ELAN业务：AC VLAN动作为删除验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3（结论）ELAN业务：AC VLAN动作为删除验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：AC VLAN动作为删除验证业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：AC VLAN动作为修改验证业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "modify" "100" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "AC" 5 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case1-5"]} {
		set flag4_case1 1
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA4（结论）ELAN业务：AC VLAN动作为修改验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4（结论）ELAN业务：AC VLAN动作为修改验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：AC VLAN动作为修改验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：AC VLAN动作为添加验证业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x9100" "1"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "add" "1000" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "AC" 6 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case1-6"]} {
		set flag5_case1 1
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA5（结论）ELAN业务：AC VLAN动作为添加验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5（结论）ELAN业务：AC VLAN动作为添加验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：AC VLAN动作为添加验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
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
	puts $fileId "Test Case 1 ELAN业务：AC VLAN动作验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 ELAN业务：PW VLAN动作验证测试\n"
        ##PW VLAN动作为不变
        #   <1>删除NE1和NE2设备的所配置专网业务（AC）和伪线（PW），删除成功，系统无异常
        #   <2>配置NE1的PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，用户侧（GE端口）接入模式为“端口模式+运营商VLAN”端口模式，运营商VLAN为 VLAN 50；
        #      配置NE2的PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，用户侧（GE端口）接入模式为“端口模式”端口模式，
        #      NE1--NE3 、NE2--NE3的lsp、pw、ac配置同上，只是标签不同
        #   <3>向NE1的UNI端口发送带有VID 800（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果
        #   预期结果:可接收到带有VID 800数据流；向NE1的UNI端口发送untag 、tag800（TPID为0x9100）tag500数据流，观察NE2的UNI端口接收结果，未收到数据流
        ##PW VLAN动作为删除
        #   <4>删除NE1设备的专网业务（AC）和伪线（PW），更改PW的VLAN动作为删除，其他配置信息保持不变
        #   <5>向NE1的UNI端口发送带有VID 800（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果，可接收到untag数据流；
        #      向NE1的UNI端口发送untag 、tag800（TPID为0x9100）tag500数据流，观察NE2、NE3的UNI端口接收结果，未收到数据流
        ##PW VLAN动作为修改
        #   <6>删除NE1设备的专网业务（AC）和伪线（PW），更改PW的VLAN动作为修改（修改为 VID=80），其他配置信息保持不变
        #   <7>向NE1的UNI端口发送带有VID 50并匹配规则数据流，观察NE2的UNI端口接收结果，可接收到带有VID 80数据流；
        #      向NE1的UNI端口发送untag 、tag100数据流，观察NE2的UNI端口接收结果，未收到数据流
        ##PW VLAN动作为添加
        #   <8>删除NE1设备的专网业务（AC）和伪线（PW），更改PW的VLAN动作为添加（添加VID=100），更改AC的匹配TPID为0x9100，其他配置信息保持不变
        #   <9>向NE1的NI端口发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的UNI端口接收结果，可接收到带有双层标签的数据流（外层100，内层50）；
        #      向NE1的UNI端口发送untag 、tag50（TPID为0x9100）tag100数据流，观察NE2的UNI端口接收结果，未收到数据流
        #   <10>将NNI端口更改为LAG接口，UNI端口为FE端口/GE端口，其他条件不变，重复以上步骤
        #   <11>在用户侧端口接入模式为“端口+运营商VLAN+客户VLAN”下，分别验证PW/AC的VLAN动作删除、添加、修改、不变均生效
        #   <11>清空4台76设备配置，重启4台76设备,等设备起来后查看无配置
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：PW VLAN动作为不变验证业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "0" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "PW" "1" 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case2-1"]} {
		set flag1_case2 1
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA6（结论）ELAN业务：PW VLAN动作为不变验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6（结论）ELAN业务：PW VLAN动作为不变验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：PW VLAN动作为不变验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：PW VLAN动作为删除验证业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 800 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "PW" "4" 7 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg7 "GPN_PTN_007_case2-2"]} {
		set flag2_case2 1
	}
	puts $fileId ""
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA7（结论）ELAN业务：PW VLAN动作为删除验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7（结论）ELAN业务：PW VLAN动作为删除验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：PW VLAN动作为删除验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：PW VLAN动作为修改验证业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "modify" "none" 100 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "PW" "5" 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case2-3"]} {
		set flag3_case2 1
	}
	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA8（结论）ELAN业务：PW VLAN动作为修改验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8（结论）ELAN业务：PW VLAN动作为修改验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：PW VLAN动作为修改验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：PW VLAN动作为添加验证业务  测试开始=====\n"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1000 0 "0x8100" "0x8100" "2"
        gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"
	if {[PTN_ElanActiveChange "PW" "6" 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case2-4"]} {
		set flag4_case2 1
	}
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA9（结论）ELAN业务：PW VLAN动作为添加验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9（结论）ELAN业务：PW VLAN动作为添加验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务：PW VLAN动作为添加验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
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
	puts $fileId "Test Case 2 ELAN业务：PW VLAN动作验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 ELAN业务：NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作验证测试\n"
	set flag1_case3 0
	set flag2_case3 0
	set flag3_case3 0
	set flag4_case3 0
	if {[string match "L2" $Worklevel]} {
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为不变验证业务  测试开始=====\n"
        	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "undo shutdown"
        	gwd::GWTrunk_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "$GPNPort5,$GPNPort13"
        	gwd::GWpublic_addTrunkMode $telnet1 $matchType1 $Gpn_type1 $fileId "t1" "" "lag1:1"
        	gwd::GWL2Inter_AddVlanPort $telnet1 $matchType1 $Gpn_type1 $fileId "4" "trunk" "t1" "untagged"
        	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
        	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
        	
        	gwd::GWTrunk_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "" "$GPNPort6,$GPNPort14"
        	gwd::GWpublic_addTrunkMode $telnet2 $matchType2 $Gpn_type2 $fileId "t1" "" "lag1:1"
        	gwd::GWL2Inter_AddVlanPort $telnet2 $matchType2 $Gpn_type2 $fileId "4" "trunk" "t1" "untagged"
        	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
        	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
        	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
        	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $::GPNTestEth2 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
        	
        	####NE1-NE2方向数据流验证
        	if {[PTN_ElanActiveChange "AC" 1 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case3-1"]} {
        		set flag1_case3 1
        	}
        	stc::perform streamBlockActivate \
        		-streamBlockList $hGPNPortStreamList11 \
        		-activate "false"
        	stc::perform streamBlockActivate \
        		-streamBlockList $hGPNPortStreamList12 \
        		-activate "true"
        	####NE2-NE1方向数据流验证
        	if {[PTN_ElanActiveChange "AC" 2 1 $hGPNPort2Gen $hGPNPort1Ana $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case3-2"]} {
        		set flag1_case3 1
        	}
        	puts $fileId ""
        	if {$flag1_case3 == 1} {
        		set flagCase3 1
        		gwd::GWpublic_print "NOK" "FB1（结论）NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为不变验证业务" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB1（结论）NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为不变验证业务" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为不变验证业务  测试结束=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为删除验证业务  测试开始=====\n"
        	stc::perform streamBlockActivate \
        		-streamBlockList $hGPNPortStreamList11 \
        		-activate "true"
        	stc::perform streamBlockActivate \
        		-streamBlockList $hGPNPortStreamList12 \
        		-activate "false"
        	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
        	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "delete" "800" "0" "0" "0x8100" "evc2"
        	if {[PTN_ElanActiveChange "AC" 4 7 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg7 "GPN_PTN_007_case3-3"]} {
        		set flag2_case3 1
        	}
        	puts $fileId ""
        	if {$flag2_case3 == 1} {
        		set flagCase3 1
        		gwd::GWpublic_print "NOK" "FB2（结论）NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为删除验证业务" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB2（结论）NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为删除验证业务" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为删除验证业务  测试结束=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为修改验证业务  测试开始=====\n"
        	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
        	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "modify" "100" "0" "0" "0x8100" "evc2"
        	if {[PTN_ElanActiveChange "AC" 5 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case3-4"]} {
        		set flag3_case3 1
        	}
        	puts $fileId ""
        	if {$flag3_case3 == 1} {
        		set flagCase3 1
        		gwd::GWpublic_print "NOK" "FB3（结论）NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为修改验证业务" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB3（结论）NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为修改验证业务" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为修改验证业务  测试结束=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为添加验证业务  测试开始=====\n"
        	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
        	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
        	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x9100" "1"
        	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "0" "none" "add" "1000" "0" "0" "0x8100" "evc2"
        	if {[PTN_ElanActiveChange "AC" 6 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case3-5"]} {
        		set flag4_case3 1
        	}
        	puts $fileId ""
        	if {$flag4_case3 == 1} {
        		set flagCase3 1
        		gwd::GWpublic_print "NOK" "FB4（结论）NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为添加验证业务" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB4（结论）NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为添加验证业务" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为添加验证业务  测试结束=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
	} else {
		puts $fileId "被测设备没有工作在L2层，测试略过"
	}
	if {$flagCase3 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 3测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 3测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 3 ELAN业务：NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 ELAN业务：NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作验证测试\n"
	
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	if {[string match "L2" $Worklevel]} {
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为不变验证业务  测试开始=====\n"
        	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
        	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
        	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
        	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "0" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
        	if {[PTN_ElanActiveChange "PW" "1" 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case4-1"]} {
        		set flag1_case4 1
        	}
        	puts $fileId ""
        	if {$flag1_case4 == 1} {
        		set flagCase4 1
        		gwd::GWpublic_print "NOK" "FB5（结论）NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为不变验证业务" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB5（结论）NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为不变验证业务" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为不变验证业务  测试结束=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为删除验证业务  测试开始=====\n"
        	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 800 0 "0x8100" "0x8100" "2"
        	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
        	if {[PTN_ElanActiveChange "PW" "4" 7 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg7 "GPN_PTN_007_case4-2"]} {
        		set flag2_case4 1
        	}
        	puts $fileId ""
        	if {$flag2_case4 == 1} {
        		set flagCase4 1
        		gwd::GWpublic_print "NOK" "FB6（结论）NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为删除验证业务" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB6（结论）NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为删除验证业务" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为删除验证业务  测试结束=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为修改验证业务  测试开始=====\n"
        	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "modify" "none" 100 0 "0x8100" "0x8100" "2"
        	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
        	if {[PTN_ElanActiveChange "PW" "5" 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case4-3"]} {
        		set flag3_case4 1
        	}
        	puts $fileId ""
        	if {$flag3_case4 == 1} {
        		set flagCase4 1
        		gwd::GWpublic_print "NOK" "FB7（结论）NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为修改验证业务" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB7（结论）NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为修改验证业务" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为修改验证业务  测试结束=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为添加验证业务  测试开始=====\n"
        	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
        	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1000 0 "0x8100" "0x8100" "2"
        	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"
        	if {[PTN_ElanActiveChange "PW" "6" 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case4-4"]} {
        		set flag4_case4 1
        	}
        	puts $fileId ""
        	if {$flag4_case4 == 1} {
        		set flagCase4 1
        		gwd::GWpublic_print "NOK" "FB8（结论）NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为添加验证业务" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "FB8（结论）NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为添加验证业务" $fileId
        	}
        	puts $fileId ""
        	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为添加验证业务  测试结束=====\n"
        	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
        	incr cfgId
        	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
        	if {$lFailFileTmp != ""} {
        		set lFailFile [concat $lFailFile $lFailFileTmp]
        	}
        	puts $fileId "======================================================================================\n"
	} else {
		puts $fileId "被测设备没有工作在L2层，测试略过"
	}
	if {$flagCase4 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 4测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 4测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 4 ELAN业务：ELAN业务：NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 ELAN业务：端口模式为PORT+SVLAN+CVLAN、AC VLAN动作验证测试\n"
	set flag1_case5 0
	set flag2_case5 0
	set flag3_case5 0
	set flag4_case5 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为不变验证业务  测试开始=====\n"
	if {[string match "L2" $Worklevel]} {
                gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "shutdown"
                gwd::GWTrunk_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "t1" ""
		gwd::GWL2Inter_AddVlanPort $telnet1 $matchType1 $Gpn_type1 $fileId 4 "port" $GPNPort5 "untagged"
		#GPNTestEth1 shutdown/undo shutdown的目的是为了规避：trunk测试完成后如果不shut/undo shut就会导致业务不通的问题
		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "shutdown"
		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "undo shutdown"
		gwd::GWTrunk_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "t1" ""
		gwd::GWL2Inter_AddVlanPort $telnet2 $matchType2 $Gpn_type2 $fileId 4 "port" $GPNPort6 "untagged"
        }
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "100" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $::GPNTestEth2 "800" "100" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPort1Stream14 \
		-activate "true"
	####NE1-NE2方向数据流验证
	if {[PTN_ElanActiveChange "AC" 7 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case5-1"]} {
		set flag1_case5 1
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList12 $hGPNPort2Stream15" \
		-activate "true"
	####NE2-NE1方向数据流验证
	if {[PTN_ElanActiveChange "AC" 8 6 $hGPNPort2Gen $hGPNPort1Ana $hGPNPort1AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case5-2"]} {
		set flag1_case5 1
	}
	puts $fileId ""
	if {$flag1_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FB9（结论）端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为不变验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9（结论）端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为不变验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为不变验证业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为删除验证业务  测试开始=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList12 $hGPNPort2Stream15" \
		-activate "false"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "100" "none" "delete" "800" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "AC" 9 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case5-3"]} {
		set flag2_case5 1
	}
	puts $fileId ""
	if {$flag2_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC1（结论）端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为删除验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1（结论）端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为删除验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为删除验证业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为修改验证业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "100" "none" "modify" "1000" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "AC" 10 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case5-4"]} {
		set flag3_case5 1
	}
	puts $fileId ""
	if {$flag3_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC2（结论）端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为修改验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2（结论）端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为修改验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为修改验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为添加验证业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x9100" "1"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "800" "100" "none" "add" "1000" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "AC" 11 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg4 "GPN_PTN_007_case5-5"]} {
		set flag4_case5 1
	}
	puts $fileId ""
	if {$flag4_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC3（结论）端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为添加验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3（结论）端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为添加验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为添加验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
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
	puts $fileId "Test Case 5 ELAN业务：端口模式为PORT+SVLAN+CVLAN、AC VLAN动作验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 6 ELAN业务：端口模式为PORT+SVLAN+CVLAN、PW VLAN动作验证测试\n"
	set flag1_case6 0
	set flag2_case6 0
	set flag3_case6 0
	set flag4_case6 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为不变验证业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "100" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac800" "vpls2" "" $GPNTestEth2 "0" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "PW" "7" 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case6-1"]} {
		set flag1_case6 1
	}
	puts $fileId ""
	if {$flag1_case6 == 1} {
		set flagCase6 1
		gwd::GWpublic_print "NOK" "FC4（结论）端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为不变验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4（结论）端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为不变验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为不变验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为删除验证业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 800 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "100" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "PW" "9" 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg1 "GPN_PTN_007_case6-2"]} {
		set flag2_case6 1
	}
	puts $fileId ""
	if {$flag2_case6 == 1} {
		set flagCase6 1
		gwd::GWpublic_print "NOK" "FC5（结论）端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为删除验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5（结论）端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为删除验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为删除验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为修改验证业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "modify" "none" 1000 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "100" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	if {[PTN_ElanActiveChange "PW" "10" 6 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg6 "GPN_PTN_007_case6-3"]} {
		set flag3_case6 1
	}
	puts $fileId ""
	if {$flag3_case6 == 1} {
		set flagCase6 1
		gwd::GWpublic_print "NOK" "FC6（结论）端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为修改验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6（结论）端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为修改验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为修改验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为添加验证业务  测试开始=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1000 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls1" "" $GPNTestEth1 "800" "100" "none" "nochange" "1" "0" "0" "0x9100" "evc2"
	if {[PTN_ElanActiveChange "PW" "11" 1 $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2AnaFrameCfgFil $anaFliFrameCfg4 "GPN_PTN_007_case6-4"]} {
		set flag4_case6 1
	}
	puts $fileId ""
	if {$flag4_case6 == 1} {
		set flagCase6 1
		gwd::GWpublic_print "NOK" "FC7（结论）端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为添加验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7（结论）端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为添加验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为添加验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_007_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_007" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase6 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 6测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 6测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 6 ELAN业务：端口模式为PORT+SVLAN+CVLAN、PW VLAN动作验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 7 ELAN业务：多域业务验证测试\n"
        #   <1>三台设备，NE1--NE2--NE3两两互连，建立EPLAN业务1，vpls域为vpls1，互发数据流，业务正常
        #   <2>重新创建一条EPLAN业务2，vpls域为vpls2，lsp与业务1的lsp公用，pw和UNI口另外配置
        #   预期结果:发送数据流，业务正常且业务1无影响
        #   <3>undo shutdown和shutdown NE1设备的NNI端口50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
        #   <4>重启NE1设备的NNI端口所在板卡50次，系统无异常，业务可恢复
        #   <5>NE1设备进行SW/NMS倒换50次，系统无异常，业务可恢复，查看标签转发表项正确
        #   <6>保存重启NE1设备50次，设备正常启动，配置不丢失，业务正常转发
        #   <7>清空设备NE1、NE2、NE3重启
        #   <8>配置一条EVPLAN业务1，vpls域为vpls1，发送数据流，业务正常
        #   <9>在业务1的基础上再配置一条EVPLAN业务2，vpls域为vpls2，UNI加入另一vlan，lsp公用，pw另外配置
        #   预期结果:发送数据流，业务正常且业务1无影响
        #   <10>undo shutdown和shutdown NE1设备的NNI端口50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
        #   <11>重启NE1设备的NNI端口所在板卡50次，系统无异常，业务可恢复
        #   <12>NE1设备进行SW/NMS倒换50次，系统无异常，业务可恢复，查看标签转发表项正确
        #   <13>保存重启NE1设备50次，设备正常启动，配置不丢失，业务正常转发
        #   <14>清空设备重启，重启后配置消失
        puts $fileId "多域业务验证见”GPN_PTN_006“的case5测试结果，不再单独测试"
        puts $fileId ""
        puts $fileId "Test Case 7 ELAN业务：多域业务验证测试  测试结束\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===恢复初始化配置...\n"
	if {[string match "L2" $Worklevel]} {
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "none"]
	}
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface3 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface5 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "undo shutdown"]
	
	lappend flagDel [gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls2"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"] 
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface4 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface6 $matchType2 $Gpn_type2 $telnet2]
	
	if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
		foreach port $portList22 {
			lappend flagDel [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "enable" "disable"]
		}
		foreach port $portList11 {
			lappend flagDel [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "enable" "disable"]
		}
	}
	
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "测试结束后配置恢复" "测试结束后配置恢复" "GPN_PTN_007"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "测试过程中所有配置文件都上传成功" "GPN_PTN_007"
	chan seek $fileId 0
        puts $fileId "\n**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "GPN_PTN_007测试目的：E-LAN业务：AC PW动作测试\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1 == 1 || $flagCase2 == 1 || $flagCase3 == 1 || $flagCase4 == 1 || $flagCase5 == 1 || $flagCase6 == 1\
		|| $flagCase7 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_007测试结果" $fileId
	puts $fileId ""
        gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase6 == 0) ? "OK" : "NOK"}] "Test Case 6测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase7 == 0) ? "OK" : "NOK"}] "Test Case 7测试结果" $fileId
        
        puts $fileId ""
        puts $fileId ""
        gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "（结论）ELAN业务：AC VLAN动作为不变验证业务" $fileId
        gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "（结论）ELAN业务：AC VLAN动作为不变NE1($gpnIp1)镜像NNI口的出方向测试MPLS报文" $fileId
        gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "（结论）ELAN业务：AC VLAN动作为删除验证业务" $fileId
        gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "（结论）ELAN业务：AC VLAN动作为修改验证业务" $fileId
        gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "（结论）ELAN业务：AC VLAN动作为添加验证业务" $fileId
        gwd::GWpublic_print "== FA6 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "（结论）ELAN业务：PW VLAN动作为不变验证业务" $fileId
        gwd::GWpublic_print "== FA7 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "（结论）ELAN业务：PW VLAN动作为删除验证业务" $fileId
        gwd::GWpublic_print "== FA8 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "（结论）ELAN业务：PW VLAN动作为修改验证业务" $fileId
        gwd::GWpublic_print "== FA9 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "（结论）ELAN业务：PW VLAN动作为添加验证业务" $fileId
        gwd::GWpublic_print "== FB1 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "（结论）NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为不变验证业务" $fileId
        gwd::GWpublic_print "== FB2 == [expr {($flag2_case3 == 1) ? "NOK" : "OK"}]" "（结论）NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为删除验证业务" $fileId
        gwd::GWpublic_print "== FB3 == [expr {($flag3_case3 == 1) ? "NOK" : "OK"}]" "（结论）NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为修改验证业务" $fileId
        gwd::GWpublic_print "== FB4 == [expr {($flag4_case3 == 1) ? "NOK" : "OK"}]" "（结论）NNI口为LAG端口、端口模式为PORT+VLAN、AC VLAN动作为添加验证业务" $fileId
        gwd::GWpublic_print "== FB5 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "（结论）NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为不变验证业务" $fileId
        gwd::GWpublic_print "== FB6 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "（结论）NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为删除验证业务" $fileId
        gwd::GWpublic_print "== FB7 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "（结论）NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为修改验证业务" $fileId
        gwd::GWpublic_print "== FB8 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "（结论）NNI口为LAG端口、端口模式为PORT+VLAN、PW VLAN动作为添加验证业务" $fileId
        gwd::GWpublic_print "== FB9 == [expr {($flag1_case5 == 1) ? "NOK" : "OK"}]" "（结论）端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为不变验证业务" $fileId
        gwd::GWpublic_print "== FC1 == [expr {($flag2_case5 == 1) ? "NOK" : "OK"}]" "（结论）端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为删除验证业务" $fileId
        gwd::GWpublic_print "== FC2 == [expr {($flag3_case5 == 1) ? "NOK" : "OK"}]" "（结论）端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为修改验证业务" $fileId
        gwd::GWpublic_print "== FC3 == [expr {($flag4_case5 == 1) ? "NOK" : "OK"}]" "（结论）端口模式为PORT+SVLAN+CVLAN、AC VLAN动作为添加验证业务" $fileId
        gwd::GWpublic_print "== FC4 == [expr {($flag1_case6 == 1) ? "NOK" : "OK"}]" "（结论）端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为不变验证业务" $fileId
        gwd::GWpublic_print "== FC5 == [expr {($flag2_case6 == 1) ? "NOK" : "OK"}]" "（结论）端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为删除验证业务" $fileId
        gwd::GWpublic_print "== FC6 == [expr {($flag3_case6 == 1) ? "NOK" : "OK"}]" "（结论）端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为修改验证业务" $fileId
        gwd::GWpublic_print "== FC7 == [expr {($flag4_case6 == 1) ? "NOK" : "OK"}]" "（结论）端口模式为PORT+SVLAN+CVLAN、PW VLAN动作为添加验证业务" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "（结论）测试结束后配置恢复" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "（结论）测试过程中配置文件的上传" $fileId
        puts $fileId ""
        puts $fileId "**************************************************************************************"
        puts $fileId ""
        puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "运行异常：错误为$err" "" "GPN_PTN_007"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_007_REPORT.txt" "report\\NOK_GPN_PTN_007_REPORT.txt"
	file rename "log\\GPN_PTN_007_LOG.txt" "log\\NOK_GPN_PTN_007_LOG.txt"
} else {
	file rename "report\\GPN_PTN_007_REPORT.txt" "report\\OK_GPN_PTN_007_REPORT.txt"
	file rename "log\\GPN_PTN_007_LOG.txt" "log\\OK_GPN_PTN_007_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}
