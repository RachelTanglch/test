

##�����̴���Ĳ���
set gpnIp1 [lindex $argv 0] ;#GpnIp��GPN1��IP��ַ
set userName1 [lindex $argv 1] ;#STC��IP��ַ
set password1 [lindex $argv 2] ;#STC��IP��ַ
set matchType1 [lindex $argv 3] ;#STC��IP��ַ
set Gpn_type1 [lindex $argv 4] ;#STC��IP��ַ
set gpnIp2 [lindex $argv 5] ;#GpnIp��GPN1��IP��ַ
set userName2 [lindex $argv 6] ;#STC��IP��ַ
set password2 [lindex $argv 7] ;#STC��IP��ַ
set matchType2 [lindex $argv 8] ;#STC��IP��ַ
set Gpn_type2 [lindex $argv 9] ;#STC��IP��ַ
set gpnIp3 [lindex $argv 10] ;#GpnIp��GPN1��IP��ַ
set userName3 [lindex $argv 11] ;#STC��IP��ַ
set password3 [lindex $argv 12] ;#STC��IP��ַ
set matchType3 [lindex $argv 13] ;#STC��IP��ַ
set Gpn_type3 [lindex $argv 14] ;#STC��IP��ַ
set gpnIp4 [lindex $argv 15] ;#GpnIp��GPN1��IP��ַ
set userName4 [lindex $argv 16] ;#STC��IP��ַ
set password4 [lindex $argv 17] ;#STC��IP��ַ
set matchType4 [lindex $argv 18] ;#STC��IP��ַ
set Gpn_type4 [lindex $argv 19] ;#STC��IP��ַ

set managePort1 [lindex $argv 20] ;#STC��IP��ַ
set managePort2 [lindex $argv 21] ;#STC��IP��ַ
set managePort3 [lindex $argv 22] ;#STC��IP��ַ
set managePort4 [lindex $argv 23] ;#STC��IP��ַ
set ftp [lindex $argv 24] ;#STC��IP��ַ
set stcIp [lindex $argv 25] ;#STC��IP��ַ

set GPNStcPort1 [lindex $argv 26] ;#STC��IP��ַ
set GPNTestEth1 [lindex $argv 27] ;#STC��IP��ַ
set GPNEth1Media [lindex $argv 28] ;#STC��IP��ַ
set GPNStcPort2 [lindex $argv 29] ;#STC��IP��ַ
set GPNTestEth2 [lindex $argv 30] ;#STC��IP��ַ
set GPNEth2Media [lindex $argv 31] ;#STC��IP��ַ
set GPNStcPort3 [lindex $argv 32] ;#STC��IP��ַ
set GPNTestEth3 [lindex $argv 33] ;#STC��IP��ַ
set GPNEth3Media [lindex $argv 34] ;#STC��IP��ַ
set GPNStcPort4 [lindex $argv 35] ;#STC��IP��ַ
set GPNTestEth4 [lindex $argv 36] ;#STC��IP��ַ
set GPNEth4Media [lindex $argv 37] ;#STC��IP��ַ
set GPNStcPort5 [lindex $argv 38] ;#STC��IP��ַ
set GPNTestEth5 [lindex $argv 39] ;#STC��IP��ַ
set GPNEth5Media [lindex $argv 40] ;#STC��IP��ַ
set GPNStcPort6 [lindex $argv 41] ;#STC��IP��ַ
set GPNTestEth6 [lindex $argv 42] ;#STC��IP��ַ
set GPNEth6Media [lindex $argv 43] ;#STC��IP��ַ
set GPNPortList [lindex $argv 44] ;#STC��IP��ַ
set Worklevel [lindex $argv 45] ;#STC��IP��ַ
set SoftVer [lindex $argv 46] ;#STC��IP��ַ
set trunkLevel [lindex $argv 47] ;#STC��IP��ַ
set lDev1TestPort [lindex $argv 48] ;#STC��IP��ַ
# set cpuErrRatio [lindex $argv 49] ;#cpu�������ڽ��з��������ͳ�ʱ����Թ���������仯�ķ�Χ����λ���ٷֱ�
# set sysErrRatio [lindex $argv 50] ;#ϵͳ�������ڽ��з��������ͳ�ʱ����Թ���������仯�ķ�Χ����λ���ٷֱ�
# set userErrRatio [lindex $argv 51] ;#�û��������ڽ��з��������ͳ�ʱ����Թ���������仯�ķ�Χ����λ���ٷֱ�



