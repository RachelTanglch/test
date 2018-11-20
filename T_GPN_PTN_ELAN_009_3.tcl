#!/bin/sh
# T4_GPN_PTN_ELAN_009_3.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#����Ŀ�ģ�E-LANҵ����������׳�Բ���
# 1��VSI����1��AC��
# ϵͳ����-1��PW����������   
# CASE2
# vpls������ac��pw��������һ�������õ�ֵ�������ֵΪacPwCnt
# 1��NE3��vpls���д���acPwCnt-1��pw��NE1��1��acΪport+10��
#    NE1��vpls���д���acPwCnt-1��pw��NE3��1��acΪport+10��
# 2��NE1��NE3����smac��dmac��vid��vid��10��ʼ��acPwCnt-2����������֪������
# Ԥ�ڽ����ÿ������������ת����ֻ����Ƿ��յ�ÿ������������鶪��
# 3����ȡϵͳ��Դ��show system resource usage������shutdown/undo shut NE3�忨��
#    NNI�ں�UNI�ڣ������������ã���ÿ��shut undoshut����ÿ������ת����ֻ���
#    �Ƿ��յ�ÿ������������鶪��
# Ԥ�ڽ����ÿ��shut undoshut��ÿ������������ת����2��cpu�������������5%���û�
#     �����ʵ������1%��ϵͳ�����ʵ������1%��
# 4����ȡϵͳ��Դ��show system resource usage����������NE3��NNI�����ڰ壨������
#    �����ã���ÿ�������忨����ÿ������ת����ֻ����Ƿ��յ�ÿ������������鶪��
# Ԥ�ڽ����ÿ�������忨��ÿ������������ת����2��cpu�������������5%���û�
#     �����ʵ������1%��ϵͳ�����ʵ������1%��
# 5����ȡϵͳ��Դ��show system resource usage����������NE3�Ľ�������������������
#    �������ã���ÿ��SW��������ÿ������ת����ֻ����Ƿ��յ�ÿ������������鶪��
# Ԥ�ڽ����ÿ��SW������ÿ������������ת����2��cpu�������������5%���û�
#     �����ʵ������1%��ϵͳ�����ʵ������1%��
# 6����ȡϵͳ��Դ��show system resource usage����������NE3��NMS��������������
#    �������ã���ÿ�ε�������ÿ������ת����ֻ����Ƿ��յ�ÿ������������鶪��
# Ԥ�ڽ����ÿ��NMS������ÿ������������ת����2��cpu�������������5%���û�
#     �����ʵ������1%��ϵͳ�����ʵ������1%��
# 7����ȡϵͳ��Դ��show system resource usage��NE3�������б���������������������
#    �������ã���ÿ�α�����������ÿ����ת����ֻ����Ƿ��յ�ÿ������������鶪��
# Ԥ�ڽ����ÿ�α���������ÿ������������ת����2��cpu�������������5%���û�
#     �����ʵ������1%��ϵͳ�����ʵ������1%����
# 8������NE1��NE4�����ã������������
# Ԥ�ڽ������NE1��NE4��ͨ��show running mpls�鿴����elan����
# 9�������8��������NE1��NE4�����ò�����NE1��NE4����������ҵ���ϵͳ��Դ
# Ԥ�ڽ����ÿ��shut undoshut��ÿ������������ת����2��cpu�������������5%���û�
#     �����ʵ������1%��ϵͳ�����ʵ������1%��
# ��Ҫ�����û������ʺ�ϵͳ�����ʵļ�飬��׳�Բ��Կ�����
# 10�������Լ��
# *******************************************************************

