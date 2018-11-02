#!/bin/sh
# T4_GPN_PTN_ELAN_006.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#����Ŀ�ģ�E-LAN�Ĺ���
#1-2-E-LANҵ������֤  
#3-mac��ַѧϰ����
#4-���Ĺ���  
#5-�ڰ���������
#6-����ͳ��  
#7-LSP��ǩ����������֤
#-----------------------------------------------------------------------------------------------------------------------------------
#�����������Ͷ���������7600/SΪ����                                                                                                                             
#                                                                              
#                                    ___________              ___________                               
#                                   |   4GE/ge  |____________| 4GE/ge    |
#  _______                          |   8fx     |____________| 8fx       |������������������������TC2     
# |       |                         |           |____________|           |  
# |  PC   |_______Internet���� ______|           |____________|           |
# |_______|                         |           |            |           |
#    /__\                           |GPN(7600/S)|            |           |       
#                        TC1����������������|           |            |           |
#                                   |___________|            |GPN(7600/S)|
#                                          Internet��������������������|___________| 
#                                                                         
#                                                                  				                     	           
#---------------------------------------------------------------------------------------------------------------------------------
#�ű�����������
#1�����ղ������˴���Ի���:��GPN�Ĺ���˿ڣ�U/D����PC��������Internet������GPN��2��������
#   ��STC�˿ڣ� 9/9����9/10��
#2����GPN��������� ���ã���������vlan vid=4000���ڸ�vlan�����ù���IP����untagged��ʽ��ӹ���˿ڣ�U/D��
#-----------------------------------------------------------------------------------------------------------------------------------
#���Թ��̣�
#1���Test Case 1���Ի���
##E-LANҵ������֤ -����ģʽΪ�˿�ģʽ
#   <1>��̨76�������������˼�����ͼ7��NE1�豸ͨ������������,NE2��NE3��NE4�豸ͨ�����������ܣ���4̨�豸��DCN������̨�豸�˴�֮���NNI�˿�ͨ����̫���ӿ���ʽ������NNI�˿���untag��ʽ���뵽VLANIF��
#   <2>����NE1��NE2��NE3��NE4֮���һ��EP-LANҵ��NE2��ΪPE��Ϊp�豸���û������ģʽΪ�˿�ģʽ
#   <3>����LSP1
#      ����NE1��NE2��LSP���ǩ100������ǩ100��PW���ر�ǩ1000��Զ�̱�ǩ1000
#      ����NE2��NE1��LSP���ǩ100������ǩ100��PW���ر�ǩ1000��Զ�̱�ǩ1000
#      ����NE2��NE3��LSP���ǩ200������ǩ200��PW���ر�ǩ2000��Զ�̱�ǩ2000
#      ����NE3��NE2��LSP���ǩ200������ǩ200��PW���ر�ǩ2000��Զ�˱�ǩ2000
#      ����NE3��NE4��LSP���ǩ300������ǩ300��PW���ر�ǩ3000��Զ�̱�ǩ3000
#      ����NE4��NE3��LSP���ǩ300������ǩ300��PW���ر�ǩ3000��Զ�̱�ǩ3000
#      ����NE4��NE1��LSP���ǩ400������ǩ400��PW���ر�ǩ4000��Զ�̱�ǩ4000
#      ����NE1��NE4��LSP���ǩ400������ǩ400��PW���ر�ǩ4000��Զ�˱�ǩ4000
#      ����NE1��NE2��LSP���ǩ500������ǩ500��NE2��NE3��lsp���ǩ600������ǩ600��NE2����ǩ������PW���ر�ǩ5000��Զ�̱�ǩ5000
#      ����NE3��NE2��LSP���ǩ600������ǩ600��NE2��NE1��lsp���ǩ500������ǩ500��NE2����ǩ������PW���ر�ǩ5000��Զ�̱�ǩ5000
#      ����NE2��NE3��LSP���ǩ700������ǩ700��NE3��NE4��lsp���ǩ800������ǩ800��NE3����ǩ������PW���ر�ǩ6000��Զ�̱�ǩ6000
#      ����NE4��NE3��LSP���ǩ800������ǩ800��NE3��NE2��lsp���ǩ700������ǩ700��NE3����ǩ������PW���ر�ǩ6000��Զ�̱�ǩ6000
#      NE2/NE3��SW���ã�mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000>
#      <1-65535> [normal|ring] 
#   <4>NE1��NE2��NE3��NE4�û�������undo vlan check
#   <5>��NE1��NE2��NE3��NE4�Ķ˿�1�ֱ���untag/tag���㲥���鲥����֪����ҵ������
#   Ԥ�ڽ�����۲�������̨�豸�Ķ˿ڽ��ս������̨PE�豸���ɷ��ͺͽ�������
#   <6>ʹ��NE1�豸PW1�Ŀ����֣�������NE1��NE2��NE4��NNI�˿�egress�����ģ�
#   Ԥ�ڽ��:NE1��NE4Ϊ��VLAN TAG��ǩ����������mpls��ǩ���ģ����lsp��ǩ400���ڲ�pw��ǩ4000��LSP�ֶ��е�TTLֵΪ255��PW�ֶ��е�TTLֵΪ255��PW�ֶ��к���4�ֽڿ����֣�
#           NE1��NE2�������ֱ��ģ�һΪ���lsp��ǩΪ200���ڲ�pw��ǩΪ2000��MPLS���ģ���Ϊ���lsp��ǩΪ500���ڲ�pw��ǩΪ5000��ת��NE3�ı���
#   <7>ʹ��NE1��LSP1/PW1/AC1����ͳ�ƣ�ϵͳ���쳣������ͳ�ƹ�����Ч��ͳ��ֵ��ȷ
#   <8>ʹ��NE1�豸PW1�Ŀ����֣�������NE1��NNI�˿�egress������
#   Ԥ�ڽ����������Ϊ��VLAN TAG��ǩ����������mpls��ǩ���ģ����lsp��ǩ200���ڲ�pw��ǩ2000
#             LSP�ֶ��е�TTLֵΪ255��PW�ֶ��е�TTLֵΪ255��PW�ֶ��к���4�ֽڿ�����
#   <9>undo shutdown��shutdown NE1�豸��NNI/UNI�˿�50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
#   <10>����NE1�豸��NNI/UNI�˿����ڰ忨50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
#   <11>NE1�豸����SW/NMS����50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 ���鿴��ǩת��������ȷ����̨�豸��������
#   <12>��������NE1�豸��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ�������ϵͳ���쳣���鿴��ǩת��������ȷ����̨�豸�������� 
#2���Test Case 2���Ի���
##E-LANҵ������֤ -����ģʽΪ"�˿�+��Ӫ��VLAN"ģʽ
#   <1>ɾ��NE1��NE2��NE3��NE4�豸��ר��ҵ��AC+vpls�򣩣�ɾ���ɹ�ҵ���жϣ�ϵͳ���쳣���ײ�鿴ac��vpls��������ʧ
#   <2>������4̨�豸����AC�ڵ�ר��ҵ��AC),����α�ߣ�PW���������ģ�����������ģʽ��Ϊ���˿�+��Ӫ��VLAN��
#   <3>�û������ָ����vlan��
#   <4>����̨�豸�Ͼ����������VLAN��vlan 1000����������˿�
#   <5>��NE1�Ķ˿�1����tag1000��tag2000ҵ���������۲�NE2��NE3��NE4��UNI�˿ڵĽ��ս��
#   Ԥ�ڽ�����ٴδ�������ģʽΪ���˿�+��Ӫ��VLAN����ר��ҵ�񣬳ɹ�������ϵͳ���쳣
#             NE2��NE3��NE4��UNI�˿�ֻ�ɽ���tag1000ҵ��������˫����ҵ������
#   <6>ɾ��֮ǰ����ģʽ��Ϊ���˿�+��Ӫ��VLAN����AC
#   <7>��NE1��NE2��NE3��NE4�豸���ٴ���һ���µ�E-LANҵ��(��֮ǰ��ҵ����ͬһ��LSP)����AC����ģʽ��Ϊ���˿�+��Ӫ��VLAN+�ͻ�VLAN��
#      ��Ӫ��VLANΪ vlan 3000���ͻ�VLANΪvlan 300
#   Ԥ�ڽ����ҵ��ɹ�������ϵͳ���쳣����֮ǰ��ҵ�����κθ���
#   <8>��NE1��UNI�˿�2����untag��tag300��tag3000�� ˫��tag����3000 ��300��ҵ���������۲�NE2��NE3��NE4��UNI�˿ڵĽ��ս��
#   Ԥ�ڽ����NE2��NE3��NE4��UNI�˿�ֻ�ɽ��յ�˫��tag����3000 ��300��ҵ����������֮ǰ��ҵ���޸��ţ�˫����ҵ������
#   <9>undo shutdown��shutdown NE1�豸��NNI/UNI�˿�50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
#   <10>����NE1�豸��NNI/UNI�˿����ڰ忨50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
#   <11>NE1�豸����SW/NMS����50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 ���鿴��ǩת��������ȷ��4̨�豸��������
#   <12>��������NE1�豸��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ�������ϵͳ���쳣���鿴��ǩת��������ȷ��4̨�豸�������� 
#   <13>��UNI�˿ڸ���ΪFE/10GE�˿ڣ������������䣬�ظ����ϲ���
#   <14>��FE�˿�����ELANҵ��ʱ���迪���ð忨��MPLSҵ��ģʽ��mpls enable <slot>��
#3���Test Case 3���Ի���
###mac��ַѧϰ����
#   <1>����vpls����mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ����
#   <2>��NE1���û���˿ڷ���Դmac��ͬ��110�������鿴mac��ַ��
#   Ԥ�ڽ����mac��ַѧϰ��Ŀ��ȷΪ100������Ŀ��ȷ��NE2��NE3��NE4��ֻ���յ�100��������֤������������Ч
#   <3>ѧϰ�������䣬��ѧϰ�����Ϊ�鷺
#   <4>��NE1���û���˿ڷ���Դmac��ͬ��110�������鿴mac��ַ��
#   Ԥ�ڽ����mac��ַѧϰ��Ŀ��ȷΪ110������Ŀ��ȷ��NE2��NE3��NE4�����յ�110��������֤���鷺������Ч��ûѧ����mac���鷺
#   <5>��ѧϰ��������Ϊ����ֵ���ж����֤��Ч
#4���Test Case 4���Ի���
###���Ĺ���
#   <1>NE1��ac�ڷ���δ֪����/�鲥/�㲥���ģ�ȡ��/�鲥�㲥���ƣ�ҵ������
#   <2>���õ���/�鲥/�㲥���ƹ���ʹ�ܣ�ҵ��ͨ�����ƹ��ܽ�ֹ��ҵ��ָ�
#5���Test Case 5���Ի���
###�ڰ���������
#   <1>��NE1����ԴΪ0000.0012.0012��Ŀ��macΪ0000.0012.0002����������NE2��NE3��NE4�����յ�
#   <2>�鿴mac��ַ��0000.0012.0012��̬ѧ��ac��
#   <3>��NE1��ac�������û���Դ�ľ�̬mac��mac��ַΪ0000.0012.0012���鿴mac��ַ����mac�����ɶ�̬��Ϊ��̬��ҵ������
#   <4>��������������������ȷ��ҵ������
#   <5>ɾ����̬mac��mac��ַ�ֱ����¶�̬ѧϰ��
#   <6>��NE1--NE2��pw�����û���Դ�ľ�̬mac��mac��ַΪ0000.0012.0002��NE2�յ���������NE3��NE4���ղ�������
#   <7>��������������������ȷ��ҵ������
#   <8>ɾ����̬mac��NE3��NE4�յ�������
#   <9>��NE1��ac�������û���Դ�ľ��ڶ�mac��mac��ַΪ0000.0012.0012���鿴mac��ַ����̬������ʧ���ڶ�mac������ڣ�ҵ��ͨ
#   <10>��������������������ȷ��ҵ������
#   <11>ɾ���ڶ�mac��ҵ���������ڶ�mac������ʧ
#6���Test Case 6���Ի���
###����ͳ��
#   <1>NE1��NE2��NE3��NE4��ac�ڶԷ����������ĸ�AC�ھ����յ�������
#   <2>����ĳһ̨�豸��ac�˿ڡ�lsp��pw�ĵ�ǰ����ͳ��
#   <3>һ��ʱ��󣬲鿴ͳ�ƽ����ͳ����ȷ
#   <4>���AC�˿ڣ�lsp��pw��15���Ӳɼ���Ϣ��һСʱ��鿴15������ʷ����ͳ�ƣ�Ӧ�����ĸ�ͳ�ƽ����ÿ15����ͳ��һ�Σ�ͳ����ȷ
#   <5>���AC�˿ڣ�lsp��pw��24Сʱ�ɼ���Ϣ��48Сʱ��鿴24Сʱ��ʷ����ͳ�ƣ�Ӧ��������ͳ�ƽ����ÿ24Сʱͳ��һ�Σ�ͳ����ȷ
#7���Test Case 7���Ի���
##LSP��ǩ����������֤
#   <1>���´���NE1��NE3һ��E-LANҵ��NNI�˿ں�֮ǰ������ҵ���NNI�˿���ͬ����NNI�˿ڸ��ã���ֻ����tag��ʽ���뵽����VLANIF�У�
#      �û������ģʽΪ�˿�ģʽ�������´���LSP��PW��AC
#   <2>����NE1��LSP10���ǩ17������ǩ17��PW10���ر�ǩ20��Զ�̱�ǩ20
#      ����NE3��LSP10���ǩ18������ǩ18��PW10���ر�ǩ20��Զ�̱�ǩ20 
#      NE2��SW���ã�mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000> <1-65535> [normal|ring] 
#   Ԥ�ڽ����ҵ�����óɹ�����֮ǰ��E-LANҵ����Ӱ�죬ϵͳ���쳣
#   <3>NE1��NE3�û�������undo vlan check
#   <4>����PW1/AC1
#   <5>��NE1��UNI�˿ڷ���untag/tagҵ���������۲�NE3�Ľ��ս��
#   Ԥ�ڽ����NE3�Ķ˿�3����������untag/tagҵ��������˫��������������֮ǰ��ҵ���޸���
#   <6>����NE1��NNI�˿�egress������
#   Ԥ�ڽ����Ϊ��VLAN TAG��ǩ����������mpls��ǩ���ģ����lsp��ǩ17���ڲ�pw��ǩ20��
#             LSP�ֶ��е�TTLֵΪ255��PW�ֶ��е�TTLֵΪ255��PW�ֶ��к���4�ֽڿ�����
#   <7>����NE2��NNI�˿�egress����ͬ������ץ�������ǩ������ǩ����Ϊ18���ڲ��ǩ20��LSP�ֶ��е�TTLֵ��1��PW�ֶ��е�TTLֵ��Ϊ255
#   <8>undo shutdown��shutdown NE1��NE2�豸��NNI/UNI�˿�50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
#   <9>����NE1��NE2�豸��NNI/UNI�˿����ڰ忨50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
#   <10>NE1��NE2�豸����SW/NMS����50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 ���鿴��ǩת��������ȷ
#   <11>��������NE1��NE2�豸��50�Σ�ÿ�β�����ϵͳ����������ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣���鿴��ǩת��������ȷ
#   <12>�����̨�豸���ã���̨�豸����������������鿴�����κ�����
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
        close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_006_LOG.txt" a]
        set stdout $fd_log
        log_file log\\GPN_PTN_006_LOG.txt
        chan configure $fd_log -blocking 0 -buffering none;#������ģʽ ����flush
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_006_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_006_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_006_DEBUG.txt 0
	chan configure $fd_debug -blocking 0 -buffering none;#������ģʽ ����flush
	  
	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl

        ###����������
        array set dataArr1 {-srcMac "00:00:00:00:00:01" -dstMac "00:00:00:00:00:11" -srcIp "192.85.1.1" -dstIp "192.0.0.1"}
        array set dataArr2 {-srcMac "00:00:00:00:00:02" -dstMac "00:00:00:00:00:22" -srcIp "192.85.1.2" -dstIp "192.0.0.2" -vid "500" -pri "000"}
        array set dataArr3 {-srcMac "00:00:00:00:00:03" -dstMac "00:00:00:00:00:33" -srcIp "192.85.1.3" -dstIp "192.0.0.3" -vid "500" -pri "000"}
        array set dataArr4 {-srcMac "00:00:00:00:00:04" -dstMac "00:00:00:00:00:44" -srcIp "192.85.1.4" -dstIp "192.0.0.4" -vid "500" -pri "000"}
        array set dataArr5 {-srcMac "00:00:00:00:00:05" -dstMac "FF:FF:FF:FF:FF:FF" -srcIp "192.85.1.5" -dstIp "192.0.0.5"}
        array set dataArr6 {-srcMac "00:00:00:00:00:06" -dstMac "01:00:5e:01:02:03" -srcIp "192.85.1.6" -dstIp "192.0.0.6"}
        array set dataArr7 {-srcMac "00:00:00:00:00:22" -dstMac "00:00:00:00:00:02" -srcIp "192.85.1.7" -dstIp "192.0.0.27" -vid "500" -pri "000"}
        array set dataArr8 {-srcMac "00:00:00:00:00:33" -dstMac "00:00:00:00:00:03" -srcIp "192.85.1.8" -dstIp "192.0.0.8" -vid "500" -pri "000"}
        array set dataArr9 {-srcMac "00:00:00:00:00:44" -dstMac "00:00:00:00:00:04" -srcIp "192.85.1.9" -dstIp "192.0.0.9" -vid "500" -pri "000"}
        array set dataArr10 {-srcMac "00:00:00:00:00:0a" -dstMac "FF:FF:FF:FF:FF:FF" -srcIp "192.85.1.10" -dstIp "192.0.0.10" -vid "800" -pri "000"}
        array set dataArr11 {-srcMac "00:00:00:00:00:0b" -dstMac "01:00:5e:04:05:06" -srcIp "192.85.1.11" -dstIp "192.0.0.11" -vid "800" -pri "000"}
        array set dataArr12 {-srcMac "00:00:00:00:00:0c" -dstMac "00:00:00:00:00:cc" -srcIp "192.85.1.12" -dstIp "192.0.0.12" -vid "800" -pri "000"}
        array set dataArr13 {-srcMac "00:00:00:00:00:0d" -dstMac "00:00:00:00:00:dd" -srcIp "192.85.1.13" -dstIp "192.0.0.13" -vid "800" -pri "000"}
        array set dataArr14 {-srcMac "00:00:00:00:00:08" -dstMac "00:00:00:00:00:88" -srcIp "192.85.1.14" -dstIp "192.0.0.14" -vid1 "1000" -pri1 "000" -vid2 "100" -pri2 "000"}
        array set dataArr15 {-srcMac "00:00:00:00:00:09" -dstMac "00:00:00:00:00:99" -srcIp "192.85.1.15" -dstIp "192.0.0.15" -vid1 "1000" -pri1 "000" -vid2 "100" -pri2 "000"}
        array set dataArr16 {-srcMac "00:00:00:00:00:0e" -dstMac "00:00:00:00:00:ee" -srcIp "192.85.1.16" -dstIp "192.0.0.16"}
        array set dataArr17 {-srcMac "00:00:00:10:00:07" -dstMac "00:00:00:20:00:77" -srcIp "192.85.1.17" -dstIp "192.0.0.17" -vid "500" -pri "000" -stepValue "00:00:00:00:00:01" -recycleCount "200" -EnableStream "FALSE"}
        array set dataArr18 {-srcMac "00:00:00:00:00:12" -dstMac "00:00:00:00:12:12" -srcIp "192.85.1.18" -dstIp "192.0.0.18" -vid "800" -pri "000" -etherType "8847" -pattern "000650ff003e91ff"}
        array set dataArr19 {-srcMac "00:00:00:00:00:13" -dstMac "00:00:00:00:12:13" -srcIp "192.85.1.19" -dstIp "192.0.0.19" -vid "800" -pri "000" -etherType "8847" -pattern "000c90ff007d11ff"}
        array set dataArr20 {-srcMac "00:00:00:00:00:14" -dstMac "00:00:00:00:13:14" -srcIp "192.85.1.20" -dstIp "192.0.0.20" -vid "800" -pri "000" -etherType "8847" -pattern "0012d0ff00bb91ff"}
        array set dataArr21 {-srcMac "00:00:00:00:00:15" -dstMac "00:00:00:00:14:15" -srcIp "192.85.1.21" -dstIp "192.0.0.21" -vid "800" -pri "000" -etherType "8847" -pattern "001910ff00fa11ff"}
        
	array set dataArr22 {-srcMac "00:00:00:00:01:05" -dstMac "00:00:00:00:11:55" -srcIp "192.86.1.2" -dstIp "192.0.0.1" -vid "500" -pri "000"}
	array set dataArr23 {-srcMac "00:00:00:00:04:05" -dstMac "00:00:00:00:44:55" -srcIp "192.86.4.2" -dstIp "192.0.0.2" -vid "500" -pri "000"}
	
	array set dataArr24 {-srcMac "00:00:00:00:02:00" -dstMac "00:00:00:00:22:00" -srcIp "192.86.2.2" -dstIp "192.0.0.3"}
	array set dataArr25 {-srcMac "00:00:00:00:02:05" -dstMac "00:00:00:00:22:55" -srcIp "192.86.2.3" -dstIp "192.0.0.4" -vid "500" -pri "000"}
	array set dataArr26 {-srcMac "00:00:00:00:02:08" -dstMac "00:00:00:00:22:88" -srcIp "192.86.2.4" -dstIp "192.0.0.5" -vid "800" -pri "000"}
	
	array set dataArr27 {-srcMac "00:00:00:00:03:00" -dstMac "00:00:00:00:33:00" -srcIp "192.86.3.2" -dstIp "192.0.0.6"}
	array set dataArr28 {-srcMac "00:00:00:00:03:05" -dstMac "00:00:00:00:33:55" -srcIp "192.86.3.3" -dstIp "192.0.0.7" -vid "500" -pri "000"}
	array set dataArr29 {-srcMac "00:00:00:00:03:08" -dstMac "00:00:00:00:33:88" -srcIp "192.86.3.4" -dstIp "192.0.0.8" -vid "800" -pri "000"}
	
	array set dataArr30 {-srcMac "00:00:00:00:02:10" -dstMac "00:00:00:00:22:88" -srcIp "192.85.1.14" -dstIp "192.0.0.14" -vid1 "1000" -pri1 "000" -vid2 "100" -pri2 "000"}
	array set dataArr31 {-srcMac "00:00:00:00:03:10" -dstMac "00:00:00:00:33:99" -srcIp "192.85.1.15" -dstIp "192.0.0.15" -vid1 "1000" -pri1 "000" -vid2 "100" -pri2 "000"}
	
	array set dataArr32 {-srcMac "00:00:00:00:01:0a" -dstMac "FF:FF:FF:FF:FF:FF" -srcIp "192.85.1.10" -dstIp "192.0.0.10" -vid "800" -pri "000"}
	array set dataArr33 {-srcMac "00:00:00:00:01:0b" -dstMac "01:00:5e:07:08:09" -srcIp "192.85.1.11" -dstIp "192.0.0.11" -vid "800" -pri "000"}
	
	###���ö�����Ϣ����
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        #���÷���������
        set GenCfg {-SchedulingMode RATE_BASED}
        ###���ù��˷���������
        ##ƥ��smc
        set anaFliFrameCfg0 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        ##ƥ��smc��vid��EtherType
        set anaFliFrameCfg1 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType><vlans name="anon_2561"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        ##ƥ������vid
        set anaFliFrameCfg4 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5580"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        ##mpls�����е�smac�� vid
        set anaFliFrameCfg51 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5699"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu></pdus></config></frame>}
        ##mpls�����е������ǩ
        set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
        ##mpls�����еĴ���vid��Experimental Bits (bits)/Bottom of stack (bit)
        set anaFliFrameCfg3 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4647"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><exp override="true"  filterMinValue="0" filterMaxValue="111">111</exp></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><sBit override="true"  filterMinValue="0" filterMaxValue="1">1</sBit></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
	##ƥ��smac��vid1��vid2��ethtype
	set anaFliFrameCfg6 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType><vlans name="anon_2516"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	##ƥ��smac��ethtype
	set anaFliFrameCfg7 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	
	set rateL 95000000;#�շ�������ȡֵ��Сֵ��Χ
	set rateR 105000000;#�շ�������ȡֵ���ֵ��Χ
	set rateL1 100000000 
	set rateR1 125000000
	set rateL0 91000000;#�շ�������ȡֵ��Сֵ��Χ
	set rateR0 106000000;#�շ�������ȡֵ���ֵ��Χ
	
	set rateL2 81000000;#�շ�������ȡֵ��Сֵ��Χ
	set rateR2 106000000;#�շ�������ȡֵ���ֵ��Χ 
	
	set flagCase1 0   ;#Test case 1��־λ 
	set flagCase2 0   ;#Test case 2��־λ
	set flagCase3 0   ;#Test case 3��־λ 
	set flagCase4 0   ;#Test case 4��־λ
	set flagCase5 0   ;#Test case 5��־λ 
	set flagCase6 0   ;#Test case 6��־λ 
	set flagCase7 0   ;#Test case 7��־λ 
	set flagCase8 0   ;#Test case 7��־λ 
	
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
	
	
	proc TestVplsTag {fileId printWord rateL rateR caseId} {
	
		global hGPNPortGenList
		global hGPNPortAnaList
		global hGPNPortAnaFrameCfgFilList
		global hGPNPort1Cap
		global hGPNPort2Cap
		global hGPNPort3Cap
		global hGPNPort4Cap
		global hGPNPort1CapAnalyzer
		global hGPNPort2CapAnalyzer
		global hGPNPort3CapAnalyzer
		global hGPNPort4CapAnalyzer
		global gpnIp1
		global gpnIp2
		global gpnIp3
		global gpnIp4
		global Portlist0
		global anaFliFrameCfg1
		global anaFliFrameCfg0
		global anaFliFrameCfg6
		global anaFliFrameCfg7
		global GPNTestEth1
		global GPNTestEth2
		global GPNTestEth3
		global GPNTestEth4
		
		set flag 0
		
		#NE1 NE2 NE3 NE4����untag��tag=500��tag=800��δ֪���� ------
		SendAndStat_ptn006 1 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
			$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
			$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 $caseId
		SendAndStat_ptn006 0 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
			$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
			$hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $anaFliFrameCfg0 $caseId
		SendAndStat_ptn006 0 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
			$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
			$hGPNPortAnaFrameCfgFilList GPNPort1Cnt2 GPNPort2Cnt2 GPNPort3Cnt2 GPNPort4Cnt2 6 $anaFliFrameCfg6 $caseId
		SendAndStat_ptn006 0 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
			$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
			$hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 7 $anaFliFrameCfg7 $caseId
		
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		#DEV1 GPNTestEth1�Ľ��ռ��
		if {$GPNPort1Cnt7(cnt20) < $rateL || $GPNPort1Cnt7(cnt20) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt20)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt20)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt1(cnt53) < $rateL || $GPNPort1Cnt1(cnt53) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=500��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt53)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=500��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt53)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt1(cnt54) < $rateL || $GPNPort1Cnt1(cnt54) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=800��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt54)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=800��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt54)����$rateL-$rateR\��Χ��" $fileId
		}
		
		if {$GPNPort1Cnt0(cnt55) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt55)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt55)" $fileId
		}
		if {$GPNPort1Cnt7(cnt35) < $rateL || $GPNPort1Cnt7(cnt35) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=500��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt35)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=500��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt35)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt0(cnt57) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=800��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt57)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=800��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt57)" $fileId
		}
		
		if {$GPNPort1Cnt0(cnt01) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt01)" $fileId
		}
		if {$GPNPort1Cnt0(cnt04) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=500��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt04)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=500��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt04)" $fileId
		}
		if {$GPNPort1Cnt0(cnt13) < $rateL || $GPNPort1Cnt0(cnt13) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt0(cnt13)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt0(cnt13)����$rateL-$rateR\��Χ��" $fileId
		}
		
		#DEV2 GPNTestEth2�Ľ��ռ��
		if {$GPNPort2Cnt7(cnt10) < $rateL || $GPNPort2Cnt7(cnt10) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt10)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt1(cnt50) < $rateL || $GPNPort2Cnt1(cnt50) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt50)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt50)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt1(cnt12) < $rateL || $GPNPort2Cnt1(cnt12) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt12)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt12)����$rateL-$rateR\��Χ��" $fileId
		}
		
		if {$GPNPort2Cnt0(cnt55) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����untag��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����untag��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
		}
		if {$GPNPort2Cnt7(cnt35) < $rateL || $GPNPort2Cnt7(cnt35) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=500��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt35)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=500��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt35)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt0(cnt57) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=800��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt57)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=800��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt57)" $fileId
		}
		
		if {$GPNPort2Cnt0(cnt01) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt01)" $fileId
		}
		if {$GPNPort2Cnt0(cnt04) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=500��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt04)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=500��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt04)" $fileId
		}
		if {$GPNPort2Cnt0(cnt13) < $rateL || $GPNPort2Cnt0(cnt13) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt0(cnt13)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt0(cnt13)" $fileId
		}
		
		#DEV3 GPNTestEth3�Ľ��ռ��
		if {$GPNPort3Cnt1(cnt1) < $rateL || $GPNPort3Cnt1(cnt1) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt1)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt2(cnt11) < $rateL || $GPNPort3Cnt2(cnt11) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ��ڲ�tag=500 ���tag=500��������������Ϊ$GPNPort3Cnt2(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ��ڲ�tag=500 ���tag=500��������������Ϊ$GPNPort3Cnt2(cnt11)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt2(cnt13) < $rateL || $GPNPort3Cnt2(cnt13) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ��ڲ�tag=800 ���tag=500��������������Ϊ$GPNPort3Cnt2(cnt13)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ��ڲ�tag=800 ���tag=500��������������Ϊ$GPNPort3Cnt2(cnt13)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt1(cnt51) < $rateL || $GPNPort3Cnt1(cnt51) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt51)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt51)����$rateL-$rateR\��Χ��" $fileId
		}	
		if {$GPNPort3Cnt2(cnt21) < $rateL || $GPNPort3Cnt2(cnt21) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=500��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ��ڲ�tag=500 ���tag=500��������������Ϊ$GPNPort3Cnt2(cnt21)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=500��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ��ڲ�tag=500 ���tag=500��������������Ϊ$GPNPort3Cnt2(cnt21)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt2(cnt23) < $rateL || $GPNPort3Cnt2(cnt23) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=800��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ��ڲ�tag=800 ���tag=500��������������Ϊ$GPNPort3Cnt2(cnt23)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=800��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ��ڲ�tag=800 ���tag=500��������������Ϊ$GPNPort3Cnt2(cnt23)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt0(cnt01) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt01)" $fileId
		}
		if {$GPNPort3Cnt0(cnt51) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=500��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�������������ӦΪ0ʵΪGPNPort3Cnt0(cnt51)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=500��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�������������ӦΪ0ʵΪGPNPort3Cnt0(cnt51)" $fileId
		}
		if {$GPNPort3Cnt1(cnt55) < $rateL || $GPNPort3Cnt1(cnt55) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt55)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt55)����$rateL-$rateR\��Χ��" $fileId
		}
		#DEV4 GPNTestEth4�Ľ��ռ�� 
		if {$GPNPort4Cnt1(cnt81) < $rateL || $GPNPort4Cnt1(cnt81) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt81)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt81)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt2(cnt12) < $rateL || $GPNPort4Cnt2(cnt12) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ��ڲ�tag=500 ���tag=800��������������Ϊ$GPNPort4Cnt2(cnt12)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ��ڲ�tag=500 ���tag=800��������������Ϊ$GPNPort4Cnt2(cnt12)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt2(cnt14) < $rateL || $GPNPort4Cnt2(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ��ڲ�tag=800 ���tag=800��������������Ϊ$GPNPort4Cnt2(cnt14)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ��ڲ�tag=800 ���tag=800��������������Ϊ$GPNPort4Cnt2(cnt14)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt1(cnt52) < $rateL || $GPNPort4Cnt1(cnt52) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����untag��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt52)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����untag��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt52)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt2(cnt22) < $rateL || $GPNPort4Cnt2(cnt22) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=500��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ��ڲ�tag=500 ���tag=800��������������Ϊ$GPNPort4Cnt2(cnt22)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=500��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ��ڲ�tag=500 ���tag=800��������������Ϊ$GPNPort4Cnt2(cnt22)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt2(cnt24) < $rateL || $GPNPort4Cnt2(cnt24) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=800��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ��ڲ�tag=800 ���tag=800��������������Ϊ$GPNPort4Cnt2(cnt24)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=800��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ��ڲ�tag=800 ���tag=800��������������Ϊ$GPNPort4Cnt2(cnt24)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt0(cnt55) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����untag��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt55)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����untag��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt55)" $fileId
		}
		if {$GPNPort4Cnt1(cnt56) < $rateL || $GPNPort4Cnt1(cnt56) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=500��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt56)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=500��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt56)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt0(cnt57) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=800��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt57)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=800��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt57)����$rateL-$rateR\��Χ��" $fileId
		}
		return $flag
	}
	#flagElan = 1 һ��ELANҵ�����(vplsTypeΪtag acΪPORT+SVLAN+CVLAN); =2  ����ELANҵ�����(vplsTypeΪtag acΪPORT+SVLAN+CVLAN   vplsΪRaw acΪPORT+VLAN)
	proc TestResultPrint {flagElan fileId} {
		global GPNPort1Cnt0
		global GPNPort2Cnt0
		global GPNPort3Cnt0
		global GPNPort4Cnt0
		
		global GPNPort1Cnt1
		global GPNPort2Cnt1
		global GPNPort3Cnt1
		global GPNPort4Cnt1
		
		global GPNPort1Cnt2
		global GPNPort2Cnt2
		global GPNPort3Cnt2
		global GPNPort4Cnt2
		
		set flag 0
		#DEV1 GPNTestEth1�Ľ��ռ�� 
		if {$GPNPort1Cnt0(cnt52) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\����untag��δ֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt52)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\����untag��δ֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt52)" $fileId
		}
		if {$flagElan == 1} {
			if {$GPNPort1Cnt0(cnt54) !=0} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\����tag=800��δ֪������������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt54)" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\����tag=800��δ֪������������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt54)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt57) < $::rateL || $GPNPort1Cnt1(cnt57) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\����tag=800��δ֪������������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt57)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\����tag=800��δ֪������������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt57)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort1Cnt2(cnt25) < $::rateL || $GPNPort1Cnt2(cnt25) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\�����ڲ�tag=100���tag=1000��δ֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort1Cnt2(cnt25)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\�����ڲ�tag=100���tag=1000��δ֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort1Cnt2(cnt25)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt0(cnt55) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\����untag��δ֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt55)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\����untag��δ֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt55)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort1Cnt0(cnt56) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\����tag=500��δ֪������������NE1($::gpnIp1)\
        				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt56)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\����tag=500��δ֪������������NE1($::gpnIp1)\
        				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt56)" $fileId
        		}
		} else {
			if {$GPNPort1Cnt1(cnt58) < $::rateL || $GPNPort1Cnt1(cnt58) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\����tag=500��δ֪������������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�tag=500������������Ϊ$GPNPort1Cnt1(cnt58)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\����tag=500��δ֪������������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�tag=500������������Ϊ$GPNPort1Cnt1(cnt58)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
        	if {$GPNPort1Cnt2(cnt35) < $::rateL || $GPNPort1Cnt2(cnt35) > $::rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\�����ڲ�tag=100���tag=1000��δ֪������������NE1($::gpnIp1)\
        			$::GPNTestEth1\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort1Cnt2(cnt35)��û��$::rateL-$::rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\�����ڲ�tag=100���tag=1000��δ֪������������NE1($::gpnIp1)\
        			$::GPNTestEth1\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort1Cnt2(cnt35)����$::rateL-$::rateR\��Χ��" $fileId
        	}
		
		if {$GPNPort1Cnt0(cnt01) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����untag��δ֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����untag��δ֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt01)" $fileId
		}
		if {$flagElan == 1} {
			if {$GPNPort1Cnt0(cnt13) !=0} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt13)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt55) < $::rateL || $GPNPort1Cnt1(cnt55) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt55)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt55)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort1Cnt2(cnt45) < $::rateL || $GPNPort1Cnt2(cnt45) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\�����ڲ�tag=100���tag=1000��δ֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort1Cnt2(cnt45)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\�����ڲ�tag=100���tag=1000��δ֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort1Cnt2(cnt45)����$::rateL-$::rateR\��Χ��" $fileId
		}
		#DEV2 GPNTestEth2�Ľ��ռ�� 
		if {$GPNPort2Cnt0(cnt1) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort2Cnt0(cnt50) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE2($::gpnIp2)\
        				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt50)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE2($::gpnIp2)\
        				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt50)" $fileId
        		}
		} else {
			if {$GPNPort2Cnt1(cnt59) < $::rateL || $GPNPort2Cnt1(cnt59) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt59)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt59)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort2Cnt2(cnt15) < $::rateL || $GPNPort2Cnt2(cnt15) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\�����ڲ�tag=100���tag=1000��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort2Cnt2(cnt15)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\�����ڲ�tag=100���tag=1000��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort2Cnt2(cnt15)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt0(cnt55) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\����untag��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt55)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\����untag��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt55)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort2Cnt0(cnt56) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\����tag=500��δ֪������������NE2($::gpnIp2)\
        				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt56)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\����tag=500��δ֪������������NE2($::gpnIp2)\
        				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt56)" $fileId
        		}
		} else {
			if {$GPNPort2Cnt1(cnt56) < $::rateL || $GPNPort2Cnt1(cnt56) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\����tag=500��δ֪������������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�tag=800������������Ϊ$GPNPort2Cnt1(cnt56)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\����tag=500��δ֪������������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�tag=800������������Ϊ$GPNPort2Cnt1(cnt56)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort2Cnt2(cnt35) < $::rateL || $GPNPort2Cnt2(cnt35) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\�����ڲ�tag=100���tag=1000��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort2Cnt2(cnt35)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\�����ڲ�tag=100���tag=1000��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort2Cnt2(cnt35)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt0(cnt01) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����untag��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����untag��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt01)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort2Cnt0(cnt13) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE2($::gpnIp2)\
        				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt13)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE2($::gpnIp2)\
        				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt13)" $fileId
        		}
		} else {
			if {$GPNPort2Cnt1(cnt13) < $::rateL || $GPNPort2Cnt1(cnt13) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt13)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt13)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort2Cnt2(cnt45) < $::rateL || $GPNPort2Cnt2(cnt45) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\�����ڲ�tag=100���tag=1000��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort2Cnt2(cnt45)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\�����ڲ�tag=100���tag=1000��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort2Cnt2(cnt45)����$::rateL-$::rateR\��Χ��" $fileId
		}
		#DEV3 GPNTestEth3�Ľ��ռ�� 
		if {$GPNPort3Cnt0(cnt1) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort3Cnt0(cnt50) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE3($::gpnIp3)\
        				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt50)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE3($::gpnIp3)\
        				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt50)" $fileId
        		}
		} else {
			if {$GPNPort3Cnt1(cnt50) < $::rateL || $GPNPort3Cnt1(cnt50) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE3($::gpnIp3)\
					$::GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt50)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE3($::gpnIp3)\
					$::GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt50)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort3Cnt2(cnt15) < $::rateL || $GPNPort3Cnt2(cnt15) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\�����ڲ�tag=100���tag=1000��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort3Cnt2(cnt15)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\�����ڲ�tag=100���tag=1000��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort3Cnt2(cnt15)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt0(cnt52) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\����untag��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt52)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\����untag��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt52)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort3Cnt0(cnt54) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\����tag=800��δ֪������������NE3($::gpnIp3)\
        				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt54)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\����tag=800��δ֪������������NE3($::gpnIp3)\
        				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt54)" $fileId
        		}
		} else {
			if {$GPNPort3Cnt1(cnt57) < $::rateL || $GPNPort3Cnt1(cnt57) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\����tag=800��δ֪������������NE3($::gpnIp3)\
					$::GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt57)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\����tag=800��δ֪������������NE3($::gpnIp3)\
					$::GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt57)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort3Cnt2(cnt25) < $::rateL || $GPNPort3Cnt2(cnt25) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\�����ڲ�tag=100���tag=1000��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort3Cnt2(cnt25)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\�����ڲ�tag=100���tag=1000��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort3Cnt2(cnt25)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt0(cnt01) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����untag��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����untag��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt01)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort3Cnt0(cnt13) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE3($::gpnIp3)\
        				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt13)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE3($::gpnIp3)\
        				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt13)" $fileId
        		}
		} else {
			if {$GPNPort3Cnt1(cnt55) < $::rateL || $GPNPort3Cnt1(cnt55) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE3($::gpnIp3)\
					$::GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt55)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE3($::gpnIp3)\
					$::GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt55)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort3Cnt2(cnt45) < $::rateL || $GPNPort3Cnt2(cnt45) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\�����ڲ�tag=100���tag=1000��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort3Cnt2(cnt45)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\�����ڲ�tag=100���tag=1000��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort3Cnt2(cnt45)����$::rateL-$::rateR\��Χ��" $fileId
		}
		#DEV4 GPNTestEth4�Ľ��ռ�� 
		if {$GPNPort4Cnt0(cnt1) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1))" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort4Cnt0(cnt50) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE4($::gpnIp4)\
        				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt50)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE4($::gpnIp4)\
        				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt50)" $fileId
        		}
		} else {
			if {$GPNPort4Cnt1(cnt59) < $::rateL || $GPNPort4Cnt1(cnt59) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE4($::gpnIp4)\
					$::GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt59)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE4($::gpnIp4)\
					$::GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt59)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort4Cnt2(cnt15) < $::rateL || $GPNPort4Cnt2(cnt15) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\�����ڲ�tag=100���tag=1000��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort4Cnt2(cnt15)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\�����ڲ�tag=100���tag=1000��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort4Cnt2(cnt15)����$::rateL-$::rateR\��Χ��" $fileId
		}
		
		if {$GPNPort4Cnt0(cnt52) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\����untag��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt52)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\����untag��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt52)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort4Cnt0(cnt54) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\����tag=800��δ֪������������NE4($::gpnIp4)\
        				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt54)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\����tag=800��δ֪������������NE4($::gpnIp4)\
        				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt54)" $fileId
        		}
		} else {
			if {$GPNPort4Cnt1(cnt54) < $::rateL || $GPNPort4Cnt1(cnt54) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\����tag=800��δ֪������������NE4($::gpnIp4)\
					$::GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt54)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\����tag=800��δ֪������������NE4($::gpnIp4)\
					$::GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt54)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort4Cnt2(cnt25) < $::rateL || $GPNPort4Cnt2(cnt25) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\�����ڲ�tag=100���tag=1000��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort4Cnt2(cnt25)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\�����ڲ�tag=100���tag=1000��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort4Cnt2(cnt25)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt0(cnt55) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\����untag��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt55)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\����untag��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt55)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort4Cnt0(cnt56) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\����tag=500��δ֪������������NE4($::gpnIp4)\
        				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt56)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\����tag=500��δ֪������������NE4($::gpnIp4)\
        				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt56)" $fileId
        		}
		} else {
			if {$GPNPort4Cnt1(cnt56) < $::rateL || $GPNPort4Cnt1(cnt56) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\����tag=500��δ֪������������NE4($::gpnIp4)\
					$::GPNTestEth4\�յ�tag=800������������Ϊ$GPNPort4Cnt1(cnt56)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\����tag=500��δ֪������������NE4($::gpnIp4)\
					$::GPNTestEth4\�յ�tag=800������������Ϊ$GPNPort4Cnt1(cnt56)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort4Cnt2(cnt35) < $::rateL || $GPNPort4Cnt2(cnt35) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\�����ڲ�tag=100���tag=1000��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort4Cnt2(cnt35)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\�����ڲ�tag=100���tag=1000��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ��ڲ�tag=100���tag=1000������������Ϊ$GPNPort4Cnt2(cnt35)����$::rateL-$::rateR\��Χ��" $fileId
		}
		return $flag
	}
	###################################################################################
	#��������: case7��ҵ����֤
	#f_broadcast  =1 ��ֹ�㲥ת��
	#f_mcast   =1 ��ֹ�鲥ת��
	#f_unknow  =1 ��ֹδ֪����ת��
	##################################################################################
	proc TestCase7 {printWord rateL0 rateR0 rateL rateR f_broadcast f_mcast f_unknow} {
		global hGPNPort1Gen
		global hGPNPort4Gen
		global hGPNPort1Ana
		global hGPNPort4Ana
		global hGPNPort1AnaFrameCfgFil
		global hGPNPort4AnaFrameCfgFil
		global hGPNPort1Cap
		global hGPNPort4Cap
		global hGPNPort1CapAnalyzer
		global hGPNPort4CapAnalyzer
		global gpnIp1
		global gpnIp4
		global anaFliFrameCfg1
		global GPNTestEth1
		global GPNTestEth4
		global fileId
		set flag 0
		global capId
		
		incr capId
		SendAndStat_ptn006 1 "$hGPNPort1Gen $hGPNPort4Gen" "$hGPNPort1Ana $hGPNPort4Ana" "$GPNTestEth1 $GPNTestEth4" \
			"$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
			"$hGPNPort1AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" GPNPort1Cnt1 GPNPort4Cnt1 TmpCnt1 TmpCnt2 1 $anaFliFrameCfg1 "GPN_PTN_006_$capId"
		gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		if {$f_broadcast == 1} {
			if {$GPNPort1Cnt1(cnt10) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt10)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt10)" $fileId
			}
			if {$GPNPort4Cnt1(cnt60) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt60)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt60)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt10) < $rateL0 || $GPNPort1Cnt1(cnt10) > $rateR0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt10)��û��$rateL0-$rateR0\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt10)����$rateL0-$rateR0\��Χ��" $fileId
			}
			if {$GPNPort4Cnt1(cnt60) < $rateL0 || $GPNPort4Cnt1(cnt60) > $rateR0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt60)��û��$rateL0-$rateR0\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt60)����$rateL0-$rateR0\��Χ��" $fileId
			}
		}
		if {$f_mcast == 1} {
			if {$GPNPort1Cnt1(cnt11) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt11)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt11)" $fileId
			}
			if {$GPNPort4Cnt1(cnt65) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt65)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt65)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt11) < $rateL || $GPNPort1Cnt1(cnt11) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt11)����$rateL-$rateR\��Χ��" $fileId
			}
			if {$GPNPort4Cnt1(cnt65) < $rateL || $GPNPort4Cnt1(cnt65) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt65)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt65)����$rateL-$rateR\��Χ��" $fileId
			}
		}
		if {$f_unknow == 1} {
			if {$GPNPort1Cnt1(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt13)" $fileId
			}
			if {$GPNPort4Cnt1(cnt12) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt12)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt12)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt13) < $rateL || $GPNPort1Cnt1(cnt13) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt13)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt13)����$rateL-$rateR\��Χ��" $fileId
			}
			if {$GPNPort4Cnt1(cnt12) < $rateL || $GPNPort4Cnt1(cnt12) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt12)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt12)����$rateL-$rateR\��Χ��" $fileId
			}
		}
		return $flag
	}
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
	
	#���ڵ��������豸�õ��ı���------
	set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
	set lMatchType "$matchType1 $matchType2 $matchType3 $matchType4"
	set lDutType "$Gpn_type1 $Gpn_type2 $Gpn_type3 $Gpn_type4"
	set lIp "$gpnIp1 $gpnIp2 $gpnIp3 $gpnIp4"
	#------���ڵ��������豸�õ��ı���
	
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "�������Թ���...\n"
	set hPtnProject [stc::create project]
	set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3\
			\"media $GPNEth3Media\" $GPNStcPort4 \"media $GPNEth4Media\" $GPNStcPort5 \"media $GPNEth5Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4 hGPNPort5	

        ###������������
        gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort1 hGPNPort1Stream1
        gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort1 hGPNPort1Stream2
        gwd::STC_Create_VlanStream $fileId dataArr3 $hGPNPort1 hGPNPort1Stream3
        gwd::STC_Create_VlanStream $fileId dataArr4 $hGPNPort1 hGPNPort1Stream4
        gwd::STC_Create_Stream $fileId dataArr5 $hGPNPort1 hGPNPort1Stream5
        gwd::STC_Create_Stream $fileId dataArr6 $hGPNPort1 hGPNPort1Stream6
        gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort2 hGPNPort2Stream7
        gwd::STC_Create_VlanStream $fileId dataArr8 $hGPNPort3 hGPNPort3Stream8
        gwd::STC_Create_VlanStream $fileId dataArr9 $hGPNPort4 hGPNPort4Stream9
        gwd::STC_Create_VlanStream $fileId dataArr10 $hGPNPort4 hGPNPort4Stream10
        gwd::STC_Create_VlanStream $fileId dataArr11 $hGPNPort4 hGPNPort4Stream11
        gwd::STC_Create_VlanStream $fileId dataArr12 $hGPNPort1 hGPNPort1Stream12
        gwd::STC_Create_VlanStream $fileId dataArr13 $hGPNPort4 hGPNPort4Stream13
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr14 $hGPNPort1 hGPNPort1Stream14
        gwd::STC_Create_DoubleVlan_Stream $fileId dataArr15 $hGPNPort4 hGPNPort4Stream15
        gwd::STC_Create_Stream $fileId dataArr16 $hGPNPort4 hGPNPort4Stream16
        gwd::STC_Create_VlanSmacModiferStream $fileId dataArr17 $hGPNPort1 hGPNPort1Stream17
        gwd::STC_Create_VlanMplsCustomStream $fileId dataArr18 $hGPNPort1 hGPNPort1Stream18
        gwd::STC_Create_VlanMplsCustomStream $fileId dataArr19 $hGPNPort2 hGPNPort2Stream19
        gwd::STC_Create_VlanMplsCustomStream $fileId dataArr20 $hGPNPort3 hGPNPort3Stream20
        gwd::STC_Create_VlanMplsCustomStream $fileId dataArr21 $hGPNPort4 hGPNPort4Stream21
	
	gwd::STC_Create_VlanStream $fileId dataArr22 $hGPNPort1 hGPNPort1Stream22
	gwd::STC_Create_VlanStream $fileId dataArr23 $hGPNPort4 hGPNPort4Stream23
	gwd::STC_Create_Stream $fileId dataArr24 $hGPNPort2 hGPNPort2Stream24
	gwd::STC_Create_VlanStream $fileId dataArr25 $hGPNPort2 hGPNPort2Stream25
	gwd::STC_Create_VlanStream $fileId dataArr26 $hGPNPort2 hGPNPort2Stream26	
	gwd::STC_Create_Stream $fileId dataArr27 $hGPNPort3 hGPNPort3Stream27
	gwd::STC_Create_VlanStream $fileId dataArr28 $hGPNPort3 hGPNPort3Stream28
	gwd::STC_Create_VlanStream $fileId dataArr29 $hGPNPort3 hGPNPort3Stream29
	
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr30 $hGPNPort2 hGPNPort2Stream30
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr31 $hGPNPort3 hGPNPort3Stream31
	
	gwd::STC_Create_VlanStream $fileId dataArr32 $hGPNPort1 hGPNPort1Stream32
	gwd::STC_Create_VlanStream $fileId dataArr33 $hGPNPort1 hGPNPort1Stream33
	
        set hGPNPortStreamList "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream3 $hGPNPort1Stream4 $hGPNPort1Stream5 $hGPNPort1Stream6\
                                $hGPNPort2Stream7 $hGPNPort3Stream8 $hGPNPort4Stream9 $hGPNPort4Stream10 $hGPNPort4Stream11"
        set hGPNPortStreamList1 "$hGPNPort1Stream12 $hGPNPort1Stream14 $hGPNPort4Stream13 $hGPNPort4Stream15 $hGPNPort4Stream16 $hGPNPort1Stream17"
        set hGPNPortStreamList3 "$hGPNPort1Stream2 $hGPNPort1Stream3 $hGPNPort1Stream4 $hGPNPort2Stream7 $hGPNPort3Stream8 $hGPNPort4Stream9"
        set hGPNPortStreamList2 "$hGPNPort1Stream1 $hGPNPort1Stream22 $hGPNPort1Stream14\
				$hGPNPort2Stream24 $hGPNPort2Stream26 $hGPNPort2Stream30\
				$hGPNPort3Stream27 $hGPNPort3Stream28 $hGPNPort3Stream31\
				$hGPNPort4Stream16 $hGPNPort4Stream13 $hGPNPort4Stream15"
        set hGPNPortStreamList4 "$hGPNPort1Stream18 $hGPNPort2Stream19 $hGPNPort3Stream20 $hGPNPort4Stream21"
	set hGPNPortStreamList5 "$hGPNPort1Stream1 $hGPNPort1Stream22 $hGPNPort1Stream12 $hGPNPort4Stream16 $hGPNPort4Stream23 $hGPNPort4Stream13 \
				$hGPNPort2Stream24 $hGPNPort2Stream25 $hGPNPort2Stream26 $hGPNPort3Stream27 $hGPNPort3Stream28 $hGPNPort3Stream29"
        ###��ȡ�������ͷ�����ָ��
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
        ###�����շ���Ϣ
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
        ###������������
        foreach stream "$hGPNPortStreamList $hGPNPortStreamList1 $hGPNPortStreamList2 $hGPNPortStreamList4 $hGPNPortStreamList5 $hGPNPort1Stream32 $hGPNPort1Stream33" {
        	stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        	gwd::Cfg_StreamActive $stream "FALSE"
        }
        stc::apply 
        ###��ȡ����������ָ��
        gwd::Get_GeneratorCfgObj $hGPNPort1Gen hGPNPort1GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort2Gen hGPNPort2GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort3Gen hGPNPort3GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort4Gen hGPNPort4GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort5Gen hGPNPort5GenCfg
        set hGPNPortGenCfgList "$hGPNPort1GenCfg $hGPNPort2GenCfg $hGPNPort3GenCfg $hGPNPort4GenCfg $hGPNPort5GenCfg"
        foreach hGenCfg $hGPNPortGenCfgList {
        	gwd::Cfg_GeneratorCfgObj $hGenCfg $GenCfg
        }
        ###���������ù�������Ĭ�Ϲ���tag
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort1Ana hGPNPort1AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort2Ana hGPNPort2AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort3Ana hGPNPort3AnaFrameCfgFil	
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort5Ana hGPNPort5AnaFrameCfgFil
        set hGPNPortAnaFrameCfgFilList "$hGPNPort1AnaFrameCfgFil $hGPNPort2AnaFrameCfgFil $hGPNPort3AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil"
        foreach hCfgFil $hGPNPortAnaFrameCfgFilList {
        	gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $anaFliFrameCfg1
        }
        if {$cap_enable} {
          	###��ȡ������capture������ص�ָ��
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
          	set hGPNPortCapList "$hGPNPort1Cap $hGPNPort2Cap $hGPNPort3Cap $hGPNPort4Cap $hGPNPort5Cap"
          	set hGPNPortCapAnalyzerList "$hGPNPort1CapAnalyzer $hGPNPort2CapAnalyzer $hGPNPort3CapAnalyzer $hGPNPort4CapAnalyzer  $hGPNPort5CapAnalyzer"
        }
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-LAN��Vpls=tag��rawģʽ��ҵ����֤��LSP PW����������֤�������ÿ�ʼ...\n"
	regsub {/} $GPNTestEth1 {_} GPNTestEth1_cap
	regsub {/} $GPNTestEth2 {_} GPNTestEth2_cap
	regsub {/} $GPNTestEth3 {_} GPNTestEth3_cap
	regsub {/} $GPNTestEth4 {_} GPNTestEth4_cap
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
	gwd::GWpublic_print "OK" "��ȡ�豸NE1($gpnIp1)ҵ��忨��λ��$rebootSlotlist1" $fileId
        set rebootSlotList1 [gwd::GWpulic_getWorkCardList $portList1]
	gwd::GWpublic_print "OK" "��ȡ�豸NE1($gpnIp1)�����忨��λ��$rebootSlotList1" $fileId
        set mslot1 [gwd::GWpulic_getWorkCardList $managePort1]
	gwd::GWpublic_print "OK" "��ȡ�豸NE1($gpnIp1)��������ڰ忨��λ��$mslot1" $fileId
	
	
	
        set portlist2 "$GPNPort6 $GPNPort7"
        set portList2 "$GPNTestEth2"
        set portList22 [concat $portlist2 $portList2]
        foreach port $portList22 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "disable" "enable"]
        	}
        }
        set rebootSlotlist2 [gwd::GWpulic_getWorkCardList $portlist2]
	gwd::GWpublic_print "OK" "��ȡ�豸NE2($gpnIp2)ҵ��忨��λ��$rebootSlotlist2" $fileId
        set rebootSlotList2 [gwd::GWpulic_getWorkCardList $portList2]
	gwd::GWpublic_print "OK" "��ȡ�豸NE2($gpnIp2)�����忨��λ��$rebootSlotList2" $fileId
        
	
        set portlist3 "$GPNPort8 $GPNPort9"
        set portList3 "$GPNTestEth3"
        set portList33 [concat $portlist3 $portList3]
        foreach port $portList33 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "disable" "enable"]
        	}
        }
        set rebootSlotlist3 [gwd::GWpulic_getWorkCardList $portlist3]
	gwd::GWpublic_print "OK" "��ȡ�豸NE3($gpnIp3)ҵ��忨��λ��$rebootSlotlist3" $fileId
        set rebootSlotList3 [gwd::GWpulic_getWorkCardList $portList3]
	gwd::GWpublic_print "OK" "��ȡ�豸NE3($gpnIp3)�����忨��λ��$rebootSlotList3" $fileId
	
        set portlist4 "$GPNPort10 $GPNPort11"
        set portList4 "$GPNTestEth4"
        set portList44 [concat $portlist4 $portList4]
        foreach port $portList44 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet4 $matchType4 $Gpn_type4 $fileId $port "disable" "enable"]
        	}
        }
        set rebootSlotlist4 [gwd::GWpulic_getWorkCardList $portlist4]
	gwd::GWpublic_print "OK" "��ȡ�豸NE4($gpnIp4)ҵ��忨��λ��$rebootSlotlist4" $fileId
        set rebootSlotList4 [gwd::GWpulic_getWorkCardList $portList4]
	gwd::GWpublic_print "OK" "��ȡ�豸NE4($gpnIp4)�����忨��λ��$rebootSlotList4" $fileId


        set Portlist "$GPNPort5 $GPNPort12 $GPNPort6 $GPNPort7 $GPNPort8 $GPNPort9 $GPNPort10 $GPNPort11"
        set Portlist0 "$GPNTestEth1 $GPNTestEth2 $GPNTestEth3 $GPNTestEth4"
        set Iplist "$ip612 $ip614 $ip621 $ip623 $ip632 $ip634 $ip643 $ip641"
        ###������ӿ����ò���
        if {[string match "L2" $Worklevel]} {
        	set interface3 v4
        	set interface4 v4
        	set interface5 v5
        	set interface6 v5
        	set interface7 v6
        	set interface8 v6
        	set interface9 v7
        	set interface10 v7
        	set interface11 v500
        	set interface12 v1000
        	set interface13 v500
        	set interface14 v1000
        	set interface15 v500
        	set interface16 v1000
        	set interface17 v500
        	set interface18 v1000
		set interface19 v800
		set interface20 v800
		set interface21 v800
		set interface22 v800
        } else {
        	set interface3 $GPNPort5.4
        	set interface4 $GPNPort6.4
        	set interface5 $GPNPort7.5
        	set interface6 $GPNPort8.5
        	set interface7 $GPNPort9.6
        	set interface8 $GPNPort10.6
        	set interface9 $GPNPort11.7
        	set interface10 $GPNPort12.7
        	set interface11 $GPNTestEth1.500
        	set interface12 $GPNTestEth1.1000
        	set interface13 $GPNTestEth2.500
        	set interface14 $GPNTestEth2.1000
        	set interface15 $GPNTestEth3.500
        	set interface16 $GPNTestEth3.1000
        	set interface17 $GPNTestEth4.500
        	set interface18 $GPNTestEth4.1000
		set interface19 $GPNTestEth1.800
		set interface20 $GPNTestEth2.800
		set interface21 $GPNTestEth3.800
		set interface22 $GPNTestEth4.800
        }
        set Interlist "$interface11 $interface12 $interface13 $interface14 $interface15 $interface16 $interface17 $interface18"
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-LAN��Vpls=tag��rawģʽ��ҵ����֤��LSP PW����������֤�Ļ�������ʧ�ܣ����Խ���" \
			"E-LAN��Vpls=tag��rawģʽ��ҵ����֤��LSP PW����������֤�Ļ������óɹ�����������Ĳ���" "GPN_PTN_006"
	puts $fileId ""
	puts $fileId "===E-LAN��Vpls=tag��rawģʽ��ҵ����֤��LSP PW����������֤�������ý���..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId ""
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 EP-LANҵ������֤-�û������ģʽΪ�˿�ģʽ\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsTypeΪrawģʽ���û������ģʽΪ�˿�ģʽ��֤ELANҵ��  ���Կ�ʼ=====\n"
        set flag1_case1 0
	set flag2_case1 0
	set flag3_case1 0
	set flag4_case1 0
	set flag5_case1 0
	set flag6_case1 0
	set flag7_case1 0
	set flag8_case1 0
	
	set id 1
        foreach {port1 port2} $Portlist telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 {vid1 vid2} $Vlanlist {Ip1 Ip2} $Iplist matchType $lMatchType {
        ###������ӿ����ò���
        	if {[string match "L2" $Worklevel]} {
        		set interface1 v$vid1
        		set interface2 v$vid2
        	} else {
        		set interface1 $port1.$vid1
        		set interface2 $port2.$vid2
        	}

		if {[string match "L2" $Worklevel]} {
			gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port1 "enable"
			gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port2 "enable"
        		gwd::GWpublic_CfgVlanCheck $telnet $matchType $Gpn_type $fileId $eth "disable"
		}
                ###����VLANIF�ӿ�
                PTN_NNI_AddInterIp $fileId $Worklevel $interface1 $Ip1 $port1 $matchType $Gpn_type $telnet
                PTN_NNI_AddInterIp $fileId $Worklevel $interface2 $Ip2 $port2 $matchType $Gpn_type $telnet
                gwd::GWpublic_disableStorm $telnet $matchType $Gpn_type $fileId $eth "bcast"
                gwd::GWpublic_disableStorm $telnet $matchType $Gpn_type $fileId $port1 "bcast"
                gwd::GWpublic_disableStorm $telnet $matchType $Gpn_type $fileId $port2 "bcast"
                ###����vpls
        	gwd::GWVpls_AddInfo $telnet $matchType $Gpn_type $fileId "vpls$id" $id "elan" "flood" "false" "false" "false" "true" "2000" "" "raw"
                incr id
        }

	gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $interface3 $ip621 "100" "100" "normal" "2"
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" $address612
        gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"
        gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $interface10 $ip641 "400" "400" "normal" "4"
        gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" $address614
        gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"
        gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $interface3 $ip621 "500" "500" "normal" "3"
        gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" $address613
        gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"
        ###����pw
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "4000" "4000" "" "delete" "none" 1 0 "0x8100" "0x8100" "4"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "5000" "5000" "" "delete" "none" 1 0 "0x8100" "0x8100" "3"
        ###����ac
        gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "0" "0" "none" "delete" "1" "0" "0" "0x9100" "evc2"
        
        ###����lsp
        gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface4 $ip612 "100" "100" "normal" "1"
        gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
        gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
        gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $interface5 $ip632 "200" "200" "normal" "3"
        gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $address623
        gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
        gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $interface5 $ip632 "700" "700" "normal" "4"
        gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $address624
        gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"
        ###����LSP��ǩ����
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface5 $ip632 "500" "600" "0" 23 "normal"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface4 $ip612 "600" "500" "0" 21 "normal"
        ###����pw
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "1"
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "vpls" "vpls2" "peer" $address623 "2000" "2000" "" "delete" "none" 1 0 "0x8100" "0x8100" "3"
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24" "vpls" "vpls2" "peer" $address624 "6000" "6000" "" "delete" "none" 1 0 "0x8100" "0x8100" "4"
        ###����ac
        gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac1" "vpls2" "" $GPNTestEth2 "0" "0" "none" "delete" "1" "0" "0" "0x9100" "evc2"

        ###����lsp
        gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $interface6 $ip623 "200" "200" "normal" "2"
        gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $address632
        gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
        gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34" $interface7 $ip643 "300" "300" "normal" "4"
        gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34" $address634
        gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34"
        gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $interface6 $ip623 "600" "600" "normal" "1"
        gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $address631
        gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
        ###����LSP��ǩ����
        gwd::GWpublic_createLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $interface6 $ip623 "800" "700" "0" 32 "normal"
        gwd::GWpublic_createLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $interface7 $ip643 "700" "800" "0" 34 "normal"
        ##����pw
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "2000" "2000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw34" "vpls" "vpls3" "peer" $address634 "3000" "3000" "" "delete" "none" 1 0 "0x8100" "0x8100" "4"
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "5000" "5000" "" "delete" "none" 1 0 "0x8100" "0x8100" "1"
        ###����ac
        gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "vpls3" "" $GPNTestEth3 "0" "0" "none" "delete" "1" "0" "0" "0x9100" "evc2"

        ###����lsp
        gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $interface9 $ip614 "400" "400" "normal" "1"
        gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $address641
        gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"
        gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43" $interface8 $ip634 "300" "300" "normal" "3"
        gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43" $address643
        gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43"
        gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42" $interface8 $ip634 "800" "800" "normal" "2"
        gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42" $address642
        gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42"
        ###����pw
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "4000" "4000" "" "delete" "none" 1 0 "0x8100" "0x8100" "1"
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43" "vpls" "vpls4" "peer" $address643 "3000" "3000" "" "delete" "none" 1 0 "0x8100" "0x8100" "3"
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42" "vpls" "vpls4" "peer" $address642 "6000" "6000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
        ###����ac
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac1" "vpls4" "" $GPNTestEth4 "0" "0" "none" "delete" "1" "0" "0" "0x9100" "evc2"
        #####===NE1����unatgδ֪������tag=500����֪������unatg�Ĺ㲥,�鲥������===######
        #####===NE2����tag=500��֪����===######
        #####===NE3����tag=500��֪����===######
        #####===NE4����tag=500����֪������tag=800�Ĺ㲥,�鲥������===######
        foreach stream $hGPNPortStreamList {
        	gwd::Cfg_StreamActive $stream "TRUE"
        }
	incr capId
	if {[PTN_EPRepeatFunc $fileId 0 "" "GPN_PTN_006_$capId"]} {
		set  flag1_case1 1
	}
        
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1�����ۣ�vplsTypeΪrawģʽ���û������ģʽΪ�˿�ģʽ��֤ELANҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1�����ۣ�vplsTypeΪrawģʽ���û������ģʽΪ�˿�ģʽ��֤ELANҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsTypeΪrawģʽ���û������ģʽΪ�˿�ģʽ��֤ELANҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ʹ��PW12�����֣�����NE1��NE2��NE4��NNI���ڷ����Ĳ���MPLS��ǩ  ���Կ�ʼ=====\n"
        foreach stream $hGPNPortStreamList {
        	gwd::Cfg_StreamActive $stream "FALSE"
        }
        foreach stream3 $hGPNPortStreamList3 {
        	gwd::Cfg_StreamActive $stream3 "TRUE"
        }
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg2
        foreach i "GPNPort5Cnt2 GPNPort5Cnt20" {
          	array set $i {cnt7 0 cnt8 0 cnt9 0} 
        }
        ####ʹ��pw�����֣�����NNI��ץ������
        for {set p 12} {$p<=14} {incr p} {
        	gwd::GWpublic_addPwWordEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw$p" "enable"
        }
        
        array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
        gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	stc::apply
        gwd::Start_SendFlow $hGPNPortGenList  "$hGPNPort5Ana"
        after 10000
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt5 2 $hGPNPort5Ana GPNPort5Cnt2]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 0 0 1 0
		after 5000
	}
        
        parray GPNPort5Cnt2
        gwd::Stop_SendFlow $hGPNPortGenList  "$hGPNPort5Ana"
        gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
        array set aMirror "dir1 egress port1 $GPNPort12 dir2 \"\" port2 \"\""
        gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
        gwd::Start_SendFlow $hGPNPortGenList  "$hGPNPort5Ana"
        after 10000
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt5 2 $hGPNPort5Ana GPNPort5Cnt20]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 0 0 1 0
		after 5000
	}
        parray GPNPort5Cnt20
        gwd::Stop_SendFlow $hGPNPortGenList  "$hGPNPort5Ana"
	if {$GPNPort5Cnt2(cnt7) < $rateL1 || $GPNPort5Cnt2(cnt7) > $rateR1} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)��NE2($gpnIp2)���෢��tag=500����֪������������NE1($gpnIp1)$GPNTestEth5�ھ���NNI��$GPNPort5\
			�յ���mpls���ĵ�lsp��ǩ=100��pw��ǩ=1000������������Ϊ$GPNPort5Cnt2(cnt7)��û��$::rateL1-$::rateR1\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)��NE2($gpnIp2)���෢��tag=500����֪������������NE1($gpnIp1)$GPNTestEth5�ھ���NNI��$GPNPort5\
			�յ���mpls���ĵ�lsp��ǩ=100��pw��ǩ=1000������������Ϊ$GPNPort5Cnt2(cnt7)����$::rateL1-$::rateR1\��Χ��" $fileId
	}
	if {$GPNPort5Cnt2(cnt8) < $rateL1 || $GPNPort5Cnt2(cnt8) > $rateR1} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)��NE3($gpnIp3)���෢��tag=500����֪������������NE1($gpnIp1)$GPNTestEth5�ھ���NNI��$GPNPort5\
			�յ���mpls���ĵ�lsp��ǩ=500��pw��ǩ=5000������������Ϊ$GPNPort5Cnt2(cnt8)��û��$rateL1-$rateR1\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)��NE3($gpnIp3)���෢��tag=500����֪������������NE1($gpnIp1)$GPNTestEth5�ھ���NNI��$GPNPort5\
			�յ���mpls���ĵ�lsp��ǩ=500��pw��ǩ=5000������������Ϊ$GPNPort5Cnt2(cnt8)����$rateL1-$rateR1\��Χ��" $fileId
	}
	if {$GPNPort5Cnt20(cnt9) < $rateL1 || $GPNPort5Cnt20(cnt9) > $rateR1} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)��NE4($gpnIp4)���෢��tag=500����֪������������NE1($gpnIp1)$GPNTestEth5�ھ���NNI��$GPNPort12\
			�յ���mpls���ĵ�lsp��ǩ=400��pw��ǩ=4000������������Ϊ$GPNPort5Cnt20(cnt9)��û��$rateL1-$rateR1\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)��NE4($gpnIp4)���෢��tag=500����֪������������NE1($gpnIp1)$GPNTestEth5�ھ���NNI��$GPNPort12\
			�յ���mpls���ĵ�lsp��ǩ=400��pw��ǩ=4000������������Ϊ$GPNPort5Cnt20(cnt9)����$rateL1-$rateR1\��Χ��" $fileId
	}
        gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2�����ۣ�����NE1($gpnIp1)��NE2($gpnIp2)��NE4($gpnIp4)��NNI���ڷ����Ĳ���MPLS��ǩ" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2�����ۣ�����NE1($gpnIp1)��NE2($gpnIp2)��NE4($gpnIp4)��NNI���ڷ����Ĳ���MPLS��ǩ" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ʹ��PW12�����֣�����NE1($gpnIp1)��NE2($gpnIp2)��NE4($gpnIp4)��NNI���ڷ����Ĳ���MPLS��ǩ  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ʹ��lsp��pw��ac������ͳ�ƣ���������ͳ�Ƶ�׼ȷ��  ���Կ�ʼ=====\n"
        foreach stream3 $hGPNPortStreamList3 {
        	gwd::Cfg_StreamActive $stream3 "FALSE"
        }
        ####ʹ���豸lsp��pw��ac������ͳ�ƣ���֤
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" "enable"
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "enable"
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" "enable"
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "enable"
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" "enable"
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "enable"
        gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "enable"
	
	if {[PTN_EVP_State $telnet1 $matchType1 $Gpn_type1 $fileId "$hGPNPort1Stream2 $hGPNPort2Stream7" \
			$GPNTestEth1 "lsp12" "pw12" "ac1" $hGPNPort1Ana $hGPNPort1Gen]} {
		set flag3_case1 1
	}
	if {[PTN_EVP_State $telnet1 $matchType1 $Gpn_type1 $fileId "$hGPNPort1Stream3 $hGPNPort3Stream8" \
			$GPNTestEth1 "lsp13" "pw13" "ac1" $hGPNPort1Ana $hGPNPort1Gen]} {
		set flag3_case1 1
	}
	if {[PTN_EVP_State $telnet1 $matchType1 $Gpn_type1 $fileId "$hGPNPort1Stream4 $hGPNPort4Stream9" \
			$GPNTestEth1 "lsp14" "pw14" "ac1" $hGPNPort1Ana $hGPNPort1Gen]} {
		set flag3_case1 1
	}
	
	
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
	 	gwd::GWpublic_print "NOK" "FA3�����ۣ�NE1($gpnIp1)ʹ��lsp��pw��ac������ͳ�ƣ���������ͳ�Ƶ�׼ȷ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3�����ۣ�NE1($gpnIp1)ʹ��lsp��pw��ac������ͳ�ƣ���������ͳ�Ƶ�׼ȷ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ʹ��lsp��pw��ac������ͳ�ƣ���������ͳ�Ƶ�׼ȷ��  ���Խ���=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)����shut undoshut NNI�ں󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
        ##ȥʹ���豸lsp��pw��ac������ͳ��
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" "disable"
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "disable"
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" "disable"
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "disable"
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" "disable"
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "disable"
        gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "disable"
       
        foreach stream $hGPNPortStreamList {
        	gwd::Cfg_StreamActive $stream "TRUE"
        }
	##����undo shutdown/shutdown�˿�
	foreach eth $portlist1 {
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
        		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
        		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
          		after $WaiteTime
			incr capId
        		if {[PTN_EPRepeatFunc $fileId 0 "��$j\��shutdown/undo shutdown NE1($gpnIp1)��$eth\�˿ں�" "GPN_PTN_006_$capId"]} {
        			set  flag4_case1 1
        		}
        	}
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
        	send_log "\n resource1:$resource1"
        	send_log "\n resource2:$resource2"
        	if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
        		set flag4_case1 1
        		gwd::GWpublic_print "NOK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
        	}
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA4�����ۣ�NE1($gpnIp1)����shut undoshut NNI�ں󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4�����ۣ�NE1($gpnIp1)����shut undoshut NNI�ں󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)����shut undoshut NNI�ں󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
        ###��������NNI�����ڰ忨
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
        			if {[PTN_EPRepeatFunc $fileId 0 "��$j\������NE1($gpnIp1)$slot\��λ�忨" "GPN_PTN_006_$capId"]} {
        				set  flag5_case1 1
        			}
        		} else {
                		set testFlag 1
                		gwd::GWpublic_print "OK" " NE1($gpnIp1)$slot\��λ�忨��֧�ְ忨������������������" $fileId
                		break
        		}
        	}
        	if {$testFlag == 0} {
        		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
        		send_log "\n resource3:$resource3"
        		send_log "\n resource4:$resource4"
        		if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
        			set flag5_case1 1
        			gwd::GWpublic_print "NOK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
        		}
        	}
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA5�����ۣ�NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5�����ۣ�NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ棬����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	set expectTable "0000.0000.0006 ac1 0000.0000.0005 ac1 0000.0000.0004 ac1 0000.0000.0003 ac1 0000.0000.0002 ac1 0000.0000.0001 ac1\
			0000.0000.0044 pw14 0000.0000.000A pw14 0000.0000.000B pw14 0000.0000.0022 pw12 0000.0000.0033 pw13"
	###��������NMS��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
        for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
        		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_EPRepeatFunc $fileId 0 "��$j\�� NE1($gpnIp1)����NMS��������" "GPN_PTN_006_$capId"]} {
				set  flag6_case1 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable $expectTable]} {
				set flag6_case1 1
			}
        	} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag 1
			break
        	}
        }
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource6
		send_log "\n resource5:$resource5"
		send_log "\n resource6:$resource6"
		if {$resource6 > [expr $resource5 + $resource5 * $errRate]} {
			set flag6_case1	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
		}
	}
        puts $fileId ""
        if {$flag6_case1 == 1} {
        	set flagCase1 1
        	 gwd::GWpublic_print "NOK" "FA6�����ۣ�NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA6�����ۣ�NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ棬����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
        ##��������SW��������
	set testFlag 0 ;#=1 ��������
        gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
        for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
        		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_EPRepeatFunc $fileId 0 "��$j\�� NE1($gpnIp1)����SW��������" "GPN_PTN_006_$capId"]} {
				set  flag7_case1 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����SW����������" $dTable $expectTable]} {
				set flag7_case1 1
			}
        	} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag 1 ;#=1 ��������
			break
        	}
        }
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource8
		send_log "\n resource7:$resource7"
		send_log "\n resource8:$resource8"
		if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
			set flag7_case1	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag7_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA7�����ۣ�NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7�����ۣ�NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ棬����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
        ##���������豸����
        gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
        for {set j 1} {$j<=$cnt} {incr j} {
        	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
        	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
        	after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[PTN_EPRepeatFunc $fileId 0 "��$j\�� NE1($gpnIp1)���б����豸������" "GPN_PTN_006_$capId"]} {
			set  flag8_case1 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
		if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)���б����豸������" $dTable $expectTable]} {
			set flag8_case1 1
		}
        }
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag8_case1	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag8_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA8�����ۣ�NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8�����ۣ�NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ棬����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase1 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 1���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 1���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 1 EP-LANҵ������֤-�û������ģʽΪ�˿�ģʽ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 ELANҵ������֤��vplsΪrawģʽ���û������ģʽΪ���˿�+��Ӫ��VLAN��\n"
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0

	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ�������豸�ϵ�ר��ҵ��AC������ҵ���Ƿ��ж�  ���Կ�ʼ=====\n"
	
        ##ɾ��ac
        foreach telnet $lSpawn_id Gpn_type $lDutType matchType $lMatchType {
        	gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac1"
        }
        ####=======��֤������ת��===========####
	incr capId
	if {[PTN_EPRepeatFunc $fileId 1 "ɾ�������豸�ϵ�ר��ҵ��AC��" "GPN_PTN_006_$capId"]} {
		set  flag1_case2 1
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA9�����ۣ�ɾ�������豸�ϵ�ר��ҵ��AC������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9�����ۣ�ɾ�������豸�ϵ�ר��ҵ��AC������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ�������豸�ϵ�ר��ҵ��AC������ҵ���Ƿ��ж�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlpsΪrawģʽ������ģʽ��Ϊ���˿�+��Ӫ��VLAN��ģʽ����֤ҵ��ת��  ���Կ�ʼ=====\n" 
        foreach stream $hGPNPortStreamList {
        	gwd::Cfg_StreamActive $stream "FALSE"
        }
	gwd::Cfg_StreamActive $hGPNPort1Stream2 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort1Stream12 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream9 "TRUE"
	gwd::Cfg_StreamActive $hGPNPort4Stream13 "TRUE"
        set id2 1
        foreach eth $Portlist0 telnet $lSpawn_id Gpn_type $lDutType matchType $lMatchType {
		if {[string match "L2" $Worklevel]} {
        		gwd::GWpublic_CfgVlanCheck $telnet $matchType $Gpn_type $fileId $eth "enable"
		}
                ##�û������vlan
                PTN_UNI_AddInter $telnet $matchType $Gpn_type $fileId $Worklevel "800" $eth
                PTN_UNI_AddInter $telnet $matchType $Gpn_type $fileId $Worklevel "500" $eth
                #����ac
                gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac800" "vpls$id2" "" $eth "800" "0" "none" "modify" "800" "0" "0" "0x8100" "evc2"
                incr id2
        }
	incr capId
	SendAndStat_ptn006 1 "$hGPNPort1Gen $hGPNPort4Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
			$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
			$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_006_$capId"
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#DEV1 GPNTestEth1�Ľ��ռ�� 
	if {$GPNPort1Cnt1(cnt44) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=500��δ֪������������NE1($::gpnIp1)\
			$::GPNTestEth1\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt44)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=500��δ֪������������NE1($::gpnIp1)\
			$::GPNTestEth1\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt44)" $fileId
	}
	if {$GPNPort1Cnt1(cnt13) < $rateL || $GPNPort1Cnt1(cnt13) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE1($::gpnIp1)\
			$::GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt13)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE1($::gpnIp1)\
			$::GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt13)����$::rateL-$::rateR\��Χ��" $fileId
	}
	#DEV2 GPNTestEth2�Ľ��ռ�� 
	if {$GPNPort2Cnt1(cnt44) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=500��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt44)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=500��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt44)" $fileId
	}
	if {$GPNPort2Cnt1(cnt13) < $rateL || $GPNPort2Cnt1(cnt13) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt13)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt13)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt1(cnt2) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt2)" $fileId
	}
	if {$GPNPort2Cnt1(cnt12) < $rateL || $GPNPort2Cnt1(cnt12) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=800��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=800��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
	}
	#DEV3 GPNTestEth3�Ľ��ռ�� 
	if {$GPNPort3Cnt1(cnt44) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=500��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt44)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=500��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt44)" $fileId
	}
	if {$GPNPort3Cnt1(cnt13) < $rateL || $GPNPort3Cnt1(cnt13) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt13)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt13)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt1(cnt2) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt2)" $fileId
	}
	if {$GPNPort3Cnt1(cnt12) < $rateL || $GPNPort3Cnt1(cnt12) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=800��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=800��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
	}
	#DEV4 GPNTestEth4�Ľ��ռ�� 
	if {$GPNPort4Cnt1(cnt2) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE4($::gpnIp4)\
			$::GPNTestEth4\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE4($::gpnIp4)\
			$::GPNTestEth4\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt2)" $fileId
	}
	if {$GPNPort4Cnt1(cnt12) < $rateL || $GPNPort4Cnt1(cnt12) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=800��δ֪������������NE4($::gpnIp4)\
			$::GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=800��δ֪������������NE4($::gpnIp4)\
			$::GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB1�����ۣ�vlpsΪrawģʽ������ģʽ��Ϊ���˿�+��Ӫ��VLAN��ģʽ����֤ҵ��ת��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1�����ۣ�vlpsΪrawģʽ������ģʽ��Ϊ���˿�+��Ӫ��VLAN��ģʽ����֤ҵ��ת��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlpsΪrawģʽ������ģʽ��Ϊ���˿�+��Ӫ��VLAN��ģʽ����֤ҵ��ת��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlpsΪrawģʽ������ģʽ��Ϊ���˿�+��Ӫ��VLAN��ģʽ��δʹ��overlay����ʱҵ�����  ���Կ�ʼ=====\n"
	gwd::Cfg_StreamActive $hGPNPort1Stream2 "false"
	gwd::Cfg_StreamActive $hGPNPort1Stream12 "false"
	gwd::Cfg_StreamActive $hGPNPort4Stream9 "false"
	gwd::Cfg_StreamActive $hGPNPort4Stream13 "false"
	foreach stream4 $hGPNPortStreamList4 {
        	gwd::Cfg_StreamActive $stream4 "TRUE"
        }
	
	incr capId
	SendAndStat_ptn006 1 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_006_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#DEV1 GPNTestEth1�Ľ��ռ�� 
	if {$GPNPort1Cnt1(cnt62) < $rateL || $GPNPort1Cnt1(cnt62) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "flag3_case2δʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=800��mpls��������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt62)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=800��mpls��������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt62)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt1(cnt63) < $rateL || $GPNPort1Cnt1(cnt63) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE3($gpnIp3)$GPNTestEth3\����tag=800��mpls��������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt63)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE3($gpnIp3)$GPNTestEth3\����tag=800��mpls��������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt63)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt1(cnt64) < $rateL || $GPNPort1Cnt1(cnt64) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=800��mpls��������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt64)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=800��mpls��������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt64)����$rateL-$rateR\��Χ��" $fileId
	}
	#DEV2 GPNTestEth2�Ľ��ռ�� 
	if {$GPNPort2Cnt1(cnt61) < $rateL || $GPNPort2Cnt1(cnt61) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=800��mpls��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt61)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=800��mpls��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt61)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt1(cnt63) < $rateL || $GPNPort2Cnt1(cnt63) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE3($gpnIp3)$GPNTestEth3\����tag=800��mpls��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt63)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE3($gpnIp3)$GPNTestEth3\����tag=800��mpls��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt63)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt1(cnt64) < $rateL || $GPNPort2Cnt1(cnt64) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=800��mpls��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt64)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=800��mpls��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt64)����$rateL-$rateR\��Χ��" $fileId
	}
	#DEV3 GPNTestEth3�Ľ��ռ�� 
	if {$GPNPort3Cnt1(cnt61) < $rateL || $GPNPort3Cnt1(cnt61) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=800��mpls��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt61)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=800��mpls��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt61)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt1(cnt62) < $rateL || $GPNPort3Cnt1(cnt62) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=800��mpls��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt62)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=800��mpls��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt62)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt1(cnt64) < $rateL || $GPNPort3Cnt1(cnt64) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=800��mpls��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt64)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=800��mpls��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt64)����$rateL-$rateR\��Χ��" $fileId
	}	
	#DEV4 GPNTestEth4�Ľ��ռ�� 
	if {$GPNPort4Cnt1(cnt61) < $rateL || $GPNPort4Cnt1(cnt61) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=800��mpls��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt61)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=800��mpls��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt61)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt1(cnt62) < $rateL || $GPNPort4Cnt1(cnt62) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=800��mpls��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt62)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=800��mpls��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt62)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt1(cnt63) < $rateL || $GPNPort4Cnt1(cnt63) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE3($gpnIp3)$GPNTestEth3\����tag=800��mpls��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt63)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE3($gpnIp3)$GPNTestEth3\����tag=800��mpls��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt63)����$rateL-$rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB2�����ۣ�vlpsΪrawģʽ������ģʽ��Ϊ���˿�+��Ӫ��VLAN��ģʽ��δʹ��overlay����ʱҵ�����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2�����ۣ�vlpsΪrawģʽ������ģʽ��Ϊ���˿�+��Ӫ��VLAN��ģʽ��δʹ��overlay����ʱҵ�����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlpsΪrawģʽ������ģʽΪ���˿�+��Ӫ��VLAN��ģʽ��δʹ��overlay����ʱҵ�����  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlpsΪrawģʽ������ģʽΪ���˿�+��Ӫ��VLAN��ģʽ��ʹ��overlay����ʱҵ�����  ���Կ�ʼ=====\n"
        gwd::GWpublic_addOverLay $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "enable"
        gwd::GWpublic_addOverLay $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "enable"
        gwd::GWpublic_addOverLay $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "enable"
        gwd::GWpublic_addOverLay $telnet4 $matchType4 $Gpn_type4 $fileId $GPNTestEth4 "enable"
	incr capId
	SendAndStat_ptn006 1 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_006_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
        #DEV1 GPNTestEth1�Ľ��ռ�� 
        if {$GPNPort1Cnt1(cnt62) < $rateL || $GPNPort1Cnt1(cnt62) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=800��mpls��������NE1($gpnIp1)\
        		$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt62)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=800��mpls��������NE1($gpnIp1)\
        		$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt62)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$GPNPort1Cnt1(cnt63) < $rateL || $GPNPort1Cnt1(cnt63) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE3($gpnIp3)$GPNTestEth3\����tag=800��mpls��������NE1($gpnIp1)\
        		$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt63)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE3($gpnIp3)$GPNTestEth3\����tag=800��mpls��������NE1($gpnIp1)\
        		$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt63)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$GPNPort1Cnt1(cnt64) < $rateL || $GPNPort1Cnt1(cnt64) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=800��mpls��������NE1($gpnIp1)\
        		$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt64)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=800��mpls��������NE1($gpnIp1)\
        		$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt64)����$rateL-$rateR\��Χ��" $fileId
        }
        #DEV2 GPNTestEth2�Ľ��ռ�� 
        if {$GPNPort2Cnt1(cnt61) < $rateL || $GPNPort2Cnt1(cnt61) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=800��mpls��������NE2($gpnIp2)\
        		$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt61)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=800��mpls��������NE2($gpnIp2)\
        		$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt61)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$GPNPort2Cnt1(cnt63) < $rateL || $GPNPort2Cnt1(cnt63) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE3($gpnIp3)$GPNTestEth3\����tag=800��mpls��������NE2($gpnIp2)\
        		$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt63)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE3($gpnIp3)$GPNTestEth3\����tag=800��mpls��������NE2($gpnIp2)\
        		$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt63)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$GPNPort2Cnt1(cnt64) < $rateL || $GPNPort2Cnt1(cnt64) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=800��mpls��������NE2($gpnIp2)\
        		$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt64)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=800��mpls��������NE2($gpnIp2)\
        		$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt64)����$rateL-$rateR\��Χ��" $fileId
        }
        #DEV3 GPNTestEth3�Ľ��ռ�� 
        if {$GPNPort3Cnt1(cnt61) < $rateL || $GPNPort3Cnt1(cnt61) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=800��mpls��������NE3($gpnIp3)\
        		$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt61)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=800��mpls��������NE3($gpnIp3)\
        		$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt61)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$GPNPort3Cnt1(cnt62) < $rateL || $GPNPort3Cnt1(cnt62) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=800��mpls��������NE3($gpnIp3)\
        		$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt62)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=800��mpls��������NE3($gpnIp3)\
        		$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt62)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$GPNPort3Cnt1(cnt64) < $rateL || $GPNPort3Cnt1(cnt64) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=800��mpls��������NE3($gpnIp3)\
        		$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt64)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=800��mpls��������NE3($gpnIp3)\
        		$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt64)����$rateL-$rateR\��Χ��" $fileId
        }	
        #DEV4 GPNTestEth4�Ľ��ռ�� 
        if {$GPNPort4Cnt1(cnt61) < $rateL || $GPNPort4Cnt1(cnt61) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=800��mpls��������NE4($gpnIp4)\
        		$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt61)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=800��mpls��������NE4($gpnIp4)\
        		$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt61)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$GPNPort4Cnt1(cnt62) < $rateL || $GPNPort4Cnt1(cnt62) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=800��mpls��������NE4($gpnIp4)\
        		$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt62)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=800��mpls��������NE4($gpnIp4)\
        		$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt62)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$GPNPort4Cnt1(cnt63) < $rateL || $GPNPort4Cnt1(cnt63) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE3($gpnIp3)$GPNTestEth3\����tag=800��mpls��������NE4($gpnIp4)\
        		$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt63)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE3($gpnIp3)$GPNTestEth3\����tag=800��mpls��������NE4($gpnIp4)\
        		$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt63)����$rateL-$rateR\��Χ��" $fileId
        }
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB3�����ۣ�vlpsΪrawģʽ������ģʽ��Ϊ���˿�+��Ӫ��VLAN��ģʽ��ʹ��overlay����ʱҵ�����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3�����ۣ�vlpsΪrawģʽ������ģʽ��Ϊ���˿�+��Ӫ��VLAN��ģʽ��ʹ��overlay����ʱҵ�����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlpsΪrawģʽ������ģʽΪ���˿�+��Ӫ��VLAN��ģʽ��ʹ��overlay����ʱҵ�����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase2 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 2���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 2���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 2 ELANҵ������֤��vplsΪrawģʽ���û������ģʽΪ���˿�+��Ӫ��VLAN  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 ELANҵ������֤��vplsΪrawģʽ���û������ģʽΪ���˿ںͶ˿�+��Ӫ��VLAN����ģʽ����֤ҵ��\n"
	set flag1_case3 0
	gwd::GWpublic_addOverLay $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "disable"
	gwd::GWpublic_addOverLay $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "disable"
	gwd::GWpublic_addOverLay $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "disable"
	gwd::GWpublic_addOverLay $telnet4 $matchType4 $Gpn_type4 $fileId $GPNTestEth4 "disable"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "disable"
	}
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "0" "0" "none" "delete" "1" "0" "0" "0x8100" "evc2"
	
	foreach stream4 $hGPNPortStreamList4 {
		gwd::Cfg_StreamActive $stream4 "false"
	}
	gwd::Cfg_StreamActive $hGPNPort1Stream1 "true"  ;#untagδ֪����
	gwd::Cfg_StreamActive $hGPNPort1Stream22 "true"  ;#tag=500δ֪����
	gwd::Cfg_StreamActive $hGPNPort1Stream12 "true" ;#tag=800δ֪����
	gwd::Cfg_StreamActive $hGPNPort4Stream16 "true" ;#untagδ֪����
	gwd::Cfg_StreamActive $hGPNPort4Stream23 "true"  ;#tag=500δ֪����
	gwd::Cfg_StreamActive $hGPNPort4Stream13 "true" ;#tag=800δ֪����
	incr capId	
	SendAndStat_ptn006 1 "$hGPNPort1Gen $hGPNPort4Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_006_$capId"
	SendAndStat_ptn006 0 "$hGPNPort1Gen $hGPNPort4Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $anaFliFrameCfg0 "GPN_PTN_006_$capId"
	SendAndStat_ptn006 0 "$hGPNPort1Gen $hGPNPort4Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt2 GPNPort2Cnt2 GPNPort3Cnt2 GPNPort4Cnt2 6 $anaFliFrameCfg6 "GPN_PTN_006_$capId"
	SendAndStat_ptn006 0 "$hGPNPort1Gen $hGPNPort4Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 7 $anaFliFrameCfg7 "GPN_PTN_006_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_006_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE1����untag��tag=500��tag=800��δ֪����  ��NE4����untag��tag=500��tag=800��δ֪����  
	#DEV1 GPNTestEth1�Ľ��ռ�� 
	if {$GPNPort1Cnt0(cnt01) !=0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����untag��δ֪������������NE1($::gpnIp1)\
			$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt01)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����untag��δ֪������������NE1($::gpnIp1)\
			$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt01)" $fileId
	}
	if {$GPNPort1Cnt0(cnt51) !=0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=500��δ֪������������NE1($::gpnIp1)\
			$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt51)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=500��δ֪������������NE1($::gpnIp1)\
			$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt51)" $fileId
	}
	if {$GPNPort1Cnt7(cnt48) < $rateL || $GPNPort1Cnt7(cnt48) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE1($::gpnIp1)\
			$::GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt48)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE1($::gpnIp1)\
			$::GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt48)����$::rateL-$::rateR\��Χ��" $fileId
	}
	
	#DEV2 GPNTestEth2�Ľ��ռ�� 
	if {$GPNPort2Cnt0(cnt01) !=0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����untag��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt01)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����untag��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt01)" $fileId
	}
	if {$GPNPort2Cnt0(cnt51) !=0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=500��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt51)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=500��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt51)" $fileId
	}
	if {$GPNPort2Cnt1(cnt13) < $rateL || $GPNPort2Cnt1(cnt13) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt13)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt13)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt1(cnt81) < $rateL || $GPNPort2Cnt1(cnt81) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt81)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt81)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt2(cnt12) < $rateL || $GPNPort2Cnt2(cnt12) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ��ڲ�tag=500 ���tag=800��������������Ϊ$GPNPort2Cnt2(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ��ڲ�tag=500 ���tag=800��������������Ϊ$GPNPort2Cnt2(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt2(cnt14) < $rateL || $GPNPort2Cnt2(cnt14) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=800��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ��ڲ�tag=800 ���tag=800��������������Ϊ$GPNPort2Cnt2(cnt14)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=800��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ��ڲ�tag=800 ���tag=800��������������Ϊ$GPNPort2Cnt2(cnt14)����$::rateL-$::rateR\��Χ��" $fileId
	}
	#DEV3 GPNTestEth3�Ľ��ռ��
	if {$GPNPort3Cnt0(cnt01) !=0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����untag��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt01)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����untag��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt01)" $fileId
	}
	if {$GPNPort3Cnt0(cnt51) !=0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=500��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt44)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=500��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt44)" $fileId
	}
	if {$GPNPort3Cnt1(cnt13) < $rateL || $GPNPort3Cnt1(cnt13) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt13)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\����tag=800��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt13)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt1(cnt81) < $rateL || $GPNPort3Cnt1(cnt81) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt81)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt81)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt2(cnt12) < $rateL || $GPNPort3Cnt2(cnt12) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ��ڲ�tag=500 ���tag=800��������������Ϊ$GPNPort3Cnt2(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ��ڲ�tag=500 ���tag=800��������������Ϊ$GPNPort3Cnt2(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt2(cnt14) < $rateL || $GPNPort3Cnt2(cnt14) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=800��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ��ڲ�tag=800 ���tag=800��������������Ϊ$GPNPort3Cnt2(cnt14)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=800��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ��ڲ�tag=800 ���tag=800��������������Ϊ$GPNPort3Cnt2(cnt14)����$::rateL-$::rateR\��Χ��" $fileId
	}
	#DEV4 GPNTestEth4�Ľ��ռ�� 
	if {$GPNPort4Cnt1(cnt81) < $rateL || $GPNPort4Cnt1(cnt81) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE4($::gpnIp4)\
			$::GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt81)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE4($::gpnIp4)\
			$::GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt81)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt2(cnt12) < $rateL || $GPNPort4Cnt2(cnt12) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE4($::gpnIp4)\
			$::GPNTestEth4\�յ��ڲ�tag=500 ���tag=800��������������Ϊ$GPNPort4Cnt2(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=500��δ֪������������NE4($::gpnIp4)\
			$::GPNTestEth4\�յ��ڲ�tag=500 ���tag=800��������������Ϊ$GPNPort4Cnt2(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt2(cnt14) < $rateL || $GPNPort4Cnt2(cnt14) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=800��δ֪������������NE4($::gpnIp4)\
			$::GPNTestEth4\�յ��ڲ�tag=800 ���tag=800��������������Ϊ$GPNPort4Cnt2(cnt14)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\����tag=800��δ֪������������NE4($::gpnIp4)\
			$::GPNTestEth4\�յ��ڲ�tag=800 ���tag=800��������������Ϊ$GPNPort4Cnt2(cnt14)����$::rateL-$::rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag1_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB4�����ۣ�vplsΪrawģʽ���û������ģʽΪ���˿ںͶ˿�+��Ӫ��VLAN����ģʽ����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4�����ۣ�vplsΪrawģʽ���û������ģʽΪ���˿ںͶ˿�+��Ӫ��VLAN����ģʽ����֤ҵ��" $fileId
	}
	puts $fileId ""
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	if {$flagCase3 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 3���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 3���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 3 ELANҵ������֤��vplsΪrawģʽ���û������ģʽΪ���˿ںͶ˿�+��Ӫ��VLAN����ģʽ����֤ҵ��  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 ELANҵ������֤��vplsΪtagģʽ��֤ҵ��\n"
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set flag5_case4 0
	set flag6_case4 0
	set flag7_case4 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlpsΪtagģʽ������ģʽΪ���˿ںͶ˿�+��Ӫ��VLAN������ģʽ����֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24"
	gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls2"
	
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw34"
	gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3"
	
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43"
	gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls4"

        ########========vplsΪtagged����==========#########
        set vplstype "tagged"
        ##����vpls
        gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11" "11" "elan" "flood" "false" "false" "false" "true" "2000" "" "tagged"
        ###����pw
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw120" "vpls" "vpls11" "peer" $address612 "101" "101" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw140" "vpls" "vpls11" "peer" $address614 "401" "401" "" "add" "none" 1 0 "0x8100" "0x8100" "4"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw130" "vpls" "vpls11" "peer" $address613 "51" "51" "" "add" "none" 1 0 "0x8100" "0x8100" "3"
        ###����ac
        gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls11" "" $GPNTestEth1 "0" "0" "none" "delete" "1" "0" "0" "0x8100" "evc2"
        
        ##����vpls
        gwd::GWVpls_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls12" "12" "elan" "flood" "false" "false" "false" "true" "2000" "" "tagged"
        ###����pw
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw210" "vpls" "vpls12" "peer" $address621 "101" "101" "" "add" "none" 1 0 "0x8100" "0x8100" "1"
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw230" "vpls" "vpls12" "peer" $address623 "201" "201" "" "add" "none" 1 0 "0x8100" "0x8100" "3"
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw240" "vpls" "vpls12" "peer" $address624 "61" "61" "" "add" "none" 1 0 "0x8100" "0x8100" "4"
        ###����ac
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "disable"
	}
        gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac1" "vpls12" "" $GPNTestEth2 "0" "0" "none" "delete" "1" "0" "0" "0x8100" "evc2"
        
        ##����vpls
        gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls13" "13" "elan" "flood" "false" "false" "false" "true" "2000" "" "tagged"
        ##����pw
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw320" "vpls" "vpls13" "peer" $address632 "201" "201" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw340" "vpls" "vpls13" "peer" $address634 "301" "301" "" "add" "none" 1 0 "0x8100" "0x8100" "4"
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw310" "vpls" "vpls13" "peer" $address631 "51" "51" "" "add" "none" 1 0 "0x8100" "0x8100" "1"
        ###����ac
        gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "vpls13" "" $GPNTestEth3 "500" "0" "none" "modify" "500" "0" "0" "0x8100" "evc2"
        
        ##����vpls
        gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls14" "14" "elan" "flood" "false" "false" "false" "true" "2000" "" "tagged"
        ###����pw
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw410" "vpls" "vpls14" "peer" $address641 "401" "401" "" "add" "none" 1 0 "0x8100" "0x8100" "1"
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw430" "vpls" "vpls14" "peer" $address643 "301" "301" "" "add" "none" 1 0 "0x8100" "0x8100" "3"
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw420" "vpls" "vpls14" "peer" $address642 "61" "61" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
        gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac1" "vpls14" "" $GPNTestEth4 "800" "0" "none" "modify" "800" "0" "0" "0x8100" "evc2"

	stc::perform streamBlockActivate -streamBlockList "$hGPNPort1Stream1 $hGPNPort1Stream22 $hGPNPort1Stream12 \
			$hGPNPort4Stream16 $hGPNPort4Stream23 $hGPNPort4Stream13" -activate "false"
	stc::perform streamBlockActivate -streamBlockList $hGPNPortStreamList5 -activate "true"
	#NE1 NE2 NE3 NE4����untag��tag=500��tag=800��δ֪����
	incr capId
	if {[TestVplsTag $fileId "" $rateL2 $rateR2 "GPN_PTN_006_$capId"]} {
		set flag1_case4 1
	}
	puts $fileId ""
	if {$flag1_case4 == 1} {
		set flagCase4 1
	 	gwd::GWpublic_print "NOK" "FB5�����ۣ�vlpsΪtagģʽ������ģʽΪ���˿ںͶ˿�+��Ӫ��VLAN������ģʽ����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5�����ۣ�vlpsΪtagģʽ������ģʽΪ���˿ںͶ˿�+��Ӫ��VLAN������ģʽ����֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlpsΪtagģʽ������ģʽΪ���˿ںͶ˿�+��Ӫ��VLAN������ģʽ����֤ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)����shut undoshut NNI�ں󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	##����undo shutdown/shutdown�˿�
	foreach eth $portlist1 {
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
        		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
        		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
          		after $WaiteTime
			incr capId
			if {[TestVplsTag $fileId "��$j\��undo shutdown/shutdown NE1($gpnIp1)��$eth\�˿�" $rateL2 $rateR2 "GPN_PTN_006_$capId"]} {
				set flag2_case4 1
			}
        	}
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag2_case4	1
			gwd::GWpublic_print "NOK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag2_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FB6�����ۣ�NE1($gpnIp1)����shut undoshut NNI�ں󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6�����ۣ�NE1($gpnIp1)����shut undoshut NNI�ں󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)����shut undoshut NNI�ں󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	###��������NNI�����ڰ忨
	foreach slot $rebootSlotlist1 {
		set testFlag 0 ;#=1 �忨��֧�������������������� 
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource3
          	for {set j 1} {$j<=$cnt} {incr j} {
			if {![gwd::GWCard_AddReboot $telnet1 $matchType1 $Gpn_type1 $fileId $slot]} {
          			after $rebootBoardTime
          			if {[string match $mslot1 $slot]} {
        				set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
					set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
            			}
				incr capId
				if {[TestVplsTag $fileId "��$j\������NE1($gpnIp1)$slot\��λ�忨��" $rateL2 $rateR2 "GPN_PTN_006_$capId"]} {
					set flag3_case4 1
				}
			} else {
                		gwd::GWpublic_print "OK" $fileId "$matchType1\��֧��$slot\��λ�忨������������������" $fileId
                		set testFlag 1
        			break
			}
        	}
		if {$testFlag == 0} {
			gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
			send_log "\n resource3:$resource3"
			send_log "\n resource4:$resource4"
			if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
				set flag3_case4	1
				gwd::GWpublic_print "NOK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
			} 
		}     
	}
	puts $fileId ""
	if {$flag3_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FB7�����ۣ�NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7�����ۣ�NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������NMS���������󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	set expectTable "0000.0000.0001 ac1 0000.0000.0105 ac1 0000.0000.000C ac1 0000.0000.0200 pw120 0000.0000.0205 pw120 0000.0000.0208 pw120\
			0000.0000.0305 pw130 0000.0000.000D pw140"
	##��������NMS��������
	set testFlag 0 ;#=1 ��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
        		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestVplsTag $fileId "��$j\��NE1($gpnIp1)����NMS����������" $rateL2 $rateR2 "GPN_PTN_006_$capId"]} {
				set flag4_case4 1
			} 
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls11" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable $expectTable]} {
				set flag4_case4 1
			}
        	} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
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
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag4_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FB8�����ۣ�NE1($gpnIp1)��������NMS���������󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8�����ۣ�NE1($gpnIp1)��������NMS���������󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������NMS���������󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������SW���������󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	###��������SW��������
	set testFlag 0 ;#=1 ��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
        		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
        		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
        		if {[TestVplsTag $fileId "��$j\��NE1($gpnIp1)����SW����������" $rateL2 $rateR2 "GPN_PTN_006_$capId"]} {
        			set flag5_case4 1
        		} 
        		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls11" dTable
        		if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����SW����������" $dTable $expectTable]} {
        			set flag5_case4 1
        		}
        	} else {
        		gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��SW����������" $fileId
        		set testFlag 1
        		break
        	}
	}
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource8
		send_log "\n resource7:$resource7"
		send_log "\n resource8:$resource8"
		if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
			set flag5_case4	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag5_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FB9�����ۣ�NE1($gpnIp1)��������SW���������󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9�����ۣ�NE1($gpnIp1)��������SW���������󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��������SW���������󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)���������豸�����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	#���������豸����
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
        for {set j 1} {$j<=$cnt} {incr j} {
          	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
          	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
          	after $rebootTime
        	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[TestVplsTag $fileId "��$j\��NE1($gpnIp1)�����豸������" $rateL2 $rateR2 "GPN_PTN_006_$capId"]} {
			set flag6_case4 1
		} 
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls11" dTable
		if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)�����豸������" $dTable $expectTable]} {
			set flag6_case4 1
		}
        }
        gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag6_case4	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FC1�����ۣ�NE1($gpnIp1)���������豸�����󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1�����ۣ�NE1($gpnIp1)���������豸�����󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)���������豸�����󣬲���ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪtagģʽ��NE1($gpnIp1)��NE4($gpnIp4)�û������ģʽΪPORT+SVLAN+CVLAN����֤ҵ��  ���Կ�ʼ=====\n"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "enable"
	}
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "1000" $GPNTestEth1
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls11" "" $GPNTestEth1 "1000" "100" "none" "modify" "1000" "0" "0" "0x8100" "evc2"
	
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "enable"
	}
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac1"
	PTN_UNI_AddInter $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel "1000" $GPNTestEth2
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac1" "vpls12" "" $GPNTestEth2 "1000" "100" "none" "modify" "1000" "0" "0" "0x8100" "evc2"
	
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
	PTN_UNI_AddInter $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel "1000" $GPNTestEth3
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "vpls13" "" $GPNTestEth3 "1000" "100" "none" "modify" "1000" "0" "0" "0x8100" "evc2"
	
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac1"
	PTN_UNI_AddInter $telnet4 $matchType4 $Gpn_type4 $fileId $Worklevel "1000" $GPNTestEth4
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac1" "vpls14" "" $GPNTestEth4 "1000" "100" "none" "modify" "1000" "0" "0" "0x8100" "evc2"
	#NE1��NE4����untag��vid=1000 100��������
	stc::perform streamBlockActivate -streamBlockList $hGPNPortStreamList5 -activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList2 \
		-activate "true"
	incr capId
	SendAndStat_ptn006 1 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
        	$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
        	$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_006_$capId"
        SendAndStat_ptn006 0 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
        	$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
        	$hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $anaFliFrameCfg0 "GPN_PTN_006_$capId"
        SendAndStat_ptn006 0 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
        	$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
        	$hGPNPortAnaFrameCfgFilList GPNPort1Cnt2 GPNPort2Cnt2 GPNPort3Cnt2 GPNPort4Cnt2 6 $anaFliFrameCfg6 "GPN_PTN_006_$capId"
       
	if {[TestResultPrint 1 $fileId]} {
		set flag7_case4 1
	}
	puts $fileId ""
	if {$flag7_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC2�����ۣ�vplsΪtagģʽ��NE1($gpnIp1)��NE4($gpnIp4)�û������ģʽΪPORT+SVLAN+CVLAN����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2�����ۣ�vplsΪtagģʽ��NE1($gpnIp1)��NE4($gpnIp4)�û������ģʽΪPORT+SVLAN+CVLAN����֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsΪtagģʽ��NE1($gpnIp1)��NE4($gpnIp4)�û������ģʽΪPORT+SVLAN+CVLAN����֤ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase4 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 4���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 4���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 4 ELANҵ������֤��vplsΪtagģʽ��֤ҵ��  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 ����ELANҵ����һ��LSP����֤ҵ��֮����Ӱ��\n"
	set flag1_case5 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��ELAN��vplsTypeΪraw��acΪPORT+VLAN��һ��ELAN��vplsTypeΪtag��acΪPORT+SVLAN+CLVAN����������ELAN��ҵ��  ���Կ�ʼ=====\n"
	#�½�һ��ELANҵ��vplsΪrawģʽ����֮ǰ��ELANҵ����һ��lsp
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" 1 "elan" "flood" "false" "false" "false" "true" "2000" "" "raw"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "4000" "4000" "" "delete" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "5000" "5000" "" "delete" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac11" "vpls1" "" $GPNTestEth1 "500" "0" "none" "modify" "500" "0" "0" "0x8100" "evc1"
	
	gwd::GWVpls_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls2" 2 "elan" "flood" "false" "false" "false" "true" "2000" "" "raw"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "vpls" "vpls2" "peer" $address623 "2000" "2000" "" "delete" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24" "vpls" "vpls2" "peer" $address624 "6000" "6000" "" "delete" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac22" "vpls2" "" $GPNTestEth2 "800" "0" "none" "modify" "800" "0" "0" "0x8100" "evc1"
		
	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3" 3 "elan" "flood" "false" "false" "false" "true" "2000" "" "raw"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "2000" "2000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw34" "vpls" "vpls3" "peer" $address634 "3000" "3000" "" "delete" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "5000" "5000" "" "delete" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac33" "vpls3" "" $GPNTestEth3 "500" "0" "none" "modify" "500" "0" "0" "0x8100" "evc1"
	
	gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls4" 4 "elan" "flood" "false" "false" "false" "true" "2000" "" "raw"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "4000" "4000" "" "delete" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43" "vpls" "vpls4" "peer" $address643 "3000" "3000" "" "delete" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42" "vpls" "vpls4" "peer" $address642 "6000" "6000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac44" "vpls4" "" $GPNTestEth4 "800" "0" "none" "modify" "800" "0" "0" "0x8100" "evc1"
	incr capId
	SendAndStat_ptn006 1 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_006_$capId"
	SendAndStat_ptn006 0 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $anaFliFrameCfg0 "GPN_PTN_006_$capId"
	SendAndStat_ptn006 0 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt2 GPNPort2Cnt2 GPNPort3Cnt2 GPNPort4Cnt2 6 $anaFliFrameCfg6 "GPN_PTN_006_$capId"
	if {[TestResultPrint 2 $fileId]} {
		set flag1_case5 1
	}
	puts $fileId ""
	if {$flag1_case5 == 1} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC3�����ۣ�һ��ELAN��vplsTypeΪraw��acΪPORT+VLAN��һ��ELAN��vplsTypeΪtag��acΪPORT+SVLAN+CLVAN����������ELAN��ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3�����ۣ�һ��ELAN��vplsTypeΪraw��acΪPORT+VLAN��һ��ELAN��vplsTypeΪtag��acΪPORT+SVLAN+CLVAN����������ELAN��ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��ELAN��vplsTypeΪraw��acΪPORT+VLAN��һ��ELAN��vplsTypeΪtag��acΪPORT+SVLAN+CLVAN����������ELAN��ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase5 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 5���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 5���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 5 ����ELANҵ����һ��LSP����֤ҵ��֮����Ӱ��  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 6 E-LANҵ��vpls���������mac��ַѧϰ���Ʋ���\n"
	set flag1_case6 0
	set flag2_case6 0
	set flag3_case6 0
	set flag4_case6 0
	set flag5_case6 0
	
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac11"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw120"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw130"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw140"
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11"
	
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac1"
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac22"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw210"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw230"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw240"
	gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls2"
	gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls12"
	
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac1"
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac33"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw34"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw310"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw320"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw340"
	gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3"
	gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls13"
	
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac1"
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac44"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw410"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw420"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw430"
	gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls4"
	gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls14"
	
	gwd::GWVpls_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls20" 20 "elan" "discard" "false" "false" "false" "true" 2000 "" ""
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls20" "peer" $::address621 "102" "102" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "vpls" "vpls20" "peer" $::address623 "202" "202" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24" "vpls" "vpls20" "peer" $::address624 "62" "62" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac500" "vpls20" "" $::GPNTestEth2 "500" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
		
	gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls30" 30 "elan" "discard" "false" "false" "false" "true" 2000 "" ""
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls30" "peer" $::address632 "202" "202" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw34" "vpls" "vpls30" "peer" $::address634 "302" "302" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls30" "peer" $::address631 "52" "52" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac500" "vpls30" "" $::GPNTestEth3 "500" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40" 40 "elan" "discard" "false" "false" "false" "true" 2000 "" ""
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls40" "peer" $::address641 "402" "402" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1" 
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43" "vpls" "vpls40" "peer" $::address643 "302" "302" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42" "vpls" "vpls40" "peer" $::address642 "62" "62" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac500" "vpls40" "" $::GPNTestEth4 "500" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	stc::config $hGPNPort1GenCfg -DurationMode BURSTS -BurstSize 1 -Duration 200
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPortStreamList2 \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPort1Stream17 \
		-activate "true"
	stc::apply
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ80��ѧϰ����Ϊ����  ���Կ�ʼ=====\n"
	PTN_ChangeElanConfig $fileId 10 "discard" "80" 0 1
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "discard" "ac500" "vpls10" 80 80]} {
		set flag1_case6 1
	}
	puts $fileId ""
	if {$flag1_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FC4�����ۣ�vpls��������mac��ַѧϰ����Ϊ80��ѧϰ����Ϊ���������ò���Ч" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4�����ۣ�vpls��������mac��ַѧϰ����Ϊ80��ѧϰ����Ϊ������������Ч" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ80��ѧϰ����Ϊ����  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ80��ѧϰ����Ϊ����  ���Կ�ʼ=====\n"
	PTN_ChangeElanConfig $fileId 10 "flood" "80" 1 1
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "flood" "ac500" "vpls10" 80 200]} {
		set flag2_case6 1
	}
	puts $fileId ""
	if {$flag2_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FC5�����ۣ�vpls��������mac��ַѧϰ����Ϊ80��ѧϰ����Ϊ���飬���ò���Ч" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5�����ۣ�vpls��������mac��ַѧϰ����Ϊ80��ѧϰ����Ϊ���飬������Ч" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ80��ѧϰ����Ϊ����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ����  ���Կ�ʼ=====\n"
	PTN_ChangeElanConfig $fileId 10 "flood" "100" 1 1
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "flood" "ac500" "vpls10" 100 200]} {
		set flag3_case6 1
	}
	puts $fileId ""
	if {$flag3_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FC6�����ۣ�vpls��������mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ���飬���ò���Ч" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6�����ۣ�vpls��������mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ���飬������Ч" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ����  ���Կ�ʼ=====\n"
	PTN_ChangeElanConfig $fileId 10 "discard" "100" 1 1
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "discard" "ac500" "vpls10" 100 100]} {
		set flag4_case6 1
	}
	puts $fileId ""
	if {$flag4_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FC7�����ۣ�vpls��������mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ���������ò���Ч" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7�����ۣ�vpls��������mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ������������Ч" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ50��ѧϰ����Ϊ����  ���Կ�ʼ=====\n"
	PTN_ChangeElanConfig $fileId 10 "flood" "50" 1 1
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "flood" "ac500" "vpls10" 50 200]} {
		set flag5_case6 1
	}
	puts $fileId ""
	if {$flag5_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FC8�����ۣ�vpls��������mac��ַѧϰ����Ϊ50��ѧϰ����Ϊ���飬���ò���Ч" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8�����ۣ�vpls��������mac��ַѧϰ����Ϊ50��ѧϰ����Ϊ���飬������Ч" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ50��ѧϰ����Ϊ����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase6 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 6���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 6���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 6 E-LANҵ��vpls���������mac��ַѧϰ���Ʋ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 7 E-LANҵ��vpls��������б��Ĺ��˲�������\n"
	set flag1_case7 0
	set flag2_case7 0
	set flag3_case7 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls�������ý�ֹͨ���㲥��������ͨ���鲥����δ֪��������֤ҵ��  ���Կ�ʼ=====\n"
	stc::config $hGPNPort1GenCfg -DurationMode CONTINUOUS
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPort1Stream17 \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream12 $hGPNPort1Stream32 $hGPNPort1Stream33 $hGPNPort4Stream13 $hGPNPort4Stream10 $hGPNPort4Stream11" \
		-activate "true"
	stc::apply
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac500"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls10"
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls10" 10 "elan" "discard" "false" "false" "false" "true" 2000 "" ""
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls10" "peer" $::address612 "102" "102" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls10" "peer" $::address614 "402" "402" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4" 
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls10" "peer" $::address613 "52" "52" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls10" "" $::GPNTestEth1 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
		
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac500"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43"
	gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40"
	gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40" 40 "elan" "discard" "true" "false" "false" "true" 2000 "" ""
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls40" "peer" $::address641 "402" "402" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1" 
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43" "vpls" "vpls40" "peer" $::address643 "302" "302" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42" "vpls" "vpls40" "peer" $::address642 "62" "62" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac800" "vpls40" "" $GPNTestEth4 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	if {[TestCase7 "NE4($gpnIp4)vpls���ý�ֹͨ���㲥��������ͨ���鲥����δ֪��������" $rateL0 $rateR0 $rateL $rateR 1 0 0]} {
		set flag1_case7 1
	}
	puts $fileId ""
	if {$flag1_case7 == 1} {
		set flagCase7 1
		 gwd::GWpublic_print "NOK" "FC9�����ۣ�vpls�������ý�ֹͨ���㲥��������ͨ���鲥����δ֪��������֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC9�����ۣ�vpls�������ý�ֹͨ���㲥��������ͨ���鲥����δ֪��������֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls�������ý�ֹͨ���㲥��������ͨ���鲥����δ֪��������֤ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls�������ý�ֹͨ���鲥��������ͨ���㲥����δ֪��������֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43"
	gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40"
	gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40" 40 "elan" "discard" "false" "true" "false" "true" 2000 "" ""
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls40" "peer" $::address641 "402" "402" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1" 
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43" "vpls" "vpls40" "peer" $::address643 "302" "302" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42" "vpls" "vpls40" "peer" $::address642 "62" "62" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac800" "vpls40" "" $GPNTestEth4 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	if {[TestCase7 "NE4($gpnIp4)vpls���ý�ֹͨ���鲥��������ͨ���㲥����δ֪��������" $rateL0 $rateR0 $rateL $rateR 0 1 0]} {
		set flag2_case7 1
	}
	puts $fileId ""
	if {$flag2_case7 == 1} {
		set flagCase7 1
		 gwd::GWpublic_print "NOK" "FD1�����ۣ�vpls�������ý�ֹͨ���鲥��������ͨ���㲥����δ֪��������֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD1�����ۣ�vpls�������ý�ֹͨ���鲥��������ͨ���㲥����δ֪��������֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls�������ý�ֹͨ���鲥��������ͨ���㲥����δ֪��������֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls�������ý�ֹͨ��δ֪������������ͨ���㲥�����鲥����֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43"
	gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40"
	gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40" 40 "elan" "discard" "false" "false" "true" "true" 2000 "" ""
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls40" "peer" $::address641 "402" "402" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1" 
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43" "vpls" "vpls40" "peer" $::address643 "302" "302" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42" "vpls" "vpls40" "peer" $::address642 "62" "62" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac800" "vpls40" "" $GPNTestEth4 "800" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	if {[TestCase7 "NE4($gpnIp4)vpls���ý�ֹͨ��δ֪������������ͨ���㲥�����鲥����" $rateL0 $rateR0 $rateL $rateR 0 0 1]} {
		set flag3_case7 1
	}
	puts $fileId ""
	if {$flag3_case7 == 1} {
		set flagCase7 1
		 gwd::GWpublic_print "NOK" "FD2�����ۣ�vpls�������ý�ֹͨ��δ֪������������ͨ���㲥�����鲥����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD2�����ۣ�vpls�������ý�ֹͨ��δ֪������������ͨ���㲥�����鲥����֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls�������ý�ֹͨ��δ֪������������ͨ���㲥�����鲥����֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase7 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 7���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 7���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 7 E-LANҵ��vpls��������б��Ĺ��˲�������  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 8 E-LANҵ�񣺺ڰ���������\n"
	set flag1_case8 0
	set flag2_case8 0
	set flag3_case8 0
	set flag4_case8 0
	set flag5_case8 0
	set flag6_case8 0
	set flag7_case8 0
	set flag8_case8 0
	set flag9_case8 0
	set flag10_case8 0
	set flag11_case8 0
	set flag12_case8 0
	set flag13_case8 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��ac500��δ���þ�̬mac��ַʱ����ת����mac��ַת����  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream12 $hGPNPort1Stream32 $hGPNPort1Stream33 $hGPNPort4Stream13 $hGPNPort4Stream10 $hGPNPort4Stream11" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPort1Stream2 \
		-activate "true"
	stc::apply
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43"
	gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40"
	gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40" 40 "elan" "discard" "false" "false" "false" "true" 2000 "" ""
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls40" "peer" $::address641 "402" "402" "" "nochange" "none" 1 0 "0x8100" "0x8100" "1" 
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43" "vpls" "vpls40" "peer" $::address643 "302" "302" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42" "vpls" "vpls40" "peer" $::address642 "62" "62" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac500" "vpls40" "" $GPNTestEth4 "500" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
	
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac500" "vpls10" "" $::GPNTestEth1 "500" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"
		
	set staticMac "0000.0000.0002"
	set staticMac_dst "0000.0000.0022"
        ####δ���þ�̬macʱ����
	incr capId
        if {[PTN_BlackAndWhiteMac 0 0 0 "��NE1($gpnIp1)��ac500��δ���þ�̬mac��ַ$staticMac\ʱ" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
        	set flag1_case8 1
        }
	puts $fileId ""
	if {$flag1_case8 == 1} {
		set flagCase8 1
		 gwd::GWpublic_print "NOK" "FD3�����ۣ���NE1($gpnIp1)��ac500��δ���þ�̬mac��ַʱ����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD3�����ۣ���NE1($gpnIp1)��ac500��δ���þ�̬mac��ַʱ����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��ac500��δ���þ�̬mac��ַʱ����ת����mac��ַת����  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_addStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls10" "ac500"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 1 0 "��NE1($gpnIp1)��ac500���þ�̬mac��ַ$staticMac\��" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
		set flag2_case8 1
	}
	puts $fileId ""
	if {$flag2_case8 == 1} {
		set flagCase8 1
		 gwd::GWpublic_print "NOK" "FD4�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD4�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����������豸�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	incr capId
	if {[PTN_BlackAndWhiteMac 0 1 0 "��NE1($gpnIp1)��ac500���þ�̬mac��ַ$staticMac\�����������豸��" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
		set flag3_case8 1
	}
	puts $fileId ""
	if {$flag3_case8 == 1} {
		set flagCase8 1
		 gwd::GWpublic_print "NOK" "FD5�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����������豸�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD5�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����������豸�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����������豸�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500��ɾ�����õľ�̬mac��ַ�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls10"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 0 0 "��NE1($gpnIp1)��ac500��ɾ�����þ�̬mac��ַ$staticMac\��" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
		set flag4_case8 1
	}
	puts $fileId ""
	if {$flag4_case8 == 1} {
		set flagCase8 1
		 gwd::GWpublic_print "NOK" "FD6�����ۣ�NE1($gpnIp1)ac500��ɾ�����õľ�̬mac��ַ�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD6�����ۣ�NE1($gpnIp1)ac500��ɾ�����õľ�̬mac��ַ�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500��ɾ�����õľ�̬mac��ַ�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��NE2($gpnIp2)��pw12�����þ�̬mac��ַ�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_addStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls10" "pw12"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 1 1 "��NE1($gpnIp1)��pw12��������þ�̬mac��ַ$staticMac_dst\��" "pw" "pw12" "vpls10" $staticMac_dst "GPN_PTN_006_$capId"]} {
		set flag5_case8 1
	}
	puts $fileId ""
	if {$flag5_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FD7�����ۣ�NE1($gpnIp1)��NE2($gpnIp2)��pw12�����þ�̬mac��ַ�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD7�����ۣ�NE1($gpnIp1)��NE2($gpnIp2)��pw12�����þ�̬mac��ַ�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��NE2($gpnIp2)��pw12�����þ�̬mac��ַ�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��NE2($gpnIp2)��pw12�����þ�̬mac��ַ���������������ת����mac��ַת����  ���Կ�ʼ=====\n"
        gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
        gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
        after $rebootTime
        set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	incr capId
	if {[PTN_BlackAndWhiteMac 0 1 1 "��NE1($gpnIp1)��pw12��������þ�̬mac��ַ$staticMac_dst\������������" "pw" "pw12" "vpls10" $staticMac_dst "GPN_PTN_006_$capId"]} {
		set flag6_case8 1
	}
	puts $fileId ""
	if {$flag6_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FD8�����ۣ�NE1($gpnIp1)��NE2($gpnIp2)��pw12�����þ�̬mac��ַ���������������ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD8�����ۣ�NE1($gpnIp1)��NE2($gpnIp2)��pw12�����þ�̬mac��ַ���������������ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��NE2($gpnIp2)��pw12�����þ�̬mac��ַ���������������ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��NE2($gpnIp2)��pw12��ɾ����̬mac��ַ�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls10"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 0 1 "��NE1($gpnIp1)��pw12��ɾ�����þ�̬mac��ַ$staticMac_dst\��" "pw" "pw12" "vpls10" $staticMac_dst "GPN_PTN_006_$capId"]} {
		set flag7_case8 1
	}
	puts $fileId ""
	if {$flag7_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FD9�����ۣ�NE1($gpnIp1)��NE2($gpnIp2)��pw12��ɾ����̬mac��ַ�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD9�����ۣ�NE1($gpnIp1)��NE2($gpnIp2)��pw12��ɾ����̬mac��ַ�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)��NE2($gpnIp2)��pw12��ɾ����̬mac��ַ�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500�����úڶ�mac�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_addBlackHoleMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls10" "ac500" "src_drop"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 1 0 "��NE1($gpnIp1)��ac500�����úڶ�mac��ַ$staticMac\��" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
		set flag8_case8 1
	}
	puts $fileId ""
	if {$flag8_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FE1�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE1�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500�����úڶ�mac�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500�����úڶ�mac���������������ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	incr capId
	if {[PTN_BlackAndWhiteMac 1 1 0 "��NE1($gpnIp1)��ac500�����úڶ�mac��ַ$staticMac\������������" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
		set flag9_case8 1
	}
	puts $fileId ""
	if {$flag9_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FE2�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac���������������ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE2�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac���������������ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500�����úڶ�mac���������������ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500��ɾ���ڶ�mac�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls10"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 0 0 "��NE1($gpnIp1)��ac500��ɾ���ڶ�mac��ַ$staticMac\��" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
		set flag10_case8 1
	}
	puts $fileId ""
	if {$flag10_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FE3�����ۣ�NE1($gpnIp1)ac500��ɾ���ڶ�mac�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE3�����ۣ�NE1($gpnIp1)ac500��ɾ���ڶ�mac�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500��ɾ���ڶ�mac�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12����Ӻڶ�mac�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_addBlackHoleMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls10" "pw12" "dest_drop"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 1 1 "��NE1($gpnIp1)��pw12����Ӻڶ�mac��ַ$staticMac_dst\��" "pw" "pw12" "vpls10" $staticMac_dst "GPN_PTN_006_$capId"]} {
		set flag11_case8 1
	}
	puts $fileId ""
	if {$flag11_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FE4�����ۣ�NE1($gpnIp1)pw12����Ӻڶ�mac�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE4�����ۣ�NE1($gpnIp1)pw12����Ӻڶ�mac�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12����Ӻڶ�mac�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12����Ӻڶ�mac���������������ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	incr capId
	if {[PTN_BlackAndWhiteMac 1 1 1 "��NE1($gpnIp1)��pw12����Ӻڶ�mac��ַ$staticMac_dst\������������" "pw" "pw12" "vpls10" $staticMac_dst "GPN_PTN_006_$capId"]} {
		set flag12_case8 1
	}
	puts $fileId ""
	if {$flag12_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FE5�����ۣ�NE1($gpnIp1)pw12����Ӻڶ�mac���������������ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE5�����ۣ�NE1($gpnIp1)pw12����Ӻڶ�mac���������������ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12����Ӻڶ�mac���������������ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12��ɾ���ڶ�mac�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls10"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 0 0 "��NE1($gpnIp1)��pw12��ɾ���ڶ�mac��ַ$staticMac_dst\��" "pw" "pw12" "vpls10" $staticMac_dst "GPN_PTN_006_$capId"]} {
		set flag13_case8 1
	}
	puts $fileId ""
	if {$flag13_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FE6�����ۣ�NE1($gpnIp1)pw12��ɾ���ڶ�mac�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE6�����ۣ�NE1($gpnIp1)pw12��ɾ���ڶ�mac�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12��ɾ���ڶ�mac�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase8 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 8���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 8���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 8 E-LANҵ�񣺺ڰ���������  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 9 E-LANҵ������ͳ�Ʋ���\n"
	puts $fileId "ʹ��NE1����ͳ�Ƽ���֤��case1���Խ�����ɼ���Ϣ������ֻ֤�������ܲ������ű�δ����"
	puts $fileId ""
	puts $fileId "Test Case 9 E-LANҵ������ͳ�Ʋ���  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 10 E-LANҵ��LSP��ǩ����������֤����\n"
	puts $fileId "����Ŀ�ģ�E-LANҵ��LSP��ǩ����������֤����"
	puts $fileId ""
	puts $fileId "NE1-NE3�豸֮��ı�ǩ������֤��case1���Խ�������ٵ�������"
	puts $fileId ""
	puts $fileId "Test Case 10 E-LANҵ��LSP��ǩ����������֤����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===�ָ���ʼ������...\n"
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac500"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls10"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14"] 
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface11 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface19 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface12 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface3 $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface10 $matchType1 $Gpn_type1 $telnet1]
	
	lappend flagDel [gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac500"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls20"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"] 
	lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort7.5 $ip632 "500" "600" "0" 23 "normal"]
	lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort6.4 $ip612 "600" "500" "0" 21 "normal"]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface4 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface5 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface13 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface14 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface20 $matchType2 $Gpn_type2 $telnet2]
	
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac500"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw34"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls30"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34"]
	lappend flagDel [gwd::GWpublic_delLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $GPNPort8.5 $ip623 "800" "700" "0" 32 "normal"]
	lappend flagDel [gwd::GWpublic_delLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $GPNPort9.6 $ip643 "700" "800" "0" 34 "normal"]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface6 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface7 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface15 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface16 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface21 $matchType3 $Gpn_type3 $telnet3]
	
	lappend flagDel [gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac500"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"] 
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface8 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface9 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface17 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface18 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface22 $matchType4 $Gpn_type4 $telnet4]
	
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

	foreach {port1 port2} $Portlist telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType {
		if {[string match "L2" $Worklevel]} {
			lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port1 "none"]
			lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port2 "none"]
		}
		if {[string match "L2" $Worklevel]||[string match "7600" $Gpn_type]} {
	        	lappend flagDel [gwd::GWpublic_addStorm $telnet $matchType $Gpn_type $fileId $eth "bcast" "64"]
	        	lappend flagDel [gwd::GWpublic_addStorm $telnet $matchType $Gpn_type $fileId $port1 "bcast" "64"]
	        	lappend flagDel [gwd::GWpublic_addStorm $telnet $matchType $Gpn_type $fileId $port2 "bcast" "64"]
		}
	}
	#Ϊ�˹��ɾ���ڶ�mac�;�̬mac�������岻ͬ�����⣬���豸�������س�ʼ��������������------
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
	#------Ϊ�˹��ɾ���ڶ�mac�;�̬mac�������岻ͬ�����⣬���豸�������س�ʼ��������������
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_006"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_006"
	chan seek $fileId 0
        puts $fileId "\n**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "GPN_PTN_006����Ŀ�ģ�E-LAN��Vpls=tag��rawģʽ��ҵ����֤��LSP PW����������֤\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1 == 1 || $flagCase2 == 1 || $flagCase3 == 1 || $flagCase4 == 1 || $flagCase5 == 1 || $flagCase6 == 1\
		|| $flagCase7 == 1 || $flagCase8 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_006���Խ��" $fileId
        puts $fileId ""
        gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5���Խ��" $fileId
        gwd::GWpublic_print [expr {($flagCase6 == 0) ? "OK" : "NOK"}] "Test Case 6���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase7 == 0) ? "OK" : "NOK"}] "Test Case 7���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase8 == 0) ? "OK" : "NOK"}] "Test Case 8���Խ��" $fileId
        puts $fileId ""
        puts $fileId ""
        gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsTypeΪrawģʽ���û������ģʽΪ�˿�ģʽ��֤ELANҵ��" $fileId
        gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����NE1($gpnIp1)��NE2($gpnIp2)��NE4($gpnIp4)��NNI���ڷ����Ĳ���MPLS��ǩ" $fileId
        gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)ʹ��lsp��pw��ac������ͳ�ƣ���������ͳ�Ƶ�׼ȷ��" $fileId
        gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)����shut undoshut NNI�ں󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FA6 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FA7 == [expr {($flag7_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FA8 == [expr {($flag8_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FA9 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�ɾ�������豸�ϵ�ר��ҵ��AC������ҵ��" $fileId
        gwd::GWpublic_print "== FB1 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vlpsΪrawģʽ������ģʽ��Ϊ���˿�+��Ӫ��VLAN��ģʽ����֤ҵ��ת��" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vlpsΪrawģʽ������ģʽ��Ϊ���˿�+��Ӫ��VLAN��ģʽ��δʹ��overlay����ʱҵ�����" $fileId
        gwd::GWpublic_print "== FB3 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�vlpsΪrawģʽ������ģʽ��Ϊ���˿�+��Ӫ��VLAN��ģʽ��ʹ��overlay����ʱҵ�����" $fileId
        gwd::GWpublic_print "== FB4 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪrawģʽ���û������ģʽΪ���˿ںͶ˿�+��Ӫ��VLAN����ģʽ����֤ҵ��" $fileId
        gwd::GWpublic_print "== FB5 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�vlpsΪtagģʽ������ģʽΪ���˿ںͶ˿�+��Ӫ��VLAN������ģʽ����֤ҵ��" $fileId
        gwd::GWpublic_print "== FB6 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)����shut undoshut NNI�ں󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FB7 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)��������NNI�����ڰ忨�󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FB8 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)��������NMS���������󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FB9 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)��������SW���������󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FC1 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)���������豸�����󣬲���ҵ��ָ���ϵͳ�ڴ�" $fileId
        gwd::GWpublic_print "== FC2 == [expr {($flag7_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�vplsΪtagģʽ��NE1($gpnIp1)��NE4($gpnIp4)�û������ģʽΪPORT+SVLAN+CVLAN����֤ҵ��" $fileId
        gwd::GWpublic_print "== FC3 == [expr {($flag1_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��ELAN��vplsTypeΪraw��acΪPORT+VLAN��һ��ELAN��vplsTypeΪtag��acΪPORT+SVLAN+CLVAN����������ELAN��ҵ��" $fileId
        gwd::GWpublic_print "== FC4 == [expr {($flag1_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls��������mac��ַѧϰ����Ϊ80��ѧϰ����Ϊ����������[expr {($flag1_case6 == 1) ? "��" : ""}]��Ч" $fileId
        gwd::GWpublic_print "== FC5 == [expr {($flag2_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls��������mac��ַѧϰ����Ϊ80��ѧϰ����Ϊ���飬����[expr {($flag2_case6 == 1) ? "��" : ""}]��Ч" $fileId
        gwd::GWpublic_print "== FC6 == [expr {($flag3_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls��������mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ���飬����[expr {($flag3_case6 == 1) ? "��" : ""}]��Ч" $fileId
        gwd::GWpublic_print "== FC7 == [expr {($flag4_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls��������mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ����������[expr {($flag4_case6 == 1) ? "��" : ""}]��Ч" $fileId
        gwd::GWpublic_print "== FC8 == [expr {($flag5_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls��������mac��ַѧϰ����Ϊ50��ѧϰ����Ϊ���飬����[expr {($flag5_case6 == 1) ? "��" : ""}]��Ч" $fileId
        gwd::GWpublic_print "== FC9 == [expr {($flag1_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls�������ý�ֹͨ���㲥��������ͨ���鲥����δ֪��������֤ҵ��" $fileId
        gwd::GWpublic_print "== FD1 == [expr {($flag2_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls�������ý�ֹͨ���鲥��������ͨ���㲥����δ֪��������֤ҵ��" $fileId
        gwd::GWpublic_print "== FD2 == [expr {($flag3_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls�������ý�ֹͨ��δ֪������������ͨ���㲥�����鲥����֤ҵ��" $fileId
	gwd::GWpublic_print "== FD3 == [expr {($flag1_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ���NE1($gpnIp1)��ac500��δ���þ�̬mac��ַʱ����ת����mac��ַת����" $fileId
        gwd::GWpublic_print "== FD4 == [expr {($flag2_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FD5 == [expr {($flag3_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����������豸�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FD6 == [expr {($flag4_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)ac500��ɾ�����õľ�̬mac��ַ�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FD7 == [expr {($flag5_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12�����þ�̬mac��ַ�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FD8 == [expr {($flag6_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12�����þ�̬mac��ַ���������������ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FD9 == [expr {($flag7_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12��ɾ����̬mac��ַ�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE1 == [expr {($flag8_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE2 == [expr {($flag9_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac���������������ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE3 == [expr {($flag10_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)ac500��ɾ���ڶ�mac�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE4 == [expr {($flag11_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12����Ӻڶ�mac�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE5 == [expr {($flag12_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12����Ӻڶ�mac���������������ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE6 == [expr {($flag13_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12��ɾ���ڶ�mac�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
        puts $fileId ""
        puts $fileId "**************************************************************************************"
        puts $fileId ""
        puts $fileId "**************************************************************************************"
} err]} {
gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_006"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_006_REPORT.txt" "report\\NOK_GPN_PTN_006_REPORT.txt"
	file rename "log\\GPN_PTN_006_LOG.txt" "log\\NOK_GPN_PTN_006_LOG.txt"
} else {
	file rename "report\\GPN_PTN_006_REPORT.txt" "report\\OK_GPN_PTN_006_REPORT.txt"
	file rename "log\\GPN_PTN_006_LOG.txt" "log\\OK_GPN_PTN_006_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}