puts  "gpnIp1     :$gpnIp1      "
puts  "userName1  :$userName1   "
puts  "password1  :$password1   "
puts  "matchType1 :$matchType1  "
puts  "Gpn_type1  :$Gpn_type1   "
puts  "gpnIp2     :$gpnIp2      "
puts  "userName2  :$userName2   "
puts  "password2  :$password2   "
puts  "matchType2 :$matchType2  "
puts  "Gpn_type2  :$Gpn_type2   "
puts  "gpnIp3     :$gpnIp3      "
puts  "userName3  :$userName3   "
puts  "password3  :$password3   "
puts  "matchType3 :$matchType3  "
puts  "Gpn_type3  :$Gpn_type3   "
puts  "gpnIp4     :$gpnIp4"
puts  "userName4  :$userName4   "
puts  "password4  :$password4   "
puts  "matchType4 :$matchType4  "
puts  "Gpn_type4  :$Gpn_type4   "

puts  "managePort1:$managePort1 "
puts  "managePort2:$managePort2 "
puts  "managePort3:$managePort3 "
puts  "managePort4:$managePort4 "
puts  "ftp        :$ftp"
puts  "stcIp      :$stcIp"


puts  "GPNStcPort1    :$GPNStcPort1       "
puts  "GPNTestEth1    :$GPNTestEth1       "
puts  "GPNEth1Media   :$GPNEth1Media      "
puts  "GPNStcPort2    :$GPNStcPort2       "
puts  "GPNTestEth2    :$GPNTestEth2       "
puts  "GPNEth2Media   :$GPNEth2Media      "
puts  "GPNStcPort3    :$GPNStcPort3       "
puts  "GPNTestEth3    :$GPNTestEth3       "
puts  "GPNEth3Media   :$GPNEth3Media      "
puts  "GPNStcPort4    :$GPNStcPort4       "
puts  "GPNTestEth4    :$GPNTestEth4       "
puts  "GPNEth4Media   :$GPNEth4Media      "
puts  "GPNStcPort5    :$GPNStcPort5       "
puts  "GPNTestEth5    :$GPNTestEth5       "
puts  "GPNEth5Media   :$GPNEth5Media      "
puts  "GPNStcPort6    :$GPNStcPort6       "
puts  "GPNTestEth6    :$GPNTestEth6       "
puts  "GPNEth6Media   :$GPNEth6Media      "
puts  "GPNPortList    :$GPNPortList       "
puts  "Worklevel      :$Worklevel         "
puts  "SoftVer        :$SoftVer           "
puts  "trunkLevel     :$trunkLevel        "
puts  "lDev1TestPort  :$lDev1TestPort     "

set GPNPort5 [dict get $GPNPortList GPNPort5]
set GPNPort6 [dict get $GPNPortList GPNPort6]
set GPNPort7 [dict get $GPNPortList GPNPort7]
set GPNPort8 [dict get $GPNPortList GPNPort8]
set GPNPort9 [dict get $GPNPortList GPNPort9]
set GPNPort10 [dict get $GPNPortList GPNPort10]
set GPNPort11 [dict get $GPNPortList GPNPort11]
set GPNPort12 [dict get $GPNPortList GPNPort12]
set GPNPort13 [dict get $GPNPortList GPNPort13]
set GPNPort14 [dict get $GPNPortList GPNPort14]
set GPNPort15 [dict get $GPNPortList GPNPort15]
set GPNPort16 [dict get $GPNPortList GPNPort16]
set GPNPort17 [dict get $GPNPortList GPNPort17]
set GPNPort18 [dict get $GPNPortList GPNPort18]
set GPNPort19 [dict get $GPNPortList GPNPort19]
set GPNPort20 [dict get $GPNPortList GPNPort20]
set GPNPort21 [dict get $GPNPortList GPNPort21]
set GPNPort22 [dict get $GPNPortList GPNPort22]
set GPNPort23 [dict get $GPNPortList GPNPort23]
set GPNPort24 [dict get $GPNPortList GPNPort24]






##�ű����õ�ȫ�ֵĲ���-----------------------------------------------------------------------
# regexp {[\d|\.]+} $cpuErrRatio cpuErrRatio
# regexp {[\d|\.]+} $sysErrRatio sysErrRatio
# regexp {[\d|\.]+} $userErrRatio userErrRatio
set cap_enable 1;#ץ��ʹ�ܱ�ʶ =1��ץ���� =0����ץ��
match_max -d 20000000 
set porttype3 "GE";#ELINEҵ��ac�˿�3������:GE/8FX
set porttype4 "GE";#ELINEҵ��ac�˿�4������:GE/8FX
#regexp -nocase {([0-9]+)/([0-9]+)} $GPNTestEth3 match slot3 port3
#regexp -nocase {([0-9]+)/([0-9]+)} $GPNTestEth4 match slot4 port4


