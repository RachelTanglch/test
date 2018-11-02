#!/bin/sh
# T4_GPN_PTN_ETREE_010.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#����Ŀ�ģ�E-TREE�Ĺ���
#1-E-TREEҵ������֤  
#2-����E-Treeҵ����֤
#3-lsp��ǩ���� 
#4-VSI��macѧϰ����
#5-���Ĺ��� 
#6-�ڰ���������
#7-����ͳ��
#9-�����E-Treeҵ����֤
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
#   <2>��NE1��NE4��NE3ΪPE��ɫ��PE2��ΪPE��ΪP��ɫ��NE1��NE3��treeҵ�񾭹�NE2����ʱNE2Ϊp
#   <3>�������ڵ�NE1�Ķ˿�1����Ҷ�ӽڵ�NE2/NE4/NE3�Ķ˿�2/4/3��EP-Treeҵ���û��ࣨGE�˿ڣ�����ģʽΪ�˿�ģʽ
#      ����NE1��NE2��LSP���ǩ17������ǩ17��PW1���ر�ǩ1000��Զ�̱�ǩ1000��
#      ����NE1��NE4��LSP���ǩ18������ǩ18��PW1���ر�ǩ2000��Զ�̱�ǩ2000��
#      ����NE1��NE3��LSP���ǩ20������ǩ21��PW1���ر�ǩ3000��Զ�̱�ǩ3000��
#      ����NE3��NE1��LSP���ǩ22������ǩ23��PW1���ر�ǩ3000��Զ�̱�ǩ3000��
#      NE2�豸������lsp�ı�ǩ������NE2��LSP���ǩ21����Ϊ����ǩ22��NE2��LSP���ǩ23����Ϊ����ǩ20��
#      ���������ã�mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000><1-65535> [normal|ring] 
#   <4>��NE1/NE2/NE3/NE4��ΪPE��ɫ��NE1��NE3��treeҵ�񾭹�NE2����ʱNE2�ϵ�����pw,��NE1����Ϊroot��ɫ����NE3����Ϊnone(Ҷ��)��ɫ
#   <5>�������ڵ�NE1�Ķ˿�1����Ҷ�ӽڵ�NE2/NE4/NE3�Ķ˿�2/4/3��EP-Treeҵ���������£������ǩ����
#      ����NE1��NE2��LSP���ǩ17������ǩ17��PW1���ر�ǩ1000��Զ�̱�ǩ1000��
#      ����NE1��NE4��LSP���ǩ18������ǩ18��PW1���ر�ǩ2000��Զ�̱�ǩ2000��
#      ����NE2��NE3��LSP���ǩ20������ǩ20��PW1���ر�ǩ3000��Զ�̱�ǩ3000��
#   <6>���û���˿�������undo vlan check;
#   Ԥ�ڽ��:ϵͳ���쳣���鿴������ȷ������ҵ����������ҵ������ת����NE2/NE3/NE4��̨�豸��Ϊ���ڹ��������
#����E-Tree��ep-tree��ҵ����֤ 
#      �����������ã�ep-tree��
#      NE1����untag/tag�Ĺ㲥����NE2/NE3/NE4�豸��Ҷ�Ӷ˿ڶ����յ���
#      NE1����untag/tag���鲥����NE2/NE3/NE4�豸��Ҷ�Ӷ˿ڶ����յ���
#      NE1����untag/tag�ĵ�������NE2/NE3/NE4�豸��Ҷ�Ӷ˿ڶ����յ���
#      NE1��NE2�Ļ���untag/tag��֪������NE3��NE4�豸Ҷ�Ӷ˿��ղ������ݣ�
#      NE1��NE3�Ļ���untag/tag��֪������NE2��NE4�豸Ҷ�Ӷ˿��ղ������ݣ�
#      NE1��NE4�Ļ���untag/tag��֪������NE2��NE3�豸Ҷ�Ӷ˿��ղ������ݣ�
#   <7>NE2,NE4,NE3����untag/tag�Ĺ㲥/����/�鲥��
#   Ԥ�ڽ������NE1���յ����ݣ�����Ҷ�ӽڵ㲻���յ���Ҷ�ӽڵ��Ҷ�Ӷ˿ڼ䲻�ܻ�ͨ��
#             ����NE1��NNI�˿�egress�����ģ�Ϊ����VLAN TAG��ǩ��mpls��ǩ���ģ����lsp��ǩ17���ڲ�pw��ǩ1000,��
#            LSP�ֶ��е�TTLֵΪ255��PW�ֶ��е�TTLֵΪ255��PW�ֶ��к���4�ֽڿ�����
#   <8>undo shutdown��shutdown NE1�豸��NNI/UNI�˿�50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
#   <9>����NE1�豸��NNI/UNI�˿����ڰ忨50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
#   <10>NE1�豸����SW/NMS����50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 ���鿴��ǩת��������ȷ����̨�豸��������
#   <11>��������NE1�豸��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ�������ϵͳ���쳣���鿴��ǩת��������ȷ����̨�豸�������� 
#   <12>��ɾ���������£�ɾ��NE1��NE2��NE3��NE4�ϵ�ac���鿴����acɾ���ɹ�,pw����İ��ǲ�ɾ���ģ�NE1������3̨�豸��ҵ���жϣ�ϵͳ���쳣
#   <13>�������ac���鿴������ӳɹ�������ҵ����֤��Ч
#2���Test Case 2���Ի���
#����E-Tree��evp-tree��ҵ����֤ 
#   <14>ɾ��NE1��NE2��NE3��NE4�豸�Ļ��ҵ��AC+vpls�򣩣��鿴����ɾ���ɹ���ac��vpls��������ʧ��ҵ���жϣ�ϵͳ���쳣
#   <15>���´���NE1��NE2��NE3��NE4�ϵĻ��ҵ��AC+vpls��,����α�߲������ģ���ac����ģʽ��Ϊ���˿�+��Ӫ��VLAN��������evp-Treeҵ��
#   <16>��NE1��NE2��NE3��NE4�Ͼ����������VLAN��vlan 100����������˿ڣ��ٴδ�������ģʽΪ���˿�+��Ӫ��VLAN���Ļ��ҵ�񣬳ɹ�������ϵͳ���쳣
#   <17>��NE1�Ķ˿�1����tag100��tag200ҵ������NE2��NE3��NE4��Ҷ�Ӷ˿�ֻ�ɽ���tag100ҵ������NE1��NE2��NE3��NE4����vlan100��˫����ҵ������
#   <18>NE2��NE3��NE4��vlan100�ĵ�������ֻ��NE1�����յ���Ҷ�ӽڵ��Ҷ�Ӷ˿ڼ䲻�ܻ�ͨ
#   <19>�ظ�����8-11
#   <20>��UNI�˿ڸ���ΪFE/10GE�˿ڣ������������䣬�ظ����ϲ�  ע��ʹ��FE�˿����û��ҵ��ʱ���迪���ð忨��MPLSҵ��ģʽ������Ϊ��mpls enable <slot>��
#3���Test Case 3���Ի���
##E-LANҵ������֤ -����ģʽΪ"�˿�+��Ӫ��VLAN"ģʽ
#   <1>���������˼����ã�NE2ΪNE1��NE3���P�ڵ㣻NE1��NE3��LSP���ǩ20������ǩ21��
#      NE3��NE1��LSP���ǩ22������ǩ23��NE2��LSP���ǩ21����Ϊ����ǩ22��NE2��LSP���ǩ23����Ϊ����ǩ20��
#   <2>NE1��NE3�Է�tag100����֪������ҵ������������NE2��NE1������NNI��˿ڵ�����Ϊ����tag��ǩ��mpls����lsp��ǩΪ21��TTLֵΪ255��pw��ǩ3000��PW��TTLֵΪ255��
#      ����NE2��NE3������NNI���˿ڵ�����Ϊ����tag��ǩ��mpls����lsp��ǩΪ22��TTLֵΪ254��pw��ǩ3000��PW��TTLֵΪ255��֤��NE2��NE1��NE3�����lsp��ǩ��������ȷ�Ľ���
#      ����NE2��NE1������NNI���˿ڵ�����Ϊ����tag��ǩ��mpls����lsp��ǩΪ20��TTLֵΪ254��pw��ǩ3000��PW��TTLֵΪ255��
#      ����NE2��NE3������NNI��˿ڵ�����Ϊ����tag��ǩ��mpls����lsp��ǩΪ23��TTLֵΪ255��pw��ǩ3000��PW��TTLֵΪ255��֤��NE2��NE3��NE1�����lsp��ǩ��������ȷ�Ľ���
#   <3>undo shutdown��shutdown NE2�豸��NNI/UNI�˿�10�Σ���ǩ����������ҵ��ָ�������ϵͳ���쳣 
#   <4>����NE2�豸��NNI/UNI�˿����ڰ忨10�Σ���ǩ����������ҵ��ָ�������ϵͳ���쳣 
#   <5>NE2�豸����SW/NMS����10�Σ���ǩ����������ҵ��ָ�������ϵͳ���쳣 
#   <6>��������NE2�豸��10�Σ�ϵͳ������������ǩ����������ҵ��ָ�������ϵͳ���쳣 
#4���Test Case 4���Ի���
###VSI��macѧϰ����
#   <1>���˼����ò��䣬��vpls����mac��ַѧϰ������Ϊ20��ѧϰ����Ϊ����ʱ��������������ȷ
#   <2>��NE1��UNI��һ�η���Դtag100�� mac��ͬ��30��������NE1��������show forward-entry vpls vpls1�鿴mac��ַ��
#   Ԥ�ڽ����mac��ַѧϰ��Ŀ��ȷΪ20����ѧϰ��Ŀ��ȷ��ѧ�ڶ�Ӧvpls��ac��
#	     NE1��NE2��NE3��UNI�ھ�ֻ���յ�20������˵��ѧϰ����Ϊ������Ч��ûѧ���Ķ�������
#   <3>vpls����mac��ַѧϰ��������Ϊ20���޸�ѧϰ����Ϊ�鷺
#   Ԥ�ڽ������NE1��UNI��һ�η���Դmac��ͬ��30��������NE1��������show forward-entry vpls vpls1�鿴mac��ַ��
#             mac��ַѧϰ��Ŀ��ȷΪ20����ѧϰ��Ŀ��ȷ��ѧ�ڶ�Ӧvpls��ac��
#             NE1��NE2��NE3��UNI�ھ����յ�30������˵��ѧϰ����Ϊ�鷺��Ч��ûѧ���������鷺��ȥ��
#   <4>��macѧϰ��������������Ϊ������ֵ���ж����֤����Ч
#5���Test Case 5���Ի���
###�Ե���/�鲥/�㲥 �Ĺ���
#   <1>���˼����ò��䣬NE1����tag100�Ĺ㲥��Ŀ��macffff.ffff.ffff�����鲥(Ŀ��mac 0100.5e00.0001)��������NE2/NE3/NE4�豸��Ҷ�Ӷ˿ڶ����յ�
#   <2>����/�鲥���ƹ����޸�Ϊʹ�ܣ�Ĭ�Ͻ�ֹ�����鿴������Ч��ҵ���ж�
#   <3>�ٽ���/��/�������ƹ��ܸ�Ϊ��ֹ��ҵ��ָ�
#6���Test Case 6���Ի���
###mac��ַ�ڰ������Ĳ���
#   <1>���˼����ò��䣬NE1����tag100ԴΪ0000.0010.0001��Ŀ��macΪ0000.0010.0002����������NE2��NE3��NE4�����յ�
#   <2>�鿴mac��ַ��0000.0010.0001��̬ѧ����Ӧvpls��ac��
#   <3>��NE1�����û���Դ�ľ�̬mac�󶨵�ac�ڣ���mac��ַΪ0000.0010.0001���鿴mac��ַ����mac�����ɶ�̬��Ϊ��̬��ҵ������
#   <4>����NE1�豸��SW/NMS����10�Σ���������ÿ�β�����ҵ��ָ�������ϵͳ���쳣����̬mac������ȷ
#   <5>ɾ����̬mac��mac��ַ�ֱ����¶�̬ѧϰ��
#   <6>��NE1�����û���Դ�ľ�̬mac�󶨵�pw1�ϣ���mac��ַΪ0000.0010.0002���鿴mac��ַ����ȷ����ֻ��NE2���յ���������NE3��NE4�������������ж�
#   <7>����NE1�豸��SW/NMS����10�Σ���������ÿ�β�����ҵ��ָ�������ϵͳ���쳣����̬mac������ȷ����Ч
#   <8>ɾ����̬mac��NE3��NE4�����յ�������
#   <9>��NE1�����û���Դ�ĺڶ�mac�󶨵�ac�ڣ���mac��ַΪ0000.0010.0001���鿴mac��ַ���ڶ�mac����ȡ����̬���ҵ���ж�
#   <10>����NE1�豸��SW/NMS����10�Σ���������ÿ�β�����ҵ��ָ�������ϵͳ���쳣���ڶ�mac������ȷ����Ч
#   <11>ɾ���ڶ�̬mac��mac��ַ�ֱ����¶�̬ѧϰ����ҵ�����»ָ�
#   <12>��NE1�����û���Դ�ĺڶ�mac�󶨵�pw1����mac��ַΪ0000.0010.0002���鿴mac��ַ���ڶ�mac������ȷ����NE2ҵ���жϣ�NE3/NE4ҵ������
#   <13>����NE1�豸��SW/NMS����4�Σ���������ÿ�β�����ҵ��ָ�������ϵͳ���쳣����̬mac������ȷ����Ч
#   <14>ɾ���ڶ�mac��NE2ҵ��ָ��������ڶ�mac������ʧ
#7���Test Case 7���Ի���
###����ͳ��
#   <1>�������ˣ����ò��䣬NE1��NE2��NE3��NE4������֪������ÿ�뷢10000��������ҵ������
#   <2>ʹ��NE1��lsp/pw������ͳ�ƣ�����ac����ac���󶨵�����˿ڣ���lsp��pw�ĵ�ǰ����ͳ�ƣ���ѯʱ����Ϊ1����
#   <3>һ5���Ӻ��������ϲ鿴ͳ�ƽ����Ӧ����5��ͳ�ƽ������ÿ�������ֵ�������/������Ϊ60*10000�����ң�û���������ϵ����
#   <4>ɾ����ǰ����ͳ�ƣ������������ac����ac���󶨵�����˿ڣ���lsp��pw��15���Ӳɼ���Ϣ
#   <5>һСʱ��鿴15������ʷ����ͳ�ƣ�Ӧ�����ĸ�ͳ�ƽ����ÿ15����ͳ��һ�Σ�ͳ����ȷ
#   <6>ɾ��15������ʷ����ͳ�ƣ������������ac����ac���󶨵�����˿ڣ���lsp��pw��24Сʱ�ɼ���Ϣ��
#   <7>48Сʱ��鿴24Сʱ��ʷ����ͳ�ƣ�Ӧ��������ͳ�ƽ����ÿ24Сʱͳ��һ�Σ�ͳ����ȷ
#8���Test Case 8���Ի���
##�����E-Treeҵ��
#   <1>���˲��䣬�½�һ����vpls2��,�ٴ���һ���µ�E-Treeҵ��(��֮ǰ��ҵ����ͬ��ͬLSP)�������µ�pw�������豸��AC����ģʽ��Ϊ���˿�+��Ӫ��VLAN+�ͻ�VLAN����
#      ��Ӫ��VLANΪ vlan 300���ͻ�VLANΪvlan 3000��ҵ��ɹ�������ϵͳ���쳣����֮ǰ��ҵ�����κθ��ţ�
#   <2>����NE1��LSP10���ǩ17������ǩ17��PW10���ر�ǩ20��Զ�̱�ǩ20
#      ����NE3��LSP10���ǩ18������ǩ18��PW10���ر�ǩ20��Զ�̱�ǩ20 
#      NE2��SW���ã�mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000> <1-65535> [normal|ring] 
#   <3>��NE1��UNI�˿ڷ���untag��tag300��tag3000�� ˫��tag����300 ��3000��ҵ������
#   Ԥ�ڽ����NE2��NE3��NE4��UNI�˿�ֻ�ɽ��յ�˫��tag����300 ��3000��ҵ���������Ҷ�֮ǰ��ҵ���޸��ţ�˫����ҵ������
#   <4>undo shutdown��shutdown NE1��NE2�豸��NNI/UNI�˿�50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
#   <5>����NE1��NE2�豸��NNI/UNI�˿����ڰ忨50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
#   <6>NE1��NE2�豸����SW/NMS����50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 ���鿴��ǩת��������ȷ
#   <7>��������NE1��NE2�豸��50�Σ�ÿ�β�����ϵͳ����������ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣���鿴��ǩת��������ȷ
#   <8>�ڲ�ɾ��vpls������£�ɾ��vpls2��ac��vpls2��ҵ���жϣ�vpls1��ҵ����Ӱ��
#   <9>�������ac���鿴������ӳɹ���ҵ��ָ����Ҳ�Ӱ���������ҵ��
#   <10>ֱ��ɾ����vpls����ɾ����Ӧ��pw,
#   Ԥ�ڽ��������ҵ���жϣ���Ӱ��vpls1��ҵ��
#   <11>���´���һ��vpls2,NE2Ϊ���ڵ�NE1ΪҶ�ӽڵ㣬lsp����vpls1�ģ�pw���´�����NE2���½���PW�Ľ�ɫΪnone(Ҷ��)��
#       NE1���½���pw�Ľ�ɫΪroot����֤�˸��ڵ�����NNI�ڻ�۵��������pwΪroot
#   <12>����һ���µ�E-Treeҵ��AC����ģʽ��Ϊ���˿�+��Ӫ��VLAN������Ӫ��VLANΪ vlan 200ҵ��ɹ�������
#   Ԥ�ڽ����ϵͳ���쳣����֮ǰ��ҵ�����κθ���
#   <13>ɾ����vpls����ɾ����Ӧ��pw,����ҵ���жϣ���Ӱ��vpls1��ҵ�� 
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_010_LOG.txt" a]
        set stdout $fd_log
        chan configure $fd_log -blocking 0 -buffering none;#������ģʽ ����flush
        log_file log\\GPN_PTN_010_LOG.txt
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_010_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#������ģʽ ����flush
        
        file mkdir "debug"
        set fd_debug [open debug\\GPN_PTN_010_DEBUG.txt a]
        exp_internal -f debug\\GPN_PTN_010_DEBUG.txt 0
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
        array set dataArr7 {-srcMac "00:00:00:00:00:0a" -dstMac "FF:FF:FF:FF:FF:FF" -srcIp "192.85.1.10" -dstIp "192.0.0.10" -vid "800" -pri "000"}
        array set dataArr8 {-srcMac "00:00:00:00:00:0b" -dstMac "01:00:5e:04:05:06" -srcIp "192.85.1.11" -dstIp "192.0.0.11" -vid "800" -pri "000"}
        array set dataArr9 {-srcMac "00:00:00:00:00:22" -dstMac "00:00:00:00:00:02" -srcIp "192.85.1.37" -dstIp "192.0.0.37" -vid "500" -pri "000"}
        array set dataArr10 {-srcMac "00:00:00:00:00:33" -dstMac "00:00:00:00:00:03" -srcIp "192.85.1.8" -dstIp "192.0.0.8" -vid "500" -pri "000"}
        array set dataArr11 {-srcMac "00:00:00:00:00:44" -dstMac "00:00:00:00:00:04" -srcIp "192.85.1.9" -dstIp "192.0.0.9" -vid "500" -pri "000"}
        array set dataArr12 {-srcMac "00:00:00:00:00:0c" -dstMac "FF:FF:FF:FF:FF:FF" -srcIp "192.85.1.12" -dstIp "192.0.0.12" -vid "800" -pri "000"}
        array set dataArr13 {-srcMac "00:00:00:00:00:0d" -dstMac "01:00:5e:07:08:09" -srcIp "192.85.1.13" -dstIp "192.0.0.13" -vid "800" -pri "000"}
        array set dataArr14 {-srcMac "00:00:00:00:00:0c" -dstMac "00:00:00:00:00:cc" -srcIp "192.85.1.14" -dstIp "192.0.0.14" -vid "100" -pri "000"}
        array set dataArr15 {-srcMac "00:00:00:00:00:f2" -dstMac "00:00:00:00:f2:f2" -srcIp "192.85.1.15" -dstIp "192.0.0.15" -vid "100" -pri "000"}
        array set dataArr16 {-srcMac "00:00:00:00:00:f3" -dstMac "00:00:00:00:f3:f3" -srcIp "192.85.1.16" -dstIp "192.0.0.16" -vid "100" -pri "000"}
        array set dataArr17 {-srcMac "00:00:00:00:00:f4" -dstMac "00:00:00:00:f4:f4" -srcIp "192.85.1.17" -dstIp "192.0.0.17" -vid "100" -pri "000"}
        array set dataArr18 {-srcMac "00:00:00:00:00:cc" -dstMac "00:00:00:00:00:0c" -srcIp "192.85.1.18" -dstIp "192.0.0.18" -vid "100" -pri "000"}
        array set dataArr19 {-srcMac "00:00:00:10:00:07" -dstMac "00:00:00:20:00:77" -srcIp "192.85.1.19" -dstIp "192.0.0.19" -vid "800" -pri "000" -stepValue "00:00:00:00:00:01" -recycleCount "200" -EnableStream "FALSE"}
        array set dataArr20 {-srcMac "00:00:00:00:00:0d" -dstMac "00:00:00:00:00:dd" -srcIp "192.85.1.20" -dstIp "192.0.0.20" -vid "800" -pri "000"}
        array set dataArr21 {-srcMac "00:00:00:00:00:f2" -dstMac "00:00:00:00:f2:f2" -srcIp "192.85.1.21" -dstIp "192.0.0.21" -vid "800" -pri "000"}
        array set dataArr22 {-srcMac "00:00:00:00:00:f3" -dstMac "00:00:00:00:f3:f3" -srcIp "192.85.1.22" -dstIp "192.0.0.22" -vid "800" -pri "000"}
        array set dataArr23 {-srcMac "00:00:00:00:00:dd" -dstMac "00:00:00:00:00:0d" -srcIp "192.85.1.23" -dstIp "192.0.0.23" -vid "800" -pri "000"}
        array set dataArr24 {-srcMac "00:00:00:00:f2:f2" -dstMac "00:00:00:00:00:f2" -srcIp "192.85.1.24" -dstIp "192.0.0.24" -vid "800" -pri "000"}
        array set dataArr25 {-srcMac "00:00:00:00:f3:f3" -dstMac "00:00:00:00:00:f3" -srcIp "192.85.1.25" -dstIp "192.0.0.25" -vid "800" -pri "000"}
	
        array set dataArr26 {-srcMac "00:00:00:00:00:26" -dstMac "00:00:00:00:01:26" -srcIp "192.85.1.26" -dstIp "192.0.0.26" -vid1 "800" -pri1 "000" -vid2 "500" -pri2 "000"}
	array set dataArr31 {-srcMac "00:00:00:00:02:05" -dstMac "00:00:00:00:02:26" -srcIp "192.85.1.26" -dstIp "192.0.0.26" -vid1 "800" -pri1 "000" -vid2 "500" -pri2 "000"}
	array set dataArr32 {-srcMac "00:00:00:00:03:05" -dstMac "00:00:00:00:03:26" -srcIp "192.85.1.26" -dstIp "192.0.0.26" -vid1 "800" -pri1 "000" -vid2 "500" -pri2 "000"}
	array set dataArr33 {-srcMac "00:00:00:00:04:05" -dstMac "00:00:00:00:04:26" -srcIp "192.85.1.26" -dstIp "192.0.0.26" -vid1 "800" -pri1 "000" -vid2 "500" -pri2 "000"}
	
        array set dataArr27 {-srcMac "00:00:00:00:00:1b" -dstMac "00:00:00:00:1b:1b" -srcIp "192.85.1.27" -dstIp "192.0.0.27" -vid "100" -pri "000" -etherType "8847" -pattern "000650ff003e91ff"}
        array set dataArr28 {-srcMac "00:00:00:00:00:1c" -dstMac "00:00:00:00:1c:1c" -srcIp "192.85.1.28" -dstIp "192.0.0.28" -vid "100" -pri "000" -etherType "8847" -pattern "000c90ff007d11ff"}
        array set dataArr29 {-srcMac "00:00:00:00:00:1d" -dstMac "00:00:00:00:1d:1d" -srcIp "192.85.1.29" -dstIp "192.0.0.29" -vid "100" -pri "000" -etherType "8847" -pattern "001910ff00fa11ff"}
	array set dataArr30 {-srcMac "00:00:00:00:01:05" -dstMac "00:00:00:00:01:dd" -srcIp "192.85.1.20" -dstIp "192.0.0.20" -vid "800" -pri "000"}
       
	
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
	
	set flagResult 0
	set flagCase1 0   ;#Test case 1��־λ 
	set flagCase2 0   ;#Test case 2��־λ
	set flagCase3 0   ;#Test case 3��־λ 
	set flagCase4 0   ;#Test case 4��־λ 
	set flagCase5 0   ;#Test case 5��־λ
	set flagCase6 0   ;#Test case 6��־λ
	set flagCase7 0   ;#Test case 7��־λ
	set flagCase8 0   ;#Test case 8��־λ
	set flagCase9 0   ;#Test case 8��־λ
	
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
	regsub {/} $GPNTestEth5 {_} GPNTestEth5_cap
	regsub {/} $GPNTestEth6 {_} GPNTestEth6_cap
	
	
	#�������ܣ�TestCase1��ҵ�����
	#acCfg_flag =1 ��AC����    =0ɾ����AC����
	proc TestRepeat_case1 {fileId printWord caseId rateL rateR acCfg_flag} {
		global gpnIp1
		global gpnIp2
		global gpnIp3
		global gpnIp4
		global GPNTestEth1
		global GPNTestEth2
		global GPNTestEth3
		global GPNTestEth4
		
		set flag 0
		SendAndStat_ptn006 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
		$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $::anaFliFrameCfg1 $caseId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		if {$acCfg_flag == 1} {
        		#NE1����
        		if {$GPNPort1Cnt1(cnt22) < $rateL || $GPNPort1Cnt1(cnt22) > $rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=500����֪������������NE1($gpnIp1)\
        				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt22)��û��$rateL-$rateR\��Χ��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=500����֪������������NE1($gpnIp1)\
        				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt22)����$rateL-$rateR\��Χ��" $fileId
        		}
        		if {$GPNPort1Cnt1(cnt33) < $rateL || $GPNPort1Cnt1(cnt33) > $rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=500����֪������������NE1($gpnIp1)\
        				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt33)��û��$rateL-$rateR\��Χ��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=500����֪������������NE1($gpnIp1)\
        				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt33)����$rateL-$rateR\��Χ��" $fileId
        		}
        		if {$GPNPort1Cnt1(cnt44) < $rateL || $GPNPort1Cnt1(cnt44) > $rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=500����֪������������NE1($gpnIp1)\
        				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt44)��û��$rateL-$rateR\��Χ��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=500����֪������������NE1($gpnIp1)\
        				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt44)����$rateL-$rateR\��Χ��" $fileId
        		}
        		#NE2����
        		if {$GPNPort2Cnt1(cnt2) < $rateL || $GPNPort2Cnt1(cnt2) > $rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE2($gpnIp2)\
        				$GPNTestEth2\�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE2($gpnIp2)\
        				$GPNTestEth2\�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
        		}
        		#NE3����
        		if {$GPNPort3Cnt1(cnt3) < $rateL || $GPNPort3Cnt1(cnt3) > $rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE3($gpnIp3)\
        				$GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt3)��û��$rateL-$rateR\��Χ��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE3($gpnIp3)\
        				$GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt3)����$rateL-$rateR\��Χ��" $fileId
        		}
        		#NE4����
        		if {$GPNPort4Cnt1(cnt4) < $rateL || $GPNPort4Cnt1(cnt4) > $rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE4($gpnIp4)\
        				$GPNTestEth4\�յ�tag=500��������������Ϊ$GPNPort4Cnt1(cnt4)��û��$rateL-$rateR\��Χ��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE4($gpnIp4)\
        				$GPNTestEth4\�յ�tag=500��������������Ϊ$GPNPort4Cnt1(cnt4)����$rateL-$rateR\��Χ��" $fileId
        		}
		} else {
			#NE1����
			if {$GPNPort1Cnt1(cnt22) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=500����֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt22)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=500����֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=500��������������0ʵΪ$GPNPort1Cnt1(cnt22)" $fileId
			}
			if {$GPNPort1Cnt1(cnt33) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=500����֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=500��������������0ʵΪ$GPNPort1Cnt1(cnt33)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=500����֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=500��������������0ʵΪ$GPNPort1Cnt1(cnt33)" $fileId
			}
			if {$GPNPort1Cnt1(cnt44) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=500����֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=500��������������0ʵΪ$GPNPort1Cnt1(cnt44)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=500����֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=500��������������0ʵΪ$GPNPort1Cnt1(cnt44)" $fileId
			}
			#NE2����
			if {$GPNPort2Cnt1(cnt2) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�tag=500��������������0ʵΪ$GPNPort2Cnt1(cnt2)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�tag=500��������������0ʵΪ$GPNPort2Cnt1(cnt2)" $fileId
			}
			#NE3����
			if {$GPNPort3Cnt1(cnt3) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�tag=500��������������0ʵΪ$GPNPort3Cnt1(cnt3)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�tag=500��������������0ʵΪ$GPNPort3Cnt1(cnt3)" $fileId
			}
			#NE4����
			if {$GPNPort4Cnt1(cnt4) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=500��������������0ʵΪ$GPNPort4Cnt1(cnt4)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=500��������������0ʵΪ$GPNPort4Cnt1(cnt4)" $fileId
			}
		}
		return $flag
	}
	
	
	#�������ܣ�case2��case9����������
	#etreeCnt = 1��ֻ��etree1  =2������etreeҵ��     =3��ɾ��etree��ac   =4�޸�etree2������
	proc TestRepeat_case2Andcase9 {etreeCnt fileId printWord caseId rateL rateR} {
		global gpnIp1
		global gpnIp2
		global gpnIp3
		global gpnIp4
		global GPNTestEth1
		global GPNTestEth2
		global GPNTestEth3
		global GPNTestEth4
		
		set flag 0
		SendAndStat_ptn006 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
			$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $::anaFliFrameCfg1 $caseId
		SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
			$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $::anaFliFrameCfg0 $caseId
		if {$etreeCnt == 2} {
			SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
			$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
			$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt2 GPNPort2Cnt2 GPNPort3Cnt2 GPNPort4Cnt2 6 $::anaFliFrameCfg6 $caseId
		}
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		#NE1�Ľ���	
		if {$GPNPort1Cnt1(cnt15) < $rateL || $GPNPort1Cnt1(cnt15) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=100��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt15)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=100��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt15)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt1(cnt19) < $rateL || $GPNPort1Cnt1(cnt19) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=100��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt19)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=100��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt19)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt1(cnt20) < $rateL || $GPNPort1Cnt1(cnt20) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt20)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt20)����$rateL-$rateR\��Χ��" $fileId
		}
		
		#NE2����
		if {$GPNPort2Cnt1(cnt14) < $rateL || $GPNPort2Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=100��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�tag=100��������������Ϊ$GPNPort2Cnt1(cnt14)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=100��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�tag=100��������������Ϊ$GPNPort2Cnt1(cnt14)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt0(cnt16) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=100��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt16)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=100��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt16)" $fileId
		}
		if {$GPNPort2Cnt0(cnt58) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt58)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt58)" $fileId
		}
		#NE3����
		if {$GPNPort3Cnt1(cnt14) < $rateL || $GPNPort3Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=100��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=100��������������Ϊ$GPNPort3Cnt1(cnt14)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=100��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=100��������������Ϊ$GPNPort3Cnt1(cnt14)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt0(cnt14) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=100��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt14)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=100��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt14)" $fileId
		}
		if {$GPNPort3Cnt0(cnt58) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt58)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt58)" $fileId
		}
		#NE4����
		
		if {$GPNPort4Cnt1(cnt14) < $rateL || $GPNPort4Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=100��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�tag=100��������������Ϊ$GPNPort4Cnt1(cnt14)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=100��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�tag=100��������������Ϊ$GPNPort4Cnt1(cnt14)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt0(cnt14) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=100��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt14)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\����tag=100��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt14)" $fileId
		}
		if {$GPNPort4Cnt0(cnt16) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=100��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt16)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\����tag=100��δ֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt16)" $fileId
		}
		if {$etreeCnt != 4} {
			if {$GPNPort2Cnt0(cnt2) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt2)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt2)" $fileId
			}
			if {$GPNPort3Cnt0(cnt2) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt2)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt2)" $fileId
			}
			if {$GPNPort4Cnt0(cnt2) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt2)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt2)" $fileId
			}
		}
		if {$etreeCnt == 2} {
			#NE1�Ľ���	
			if {$GPNPort1Cnt2(cnt22) < $rateL || $GPNPort1Cnt2(cnt22) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\�������tag=800�ڲ�tag=500��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort1Cnt2(cnt22)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\�������tag=800�ڲ�tag=500��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort1Cnt2(cnt22)����$rateL-$rateR\��Χ��" $fileId
			}
			if {$GPNPort1Cnt2(cnt32) < $rateL || $GPNPort1Cnt2(cnt32) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\�������tag=800�ڲ�tag=500��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort1Cnt2(cnt32)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\�������tag=800�ڲ�tag=500��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort1Cnt2(cnt32)����$rateL-$rateR\��Χ��" $fileId
			}
			if {$GPNPort1Cnt2(cnt42) < $rateL || $GPNPort1Cnt2(cnt42) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\�������tag=800�ڲ�tag=500��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort1Cnt2(cnt42)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\�������tag=800�ڲ�tag=500��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort1Cnt2(cnt42)����$rateL-$rateR\��Χ��" $fileId
			}
			#NE2�Ľ���	
			if {$GPNPort2Cnt0(cnt1) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
			}
			if {$GPNPort2Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt13)" $fileId
			}
			if {$GPNPort2Cnt2(cnt10) < $rateL || $GPNPort2Cnt2(cnt10) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort2Cnt2(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort2Cnt2(cnt10)����$rateL-$rateR\��Χ��" $fileId
			}
			#NE3�Ľ���	
			if {$GPNPort3Cnt0(cnt1) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
			}
			if {$GPNPort3Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt13)" $fileId
			}
			if {$GPNPort3Cnt2(cnt10) < $rateL || $GPNPort3Cnt2(cnt10) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort3Cnt2(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort3Cnt2(cnt10)����$rateL-$rateR\��Χ��" $fileId
			}
			#NE3�Ľ���	
			if {$GPNPort4Cnt0(cnt1) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
			}
			if {$GPNPort4Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt13)" $fileId
			}
			if {$GPNPort4Cnt2(cnt10) < $rateL || $GPNPort4Cnt2(cnt10) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort4Cnt2(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ����tag=800�ڲ�tag=500��������������Ϊ$GPNPort4Cnt2(cnt10)����$rateL-$rateR\��Χ��" $fileId
			}
		}
		if {$etreeCnt == 3} {
			#NE1�Ľ���	
			if {$GPNPort1Cnt0(cnt53) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\�������tag=800�ڲ�tag=500��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt53)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\�������tag=800�ڲ�tag=500��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt53)" $fileId
			}
			if {$GPNPort1Cnt0(cnt56) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\�������tag=800�ڲ�tag=500��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt56)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\�������tag=800�ڲ�tag=500��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt56)" $fileId
			}
			if {$GPNPort1Cnt0(cnt51) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\�������tag=800�ڲ�tag=500��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt51)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\�������tag=800�ڲ�tag=500��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt51)" $fileId
			}
			#NE2�Ľ���	
			if {$GPNPort2Cnt0(cnt1) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
			}
			if {$GPNPort2Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt13)" $fileId
			}
			if {$GPNPort2Cnt0(cnt69) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt69)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt69)" $fileId
			}
			#NE3�Ľ���	
			if {$GPNPort3Cnt0(cnt1) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
			}
			if {$GPNPort3Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt13)" $fileId
			}
			if {$GPNPort3Cnt0(cnt69) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt69)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt69)" $fileId
			}
			#NE4�Ľ���	
			if {$GPNPort4Cnt0(cnt1) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
			}
			if {$GPNPort4Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt13)" $fileId
			}
			if {$GPNPort4Cnt0(cnt69) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt69)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\�������tag=800�ڲ�tag=500��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt69)" $fileId
			}
		}
		return $flag
	}
	
	###################################################################################
	#��������: case6��ҵ����֤
	#f_broadcast  =1 ��ֹ�㲥ת��
	#f_mcast   =1 ��ֹ�鲥ת��
	#f_unknow  =1 ��ֹδ֪����ת��
	##################################################################################
	proc TestCase6 {printWord rateL0 rateR0 rateL rateR f_broadcast f_mcast f_unknow caseId} {
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
		global anaFliFrameCfg0
		global GPNTestEth1
		global GPNTestEth4
		global fileId
		set flag 0
		
		SendAndStat_ptn006 1 "$hGPNPort1Gen $hGPNPort4Gen" "$hGPNPort1Ana $hGPNPort4Ana" "$GPNTestEth1 $GPNTestEth4" \
			"$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
			"$hGPNPort1AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" GPNPort1Cnt1 GPNPort4Cnt1 TmpCnt1 TmpCnt2 1 $anaFliFrameCfg1 $caseId
		SendAndStat_ptn006 0 "$hGPNPort1Gen $hGPNPort4Gen" "$hGPNPort1Ana $hGPNPort4Ana" "$GPNTestEth1 $GPNTestEth4" \
			"$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
			"$hGPNPort1AnaFrameCfgFil $hGPNPort4AnaFrameCfgFil" GPNPort1Cnt0 GPNPort4Cnt0 TmpCnt1 TmpCnt2 0 $anaFliFrameCfg0 $caseId
		
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		if {$f_broadcast == 1} {
			if {$GPNPort1Cnt0(cnt12) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt12)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt12)" $fileId
			}
			if {$GPNPort4Cnt0(cnt10) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt10)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt10)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt12) < $rateL0 || $GPNPort1Cnt1(cnt12) > $rateR0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt12)��û��$rateL0-$rateR0\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt12)����$rateL0-$rateR0\��Χ��" $fileId
			}
			if {$GPNPort4Cnt1(cnt10) < $rateL0 || $GPNPort4Cnt1(cnt10) > $rateR0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt10)��û��$rateL0-$rateR0\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt10)����$rateL0-$rateR0\��Χ��" $fileId
			}
		}
		if {$f_mcast == 1} {
			if {$GPNPort1Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt13)" $fileId
			}
			if {$GPNPort4Cnt0(cnt11) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt11)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt11)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt13) < $rateL || $GPNPort1Cnt1(cnt13) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt13)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥��������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt13)����$rateL-$rateR\��Χ��" $fileId
			}
			if {$GPNPort4Cnt1(cnt11) < $rateL || $GPNPort4Cnt1(cnt11) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt11)����$rateL-$rateR\��Χ��" $fileId
			}
		}
		if {$f_unknow == 1} {
			if {$GPNPort1Cnt0(cnt68) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt68)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt68)" $fileId
			}
			if {$GPNPort4Cnt0(cnt50) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt50)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt50)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt68) < $rateL || $GPNPort1Cnt1(cnt68) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt68)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=800��δ֪������������NE1($gpnIp1)\
					$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt68)����$rateL-$rateR\��Χ��" $fileId
			}
			if {$GPNPort4Cnt1(cnt59) < $rateL || $GPNPort4Cnt1(cnt59) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt59)��û��$rateL-$rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����tag=800��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt59)����$rateL-$rateR\��Χ��" $fileId
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
	set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3 \"media $GPNEth3Media\" \
		$GPNStcPort4 \"media $GPNEth4Media\" $GPNStcPort5 \"media $GPNEth5Media\" $GPNStcPort6 \"media $GPNEth6Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4 hGPNPort5 hGPNPort6
	
        ###������������
        gwd::STC_Create_Stream $fileId dataArr1 $hGPNPort1 hGPNPort1Stream1
        gwd::STC_Create_VlanStream $fileId dataArr2 $hGPNPort1 hGPNPort1Stream2
        gwd::STC_Create_VlanStream $fileId dataArr3 $hGPNPort1 hGPNPort1Stream3
        gwd::STC_Create_VlanStream $fileId dataArr4 $hGPNPort1 hGPNPort1Stream4
        gwd::STC_Create_Stream $fileId dataArr5 $hGPNPort1 hGPNPort1Stream5
        gwd::STC_Create_Stream $fileId dataArr6 $hGPNPort1 hGPNPort1Stream6
        gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort1 hGPNPort1Stream7
        gwd::STC_Create_VlanStream $fileId dataArr8 $hGPNPort1 hGPNPort1Stream8
        gwd::STC_Create_VlanStream $fileId dataArr9 $hGPNPort2 hGPNPort2Stream9
        gwd::STC_Create_VlanStream $fileId dataArr10 $hGPNPort3 hGPNPort3Stream10
        gwd::STC_Create_VlanStream $fileId dataArr11 $hGPNPort4 hGPNPort4Stream11
        gwd::STC_Create_VlanStream $fileId dataArr7 $hGPNPort2 hGPNPort2Stream7
        gwd::STC_Create_VlanStream $fileId dataArr8 $hGPNPort2 hGPNPort2Stream8
        gwd::STC_Create_Stream $fileId dataArr5 $hGPNPort3 hGPNPort3Stream7
        gwd::STC_Create_Stream $fileId dataArr6 $hGPNPort3 hGPNPort3Stream8
        gwd::STC_Create_VlanStream $fileId dataArr12 $hGPNPort4 hGPNPort4Stream7
        gwd::STC_Create_VlanStream $fileId dataArr13 $hGPNPort4 hGPNPort4Stream8
        gwd::STC_Create_VlanStream $fileId dataArr14 $hGPNPort1 hGPNPort1Stream14
        gwd::STC_Create_VlanStream $fileId dataArr15 $hGPNPort2 hGPNPort2Stream15
        gwd::STC_Create_VlanStream $fileId dataArr16 $hGPNPort3 hGPNPort3Stream16
        gwd::STC_Create_VlanStream $fileId dataArr17 $hGPNPort4 hGPNPort4Stream17
        gwd::STC_Create_VlanStream $fileId dataArr18 $hGPNPort3 hGPNPort3Stream18
        gwd::STC_Create_VlanSmacModiferStream $fileId dataArr19 $hGPNPort1 hGPNPort1Stream19
        gwd::STC_Create_VlanStream $fileId dataArr20 $hGPNPort1 hGPNPort1Stream20
        
        gwd::STC_Create_VlanMplsCustomStream $fileId dataArr27 $hGPNPort1 hGPNPort1Stream27
        gwd::STC_Create_VlanMplsCustomStream $fileId dataArr28 $hGPNPort2 hGPNPort2Stream28
        gwd::STC_Create_VlanMplsCustomStream $fileId dataArr29 $hGPNPort4 hGPNPort4Stream29
	
	gwd::STC_Create_VlanStream $fileId dataArr21 $hGPNPort1 hGPNPort1Stream21
	gwd::STC_Create_VlanStream $fileId dataArr22 $hGPNPort1 hGPNPort1Stream22
	gwd::STC_Create_VlanStream $fileId dataArr23 $hGPNPort2 hGPNPort2Stream23
	gwd::STC_Create_VlanStream $fileId dataArr24 $hGPNPort3 hGPNPort3Stream24
	gwd::STC_Create_VlanStream $fileId dataArr25 $hGPNPort4 hGPNPort4Stream25
	gwd::STC_Create_VlanStream $fileId dataArr30 $hGPNPort1 hGPNPort1Stream30
	
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr26 $hGPNPort1 hGPNPort1Stream26
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr31 $hGPNPort2 hGPNPort2Stream31
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr32 $hGPNPort3 hGPNPort3Stream32
	gwd::STC_Create_DoubleVlan_Stream $fileId dataArr33 $hGPNPort4 hGPNPort4Stream33
	
	set hGPNPortStreamList7 "$hGPNPort1Stream20 $hGPNPort1Stream21 $hGPNPort1Stream22 $hGPNPort2Stream23 $hGPNPort3Stream24 $hGPNPort4Stream25"
	set hGPNPortStreamList8 "$hGPNPort1Stream26 $hGPNPort2Stream31 $hGPNPort3Stream32 $hGPNPort4Stream33 $hGPNPort1Stream20 $hGPNPort1Stream1"
        set hGPNPortStreamList "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream5 $hGPNPort1Stream7 $hGPNPort1Stream6 $hGPNPort1Stream8 $hGPNPort1Stream3\
                                $hGPNPort1Stream4 $hGPNPort2Stream9 $hGPNPort3Stream10 $hGPNPort4Stream11 $hGPNPort2Stream7 $hGPNPort2Stream8 $hGPNPort3Stream7\
        	                $hGPNPort3Stream8 $hGPNPort4Stream7 $hGPNPort4Stream8 $hGPNPort1Stream14 $hGPNPort2Stream15 $hGPNPort3Stream16 $hGPNPort4Stream17\
                                $hGPNPort3Stream18 $hGPNPort1Stream19 $hGPNPort1Stream20 $hGPNPort1Stream26 $hGPNPort1Stream27 $hGPNPort2Stream28 $hGPNPort4Stream29"
        set hGPNPortStreamList1 "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream5 $hGPNPort1Stream7 $hGPNPort1Stream6 $hGPNPort1Stream8"
        set hGPNPortStreamList2 "$hGPNPort1Stream2 $hGPNPort1Stream3 $hGPNPort1Stream4 $hGPNPort2Stream9 $hGPNPort3Stream10 $hGPNPort4Stream11"
        set hGPNPortStreamList3 "$hGPNPort2Stream9 $hGPNPort2Stream7 $hGPNPort2Stream8 $hGPNPort3Stream10 $hGPNPort3Stream7 $hGPNPort3Stream8 $hGPNPort4Stream11 $hGPNPort4Stream7 $hGPNPort4Stream8"
        set hGPNPortStreamList5 "$hGPNPort1Stream2 $hGPNPort1Stream14 $hGPNPort2Stream15 $hGPNPort3Stream16 $hGPNPort4Stream17"
        set hGPNPortStreamList6 "$hGPNPort1Stream27 $hGPNPort2Stream28 $hGPNPort4Stream29"
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
        gwd::Get_Generator $hGPNPort6 hGPNPort6Gen
        gwd::Get_Analyzer $hGPNPort6 hGPNPort6Ana
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
	
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort6 txInfoArr hGPNPort6TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort6 rxInfoArr1 hGPNPort6RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort6 rxInfoArr2 hGPNPort6RxInfo2
        ###������������ 10%��Mbps
        foreach stream "$hGPNPortStreamList $hGPNPortStreamList7 $hGPNPort1Stream30 $hGPNPortStreamList8" {
        	stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        }
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList $hGPNPortStreamList7 $hGPNPort1Stream30 $hGPNPortStreamList8" \
		-activate "false"
        stc::apply 
        ###��ȡ����������ָ��
        gwd::Get_GeneratorCfgObj $hGPNPort1Gen hGPNPort1GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort2Gen hGPNPort2GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort3Gen hGPNPort3GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort4Gen hGPNPort4GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort5Gen hGPNPort5GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort6Gen hGPNPort6GenCfg
        set hGPNPortGenCfgList "$hGPNPort1GenCfg $hGPNPort2GenCfg $hGPNPort3GenCfg $hGPNPort4GenCfg $hGPNPort5GenCfg $hGPNPort6GenCfg"
        foreach hGenCfg $hGPNPortGenCfgList {
        	gwd::Cfg_GeneratorCfgObj $hGenCfg $GenCfg
        }
        ###���������ù�������Ĭ�Ϲ���tag
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort1Ana hGPNPort1AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort2Ana hGPNPort2AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort3Ana hGPNPort3AnaFrameCfgFil	
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort4Ana hGPNPort4AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort5Ana hGPNPort5AnaFrameCfgFil
        gwd::Create_AnalyzerFrameCfgFilter $hGPNPort6Ana hGPNPort6AnaFrameCfgFil
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
                gwd::Get_Capture $hGPNPort6 hGPNPort6Cap
                gwd::Create_FilterAnalyzer $hGPNPort1Cap hGPNPort1CapFilter hGPNPort1CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort2Cap hGPNPort2CapFilter hGPNPort2CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort3Cap hGPNPort3CapFilter hGPNPort3CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort4Cap hGPNPort4CapFilter hGPNPort4CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort5Cap hGPNPort5CapFilter hGPNPort5CapAnalyzer
                gwd::Create_FilterAnalyzer $hGPNPort6Cap hGPNPort6CapFilter hGPNPort6CapAnalyzer
                array set capArr {capMode "REGULAR_MODE" capSource "Tx_Rx_MODE"}
                set hGPNPortCapList "$hGPNPort1Cap $hGPNPort2Cap $hGPNPort3Cap $hGPNPort4Cap"
                set hGPNPortCapAnalyzerList "$hGPNPort1CapAnalyzer $hGPNPort2CapAnalyzer $hGPNPort3CapAnalyzer $hGPNPort4CapAnalyzer"
        }
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-TREE������֤ LSP PW�������Ի������ÿ�ʼ...\n"
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
        set mslot2 [gwd::GWpulic_getWorkCardList $managePort2]
        gwd::GWpublic_print "OK" "��ȡ�豸NE2($gpnIp2)��������ڰ忨��λ��$mslot2" $fileId

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
	###������ӿ����ò���
	if {[string match "L2" $Worklevel]} {
		set interface15 v4
		set interface16 v7
		set interface17 v4
		set interface18 v5
		set interface19 v5
		set interface20 v7
		set interface21 v6
		set interface22 v6
	} else {
		set interface15 $GPNPort5.4
		set interface16 $GPNPort12.7
		set interface17 $GPNPort6.4
		set interface18 $GPNPort7.5
		set interface19 $GPNPort8.5
		set interface21 $GPNPort9.6
		set interface22 $GPNPort10.6
		set interface20 $GPNPort11.7
	}
        set Portlist "$GPNPort5 $GPNPort12 $GPNPort6 $GPNPort7 $GPNPort8 $GPNPort9 $GPNPort10 $GPNPort11"
        set Portlist0 "$GPNTestEth1 $GPNTestEth2 $GPNTestEth3 $GPNTestEth4"
        set Iplist "$ip612 $ip614 $ip621 $ip623 $ip632 $ip634 $ip643 $ip641"
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-TREE������֤ LSP PW�������Ի�������ʧ�ܣ����Խ���" \
		"E-TREE������֤ LSP PW�������Ի������óɹ�����������Ĳ���" "GPN_PTN_010"
        puts $fileId ""
        puts $fileId "===E-TREE������֤ LSP PW�������Ի������ý���..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 ����vplsTypeΪrawģʽ���û������ģʽΪ�˿�ģʽ��֤ETREEҵ��\n"
        #   <1>��̨76�������������˼�����ͼ7��NE1�豸ͨ������������,NE2��NE3��NE4�豸ͨ�����������ܣ���4̨�豸��DCN������̨�豸�˴�֮���NNI�˿�ͨ����̫���ӿ���ʽ������NNI�˿���untag��ʽ���뵽VLANIF��
        #   <2>��NE1��NE4��NE3ΪPE��ɫ��PE2��ΪPE��ΪP��ɫ��NE1��NE3��treeҵ�񾭹�NE2����ʱNE2Ϊp
        #   <3>�������ڵ�NE1�Ķ˿�1����Ҷ�ӽڵ�NE2/NE4/NE3�Ķ˿�2/4/3��EP-Treeҵ���û��ࣨGE�˿ڣ�����ģʽΪ�˿�ģʽ
        #      ����NE1��NE2��LSP���ǩ17������ǩ17��PW1���ر�ǩ1000��Զ�̱�ǩ1000��
        #      ����NE1��NE4��LSP���ǩ18������ǩ18��PW1���ر�ǩ2000��Զ�̱�ǩ2000��
        #      ����NE1��NE3��LSP���ǩ20������ǩ21��PW1���ر�ǩ3000��Զ�̱�ǩ3000��
        #      ����NE3��NE1��LSP���ǩ22������ǩ23��PW1���ر�ǩ3000��Զ�̱�ǩ3000��
        #      NE2�豸������lsp�ı�ǩ������NE2��LSP���ǩ21����Ϊ����ǩ22��NE2��LSP���ǩ23����Ϊ����ǩ20��
        #   <4>��NE1/NE2/NE3/NE4��ΪPE��ɫ��NE1��NE3��treeҵ�񾭹�NE2����ʱNE2�ϵ�����pw,��NE1����Ϊroot��ɫ����NE3����Ϊnone(Ҷ��)��ɫ
        #   <5>�������ڵ�NE1�Ķ˿�1����Ҷ�ӽڵ�NE2/NE4/NE3�Ķ˿�2/4/3��EP-Treeҵ���������£������ǩ����
        #      ����NE1��NE2��LSP���ǩ17������ǩ17��PW1���ر�ǩ1000��Զ�̱�ǩ1000��
        #      ����NE1��NE4��LSP���ǩ18������ǩ18��PW1���ر�ǩ2000��Զ�̱�ǩ2000��
        #      ����NE2��NE3��LSP���ǩ20������ǩ20��PW1���ر�ǩ3000��Զ�̱�ǩ3000��
        #   <6>���û���˿�������undo vlan check;
        #   Ԥ�ڽ��:ϵͳ���쳣���鿴������ȷ������ҵ����������ҵ������ת����NE2/NE3/NE4��̨�豸��Ϊ���ڹ��������
        #����E-Tree��ep-tree��ҵ����֤ 
        #      �����������ã�ep-tree��
        #      NE1����untag/tag�Ĺ㲥����NE2/NE3/NE4�豸��Ҷ�Ӷ˿ڶ����յ���
        #      NE1����untag/tag���鲥����NE2/NE3/NE4�豸��Ҷ�Ӷ˿ڶ����յ���
        #      NE1����untag/tag�ĵ�������NE2/NE3/NE4�豸��Ҷ�Ӷ˿ڶ����յ���
        #      NE1��NE2�Ļ���untag/tag��֪������NE3��NE4�豸Ҷ�Ӷ˿��ղ������ݣ�
        #      NE1��NE3�Ļ���untag/tag��֪������NE2��NE4�豸Ҷ�Ӷ˿��ղ������ݣ�
        #      NE1��NE4�Ļ���untag/tag��֪������NE2��NE3�豸Ҷ�Ӷ˿��ղ������ݣ�
        #   <7>NE2,NE4,NE3����untag/tag�Ĺ㲥/����/�鲥��
        #   Ԥ�ڽ������NE1���յ����ݣ�����Ҷ�ӽڵ㲻���յ���Ҷ�ӽڵ��Ҷ�Ӷ˿ڼ䲻�ܻ�ͨ��
        #             ����NE1��NNI�˿�egress�����ģ�Ϊ����VLAN TAG��ǩ��mpls��ǩ���ģ����lsp��ǩ17���ڲ�pw��ǩ1000,��
        #            LSP�ֶ��е�TTLֵΪ255��PW�ֶ��е�TTLֵΪ255��PW�ֶ��к���4�ֽڿ�����
        #   <8>undo shutdown��shutdown NE1�豸��NNI/UNI�˿�50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
        #   <9>����NE1�豸��NNI/UNI�˿����ڰ忨50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 
        #   <10>NE1�豸����SW/NMS����50�Σ�ÿ�β�����ҵ��ָ�������ϵͳ���쳣 ���鿴��ǩת��������ȷ����̨�豸��������
        #   <11>��������NE1�豸��50�Σ�ÿ�β�����ϵͳ����������ҵ��ָ�������ϵͳ���쳣���鿴��ǩת��������ȷ����̨�豸�������� 
        #   <12>��ɾ���������£�ɾ��NE1��NE2��NE3��NE4�ϵ�ac���鿴����acɾ���ɹ�,pw����İ��ǲ�ɾ���ģ�NE1������3̨�豸��ҵ���жϣ�ϵͳ���쳣
        #   <13>�������ac���鿴������ӳɹ�������ҵ����֤��Ч
	#   <14>ɾ��NE1��NE2��NE3��NE4�豸�Ļ��ҵ��AC+vpls�򣩣��鿴����ɾ���ɹ���ac��vpls��������ʧ��ҵ���жϣ�ϵͳ���쳣
	#   <15>���´���NE1��NE2��NE3��NE4�ϵĻ��ҵ��AC+vpls��,����α�߲������ģ���ac����ģʽ��Ϊ���˿�+��Ӫ��VLAN��������evp-Treeҵ��
        ########========vplsΪrawģʽ����==========#########
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1����untag/tag��δ֪�������㲥���鲥������ҵ��  ���Կ�ʼ=====\n"
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
	set flag11_case1 0
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
		if {[string match "L2" $Worklevel]}  {
        		gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port1 "enable"
        		gwd::GWpublic_CfgVlanStack $telnet $matchType $Gpn_type $fileId $port2 "enable"
		}
                ###����undo vlan check
                if {[string match "L2" $Worklevel]} {
        		gwd::GWpublic_CfgVlanCheck $telnet $matchType $Gpn_type $fileId $eth "disable"
                }
                PTN_NNI_AddInterIp $fileId $Worklevel $interface1 $Ip1 $port1 $matchType $Gpn_type $telnet
                PTN_NNI_AddInterIp $fileId $Worklevel $interface2 $Ip2 $port2 $matchType $Gpn_type $telnet
		gwd::GWpublic_disableStorm $telnet $matchType $Gpn_type $fileId $eth "bcast"
		gwd::GWpublic_disableStorm $telnet $matchType $Gpn_type $fileId $port1 "bcast"
		gwd::GWpublic_disableStorm $telnet $matchType $Gpn_type $fileId $port2 "bcast"
        	gwd::GWVpls_AddInfo $telnet $matchType $Gpn_type $fileId "vpls$id" $id "etree" "flood" "false" "false" "false" "true" "2000" "" "raw"
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
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "2000" "2000" "" "delete" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "3000" "3000" "" "delete" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "0" "0" "root" "delete" "1" "0" "0" "0x8100" "evc2"
	
	gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface17 $ip612 "17" "17" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
	gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface18 $ip632 "21" "22" "0" 23 "normal"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface17 $ip612 "23" "20" "0" 21 "normal"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "delete" "root" 1 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac1" "vpls2" "" $GPNTestEth2 "0" "0" "leaf" "delete" "1" "0" "0" "0x8100" "evc2"
	
	gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $interface19 $ip623 "22" "23" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $address631
	gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "3000" "3000" "" "delete" "root" 1 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "vpls3" "" $GPNTestEth3 "0" "0" "leaf" "delete" "1" "0" "0" "0x8100" "evc2"
	
	gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $interface20 $ip614 "18" "18" "normal" "1"
	gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $address641
	gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "2000" "2000" "" "delete" "root" 1 0 "0x8100" "0x8100" "1"
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac1" "vpls4" "" $GPNTestEth4 "0" "0" "leaf" "delete" "1" "0" "0" "0x8100" "evc2"
		
	

	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream6 $hGPNPort1Stream8" \
		-activate "true"
	incr capId
	SendAndStat_ptn006 1 "$hGPNPort1Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_010_$capId"
	SendAndStat_ptn006 0 "$hGPNPort1Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 7 $anaFliFrameCfg7 "GPN_PTN_010_$capId"
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE2����
	if {$GPNPort2Cnt0(cnt10) < $rateL || $GPNPort2Cnt0(cnt10) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt0(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt0(cnt10)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt0(cnt6) < $rateL || $GPNPort2Cnt0(cnt6) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag���鲥��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt0(cnt6)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag���鲥��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt0(cnt6)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt1(cnt2) < $rateL || $GPNPort2Cnt1(cnt2) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt1(cnt11) < $rateL || $GPNPort2Cnt1(cnt11) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt11)����$rateL-$rateR\��Χ��" $fileId
	}
	#NE3����
	if {$GPNPort3Cnt0(cnt10) < $rateL || $GPNPort3Cnt0(cnt10) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�untag��������������Ϊ$GPNPort3Cnt0(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�untag��������������Ϊ$GPNPort3Cnt0(cnt10)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt0(cnt6) < $rateL || $GPNPort3Cnt0(cnt6) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag���鲥��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�untag��������������Ϊ$GPNPort3Cnt0(cnt6)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag���鲥��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�untag��������������Ϊ$GPNPort3Cnt0(cnt6)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt1(cnt2) < $rateL || $GPNPort3Cnt1(cnt2) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt1(cnt11) < $rateL || $GPNPort3Cnt1(cnt11) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt11)����$rateL-$rateR\��Χ��" $fileId
	}
	#NE4����
	if {$GPNPort4Cnt0(cnt10) < $rateL || $GPNPort4Cnt0(cnt10) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt0(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt0(cnt10)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt0(cnt6) < $rateL || $GPNPort4Cnt0(cnt6) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag���鲥��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt0(cnt6)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag���鲥��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt0(cnt6)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt1(cnt2) < $rateL || $GPNPort4Cnt1(cnt2) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=500��������������Ϊ$GPNPort4Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=500��������������Ϊ$GPNPort4Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt1(cnt11) < $rateL || $GPNPort4Cnt1(cnt11) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=800���鲥��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt11)����$rateL-$rateR\��Χ��" $fileId
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream5" \
		-activate "true"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream6 $hGPNPort1Stream8" \
		-activate "false"
	incr capId
	SendAndStat_ptn006 1 "$hGPNPort1Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 7 $anaFliFrameCfg7 "GPN_PTN_010_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	if {$GPNPort2Cnt0(cnt5) < $rateL0 || $GPNPort2Cnt0(cnt5) > $rateR0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag�Ĺ㲥��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt0(cnt5)��û��$rateL0-$rateR0\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag�Ĺ㲥��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt0(cnt5)����$rateL0-$rateR0\��Χ��" $fileId
	}
	if {$GPNPort3Cnt0(cnt5) < $rateL0 || $GPNPort3Cnt0(cnt5) > $rateR0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag�Ĺ㲥��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�untag��������������Ϊ$GPNPort3Cnt0(cnt5)��û��$rateL0-$rateR0\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag�Ĺ㲥��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�untag��������������Ϊ$GPNPort3Cnt0(cnt5)����$rateL0-$rateR0\��Χ��" $fileId
	}
	if {$GPNPort4Cnt0(cnt5) < $rateL0 || $GPNPort4Cnt0(cnt5) > $rateR0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag�Ĺ㲥��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt0(cnt5)��û��$rateL0-$rateR0\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag�Ĺ㲥��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt0(cnt5)����$rateL0-$rateR0\��Χ��" $fileId
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream5" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream7" \
		-activate "true"
	incr capId
	SendAndStat_ptn006 1 "$hGPNPort1Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_010_$capId"
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	
	if {$GPNPort2Cnt1(cnt10) < $rateL0 || $GPNPort2Cnt1(cnt10) > $rateR0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt10)��û��$rateL0-$rateR0\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt10)����$rateL0-$rateR0\��Χ��" $fileId
	}
	if {$GPNPort3Cnt1(cnt10) < $rateL0 || $GPNPort3Cnt1(cnt10) > $rateR0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt10)��û��$rateL0-$rateR0\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt10)����$rateL0-$rateR0\��Χ��" $fileId
	}
	if {$GPNPort4Cnt1(cnt10) < $rateL0 || $GPNPort4Cnt1(cnt10) > $rateR0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt10)��û��$rateL0-$rateR0\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=800�Ĺ㲥��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt10)����$rateL0-$rateR0\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1����untag/tag��δ֪�������㲥���鲥������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1����untag/tag��δ֪�������㲥���鲥������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1����untag/tag��δ֪�������㲥���鲥������ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1��NE2/NE3/NE4 ����vid=500����֪����������ҵ��  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream7" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList2" \
		-activate "true"
	incr capId
	if {[TestRepeat_case1 $fileId "" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
		set flag2_case1 1
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1��NE2/NE3/NE4 ����vid=500����֪����������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1��NE2/NE3/NE4 ����vid=500����֪����������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1��NE2/NE3/NE4 ����vid=500����֪����������ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE2��NE3��NE4 ����untag/tag��������������ҵ��  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList2" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList3" \
		-activate "true"
	incr capId
	SendAndStat_ptn006 1 "$hGPNPort2Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_010_$capId"
	SendAndStat_ptn006 0 "$hGPNPort2Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 7 $anaFliFrameCfg7 "GPN_PTN_010_$capId"
	SendAndStat_ptn006 0 "$hGPNPort2Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $anaFliFrameCfg0 "GPN_PTN_010_$capId"
	
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE1�Ľ���
	if {$GPNPort1Cnt1(cnt22) < $rateL || $GPNPort1Cnt1(cnt22) > $rateR} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\����tag=500�ĵ�������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt22)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\����tag=500�ĵ�������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt22)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt1(cnt10) < $rateL0 || $GPNPort1Cnt1(cnt10) > $rateR0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\����tag=800�Ĺ㲥����NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt10)��û��$rateL0-$rateR0\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\����tag=800�Ĺ㲥����NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt10)����$rateL0-$rateR0\��Χ��" $fileId
	}
	if {$GPNPort1Cnt1(cnt11) < $rateL || $GPNPort1Cnt1(cnt11) > $rateR} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\����tag=800���鲥����NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\����tag=800���鲥����NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt11)����$rateL-$rateR\��Χ��" $fileId
	}
	#NE3�Ľ���
	if {$GPNPort3Cnt0(cnt02) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\����tag=500�ĵ�������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt02)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\����tag=500�ĵ�������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt02)" $fileId
	}
	if {$GPNPort3Cnt0(cnt10) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\����tag=800�Ĺ㲥����NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt10)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\����tag=800�Ĺ㲥����NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt10)" $fileId
	}
	if {$GPNPort3Cnt0(cnt11) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\����tag=800���鲥����NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt11)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\����tag=800���鲥����NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt11)" $fileId
	}
	if {$GPNPort4Cnt0(cnt02) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\����tag=500�ĵ�������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt02)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\����tag=500�ĵ�������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt02)" $fileId
	}
	if {$GPNPort4Cnt0(cnt10) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\����tag=800�Ĺ㲥����NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt10)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\����tag=800�Ĺ㲥����NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt10)" $fileId
	}
	if {$GPNPort4Cnt0(cnt11) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\����tag=800���鲥����NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt11)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\����tag=800���鲥����NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt11)" $fileId
	}
	incr capId
	SendAndStat_ptn006 1 "$hGPNPort3Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_010_$capId"
	SendAndStat_ptn006 0 "$hGPNPort3Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 7 $anaFliFrameCfg7 "GPN_PTN_010_$capId"
	SendAndStat_ptn006 0 "$hGPNPort3Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $anaFliFrameCfg0 "GPN_PTN_010_$capId"
	
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE1�Ľ���
	if {$GPNPort1Cnt1(cnt33) < $rateL || $GPNPort1Cnt1(cnt33) > $rateR} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\����tag=500�ĵ�������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt33)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\����tag=500�ĵ�������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt33)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt7(cnt5) < $rateL0 || $GPNPort1Cnt7(cnt5) > $rateR0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\����untag�Ĺ㲥����NE1($gpnIp1)\
			$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt5)��û��$rateL0-$rateR0\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\����untag�Ĺ㲥����NE1($gpnIp1)\
			$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt5)����$rateL0-$rateR0\��Χ��" $fileId
	}
	if {$GPNPort1Cnt7(cnt6) < $rateL || $GPNPort1Cnt7(cnt6) > $rateR} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\����untag���鲥����NE1($gpnIp1)\
			$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt6)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\����untag���鲥����NE1($gpnIp1)\
			$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt6)����$rateL-$rateR\��Χ��" $fileId
	}
	#NE2�Ľ���
	if {$GPNPort2Cnt0(cnt03) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\����tag=500�ĵ�������NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt03)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\����tag=500�ĵ�������NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt03)" $fileId
	}
	if {$GPNPort2Cnt0(cnt5) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\����untag�Ĺ㲥����NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt5)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\����untag�Ĺ㲥����NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt5)" $fileId
	}
	if {$GPNPort2Cnt0(cnt6) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\����untag���鲥����NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt6)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\����untag���鲥����NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt6)" $fileId
	}
	#NE4�Ľ���
	if {$GPNPort4Cnt0(cnt03) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\����tag=500�ĵ�������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt03)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\����tag=500�ĵ�������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt03)" $fileId
	}
	if {$GPNPort4Cnt0(cnt5) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\����untag�Ĺ㲥����NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt5)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\����untag�Ĺ㲥����NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt5)" $fileId
	}
	if {$GPNPort4Cnt0(cnt6) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\����untag���鲥����NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt6)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\����untag���鲥����NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt6)" $fileId
	}
	incr capId
	SendAndStat_ptn006 1 "$hGPNPort4Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_010_$capId"
	SendAndStat_ptn006 0 "$hGPNPort4Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 7 $anaFliFrameCfg7 "GPN_PTN_010_$capId"
	SendAndStat_ptn006 0 "$hGPNPort4Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $anaFliFrameCfg0 "GPN_PTN_010_$capId"
	
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE1�Ľ���
	if {$GPNPort1Cnt1(cnt44) < $rateL || $GPNPort1Cnt1(cnt44) > $rateR} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����tag=500�ĵ�������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt44)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����tag=500�ĵ�������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt44)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt1(cnt12) < $rateL0 || $GPNPort1Cnt1(cnt12) > $rateR0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥����NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt12)��û��$rateL0-$rateR0\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥����NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt12)����$rateL0-$rateR0\��Χ��" $fileId
	}
	if {$GPNPort1Cnt1(cnt13) < $rateL || $GPNPort1Cnt1(cnt13) > $rateR} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥����NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt13)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥����NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt13)����$rateL-$rateR\��Χ��" $fileId
	}
	#NE2�Ľ���
	if {$GPNPort2Cnt0(cnt04) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����tag=500�ĵ�������NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt04)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����tag=500�ĵ�������NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt04)" $fileId
	}
	if {$GPNPort2Cnt0(cnt12) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥����NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt12)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥����NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt12)" $fileId
	}
	if {$GPNPort2Cnt0(cnt13) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥����NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt13)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥����NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt13)" $fileId
	}
	#NE3�Ľ���
	if {$GPNPort3Cnt0(cnt04) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����tag=500�ĵ�������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt04)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����tag=500�ĵ�������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt04)" $fileId
	}
	if {$GPNPort3Cnt0(cnt12) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥����NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt12)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����tag=800�Ĺ㲥����NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt12)" $fileId
	}
	if {$GPNPort3Cnt0(cnt13) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥����NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt13)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����tag=800���鲥����NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt13)" $fileId
	}
	
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE2��NE3��NE4 ����untag/tag��������������ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE2��NE3��NE4 ����untag/tag��������������ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE2��NE3��NE4 ����untag/tag��������������ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ������NE1($gpnIp1)��NE2($gpnIp2)��NE4($gpnIp4)��NNI���ڷ����Ĳ���MPLS��ǩ  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList3" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort2Stream9 $hGPNPort1Stream4 $hGPNPort4Stream11" \
		-activate "true"
	gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPort5AnaFrameCfgFil $anaFliFrameCfg2
	
	foreach aTmpCnt "GPNPort5Cnt2 GPNPort5Cnt20" {
		array set $aTmpCnt {cnt10 0 cnt12 0} 
	}
	array set aMirror "dir1 egress port1 $GPNPort5 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	gwd::Start_CapAllData capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
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
	incr capId
	gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_010_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	if {$GPNPort5Cnt2(cnt10) < $rateL1 || $GPNPort5Cnt2(cnt10) > $rateR1} {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)��NE2($gpnIp2)���෢��tag=500����֪������������NE1($gpnIp1)$GPNTestEth5�ھ���NNI��$GPNPort5\
			�ĳ����յ���mpls���ĵ�lsp��ǩ=17��pw��ǩ=1000������������Ϊ$GPNPort5Cnt2(cnt10)��û��$::rateL1-$::rateR1\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)��NE2($gpnIp2)���෢��tag=500����֪������������NE1($gpnIp1)$GPNTestEth5�ھ���NNI��$GPNPort5\
			�ĳ����յ���mpls���ĵ�lsp��ǩ=17��pw��ǩ=1000������������Ϊ$GPNPort5Cnt2(cnt10)����$::rateL1-$::rateR1\��Χ��" $fileId
	}
	
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	array set aMirror "dir1 egress port1 $GPNPort12 dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5 aMirror
	gwd::Start_CapAllData capArr $hGPNPort5Cap $hGPNPort5CapAnalyzer
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
	incr capId
	gwd::Stop_CapData $hGPNPort5Cap 1 "GPN_PTN_010_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	if {$GPNPort5Cnt20(cnt12) < $rateL1 || $GPNPort5Cnt20(cnt12) > $rateR1} {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)��NE4($gpnIp4)���෢��tag=500����֪������������NE1($gpnIp1)$GPNTestEth5�ھ���NNI��$GPNPort12\
			�ĳ����յ���mpls���ĵ�lsp��ǩ=18��pw��ǩ=2000������������Ϊ$GPNPort5Cnt20(cnt12)��û��$rateL1-$rateR1\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)��NE4($gpnIp4)���෢��tag=500����֪������������NE1($gpnIp1)$GPNTestEth5�ھ���NNI��$GPNPort12\
			�ĳ����յ���mpls���ĵ�lsp��ǩ=18��pw��ǩ=2000������������Ϊ$GPNPort5Cnt20(cnt12)����$rateL1-$rateR1\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA4�����ۣ�����NE1($gpnIp1)��NE2($gpnIp2)��NE4($gpnIp4)��NNI���ڷ����Ĳ���MPLS��ǩ" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4�����ۣ�����NE1($gpnIp1)��NE2($gpnIp2)��NE4($gpnIp4)��NNI���ڷ����Ĳ���MPLS��ǩ" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ������NE1($gpnIp1)��NE2($gpnIp2)��NE4($gpnIp4)��NNI���ڷ����Ĳ���MPLS��ǩ  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)����shut undoshut NNI�ں����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort2Stream9 $hGPNPort1Stream4 $hGPNPort4Stream11" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList2" \
		-activate "true"
	##����undo shutdown/shutdown�˿�
	foreach eth $portlist1 {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
		for {set j 1} {$j<=$cnt} {incr j} {
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
			after $WaiteTime
			incr capId
			if {[TestRepeat_case1 $fileId "��$j\��shutdown/undo shutdown NE1($gpnIp1)��$eth\�˿ں�" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
				set  flag5_case1 1
			}
			
		}
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag5_case1 1
			gwd::GWpublic_print "NOK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA5�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)����shut undoshut NNI�ں����ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)����shut undoshut NNI�ں����ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)����shut undoshut NNI�ں����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
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
				if {[TestRepeat_case1 $fileId "��$j\������NE1($gpnIp1)$slot\��λ�忨" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
					set  flag6_case1 1
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
				set flag6_case1 1
				gwd::GWpublic_print "NOK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
			}
		}
	}
	puts $fileId ""
	if {$flag6_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA6�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	set expectTable "0000.0000.0002 ac1 0000.0000.0003 ac1 0000.0000.0004 ac1 0000.0000.0022 pw12 0000.0000.0033 pw13 0000.0000.0044 pw14"
	###��������NMS��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
        for {set j 1} {$j<$cntdh} {incr j} {
                if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
                	  after $rebootTime
                	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
                	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
                	if {[TestRepeat_case1 $fileId "��$j\�� NE1($gpnIp1)����NMS����������" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
                		set  flag7_case1 1
                	}
                	gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
                	if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable $expectTable]} {
                		set flag7_case1 1
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
        	set flag7_case1	1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
        }
        }
        puts $fileId ""
        if {$flag7_case1 == 1} {
        set flagCase1 1
         gwd::GWpublic_print "NOK" "FA7�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
        } else {
        gwd::GWpublic_print "OK" "FA7�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	##��������SW��������
	set testFlag 0 ;#=1 ��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestRepeat_case1 $fileId "��$j\�� NE1($gpnIp1)����SW��������" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
				set  flag8_case1 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����SW����������" $dTable $expectTable]} {
				set flag8_case1 1
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
			set flag8_case1	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag8_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA8�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	##���������豸����
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[TestRepeat_case1 $fileId "��$j\�� NE1($gpnIp1)���б����豸������" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
			set  flag9_case1 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
		if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)���б����豸������" $dTable $expectTable]} {
			set flag9_case1 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag9_case1	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag9_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA9�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ�����豸AC�����ã�����ҵ���Ƿ��ж�  ���Կ�ʼ=====\n" 
	foreach telnet $lSpawn_id Gpn_type $lDutType matchType $lMatchType {
		gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac1"
	}
	incr capId
	if {[TestRepeat_case1 $fileId "ɾ�����豸AC�����ú�" "GPN_PTN_010_$capId" $rateL $rateR 0]} {
		set  flag10_case1 1
	}
	puts $fileId ""
	if {$flag10_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB1�����ۣ�ɾ�����豸AC�����ã�ҵ��û���ж�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1�����ۣ�ɾ�����豸AC�����ã�ҵ���ж�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ɾ�����豸AC�����ã�����ҵ���Ƿ��ж�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====������Ӹ��豸AC�����ã�����ҵ��  ���Կ�ʼ=====\n" 
	#�������ac
	set id2 1
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 role $RoleList matchType $lMatchType {
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac1" "vpls$id2" "" $eth "0" "0" $role "delete" "1" "0" "0" "0x8100" "evc2"
		incr id2
	}
	incr capId
	if {[TestRepeat_case1 $fileId "������Ӹ��豸AC�����ú�" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
		set  flag11_case1 1
	}
	puts $fileId ""
	if {$flag11_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB2�����ۣ�������Ӹ��豸AC�����ã�����ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2�����ۣ�������Ӹ��豸AC�����ã�����ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====������Ӹ��豸AC�����ã�����ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase1 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 1���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 1���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 1 ����vplsTypeΪrawģʽ���û������ģʽΪ�˿�ģʽ��֤ETREEҵ��  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 ����vplsTypeΪrawģʽ���û������ģʽΪ���˿�+��Ӫ��VLAN����֤ETREEҵ��\n"
        #����E-Tree��evp-tree��ҵ����֤ 
        #   <16>��NE1��NE2��NE3��NE4�Ͼ����������VLAN��vlan 100����������˿ڣ��ٴδ�������ģʽΪ���˿�+��Ӫ��VLAN���Ļ��ҵ�񣬳ɹ�������ϵͳ���쳣
        #   <17>��NE1�Ķ˿�1����tag100��tag200ҵ������NE2��NE3��NE4��Ҷ�Ӷ˿�ֻ�ɽ���tag100ҵ������NE1��NE2��NE3��NE4����vlan100��˫����ҵ������
        #   <18>NE2��NE3��NE4��vlan100�ĵ�������ֻ��NE1�����յ���Ҷ�ӽڵ��Ҷ�Ӷ˿ڼ䲻�ܻ�ͨ
        #   <19>�ظ�����8-11
        #   <20>��UNI�˿ڸ���ΪFE/10GE�˿ڣ������������䣬�ظ����ϲ�  ע��ʹ��FE�˿����û��ҵ��ʱ���迪���ð忨��MPLSҵ��ģʽ������Ϊ��mpls enable <slot>��
	
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0
	set flag5_case2 0
	set flag6_case2 0
	set flag7_case2 0
	set flag8_case2 0
	##����acΪ���˿�+vlan��ģʽ����EVP-TREE��
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ��δʹ��overlay����ǰ����MPLS������֤ҵ��=====\n" 
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList2" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList6" \
		-activate "true"
        set vpls 1
        foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 role $RoleList matchType $lMatchType {
                ###����vlan check
                if {[string match "L2" $Worklevel]} {
                	gwd::GWpublic_CfgVlanCheck $telnet $matchType $Gpn_type $fileId $eth "enable"
                }
                ##ɾ��ac
                gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac1"
                ##�û������vlan
                PTN_UNI_AddInter $telnet $matchType $Gpn_type $fileId $Worklevel "100" $eth
                gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac100" "vpls$vpls" "" $eth "100" "0" $role "modify" "100" "0" "0" "0x8100" "evc2"
                incr vpls
        }
	
	incr capId
	SendAndStat_ptn006 1 "$hGPNPortGenList" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $anaFliFrameCfg0 "GPN_PTN_010_$capId"

	SendAndStat_ptn006 0 "$hGPNPortGenList" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_010_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	if {$GPNPort1Cnt1(cnt112) < $rateL || $GPNPort1Cnt1(cnt112) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=100��mpls��������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=100������������ӦΪ$GPNPort1Cnt1(cnt112)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=100��mpls��������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=100������������ӦΪ$GPNPort1Cnt1(cnt112)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt1(cnt114) < $rateL || $GPNPort1Cnt1(cnt114) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=100��mpls��������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=100������������Ϊ$GPNPort1Cnt1(cnt114)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=100��mpls��������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=100������������Ϊ$GPNPort1Cnt1(cnt114)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt1(cnt111) < $rateL || $GPNPort2Cnt1(cnt111) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=100��mpls��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=100������������Ϊ$GPNPort2Cnt1(cnt111)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=100��mpls��������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=100������������Ϊ$GPNPort2Cnt1(cnt111)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt0(cnt104) !=0} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE4��NE2��AC����leaf��NE4($gpnIp4)$GPNTestEth4\����tag=100��mpls��������\
			NE2($gpnIp2)$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt104)" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE4��NE2��AC����leaf��NE4($gpnIp4)$GPNTestEth4\����tag=100��mpls��������\
			NE2($gpnIp2)$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt104)" $fileId
	}
	if {$GPNPort4Cnt1(cnt111) < $rateL || $GPNPort4Cnt1(cnt111) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=100��mpls��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=100������������Ϊ$GPNPort4Cnt1(cnt111)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=100��mpls��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=100������������Ϊ$GPNPort4Cnt1(cnt111)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt0(cnt102) !=0} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "δʹ��overlayʱ��NE4��NE2��AC����leaf��NE2($gpnIp2)$GPNTestEth2\����tag=100��mpls��������\
			NE4($gpnIp4)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt102)" $fileId
	} else {
		gwd::GWpublic_print "OK" "δʹ��overlayʱ��NE4��NE2��AC����leaf��NE2($gpnIp2)$GPNTestEth2\����tag=100��mpls��������\
			NE4($gpnIp4)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt102)" $fileId
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB3�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ��δʹ��overlay����ǰ����MPLS������֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ��δʹ��overlay����ǰ����MPLS������֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ��δʹ��overlay����ǰ����MPLS������֤ҵ��  ���Խ���=====\n"
	incr $tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ��ʹ��overlay���ܺ���MPLS������֤ҵ��  ���Կ�ʼ=====\n"
	gwd::GWpublic_addOverLay $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "enable"
	gwd::GWpublic_addOverLay $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "enable"
	gwd::GWpublic_addOverLay $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "enable"
	gwd::GWpublic_addOverLay $telnet4 $matchType4 $Gpn_type4 $fileId $GPNTestEth4 "enable"
	incr capId
	SendAndStat_ptn006 1 "$hGPNPortGenList" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $anaFliFrameCfg0 "GPN_PTN_010_$capId"

	SendAndStat_ptn006 0 "$hGPNPortGenList" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_010_$capId"
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
        if {$GPNPort1Cnt1(cnt112) < $rateL || $GPNPort1Cnt1(cnt112) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=100��mpls��������NE1($gpnIp1)\
        		$GPNTestEth1\�յ�tag=100������������ӦΪ$GPNPort1Cnt1(cnt112)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE2($gpnIp2)$GPNTestEth2\����tag=100��mpls��������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=100������������ӦΪ$GPNPort1Cnt1(cnt112)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$GPNPort1Cnt1(cnt114) < $rateL || $GPNPort1Cnt1(cnt114) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=100��mpls��������NE1($gpnIp1)\
        		$GPNTestEth1\�յ�tag=100������������Ϊ$GPNPort1Cnt1(cnt114)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE4($gpnIp4)$GPNTestEth4\����tag=100��mpls��������NE1($gpnIp1)\
        		$GPNTestEth1\�յ�tag=100������������Ϊ$GPNPort1Cnt1(cnt114)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$GPNPort2Cnt1(cnt111) < $rateL || $GPNPort2Cnt1(cnt111) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=100��mpls��������NE2($gpnIp2)\
        		$GPNTestEth2\�յ�tag=100������������Ϊ$GPNPort2Cnt1(cnt111)��û��$rateL-$rateR\��Χ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=100��mpls��������NE2($gpnIp2)\
        		$GPNTestEth2\�յ�tag=100������������Ϊ$GPNPort2Cnt1(cnt111)����$rateL-$rateR\��Χ��" $fileId
        }
        if {$GPNPort2Cnt0(cnt104) !=0} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE4��NE2��AC����leaf��NE4($gpnIp4)$GPNTestEth4\����tag=100��mpls��������\
        		NE2($gpnIp2)$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt104)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE4��NE2��AC����leaf��NE4($gpnIp4)$GPNTestEth4\����tag=100��mpls��������\
        		NE2($gpnIp2)$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt104)" $fileId
        }
	if {$GPNPort4Cnt1(cnt111) < $rateL || $GPNPort4Cnt1(cnt111) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=100��mpls��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=100������������Ϊ$GPNPort4Cnt1(cnt111)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE1($gpnIp1)$GPNTestEth1\����tag=100��mpls��������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=100������������Ϊ$GPNPort4Cnt1(cnt111)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt0(cnt102) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "ʹ��overlayʱ��NE4��NE2��AC����leaf��NE2($gpnIp2)$GPNTestEth2\����tag=100��mpls��������\
			NE4($gpnIp4)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt102)" $fileId
	} else {
		gwd::GWpublic_print "OK" "ʹ��overlayʱ��NE4��NE2��AC����leaf��NE2($gpnIp2)$GPNTestEth2\����tag=100��mpls��������\
			NE4($gpnIp4)$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt102)" $fileId
	}
        puts $fileId ""
        if {$flag2_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FB4�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ��ʹ��overlay���ܺ���MPLS������֤ҵ��" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB4�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ��ʹ��overlay���ܺ���MPLS������֤ҵ��" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ��ʹ��overlay���ܺ���MPLS������֤ҵ��  ���Խ���=====\n"
        gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ����֤ҵ��  ���Կ�ʼ=====\n" 
	gwd::GWpublic_addOverLay $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "disable"
	gwd::GWpublic_addOverLay $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "disable"
	gwd::GWpublic_addOverLay $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "disable"
	gwd::GWpublic_addOverLay $telnet4 $matchType4 $Gpn_type4 $fileId $GPNTestEth4 "disable"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList6" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList5" \
		-activate "true"
	incr capId
	if {[TestRepeat_case2Andcase9 1 $fileId "" "GPN_PTN_010_$capId" $rateL $rateR]} {
		set flag3_case2 1
	}

	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB5�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ����֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ����֤ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n" 
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)����shut undoshut NNI �ں����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	##����undo shutdown/shutdown�˿�
	foreach eth $portlist1 {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
		for {set j 1} {$j<=$cnt} {incr j} {
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
			  after $WaiteTime
			incr capId
			if {[TestRepeat_case2Andcase9 1 $fileId "��$j\��shutdown/undo shutdown NE1($gpnIp1)��$eth\�˿ں�" "GPN_PTN_010_$capId" $rateL $rateR]} {
				set  flag4_case2 1
			}
		}
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag4_case2 1
			gwd::GWpublic_print "NOK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		 gwd::GWpublic_print "NOK" "FB6�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)����shut undoshut NNI �ں����ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)����shut undoshut NNI �ں����ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)����shut undoshut NNI �ں����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
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
				if {[TestRepeat_case2Andcase9 1 $fileId "��$j\������NE1($gpnIp1)$slot\��λ�忨" "GPN_PTN_010_$capId" $rateL $rateR]} {
					set  flag5_case2 1
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
				set flag5_case2 1
				gwd::GWpublic_print "NOK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
			}
		}
	}
	puts $fileId ""
	if {$flag5_case2 == 1} {
		set flagCase2 1
		 gwd::GWpublic_print "NOK" "FB7�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	set expectTable "0000.0000.000C ac100 0000.0000.00F2 pw12 0000.0000.00F3 pw13 0000.0000.00F4 pw14"
	###��������NMS��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestRepeat_case2Andcase9 1 $fileId "��$j\�� NE1($gpnIp1)����NMS����������" "GPN_PTN_010_$capId" $rateL $rateR]} {
				set  flag6_case2 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable $expectTable]} {
				set flag6_case2 1
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
		set flag6_case2	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
	}
	}
	puts $fileId ""
	if {$flag6_case2 == 1} {
	set flagCase2 1
	 gwd::GWpublic_print "NOK" "FB8�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
	gwd::GWpublic_print "OK" "FB8�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	##��������SW��������
	set testFlag 0 ;#=1 ��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestRepeat_case2Andcase9 1 $fileId "��$j\�� NE1($gpnIp1)����SW��������" "GPN_PTN_010_$capId" $rateL $rateR]} {
				set  flag7_case2 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����SW����������" $dTable $expectTable]} {
				set flag7_case2 1
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
			set flag7_case2	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag7_case2 == 1} {
		set flagCase2 1
		 gwd::GWpublic_print "NOK" "FB9�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	##���������豸����
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[TestRepeat_case2Andcase9 1 $fileId "��$j\�� NE1($gpnIp1)���б����豸������" "GPN_PTN_010_$capId" $rateL $rateR]} {
			set  flag8_case2 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
		if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)���б����豸������" $dTable $expectTable]} {
			set flag8_case2 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag8_case2	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag8_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC1�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
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
	puts $fileId "Test Case 2 ����vplsTypeΪrawģʽ���û������ģʽΪ���˿�+��Ӫ��VLAN����֤ETREEҵ��  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 ����vplsTypeΪtaggedģʽ������ģʽ��Ϊ���˿ںͶ˿�+��Ӫ��VLAN������ģʽ��֤ETREEҵ��\n"
	set flag1_case3 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root��NE2-NE4��AC��leaf��ACΪport��port+vlan���֡�vplsTypeΪtagged������ETREEҵ��  ���Կ�ʼ=====\n"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
        gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"
        gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
        
	set vpls 1
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType {
                ##ɾ��ac
                gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac100"
                gwd::GWVpls_DelInfo $telnet $matchType $Gpn_type $fileId "vpls$vpls"
                gwd::GWVpls_AddInfo $telnet $matchType $Gpn_type $fileId "vpls$vpls" $vpls "etree" "flood" "false" "false" "false" "true" "2000" "" "tagged"
                incr vpls
	}
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "3000" "3000" "" "add" "none" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "4000" "4000" "" "add" "none" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "add" "root" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "3000" "3000" "" "add" "root" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "4000" "4000" "" "add" "root" 1 0 "0x8100" "0x8100" "1"
	
        gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac100" "vpls1" "" $GPNTestEth1 "0" "0" "root" "delete" "1" "0" "0" "0x8100" "evc2"
        gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac100" "vpls2" "" $GPNTestEth2 "0" "0" "leaf" "delete" "1" "0" "0" "0x8100" "evc2"
        gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac100" "vpls3" "" $GPNTestEth3 "100" "0" "leaf" "modify" "100" "0" "0" "0x8100" "evc2"
        gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac100" "vpls4" "" $GPNTestEth4 "100" "0" "leaf" "modify" "100" "0" "0" "0x8100" "evc2"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "disable"
		gwd::GWpublic_CfgVlanCheck $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "disable"
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList5" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream14 $hGPNPort2Stream15 $hGPNPort3Stream16 $hGPNPort4Stream17" \
		-activate "true"
	
	incr capId
	SendAndStat_ptn006 1 "$hGPNPortGenList" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 7 $anaFliFrameCfg7 "GPN_PTN_010_$capId"
	SendAndStat_ptn006 0 "$hGPNPortGenList" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $anaFliFrameCfg0 "GPN_PTN_010_$capId"
	SendAndStat_ptn006 0 "$hGPNPortGenList" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_010_$capId"
	SendAndStat_ptn006 0 "$hGPNPortGenList" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt2 GPNPort2Cnt2 GPNPort3Cnt2 GPNPort4Cnt2 6 $anaFliFrameCfg6 "GPN_PTN_010_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_$capId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_$capId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_$capId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_$capId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE1����
	if {$GPNPort1Cnt1(cnt15) < $rateL || $GPNPort1Cnt1(cnt15) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\����tag=100��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt15)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\����tag=100��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt15)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt7(cnt31) < $rateL || $GPNPort1Cnt7(cnt31) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\����tag=100��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt31)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\����tag=100��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt31)������$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt7(cnt42) < $rateL || $GPNPort1Cnt7(cnt42) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt42)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�untag��������������Ϊ$GPNPort1Cnt7(cnt42)����$rateL-$rateR\��Χ��" $fileId
	}
	#NE2����	
	if {$GPNPort2Cnt7(cnt10) < $rateL || $GPNPort2Cnt7(cnt10) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt10)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt1(cnt2) < $rateL || $GPNPort2Cnt1(cnt2) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt1(cnt14) < $rateL || $GPNPort2Cnt1(cnt14) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=100��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=100��������������Ϊ$GPNPort2Cnt1(cnt14)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=100��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=100��������������Ϊ$GPNPort2Cnt1(cnt14)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt0(cnt16) != 0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\����tag=100��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt16)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\����tag=100��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt16)" $fileId
	}
	if {$GPNPort2Cnt0(cnt58) != 0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt58)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt58)" $fileId
	}
	#NE3����	
	if {$GPNPort3Cnt1(cnt67) < $rateL || $GPNPort3Cnt1(cnt67) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=100��������������Ϊ$GPNPort3Cnt1(cnt67)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=100��������������Ϊ$GPNPort3Cnt1(cnt67)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt2(cnt18) < $rateL || $GPNPort3Cnt2(cnt18) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ����tag=100�ڲ�tag=500��������������Ϊ$GPNPort3Cnt2(cnt18)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ����tag=100�ڲ�tag=500��������������Ϊ$GPNPort3Cnt2(cnt18)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt2(cnt19) < $rateL || $GPNPort3Cnt2(cnt19) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ����tag=100�ڲ�tag=100��������������Ϊ$GPNPort3Cnt2(cnt19)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ����tag=100�ڲ�tag=100��������������Ϊ$GPNPort3Cnt2(cnt19)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt0(cnt14) != 0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt14)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt14)" $fileId
	}
	if {$GPNPort3Cnt0(cnt58) != 0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt58)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt58)" $fileId
	}
	#NE4����	
	if {$GPNPort4Cnt1(cnt67) < $rateL || $GPNPort4Cnt1(cnt67) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=100��������������Ϊ$GPNPort4Cnt1(cnt67)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=100��������������Ϊ$GPNPort4Cnt1(cnt67)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt2(cnt18) < $rateL || $GPNPort4Cnt2(cnt18) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ����tag=100�ڲ�tag=500��������������Ϊ$GPNPort4Cnt2(cnt18)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=500��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ����tag=100�ڲ�tag=500��������������Ϊ$GPNPort4Cnt2(cnt18)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt2(cnt19) < $rateL || $GPNPort4Cnt2(cnt19) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ����tag=100�ڲ�tag=100��������������Ϊ$GPNPort4Cnt2(cnt19)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ����tag=100�ڲ�tag=100��������������Ϊ$GPNPort4Cnt2(cnt19)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt0(cnt14) != 0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt14)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt14)" $fileId
	}
	if {$GPNPort4Cnt0(cnt16) != 0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt16)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt16)" $fileId
	}
	puts $fileId ""
	if {$flag1_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC2�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport��port+vlan���֡�vplsTypeΪtagged������ETREEҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport��port+vlan���֡�vplsTypeΪtagged������ETREEҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root��NE2-NE4��AC��leaf��ACΪport��port+vlan���֡�vplsTypeΪtagged������ETREEҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase3 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 3���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 3���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 3 ����vplsTypeΪtaggedģʽ������ģʽ��Ϊ���˿ںͶ˿�+��Ӫ��VLAN������ģʽ��֤ETREEҵ��  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 E-TREEҵ���ܣ�����E-Tree��evp-tree��ҵ���ǩ������֤����\n"	
	#   <1>���������˼����ã�NE2ΪNE1��NE3���P�ڵ㣻NE1��NE3��LSP���ǩ20������ǩ21��
	#      NE3��NE1��LSP���ǩ22������ǩ23��NE2��LSP���ǩ21����Ϊ����ǩ22��NE2��LSP���ǩ23����Ϊ����ǩ20��
	#   <2>NE1��NE3�Է�tag100����֪������ҵ������������NE2��NE1������NNI��˿ڵ�����Ϊ����tag��ǩ��mpls����lsp��ǩΪ21��TTLֵΪ255��pw��ǩ3000��PW��TTLֵΪ255��
	#      ����NE2��NE3������NNI���˿ڵ�����Ϊ����tag��ǩ��mpls����lsp��ǩΪ22��TTLֵΪ254��pw��ǩ3000��PW��TTLֵΪ255��֤��NE2��NE1��NE3�����lsp��ǩ��������ȷ�Ľ���
	#      ����NE2��NE1������NNI���˿ڵ�����Ϊ����tag��ǩ��mpls����lsp��ǩΪ20��TTLֵΪ254��pw��ǩ3000��PW��TTLֵΪ255��
	#      ����NE2��NE3������NNI��˿ڵ�����Ϊ����tag��ǩ��mpls����lsp��ǩΪ23��TTLֵΪ255��pw��ǩ3000��PW��TTLֵΪ255��֤��NE2��NE3��NE1�����lsp��ǩ��������ȷ�Ľ���
	#   <3>undo shutdown��shutdown NE2�豸��NNI/UNI�˿�10�Σ���ǩ����������ҵ��ָ�������ϵͳ���쳣 
	#   <4>����NE2�豸��NNI/UNI�˿����ڰ忨10�Σ���ǩ����������ҵ��ָ�������ϵͳ���쳣 
	#   <5>NE2�豸����SW/NMS����10�Σ���ǩ����������ҵ��ָ�������ϵͳ���쳣 
	#   <6>��������NE2�豸��10�Σ�ϵͳ������������ǩ����������ҵ��ָ�������ϵͳ���쳣 
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set flag5_case4 0
	set flag6_case4 0
	set flag7_case4 0
	
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ����֤ETREEҵ��  ���Կ�ʼ=====\n" 
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
        gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"
        gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
        
        set vpls 1
        foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 role $RoleList matchType $lMatchType {
                ##ɾ��ac
                gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac100"
                gwd::GWVpls_DelInfo $telnet $matchType $Gpn_type $fileId "vpls$vpls"
                gwd::GWVpls_AddInfo $telnet $matchType $Gpn_type $fileId "vpls$vpls" $vpls "etree" "flood" "false" "false" "false" "true" "2000" "" ""
                gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac100" "vpls$vpls" "" $eth "100" "0" $role "nochange" "1" "0" "0" "0x8100" "evc2"
                incr vpls
        }
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "3000" "3000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "3000" "3000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1" 
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "2000" "2000" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "enable"
		gwd::GWpublic_CfgVlanCheck $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "enable"
	}
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream1 $hGPNPort1Stream2 $hGPNPort1Stream14 $hGPNPort2Stream15 $hGPNPort3Stream16 $hGPNPort4Stream17" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream14 $hGPNPort3Stream18" \
		-activate "true"
	incr capId
	SendAndStat_ptn006 1 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_010_$capId"
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_$capId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_$capId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_$capId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_$capId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE1����
	if {$GPNPort1Cnt1(cnt21) < $rateL || $GPNPort1Cnt1(cnt21) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\����tag=100����֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt21)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\����tag=100����֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt21)����$rateL-$rateR\��Χ��" $fileId
	}
	#NE3����
	if {$GPNPort3Cnt1(cnt14) < $rateL || $GPNPort3Cnt1(cnt14) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=100����֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=100��������������Ϊ$GPNPort3Cnt1(cnt14)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=100����֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=100��������������Ϊ$GPNPort3Cnt1(cnt14)����$rateL-$rateR\��Χ��" $fileId
	}
	puts $fileId ""
	if {$flag1_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC3�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ����֤ETREEҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ����֤ETREEҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ����֤ETREEҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�����MPLS��ǩ  ���Կ�ʼ=====\n"
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort6AnaFrameCfgFil $anaFliFrameCfg2
	incr capId
        PTN_EVP_LabelSwith 1 "" $GPNPort6 "ingress" "GPN_PTN_010_$capId" flag1
	incr capId
        PTN_EVP_LabelSwith 2 "" $GPNPort7 "egress" "GPN_PTN_010_$capId" flag2
	incr capId
        PTN_EVP_LabelSwith 3 "" $GPNPort6 "egress" "GPN_PTN_010_$capId" flag3
	incr capId
        PTN_EVP_LabelSwith 4 "" $GPNPort7 "ingress" "GPN_PTN_010_$capId" flag4
	if {($flag1 == 1) || ($flag2 ==1) || ($flag3 ==1) || ($flag4 ==1)} {
		set flag2_case4 1
	}
	puts $fileId ""
	if {$flag2_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC4�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�����MPLS��ǩ" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�����MPLS��ǩ" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�����MPLS��ǩ  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2����shutdown/undo shutdown NNI�ڲ���MPLS��ǩ��ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	foreach eth $portlist2 {
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource1
		for {set j 1} {$j<=$cnt} {incr j} {
			 gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $eth "shutdown"
			 gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $eth "undo shutdown"
			   after $WaiteTime
			 if {[PTN_EVP_LabelSwithRepeat "��$j\��shutdown/undo shutdown NE2($gpnIp2)��$eth\�˿ں�"]} {
				 set  flag3_case4 1
			 }
		}
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag3_case4 1
			gwd::GWpublic_print "NOK" "����shutdown/undo shutdown NE2($gpnIp2)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "����shutdown/undo shutdown NE2($gpnIp2)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag3_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC5�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2����shutdown/undo shutdown NNI�ڲ���MPLS��ǩ��ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2����shutdown/undo shutdown NNI�ڲ���MPLS��ǩ��ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2����shutdown/undo shutdown NNI�ڲ���MPLS��ǩ��ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������NNI�����ڰ忨�����MPLS��ǩ��ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	foreach slot $rebootSlotlist2 {
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource3
		set testFlag 0
		for {set j 1} {$j<=$cnt} {incr j} {
			if {![gwd::GWCard_AddReboot $telnet2 $matchType2 $Gpn_type2 $fileId $slot]} {
        			after $rebootBoardTime
        			if {[string match $mslot2 $slot]} {
                        		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
                        		set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
        			}
        			if {[PTN_EVP_LabelSwithRepeat "��$j\������NE2($gpnIp2)$slot\��λ�忨"]} {
        			      set  flag4_case4 1
        			}
		      } else {
			      set testFlag 1
			      gwd::GWpublic_print "OK" " NE2($gpnIp2)$slot\��λ�忨��֧�ְ忨������������������" $fileId
			      break
		      }
		}
	      	if {$testFlag == 0} {
		      gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource4
		      send_log "\n resource3:$resource3"
		      send_log "\n resource4:$resource4"
		      if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
			      set flag4_case4 1
			      gwd::GWpublic_print "NOK" "��������NE2($gpnIp2)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
		      } else {
			      gwd::GWpublic_print "OK" "��������NE2($gpnIp2)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
		      }
	      	}
	}
	puts $fileId ""
	if {$flag4_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC6�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������NNI�����ڰ忨�����MPLS��ǩ��ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������NNI�����ڰ忨�����MPLS��ǩ��ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������NNI�����ڰ忨�����MPLS��ǩ��ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������NMS�������������MPLS��ǩ��ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource5
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet2 $matchType2 $Gpn_type2 $fileId]} {
	 		after $rebootTime
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
			if {[PTN_EVP_LabelSwithRepeat "��$j\�� NE2($gpnIp2)����NMS��������"]} {
				set  flag5_case4 1
			}			
                } else {
                	gwd::GWpublic_print "OK" "$matchType2\ֻ��һ�������̣���������" $fileId
                	set testFlag 1
                	break
                }
	}
        if {$testFlag == 0} {
                gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource6
                send_log "\n resource5:$resource5"
                send_log "\n resource6:$resource6"
                if {$resource6 > [expr $resource5 + $resource5 * $errRate]} {
                	set flag5_case4	1
                	gwd::GWpublic_print "NOK" "NE2($gpnIp2)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
                } else {
                	gwd::GWpublic_print "OK" "NE2($gpnIp2)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
                }
	}
	puts $fileId ""
	if {$flag5_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC7�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������NMS�������������MPLS��ǩ��ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������NMS�������������MPLS��ǩ��ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������NMS�������������MPLS��ǩ��ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������SW�������������MPLS��ǩ��ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource7
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			after $rebootTime
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
			if {[PTN_EVP_LabelSwithRepeat "��$j\�� NE2($gpnIp2)����SW��������"]} {
				set  flag6_case4 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType2\ֻ��һ��SW�̣���������" $fileId
			set testFlag 1
			break
		}
	}
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource8
		send_log "\n resource7:$resource7"
		send_log "\n resource8:$resource8"
		if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
			set flag6_case4	1
			gwd::GWpublic_print "NOK" "NE2($gpnIp2)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($gpnIp2)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC8�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������SW�������������MPLS��ǩ��ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������SW�������������MPLS��ǩ��ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������SW�������������MPLS��ǩ��ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2�������б����豸���������MPLS��ǩ��ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
		after $rebootTime
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		if {[PTN_EVP_LabelSwithRepeat "��$j\�� NE2($gpnIp2)���б����豸������"]} {
			set  flag7_case4 1
		}
	}
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag7_case4	1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag7_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC9�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2�������б����豸���������MPLS��ǩ��ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC9�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2�������б����豸���������MPLS��ǩ��ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2�������б����豸���������MPLS��ǩ��ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase4 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 4���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 4���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 4 E-TREEҵ���ܣ�����E-Tree��evp-tree��ҵ���ǩ������֤����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 E-TREEҵ���ܣ�VSI��macѧϰ���Ʋ���\n"	
        #   <1>���˼����ò��䣬��vpls����mac��ַѧϰ������Ϊ20��ѧϰ����Ϊ����ʱ��������������ȷ
        #   <2>��NE1��UNI��һ�η���Դtag100�� mac��ͬ��30��������NE1��������show forward-entry vpls vpls1�鿴mac��ַ��
        #   Ԥ�ڽ����mac��ַѧϰ��Ŀ��ȷΪ20����ѧϰ��Ŀ��ȷ��ѧ�ڶ�Ӧvpls��ac��
        #	     NE1��NE2��NE3��UNI�ھ�ֻ���յ�20������˵��ѧϰ����Ϊ������Ч��ûѧ���Ķ�������
        #   <3>vpls����mac��ַѧϰ��������Ϊ20���޸�ѧϰ����Ϊ�鷺
        #   Ԥ�ڽ������NE1��UNI��һ�η���Դmac��ͬ��30��������NE1��������show forward-entry vpls vpls1�鿴mac��ַ��
        #             mac��ַѧϰ��Ŀ��ȷΪ20����ѧϰ��Ŀ��ȷ��ѧ�ڶ�Ӧvpls��ac��
        #             NE1��NE2��NE3��UNI�ھ����յ�30������˵��ѧϰ����Ϊ�鷺��Ч��ûѧ���������鷺��ȥ��
        #   <4>��macѧϰ��������������Ϊ������ֵ���ж����֤����Ч
	set flag1_case5 0
	set flag2_case5 0
	set flag3_case5 0
	set flag4_case5 0
	set flag5_case5 0
	stc::config $hGPNPort1GenCfg -DurationMode BURSTS -BurstSize 1 -Duration 200
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream14 $hGPNPort3Stream18"\
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPort1Stream19 \
		-activate "true"
	stc::apply
	set vpls 1
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType role $RoleList {
		gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac100"
		PTN_UNI_AddInter $telnet $matchType $Gpn_type $fileId $Worklevel "800" $eth
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac800" "vpls$vpls" "" $eth "800" "0" $role "nochange" "1" "0" "0" "0x8100" "evc2"
		incr vpls
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ20��ѧϰ����Ϊ����  ���Կ�ʼ=====\n"
	PTN_ChangeETreeConfig $fileId 1 "discard" "20" 1 1 "false" "false" "false"
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "discard" "ac800" "vpls1" 20 20]} {
		set flag1_case5 1
	}
	puts $fileId ""
	if {$flag1_case5 == 1} {
		set flagCase5 1
		 gwd::GWpublic_print "NOK" "FD1�����ۣ�vpls��������mac��ַѧϰ����Ϊ20��ѧϰ����Ϊ���������ò���Ч" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD1�����ۣ�vpls��������mac��ַѧϰ����Ϊ20��ѧϰ����Ϊ������������Ч" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ20��ѧϰ����Ϊ����  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ20��ѧϰ����Ϊ����  ���Կ�ʼ=====\n"
	PTN_ChangeETreeConfig $fileId 1 "flood" "20" 1 1 "false" "false" "false"
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "flood" "ac800" "vpls1" 20 200]} {
		set flag2_case5 1
	}
	puts $fileId ""
	if {$flag2_case5 == 1} {
		set flagCase5 1
		 gwd::GWpublic_print "NOK" "FD2�����ۣ�vpls��������mac��ַѧϰ����Ϊ20��ѧϰ����Ϊ���飬���ò���Ч" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD2�����ۣ�vpls��������mac��ַѧϰ����Ϊ20��ѧϰ����Ϊ���飬������Ч" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ20��ѧϰ����Ϊ����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ15��ѧϰ����Ϊ����  ���Կ�ʼ=====\n"
	PTN_ChangeETreeConfig $fileId 1 "flood" "15" 1 1 "false" "false" "false"
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "flood" "ac800" "vpls1" 15 200]} {
		set flag3_case5 1
	}
	puts $fileId ""
	if {$flag3_case5 == 1} {
		set flagCase5 1
		 gwd::GWpublic_print "NOK" "FD3�����ۣ�vpls��������mac��ַѧϰ����Ϊ15��ѧϰ����Ϊ���飬���ò���Ч" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD3�����ۣ�vpls��������mac��ַѧϰ����Ϊ15��ѧϰ����Ϊ���飬������Ч" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ15��ѧϰ����Ϊ����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ15��ѧϰ����Ϊ����  ���Կ�ʼ=====\n"
	PTN_ChangeETreeConfig $fileId 1 "discard" "15" 1 1 "false" "false" "false"
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "discard" "ac800" "vpls1" 15 15]} {
		set flag4_case5 1
	}
	puts $fileId ""
	if {$flag4_case5 == 1} {
		set flagCase5 1
		 gwd::GWpublic_print "NOK" "FD4�����ۣ�vpls��������mac��ַѧϰ����Ϊ15��ѧϰ����Ϊ���������ò���Ч" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD4�����ۣ�vpls��������mac��ַѧϰ����Ϊ15��ѧϰ����Ϊ������������Ч" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ15��ѧϰ����Ϊ����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ����  ���Կ�ʼ=====\n"
	PTN_ChangeETreeConfig $fileId 1 "flood" "100" 1 1 "false" "false" "false"
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "flood" "ac800" "vpls1" 100 200]} {
		set flag5_case5 1
	}
	puts $fileId ""
	if {$flag5_case5 == 1} {
		set flagCase5 1
		 gwd::GWpublic_print "NOK" "FD5�����ۣ�vpls��������mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ���飬���ò���Ч" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD5�����ۣ�vpls��������mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ���飬������Ч" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls����mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
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
	puts $fileId "Test Case 5 E-TREEҵ���ܣ�VSI��macѧϰ���Ʋ���  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 6 E-TREEҵ��vpls��������б��Ĺ��˲�������\n"
        #   <1>���˼����ò��䣬NE1����tag100�Ĺ㲥��Ŀ��macffff.ffff.ffff�����鲥(Ŀ��mac 0100.5e00.0001)��������NE2/NE3/NE4�豸��Ҷ�Ӷ˿ڶ����յ�
        #   <2>����/�鲥���ƹ����޸�Ϊʹ�ܣ�Ĭ�Ͻ�ֹ�����鿴������Ч��ҵ���ж�
        #   <3>�ٽ���/��/�������ƹ��ܸ�Ϊ��ֹ��ҵ��ָ�
        ###���ù�����
	set flag1_case6 0
	set flag2_case6 0
	set flag3_case6 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls�������ý�ֹͨ���㲥��������ͨ���鲥����δ֪��������֤ҵ��  ���Կ�ʼ=====\n"
	stc::config $hGPNPort1GenCfg -DurationMode CONTINUOUS
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPort1Stream19 \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream7 $hGPNPort1Stream8 $hGPNPort1Stream30 $hGPNPort4Stream7 $hGPNPort4Stream8 $hGPNPort4Stream25" \
		-activate "true"
	stc::apply
	
	PTN_ChangeETreeConfig $fileId 1 "flood" "2000" 1 1 "true" "false" "false"
	incr capId
	if {[TestCase6 "NE1($gpnIp1)vpls��vpls1�����ý�ֹͨ���㲥��������ͨ���鲥����δ֪��������" $rateL0 $rateR0 $rateL $rateR 1 0 0 "GPN_PTN_010_$capId"]} {
		set flag1_case6 1
	}
	puts $fileId ""
	if {$flag1_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FD6�����ۣ�vpls�������ý�ֹͨ���㲥��������ͨ���鲥����δ֪��������֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD6�����ۣ�vpls�������ý�ֹͨ���㲥��������ͨ���鲥����δ֪��������֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls�������ý�ֹͨ���㲥��������ͨ���鲥����δ֪��������֤ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls�������ý�ֹͨ���鲥��������ͨ���㲥����δ֪��������֤ҵ��  ���Կ�ʼ=====\n"
	PTN_ChangeETreeConfig $fileId 1 "flood" "2000" 1 1 "false" "true" "false"
	incr capId
	if {[TestCase6 "NE1($gpnIp1)vpls��vpls1�����ý�ֹͨ���鲥��������ͨ���㲥����δ֪��������" $rateL0 $rateR0 $rateL $rateR 0 1 0 "GPN_PTN_010_$capId"]} {
		set flag2_case6 1
	}
	puts $fileId ""
	if {$flag2_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FD7�����ۣ�vpls�������ý�ֹͨ���鲥��������ͨ���㲥����δ֪��������֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD7�����ۣ�vpls�������ý�ֹͨ���鲥��������ͨ���㲥����δ֪��������֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls�������ý�ֹͨ���鲥��������ͨ���㲥����δ֪��������֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls�������ý�ֹͨ��δ֪������������ͨ���㲥�����鲥����֤ҵ��  ���Կ�ʼ=====\n"
	PTN_ChangeETreeConfig $fileId 1 "flood" "2000" 1 1 "false" "false" "true"
	incr capId
	if {[TestCase6 "NE1($gpnIp1)vpls�������ý�ֹͨ��δ֪������������ͨ���㲥�����鲥����" $rateL0 $rateR0 $rateL $rateR 0 0 1 "GPN_PTN_010_$capId"]} {
		set flag3_case6 1
	}
	puts $fileId ""
	if {$flag3_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FD8�����ۣ�vpls�������ý�ֹͨ��δ֪������������ͨ���㲥�����鲥����֤ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD8�����ۣ�vpls�������ý�ֹͨ��δ֪������������ͨ���㲥�����鲥����֤ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls�������ý�ֹͨ��δ֪������������ͨ���㲥�����鲥����֤ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
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
	puts $fileId "Test Case 6 E-TREEҵ��vpls��������б��Ĺ��˲�������  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 7 E-TREEҵ�񣺺ڰ���������\n"
        #   <1>���˼����ò��䣬NE1����tag100ԴΪ0000.0010.0001��Ŀ��macΪ0000.0010.0002����������NE2��NE3��NE4�����յ�
        #   <2>�鿴mac��ַ��0000.0010.0001��̬ѧ����Ӧvpls��ac��
        #   <3>��NE1�����û���Դ�ľ�̬mac�󶨵�ac�ڣ���mac��ַΪ0000.0010.0001���鿴mac��ַ����mac�����ɶ�̬��Ϊ��̬��ҵ������
        #   <4>����NE1�豸��SW/NMS����10�Σ���������ÿ�β�����ҵ��ָ�������ϵͳ���쳣����̬mac������ȷ
        #   <5>ɾ����̬mac��mac��ַ�ֱ����¶�̬ѧϰ��
        #   <6>��NE1�����û���Դ�ľ�̬mac�󶨵�pw1�ϣ���mac��ַΪ0000.0010.0002���鿴mac��ַ����ȷ����ֻ��NE2���յ���������NE3��NE4�������������ж�
        #   <7>����NE1�豸��SW/NMS����10�Σ���������ÿ�β�����ҵ��ָ�������ϵͳ���쳣����̬mac������ȷ����Ч
        #   <8>ɾ����̬mac��NE3��NE4�����յ�������
        #   <9>��NE1�����û���Դ�ĺڶ�mac�󶨵�ac�ڣ���mac��ַΪ0000.0010.0001���鿴mac��ַ���ڶ�mac����ȡ����̬���ҵ���ж�
        #   <10>����NE1�豸��SW/NMS����10�Σ���������ÿ�β�����ҵ��ָ�������ϵͳ���쳣���ڶ�mac������ȷ����Ч
        #   <11>ɾ���ڶ�̬mac��mac��ַ�ֱ����¶�̬ѧϰ����ҵ�����»ָ�
        #   <12>��NE1�����û���Դ�ĺڶ�mac�󶨵�pw1����mac��ַΪ0000.0010.0002���鿴mac��ַ���ڶ�mac������ȷ����NE2ҵ���жϣ�NE3/NE4ҵ������
        #   <13>����NE1�豸��SW/NMS����4�Σ���������ÿ�β�����ҵ��ָ�������ϵͳ���쳣����̬mac������ȷ����Ч
        #   <14>ɾ���ڶ�mac��NE2ҵ��ָ��������ڶ�mac������ʧ
	set flag1_case7 0
	set flag2_case7 0
	set flag3_case7 0
	set flag4_case7 0
	set flag5_case7 0
	set flag6_case7 0
	set flag7_case7 0
	set flag8_case7 0
	set flag9_case7 0
	set flag10_case7 0
	set flag11_case7 0
	set flag12_case7 0
	set flag13_case7 0
	set flag14_case7 0
	set flag15_case7 0
	set flag16_case7 0
	set flag17_case7 0
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream7 $hGPNPort1Stream8 $hGPNPort1Stream30 $hGPNPort4Stream7 $hGPNPort4Stream8 $hGPNPort4Stream25" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPort1Stream2 \
		-activate "true"
	stc::apply
	PTN_ChangeETreeConfig $fileId 1 "flood" "2000" 1 1 "false" "false" "false"
        set vpls 1
        foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType role $RoleList {
        	gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac800"
        	PTN_UNI_AddInter $telnet $matchType $Gpn_type $fileId $Worklevel "500" $eth
        	gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac500" "vpls$vpls" "" $eth "500" "0" $role "nochange" "1" "0" "0" "0x8100" "evc2"
        	incr vpls
        }
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��ac500��δ���þ�̬mac��ַʱ����ת����mac��ַת����  ���Կ�ʼ=====\n"
	set staticMac "0000.0000.0002"
	set staticMac_dst "0000.0000.0022"
	####δ���þ�̬macʱ����
	incr capId
	if {[PTN_BlackAndWhiteMac 0 0 0 "��NE1($gpnIp1)��ac500��δ���þ�̬mac��ַ$staticMac\ʱ" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010_$capId"]} {
		set flag1_case7 1
	}
	puts $fileId ""
	if {$flag1_case7 == 1} {
		set flagCase7 1
		 gwd::GWpublic_print "NOK" "FD9�����ۣ���NE1($gpnIp1)��ac500��δ���þ�̬mac��ַʱ����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD9�����ۣ���NE1($gpnIp1)��ac500��δ���þ�̬mac��ַʱ����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls�������ý�ֹͨ��δ֪������������ͨ���㲥�����鲥����֤ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_addStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls1" "ac500"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 1 0 "��NE1($gpnIp1)��ac500���þ�̬mac��ַ$staticMac\��" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010_$capId"]} {
		set flag2_case7 1
	}
	puts $fileId ""
	if {$flag2_case7 == 1} {
		set flagCase7 1
		 gwd::GWpublic_print "NOK" "FE1�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE1�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��ac500�����þ�̬mac��ַ����������SW�������������ת����mac��ַת����  ���Կ�ʼ=====\n"
	##��������SW��������
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 0 1 0 "��NE1($gpnIp1)��ac500���þ�̬mac��ַ$staticMac\�����е�$j\��SW����������" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010_$capId"]} {
				set flag3_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag 1 ;#=1 ��������
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag3_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FE2�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ����������SW�������������ת����mac��ַת����" $fileId
		} else {
			gwd::GWpublic_print "OK" "FE2�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ����������SW�������������ת����mac��ַת����" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��ac500�����þ�̬mac��ַ����������SW�������������ת����mac��ַת����  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��ac500�����þ�̬mac��ַ����������NMS�������������ת����mac��ַת����  ���Կ�ʼ=====\n"
	##��������NMS��������
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 0 1 0 "��NE1($gpnIp1)��ac500���þ�̬mac��ַ$staticMac\�����е�$j\��NMS����������" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010_$capId"]} {
				set flag4_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��NMS�̣���������" $fileId
			set testFlag 1 ;#=1 ��������
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag4_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FE3�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ����������NMS�������������ת����mac��ַת����" $fileId
		} else {
			gwd::GWpublic_print "OK" "FE3�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ����������NMS�������������ת����mac��ַת����" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====��NE1($gpnIp1)��ac500�����þ�̬mac��ַ����������NMS�������������ת����mac��ַת����  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500��ɾ�����õľ�̬mac��ַ�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls1"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 0 0 "��NE1($gpnIp1)��ac500��ɾ�����þ�̬mac��ַ$staticMac\��" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010_$capId"]} {
		set flag5_case7 1
	}
	puts $fileId ""
	if {$flag5_case7 == 1} {
		set flagCase7 1
		 gwd::GWpublic_print "NOK" "FE4�����ۣ�NE1($gpnIp1)ac500��ɾ�����õľ�̬mac��ַ�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE4�����ۣ�NE1($gpnIp1)ac500��ɾ�����õľ�̬mac��ַ�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500��ɾ�����õľ�̬mac��ַ�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12�����þ�̬mac��ַ�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_addStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls1" "pw12"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 1 1 "��NE1($gpnIp1)��pw12��������þ�̬mac��ַ$staticMac_dst\��" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010_$capId"]} {
		set flag6_case7 1
	}
	puts $fileId ""
	if {$flag6_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FE5�����ۣ�NE1($gpnIp1)pw12�����þ�̬mac��ַ�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE5�����ۣ�NE1($gpnIp1)pw12�����þ�̬mac��ַ�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12�����þ�̬mac��ַ�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12�����þ�̬mac��ַ����������SW�������������ת����mac��ַת����  ���Կ�ʼ=====\n"
	##��������SW��������
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 0 1 1 "��NE1($gpnIp1)��pw12��������þ�̬mac��ַ$staticMac_dst\�����е�$j\��SW����������" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010_$capId"]} {
				set flag7_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag 1 ;#=1 ��������
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag7_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FE6�����ۣ�NE1($gpnIp1)pw12�����þ�̬mac��ַ����������SW�������������ת����mac��ַת����" $fileId
		} else {
			gwd::GWpublic_print "OK" "FE6�����ۣ�NE1($gpnIp1)pw12�����þ�̬mac��ַ����������SW�������������ת����mac��ַת����" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12�����þ�̬mac��ַ����������SW�������������ת����mac��ַת����  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12�����þ�̬mac��ַ����������NMS�������������ת����mac��ַת����  ���Կ�ʼ=====\n"
	##��������NMS��������
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 0 1 1 "��NE1($gpnIp1)��pw12��������þ�̬mac��ַ$staticMac_dst\�����е�$j\��NMS����������" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010_$capId"]} {
				set flag8_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��NMS�̣���������" $fileId
			set testFlag 1 ;#=1 ��������
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag8_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FE7�����ۣ�NE1($gpnIp1)pw12�����þ�̬mac��ַ����������NMS�������������ת����mac��ַת����" $fileId
		} else {
			gwd::GWpublic_print "OK" "FE7�����ۣ�NE1($gpnIp1)pw12�����þ�̬mac��ַ����������NMS�������������ת����mac��ַת����" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12�����þ�̬mac��ַ����������NMS�������������ת����mac��ַת����  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12��ɾ����̬mac��ַ�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls1"
	if {[PTN_BlackAndWhiteMac 0 0 1 "��NE1($gpnIp1)��pw12��ɾ�����þ�̬mac��ַ$staticMac_dst\��" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010_$capId"]} {
		set flag9_case7 1
	}
	puts $fileId ""
	if {$flag9_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FE8�����ۣ�NE1($gpnIp1)pw12��ɾ����̬mac��ַ�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE8�����ۣ�NE1($gpnIp1)pw12��ɾ����̬mac��ַ�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12��ɾ����̬mac��ַ�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500�����úڶ�mac�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_addBlackHoleMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls1" "ac500" "src_drop"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 1 0 "��NE1($gpnIp1)��ac500�����úڶ�mac��ַ$staticMac\��" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010-$capId"]} {
		set flag10_case7 1
	}
	puts $fileId ""
	if {$flag10_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FE9�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE9�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500�����úڶ�mac�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500�����úڶ�mac����������SW�������������ת����mac��ַת����  ���Կ�ʼ=====\n"
	##��������SW��������
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 1 1 0 "��NE1($gpnIp1)��ac500�����úڶ�mac��ַ$staticMac\�����е�$j\��SW����������" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010-$capId"]} {
				set flag11_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag 1 ;#=1 ��������
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag11_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FF1�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac����������SW�������������ת����mac��ַת����" $fileId
		} else {
			gwd::GWpublic_print "OK" "FF1�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac����������SW�������������ת����mac��ַת����" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500�����úڶ�mac����������SW�������������ת����mac��ַת����  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500�����úڶ�mac����������NMS�������������ת����mac��ַת����  ���Կ�ʼ=====\n"
	##��������NMS��������
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 1 1 0 "��NE1($gpnIp1)��ac500�����úڶ�mac��ַ$staticMac\�����е�$j\��NMS����������" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010-$capId"]} {
				set flag12_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��NMS�̣���������" $fileId
			set testFlag 1 ;#=1 ��������
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag12_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FF2�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac����������NMS�������������ת����mac��ַת����" $fileId
		} else {
			gwd::GWpublic_print "OK" "FF2�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac����������NMS�������������ת����mac��ַת����" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500�����úڶ�mac����������NMS�������������ת����mac��ַת����  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500��ɾ���ڶ�mac�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls1"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 0 0 "��NE1($gpnIp1)��ac500��ɾ���ڶ�mac��ַ$staticMac\��" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010-$capId"]} {
		set flag13_case7 1
	}
	puts $fileId ""
	if {$flag13_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FF3�����ۣ�NE1($gpnIp1)ac500��ɾ���ڶ�mac�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FF3�����ۣ�NE1($gpnIp1)ac500��ɾ���ڶ�mac�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500��ɾ���ڶ�mac�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12����Ӻڶ�mac�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_addBlackHoleMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls1" "pw12" "src_drop"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 1 1 "��NE1($gpnIp1)��pw12����Ӻڶ�mac��ַ$staticMac_dst\��" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010-$capId"]} {
		set flag14_case7 1
	}
	puts $fileId ""
	if {$flag14_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FF4�����ۣ�NE1($gpnIp1)pw12����Ӻڶ�mac�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FF4�����ۣ�NE1($gpnIp1)pw12����Ӻڶ�mac�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12����Ӻڶ�mac�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12�����úڶ�mac����������SW�������������ת����mac��ַת����  ���Կ�ʼ=====\n"
	##��������SW��������
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 1 1 1 "��NE1($gpnIp1)��pw12����Ӻڶ�mac��ַ$staticMac_dst\�����е�$j\��SW����������" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010-$capId"]} {
				set flag15_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ�������̣���������" $fileId
			set testFlag 1 ;#=1 ��������
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag15_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FF5�����ۣ�NE1($gpnIp1)pw12�����úڶ�mac����������SW�������������ת����mac��ַת����" $fileId
		} else {
			gwd::GWpublic_print "OK" "FF5�����ۣ�NE1($gpnIp1)pw12�����úڶ�mac����������SW�������������ת����mac��ַת����" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12�����úڶ�mac����������SW�������������ת����mac��ַת����  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12�����úڶ�mac����������NMS�������������ת����mac��ַת����  ���Կ�ʼ=====\n"
	##��������NMS��������
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 1 1 1 "��NE1($gpnIp1)��pw12����Ӻڶ�mac��ַ$staticMac_dst\�����е�$j\��NMS����������" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010-$capId"]} {
				set flag16_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\ֻ��һ��NMS�̣���������" $fileId
			set testFlag 1 ;#=1 ��������
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag16_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FF6�����ۣ�NE1($gpnIp1)pw12�����úڶ�mac����������NMS�������������ת����mac��ַת����" $fileId
		} else {
			gwd::GWpublic_print "OK" "FF6�����ۣ�NE1($gpnIp1)pw12�����úڶ�mac����������NMS�������������ת����mac��ַת����" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12�����úڶ�mac����������NMS�������������ת����mac��ַת����  ���Խ���=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12��ɾ���ڶ�mac�����ת����mac��ַת����  ���Կ�ʼ=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls1"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 0 0 "��NE1($gpnIp1)��pw12��ɾ���ڶ�mac��ַ$staticMac_dst\��" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010-$capId"]} {
		set flag17_case7 1
	}
	puts $fileId ""
	if {$flag17_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FF7�����ۣ�NE1($gpnIp1)pw12��ɾ���ڶ�mac�����ת����mac��ַת����" $fileId
	} else {
		gwd::GWpublic_print "OK" "FF7�����ۣ�NE1($gpnIp1)pw12��ɾ���ڶ�mac�����ת����mac��ַת����" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12��ɾ���ڶ�mac�����ת����mac��ַת����  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
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
	puts $fileId "Test Case 7 E-TREEҵ�񣺺ڰ���������  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 8 E-TREEҵ������ͳ�Ʋ���\n"
        #   <1>�������ˣ����ò��䣬NE1��NE2��NE3��NE4������֪������ÿ�뷢10000��������ҵ������
        #   <2>ʹ��NE1��lsp/pw������ͳ�ƣ�����ac����ac���󶨵�����˿ڣ���lsp��pw�ĵ�ǰ����ͳ�ƣ���ѯʱ����Ϊ1����
        #   <3>һ5���Ӻ��������ϲ鿴ͳ�ƽ����Ӧ����5��ͳ�ƽ������ÿ�������ֵ�������/������Ϊ60*10000�����ң�û���������ϵ����
        #   <4>ɾ����ǰ����ͳ�ƣ������������ac����ac���󶨵�����˿ڣ���lsp��pw��15���Ӳɼ���Ϣ
        #   <5>һСʱ��鿴15������ʷ����ͳ�ƣ�Ӧ�����ĸ�ͳ�ƽ����ÿ15����ͳ��һ�Σ�ͳ����ȷ
        #   <6>ɾ��15������ʷ����ͳ�ƣ������������ac����ac���󶨵�����˿ڣ���lsp��pw��24Сʱ�ɼ���Ϣ��
        #   <7>48Сʱ��鿴24Сʱ��ʷ����ͳ�ƣ�Ӧ��������ͳ�ƽ����ÿ24Сʱͳ��һ�Σ�ͳ����ȷ
        ##ʹ���豸lsp��pw��ac������ͳ�ƣ���֤
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====E-TREEҵ���lsp��pw��ac����ͳ�Ʋ���  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPort1Stream2 \
		-activate "false"
	set flag1_case8 0
	set vpls 1
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType role $RoleList {
        	gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac500"
        	gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac800" "vpls$vpls" "" $eth "800" "0" $role "nochange" "1" "0" "0" "0x8100" "evc2"
        	incr vpls
	}
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp12" "enable"
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "enable"
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp13" "enable"
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "enable"
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp14" "enable"
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "enable"
        gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "enable"
	if {[PTN_EVP_State $telnet1 $matchType1 $Gpn_type1 $fileId "$hGPNPort1Stream20 $hGPNPort2Stream23" \
		 $GPNTestEth1 "lsp12" "pw12" "ac800" $hGPNPort1Ana $hGPNPort1Gen]} {
		set flag1_case8 1
	}
	if {[PTN_EVP_State $telnet1 $matchType1 $Gpn_type1 $fileId "$hGPNPort1Stream21 $hGPNPort3Stream24" \
		 $GPNTestEth1 "lsp13" "pw13" "ac800" $hGPNPort1Ana $hGPNPort1Gen]} {
		set flag1_case8 1
	}
	if {[PTN_EVP_State $telnet1 $matchType1 $Gpn_type1 $fileId "$hGPNPort1Stream22 $hGPNPort4Stream25" \
		 $GPNTestEth1 "lsp14" "pw14" "ac800" $hGPNPort1Ana $hGPNPort1Gen]} {
		set flag1_case8 1
	}
	puts $fileId ""
	if {$flag1_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FF8�����ۣ�E-TREEҵ���lsp��pw��ac����ͳ�Ʋ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "FF8�����ۣ�E-TREEҵ���lsp��pw��ac����ͳ�Ʋ���" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====E-TREEҵ���lsp��pw��ac����ͳ�Ʋ���  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
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
	puts $fileId "Test Case 8 E-TREEҵ������ͳ�Ʋ���  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 9 E-TREEҵ���ܣ������E-Treeҵ�����\n"
        ##�����E-Treeҵ��
        #   <1>���˲��䣬�½�һ����vpls2��,�ٴ���һ���µ�E-Treeҵ��(��֮ǰ��ҵ����ͬ��ͬLSP)�������µ�pw�������豸��AC����ģʽ��Ϊ���˿�+��Ӫ��VLAN+�ͻ�VLAN����
        #      ��Ӫ��VLANΪ vlan 800���ͻ�VLANΪvlan 500��ҵ��ɹ�������ϵͳ���쳣����֮ǰ��ҵ�����κθ��ţ�
        #   <2>����NE1��LSP10���ǩ17������ǩ17��PW10���ر�ǩ20��Զ�̱�ǩ20
        #      ����NE3��LSP10���ǩ18������ǩ18��PW10���ر�ǩ20��Զ�̱�ǩ20 
        #      NE2��SW���ã�mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000> <1-65535> [normal|ring] 
        #   <3>��NE1��UNI�˿ڷ���untag��tag300��tag3000�� ˫��tag����800 ��500��ҵ������
        #   Ԥ�ڽ����NE2��NE3��NE4��UNI�˿�ֻ�ɽ��յ�˫��tag����800 ��500��ҵ���������Ҷ�֮ǰ��ҵ���޸��ţ�˫����ҵ������
        #   <4>undo shutdown��shutdown NE1��NE2�豸��NNI/UNI�˿�50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
        #   <5>����NE1��NE2�豸��NNI/UNI�˿����ڰ忨50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 
        #   <6>NE1��NE2�豸����SW/NMS����50�Σ�ÿ�β�����ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣 ���鿴��ǩת��������ȷ
        #   <7>��������NE1��NE2�豸��50�Σ�ÿ�β�����ϵͳ����������ÿ��ҵ��ָ������ұ˴��޸��ţ�ϵͳ���쳣���鿴��ǩת��������ȷ
        #   <8>�ڲ�ɾ��vpls������£�ɾ��vpls2��ac��vpls2��ҵ���жϣ�vpls1��ҵ����Ӱ��
        #   <9>�������ac���鿴������ӳɹ���ҵ��ָ����Ҳ�Ӱ���������ҵ��
        #   <10>ֱ��ɾ����vpls����ɾ����Ӧ��pw,
        #   Ԥ�ڽ��������ҵ���жϣ���Ӱ��vpls1��ҵ��
        #   <11>���´���һ��vpls2,NE2Ϊ���ڵ�NE1ΪҶ�ӽڵ㣬lsp����vpls1�ģ�pw���´�����NE2���½���PW�Ľ�ɫΪnone(Ҷ��)��
        #       NE1���½���pw�Ľ�ɫΪroot����֤�˸��ڵ�����NNI�ڻ�۵��������pwΪroot
        #   <12>����һ���µ�E-Treeҵ��AC����ģʽ��Ϊ���˿�+��Ӫ��VLAN������Ӫ��VLANΪ vlan 200ҵ��ɹ�������
        #   Ԥ�ڽ����ϵͳ���쳣����֮ǰ��ҵ�����κθ���
        #   <13>ɾ����vpls����ɾ����Ӧ��pw,����ҵ���жϣ���Ӱ��vpls1��ҵ�� 
	set flag1_case9 0
	set flag2_case9 0
	set flag3_case9 0
	set flag4_case9 0
	set flag5_case9 0
	set flag6_case9 0
	set flag7_case9 0
	set flag8_case9 0
	set flag9_case9 0
	set flag10_case9 0
	
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN����������ETREE��ҵ��  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList $hGPNPort1Stream2 \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList8 $hGPNPortStreamList5" \
		-activate "true"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort5 "undo shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "shutdown"
	gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $GPNPort12 "undo shutdown"
	set vpls 1
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 role $RoleList matchType $lMatchType {
	        gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac800"
	        gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac100" "vpls$vpls" "" $eth "100" "0" $role "modify" "100" "0" "0" "0x8100" "evc2"
	        incr vpls
	}
	set id 10
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 role $RoleList matchType $lMatchType {
		gwd::GWVpls_AddInfo $telnet $matchType $Gpn_type $fileId "vpls$id" $id "etree" "flood" "false" "false" "false" "true" "2000" "" ""
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac800" "vpls$id" "" $eth "800" "500" $role "nochange" "1" "0" "0" "0x8100" "evc3"
		incr id 10
	}
	###����pw
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw012" "vpls" "vpls10" "peer" $address612 "100" "100" "" "nochange" "leaf" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw014" "vpls" "vpls10" "peer" $address614 "200" "200" "" "nochange" "leaf" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw013" "vpls" "vpls10" "peer" $address613 "300" "300" "" "nochange" "leaf" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw021" "vpls" "vpls20" "peer" $address621 "100" "100" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw031" "vpls" "vpls30" "peer" $address631 "300" "300" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw041" "vpls" "vpls40" "peer" $address641 "200" "200" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	
	incr capId
	if {[TestRepeat_case2Andcase9 2 $fileId "" "GPN_PTN_010_$capId" $rateL $rateR]} {
		set flag1_case9 1
	}

	puts $fileId ""
	if {$flag1_case9 == 1} {
		set flagCase9 1
		gwd::GWpublic_print "NOK" "FF9�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN����������ETREE��ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FF9�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN����������ETREE��ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN����������ETREE��ҵ��  ���Խ���=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n" 
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====2��ETREEҵ��NE1($gpnIp1)����shut undoshut NNI �ں����2��ETREEҵ��Ļָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n"
	##����undo shutdown/shutdown�˿�
	foreach eth $portlist1 {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
		for {set j 1} {$j<=$cnt} {incr j} {
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
			after $WaiteTime
			incr capId
			if {[TestRepeat_case2Andcase9 2 $fileId "��$j\��shutdown/undo shutdown NE1($gpnIp1)��$eth\�˿ں�" "GPN_PTN_010_$capId" $rateL $rateR]} {
				set  flag2_case9 1
			}
		}
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag2_case9 1
			gwd::GWpublic_print "NOK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "����shutdown/undo shutdown NE1($gpnIp1)�Ķ˿�$eth\֮ǰϵͳ�ڴ�Ϊ$resource1\��֮��ϵͳ�ڴ�Ϊ$resource2���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag2_case9 == 1} {
		set flagCase9 1
		 gwd::GWpublic_print "NOK" "FG1�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)����shut undoshut NNI �ں����ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG1�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)����shut undoshut NNI �ں����ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)����shut undoshut NNI �ں����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
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
				if {[TestRepeat_case2Andcase9 2 $fileId "��$j\������NE1($gpnIp1)$slot\��λ�忨" "GPN_PTN_010_$capId" $rateL $rateR]} {
					set  flag3_case9 1
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
				set flag3_case9 1
				gwd::GWpublic_print "NOK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯�����������$errRate\��" $fileId
			} else {
				gwd::GWpublic_print "OK" "��������NE1($gpnIp1)$slot\��λ�忨֮ǰϵͳ�ڴ�Ϊ$resource3\��֮��ϵͳ�ڴ�Ϊ$resource4���ڴ�仯���������$errRate\��" $fileId
			}
		}
	}
	puts $fileId ""
	if {$flag3_case9 == 1} {
		set flagCase9 1
		 gwd::GWpublic_print "NOK" "FG2�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG2�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	set expectTable1 "0000.0000.000C ac100 0000.0000.00F2 pw12 0000.0000.00F3 pw13 0000.0000.00F4 pw14"
	set expectTable2 "0000.0000.0026 ac800 0000.0000.0205 pw012 0000.0000.0305 pw013 0000.0000.0405 pw014"
	###��������NMS��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestRepeat_case2Andcase9 2 $fileId "��$j\�� NE1($gpnIp1)����NMS����������" "GPN_PTN_010_$capId" $rateL $rateR]} {
				set  flag4_case9 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable $expectTable1]} {
				set flag4_case9 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls10" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����NMS����������" $dTable $expectTable2]} {
				set flag4_case9 1
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
		set flag4_case9	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)����NMS��������֮ǰϵͳ�ڴ�Ϊ$resource5\��֮��ϵͳ�ڴ�Ϊ$resource6���ڴ�仯���������$errRate\��" $fileId
	}
	}
	puts $fileId ""
	if {$flag4_case9 == 1} {
	set flagCase9 1
	 gwd::GWpublic_print "NOK" "FG3�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
	gwd::GWpublic_print "OK" "FG3�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	##��������SW��������
	set testFlag 0 ;#=1 ��������
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestRepeat_case2Andcase9 2 $fileId "��$j\�� NE1($gpnIp1)����SW��������" "GPN_PTN_010_$capId" $rateL $rateR]} {
				set  flag5_case9 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����SW����������" $dTable $expectTable1]} {
				set flag5_case9 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls10" dTable
			if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)����SW����������" $dTable $expectTable2]} {
				set flag5_case9 1
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
			set flag5_case9	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯�����������$errRate\��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)����SW��������֮ǰϵͳ�ڴ�Ϊ$resource7\��֮��ϵͳ�ڴ�Ϊ$resource8���ڴ�仯���������$errRate\��" $fileId
		}
	}
	puts $fileId ""
	if {$flag5_case9 == 1} {
		set flagCase9 1
		 gwd::GWpublic_print "NOK" "FG4�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG4�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�  ���Կ�ʼ=====\n" 
	##���������豸����
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[TestRepeat_case2Andcase9 2 $fileId "��$j\�� NE1($gpnIp1)���б����豸������" "GPN_PTN_010_$capId" $rateL $rateR]} {
			set  flag6_case9 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
		if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)���б����豸������" $dTable $expectTable1]} {
			set flag6_case9 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls10" dTable
		if {[TestVplsForwardEntry $fileId "��$j\�� NE1($gpnIp1)���б����豸������" $dTable $expectTable2]} {
			set flag6_case9 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag6_case9	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯�����������$errRate\��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)���������豸����֮ǰϵͳ�ڴ�Ϊ$resource9\��֮��ϵͳ�ڴ�Ϊ$resource10���ڴ�仯���������$errRate\��" $fileId
	}
	puts $fileId ""
	if {$flag6_case9 == 1} {
		set flagCase9 1
		gwd::GWpublic_print "NOK" "FG5�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG5�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1��������vplsType��acΪPORT+VLAN��ETREE2��������vplsType��acΪPORT+SVLAN+CLVAN��ɾ��ETREE2��AC�����ҵ��  ���Կ�ʼ=====\n"
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 role $RoleList matchType $lMatchType {
		gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac800"
	}
	incr capId
	if {[TestRepeat_case2Andcase9 3 $fileId "ɾ��ETREE2��AC��" "GPN_PTN_010_$capId" $rateL $rateR]} {
		set  flag7_case9 1
	}
	puts $fileId ""
	if {$flag7_case9 == 1} {
		set flagCase9 1
		gwd::GWpublic_print "NOK" "FG6�����ۣ�2��ETREEҵ��ɾ��ETREE2ҵ���AC������ETREE1��ETREE2��ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG6�����ۣ�2��ETREEҵ��ɾ��ETREE2ҵ���AC������ETREE1��ETREE2��ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1��������vplsType��acΪPORT+VLAN��ETREE2��������vplsType��acΪPORT+SVLAN+CLVAN��ɾ��ETREE2��AC�����ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1��������vplsType��acΪPORT+VLAN��ETREE2��������vplsType��acΪPORT+SVLAN+CLVAN��ɾ��ETREE2ҵ���AC��ָ�AC���ò���ҵ��  ���Կ�ʼ=====\n"
	set id 10
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 role $RoleList matchType $lMatchType {
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac800" "vpls$id" "" $eth "800" "500" $role "nochange" "1" "0" "0" "0x8100" "evc3"
		incr id 10
	}
	incr capId
	if {[TestRepeat_case2Andcase9 2 $fileId "ɾ��ETREE2ҵ���AC��ָ�AC����" "GPN_PTN_010_$capId" $rateL $rateR]} {
		set  flag8_case9 1
	}
	puts $fileId ""
	if {$flag8_case9 == 1} {
		set flagCase9 1
		gwd::GWpublic_print "NOK" "FG7�����ۣ�2��ETREEҵ��ɾ��ETREE2ҵ���AC��ָ�AC���ã�����ETREE1��ETREE2��ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG7�����ۣ�2��ETREEҵ��ɾ��ETREE2ҵ���AC��ָ�AC���ã�����ETREE1��ETREE2��ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1��������vplsType��acΪPORT+VLAN��ETREE2��������vplsType��acΪPORT+SVLAN+CLVAN��ɾ��ETREE2ҵ���AC��ָ�AC���ò���ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1��������vplsType��acΪPORT+VLAN��ETREE2��������vplsType��acΪPORT+SVLAN+CLVAN��ɾ��ETREE2��vpls���  ���Կ�ʼ=====\n"
	gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw012"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw013"
	gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw014"
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls10"
	
	gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw021"
	gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls20"
	
	gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw031"
	gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls30"
	
	gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac800"
	gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw041"
	gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40"
	incr capId
	if {[TestRepeat_case2Andcase9 3 $fileId "ɾ��ETREE2��vpls���" "GPN_PTN_010_$capId" $rateL $rateR]} {
		set  flag9_case9 1
	}
	puts $fileId ""
	if {$flag9_case9 == 1} {
		set flagCase9 1
		gwd::GWpublic_print "NOK" "FG8�����ۣ�2��ETREEҵ��ɾ��ETREE2��vpls��󣬲���ETREE1��ETREE2��ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG8�����ۣ�2��ETREEҵ��ɾ��ETREE2��vpls��󣬲���ETREE1��ETREE2��ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1��������vplsType��acΪPORT+VLAN��ETREE2��������vplsType��acΪPORT+SVLAN+CLVAN��ɾ��ETREE2��vpls���  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1��������vplsType��acΪPORT+VLAN(100)��ETREE2��������vplsType��acΪPORT+VLAN(500)������������ETREE��ҵ��  ���Կ�ʼ=====\n"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList8" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList2" \
		-activate "true"
	set id 10
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 role $RoleList matchType $lMatchType {
		gwd::GWVpls_AddInfo $telnet $matchType $Gpn_type $fileId "vpls$id" $id "etree" "flood" "false" "false" "false" "true" "2000" "" ""
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac500" "vpls$id" "" $eth "500" "0" $role "nochange" "1" "0" "0" "0x8100" "evc3"
		incr id 10
	}
	###����pw
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw012" "vpls" "vpls10" "peer" $address612 "100" "100" "" "nochange" "leaf" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw014" "vpls" "vpls10" "peer" $address614 "200" "200" "" "nochange" "leaf" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw013" "vpls" "vpls10" "peer" $address613 "300" "300" "" "nochange" "leaf" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw021" "vpls" "vpls20" "peer" $address621 "100" "100" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw031" "vpls" "vpls30" "peer" $address631 "300" "300" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw041" "vpls" "vpls40" "peer" $address641 "200" "200" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	#��֤vpls10/20/30/40
	incr capId
	if {[TestRepeat_case1 $fileId "ETREE2��AC����Ϊport+vlanģʽ��" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
		set flag10_case9 1
	}
	#��֤vpls1/2/3/4
	incr capId
	if {[TestRepeat_case2Andcase9 4 $fileId "ETREE2��AC����Ϊport+vlanģʽ��" "GPN_PTN_010_$capId" $rateL $rateR]} {
		set  flag10_case9 1
	}
	puts $fileId ""
	if {$flag10_case9 == 1} {
		set flagCase9 1
		gwd::GWpublic_print "NOK" "FG9�����ۣ�ETREE1��������vplsType��acΪPORT+VLAN(100)��ETREE2��������vplsType��acΪPORT+VLAN(500)������������ETREE��ҵ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG9�����ۣ�ETREE1��������vplsType��acΪPORT+VLAN(100)��ETREE2��������vplsType��acΪPORT+VLAN(500)������������ETREE��ҵ��" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1��������vplsType��acΪPORT+VLAN(100)��ETREE2��������vplsType��acΪPORT+VLAN(500)������������ETREE��ҵ��  ���Խ���=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase9 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 9���Խ���" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 9���Խ���" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 9 E-TREEҵ���ܣ������E-Treeҵ�����  ���Խ���\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===�ָ���ʼ������...\n"
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac500"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw012"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw013"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw014"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls10"]
	lappend flagDel [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac100"]
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
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.500  $matchType1 $Gpn_type1 $telnet1]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth1.800  $matchType1 $Gpn_type1 $telnet1]
	
	lappend flagDel [gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac500"]
	lappend flagDel [gwd::GWAc_DelName $telnet2 $matchType2 $Gpn_type2 $fileId "ac100"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw021"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls2"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls20"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"] 
	lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort7.5 $ip632 "21" "22" "0" 23 "normal"]
	lappend flagDel [gwd::GWpublic_delLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $GPNPort6.4 $ip612 "23" "20" "0" 21 "normal"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort6.4 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort7.5 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth2.100 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth2.500 $matchType2 $Gpn_type2 $telnet2]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth2.800 $matchType2 $Gpn_type2 $telnet2]
	
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac500"]
	lappend flagDel [gwd::GWAc_DelName $telnet3 $matchType3 $Gpn_type3 $fileId "ac100"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw031"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls3"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls30"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort8.5 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort9.6 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.100 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.500 $matchType3 $Gpn_type3 $telnet3]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth3.800 $matchType3 $Gpn_type3 $telnet3]
	
	lappend flagDel [gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac500"]
	lappend flagDel [gwd::GWAc_DelName $telnet4 $matchType4 $Gpn_type4 $fileId "ac100"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw041"]
	lappend flagDel [gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls4"]
	lappend flagDel [gwd::GWVpls_DelInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls40"]
	lappend flagDel [gwd::GWStaLsp_DelLspName $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"] 
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort10.6 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNPort11.7 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth4.100 $matchType4 $Gpn_type4 $telnet4]
	lappend flagDel [PTN_DelInterVid_new $fileId $Worklevel $GPNTestEth4.500 $matchType4 $Gpn_type4 $telnet4]
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

	foreach {port1 port2} $Portlist telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType {
		if {[string match "L2" $Worklevel]}  {
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
	lappend flagDel [gwd::GWmanage_ftpDownload $telnet1 $matchType1 $Gpn_type1 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"NE1.txt" ""]
	lappend flagDel [gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId]
	lappend flagDel [gwd::GWmanage_ftpDownload $telnet2 $matchType2 $Gpn_type2 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"NE2.txt" ""]
	lappend flagDel [gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId]
	lappend flagDel [gwd::GWmanage_ftpDownload $telnet3 $matchType3 $Gpn_type3 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"NE3.txt" ""]
	lappend flagDel [gwd::GWpublic_Reboot $telnet3 $matchType3 $Gpn_type3 $fileId]
	lappend flagDel [gwd::GWmanage_ftpDownload $telnet4 $matchType4 $Gpn_type4 $fileId $fd_log 60 "config" [dict get $ftp ip] [dict get $ftp userName] [dict get $ftp passWord] \
		"NE4.txt" ""]
	lappend flagDel [gwd::GWpublic_Reboot $telnet4 $matchType4 $Gpn_type4 $fileId]
	after $rebootTime
	#------Ϊ�˹��ɾ���ڶ�mac�;�̬mac�������岻ͬ�����⣬���豸�������س�ʼ��������������
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "���Խ��������ûָ�" "���Խ��������ûָ�" "GPN_PTN_010"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "���Թ��������������ļ����ϴ��ɹ�" "GPN_PTN_010"
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_010����Ŀ�ģ�E-TREE������֤ LSP PW��������\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1==1 || $flagCase2==1 || $flagCase3==1 || $flagCase4==1 || $flagCase5==1 || $flagCase6 == 1 || $flagCase7==1 \
		|| $flagCase8 == 1 || $flagCase9 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_010���Խ��" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase6 == 0) ? "OK" : "NOK"}] "Test Case 6���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase7 == 0) ? "OK" : "NOK"}] "Test Case 7���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase8 == 0) ? "OK" : "NOK"}] "Test Case 8���Խ��" $fileId
	gwd::GWpublic_print [expr {($flagCase9 == 0) ? "OK" : "NOK"}] "Test Case 9���Խ��" $fileId
	gwd::GWpublic_print [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}] "���Խ��������ûָ�" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1����untag/tag��δ֪�������㲥���鲥������ҵ��" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1��NE2/NE3/NE4 ����vid=500����֪����������ҵ��" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE2��NE3��NE4 ����untag/tag��������������ҵ��" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�����NE1($gpnIp1)��NE2($gpnIp2)��NE4($gpnIp4)��NNI���ڷ����Ĳ���MPLS��ǩ" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)����shut undoshut NNI�ں����ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag7_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag8_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag9_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪportģʽ��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB1 == [expr {($flag10_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�ɾ�����豸AC�����ã�ҵ��[expr {($flag10_case1 == 1) ? "û��" : ""}]�ж�" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag11_case1 == 1) ? "NOK" : "OK"}]" "�����ۣ�������Ӹ��豸AC�����ã�����ҵ��" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ��δʹ��overlay����ǰ����MPLS������֤ҵ��" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ��ʹ��overlay���ܺ���MPLS������֤ҵ��" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlanģʽ����֤ҵ��" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)����shut undoshut NNI �ں����ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag7_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC1 == [expr {($flag8_case2 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport+vlanģʽ��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC2 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root��NE2-NE4��AC��leaf��ACΪport��port+vlan���֡�vplsTypeΪtagged������ETREEҵ��" $fileId
	gwd::GWpublic_print "== FC3 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root  NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ����֤ETREEҵ��" $fileId
	gwd::GWpublic_print "== FC4 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�����MPLS��ǩ" $fileId
	gwd::GWpublic_print "== FC5 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2����shutdown/undo shutdown NNI�ڲ���MPLS��ǩ��ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC6 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������NNI�����ڰ忨�����MPLS��ǩ��ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC7 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������NMS�������������MPLS��ǩ��ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC8 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2��������SW�������������MPLS��ǩ��ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FC9 == [expr {($flag7_case4 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1��AC��root NE2-NE4��AC��leaf��ACΪport+vlan��������vpls��ģʽ������NE2�豸��NNI�ڣ�NE2�������б����豸���������MPLS��ǩ��ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FD1 == [expr {($flag1_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls��������mac��ַѧϰ����Ϊ20��ѧϰ����Ϊ����������[expr {($flag1_case5 == 1) ? "��" : ""}]��Ч" $fileId
	gwd::GWpublic_print "== FD2 == [expr {($flag2_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls��������mac��ַѧϰ����Ϊ20��ѧϰ����Ϊ���飬����[expr {($flag2_case5 == 1) ? "��" : ""}]��Ч" $fileId
	gwd::GWpublic_print "== FD3 == [expr {($flag3_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls��������mac��ַѧϰ����Ϊ15��ѧϰ����Ϊ���飬����[expr {($flag3_case5 == 1) ? "��" : ""}]��Ч" $fileId
	gwd::GWpublic_print "== FD4 == [expr {($flag4_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls��������mac��ַѧϰ����Ϊ15��ѧϰ����Ϊ����������[expr {($flag4_case5 == 1) ? "��" : ""}]��Ч" $fileId
	gwd::GWpublic_print "== FD5 == [expr {($flag5_case5 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls��������mac��ַѧϰ����Ϊ100��ѧϰ����Ϊ���飬����[expr {($flag5_case5 == 1) ? "��" : ""}]��Ч" $fileId
	gwd::GWpublic_print "== FD6 == [expr {($flag1_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls�������ý�ֹͨ���㲥��������ͨ���鲥����δ֪��������֤ҵ��" $fileId
	gwd::GWpublic_print "== FD7 == [expr {($flag2_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls�������ý�ֹͨ���鲥��������ͨ���㲥����δ֪��������֤ҵ��" $fileId
	gwd::GWpublic_print "== FD8 == [expr {($flag3_case6 == 1) ? "NOK" : "OK"}]" "�����ۣ�vpls�������ý�ֹͨ��δ֪������������ͨ���㲥�����鲥����֤ҵ��" $fileId
	gwd::GWpublic_print "== FD9 == [expr {($flag1_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ���NE1($gpnIp1)��ac500��δ���þ�̬mac��ַʱ����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE1 == [expr {($flag2_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE2 == [expr {($flag3_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ����������SW�������������ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE3 == [expr {($flag4_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ���NE1($gpnIp1)��ac500�����þ�̬mac��ַ����������NMS�������������ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE4 == [expr {($flag5_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)ac500��ɾ�����õľ�̬mac��ַ�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE5 == [expr {($flag6_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12�����þ�̬mac��ַ�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE6 == [expr {($flag7_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12�����þ�̬mac��ַ����������SW�������������ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE7 == [expr {($flag8_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12�����þ�̬mac��ַ����������NMS�������������ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE8 == [expr {($flag9_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12��ɾ����̬mac��ַ�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FE9 == [expr {($flag10_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FF1 == [expr {($flag11_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac����������SW�������������ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FF2 == [expr {($flag12_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)ac500�����úڶ�mac����������NMS�������������ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FF3 == [expr {($flag13_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)ac500��ɾ���ڶ�mac�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FF4 == [expr {($flag14_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12����Ӻڶ�mac�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FF5 == [expr {($flag15_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12�����úڶ�mac����������SW�������������ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FF6 == [expr {($flag16_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12�����úڶ�mac����������NMS�������������ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FF7 == [expr {($flag17_case7 == 1) ? "NOK" : "OK"}]" "�����ۣ�NE1($gpnIp1)pw12��ɾ���ڶ�mac�����ת����mac��ַת����" $fileId
	gwd::GWpublic_print "== FF8 == [expr {($flag1_case8 == 1) ? "NOK" : "OK"}]" "�����ۣ�E-TREEҵ���lsp��pw��ac����ͳ�Ʋ���" $fileId
	gwd::GWpublic_print "== FF9 == [expr {($flag1_case9 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN����������ETREE��ҵ��" $fileId
	gwd::GWpublic_print "== FG1 == [expr {($flag2_case9 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)����shut undoshut NNI �ں����ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FG2 == [expr {($flag3_case9 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������NNI�����ڰ忨�����ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FG3 == [expr {($flag4_case9 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������NMS������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FG4 == [expr {($flag5_case9 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)��������SW������������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FG5 == [expr {($flag6_case9 == 1) ? "NOK" : "OK"}]" "�����ۣ�һ��ETREE��������vplsType��acΪPORT+VLAN��һ��ETREE��������vplsType��acΪPORT+SVLAN+CLVAN��NE1($gpnIp1)�������б����豸���������ҵ��ָ���ϵͳ�ڴ�" $fileId
	gwd::GWpublic_print "== FG6 == [expr {($flag7_case9 == 1) ? "NOK" : "OK"}]" "�����ۣ�2��ETREEҵ��ɾ��ETREE2ҵ���AC������ETREE1��ETREE2��ҵ��" $fileId
	gwd::GWpublic_print "== FG7 == [expr {($flag8_case9 == 1) ? "NOK" : "OK"}]" "�����ۣ�2��ETREEҵ��ɾ��ETREE2ҵ���AC��ָ�AC���ã�����ETREE1��ETREE2��ҵ��" $fileId
	gwd::GWpublic_print "== FG8 == [expr {($flag9_case9 == 1) ? "NOK" : "OK"}]" "�����ۣ�2��ETREEҵ��ɾ��ETREE2��vpls��󣬲���ETREE1��ETREE2��ҵ��" $fileId
	gwd::GWpublic_print "== FG9 == [expr {($flag10_case9 == 1) ? "NOK" : "OK"}]" "�����ۣ�ETREE1��������vplsType��acΪPORT+VLAN(100)��ETREE2��������vplsType��acΪPORT+VLAN(500)������������ETREE��ҵ��" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "�����ۣ����Խ��������ûָ�" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "�����ۣ����Թ����������ļ����ϴ�" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "�����쳣������Ϊ$err" "" "GPN_PTN_010"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_010_REPORT.txt" "report\\NOK_GPN_PTN_010_REPORT.txt"
	file rename "log\\GPN_PTN_010_LOG.txt" "log\\NOK_GPN_PTN_010_LOG.txt"
} else {
	file rename "report\\GPN_PTN_010_REPORT.txt" "report\\OK_GPN_PTN_010_REPORT.txt"
	file rename "log\\GPN_PTN_010_LOG.txt" "log\\OK_GPN_PTN_010_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}
