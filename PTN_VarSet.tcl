

##主进程传入的参数
set gpnIp1 [lindex $argv 0] ;#GpnIp：GPN1的IP地址
set userName1 [lindex $argv 1] ;#STC的IP地址
set password1 [lindex $argv 2] ;#STC的IP地址
set matchType1 [lindex $argv 3] ;#STC的IP地址
set Gpn_type1 [lindex $argv 4] ;#STC的IP地址
set gpnIp2 [lindex $argv 5] ;#GpnIp：GPN1的IP地址
set userName2 [lindex $argv 6] ;#STC的IP地址
set password2 [lindex $argv 7] ;#STC的IP地址
set matchType2 [lindex $argv 8] ;#STC的IP地址
set Gpn_type2 [lindex $argv 9] ;#STC的IP地址
set gpnIp3 [lindex $argv 10] ;#GpnIp：GPN1的IP地址
set userName3 [lindex $argv 11] ;#STC的IP地址
set password3 [lindex $argv 12] ;#STC的IP地址
set matchType3 [lindex $argv 13] ;#STC的IP地址
set Gpn_type3 [lindex $argv 14] ;#STC的IP地址
set gpnIp4 [lindex $argv 15] ;#GpnIp：GPN1的IP地址
set userName4 [lindex $argv 16] ;#STC的IP地址
set password4 [lindex $argv 17] ;#STC的IP地址
set matchType4 [lindex $argv 18] ;#STC的IP地址
set Gpn_type4 [lindex $argv 19] ;#STC的IP地址

set managePort1 [lindex $argv 20] ;#STC的IP地址
set managePort2 [lindex $argv 21] ;#STC的IP地址
set managePort3 [lindex $argv 22] ;#STC的IP地址
set managePort4 [lindex $argv 23] ;#STC的IP地址
set ftp [lindex $argv 24] ;#STC的IP地址
set stcIp [lindex $argv 25] ;#STC的IP地址

set GPNStcPort1 [lindex $argv 26] ;#STC的IP地址
set GPNTestEth1 [lindex $argv 27] ;#STC的IP地址
set GPNEth1Media [lindex $argv 28] ;#STC的IP地址
set GPNStcPort2 [lindex $argv 29] ;#STC的IP地址
set GPNTestEth2 [lindex $argv 30] ;#STC的IP地址
set GPNEth2Media [lindex $argv 31] ;#STC的IP地址
set GPNStcPort3 [lindex $argv 32] ;#STC的IP地址
set GPNTestEth3 [lindex $argv 33] ;#STC的IP地址
set GPNEth3Media [lindex $argv 34] ;#STC的IP地址
set GPNStcPort4 [lindex $argv 35] ;#STC的IP地址
set GPNTestEth4 [lindex $argv 36] ;#STC的IP地址
set GPNEth4Media [lindex $argv 37] ;#STC的IP地址
set GPNStcPort5 [lindex $argv 38] ;#STC的IP地址
set GPNTestEth5 [lindex $argv 39] ;#STC的IP地址
set GPNEth5Media [lindex $argv 40] ;#STC的IP地址
set GPNStcPort6 [lindex $argv 41] ;#STC的IP地址
set GPNTestEth6 [lindex $argv 42] ;#STC的IP地址
set GPNEth6Media [lindex $argv 43] ;#STC的IP地址
set GPNPortList [lindex $argv 44] ;#STC的IP地址
set Worklevel [lindex $argv 45] ;#STC的IP地址
set SoftVer [lindex $argv 46] ;#STC的IP地址
set trunkLevel [lindex $argv 47] ;#STC的IP地址
set lDev1TestPort [lindex $argv 48] ;#STC的IP地址
# set cpuErrRatio [lindex $argv 49] ;#cpu利用率在进行反复操作和长时间测试过程中允许变化的范围，单位：百分比
# set sysErrRatio [lindex $argv 50] ;#系统利用率在进行反复操作和长时间测试过程中允许变化的范围，单位：百分比
# set userErrRatio [lindex $argv 51] ;#用户利用率在进行反复操作和长时间测试过程中允许变化的范围，单位：百分比



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