set cnt 1   ;#�豸���߰忨�����Ĵ���
set cntdh 2 ;#���������Ĵ���
set errRate 0.1;#�������ķ�Χ
set ptn004_case2_cnt 2 ;#�������ɾ��E-LINEʵ���Ĵ���
set ptn008_case2_cnt 2 ;#ELAN��trunk��������up��down�˿ڵĴ���
set ptn009_case2_cnt 1 ;#ELAN�ȶ��Բ����з�����ɾELANҵ�����õĴ���
set ptn013_case2_cnt 2 ;#ELAN�ȶ��Բ����з�����ɾETREEҵ�����õĴ���
set sendTime 60000;#����ͳ��ʱ��

set WaiteTime 55000 ;#�ȴ�ʱ��
set WaiteTime1 25000 ;#�ȴ�ʱ��
#set WaiteTime8 300000 ;#�ȴ�ʱ��
set rebootTime 300000;#�����豸��ʱ��
set rebootBoardTime 45000;#�����忨��ʱ��
set ip612 20.6.4.1;#NE1�豸��NE2����NNI�ڼ����ip
set ip621 20.6.4.2;#NE2�豸��NE1����NNI�ڼ����ip
set ip623 20.6.5.1;#NE2�豸��NE3����NNI�ڼ����ip
set ip632 20.6.5.2;#NE3�豸��NE2����NNI�ڼ����ip
set ip634 20.6.6.1;#NE3�豸��NE3����NNI�ڼ����ip
set ip643 20.6.6.2;#NE4�豸��NE3����NNI�ڼ����ip
set ip641 20.6.7.2;#NE4�豸��NE1����NNI�ڼ����ip
set ip614 20.6.7.1;#NE1�豸��NE4����NNI�ڼ����ip
set address612 5.5.5.5;#NE1�豸ָ��NE2�豸��Ŀ����Ԫ
set address614 7.7.7.7;#NE1�豸ָ��NE4�豸��Ŀ����Ԫ
set address621 4.4.4.4;#NE2�豸ָ��NE1�豸��Ŀ����Ԫ
set address623 6.6.6.6;#NE2�豸ָ��NE3�豸��Ŀ����Ԫ
set address632 5.5.5.5;#NE3�豸ָ��NE2�豸��Ŀ����Ԫ
set address634 7.7.7.7;#NE3�豸ָ��NE4�豸��Ŀ����Ԫ
set address641 4.4.4.4;#NE4�豸ָ��NE1�豸��Ŀ����Ԫ
set address643 6.6.6.6;#NE4�豸ָ��NE3�豸��Ŀ����Ԫ
set address613 6.6.6.6;#NE1�豸ָ��NE3�豸��Ŀ����Ԫ
set address631 4.4.4.4;#NE3�豸ָ��NE1�豸��Ŀ����Ԫ
set address624 7.7.7.7;#NE2�豸ָ��NE4�豸��Ŀ����Ԫ
set address642 5.5.5.5;#NE4�豸ָ��NE2�豸��Ŀ����Ԫ
set Vlanlist "4 7 4 5 5 6 6 7";#vlan�ӿڵ�id�б�

set macs10 "0000.0000.000d";#Դmac
set macd10 "0000.0000.00dd";#Ŀ��mac
set VsiNum 1024;#����vsi�ĸ���
set AcNum 1024 ;#����ac�ĸ���
set pwNum 1024 ;#����pw�ĸ���
set RoleList "none leaf leaf leaf" ;#E-TREEҵ��ac�Ľ�ɫ�б�
set RoleList1 "leaf none leaf leaf";#E-TREEҵ��ac�Ľ�ɫ�б�
set macount 32000;#vsi������mac��ַѧϰ���������

set filterGlobalCnt 5 ;#����filter_err�����¶��Ʋ���ȡ������������

set trunkSwTime 200 ;#trunk�˿�ҵ�񵹻�ʱ��
###���������ӱ���
set acPwCnt 256
set cpuErrRatio 1
set sysErrRatio 0.1
set userErrRatio 0.1

set longTermIf true ;#�Ƿ���г����Բ��� 1.true ����	2.false ������
set lTermTime 1 ; #�����Բ���ʱ�� СʱΪ��λ���� 24��
set ptn003_case1_cnt 2 ;#ELAN��trunk��������up��down�˿ڵĴ���