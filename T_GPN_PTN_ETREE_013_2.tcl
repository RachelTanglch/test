#!/bin/sh
# T4_GPN_PTN_ETREE_013_2.tcl \
exec tclsh "$0" ${1+"$@"}
# 1��VSI����1��PW��
# ϵͳ����-1��AC����������   
# Test Case 1
# vpls������ac��pw��������������һ�������õ�ֵ�������ֵΪacPwCnt
# 1����NE1��NE2֮�䴴��E-Treeҵ������NE1һ��vpls��һ��LSP��һ��PW��һ��ac����
#    ���˿ڣ�����Ϊ�˿�ģʽ��NE2һ��vpls��һ��LSP��һ��PW��acPwCnt-1��ac����Ҷ
#    �Ӷ˿ڣ���Ϊ���˿�+��Ӫ�̡�ģʽ���Ҷ˿ڼ��뵽��Ӧ��vlan�У�NE2��ʹ��ÿ��lsp
#    ��pw��ac������ͳ��
# 2��NE1��NE2������smac��vid��vid��10��ʼ��acPwCnt-2��������δ֪����
# Ԥ�ڽ������1��ÿ������������ת��������鶪��
# 3��ֹͣ�������鿴NE2��NNI�ڵ�������ͳ�Ƹ���
# Ԥ�ڽ����ͳ�Ƹ�����ȷ����TC���շ��Ƚ�
# 4����NE1��NE2��UNI���໥�������������֪������600M��smac��dmac��vid�������ֽڳ�
#    ��Ϊrandom��len��64-1518�������ֱ���ΪЭ�鱨�ģ�һ��vid�з��ͣ�����Ҫ����ÿ
#    ��vid������0.5M�� arp�������ģ�0.5M��
# Ԥ�ڽ������֪������������Э�鱨�Ĳ�������arp���Ĳ�����
# 3����ȡϵͳ��Դ��show system resource usage������shutdown/undo shut NE2�忨��
#    NNI�ں�UNI�ڣ������������ã�
# Ԥ�ڽ������1��ÿ��shut undoshut��ÿ������������ת������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%��
# 4����ȡϵͳ��Դ��show system resource usage����������NE2��NNI�����ڰ壨������
#    �����ã�
# Ԥ�ڽ������1��ÿ�������忨�󣬣�ÿ������������ת������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%��
# 5����ȡϵͳ��Դ��show system resource usage����������NE2�Ľ�������������������
#    �������ã�
# Ԥ�ڽ������1��ÿ��SW�����󣬣�ÿ������������ת������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%��
# 6����ȡϵͳ��Դ��show system resource usage����������NE2��NMS��������������
#    �������ã�
# Ԥ�ڽ������1��ÿ��NMS�����󣬣�ÿ������������ת������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%��
# 7����ȡϵͳ��Դ��show system resource usage��NE2�������б���������������������
#    �������ã�
# Ԥ�ڽ������1��ÿ�α���������ÿ������������ת������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%��
# 8������ɾ��10��pw��ac�����ã�50�Σ�Ҫ����������ã�ÿ��ɾ������
# ��1��ÿ������������ת������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%��
# 8������NE1��NE2�����ã������������
# Ԥ�ڽ������NE1��NE2��ͨ��show running mpls�鿴����etree����
# 9�������8��������NE1��NE2�����ò�����NE1��NE2����������ҵ���ϵͳ��Դ
# Ԥ�ڽ������1��ÿ������������ת������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%��
# 10�������Լ��
# *******************************************************************


