#!/bin/sh
# T4_GPN_PTN_ETREE_010.tcl \
exec tclsh "$0" ${1+"$@"}
#-----------------------------------------------------------------------------------------------------------------------------------
#测试目的：E-TREE的功能
#1-E-TREE业务功能验证  
#2-单域E-Tree业务验证
#3-lsp标签交换 
#4-VSI中mac学习限制
#5-报文过滤 
#6-黑白名单测试
#7-性能统计
#9-多域的E-Tree业务验证
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
#   <2>当NE1、NE4、NE3为PE角色，PE2既为PE又为P角色，NE1到NE3的tree业务经过NE2，此时NE2为p
#   <3>创建根节点NE1的端口1到到叶子节点NE2/NE4/NE3的端口2/4/3的EP-Tree业务，用户侧（GE端口）接入模式为端口模式
#      配置NE1到NE2的LSP入标签17，出标签17；PW1本地标签1000，远程标签1000；
#      配置NE1到NE4的LSP入标签18，出标签18；PW1本地标签2000，远程标签2000；
#      配置NE1到NE3的LSP入标签20，出标签21；PW1本地标签3000，远程标签3000；
#      配置NE3到NE1的LSP入标签22，出标签23；PW1本地标签3000，远程标签3000；
#      NE2设备上配置lsp的标签交换，NE2将LSP入标签21交换为出标签22；NE2将LSP入标签23交换为出标签20；
#      命令行配置：mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000><1-65535> [normal|ring] 
#   <4>当NE1/NE2/NE3/NE4都为PE角色，NE1到NE3的tree业务经过NE2，此时NE2上的两条pw,与NE1连的为root角色，与NE3连的为none(叶子)角色
#   <5>创建根节点NE1的端口1到到叶子节点NE2/NE4/NE3的端口2/4/3的EP-Tree业务，配置如下，无需标签交换
#      配置NE1到NE2的LSP入标签17，出标签17；PW1本地标签1000，远程标签1000；
#      配置NE1到NE4的LSP入标签18，出标签18；PW1本地标签2000，远程标签2000；
#      配置NE2到NE3的LSP入标签20，出标签20；PW1本地标签3000，远程标签3000；
#   <6>在用户侧端口下配置undo vlan check;
#   预期结果:系统无异常，查看配置正确，发送业务数据流，业务正常转发；NE2/NE3/NE4三台设备变为带内管理均正常
#单域E-Tree（ep-tree）业务验证 
#      按上述的配置（ep-tree）
#      NE1发送untag/tag的广播包，NE2/NE3/NE4设备的叶子端口都能收到；
#      NE1发送untag/tag的组播包，NE2/NE3/NE4设备的叶子端口都能收到；
#      NE1发送untag/tag的单播包，NE2/NE3/NE4设备的叶子端口都能收到；
#      NE1、NE2的互发untag/tag已知单播，NE3、NE4设备叶子端口收不到数据；
#      NE1、NE3的互发untag/tag已知单播，NE2、NE4设备叶子端口收不到数据；
#      NE1、NE4的互发untag/tag已知单播，NE2、NE3设备叶子端口收不到数据；
#   <7>NE2,NE4,NE3发送untag/tag的广播/单播/组播，
#   预期结果：仅NE1能收到数据，其他叶子节点不能收到，叶子节点的叶子端口间不能互通；
#             镜像NE1的NNI端口egress方向报文，为不带VLAN TAG标签的mpls标签报文，外层lsp标签17，内层pw标签1000,，
#            LSP字段中的TTL值为255，PW字段中的TTL值为255，PW字段中含有4字节控制字
#   <8>undo shutdown和shutdown NE1设备的NNI/UNI端口50次，每次操作后业务恢复正常，系统无异常 
#   <9>重启NE1设备的NNI/UNI端口所在板卡50次，每次操作后业务恢复正常，系统无异常 
#   <10>NE1设备进行SW/NMS倒换50次，每次操作后业务恢复正常，系统无异常 ，查看标签转发表项正确，三台设备管理正常
#   <11>保存重启NE1设备的50次，每次操作后系统正常启动，业务恢复正常，系统无异常，查看标签转发表项正确，三台设备管理正常 
#   <12>不删除域的情况下，删除NE1、NE2、NE3、NE4上的ac，查看配置ac删除成功,pw与域的绑定是不删除的，NE1与其他3台设备的业务中断，系统无异常
#   <13>重新添加ac，查看配置添加成功，发送业务验证生效
#2、搭建Test Case 2测试环境
#单域E-Tree（evp-tree）业务验证 
#   <14>删除NE1、NE2、NE3、NE4设备的汇聚业务（AC+vpls域），查看配置删除成功，ac和vpls域配置消失，业务中断，系统无异常
#   <15>重新创建NE1、NE2、NE3、NE4上的汇聚业务（AC+vpls域）,承载伪线不做更改，将ac接入模式设为“端口+运营商VLAN”，即（evp-Tree业务）
#   <16>在NE1、NE2、NE3、NE4上均创建所需的VLAN（vlan 100），并加入端口，再次创建接入模式为“端口+运营商VLAN”的汇聚业务，成功创建，系统无异常
#   <17>向NE1的端口1发送tag100、tag200业务流，NE2、NE3、NE4的叶子端口只可接收tag100业务流；NE1与NE2、NE3、NE4互发vlan100的双向发流业务正常
#   <18>NE2、NE3、NE4发vlan100的单向流，只有NE1可以收到，叶子节点的叶子端口间不能互通
#   <19>重复步骤8-11
#   <20>将UNI端口更改为FE/10GE端口，其他条件不变，重复以上步  注：使用FE端口配置汇聚业务时，需开启该板卡的MPLS业务模式（命令为：mpls enable <slot>）
#3、搭建Test Case 3测试环境
##E-LAN业务功能验证 -接入模式为"端口+运营商VLAN"模式
#   <1>按上述拓扑及配置，NE2为NE1及NE3间的P节点；NE1到NE3的LSP入标签20，出标签21；
#      NE3到NE1的LSP入标签22，出标签23；NE2将LSP入标签21交换为出标签22；NE2将LSP入标签23交换为出标签20；
#   <2>NE1与NE3对发tag100的已知单播，业务正常；镜像NE2与NE1相连的NNI入端口的流，为不带tag标签的mpls流，lsp标签为21，TTL值为255，pw标签3000，PW的TTL值为255；
#      镜像NE2与NE3相连的NNI出端口的流，为不带tag标签的mpls流，lsp标签为22，TTL值为254，pw标签3000，PW的TTL值为255；证明NE2将NE1到NE3方向的lsp标签进行了正确的交换
#      镜像NE2与NE1相连的NNI出端口的流，为不带tag标签的mpls流，lsp标签为20，TTL值为254，pw标签3000，PW的TTL值为255；
#      镜像NE2与NE3相连的NNI入端口的流，为不带tag标签的mpls流，lsp标签为23，TTL值为255，pw标签3000，PW的TTL值为255；证明NE2将NE3到NE1方向的lsp标签进行了正确的交换
#   <3>undo shutdown和shutdown NE2设备的NNI/UNI端口10次，标签交换正常，业务恢复正常，系统无异常 
#   <4>重启NE2设备的NNI/UNI端口所在板卡10次，标签交换正常，业务恢复正常，系统无异常 
#   <5>NE2设备进行SW/NMS倒换10次，标签交换正常，业务恢复正常，系统无异常 
#   <6>保存重启NE2设备的10次，系统正常启动，标签交换正常，业务恢复正常，系统无异常 
#4、搭建Test Case 4测试环境
###VSI中mac学习限制
#   <1>拓扑及配置不变，将vpls域中mac地址学习数量设为20，学习规则为丢弃时，命令行配置正确
#   <2>从NE1的UNI口一次发送源tag100、 mac不同的30条流，在NE1上用命令show forward-entry vpls vpls1查看mac地址表，
#   预期结果：mac地址学习数目正确为20个；学习条目正确，学在对应vpls的ac上
#	     NE1、NE2、NE3的UNI口均只能收到20条流，说明学习规则为丢弃生效，没学到的都丢弃了
#   <3>vpls域中mac地址学习数量仍设为20，修改学习规则为洪泛
#   预期结果：从NE1的UNI口一次发送源mac不同的30条流，在NE1上用命令show forward-entry vpls vpls1查看mac地址表，
#             mac地址学习数目正确为20个；学习条目正确，学在对应vpls的ac上
#             NE1、NE2、NE3的UNI口均能收到30条流，说明学习规则为洪泛生效，没学到的流都洪泛出去了
#   <4>将mac学习的限制数量更改为其他的值进行多次验证均生效
#5、搭建Test Case 5测试环境
###对单播/组播/广播 的过滤
#   <1>拓扑及配置不变，NE1发送tag100的广播（目的macffff.ffff.ffff），组播(目的mac 0100.5e00.0001)，单播，NE2/NE3/NE4设备的叶子端口都能收到
#   <2>将广/组播控制功能修改为使能（默认禁止），查看配置生效，业务中断
#   <3>再将广/组/单播控制功能改为禁止，业务恢复
#6、搭建Test Case 6测试环境
###mac地址黑白名单的测试
#   <1>拓扑及配置不变，NE1发送tag100源为0000.0010.0001，目的mac为0000.0010.0002的数据流，NE2、NE3、NE4均可收到
#   <2>查看mac地址表，0000.0010.0001动态学到对应vpls的ac上
#   <3>在NE1上配置基于源的静态mac绑定到ac口，该mac地址为0000.0010.0001，查看mac地址表，该mac表项由动态变为静态，业务正常
#   <4>进行NE1设备的SW/NMS倒换10次（软倒换），每次操作后业务恢复正常，系统无异常，静态mac表项正确
#   <5>删除静态mac，mac地址又被重新动态学习到
#   <6>在NE1上配置基于源的静态mac绑定到pw1上，该mac地址为0000.0010.0002，查看mac地址表正确，且只有NE2能收到数据流，NE3、NE4的数据数据流中断
#   <7>进行NE1设备的SW/NMS倒换10次（软倒换），每次操作后业务恢复正常，系统无异常，静态mac表项正确且生效
#   <8>删除静态mac，NE3、NE4重新收到数据流
#   <9>在NE1上配置基于源的黑洞mac绑定到ac口，该mac地址为0000.0010.0001，查看mac地址表，黑洞mac表项取代动态表项，业务中断
#   <10>进行NE1设备的SW/NMS倒换10次（软倒换），每次操作后业务恢复正常，系统无异常，黑洞mac表项正确且生效
#   <11>删除黑洞态mac，mac地址又被重新动态学习到，业务重新恢复
#   <12>在NE1上配置基于源的黑洞mac绑定到pw1，该mac地址为0000.0010.0002，查看mac地址表，黑洞mac表项正确，且NE2业务中断，NE3/NE4业务正常
#   <13>进行NE1设备的SW/NMS倒换4次（软倒换），每次操作后业务恢复正常，系统无异常，静态mac表项正确且生效
#   <14>删除黑洞mac，NE2业务恢复正常，黑洞mac表项消失
#7、搭建Test Case 7测试环境
###性能统计
#   <1>上述拓扑，配置不变，NE1与NE2、NE3、NE4互发已知单播（每秒发10000个包），业务正常
#   <2>使能NE1的lsp/pw的性能统计，开启ac（即ac所绑定的物理端口）、lsp、pw的当前性能统计，轮询时间设为1分钟
#   <3>一5分钟后，在网管上查看统计结果，应该有5个统计结果，且每个结果的值相近，收/发包数为60*10000个左右，没有数量级上的误差
#   <4>删除当前性能统计，在网管上添加ac（即ac所绑定的物理端口）、lsp、pw的15分钟采集信息
#   <5>一小时后查看15分钟历史性能统计，应该有四个统计结果，每15分钟统计一次，统计正确
#   <6>删除15分钟历史性能统计，在网管上添加ac（即ac所绑定的物理端口）、lsp、pw的24小时采集信息计
#   <7>48小时后查看24小时历史性能统计，应该有两个统计结果，每24小时统计一次，统计正确
#8、搭建Test Case 8测试环境
##多域的E-Tree业务
#   <1>拓扑不变，新建一个域vpls2，,再创建一条新的E-Tree业务(与之前的业务共用同相同LSP)，创建新的pw，所有设备的AC接入模式设为“端口+运营商VLAN+客户VLAN”，
#      运营商VLAN为 vlan 300，客户VLAN为vlan 3000，业务成功创建，系统无异常，对之前的业务无任何干扰，
#   <2>配置NE1的LSP10入标签17，出标签17；PW10本地标签20，远程标签20
#      配置NE3的LSP10入标签18，出标签18；PW10本地标签20，远程标签20 
#      NE2的SW配置：mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000> <1-65535> [normal|ring] 
#   <3>向NE1的UNI端口发送untag、tag300、tag3000、 双层tag（外300 内3000）业务流量
#   预期结果：NE2、NE3、NE4的UNI端口只可接收到双层tag（外300 内3000）业务流量，且对之前的业务无干扰，双向发流业务正常
#   <4>undo shutdown和shutdown NE1和NE2设备的NNI/UNI端口50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
#   <5>重启NE1和NE2设备的NNI/UNI端口所在板卡50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
#   <6>NE1和NE2设备进行SW/NMS倒换50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 ，查看标签转发表项正确
#   <7>保存重启NE1和NE2设备的50次，每次操作后系统正常启动，每条业务恢复正常且彼此无干扰，系统无异常，查看标签转发表项正确
#   <8>在不删除vpls的情况下，删除vpls2的ac，vpls2的业务中断，vpls1的业务不受影响
#   <9>重新添加ac，查看配置添加成功，业务恢复，且不影响其他域的业务
#   <10>直接删除该vpls，再删除对应的pw,
#   预期结果：该域业务中断，不影响vpls1的业务
#   <11>重新创建一个vpls2,NE2为根节点NE1为叶子节点，lsp共用vpls1的，pw重新创建，NE2上新建的PW的角色为none(叶子)，
#       NE1上新建的pw的角色为root，验证了根节点上向NNI口汇聚的情况，即pw为root
#   <12>创建一条新的E-Tree业务，AC接入模式设为“端口+运营商VLAN”，运营商VLAN为 vlan 200业务成功创建，
#   预期结果：系统无异常，对之前的业务无任何干扰
#   <13>删除该vpls，再删除对应的pw,该域业务中断，不影响vpls1的业务 
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
        file mkdir "log"
        set fd_log [open "log\\GPN_PTN_010_LOG.txt" a]
        set stdout $fd_log
        chan configure $fd_log -blocking 0 -buffering none;#非阻塞模式 按行flush
        log_file log\\GPN_PTN_010_LOG.txt
        
        file mkdir "report"
        set fileId [open "report\\GPN_PTN_010_REPORT.txt" a+]
        chan configure $fileId -blocking 0 -buffering none;#非阻塞模式 按行flush
        
        file mkdir "debug"
        set fd_debug [open debug\\GPN_PTN_010_DEBUG.txt a]
        exp_internal -f debug\\GPN_PTN_010_DEBUG.txt 0
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
	
	set flagResult 0
	set flagCase1 0   ;#Test case 1标志位 
	set flagCase2 0   ;#Test case 2标志位
	set flagCase3 0   ;#Test case 3标志位 
	set flagCase4 0   ;#Test case 4标志位 
	set flagCase5 0   ;#Test case 5标志位
	set flagCase6 0   ;#Test case 6标志位
	set flagCase7 0   ;#Test case 7标志位
	set flagCase8 0   ;#Test case 8标志位
	set flagCase9 0   ;#Test case 8标志位
	
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
	regsub {/} $GPNTestEth5 {_} GPNTestEth5_cap
	regsub {/} $GPNTestEth6 {_} GPNTestEth6_cap
	
	
	#函数功能：TestCase1的业务测试
	#acCfg_flag =1 有AC配置    =0删除了AC配置
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
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		if {$acCfg_flag == 1} {
        		#NE1接收
        		if {$GPNPort1Cnt1(cnt22) < $rateL || $GPNPort1Cnt1(cnt22) > $rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=500的已知单播数据流，NE1($gpnIp1)\
        				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt22)，没在$rateL-$rateR\范围内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=500的已知单播数据流，NE1($gpnIp1)\
        				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt22)，在$rateL-$rateR\范围内" $fileId
        		}
        		if {$GPNPort1Cnt1(cnt33) < $rateL || $GPNPort1Cnt1(cnt33) > $rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=500的已知单播数据流，NE1($gpnIp1)\
        				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt33)，没在$rateL-$rateR\范围内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=500的已知单播数据流，NE1($gpnIp1)\
        				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt33)，在$rateL-$rateR\范围内" $fileId
        		}
        		if {$GPNPort1Cnt1(cnt44) < $rateL || $GPNPort1Cnt1(cnt44) > $rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=500的已知单播数据流，NE1($gpnIp1)\
        				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt44)，没在$rateL-$rateR\范围内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=500的已知单播数据流，NE1($gpnIp1)\
        				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt44)，在$rateL-$rateR\范围内" $fileId
        		}
        		#NE2接收
        		if {$GPNPort2Cnt1(cnt2) < $rateL || $GPNPort2Cnt1(cnt2) > $rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE2($gpnIp2)\
        				$GPNTestEth2\收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt2)，没在$rateL-$rateR\范围内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE2($gpnIp2)\
        				$GPNTestEth2\收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt2)，在$rateL-$rateR\范围内" $fileId
        		}
        		#NE3接收
        		if {$GPNPort3Cnt1(cnt3) < $rateL || $GPNPort3Cnt1(cnt3) > $rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE3($gpnIp3)\
        				$GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt3)，没在$rateL-$rateR\范围内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE3($gpnIp3)\
        				$GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt3)，在$rateL-$rateR\范围内" $fileId
        		}
        		#NE4接收
        		if {$GPNPort4Cnt1(cnt4) < $rateL || $GPNPort4Cnt1(cnt4) > $rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE4($gpnIp4)\
        				$GPNTestEth4\收到tag=500的数据流的速率为$GPNPort4Cnt1(cnt4)，没在$rateL-$rateR\范围内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE4($gpnIp4)\
        				$GPNTestEth4\收到tag=500的数据流的速率为$GPNPort4Cnt1(cnt4)，在$rateL-$rateR\范围内" $fileId
        		}
		} else {
			#NE1接收
			if {$GPNPort1Cnt1(cnt22) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=500的已知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=500的数据流的速率应为0实为$GPNPort1Cnt1(cnt22)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=500的已知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=500的数据流的速率0实为$GPNPort1Cnt1(cnt22)" $fileId
			}
			if {$GPNPort1Cnt1(cnt33) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=500的已知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=500的数据流的速率0实为$GPNPort1Cnt1(cnt33)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=500的已知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=500的数据流的速率0实为$GPNPort1Cnt1(cnt33)" $fileId
			}
			if {$GPNPort1Cnt1(cnt44) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=500的已知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=500的数据流的速率0实为$GPNPort1Cnt1(cnt44)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=500的已知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=500的数据流的速率0实为$GPNPort1Cnt1(cnt44)" $fileId
			}
			#NE2接收
			if {$GPNPort2Cnt1(cnt2) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到tag=500的数据流的速率0实为$GPNPort2Cnt1(cnt2)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到tag=500的数据流的速率0实为$GPNPort2Cnt1(cnt2)" $fileId
			}
			#NE3接收
			if {$GPNPort3Cnt1(cnt3) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到tag=500的数据流的速率0实为$GPNPort3Cnt1(cnt3)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到tag=500的数据流的速率0实为$GPNPort3Cnt1(cnt3)" $fileId
			}
			#NE4接收
			if {$GPNPort4Cnt1(cnt4) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=500的数据流的速率0实为$GPNPort4Cnt1(cnt4)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=500的数据流的速率0实为$GPNPort4Cnt1(cnt4)" $fileId
			}
		}
		return $flag
	}
	
	
	#函数功能：case2和case9的流量测试
	#etreeCnt = 1：只有etree1  =2：两个etree业务     =3：删除etree的ac   =4修改etree2的配置
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
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		#NE1的接收	
		if {$GPNPort1Cnt1(cnt15) < $rateL || $GPNPort1Cnt1(cnt15) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=100的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=100的数据流的速率为$GPNPort1Cnt1(cnt15)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=100的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=100的数据流的速率为$GPNPort1Cnt1(cnt15)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort1Cnt1(cnt19) < $rateL || $GPNPort1Cnt1(cnt19) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=100的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=100的数据流的速率为$GPNPort1Cnt1(cnt19)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=100的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=100的数据流的速率为$GPNPort1Cnt1(cnt19)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort1Cnt1(cnt20) < $rateL || $GPNPort1Cnt1(cnt20) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=100的数据流的速率为$GPNPort1Cnt1(cnt20)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=100的数据流的速率为$GPNPort1Cnt1(cnt20)，在$rateL-$rateR\范围内" $fileId
		}
		
		#NE2接收
		if {$GPNPort2Cnt1(cnt14) < $rateL || $GPNPort2Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=100的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到tag=100的数据流的速率为$GPNPort2Cnt1(cnt14)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=100的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到tag=100的数据流的速率为$GPNPort2Cnt1(cnt14)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort2Cnt0(cnt16) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=100的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt16)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=100的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt16)" $fileId
		}
		if {$GPNPort2Cnt0(cnt58) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt58)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt58)" $fileId
		}
		#NE3接收
		if {$GPNPort3Cnt1(cnt14) < $rateL || $GPNPort3Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=100的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到tag=100的数据流的速率为$GPNPort3Cnt1(cnt14)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=100的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到tag=100的数据流的速率为$GPNPort3Cnt1(cnt14)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort3Cnt0(cnt14) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=100的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt14)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=100的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt14)" $fileId
		}
		if {$GPNPort3Cnt0(cnt58) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt58)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt58)" $fileId
		}
		#NE4接收
		
		if {$GPNPort4Cnt1(cnt14) < $rateL || $GPNPort4Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=100的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到tag=100的数据流的速率为$GPNPort4Cnt1(cnt14)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=100的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到tag=100的数据流的速率为$GPNPort4Cnt1(cnt14)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort4Cnt0(cnt14) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=100的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt14)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送tag=100的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt14)" $fileId
		}
		if {$GPNPort4Cnt0(cnt16) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=100的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt16)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送tag=100的未知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt16)" $fileId
		}
		if {$etreeCnt != 4} {
			if {$GPNPort2Cnt0(cnt2) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt2)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt2)" $fileId
			}
			if {$GPNPort3Cnt0(cnt2) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt2)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt2)" $fileId
			}
			if {$GPNPort4Cnt0(cnt2) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt2)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt2)" $fileId
			}
		}
		if {$etreeCnt == 2} {
			#NE1的接收	
			if {$GPNPort1Cnt2(cnt22) < $rateL || $GPNPort1Cnt2(cnt22) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送外层tag=800内层tag=500的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到外层tag=800内层tag=500的数据流的速率为$GPNPort1Cnt2(cnt22)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送外层tag=800内层tag=500的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到外层tag=800内层tag=500的数据流的速率为$GPNPort1Cnt2(cnt22)，在$rateL-$rateR\范围内" $fileId
			}
			if {$GPNPort1Cnt2(cnt32) < $rateL || $GPNPort1Cnt2(cnt32) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送外层tag=800内层tag=500的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到外层tag=800内层tag=500的数据流的速率为$GPNPort1Cnt2(cnt32)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送外层tag=800内层tag=500的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到外层tag=800内层tag=500的数据流的速率为$GPNPort1Cnt2(cnt32)，在$rateL-$rateR\范围内" $fileId
			}
			if {$GPNPort1Cnt2(cnt42) < $rateL || $GPNPort1Cnt2(cnt42) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送外层tag=800内层tag=500的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到外层tag=800内层tag=500的数据流的速率为$GPNPort1Cnt2(cnt42)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送外层tag=800内层tag=500的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到外层tag=800内层tag=500的数据流的速率为$GPNPort1Cnt2(cnt42)，在$rateL-$rateR\范围内" $fileId
			}
			#NE2的接收	
			if {$GPNPort2Cnt0(cnt1) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt1)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt1)" $fileId
			}
			if {$GPNPort2Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt13)" $fileId
			}
			if {$GPNPort2Cnt2(cnt10) < $rateL || $GPNPort2Cnt2(cnt10) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到外层tag=800内层tag=500的数据流的速率为$GPNPort2Cnt2(cnt10)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到外层tag=800内层tag=500的数据流的速率为$GPNPort2Cnt2(cnt10)，在$rateL-$rateR\范围内" $fileId
			}
			#NE3的接收	
			if {$GPNPort3Cnt0(cnt1) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
			}
			if {$GPNPort3Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt13)" $fileId
			}
			if {$GPNPort3Cnt2(cnt10) < $rateL || $GPNPort3Cnt2(cnt10) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到外层tag=800内层tag=500的数据流的速率为$GPNPort3Cnt2(cnt10)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到外层tag=800内层tag=500的数据流的速率为$GPNPort3Cnt2(cnt10)，在$rateL-$rateR\范围内" $fileId
			}
			#NE3的接收	
			if {$GPNPort4Cnt0(cnt1) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
			}
			if {$GPNPort4Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt13)" $fileId
			}
			if {$GPNPort4Cnt2(cnt10) < $rateL || $GPNPort4Cnt2(cnt10) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到外层tag=800内层tag=500的数据流的速率为$GPNPort4Cnt2(cnt10)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到外层tag=800内层tag=500的数据流的速率为$GPNPort4Cnt2(cnt10)，在$rateL-$rateR\范围内" $fileId
			}
		}
		if {$etreeCnt == 3} {
			#NE1的接收	
			if {$GPNPort1Cnt0(cnt53) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送外层tag=800内层tag=500的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt53)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE2($gpnIp2)$GPNTestEth2\发送外层tag=800内层tag=500的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt53)" $fileId
			}
			if {$GPNPort1Cnt0(cnt56) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送外层tag=800内层tag=500的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt56)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\发送外层tag=800内层tag=500的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt56)" $fileId
			}
			if {$GPNPort1Cnt0(cnt51) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送外层tag=800内层tag=500的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt51)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送外层tag=800内层tag=500的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt51)" $fileId
			}
			#NE2的接收	
			if {$GPNPort2Cnt0(cnt1) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt1)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt1)" $fileId
			}
			if {$GPNPort2Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt13)" $fileId
			}
			if {$GPNPort2Cnt0(cnt69) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt69)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt69)" $fileId
			}
			#NE3的接收	
			if {$GPNPort3Cnt0(cnt1) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
			}
			if {$GPNPort3Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt13)" $fileId
			}
			if {$GPNPort3Cnt0(cnt69) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt69)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt69)" $fileId
			}
			#NE4的接收	
			if {$GPNPort4Cnt0(cnt1) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
			}
			if {$GPNPort4Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt13)" $fileId
			}
			if {$GPNPort4Cnt0(cnt69) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt69)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送外层tag=800内层tag=500的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt69)" $fileId
			}
		}
		return $flag
	}
	
	###################################################################################
	#函数功能: case6的业务验证
	#f_broadcast  =1 禁止广播转发
	#f_mcast   =1 禁止组播转发
	#f_unknow  =1 禁止未知单播转发
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
		
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
		if {$f_broadcast == 1} {
			if {$GPNPort1Cnt0(cnt12) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt12)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt12)" $fileId
			}
			if {$GPNPort4Cnt0(cnt10) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt10)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt10)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt12) < $rateL0 || $GPNPort1Cnt1(cnt12) > $rateR0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt12)，没在$rateL0-$rateR0\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt12)，在$rateL0-$rateR0\范围内" $fileId
			}
			if {$GPNPort4Cnt1(cnt10) < $rateL0 || $GPNPort4Cnt1(cnt10) > $rateR0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt10)，没在$rateL0-$rateR0\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt10)，在$rateL0-$rateR0\范围内" $fileId
			}
		}
		if {$f_mcast == 1} {
			if {$GPNPort1Cnt0(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt13)" $fileId
			}
			if {$GPNPort4Cnt0(cnt11) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt11)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt11)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt13) < $rateL || $GPNPort1Cnt1(cnt13) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt13)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt13)，在$rateL-$rateR\范围内" $fileId
			}
			if {$GPNPort4Cnt1(cnt11) < $rateL || $GPNPort4Cnt1(cnt11) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt11)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt11)，在$rateL-$rateR\范围内" $fileId
			}
		}
		if {$f_unknow == 1} {
			if {$GPNPort1Cnt0(cnt68) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt68)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt68)" $fileId
			}
			if {$GPNPort4Cnt0(cnt50) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt50)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt50)" $fileId
			}
		} else {
			if {$GPNPort1Cnt1(cnt68) < $rateL || $GPNPort1Cnt1(cnt68) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt68)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=800的未知单播数据流，NE1($gpnIp1)\
					$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt68)，在$rateL-$rateR\范围内" $fileId
			}
			if {$GPNPort4Cnt1(cnt59) < $rateL || $GPNPort4Cnt1(cnt59) > $rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt59)，没在$rateL-$rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送tag=800的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt59)，在$rateL-$rateR\范围内" $fileId
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
	set lPortAttribute "$GPNStcPort1 \"media $GPNEth1Media\" $GPNStcPort2 \"media $GPNEth2Media\" $GPNStcPort3 \"media $GPNEth3Media\" \
		$GPNStcPort4 \"media $GPNEth4Media\" $GPNStcPort5 \"media $GPNEth5Media\" $GPNStcPort6 \"media $GPNEth6Media\""
	gwd::STC_cfgPortAttributeAndReservePort $fileId $hPtnProject $lPortAttribute hPortList hMediaList
	lassign $hPortList hGPNPort1 hGPNPort2 hGPNPort3 hGPNPort4 hGPNPort5 hGPNPort6
	
        ###创建测试流量
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
        gwd::Get_Generator $hGPNPort6 hGPNPort6Gen
        gwd::Get_Analyzer $hGPNPort6 hGPNPort6Ana
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
	
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort6 txInfoArr hGPNPort6TxInfo
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort6 rxInfoArr1 hGPNPort6RxInfo1
	gwd::Sub_TxAndRx_Info $hPtnProject $hGPNPort6 rxInfoArr2 hGPNPort6RxInfo2
        ###配置流的速率 10%，Mbps
        foreach stream "$hGPNPortStreamList $hGPNPortStreamList7 $hGPNPort1Stream30 $hGPNPortStreamList8" {
        	stc::config [stc::get $stream -AffiliationStreamBlockLoadProfile-targets] -load 100 -LoadUnit MEGABITS_PER_SECOND
        }
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList $hGPNPortStreamList7 $hGPNPort1Stream30 $hGPNPortStreamList8" \
		-activate "false"
        stc::apply 
        ###获取发生器配置指针
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
        ###创建并配置过滤器，默认过滤tag
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
                ###获取和配置capture对象相关的指针
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
	puts $fileId "===E-TREE功能验证 LSP PW交换测试基础配置开始...\n"
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
        set mslot2 [gwd::GWpulic_getWorkCardList $managePort2]
        gwd::GWpublic_print "OK" "获取设备NE2($gpnIp2)管理口所在板卡槽位号$mslot2" $fileId

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
	###二三层接口配置参数
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
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-TREE功能验证 LSP PW交换测试基础配置失败，测试结束" \
		"E-TREE功能验证 LSP PW交换测试基础配置成功，继续后面的测试" "GPN_PTN_010"
        puts $fileId ""
        puts $fileId "===E-TREE功能验证 LSP PW交换测试基础配置结束..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
        puts $fileId ""
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 单域、vplsType为raw模式、用户侧接入模式为端口模式验证ETREE业务\n"
        #   <1>四台76组网，组网拓扑见拓扑图7，NE1设备通过带外上网管,NE2和NE3、NE4设备通过带内上网管，或4台设备以DCN管理，四台设备彼此之间的NNI端口通过以太网接口形式相连，NNI端口以untag方式加入到VLANIF中
        #   <2>当NE1、NE4、NE3为PE角色，PE2既为PE又为P角色，NE1到NE3的tree业务经过NE2，此时NE2为p
        #   <3>创建根节点NE1的端口1到到叶子节点NE2/NE4/NE3的端口2/4/3的EP-Tree业务，用户侧（GE端口）接入模式为端口模式
        #      配置NE1到NE2的LSP入标签17，出标签17；PW1本地标签1000，远程标签1000；
        #      配置NE1到NE4的LSP入标签18，出标签18；PW1本地标签2000，远程标签2000；
        #      配置NE1到NE3的LSP入标签20，出标签21；PW1本地标签3000，远程标签3000；
        #      配置NE3到NE1的LSP入标签22，出标签23；PW1本地标签3000，远程标签3000；
        #      NE2设备上配置lsp的标签交换，NE2将LSP入标签21交换为出标签22；NE2将LSP入标签23交换为出标签20；
        #   <4>当NE1/NE2/NE3/NE4都为PE角色，NE1到NE3的tree业务经过NE2，此时NE2上的两条pw,与NE1连的为root角色，与NE3连的为none(叶子)角色
        #   <5>创建根节点NE1的端口1到到叶子节点NE2/NE4/NE3的端口2/4/3的EP-Tree业务，配置如下，无需标签交换
        #      配置NE1到NE2的LSP入标签17，出标签17；PW1本地标签1000，远程标签1000；
        #      配置NE1到NE4的LSP入标签18，出标签18；PW1本地标签2000，远程标签2000；
        #      配置NE2到NE3的LSP入标签20，出标签20；PW1本地标签3000，远程标签3000；
        #   <6>在用户侧端口下配置undo vlan check;
        #   预期结果:系统无异常，查看配置正确，发送业务数据流，业务正常转发；NE2/NE3/NE4三台设备变为带内管理均正常
        #单域E-Tree（ep-tree）业务验证 
        #      按上述的配置（ep-tree）
        #      NE1发送untag/tag的广播包，NE2/NE3/NE4设备的叶子端口都能收到；
        #      NE1发送untag/tag的组播包，NE2/NE3/NE4设备的叶子端口都能收到；
        #      NE1发送untag/tag的单播包，NE2/NE3/NE4设备的叶子端口都能收到；
        #      NE1、NE2的互发untag/tag已知单播，NE3、NE4设备叶子端口收不到数据；
        #      NE1、NE3的互发untag/tag已知单播，NE2、NE4设备叶子端口收不到数据；
        #      NE1、NE4的互发untag/tag已知单播，NE2、NE3设备叶子端口收不到数据；
        #   <7>NE2,NE4,NE3发送untag/tag的广播/单播/组播，
        #   预期结果：仅NE1能收到数据，其他叶子节点不能收到，叶子节点的叶子端口间不能互通；
        #             镜像NE1的NNI端口egress方向报文，为不带VLAN TAG标签的mpls标签报文，外层lsp标签17，内层pw标签1000,，
        #            LSP字段中的TTL值为255，PW字段中的TTL值为255，PW字段中含有4字节控制字
        #   <8>undo shutdown和shutdown NE1设备的NNI/UNI端口50次，每次操作后业务恢复正常，系统无异常 
        #   <9>重启NE1设备的NNI/UNI端口所在板卡50次，每次操作后业务恢复正常，系统无异常 
        #   <10>NE1设备进行SW/NMS倒换50次，每次操作后业务恢复正常，系统无异常 ，查看标签转发表项正确，三台设备管理正常
        #   <11>保存重启NE1设备的50次，每次操作后系统正常启动，业务恢复正常，系统无异常，查看标签转发表项正确，三台设备管理正常 
        #   <12>不删除域的情况下，删除NE1、NE2、NE3、NE4上的ac，查看配置ac删除成功,pw与域的绑定是不删除的，NE1与其他3台设备的业务中断，系统无异常
        #   <13>重新添加ac，查看配置添加成功，发送业务验证生效
	#   <14>删除NE1、NE2、NE3、NE4设备的汇聚业务（AC+vpls域），查看配置删除成功，ac和vpls域配置消失，业务中断，系统无异常
	#   <15>重新创建NE1、NE2、NE3、NE4上的汇聚业务（AC+vpls域）,承载伪线不做更改，将ac接入模式设为“端口+运营商VLAN”，即（evp-Tree业务）
        ########========vpls为raw模式测试==========#########
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1发送untag/tag的未知单播、广播、组播，测试业务  测试开始=====\n"
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
                ###二三层接口配置参数
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
                ###配置undo vlan check
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
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE2接收
	if {$GPNPort2Cnt0(cnt10) < $rateL || $GPNPort2Cnt0(cnt10) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt0(cnt10)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt0(cnt10)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt0(cnt6) < $rateL || $GPNPort2Cnt0(cnt6) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的组播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt0(cnt6)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的组播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt0(cnt6)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt1(cnt2) < $rateL || $GPNPort2Cnt1(cnt2) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt1(cnt11) < $rateL || $GPNPort2Cnt1(cnt11) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt11)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt11)，在$rateL-$rateR\范围内" $fileId
	}
	#NE3接收
	if {$GPNPort3Cnt0(cnt10) < $rateL || $GPNPort3Cnt0(cnt10) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到untag的数据流的速率为$GPNPort3Cnt0(cnt10)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到untag的数据流的速率为$GPNPort3Cnt0(cnt10)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt0(cnt6) < $rateL || $GPNPort3Cnt0(cnt6) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的组播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到untag的数据流的速率为$GPNPort3Cnt0(cnt6)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的组播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到untag的数据流的速率为$GPNPort3Cnt0(cnt6)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt1(cnt2) < $rateL || $GPNPort3Cnt1(cnt2) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt1(cnt11) < $rateL || $GPNPort3Cnt1(cnt11) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt11)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt11)，在$rateL-$rateR\范围内" $fileId
	}
	#NE4接收
	if {$GPNPort4Cnt0(cnt10) < $rateL || $GPNPort4Cnt0(cnt10) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt0(cnt10)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt0(cnt10)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt0(cnt6) < $rateL || $GPNPort4Cnt0(cnt6) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的组播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt0(cnt6)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的组播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt0(cnt6)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt1(cnt2) < $rateL || $GPNPort4Cnt1(cnt2) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=500的数据流的速率为$GPNPort4Cnt1(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=500的数据流的速率为$GPNPort4Cnt1(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt1(cnt11) < $rateL || $GPNPort4Cnt1(cnt11) > $rateR} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt11)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=800的组播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt11)，在$rateL-$rateR\范围内" $fileId
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	if {$GPNPort2Cnt0(cnt5) < $rateL0 || $GPNPort2Cnt0(cnt5) > $rateR0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的广播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt0(cnt5)，没在$rateL0-$rateR0\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的广播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt0(cnt5)，在$rateL0-$rateR0\范围内" $fileId
	}
	if {$GPNPort3Cnt0(cnt5) < $rateL0 || $GPNPort3Cnt0(cnt5) > $rateR0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的广播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到untag的数据流的速率为$GPNPort3Cnt0(cnt5)，没在$rateL0-$rateR0\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的广播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到untag的数据流的速率为$GPNPort3Cnt0(cnt5)，在$rateL0-$rateR0\范围内" $fileId
	}
	if {$GPNPort4Cnt0(cnt5) < $rateL0 || $GPNPort4Cnt0(cnt5) > $rateR0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的广播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt0(cnt5)，没在$rateL0-$rateR0\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的广播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt0(cnt5)，在$rateL0-$rateR0\范围内" $fileId
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
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	
	if {$GPNPort2Cnt1(cnt10) < $rateL0 || $GPNPort2Cnt1(cnt10) > $rateR0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt10)，没在$rateL0-$rateR0\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt10)，在$rateL0-$rateR0\范围内" $fileId
	}
	if {$GPNPort3Cnt1(cnt10) < $rateL0 || $GPNPort3Cnt1(cnt10) > $rateR0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt10)，没在$rateL0-$rateR0\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt10)，在$rateL0-$rateR0\范围内" $fileId
	}
	if {$GPNPort4Cnt1(cnt10) < $rateL0 || $GPNPort4Cnt1(cnt10) > $rateR0} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt10)，没在$rateL0-$rateR0\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=800的广播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt10)，在$rateL0-$rateR0\范围内" $fileId
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1发送untag/tag的未知单播、广播、组播，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1发送untag/tag的未知单播、广播、组播，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1发送untag/tag的未知单播、广播、组播，测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1与NE2/NE3/NE4 互发vid=500的已知单播，测试业务  测试开始=====\n"
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
		gwd::GWpublic_print "NOK" "FA2（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1与NE2/NE3/NE4 互发vid=500的已知单播，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1与NE2/NE3/NE4 互发vid=500的已知单播，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1与NE2/NE3/NE4 互发vid=500的已知单播，测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE2、NE3、NE4 发送untag/tag的数据流，测试业务  测试开始=====\n"
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
	
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE1的接收
	if {$GPNPort1Cnt1(cnt22) < $rateL || $GPNPort1Cnt1(cnt22) > $rateR} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\发送tag=500的单播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt22)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\发送tag=500的单播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt22)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt1(cnt10) < $rateL0 || $GPNPort1Cnt1(cnt10) > $rateR0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\发送tag=800的广播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt10)，没在$rateL0-$rateR0\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\发送tag=800的广播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt10)，在$rateL0-$rateR0\范围内" $fileId
	}
	if {$GPNPort1Cnt1(cnt11) < $rateL || $GPNPort1Cnt1(cnt11) > $rateR} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\发送tag=800的组播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt11)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\发送tag=800的组播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt11)，在$rateL-$rateR\范围内" $fileId
	}
	#NE3的接收
	if {$GPNPort3Cnt0(cnt02) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\发送tag=500的单播流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt02)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\发送tag=500的单播流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt02)" $fileId
	}
	if {$GPNPort3Cnt0(cnt10) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\发送tag=800的广播流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt10)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\发送tag=800的广播流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt10)" $fileId
	}
	if {$GPNPort3Cnt0(cnt11) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\发送tag=800的组播流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt11)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\发送tag=800的组播流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt11)" $fileId
	}
	if {$GPNPort4Cnt0(cnt02) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\发送tag=500的单播流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt02)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\发送tag=500的单播流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt02)" $fileId
	}
	if {$GPNPort4Cnt0(cnt10) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\发送tag=800的广播流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt10)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\发送tag=800的广播流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt10)" $fileId
	}
	if {$GPNPort4Cnt0(cnt11) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\发送tag=800的组播流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt11)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\发送tag=800的组播流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt11)" $fileId
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
	
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE1的接收
	if {$GPNPort1Cnt1(cnt33) < $rateL || $GPNPort1Cnt1(cnt33) > $rateR} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\发送tag=500的单播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt33)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\发送tag=500的单播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt33)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt7(cnt5) < $rateL0 || $GPNPort1Cnt7(cnt5) > $rateR0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\发送untag的广播流，NE1($gpnIp1)\
			$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt5)，没在$rateL0-$rateR0\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\发送untag的广播流，NE1($gpnIp1)\
			$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt5)，在$rateL0-$rateR0\范围内" $fileId
	}
	if {$GPNPort1Cnt7(cnt6) < $rateL || $GPNPort1Cnt7(cnt6) > $rateR} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\发送untag的组播流，NE1($gpnIp1)\
			$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt6)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\发送untag的组播流，NE1($gpnIp1)\
			$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt6)，在$rateL-$rateR\范围内" $fileId
	}
	#NE2的接收
	if {$GPNPort2Cnt0(cnt03) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\发送tag=500的单播流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt03)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\发送tag=500的单播流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt03)" $fileId
	}
	if {$GPNPort2Cnt0(cnt5) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\发送untag的广播流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt5)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\发送untag的广播流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt5)" $fileId
	}
	if {$GPNPort2Cnt0(cnt6) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\发送untag的组播流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt6)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\发送untag的组播流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt6)" $fileId
	}
	#NE4的接收
	if {$GPNPort4Cnt0(cnt03) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\发送tag=500的单播流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt03)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\发送tag=500的单播流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt03)" $fileId
	}
	if {$GPNPort4Cnt0(cnt5) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\发送untag的广播流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt5)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\发送untag的广播流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt5)" $fileId
	}
	if {$GPNPort4Cnt0(cnt6) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\发送untag的组播流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt6)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\发送untag的组播流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt6)" $fileId
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
	
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE1的接收
	if {$GPNPort1Cnt1(cnt44) < $rateL || $GPNPort1Cnt1(cnt44) > $rateR} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送tag=500的单播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt44)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送tag=500的单播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt44)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt1(cnt12) < $rateL0 || $GPNPort1Cnt1(cnt12) > $rateR0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt12)，没在$rateL0-$rateR0\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt12)，在$rateL0-$rateR0\范围内" $fileId
	}
	if {$GPNPort1Cnt1(cnt13) < $rateL || $GPNPort1Cnt1(cnt13) > $rateR} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt13)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt13)，在$rateL-$rateR\范围内" $fileId
	}
	#NE2的接收
	if {$GPNPort2Cnt0(cnt04) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送tag=500的单播流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt04)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送tag=500的单播流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt04)" $fileId
	}
	if {$GPNPort2Cnt0(cnt12) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt12)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt12)" $fileId
	}
	if {$GPNPort2Cnt0(cnt13) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt13)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt13)" $fileId
	}
	#NE3的接收
	if {$GPNPort3Cnt0(cnt04) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送tag=500的单播流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt04)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送tag=500的单播流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt04)" $fileId
	}
	if {$GPNPort3Cnt0(cnt12) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt12)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送tag=800的广播流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt12)" $fileId
	}
	if {$GPNPort3Cnt0(cnt13) != 0} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt13)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送tag=800的组播流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt13)" $fileId
	}
	
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE2、NE3、NE4 发送untag/tag的数据流，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE2、NE3、NE4 发送untag/tag的数据流，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE2、NE3、NE4 发送untag/tag的数据流，测试业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，镜像NE1($gpnIp1)到NE2($gpnIp2)、NE4($gpnIp4)的NNI出口方向报文测试MPLS标签  测试开始=====\n"
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	if {$GPNPort5Cnt2(cnt10) < $rateL1 || $GPNPort5Cnt2(cnt10) > $rateR1} {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)和NE2($gpnIp2)互相发送tag=500的已知单播数据流，NE1($gpnIp1)$GPNTestEth5口镜像NNI口$GPNPort5\
			的出口收到的mpls报文的lsp标签=17、pw标签=1000的数据流速率为$GPNPort5Cnt2(cnt10)，没在$::rateL1-$::rateR1\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)和NE2($gpnIp2)互相发送tag=500的已知单播数据流，NE1($gpnIp1)$GPNTestEth5口镜像NNI口$GPNPort5\
			的出口收到的mpls报文的lsp标签=17、pw标签=1000的数据流速率为$GPNPort5Cnt2(cnt10)，在$::rateL1-$::rateR1\范围内" $fileId
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	if {$GPNPort5Cnt20(cnt12) < $rateL1 || $GPNPort5Cnt20(cnt12) > $rateR1} {
		set flag4_case1 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)和NE4($gpnIp4)互相发送tag=500的已知单播数据流，NE1($gpnIp1)$GPNTestEth5口镜像NNI口$GPNPort12\
			的出口收到的mpls报文的lsp标签=18、pw标签=2000的数据流速率为$GPNPort5Cnt20(cnt12)，没在$rateL1-$rateR1\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)和NE4($gpnIp4)互相发送tag=500的已知单播数据流，NE1($gpnIp1)$GPNTestEth5口镜像NNI口$GPNPort12\
			的出口收到的mpls报文的lsp标签=18、pw标签=2000的数据流速率为$GPNPort5Cnt20(cnt12)，在$rateL1-$rateR1\范围内" $fileId
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA4（结论）镜像NE1($gpnIp1)到NE2($gpnIp2)、NE4($gpnIp4)的NNI出口方向报文测试MPLS标签" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4（结论）镜像NE1($gpnIp1)到NE2($gpnIp2)、NE4($gpnIp4)的NNI出口方向报文测试MPLS标签" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，镜像NE1($gpnIp1)到NE2($gpnIp2)、NE4($gpnIp4)的NNI出口方向报文测试MPLS标签  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复shut undoshut NNI口后测试业务恢复和系统内存  测试开始=====\n"
	gwd::GWpublic_DelPortMirror $telnet1 $matchType1 $Gpn_type1 $fileId $GPNTestEth5
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPort1Stream2 $hGPNPort2Stream9 $hGPNPort1Stream4 $hGPNPort4Stream11" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList2" \
		-activate "true"
	##反复undo shutdown/shutdown端口
	foreach eth $portlist1 {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
		for {set j 1} {$j<=$cnt} {incr j} {
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
			after $WaiteTime
			incr capId
			if {[TestRepeat_case1 $fileId "第$j\次shutdown/undo shutdown NE1($gpnIp1)的$eth\端口后" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
				set  flag5_case1 1
			}
			
		}
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag5_case1 1
			gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA5（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复shut undoshut NNI口后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复shut undoshut NNI口后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复shut undoshut NNI口后测试业务恢复和系统内存  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存  测试开始=====\n" 
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
				if {[TestRepeat_case1 $fileId "第$j\次重启NE1($gpnIp1)$slot\槽位板卡" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
					set  flag6_case1 1
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
				set flag6_case1 1
				gwd::GWpublic_print "NOK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
			} else {
				gwd::GWpublic_print "OK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
			}
		}
	}
	puts $fileId ""
	if {$flag6_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA6（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存  测试开始=====\n" 
	set expectTable "0000.0000.0002 ac1 0000.0000.0003 ac1 0000.0000.0004 ac1 0000.0000.0022 pw12 0000.0000.0033 pw13 0000.0000.0044 pw14"
	###反复进行NMS主备倒换
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
        for {set j 1} {$j<$cntdh} {incr j} {
                if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
                	  after $rebootTime
                	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
                	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
                	if {[TestRepeat_case1 $fileId "第$j\次 NE1($gpnIp1)进行NMS主备倒换后" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
                		set  flag7_case1 1
                	}
                	gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
                	if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行NMS主备倒换后" $dTable $expectTable]} {
                		set flag7_case1 1
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
        	set flag7_case1	1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
        }
        }
        puts $fileId ""
        if {$flag7_case1 == 1} {
        set flagCase1 1
         gwd::GWpublic_print "NOK" "FA7（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
        } else {
        gwd::GWpublic_print "OK" "FA7（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存  测试开始=====\n" 
	##反复进行SW主备倒换
	set testFlag 0 ;#=1 测试跳过
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestRepeat_case1 $fileId "第$j\次 NE1($gpnIp1)进行SW主备倒换" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
				set  flag8_case1 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行SW主备倒换后" $dTable $expectTable]} {
				set flag8_case1 1
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
			set flag8_case1	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag8_case1 == 1} {
		set flagCase1 1
		 gwd::GWpublic_print "NOK" "FA8（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存  测试开始=====\n" 
	##反复保存设备重启
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[TestRepeat_case1 $fileId "第$j\次 NE1($gpnIp1)进行保存设备重启后" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
			set  flag9_case1 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
		if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行保存设备重启后" $dTable $expectTable]} {
			set flag9_case1 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag9_case1	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag9_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA9（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除各设备AC的配置，测试业务是否中断  测试开始=====\n" 
	foreach telnet $lSpawn_id Gpn_type $lDutType matchType $lMatchType {
		gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac1"
	}
	incr capId
	if {[TestRepeat_case1 $fileId "删除各设备AC的配置后" "GPN_PTN_010_$capId" $rateL $rateR 0]} {
		set  flag10_case1 1
	}
	puts $fileId ""
	if {$flag10_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB1（结论）删除各设备AC的配置，业务没有中断" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1（结论）删除各设备AC的配置，业务中断" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除各设备AC的配置，测试业务是否中断  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====重新添加各设备AC的配置，测试业务  测试开始=====\n" 
	#重新添加ac
	set id2 1
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 role $RoleList matchType $lMatchType {
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac1" "vpls$id2" "" $eth "0" "0" $role "delete" "1" "0" "0" "0x8100" "evc2"
		incr id2
	}
	incr capId
	if {[TestRepeat_case1 $fileId "重新添加各设备AC的配置后" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
		set  flag11_case1 1
	}
	puts $fileId ""
	if {$flag11_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FB2（结论）重新添加各设备AC的配置，测试业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2（结论）重新添加各设备AC的配置，测试业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====重新添加各设备AC的配置，测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
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
	puts $fileId "Test Case 1 单域、vplsType为raw模式、用户侧接入模式为端口模式验证ETREE业务  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 单域、vplsType为raw模式、用户侧接入模式为”端口+运营商VLAN”验证ETREE业务\n"
        #单域E-Tree（evp-tree）业务验证 
        #   <16>在NE1、NE2、NE3、NE4上均创建所需的VLAN（vlan 100），并加入端口，再次创建接入模式为“端口+运营商VLAN”的汇聚业务，成功创建，系统无异常
        #   <17>向NE1的端口1发送tag100、tag200业务流，NE2、NE3、NE4的叶子端口只可接收tag100业务流；NE1与NE2、NE3、NE4互发vlan100的双向发流业务正常
        #   <18>NE2、NE3、NE4发vlan100的单向流，只有NE1可以收到，叶子节点的叶子端口间不能互通
        #   <19>重复步骤8-11
        #   <20>将UNI端口更改为FE/10GE端口，其他条件不变，重复以上步  注：使用FE端口配置汇聚业务时，需开启该板卡的MPLS业务模式（命令为：mpls enable <slot>）
	
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0
	set flag5_case2 0
	set flag6_case2 0
	set flag7_case2 0
	set flag8_case2 0
	##配置ac为“端口+vlan”模式（即EVP-TREE）
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，未使能overlay功能前发送MPLS报文验证业务=====\n" 
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList2" \
		-activate "false"
	stc::perform streamBlockActivate \
		-streamBlockList "$hGPNPortStreamList6" \
		-activate "true"
        set vpls 1
        foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 role $RoleList matchType $lMatchType {
                ###配置vlan check
                if {[string match "L2" $Worklevel]} {
                	gwd::GWpublic_CfgVlanCheck $telnet $matchType $Gpn_type $fileId $eth "enable"
                }
                ##删除ac
                gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac1"
                ##用户侧加入vlan
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	if {$GPNPort1Cnt1(cnt112) < $rateL || $GPNPort1Cnt1(cnt112) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=100的mpls数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=100数据流的速率应为$GPNPort1Cnt1(cnt112)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=100的mpls数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=100数据流的速率应为$GPNPort1Cnt1(cnt112)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt1(cnt114) < $rateL || $GPNPort1Cnt1(cnt114) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=100的mpls数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=100数据流的速率为$GPNPort1Cnt1(cnt114)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=100的mpls数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=100数据流的速率为$GPNPort1Cnt1(cnt114)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt1(cnt111) < $rateL || $GPNPort2Cnt1(cnt111) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=100的mpls数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=100数据流的速率为$GPNPort2Cnt1(cnt111)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=100的mpls数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=100数据流的速率为$GPNPort2Cnt1(cnt111)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt0(cnt104) !=0} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE4和NE2的AC都是leaf，NE4($gpnIp4)$GPNTestEth4\发送tag=100的mpls数据流，\
			NE2($gpnIp2)$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt104)" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE4和NE2的AC都是leaf，NE4($gpnIp4)$GPNTestEth4\发送tag=100的mpls数据流，\
			NE2($gpnIp2)$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt104)" $fileId
	}
	if {$GPNPort4Cnt1(cnt111) < $rateL || $GPNPort4Cnt1(cnt111) > $rateR} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=100的mpls数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=100数据流的速率为$GPNPort4Cnt1(cnt111)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=100的mpls数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=100数据流的速率为$GPNPort4Cnt1(cnt111)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt0(cnt102) !=0} {
		set flag1_case2 1
		gwd::GWpublic_print "NOK" "未使能overlay时，NE4和NE2的AC都是leaf，NE2($gpnIp2)$GPNTestEth2\发送tag=100的mpls数据流，\
			NE4($gpnIp4)$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt102)" $fileId
	} else {
		gwd::GWpublic_print "OK" "未使能overlay时，NE4和NE2的AC都是leaf，NE2($gpnIp2)$GPNTestEth2\发送tag=100的mpls数据流，\
			NE4($gpnIp4)$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt102)" $fileId
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB3（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，未使能overlay功能前发送MPLS报文验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，未使能overlay功能前发送MPLS报文验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，未使能overlay功能前发送MPLS报文验证业务  测试结束=====\n"
	incr $tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，使能overlay功能后发送MPLS报文验证业务  测试开始=====\n"
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
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为GPN_PTN_010_$capId-p$GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
        if {$GPNPort1Cnt1(cnt112) < $rateL || $GPNPort1Cnt1(cnt112) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=100的mpls数据流，NE1($gpnIp1)\
        		$GPNTestEth1\收到tag=100数据流的速率应为$GPNPort1Cnt1(cnt112)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE2($gpnIp2)$GPNTestEth2\发送tag=100的mpls数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=100数据流的速率应为$GPNPort1Cnt1(cnt112)，在$rateL-$rateR\范围内" $fileId
        }
        if {$GPNPort1Cnt1(cnt114) < $rateL || $GPNPort1Cnt1(cnt114) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=100的mpls数据流，NE1($gpnIp1)\
        		$GPNTestEth1\收到tag=100数据流的速率为$GPNPort1Cnt1(cnt114)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE4($gpnIp4)$GPNTestEth4\发送tag=100的mpls数据流，NE1($gpnIp1)\
        		$GPNTestEth1\收到tag=100数据流的速率为$GPNPort1Cnt1(cnt114)，在$rateL-$rateR\范围内" $fileId
        }
        if {$GPNPort2Cnt1(cnt111) < $rateL || $GPNPort2Cnt1(cnt111) > $rateR} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=100的mpls数据流，NE2($gpnIp2)\
        		$GPNTestEth2\收到tag=100数据流的速率为$GPNPort2Cnt1(cnt111)，没在$rateL-$rateR\范围内" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=100的mpls数据流，NE2($gpnIp2)\
        		$GPNTestEth2\收到tag=100数据流的速率为$GPNPort2Cnt1(cnt111)，在$rateL-$rateR\范围内" $fileId
        }
        if {$GPNPort2Cnt0(cnt104) !=0} {
        	set flag2_case2 1
        	gwd::GWpublic_print "NOK" "使能overlay时，NE4和NE2的AC都是leaf，NE4($gpnIp4)$GPNTestEth4\发送tag=100的mpls数据流，\
        		NE2($gpnIp2)$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt104)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "使能overlay时，NE4和NE2的AC都是leaf，NE4($gpnIp4)$GPNTestEth4\发送tag=100的mpls数据流，\
        		NE2($gpnIp2)$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt104)" $fileId
        }
	if {$GPNPort4Cnt1(cnt111) < $rateL || $GPNPort4Cnt1(cnt111) > $rateR} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=100的mpls数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=100数据流的速率为$GPNPort4Cnt1(cnt111)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "使能overlay时，NE1($gpnIp1)$GPNTestEth1\发送tag=100的mpls数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=100数据流的速率为$GPNPort4Cnt1(cnt111)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt0(cnt102) !=0} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "使能overlay时，NE4和NE2的AC都是leaf，NE2($gpnIp2)$GPNTestEth2\发送tag=100的mpls数据流，\
			NE4($gpnIp4)$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt102)" $fileId
	} else {
		gwd::GWpublic_print "OK" "使能overlay时，NE4和NE2的AC都是leaf，NE2($gpnIp2)$GPNTestEth2\发送tag=100的mpls数据流，\
			NE4($gpnIp4)$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt102)" $fileId
	}
        puts $fileId ""
        if {$flag2_case2 == 1} {
        	set flagCase2 1
        	gwd::GWpublic_print "NOK" "FB4（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，使能overlay功能后发送MPLS报文验证业务" $fileId
        } else {
        	gwd::GWpublic_print "OK" "FB4（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，使能overlay功能后发送MPLS报文验证业务" $fileId
        }
        puts $fileId ""
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，使能overlay功能后发送MPLS报文验证业务  测试结束=====\n"
        gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
        incr cfgId
        lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
        if {$lFailFileTmp != ""} {
        	set lFailFile [concat $lFailFile $lFailFileTmp]
        }
        puts $fileId "======================================================================================\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，验证业务  测试开始=====\n" 
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
		gwd::GWpublic_print "NOK" "FB5（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，验证业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n" 
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复shut undoshut NNI 口后测试业务恢复和系统内存  测试开始=====\n"
	##反复undo shutdown/shutdown端口
	foreach eth $portlist1 {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
		for {set j 1} {$j<=$cnt} {incr j} {
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
			  after $WaiteTime
			incr capId
			if {[TestRepeat_case2Andcase9 1 $fileId "第$j\次shutdown/undo shutdown NE1($gpnIp1)的$eth\端口后" "GPN_PTN_010_$capId" $rateL $rateR]} {
				set  flag4_case2 1
			}
		}
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag4_case2 1
			gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		 gwd::GWpublic_print "NOK" "FB6（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复shut undoshut NNI 口后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复shut undoshut NNI 口后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复shut undoshut NNI 口后测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存  测试开始=====\n" 
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
				if {[TestRepeat_case2Andcase9 1 $fileId "第$j\次重启NE1($gpnIp1)$slot\槽位板卡" "GPN_PTN_010_$capId" $rateL $rateR]} {
					set  flag5_case2 1
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
				set flag5_case2 1
				gwd::GWpublic_print "NOK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
			} else {
				gwd::GWpublic_print "OK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
			}
		}
	}
	puts $fileId ""
	if {$flag5_case2 == 1} {
		set flagCase2 1
		 gwd::GWpublic_print "NOK" "FB7（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存  测试开始=====\n" 
	set expectTable "0000.0000.000C ac100 0000.0000.00F2 pw12 0000.0000.00F3 pw13 0000.0000.00F4 pw14"
	###反复进行NMS主备倒换
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestRepeat_case2Andcase9 1 $fileId "第$j\次 NE1($gpnIp1)进行NMS主备倒换后" "GPN_PTN_010_$capId" $rateL $rateR]} {
				set  flag6_case2 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行NMS主备倒换后" $dTable $expectTable]} {
				set flag6_case2 1
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
		set flag6_case2	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
	}
	}
	puts $fileId ""
	if {$flag6_case2 == 1} {
	set flagCase2 1
	 gwd::GWpublic_print "NOK" "FB8（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	} else {
	gwd::GWpublic_print "OK" "FB8（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存  测试开始=====\n" 
	##反复进行SW主备倒换
	set testFlag 0 ;#=1 测试跳过
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestRepeat_case2Andcase9 1 $fileId "第$j\次 NE1($gpnIp1)进行SW主备倒换" "GPN_PTN_010_$capId" $rateL $rateR]} {
				set  flag7_case2 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行SW主备倒换后" $dTable $expectTable]} {
				set flag7_case2 1
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
			set flag7_case2	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag7_case2 == 1} {
		set flagCase2 1
		 gwd::GWpublic_print "NOK" "FB9（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存  测试开始=====\n" 
	##反复保存设备重启
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[TestRepeat_case2Andcase9 1 $fileId "第$j\次 NE1($gpnIp1)进行保存设备重启后" "GPN_PTN_010_$capId" $rateL $rateR]} {
			set  flag8_case2 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
		if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行保存设备重启后" $dTable $expectTable]} {
			set flag8_case2 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag8_case2	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag8_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FC1（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
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
	puts $fileId "Test Case 2 单域、vplsType为raw模式、用户侧接入模式为”端口+运营商VLAN”验证ETREE业务  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 单域、vplsType为tagged模式、接入模式改为“端口和端口+运营商VLAN”两种模式验证ETREE业务\n"
	set flag1_case3 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root、NE2-NE4的AC是leaf、AC为port和port+vlan两种、vplsType为tagged，测试ETREE业务  测试开始=====\n"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
        gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"
        gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
        
	set vpls 1
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 matchType $lMatchType {
                ##删除ac
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_$capId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_$capId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_$capId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_$capId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE1接收
	if {$GPNPort1Cnt1(cnt15) < $rateL || $GPNPort1Cnt1(cnt15) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\发送tag=100的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=100的数据流的速率为$GPNPort1Cnt1(cnt15)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\发送tag=100的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=100的数据流的速率为$GPNPort1Cnt1(cnt15)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt7(cnt31) < $rateL || $GPNPort1Cnt7(cnt31) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\发送tag=100的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt31)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\发送tag=100的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt31)，，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt7(cnt42) < $rateL || $GPNPort1Cnt7(cnt42) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt42)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到untag的数据流的速率为$GPNPort1Cnt7(cnt42)，在$rateL-$rateR\范围内" $fileId
	}
	#NE2接收	
	if {$GPNPort2Cnt7(cnt10) < $rateL || $GPNPort2Cnt7(cnt10) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt7(cnt10)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt7(cnt10)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt1(cnt2) < $rateL || $GPNPort2Cnt1(cnt2) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt1(cnt14) < $rateL || $GPNPort2Cnt1(cnt14) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=100的数据流的速率为$GPNPort2Cnt1(cnt14)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=100的数据流的速率为$GPNPort2Cnt1(cnt14)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt0(cnt16) != 0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\发送tag=100的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt16)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\发送tag=100的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt16)" $fileId
	}
	if {$GPNPort2Cnt0(cnt58) != 0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt58)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt58)" $fileId
	}
	#NE3接收	
	if {$GPNPort3Cnt1(cnt67) < $rateL || $GPNPort3Cnt1(cnt67) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=100的数据流的速率为$GPNPort3Cnt1(cnt67)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=100的数据流的速率为$GPNPort3Cnt1(cnt67)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt2(cnt18) < $rateL || $GPNPort3Cnt2(cnt18) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到外层tag=100内层tag=500的数据流的速率为$GPNPort3Cnt2(cnt18)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到外层tag=100内层tag=500的数据流的速率为$GPNPort3Cnt2(cnt18)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt2(cnt19) < $rateL || $GPNPort3Cnt2(cnt19) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到外层tag=100内层tag=100的数据流的速率为$GPNPort3Cnt2(cnt19)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到外层tag=100内层tag=100的数据流的速率为$GPNPort3Cnt2(cnt19)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt0(cnt14) != 0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt14)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt14)" $fileId
	}
	if {$GPNPort3Cnt0(cnt58) != 0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt58)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt58)" $fileId
	}
	#NE4接收	
	if {$GPNPort4Cnt1(cnt67) < $rateL || $GPNPort4Cnt1(cnt67) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=100的数据流的速率为$GPNPort4Cnt1(cnt67)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=100的数据流的速率为$GPNPort4Cnt1(cnt67)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt2(cnt18) < $rateL || $GPNPort4Cnt2(cnt18) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到外层tag=100内层tag=500的数据流的速率为$GPNPort4Cnt2(cnt18)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=500的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到外层tag=100内层tag=500的数据流的速率为$GPNPort4Cnt2(cnt18)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt2(cnt19) < $rateL || $GPNPort4Cnt2(cnt19) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到外层tag=100内层tag=100的数据流的速率为$GPNPort4Cnt2(cnt19)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到外层tag=100内层tag=100的数据流的速率为$GPNPort4Cnt2(cnt19)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt0(cnt14) != 0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)$GPNTestEth2\发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt14)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)$GPNTestEth2\发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt14)" $fileId
	}
	if {$GPNPort4Cnt0(cnt16) != 0} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt16)" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt16)" $fileId
	}
	puts $fileId ""
	if {$flag1_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FC2（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port和port+vlan两种、vplsType为tagged，测试ETREE业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port和port+vlan两种、vplsType为tagged，测试ETREE业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root、NE2-NE4的AC是leaf、AC为port和port+vlan两种、vplsType为tagged，测试ETREE业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
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
	puts $fileId "Test Case 3 单域、vplsType为tagged模式、接入模式改为“端口和端口+运营商VLAN”两种模式验证ETREE业务  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 E-TREE业务功能，单域E-Tree（evp-tree）业务标签交换验证测试\n"	
	#   <1>按上述拓扑及配置，NE2为NE1及NE3间的P节点；NE1到NE3的LSP入标签20，出标签21；
	#      NE3到NE1的LSP入标签22，出标签23；NE2将LSP入标签21交换为出标签22；NE2将LSP入标签23交换为出标签20；
	#   <2>NE1与NE3对发tag100的已知单播，业务正常；镜像NE2与NE1相连的NNI入端口的流，为不带tag标签的mpls流，lsp标签为21，TTL值为255，pw标签3000，PW的TTL值为255；
	#      镜像NE2与NE3相连的NNI出端口的流，为不带tag标签的mpls流，lsp标签为22，TTL值为254，pw标签3000，PW的TTL值为255；证明NE2将NE1到NE3方向的lsp标签进行了正确的交换
	#      镜像NE2与NE1相连的NNI出端口的流，为不带tag标签的mpls流，lsp标签为20，TTL值为254，pw标签3000，PW的TTL值为255；
	#      镜像NE2与NE3相连的NNI入端口的流，为不带tag标签的mpls流，lsp标签为23，TTL值为255，pw标签3000，PW的TTL值为255；证明NE2将NE3到NE1方向的lsp标签进行了正确的交换
	#   <3>undo shutdown和shutdown NE2设备的NNI/UNI端口10次，标签交换正常，业务恢复正常，系统无异常 
	#   <4>重启NE2设备的NNI/UNI端口所在板卡10次，标签交换正常，业务恢复正常，系统无异常 
	#   <5>NE2设备进行SW/NMS倒换10次，标签交换正常，业务恢复正常，系统无异常 
	#   <6>保存重启NE2设备的10次，系统正常启动，标签交换正常，业务恢复正常，系统无异常 
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set flag5_case4 0
	set flag6_case4 0
	set flag7_case4 0
	
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，验证ETREE业务  测试开始=====\n" 
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
        gwd::GWStaPw_DelPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw21"
        gwd::GWStaPw_DelPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw31"
        gwd::GWStaPw_DelPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw41"
        
        set vpls 1
        foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 role $RoleList matchType $lMatchType {
                ##删除ac
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
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_$capId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_$capId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_$capId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_$capId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	#NE1接收
	if {$GPNPort1Cnt1(cnt21) < $rateL || $GPNPort1Cnt1(cnt21) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE3($gpnIp3)$GPNTestEth3\发送tag=100的已知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=100的数据流的速率为$GPNPort1Cnt1(cnt21)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($gpnIp3)$GPNTestEth3\发送tag=100的已知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=100的数据流的速率为$GPNPort1Cnt1(cnt21)，在$rateL-$rateR\范围内" $fileId
	}
	#NE3接收
	if {$GPNPort3Cnt1(cnt14) < $rateL || $GPNPort3Cnt1(cnt14) > $rateR} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100的已知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=100的数据流的速率为$GPNPort3Cnt1(cnt14)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100的已知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=100的数据流的速率为$GPNPort3Cnt1(cnt14)，在$rateL-$rateR\范围内" $fileId
	}
	puts $fileId ""
	if {$flag1_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC3（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，验证ETREE业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，验证ETREE业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，验证ETREE业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，测试MPLS标签  测试开始=====\n"
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
		gwd::GWpublic_print "NOK" "FC4（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，测试MPLS标签" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，测试MPLS标签" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，测试MPLS标签  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复shutdown/undo shutdown NNI口测试MPLS标签和系统内存  测试开始=====\n"
	foreach eth $portlist2 {
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource1
		for {set j 1} {$j<=$cnt} {incr j} {
			 gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $eth "shutdown"
			 gwd::GWpublic_CfgPortState $telnet2 $matchType2 $Gpn_type2 $fileId $eth "undo shutdown"
			   after $WaiteTime
			 if {[PTN_EVP_LabelSwithRepeat "第$j\次shutdown/undo shutdown NE2($gpnIp2)的$eth\端口后"]} {
				 set  flag3_case4 1
			 }
		}
		gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag3_case4 1
			gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown NE2($gpnIp2)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "反复shutdown/undo shutdown NE2($gpnIp2)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag3_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC5（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复shutdown/undo shutdown NNI口测试MPLS标签和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复shutdown/undo shutdown NNI口测试MPLS标签和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复shutdown/undo shutdown NNI口测试MPLS标签和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复重启NNI口所在板卡后测试MPLS标签和系统内存  测试开始=====\n"
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
        			if {[PTN_EVP_LabelSwithRepeat "第$j\次重启NE2($gpnIp2)$slot\槽位板卡"]} {
        			      set  flag4_case4 1
        			}
		      } else {
			      set testFlag 1
			      gwd::GWpublic_print "OK" " NE2($gpnIp2)$slot\槽位板卡不支持板卡重启操作，测试跳过" $fileId
			      break
		      }
		}
	      	if {$testFlag == 0} {
		      gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource4
		      send_log "\n resource3:$resource3"
		      send_log "\n resource4:$resource4"
		      if {$resource4 > [expr $resource3 + $resource3 * $errRate]} {
			      set flag4_case4 1
			      gwd::GWpublic_print "NOK" "反复重启NE2($gpnIp2)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
		      } else {
			      gwd::GWpublic_print "OK" "反复重启NE2($gpnIp2)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
		      }
	      	}
	}
	puts $fileId ""
	if {$flag4_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC6（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复重启NNI口所在板卡后测试MPLS标签和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复重启NNI口所在板卡后测试MPLS标签和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复重启NNI口所在板卡后测试MPLS标签和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行NMS主备倒换后测试MPLS标签和系统内存  测试开始=====\n"
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource5
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet2 $matchType2 $Gpn_type2 $fileId]} {
	 		after $rebootTime
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
			if {[PTN_EVP_LabelSwithRepeat "第$j\次 NE2($gpnIp2)进行NMS主备倒换"]} {
				set  flag5_case4 1
			}			
                } else {
                	gwd::GWpublic_print "OK" "$matchType2\只有一个主控盘，测试跳过" $fileId
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
                	gwd::GWpublic_print "NOK" "NE2($gpnIp2)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
                } else {
                	gwd::GWpublic_print "OK" "NE2($gpnIp2)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
                }
	}
	puts $fileId ""
	if {$flag5_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC7（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行NMS主备倒换后测试MPLS标签和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行NMS主备倒换后测试MPLS标签和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行NMS主备倒换后测试MPLS标签和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行SW主备倒换后测试MPLS标签和系统内存  测试开始=====\n"
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource7
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet2 $matchType2 $Gpn_type2 $fileId]} {
			after $rebootTime
			set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
			if {[PTN_EVP_LabelSwithRepeat "第$j\次 NE2($gpnIp2)进行SW主备倒换"]} {
				set  flag6_case4 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType2\只有一个SW盘，测试跳过" $fileId
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
			gwd::GWpublic_print "NOK" "NE2($gpnIp2)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE2($gpnIp2)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag6_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC8（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行SW主备倒换后测试MPLS标签和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行SW主备倒换后测试MPLS标签和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行SW主备倒换后测试MPLS标签和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行保存设备重启后测试MPLS标签和系统内存  测试开始=====\n"
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet2 $matchType2 $Gpn_type2 $fileId
		gwd::GWpublic_Reboot $telnet2 $matchType2 $Gpn_type2 $fileId
		after $rebootTime
		set telnet2 [gwd::GWpublic_loginGpn $gpnIp2 $userName2 $password2 $matchType2 $Gpn_type2 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 1 1 $telnet2]
		if {[PTN_EVP_LabelSwithRepeat "第$j\次 NE2($gpnIp2)进行保存设备重启后"]} {
			set  flag7_case4 1
		}
	}
	gwd::GWpublic_Getresource $telnet2 $matchType2 $Gpn_type2 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag7_case4	1
		gwd::GWpublic_print "NOK" "NE2($gpnIp2)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE2($gpnIp2)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag7_case4 == 1} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC9（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行保存设备重启后测试MPLS标签和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC9（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行保存设备重启后测试MPLS标签和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行保存设备重启后测试MPLS标签和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	gwd::GWpublic_uploadDevCfg 0 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp
	puts $fileId "======================================================================================\n"
	if {$flagCase4 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 4测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 4测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 4 E-TREE业务功能，单域E-Tree（evp-tree）业务标签交换验证测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 E-TREE业务功能，VSI中mac学习限制测试\n"	
        #   <1>拓扑及配置不变，将vpls域中mac地址学习数量设为20，学习规则为丢弃时，命令行配置正确
        #   <2>从NE1的UNI口一次发送源tag100、 mac不同的30条流，在NE1上用命令show forward-entry vpls vpls1查看mac地址表，
        #   预期结果：mac地址学习数目正确为20个；学习条目正确，学在对应vpls的ac上
        #	     NE1、NE2、NE3的UNI口均只能收到20条流，说明学习规则为丢弃生效，没学到的都丢弃了
        #   <3>vpls域中mac地址学习数量仍设为20，修改学习规则为洪泛
        #   预期结果：从NE1的UNI口一次发送源mac不同的30条流，在NE1上用命令show forward-entry vpls vpls1查看mac地址表，
        #             mac地址学习数目正确为20个；学习条目正确，学在对应vpls的ac上
        #             NE1、NE2、NE3的UNI口均能收到30条流，说明学习规则为洪泛生效，没学到的流都洪泛出去了
        #   <4>将mac学习的限制数量更改为其他的值进行多次验证均生效
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
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为20，学习规则为丢弃  测试开始=====\n"
	PTN_ChangeETreeConfig $fileId 1 "discard" "20" 1 1 "false" "false" "false"
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "discard" "ac800" "vpls1" 20 20]} {
		set flag1_case5 1
	}
	puts $fileId ""
	if {$flag1_case5 == 1} {
		set flagCase5 1
		 gwd::GWpublic_print "NOK" "FD1（结论）vpls域中配置mac地址学习数量为20、学习规则为丢弃，配置不生效" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD1（结论）vpls域中配置mac地址学习数量为20，学习规则为丢弃，配置生效" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为20，学习规则为丢弃  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为20，学习规则为泛洪  测试开始=====\n"
	PTN_ChangeETreeConfig $fileId 1 "flood" "20" 1 1 "false" "false" "false"
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "flood" "ac800" "vpls1" 20 200]} {
		set flag2_case5 1
	}
	puts $fileId ""
	if {$flag2_case5 == 1} {
		set flagCase5 1
		 gwd::GWpublic_print "NOK" "FD2（结论）vpls域中配置mac地址学习数量为20、学习规则为泛洪，配置不生效" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD2（结论）vpls域中配置mac地址学习数量为20，学习规则为泛洪，配置生效" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为20，学习规则为泛洪  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为15，学习规则为泛洪  测试开始=====\n"
	PTN_ChangeETreeConfig $fileId 1 "flood" "15" 1 1 "false" "false" "false"
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "flood" "ac800" "vpls1" 15 200]} {
		set flag3_case5 1
	}
	puts $fileId ""
	if {$flag3_case5 == 1} {
		set flagCase5 1
		 gwd::GWpublic_print "NOK" "FD3（结论）vpls域中配置mac地址学习数量为15、学习规则为泛洪，配置不生效" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD3（结论）vpls域中配置mac地址学习数量为15，学习规则为泛洪，配置生效" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为15，学习规则为泛洪  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为15，学习规则为丢弃  测试开始=====\n"
	PTN_ChangeETreeConfig $fileId 1 "discard" "15" 1 1 "false" "false" "false"
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "discard" "ac800" "vpls1" 15 15]} {
		set flag4_case5 1
	}
	puts $fileId ""
	if {$flag4_case5 == 1} {
		set flagCase5 1
		 gwd::GWpublic_print "NOK" "FD4（结论）vpls域中配置mac地址学习数量为15、学习规则为丢弃，配置不生效" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD4（结论）vpls域中配置mac地址学习数量为15，学习规则为丢弃，配置生效" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为15，学习规则为丢弃  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为100，学习规则为泛洪  测试开始=====\n"
	PTN_ChangeETreeConfig $fileId 1 "flood" "100" 1 1 "false" "false" "false"
	if {[PTN_VplsChangeTest $telnet1 $matchType1 $Gpn_type1 $fileId "flood" "ac800" "vpls1" 100 200]} {
		set flag5_case5 1
	}
	puts $fileId ""
	if {$flag5_case5 == 1} {
		set flagCase5 1
		 gwd::GWpublic_print "NOK" "FD5（结论）vpls域中配置mac地址学习数量为100、学习规则为泛洪，配置不生效" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD5（结论）vpls域中配置mac地址学习数量为100，学习规则为泛洪，配置生效" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中mac地址学习数量为100，学习规则为泛洪  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
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
	puts $fileId "Test Case 5 E-TREE业务功能，VSI中mac学习限制测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 6 E-TREE业务：vpls域的配置中报文过滤参数测试\n"
        #   <1>拓扑及配置不变，NE1发送tag100的广播（目的macffff.ffff.ffff），组播(目的mac 0100.5e00.0001)，单播，NE2/NE3/NE4设备的叶子端口都能收到
        #   <2>将广/组播控制功能修改为使能（默认禁止），查看配置生效，业务中断
        #   <3>再将广/组/单播控制功能改为禁止，业务恢复
        ###配置过滤器
	set flag1_case6 0
	set flag2_case6 0
	set flag3_case6 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中配置禁止通过广播包，允许通过组播包和未知单播包验证业务  测试开始=====\n"
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
	if {[TestCase6 "NE1($gpnIp1)vpls域vpls1中配置禁止通过广播包，允许通过组播包和未知单播包。" $rateL0 $rateR0 $rateL $rateR 1 0 0 "GPN_PTN_010_$capId"]} {
		set flag1_case6 1
	}
	puts $fileId ""
	if {$flag1_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FD6（结论）vpls域中配置禁止通过广播包，允许通过组播包和未知单播包验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD6（结论）vpls域中配置禁止通过广播包，允许通过组播包和未知单播包验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中配置禁止通过广播包，允许通过组播包和未知单播包验证业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中配置禁止通过组播包，允许通过广播包和未知单播包验证业务  测试开始=====\n"
	PTN_ChangeETreeConfig $fileId 1 "flood" "2000" 1 1 "false" "true" "false"
	incr capId
	if {[TestCase6 "NE1($gpnIp1)vpls域vpls1中配置禁止通过组播包，允许通过广播包和未知单播包。" $rateL0 $rateR0 $rateL $rateR 0 1 0 "GPN_PTN_010_$capId"]} {
		set flag2_case6 1
	}
	puts $fileId ""
	if {$flag2_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FD7（结论）vpls域中配置禁止通过组播包，允许通过广播包和未知单播包验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD7（结论）vpls域中配置禁止通过组播包，允许通过广播包和未知单播包验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中配置禁止通过组播包，允许通过广播包和未知单播包验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中配置禁止通过未知单播包，允许通过广播包和组播包验证业务  测试开始=====\n"
	PTN_ChangeETreeConfig $fileId 1 "flood" "2000" 1 1 "false" "false" "true"
	incr capId
	if {[TestCase6 "NE1($gpnIp1)vpls域中配置禁止通过未知单播包，允许通过广播包和组播包。" $rateL0 $rateR0 $rateL $rateR 0 0 1 "GPN_PTN_010_$capId"]} {
		set flag3_case6 1
	}
	puts $fileId ""
	if {$flag3_case6 == 1} {
		set flagCase6 1
		 gwd::GWpublic_print "NOK" "FD8（结论）vpls域中配置禁止通过未知单播包，允许通过广播包和组播包验证业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD8（结论）vpls域中配置禁止通过未知单播包，允许通过广播包和组播包验证业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中配置禁止通过未知单播包，允许通过广播包和组播包验证业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
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
	puts $fileId "Test Case 6 E-TREE业务：vpls域的配置中报文过滤参数测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 7 E-TREE业务：黑白名单测试\n"
        #   <1>拓扑及配置不变，NE1发送tag100源为0000.0010.0001，目的mac为0000.0010.0002的数据流，NE2、NE3、NE4均可收到
        #   <2>查看mac地址表，0000.0010.0001动态学到对应vpls的ac上
        #   <3>在NE1上配置基于源的静态mac绑定到ac口，该mac地址为0000.0010.0001，查看mac地址表，该mac表项由动态变为静态，业务正常
        #   <4>进行NE1设备的SW/NMS倒换10次（软倒换），每次操作后业务恢复正常，系统无异常，静态mac表项正确
        #   <5>删除静态mac，mac地址又被重新动态学习到
        #   <6>在NE1上配置基于源的静态mac绑定到pw1上，该mac地址为0000.0010.0002，查看mac地址表正确，且只有NE2能收到数据流，NE3、NE4的数据数据流中断
        #   <7>进行NE1设备的SW/NMS倒换10次（软倒换），每次操作后业务恢复正常，系统无异常，静态mac表项正确且生效
        #   <8>删除静态mac，NE3、NE4重新收到数据流
        #   <9>在NE1上配置基于源的黑洞mac绑定到ac口，该mac地址为0000.0010.0001，查看mac地址表，黑洞mac表项取代动态表项，业务中断
        #   <10>进行NE1设备的SW/NMS倒换10次（软倒换），每次操作后业务恢复正常，系统无异常，黑洞mac表项正确且生效
        #   <11>删除黑洞态mac，mac地址又被重新动态学习到，业务重新恢复
        #   <12>在NE1上配置基于源的黑洞mac绑定到pw1，该mac地址为0000.0010.0002，查看mac地址表，黑洞mac表项正确，且NE2业务中断，NE3/NE4业务正常
        #   <13>进行NE1设备的SW/NMS倒换4次（软倒换），每次操作后业务恢复正常，系统无异常，静态mac表项正确且生效
        #   <14>删除黑洞mac，NE2业务恢复正常，黑洞mac表项消失
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
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在NE1($gpnIp1)的ac500上未配置静态mac地址时测试转发和mac地址转发表  测试开始=====\n"
	set staticMac "0000.0000.0002"
	set staticMac_dst "0000.0000.0022"
	####未配置静态mac时测试
	incr capId
	if {[PTN_BlackAndWhiteMac 0 0 0 "在NE1($gpnIp1)的ac500上未配置静态mac地址$staticMac\时" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010_$capId"]} {
		set flag1_case7 1
	}
	puts $fileId ""
	if {$flag1_case7 == 1} {
		set flagCase7 1
		 gwd::GWpublic_print "NOK" "FD9（结论）在NE1($gpnIp1)的ac500上未配置静态mac地址时测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD9（结论）在NE1($gpnIp1)的ac500上未配置静态mac地址时测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====vpls域中配置禁止通过未知单播包，允许通过广播包和组播包验证业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在NE1($gpnIp1)的ac500上配置静态mac地址后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_addStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls1" "ac500"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 1 0 "在NE1($gpnIp1)的ac500配置静态mac地址$staticMac\后" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010_$capId"]} {
		set flag2_case7 1
	}
	puts $fileId ""
	if {$flag2_case7 == 1} {
		set flagCase7 1
		 gwd::GWpublic_print "NOK" "FE1（结论）在NE1($gpnIp1)的ac500上配置静态mac地址后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE1（结论）在NE1($gpnIp1)的ac500上配置静态mac地址后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在NE1($gpnIp1)的ac500上配置静态mac地址后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在NE1($gpnIp1)的ac500上配置静态mac地址并反复进行SW主备倒换后测试转发和mac地址转发表  测试开始=====\n"
	##反复进行SW主备倒换
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 0 1 0 "在NE1($gpnIp1)的ac500配置静态mac地址$staticMac\并进行第$j\次SW主备倒换后" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010_$capId"]} {
				set flag3_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\只有一个交换盘，测试跳过" $fileId
			set testFlag 1 ;#=1 测试跳过
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag3_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FE2（结论）在NE1($gpnIp1)的ac500上配置静态mac地址并反复进行SW主备倒换后测试转发和mac地址转发表" $fileId
		} else {
			gwd::GWpublic_print "OK" "FE2（结论）在NE1($gpnIp1)的ac500上配置静态mac地址并反复进行SW主备倒换后测试转发和mac地址转发表" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在NE1($gpnIp1)的ac500上配置静态mac地址并反复进行SW主备倒换后测试转发和mac地址转发表  测试结束=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在NE1($gpnIp1)的ac500上配置静态mac地址并反复进行NMS主备倒换后测试转发和mac地址转发表  测试开始=====\n"
	##反复进行NMS主备倒换
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 0 1 0 "在NE1($gpnIp1)的ac500配置静态mac地址$staticMac\并进行第$j\次NMS主备倒换后" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010_$capId"]} {
				set flag4_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\只有一个NMS盘，测试跳过" $fileId
			set testFlag 1 ;#=1 测试跳过
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag4_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FE3（结论）在NE1($gpnIp1)的ac500上配置静态mac地址并反复进行NMS主备倒换后测试转发和mac地址转发表" $fileId
		} else {
			gwd::GWpublic_print "OK" "FE3（结论）在NE1($gpnIp1)的ac500上配置静态mac地址并反复进行NMS主备倒换后测试转发和mac地址转发表" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在NE1($gpnIp1)的ac500上配置静态mac地址并反复进行NMS主备倒换后测试转发和mac地址转发表  测试结束=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上删除配置的静态mac地址后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls1"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 0 0 "在NE1($gpnIp1)的ac500上删除配置静态mac地址$staticMac\后" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010_$capId"]} {
		set flag5_case7 1
	}
	puts $fileId ""
	if {$flag5_case7 == 1} {
		set flagCase7 1
		 gwd::GWpublic_print "NOK" "FE4（结论）NE1($gpnIp1)ac500上删除配置的静态mac地址后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE4（结论）NE1($gpnIp1)ac500上删除配置的静态mac地址后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上删除配置的静态mac地址后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上配置静态mac地址后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_addStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls1" "pw12"
	incr capId
	if {[PTN_BlackAndWhiteMac 0 1 1 "在NE1($gpnIp1)的pw12上添加配置静态mac地址$staticMac_dst\后" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010_$capId"]} {
		set flag6_case7 1
	}
	puts $fileId ""
	if {$flag6_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FE5（结论）NE1($gpnIp1)pw12上配置静态mac地址后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE5（结论）NE1($gpnIp1)pw12上配置静态mac地址后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上配置静态mac地址后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上配置静态mac地址并反复进行SW主备倒换后测试转发和mac地址转发表  测试开始=====\n"
	##反复进行SW主备倒换
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 0 1 1 "在NE1($gpnIp1)的pw12上添加配置静态mac地址$staticMac_dst\并进行第$j\次SW主备倒换后" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010_$capId"]} {
				set flag7_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\只有一个交换盘，测试跳过" $fileId
			set testFlag 1 ;#=1 测试跳过
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag7_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FE6（结论）NE1($gpnIp1)pw12上配置静态mac地址并反复进行SW主备倒换后测试转发和mac地址转发表" $fileId
		} else {
			gwd::GWpublic_print "OK" "FE6（结论）NE1($gpnIp1)pw12上配置静态mac地址并反复进行SW主备倒换后测试转发和mac地址转发表" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上配置静态mac地址并反复进行SW主备倒换后测试转发和mac地址转发表  测试结束=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上配置静态mac地址并反复进行NMS主备倒换后测试转发和mac地址转发表  测试开始=====\n"
	##反复进行NMS主备倒换
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 0 1 1 "在NE1($gpnIp1)的pw12上添加配置静态mac地址$staticMac_dst\并进行第$j\次NMS主备倒换后" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010_$capId"]} {
				set flag8_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\只有一个NMS盘，测试跳过" $fileId
			set testFlag 1 ;#=1 测试跳过
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag8_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FE7（结论）NE1($gpnIp1)pw12上配置静态mac地址并反复进行NMS主备倒换后测试转发和mac地址转发表" $fileId
		} else {
			gwd::GWpublic_print "OK" "FE7（结论）NE1($gpnIp1)pw12上配置静态mac地址并反复进行NMS主备倒换后测试转发和mac地址转发表" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上配置静态mac地址并反复进行NMS主备倒换后测试转发和mac地址转发表  测试结束=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上删除静态mac地址后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls1"
	if {[PTN_BlackAndWhiteMac 0 0 1 "在NE1($gpnIp1)的pw12上删除配置静态mac地址$staticMac_dst\后" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010_$capId"]} {
		set flag9_case7 1
	}
	puts $fileId ""
	if {$flag9_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FE8（结论）NE1($gpnIp1)pw12上删除静态mac地址后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE8（结论）NE1($gpnIp1)pw12上删除静态mac地址后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上删除静态mac地址后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上配置黑洞mac后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_addBlackHoleMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls1" "ac500" "src_drop"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 1 0 "在NE1($gpnIp1)的ac500上配置黑洞mac地址$staticMac\后" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010-$capId"]} {
		set flag10_case7 1
	}
	puts $fileId ""
	if {$flag10_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FE9（结论）NE1($gpnIp1)ac500上配置黑洞mac后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FE9（结论）NE1($gpnIp1)ac500上配置黑洞mac后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上配置黑洞mac后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上配置黑洞mac并反复进行SW主备倒换后测试转发和mac地址转发表  测试开始=====\n"
	##反复进行SW主备倒换
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 1 1 0 "在NE1($gpnIp1)的ac500上配置黑洞mac地址$staticMac\并进行第$j\次SW主备倒换后" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010-$capId"]} {
				set flag11_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\只有一个交换盘，测试跳过" $fileId
			set testFlag 1 ;#=1 测试跳过
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag11_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FF1（结论）NE1($gpnIp1)ac500上配置黑洞mac并反复进行SW主备倒换后测试转发和mac地址转发表" $fileId
		} else {
			gwd::GWpublic_print "OK" "FF1（结论）NE1($gpnIp1)ac500上配置黑洞mac并反复进行SW主备倒换后测试转发和mac地址转发表" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上配置黑洞mac并反复进行SW主备倒换后测试转发和mac地址转发表  测试结束=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上配置黑洞mac并反复进行NMS主备倒换后测试转发和mac地址转发表  测试开始=====\n"
	##反复进行NMS主备倒换
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 1 1 0 "在NE1($gpnIp1)的ac500上配置黑洞mac地址$staticMac\并进行第$j\次NMS主备倒换后" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010-$capId"]} {
				set flag12_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\只有一个NMS盘，测试跳过" $fileId
			set testFlag 1 ;#=1 测试跳过
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag12_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FF2（结论）NE1($gpnIp1)ac500上配置黑洞mac并反复进行NMS主备倒换后测试转发和mac地址转发表" $fileId
		} else {
			gwd::GWpublic_print "OK" "FF2（结论）NE1($gpnIp1)ac500上配置黑洞mac并反复进行NMS主备倒换后测试转发和mac地址转发表" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上配置黑洞mac并反复进行NMS主备倒换后测试转发和mac地址转发表  测试结束=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上删除黑洞mac后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac "vpls" "vpls1"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 0 0 "在NE1($gpnIp1)的ac500上删除黑洞mac地址$staticMac\后" "ac" "ac500" "vpls1" $staticMac "GPN_PTN_010-$capId"]} {
		set flag13_case7 1
	}
	puts $fileId ""
	if {$flag13_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FF3（结论）NE1($gpnIp1)ac500上删除黑洞mac后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FF3（结论）NE1($gpnIp1)ac500上删除黑洞mac后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)ac500上删除黑洞mac后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上添加黑洞mac后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_addBlackHoleMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls1" "pw12" "src_drop"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 1 1 "在NE1($gpnIp1)的pw12上添加黑洞mac地址$staticMac_dst\后" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010-$capId"]} {
		set flag14_case7 1
	}
	puts $fileId ""
	if {$flag14_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FF4（结论）NE1($gpnIp1)pw12上添加黑洞mac后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FF4（结论）NE1($gpnIp1)pw12上添加黑洞mac后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上添加黑洞mac后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上配置黑洞mac并反复进行SW主备倒换后测试转发和mac地址转发表  测试开始=====\n"
	##反复进行SW主备倒换
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 1 1 1 "在NE1($gpnIp1)的pw12上添加黑洞mac地址$staticMac_dst\并进行第$j\次SW主备倒换后" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010-$capId"]} {
				set flag15_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\只有一个交换盘，测试跳过" $fileId
			set testFlag 1 ;#=1 测试跳过
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag15_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FF5（结论）NE1($gpnIp1)pw12上配置黑洞mac并反复进行SW主备倒换后测试转发和mac地址转发表" $fileId
		} else {
			gwd::GWpublic_print "OK" "FF5（结论）NE1($gpnIp1)pw12上配置黑洞mac并反复进行SW主备倒换后测试转发和mac地址转发表" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上配置黑洞mac并反复进行SW主备倒换后测试转发和mac地址转发表  测试结束=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上配置黑洞mac并反复进行NMS主备倒换后测试转发和mac地址转发表  测试开始=====\n"
	##反复进行NMS主备倒换
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[PTN_BlackAndWhiteMac 1 1 1 "在NE1($gpnIp1)的pw12上添加黑洞mac地址$staticMac_dst\并进行第$j\次NMS主备倒换后" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010-$capId"]} {
				set flag16_case7 1
			}
		} else {
			gwd::GWpublic_print "OK" "$matchType1\只有一个NMS盘，测试跳过" $fileId
			set testFlag 1 ;#=1 测试跳过
			break
		}
	}
	if {$testFlag == 0} {
		puts $fileId ""
		if {$flag16_case7 == 1} {
			set flagCase7 1
			 gwd::GWpublic_print "NOK" "FF6（结论）NE1($gpnIp1)pw12上配置黑洞mac并反复进行NMS主备倒换后测试转发和mac地址转发表" $fileId
		} else {
			gwd::GWpublic_print "OK" "FF6（结论）NE1($gpnIp1)pw12上配置黑洞mac并反复进行NMS主备倒换后测试转发和mac地址转发表" $fileId
		}
		puts $fileId ""
		gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上配置黑洞mac并反复进行NMS主备倒换后测试转发和mac地址转发表  测试结束=====\n"
		gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
		incr cfgId
		lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
		if {$lFailFileTmp != ""} {
			set lFailFile [concat $lFailFile $lFailFileTmp]
		}
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上删除黑洞mac后测试转发和mac地址转发表  测试开始=====\n"
	gwd::GWpublic_delStaticMAC $telnet1 $matchType1 $Gpn_type1 $fileId $staticMac_dst "vpls" "vpls1"
	incr capId
	if {[PTN_BlackAndWhiteMac 1 0 0 "在NE1($gpnIp1)的pw12上删除黑洞mac地址$staticMac_dst\后" "pw" "pw12" "vpls1" $staticMac_dst "GPN_PTN_010-$capId"]} {
		set flag17_case7 1
	}
	puts $fileId ""
	if {$flag17_case7 == 1} {
		set flagCase7 1
		gwd::GWpublic_print "NOK" "FF7（结论）NE1($gpnIp1)pw12上删除黑洞mac后测试转发和mac地址转发表" $fileId
	} else {
		gwd::GWpublic_print "OK" "FF7（结论）NE1($gpnIp1)pw12上删除黑洞mac后测试转发和mac地址转发表" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====NE1($gpnIp1)pw12上删除黑洞mac后测试转发和mac地址转发表  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
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
	puts $fileId "Test Case 7 E-TREE业务：黑白名单测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 8 E-TREE业务：性能统计测试\n"
        #   <1>上述拓扑，配置不变，NE1与NE2、NE3、NE4互发已知单播（每秒发10000个包），业务正常
        #   <2>使能NE1的lsp/pw的性能统计，开启ac（即ac所绑定的物理端口）、lsp、pw的当前性能统计，轮询时间设为1分钟
        #   <3>一5分钟后，在网管上查看统计结果，应该有5个统计结果，且每个结果的值相近，收/发包数为60*10000个左右，没有数量级上的误差
        #   <4>删除当前性能统计，在网管上添加ac（即ac所绑定的物理端口）、lsp、pw的15分钟采集信息
        #   <5>一小时后查看15分钟历史性能统计，应该有四个统计结果，每15分钟统计一次，统计正确
        #   <6>删除15分钟历史性能统计，在网管上添加ac（即ac所绑定的物理端口）、lsp、pw的24小时采集信息计
        #   <7>48小时后查看24小时历史性能统计，应该有两个统计结果，每24小时统计一次，统计正确
        ##使能设备lsp、pw、ac的性能统计，验证
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====E-TREE业务的lsp、pw、ac性能统计测试  测试开始=====\n"
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
		gwd::GWpublic_print "NOK" "FF8（结论）E-TREE业务的lsp、pw、ac性能统计测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FF8（结论）E-TREE业务的lsp、pw、ac性能统计测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====E-TREE业务的lsp、pw、ac性能统计测试  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
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
	puts $fileId "Test Case 8 E-TREE业务：性能统计测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 9 E-TREE业务功能，多域的E-Tree业务测试\n"
        ##多域的E-Tree业务
        #   <1>拓扑不变，新建一个域vpls2，,再创建一条新的E-Tree业务(与之前的业务共用同相同LSP)，创建新的pw，所有设备的AC接入模式设为“端口+运营商VLAN+客户VLAN”，
        #      运营商VLAN为 vlan 800，客户VLAN为vlan 500，业务成功创建，系统无异常，对之前的业务无任何干扰，
        #   <2>配置NE1的LSP10入标签17，出标签17；PW10本地标签20，远程标签20
        #      配置NE3的LSP10入标签18，出标签18；PW10本地标签20，远程标签20 
        #      NE2的SW配置：mpls traffic-eng static swap <in_table> <out_table> vlan <vlanname> <A.B.C.D> bandwidth <0-10000> <1-65535> [normal|ring] 
        #   <3>向NE1的UNI端口发送untag、tag300、tag3000、 双层tag（外800 内500）业务流量
        #   预期结果：NE2、NE3、NE4的UNI端口只可接收到双层tag（外800 内500）业务流量，且对之前的业务无干扰，双向发流业务正常
        #   <4>undo shutdown和shutdown NE1和NE2设备的NNI/UNI端口50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
        #   <5>重启NE1和NE2设备的NNI/UNI端口所在板卡50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 
        #   <6>NE1和NE2设备进行SW/NMS倒换50次，每次操作后每条业务恢复正常且彼此无干扰，系统无异常 ，查看标签转发表项正确
        #   <7>保存重启NE1和NE2设备的50次，每次操作后系统正常启动，每条业务恢复正常且彼此无干扰，系统无异常，查看标签转发表项正确
        #   <8>在不删除vpls的情况下，删除vpls2的ac，vpls2的业务中断，vpls1的业务不受影响
        #   <9>重新添加ac，查看配置添加成功，业务恢复，且不影响其他域的业务
        #   <10>直接删除该vpls，再删除对应的pw,
        #   预期结果：该域业务中断，不影响vpls1的业务
        #   <11>重新创建一个vpls2,NE2为根节点NE1为叶子节点，lsp共用vpls1的，pw重新创建，NE2上新建的PW的角色为none(叶子)，
        #       NE1上新建的pw的角色为root，验证了根节点上向NNI口汇聚的情况，即pw为root
        #   <12>创建一条新的E-Tree业务，AC接入模式设为“端口+运营商VLAN”，运营商VLAN为 vlan 200业务成功创建，
        #   预期结果：系统无异常，对之前的业务无任何干扰
        #   <13>删除该vpls，再删除对应的pw,该域业务中断，不影响vpls1的业务 
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
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，测试两条ETREE的业务  测试开始=====\n"
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
	###配置pw
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
		gwd::GWpublic_print "NOK" "FF9（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，测试两条ETREE的业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FF9（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，测试两条ETREE的业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，测试两条ETREE的业务  测试结束=====\n"
	incr tcId
	gwd::GWpublic_saveTCCfg 1 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n" 
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====2条ETREE业务，NE1($gpnIp1)反复shut undoshut NNI 口后测试2条ETREE业务的恢复和系统内存  测试开始=====\n"
	##反复undo shutdown/shutdown端口
	foreach eth $portlist1 {
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource1
		for {set j 1} {$j<=$cnt} {incr j} {
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "shutdown"
			gwd::GWpublic_CfgPortState $telnet1 $matchType1 $Gpn_type1 $fileId $eth "undo shutdown"
			after $WaiteTime
			incr capId
			if {[TestRepeat_case2Andcase9 2 $fileId "第$j\次shutdown/undo shutdown NE1($gpnIp1)的$eth\端口后" "GPN_PTN_010_$capId" $rateL $rateR]} {
				set  flag2_case9 1
			}
		}
		gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource2
		send_log "\n resource1:$resource1"
		send_log "\n resource2:$resource2"
		if {$resource2 > [expr $resource1 + $resource1 * $errRate]} {
			set flag2_case9 1
			gwd::GWpublic_print "NOK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "反复shutdown/undo shutdown NE1($gpnIp1)的端口$eth\之前系统内存为$resource1\，之后系统内存为$resource2。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag2_case9 == 1} {
		set flagCase9 1
		 gwd::GWpublic_print "NOK" "FG1（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复shut undoshut NNI 口后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG1（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复shut undoshut NNI 口后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复shut undoshut NNI 口后测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存  测试开始=====\n" 
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
				if {[TestRepeat_case2Andcase9 2 $fileId "第$j\次重启NE1($gpnIp1)$slot\槽位板卡" "GPN_PTN_010_$capId" $rateL $rateR]} {
					set  flag3_case9 1
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
				set flag3_case9 1
				gwd::GWpublic_print "NOK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化不在允许误差$errRate\内" $fileId
			} else {
				gwd::GWpublic_print "OK" "反复重启NE1($gpnIp1)$slot\槽位板卡之前系统内存为$resource3\，之后系统内存为$resource4。内存变化在允许误差$errRate\内" $fileId
			}
		}
	}
	puts $fileId ""
	if {$flag3_case9 == 1} {
		set flagCase9 1
		 gwd::GWpublic_print "NOK" "FG2（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG2（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存  测试开始=====\n" 
	set expectTable1 "0000.0000.000C ac100 0000.0000.00F2 pw12 0000.0000.00F3 pw13 0000.0000.00F4 pw14"
	set expectTable2 "0000.0000.0026 ac800 0000.0000.0205 pw012 0000.0000.0305 pw013 0000.0000.0405 pw014"
	###反复进行NMS主备倒换
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource5
	set testFlag 0
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitch $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestRepeat_case2Andcase9 2 $fileId "第$j\次 NE1($gpnIp1)进行NMS主备倒换后" "GPN_PTN_010_$capId" $rateL $rateR]} {
				set  flag4_case9 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行NMS主备倒换后" $dTable $expectTable1]} {
				set flag4_case9 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls10" dTable
			if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行NMS主备倒换后" $dTable $expectTable2]} {
				set flag4_case9 1
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
		set flag4_case9	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)反复NMS主备倒换之前系统内存为$resource5\，之后系统内存为$resource6。内存变化在允许误差$errRate\内" $fileId
	}
	}
	puts $fileId ""
	if {$flag4_case9 == 1} {
	set flagCase9 1
	 gwd::GWpublic_print "NOK" "FG3（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	} else {
	gwd::GWpublic_print "OK" "FG3（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存  测试开始=====\n" 
	##反复进行SW主备倒换
	set testFlag 0 ;#=1 测试跳过
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource7
	for {set j 1} {$j<$cntdh} {incr j} {
		if {![gwd::GWCard_AddSwitchSw $telnet1 $matchType1 $Gpn_type1 $fileId]} {
			  after $rebootTime
			set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
			set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
			incr capId
			if {[TestRepeat_case2Andcase9 2 $fileId "第$j\次 NE1($gpnIp1)进行SW主备倒换" "GPN_PTN_010_$capId" $rateL $rateR]} {
				set  flag5_case9 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
			if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行SW主备倒换后" $dTable $expectTable1]} {
				set flag5_case9 1
			}
			gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls10" dTable
			if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行SW主备倒换后" $dTable $expectTable2]} {
				set flag5_case9 1
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
			set flag5_case9	1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化不在允许误差$errRate\内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)反复SW主备倒换之前系统内存为$resource7\，之后系统内存为$resource8。内存变化在允许误差$errRate\内" $fileId
		}
	}
	puts $fileId ""
	if {$flag5_case9 == 1} {
		set flagCase9 1
		 gwd::GWpublic_print "NOK" "FG4（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG4（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存  测试开始=====\n" 
	##反复保存设备重启
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource9
	for {set j 1} {$j<=$cnt} {incr j} {
		gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
		gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
		after $rebootTime
		set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
		set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
		incr capId
		if {[TestRepeat_case2Andcase9 2 $fileId "第$j\次 NE1($gpnIp1)进行保存设备重启后" "GPN_PTN_010_$capId" $rateL $rateR]} {
			set  flag6_case9 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls1" dTable
		if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行保存设备重启后" $dTable $expectTable1]} {
			set flag6_case9 1
		}
		gwd::GWpubic_queryVPLSForwardTable $telnet1 $matchType1 $Gpn_type1 $fileId "" "" "vpls10" dTable
		if {[TestVplsForwardEntry $fileId "第$j\次 NE1($gpnIp1)进行保存设备重启后" $dTable $expectTable2]} {
			set flag6_case9 1
		}
	}
	gwd::GWpublic_Getresource $telnet1 $matchType1 $Gpn_type1 $fileId resource10
	send_log "\n resource9:$resource9"
	send_log "\n resource10:$resource10"
	if {$resource10 > [expr $resource9 + $resource9 * $errRate]} {
		set flag6_case9	1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化不在允许误差$errRate\内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)反复保存设备重启之前系统内存为$resource9\，之后系统内存为$resource10。内存变化在允许误差$errRate\内" $fileId
	}
	puts $fileId ""
	if {$flag6_case9 == 1} {
		set flagCase9 1
		gwd::GWpublic_print "NOK" "FG5（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG5（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1：不配置vplsType、ac为PORT+VLAN；ETREE2：不配置vplsType、ac为PORT+SVLAN+CLVAN，删除ETREE2的AC后测试业务  测试开始=====\n"
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 role $RoleList matchType $lMatchType {
		gwd::GWAc_DelName $telnet $matchType $Gpn_type $fileId "ac800"
	}
	incr capId
	if {[TestRepeat_case2Andcase9 3 $fileId "删除ETREE2的AC后" "GPN_PTN_010_$capId" $rateL $rateR]} {
		set  flag7_case9 1
	}
	puts $fileId ""
	if {$flag7_case9 == 1} {
		set flagCase9 1
		gwd::GWpublic_print "NOK" "FG6（结论）2条ETREE业务，删除ETREE2业务的AC，测试ETREE1和ETREE2的业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG6（结论）2条ETREE业务，删除ETREE2业务的AC，测试ETREE1和ETREE2的业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1：不配置vplsType、ac为PORT+VLAN；ETREE2：不配置vplsType、ac为PORT+SVLAN+CLVAN，删除ETREE2的AC后测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1：不配置vplsType、ac为PORT+VLAN；ETREE2：不配置vplsType、ac为PORT+SVLAN+CLVAN，删除ETREE2业务的AC后恢复AC配置测试业务  测试开始=====\n"
	set id 10
	foreach telnet $lSpawn_id Gpn_type $lDutType eth $Portlist0 role $RoleList matchType $lMatchType {
		gwd::GWAc_AddVplsInfo $telnet $matchType $Gpn_type $fileId "ac800" "vpls$id" "" $eth "800" "500" $role "nochange" "1" "0" "0" "0x8100" "evc3"
		incr id 10
	}
	incr capId
	if {[TestRepeat_case2Andcase9 2 $fileId "删除ETREE2业务的AC后恢复AC配置" "GPN_PTN_010_$capId" $rateL $rateR]} {
		set  flag8_case9 1
	}
	puts $fileId ""
	if {$flag8_case9 == 1} {
		set flagCase9 1
		gwd::GWpublic_print "NOK" "FG7（结论）2条ETREE业务，删除ETREE2业务的AC后恢复AC配置，测试ETREE1和ETREE2的业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG7（结论）2条ETREE业务，删除ETREE2业务的AC后恢复AC配置，测试ETREE1和ETREE2的业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1：不配置vplsType、ac为PORT+VLAN；ETREE2：不配置vplsType、ac为PORT+SVLAN+CLVAN，删除ETREE2业务的AC后恢复AC配置测试业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1：不配置vplsType、ac为PORT+VLAN；ETREE2：不配置vplsType、ac为PORT+SVLAN+CLVAN，删除ETREE2的vpls域后  测试开始=====\n"
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
	if {[TestRepeat_case2Andcase9 3 $fileId "删除ETREE2的vpls域后" "GPN_PTN_010_$capId" $rateL $rateR]} {
		set  flag9_case9 1
	}
	puts $fileId ""
	if {$flag9_case9 == 1} {
		set flagCase9 1
		gwd::GWpublic_print "NOK" "FG8（结论）2条ETREE业务，删除ETREE2的vpls域后，测试ETREE1和ETREE2的业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG8（结论）2条ETREE业务，删除ETREE2的vpls域后，测试ETREE1和ETREE2的业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1：不配置vplsType、ac为PORT+VLAN；ETREE2：不配置vplsType、ac为PORT+SVLAN+CLVAN，删除ETREE2的vpls域后  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1：不配置vplsType、ac为PORT+VLAN(100)；ETREE2：不配置vplsType、ac为PORT+VLAN(500)，，测试两条ETREE的业务  测试开始=====\n"
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
	###配置pw
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw012" "vpls" "vpls10" "peer" $address612 "100" "100" "" "nochange" "leaf" 1 0 "0x8100" "0x8100" "2"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw014" "vpls" "vpls10" "peer" $address614 "200" "200" "" "nochange" "leaf" 1 0 "0x8100" "0x8100" "4"
	gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw013" "vpls" "vpls10" "peer" $address613 "300" "300" "" "nochange" "leaf" 1 0 "0x8100" "0x8100" "3"
	gwd::GWpublic_CfgPw $telnet2 $matchType2 $Gpn_type2 $fileId "pw021" "vpls" "vpls20" "peer" $address621 "100" "100" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet3 $matchType3 $Gpn_type3 $fileId "pw031" "vpls" "vpls30" "peer" $address631 "300" "300" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	gwd::GWpublic_CfgPw $telnet4 $matchType4 $Gpn_type4 $fileId "pw041" "vpls" "vpls40" "peer" $address641 "200" "200" "" "nochange" "root" 1 0 "0x8100" "0x8100" "1"
	#验证vpls10/20/30/40
	incr capId
	if {[TestRepeat_case1 $fileId "ETREE2的AC配置为port+vlan模式后" "GPN_PTN_010_$capId" $rateL $rateR 1]} {
		set flag10_case9 1
	}
	#验证vpls1/2/3/4
	incr capId
	if {[TestRepeat_case2Andcase9 4 $fileId "ETREE2的AC配置为port+vlan模式后" "GPN_PTN_010_$capId" $rateL $rateR]} {
		set  flag10_case9 1
	}
	puts $fileId ""
	if {$flag10_case9 == 1} {
		set flagCase9 1
		gwd::GWpublic_print "NOK" "FG9（结论）ETREE1：不配置vplsType、ac为PORT+VLAN(100)；ETREE2：不配置vplsType、ac为PORT+VLAN(500)，，测试两条ETREE的业务" $fileId
	} else {
		gwd::GWpublic_print "OK" "FG9（结论）ETREE1：不配置vplsType、ac为PORT+VLAN(100)；ETREE2：不配置vplsType、ac为PORT+VLAN(500)，，测试两条ETREE的业务" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ETREE1：不配置vplsType、ac为PORT+VLAN(100)；ETREE2：不配置vplsType、ac为PORT+VLAN(500)，，测试两条ETREE的业务  测试结束=====\n"
	gwd::GWpublic_saveTCCfg 0 $fileId "GPN_PTN_010_$tcId.xml" [pwd]/Untitled
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_010" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	if {$flagCase9 == 1} {
		gwd::GWpublic_print "NOK" "TestCase 9测试结论" $fileId
	} else {
		gwd::GWpublic_print "OK" "TestCase 9测试结论" $fileId
	}
	puts $fileId ""
	puts $fileId "Test Case 9 E-TREE业务功能，多域的E-Tree业务测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===恢复初始化配置...\n"
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
	#为了规避删除黑洞mac和静态mac，主备板不同步问题，对设备进行下载初始化配置重启操作------
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
	#------为了规避删除黑洞mac和静态mac，主备板不同步问题，对设备进行下载初始化配置重启操作
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "测试结束后配置恢复" "测试结束后配置恢复" "GPN_PTN_010"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "测试过程中所有配置文件都上传成功" "GPN_PTN_010"
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_010测试目的：E-TREE功能验证 LSP PW交换测试\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1==1 || $flagCase2==1 || $flagCase3==1 || $flagCase4==1 || $flagCase5==1 || $flagCase6 == 1 || $flagCase7==1 \
		|| $flagCase8 == 1 || $flagCase9 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_010测试结果" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase6 == 0) ? "OK" : "NOK"}] "Test Case 6测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase7 == 0) ? "OK" : "NOK"}] "Test Case 7测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase8 == 0) ? "OK" : "NOK"}] "Test Case 8测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase9 == 0) ? "OK" : "NOK"}] "Test Case 9测试结果" $fileId
	gwd::GWpublic_print [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}] "测试结束后配置恢复" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1发送untag/tag的未知单播、广播、组播，测试业务" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1与NE2/NE3/NE4 互发vid=500的已知单播，测试业务" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE2、NE3、NE4 发送untag/tag的数据流，测试业务" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "（结论）镜像NE1($gpnIp1)到NE2($gpnIp2)、NE4($gpnIp4)的NNI出口方向报文测试MPLS标签" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复shut undoshut NNI口后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag7_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag8_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag9_case1 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port模式，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FB1 == [expr {($flag10_case1 == 1) ? "NOK" : "OK"}]" "（结论）删除各设备AC的配置，业务[expr {($flag10_case1 == 1) ? "没有" : ""}]中断" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag11_case1 == 1) ? "NOK" : "OK"}]" "（结论）重新添加各设备AC的配置，测试业务" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，未使能overlay功能前发送MPLS报文验证业务" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，使能overlay功能后发送MPLS报文验证业务" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan模式，验证业务" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复shut undoshut NNI 口后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag7_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FC1 == [expr {($flag8_case2 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port+vlan模式，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FC2 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root、NE2-NE4的AC是leaf、AC为port和port+vlan两种、vplsType为tagged，测试ETREE业务" $fileId
	gwd::GWpublic_print "== FC3 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root  NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，验证ETREE业务" $fileId
	gwd::GWpublic_print "== FC4 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，测试MPLS标签" $fileId
	gwd::GWpublic_print "== FC5 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复shutdown/undo shutdown NNI口测试MPLS标签和系统内存" $fileId
	gwd::GWpublic_print "== FC6 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复重启NNI口所在板卡后测试MPLS标签和系统内存" $fileId
	gwd::GWpublic_print "== FC7 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行NMS主备倒换后测试MPLS标签和系统内存" $fileId
	gwd::GWpublic_print "== FC8 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行SW主备倒换后测试MPLS标签和系统内存" $fileId
	gwd::GWpublic_print "== FC9 == [expr {($flag7_case4 == 1) ? "NOK" : "OK"}]" "（结论）NE1的AC是root NE2-NE4的AC是leaf、AC为port+vlan、不配置vpls的模式，镜像NE2设备的NNI口，NE2反复进行保存设备重启后测试MPLS标签和系统内存" $fileId
	gwd::GWpublic_print "== FD1 == [expr {($flag1_case5 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置mac地址学习数量为20、学习规则为丢弃，配置[expr {($flag1_case5 == 1) ? "不" : ""}]生效" $fileId
	gwd::GWpublic_print "== FD2 == [expr {($flag2_case5 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置mac地址学习数量为20、学习规则为泛洪，配置[expr {($flag2_case5 == 1) ? "不" : ""}]生效" $fileId
	gwd::GWpublic_print "== FD3 == [expr {($flag3_case5 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置mac地址学习数量为15、学习规则为泛洪，配置[expr {($flag3_case5 == 1) ? "不" : ""}]生效" $fileId
	gwd::GWpublic_print "== FD4 == [expr {($flag4_case5 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置mac地址学习数量为15、学习规则为丢弃，配置[expr {($flag4_case5 == 1) ? "不" : ""}]生效" $fileId
	gwd::GWpublic_print "== FD5 == [expr {($flag5_case5 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置mac地址学习数量为100、学习规则为泛洪，配置[expr {($flag5_case5 == 1) ? "不" : ""}]生效" $fileId
	gwd::GWpublic_print "== FD6 == [expr {($flag1_case6 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置禁止通过广播包，允许通过组播包和未知单播包验证业务" $fileId
	gwd::GWpublic_print "== FD7 == [expr {($flag2_case6 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置禁止通过组播包，允许通过广播包和未知单播包验证业务" $fileId
	gwd::GWpublic_print "== FD8 == [expr {($flag3_case6 == 1) ? "NOK" : "OK"}]" "（结论）vpls域中配置禁止通过未知单播包，允许通过广播包和组播包验证业务" $fileId
	gwd::GWpublic_print "== FD9 == [expr {($flag1_case7 == 1) ? "NOK" : "OK"}]" "（结论）在NE1($gpnIp1)的ac500上未配置静态mac地址时测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE1 == [expr {($flag2_case7 == 1) ? "NOK" : "OK"}]" "（结论）在NE1($gpnIp1)的ac500上配置静态mac地址后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE2 == [expr {($flag3_case7 == 1) ? "NOK" : "OK"}]" "（结论）在NE1($gpnIp1)的ac500上配置静态mac地址并反复进行SW主备倒换后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE3 == [expr {($flag4_case7 == 1) ? "NOK" : "OK"}]" "（结论）在NE1($gpnIp1)的ac500上配置静态mac地址并反复进行NMS主备倒换后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE4 == [expr {($flag5_case7 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)ac500上删除配置的静态mac地址后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE5 == [expr {($flag6_case7 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上配置静态mac地址后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE6 == [expr {($flag7_case7 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上配置静态mac地址并反复进行SW主备倒换后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE7 == [expr {($flag8_case7 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上配置静态mac地址并反复进行NMS主备倒换后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE8 == [expr {($flag9_case7 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上删除静态mac地址后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FE9 == [expr {($flag10_case7 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)ac500上配置黑洞mac后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FF1 == [expr {($flag11_case7 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)ac500上配置黑洞mac并反复进行SW主备倒换后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FF2 == [expr {($flag12_case7 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)ac500上配置黑洞mac并反复进行NMS主备倒换后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FF3 == [expr {($flag13_case7 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)ac500上删除黑洞mac后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FF4 == [expr {($flag14_case7 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上添加黑洞mac后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FF5 == [expr {($flag15_case7 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上配置黑洞mac并反复进行SW主备倒换后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FF6 == [expr {($flag16_case7 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上配置黑洞mac并反复进行NMS主备倒换后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FF7 == [expr {($flag17_case7 == 1) ? "NOK" : "OK"}]" "（结论）NE1($gpnIp1)pw12上删除黑洞mac后测试转发和mac地址转发表" $fileId
	gwd::GWpublic_print "== FF8 == [expr {($flag1_case8 == 1) ? "NOK" : "OK"}]" "（结论）E-TREE业务的lsp、pw、ac性能统计测试" $fileId
	gwd::GWpublic_print "== FF9 == [expr {($flag1_case9 == 1) ? "NOK" : "OK"}]" "（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，测试两条ETREE的业务" $fileId
	gwd::GWpublic_print "== FG1 == [expr {($flag2_case9 == 1) ? "NOK" : "OK"}]" "（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复shut undoshut NNI 口后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FG2 == [expr {($flag3_case9 == 1) ? "NOK" : "OK"}]" "（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复重启NNI口所在板卡后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FG3 == [expr {($flag4_case9 == 1) ? "NOK" : "OK"}]" "（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行NMS主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FG4 == [expr {($flag5_case9 == 1) ? "NOK" : "OK"}]" "（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行SW主备倒换测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FG5 == [expr {($flag6_case9 == 1) ? "NOK" : "OK"}]" "（结论）一条ETREE：不配置vplsType、ac为PORT+VLAN；一条ETREE：不配置vplsType、ac为PORT+SVLAN+CLVAN，NE1($gpnIp1)反复进行保存设备重启后测试业务恢复和系统内存" $fileId
	gwd::GWpublic_print "== FG6 == [expr {($flag7_case9 == 1) ? "NOK" : "OK"}]" "（结论）2条ETREE业务，删除ETREE2业务的AC，测试ETREE1和ETREE2的业务" $fileId
	gwd::GWpublic_print "== FG7 == [expr {($flag8_case9 == 1) ? "NOK" : "OK"}]" "（结论）2条ETREE业务，删除ETREE2业务的AC后恢复AC配置，测试ETREE1和ETREE2的业务" $fileId
	gwd::GWpublic_print "== FG8 == [expr {($flag9_case9 == 1) ? "NOK" : "OK"}]" "（结论）2条ETREE业务，删除ETREE2的vpls域后，测试ETREE1和ETREE2的业务" $fileId
	gwd::GWpublic_print "== FG9 == [expr {($flag10_case9 == 1) ? "NOK" : "OK"}]" "（结论）ETREE1：不配置vplsType、ac为PORT+VLAN(100)；ETREE2：不配置vplsType、ac为PORT+VLAN(500)，，测试两条ETREE的业务" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "（结论）测试结束后配置恢复" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "（结论）测试过程中配置文件的上传" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "运行异常：错误为$err" "" "GPN_PTN_010"
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
