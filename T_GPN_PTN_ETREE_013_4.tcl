#!/bin/sh
# T4_GPN_PTN_ETREE_013_4.tcl \
exec tclsh "$0" ${1+"$@"}
# ϵͳ�г���VSI����������
# 1������NE1��NE2��NE3��NE4֮���EVP-Treeҵ��NE2��ΪPE��Ϊp�豸�������豸�û���
#    ����ģʽΪ���˿�+��Ӫ��VLAN��ģʽ��NE1��NE2��NE3��NE4֮�������һ��lsp��һ��
#    vpls���������PW��һ��AC������1024��vpls(������)��ʹ������lsp pw ac������ͳ
#    ��
# 2��NE1����100M��δ֪����
# Ԥ�ڽ����NE2��NE3��NE4�����յ�100M
# 2��NE1��NE2��NE3��NE4����smac��dmac��vid��vid��10��ʼ��������������֪��������
#    ��Ϊrandom��64-1518��300M����̨�豸������100Marp�������ģ�reply��qurey��vid
#    ��10��ʼ����������vid����ȷ��arp�������ģ�reply��request����100M��Э�鱨�Ĺ�
#    10M��һ����ȷvid���ɣ���ʹNE1��NE2�ڵ�NNI�������ﵽ810M
# Ԥ�ڽ����ÿ������������ת����vid+smac��ȷ����������Э�鱨�Ĳ�������arp������
# 3����ȡNE1ϵͳ��Դ��show system resource usage������shutdown/undo shut NE1��
#    ����NNI�ں�UNI�ڣ������������ã�
# Ԥ�ڽ����ÿ��shut undoshut����
# ��1����֪������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%
# 4����ȡϵͳ��Դ��show system resource usage����������NE1��NNI�����ڰ壨������
#    �����ã�
# Ԥ�ڽ����ÿ�������忨����
# ��1����֪������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%
# 5����ȡϵͳ��Դ��show system resource usage����������NE1�Ľ���������������������ÿ��SW��������ÿ������ת����ֻ����Ƿ��յ�ÿ������������鶪��
# Ԥ�ڽ����ÿ��SW��������
# ��1����֪������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%
# 6����ȡϵͳ��Դ��show system resource usage����������NE1��NMS��������������
#    �������ã�
# Ԥ�ڽ����ÿ��NMS������
# ��1����֪������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%
# 7����ȡϵͳ��Դ��show system resource usage��NE1�������б���������������������
#    �������ã�
# Ԥ�ڽ����ÿ�α���������
# ��1����֪������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%
# 8������ɾ��10��pw��10��ac��10��vpls��ÿ����ɾ����
# Ԥ�ڽ����
# ��1����֪������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%
# 8������NE1��NE3�����ã������������
# Ԥ�ڽ������NE1��NE3��ͨ��show running mpls�鿴����etree����
# 9�������8��������NE1��NE3�����ò�����NE1��NE3����������ҵ���ϵͳ��Դ
# Ԥ�ڽ����
# ��1����֪������������Э�鱨�Ĳ�������arp���Ĳ�����
# ��2��show interface pw ��show interface ac
# ��3���鿴NE1 lsp ac pw������ͳ�Ʋ��ѽ����ӡ��log�У����ж�����ͳ���Ƿ���ȷ
# ��4��show task�Ľ����ӡ��log��
# ��5��cpu�������������1%���û������ʵ������0.1%��ϵͳ�����ʵ������0.1%
# 10�������Լ��

# *******************************************************************