set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
	file mkdir "log"
	set fd_log [open "log\\GPN_PTN_013_2_LOG.txt" a]
	set stdout $fd_log
	chan configure $fd_log -blocking 0 -buffering none;#������ģʽ ����flush
	log_file log\\GPN_PTN_013_2_LOG.txt
	
	file mkdir "report"
	set fileId [open "report\\GPN_PTN_013_2_REPORT.txt" a+]
	chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_013_2_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_013_2_DEBUG.txt 0
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
	set flagCase1 0   ;#Test case 4��־λ 
	set flagCase2 0   ;#Test case 5��־λ
	set flagCase3 0   ;#Test case 6��־λ 
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
	while {[gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort15 "shutdown"]} {
					
	}
	
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
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:10:94:00:00:45</dstMac><srcMac>00:00:00:00:00:01</srcMac><vlans name="anon_55548"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} ]
 #    set dStreamData26 [stc::create "StreamBlock" \
	# -under $hGPNPort2 \
	# -EqualRxPortDistribution "FALSE" \
	# -FrameLengthMode "RANDOM" \
	# -MinFrameLength "64" \
	# -MaxFrameLength "1518" \
	# -FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:10:94:00:00:04</dstMac><srcMac>00:00:00:01:00:01</srcMac><vlans name="anon_7611"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} ]
    
    ###���ö˿�2ARPreply��request

    set dStreamData22 [stc::create "StreamBlock" \
	-under $hGPNPort2 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:01:00:00:00:01</dstMac><srcMac>01:00:00:00:00:01</srcMac><vlans name="anon_33114"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="ARP_1" pdu="arp:ARP"><hardware>0001</hardware><protocol>0800</protocol><operation>2</operation><senderHwAddr>01:00:00:00:00:01</senderHwAddr></pdu></pdus></config></frame>} ]
    set dStreamData23 [stc::create "StreamBlock" \
	-under $hGPNPort2 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>FF:FF:FF:FF:FF:FF</dstMac><srcMac>01:00:00:00:00:01</srcMac><vlans name="anon_33119"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="ARP_1" pdu="arp:ARP"><hardware>0001</hardware><protocol>0800</protocol><senderHwAddr>01:00:00:00:00:01</senderHwAddr><targetPAddr>192.85.1.3</targetPAddr></pdu></pdus></config></frame>} ]
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
    ###δ֪����0.001M
    stc::config [stc::get $dStreamData16 -AffiliationStreamBlockLoadProfile] -LoadUnit "MEGABITS_PER_SECOND" -Load "1"
    #stc::config [stc::get $dStreamData26 -AffiliationStreamBlockLoadProfile] -LoadUnit "MEGABITS_PER_SECOND" -Load "1"
    foreach hStream "$dStreamData16" {
	 stc::perform streamBlockActivate -streamBlockList $hStream -activate "TRUE"
    }
    foreach hStream "$dStreamData22 $dStreamData23" {
	 stc::perform streamBlockActivate -streamBlockList $hStream -activate "FALSE"
    }
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
    gwd::GWpublic_saveTCCfg 1 $fd_log "GPN_LSP_013_2_Case1_$tcId.xml" [pwd]/Untitled
    puts $fileId ""
    puts $fileId "======================================================================================\n"
 
	#���ڵ��������豸�õ��ı���------
	set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
	set lMatchType "$matchType1 $matchType2 $matchType3 $matchType4"
	set lDutType "$Gpn_type1 $Gpn_type2 $Gpn_type3 $Gpn_type4"
	set lIp "$gpnIp1 $gpnIp2 $gpnIp3 $gpnIp4"
	#------���ڵ��������豸�õ��ı���
	
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 1��VSI����1��PW��ϵͳ����-1��AC����������\n"
    set cfgFlag 0
    set flag1_Case1 0;set flag2_Case1 0;set flag3_Case1 0;set flag4_Case1 0;set flag5_Case1 0;set flag6_Case1 0;set flag7_Case1 0;set flag8_Case1 0;set flag9_Case1 0;set flag10_Case1 0 
    set pw12 "pw12_1"
    set pw21 "pw21_1"
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
	
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "ETREE�������ȶ��Բ��Ի�������ʧ�ܣ����Խ���" \
	"ETREE�������ȶ��Բ��Ի������óɹ�����������Ĳ���" "GPN_PTN_013_2"
    puts $fileId ""
    puts $fileId "===ETREE�������ȶ��Բ��Ի������ý���..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "default" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====1��VSI����1��PW��ϵͳ����-1��AC�����ã����Կ�ʼ=====\n"
	set vid 10
	set ip12 11.1.1.1
	set ip21 11.1.1.2
	if {[string match "L2" $Worklevel]} {
		set interfaceA v$vid
		set interfaceB v$vid
		set interface1 v10
		set interface2 v10

		lappend flag1_Case1 [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "enable"]
		lappend flag1_Case1 [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "enable"]
	} else {
		set interfaceA $GPNPort5.$vid
		set interfaceB $GPNPort6.$vid
		set interface1 $GPNPort5.$vid
		set interface2 $GPNPort6.$vid
	}
	###����VLANIF�ӿ�(NE1�˿�ģʽ��NE2�˿ڼ���Ӫ��ģʽ)
	lappend flag1_Case1 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceA $ip12 $GPNPort5 $matchType1 $Gpn_type1 $telnet1]
	lappend flag1_Case1 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceB $ip21 $GPNPort6 $matchType2 $Gpn_type2 $telnet2]
	###����vpls
	lappend flag1_Case1 [gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" 1 "etree" "flood" "false" "false" "false" "true" "5000" "" "tagged"]
	lappend flag1_Case1 [gwd::GWVpls_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls1" 1 "etree" "flood" "false" "false" "false" "true" "5000" "" "tagged"]
    ####����NE1
	lappend flag1_Case1 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface1 $ip21 "1000" "1000" "normal" "1"]
	lappend flag1_Case1 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612]
	lappend flag1_Case1 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"]
	lappend flag1_Case1 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "$pw12" "vpls" "vpls1" "peer" $address612 "100" "100" "" "add" "none" 1 0 "0x8100" "0x8100" "1"]
	
	####����NE2
	lappend flag1_Case1 [gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface2 $ip12 "1000" "1000" "normal" "1"]
	lappend flag1_Case1 [gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621]
	lappend flag1_Case1 [gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"]
	lappend flag1_Case1 [gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "$pw21" "vpls" "vpls1" "peer" $address621 "100" "100" "" "add" "root" 1 0 "0x8100" "0x8100" "1"]
	####����lsp��ac��pw����ͳ��ʹ��
	lappend flag1_Case1 [gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" "enable"]
  lappend flag1_Case1 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "$pw12" "enable"]
  lappend flag1_Case1 [gwd::GWpublic_addLspStat $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" "enable"]
  lappend flag1_Case1 [gwd::GWpublic_addPwStatEn $telnet2 $matchType2 $Gpn_type2 $fileId "$pw21" "enable"]
  lappend flag1_Case1 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel 1000 $GPNTestEth1]
	lappend flag1_Case1 [PTN_UNI_AddInter $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel 1000 $GPNTestEth2]
	lappend flag1_Case1 [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "vpls1" "" $GPNTestEth1 "0" "0" "none" "delete" "1000" "0" "0" "0x8100" "evc2"]	
	lappend flag1_Case1 [gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac1000" "vpls1" "" $GPNTestEth2 "1000" "0" "leaf" "modify" "1000" "0" "0" "0x8100" "evc2"]
	lappend flag1_Case1 [gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac1000" "enable"]
	lappend flag1_Case1 [gwd::GWpublic_addAcStatEn $telnet2 $matchType2 $Gpn_type2 $fileId "ac1000" "enable"]
	for {set i 1} {$i < [expr $acPwCnt-1]} {incr i} {
		set acVlan [expr 1000+$i]
		lappend flag1_Case1 [PTN_UNI_AddInter $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $acVlan $GPNTestEth2]
		lappend flag1_Case1 [gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac$acVlan" "vpls1" "ethernet" $GPNTestEth2 "$acVlan" "0" "leaf" "modify" "$acVlan" "0" "0" "0x8100" "evc2"]
		lappend flag1_Case1 [gwd::GWpublic_addAcStatEn $telnet2 $matchType2 $Gpn_type2 $fileId "ac$acVlan" "enable"]
    }
  gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
  gwd::GW_AddUploadFile $telnet1 $matchType1 $Gpn_type1 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
    "config" "GPN_PTN_013_2_fullacNE1.txt" "" "120"
  gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
  gwd::GW_AddUploadFile $telnet2 $matchType2 $Gpn_type2 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
    "config" "GPN_PTN_013_2_fullacNE2.txt" "" "120"
    incr cfgId
  lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_013_2" lFailFileTmp]
  if {$lFailFileTmp != ""} {
    set lFailFile [concat $lFailFile $lFailFileTmp]
  }
    if {"1" in $flag1_Case1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1�����ۣ�1��VSI����1��PW��ϵͳ����-1��AC�����ã�ʧ��" $fileId 
	} else { 
		gwd::GWpublic_print "OK" "FA1�����ۣ�1��VSI����1��PW��ϵͳ����-1��AC�����ã��ɹ�" $fileId
	}
	puts $fileId ""
    gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====1��VSI����1��PW��ϵͳ����-1��AC�����ã����Խ���=====\n"
    puts $fileId ""
	puts $fileId "======================================================================================\n"
	puts $fileId ""
    gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ��NE1��NE2�Է��������ֽڳ���Ϊrandom��len��64-1518���鿴�������������ͳ�ƣ����Կ�ʼ=====\n"
	
	gwd::Start_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
	after 20000

	lappend flag2_Case1 [MPLS_ClassStatisticsAna "1" $infoObj1 $infoObj2 "" "" "1000" "00:00:00:00:00:01" valuedrop1 valuedrop2 valuecnt1 valuecnt2 "GPN_PTN_013_2_A2_1"]
	gwd::Stop_SendFlow $::hGPNPortGenList $::hGPNPortAnaList

	set dStreamData14 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:00:00:00:01</dstMac><srcMac>00:01:00:01:00:01</srcMac><vlans name="anon_33148"><Vlan name="Vlan"><pri>000</pri><id>999</id></Vlan></vlans></pdu><pdu name="ARP_1" pdu="arp:ARP"><hardware>0001</hardware><protocol>0800</protocol><operation>2</operation><senderHwAddr>00:01:00:01:00:01</senderHwAddr></pdu></pdus></config></frame>} ]

    set dStreamData15 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>FF:FF:FF:FF:FF:FF</dstMac><srcMac>00:01:00:01:00:01</srcMac><vlans name="anon_33153"><Vlan name="Vlan"><pri>000</pri><id>999</id></Vlan></vlans></pdu><pdu name="ARP_1" pdu="arp:ARP"><hardware>0001</hardware><protocol>0800</protocol><operation>2</operation><senderHwAddr>00:01:00:01:00:01</senderHwAddr></pdu></pdus></config></frame>} ]
    set dStreamData24 [stc::create "StreamBlock" \
	-under $hGPNPort2 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:01:00:00:00:01</dstMac><srcMac>01:00:00:00:00:01</srcMac><vlans name="anon_33124"><Vlan name="Vlan"><pri>000</pri><id>999</id></Vlan></vlans></pdu><pdu name="ARP_1" pdu="arp:ARP"><hardware>0001</hardware><protocol>0800</protocol><operation>2</operation><senderHwAddr>01:00:00:00:00:01</senderHwAddr></pdu></pdus></config></frame>} ]
   
    set dStreamData25 [stc::create "StreamBlock" \
	-under $hGPNPort2 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>FF:FF:FF:FF:FF:FF</dstMac><srcMac>01:00:00:00:00:01</srcMac><vlans name="anon_33129"><Vlan name="Vlan"><pri>000</pri><id>999</id></Vlan></vlans></pdu><pdu name="ARP_1" pdu="arp:ARP"><hardware>0001</hardware><protocol>0800</protocol><operation>2</operation><senderHwAddr>01:00:00:00:00:01</senderHwAddr></pdu></pdus></config></frame>} ]
    ###���͸���Э�鱨��
   set protocol1 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-EnableFcsErrorInsertion "TRUE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac>00:10:94:00:00:01</srcMac><vlans name="anon_46825"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><checksum>14740</checksum><tosDiffserv name="anon_46828"><tos name="anon_46829"></tos></tosDiffserv></pdu></pdus></config></frame>} \
	-Name {crc} ]
   set protocol2 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>FF:FF:FF:FF:FF:FF</dstMac><srcMac>00:10:94:00:00:22</srcMac><vlans name="anon_46834"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="proto1" pdu="arp:ARP"><hardware>0001</hardware><protocol>0800</protocol><senderHwAddr>00:10:94:00:00:02</senderHwAddr><senderPAddr>10.1.0.2</senderPAddr><targetPAddr>10.1.0.1</targetPAddr></pdu></pdus></config></frame>} \
	-Name {arp-req} ]
   set protocol3 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:0F:E9:36:F0:FB</dstMac><vlans name="anon_46687"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="proto1" pdu="arp:ARP"><hardware>0001</hardware><protocol>0800</protocol><operation>2</operation><senderHwAddr>00:10:94:00:00:02</senderHwAddr><senderPAddr>192.168.0.6</senderPAddr><targetHwAddr>00:10:94:00:00:02</targetHwAddr><targetPAddr>192.168.0.6</targetPAddr></pdu></pdus></config></frame>} \
	-Name {arp-rep} ]
   set protocol4 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:01:00:00:01</dstMac><srcMac>00:10:94:00:00:03</srcMac><vlans name="anon_46839"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><checksum>14740</checksum><tosDiffserv name="anon_46842"><tos name="anon_46843"></tos></tosDiffserv></pdu></pdus></config></frame>} \
	-Name {zubo} ]
   set protocol5 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>FF:FF:FF:FF:FF:FF</dstMac><srcMac>00:10:94:00:00:23</srcMac><vlans name="anon_46848"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><checksum>14740</checksum><tosDiffserv name="anon_46851"><tos name="anon_46852"></tos></tosDiffserv></pdu></pdus></config></frame>} \
	-Name {guangbo} ]
   set protocol6 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:09</dstMac><srcMac>00:10:94:00:00:09</srcMac><vlans name="anon_46857"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><protocol override="true" >17</protocol><checksum>14976</checksum><tosDiffserv name="anon_46860"><tos name="anon_46861"></tos></tosDiffserv></pdu></pdus></config></frame>} \
	-Name {rip} ]
   set protocol7 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:05</dstMac><srcMac>00:10:94:00:00:07</srcMac><vlans name="anon_46866"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><protocol override="true" >89</protocol><checksum>14904</checksum><tosDiffserv name="anon_46869"><tos name="anon_46870"></tos></tosDiffserv></pdu></pdus></config></frame>} \
	-Name {ospf-1} ]
   set protocol8 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:06</dstMac><srcMac>00:10:94:00:00:08</srcMac><vlans name="anon_46875"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><protocol override="true" >89</protocol><checksum>14904</checksum><tosDiffserv name="anon_46878"><tos name="anon_46879"></tos></tosDiffserv></pdu></pdus></config></frame>} \
	-Name {ospf-2} ]
   set protocol9 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:14</dstMac><srcMac>00:10:94:00:00:15</srcMac><vlans name="anon_46884"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} \
	-Name {isis-1} ]
   set protocol10 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:15</dstMac><srcMac>00:10:94:00:00:16</srcMac><vlans name="anon_46888"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} \
	-Name {isis-2} ]
   set protocol11 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>09:00:2B:00:00:05</dstMac><srcMac>00:10:94:00:00:18</srcMac><vlans name="anon_46892"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} \
	-Name {isis-3} ]
   set protocol12 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:02</dstMac><srcMac>00:10:94:00:00:06</srcMac><vlans name="anon_46896"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><protocol override="true" >17</protocol><checksum>14976</checksum><tosDiffserv name="anon_46899"><tos name="anon_46900"></tos></tosDiffserv></pdu></pdus></config></frame>} \
	-Name {ldp} ]
   set protocol13 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:00</dstMac><srcMac>00:10:94:00:00:04</srcMac><vlans name="anon_46905"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><protocol override="true" >103</protocol><checksum>14890</checksum><tosDiffserv name="anon_46908"><tos name="anon_46909"></tos></tosDiffserv></pdu></pdus></config></frame>} \
	-Name {pim-1} ]
   set protocol14 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:0D</dstMac><srcMac>00:10:94:00:00:10</srcMac><vlans name="anon_46914"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><protocol override="true" >103</protocol><checksum>14890</checksum><tosDiffserv name="anon_46917"><tos name="anon_46918"></tos></tosDiffserv></pdu></pdus></config></frame>} \
	-Name {pim-2} ]
   set protocol15 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:00</dstMac><srcMac>00:10:94:00:00:05</srcMac><vlans name="anon_46923"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv6:IPv6"><payloadLength>0</payloadLength><nextHeader override="true" >103</nextHeader></pdu></pdus></config></frame>} \
	-Name {pimv6-1} ]
   set protocol16 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:00:5E:00:00:0D</dstMac><srcMac>00:10:94:00:00:11</srcMac><vlans name="anon_46928"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv6:IPv6"><payloadLength>0</payloadLength><nextHeader override="true" >103</nextHeader></pdu></pdus></config></frame>} \
	-Name {pimv6-2} ]
   set protocol17 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:CD:00:00:01</dstMac><srcMac>00:10:94:00:00:17</srcMac><etherType override="true" >8903</etherType><vlans name="anon_46933"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} \
	-Name {mrps} ]
   set protocol18 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:02</dstMac><srcMac>00:10:94:00:00:13</srcMac><etherType override="true" >8809</etherType><vlans name="anon_46937"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} \
	-Name {lacp/eth/efm} ]
   set protocol19 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C2:00:00:0E</dstMac><srcMac>00:10:94:00:00:14</srcMac><etherType override="true" >88CC</etherType><vlans name="anon_46941"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} \
	-Name {lldp} ]

   set protocol20 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>01:80:C0:00:00:02</dstMac><srcMac>00:10:94:00:00:12</srcMac><etherType override="true" >8809</etherType><vlans name="anon_46945"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} \
	-Name {cfm} ]
   set protocol21 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>33:33:00:00:00:09</dstMac><srcMac>00:10:94:00:00:21</srcMac><vlans name="anon_46949"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"><totalLength>20</totalLength><protocol override="true" >17</protocol><checksum>14976</checksum><tosDiffserv name="anon_46952"><tos name="anon_46953"></tos></tosDiffserv></pdu></pdus></config></frame>} \
	-Name {rping} ]
   set protocol22 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>33:33:00:00:00:05</dstMac><srcMac>00:10:94:00:00:19</srcMac><vlans name="anon_46958"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv6:IPv6"><payloadLength>0</payloadLength><nextHeader override="true" >89</nextHeader></pdu></pdus></config></frame>} \
	-Name {ospfv3-1} ]
   set protocol23 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>33:33:00:00:00:06</dstMac><srcMac>00:10:94:00:00:20</srcMac><vlans name="anon_46963"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv6:IPv6"><payloadLength>0</payloadLength><nextHeader override="true" >89</nextHeader></pdu></pdus></config></frame>} \
	-Name {ospfv3-2} ]
    
	
	set dStreamData11 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FixedFrameLength "68" \
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
    set RangeModifier113 [stc::create "RangeModifier" \
	    -under $dStreamData11 \
	    -Mask {4095} \
	    -StepValue {1} \
	    -RecycleCount "[expr $acPwCnt-1]" \
	    -Data {1000} \
	    -EnableStream "TRUE" \
	    -OffsetReference {eth1.vlans.Vlan.id} \
	    -Name {Modifier} ]
	set dStreamData21 [stc::create "StreamBlock" \
	-under $hGPNPort2 \
	-EqualRxPortDistribution "FALSE" \
	-FixedFrameLength "68" \
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
   set RangeModifier213 [stc::create "RangeModifier" \
	    -under $dStreamData21 \
	    -Mask {4095} \
	    -StepValue {1} \
	    -RecycleCount "[expr $acPwCnt-1]" \
	    -Data {1000} \
	    -EnableStream "TRUE" \
	    -OffsetReference {eth1.vlans.Vlan.id} \
	    -Name {Modifier} ]
	###��֪����600M
    stc::config [stc::get $dStreamData11 -AffiliationStreamBlockLoadProfile] -LoadUnit "MEGABITS_PER_SECOND" -Load "0.001" 
    stc::config [stc::get $dStreamData21 -AffiliationStreamBlockLoadProfile] -LoadUnit "MEGABITS_PER_SECOND" -Load "0.001" 
    ###Э�鱨���ܹ���1M
   set hGPNPortStreamList1 "$dStreamData14 $dStreamData15 $dStreamData24 $dStreamData25 $protocol1 $protocol2 $protocol3 $protocol4 $protocol5 \
   $protocol6 $protocol7 $protocol8 $protocol9 $protocol10 $protocol11 $protocol12 $protocol13 $protocol14 $protocol15 $protocol16 $protocol17 \
   $protocol18 $protocol19 $protocol20 $protocol21 $protocol22 $protocol23 $dStreamData22 $dStreamData23"
   foreach stream $::hGPNPortStreamList1 {
			stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 0.02 -LoadUnit MEGABITS_PER_SECOND
		}
   foreach hStream $::hGPNPortStreamList1 {
	stc::perform streamBlockActivate -streamBlockList $hStream -activate "FALSE"
   }
   foreach hStream "$dStreamData11 $dStreamData21" {
	stc::perform streamBlockActivate -streamBlockList $hStream -activate "TRUE"
   }
   foreach hStream "$dStreamData16" {
	stc::perform streamBlockActivate -streamBlockList $hStream -activate "FALSE"
   }
    incr tcId 
    gwd::GWpublic_saveTCCfg 1 $fd_log "GPN_LSP_013_2_Case1_$tcId.xml" [pwd]/Untitled
    stc::apply
    gwd::Start_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
    if {$acPwCnt>256} {
	    after 900000;###15���Ӻ�
    } elseif {$acPwCnt < 257 && $acPwCnt > 128} {
	    after 300000;###5�����Ժ�
    } else {
	    after 240000;###4�����Ժ�
    }
    stc::config [stc::get $dStreamData11 -AffiliationStreamBlockLoadProfile] -LoadUnit "MEGABITS_PER_SECOND" -Load "600" 
    stc::config [stc::get $dStreamData21 -AffiliationStreamBlockLoadProfile] -LoadUnit "MEGABITS_PER_SECOND" -Load "600" 
    stc::apply
    set lport1 "$hGPNPort1 $hGPNPort2 $hGPNPort3 $hGPNPort4"
    gwd::Stop_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
    stc::config $dStreamData11 -FrameLengthMode "RANDOM"
    stc::config $dStreamData21 -FrameLengthMode "RANDOM"
    stc::perform ResultsClearAll -PortList $lport1
    stc::apply
    incr tcId 
    gwd::GWpublic_saveTCCfg 1 $fd_log "GPN_LSP_013_2_Case1_$tcId.xml" [pwd]/Untitled
    lappend flag2_Case1 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_013_2_FA2"]
	lappend flag2_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
	lappend flag2_Case1 [gwd::GWpublic_getMplsStat $telnet2 $matchType2 $Gpn_type2 $fileId "lsp tunnel" "lsp21" GPNLsp1Stat2]
	lappend flag2_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
	lappend flag2_Case1 [gwd::GWpublic_getMplsStat $telnet2 $matchType2 $Gpn_type2 $fileId "ac" "ac1000" GPNAcStat2]
	lappend flag2_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "$pw12" GPNPwStat1]
	lappend flag2_Case1 [gwd::GWpublic_getMplsStat $telnet2 $matchType2 $Gpn_type2 $fileId "pw" "$pw21" GPNPwStat2]
	lappend flag2_Case1 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	lappend flag2_Case1 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
	if {"1" in $flag2_Case1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2�����ۣ�����acʱ��NE1($gpnIp1)��NE2($gpnIp2)�Է���������arp������ʧ��" $fileId 
	} else { 
		gwd::GWpublic_print "OK" "FA2�����ۣ�����acʱ��NE1($gpnIp1)��NE2($gpnIp2)�Է���������arp�������ɹ�" $fileId
	}
    gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ��NE1��NE2�Է���������arp�������ֽڳ���Ϊrandom��len��64-1518���鿴�������������ͳ�ƣ����Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ��NE1($gpnIp1)����shutdown/undo shut NE2�忨��NNI�ں�UNI�ڣ�����ҵ��ָ���ϵͳ�ڴ�   ���Կ�ʼ=====\n"
	foreach eth "$GPNPort5 $GPNTestEth1" {
		lappend flag3_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource1_1]
		for {set j 1} {$j<=$cnt} {incr j} {
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
		after $WaiteTime
			after 120000
			stc::perform ResultsClearAll -PortList $lport1
	    lappend flag3_Case1 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_013_2_FA3"]
			lappend flag3_Case1 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
			lappend flag3_Case1 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
			lappend flag3_Case1 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
			lappend flag3_Case1 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
			lappend flag3_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
			lappend flag3_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
			lappend flag3_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "$pw12" GPNPwStat1]
			lappend flag3_Case1 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
		    lappend flag3_Case1 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
			lappend flag3_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource1_2]
			send_log "\n shutdownǰresource:$resource1_1"
			send_log "\n ����shutdown/undoshutdown��resource:$resource1_2"
			lappend flag3_Case1 [CheckSystemResource $fileId "��$j\��shutdown/undo shutdown NE2($gpnIp2)�忨��NNI��UNI��" $resource1_1 $resource1_2]
		    
			}
	    }
	puts $fileId ""
	if {"1" in $flag3_Case1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3�����ۣ�����acʱ��NE1($gpnIp1)����shutdown/undo shut NE1�忨��NNI�ں�UNI�ڣ�ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3�����ۣ�����acʱ��NE1($gpnIp1)����shutdown/undo shut NE1�忨��NNI�ں�UNI�ڣ�ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ��NE1($gpnIp1)����shutdown/undo shut NE2�忨��NNI�ں�UNI�ڣ�����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ��NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	foreach slot $rebootSlotlist2 {
		lappend flag4_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource2_1]
		set testFlag 0
		for {set j 1} {$j<=$cnt} {incr j} {
			if {![gwd::GWCard_AddReboot $telnet2 $matchType2 $Gpn_type2 $fileId $slot]} {
			after $rebootBoardTime
				after 120000
			if {[string match $mslot1 $slot]} {
			      set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			      set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
			}
		lappend flag4_Case1 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_013_2_A4_$j"]

			} else {
		set testFlag 1
		gwd::GWpublic_print "OK" " NE1($gpnIp1)$slot\��λ�忨��֧�ְ忨������������������" $fileId
		break
			}
			if {$testFlag == 0} {
				lappend flag4_Case1 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
				lappend flag4_Case1 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
				lappend flag4_Case1 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
				lappend flag4_Case1 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
				lappend flag4_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
				lappend flag4_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
				lappend flag4_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "$pw12" GPNPwStat1]
				lappend flag4_Case1 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
			    lappend flag4_Case1 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
			lappend flag4_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource2_2]
			send_log "\n ����NNI�忨ǰresource:$resource2_1"
			send_log "\n ����NNI�忨��resource:$resource2_2"
			lappend flag4_Case1 [CheckSystemResource $fileId "��$j\������NE1($gpnIp1)$slot\��λ�忨" $resource2_1 $resource2_2]
		}
		}  
	}
	puts $fileId ""
	if {"1" in $flag4_Case1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA4�����ۣ�����acʱ��NE1($gpnIp1)��������NNI�����ڰ忨��ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4�����ۣ�����acʱ��NE1($gpnIp1)��������NNI�����ڰ忨��ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ��NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ��NE1($gpnIp1)�������н����̵ĵ����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	set testFlag 0
	for {set j 1} {$j<=$cntdh} {incr j} {
		lappend flag5_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource3_1]
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
		       after [expr 2*$rebootTime]
			after 120000
		       set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	    set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	    lappend flag5_Case1 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_013_2_A5_$j"]
		} else {
	       set testFlag 1
	       gwd::GWpublic_print "OK" " NE1($gpnIp1)ֻ��һ�������̣���������" $fileId
	       break
		}
		if {$testFlag == 0} {
			lappend flag5_Case1 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
			lappend flag5_Case1 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
			lappend flag5_Case1 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
			lappend flag5_Case1 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
			lappend flag5_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
			lappend flag5_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
			lappend flag5_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "$pw12" GPNPwStat1]
			lappend flag5_Case1 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
		    lappend flag5_Case1 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
		lappend flag5_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource3_2]
		send_log "\n �����̵���ǰresource:$resource3_1"
		send_log "\n �����̵�����resource:$resource3_2"
		lappend flag5_Case1 [CheckSystemResource $fileId "��$j\�ε���NE1($gpnIp1)�Ľ�����" $resource3_1 $resource3_2]
	       }
	}
	puts $fileId ""
	if {"1" in $flag5_Case1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA5�����ۣ�����acʱ��NE1($gpnIp1)�������н����̵ĵ�����ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5�����ۣ�����acʱ��NE1($gpnIp1)�������н����̵ĵ�����ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ��NE1($gpnIp1)�������н����̵ĵ����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ��NE1($gpnIp1)��������NMS��������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	set testFlag 0
	for {set j 1} {$j<=$cntdh} {incr j} {
		lappend flag6_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource4_1]
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
		       after [expr 2*$rebootTime]
			after 120000
		       set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType2 $Gpn_type2 $fileId]
	    set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
	    lappend flag6_Case1 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_013_2_A6_$j"]
		} else {
	       set testFlag 1
	       gwd::GWpublic_print "OK" " NE1($gpnIp1)ֻ��һ�������̣���������" $fileId
	       break
		}
		if {$testFlag == 0} {
			lappend flag6_Case1 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
			lappend flag6_Case1 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
			lappend flag6_Case1 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
			lappend flag6_Case1 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
			lappend flag6_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
			lappend flag6_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
			lappend flag6_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "$pw12" GPNPwStat1]
			lappend flag6_Case1 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
		    lappend flag6_Case1 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
		lappend flag6_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource4_2]
		send_log "\n NMS��������ǰresource:$resource4_1"
		send_log "\n NMS����������resource:$resource4_2"
		lappend flag6_Case1 [CheckSystemResource $fileId "��$j\�ε���NE1($gpnIp1)��������" $resource4_1 $resource4_2]
	       }
	}
	puts $fileId ""
	if {"1" in $flag6_Case1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA6�����ۣ�����acʱ��NE1($gpnIp1)��������NMS������������ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6�����ۣ�����acʱ��NE1($gpnIp1)��������NMS������������ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������NMS�����������󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)�������б����豸�����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	set testFlag 0
	for {set j 1} {$j<=$cnt} {incr j} {
		lappend flag7_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource5_1]
		lappend flag7_Case1 [gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId]
		after 60000
		lappend flag7_Case1 [gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId]
		after [expr 2*$rebootTime]
    set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
    set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
    lappend flag7_Case1 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_013_2_A7_$j"]
	  lappend flag7_Case1 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
		lappend flag7_Case1 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
		lappend flag7_Case1 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
		lappend flag7_Case1 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
		lappend flag7_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
		lappend flag7_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
		lappend flag7_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "$pw12" GPNPwStat1]
		lappend flag7_Case1 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	    lappend flag7_Case1 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
	    lappend flag7_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource5_2]
	    send_log "\n ��������ǰresource:$resource5_1"
	    send_log "\n ����������resource:$resource5_2"
	    lappend flag7_Case1 [CheckSystemResource $fileId "��$j\�α�������NE1($gpnIp1)" $resource5_1 $resource5_2]
	}
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_013_2" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId ""
	if {"1" in $flag7_Case1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA7�����ۣ�����acʱ��NE1($gpnIp1)�������б����豸������ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7�����ۣ�����acʱ��NE1($gpnIp1)�������б����豸������ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ��NE1($gpnIp1)�������б����豸�����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ������ɾ��10��pw��ac�����ã�����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	for {set j 1} {$j<=$cnt} {incr j} {
		lappend flag8_Case1 [gwd::GWmanage_GetSystemResource $telnet2 $matchType2 $Gpn_type2 $fileId "usage" resource6_1]
		lappend flag8_Case1 [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId $pw21]
		if {[expr $acPwCnt]<11} {
			for {set k 1} {$k<[expr $acPwCnt]} {incr k} {
			lappend flag8_Case1 [gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac[expr $k+999]"]
			}
		} else {
			for {set k 1} {$k<11} {incr k} {
			lappend flag8_Case1 [gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac[expr $k+999]"]
			}
		}
		lappend flag8_Case1 [gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "$pw21" "vpls" "vpls1" "peer" $address612 "100" "100" "" "add" "root" 1 0 "0x8100" "0x8100" "1"]
		lappend flag8_Case1 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "$pw21" "enable"]
		for {set i 1} {$i < 11} {incr i} {
			set acVlan [expr 999+$i]
      lappend flag8_Case1 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel $acVlan $GPNTestEth1]
			lappend flag8_Case1 [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac$acVlan" "vpls1" "ethernet" $GPNTestEth1 "$acVlan" "0" "root" "modify" "1" "0" "0" "0x8100" "evc2"]
			lappend flag8_Case1 [gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac$acVlan" "enable"]
	    }
	    lappend flag8_Case1 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_013_2_A7_$j"]
	    lappend flag8_Case1 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
		lappend flag8_Case1 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
		lappend flag8_Case1 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
		lappend flag8_Case1 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
		lappend flag8_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
		lappend flag8_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
		lappend flag8_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "$pw12" GPNPwStat1]
		lappend flag8_Case1 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	    lappend flag8_Case1 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
	    lappend flag8_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource6_2]
	    send_log "\n ɾ��ac��pwǰresource:$resource6_1"
	    send_log "\n ɾ�����ָ�ac��pw��resource:$resource6_2"
	    lappend flag8_Case1 [CheckSystemResource $fileId "��$j\�α�������NE1($gpnIp1)" $resource6_1 $resource6_2]
	}
	
	puts $fileId ""
	if {"1" in $flag8_Case1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA8�����ۣ�����acʱ������ɾ��NE1($gpnIp1)��pw��ac�����ã�ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8�����ۣ�����acʱ������ɾ��NE1($gpnIp1)��pw��ac�����ã�ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ������ɾ��10��pw��ac�����ã�����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ������NE1��NE2�����ã��������������NE1($gpnIp1)��NE2($gpnIp2)����VSI��������ò������豸����֤ҵ��  ���Կ�ʼ=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	lappend flag9_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource7_1]

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
	lappend flag9_Case1 [gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	lappend flag9_Case1 [gwd::GWpublic_showMplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
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
		"GPN_PTN_013_2_fullacNE1.txt" ""
	gwd::GWmanage_ftpDownload $telnet2 $matchType2 $Gpn_type2 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"GPN_PTN_013_2_fullacNE2.txt" ""
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
	after [expr 2*$rebootTime]
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
    set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
	lappend flag9_Case1 [MPLS_ClassStatisticsPort $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen "GPN_PTN_013_2_A7_$j"]
    lappend flag9_Case1 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
	lappend flag9_Case1 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
	lappend flag9_Case1 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
	lappend flag9_Case1 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
	lappend flag9_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
	lappend flag9_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
	lappend flag9_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "$pw12" GPNPwStat1]
	lappend flag9_Case1 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	lappend flag9_Case1 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
	lappend flag9_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource7_2]
	send_log "\n ������ò��ָ�����ǰresource:$resource7_1"
	send_log "\n ������ò��ָ����ú�resource:$resource7_2"
	lappend flag9_Case1 [CheckSystemResource $fileId "��������NE1($gpnIp1)" $resource7_1 $resource7_2]
	if {"1" in $flag9_Case1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA9�����ۣ�����acʱ������NE1��NE2�����ã�������ú�ָ����ã�ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9�����ۣ�����acʱ������NE1��NE2�����ã�������ú�ָ����ã�ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	gwd::Stop_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====����acʱ������NE1��NE2�����ã��������������NE1($gpnIp1)��NE2($gpnIp2)����VSI��������ò������豸����֤ҵ��  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���ܳ��ڣ�����ҵ��  ���Կ�ʼ=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	lappend flag10_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource8_1]
	if {[string match -nocase $longTermIf "true"]} {
		lappend flag10_Case1 [MPLS_ClassStatisticsPort4 $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen $hGPNPort3Ana $hGPNPort3Gen $hGPNPort4Ana $hGPNPort4Gen $lTermTime "1"]
		    lappend flag10_Case1 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
			lappend flag10_Case1 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
			lappend flag10_Case1 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
			lappend flag10_Case1 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
			lappend flag10_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
			lappend flag10_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
			lappend flag10_Case1 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "$pw12" GPNPwStat1]
			lappend flag10_Case1 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
			lappend flag10_Case1 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
			lappend flag10_Case1 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource8_2]
			send_log "\n ���ܳ���ǰresource:$resource8_1"
			send_log "\n ���ܳ��ں�resource:$resource8_2"
			lappend flag10_Case1 [CheckSystemResource $fileId "���ܳ���ǰ��" $resource8_1 $resource8_2]
		} else {
        	       gwd::GWpublic_print "OK" "�˴β��Բ����г����Բ��ԣ���������" $fileId
        	       
		}
	
	if {"1" in $flag10_Case1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA10�����ۣ����ܳ��ڣ�ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA10�����ۣ����ܳ��ڣ�ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	gwd::Stop_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���ܳ��ڣ�����ҵ��  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"

	puts $fileId ""
	if {$flagCase1 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 1���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 1���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 1 1��VSI����1��PW��ϵͳ����-1��AC����������\n"
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
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_013_2"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_013_2"
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_013_2����Ŀ�ģ�ETREE�������ȶ��Բ���\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1==1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_013_2���Խ��" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1���Խ��" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_Case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�1��VSI����1��PW��ϵͳ����-1��AC������,[expr {($flag1_Case1 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_Case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����acʱ��NE1($gpnIp1)��NE2($gpnIp2)�Է���������arp����,[expr {($flag2_Case1 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_Case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����acʱ��NE1($gpnIp1)����shutdown/undo shut NE1�忨��NNI�ں�UNI��,���Զ�etreeҵ���CPU�����ʵ�Ӱ��,[expr {($flag3_Case1 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_Case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����acʱ��NE1($gpnIp1)��������NNI�����ڰ忨��,���Զ�etreeҵ���CPU�����ʵ�Ӱ��,[expr {($flag4_Case1 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_Case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����acʱ��NE1($gpnIp1)�������н����̵ĵ�����,���Զ�etreeҵ���ϵͳCPU�����ʵ�Ӱ��,[expr {($flag5_Case1 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag6_Case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����acʱ��NE1($gpnIp1)��������NMS������������,��etreeҵ���ϵͳ�ڴ��Ӱ��,[expr {($flag6_Case1 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag7_Case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����acʱ��NE1($gpnIp1)�������б����豸������,��etreeҵ���ϵͳ�ڴ��Ӱ��,[expr {($flag7_Case1 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag8_Case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����acʱ������ɾ��NE1($gpnIp1)��pw��ac������,��etreeҵ���ϵͳ�ڴ��Ӱ��,[expr {($flag8_Case1 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag9_Case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����acʱ������NE1��NE2�����ã�������ú�ָ�����,��etreeҵ���ϵͳ�ڴ��Ӱ��,[expr {($flag9_Case1 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FA10 == [expr {($flag10_Case1 == 1) ? "NOK" : "OK"}]" "�����ۣ������Բ���[expr {($flag10_Case1 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_013_2"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_013_2_REPORT.txt" "report\\NOK_GPN_PTN_013_2_REPORT.txt"
	file rename "log\\GPN_PTN_013_2_LOG.txt" "log\\NOK_GPN_PTN_013_2_LOG.txt"
} else {
	file rename "report\\GPN_PTN_013_2_REPORT.txt" "report\\OK_GPN_PTN_013_2_REPORT.txt"
	file rename "log\\GPN_PTN_013_2_LOG.txt" "log\\OK_GPN_PTN_013_2_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}
