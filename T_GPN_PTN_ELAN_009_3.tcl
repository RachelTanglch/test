#!/bin/sh
# T4_GPN_PTN_ELAN_009_3.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#测试目的：E-LAN业务容量及健壮性测试
# 1个VSI承载1个AC和
# 系统容量-1个PW的容量测试   
# CASE2
# vpls中配置ac和pw的容量是一个可设置的值，设这个值为acPwCnt
# 1、NE3的vpls域中创建acPwCnt-1个pw到NE1，1个ac为port+10。
#    NE1的vpls域中创建acPwCnt-1个pw到NE3，1个ac为port+10。
# 2、NE1和NE3发送smac、dmac、vid（vid从10开始到acPwCnt-2）递增的已知单播流
# 预期结果：每条流都能正常转发，只检查是否收到每条数据流不检查丢包
# 3、读取系统资源（show system resource usage）反复shutdown/undo shut NE3板卡的
#    NNI口和UNI口（次数可以配置），每次shut undoshut后检查每条流的转发，只检查
#    是否收到每条数据流不检查丢包
# 预期结果：每次shut undoshut后，每条流都能正常转发（2）cpu的利用率误差在5%，用户
#     利用率的误差在1%，系统利用率的误差在1%。
# 4、读取系统资源（show system resource usage）反复重启NE3的NNI口所在板（次数可
#    以配置），每次重启板卡后检查每条流的转发，只检查是否收到每条数据流不检查丢包
# 预期结果：每次重启板卡后，每条流都能正常转发（2）cpu的利用率误差在5%，用户
#     利用率的误差在1%，系统利用率的误差在1%。
# 5、读取系统资源（show system resource usage）反复进行NE3的交换盘主备倒换（次数
#    可以配置），每次SW倒换后检查每条流的转发，只检查是否收到每条数据流不检查丢包
# 预期结果：每次SW倒换后，每条流都能正常转发（2）cpu的利用率误差在5%，用户
#     利用率的误差在1%，系统利用率的误差在1%。
# 6、读取系统资源（show system resource usage）反复进行NE3的NMS主备倒换（次数
#    可以配置），每次倒换后检查每条流的转发，只检查是否收到每条数据流不检查丢包
# 预期结果：每次NMS倒换后，每条流都能正常转发（2）cpu的利用率误差在5%，用户
#     利用率的误差在1%，系统利用率的误差在1%。
# 7、读取系统资源（show system resource usage）NE3反复进行保存配置重启操作（次数
#    可以配置），每次保存重启后检查每条流转发，只检查是否收到每条数据流不检查丢包
# 预期结果：每次保存重启后，每条流都能正常转发（2）cpu的利用率误差在5%，用户
#     利用率的误差在1%，系统利用率的误差在1%。。
# 8、导出NE1和NE4的配置，清空配置重启
# 预期结果：在NE1和NE4上通过show running mpls查看，无elan配置
# 9、导入第8步导出的NE1和NE4的配置并重启NE1和NE4，重启后检查业务和系统资源
# 预期结果：每次shut undoshut后，每条流都能正常转发（2）cpu的利用率误差在5%，用户
#     利用率的误差在1%，系统利用率的误差在1%。
# 需要补充用户利用率和系统利用率的检查，健壮性测试可配置
# 10、长期性检查
# *******************************************************************