set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
	file mkdir "log"
	set fd_log [open "log\\GPN_PTN_013_4_LOG.txt" a]
	set stdout $fd_log
	chan configure $fd_log -blocking 0 -buffering none;#������ģʽ ����flush
	log_file log\\GPN_PTN_013_4_LOG.txt
	
	file mkdir "report"
	set fileId [open "report\\GPN_PTN_013_4_REPORT.txt" a+]
	chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_013_4_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_013_4_DEBUG.txt 0
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
	set flagCase3 0   ;#Test case 3��־λ 
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
	# while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"]} {
		
	# }
	# while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort13 "shutdown"]} {
		
	# }
	# while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort17 "shutdown"]} {
			
	# }
	# while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort19 "shutdown"]} {
		
	# }
	# while {[gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort23 "shutdown"]} {
			
	# }
	
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
    set hGPNPortGenCfgList "$hgenerator1 $hgenerator2 $hgenerator3 $hgenerator4"
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
    ###δ֪������modifier
	set RangeModifier161 [stc::create "RangeModifier" \
		-under $dStreamData16 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "$acPwCnt" \
		-Data {00:00:00:00:00:01} \
		-EnableStream "TRUE" \
		-Offset "2" \
		-OffsetReference {eth1.srcMac} \
		-Name {MAC Modifier} ]
	
	set RangeModifier162 [stc::create "RangeModifier" \
		-under $dStreamData16 \
		-Mask {4095} \
		-StepValue {1} \
		-RecycleCount "$acPwCnt" \
		-Data {1000} \
		-EnableStream "TRUE" \
		-OffsetReference {eth1.vlans.Vlan.id} \
		-Name {Modifier} ]
	set dStreamData12 [stc::create "StreamBlock" \
	-under $hGPNPort1 \
	-EqualRxPortDistribution "FALSE" \
	-FrameLengthMode "RANDOM" \
	-MinFrameLength "64" \
	-MaxFrameLength "1518" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:00:00:10:00:01</dstMac><srcMac>00:00:00:20:00:01</srcMac><vlans name="anon_12266"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} ]

	set RangeModifier(1) [stc::create "RangeModifier" \
		-under $dStreamData12 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "$acPwCnt" \
		-Data {00:00:00:10:00:01} \
		-EnableStream "TRUE" \
		-Offset "2" \
		-OffsetReference {eth1.dstMac} \
		-Name {MAC Modifier} ]
	
	set RangeModifier(2) [stc::create "RangeModifier" \
		-under $dStreamData12 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "$acPwCnt" \
		-Data {00:00:00:20:00:01} \
		-EnableStream "TRUE" \
		-Offset "2" \
		-OffsetReference {eth1.srcMac} \
		-Name {MAC Modifier} ]
	
	set RangeModifier(3) [stc::create "RangeModifier" \
		-under $dStreamData12 \
		-Mask {4095} \
		-StepValue {1} \
		-RecycleCount "$acPwCnt" \
		-Data {1000} \
		-EnableStream "TRUE" \
		-OffsetReference {eth1.vlans.Vlan.id} \
		-Name {Modifier} ]
	
	set dStreamData13 [stc::create "StreamBlock" \
		-under $hGPNPort1 \
		-EqualRxPortDistribution "FALSE" \
		-FrameLengthMode "RANDOM" \
		-MinFrameLength "64" \
		-MaxFrameLength "1518" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:00:00:30:00:01</dstMac><srcMac>00:00:00:40:00:01</srcMac><vlans name="anon_12270"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} ]
	
	set RangeModifier(4) [stc::create "RangeModifier" \
		-under $dStreamData13 \
		-Mask {4095} \
		-StepValue {1} \
		-RecycleCount "$acPwCnt" \
		-Data {1000} \
		-EnableStream "TRUE" \
		-OffsetReference {eth1.vlans.Vlan.id} \
		-Name {Modifier} ]
	
	set RangeModifier(5) [stc::create "RangeModifier" \
		-under $dStreamData13 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "$acPwCnt" \
		-Data {00:00:00:30:00:01} \
		-EnableStream "TRUE" \
		-Offset "2" \
		-OffsetReference {eth1.dstMac} \
		-Name {MAC Modifier} ]
	
	set RangeModifier(6) [stc::create "RangeModifier" \
		-under $dStreamData13 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "$acPwCnt" \
		-Data {00:00:00:40:00:01} \
		-EnableStream "TRUE" \
		-Offset "2" \
		-OffsetReference {eth1.srcMac} \
		-Name {MAC Modifier} ]
	
	set dStreamData14 [stc::create "StreamBlock" \
		-under $hGPNPort1 \
		-EqualRxPortDistribution "FALSE" \
		-FrameLengthMode "RANDOM" \
		-MinFrameLength "64" \
		-MaxFrameLength "1518" \
		-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:00:00:50:00:01</dstMac><srcMac>00:00:00:60:00:01</srcMac><vlans name="anon_12274"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} ]
	
	set RangeModifier(7) [stc::create "RangeModifier" \
		-under $dStreamData14 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "$acPwCnt" \
		-Data {00:00:00:50:00:01} \
		-EnableStream "TRUE" \
		-Offset "2" \
		-OffsetReference {eth1.dstMac} \
		-Name {MAC Modifier} ]
	
	set RangeModifier(8) [stc::create "RangeModifier" \
		-under $dStreamData14 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "$acPwCnt" \
		-Data {00:00:00:60:00:01} \
		-EnableStream "TRUE" \
		-Offset "2" \
		-OffsetReference {eth1.srcMac} \
		-Name {MAC Modifier} ]
	
	set RangeModifier(9) [stc::create "RangeModifier" \
		-under $dStreamData14 \
		-Mask {4095} \
		-StepValue {1} \
		-RecycleCount "$acPwCnt" \
		-Data {1000} \
		-EnableStream "TRUE" \
		-OffsetReference {eth1.vlans.Vlan.id} \
		-Name {Modifier} ]

	set dStreamData21 [stc::create "StreamBlock" \
	-under $hGPNPort2 \
	-EqualRxPortDistribution "FALSE" \
	-FrameLengthMode "RANDOM" \
	-MinFrameLength "64" \
	-MaxFrameLength "1518" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:00:00:20:00:01</dstMac><srcMac>00:00:00:10:00:01</srcMac><vlans name="anon_12262"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} ]

	set RangeModifier(10) [stc::create "RangeModifier" \
		-under $dStreamData21 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "$acPwCnt" \
		-Data {00:00:00:20:00:01} \
		-EnableStream "TRUE" \
		-Offset "2" \
		-OffsetReference {eth1.dstMac} \
		-Name {MAC Modifier} ]
	
	set RangeModifier(11) [stc::create "RangeModifier" \
		-under $dStreamData21 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "$acPwCnt" \
		-Data {00:00:00:10:00:01} \
		-EnableStream "TRUE" \
		-Offset "2" \
		-OffsetReference {eth1.srcMac} \
		-Name {MAC Modifier} ]
	
	set RangeModifier(12) [stc::create "RangeModifier" \
		-under $dStreamData21 \
		-Mask {4095} \
		-StepValue {1} \
		-RecycleCount "$acPwCnt" \
		-Data {1000} \
		-EnableStream "TRUE" \
		-OffsetReference {eth1.vlans.Vlan.id} \
		-Name {Modifier} ]

	set dStreamData31 [stc::create "StreamBlock" \
	-under $hGPNPort3 \
	-EqualRxPortDistribution "FALSE" \
	-FrameLengthMode "RANDOM" \
	-MinFrameLength "64" \
	-MaxFrameLength "1518" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:00:00:40:00:01</dstMac><srcMac>00:00:00:30:00:01</srcMac><vlans name="anon_12434"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} ]

	set RangeModifier(13) [stc::create "RangeModifier" \
		-under $dStreamData31 \
		-Mask {4095} \
		-StepValue {1} \
		-RecycleCount "$acPwCnt" \
		-Data {1000} \
		-EnableStream "TRUE" \
		-OffsetReference {eth1.vlans.Vlan.id} \
		-Name {Modifier} ]
	
	set RangeModifier(14) [stc::create "RangeModifier" \
		-under $dStreamData31 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "$acPwCnt" \
		-Data {00:00:00:40:00:01} \
		-EnableStream "TRUE" \
		-Offset "2" \
		-OffsetReference {eth1.dstMac} \
		-Name {MAC Modifier} ]
	
	set RangeModifier(15) [stc::create "RangeModifier" \
		-under $dStreamData31 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "$acPwCnt" \
		-Data {00:00:00:30:00:01} \
		-EnableStream "TRUE" \
		-Offset "2" \
		-OffsetReference {eth1.srcMac} \
		-Name {MAC Modifier} ]
	set dStreamData41 [stc::create "StreamBlock" \
	-under $hGPNPort4 \
	-EqualRxPortDistribution "FALSE" \
	-FrameLengthMode "RANDOM" \
	-MinFrameLength "64" \
	-MaxFrameLength "1518" \
	-FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><dstMac>00:00:00:60:00:01</dstMac><srcMac>00:00:00:50:00:01</srcMac><vlans name="anon_12430"><Vlan name="Vlan"><pri>000</pri><id>1000</id></Vlan></vlans></pdu></pdus></config></frame>} ]

	set RangeModifier(16) [stc::create "RangeModifier" \
		-under $dStreamData41 \
		-Mask {4095} \
		-StepValue {1} \
		-RecycleCount "$acPwCnt" \
		-Data {1000} \
		-EnableStream "TRUE" \
		-OffsetReference {eth1.vlans.Vlan.id} \
		-Name {Modifier} ]
	
	set RangeModifier(17) [stc::create "RangeModifier" \
		-under $dStreamData41 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "$acPwCnt" \
		-Data {00:00:00:60:00:01} \
		-EnableStream "TRUE" \
		-Offset "2" \
		-OffsetReference {eth1.dstMac} \
		-Name {MAC Modifier} ]
	
	set RangeModifier(18) [stc::create "RangeModifier" \
		-under $dStreamData41 \
		-Mask {00:00:FF:FF:FF:FF} \
		-StepValue {00:00:00:00:00:01} \
		-RecycleCount "$acPwCnt" \
		-Data {00:00:00:50:00:01} \
		-EnableStream "TRUE" \
		-Offset "2" \
		-OffsetReference {eth1.srcMac} \
		-Name {MAC Modifier} ]

    ###������֪������Э�鱨��
    set rebootSlotlist2 [gwd::GWpulic_getWorkCardList $GPNPort5]
    set slottype [gwd::GWpublic_getSlotInfo_reconsitution $telnet1 $matchType1 $Gpn_type1 $fd_log $rebootSlotlist2 slotInfo]
    if {[string match $slottype "GFT-2XG"]} {
	    set loadcnt 700
    } else {
	    set loadcnt 350
    }
    
    
    set loadcntknow [format "%.3f" [expr 700.0/3]]
    foreach hStream "$dStreamData16" {
		stc::perform streamBlockActivate -streamBlockList $hStream -activate "TRUE"
		stc::config [stc::get $hStream -AffiliationStreamBlockLoadProfile-targets] -load $loadcnt -LoadUnit MEGABITS_PER_SECOND
	   }
	foreach hStream "$dStreamData12 $dStreamData12 $dStreamData13 $dStreamData14 $dStreamData21 $dStreamData31 $dStreamData41" {
		stc::perform streamBlockActivate -streamBlockList $hStream -activate "FALSE"
		stc::config [stc::get $hStream -AffiliationStreamBlockLoadProfile-targets] -load $loadcntknow -LoadUnit MEGABITS_PER_SECOND
	   }
    
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
	 -FrameConfig {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:01" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><vlans name="anon_32777"><Vlan name="Vlan"><id filterMinValue="999" filterMaxValue="4000">4095</id></Vlan></vlans></pdu></pdus></config></frame>} ]

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
    TxAndRx_Info $hProject $hGPNPort3 infoObj3
    TxAndRx_Info $hProject $hGPNPort4 infoObj4

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
    set totalPage3 [stc::get $infoObj3 -TotalPageCount]
    set totalPage4 [stc::get $infoObj4 -TotalPageCount]
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
		 set hGPNPortCapList "$hGPNPort1Cap $hGPNPort2Cap $hGPNPort3Cap $hGPNPort4Cap"
	 }
	stc::apply
    incr tcId 
    gwd::GWpublic_saveTCCfg 1 $fd_log "GPN_LSP_013_4_$tcId.xml" [pwd]/Untitled
   #������������
   #���ڵ��������豸�õ��ı���------
	set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
	set lMatchType "$matchType1 $matchType2 $matchType3 $matchType4"
	set lDutType "$Gpn_type1 $Gpn_type2 $Gpn_type3 $Gpn_type4"
	set lIp "$gpnIp1 $gpnIp2 $gpnIp3 $gpnIp4"
	#------���ڵ��������豸�õ��ı���
   ###���ö˿�1
   set lport1 "$hGPNPort1 $hGPNPort2 $hGPNPort3 $hGPNPort4"
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
   gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ���ض���vsi�����ã����Կ�ʼ=====\n"
   set flag1_Case3 0;set flag2_Case3 0;set flag3_Case3 0;set flag4_Case3 0;set flag5_Case3 0;set flag6_Case3 0;set flag7_Case3 0;set flag8_Case3 0;set flag9_Case3 0;set flag10_Case3 0

	set vid1 10
	set vid2 20
	set vid3 30
	set vid4 40
	set ip12 11.1.1.1
	set ip21 11.1.1.2
	set ip23 12.1.1.1
	set ip32 12.1.1.2
	set ip34 13.1.1.1
	set ip43 13.1.1.2
	set ip41 14.1.1.1
	set ip14 14.1.1.2
	if {[string match "L2" $Worklevel]} {
		set interfaceA v$vid1
		set interfaceB v$vid1
		set interfaceC v$vid2
		set interfaceD v$vid2
		set interfaceE v$vid3
		set interfaceF v$vid3
		set interfaceG v$vid4
		set interfaceH v$vid4 
		set interface1 v10
		set interface2 v10
		lappend flag1_Case3 [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "enable"]
		lappend flag1_Case3 [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "enable"]
		lappend flag1_Case3 [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort6 "enable"]
		lappend flag1_Case3 [gwd::GWpublic_CfgVlanStack $telnet2 $matchType2 $Gpn_type2 $fileId $GPNPort7 "enable"]
		lappend flag1_Case3 [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort8 "enable"]
		lappend flag1_Case3 [gwd::GWpublic_CfgVlanStack $telnet3 $matchType3 $Gpn_type3 $fileId $GPNPort9 "enable"]
		lappend flag1_Case3 [gwd::GWpublic_CfgVlanStack $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort10 "enable"]
		lappend flag1_Case3 [gwd::GWpublic_CfgVlanStack $telnet4 $matchType4 $Gpn_type4 $fileId $GPNPort11 "enable"]
	} else {
		set interfaceA $GPNPort5.$vid1
		set interfaceB $GPNPort6.$vid1
		set interfaceC $GPNPort7.$vid2
		set interfaceD $GPNPort8.$vid2
		set interfaceE $GPNPort9.$vid3
		set interfaceF $GPNPort10.$vid3
		set interfaceG $GPNPort11.$vid4
		set interfaceH $GPNPort12.$vid4
		set interface1 $GPNPort5.$vid1
		set interface2 $GPNPort6.$vid1
	}
	###����VLANIF�ӿ�
	lappend flag1_Case3 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceA $ip12 $GPNPort5 $matchType1 $Gpn_type1 $telnet1]
	lappend flag1_Case3 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceB $ip21 $GPNPort6 $matchType2 $Gpn_type2 $telnet2]
	lappend flag1_Case3 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceC $ip23 $GPNPort7 $matchType2 $Gpn_type2 $telnet2]
	lappend flag1_Case3 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceD $ip32 $GPNPort8 $matchType3 $Gpn_type3 $telnet3]
	lappend flag1_Case3 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceE $ip34 $GPNPort9 $matchType3 $Gpn_type3 $telnet3]
	lappend flag1_Case3 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceF $ip43 $GPNPort10 $matchType4 $Gpn_type4 $telnet4]
	lappend flag1_Case3 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceH $ip41 $GPNPort11 $matchType4 $Gpn_type4 $telnet4]
	lappend flag1_Case3 [PTN_NNI_AddInterIp $fileId $Worklevel $interfaceG $ip14 $GPNPort12 $matchType1 $Gpn_type1 $telnet1]

	####����NE1
	lappend flag1_Case3 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interfaceA $ip21 "20" "20" "normal" "2"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612]
	lappend flag1_Case3 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $interfaceH $ip41 "24" "24" "normal" "4"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $address614]
	lappend flag1_Case3 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $interfaceA $ip21 "23" "23" "normal" "3"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $address613]
	lappend flag1_Case3 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"]
	lappend flag1_Case3 [gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" "enable"]
	lappend flag1_Case3 [gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" "enable"]
	lappend flag1_Case3 [gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" "enable"]
	####����NE2
	lappend flag1_Case3 [gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interfaceB $ip12 "20" "20" "normal" "1"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621]
	lappend flag1_Case3 [gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $interfaceC $ip32 "26" "26" "normal" "3"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $address623]
	lappend flag1_Case3 [gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $interfaceC $ip32 "27" "27" "normal" "4"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $address624]
	lappend flag1_Case3 [gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"]
	lappend flag1_Case3 [gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interfaceC $ip32 "23" "25" "0" 23 "normal"]
	lappend flag1_Case3 [gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interfaceB $ip12 "25" "23" "0" 21 "normal"]
	lappend flag1_Case3 [gwd::GWpublic_addLspStat $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" "enable"]
	lappend flag1_Case3 [gwd::GWpublic_addLspStat $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" "enable"]
	lappend flag1_Case3 [gwd::GWpublic_addLspStat $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" "enable"]
	####����NE3
	lappend flag1_Case3 [gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $interfaceD $ip23 "26" "26" "normal" "2"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $address632]
	lappend flag1_Case3 [gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34" $interfaceE $ip43 "28" "28" "normal" "4"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34" $address634]
	lappend flag1_Case3 [gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $interfaceD $ip23 "25" "25" "normal" "1"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $address631]
	lappend flag1_Case3 [gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"]
	lappend flag1_Case3 [gwd::GWpublic_addLspStat $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" "enable"]
	lappend flag1_Case3 [gwd::GWpublic_addLspStat $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34" "enable"]
	lappend flag1_Case3 [gwd::GWpublic_addLspStat $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" "enable"]
	#####����NE4
	lappend flag1_Case3 [gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $interfaceG $ip14 "24" "24" "normal" "1"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $address641]
	lappend flag1_Case3 [gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43" $interfaceF $ip34 "28" "28" "normal" "3"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43" $address643]
	lappend flag1_Case3 [gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42" $interfaceF $ip34 "29" "29" "normal" "2"]
	lappend flag1_Case3 [gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42" $address642]
	lappend flag1_Case3 [gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42"]
	lappend flag1_Case3 [gwd::GWpublic_addLspStat $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" "enable"]
	lappend flag1_Case3 [gwd::GWpublic_addLspStat $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43" "enable"]
	lappend flag1_Case3 [gwd::GWpublic_addLspStat $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42" "enable"]
	for {set id 1} {$id <= $acPwCnt} {incr id} {
		foreach telnet $lSpawn_id matchType $lMatchType Gpn_type $lDutType {
			gwd::GWVpls_AddInfo $telnet $matchType $Gpn_type $fileId "vpls$id" $id "etree" "flood" "false" "false" "false" "true" "2000" "" "tagged"
		}
		set pw12 "pw12_[expr $id]"
		set pw13 "pw13_[expr $id]"
		set pw14 "pw14_[expr $id]"
		set pw21 "pw21_[expr $id]"
		set pw23 "pw23_[expr $id]"
		set pw24 "pw24_[expr $id]"
		set pw31 "pw31_[expr $id]"
		set pw32 "pw32_[expr $id]"
		set pw34 "pw34_[expr $id]"
		set pw41 "pw41_[expr $id]"
		set pw42 "pw42_[expr $id]"
		set pw43 "pw43_[expr $id]"

		set local_label_1 "[expr 100+$id]"
		set remote_label_1 "[expr 100+$id]"
		set local_label_2 "[expr 2100+$id]"
		set remote_label_2 "[expr 2100+$id]"
		set local_label_3 "[expr 4100+$id]"
		set remote_label_3 "[expr 4100+$id]"
		set local_label_4 "[expr 6100+$id]"
		set remote_label_4 "[expr 6100+$id]"
		set acVlan [expr 999+$id]
		###����pw
		lappend flag1_Case3 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "$pw12" "vpls" "vpls$id" "peer" $address612 "$local_label_1" "$remote_label_1" "" "add" "none" 1 0 "0x8100" "0x8100" "2"]
		lappend flag1_Case3 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "$pw12" "enable"]
		# lappend flag1_Case3 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "$pw13" "vpls" "vpls$id" "peer" $address613 "$local_label_2" "$remote_label_2" "" "add" "none" 1 0 "0x8100" "0x8100" "3"]
		# lappend flag1_Case3 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "$pw13" "enable"]
		# lappend flag1_Case3 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "$pw14" "vpls" "vpls$id" "peer" $address614 "$local_label_3" "$remote_label_3" "" "add" "none" 1 0 "0x8100" "0x8100" "4"]
		# lappend flag1_Case3 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "$pw14" "enable"]

		lappend flag1_Case3 [gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "$pw21" "vpls" "vpls$id" "peer" $address621 "$remote_label_1" "$local_label_1" "" "add" "root" 1 0 "0x8100" "0x8100" "1"]
		lappend flag1_Case3 [gwd::GWpublic_addPwStatEn $telnet2 $matchType2 $Gpn_type2 $fileId "$pw21" "enable"]
		# lappend flag1_Case3 [gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "$pw23" "vpls" "vpls$id" "peer" $address623 "$local_label_3" "$remote_label_3" "" "add" "none" 1 0 "0x8100" "0x8100" "3"]
		# lappend flag1_Case3 [gwd::GWpublic_addPwStatEn $telnet2 $matchType2 $Gpn_type2 $fileId "$pw23" "enable"]
		# lappend flag1_Case3 [gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "$pw24" "vpls" "vpls$id" "peer" $address624 "$local_label_2" "$remote_label_2" "" "add" "none" 1 0 "0x8100" "0x8100" "4"]
		# lappend flag1_Case3 [gwd::GWpublic_addPwStatEn $telnet2 $matchType2 $Gpn_type2 $fileId "$pw24" "enable"]

		lappend flag1_Case3 [gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "$pw31" "vpls" "vpls$id" "peer" $address631 "$remote_label_2" "$local_label_2" "" "add" "root" 1 0 "0x8100" "0x8100" "1"]
		lappend flag1_Case3 [gwd::GWpublic_addPwStatEn $telnet3 $matchType3 $Gpn_type3 $fileId "$pw31" "enable"]
		# lappend flag1_Case3 [gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "$pw32" "vpls" "vpls$id" "peer" $address632 "$remote_label_3" "$local_label_3" "" "add" "none" 1 0 "0x8100" "0x8100" "2"]
		# lappend flag1_Case3 [gwd::GWpublic_addPwStatEn $telnet3 $matchType3 $Gpn_type3 $fileId "$pw32" "enable"]
		# lappend flag1_Case3 [gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "$pw34" "vpls" "vpls$id" "peer" $address634 "$local_label_1" "$remote_label_1" "" "add" "none" 1 0 "0x8100" "0x8100" "4"]
		# lappend flag1_Case3 [gwd::GWpublic_addPwStatEn $telnet3 $matchType3 $Gpn_type3 $fileId "$pw34" "enable"]

		lappend flag1_Case3 [gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "$pw41" "vpls" "vpls$id" "peer" $address641 "$remote_label_3" "$local_label_3" "" "add" "root" 1 0 "0x8100" "0x8100" "1"]
		# lappend flag1_Case3 [gwd::GWpublic_addPwStatEn $telnet4 $matchType4 $Gpn_type4 $fileId "$pw41" "enable"]
		# lappend flag1_Case3 [gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "$pw42" "vpls" "vpls$id" "peer" $address642 "$remote_label_2" "$local_label_2" "" "add" "none" 1 0 "0x8100" "0x8100" "2"]
		# lappend flag1_Case3 [gwd::GWpublic_addPwStatEn $telnet4 $matchType4 $Gpn_type4 $fileId "$pw42" "enable"]
		# lappend flag1_Case3 [gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "$pw43" "vpls" "vpls$id" "peer" $address643 "$remote_label_1" "$local_label_1" "" "add" "none" 1 0 "0x8100" "0x8100" "3"]
		# lappend flag1_Case3 [gwd::GWpublic_addPwStatEn $telnet4 $matchType4 $Gpn_type4 $fileId "$pw43" "enable"]
		
		###����ac
		lappend flag1_Case3 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel $acVlan $GPNTestEth1]
		lappend flag1_Case3 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel $acVlan $GPNTestEth1]
		lappend flag1_Case3 [PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $acVlan $GPNTestEth3]
		lappend flag1_Case3 [PTN_UNI_AddInter $telnet4 $matchType4 $Gpn_type4 $fileId $Worklevel $acVlan $GPNTestEth4]
		lappend flag1_Case3 [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac$acVlan" "vpls$id" "ethernet" $GPNTestEth1 "$acVlan" "0" "none" "delete" "$acVlan" "0" "0" "0x8100" ""]	
		lappend flag1_Case3 [gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac$acVlan" "vpls$id" "ethernet" $GPNTestEth2 "$acVlan" "0" "leaf" "modify" "$acVlan" "0" "0" "0x8100" ""]
		lappend flag1_Case3 [gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac$acVlan" "vpls$id" "ethernet" $GPNTestEth3 "$acVlan" "0" "leaf" "modify" "$acVlan" "0" "0" "0x8100" ""]	
		lappend flag1_Case3 [gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac$acVlan" "vpls$id" "ethernet" $GPNTestEth4 "$acVlan" "0" "leaf" "modify" "$acVlan" "0" "0" "0x8100" ""]

		lappend flag1_Case3 [gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac$acVlan" "enable"]
		lappend flag1_Case3 [gwd::GWpublic_addAcStatEn $telnet2 $matchType2 $Gpn_type2 $fileId "ac$acVlan" "enable"]
		lappend flag1_Case3 [gwd::GWpublic_addAcStatEn $telnet3 $matchType3 $Gpn_type3 $fileId "ac$acVlan" "enable"]
		lappend flag1_Case3 [gwd::GWpublic_addAcStatEn $telnet4 $matchType4 $Gpn_type4 $fileId "ac$acVlan" "enable"]
	}
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GW_AddUploadFile $telnet1 $matchType1 $Gpn_type1 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"config" "GPN_PTN_013_4_fullvsiNE1.txt" "" "120"
	gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
	gwd::GW_AddUploadFile $telnet2 $matchType2 $Gpn_type2 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"config" "GPN_PTN_013_4_fullvsiNE2.txt" "" "120"
	gwd::GWpublic_SaveCfg $telnet3 $matchType3 $Gpn_type3 $fileId
	gwd::GW_AddUploadFile $telnet3 $matchType3 $Gpn_type3 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"config" "GPN_PTN_013_4_fullvsiNE3.txt" "" "120"
	gwd::GWpublic_SaveCfg $telnet4 $matchType4 $Gpn_type4 $fileId
	gwd::GW_AddUploadFile $telnet4 $matchType4 $Gpn_type4 $fileId [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"config" "GPN_PTN_013_4_fullvsiNE4.txt" "" "120"
    if {"1" in $flag1_Case3} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC1�����ۣ�ϵͳ�г��ض���vsi�����ã�ʧ��" $fileId 
	} else { 
		gwd::GWpublic_print "OK" "FC1�����ۣ�ϵͳ�г��ض���vsi�����ã��ɹ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ���ض���vsi�����ã����Խ���=====\n"
    puts $fileId "======================================================================================\n"
    gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ��NE1��NE2������֤ҵ�񶪰���������Կ�ʼ=====\n"

	stc::apply
    gwd::Start_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
    lappend flag2_Case3 [MPLS_ClassStatisticsAna4 "1" $infoObj1 $infoObj2 $infoObj3 $infoObj4 "" "" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" valuedrop1 valuedrop2 valuedrop3 valuedrop4 valuecnt1 valuecnt2 valuecnt3 valuecnt4 "GPN_PTN_013_4_C2_2"]
	   if {"1" in $flag2_Case3} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC2�����ۣ�ϵͳ�г���ָ����vsiʱ����ҵ������֤��ҵ�񶪰�" $fileId 
	} else { 
		gwd::GWpublic_print "OK" "FC2�����ۣ�ϵͳ�г���ָ����vsiʱ����ҵ������֤��ҵ�񲻶���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ��NE1��NE2������֤ҵ�񶪰���������Խ���=====\n"
    puts $fileId "======================================================================================\n"
    gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)����shutdown/undo shut NE1�忨��NNI�ں�UNI�ڣ�����ҵ��ָ���ϵͳ�ڴ�   ���Կ�ʼ=====\n"	
	foreach eth "$GPNPort5 $GPNTestEth1" {
		lappend flag3_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource1_1]
		for {set j 1} {$j<=$cnt} {incr j} {
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
		after $WaiteTime
			after 120000
			stc::perform ResultsClearAll -PortList $lport1
		    lappend flag3_Case3 [MPLS_ClassStatisticsAna4 "1" $infoObj1 $infoObj2 $infoObj3 $infoObj4 "" "" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" valuedrop1 valuedrop2 valuedrop3 valuedrop4 valuecnt1 valuecnt2 valuecnt3 valuecnt4 "GPN_PTN_013_4_C2_$j"]
			lappend flag3_Case3 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
			lappend flag3_Case3 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
			lappend flag3_Case3 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
			lappend flag3_Case3 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
			lappend flag3_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
			lappend flag3_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
			lappend flag3_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
			lappend flag3_Case3 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
		    lappend flag3_Case3 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
			lappend flag3_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource1_2]
			send_log "\n shutdwnǰresource:$resource1_1"
			send_log "\n ����shutdown/undoshutdown��resource:$resource1_2"
			lappend flag3_Case3 [CheckSystemResource $fileId "��$j\��shutdown/undo shutdown NE2($gpnIp2)�忨��NNI��UNI��" $resource1_1 $resource1_2]
		    
			}
	    }
	puts $fileId ""
	if {"1" in $flag3_Case3} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC3�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)����shutdown/undo shut NE1�忨��NNI�ں�UNI�ڣ�ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)����shutdown/undo shut NE1�忨��NNI�ں�UNI�ڣ�ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)����shutdown/undo shut NE1�忨��NNI�ں�UNI�ڣ�����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	foreach slot $rebootSlotlist2 {
		lappend flag4_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource2_1]
		set testFlag 0
		for {set j 1} {$j<=$cnt} {incr j} {
			if {![gwd::GWCard_AddReboot $telnet1 $matchType1 $Gpn_type1 $fileId $slot]} {
			after $rebootBoardTime
				after 120000
			if {[string match $mslot1 $slot]} {
			      set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			      set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			}
		lappend flag4_Case3 [MPLS_ClassStatisticsAna4 "1" $infoObj1 $infoObj2 $infoObj3 $infoObj4 "" "" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" valuedrop1 valuedrop2 valuedrop3 valuedrop4 valuecnt1 valuecnt2 valuecnt3 valuecnt4 "GPN_PTN_013_4_C3_$j"]

			} else {
		set testFlag 1
		gwd::GWpublic_print "OK" " NE1($gpnIp1)$slot\��λ�忨��֧�ְ忨������������������" $fileId
		break
			}
			if {$testFlag == 0} {
				lappend flag4_Case3 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
				lappend flag4_Case3 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
				lappend flag4_Case3 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
				lappend flag4_Case3 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
				lappend flag4_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
				lappend flag4_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
				lappend flag4_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
				lappend flag4_Case3 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
			    lappend flag4_Case3 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
			lappend flag4_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource2_2]
			send_log "\n ����NNI�忨ǰresource:$resource2_1"
			send_log "\n ����NNI�忨��resource:$resource2_2"
			lappend flag4_Case3 [CheckSystemResource $fileId "��$j\������NE1($gpnIp1)$slot\��λ�忨" $resource2_1 $resource2_2]
		}
		}  
	}
	puts $fileId ""
	if {"1" in $flag4_Case3} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC4�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)��������NNI�����ڰ忨��ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)��������NNI�����ڰ忨��ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)�������н����̵ĵ����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	set testFlag 0
	for {set j 1} {$j<=$cntdh} {incr j} {
		lappend flag5_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource3_1]
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
		       after [expr 2*$rebootTime]
			after 120000
		       set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	    set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	    lappend flag5_Case3 [MPLS_ClassStatisticsAna4 "1" $infoObj1 $infoObj2 $infoObj3 $infoObj4 "" "" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" valuedrop1 valuedrop2 valuedrop3 valuedrop4 valuecnt1 valuecnt2 valuecnt3 valuecnt4 "GPN_PTN_013_4_C5_$j"]
		} else {
	       set testFlag 1
	       gwd::GWpublic_print "OK" " NE1($gpnIp1)ֻ��һ�������̣���������" $fileId
	       break
		}
		if {$testFlag == 0} {
			lappend flag5_Case3 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
			lappend flag5_Case3 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
			lappend flag5_Case3 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
			lappend flag5_Case3 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
			lappend flag5_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
			lappend flag5_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
			lappend flag5_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
			lappend flag5_Case3 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
		    lappend flag5_Case3 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
		lappend flag5_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource3_2]
		send_log "\n �����̵���ǰresource:$resource3_1"
		send_log "\n �����̵�����resource:$resource3_2"
		lappend flag5_Case3 [CheckSystemResource $fileId "��$j\�ε���NE1($gpnIp1)�Ľ�����" $resource3_1 $resource3_2]
	       }
	}
	puts $fileId ""
	if {"1" in $flag5_Case3} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC5�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)�������н����̵ĵ�����ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)�������н����̵ĵ�����ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)�������н����̵ĵ����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)��������NMS��������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	set testFlag 0
	for {set j 1} {$j<=$cntdh} {incr j} {
		lappend flag6_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource4_1]
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
		       after [expr 2*$rebootTime]
			after 120000
		       set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	    set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	    lappend flag6_Case3 [MPLS_ClassStatisticsAna4 "1" $infoObj1 $infoObj2 $infoObj3 $infoObj4 "" "" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" valuedrop1 valuedrop2 valuedrop3 valuedrop4 valuecnt1 valuecnt2 valuecnt3 valuecnt4 "GPN_PTN_013_4_C6_$j"]
		} else {
	       set testFlag 1
	       gwd::GWpublic_print "OK" " NE1($gpnIp1)ֻ��һ�������̣���������" $fileId
	       break
		}
		if {$testFlag == 0} {
			lappend flag6_Case3 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
			lappend flag6_Case3 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
			lappend flag6_Case3 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
			lappend flag6_Case3 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
			lappend flag6_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
			lappend flag6_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
			lappend flag6_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
			lappend flag6_Case3 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
		    lappend flag6_Case3 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
		lappend flag6_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource4_2]
		send_log "\n NMS��������ǰresource:$resource4_1"
		send_log "\n NMS����������resource:$resource4_2"
		lappend flag6_Case3 [CheckSystemResource $fileId "��$j\�ε���NE1($gpnIp1)��������" $resource4_1 $resource4_2]
	       }
	}
	puts $fileId ""
	if {"1" in $flag6_Case3} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC6�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)��������NMS������������ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)��������NMS������������ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)��������NMS�����������󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)�������б����豸�����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	set testFlag 0
	for {set j 1} {$j<=$cnt} {incr j} {
		lappend flag7_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource5_1]
		lappend flag7_Case3 [gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId]
		after 60000
		lappend flag7_Case3 [gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId]
		after [expr 2*$rebootTime]
	       set telnet2 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	lappend flag7_Case3 [MPLS_ClassStatisticsAna4 "1" $infoObj1 $infoObj2 $infoObj3 $infoObj4 "" "" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" valuedrop1 valuedrop2 valuedrop3 valuedrop4 valuecnt1 valuecnt2 valuecnt3 valuecnt4 "GPN_PTN_013_4_C7_$j"]
	    lappend flag7_Case3 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
		lappend flag7_Case3 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
		lappend flag7_Case3 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
		lappend flag7_Case3 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
		lappend flag7_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
		lappend flag7_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
		lappend flag7_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
		lappend flag7_Case3 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	    lappend flag7_Case3 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
	    lappend flag7_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource5_2]
	    send_log "\n ��������ǰresource:$resource5_1"
	    send_log "\n ����������resource:$resource5_2"
	    lappend flag7_Case3 [CheckSystemResource $fileId "��$j\�α�������NE1($gpnIp1)" $resource5_1 $resource5_2]
	}
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_009" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId ""
	if {"1" in $flag7_Case3} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC7�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)�������б����豸������ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)�������б����豸������ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)�������б����豸�����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ������ɾ��10��pw��ac�����ã�����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	for {set j 1} {$j<=$cnt} {incr j} {
		lappend flag8_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource6_1]
		
		if {[expr $acPwCnt]<11} {
			for {set k 1} {$k<[expr $acPwCnt]} {incr k} {
			lappend flag8_Case3 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac[expr 999+$k]"]
			lappend flag8_Case3 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12_$k"]
			lappend flag8_Case3 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13_$k"]
			lappend flag8_Case3 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14_$k"]			
			lappend flag8_Case3 [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls[expr $k]"]
			}
		} else {
			for {set k 1} {$k<11} {incr k} {
			lappend flag8_Case3 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac[expr 999+$k]"]
			lappend flag8_Case3 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12_$k"]
			lappend flag8_Case3 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13_$k"]
			lappend flag8_Case3 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14_$k"]
			lappend flag8_Case3 [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls[expr $k]"]
			}
		}
		
		for {set k 1} {$k<11} {incr k} {
			lappend flag8_Case3 [gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls$k" $k "etree" "flood" "false" "false" "false" "true" "2000" "" ""]
			lappend flag8_Case3 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12_$k" "vpls" "vpls$k" "peer" $address612 "[expr 100+$k]" "[expr 100+$k]" "" "add" "leaf" 1 0 "0x8100" "0x8100" "2"]
			lappend flag8_Case3 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw12_$k" "enable"]
			lappend flag8_Case3 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13_$k" "vpls" "vpls$k" "peer" $address612 "[expr 2100+$k]" "[expr 2100+$k]" "" "add" "leaf" 1 0 "0x8100" "0x8100" "3"]
			lappend flag8_Case3 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw13_$k" "enable"]
			lappend flag8_Case3 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14_$k" "vpls" "vpls$k" "peer" $address612 "[expr 4100+$k]" "[expr 4100+$k]" "" "add" "leaf" 1 0 "0x8100" "0x8100" "4"]
			lappend flag8_Case3 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw14_$k" "enable"]
			lappend flag8_Case3 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "[expr 999+$k]" $GPNTestEth1]
			lappend flag8_Case3 [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac[expr 999+$k]" "vpls1" "ethernet" $GPNTestEth1 "[expr 999+$k]" "0" "root" "modify" "1" "0" "0" "0x8100" ""]
			lappend flag8_Case3 [gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac[expr 999+$k]" "enable"]
			lappend flag8_Case3 [gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac[expr 999+$k]" "enable"]
			
		}
	    lappend flag8_Case3 [MPLS_ClassStatisticsAna4 "1" $infoObj1 $infoObj2 $infoObj3 $infoObj4 "" "" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" valuedrop1 valuedrop2 valuedrop3 valuedrop4 valuecnt1 valuecnt2 valuecnt3 valuecnt4 "GPN_PTN_013_4_C8_$k"]
	    lappend flag8_Case3 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
		lappend flag8_Case3 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
		lappend flag8_Case3 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
		lappend flag8_Case3 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
		lappend flag8_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
		lappend flag8_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
		lappend flag8_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
		lappend flag8_Case3 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	    lappend flag8_Case3 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
	    lappend flag8_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource6_2]
	    send_log "\n ɾ��ac��pwǰresource:$resource6_1"
	    send_log "\n ɾ�����ָ�ac��pw��resource:$resource6_2"
	    lappend flag8_Case3 [CheckSystemResource $fileId "��$j\�α�������NE1($gpnIp1)" $resource6_1 $resource6_2]
	}
	
	puts $fileId ""
	if {"1" in $flag8_Case3} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC8�����ۣ�ϵͳ�г���ָ����vsiʱ������ɾ��NE1($gpnIp1)��pw��ac�����ã�ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8�����ۣ�ϵͳ�г���ָ����vsiʱ������ɾ��NE1($gpnIp1)��pw��ac�����ã�ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ������ɾ��10��pw��ac�����ã�����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ������NE1��NE2�����ã��������������NE1($gpnIp1)��NE2($gpnIp2)����VSI��������ò������豸����֤ҵ��  ���Կ�ʼ=====\n"
	stc::perform ResultsClearAll -PortList $lport1
	lappend flag9_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource7_1]

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
	lappend flag9_Case3 [gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	lappend flag9_Case3 [gwd::GWpublic_showMplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
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
		"GPN_PTN_013_4_fullpwNE1.txt" ""
	gwd::GWmanage_ftpDownload $telnet2 $matchType2 $Gpn_type2 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"GPN_PTN_013_4_fullpwNE2.txt" ""
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
	after [expr 2*$rebootTime]
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
    set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
	lappend flag9_Case3 [MPLS_ClassStatisticsAna4 "1" $infoObj1 $infoObj2 $infoObj3 $infoObj4 "" "" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" "1000" "00:00:00:00:00:01" valuedrop1 valuedrop2 valuedrop3 valuedrop4 valuecnt1 valuecnt2 valuecnt3 valuecnt4 "GPN_PTN_013_4_C9"]
    lappend flag9_Case3 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
	lappend flag9_Case3 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
	lappend flag9_Case3 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
	lappend flag9_Case3 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
	lappend flag9_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
	lappend flag9_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
	lappend flag9_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "pw12_1" GPNPwStat1]
	lappend flag9_Case3 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
	lappend flag9_Case3 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
	lappend flag9_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource7_2]
	send_log "\n ������ò��ָ�����ǰresource:$resource7_1"
	send_log "\n ������ò��ָ����ú�resource:$resource7_2"
	lappend flag9_Case3 [CheckSystemResource $fileId "��������NE1($gpnIp1)" $resource7_1 $resource7_2]
	if {"1" in $flag9_Case3} {
		set flagCase1 2
		gwd::GWpublic_print "NOK" "FC9�����ۣ�ϵͳ�г���ָ����vsiʱ������NE1��NE2�����ã�������ú�ָ����ã�ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC9�����ۣ�ϵͳ�г���ָ����vsiʱ������NE1��NE2�����ã�������ú�ָ����ã�ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	gwd::Stop_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ϵͳ�г���ָ����vsiʱ������NE1��NE2�����ã��������������NE1($gpnIp1)��NE2($gpnIp2)����VSI��������ò������豸����֤ҵ��  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���ܳ��ڣ�����ҵ��  ���Կ�ʼ=====\n"
	foreach hStream "$dStreamData12 $dStreamData12 $dStreamData13 $dStreamData14 $dStreamData21 $dStreamData31 $dStreamData41" {
		stc::perform streamBlockActivate -streamBlockList $hStream -activate "TRUE"
		stc::config [stc::get $hStream -AffiliationStreamBlockLoadProfile-targets] -load $loadcntknow -LoadUnit MEGABITS_PER_SECOND
	   }
	stc::perform ResultsClearAll -PortList $lport1
	lappend flag10_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource8_1]
	if {[string match -nocase $longTermIf "true"]} {
		lappend flag10_Case3 [MPLS_ClassStatisticsPort4 $fileId $hGPNPort1Ana $hGPNPort1Gen $hGPNPort2Ana $hGPNPort2Gen $hGPNPort3Ana $hGPNPort3Gen $hGPNPort4Ana $hGPNPort4Gen $lTermTime "2"]
		    lappend flag10_Case3 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "" resultpw1]
			lappend flag10_Case3 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId ""]
			lappend flag10_Case3 [gwd::GWpublic_getPwInfo $telnet2 $matchType2 $Gpn_type2 $fileId "" resultpw2]
			lappend flag10_Case3 [gwd::GWpublic_getAcInfo $telnet2 $matchType2 $Gpn_type2 $fileId ""]
			lappend flag10_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp tunnel" "lsp12" GPNLsp1Stat1]
			lappend flag10_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "ac" "ac1000" GPNAcStat1]
			lappend flag10_Case3 [gwd::GWpublic_getMplsStat $telnet1 $matchType1 $Gpn_type1 $fileId "pw" "$pw12" GPNPwStat1]
			lappend flag10_Case3 [gwd::GW_GetTaskInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]
			lappend flag10_Case3 [gwd::GW_GetTaskInfo $telnet2 $matchType2 $Gpn_type2 $fileId result2]
			lappend flag10_Case3 [gwd::GWmanage_GetSystemResource $telnet1 $matchType1 $Gpn_type1 $fileId "usage" resource8_2]
			send_log "\n ���ܳ���ǰresource:$resource8_1"
			send_log "\n ���ܳ��ں�resource:$resource8_2"
			lappend flag10_Case3 [CheckSystemResource $fileId "���ܳ���ǰ��" $resource8_1 $resource8_2]
		} else {
	       gwd::GWpublic_print "OK" "�˴β��Բ����г����Բ��ԣ���������" $fileId
	       
		}
	
	if {"1" in $flag10_Case3} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FC10�����ۣ����ܳ��ڣ�ҵ���쳣" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC10�����ۣ����ܳ��ڣ�ҵ�񲻶�����ϵͳ��Դ���������Χ��" $fileId
	}
	gwd::Stop_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====���ܳ��ڣ�����ҵ��  ���Խ���=====\n"
	puts $fileId "======================================================================================\n"
	puts $fileId ""
	puts $fileId ""
	if {$flagCase3 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 3���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 3���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 3 ϵͳ�г���VSI����������  ���Խ���\n"


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
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_013_4"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_013_4"
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_013_4����Ŀ�ģ�ETREE�������ȶ��Բ���\n"


	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase3==1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_013_4���Խ��" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3���Խ��" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FC1 == [expr {($flag1_Case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)VSIϵͳ�г��ض���vsi������,[expr {($flag1_case3 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FC2 == [expr {($flag2_Case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�ϵͳ�г���ָ����vsiʱ,��ҵ������֤ҵ���CPU������,[expr {($flag2_case3 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FC3 == [expr {($flag3_Case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)����shutdown/undo shut NE1�忨��NNI�ں�UNI��,����ҵ��ָ���ϵͳ�ڴ�,[expr {($flag3_case3 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FC4 == [expr {($flag4_Case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)��������NNI�����ڰ忨��ҵ�񲻶���,��ҵ������֤ҵ���CPU������,[expr {($flag4_case3 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FC5 == [expr {($flag5_Case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)�������н����̵ĵ�����,��ҵ������֤ҵ���CPU������,[expr {($flag5_case3 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FC6 == [expr {($flag6_Case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)��������NMS������������,��ҵ������֤ҵ���CPU������,[expr {($flag6_case3 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FC7 == [expr {($flag7_Case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�ϵͳ�г���ָ����vsiʱ��NE1($gpnIp1)�������б����豸������,��ҵ������֤ҵ���CPU������,[expr {($flag7_case3 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FC8 == [expr {($flag8_Case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�ϵͳ�г���ָ����vsiʱ������ɾ��NE1($gpnIp1)��pw��ac��pw������,��ҵ������֤ҵ���CPU������,[expr {($flag8_case3 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FC9 == [expr {($flag9_Case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�ϵͳ�г���ָ����vsiʱ������NE1��NE2�����ã�������ú�ָ�����,��ҵ������֤ҵ���CPU������,[expr {($flag9_case3 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FC10 == [expr {($flag10_Case3 == 1) ? "NOK" : "OK"}]" "�����ۣ������Բ���,[expr {($flag10_case3 == 1) ? "�ɹ�" : "ʧ��"}]" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_013_4"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_013_4_REPORT.txt" "report\\NOK_GPN_PTN_013_4_REPORT.txt"
	file rename "log\\GPN_PTN_013_4_LOG.txt" "log\\NOK_GPN_PTN_013_4_LOG.txt"
} else {
	file rename "report\\GPN_PTN_013_4_REPORT.txt" "report\\OK_GPN_PTN_013_4_REPORT.txt"
	file rename "log\\GPN_PTN_013_4_LOG.txt" "log\\OK_GPN_PTN_013_4_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}