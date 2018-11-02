#!/bin/sh
# T4_GPN_PTN_ELAN_006.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#测试目的：E-LAN的功能
#1-2-E-LAN业务功能验证  
#3-mac地址学习限制
#4-报文过滤  
#5-黑白名单测试
#6-性能统计  
#7-LSP标签交换功能验证
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
##E-LAN业务功能验证 -接入模式为端口模式
#   <1>四台76组网，组网拓扑见拓扑图7，NE1设备通过带外上网管,NE2和NE3、NE4设备通过带内上网管，或4台设备以DCN管理，四台设备彼此之间的NNI端口通过以太网接口形式相连，NNI端口以untag方式加入到VLANIF中
#   <2>创建NE1、NE2、NE3和NE4之间的一条EP-LAN业务，NE2既为PE又为p设备，用户侧接入模式为端口模式
#   <3>创建LSP1
#      配置NE1到NE2的LSP入标签100，出标签100；PW本地标签1000，远程标签1000
#      配置NE2到NE1的LSP入标签100，出标签100；PW本地标签1000，远程标签1000
#      配置NE2到NE3的LSP入标签200，出标签200；PW本地标签2000，远程标签2000
#      配置NE3到NE2的LSP入标签200，出标签200；PW本地标签2000，远端标签2000
#      配置NE3到NE4的LSP入标签300，出标签300；PW本地标签3000，远程标签3000
#      配置NE4到NE3的LSP入标签300，出标签300；PW本地标签3000，远程标签3000
#      配置NE4到NE1的LSP入标签400，出标签400；PW本地标签4000，远程标签4000
#      配置NE1到NE4的LSP入标签400，出标签400；PW本地标签4000，远端标签4000
#      配置NE1到NE2的LSP入标签500，出标签500，NE2到NE3的lsp入标签600，出标签600，NE2做标签交换；PW本地标签5000，远程标签5000
#      配置NE3到NE2的LSP入标签600，出标签600，NE2到NE1的lsp入标签500，出标签500，NE2做标签交换；PW本地标签5000，远程标签5000
#      配置NE2到NE3的LSP入标签700，出标签700，NE3到NE4的lsp入标签800，出标签800，NE3做标签交换；PW本地标签6000，远程标签6000
#      配置NE4到NE3的LSP入标签800，出标签800，NE3到NE2的lsp入标签700，出标签700，NE3做标签交换；PW本地标签6000，远程标签6000
#      NE2/NE3的SW配置：mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000>
#      <1-65535> [normal|ring] 
#   <4>NE1、NE2、NE3、NE4用户测配置undo vlan check
#   <5>向NE1、NE2、NE3、NE4的端口1分别发送untag/tag、广播、组播、已知单播业务流量
#   预期结果：观察其余三台设备的端口接收结果，三台PE设备均可发送和接收数据
#   <6>使能NE1设备PW1的控制字，并镜像NE1向NE2和NE4的NNI端口egress方向报文，
#   预期结果:NE1向NE4为带VLAN TAG标签并打上两层mpls标签报文，外层lsp标签400，内层pw标签4000，LSP字段中的TTL值为255，PW字段中的TTL值为255，PW字段中含有4字节控制字；
#           NE1向NE2会有两种报文，一为外层lsp标签为200，内层pw标签为2000的MPLS报文，二为外层lsp标签为500，内层pw标签为5000的转向NE3的报文
#   <7>使能NE1的LSP1/PW1/AC1性能统计，系统无异常，性能统计功能生效，统计值正确
#   <8>使能NE1设备PW1的控制字，并镜像NE1的NNI端口egress方向报文
#   预期结果：镜像报文为带VLAN TAG标签并打上两层mpls标签报文，外层lsp标签200，内层pw标签2000
#             LSP字段中的TTL值为255，PW字段中的TTL值为255，PW字段中含有4字节控制字
#   <9>undo shutdown和shutdown NE1设备的NNI/UNI端口50次，每次操作后业务恢复正常，系统无异常 
#   <10>重启NE1设备的NNI/UNI端口所在板卡50次，每次操作后业务恢复正常，系统无异常 
#   <11>NE1设备进行SW/NMS倒换50次，每次操作后业务恢复正常，系统无异常 ，查看标签转发表项正确，三台设备管理正常
#   <12>保存重启NE1设备的50次，每次操作后系统正常启动，业务恢复正常，系统无异常，查看标签转发表项正确，三台设备管理正常 
#2、搭建Test Case 2测试环境
##E-LAN业务功能验证 -接入模式为"端口+运营商VLAN"模式
#   <1>删除NE1、NE2、NE3、NE4设备的专网业务（AC+vpls域），删除成功业务中断，系统无异常，底层查看ac和vpls域配置消失
#   <2>重新在4台设备创建AC节点专网业务（AC),承载伪线（PW）不做更改，均仅将接入模式设为“端口+运营商VLAN”
#   <3>用户侧加入指定的vlan中
#   <4>在四台设备上均创建所需的VLAN（vlan 1000），并加入端口
#   <5>向NE1的端口1发送tag1000、tag2000业务流量，观察NE2、NE3、NE4的UNI端口的接收结果
#   预期结果：再次创建接入模式为“端口+运营商VLAN”的专线业务，成功创建，系统无异常
#             NE2、NE3和NE4的UNI端口只可接收tag1000业务流量；双向发流业务正常
#   <6>删除之前接入模式设为“端口+运营商VLAN”的AC
#   <7>在NE1、NE2、NE3、NE4设备上再创建一条新的E-LAN业务(与之前的业务共用同一条LSP)，且AC接入模式设为“端口+运营商VLAN+客户VLAN”
#      运营商VLAN为 vlan 3000，客户VLAN为vlan 300
#   预期结果：业务成功创建，系统无异常，对之前的业务无任何干扰
#   <8>向NE1的UNI端口2发送untag、tag300、tag3000、 双层tag（外3000 内300）业务流量，观察NE2、NE3、NE4的UNI端口的接收结果
#   预期结果：NE2、NE3、NE4的UNI端口只可接收到双层tag（外3000 内300）业务流量，对之前的业务无干扰，双向发流业务正常
#   <9>undo shutdown和shutdown NE1设备的NNI/UNI端口50次，每次操作后业务恢复正常，系统无异常 
#   <10>重启NE1设备的NNI/UNI端口所在板卡50次，每次操作后业务恢复正常，系统无异常 
#   <11>NE1设备进行SW/NMS倒换50次，每次操作后业务恢复正常，系统无异常 ，查看标签转发表项正确，4台设备管理正常
#   <12>保存重启NE1设备的50次，每次操作后系统正常启动，业务恢复正常，系统无异常，查看标签转发表项正确，4台设备管理正常 
#   <13>将UNI端口更改为FE/10GE端口，其他条件不变，重复以上步骤
#   <14>用FE端口配置ELAN业务时，需开启该板卡的MPLS业务模式（mpls enable <slot>）
#3、搭建Test Case 3测试环境
###mac地址学习限制
#   <1>配置vpls域中mac地址学习数量为100，学习规则为丢弃
#   <2>从NE1的用户侧端口发送源mac不同的110条流，查看mac地址表
#   预期结果：mac地址学习数目正确为100个，条目正确，NE2、NE3、NE4均只能收到100条流，即证明丢弃规则生效
#   <3>学习数量不变，将学习规则改为洪泛
#   <4>从NE1的用户侧端口发送源mac不同的110条流，查看mac地址表
#   预期结果：mac地址学习数目正确为110个，条目正确，NE2、NE3、NE4均能收到110条流，即证明洪泛规则生效，没学到的mac被洪泛
#   <5>将学习数量更改为其他值进行多次验证生效
#4、搭建Test Case 4测试环境
###报文过滤
#   <1>NE1的ac口发送未知单播/组播/广播报文，取消/组播广播抑制，业务正常
#   <2>配置单播/组播/广播抑制功能使能，业务不通，抑制功能禁止，业务恢复
#5、搭建Test Case 5测试环境
###黑白名单测试
#   <1>向NE1发送源为0000.0012.0012，目的mac为0000.0012.0002的数据流，NE2、NE3、NE4均可收到
#   <2>查看mac地址表，0000.0012.0012动态学到ac上
#   <3>在NE1的ac口上配置基于源的静态mac，mac地址为0000.0012.0012，查看mac地址表，该mac表项由动态变为静态，业务正常
#   <4>保存配置重启，表项正确，业务正常
#   <5>删除静态mac，mac地址又被重新动态学习到
#   <6>在NE1--NE2的pw上配置基于源的静态mac，mac地址为0000.0012.0002，NE2收到数据流，NE3、NE4均收不到数据
#   <7>保存配置重启，表项正确，业务正常
#   <8>删除静态mac，NE3、NE4收到数据流
#   <9>在NE1的ac口上配置基于源的静黑洞mac，mac地址为0000.0012.0012，查看mac地址表，动态表项消失，黑洞mac表项存在，业务不通
#   <10>保存配置重启，表项正确，业务正常
#   <11>删除黑洞mac，业务正常，黑洞mac表项消失
#6、搭建Test Case 6测试环境
###性能统计
#   <1>NE1、NE2、NE3、NE4的ac口对发数据流，四个AC口均能收到数据流
#   <2>开启某一台设备的ac端口、lsp、pw的当前性能统计
#   <3>一段时间后，查看统计结果，统计正确
#   <4>添加AC端口，lsp，pw的15分钟采集信息，一小时后查看15分钟历史性能统计，应该有四个统计结果，每15分钟统计一次，统计正确
#   <5>添加AC端口，lsp，pw的24小时采集信息，48小时后查看24小时历史性能统计，应该有两个统计结果，每24小时统计一次，统计正确
#7、搭建Test Case 7测试环境
##LSP标签交换功能验证
#   <1>重新创建NE1到NE3一条E-LAN业务，NNI端口和之前所创建业务的NNI端口相同（即NNI端口复用），只是以tag方式加入到其他VLANIF中，
#      用户侧接入模式为端口模式，故需新创建LSP、PW、AC
#   <2>配置NE1的LSP10入标签17，出标签17；PW10本地标签20，远程标签20
#      配置NE3的LSP10入标签18，出标签18；PW10本地标签20，远程标签20 
#      NE2的SW配置：mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000> <1-65535> [normal|ring] 
#   预期结果：业务配置成功，对之前的E-LAN业务无影响，系统无异常
#   <3>NE1和NE3用户测配置undo vlan check
#   <4>创建PW1/AC1
#   <5>向NE1的UNI端口发送untag/tag业务流量，观察NE3的接收结果
#   预期结果：NE3的端口3可正常接收untag/tag业务流量；双向发流均正常，对之前的业务无干扰
#   <6>镜像NE1的NNI端口egress方向报文
#   预期结果：为带VLAN TAG标签并打上两层mpls标签报文，外层lsp标签17，内层pw标签20，
#             LSP字段中的TTL值为255，PW字段中的TTL值为255，PW字段中含有4字节控制字
#   <7>镜像NE2的NNI端口egress方向，同样可以抓到两层标签，外层标签交换为18，内层标签20，LSP字段中的TTL值减1，PW字段中的TTL值仍为255
#   <8>undo shutdown和shutdown NE1和NE2设备的NNI/UNI端口50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
#   <9>重启NE1和NE2设备的NNI/UNI端口所在板卡50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
#   <10>NE1和NE2设备进行SW/NMS倒换50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 ，查看标签转发表项正确
#   <11>保存重启NE1和NE2设备的50次，每次操作后系统正常启动，每条业务恢复正常且彼此无干扰，系统无异常，查看标签转发表项正确
#   <12>清空四台设备配置，四台设备正常启动，启动后查看均无任何配置
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
        chan configure $fd_log -blocking 0 -buffering none;#非阻塞模式 按行flush
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_006_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#非阻塞模式 按行flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_006_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_006_DEBUG.txt 0
	chan configure $fd_debug -blocking 0 -buffering none;#非阻塞模式 按行flush
	  
	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl

        ###数据流设置
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
	
	###设置定制信息参数
	array set txInfoArr {-configType Generator -resultType GeneratorPortResults  -interval 1}
	array set rxInfoArr1 {-configType Analyzer -resultType FilteredStreamResults -interval 1}
	array set rxInfoArr2 {-configType Analyzer -resultType AnalyzerPortResults -interval 1}
        #设置发生器参数
        set GenCfg {-SchedulingMode RATE_BASED}
        ###设置过滤分析器参数
        ##匹配smc
        set anaFliFrameCfg0 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        ##匹配smc、vid、EtherType
        set anaFliFrameCfg1 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType><vlans name="anon_2561"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        ##匹配两层vid
        set anaFliFrameCfg4 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5580"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
        ##mpls报文中的smac和 vid
        set anaFliFrameCfg51 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_5699"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac></pdu></pdus></config></frame>}
        ##mpls报文中的两层标签
        set anaFliFrameCfg2 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4630"><Vlan name="Vlan"></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><label filterMinValue="0" filterMaxValue="1048575">1048575</label></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
        ##mpls报文中的带的vid和Experimental Bits (bits)/Bottom of stack (bit)
        set anaFliFrameCfg3 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><vlans name="anon_4647"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="proto1" pdu="mpls:Mpls"><exp override="true"  filterMinValue="0" filterMaxValue="111">111</exp></pdu><pdu name="Mpls_1" pdu="mpls:Mpls"><sBit override="true"  filterMinValue="0" filterMaxValue="1">1</sBit></pdu><pdu name="EthernetII_2" pdu="ethernet:EthernetII"></pdu></pdus></config></frame>}
	##匹配smac、vid1、vid2、ethtype
	set anaFliFrameCfg6 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType><vlans name="anon_2516"><Vlan name="Vlan"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan><Vlan name="Vlan_1"><id filterMinValue="0" filterMaxValue="4095">4095</id></Vlan></vlans></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	##匹配smac、ethtype
	set anaFliFrameCfg7 {<frame><config><pdus><pdu name="eth1" pdu="ethernet:EthernetII"><srcMac filterMinValue="00:00:00:00:00:00" filterMaxValue="FF:FF:FF:FF:FF:FF">FF:FF:FF:FF:FF:FF</srcMac><etherType override="true"  filterMinValue="0" filterMaxValue="FFFF">FFFF</etherType></pdu><pdu name="ip_1" pdu="ipv4:IPv4"></pdu></pdus></config></frame>}
	
	set rateL 95000000;#收发数据流取值最小值范围
	set rateR 105000000;#收发数据流取值最大值范围
	set rateL1 100000000 
	set rateR1 125000000
	set rateL0 91000000;#收发数据流取值最小值范围
	set rateR0 106000000;#收发数据流取值最大值范围
	
	set rateL2 81000000;#收发数据流取值最小值范围
	set rateR2 106000000;#收发数据流取值最大值范围 
	
	set flagCase1 0   ;#Test case 1标志位 
	set flagCase2 0   ;#Test case 2标志位
	set flagCase3 0   ;#Test case 3标志位 
	set flagCase4 0   ;#Test case 4标志位
	set flagCase5 0   ;#Test case 5标志位 
	set flagCase6 0   ;#Test case 6标志位 
	set flagCase7 0   ;#Test case 7标志位 
	set flagCase8 0   ;#Test case 7标志位 
	
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
		
		#NE1 NE2 NE3 NE4发送untag、tag=500、tag=800的未知单播 ------
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
		
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		#DEV1 GPNTestEth1的接收检查
		if {$GPNPort1Cnt7(cnt20) < $rateL || $GPNPort1Cnt7(cnt20) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送untag的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt20)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送untag的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt20)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort1Cnt1(cnt53) < $rateL || $GPNPort1Cnt1(cnt53) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=500的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt53)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=500的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt53)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort1Cnt1(cnt54) < $rateL || $GPNPort1Cnt1(cnt54) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=800的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt54)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=800的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt54)，在$rateL-$rateR\范围内" $fileId
		}
		
		if {$GPNPort1Cnt0(cnt55) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送untag的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt55)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送untag的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt55)" $fileId
		}
		if {$GPNPort1Cnt7(cnt35) < $rateL || $GPNPort1Cnt7(cnt35) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=500的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt35)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=500的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt35)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort1Cnt0(cnt57) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=800的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt57)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=800的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt57)" $fileId
		}
		
		if {$GPNPort1Cnt0(cnt01) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt01)" $fileId
		}
		if {$GPNPort1Cnt0(cnt04) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=500的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt04)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=500的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt04)" $fileId
		}
		if {$GPNPort1Cnt0(cnt13) < $rateL || $GPNPort1Cnt0(cnt13) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt0(cnt13)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt0(cnt13)，在$rateL-$rateR\范围内" $fileId
		}
		
		#DEV2 GPNTestEth2的接收检查
		if {$GPNPort2Cnt7(cnt10) < $rateL || $GPNPort2Cnt7(cnt10) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt7(cnt10)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt7(cnt10)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort2Cnt1(cnt50) < $rateL || $GPNPort2Cnt1(cnt50) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt50)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt50)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort2Cnt1(cnt12) < $rateL || $GPNPort2Cnt1(cnt12) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt12)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt12)，在$rateL-$rateR\范围内" $fileId
		}
		
		if {$GPNPort2Cnt0(cnt55) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送untag的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送untag的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt1)" $fileId
		}
		if {$GPNPort2Cnt7(cnt35) < $rateL || $GPNPort2Cnt7(cnt35) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=500的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt7(cnt35)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=500的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt7(cnt35)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort2Cnt0(cnt57) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=800的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt57)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=800的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt57)" $fileId
		}
		
		if {$GPNPort2Cnt0(cnt01) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt01)" $fileId
		}
		if {$GPNPort2Cnt0(cnt04) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=500的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt04)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=500的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt04)" $fileId
		}
		if {$GPNPort2Cnt0(cnt13) < $rateL || $GPNPort2Cnt0(cnt13) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt0(cnt13)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt0(cnt13)" $fileId
		}
		
		#DEV3 GPNTestEth3的接收检查
		if {$GPNPort3Cnt1(cnt1) < $rateL || $GPNPort3Cnt1(cnt1) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt1)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt1)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort3Cnt2(cnt11) < $rateL || $GPNPort3Cnt2(cnt11) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到内层tag=500 外层tag=500的数据流的速率为$GPNPort3Cnt2(cnt11)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到内层tag=500 外层tag=500的数据流的速率为$GPNPort3Cnt2(cnt11)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort3Cnt2(cnt13) < $rateL || $GPNPort3Cnt2(cnt13) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到内层tag=800 外层tag=500的数据流的速率为$GPNPort3Cnt2(cnt13)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到内层tag=800 外层tag=500的数据流的速率为$GPNPort3Cnt2(cnt13)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort3Cnt1(cnt51) < $rateL || $GPNPort3Cnt1(cnt51) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送untag的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt51)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送untag的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt51)，在$rateL-$rateR\范围内" $fileId
		}	
		if {$GPNPort3Cnt2(cnt21) < $rateL || $GPNPort3Cnt2(cnt21) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=500的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到内层tag=500 外层tag=500的数据流的速率为$GPNPort3Cnt2(cnt21)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=500的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到内层tag=500 外层tag=500的数据流的速率为$GPNPort3Cnt2(cnt21)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort3Cnt2(cnt23) < $rateL || $GPNPort3Cnt2(cnt23) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=800的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到内层tag=800 外层tag=500的数据流的速率为$GPNPort3Cnt2(cnt23)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=800的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到内层tag=800 外层tag=500的数据流的速率为$GPNPort3Cnt2(cnt23)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort3Cnt0(cnt01) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt01)" $fileId
		}
		if {$GPNPort3Cnt0(cnt51) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=500的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到数据流的速率应为0实为GPNPort3Cnt0(cnt51)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=500的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到数据流的速率应为0实为GPNPort3Cnt0(cnt51)" $fileId
		}
		if {$GPNPort3Cnt1(cnt55) < $rateL || $GPNPort3Cnt1(cnt55) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt55)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt55)，在$rateL-$rateR\范围内" $fileId
		}
		#DEV4 GPNTestEth4的接收检查 
		if {$GPNPort4Cnt1(cnt81) < $rateL || $GPNPort4Cnt1(cnt81) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt81)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt81)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort4Cnt2(cnt12) < $rateL || $GPNPort4Cnt2(cnt12) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到内层tag=500 外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt12)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到内层tag=500 外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt12)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort4Cnt2(cnt14) < $rateL || $GPNPort4Cnt2(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到内层tag=800 外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt14)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到内层tag=800 外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt14)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort4Cnt1(cnt52) < $rateL || $GPNPort4Cnt1(cnt52) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送untag的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt52)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送untag的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt52)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort4Cnt2(cnt22) < $rateL || $GPNPort4Cnt2(cnt22) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=500的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到内层tag=500 外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt22)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=500的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到内层tag=500 外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt22)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort4Cnt2(cnt24) < $rateL || $GPNPort4Cnt2(cnt24) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=800的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到内层tag=800 外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt24)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=800的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到内层tag=800 外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt24)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort4Cnt0(cnt55) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送untag的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt55)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送untag的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt55)" $fileId
		}
		if {$GPNPort4Cnt1(cnt56) < $rateL || $GPNPort4Cnt1(cnt56) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=500的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt56)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=500的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt56)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort4Cnt0(cnt57) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=800的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt57)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=800的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt57)，在$rateL-$rateR\范围内" $fileId
		}
		return $flag
	}
	#flagElan = 1 一条ELAN业务测试(vplsType为tag ac为PORT+SVLAN+CVLAN); =2  两条ELAN业务测试(vplsType为tag ac为PORT+SVLAN+CVLAN   vpls为Raw ac为PORT+VLAN)
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
		#DEV1 GPNTestEth1的接收检查 
		if {$GPNPort1Cnt0(cnt52) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\发送untag的未知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt52)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\发送untag的未知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt52)" $fileId
		}
		if {$flagElan == 1} {
			if {$GPNPort1Cnt0(cnt54) !=0} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的未知单播数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt54)" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的未知单播数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt54)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt57) < $::rateL || $GPNPort1Cnt1(cnt57) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的未知单播数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt57)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的未知单播数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt57)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort1Cnt2(cnt25) < $::rateL || $GPNPort1Cnt2(cnt25) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\发送内层tag=100外层tag=1000的未知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到内层tag=100外层tag=1000数据流的速率为$GPNPort1Cnt2(cnt25)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\发送内层tag=100外层tag=1000的未知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到内层tag=100外层tag=1000数据流的速率为$GPNPort1Cnt2(cnt25)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort1Cnt0(cnt55) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\发送untag的未知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt55)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\发送untag的未知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt55)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort1Cnt0(cnt56) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的未知单播数据流，NE1($::gpnIp1)\
        				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt56)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的未知单播数据流，NE1($::gpnIp1)\
        				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt56)" $fileId
        		}
		} else {
			if {$GPNPort1Cnt1(cnt58) < $::rateL || $GPNPort1Cnt1(cnt58) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的未知单播数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到tag=500数据流的速率为$GPNPort1Cnt1(cnt58)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的未知单播数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到tag=500数据流的速率为$GPNPort1Cnt1(cnt58)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
        	if {$GPNPort1Cnt2(cnt35) < $::rateL || $GPNPort1Cnt2(cnt35) > $::rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\发送内层tag=100外层tag=1000的未知单播数据流，NE1($::gpnIp1)\
        			$::GPNTestEth1\收到内层tag=100外层tag=1000数据流的速率为$GPNPort1Cnt2(cnt35)，没在$::rateL-$::rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\发送内层tag=100外层tag=1000的未知单播数据流，NE1($::gpnIp1)\
        			$::GPNTestEth1\收到内层tag=100外层tag=1000数据流的速率为$GPNPort1Cnt2(cnt35)，在$::rateL-$::rateR\范围内" $fileId
        	}
		
		if {$GPNPort1Cnt0(cnt01) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送untag的未知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送untag的未知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt01)" $fileId
		}
		if {$flagElan == 1} {
			if {$GPNPort1Cnt0(cnt13) !=0} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt13)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt55) < $::rateL || $GPNPort1Cnt1(cnt55) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt55)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt55)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort1Cnt2(cnt45) < $::rateL || $GPNPort1Cnt2(cnt45) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送内层tag=100外层tag=1000的未知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到内层tag=100外层tag=1000数据流的速率为$GPNPort1Cnt2(cnt45)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送内层tag=100外层tag=1000的未知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到内层tag=100外层tag=1000数据流的速率为$GPNPort1Cnt2(cnt45)，在$::rateL-$::rateR\范围内" $fileId
		}
		#DEV2 GPNTestEth2的接收检查 
		if {$GPNPort2Cnt0(cnt1) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt1)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort2Cnt0(cnt50) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
        				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt50)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
        				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt50)" $fileId
        		}
		} else {
			if {$GPNPort2Cnt1(cnt59) < $::rateL || $GPNPort2Cnt1(cnt59) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt59)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt59)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort2Cnt2(cnt15) < $::rateL || $GPNPort2Cnt2(cnt15) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送内层tag=100外层tag=1000的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到内层tag=100外层tag=1000数据流的速率为$GPNPort2Cnt2(cnt15)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送内层tag=100外层tag=1000的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到内层tag=100外层tag=1000数据流的速率为$GPNPort2Cnt2(cnt15)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort2Cnt0(cnt55) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\发送untag的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt55)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\发送untag的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt55)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort2Cnt0(cnt56) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
        				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt56)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
        				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt56)" $fileId
        		}
		} else {
			if {$GPNPort2Cnt1(cnt56) < $::rateL || $GPNPort2Cnt1(cnt56) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到tag=800数据流的速率为$GPNPort2Cnt1(cnt56)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到tag=800数据流的速率为$GPNPort2Cnt1(cnt56)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort2Cnt2(cnt35) < $::rateL || $GPNPort2Cnt2(cnt35) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\发送内层tag=100外层tag=1000的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到内层tag=100外层tag=1000数据流的速率为$GPNPort2Cnt2(cnt35)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\发送内层tag=100外层tag=1000的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到内层tag=100外层tag=1000数据流的速率为$GPNPort2Cnt2(cnt35)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort2Cnt0(cnt01) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送untag的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送untag的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt01)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort2Cnt0(cnt13) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE2($::gpnIp2)\
        				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt13)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE2($::gpnIp2)\
        				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt13)" $fileId
        		}
		} else {
			if {$GPNPort2Cnt1(cnt13) < $::rateL || $GPNPort2Cnt1(cnt13) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt13)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt13)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort2Cnt2(cnt45) < $::rateL || $GPNPort2Cnt2(cnt45) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送内层tag=100外层tag=1000的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到内层tag=100外层tag=1000数据流的速率为$GPNPort2Cnt2(cnt45)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送内层tag=100外层tag=1000的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到内层tag=100外层tag=1000数据流的速率为$GPNPort2Cnt2(cnt45)，在$::rateL-$::rateR\范围内" $fileId
		}
		#DEV3 GPNTestEth3的接收检查 
		if {$GPNPort3Cnt0(cnt1) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort3Cnt0(cnt50) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE3($::gpnIp3)\
        				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt50)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE3($::gpnIp3)\
        				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt50)" $fileId
        		}
		} else {
			if {$GPNPort3Cnt1(cnt50) < $::rateL || $GPNPort3Cnt1(cnt50) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE3($::gpnIp3)\
					$::GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt50)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE3($::gpnIp3)\
					$::GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt50)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort3Cnt2(cnt15) < $::rateL || $GPNPort3Cnt2(cnt15) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送内层tag=100外层tag=1000的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到内层tag=100外层tag=1000数据流的速率为$GPNPort3Cnt2(cnt15)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送内层tag=100外层tag=1000的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到内层tag=100外层tag=1000数据流的速率为$GPNPort3Cnt2(cnt15)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort3Cnt0(cnt52) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\发送untag的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt52)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\发送untag的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt52)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort3Cnt0(cnt54) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
        				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt54)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
        				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt54)" $fileId
        		}
		} else {
			if {$GPNPort3Cnt1(cnt57) < $::rateL || $GPNPort3Cnt1(cnt57) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
					$::GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt57)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
					$::GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt57)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort3Cnt2(cnt25) < $::rateL || $GPNPort3Cnt2(cnt25) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\发送内层tag=100外层tag=1000的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到内层tag=100外层tag=1000数据流的速率为$GPNPort3Cnt2(cnt25)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\发送内层tag=100外层tag=1000的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到内层tag=100外层tag=1000数据流的速率为$GPNPort3Cnt2(cnt25)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort3Cnt0(cnt01) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送untag的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送untag的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt01)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort3Cnt0(cnt13) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
        				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt13)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
        				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt13)" $fileId
        		}
		} else {
			if {$GPNPort3Cnt1(cnt55) < $::rateL || $GPNPort3Cnt1(cnt55) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
					$::GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt55)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
					$::GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt55)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort3Cnt2(cnt45) < $::rateL || $GPNPort3Cnt2(cnt45) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送内层tag=100外层tag=1000的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到内层tag=100外层tag=1000数据流的速率为$GPNPort3Cnt2(cnt45)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送内层tag=100外层tag=1000的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到内层tag=100外层tag=1000数据流的速率为$GPNPort3Cnt2(cnt45)，在$::rateL-$::rateR\范围内" $fileId
		}
		#DEV4 GPNTestEth4的接收检查 
		if {$GPNPort4Cnt0(cnt1) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1))" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort4Cnt0(cnt50) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE4($::gpnIp4)\
        				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt50)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE4($::gpnIp4)\
        				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt50)" $fileId
        		}
		} else {
			if {$GPNPort4Cnt1(cnt59) < $::rateL || $GPNPort4Cnt1(cnt59) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE4($::gpnIp4)\
					$::GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt59)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE4($::gpnIp4)\
					$::GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt59)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort4Cnt2(cnt15) < $::rateL || $GPNPort4Cnt2(cnt15) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送内层tag=100外层tag=1000的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到内层tag=100外层tag=1000数据流的速率为$GPNPort4Cnt2(cnt15)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送内层tag=100外层tag=1000的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到内层tag=100外层tag=1000数据流的速率为$GPNPort4Cnt2(cnt15)，在$::rateL-$::rateR\范围内" $fileId
		}
		
		if {$GPNPort4Cnt0(cnt52) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\发送untag的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt52)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\发送untag的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt52)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort4Cnt0(cnt54) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的未知单播数据流，NE4($::gpnIp4)\
        				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt54)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的未知单播数据流，NE4($::gpnIp4)\
        				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt54)" $fileId
        		}
		} else {
			if {$GPNPort4Cnt1(cnt54) < $::rateL || $GPNPort4Cnt1(cnt54) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的未知单播数据流，NE4($::gpnIp4)\
					$::GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt54)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的未知单播数据流，NE4($::gpnIp4)\
					$::GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt54)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort4Cnt2(cnt25) < $::rateL || $GPNPort4Cnt2(cnt25) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)$::GPNTestEth2\发送内层tag=100外层tag=1000的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到内层tag=100外层tag=1000数据流的速率为$GPNPort4Cnt2(cnt25)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($::gpnIp2)$::GPNTestEth2\发送内层tag=100外层tag=1000的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到内层tag=100外层tag=1000数据流的速率为$GPNPort4Cnt2(cnt25)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort4Cnt0(cnt55) !=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\发送untag的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt55)" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\发送untag的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt55)" $fileId
		}
		if {$flagElan == 1} {
        		if {$GPNPort4Cnt0(cnt56) !=0} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的未知单播数据流，NE4($::gpnIp4)\
        				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt56)" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的未知单播数据流，NE4($::gpnIp4)\
        				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt56)" $fileId
        		}
		} else {
			if {$GPNPort4Cnt1(cnt56) < $::rateL || $GPNPort4Cnt1(cnt56) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的未知单播数据流，NE4($::gpnIp4)\
					$::GPNTestEth4\收到tag=800数据流的速率为$GPNPort4Cnt1(cnt56)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的未知单播数据流，NE4($::gpnIp4)\
					$::GPNTestEth4\收到tag=800数据流的速率为$GPNPort4Cnt1(cnt56)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort4Cnt2(cnt35) < $::rateL || $GPNPort4Cnt2(cnt35) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth3\发送内层tag=100外层tag=1000的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到内层tag=100外层tag=1000数据流的速率为$GPNPort4Cnt2(cnt35)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth3\发送内层tag=100外层tag=1000的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到内层tag=100外层tag=1000数据流的速率为$GPNPort4Cnt2(cnt35)，在$::rateL-$::rateR\范围内" $fileId
		}
		return $flag
	}
	###################################################################################
	#函数功能: case7的业务验证
	#f_broadcast  =1 禁止广播转发
	#f_mcast   =1 禁止组播转发
	#f_unknow  =1 禁止未知单播转发
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
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		if {$f_broadcast == 1} {
			if {$GPNPort1Cnt1(cnt10) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt1(cnt10)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt1(cnt10)" $fileId
			}
			if {$GPNPort4Cnt1(cnt60) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt1(cnt60)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt1(cnt60)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt10) < $rateL0 || $GPNPort1Cnt1(cnt10) > $rateR0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt10)，没在$rateL0-$rateR0\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt10)，在$rateL0-$rateR0\范围内" $fileId
			}
			if {$GPNPort4Cnt1(cnt60) < $rateL0 || $GPNPort4Cnt1(cnt60) > $rateR0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt60)，没在$rateL0-$rateR0\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt60)，在$rateL0-$rateR0\范围内" $fileId
			}
		}
		if {$f_mcast == 1} {
			if {$GPNPort1Cnt1(cnt11) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt1(cnt11)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt1(cnt11)" $fileId
			}
			if {$GPNPort4Cnt1(cnt65) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt1(cnt65)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt1(cnt65)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt11) < $rateL || $GPNPort1Cnt1(cnt11) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt11)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt11)，在$rateL-$rateR\范围内" $fileId
			}
			if {$GPNPort4Cnt1(cnt65) < $rateL || $GPNPort4Cnt1(cnt65) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt65)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt65)，在$rateL-$rateR\范围内" $fileId
			}
		}
		if {$f_unknow == 1} {
			if {$GPNPort1Cnt1(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt1(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt1(cnt13)" $fileId
			}
			if {$GPNPort4Cnt1(cnt12) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt1(cnt12)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt1(cnt12)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt13) < $rateL || $GPNPort1Cnt1(cnt13) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt13)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt13)，在$rateL-$rateR\范围内" $fileId
			}
			if {$GPNPort4Cnt1(cnt12) < $rateL || $GPNPort4Cnt1(cnt12) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt12)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt12)，在$rateL-$rateR\范围内" $fileId
			}
		}
		return $flag
	}
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
	
	puts $fileId "\n=====登录被测设备3====\n"
	set telnet3 [gwd::GWpublic_loginGpn $gpnIp3 $userName3 $password3 $matchType3 $Gpn_type3 $fileId]
	
	puts $fileId "\n=====登录被测设备4====\n"
	set telnet4 [gwd::GWpublic_loginGpn $gpnIp4 $userName4 $password4 $matchType4 $Gpn_type4 $fileId]
	
	#用于导出被测设备用到的变量------
	set lSpawn_id "$telnet1 $telnet2 $telnet3 $telnet4"
	set lMatchType "$matchType1 $matchType2 $matchType3 $matchType4"
	set lDutType "$Gpn_type1 $Gpn_type2 $Gpn_type3 $Gpn_type4"
	set lIp "$gpnIp1 $gpnIp2 $gpnIp3 $gpnIp4"
	#------用于导出被测设备用到的变量
	
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
        set hGPNPortGenList "$hGPNPort1Gen $hGPNPort2Gen $hGPNPort3Gen $hGPNPort4Gen"
        set hGPNPortAnaList "$hGPNPort1Ana $hGPNPort2Ana $hGPNPort3Ana $hGPNPort4Ana"
	
	stc::config $hGPNPort1Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort2Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort3Ana -FilterOnStreamId "FALSE"
	stc::config $hGPNPort4Ana -FilterOnStreamId "FALSE"
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
        ###配置流的速率
        foreach stream "$hGPNPortStreamList $hGPNPortStreamList1 $hGPNPortStreamList2 $hGPNPortStreamList4 $hGPNPortStreamList5 $hGPNPort1Stream32 $hGPNPort1Stream33" {
        	stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        	gwd::Cfg_StreamActive $stream "FALSE"
        }
        stc::apply 
        ###获取发生器配置指针
        gwd::Get_GeneratorCfgObj $hGPNPort1Gen hGPNPort1GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort2Gen hGPNPort2GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort3Gen hGPNPort3GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort4Gen hGPNPort4GenCfg
        gwd::Get_GeneratorCfgObj $hGPNPort5Gen hGPNPort5GenCfg
        set hGPNPortGenCfgList "$hGPNPort1GenCfg $hGPNPort2GenCfg $hGPNPort3GenCfg $hGPNPort4GenCfg $hGPNPort5GenCfg"
        foreach hGenCfg $hGPNPortGenCfgList {
        	gwd::Cfg_GeneratorCfgObj $hGenCfg $GenCfg
        }
        ###创建并配置过滤器，默认过滤tag
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
          	###获取和配置capture对象相关的指针
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
	puts $fileId "===E-LAN：Vpls=tag和raw模式的业务验证、LSP PW交换功能验证基础配置开始...\n"
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
	gwd::GWpublic_print "OK" "获取设备NE1($gpnIp1)业务板卡槽位号$rebootSlotlist1" $fileId
        set rebootSlotList1 [gwd::GWpulic_getWorkCardList $portList1]
	gwd::GWpublic_print "OK" "获取设备NE1($gpnIp1)上联板卡槽位号$rebootSlotList1" $fileId
        set mslot1 [gwd::GWpulic_getWorkCardList $managePort1]
	gwd::GWpublic_print "OK" "获取设备NE1($gpnIp1)管理口所在板卡槽位号$mslot1" $fileId
	
	
	
        set portlist2 "$GPNPort6 $GPNPort7"
        set portList2 "$GPNTestEth2"
        set portList22 [concat $portlist2 $portList2]
        foreach port $portList22 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet2 $matchType2 $Gpn_type2 $fileId $port "disable" "enable"]
        	}
        }
        set rebootSlotlist2 [gwd::GWpulic_getWorkCardList $portlist2]
	gwd::GWpublic_print "OK" "获取设备NE2($gpnIp2)业务板卡槽位号$rebootSlotlist2" $fileId
        set rebootSlotList2 [gwd::GWpulic_getWorkCardList $portList2]
	gwd::GWpublic_print "OK" "获取设备NE2($gpnIp2)上联板卡槽位号$rebootSlotList2" $fileId
        
	
        set portlist3 "$GPNPort8 $GPNPort9"
        set portList3 "$GPNTestEth3"
        set portList33 [concat $portlist3 $portList3]
        foreach port $portList33 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet3 $matchType3 $Gpn_type3 $fileId $port "disable" "enable"]
        	}
        }
        set rebootSlotlist3 [gwd::GWpulic_getWorkCardList $portlist3]
	gwd::GWpublic_print "OK" "获取设备NE3($gpnIp3)业务板卡槽位号$rebootSlotlist3" $fileId
        set rebootSlotList3 [gwd::GWpulic_getWorkCardList $portList3]
	gwd::GWpublic_print "OK" "获取设备NE3($gpnIp3)上联板卡槽位号$rebootSlotList3" $fileId
	
        set portlist4 "$GPNPort10 $GPNPort11"
        set portList4 "$GPNTestEth4"
        set portList44 [concat $portlist4 $portList4]
        foreach port $portList44 {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet4 $matchType4 $Gpn_type4 $fileId $port "disable" "enable"]
        	}
        }
        set rebootSlotlist4 [gwd::GWpulic_getWorkCardList $portlist4]
	gwd::GWpublic_print "OK" "获取设备NE4($gpnIp4)业务板卡槽位号$rebootSlotlist4" $fileId
        set rebootSlotList4 [gwd::GWpulic_getWorkCardList $portList4]
	gwd::GWpublic_print "OK" "获取设备NE4($gpnIp4)上联板卡槽位号$rebootSlotList4" $fileId


        set Portlist "$GPNPort5 $GPNPort12 $GPNPort6 $GPNPort7 $GPNPort8 $GPNPort9 $GPNPort10 $GPNPort11"
        set Portlist0 "$GPNTestEth1 $GPNTestEth2 $GPNTestEth3 $GPNTestEth4"
        set Iplist "$ip612 $ip614 $ip621 $ip623 $ip632 $ip634 $ip643 $ip641"
        ###二三层接口配置参数
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
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-LAN：Vpls=tag和raw模式的业务验证、LSP PW交换功能验证的基础配置失败，测试结束" \
			"E-LAN：Vpls=tag和raw模式的业务验证、LSP PW交换功能验证的基础配置成功，继续后面的测试" "GPN_PTN_006"
	puts $fileId ""
	puts $fileId "===E-LAN：Vpls=tag和raw模式的业务验证、LSP PW交换功能验证基础配置结束..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId ""
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 EP-LAN业务功能验证-用户侧接入模式为端口模式\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsType为raw模式、用户侧接入模式为端口模式验证ELAN业务  测试开始=====\n"
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
        ###二三层接口配置参数
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
                ###配置VLANIF接口
                PTN_NNI_AddInterIp $fileId $Worklevel $interface1 $Ip1 $port1 $matchType $Gpn_type $telnet
                PTN_NNI_AddInterIp $fileId $Worklevel $interface2 $Ip2 $port2 $matchType $Gpn_type $telnet
                gwd::GWpublic_disableStorm $telnet $matchType $Gpn_type $fileId $eth "bcast"
                gwd::GWpublic_disableStorm $telnet $matchType $Gpn_type $fileId $port1 "bcast"
                gwd::GWpublic_disableStorm $telnet $matchType $Gpn_type $fileId $port2 "bcast"
                ###配置vpls
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
        ###配置pw
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls1" "peer" $address612 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls1" "peer" $address614 "4000" "4000" "" "delete" "none" 1 0 "0x8100" "0x8100" "4"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls1" "peer" $address613 "5000" "5000" "" "delete" "none" 1 0 "0x8100" "0x8100" "3"
        ###配置ac
        gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "" $GPNTestEth1 "0" "0" "none" "delete" "1" "0" "0" "0x9100" "evc2"
        
        ###配置lsp
        gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $interface4 $ip612 "100" "100" "normal" "1"
        gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21" $address621
        gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp21"
        gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $interface5 $ip632 "200" "200" "normal" "3"
        gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23" $address623
        gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp23"
        gwd::GWpublic_CfgLspTunnel $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $interface5 $ip632 "700" "700" "normal" "4"
        gwd::GWpublic_CfgLspAddress $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24" $address624
        gwd::GWpublic_CfgUndoShutLsp $telnet2 $matchType2 $Gpn_type2 $fileId "lsp24"
        ###配置LSP标签交换
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface5 $ip632 "500" "600" "0" 23 "normal"
	gwd::GWpublic_createLspSw $telnet2 $matchType2 $Gpn_type2 $fileId $Worklevel $interface4 $ip612 "600" "500" "0" 21 "normal"
        ###配置pw
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21" "vpls" "vpls2" "peer" $address621 "1000" "1000" "" "delete" "none" 1 0 "0x8100" "0x8100" "1"
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw23" "vpls" "vpls2" "peer" $address623 "2000" "2000" "" "delete" "none" 1 0 "0x8100" "0x8100" "3"
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw24" "vpls" "vpls2" "peer" $address624 "6000" "6000" "" "delete" "none" 1 0 "0x8100" "0x8100" "4"
        ###配置ac
        gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac1" "vpls2" "" $GPNTestEth2 "0" "0" "none" "delete" "1" "0" "0" "0x9100" "evc2"

        ###配置lsp
        gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $interface6 $ip623 "200" "200" "normal" "2"
        gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32" $address632
        gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp32"
        gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34" $interface7 $ip643 "300" "300" "normal" "4"
        gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34" $address634
        gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp34"
        gwd::GWpublic_CfgLspTunnel $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $interface6 $ip623 "600" "600" "normal" "1"
        gwd::GWpublic_CfgLspAddress $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31" $address631
        gwd::GWpublic_CfgUndoShutLsp $telnet3 $matchType3 $Gpn_type3 $fileId "lsp31"
        ###配置LSP标签交换
        gwd::GWpublic_createLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $interface6 $ip623 "800" "700" "0" 32 "normal"
        gwd::GWpublic_createLspSw $telnet3 $matchType3 $Gpn_type3 $fileId $Worklevel $interface7 $ip643 "700" "800" "0" 34 "normal"
        ##配置pw
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw32" "vpls" "vpls3" "peer" $address632 "2000" "2000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw34" "vpls" "vpls3" "peer" $address634 "3000" "3000" "" "delete" "none" 1 0 "0x8100" "0x8100" "4"
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31" "vpls" "vpls3" "peer" $address631 "5000" "5000" "" "delete" "none" 1 0 "0x8100" "0x8100" "1"
        ###配置ac
        gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "vpls3" "" $GPNTestEth3 "0" "0" "none" "delete" "1" "0" "0" "0x9100" "evc2"

        ###配置lsp
        gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $interface9 $ip614 "400" "400" "normal" "1"
        gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41" $address641
        gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp41"
        gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43" $interface8 $ip634 "300" "300" "normal" "3"
        gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43" $address643
        gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp43"
        gwd::GWpublic_CfgLspTunnel $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42" $interface8 $ip634 "800" "800" "normal" "2"
        gwd::GWpublic_CfgLspAddress $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42" $address642
        gwd::GWpublic_CfgUndoShutLsp $telnet4 $matchType4 $Gpn_type4 $fileId "lsp42"
        ###配置pw
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41" "vpls" "vpls4" "peer" $address641 "4000" "4000" "" "delete" "none" 1 0 "0x8100" "0x8100" "1"
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw43" "vpls" "vpls4" "peer" $address643 "3000" "3000" "" "delete" "none" 1 0 "0x8100" "0x8100" "3"
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw42" "vpls" "vpls4" "peer" $address642 "6000" "6000" "" "delete" "none" 1 0 "0x8100" "0x8100" "2"
        ###配置ac
	gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac1" "vpls4" "" $GPNTestEth4 "0" "0" "none" "delete" "1" "0" "0" "0x9100" "evc2"
        #####===NE1发送unatg未知单播和tag=500的已知单播，unatg的广播,组播数据流===######
        #####===NE2发送tag=500已知单播===######
        #####===NE3发送tag=500已知单播===######
        #####===NE4发送tag=500的已知单播，tag=800的广播,组播数据流===######
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
		gwd::GWpublic_print "NOK" "FA1（结论）vplsType为raw模式、用户侧接入模式为端口模式验证ELAN业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1（结论）vplsType为raw模式、用户侧接入模式为端口模式验证ELAN业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vplsType为raw模式、用户侧接入模式为端口模式验证ELAN业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)使能PW12控制字，镜像NE1到NE2和NE4的NNI出口方向报文测试MPLS标签  测试开始=====\n"
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
        ####使能pw控制字，镜像NNI口抓包分析
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
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)和NE2($gpnIp2)互相发送tag=500的已知单播数据流，NE1($gpnIp1)$GPNTestEth5口镜像NNI口$GPNPort5\
			收到的mpls报文的lsp标签=100、pw标签=1000的数据流速率为$GPNPort5Cnt2(cnt7)，没在$::rateL1-$::rateR1\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)和NE2($gpnIp2)互相发送tag=500的已知单播数据流，NE1($gpnIp1)$GPNTestEth5口镜像NNI口$GPNPort5\
			收到的mpls报文的lsp标签=100、pw标签=1000的数据流速率为$GPNPort5Cnt2(cnt7)，在$::rateL1-$::rateR1\范围内" $fileId
	}
	if {$GPNPort5Cnt2(cnt8) < $rateL1 || $GPNPort5Cnt2(cnt8) > $rateR1} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)和NE3($gpnIp3)互相发送tag=500的已知单播数据流，NE1($gpnIp1)$GPNTestEth5口镜像NNI口$GPNPort5\
			收到的mpls报文的lsp标签=500、pw标签=5000的数据流速率为$GPNPort5Cnt2(cnt8)，没在$rateL1-$rateR1\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)和NE3($gpnIp3)互相发送tag=500的已知单播数据流，NE1($gpnIp1)$GPNTestEth5口镜像NNI口$GPNPort5\
			收到的mpls报文的lsp标签=500、pw标签=5000的数据流速率为$GPNPort5Cnt2(cnt8)，在$rateL1-$rateR1\范围内" $fileId
	}
	if {$GPNPort5Cnt20(cnt9) < $rateL1 || $GPNPort5Cnt20(cnt9) > $rateR1} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)和NE4($gpnIp4)互相发送tag=500的已知单播数据流，NE1($gpnIp1)$GPNTestEth5口镜像NNI口$GPNPort12\
			收到的mpls报文的lsp标签=400、pw标签=4000的数据流速率为$GPNPort5Cnt20(cnt9)，没在$rateL1-$rateR1\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)和NE4($gpnIp4)互相发送tag=500的已知单播数据流，NE1($gpnIp1)$GPNTestEth5口镜像NNI口$GPNPort12\
			收到的mpls报文的lsp标签=400、pw标签=4000的数据流速率为$GPNPort5Cnt20(cnt9)，在$rateL1-$rateR1\范围内" $fileId
	}
        gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2（结论）镜像NE1($gpnIp1)到NE2($gpnIp2)、NE4($gpnIp4)的NNI出口方向报文测试MPLS标签" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2（结论）镜像NE1($gpnIp1)到NE2($gpnIp2)、NE4($gpnIp4)的NNI出口方向报文测试MPLS标签" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)使能PW12控制字，镜像NE1($gpnIp1)到NE2($gpnIp2)、NE4($gpnIp4)的NNI出口方向报文测试MPLS标签  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)使能lsp、pw、ac的性能统计，测试性能统计的准确性  测试开始=====\n"
        foreach stream3 $hGPNPortStreamList3 {
        	gwd::Cfg_StreamActive $stream3 "FALSE"
        }
        ####使能设备lsp、pw、ac的性能统计，验证
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
	 	gwd::GWpublic_print "NOK" "FA3（结论）NE1($gpnIp1)使能lsp、pw、ac的性能统计，测试性能统计的准确性" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3（结论）NE1($gpnIp1)使能lsp、pw、ac的性能统计，测试性能统计的准确性" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)使能lsp、pw、ac的性能统计，测试性能统计的准确性  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复shut undoshut NNI口后，测试业务恢复和系统内存  测试开始=====\n" 
        ##去使能设备lsp、pw、ac的性能统计
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
	##反复undo shutdown/shutdown端口
	foreach eth $portlist1 {
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
        		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
        		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
          		after $WaiteTime
			incr capId
        		if {[PTN_EPRepeatFunc $fileId 0 "第$j\次shutdown/undo shutdown NE1($gpnIp1)的$eth\端口后" "GPN_PTN_006_$capId"]} {
        			set  flag4_case1 1
        		}
        	}
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
        	send_log "\n resource1:$resource1"
        	send_log "\n resource2:$resource2"
        	if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
        		set flag4_case1 1
        		gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
        	}
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA4（结论）NE1($gpnIp1)反复shut undoshut NNI口后，测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4（结论）NE1($gpnIp1)反复shut undoshut NNI口后，测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复shut undoshut NNI口后，测试业务恢复和系统内存  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存  测试开始=====\n" 
        ###反复重启NNI口所在板卡
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
        			if {[PTN_EPRepeatFunc $fileId 0 "第$j\次重启NE1($gpnIp1)$slot\槽位板卡" "GPN_PTN_006_$capId"]} {
        				set  flag5_case1 1
        			}
        		} else {
                		set testFlag 1
                		gwd::GWpublic_print "OK" " NE1($gpnIp1)$slot\槽位板卡不支持板卡重启操作，测试跳过" $fileId
                		break
        		}
        	}
        	if {$testFlag == 0} {
        		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource4
        		send_log "\n resource3:$resource3"
        		send_log "\n resource4:$resource4"
        		if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
        			set flag5_case1 1
        			gwd::GWpublic_print "NOK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
        		}
        	}
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA5（结论）NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5（结论）NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存，测试业务恢复和系统内存  测试开始=====\n" 
	set expectTable "0000.0000.0006 ac1 0000.0000.0005 ac1 0000.0000.0004 ac1 0000.0000.0003 ac1 0000.0000.0002 ac1 0000.0000.0001 ac1\
			0000.0000.0044 pw14 0000.0000.000A pw14 0000.0000.000B pw14 0000.0000.0022 pw12 0000.0000.0033 pw13"
	###反复进行NMS主备倒换
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
        for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
        		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_EPRepeatFunc $fileId 0 "第$j\次 NE1($gpnIp1)进行NMS主备倒换" "GPN_PTN_006_$capId"]} {
				set  flag6_case1 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行NMS主备倒换后" $dTable $expectTable]} {
				set flag6_case1 1
			}
        	} else {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
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
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
		}
	}
        puts $fileId ""
        if {$flag6_case1 == 1} {
        	set flagCase1 1
        	 gwd::GWpublic_print "NOK" "FA6（结论）NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FA6（结论）NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存，测试业务恢复和系统内存  测试开始=====\n" 
        ##反复进行SW主备倒换
	set testFlag 0 ;#=1 测试跳过
        gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
        for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
        		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_EPRepeatFunc $fileId 0 "第$j\次 NE1($gpnIp1)进行SW主备倒换" "GPN_PTN_006_$capId"]} {
				set  flag7_case1 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行SW主备倒换后" $dTable $expectTable]} {
				set flag7_case1 1
			}
        	} else {
			gwd::GWpublic_print "OK" "$matchType1\只有一个交换盘，测试跳过" $fileId
			set testFlag 1 ;#=1 测试跳过
			break
        	}
        }
	if {$testFlag == 0} {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource8
		send_log "\n resource7:$resource7"
		send_log "\n resource8:$resource8"
		if {$resource8 > [expr $resource7 + $resource7 * $errRate]} {
			set flag7_case1	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag7_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA7（结论）NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7（结论）NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存，测试业务恢复和系统内存  测试开始=====\n" 
        ##反复保存设备重启
        gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
        for {set j 1} {$j<=$cnt} {incr j} {
        	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
        	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
        	after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[PTN_EPRepeatFunc $fileId 0 "第$j\次 NE1($gpnIp1)进行保存设备重启后" "GPN_PTN_006_$capId"]} {
			set  flag8_case1 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
		if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行保存设备重启后" $dTable $expectTable]} {
			set flag8_case1 1
		}
        }
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag8_case1	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag8_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA8（结论）NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8（结论）NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存，测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase1 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 1测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 1测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 1 EP-LAN业务功能验证-用户侧接入模式为端口模式测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 ELAN业务功能验证：vpls为raw模式、用户侧接入模式为”端口+运营商VLAN”\n"
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0

	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除所有设备上的专网业务AC，测试业务是否中断  测试开始=====\n"
	
        ##删除ac
        foreach telnet $lSpawn_id Gpn_type $lDutType matchType $lMatchType {
        	gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac1"
        }
        ####=======验证数据流转发===========####
	incr capId
	if {[PTN_EPRepeatFunc $fileId 1 "删除所有设备上的专网业务AC后" "GPN_PTN_006_$capId"]} {
		set  flag1_case2 1
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA9（结论）删除所有设备上的专网业务AC，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9（结论）删除所有设备上的专网业务AC，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除所有设备上的专网业务AC，测试业务是否中断  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlps为raw模式、接入模式改为“端口+运营商VLAN”模式，验证业务转发  测试开始=====\n" 
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
                ##用户侧加入vlan
                PTN_UNI_AddInter $telnet $matchType $Gpn_type $fileId $Worklevel "800" $eth
                PTN_UNI_AddInter $telnet $matchType $Gpn_type $fileId $Worklevel "500" $eth
                #配置ac
                gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac800" "vpls$id2" "" $eth "800" "0" "none" "modify" "800" "0" "0" "0x8100" "evc2"
                incr id2
        }
	incr capId
	SendAndStat_ptn006 1 "$hGPNPort1Gen $hGPNPort4Gen" $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
			$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
			$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_006_$capId"
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#DEV1 GPNTestEth1的接收检查 
	if {$GPNPort1Cnt1(cnt44) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的未知单播数据流，NE1($::gpnIp1)\
			$::GPNTestEth1\收到tag=500的数据流的速率应为0实为$GPNPort1Cnt1(cnt44)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的未知单播数据流，NE1($::gpnIp1)\
			$::GPNTestEth1\收到tag=500的数据流的速率应为0实为$GPNPort1Cnt1(cnt44)" $fileId
	}
	if {$GPNPort1Cnt1(cnt13) < $rateL || $GPNPort1Cnt1(cnt13) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE1($::gpnIp1)\
			$::GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt13)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE1($::gpnIp1)\
			$::GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt13)，在$::rateL-$::rateR\范围内" $fileId
	}
	#DEV2 GPNTestEth2的接收检查 
	if {$GPNPort2Cnt1(cnt44) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=500的数据流的速率应为0实为$GPNPort2Cnt1(cnt44)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=500的数据流的速率应为0实为$GPNPort2Cnt1(cnt44)" $fileId
	}
	if {$GPNPort2Cnt1(cnt13) < $rateL || $GPNPort2Cnt1(cnt13) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt13)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt13)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt1(cnt2) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=500的数据流的速率应为0实为$GPNPort2Cnt1(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=500的数据流的速率应为0实为$GPNPort2Cnt1(cnt2)" $fileId
	}
	if {$GPNPort2Cnt1(cnt12) < $rateL || $GPNPort2Cnt1(cnt12) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt12)，在$::rateL-$::rateR\范围内" $fileId
	}
	#DEV3 GPNTestEth3的接收检查 
	if {$GPNPort3Cnt1(cnt44) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=500的数据流的速率应为0实为$GPNPort3Cnt1(cnt44)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=500的数据流的速率应为0实为$GPNPort3Cnt1(cnt44)" $fileId
	}
	if {$GPNPort3Cnt1(cnt13) < $rateL || $GPNPort3Cnt1(cnt13) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt13)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt13)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt1(cnt2) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=500的数据流的速率应为0实为$GPNPort3Cnt1(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=500的数据流的速率应为0实为$GPNPort3Cnt1(cnt2)" $fileId
	}
	if {$GPNPort3Cnt1(cnt12) < $rateL || $GPNPort3Cnt1(cnt12) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt12)，在$::rateL-$::rateR\范围内" $fileId
	}
	#DEV4 GPNTestEth4的接收检查 
	if {$GPNPort4Cnt1(cnt2) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE4($::gpnIp4)\
			$::GPNTestEth4\收到tag=500的数据流的速率应为0实为$GPNPort4Cnt1(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE4($::gpnIp4)\
			$::GPNTestEth4\收到tag=500的数据流的速率应为0实为$GPNPort4Cnt1(cnt2)" $fileId
	}
	if {$GPNPort4Cnt1(cnt12) < $rateL || $GPNPort4Cnt1(cnt12) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的未知单播数据流，NE4($::gpnIp4)\
			$::GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的未知单播数据流，NE4($::gpnIp4)\
			$::GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt12)，在$::rateL-$::rateR\范围内" $fileId
	}
	puts $fileId ""
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB1（结论）vlps为raw模式、接入模式改为“端口+运营商VLAN”模式，验证业务转发" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1（结论）vlps为raw模式、接入模式改为“端口+运营商VLAN”模式，验证业务转发" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlps为raw模式、接入模式改为“端口+运营商VLAN”模式，验证业务转发  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlps为raw模式、接入模式改为“端口+运营商VLAN”模式，未使能overlay功能时业务测试  测试开始=====\n"
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#DEV1 GPNTestEth1的接收检查 
	if {$GPNPort1Cnt1(cnt62) < $rateL || $GPNPort1Cnt1(cnt62) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "flag3_case2未使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=800的mpls数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt62)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=800的mpls数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt62)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt1(cnt63) < $rateL || $GPNPort1Cnt1(cnt63) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE3($gpnIp3)$GPNTestEth3\发送tag=800的mpls数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt63)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE3($gpnIp3)$GPNTestEth3\发送tag=800的mpls数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt63)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt1(cnt64) < $rateL || $GPNPort1Cnt1(cnt64) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=800的mpls数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt64)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=800的mpls数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt64)，在$rateL-$rateR\范围内" $fileId
	}
	#DEV2 GPNTestEth2的接收检查 
	if {$GPNPort2Cnt1(cnt61) < $rateL || $GPNPort2Cnt1(cnt61) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=800的mpls数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt61)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=800的mpls数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt61)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt1(cnt63) < $rateL || $GPNPort2Cnt1(cnt63) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE3($gpnIp3)$GPNTestEth3\发送tag=800的mpls数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt63)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE3($gpnIp3)$GPNTestEth3\发送tag=800的mpls数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt63)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt1(cnt64) < $rateL || $GPNPort2Cnt1(cnt64) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=800的mpls数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt64)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=800的mpls数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt64)，在$rateL-$rateR\范围内" $fileId
	}
	#DEV3 GPNTestEth3的接收检查 
	if {$GPNPort3Cnt1(cnt61) < $rateL || $GPNPort3Cnt1(cnt61) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=800的mpls数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt61)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=800的mpls数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt61)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt1(cnt62) < $rateL || $GPNPort3Cnt1(cnt62) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=800的mpls数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt62)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=800的mpls数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt62)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt1(cnt64) < $rateL || $GPNPort3Cnt1(cnt64) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=800的mpls数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt64)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=800的mpls数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt64)，在$rateL-$rateR\范围内" $fileId
	}	
	#DEV4 GPNTestEth4的接收检查 
	if {$GPNPort4Cnt1(cnt61) < $rateL || $GPNPort4Cnt1(cnt61) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=800的mpls数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt61)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=800的mpls数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt61)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt1(cnt62) < $rateL || $GPNPort4Cnt1(cnt62) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=800的mpls数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt62)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=800的mpls数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt62)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt1(cnt63) < $rateL || $GPNPort4Cnt1(cnt63) > $rateR} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE3($gpnIp3)$GPNTestEth3\发送tag=800的mpls数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt63)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE3($gpnIp3)$GPNTestEth3\发送tag=800的mpls数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt63)，在$rateL-$rateR\范围内" $fileId
	}
	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB2（结论）vlps为raw模式、接入模式改为“端口+运营商VLAN”模式，未使能overlay功能时业务测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2（结论）vlps为raw模式、接入模式改为“端口+运营商VLAN”模式，未使能overlay功能时业务测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlps为raw模式、接入模式为“端口+运营商VLAN”模式，未使能overlay功能时业务测试  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlps为raw模式、接入模式为“端口+运营商VLAN”模式，使能overlay功能时业务测试  测试开始=====\n"
        gwd::GWpublic_addOverLay $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth1 "enable"
        gwd::GWpublic_addOverLay $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "enable"
        gwd::GWpublic_addOverLay $telnet3 $matchType3 $Gpn_type3 $fileId $GPNTestEth3 "enable"
        gwd::GWpublic_addOverLay $telnet4 $matchType4 $Gpn_type4 $fileId $GPNTestEth4 "enable"
	incr capId
	SendAndStat_ptn006 1 $hGPNPortGenList $hGPNPortAnaList $Portlist0 "$hGPNPort1Cap $hGPNPort1CapAnalyzer $gpnIp1 \
		$hGPNPort2Cap $hGPNPort2CapAnalyzer $gpnIp2 $hGPNPort3Cap $hGPNPort3CapAnalyzer $gpnIp3 $hGPNPort4Cap $hGPNPort4CapAnalyzer $gpnIp4" \
		$hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $anaFliFrameCfg1 "GPN_PTN_006_$capId"
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
        #DEV1 GPNTestEth1的接收检查 
        if {$GPNPort1Cnt1(cnt62) < $rateL || $GPNPort1Cnt1(cnt62) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=800的mpls数据流，NE1($gpnIp1)\
        		$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt62)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=800的mpls数据流，NE1($gpnIp1)\
        		$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt62)，在$rateL-$rateR\范围内" $fileId
        }
        if {$GPNPort1Cnt1(cnt63) < $rateL || $GPNPort1Cnt1(cnt63) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE3($gpnIp3)$GPNTestEth3\发送tag=800的mpls数据流，NE1($gpnIp1)\
        		$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt63)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE3($gpnIp3)$GPNTestEth3\发送tag=800的mpls数据流，NE1($gpnIp1)\
        		$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt63)，在$rateL-$rateR\范围内" $fileId
        }
        if {$GPNPort1Cnt1(cnt64) < $rateL || $GPNPort1Cnt1(cnt64) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=800的mpls数据流，NE1($gpnIp1)\
        		$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt64)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=800的mpls数据流，NE1($gpnIp1)\
        		$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt64)，在$rateL-$rateR\范围内" $fileId
        }
        #DEV2 GPNTestEth2的接收检查 
        if {$GPNPort2Cnt1(cnt61) < $rateL || $GPNPort2Cnt1(cnt61) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=800的mpls数据流，NE2($gpnIp2)\
        		$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt61)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=800的mpls数据流，NE2($gpnIp2)\
        		$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt61)，在$rateL-$rateR\范围内" $fileId
        }
        if {$GPNPort2Cnt1(cnt63) < $rateL || $GPNPort2Cnt1(cnt63) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE3($gpnIp3)$GPNTestEth3\发送tag=800的mpls数据流，NE2($gpnIp2)\
        		$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt63)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE3($gpnIp3)$GPNTestEth3\发送tag=800的mpls数据流，NE2($gpnIp2)\
        		$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt63)，在$rateL-$rateR\范围内" $fileId
        }
        if {$GPNPort2Cnt1(cnt64) < $rateL || $GPNPort2Cnt1(cnt64) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=800的mpls数据流，NE2($gpnIp2)\
        		$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt64)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=800的mpls数据流，NE2($gpnIp2)\
        		$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt64)，在$rateL-$rateR\范围内" $fileId
        }
        #DEV3 GPNTestEth3的接收检查 
        if {$GPNPort3Cnt1(cnt61) < $rateL || $GPNPort3Cnt1(cnt61) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=800的mpls数据流，NE3($gpnIp3)\
        		$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt61)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=800的mpls数据流，NE3($gpnIp3)\
        		$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt61)，在$rateL-$rateR\范围内" $fileId
        }
        if {$GPNPort3Cnt1(cnt62) < $rateL || $GPNPort3Cnt1(cnt62) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=800的mpls数据流，NE3($gpnIp3)\
        		$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt62)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=800的mpls数据流，NE3($gpnIp3)\
        		$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt62)，在$rateL-$rateR\范围内" $fileId
        }
        if {$GPNPort3Cnt1(cnt64) < $rateL || $GPNPort3Cnt1(cnt64) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=800的mpls数据流，NE3($gpnIp3)\
        		$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt64)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=800的mpls数据流，NE3($gpnIp3)\
        		$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt64)，在$rateL-$rateR\范围内" $fileId
        }	
        #DEV4 GPNTestEth4的接收检查 
        if {$GPNPort4Cnt1(cnt61) < $rateL || $GPNPort4Cnt1(cnt61) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=800的mpls数据流，NE4($gpnIp4)\
        		$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt61)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=800的mpls数据流，NE4($gpnIp4)\
        		$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt61)，在$rateL-$rateR\范围内" $fileId
        }
        if {$GPNPort4Cnt1(cnt62) < $rateL || $GPNPort4Cnt1(cnt62) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=800的mpls数据流，NE4($gpnIp4)\
        		$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt62)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=800的mpls数据流，NE4($gpnIp4)\
        		$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt62)，在$rateL-$rateR\范围内" $fileId
        }
        if {$GPNPort4Cnt1(cnt63) < $rateL || $GPNPort4Cnt1(cnt63) > $rateR} {
        	set flag4_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE3($gpnIp3)$GPNTestEth3\发送tag=800的mpls数据流，NE4($gpnIp4)\
        		$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt63)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE3($gpnIp3)$GPNTestEth3\发送tag=800的mpls数据流，NE4($gpnIp4)\
        		$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt63)，在$rateL-$rateR\范围内" $fileId
        }
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB3（结论）vlps为raw模式、接入模式改为“端口+运营商VLAN”模式，使能overlay功能时业务测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3（结论）vlps为raw模式、接入模式改为“端口+运营商VLAN”模式，使能overlay功能时业务测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlps为raw模式、接入模式为“端口+运营商VLAN”模式，使能overlay功能时业务测试  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
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
	puts $fileId "Test Case 2 ELAN业务功能验证：vpls为raw模式、用户侧接入模式为”端口+运营商VLAN  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 ELAN业务功能验证：vpls为raw模式、用户侧接入模式为”端口和端口+运营商VLAN两种模式，验证业务”\n"
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
	gwd::Cfg_StreamActive $hGPNPort1Stream1 "true"  ;#untag未知单播
	gwd::Cfg_StreamActive $hGPNPort1Stream22 "true"  ;#tag=500未知单播
	gwd::Cfg_StreamActive $hGPNPort1Stream12 "true" ;#tag=800未知单播
	gwd::Cfg_StreamActive $hGPNPort4Stream16 "true" ;#untag未知单播
	gwd::Cfg_StreamActive $hGPNPort4Stream23 "true"  ;#tag=500未知单播
	gwd::Cfg_StreamActive $hGPNPort4Stream13 "true" ;#tag=800未知单播
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_006_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE1发送untag、tag=500、tag=800的未知单播  ；NE4发送untag、tag=500、tag=800的未知单播  
	#DEV1 GPNTestEth1的接收检查 
	if {$GPNPort1Cnt0(cnt01) !=0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送untag的未知单播数据流，NE1($::gpnIp1)\
			$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt01)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送untag的未知单播数据流，NE1($::gpnIp1)\
			$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt01)" $fileId
	}
	if {$GPNPort1Cnt0(cnt51) !=0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的未知单播数据流，NE1($::gpnIp1)\
			$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt51)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的未知单播数据流，NE1($::gpnIp1)\
			$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt51)" $fileId
	}
	if {$GPNPort1Cnt7(cnt48) < $rateL || $GPNPort1Cnt7(cnt48) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE1($::gpnIp1)\
			$::GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt48)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE1($::gpnIp1)\
			$::GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt48)，在$::rateL-$::rateR\范围内" $fileId
	}
	
	#DEV2 GPNTestEth2的接收检查 
	if {$GPNPort2Cnt0(cnt01) !=0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送untag的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt01)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送untag的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt01)" $fileId
	}
	if {$GPNPort2Cnt0(cnt51) !=0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt1(cnt51)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt1(cnt51)" $fileId
	}
	if {$GPNPort2Cnt1(cnt13) < $rateL || $GPNPort2Cnt1(cnt13) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt13)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt13)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt1(cnt81) < $rateL || $GPNPort2Cnt1(cnt81) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt81)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt81)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt2(cnt12) < $rateL || $GPNPort2Cnt2(cnt12) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到内层tag=500 外层tag=800的数据流的速率为$GPNPort2Cnt2(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到内层tag=500 外层tag=800的数据流的速率为$GPNPort2Cnt2(cnt12)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt2(cnt14) < $rateL || $GPNPort2Cnt2(cnt14) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到内层tag=800 外层tag=800的数据流的速率为$GPNPort2Cnt2(cnt14)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到内层tag=800 外层tag=800的数据流的速率为$GPNPort2Cnt2(cnt14)，在$::rateL-$::rateR\范围内" $fileId
	}
	#DEV3 GPNTestEth3的接收检查
	if {$GPNPort3Cnt0(cnt01) !=0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送untag的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt01)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送untag的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt01)" $fileId
	}
	if {$GPNPort3Cnt0(cnt51) !=0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt1(cnt44)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt1(cnt44)" $fileId
	}
	if {$GPNPort3Cnt1(cnt13) < $rateL || $GPNPort3Cnt1(cnt13) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt13)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt13)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt1(cnt81) < $rateL || $GPNPort3Cnt1(cnt81) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt81)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt81)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt2(cnt12) < $rateL || $GPNPort3Cnt2(cnt12) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到内层tag=500 外层tag=800的数据流的速率为$GPNPort3Cnt2(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到内层tag=500 外层tag=800的数据流的速率为$GPNPort3Cnt2(cnt12)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt2(cnt14) < $rateL || $GPNPort3Cnt2(cnt14) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到内层tag=800 外层tag=800的数据流的速率为$GPNPort3Cnt2(cnt14)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到内层tag=800 外层tag=800的数据流的速率为$GPNPort3Cnt2(cnt14)，在$::rateL-$::rateR\范围内" $fileId
	}
	#DEV4 GPNTestEth4的接收检查 
	if {$GPNPort4Cnt1(cnt81) < $rateL || $GPNPort4Cnt1(cnt81) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE4($::gpnIp4)\
			$::GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt81)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE4($::gpnIp4)\
			$::GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt81)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt2(cnt12) < $rateL || $GPNPort4Cnt2(cnt12) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE4($::gpnIp4)\
			$::GPNTestEth4\收到内层tag=500 外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的未知单播数据流，NE4($::gpnIp4)\
			$::GPNTestEth4\收到内层tag=500 外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt12)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt2(cnt14) < $rateL || $GPNPort4Cnt2(cnt14) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的未知单播数据流，NE4($::gpnIp4)\
			$::GPNTestEth4\收到内层tag=800 外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt14)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth1\发送tag=800的未知单播数据流，NE4($::gpnIp4)\
			$::GPNTestEth4\收到内层tag=800 外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt14)，在$::rateL-$::rateR\范围内" $fileId
	}
	puts $fileId ""
	if {$flag1_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB4（结论）vpls为raw模式、用户侧接入模式为”端口和端口+运营商VLAN两种模式，验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4（结论）vpls为raw模式、用户侧接入模式为”端口和端口+运营商VLAN两种模式，验证业务" $fileId
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
		gwd::GWpublic_print "NOK" "TestCase 3测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 3测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 3 ELAN业务功能验证：vpls为raw模式、用户侧接入模式为”端口和端口+运营商VLAN两种模式，验证业务  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 ELAN业务功能验证：vpls为tag模式验证业务”\n"
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set flag5_case4 0
	set flag6_case4 0
	set flag7_case4 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlps为tag模式、接入模式为“端口和端口+运营商VLAN”两种模式，验证业务  测试开始=====\n"
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

        ########========vpls为tagged测试==========#########
        set vplstype "tagged"
        ##配置vpls
        gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls11" "11" "elan" "flood" "false" "false" "false" "true" "2000" "" "tagged"
        ###配置pw
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw120" "vpls" "vpls11" "peer" $address612 "101" "101" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw140" "vpls" "vpls11" "peer" $address614 "401" "401" "" "add" "none" 1 0 "0x8100" "0x8100" "4"
        gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw130" "vpls" "vpls11" "peer" $address613 "51" "51" "" "add" "none" 1 0 "0x8100" "0x8100" "3"
        ###配置ac
        gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls11" "" $GPNTestEth1 "0" "0" "none" "delete" "1" "0" "0" "0x8100" "evc2"
        
        ##配置vpls
        gwd::GWVpls_AddInfo $telnet2 $matchType2 $Gpn_type2 $fileId "vpls12" "12" "elan" "flood" "false" "false" "false" "true" "2000" "" "tagged"
        ###配置pw
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw210" "vpls" "vpls12" "peer" $address621 "101" "101" "" "add" "none" 1 0 "0x8100" "0x8100" "1"
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw230" "vpls" "vpls12" "peer" $address623 "201" "201" "" "add" "none" 1 0 "0x8100" "0x8100" "3"
        gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw240" "vpls" "vpls12" "peer" $address624 "61" "61" "" "add" "none" 1 0 "0x8100" "0x8100" "4"
        ###配置ac
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanCheck $telnet2 $matchType2 $Gpn_type2 $fileId $GPNTestEth2 "disable"
	}
        gwd::GWAc_AddVplsInfo $telnet2 $matchType2 $Gpn_type2 $fileId "ac1" "vpls12" "" $GPNTestEth2 "0" "0" "none" "delete" "1" "0" "0" "0x8100" "evc2"
        
        ##配置vpls
        gwd::GWVpls_AddInfo $telnet3 $matchType3 $Gpn_type3 $fileId "vpls13" "13" "elan" "flood" "false" "false" "false" "true" "2000" "" "tagged"
        ##配置pw
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw320" "vpls" "vpls13" "peer" $address632 "201" "201" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw340" "vpls" "vpls13" "peer" $address634 "301" "301" "" "add" "none" 1 0 "0x8100" "0x8100" "4"
        gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw310" "vpls" "vpls13" "peer" $address631 "51" "51" "" "add" "none" 1 0 "0x8100" "0x8100" "1"
        ###配置ac
        gwd::GWAc_AddVplsInfo $telnet3 $matchType3 $Gpn_type3 $fileId "ac1" "vpls13" "" $GPNTestEth3 "500" "0" "none" "modify" "500" "0" "0" "0x8100" "evc2"
        
        ##配置vpls
        gwd::GWVpls_AddInfo $telnet4 $matchType4 $Gpn_type4 $fileId "vpls14" "14" "elan" "flood" "false" "false" "false" "true" "2000" "" "tagged"
        ###配置pw
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw410" "vpls" "vpls14" "peer" $address641 "401" "401" "" "add" "none" 1 0 "0x8100" "0x8100" "1"
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw430" "vpls" "vpls14" "peer" $address643 "301" "301" "" "add" "none" 1 0 "0x8100" "0x8100" "3"
        gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw420" "vpls" "vpls14" "peer" $address642 "61" "61" "" "add" "none" 1 0 "0x8100" "0x8100" "2"
        gwd::GWAc_AddVplsInfo $telnet4 $matchType4 $Gpn_type4 $fileId "ac1" "vpls14" "" $GPNTestEth4 "800" "0" "none" "modify" "800" "0" "0" "0x8100" "evc2"

	stc::perform streamBlockActivate -streamBlockList "$hGPNPort1Stream1 $hGPNPort1Stream22 $hGPNPort1Stream12 \
			$hGPNPort4Stream16 $hGPNPort4Stream23 $hGPNPort4Stream13" -activate "false"
	stc::perform streamBlockActivate -streamBlockList $hGPNPortStreamList5 -activate "true"
	#NE1 NE2 NE3 NE4发送untag、tag=500、tag=800的未知单播
	incr capId
	if {[TestVplsTag $fileId "" $rateL2 $rateR2 "GPN_PTN_006_$capId"]} {
		set flag1_case4 1
	}
	puts $fileId ""
	if {$flag1_case4 == 1} {
		set flagCase4 1
	 	gwd::GWpublic_print "NOK" "FB5（结论）vlps为tag模式、接入模式为“端口和端口+运营商VLAN”两种模式，验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5（结论）vlps为tag模式、接入模式为“端口和端口+运营商VLAN”两种模式，验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vlps为tag模式、接入模式为“端口和端口+运营商VLAN”两种模式，验证业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复shut undoshut NNI口后，测试业务恢复和系统内存  测试开始=====\n"
	##反复undo shutdown/shutdown端口
	foreach eth $portlist1 {
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
        	for {set j 1} {$j<=$cnt} {incr j} {
        		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
        		gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
          		after $WaiteTime
			incr capId
			if {[TestVplsTag $fileId "第$j\次undo shutdown/shutdown NE1($gpnIp1)的$eth\端口" $rateL2 $rateR2 "GPN_PTN_006_$capId"]} {
				set flag2_case4 1
			}
        	}
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag2_case4	1
			gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag2_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FB6（结论）NE1($gpnIp1)反复shut undoshut NNI口后，测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6（结论）NE1($gpnIp1)反复shut undoshut NNI口后，测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复shut undoshut NNI口后，测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存  测试开始=====\n" 
	###反复重启NNI口所在板卡
	foreach slot $rebootSlotlist1 {
		set testFlag 0 ;#=1 板卡不支持重启操作，测试跳过 
        	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource3
          	for {set j 1} {$j<=$cnt} {incr j} {
			if {![gwd::GWCard_AddReboot $telnet1 $matchType1 $Gpn_type1 $fileId $slot]} {
          			after $rebootBoardTime
          			if {[string match $mslot1 $slot]} {
        				set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
					set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
            			}
				incr capId
				if {[TestVplsTag $fileId "第$j\次重启NE1($gpnIp1)$slot\槽位板卡后" $rateL2 $rateR2 "GPN_PTN_006_$capId"]} {
					set flag3_case4 1
				}
			} else {
                		gwd::GWpublic_print "OK" $fileId "$matchType1\不支持$slot\槽位板卡重启操作，测试跳过" $fileId
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
				gwd::GWpublic_print "NOK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
			} else {
				gwd::GWpublic_print "OK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
			} 
		}     
	}
	puts $fileId ""
	if {$flag3_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FB7（结论）NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7（结论）NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行NMS主备倒换后，测试业务恢复和系统内存  测试开始=====\n"
	set expectTable "0000.0000.0001 ac1 0000.0000.0105 ac1 0000.0000.000C ac1 0000.0000.0200 pw120 0000.0000.0205 pw120 0000.0000.0208 pw120\
			0000.0000.0305 pw130 0000.0000.000D pw140"
	##反复进行NMS主备倒换
	set testFlag 0 ;#=1 测试跳过
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
        		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestVplsTag $fileId "第$j\次NE1($gpnIp1)进行NMS主备倒换后" $rateL2 $rateR2 "GPN_PTN_006_$capId"]} {
				set flag4_case4 1
			} 
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls11" dTable
			if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行NMS主备倒换后" $dTable $expectTable]} {
				set flag4_case4 1
			}
        	} else {
			gwd::GWpublic_print "OK" "$matchType1\只有一个主控盘，测试跳过" $fileId
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
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag4_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FB8（结论）NE1($gpnIp1)反复进行NMS主备倒换后，测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8（结论）NE1($gpnIp1)反复进行NMS主备倒换后，测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行NMS主备倒换后，测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行SW主备倒换后，测试业务恢复和系统内存  测试开始=====\n"
	###反复进行SW主备倒换
	set testFlag 0 ;#=1 测试跳过
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
        	if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
          		after $rebootTime
        		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
        		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
        		if {[TestVplsTag $fileId "第$j\次NE1($gpnIp1)进行SW主备倒换后" $rateL2 $rateR2 "GPN_PTN_006_$capId"]} {
        			set flag5_case4 1
        		} 
        		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls11" dTable
        		if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行SW主备倒换后" $dTable $expectTable]} {
        			set flag5_case4 1
        		}
        	} else {
        		gwd::GWpublic_print "OK" "$matchType1\只有一个SW，测试跳过" $fileId
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
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag5_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FB9（结论）NE1($gpnIp1)反复进行SW主备倒换后，测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9（结论）NE1($gpnIp1)反复进行SW主备倒换后，测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复进行SW主备倒换后，测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复保存设备重启后，测试业务恢复和系统内存  测试开始=====\n"
	#反复保存设备重启
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
        for {set j 1} {$j<=$cnt} {incr j} {
          	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
          	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
          	after $rebootTime
        	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[TestVplsTag $fileId "第$j\次NE1($gpnIp1)保存设备重启后" $rateL2 $rateR2 "GPN_PTN_006_$capId"]} {
			set flag6_case4 1
		} 
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls11" dTable
		if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)保存设备重启后" $dTable $expectTable]} {
			set flag6_case4 1
		}
        }
        gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag6_case4	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		 gwd::GWpublic_print "NOK" "FC1（结论）NE1($gpnIp1)反复保存设备重启后，测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1（结论）NE1($gpnIp1)反复保存设备重启后，测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)反复保存设备重启后，测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为tag模式、NE1($gpnIp1)和NE4($gpnIp4)用户侧接入模式为PORT+SVLAN+CVLAN，验证业务  测试开始=====\n"
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
	#NE1和NE4发送untag、vid=1000 100的数据流
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
		gwd::GWpublic_print "NOK" "FC2（结论）vpls为tag模式、NE1($gpnIp1)和NE4($gpnIp4)用户侧接入模式为PORT+SVLAN+CVLAN，验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2（结论）vpls为tag模式、NE1($gpnIp1)和NE4($gpnIp4)用户侧接入模式为PORT+SVLAN+CVLAN，验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls为tag模式、NE1($gpnIp1)和NE4($gpnIp4)用户侧接入模式为PORT+SVLAN+CVLAN，验证业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase4 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 4测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 4测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 4 ELAN业务功能验证：vpls为tag模式验证业务  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 两条ELAN业务共用一条LSP，验证业务之间无影响\n"
	set flag1_case5 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一条ELAN：vplsType为raw、ac为PORT+VLAN；一条ELAN：vplsType为tag、ac为PORT+SVLAN+CLVAN，测试两条ELAN的业务  测试开始=====\n"
	#新建一条ELAN业务vpls为raw模式，与之前的ELAN业务共用一条lsp
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
		gwd::GWpublic_print "NOK" "FC3（结论）一条ELAN：vplsType为raw、ac为PORT+VLAN；一条ELAN：vplsType为tag、ac为PORT+SVLAN+CLVAN，测试两条ELAN的业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3（结论）一条ELAN：vplsType为raw、ac为PORT+VLAN；一条ELAN：vplsType为tag、ac为PORT+SVLAN+CLVAN，测试两条ELAN的业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一条ELAN：vplsType为raw、ac为PORT+VLAN；一条ELAN：vplsType为tag、ac为PORT+SVLAN+CLVAN，测试两条ELAN的业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
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
	puts $fileId "Test Case 5 两条ELAN业务共用一条LSP，验证业务之间无影响  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 6 E-LAN业务：vpls域的配置中mac地址学习限制测试\n"
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
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为80，学习规则为丢弃  测试开始=====\n"
	PTN_ChangeElanConfig $fileId 10 "discard" "80" 0 1
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "discard" "ac500" "vpls10" 80 80]} {
		set flag1_case6 1
	}
	puts $fileId ""
	if {$flag1_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FC4（结论）vpls域中配置mac地址学习数量为80、学习规则为丢弃，配置不生效" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4（结论）vpls域中配置mac地址学习数量为80，学习规则为丢弃，配置生效" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为80，学习规则为丢弃  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为80，学习规则为泛洪  测试开始=====\n"
	PTN_ChangeElanConfig $fileId 10 "flood" "80" 1 1
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "flood" "ac500" "vpls10" 80 200]} {
		set flag2_case6 1
	}
	puts $fileId ""
	if {$flag2_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FC5（结论）vpls域中配置mac地址学习数量为80、学习规则为泛洪，配置不生效" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5（结论）vpls域中配置mac地址学习数量为80，学习规则为泛洪，配置生效" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为80，学习规则为泛洪  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为100，学习规则为泛洪  测试开始=====\n"
	PTN_ChangeElanConfig $fileId 10 "flood" "100" 1 1
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "flood" "ac500" "vpls10" 100 200]} {
		set flag3_case6 1
	}
	puts $fileId ""
	if {$flag3_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FC6（结论）vpls域中配置mac地址学习数量为100、学习规则为泛洪，配置不生效" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6（结论）vpls域中配置mac地址学习数量为100，学习规则为泛洪，配置生效" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为100，学习规则为泛洪  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为100，学习规则为丢弃  测试开始=====\n"
	PTN_ChangeElanConfig $fileId 10 "discard" "100" 1 1
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "discard" "ac500" "vpls10" 100 100]} {
		set flag4_case6 1
	}
	puts $fileId ""
	if {$flag4_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FC7（结论）vpls域中配置mac地址学习数量为100、学习规则为丢弃，配置不生效" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7（结论）vpls域中配置mac地址学习数量为100，学习规则为丢弃，配置生效" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为100，学习规则为丢弃  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为50，学习规则为泛洪  测试开始=====\n"
	PTN_ChangeElanConfig $fileId 10 "flood" "50" 1 1
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "flood" "ac500" "vpls10" 50 200]} {
		set flag5_case6 1
	}
	puts $fileId ""
	if {$flag5_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FC8（结论）vpls域中配置mac地址学习数量为50、学习规则为泛洪，配置不生效" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8（结论）vpls域中配置mac地址学习数量为50，学习规则为泛洪，配置生效" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为50，学习规则为泛洪  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
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
	puts $fileId "Test Case 6 E-LAN业务：vpls域的配置中mac地址学习限制测试\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 7 E-LAN业务：vpls域的配置中报文过滤参数测试\n"
	set flag1_case7 0
	set flag2_case7 0
	set flag3_case7 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中配置禁止通过广播包，允许通过组播包和未知单播包验证业务  测试开始=====\n"
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
	
	if {[TestCase7 "NE4($gpnIp4)vpls配置禁止通过广播包，允许通过组播包和未知单播包。" $rateL0 $rateR0 $rateL $rateR 1 0 0]} {
		set flag1_case7 1
	}
	puts $fileId ""
	if {$flag1_case7 == 1} {
		set flagCase7 1
		 gwd::GWpublic_print "NOK" "FC9（结论）vpls域中配置禁止通过广播包，允许通过组播包和未知单播包验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC9（结论）vpls域中配置禁止通过广播包，允许通过组播包和未知单播包验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中配置禁止通过广播包，允许通过组播包和未知单播包验证业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中配置禁止通过组播包，允许通过广播包和未知单播包验证业务  测试开始=====\n"
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
	
	if {[TestCase7 "NE4($gpnIp4)vpls配置禁止通过组播包，允许通过广播包和未知单播包。" $rateL0 $rateR0 $rateL $rateR 0 1 0]} {
		set flag2_case7 1
	}
	puts $fileId ""
	if {$flag2_case7 == 1} {
		set flagCase7 1
		 gwd::GWpublic_print "NOK" "FD1（结论）vpls域中配置禁止通过组播包，允许通过广播包和未知单播包验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD1（结论）vpls域中配置禁止通过组播包，允许通过广播包和未知单播包验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中配置禁止通过组播包，允许通过广播包和未知单播包验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中配置禁止通过未知单播包，允许通过广播包和组播包验证业务  测试开始=====\n"
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
	
	if {[TestCase7 "NE4($gpnIp4)vpls配置禁止通过未知单播包，允许通过广播包和组播包。" $rateL0 $rateR0 $rateL $rateR 0 0 1]} {
		set flag3_case7 1
	}
	puts $fileId ""
	if {$flag3_case7 == 1} {
		set flagCase7 1
		 gwd::GWpublic_print "NOK" "FD2（结论）vpls域中配置禁止通过未知单播包，允许通过广播包和组播包验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD2（结论）vpls域中配置禁止通过未知单播包，允许通过广播包和组播包验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中配置禁止通过未知单播包，允许通过广播包和组播包验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase7 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 7测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 7测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 7 E-LAN业务：vpls域的配置中报文过滤参数测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 8 E-LAN业务：黑白名单测试\n"
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
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在NE1($gpnIp1)的ac500上未配置静态mac地址时测试转发和mac地址转发表  测试开始=====\n"
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
        ####未配置静态mac时测试
	incr capId
        if {[PTN_BlackAndWhiteMac 0 0 0 "在NE1($gpnIp1)的ac500上未配置静态mac地址$staticMac\时" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
        	set flag1_case8 1
        }
	puts $fileId ""
	if {$flag1_case8 == 1} {
		set flagCase8 1
		 gwd::GWpublic_print "NOK" "FD3（结论）在NE1($gpnIp1)的ac500上未配置静态mac地址时测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD3（结论）在NE1($gpnIp1)的ac500上未配置静态mac地址时测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在NE1($gpnIp1)的ac500上未配置静态mac地址时测试转发和mac地址转发表  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在NE1($gpnIp1)的ac500上配置静态mac地址后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_addStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls10" "ac500"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 1 0 "在NE1($gpnIp1)的ac500配置静态mac地址$staticMac\后" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
		set flag2_case8 1
	}
	puts $fileId ""
	if {$flag2_case8 == 1} {
		set flagCase8 1
		 gwd::GWpublic_print "NOK" "FD4（结论）在NE1($gpnIp1)的ac500上配置静态mac地址后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD4（结论）在NE1($gpnIp1)的ac500上配置静态mac地址后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在NE1($gpnIp1)的ac500上配置静态mac地址后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在NE1($gpnIp1)的ac500上配置静态mac地址并保存重启设备后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	incr capId
	if {[PTN_BlackAndWhiteMac 0 1 0 "在NE1($gpnIp1)的ac500配置静态mac地址$staticMac\并保存重启设备后" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
		set flag3_case8 1
	}
	puts $fileId ""
	if {$flag3_case8 == 1} {
		set flagCase8 1
		 gwd::GWpublic_print "NOK" "FD5（结论）在NE1($gpnIp1)的ac500上配置静态mac地址并保存重启设备后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD5（结论）在NE1($gpnIp1)的ac500上配置静态mac地址并保存重启设备后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在NE1($gpnIp1)的ac500上配置静态mac地址并保存重启设备后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上删除配置的静态mac地址后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls10"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 0 0 "在NE1($gpnIp1)的ac500上删除配置静态mac地址$staticMac\后" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
		set flag4_case8 1
	}
	puts $fileId ""
	if {$flag4_case8 == 1} {
		set flagCase8 1
		 gwd::GWpublic_print "NOK" "FD6（结论）NE1($gpnIp1)ac500上删除配置的静态mac地址后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD6（结论）NE1($gpnIp1)ac500上删除配置的静态mac地址后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上删除配置的静态mac地址后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)到NE2($gpnIp2)的pw12上配置静态mac地址后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_addStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls10" "pw12"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 1 1 "在NE1($gpnIp1)的pw12上添加配置静态mac地址$staticMac_dst\后" "pw" "pw12" "vpls10" $staticMac_dst "GPN_PTN_006_$capId"]} {
		set flag5_case8 1
	}
	puts $fileId ""
	if {$flag5_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FD7（结论）NE1($gpnIp1)到NE2($gpnIp2)的pw12上配置静态mac地址后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD7（结论）NE1($gpnIp1)到NE2($gpnIp2)的pw12上配置静态mac地址后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)到NE2($gpnIp2)的pw12上配置静态mac地址后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)到NE2($gpnIp2)的pw12上配置静态mac地址并保存重启后测试转发和mac地址转发表  测试开始=====\n"
        gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
        gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
        after $rebootTime
        set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	incr capId
	if {[PTN_BlackAndWhiteMac 0 1 1 "在NE1($gpnIp1)的pw12上添加配置静态mac地址$staticMac_dst\并保存重启后" "pw" "pw12" "vpls10" $staticMac_dst "GPN_PTN_006_$capId"]} {
		set flag6_case8 1
	}
	puts $fileId ""
	if {$flag6_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FD8（结论）NE1($gpnIp1)到NE2($gpnIp2)的pw12上配置静态mac地址并保存重启后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD8（结论）NE1($gpnIp1)到NE2($gpnIp2)的pw12上配置静态mac地址并保存重启后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)到NE2($gpnIp2)的pw12上配置静态mac地址并保存重启后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)到NE2($gpnIp2)的pw12上删除静态mac地址后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls10"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 0 1 "在NE1($gpnIp1)的pw12上删除配置静态mac地址$staticMac_dst\后" "pw" "pw12" "vpls10" $staticMac_dst "GPN_PTN_006_$capId"]} {
		set flag7_case8 1
	}
	puts $fileId ""
	if {$flag7_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FD9（结论）NE1($gpnIp1)到NE2($gpnIp2)的pw12上删除静态mac地址后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD9（结论）NE1($gpnIp1)到NE2($gpnIp2)的pw12上删除静态mac地址后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)到NE2($gpnIp2)的pw12上删除静态mac地址后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上配置黑洞mac后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_addBlackHoleMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls10" "ac500" "src_drop"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 1 0 "在NE1($gpnIp1)的ac500上配置黑洞mac地址$staticMac\后" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
		set flag8_case8 1
	}
	puts $fileId ""
	if {$flag8_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FE1（结论）NE1($gpnIp1)ac500上配置黑洞mac后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE1（结论）NE1($gpnIp1)ac500上配置黑洞mac后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上配置黑洞mac后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上配置黑洞mac并保存重启后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	incr capId
	if {[PTN_BlackAndWhiteMac 1 1 0 "在NE1($gpnIp1)的ac500上配置黑洞mac地址$staticMac\并保存重启后" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
		set flag9_case8 1
	}
	puts $fileId ""
	if {$flag9_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FE2（结论）NE1($gpnIp1)ac500上配置黑洞mac并保存重启后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE2（结论）NE1($gpnIp1)ac500上配置黑洞mac并保存重启后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上配置黑洞mac并保存重启后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上删除黑洞mac后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls10"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 0 0 "在NE1($gpnIp1)的ac500上删除黑洞mac地址$staticMac\后" "ac" "ac500" "vpls10" $staticMac "GPN_PTN_006_$capId"]} {
		set flag10_case8 1
	}
	puts $fileId ""
	if {$flag10_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FE3（结论）NE1($gpnIp1)ac500上删除黑洞mac后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE3（结论）NE1($gpnIp1)ac500上删除黑洞mac后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上删除黑洞mac后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上添加黑洞mac后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_addBlackHoleMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls10" "pw12" "dest_drop"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 1 1 "在NE1($gpnIp1)的pw12上添加黑洞mac地址$staticMac_dst\后" "pw" "pw12" "vpls10" $staticMac_dst "GPN_PTN_006_$capId"]} {
		set flag11_case8 1
	}
	puts $fileId ""
	if {$flag11_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FE4（结论）NE1($gpnIp1)pw12上添加黑洞mac后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE4（结论）NE1($gpnIp1)pw12上添加黑洞mac后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上添加黑洞mac后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上添加黑洞mac并保存重启后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	incr capId
	if {[PTN_BlackAndWhiteMac 1 1 1 "在NE1($gpnIp1)的pw12上添加黑洞mac地址$staticMac_dst\并保存重启后" "pw" "pw12" "vpls10" $staticMac_dst "GPN_PTN_006_$capId"]} {
		set flag12_case8 1
	}
	puts $fileId ""
	if {$flag12_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FE5（结论）NE1($gpnIp1)pw12上添加黑洞mac并保存重启后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE5（结论）NE1($gpnIp1)pw12上添加黑洞mac并保存重启后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上添加黑洞mac并保存重启后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上删除黑洞mac后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls10"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 0 0 "在NE1($gpnIp1)的pw12上删除黑洞mac地址$staticMac_dst\后" "pw" "pw12" "vpls10" $staticMac_dst "GPN_PTN_006_$capId"]} {
		set flag13_case8 1
	}
	puts $fileId ""
	if {$flag13_case8 == 1} {
		set flagCase8 1
		gwd::GWpublic_print "NOK" "FE6（结论）NE1($gpnIp1)pw12上删除黑洞mac后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE6（结论）NE1($gpnIp1)pw12上删除黑洞mac后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上删除黑洞mac后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_006_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_006" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase8 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 8测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 8测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 8 E-LAN业务：黑白名单测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 9 E-LAN业务，性能统计测试\n"
	puts $fileId "使能NE1性能统计简单验证见case1测试结果，采集信息长期验证只能在网管操作，脚本未覆盖"
	puts $fileId ""
	puts $fileId "Test Case 9 E-LAN业务，性能统计测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 10 E-LAN业务，LSP标签交换功能验证测试\n"
	puts $fileId "测试目的：E-LAN业务，LSP标签交换功能验证测试"
	puts $fileId ""
	puts $fileId "NE1-NE3设备之间的标签交换验证见case1测试结果，不再单独测试"
	puts $fileId ""
	puts $fileId "Test Case 10 E-LAN业务，LSP标签交换功能验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===恢复初始化配置...\n"
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
	#为了规避删除黑洞mac和静态mac，主备板不同步问题，对设备进行下载初始化配置重启操作------
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
	#------为了规避删除黑洞mac和静态mac，主备板不同步问题，对设备进行下载初始化配置重启操作
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "测试结束后配置恢复" "测试结束后配置恢复" "GPN_PTN_006"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "测试过程中所有配置文件都上传成功" "GPN_PTN_006"
	chan seek $fileId 0
        puts $fileId "\n**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "GPN_PTN_006测试目的：E-LAN：Vpls=tag和raw模式的业务验证、LSP PW交换功能验证\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1 == 1 || $flagCase2 == 1 || $flagCase3 == 1 || $flagCase4 == 1 || $flagCase5 == 1 || $flagCase6 == 1\
		|| $flagCase7 == 1 || $flagCase8 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_006测试结果" $fileId
        puts $fileId ""
        gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5测试结果" $fileId
        gwd::GWpublic_print [expr {($flagCase6 == 0) ? "OK" : "NOK"}] "Test Case 6测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase7 == 0) ? "OK" : "NOK"}] "Test Case 7测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase8 == 0) ? "OK" : "NOK"}] "Test Case 8测试结果" $fileId
        puts $fileId ""
        puts $fileId ""
        gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "（结论）vplsType为raw模式、用户侧接入模式为端口模式验证ELAN业务" $fileId
        gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "（结论）镜像NE1($gpnIp1)到NE2($gpnIp2)、NE4($gpnIp4)的NNI出口方向报文测试MPLS标签" $fileId
        gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)使能lsp、pw、ac的性能统计，测试性能统计的准确性" $fileId
        gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)反复shut undoshut NNI口后，测试业务恢复和系统内存" $fileId
        gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存" $fileId
        gwd::GWpublic_print "== FA6 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
        gwd::GWpublic_print "== FA7 == [expr {($flag7_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
        gwd::GWpublic_print "== FA8 == [expr {($flag8_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
        gwd::GWpublic_print "== FA9 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "（结论）删除所有设备上的专网业务AC，测试业务" $fileId
        gwd::GWpublic_print "== FB1 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "（结论）vlps为raw模式、接入模式改为“端口+运营商VLAN”模式，验证业务转发" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "（结论）vlps为raw模式、接入模式改为“端口+运营商VLAN”模式，未使能overlay功能时业务测试" $fileId
        gwd::GWpublic_print "== FB3 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "（结论）vlps为raw模式、接入模式改为“端口+运营商VLAN”模式，使能overlay功能时业务测试" $fileId
        gwd::GWpublic_print "== FB4 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "（结论）vpls为raw模式、用户侧接入模式为”端口和端口+运营商VLAN两种模式，验证业务" $fileId
        gwd::GWpublic_print "== FB5 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "（结论）vlps为tag模式、接入模式为“端口和端口+运营商VLAN”两种模式，验证业务" $fileId
        gwd::GWpublic_print "== FB6 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)反复shut undoshut NNI口后，测试业务恢复和系统内存" $fileId
        gwd::GWpublic_print "== FB7 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)反复重启NNI口所在板卡后，测试业务恢复和系统内存" $fileId
        gwd::GWpublic_print "== FB8 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)反复进行NMS主备倒换后，测试业务恢复和系统内存" $fileId
        gwd::GWpublic_print "== FB9 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)反复进行SW主备倒换后，测试业务恢复和系统内存" $fileId
        gwd::GWpublic_print "== FC1 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)反复保存设备重启后，测试业务恢复和系统内存" $fileId
        gwd::GWpublic_print "== FC2 == [expr {($flag7_case4 == 1) ? "NOK" : "OK"}]" "（结论）vpls为tag模式、NE1($gpnIp1)和NE4($gpnIp4)用户侧接入模式为PORT+SVLAN+CVLAN，验证业务" $fileId
        gwd::GWpublic_print "== FC3 == [expr {($flag1_case5 == 1) ? "NOK" : "OK"}]" "（结论）一条ELAN：vplsType为raw、ac为PORT+VLAN；一条ELAN：vplsType为tag、ac为PORT+SVLAN+CLVAN，测试两条ELAN的业务" $fileId
        gwd::GWpublic_print "== FC4 == [expr {($flag1_case6 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置mac地址学习数量为80、学习规则为丢弃，配置[expr {($flag1_case6 == 1) ? "不" : ""}]生效" $fileId
        gwd::GWpublic_print "== FC5 == [expr {($flag2_case6 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置mac地址学习数量为80、学习规则为泛洪，配置[expr {($flag2_case6 == 1) ? "不" : ""}]生效" $fileId
        gwd::GWpublic_print "== FC6 == [expr {($flag3_case6 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置mac地址学习数量为100、学习规则为泛洪，配置[expr {($flag3_case6 == 1) ? "不" : ""}]生效" $fileId
        gwd::GWpublic_print "== FC7 == [expr {($flag4_case6 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置mac地址学习数量为100、学习规则为丢弃，配置[expr {($flag4_case6 == 1) ? "不" : ""}]生效" $fileId
        gwd::GWpublic_print "== FC8 == [expr {($flag5_case6 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置mac地址学习数量为50、学习规则为泛洪，配置[expr {($flag5_case6 == 1) ? "不" : ""}]生效" $fileId
        gwd::GWpublic_print "== FC9 == [expr {($flag1_case7 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置禁止通过广播包，允许通过组播包和未知单播包验证业务" $fileId
        gwd::GWpublic_print "== FD1 == [expr {($flag2_case7 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置禁止通过组播包，允许通过广播包和未知单播包验证业务" $fileId
        gwd::GWpublic_print "== FD2 == [expr {($flag3_case7 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置禁止通过未知单播包，允许通过广播包和组播包验证业务" $fileId
	gwd::GWpublic_print "== FD3 == [expr {($flag1_case8 == 1) ? "NOK" : "OK"}]" "（结论）在NE1($gpnIp1)的ac500上未配置静态mac地址时测试转发和mac地址转发表" $fileId
        gwd::GWpublic_print "== FD4 == [expr {($flag2_case8 == 1) ? "NOK" : "OK"}]" "（结论）在NE1($gpnIp1)的ac500上配置静态mac地址后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FD5 == [expr {($flag3_case8 == 1) ? "NOK" : "OK"}]" "（结论）在NE1($gpnIp1)的ac500上配置静态mac地址并保存重启设备后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FD6 == [expr {($flag4_case8 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)ac500上删除配置的静态mac地址后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FD7 == [expr {($flag5_case8 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上配置静态mac地址后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FD8 == [expr {($flag6_case8 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上配置静态mac地址并保存重启后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FD9 == [expr {($flag7_case8 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上删除静态mac地址后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE1 == [expr {($flag8_case8 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)ac500上配置黑洞mac后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE2 == [expr {($flag9_case8 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)ac500上配置黑洞mac并保存重启后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE3 == [expr {($flag10_case8 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)ac500上删除黑洞mac后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE4 == [expr {($flag11_case8 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上添加黑洞mac后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE5 == [expr {($flag12_case8 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上添加黑洞mac并保存重启后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE6 == [expr {($flag13_case8 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上删除黑洞mac后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "（结论）测试结束后配置恢复" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "（结论）测试过程中配置文件的上传" $fileId
        puts $fileId ""
        puts $fileId "**************************************************************************************"
        puts $fileId ""
        puts $fileId "**************************************************************************************"
} err]} {
gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "运行异常：错误为$err" "" "GPN_PTN_006"
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