set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
	file mkdir "log"
	set fd_log [open "log\\GPN_PTN_009_3_LOG.txt" a]
	set stdout $fd_log
	chan configure $fd_log -blocking 0 -buffering none;#非阻塞模式 按行flush
	log_file log\\GPN_PTN_009_3_LOG.txt
	
	file mkdir "report"
	set fileId [open "report\\GPN_PTN_009_3_REPORT.txt" a+]
	chan configure $fileId -blocking 0 -buffering none;#非阻塞模式 按行flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_009_3_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_009_3_DEBUG.txt 0
	chan configure $fd_debug -blocking 0 -buffering none;#非阻塞模式 按行flush

    proc TxAndRx_Info {hproject hport infoObj} {
	  upvar $infoObj proInfo
	  set proInfo [stc::subscribe -parent $hproject \
		-resultParent $hport \
		-configType Analyzer \
		-resultType FilteredStreamResults]
	  stc::apply
  }
	  source test\\PTN_VarSet.tcl
	  source test\\PTN_Mode_Function.tcl
	set flagCase2 0   ;#Test case 2标志位
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
	puts $fileId ""
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
	# while {[gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort15 "shutdown"]} {
					
	# }
	
	puts $fileId "\n=====登录被测设备3====\n"
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	
	puts $fileId "\n=====登录被测设备4====\n"
	set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	###设置定制信息参数
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
	puts $fileId ""
    puts $fileId "创建测试工程...\n"
    stc::config automationoptions -logLevel warn
    #创建测试工程
    set hProject [stc::create project]
    set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3\
			 \"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4
    set hgenerator1 [stc::get $hGPNPort1 -children-generator]
    set hgenerator2 [stc::get $hGPNPort2 -children-generator]
    set hgenerator3 [stc::get $hGPNPort3 -children-generator]
    set hgenerator4 [stc::get $hGPNPort4 -children-generator]
    set hGPNPortGenCfgList "$hgenerator1 $hgenerator2"
    set hGeneratorConfig1 [stc::get $hgenerator1 -children-GeneratorConfig]
    stc::config $hGeneratorConfig1 -SchedulingMode RATE_BASED
    set hGeneratorConfig2 [stc::get $hgenerator2 -children-GeneratorConfig]
    stc::config $hGeneratorConfig2 -SchedulingMode RATE_BASED
    set hGeneratorConfig3 [stc::get $hgenerator3 -children-GeneratorConfig]
    stc::config $hGeneratorConfig3 -SchedulingMode RATE_BASED
    set hGeneratorConfig4 [stc::get $hgenerator4 -children-GeneratorConfig]
    stc::config $hGeneratorConfig4 -SchedulingMode RATE_BASED

   #配置数据流量
   ###配置端口1

	set dStreamData16 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameLengthMode "RANDOM" \
	-MinFrameLength "64" \
	-MaxFrameLength "1518" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:10:94:00:00:55</dstMac><srcMac>00:00:00:00:00:01</srcMac><vlans name="anon_5672"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} ]
	set dStreamData11 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameLengthMode "RANDOM" \
	-MinFrameLength "64" \
	-MaxFrameLength "1518" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:00:00:01:00:01</dstMac><srcMac>00:00:00:00:00:01</srcMac><vlans name="anon_33158"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} ]
	set RangeModifier111 [stc::create "RangeModifier" \
	-under $dStreamData11 \
	-Mask {00:00:FF:FF:FF:FF} \
	-StepValue {00:00:00:00:00:01} \
	-RecycleCount "[expr $acPwCnt-1]" \
	-Data {00:00:00:01:00:01} \
	-EnableStream "TRUE" \
	-Offset "2" \
	-OffsetReference {eth1.dstMac} \
	-Name {MAC Modifier} ]
    set RangeModifier112 [stc::create "RangeModifier" \
	-under $dStreamData11 \
	-Mask {00:00:FF:FF:FF:FF} \
	-StepValue {00:00:00:00:00:01} \
	-RecycleCount "[expr $acPwCnt-1]" \
	-Data {00:00:00:00:00:01} \
	-EnableStream "TRUE" \
	-Offset "2" \
	-OffsetReference {eth1.srcMac} \
	-Name {MAC Modifier} ]
    set dStreamData21 [stc::create "StreamBlock" \
	-under $hGPNPort2 \
	-EqualRxPortDistribution "FALSE" \
	-FrameLengthMode "RANDOM" \
	-MinFrameLength "64" \
	-MaxFrameLength "1518" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:00:00:00:00:01</dstMac><srcMac>00:00:00:01:00:01</srcMac><vlans name="anon_33134"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} ]
	set RangeModifier211 [stc::create "RangeModifier" \
	-under $dStreamData21 \
	-Mask {00:00:FF:FF:FF:FF} \
	-StepValue {00:00:00:00:00:01} \
	-RecycleCount "[expr $acPwCnt-1]" \
	-Data {00:00:00:00:00:01} \
	-EnableStream "TRUE" \
	-Offset "2" \
	-OffsetReference {eth1.dstMac} \
	-Name {MAC Modifier} ]
   set RangeModifier212 [stc::create "RangeModifier" \
	-under $dStreamData21 \
	-Mask {00:00:FF:FF:FF:FF} \
	-StepValue {00:00:00:00:00:01} \
	-RecycleCount "[expr $acPwCnt-1]" \
	-Data {00:00:00:01:00:01} \
	-EnableStream "TRUE" \
	-Offset "2" \
	-OffsetReference {eth1.srcMac} \
	-Name {MAC Modifier} ]
	gwd::Get_Generator $hGPNPort1 hGPNPort1Gen
    gwd::Get_Generator $hGPNPort2 hGPNPort2Gen
    gwd::Get_Generator $hGPNPort3 hGPNPort3Gen
    gwd::Get_Generator $hGPNPort4 hGPNPort4Gen
    gwd::Get_Analyzer $hGPNPort1 hGPNPort1Ana
    gwd::Get_Analyzer $hGPNPort2 hGPNPort2Ana
    gwd::Get_Analyzer $hGPNPort3 hGPNPort3Ana
    gwd::Get_Analyzer $hGPNPort4 hGPNPort4Ana
    set hGPNPortGenList "$hGPNPort1Gen $hGPNPort2Gen $hGPNPort3Gen $hGPNPort4Gen"
   	set hGPNPortAnaList "$hGPNPort1Ana $hGPNPort2Ana $hGPNPort3Ana $hGPNPort4Ana"
    foreach hStream "$dStreamData11 $dStreamData21" {
		stc::perform streamBlockActivate -streamBlockList $hStream -activate "FALSE"
	   }
	   foreach hStream "$dStreamData16" {
		   stc::perform streamBlockActivate -streamBlockList $hStream -activate "TRUE"
	   }
    stc::config [stc::get $dStreamData16 -AffiliationStreamBlockLoadProfile] -LoadUnit "MEGABITS_PER_SECOND" -Load "0.01"
	stc::apply
   
    set hanalyzer1 [stc::get $hGPNPort1 -children-analyzer]
    set AnalyzerFrameConfigFilter1 [stc::create "AnalyzerFrameConfigFilter" \
         -under $hanalyzer1 \
         -Summary {EthernetII:Source MAC = FF:FF:FF:FF:FF:FF Min Value = 00:00:00:00:00:01 Max Value = FF:FF:FF:FF:FF:FF, Vlan:ID = FFF Min Value = 999 Max Value = [expr 1000+$acPwCnt-2]} \
         -FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:01" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><vlans name="anon_32757"><Vlan name="Vlan"><id filterMinValue="999" filterMaxValue="4000">4095</id></Vlan></vlans></pdu></pdus></config></frame>} ]
 
    set hanalyzer2 [stc::get $hGPNPort2 -children-analyzer]
    set AnalyzerFrameConfigFilter2 [stc::create "AnalyzerFrameConfigFilter" \
         -under $hanalyzer2 \
         -Summary {EthernetII:Source MAC = FF:FF:FF:FF:FF:FF Min Value = 00:00:00:00:00:01 Max Value = FF:FF:FF:FF:FF:FF, Vlan:ID = FFF Min Value = 999 Max Value = [expr 1000+$acPwCnt-2]} \
         -FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:01" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><vlans name="anon_32777"><Vlan name="Vlan"><id filterMinValue="999" filterMaxValue="4000">4095</id></Vlan></vlans></pdu></pdus></config></frame>} ]
    set hanalyzer3 [stc::get $hGPNPort3 -children-analyzer]
    set AnalyzerFrameConfigFilter3 [stc::create "AnalyzerFrameConfigFilter" \
	 -under $hanalyzer3 \
	 -Summary {EthernetII:Source MAC = FF:FF:FF:FF:FF:FF Min Value = 00:00:00:00:00:01 Max Value = FF:FF:FF:FF:FF:FF, Vlan:ID = FFF Min Value = 999 Max Value = [expr 1000+$acPwCnt-2]} \
	 -FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:01" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><vlans name="anon_32757"><Vlan name="Vlan"><id filterMinValue="999" filterMaxValue="4000">4095</id></Vlan></vlans></pdu></pdus></config></frame>} ]
 
    set hanalyzer4 [stc::get $hGPNPort4 -children-analyzer]
    set AnalyzerFrameConfigFilter4 [stc::create "AnalyzerFrameConfigFilter" \
	 -under $hanalyzer4 \
	 -Summary {EthernetII:Source MAC = FF:FF:FF:FF:FF:FF Min Value = 00:00:00:00:00:01 Max Value = FF:FF:FF:FF:FF:FF, Vlan:ID = FFF Min Value = 999 Max Value = [expr 1000+$acPwCnt-2]} \
	 -FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:01" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><vlans name="anon_32777"><Vlan name="Vlan"><id filterMinValue="999" filterMaxValue="4000">4095</id></Vlan></vlans></pdu></pdus></config></frame>} ]
    
    stc::config $hanalyzer1 -FilterOnStreamId "FALSE"
    stc::config $hanalyzer2 -FilterOnStreamId "FALSE"
    stc::config $hanalyzer3 -FilterOnStreamId "FALSE"
    stc::config $hanalyzer4 -FilterOnStreamId "FALSE"
    set rateL 9500000;#收发数据流取值最小值范围
    set rateR 10500000;#收发数据流取值最大值范围   
    # #   定制结果
    TxAndRx_Info $hProject $hGPNPort1 infoObj1
    TxAndRx_Info $hProject $hGPNPort2 infoObj2
    gwd::Sub_TxAndRx_Info $hProject $hGPNPort1 txInfoArr hGPNPort1TxInfo
	gwd::Sub_TxAndRx_Info $hProject $hGPNPort1 rxInfoArr1 hGPNPort1RxInfo1
	gwd::Sub_TxAndRx_Info $hProject $hGPNPort1 rxInfoArr2 hGPNPort1RxInfo2
	
	gwd::Sub_TxAndRx_Info $hProject $hGPNPort2 txInfoArr hGPNPort2TxInfo
	gwd::Sub_TxAndRx_Info $hProject $hGPNPort2 rxInfoArr1 hGPNPort2RxInfo1
	gwd::Sub_TxAndRx_Info $hProject $hGPNPort2 rxInfoArr2 hGPNPort2RxInfo2

	gwd::Sub_TxAndRx_Info $hProject $hGPNPort3 txInfoArr hGPNPort3TxInfo
	gwd::Sub_TxAndRx_Info $hProject $hGPNPort3 rxInfoArr1 hGPNPort3RxInfo1
	gwd::Sub_TxAndRx_Info $hProject $hGPNPort3 rxInfoArr2 hGPNPort3RxInfo2

	gwd::Sub_TxAndRx_Info $hProject $hGPNPort4 txInfoArr hGPNPort4TxInfo
	gwd::Sub_TxAndRx_Info $hProject $hGPNPort4 rxInfoArr1 hGPNPort4RxInfo1
	gwd::Sub_TxAndRx_Info $hProject $hGPNPort4 rxInfoArr2 hGPNPort4RxInfo2
	
    set totalPage1 [stc::get $infoObj1 -TotalPageCount]
    set totalPage2 [stc::get $infoObj2 -TotalPageCount]
    if {$cap_enable} {
                 ###获取和配置capture对象相关的指针
                 gwd::Get_Capture $hGPNPort1 hGPNPort1Cap
                 gwd::Get_Capture $hGPNPort2 hGPNPort2Cap
                 gwd::Get_Capture $hGPNPort3 hGPNPort3Cap
                 gwd::Get_Capture $hGPNPort4 hGPNPort4Cap
                 gwd::Create_FilterAnalyzer $hGPNPort1Cap hGPNPort1CapFilter hGPNPort1CapAnalyzer
                 gwd::Create_FilterAnalyzer $hGPNPort2Cap hGPNPort2CapFilter hGPNPort2CapAnalyzer
                 gwd::Create_FilterAnalyzer $hGPNPort3Cap hGPNPort1CapFilter hGPNPort3CapAnalyzer
                 gwd::Create_FilterAnalyzer $hGPNPort4Cap hGPNPort2CapFilter hGPNPort4CapAnalyzer
                 array set capArr {capMode "REGULAR_MODE" capSource "Tx_Rx_MODE"}
                 set hGPNPortCapList "$hGPNPort1Cap $hGPNPort2Cap"
         }
	incr tcId
    gwd::GWpublic_saveTCCfg 1 $fd_log "GPN_LSP_009_3_$tcId.xml" [pwd]/Untitled

    #用于导出被测设备用到的变量------
	set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
	set lMatchType "$matchType1 $matchType2 $matchType3 $matchType4"
	set lDutType "$Gpn_type1 $Gpn_type2 $Gpn_type3 $Gpn_type4"
	set lIp "$gpnIp1 $gpnIp2 $gpnIp3 $gpnIp4"
	#------用于导出被测设备用到的变量

    gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 1个VSI承载1个AC和系统容量-1个PW的容量测试\n"
	puts $fileId ""
	set cfgFlag 0
    set flag1_Case2 0;set flag2_Case2 0;set flag3_Case2 0;set flag4_Case2 0;set flag5_Case2 0;set flag6_Case2 0;set flag7_Case2 0;set flag8_Case2 0;set flag9_Case2 0;set flag10_Case2 0
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
 	set rebootSlotlist2 [gwd::GWpulic_getWorkCardList $GPNPort5]
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
	"E-LAN容量及稳定性测试基础配置成功，继续后面的测试" "GPN_PTN_009_3"
    puts $fileId ""
    puts $fileId "===E-LAN容量及稳定性测试基础配置结束..."
	incr cfgId

	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "default" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====1个VSI承载1个AC和系统容量-1个PW的容量配置，测试开始=====\n"
	set vid 10
	set ip12 11.1.1.1
	set ip21 11.1.1.2
	if {[string match "L2" $Worklevel]} {
		set interfaceA v$vid
		set interfaceB v$vid
		set interface1 v10
		set interface2 v10

		lappend flag1_Case2 [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "enable"]
		lappend flag1_Case2 [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "enable"]
	} else {
		set interfaceA $GPNPort5.$vid
		set interfaceB $GPNPort6.$vid
		set interface1 $GPNPort5.$vid
		set interface2 $GPNPort6.$vid
	}
	set pw12 "pw12_1"
    set pw21 "pw21_1"
	###配置VLANIF接口
	lappend flag1_Case2 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceA $ip12 $GPNPort5 $matchType1 $Gpn_type1 $telnet1]
	lappend flag1_Case2 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceB $ip21 $GPNPort6 $matchType2 $Gpn_type2 $telnet2]
	###配置vpls
	lappend flag1_Case2 [gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" 1 "elan" "flood" "false" "false" "false" "true" "5000" "" "tagged"]
	lappend flag1_Case2 [gwd::GWVpls_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls1" 1 "elan" "flood" "false" "false" "false" "true" "5000" "" "tagged"]
    ####配置NE1
	lappend flag1_Case2 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface1 $ip21 "1000" "1000" "normal" "1"]
	lappend flag1_Case2 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612]
	lappend flag1_Case2 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"]
	lappend flag1_Case2 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "$pw12" "vpls" "vpls1" "peer" $address612 "100" "100" "" "add" "none" 1 0 "0x8100" "0x8100" "1"]
	
	####配置NE2
	lappend flag1_Case2 [gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface2 $ip12 "1000" "1000" "normal" "1"]
	lappend flag1_Case2 [gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621]
	lappend flag1_Case2 [gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"]
	lappend flag1_Case2 [gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "$pw21" "vpls" "vpls1" "peer" $address621 "100" "100" "" "add" "none" 1 0 "0x8100" "0x8100" "1"]
	####配置lsp、ac、pw性能统计使能
	lappend flag1_Case2 [gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" "enable"]
    lappend flag1_Case2 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "$pw12" "enable"]
    lappend flag1_Case2 [gwd::GWpublic_addLspStat $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" "enable"]
    lappend flag1_Case2 [gwd::GWpublic_addPwStatEn $telnet2 $matchType2 $Gpn_type2 $fileId "$pw21" "enable"]
    lappend flag1_Case2 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel 1000 $GPNTestEth1]
	lappend flag1_Case2 [PTN_UNI_AddInter $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel 1000 $GPNTestEth2]
	lappend flag1_Case2 [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "vpls1" "ethernet" $GPNTestEth1 "1000" "0" "root" "modify" "1000" "0" "0" "0x8100" "evc2"]	
	lappend flag1_Case2 [gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac1000" "vpls1" "ethernet" $GPNTestEth2 "1000" "0" "root" "modify" "1000" "0" "0" "0x8100" "evc2"]
	lappend flag1_Case2 [gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "enable"]
	lappend flag1_Case2 [gwd::GWpublic_addAcStatEn $telnet2 $matchType2 $Gpn_type2 $fileId "ac1000" "enable"]
	
	for {set i 1} {$i < [expr $acPwCnt-1]} {incr i} {
		set pw12 "pw12_[expr 1+$i]"
		set pw21 "pw21_[expr 1+$i]"
		set local_label "[expr 100+$i]"
		set remote_label "[expr 100+$i]"
		lappend flag1_Case2 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "$pw12" "vpls" "vpls1" "peer" $address612 "$local_label" "$remote_label" "" "add" "none" 1 0 "0x8100" "0x8100" "1"]
		lappend flag1_Case2 [gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "$pw21" "vpls" "vpls1" "peer" $address621 "$local_label" "$remote_label" "" "add" "none" 1 0 "0x8100" "0x8100" "1"]
		set getCnt 3
		while {[gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "$pw12" "enable"]} {
			if {$getCnt==0} {
        		lappend flag1_Case2 1
        		gwd::GWpublic_print "NOK" "在$matchType1\上连续三次enable $pw12的性能统计" $fileId
        		break
        	}
        	incr getCnt -1
		}
		while {[gwd::GWpublic_addPwStatEn $telnet2 $matchType2 $Gpn_type2 $fileId "$pw21" "enable"]} {
			if {$getCnt==0} {
        		lappend flag1_Case2 1
        		gwd::GWpublic_print "NOK" "在$matchType1\上连续三次enable $pw12的性能统计" $fileId
        		break
        	}
        	incr getCnt -1
		}
    }
    gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GW_AddUploadFile $telnet1 $matchType1 $Gpn_type1 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"config" "GPN_PTN_009_3_fullpwNE1.txt" "" "120"
	gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
	gwd::GW_AddUploadFile $telnet2 $matchType2 $Gpn_type2 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"config" "GPN_PTN_009_3_fullpwNE2.txt" "" "120"
	puts $fileId ""
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
     if {"1" in $flag1_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB1（结论）1个VSI承载1个PW和系统容量-1个AC的配置，失败" $fileId 
	} else { 
		gwd::GWpublic_print "OK" "FB1（结论）1个VSI承载1个PW和系统容量-1个AC的配置，成功" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====1个VSI承载1个AC和系统容量-1个PW的容量配置，测试结束=====\n"
    puts $fileId "======================================================================================\n"
    gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，NE1和NE2发流验证业务丢包情况，测试开始=====\n"
	
	gwd::Start_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
   	lappend flag2_Case2 [MPLS_ClassStatisticsAna "3" $infoObj1 $infoObj2 "" "" "1000" "00:00:00:00:00:01" valuedrop1 valuedrop2 valuecnt1 valuecnt2 "GPN_PTN_009_3_B2_1"]
 #   	foreach hStream $::hGPNPortStreamList1 {
	# stc::perform streamBlockActivate -streamBlockList $hStream -activate "FALSE"
 #    }

    gwd::GPN_ClearPortStat "1" $fd_log $matchType1 $GPNPort5 $telnet1
    lappend flag2_Case2 [PTN_ETH_Stat $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen]
    ###发送已知单播和协议报文
     gwd::Start_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
    foreach hStream "$dStreamData11 $dStreamData21" {
		stc::perform streamBlockActivate -streamBlockList $hStream -activate "TRUE"
		stc::config [stc::get $hStream -AffiliationStreamBlockLoadProfile-targets] -load 0.04 -LoadUnit MEGABITS_PER_SECOND
   	}
   	foreach hStream "$dStreamData16" {
   		stc::perform streamBlockActivate -streamBlockList $hStream -activate "FALSE"
   	}
   	set lport1 "$hGPNPort1 $hGPNPort2 $hGPNPort3 $hGPNPort4"
    stc::apply
	if {$acPwCnt>256} {
    	after 900000;###15分钟后
    } elseif {$acPwCnt < 257 && $acPwCnt > 128} {
    	after 300000;###5分钟以后
    } else {
    	after 240000;###4分钟以后
    }
	stc::perform ResultsClearAll -PortList $lport1
	###形成已知单播
	foreach hStream "$dStreamData11 $dStreamData21" {
		stc::config [stc::get $hStream -AffiliationStreamBlockLoadProfile-targets] -load 600 -LoadUnit MEGABITS_PER_SECOND
   	}
   	stc::apply
   	incr tcId
    gwd::GWpublic_saveTCCfg 1 $fd_log "GPN_LSP_002_2_Case2_$tcId.xml" [pwd]/Untitled
   	send_log "\n 开始:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
    lappend flag2_Case2 [MPLS_ClassStatisticsAna "4" $infoObj1 $infoObj2 "1000" "00:00:00:01:00:01" "1000" "00:00:00:00:00:01" valuedrop1 valuedrop2 valuecnt1 valuecnt2 "GPN_PTN_009_3_B2_2"]
   	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp
   	if {"1" in $flag2_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB2（结论）满配pw时，发业务流验证，业务丢包" $fileId 
	} else { 
		gwd::GWpublic_print "OK" "FB2（结论）满配pw时，发业务流验证，业务不丢包" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，NE1和NE2发流验证业务丢包情况，测试结束=====\n"
    puts $fileId "======================================================================================\n"
    gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，NE1($gpnIp1)反复shutdown/undo shut NE3板卡的NNI口和UNI口，测试业务恢复和系统内存   测试开始=====\n"	
	foreach eth "$GPNPort5 $GPNTestEth1" {
		lappend flag3_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource1_1]
		for {set j 1} {$j<=$cnt} {incr j} {
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
        	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
        	after $WaiteTime
			after 120000
			stc::perform ResultsClearAll -PortList $lport1
            lappend flag3_Case2 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_009_3_B3_$j"]
			lappend flag3_Case2 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
			lappend flag3_Case2 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
			lappend flag3_Case2 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
			lappend flag3_Case2 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
			lappend flag3_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
			lappend flag3_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
			lappend flag3_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
			lappend flag3_Case2 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	    	lappend flag3_Case2 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
			lappend flag3_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource1_2]
			send_log "\n shutdwn前resource:$resource1_1"
			send_log "\n 反复shutdown/undoshutdown后resource:$resource1_2"
			lappend flag3_Case2 [CheckSystemResource $fileId "第$j\次shutdown/undo shutdown NE1($gpnIp1)板卡的NNI和UNI口" $resource1_1 $resource1_2]
	    	
			}
	    }
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag3_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB3（结论）满配pw时，NE1($gpnIp1)反复shutdown/undo shut NE1板卡的NNI口和UNI口，业务异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3（结论）满配pw时，NE1($gpnIp1)反复shutdown/undo shut NE1板卡的NNI口和UNI口，业务不丢包，系统资源误差在允许范围内" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，NE1($gpnIp1)反复shutdown/undo shut NE3板卡的NNI口和UNI口，测试业务恢复和系统内存  测试结束=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存  测试开始=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	foreach slot $rebootSlotlist2 {
		lappend flag4_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource2_1]
		set testFlag 0
		for {set j 1} {$j<=$cnt} {incr j} {
			if {![gwd::GWCard_AddReboot $telnet1 $matchType1 $Gpn_type1 $fileId $slot]} {
        		after $rebootBoardTime
				after 120000
        		if {[string match $mslot1 $slot]} {
        		      set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
        		      set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
        		}
                lappend flag4_Case2 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_009_3_B4_$j"]

			} else {
                set testFlag 1
                gwd::GWpublic_print "OK" " NE1($gpnIp1)$slot\槽位板卡不支持板卡重启操作，测试跳过" $fileId
                break
			}
			if {$testFlag == 0} {
				lappend flag4_Case2 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
				lappend flag4_Case2 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
				lappend flag4_Case2 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
				lappend flag4_Case2 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
				lappend flag4_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
				lappend flag4_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
				lappend flag4_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
				lappend flag4_Case2 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	    		lappend flag4_Case2 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
		        lappend flag4_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource2_2]
		        send_log "\n 重启NNI板卡前resource:$resource2_1"
		        send_log "\n 重启NNI板卡后resource:$resource2_2"
		        lappend flag4_Case2 [CheckSystemResource $fileId "第$j\次重启NE1($gpnIp1)$slot\槽位板卡" $resource2_1 $resource2_2]
	        }
	        }  
	}
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag4_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB4（结论）满配pw时，NE1($gpnIp1)反复重启NNI口所在板卡后，业务异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4（结论）满配pw时，NE1($gpnIp1)反复重启NNI口所在板卡后，业务不丢包，系统资源误差在允许范围内" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存  测试结束=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，NE1($gpnIp1)反复进行交换盘的倒换后，测试业务恢复和系统内存  测试开始=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	set testFlag 0
	for {set j 1} {$j<=$cntdh} {incr j} {
		lappend flag5_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource3_1]
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
       		after [expr 2*$rebootTime]
			after 120000
       		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
            set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
            lappend flag5_Case2 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_009_3_B5_$j"]
		} else {
               set testFlag 1
               gwd::GWpublic_print "OK" " NE1($gpnIp1)只有一个交换盘，测试跳过" $fileId
               break
		}
		if {$testFlag == 0} {
			lappend flag5_Case2 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
			lappend flag5_Case2 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
			lappend flag5_Case2 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
			lappend flag5_Case2 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
			lappend flag5_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
			lappend flag5_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
			lappend flag5_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
			lappend flag5_Case2 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	    	lappend flag5_Case2 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
	        lappend flag5_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource3_2]
	        send_log "\n 交换盘倒换前resource:$resource3_1"
	        send_log "\n 交换盘倒换后resource:$resource3_2"
	        lappend flag5_Case2 [CheckSystemResource $fileId "第$j\次倒换NE1($gpnIp1)的交换盘" $resource3_1 $resource3_2]
	       }
	}
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag5_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB5（结论）满配pw时，NE1($gpnIp1)反复进行交换盘的倒换后，业务异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5（结论）满配pw时，NE1($gpnIp1)反复进行交换盘的倒换后，业务不丢包，系统资源误差在允许范围内" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，NE1($gpnIp1)反复进行交换盘的倒换后，测试业务恢复和系统内存  测试结束=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，NE1($gpnIp1)反复进行NMS主备倒换，测试业务恢复和系统内存  测试开始=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	set testFlag 0
	for {set j 1} {$j<=$cntdh} {incr j} {
		lappend flag6_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource4_1]
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
       		after [expr 2*$rebootTime]
			after 120000
       		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
            set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
            lappend flag6_Case2 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_009_3_B6_$j"]
		} else {
               set testFlag 1
               gwd::GWpublic_print "OK" " NE1($gpnIp1)只有一个主控盘，测试跳过" $fileId
               break
		}
		if {$testFlag == 0} {
			lappend flag6_Case2 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
			lappend flag6_Case2 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
			lappend flag6_Case2 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
			lappend flag6_Case2 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
			lappend flag6_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
			lappend flag6_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
			lappend flag6_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
			lappend flag6_Case2 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	    	lappend flag6_Case2 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
	        lappend flag6_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource4_2]
	        send_log "\n NMS主备倒换前resource:$resource4_1"
	        send_log "\n NMS主备倒换后resource:$resource4_2"
	        lappend flag6_Case2 [CheckSystemResource $fileId "第$j\次倒换NE1($gpnIp1)的主控盘" $resource4_1 $resource4_2]
	       }
	}
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag6_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB6（结论）满配pw时，NE1($gpnIp1)反复进行NMS的主备倒换后，业务异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6（结论）满配pw时，NE1($gpnIp1)反复进行NMS的主备倒换后，业务不丢包，系统资源误差在允许范围内" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，NE1($gpnIp1)反复进行NMS的主备倒换后，测试业务恢复和系统内存  测试结束=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，NE1($gpnIp1)反复进行保存设备重启后，测试业务恢复和系统内存  测试开始=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	set testFlag 0
	for {set j 1} {$j<=$cnt} {incr j} {
		lappend flag7_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource5_1]
		lappend flag7_Case2 [gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId]
		after 60000
		lappend flag7_Case2 [gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId]
		after [expr 2*$rebootTime]
       	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
        set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
        lappend flag7_Case2 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_009_3_B7_$j"]
	    lappend flag7_Case2 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
		lappend flag7_Case2 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
		lappend flag7_Case2 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
		lappend flag7_Case2 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
		lappend flag7_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
		lappend flag7_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
		lappend flag7_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
		lappend flag7_Case2 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	    lappend flag7_Case2 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
	    lappend flag7_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource5_2]
	    send_log "\n 保存重启前resource:$resource5_1"
	    send_log "\n 保存重启后resource:$resource5_2"
	    lappend flag7_Case2 [CheckSystemResource $fileId "第$j\次保存重启NE1($gpnIp1)" $resource5_1 $resource5_2]
	}
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId ""
	if {"1" in $flag7_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB7（结论）满配pw时，NE1($gpnIp1)反复进行保存设备重启后，业务异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7（结论）满配pw时，NE1($gpnIp1)反复进行保存设备重启后，业务不丢包，系统资源误差在允许范围内" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，NE1($gpnIp1)反复进行保存设备重启后，测试业务恢复和系统内存  测试结束=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，反复删增10个pw和ac的配置，测试业务恢复和系统内存  测试开始=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	for {set j 1} {$j<=$cnt} {incr j} {
		lappend flag8_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource6_1]
		lappend flag8_Case2 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000"]
		if {[expr $acPwCnt]<11} {
			for {set k 1} {$k<[expr $acPwCnt]} {incr k} {
			lappend flag8_Case2 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12_$k"]
			}
		} else {
			for {set k 1} {$k<11} {incr k} {
			lappend flag8_Case2 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12_$k"]
			}
		}
		for {set k 1} {$k<11} {incr k} {
	     	lappend flag8_Case2 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12_$k" "vpls" "vpls1" "peer" $address612 "[expr 99+$k]" "[expr 99+$k]" "" "add" "none" 1 0 "0x8100" "0x8100" "1"]
			lappend flag8_Case2 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw12_$k" "enable"]
		}
		lappend flag8_Case2 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "1000" $GPNTestEth1]
		lappend flag8_Case2 [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "vpls1" "ethernet" $GPNTestEth1 "1000" "0" "root" "modify" "1000" "0" "0" "0x8100" "evc2"]
		lappend flag8_Case2 [gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "enable"]
    	lappend flag8_Case2 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_009_3_B8_$j"]
    	lappend flag8_Case2 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
		lappend flag8_Case2 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
		lappend flag8_Case2 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
		lappend flag8_Case2 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
		lappend flag8_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
		lappend flag8_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
		lappend flag8_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
		lappend flag8_Case2 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	    lappend flag8_Case2 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
	    lappend flag8_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource6_2]
	    send_log "\n 删除ac、pw前resource:$resource6_1"
	    send_log "\n 删除并恢复ac、pw后resource:$resource6_2"
	    lappend flag8_Case2 [CheckSystemResource $fileId "第$j\次保存重启NE1($gpnIp1)" $resource6_1 $resource6_2]
	}
	
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag8_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB8（结论）满配pw时，反复删增NE1($gpnIp1)的pw和ac的配置，业务异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8（结论）满配pw时，反复删增NE1($gpnIp1)的pw和ac的配置，业务不丢包，系统资源误差在允许范围内" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，反复删增10个pw和ac的配置，测试业务恢复和系统内存  测试结束=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，导出NE1和NE2的配置，清空配置重启，NE1($gpnIp1)和NE2($gpnIp2)下载VSI满配的配置并重启设备后验证业务  测试开始=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	lappend flag9_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource7_1]
	
	gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"NE1.txt" ""
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWmanage_ftpDownload $telnet2 $matchType2 $Gpn_type2 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"NE2.txt" ""
	gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
	after [expr 2*$rebootTime]
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
    set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
	lappend flag9_Case2 [gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	lappend flag9_Case2 [gwd::GWpublic_showMplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
	set tmpresult1 [regexp -all -line -inline -nocase {!MPLS Global config\s+([a-z|0-9|\s+]+\s+)!} $result1]
	set tmpresult2 [regexp -all -line -inline -nocase {!MPLS Global config\s+([a-z|0-9|\s+]+\s+)!} $result2]
	if {[string match "" $tmpresult1]} {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)清空配置重启后无elan配置" $fileId
	} else {
		lappend flag9_Case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)清空配置重启后存在elan配置" $fileId
	}

	if {[string match "" $tmpresult2]} {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)清空配置重启后无elan配置" $fileId
	} else {
		lappend flag9_Case3 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)清空配置重启后存在elan配置" $fileId
	}
	gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"GPN_PTN_009_3_fullpwNE1.txt" ""
	gwd::GWmanage_ftpDownload $telnet2 $matchType2 $Gpn_type2 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"GPN_PTN_009_3_fullpwNE2.txt" ""
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
	after [expr 2*$rebootTime]
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
    set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
	lappend flag9_Case2 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_009_3_B9_$j"]
    lappend flag9_Case2 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
	lappend flag9_Case2 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
	lappend flag9_Case2 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
	lappend flag9_Case2 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
	lappend flag9_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
	lappend flag9_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
	lappend flag9_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
	lappend flag9_Case2 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	lappend flag9_Case2 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
	lappend flag9_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource7_2]
	send_log "\n 清空配置并恢复配置前resource:$resource7_1"
	send_log "\n 清空配置并恢复配置后resource:$resource7_2"
	lappend flag9_Case2 [CheckSystemResource $fileId "保存重启NE1($gpnIp1)" $resource7_1 $resource7_2]
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag9_Case2} {
		set flagCase1 2
		gwd::GWpublic_print "NOK" "FB9（结论）满配pw时，导出NE1和NE2的配置，清空配置后恢复配置，业务异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9（结论）满配pw时，导出NE1和NE2的配置，清空配置后恢复配置，业务不丢包，系统资源误差在允许范围内" $fileId
	}
	gwd::Stop_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====满配pw时，导出NE1和NE2的配置，清空配置重启，NE1($gpnIp1)和NE2($gpnIp2)下载VSI满配的配置并重启设备后验证业务  测试结束=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====流跑长期，测试业务  测试开始=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	lappend flag10_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource8_1]
	if {[string match -nocase $longTermIf "true"]} {
        	lappend flag10_Case2 [MPLS_ClassStatisticsPort4 $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen $hGPNPort3Ana $hGPNPort3Gen $hGPNPort4Ana $hGPNPort4Gen $lTermTime "2"]
    		lappend flag10_Case2 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
			lappend flag10_Case2 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
			lappend flag10_Case2 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
			lappend flag10_Case2 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
			lappend flag10_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
			lappend flag10_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
			lappend flag10_Case2 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "$pw12" GPNPwStat1]
			lappend flag10_Case2 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
			lappend flag10_Case2 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
			lappend flag10_Case2 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource8_2]
			send_log "\n 流跑长期前resource:$resource8_1"
			send_log "\n 流跑长期后resource:$resource8_2"
			lappend flag10_Case2 [CheckSystemResource $fileId "流跑长期前后" $resource8_1 $resource8_2]
		} else {
               gwd::GWpublic_print "OK" "此次测试不进行长期性测试，测试跳过" $fileId
          
		}
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag10_Case2} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB10（结论）流跑长期，业务异常" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB10（结论）流跑长期，业务不丢包，系统资源误差在允许范围内" $fileId
	}
	gwd::Stop_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====流跑长期，测试业务  测试结束=====\n"
	puts $fileId "======================================================================================\n"
	puts $fileId ""
	if {$flagCase2 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 2测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 2测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 2 1个VSI承载1个AC和系统容量-1个PW的容量测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"






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
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "测试结束后配置恢复" "测试结束后配置恢复" "GPN_PTN_009_3"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "测试过程中所有配置文件都上传成功" "GPN_PTN_009_3"
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_009_3测试目的：E-LAN容量及稳定性测试\n"


	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase2==1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_009_3测试结果" $fileId
	puts $fileId ""

	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2测试结果" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FB1 == [expr {($flag1_Case2 == 1) ? "NOK" : "OK"}]" "（结论）1个VSI承载1个PW和系统容量-1个AC的配置,[expr {($flag1_case2 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag2_Case2 == 1) ? "NOK" : "OK"}]" "（结论）满配pw时，发业务流验证，,[expr {($flag2_case2 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag3_Case2 == 1) ? "NOK" : "OK"}]" "（结论）满配pw时，NE1($gpnIp1)反复shutdown/undo shut NE1板卡的NNI口和UNI口,验证业务和CPU利用率,[expr {($flag3_case2 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag4_Case2 == 1) ? "NOK" : "OK"}]" "（结论）满配pw时，NE1($gpnIp1)反复重启NNI口所在板卡后,验证业务和CPU利用率,[expr {($flag4_case2 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag5_Case2 == 1) ? "NOK" : "OK"}]" "（结论）满配pw时，NE1($gpnIp1)反复进行交换盘的倒换后,验证业务和CPU利用率,[expr {($flag5_case2 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag6_Case2 == 1) ? "NOK" : "OK"}]" "（结论）满配pw时，NE1($gpnIp1)反复进行NMS的主备倒换后,验证业务和CPU利用率,[expr {($flag6_case2 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag7_Case2 == 1) ? "NOK" : "OK"}]" "（结论）满配pw时，NE1($gpnIp1)反复进行保存设备重启后,验证业务和CPU利用率,[expr {($flag7_case2 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag8_Case2 == 1) ? "NOK" : "OK"}]" "（结论）满配pw时，反复删增NE1($gpnIp1)的pw和ac的配置,验证业务和CPU利用率,[expr {($flag8_case2 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag9_Case2 == 1) ? "NOK" : "OK"}]" "（结论）满配pw时，导出NE1和NE2的配置，清空配置后恢复配置,验证业务和CPU利用率,[expr {($flag9_case2 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FB10 == [expr {($flag10_Case2 == 1) ? "NOK" : "OK"}]" "（结论）长期性测试[expr {($flag10_case2 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "（结论）测试结束后配置恢复,[expr {($flag1_case2 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "（结论）测试过程中配置文件的上传,[expr {($flag1_case2 == 1) ? "成功" : "失败"}]" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "运行异常：错误为$err" "" "GPN_PTN_009_3"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_009_3_REPORT.txt" "report\\NOK_GPN_PTN_009_3_REPORT.txt"
	file rename "log\\GPN_PTN_009_3_LOG.txt" "log\\NOK_GPN_PTN_009_3_LOG.txt"
} else {
	file rename "report\\GPN_PTN_009_3_REPORT.txt" "report\\OK_GPN_PTN_009_3_REPORT.txt"
	file rename "log\\GPN_PTN_009_3_LOG.txt" "log\\OK_GPN_PTN_009_3_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}