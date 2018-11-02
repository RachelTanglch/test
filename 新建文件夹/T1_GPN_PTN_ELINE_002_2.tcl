#!/bin/sh
# GPN_PTN_002_2.tcl \
exec tclsh "$0" ${1+"$@"}
#测试名称：ptn002_2
#-----------------------------------------------------------------------------------------------------------------------------------
#测试目的：E-LINE的功能
#3-PW/AC vlan动作验证
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
#   <1>两台设备组网，NNI端口(GE端口)通过以太网接口形式相连，NNI端口(GE端口)以untag方式加入到VLANIF中
##AC VLAN动作为不变
#   <2>创建NE1的A端口到NE2的B端口之间一条E-LINE业务
#      配置NE1的LSP1入标签100，出标签100；PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，用户侧（GE端口）接入模式为“端口模式+运营商VLAN”端口模式，运营商VLAN为 VLAN 50；
#      配置NE2的LSP1入标签100，出标签100；PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，用户侧（GE端口）接入模式为“端口模式”端口模式，
#   <3>NE1和NE2用户测配置undo vlan check
#   <4>向NE1端口A发送带有untag/tag50（TPID为0x8100）/tag50（TPID为0x9100）/tag60 四条数据流，观察NE2的端口B接收结果
#   预期结果：只可接收到带有tag50（TPID为0x8100）数据流
#   <5>镜像NE1的NNI端口egress方向报文
#   预期结果：镜像报文为不带VLAN TAG标签并打上两层mpls标签报文，外层lsp标签100，内层pw标签1000
##AC VLAN动作为删除
#   <6>删除NE2设备的专线业务（AC），更改为AC的VLAN动作为删除，其他配置信息保持不变
#   <7>向NE1端口A发送带有tag50（TPID为0x8100）并匹配数据流，观察NE2的端口B接收结果；
#   预期结果：B可接收到untag数据流，向NE1端口A发送untag/tag50（TPID为0x9100）/tag100数据流，观察NE2的端口B接收结果，未收到数据流
##AC VLAN动作为修改
#   <8>删除NE2设备的专线业务（AC），更改AC的VLAN动作为修改（修改为 VID=80），其他配置信息保持不变 
#   <9>向NE1端口A发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的端口B接收结果；
#   预期结果：B可接收到带有VID 80数据流，向NE1端口A发送untag/tag50（TPID为0x9100）/ tag100数据流，观察NE2的端口B接收结果，未收到数据流
##AC VLAN动作为添加
#   <10>删除NE2设备的专线业务（AC）和伪线（PW1），更改PW1的匹配TPID为0x9100，更改AC的VLAN动作为添加（添加VID=100）其他配置信息保持不变
#   <11>向NE1端口A发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的端口B接收结果;
#   预期结果：B可接收到带有双层标签的数据流（外层100，内层50）；向NE1端口A发送untag/tag50（TPID为0x9100）/tag100数据流，观察NE2的端口B接受结果，未收到数据流
#2、搭建Test Case 2测试环境
##PW VLAN动作为不变
#   <1>删除NE1和NE2设备的所配置专线业务（AC）和伪线（PW1），删除成功，系统无异常
#   <2>配置NE1的PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，用户侧（GE端口）接入模式为“端口模式+运营商VLAN”端口模式，运营商VLAN为 VLAN 50；
#      配置NE2的PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，用户侧（GE端口）接入模式为“端口模式”端口模式，
#   <3>NE1和NE2用户测配置undo vlan check
#   <4>向NE1端口A发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的端口B接收结果;
#   预期结果：B可接收到带有VID 50数据流；向NE1端口A发送untag/tag50（TPID为0x9100）/tag100数据流，观察NE2的端口B接受结果，未收到数据流
##PW VLAN动作为删除
#   <5>删除NE1设备的专线业务（AC）和伪线（PW1），更改PW1的VLAN动作为删除，其他配置信息保持不变
#   <6>向NE1端口A发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的端口B接受结果
#   预期结果：B可接收到untag数据流；向NE1端口A发送untag/tag50（TPID为0x9100）/tag100数据流，观察NE2的端口B接受结果，未收到数据流
##PW VLAN动作为修改
#   <7>删除NE1设备的专线业务（AC）和伪线（PW1），更改PW1的VLAN动作为修改（修改为 VID=80），其他配置信息保持不变 
#   <8>向NE1端口A发送带有VID 50并匹配规则数据流，观察NE2的端口B接受结果;
#   预期结果：B可接收到带有VID 80数据流；向NE1端口A发送untag 、tag100数据流，观察NE2的端口B接受结果，未收到数据流
##PW VLAN动作为添加
#   <9>删除NE1设备的专线业务（AC）和伪线（PW1），更改PW1的VLAN动作为添加（添加VID=100），更改AC的匹配TPID为0x9100，其他配置信息保持不变
#   <10>向NE1端口A发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的端口B接受结果
#   预期结果：B可接收到带有双层标签的数据流（外层100，内层50）；向NE1端口A发送untag/tag50（TPID为0x9100）/tag100数据流，观察NE2的端口B接受结果，未收到数据流
#3、搭建Test Case 3测试环境
#   <1>将UNI端口更改为FE端口，其他条件不变，重复以上步骤
#   <2>将NNI端口更改为10GE端口，UNI端口为FE/GE端口，其他条件不变，重复以上步骤
#   <3>将NNI端口更改为LAG接口，UNI端口为FE/GE端口，其他条件不变，重复以上步骤
#   <4>在用户侧端口接入模式为“端口+运营商VLAN+客户VLAN”下，分别验证PW/AC的VLAN动作删除、添加、修改、不变均生效
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
        close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_002_2_LOG.txt" a]
        set stdout $fd_log
        log_file log\\GPN_PTN_002_2_LOG.txt
        chan configure $stdout -blocking 0 -buffering none;#非阻塞模式 按行flush
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_002_2_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#非阻塞模式 按行flush
        
        file mkdir "debug"
        set fd_debug [open debug\\GPN_PTN_002_2_DEBUG.txt a]
        exp_internal -f debug\\GPN_PTN_002_2_DEBUG.txt 0
        chan configure $fd_debug -blocking 0 -buffering none;#非阻塞模式 按行flush
        
        source test\\PTN_VarSet.tcl
        source test\\PTN_Mode_Function.tcl

        array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
        array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "50" -pri "000"}
        array set dataArr3 {-srcMac "00:00:00:00:00:03" -dstMac "00:00:00:00:00:33" -srcIp "192.85.1.3" -dstIp "192.0.0.3" -vid "50" -pri "000" -type "9100"}
        array set dataArr4 {-srcMac "00:00:00:00:00:04" -dstMac "00:00:00:00:00:44" -srcIp "192.85.1.4" -dstIp "192.0.0.4" -vid "60" -pri "000"}
        array set dataArr5 {-srcMac "00:00:00:00:00:05" -dstMac "00:00:00:00:00:55" -srcIp "192.85.1.5" -dstIp "192.0.0.5"}
        array set dataArr6 {-srcMac "00:00:00:00:00:06" -dstMac "00:00:00:00:00:66" -srcIp "192.85.1.6" -dstIp "192.0.0.6" -vid "50" -pri "000"}
        array set dataArr7 {-srcMac "00:00:00:00:00:07" -dstMac "00:00:00:00:00:77" -srcIp "192.85.1.7" -dstIp "192.0.0.7" -vid "50" -pri "000" -type "9100"}
        array set dataArr8 {-srcMac "00:00:00:00:00:08" -dstMac "00:00:00:00:00:88" -srcIp "192.85.1.8" -dstIp "192.0.0.8" -vid "60" -pri "000"}
        array set dataArr9 {-srcMac "00:00:00:00:00:09" -dstMac "00:00:00:00:00:99" -srcIp "192.85.1.9" -dstIp "192.0.0.9" -vid "100" -pri "000"}
        array set dataArr10 {-srcMac "00:00:00:00:00:0a" -dstMac "00:00:00:00:00:aa" -srcIp "192.85.1.10" -dstIp "192.0.0.10" -vid1 "50" -pri1 "000" -vid2 "30" -pri2 "000"}
        array set dataArr11 {-srcMac "00:00:00:00:00:0b" -dstMac "00:00:00:00:00:bb" -srcIp "192.85.1.11" -dstIp "192.0.0.11" -vid1 "50" -pri1 "000" -type1 "9100" -vid2 "30" -pri2 "000" -type2 "9100"}
        array set dataArr12 {-srcMac "00:00:00:00:00:0c" -dstMac "00:00:00:00:00:cc" -srcIp "192.85.1.12" -dstIp "192.0.0.12" -vid1 "50" -pri1 "000" -vid2 "20" -pri2 "000"}
        #设置定制信息参数
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        
        #设置发生器参数
        set GenCfg {-SchedulingMode RATE_BASED}
        
        #设置过滤分析器参数
        #Vlan0-ID smac
        set anaFliFrameCfg1 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><vlans name="anon_13224"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        
        #smac
        set anaFliFrameCfg0 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        
        #Vlan0-ID Vlan1-ID
        set anaFliFrameCfg4 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5580"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        
        #Mpls0-Label  Mpls1-Label
        set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
        
        #Vlan0-ID   Mpls0-Exp   Mpls1-s
        set anaFliFrameCfg3 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4647"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><exp override="true"  filterMinValue="0" filterMaxValue="111">111</exp></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><sBit override="true"  filterMinValue="0" filterMaxValue="1">1</sBit></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}

        set rateL 9500000;#收发数据流取值最小值范围
        set rateR 10500000;#收发数据流取值最大值范围
        set rateL1 10000000 
        set rateR1 12500000
        
        set flagResult 0
        set flagCase1 0   ;#Test case 1标志位 
        set flagCase2 0   ;#Test case 2标志位
        set flagCase3 0   ;#Test case 3标志位 
        set lFailFile ""
        set FLAGF 0
        
        set tcId 0
        set capId 0
        set cfgId 0
	#为测试结论预留空行
	for {set i 0} {$i < 80} {incr i} {
	    puts $fileId "                                                                                                                                                                                                                "	
	}
	regsub {/} $GPNTestEth2 {_} GPNTestEth2_cap
	regsub {/} $GPNTestEth3 {_} GPNTestEth3_cap
	regsub {/} $GPNTestEth4 {_} GPNTestEth4_cap
	
	
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
        gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort3 hGPNPort3Stream1
        gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort3 hGPNPort3Stream2
        gwd::STC_Create_VlanTypeStream $fileId dataArr3 $hGPNPort3 hGPNPort3Stream3
        gwd::STC_Create_VlanStream $fileId dataArr4 $hGPNPort3 hGPNPort3Stream4
        gwd::STC_Create_Stream $fileId dataArr5 $hGPNPort4 hGPNPort4Stream5
        gwd::STC_Create_VlanStream $fileId dataArr6 $hGPNPort4 hGPNPort4Stream6
        gwd::STC_Create_VlanTypeStream $fileId dataArr7 $hGPNPort4 hGPNPort4Stream7
        gwd::STC_Create_VlanStream $fileId dataArr8 $hGPNPort4 hGPNPort4Stream8
        gwd::STC_Create_VlanStream $fileId dataArr9 $hGPNPort3 hGPNPort3Stream9
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr10 $hGPNPort3 hGPNPort3Stream10
        gwd::STC_Create_DoubleVlanType_Stream $fileId dataArr11 $hGPNPort3 hGPNPort3Stream11
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr12 $hGPNPort3 hGPNPort3Stream12
        set lHStream "$hGPNPort3Stream1 $hGPNPort3Stream2 $hGPNPort3Stream3 $hGPNPort3Stream4 $hGPNPort4Stream5 $hGPNPort4Stream6\
        	$hGPNPort4Stream7 $hGPNPort4Stream8 $hGPNPort3Stream9 $hGPNPort3Stream10 $hGPNPort3Stream11 $hGPNPort3Stream12"
        stc::perform streamBlockActivate -streamBlockList $lHStream -activate "false"

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
        stc::config [stc::get $hGPNPort3Stream1 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream2 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream3 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream4 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream5 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream6 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream7 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort4Stream8 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream9 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream10 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream11 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
        stc::config [stc::get $hGPNPort3Stream12 -AffiliationStreamBlockLoadProfile-targets] -load 10 -LoadUnit MEGABITS_PER_SECOND
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
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===ELINE业务AC PW动作测试基础配置开始...\n"
	set cfgFlag 0
        ##二三层接口配置参数
        if {[string match "L2" $Worklevel]} {
        	set interface10 v10
        	set interface11 v10
        	set interface12 v50
        	set interface13 v1001
        } else {
        	set interface10 $GPNPort6.10
        	set interface11 $GPNPort5.10
        	set interface12 $GPNTestEth3.50
        	set interface13 $GPNTestEth3.1001
        }
        set ip1 192.1.1.1
        set ip2 192.1.1.2
        set address1 10.1.1.1
        set address2 10.1.1.2

	set portList1 "$GPNPort5 $GPNTestEth2 $GPNTestEth3"
	foreach port $portList1 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
		}
	}
	set rebootSlotList1 [gwd::GWpulic_getWorkCardList $portList1]
	gwd::GWpublic_print "OK" "获取设备NE1($gpnIp1)业务板卡槽位号$rebootSlotList1" $fileId
	if {[string match "L2" $Worklevel]} {
        	lappend cfgFlag [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "enable"]
	}
        lappend cfgFlag [PTN_NNI_AddInterIp $fileId $Worklevel $interface11 $ip1 $GPNPort5 $matchType1 $Gpn_type1 $telnet1]
        lappend cfgFlag [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "50" $GPNTestEth3]  
        lappend cfgFlag [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "1001" $GPNTestEth3]
        lappend cfgFlag [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $interface11 $ip2 "100" "100" "normal" "1"] 
        lappend cfgFlag [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $address1]
        lappend cfgFlag [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]
        lappend cfgFlag [gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]

	set portList3 "$GPNPort6 $GPNTestEth4"
	foreach port $portList3 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend cfgFlag [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "disable" "enable"]
		}
	}
	set rebootSlotList3 [gwd::GWpulic_getWorkCardList $portList3]
	gwd::GWpublic_print "OK" "获取设备NE3($gpnIp3)业务板卡槽位号$rebootSlotList3" $fileId
	if {[string match "L2" $Worklevel]} {
		lappend cfgFlag [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort6 "enable"]
        	lappend cfgFlag [gwd::GWpublic_CfgVlanCheck  $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "disable"]
	}
        lappend cfgFlag [PTN_NNI_AddInterIp $fileId $Worklevel $interface10 $ip2 $GPNPort6 $matchType3 $Gpn_type3 $telnet3]
        lappend cfgFlag [gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" $interface10 $ip1 "100" "100" "normal" "2"]
        lappend cfgFlag [gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1" $address2]
        lappend cfgFlag [gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
        lappend cfgFlag [gwd::GWpublic_showTunnelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "ELINE业务AC PW动作测试基础配置失败，测试结束" \
		"ELINE业务AC PW动作测试基础配置成功，继续后面的测试" "GPN_PTN_002_2"
	puts $fileId ""
	puts $fileId "===ELINE业务AC PW动作测试基础配置结束..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId ""
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 $porttype4\端口ELine业务AC动作测试\n"
        #   <1>两台设备组网，NNI端口(GE端口)通过以太网接口形式相连，NNI端口(GE端口)以untag方式加入到VLANIF中
        ##AC VLAN动作为不变
        #   <2>创建NE1的A端口到NE2的B端口之间一条E-LINE业务
        #      配置NE1的LSP1入标签100，出标签100；PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，用户侧（GE端口）接入模式为“端口模式+运营商VLAN”端口模式，运营商VLAN为 VLAN 50；
        #      配置NE2的LSP1入标签100，出标签100；PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，用户侧（GE端口）接入模式为“端口模式”端口模式，
        #   <3>NE2用户测配置undo vlan check
        #   <4>向NE1端口A发送带有untag/tag50（TPID为0x8100）/tag50（TPID为0x9100）/tag60 四条数据流，观察NE2的端口B接收结果
        #   预期结果：只可接收到带有tag50（TPID为0x8100）数据流
        #   <5>镜像NE1的NNI端口egress方向报文
        #   预期结果：镜像报文为不带VLAN TAG标签并打上两层mpls标签报文，外层lsp标签100，内层pw标签1000
        ##AC VLAN动作为删除
        #   <6>删除NE2设备的专线业务（AC），更改为AC的VLAN动作为删除，其他配置信息保持不变
        #   <7>向NE1端口A发送带有tag50（TPID为0x8100）并匹配数据流，观察NE2的端口B接收结果；
        #   预期结果：B可接收到untag数据流，向NE1端口A发送untag/tag50（TPID为0x9100）/tag100数据流，观察NE2的端口B接收结果，未收到数据流
        ##AC VLAN动作为修改
        #   <8>删除NE2设备的专线业务（AC），更改AC的VLAN动作为修改（修改为 VID=80），其他配置信息保持不变 
        #   <9>向NE1端口A发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的端口B接收结果；
        #   预期结果：B可接收到带有VID 80数据流，向NE1端口A发送untag/tag50（TPID为0x9100）/ tag100数据流，观察NE2的端口B接收结果，未收到数据流
        ##AC VLAN动作为添加
        #   <10>删除NE2设备的专线业务（AC）和伪线（PW1），更改PW1的匹配TPID为0x9100，更改AC的VLAN动作为添加（添加VID=100）其他配置信息保持不变
        #   <11>向NE1端口A发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的端口B接收结果;
        #   预期结果：B可接收到带有双层标签的数据流（外层100，内层50）；向NE1端口A发送untag/tag50（TPID为0x9100）/tag100数据流，观察NE2的端口B接受结果，未收到数据流
        set flag1_case1 0
        set flag2_case1 0
        set flag3_case1 0
        set flag4_case1 0
        set flag5_case1 0
        set flag6_case1 0
        set flag7_case1 0
        set flag8_case1 0
        set flag9_case1 0
        puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作不变的测试开始=====\n"
        if {[string match "8FX" $porttype3]} {
        	gwd::GWpublic_addMplsEn $telnet1 $matchType1 $Gpn_type1 $fileId "enable" $slot3
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "delete" "" 1 0 "0x8100" "0x9100" ""
        } else {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        }
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"

        if {[string match "8FX" $porttype4]} {
                gwd::GWpublic_addMplsEn $telnet3 $matchType3 $Gpn_type3 $fileId "enable" $slot4
                gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "delete" "" 1 0 "0x8100" "0x9100" ""
                gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
        } else {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "nochange" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
        }
	gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 0 0 "nochange" 1 0 0 "0x8100"
	gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline"
	gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort3Stream1 $hGPNPort3Stream2 $hGPNPort3Stream3 $hGPNPort3Stream4 $hGPNPort4Stream8" \
		-activate "true"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt2(cnt1)!=0} {
        		set flag1_case1 1
        		gwd::GWpublic_print NOK "Dev3收到smac=00:00:00:00:00:01 untag的数据流" $fileId
        	} else {
        		gwd::GWpublic_print OK "Dev3没有收到smac=00:00:00:00:00:01 untag的数据流" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt2) < $rateL || $aGPNPort4Cnt1(cnt2) > $rateR} {
        		set flag1_case1 1
        		gwd::GWpublic_print NOK "NE1发送tag50(tpid=0x8100)的数据包，NE3($gpnIp3)$GPNTestEth4\收到tag50(tpid=0x8100)的数据流速率为$aGPNPort4Cnt1(cnt2)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print OK "NE1发送tag50(tpid=0x8100)的数据包，NE3($gpnIp3)$GPNTestEth4\收到tag50(tpid=0x8100)的数据流速率为$aGPNPort4Cnt1(cnt2)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt3)!=0} {
        		set flag1_case1 1
        		gwd::GWpublic_print NOK "Dev3收到smac=00:00:00:00:00:03 untag的数据流" $fileId
        	} else {
        		gwd::GWpublic_print OK "Dev3没有收到smac=00:00:00:00:00:03 untag的数据流" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt4)!=0} {
        		set flag1_case1 1
        		gwd::GWpublic_print NOK "Dev3收到smac=00:00:00:00:00:04 untag的数据流" $fileId
        	} else {
        		gwd::GWpublic_print OK "Dev3没有收到smac=00:00:00:00:00:04 untag的数据流" $fileId
        	}
        } else {
        	if {$aGPNPort4Cnt2(cnt1)!=0} {
        		set flag1_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送smac=00:00:00:00:00:01 untag数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率应为0实为$aGPNPort4Cnt1(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送smac=00:00:00:00:00:01 untag数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率应为0实为$aGPNPort4Cnt1(cnt1)" $fileId
		}
        	if {$aGPNPort4Cnt1(cnt2) < $rateL || $aGPNPort4Cnt1(cnt2) > $rateR} {
        		set flag1_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送smac=00:00:00:00:00:03 vid=50 tpid=8100数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率为$aGPNPort4Cnt1(cnt2)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送smac=00:00:00:00:00:03 vid=50 tpid=8100数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率为$aGPNPort4Cnt1(cnt2)，在$rateL-$rateR\范围内" $fileId
		}
        	if {$aGPNPort4Cnt1(cnt3)!=0} {
        		set flag1_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送smac=00:00:00:00:00:03 vid=50 tpid=9100数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率应为0实为$aGPNPort4Cnt1(cnt3)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送smac=00:00:00:00:00:03 vid=50 tpid=9100数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率应为0实为$aGPNPort4Cnt1(cnt3)" $fileId
		}
        	if {$aGPNPort4Cnt1(cnt4)!=0} {
        		set flag1_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送smac=00:00:00:00:00:04 vid=60数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率应为0实为$aGPNPort4Cnt1(cnt4)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送smac=00:00:00:00:00:04 vid=60数据流时，NE3($gpnIp3)$GPNTestEth4\收到数据流的速率应为0实为$aGPNPort4Cnt1(cnt4)" $fileId
		}
        	        		
        }
        if {$aGPNPort3Cnt1(cnt8) < $rateL || $aGPNPort3Cnt1(cnt8) > $rateR} {
        	set flag2_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth4\发送smac=00:00:00:00:00:08 vid=60数据流时，NE1($gpnIp1)$GPNTestEth3\收到数据流vid=60的速率为$aGPNPort3Cnt1(cnt8)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth4\发送smac=00:00:00:00:00:08 vid=60数据流时，NE1($gpnIp1)$GPNTestEth3\收到数据流vid=60的速率为$aGPNPort3Cnt1(cnt8)，在$rateL-$rateR\范围内" $fileId
	}
                	
        ##配置设备NE1
        array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
        gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2 aMirror
        foreach i "aTmpGPNPort2Cnt11 aTmpGPNPort2Cnt12" {
          	array set $i {cnt1 0 cnt2 0} 
        }
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort2AnaFrameCfgFil $::anaFliFrameCfg2
        if {$::cap_enable} {
            	gwd::Start_CapAllData ::capArr $::hGPNPort2Cap $::hGPNPort2CapAnalyzer 
            	gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
        }
        gwd::Start_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort2Ana $::hGPNPort4Ana"
        after 10000
	incr capId
        if {$::cap_enable} {
          	gwd::Stop_CapData $::hGPNPort2Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth2_cap\($gpnIp1\).pcap"	
          	gwd::Stop_CapData $::hGPNPort4Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp1\).pcap"
        }
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt 2 $::hGPNPort2Ana aTmpGPNPort2Cnt11]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 0 0 0
		after 5000
	}
        
        parray aTmpGPNPort2Cnt11
        gwd::Stop_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort2Ana $::hGPNPort4Ana"
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort2AnaFrameCfgFil $::anaFliFrameCfg3
        gwd::Start_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort2Ana $::hGPNPort4Ana"
        after 10000
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt 3 $::hGPNPort2Ana aTmpGPNPort2Cnt12]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 0 0 0
		after 5000
	}
        
        parray aTmpGPNPort2Cnt12
       gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth2_cap\($gpnIp1\).pcap" $fileId
       gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aTmpGPNPort2Cnt11(cnt1)< $rateL1 || $aTmpGPNPort2Cnt11(cnt1) > $rateR1} {
        	set flag3_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth2\收到mpls0_lable=100  mpls1_lable=1000的数据包速率为$aTmpGPNPort2Cnt11(cnt1)，没有在$rateL1-$rateR1\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth2\收到mpls0_lable=100  mpls1_lable=1000的数据包速率为$aTmpGPNPort2Cnt11(cnt1)，在$rateL1-$rateR1\范围内" $fileId
        }
        if {$aTmpGPNPort2Cnt11(cnt2)!=0} {
        	set flag3_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth2\能收到mpls0_lable=1000  mpls1_lable=100的数据包" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth2\不能收到mpls0_lable=1000  mpls1_lable=100的数据包" $fileId
        }
        
        if {$aTmpGPNPort2Cnt12(cnt1)< $rateL1 || $aTmpGPNPort2Cnt12(cnt1) > $rateR1} {
        	set flag3_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth2\收到vid=10  mpls0_exp=000  mpls1_s=1的数据包速率为$aTmpGPNPort2Cnt11(cnt1)，没有在$rateL1-$rateR1\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth2\收到vid=10  mpls0_exp=000  mpls1_s=1的数据包速率为$aTmpGPNPort2Cnt11(cnt1)，在$rateL1-$rateR1\范围内" $fileId
        }
        if {$aTmpGPNPort2Cnt12(cnt2)!=0} {
        	set flag3_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth2\能收到vid=10  mpls0_exp=000  mpls1_s=0的数据包" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth2\不能收到vid=10  mpls0_exp=000  mpls1_s=1的数据包" $fileId
        }
        
        gwd::Stop_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort2Ana $::hGPNPort4Ana"
        gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth2
        puts $fileId ""
        if {$flag1_case1 == 1 || $flag2_case1 == 1 || $flag3_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA1（结论）AC VLAN动作不变的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA1（结论）AC VLAN动作不变的测试" $fileId
        }
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作不变的测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作删除测试开始=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac11" "" $GPNTestEth4 0 0 "delete" 50 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac11" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac11"
	
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort3Stream1 $hGPNPort3Stream3 $hGPNPort3Stream4 $hGPNPort4Stream8" \
		-activate "false"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        	set flag4_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到untag的数据流速率为$aGPNPort4Cnt2(cnt2)，没有在$rateL-$rateR\范围内" $fileId
        } else {
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag4_case1 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=50的数据流速率应为0实为$aGPNPort4Cnt1(cnt2)" $fileId
        	} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到untag的数据流速率为$aGPNPort4Cnt2(cnt2)，在$rateL-$rateR\范围内" $fileId
        	}
        }
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort3Stream2" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort3Stream1 $hGPNPort3Stream3 $hGPNPort3Stream9" \
		-activate "true"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1)!=0} {
        	set flag4_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据流，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据流，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        }
        if {$aGPNPort4Cnt1(cnt3) !=0} {
        	set flag4_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为9100)的数据流，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为9100)的数据流，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        }
        if {$aGPNPort4Cnt1(cnt9)!=0} {
        	set flag4_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100的数据流，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100的数据流，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        }
        puts $fileId ""
        if {$flag4_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA2（结论）AC VLAN动作删除的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA2（结论）AC VLAN动作删除的测试" $fileId
        }
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作删除测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作修改测试开始=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac11"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac11"
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac12" "" $GPNTestEth4 0 0 "modify" 80 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac12" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac12"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag5_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到untag的数据流速率为$aGPNPort4Cnt2(cnt2)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到untag的数据流速率为$aGPNPort4Cnt2(cnt2)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt11)!=0} {
        		set flag5_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=80(TPID为8100)的数据包" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt2) !=0} {
        		set flag5_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=50(TPID为8100)的数据包" $fileId
        	}
        } else {
        	if {$aGPNPort4Cnt1(cnt11) < $rateL || $aGPNPort4Cnt1(cnt11) > $rateR} {
        		set flag5_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=80(TPID为8100)的数据包速率为$aGPNPort4Cnt1(cnt11)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=80(TPID为8100)的数据包速率为$aGPNPort4Cnt1(cnt11)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag5_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=50(TPID为8100)的数据流速率应为0实为$aGPNPort4Cnt1(cnt2)" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=50(TPID为8100)的数据流速率应为0实为$aGPNPort4Cnt1(cnt2)" $fileId
        	}
        }
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1)!=0} {
        	set flag5_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据流，NE3($gpnIp3)$GPNTestEth4\收到untag的数据流应为0实为$aGPNPort4Cnt2(cnt1)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据流，NE3($gpnIp3)$GPNTestEth4\收到untag的数据流应为0实为$aGPNPort4Cnt2(cnt1)" $fileId
        }
        if {$aGPNPort4Cnt1(cnt3) !=0 } {
        	set flag5_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为9100)的数据流，NE3($gpnIp3)$GPNTestEth4\能收到数据流" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为9100)的数据流，NE3($gpnIp3)$GPNTestEth4\不能收到数据流" $fileId
        }
        if {$aGPNPort4Cnt1(cnt9)!=0} {
        	set flag5_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100(TPID为8100)的数据流，NE3($gpnIp3)$GPNTestEth4\能收到数据流" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100(TPID为8100)的数据流，NE3($gpnIp3)$GPNTestEth4\不能收到数据流" $fileId
        }
        puts $fileId ""
        if {$flag5_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA3（结论）AC VLAN动作修改的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA3（结论）AC VLAN动作修改的测试" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作修改测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作添加测试开始=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac12"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac12"
        gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
        if {[string match "8FX" $porttype3]} {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" "l2transport" "3" "" $address2 "1000" "1000" "2" "delete" "" 1 0 "0x8100" "0x9100" ""
        	
        } else {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" "l2transport" "3" "" $address2 "1000" "1000" "2" "nochange" "" 1 0 "0x8100" "0x9100" ""
        }
        gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" result
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac13" "" $GPNTestEth4 0 0 "add" 100 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac13" "pw12" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac13"
        stc::perform streamBlockActivate \
        	-streamBlockList "$hGPNPort3Stream1 $hGPNPort3Stream3 $hGPNPort3Stream9" \
        	-activate "false"
        stc::perform streamBlockActivate \
        	-streamBlockList "$hGPNPort3Stream2" \
        	-activate "true"
        
        foreach i "aTmpGPNPort4Cnt11" {
          	array set $i {cnt2 0 cnt12 0}
        }
        if {![string match "8FX" $porttype4]} {
        	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg4
        	if {$::cap_enable} {
            		gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
        	}
        	gwd::Start_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort4Ana"
        	after 10000
		incr capId
        	if {$::cap_enable} {
          		gwd::Stop_CapData $::hGPNPort4Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap"
        	}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt 1 $::hGPNPort4Ana aTmpGPNPort4Cnt11]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 0 1 0 0
			after 5000
		}
        	
        	parray aTmpGPNPort4Cnt11
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        	if {$aTmpGPNPort4Cnt11(cnt12) < $rateL || $aTmpGPNPort4Cnt11(cnt12) > $rateR} {
        		set flag6_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag1=100 tag2=50的双层数据包速率为$aTmpGPNPort4Cnt11(cnt12)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag1=100 tag2=50的双层数据包速率为$aTmpGPNPort4Cnt11(cnt12)，在$rateL-$rateR\范围内" $fileId
        	}
        	if { $aTmpGPNPort4Cnt11(cnt2)!=0} {
        		set flag6_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=50(TPID为8100)的单层数据包" $fileId
        	}
        } else {
        	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg0
        	if {$::cap_enable} {
        		    gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
        	}
        	gwd::Start_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort4Ana"
        	after 10000
		incr capId
        	if {$::cap_enable} {
        		  gwd::Stop_CapData $::hGPNPort4Cap 0 "GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap"
        	}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt 0 $::hGPNPort4Ana aTmpGPNPort4Cnt11]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 0 1 0 0
			after 5000
		}
        	
        	parray aTmpGPNPort4Cnt11
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        	if {$aTmpGPNPort4Cnt2(cnt2) < $rateL || $aTmpGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag6_case1 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到untag数据包速率为$aTmpGPNPort4Cnt2(cnt2)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到untag数据包速率为$aTmpGPNPort4Cnt2(cnt2)，在$rateL-$rateR\范围内" $fileId
        	}
        }	
        gwd::Stop_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort4Ana"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1)!=0} {
        	set flag6_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据流，NE3($gpnIp3)$GPNTestEth4\能收到数据流" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据流，NE3($gpnIp3)$GPNTestEth4\不能收到数据流" $fileId
        }
        if {$aGPNPort4Cnt1(cnt3) !=0} {
        	set flag6_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为9100)的数据流，NE3($gpnIp3)$GPNTestEth4\能收到数据流" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为9100)的数据流，NE3($gpnIp3)$GPNTestEth4\不能收到数据流" $fileId
        }
        if {$aGPNPort4Cnt1(cnt9)!=0} {
        	set flag6_case1 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100(TPID为8100)的数据流，NE3($gpnIp3)$GPNTestEth4\能收到数据流" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100(TPID为8100)的数据流，NE3($gpnIp3)$GPNTestEth4\不能收到数据流" $fileId
        }
        puts $fileId ""
        if {$flag6_case1 == 1} {
        	set flagCase1 1
        	gwd::GWpublic_print "NOK" "FA4（结论）AC VLAN动作添加的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA4（结论）AC VLAN动作添加的测试" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作添加测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
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
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 $porttype4\端口ELine业务PW VLAN动作验证\n"
        #   <1>删除NE1和NE2设备的所配置专线业务（AC）和伪线（PW1），删除成功，系统无异常
        #   <2>配置NE1的PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，用户侧（GE端口）接入模式为“端口模式+运营商VLAN”端口模式，运营商VLAN为 VLAN 50；
        #      配置NE2的PW1本地标签1000，远程标签1000；PW和AC的VLAN动作均为不变，PW和AC的匹配TPID为0x8100，用户侧（GE端口）接入模式为“端口模式”端口模式，
        #   <3>NE1和NE2用户测配置undo vlan check
        #   <4>向NE1端口A发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的端口B接收结果;
        #   预期结果：B可接收到带有VID 50数据流；向NE1端口A发送untag/tag50（TPID为0x9100）/tag100数据流，观察NE2的端口B接受结果，未收到数据流
        ##PW VLAN动作为删除
        #   <5>删除NE1设备的专线业务（AC）和伪线（PW1），更改PW1的VLAN动作为删除，其他配置信息保持不变
        #   <6>向NE1端口A发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的端口B接受结果
        #   预期结果：B可接收到untag数据流；向NE1端口A发送untag/tag50（TPID为0x9100）/tag100数据流，观察NE2的端口B接受结果，未收到数据流
        ##PW VLAN动作为修改
        #   <7>删除NE1设备的专线业务（AC）和伪线（PW1），更改PW1的VLAN动作为修改（修改为 VID=80），其他配置信息保持不变 
        #   <8>向NE1端口A发送带有VID 50并匹配规则数据流，观察NE2的端口B接受结果;
        #   预期结果：B可接收到带有VID 80数据流；向NE1端口A发送untag 、tag100数据流，观察NE2的端口B接受结果，未收到数据流
        ##PW VLAN动作为添加
        #   <9>删除NE1设备的专线业务（AC）和伪线（PW1），更改PW1的VLAN动作为添加（添加VID=100），更改AC的匹配TPID为0x9100，其他配置信息保持不变
        #   <10>向NE1端口A发送带有VID 50（TPID为0x8100）并匹配规则数据流，观察NE2的端口B接受结果
        #   预期结果：B可接收到带有双层标签的数据流（外层100，内层50）；向NE1端口A发送untag/tag50（TPID为0x9100）/tag100数据流，观察NE2的端口B接受结果，未收到数据流
        set flag1_case2 0
        set flag2_case2 0
        set flag3_case2 0
        set flag4_case2 0

	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作不变的测试开始=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac13"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac13"
        gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw12"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw12"
        if {[string match "8FX" $porttype4]} {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "delete" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
        } else {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "nochange" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
        }
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 0 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        ###配置设备NE1
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        if {[string match "8FX" $porttype3]} {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "delete" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
        } else {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
        }
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream4 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort4Stream8 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt2(cnt1)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据流，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据流，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID=8100)的数据包，NE3($gpnIp3)$GPNTestEth4\能收到tag=50(TPID=8100)的数据包" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID=8100)的数据包，NE3($gpnIp3)$GPNTestEth4\不能收到tag=50(TPID=8100)的数据包" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID=8100)的数据流，NE3($gpnIp3)$GPNTestEth4\收到untag的数据包速率为$aGPNPort4Cnt2(cnt2)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID=8100)的数据流，NE3($gpnIp3)$GPNTestEth4\收到untag的数据包速率为$aGPNPort4Cnt2(cnt2)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt3)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID=9100)的数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID=9100)的数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt4)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=60(TPID=8100)的数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=60(TPID=8100)的数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	array set aTmpGPNPort3Cnt11 {cnt17 0} 
        	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg4
        	if {$::cap_enable} {
        		gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
        	}
        	gwd::Start_SendFlow "$::hGPNPort4Gen"  "$::hGPNPort3Ana"
        	after 10000
		incr capId
        	if {$::cap_enable} {
        		gwd::Stop_CapData $::hGPNPort3Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap"
        	}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt 1 $::hGPNPort3Ana aTmpGPNPort3Cnt11]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 0 0 0
			after 5000
		}
        	
        	parray aTmpGPNPort3Cnt11
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
        	if {$aTmpGPNPort3Cnt11(cnt17) < $rateL || $aTmpGPNPort3Cnt11(cnt17) > $rateR} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth4\发送tag=60(TPID=8100)的数据流，NE1($gpnIp1)$GPNTestEth3\收到vid1=$vid8fx vid2=60的数据包速率为$aTmpGPNPort3Cnt11(cnt17)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth4\发送tag=60(TPID=8100)的数据流，NE1($gpnIp1)$GPNTestEth3\收到vid1=$vid8fx vid2=60的数据包速率为$aTmpGPNPort3Cnt11(cnt17)，在$rateL-$rateR\范围内" $fileId
        	}
        	gwd::Stop_SendFlow "$::hGPNPort4Gen"  "$::hGPNPort3Ana"
        } else {
        	if {$aGPNPort4Cnt2(cnt1)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据流，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据流，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        		
        	if {$aGPNPort4Cnt1(cnt2) < $rateL || $aGPNPort4Cnt1(cnt2) > $rateR} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID=8100)的数据流，NE3($gpnIp3)$GPNTestEth4\收到tag=50(TPID=8100)的数据包速率为$aGPNPort4Cnt2(cnt2)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID=8100)的数据流，NE3($gpnIp3)$GPNTestEth4\收到tag=50(TPID=8100)的数据包速率为$aGPNPort4Cnt2(cnt2)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt3)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID=9100)的数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID=9100)的数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt4)!=0} {
        		set flag1_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=60(TPID=8100)的数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=60(TPID=8100)的数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        }
        puts $fileId ""
        if {$flag1_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA5（结论）PW VLAN动作不变的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA5（结论）PW VLAN动作不变的测试" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作不变的测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作删除测试开始=====\n"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "l2transport" "2" "" $address1 "1000" "1000" "1" "delete" "" 50 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" result
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw2" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream4 "FALSE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag2_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=50(TPID为8100)的数据包" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\不能收到tag=50(TPID为8100)的数据包" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag2_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到untag数据包速率为$aGPNPort4Cnt2(cnt2)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到untag数据包速率为$aGPNPort4Cnt2(cnt2)，在$rateL-$rateR\范围内" $fileId
        	}
        	
        	if {$aGPNPort3Cnt1(cnt8) < $rateL || $aGPNPort3Cnt1(cnt8) > $rateR} {
        		set flag2_case2 1
        		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth4\发送tag=60(TPID为8100)，NE1($gpnIp1)$GPNTestEth3\收到untag数据包速率为$aGPNPort3Cnt1(cnt8)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth4\发送tag=60(TPID为8100)，NE1($gpnIp1)$GPNTestEth3\收到untag数据包速率为$aGPNPort3Cnt1(cnt8)，在$rateL-$rateR\范围内" $fileId
        	}
        } else {
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag2_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=50(TPID为8100)的数据包" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\不能收到tag=50(TPID为8100)的数据包" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag2_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到untag数据包速率为$aGPNPort4Cnt2(cnt2)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到untag数据包速率为$aGPNPort4Cnt2(cnt2)，在$rateL-$rateR\范围内" $fileId
        	}
        }
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1) != 0} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        }
        if {$aGPNPort4Cnt1(cnt3) !=0} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为9100)，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为9100)，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        }
        if {$aGPNPort4Cnt1(cnt9)!=0} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        }
        puts $fileId ""
        if {$flag2_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA6（结论）PW VLAN删除的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA6（结论）PW VLAN删除的测试" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作删除的测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作修改测试开始=====\n"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" "l2transport" "3" "" $address1 "1000" "1000" "1" "modify" "" 80 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" result
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw3" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag3_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到untag数据包速率为$aGPNPort4Cnt2(cnt2)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到untag数据包速率为$aGPNPort4Cnt2(cnt2)，在$rateL-$rateR\范围内" $fileId
        	}
        	array set aTmpGPNPort3Cnt11 {cnt18 0} 
        	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg4
        	if {$::cap_enable} {
        		gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
        	}
        	gwd::Start_SendFlow "$::hGPNPort4Gen"  "$::hGPNPort3Ana"
        	after 10000
        	if {$::cap_enable} {
        		gwd::Stop_CapData $::hGPNPort3Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap"
        	}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt 1 $::hGPNPort3Ana aTmpGPNPort3Cnt11]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 0 0 0
			after 5000
		}
        	
        	parray aTmpGPNPort3Cnt11
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
        	if {$aTmpGPNPort3Cnt11(cnt17) < $rateL || $aTmpGPNPort3Cnt11(cnt17) > $rateR} {
        		set flag3_case2 1
        		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth4\发送tag=60(TPID=8100)的数据流，NE1($gpnIp1)$GPNTestEth3\收到vid1=$vid8fx vid2=60的数据包速率为$aTmpGPNPort3Cnt11(cnt17)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth4\发送tag=60(TPID=8100)的数据流，NE1($gpnIp1)$GPNTestEth3\收到vid1=$vid8fx vid2=60的数据包速率为$aTmpGPNPort3Cnt11(cnt17)，在$rateL-$rateR\范围内" $fileId
        	}
        	gwd::Stop_SendFlow "$::hGPNPort4Gen"  "$::hGPNPort3Ana"
        } else {
        	if {$aGPNPort4Cnt1(cnt11) < $rateL || $aGPNPort4Cnt1(cnt11) > $rateR} {
        		set flag3_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=80(TPID为8100)数据包速率为$aGPNPort4Cnt1(cnt11)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=80(TPID为8100)数据包速率为$aGPNPort4Cnt1(cnt11)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag3_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\能收到tag=50(TPID为8100)的数据包" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\不能收到tag=50(TPID为8100)的数据包" $fileId
        	}
        }
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1)!=0} {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        }
        if { $aGPNPort4Cnt1(cnt3) !=0 } {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(tpid=0x9100)的数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(tpid=0x9100)的数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        }
        if {$aGPNPort4Cnt1(cnt9)!=0} {
        	set flag3_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100(tpid=0x8100)的数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100(tpid=0x8100)的数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        }
        puts $fileId ""
        if {$flag3_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA7（结论）PW VLAN修改的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA7（结论）PW VLAN修改的测试" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作修改的测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作添加测试开始=====\n"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw4" "l2transport" "4" "" $address1 "1000" "1000" "1" "add" "" 100 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw4" result
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 0 "nochange" 1 0 0 "0x9100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw4" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
        foreach i "aTmpGPNPort3Cnt12 aTmpGPNPort4Cnt12" {
          	array set $i {cnt2 0 cnt12 0 cnt19 0} 
        }
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg4
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg4
        if {$::cap_enable} {
            	gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
        	gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
        }
        gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
        after 10000
	incr capId
        if {$::cap_enable} {
          	gwd::Stop_CapData $::hGPNPort3Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap"
        	gwd::Stop_CapData $::hGPNPort4Cap 1 "GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap"
        } 
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt 1 $::hGPNPort3Ana aTmpGPNPort3Cnt12]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt 1 $::hGPNPort4Ana aTmpGPNPort4Cnt12]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
        parray aTmpGPNPort3Cnt12
        parray aTmpGPNPort4Cnt12
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt2(cnt2) < $rateL || $aGPNPort4Cnt2(cnt2) > $rateR} {
        		set flag4_case2 1
        		puts -nonewline $fileId [format "%-47s" "PW动作添加，NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到数据流异常"] 
        		puts $fileId "NOK"
        	}
        	if {$aGPNPort3Cnt12(cnt19) < $rateL || $aGPNPort3Cnt12(cnt19) > $rateR} {
        		set flag4_case2 1
        		puts -nonewline $fileId [format "%-47s" "PW动作添加，NE3($gpnIp3)$GPNTestEth4\发送tag=60(TPID为8100)，NE1($gpnIp1)$GPNTestEth3\收到数据流异常"] 
        		puts $fileId "NOK"
        	}
        } else {
        	if {$aTmpGPNPort4Cnt12(cnt12) < $rateL || $aTmpGPNPort4Cnt12(cnt12) > $rateR} {
        		set flag4_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=50(TPID为8100)tag=100(TPID为8100)数据包速率为$aTmpGPNPort4Cnt12(cnt12)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\收到tag=50(TPID为8100)tag=100(TPID为8100)数据包速率为$aTmpGPNPort4Cnt12(cnt12)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aTmpGPNPort4Cnt12(cnt2)!=0} {
        		set flag4_case2 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\能收到tag=50(TPID为8100)数据包" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(TPID为8100)，NE3($gpnIp3)$GPNTestEth4\不能收到tag=50(TPID为8100)数据包" $fileId
        	}
        }
        gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "TRUE"
	incr capId
        sendAndStat aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth3_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {$aGPNPort4Cnt2(cnt1)!=0} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送untag的数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        }
        if {$aGPNPort4Cnt1(cnt3) !=0} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(tpid=0x9100)的数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=50(tpid=0x9100)的数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        }
        if {$aGPNPort4Cnt1(cnt9)!=0} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100(tpid=0x8100)的数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送tag=100(tpid=0x8100)的数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        }
        puts $fileId ""
        if {$flag4_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FA8（结论）PW VLAN添加的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA8（结论）PW VLAN添加的测试" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作添加的测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
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
	puts $fileId "Test Case 2 $porttype4\端口ELine业务PW动作测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 在用户侧端口接入模式为“端口+运营商VLAN+客户VLAN”下，VLAN动作验证\n"
        #   <1>将UNI端口更改为FE端口，其他条件不变，重复以上步骤
        #   <2>将NNI端口更改为10GE端口，UNI端口为FE/GE端口，其他条件不变，重复以上步骤
        #   <3>将NNI端口更改为LAG接口，UNI端口为FE/GE端口，其他条件不变，重复以上步骤
        #   <4>在用户侧端口接入模式为“端口+运营商VLAN+客户VLAN”下，分别验证PW/AC的VLAN动作删除、添加、修改、不变均生效
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作不变的测试开始=====\n"
        gwd::Cfg_StreamActive $hGPNPort4Stream8 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream1 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream3 "FALSE"
        gwd::Cfg_StreamActive $hGPNPort3Stream9 "FALSE"
        set flag1_case3 0
        set flag2_case3 0
        set flag3_case3 0
        set flag4_case3 0
        set flag5_case3 0
        set flag6_case3 0
        set flag7_case3 0
        set flag8_case3 0
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw4"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw4"
        if {[string match "8FX" $porttype4]} {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "delete" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
        } else {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
        }
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 30 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        ####NE1($gpnIp1)$GPNTestEth3\发送tag=50,外层vlan50，内层30（TPID=8100）,外层vlan50，内层30（TPID=9100）,外层vlan50，内层20（TPID=8100）四条数据流
        gwd::Cfg_StreamActive $hGPNPort3Stream2 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream10 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream11 "TRUE"
        gwd::Cfg_StreamActive $hGPNPort3Stream12 "TRUE"
        incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	
        } else {
        	if {$aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR || $aGPNPort4Cnt4(cnt13) < $rateL || $aGPNPort4Cnt4(cnt13) > $rateR} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100），NE3($gpnIp3)$GPNTestEth4\收到外层vlan50，内层30（TPID=8100）数据包速率为$aGPNPort4Cnt4(cnt13)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100），NE3($gpnIp3)$GPNTestEth4\收到外层vlan50，内层30（TPID=8100）数据包速率为$aGPNPort4Cnt4(cnt13)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt2)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\能收到vlan50单层数据包" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\不能收到vlan50单层数据包" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	
        	if {$aGPNPort4Cnt4(cnt14)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到外层vlan50，内层20（TPID=8100）数据包" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到外层vlan50，内层20（TPID=8100）数据包" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        }
        puts $fileId ""
        if {$flag1_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FA9（结论）AC VLAN不变的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA9（结论）AC VLAN不变的测试" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作不变的测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作删除测试开始=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac11" "" $GPNTestEth4 0 0 "delete" 50 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac11" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac11"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	
        } else {
        	if {$aGPNPort4Cnt4(cnt10)!=0} {
        		set flag2_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到外层vlan50，内层30（TPID=8100）数据包" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到外层vlan50，内层30（TPID=8100）数据包" $fileId
        	}
        	if {$aGPNPort4Cnt1(cnt15) < $rateL || $aGPNPort4Cnt1(cnt15) > $rateR} {
        		set flag2_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\收到单层tag=30的数据包速率为$aGPNPort4Cnt1(cnt15)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\收到单层tag=30的数据包速率为$aGPNPort4Cnt1(cnt15)，在$rateL-$rateR\范围内" $fileId
        	}	
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0 } {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag1_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        }
        puts $fileId ""
        if {$flag2_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB1（结论）AC VLAN删除的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB1（结论）AC VLAN删除的测试" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作删除的测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作修改测试开始=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac11"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac11"
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac12" "" $GPNTestEth4 0 0 "modify" 80 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac12" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac12"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt1(cnt15)!=0 || $aGPNPort4Cnt4(cnt16) !=0 || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR\
        		|| $aGPNPort4Cnt1(cnt2)!=0 || $aGPNPort4Cnt2(cnt2)!=0  || $aGPNPort4Cnt4(cnt13)!=0 || $aGPNPort4Cnt2(cnt13)!=0 || $aGPNPort4Cnt4(cnt14)!=0 || $aGPNPort4Cnt2(cnt14)!=0
        	} {
        		set flag3_case3 1
        		puts -nonewline $fileId [format "%-45s" "ac动作修改，NE1($gpnIp1)$GPNTestEth3\发送四条数据流，NE3($gpnIp3)$GPNTestEth4\收到数据流异常"] 
        		puts $fileId "NOK"
        	}
        	
        } else {
        	if {$aGPNPort4Cnt4(cnt16) < $rateL || $aGPNPort4Cnt4(cnt16) > $rateR || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR} {
        		set flag3_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\收到外层vlan80，内层30的数据包速率为$aGPNPort4Cnt4(cnt16)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\收到外层vlan80，内层30的数据包速率为$aGPNPort4Cnt4(cnt16)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag3_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0 } {
        		set flag3_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag3_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        }
        puts $fileId ""
        if {$flag3_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB2（结论）AC VLAN修改的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB2（结论）AC VLAN修改的测试" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作修改的测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作添加测试开始=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac12"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac12"
        gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"
        if {![string match "8FX" $porttype4]} {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" "l2transport" "3" "" $address2 "1000" "1000" "2" "nochange" "" 1 0 "0x8100" "0x9100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" result
        } else {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" "l2transport" "3" "" $address2 "1000" "1000" "2" "delete" "" 1 0 "0x8100" "0x9100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw12" result
        }
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac13" "" $GPNTestEth4 0 0 "add" 100 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac13" "pw12" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac13"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt4(cnt16) !=0 || $aGPNPort4Cnt4(cnt12) !=0 || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR\
        		|| $aGPNPort4Cnt1(cnt2)!=0 || $aGPNPort4Cnt2(cnt2)!=0  || $aGPNPort4Cnt4(cnt13)!=0 || $aGPNPort4Cnt2(cnt13)!=0 || $aGPNPort4Cnt4(cnt14)!=0 || $aGPNPort4Cnt2(cnt14)!=0
        	} {
        		set flag4_case3 1
        		puts -nonewline $fileId [format "%-45s" "ac动作添加，NE1($gpnIp1)$GPNTestEth3\发送四条数据流，NE3($gpnIp3)$GPNTestEth4\收到数据流异常"] 
        		puts $fileId "NOK"
        	}
        	
        } else {
        	if {$aGPNPort4Cnt4(cnt12) < $rateL || $aGPNPort4Cnt4(cnt12) > $rateR || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR} {
        		set flag4_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\收到外层vlan100，内层50 30的数据包速率为$aGPNPort4Cnt4(cnt12)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\收到外层vlan100，内层50 30的数据包速率为$aGPNPort4Cnt4(cnt12)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag4_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0 } {
        		set flag4_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag4_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        }
        puts $fileId ""
        if {$flag4_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB3（结论）AC VLAN添加的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB3（结论）AC VLAN添加的测试" $fileId
        }
        puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====AC VLAN动作添加的测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作不变测试开始=====\n"
        gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac13"
        gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac13"
        gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw12"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw12"
        if {![string match "8FX" $porttype4]} {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "nochange" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
        } else {
        	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" "l2transport" "2" "" $address2 "1000" "1000" "2" "delete" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet3 $matchType3 $Gpn_type3 $fileId "pw1" result
        }
        gwd::GWpublic_CfgAc $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "" $GPNTestEth4 0 0 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" 
        ###配置设备NE1
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        if {![string match "8FX" $porttype4]} {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "nochange" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
        } else {
        	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address1 "1000" "1000" "1" "delete" "" 1 0 "0x8100" "0x8100" ""
        	gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
        }
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 30 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt4(cnt10) !=0 || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR\
        		|| $aGPNPort4Cnt1(cnt2)!=0 || $aGPNPort4Cnt2(cnt2)!=0 || $aGPNPort4Cnt2(cnt13)!=0 || $aGPNPort4Cnt4(cnt14)!=0 || $aGPNPort4Cnt2(cnt14)!=0
        	} {
        		set flag5_case3 1
        		puts -nonewline $fileId [format "%-47s" "PW动作不变，NE1发送四条数据流，NE3($gpnIp3)$GPNTestEth4\收到数据流异常"] 
        		puts $fileId "NOK"
        	}
        	 
        } else {
        	if {$aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR || $aGPNPort4Cnt4(cnt10) < $rateL || $aGPNPort4Cnt4(cnt10) > $rateR} {
        		set flag5_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100），NE3($gpnIp3)$GPNTestEth4\收到外层vlan50，内层30（TPID=8100）数据包速率为$aGPNPort4Cnt4(cnt10)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100），NE3($gpnIp3)$GPNTestEth4\收到外层vlan50，内层30（TPID=8100）数据包速率为$aGPNPort4Cnt4(cnt10)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag5_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0} {
        		set flag5_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag5_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        }
        puts $fileId ""
        if {$flag5_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB4（结论）PW VLAN不变的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB4（结论）PW VLAN不变的测试" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作不变的测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作删除测试开始=====\n"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "l2transport" "2" "" $address1 "1000" "1000" "1" "delete" "" 50 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" result
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 30 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw2" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt4(cnt10)!=0 || $aGPNPort4Cnt1(cnt15) !=0 || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR\
        		|| $aGPNPort4Cnt1(cnt2)!=0 || $aGPNPort4Cnt2(cnt2)!=0  || $aGPNPort4Cnt4(cnt13)!=0 || $aGPNPort4Cnt2(cnt13)!=0 || $aGPNPort4Cnt4(cnt14)!=0 || $aGPNPort4Cnt2(cnt14)!=0
        		} {
        			set flag6_case3 1
        			puts -nonewline $fileId [format "%-45s" "PW动作删除，NE1($gpnIp1)$GPNTestEth3\发送四条数据流，NE3($gpnIp3)$GPNTestEth4\收到数据流异常"] 
        			puts $fileId "NOK"
        		}
        } else {
        	if {$aGPNPort4Cnt1(cnt15) < $rateL || $aGPNPort4Cnt1(cnt15) > $rateR} {
        		set flag6_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100），NE3($gpnIp3)$GPNTestEth4\收到单层vlan30的数据包速率为$aGPNPort4Cnt1(cnt15)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100），NE3($gpnIp3)$GPNTestEth4\收到单层vlan30的数据包速率为$aGPNPort4Cnt1(cnt15)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag6_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0} {
        		set flag6_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag6_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        }
        puts $fileId ""
        if {$flag6_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB5（结论）PW VLAN删除的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB5（结论）PW VLAN删除的测试" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作删除的测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作修改测试开始=====\n"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" "l2transport" "3" "" $address1 "1000" "1000" "1" "modify" "" 80 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" result
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 30 "nochange" 1 0 0 "0x8100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw3" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt1(cnt15)!=0 || $aGPNPort4Cnt4(cnt16) !=0 || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR\
        		|| $aGPNPort4Cnt1(cnt2)!=0 || $aGPNPort4Cnt2(cnt2)!=0  || $aGPNPort4Cnt4(cnt13)!=0 || $aGPNPort4Cnt2(cnt13)!=0 || $aGPNPort4Cnt4(cnt14)!=0 || $aGPNPort4Cnt2(cnt14)!=0
        		} {
        			set flag7_case3 1
        			puts -nonewline $fileId [format "%-45s" "PW动作修改，NE1($gpnIp1)$GPNTestEth3\发送四条数据流，NE3($gpnIp3)$GPNTestEth4\收到数据流异常"] 
        			puts $fileId "NOK"
        		}
        } else {
        	if {$aGPNPort4Cnt4(cnt16) < $rateL || $aGPNPort4Cnt4(cnt16) > $rateR || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR} {
        		set flag7_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100），NE3($gpnIp3)$GPNTestEth4\收到外层vlan80，内层30的数据包速率为$aGPNPort4Cnt4(cnt16)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100），NE3($gpnIp3)$GPNTestEth4\收到外层vlan80，内层30的数据包速率为$aGPNPort4Cnt4(cnt16)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag7_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0} {
        		set flag7_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag7_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        }
        puts $fileId ""
        if {$flag7_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB6（结论）PW VLAN修改的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB6（结论）PW VLAN修改的测试" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作修改的测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作添加测试开始=====\n"
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw4" "l2transport" "4" "" $address1 "1000" "1000" "1" "add" "" 100 0 "0x8100" "0x8100" ""
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw4" result
        gwd::GWpublic_CfgAc $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "" $GPNTestEth3 50 30 "nochange" 1 0 0 "0x9100"
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac50" "pw4" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"
	incr capId
        sendAndStat1 aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 "GPN_PTN_002_2_$capId"
        parray aGPNPort4Cnt4
        parray aGPNPort4Cnt1
        parray aGPNPort4Cnt2
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_002_2_$capId-p$::GPNTestEth4_cap\($gpnIp3\).pcap" $fileId
        if {[string match "8FX" $porttype4]} {
        	if {$aGPNPort4Cnt4(cnt16)!=0 ||$aGPNPort4Cnt4(cnt12) !=0 || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR\
        		 || $aGPNPort4Cnt1(cnt2)!=0 || $aGPNPort4Cnt2(cnt2)!=0  || $aGPNPort4Cnt4(cnt13)!=0 || $aGPNPort4Cnt2(cnt13)!=0 || $aGPNPort4Cnt4(cnt14)!=0 || $aGPNPort4Cnt2(cnt14)!=0
        	} {
        		set flag8_case3 1
        		puts -nonewline $fileId [format "%-45s" "PW动作添加，NE1($gpnIp1)$GPNTestEth3\发送四条数据流，NE3($gpnIp3)$GPNTestEth4\收到数据流异常"] 
        		puts $fileId "NOK"
        	}
        } else {
        	if {$aGPNPort4Cnt4(cnt12) < $rateL || $aGPNPort4Cnt4(cnt12) > $rateR || $aGPNPort4Cnt2(cnt10) < $rateL || $aGPNPort4Cnt2(cnt10) > $rateR} {
        		set flag8_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\收到外层vlan100，内层50 30的数据包速率为$aGPNPort4Cnt4(cnt12)，没有在$rateL-$rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\收到外层vlan100，内层50 30的数据包速率为$aGPNPort4Cnt4(cnt12)，在$rateL-$rateR\范围内" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt2)!=0} {
        		set flag8_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送vlan50单层数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt13)!=0 } {
        		set flag8_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层30（TPID=9100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        	if {$aGPNPort4Cnt2(cnt14)!=0} {
        		set flag8_case3 1
        		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\能收到" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth3\发送外层vlan50，内层20（TPID=8100）数据包，NE3($gpnIp3)$GPNTestEth4\不能收到" $fileId
        	}
        }
        puts $fileId ""
        if {$flag8_case3 == 1} {
        	set flagCase3 1
        	gwd::GWpublic_print "NOK" "FB7（结论）PW VLAN添加的测试" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB7（结论）PW VLAN添加的测试" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====PW VLAN动作添加的测试结束=====\n"
        incr tcId
        gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_002_2_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_002_2" lFailFileTmp]
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
	puts $fileId "Test Case 3 在用户侧端口接入模式为“端口+运营商VLAN+客户VLAN”下，VLAN动作验证  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===恢复初始化配置...\n"
        lappend flagDel [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
        lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac50"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw4"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw4"]
        lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface11 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface12 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface13 $matchType1 $Gpn_type1 $telnet1]
        
        lappend flagDel [gwd::GWAc_DelActPw $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
        lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"]
        lappend flagDel [gwd::GWpublic_delPwStaticPara $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"]
        lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw1"]
        lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp1"]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface10 $matchType3 $Gpn_type3 $telnet3]
	
	if {[string match "L2" $Worklevel]} {
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort6 "none"]
		lappend flagDel [gwd::GWpublic_CfgVlanCheck  $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth4 "enable"]
	}
	if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        	foreach port1 $portList1 {
			lappend flagDel [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port1 "enable" "disable"]
        	}
		foreach port3 $portList3 {
			lappend flagDel [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port3 "enable" "disable"]
		}
        } 
        
        if {[string match "8FX" $porttype3]} {
		lappend flagDel [gwd::GWpublic_addMplsEn $telnet1 $matchType1 $Gpn_type1 $fileId "disable" $slot3]
		lappend flagDel [gwd::GWL2Inter_DelVlan $telnet1 $matchType1 $Gpn_type1 $fileId "4078-4085"]
        }
        if {[string match "8FX" $porttype4]} {
		lappend flagDel [gwd::GWpublic_addMplsEn $telnet3 $matchType3 $Gpn_type3 $fileId "disable" $slot4]
		lappend flagDel [gwd::GWL2Inter_DelVlan $telnet3 $matchType3 $Gpn_type3 $fileId "4078-4085"]
        }
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "测试结束后配置恢复" "测试结束后配置恢复" "GPN_PTN_002_2"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "测试过程中所有配置文件都上传成功" "GPN_PTN_002_2"
	
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_002_2测试目的：E-LINE PW/AC vlan动作验证\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1==1 || $flagCase2==1 || $flagCase3==1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_002_2测试结果" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3测试结果" $fileId
	puts $fileId ""
	puts $fileId ""
        gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1 || $flag2_case1 == 1 || $flag3_case1 == 1) ? "NOK" : "OK"}]" "AC VLAN动作不变的测试" $fileId
        gwd::GWpublic_print "== FA2 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+客户VLAN：AC VLAN动作删除的测试" $fileId
        gwd::GWpublic_print "== FA3 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+客户VLAN：AC VLAN动作修改的测试" $fileId
        gwd::GWpublic_print "== FA4 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+客户VLAN：AC VLAN动作添加的测试" $fileId
        gwd::GWpublic_print "== FA5 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+客户VLAN：PW VLAN动作不变的测试" $fileId
        gwd::GWpublic_print "== FA6 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+客户VLAN：PW VLAN动作删除的测试" $fileId
        gwd::GWpublic_print "== FA7 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+客户VLAN：PW VLAN动作修改的测试" $fileId
        gwd::GWpublic_print "== FA8 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+客户VLAN：PW VLAN动作添加的测试" $fileId
        gwd::GWpublic_print "== FA9 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+运营商VLAN+客户VLAN：AC VLAN动作不变的测试" $fileId
        gwd::GWpublic_print "== FB1 == [expr {($flag2_case3 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+运营商VLAN+客户VLAN：AC VLAN动作删除的测试" $fileId
        gwd::GWpublic_print "== FB2 == [expr {($flag3_case3 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+运营商VLAN+客户VLAN：AC VLAN动作修改的测试" $fileId
        gwd::GWpublic_print "== FB3 == [expr {($flag4_case3 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+运营商VLAN+客户VLAN：AC VLAN动作添加的测试" $fileId
        gwd::GWpublic_print "== FB4 == [expr {($flag5_case3 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+运营商VLAN+客户VLAN：PW VLAN动作不变的测试" $fileId
        gwd::GWpublic_print "== FB5 == [expr {($flag6_case3 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+运营商VLAN+客户VLAN：PW VLAN动作删除的测试" $fileId
        gwd::GWpublic_print "== FB6 == [expr {($flag7_case3 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+运营商VLAN+客户VLAN：PW VLAN动作修改的测试" $fileId
        gwd::GWpublic_print "== FB7 == [expr {($flag8_case3 == 1) ? "NOK" : "OK"}]" "端口接入模式为端口+运营商VLAN+客户VLAN：PW VLAN动作添加的测试" $fileId
        gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "（结论）测试结束后配置恢复" $fileId
        gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "（结论）测试过程中配置文件的上传" $fileId
        puts $fileId ""
        puts $fileId "**************************************************************************************"
        puts $fileId ""
        puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "运行异常：错误为$err" "" "GPN_PTN_002_2"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_002_2_REPORT.txt" "report\\NOK_GPN_PTN_002_2_REPORT.txt"
	file rename "log\\GPN_PTN_002_2_LOG.txt" "log\\NOK_GPN_PTN_002_2_LOG.txt"
} else {
	file rename "report\\GPN_PTN_002_2_REPORT.txt" "report\\OK_GPN_PTN_002_2_REPORT.txt"
	file rename "log\\GPN_PTN_002_2_LOG.txt" "log\\OK_GPN_PTN_002_2_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}
	