set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
	file mkdir "log"
	set fd_log [open "log\\GPN_PTN_009_3_LOG.txt" a]
	set stdout $fd_log
	chan configure $fd_log -blocking 0 -buffering none;#������ģʽ ����flush
	log_file log\\GPN_PTN_009_3_LOG.txt
	
	file mkdir "report"
	set fileId [open "report\\GPN_PTN_009_3_REPORT.txt" a+]
	chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_009_3_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_009_3_DEBUG.txt 0
	chan configure $fd_debug -blocking 0 -buffering none;#������ģʽ ����flush

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
	set flagCase2 0   ;#Test case 2��־λ
	set flagResult 0
	set lFailFile ""
	set FLAGF 0
	
	set tcId 0
	set capId 0
	set cfgId 0
		
	#Ϊ���Խ���Ԥ������
	for {set i 0} {$i < 80} {incr i} {
	    puts $fileId "                                                                                                                                                                                                                "	
	}
	regsub {/} $GPNTestEth1 {_} GPNTestEth1_cap
	regsub {/} $GPNTestEth2 {_} GPNTestEth2_cap
	regsub {/} $GPNTestEth3 {_} GPNTestEth3_cap
	regsub {/} $GPNTestEth4 {_} GPNTestEth4_cap
	puts $fileId ""
	puts $fileId "��¼�����豸...\n"
	puts $fileId "\n=====��¼�����豸1====\n"
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
	
	puts $fileId "\n=====��¼�����豸2====\n"
	set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
	# while {[gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort15 "shutdown"]} {
					
	# }
	
	puts $fileId "\n=====��¼�����豸3====\n"
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	
	puts $fileId "\n=====��¼�����豸4====\n"
	set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	###���ö�����Ϣ����
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
	puts $fileId ""
    puts $fileId "�������Թ���...\n"
    stc::config automationoptions -logLevel warn
    #�������Թ���
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

   #������������
   ###���ö˿�1

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
    set rateL 9500000;#�շ�������ȡֵ��Сֵ��Χ
    set rateR 10500000;#�շ�������ȡֵ���ֵ��Χ   
    # #   ���ƽ��
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
                 ###��ȡ������capture������ص�ָ��
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

    #���ڵ��������豸�õ��ı���------
	set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
	set lMatchType "$matchType1 $matchType2 $matchType3 $matchType4"
	set lDutType "$Gpn_type1 $Gpn_type2 $Gpn_type3 $Gpn_type4"
	set lIp "$gpnIp1 $gpnIp2 $gpnIp3 $gpnIp4"
	#------���ڵ��������豸�õ��ı���

    gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 1��VSI����1��AC��ϵͳ����-1��PW����������\n"
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
	 gwd::GWpublic_print "OK" "��ȡ�豸NE1($gpnIp1)ҵ��忨��λ��$rebootSlotlist1" $fileId
        set mslot1 [gwd::GWpulic_getWorkCardList $managePort1]
	 gwd::GWpublic_print "OK" "��ȡ�豸1��������ڰ忨��λ��$mslot1" $fileId

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
        
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-LAN�������ȶ��Բ��Ի�������ʧ�ܣ����Խ���" \
	"E-LAN�������ȶ��Բ��Ի������óɹ�����������Ĳ���" "GPN_PTN_009_3"
    puts $fileId ""
    puts $fileId "===E-LAN�������ȶ��Բ��Ի������ý���..."
	incr cfgId

	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "default" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====1��VSI����1��AC��ϵͳ����-1��PW���������ã����Կ�ʼ=====\n"
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
	###����VLANIF�ӿ�
	lappend flag1_Case2 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceA $ip12 $GPNPort5 $matchType1 $Gpn_type1 $telnet1]
	lappend flag1_Case2 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceB $ip21 $GPNPort6 $matchType2 $Gpn_type2 $telnet2]
	###����vpls
	lappend flag1_Case2 [gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" 1 "elan" "flood" "false" "false" "false" "true" "5000" "" "tagged"]
	lappend flag1_Case2 [gwd::GWVpls_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls1" 1 "elan" "flood" "false" "false" "false" "true" "5000" "" "tagged"]
    ####����NE1
	lappend flag1_Case2 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface1 $ip21 "1000" "1000" "normal" "1"]
	lappend flag1_Case2 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612]
	lappend flag1_Case2 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"]
	lappend flag1_Case2 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "$pw12" "vpls" "vpls1" "peer" $address612 "100" "100" "" "add" "none" 1 0 "0x8100" "0x8100" "1"]
	
	####����NE2
	lappend flag1_Case2 [gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface2 $ip12 "1000" "1000" "normal" "1"]
	lappend flag1_Case2 [gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621]
	lappend flag1_Case2 [gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"]
	lappend flag1_Case2 [gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "$pw21" "vpls" "vpls1" "peer" $address621 "100" "100" "" "add" "none" 1 0 "0x8100" "0x8100" "1"]
	####����lsp��ac��pw����ͳ��ʹ��
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
        		gwd::GWpublic_print "NOK" "��$matchType1\����������enable $pw12������ͳ��" $fileId
        		break
        	}
        	incr getCnt -1
		}
		while {[gwd::GWpublic_addPwStatEn $telnet2 $matchType2 $Gpn_type2 $fileId "$pw21" "enable"]} {
			if {$getCnt==0} {
        		lappend flag1_Case2 1
        		gwd::GWpublic_print "NOK" "��$matchType1\����������enable $pw12������ͳ��" $fileId
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
		gwd::GWpublic_print "NOK" "FB1�����ۣ�1��VSI����1��PW��ϵͳ����-1��AC�����ã�ʧ��" $fileId 
	} else { 
		gwd::GWpublic_print "OK" "FB1�����ۣ�1��VSI����1��PW��ϵͳ����-1��AC�����ã��ɹ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====1��VSI����1��AC��ϵͳ����-1��PW���������ã����Խ���=====\n"
    puts $fileId "======================================================================================\n"
    gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ��NE1��NE2������֤ҵ�񶪰���������Կ�ʼ=====\n"
	
	gwd::Start_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
   	lappend flag2_Case2 [MPLS_ClassStatisticsAna "3" $infoObj1 $infoObj2 "" "" "1000" "00:00:00:00:00:01" valuedrop1 valuedrop2 valuecnt1 valuecnt2 "GPN_PTN_009_3_B2_1"]
 #   	foreach hStream $::hGPNPortStreamList1 {
	# stc::perform streamBlockActivate -streamBlockList $hStream -activate "FALSE"
 #    }

    gwd::GPN_ClearPortStat "1" $fd_log $matchType1 $GPNPort5 $telnet1
    lappend flag2_Case2 [PTN_ETH_Stat $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen]
    ###������֪������Э�鱨��
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
    	after 900000;###15���Ӻ�
    } elseif {$acPwCnt < 257 && $acPwCnt > 128} {
    	after 300000;###5�����Ժ�
    } else {
    	after 240000;###4�����Ժ�
    }
	stc::perform ResultsClearAll -PortList $lport1
	###�γ���֪����
	foreach hStream "$dStreamData11 $dStreamData21" {
		stc::config [stc::get $hStream -AffiliationStreamBlockLoadProfile-targets] -load 600 -LoadUnit MEGABITS_PER_SECOND
   	}
   	stc::apply
   	incr tcId
    gwd::GWpublic_saveTCCfg 1 $fd_log "GPN_LSP_002_2_Case2_$tcId.xml" [pwd]/Untitled
   	send_log "\n ��ʼ:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
    lappend flag2_Case2 [MPLS_ClassStatisticsAna "4" $infoObj1 $infoObj2 "1000" "00:00:00:01:00:01" "1000" "00:00:00:00:00:01" valuedrop1 valuedrop2 valuecnt1 valuecnt2 "GPN_PTN_009_3_B2_2"]
   	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp
   	if {"1" in $flag2_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB2�����ۣ�����pwʱ����ҵ������֤��ҵ�񶪰�" $fileId 
	} else { 
		gwd::GWpublic_print "OK" "FB2�����ۣ�����pwʱ����ҵ������֤��ҵ�񲻶���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ��NE1��NE2������֤ҵ�񶪰���������Խ���=====\n"
    puts $fileId "======================================================================================\n"
    gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ��NE1($gpnIp1)����shutdown/undo shut NE3�忨��NNI�ں�UNI�ڣ�����ҵ��ָ���ϵͳ�ڴ�   ���Կ�ʼ=====\n"	
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
			send_log "\n shutdwnǰresource:$resource1_1"
			send_log "\n ����shutdown/undoshutdown��resource:$resource1_2"
			lappend flag3_Case2 [CheckSystemResource $fileId "��$j\��shutdown/undo shutdown NE1($gpnIp1)�忨��NNI��UNI��" $resource1_1 $resource1_2]
	    	
			}
	    }
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag3_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB3�����ۣ�����pwʱ��NE1($gpnIp1)����shutdown/undo shut NE1�忨��NNI�ں�UNI�ڣ�ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3�����ۣ�����pwʱ��NE1($gpnIp1)����shutdown/undo shut NE1�忨��NNI�ں�UNI�ڣ�ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ��NE1($gpnIp1)����shutdown/undo shut NE3�忨��NNI�ں�UNI�ڣ�����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ��NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
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
                gwd::GWpublic_print "OK" " NE1($gpnIp1)$slot\��λ�忨��֧�ְ忨������������������" $fileId
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
		        send_log "\n ����NNI�忨ǰresource:$resource2_1"
		        send_log "\n ����NNI�忨��resource:$resource2_2"
		        lappend flag4_Case2 [CheckSystemResource $fileId "��$j\������NE1($gpnIp1)$slot\��λ�忨" $resource2_1 $resource2_2]
	        }
	        }  
	}
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag4_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB4�����ۣ�����pwʱ��NE1($gpnIp1)��������NNI�����ڰ忨��ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4�����ۣ�����pwʱ��NE1($gpnIp1)��������NNI�����ڰ忨��ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ��NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ��NE1($gpnIp1)�������н����̵ĵ����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
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
               gwd::GWpublic_print "OK" " NE1($gpnIp1)ֻ��һ�������̣���������" $fileId
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
	        send_log "\n �����̵���ǰresource:$resource3_1"
	        send_log "\n �����̵�����resource:$resource3_2"
	        lappend flag5_Case2 [CheckSystemResource $fileId "��$j\�ε���NE1($gpnIp1)�Ľ�����" $resource3_1 $resource3_2]
	       }
	}
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag5_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB5�����ۣ�����pwʱ��NE1($gpnIp1)�������н����̵ĵ�����ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5�����ۣ�����pwʱ��NE1($gpnIp1)�������н����̵ĵ�����ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ��NE1($gpnIp1)�������н����̵ĵ����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ��NE1($gpnIp1)��������NMS��������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
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
               gwd::GWpublic_print "OK" " NE1($gpnIp1)ֻ��һ�������̣���������" $fileId
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
	        send_log "\n NMS��������ǰresource:$resource4_1"
	        send_log "\n NMS����������resource:$resource4_2"
	        lappend flag6_Case2 [CheckSystemResource $fileId "��$j\�ε���NE1($gpnIp1)��������" $resource4_1 $resource4_2]
	       }
	}
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag6_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB6�����ۣ�����pwʱ��NE1($gpnIp1)��������NMS������������ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6�����ۣ�����pwʱ��NE1($gpnIp1)��������NMS������������ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ��NE1($gpnIp1)��������NMS�����������󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ��NE1($gpnIp1)�������б����豸�����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
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
	    send_log "\n ��������ǰresource:$resource5_1"
	    send_log "\n ����������resource:$resource5_2"
	    lappend flag7_Case2 [CheckSystemResource $fileId "��$j\�α�������NE1($gpnIp1)" $resource5_1 $resource5_2]
	}
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId ""
	if {"1" in $flag7_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB7�����ۣ�����pwʱ��NE1($gpnIp1)�������б����豸������ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7�����ۣ�����pwʱ��NE1($gpnIp1)�������б����豸������ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ��NE1($gpnIp1)�������б����豸�����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ������ɾ��10��pw��ac�����ã�����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
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
	    send_log "\n ɾ��ac��pwǰresource:$resource6_1"
	    send_log "\n ɾ�����ָ�ac��pw��resource:$resource6_2"
	    lappend flag8_Case2 [CheckSystemResource $fileId "��$j\�α�������NE1($gpnIp1)" $resource6_1 $resource6_2]
	}
	
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag8_Case2} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB8�����ۣ�����pwʱ������ɾ��NE1($gpnIp1)��pw��ac�����ã�ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8�����ۣ�����pwʱ������ɾ��NE1($gpnIp1)��pw��ac�����ã�ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ������ɾ��10��pw��ac�����ã�����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ������NE1��NE2�����ã��������������NE1($gpnIp1)��NE2($gpnIp2)����VSI��������ò������豸����֤ҵ��  ���Կ�ʼ=====\n"
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
		gwd::GWpublic_print "OK" "NE1($gpnIp1)���������������elan����" $fileId
	} else {
		lappend flag9_Case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)����������������elan����" $fileId
	}

	if {[string match "" $tmpresult2]} {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)���������������elan����" $fileId
	} else {
		lappend flag9_Case3 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)����������������elan����" $fileId
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
	send_log "\n ������ò��ָ�����ǰresource:$resource7_1"
	send_log "\n ������ò��ָ����ú�resource:$resource7_2"
	lappend flag9_Case2 [CheckSystemResource $fileId "��������NE1($gpnIp1)" $resource7_1 $resource7_2]
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag9_Case2} {
		set flagCase1 2
		gwd::GWpublic_print "NOK" "FB9�����ۣ�����pwʱ������NE1��NE2�����ã�������ú�ָ����ã�ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9�����ۣ�����pwʱ������NE1��NE2�����ã�������ú�ָ����ã�ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	gwd::Stop_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����pwʱ������NE1��NE2�����ã��������������NE1($gpnIp1)��NE2($gpnIp2)����VSI��������ò������豸����֤ҵ��  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���ܳ��ڣ�����ҵ��  ���Կ�ʼ=====\n"
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
			send_log "\n ���ܳ���ǰresource:$resource8_1"
			send_log "\n ���ܳ��ں�resource:$resource8_2"
			lappend flag10_Case2 [CheckSystemResource $fileId "���ܳ���ǰ��" $resource8_1 $resource8_2]
		} else {
               gwd::GWpublic_print "OK" "�˴β��Բ����г����Բ��ԣ���������" $fileId
          
		}
	puts $fileId ""
   	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009_3" lFailFileTmp

	if {"1" in $flag10_Case2} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB10�����ۣ����ܳ��ڣ�ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB10�����ۣ����ܳ��ڣ�ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	gwd::Stop_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���ܳ��ڣ�����ҵ��  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	puts $fileId ""
	if {$flagCase2 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 2���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 2���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 2 1��VSI����1��AC��ϵͳ����-1��PW����������  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"






	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===�ָ���ʼ������...\n"
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
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_009_3"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_009_3"
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_009_3����Ŀ�ģ�E-LAN�������ȶ��Բ���\n"


	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase2==1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_009_3���Խ��" $fileId
	puts $fileId ""

	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2���Խ��" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FB1 == [expr {($flag1_Case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�1��VSI����1��PW��ϵͳ����-1��AC������,[expr {($flag1_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag2_Case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����pwʱ����ҵ������֤��,[expr {($flag2_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag3_Case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����pwʱ��NE1($gpnIp1)����shutdown/undo shut NE1�忨��NNI�ں�UNI��,��֤ҵ���CPU������,[expr {($flag3_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag4_Case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����pwʱ��NE1($gpnIp1)��������NNI�����ڰ忨��,��֤ҵ���CPU������,[expr {($flag4_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag5_Case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����pwʱ��NE1($gpnIp1)�������н����̵ĵ�����,��֤ҵ���CPU������,[expr {($flag5_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag6_Case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����pwʱ��NE1($gpnIp1)��������NMS������������,��֤ҵ���CPU������,[expr {($flag6_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag7_Case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����pwʱ��NE1($gpnIp1)�������б����豸������,��֤ҵ���CPU������,[expr {($flag7_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag8_Case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����pwʱ������ɾ��NE1($gpnIp1)��pw��ac������,��֤ҵ���CPU������,[expr {($flag8_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag9_Case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�����pwʱ������NE1��NE2�����ã�������ú�ָ�����,��֤ҵ���CPU������,[expr {($flag9_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FB10 == [expr {($flag10_Case2 == 1) ? "NOK" : "OK"}]" "�����ۣ������Բ���[expr {($flag10_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�,[expr {($flag1_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�,[expr {($flag1_case2 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_009_3"
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