##脚本中用到全局的参数-----------------------------------------------------------------------
# regexp {[\d|\.]+} $cpuErrRatio cpuErrRatio
# regexp {[\d|\.]+} $sysErrRatio sysErrRatio
# regexp {[\d|\.]+} $userErrRatio userErrRatio
set cap_enable 1;#抓包使能标识 =1：抓包， =0：不抓包
match_max -d 20000000 
set porttype3 "GE";#ELINE业务ac端口3的属性:GE/8FX
set porttype4 "GE";#ELINE业务ac端口4的属性:GE/8FX
#regexp -nocase {([0-9]+)/([0-9]+)} $GPNTestEth3 match slot3 port3
#regexp -nocase {([0-9]+)/([0-9]+)} $GPNTestEth4 match slot4 port4


set cnt 1   ;#设备或者板卡重启的次数
set cntdh 2 ;#主备倒换的次数
set errRate 0.1;#允许误差的范围
set ptn004_case2_cnt 2 ;#反复添加删除E-LINE实例的次数
set ptn008_case2_cnt 2 ;#ELAN与trunk互操作中up、down端口的次数
set ptn009_case2_cnt 1 ;#ELAN稳定性测试中反复增删ELAN业务配置的次数
set ptn013_case2_cnt 2 ;#ELAN稳定性测试中反复增删ETREE业务配置的次数
set sendTime 60000;#性能统计时间

set WaiteTime 55000 ;#等待时间
set WaiteTime1 25000 ;#等待时间
#set WaiteTime8 300000 ;#等待时间
set rebootTime 300000;#重启设备的时间
set rebootBoardTime 45000;#重启板卡的时间
set ip612 20.6.4.1;#NE1设备与NE2相连NNI口加入的ip
set ip621 20.6.4.2;#NE2设备与NE1相连NNI口加入的ip
set ip623 20.6.5.1;#NE2设备与NE3相连NNI口加入的ip
set ip632 20.6.5.2;#NE3设备与NE2相连NNI口加入的ip
set ip634 20.6.6.1;#NE3设备与NE3相连NNI口加入的ip
set ip643 20.6.6.2;#NE4设备与NE3相连NNI口加入的ip
set ip641 20.6.7.2;#NE4设备与NE1相连NNI口加入的ip
set ip614 20.6.7.1;#NE1设备与NE4相连NNI口加入的ip
set address612 5.5.5.5;#NE1设备指向NE2设备的目标网元
set address614 7.7.7.7;#NE1设备指向NE4设备的目标网元
set address621 4.4.4.4;#NE2设备指向NE1设备的目标网元
set address623 6.6.6.6;#NE2设备指向NE3设备的目标网元
set address632 5.5.5.5;#NE3设备指向NE2设备的目标网元
set address634 7.7.7.7;#NE3设备指向NE4设备的目标网元
set address641 4.4.4.4;#NE4设备指向NE1设备的目标网元
set address643 6.6.6.6;#NE4设备指向NE3设备的目标网元
set address613 6.6.6.6;#NE1设备指向NE3设备的目标网元
set address631 4.4.4.4;#NE3设备指向NE1设备的目标网元
set address624 7.7.7.7;#NE2设备指向NE4设备的目标网元
set address642 5.5.5.5;#NE4设备指向NE2设备的目标网元
set Vlanlist "4 7 4 5 5 6 6 7";#vlan接口的id列表

set macs10 "0000.0000.000d";#源mac
set macd10 "0000.0000.00dd";#目的mac
set VsiNum 1024;#配置vsi的个数
set AcNum 1024 ;#配置ac的个数
set pwNum 1024 ;#配置pw的个数
set RoleList "none leaf leaf leaf" ;#E-TREE业务ac的角色列表
set RoleList1 "leaf none leaf leaf";#E-TREE业务ac的角色列表
set macount 32000;#vsi中配置mac地址学习的最大容量

set filterGlobalCnt 5 ;#发生filter_err后重新定制并获取结果的允许次数

set trunkSwTime 200 ;#trunk端口业务倒换时间
###唐丽春增加变量
set acPwCnt 256
set cpuErrRatio 1
set sysErrRatio 0.1
set userErrRatio 0.1

set longTermIf true ;#是否进行长期性测试 1.true 进行	2.false 不进行
set lTermTime 1 ; #长期性测试时间 小时为单位（例 24）
set ptn003_case1_cnt 2 ;#ELAN与trunk互操作中up、down端口的次数