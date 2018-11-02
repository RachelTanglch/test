#!/bin/sh
# T1_GPN_PTN_001.tcl \
exec tclsh "$0" ${1+"$@"}
#测试名称：ptn001
#-----------------------------------------------------------------------------------------------------------------------------------
#测试目的：E-LINE/E-LAN/E-TREE业务创建、修改、删除和保存
#1-业务创建   
#2-业务修改
#3-业务保存和删除
#4-业务预配置（未实现）
#-----------------------------------------------------------------------------------------------------------------------------------
#测试拓扑类型二：（仅以7600/S为例）                                                                                                                             
#                                                                              
#                                    ___________                               
#                                   |   4GE/ge  |
#  _______                          |   8fx     |    
# |       |                         |           |
# |  PC   |_______Internet连接 ______|           |
# |_______|                         |           |       
#    /__\                           |GPN(7600/S)|                  
#                        TC1————————|           |            
#                                   |___________|           
#                                          
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
#   <1>配置PW所在的端口为NNI口，AC所在的口为UNI口
#   <2>配置vlan，加入端口和Ip
#   <3>创建lsp
#   <4>配置不正确的接口vlan name，系统有提示并创建失败
#   <5>配置下一跳ip为承载接口的地址，系统有提示并创建失败
#   <6>配置不正确的in/out label，系统有提示并创建失败
#   <7>配置不正确的lsp id，系统有提示并创建失败
#   <8>没有配置destination IP时进行undo shutdown，系统有提示不能激活
#   <9>undo shutdown后，配置其带宽信息，系统有提示并创建失败
#   <10>undo shutdown后，配置其性能统计使能/禁止，系统无异常
#2、搭建Test Case 2测试环境
#   <1>创建pw
#   <2>配置不正确的L2 vc id，系统有提示并创建失败
#   <3>配置不正确destination adress，系统有提示并创建失败
#   <4>配置不正确的remote/local label，系统有提示并创建失败
#   <5>配置不正确的lsp id，系统有提示并创建失败
#   <6>没有配置hqos使能时进行带宽信息配置，系统有提示不能配置
#   <7>配置其带宽信息时pir低于cir时，系统有提示
#   <8>配置其性能统计使能/禁止，系统无异常
#   <9>配置其控制字禁止/使能，系统无异常
#3、搭建Test Case 3测试环境
#   <1>创建ac
#   <2>接入模式为“端口+运营商vlan”时配置端口没有加入的或者错误vlan id时，系统有提示并创建失败
#   <3>配置不正确的pw name，系统有提示并创建失败
#   <4>配置其带宽信息时pir低于cir时，系统有提示
#   <5>配置其性能统计使能/禁止，系统无异常
#   <6>没有删除ac与pw的绑定关系，删除ac时，系统有提示不能删除
#   <7>删除了ac与pw的绑定关系，没有删除ac，删除运营商vlan，系统有提示，删除失败
#4、搭建Test Case 4测试环境
#   <1>再创建一条新E-LINE业务，配置相应LSP、PW、AC，可成功创建，发流验证对之前所创建的E-LINE业务无影响
#   <2>对已创建好的LSP/PW /AC的带宽信息进行修改，修改成功，系统无异常
#   <3>查看系统中已存在的E-LINE业务，保存配置，重启设备，设备可正常启动，配置无丢失
#   <4>删除E-LINE业务时，需先将AC与PW绑定关系删除，再按照顺序删除ac pw lsp 
#   <5>删除一条E-LINE业务不影响另一条
#-----------------------------------------------------------------------------------------------------------------------------------
set startSeconds [clock seconds]
package require gwd 2.0
package require stcPack
if {[catch {
	close stdout
	file mkdir "log"
	set fd_log [open "log\\GPN_PTN_001_LOG.txt" a]
	set stdout $fd_log
	chan configure $fd_log -blocking 0 -buffering none;#非阻塞模式 按行flush
	log_file log\\GPN_PTN_001_LOG.txt
	
	file mkdir "report"
	set fileId [open "report\\GPN_PTN_001_REPORT.txt" a+]
	chan configure $fileId -blocking 0 -buffering none;#非阻塞模式 按行flush
	
	file mkdir "debug"
	set fd_debug [open debug\\GPN_PTN_001_DEBUG.txt a]
	exp_internal -f debug\\GPN_PTN_001_DEBUG.txt 0
	chan configure $fd_debug -blocking 0 -buffering none;#非阻塞模式 按行flush

	source test\\PTN_VarSet.tcl
	source test\\PTN_Mode_Function.tcl
	
	set flagResult 0
	set flagCase1 0   ;#Test case 1标志位 
	set flagCase2 0   ;#Test case 2标志位
	set flagCase3 0   ;#Test case 3标志位 
	set flagCase4 0   ;#Test case 4标志位
	set flagCase5 0   ;#Test case 5标志位 
	
	set lFailFile ""
	set FLAGF 0
	
	set tcId 0
	set capId 0
	set cfgId 0
	#为测试结论预留空行
	for {set i 0} {$i < 80} {incr i} {
	    puts $fileId "                                                                                                                                                                                                                "	
	}
	
	puts $fileId "登录被测设备...\n"
	puts $fileId "\n=====登录被测设备1====\n"
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]

	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"		
	puts $fileId "===E-LINE/E-LAN/E-TREE业务创建、修改、删除和保存测试基础配置开始...\n"
	set cfgFlag 0
	lassign $lDev1TestPort testPort1 testPort2 testPort3 testPort4 testPort5 testPort6
        foreach port $lDev1TestPort {
        	if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
        		lappend cfgFlag [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "disable" "enable"]
        	}
        }
        ###端口为二三层接口设置参数
        if {[string match "L2" $Worklevel]} {
        	set interface1 v100
        	set interface2 v500
        	set interface3 v300
        	set interface4 v110
        	set interface5 v310
        	set interface6 v200
        	set interface7 v400
        	set interface8 v11
        	set interface9 v12
        } else {
        	set interface1 $testPort1.100
        	set interface2 $testPort1.500
        	set interface3 $testPort3.300
        	set interface4 $testPort2.110
        	set interface5 $testPort4.310
        	set interface6 $testPort6.200
        	set interface7 $testPort5.400
        	set interface8 $testPort5.11
        	set interface9 $testPort5.12
        }
	#用于导出被测设备用到的变量------
	set lSpawn_id "$telnet1"
	set lMatchType "$matchType1"
	set lDutType "$Gpn_type1"
	set lIp "$gpnIp1"
	#------用于导出被测设备用到的变量
	gwd::GWpublic_printAbnormal $fileId $fd_log $cfgFlag "FLAGA" $startSeconds "E-LINE/E-LAN/E-TREE业务创建、修改、删除和保存测试基础配置失败，测试结束" \
		"E-LINE/E-LAN/E-TREE业务创建、修改、删除和保存测试基础配置成功，继续后面的测试" "GPN_PTN_001"
	puts $fileId ""
	puts $fileId "===E-LINE/E-LAN/E-TREE业务创建、修改、删除和保存测试基础配置结束..."
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId ""
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 1 lsp的参数合法性测试\n"
        #   <1>配置PW所在的端口为NNI口，AC所在的口为UNI口
        #   <2>配置vlan，加入端口和Ip
        #   <3>创建lsp
        #   <4>配置不正确的接口vlan name，系统有提示并创建失败
        #   <5>配置下一跳ip为承载接口的地址，系统有提示并创建失败
        #   <6>配置不正确的in/out label，系统有提示并创建失败
        #   <7>配置不正确的lsp id，系统有提示并创建失败
        #   <8>没有配置destination IP时进行undo shutdown，系统有提示不能激活
        #   <9>undo shutdown后，配置其带宽信息，系统有提示并创建失败
        #   <10>undo shutdown后，配置其性能统计使能/禁止，系统无异常
	set flag1_case1 0
	set flag2_case1 0
	set flag3_case1 0
	set flag4_case1 0
	set flag5_case1 0
	set flag6_case1 0
	
	
        set ip 192.1.1.1 ;#本端ip
        set ip2 192.1.1.2;#下一跳ip
        set ip3 192.4.1.1;#本端ip
        set ip4 192.4.1.2;#下一跳ip
        set ip13 192.4.3.2
        set ip14 192.4.4.2
        set ip31 192.4.3.1
        set ip41 192.4.4.1
        set address 10.1.1.1
        set address2 10.1.1.2
        set address3 10.4.1.1
        set address13 10.4.3.3
        set address14 10.4.4.4
        set bandwidth 50000
        set bandwidth3 50000
        set cirwidth 50000
        set cirwidth3 50000
        set pirwidth 80000
        set pirwidth3 80000
        set pirwidth5 40000
	if {[string match "L2" $Worklevel]} {
        	gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort1 "enable"	
	}
        PTN_NNI_AddInterIp $fileId $Worklevel $interface1 $ip $testPort1 $matchType1 $Gpn_type1 $telnet1
        ###配置超过长度限制和非法的lsp名称，验证是否创建失败
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====创建lsp时配置不符合要求的lsp名字，验证是否创建失败  测试开始=====\n"
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lspabcdefghijklmnopqrstuvwxyw_12"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入lsp名字lspabcdefghijklmnopqrstuvwxyw_12 长度超过限制字节，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lspabcdefghijklmnopqrstuvwxyw_12"
	} else {
		gwd::GWpublic_print "OK" "创建lsp时输入lsp名字lspabcdefghijklmnopqrstuvwxyw_12 长度超过限制字节，创建失败" $fileId
	}	
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "@#awefaweflsp"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：@#awefaweflsp，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "@#awefaweflsp"
	} else {
		gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：@#awefaweflsp，创建失败" $fileId
	}
	
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernetlsp1"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：ethernetlsp1，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "ethernetlsp1"
	} else {
		gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：ethernetlsp1，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "trunklsp2"]} {
        	set flag1_case1 1
        	gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：trunklsp2，创建成功" $fileId	
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "trunklsp2"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：trunklsp2，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "e1lspa"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：e1lspa，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "e1lspa"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：e1lspa，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "vlaniflspb"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：vlaniflspb，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "vlaniflspb"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：vlaniflspb，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "trunklspc"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：trunklspc，创建成功" $fileId	
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "trunklspc"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：trunklspc，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "e1lspd"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：e1lspd，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "e1lspd"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：e1lspd，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "loopback0lspe"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：loopback0lspe，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "loopback0lspe"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：loopback0lspe，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "loopback9lspf"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：loopback9lspf，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "loopback9lspf"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：loopback9lspf，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "Null0lspg"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：Null0lspg，创建成功" $fileId	
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "Null0lspg"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：Null0lspg，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "Null9lsph"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：Null9lsph，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "Null9lsph"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：Null9lsph，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp/1"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：lsp/1，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp/1"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：lsp/1，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log {lsp\\}]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：lsp\\，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId {lsp\\}
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：lsp\\，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp:3"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：lsp:3，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp:3"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：lsp:3，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp*4"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：lsp*4，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp*4"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：lsp*4，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp<7"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：lsp<7，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp<7"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：lsp<7，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp>8"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：lsp>8，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp>8"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：lsp>8，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp'9"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：lsp'9，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp'9"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：lsp'9，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp|10"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：lsp|10，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp|10"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：lsp|10，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp%11"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：lsp%11，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp%11"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：lsp%11，创建失败" $fileId
	}
        if {![gwd::GWStaLsp_AddLspName $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp a12"]} {
		set flag1_case1 1
		gwd::GWpublic_print "NOK" "创建lsp时输入非法lsp名字：lsp a12，创建成功" $fileId
		gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp a12"
	} else {
	       gwd::GWpublic_print "OK" "创建lsp时输入非法lsp名字：lsp a12，创建失败" $fileId
	}
	puts $fileId ""
	if {$flag1_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA1（结论）创建lsp时配置不符合要求的lsp名字，创建成功" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA1（结论）创建lsp时配置不符合要求的lsp名字，创建失败" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====创建lsp时配置不符合要求的lsp名字，验证是否创建失败  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置lsp时配置不正确的接口Vlan、下一跳ip，验证是否配置失败  测试开始=====\n"
	###配置不正确的接口Vlan，下一跳ip，入标签，出标签，lspid能否成功配置lsp
        if {![gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" $interface2 $ip2 "20" "30" "normal" 1]} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "配置lsp时输入错误的vlan接口，配置成功" $fileId	
	} else {
	       gwd::GWpublic_print "OK" "配置lsp时输入错误的vlan接口，配置失败" $fileId
	}
        if {![gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" $interface1 "255.255.255.255" "20" "30" "normal" 1]} {
		set flag2_case1 1
		gwd::GWpublic_print "NOK" "配置lsp时输入错误的下一跳ip，配置成功" $fileId	
	} else {
	       gwd::GWpublic_print "OK" "配置lsp时输入错误的下一跳ip，配置失败" $fileId
	}
	puts $fileId ""
	if {$flag2_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA2（结论）配置lsp时配置错误的接口Vlan、下一跳ip，配置成功" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA2（结论）配置lsp时配置错误的接口Vlan、下一跳ip，配置失败" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置lsp时配置错误的接口Vlan、下一跳ip，验证是否配置失败  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置lsp时配置错误的入标签、出标签、lspId，验证是否配置失败  测试开始=====\n"
        if {![gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" $interface1 $ip2 "10" "30" "normal" 1]} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "配置lsp时输入错误的入口标签，配置成功" $fileId	
	} else {
	       gwd::GWpublic_print "OK" "配置lsp时输入错误的入口标签，配置失败" $fileId
	}
        if {![gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" $interface1 $ip2 "20" "15" "normal" 1]} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "配置lsp时输入错误的出口标签，配置成功" $fileId	
	} else {
	       gwd::GWpublic_print "OK" "配置lsp时输入错误的出口标签，配置失败" $fileId
	}
        if {![gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" $interface1 $ip2 "20" "30" "normal" 65536]} {
		set flag3_case1 1
		gwd::GWpublic_print "NOK" "配置lsp时输入错误的lspId，配置成功" $fileId	
	} else {
	       gwd::GWpublic_print "OK" "配置lsp时输入错误的lspId，配置失败" $fileId
	}
	puts $fileId ""
	if {$flag3_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA3（结论）配置lsp时配置错误的入标签、出标签、lspId，配置成功" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA3（结论）配置lsp时配置错误的入标签、出标签、lspId，配置失败" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置lsp时配置错误的入标签、出标签、lspId，验证是否配置失败  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====创建和配置lsp时各个参数配置都正确，验证是否配置成功  测试开始=====\n"
        if {[gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $interface1 $ip2 "20" "30" "normal" 1]} {
        	set flag4_case1 1
		gwd::GWpublic_print "NOK" "创建和配置lsp时各个参数配置都正确，配置失败" $fileId	
	} else {
	       gwd::GWpublic_print "OK" "创建和配置lsp时各个参数配置都正确，配置成功" $fileId
	}
	puts $fileId ""
	if {$flag4_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA4（结论）创建和配置lsp时各个参数配置都正确，配置失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA4（结论）创建和配置lsp时各个参数配置都正确，配置成功" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====创建和配置lsp时各个参数配置都正确，验证是否配置成功  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====lsp的激活测试  测试开始=====\n"
        ###lsp的激活测试	
        if {![gwd::GWStaLsp_AddLspEn $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" "undo shutdown"]} {
        	set flag5_case1 1
		gwd::GWpublic_print "NOK" "没有配置目标网元时激活lsp，配置成功" $fileId
        } else {
		gwd::GWpublic_print "OK" "没有配置目标网元时激活lsp，配置失败" $fileId	
        }
	
	gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $address
        if {[gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"]} {
		set flag5_case1 1
		gwd::GWpublic_print "NOK" "配置了目标网元时激活lsp，配置失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "配置了目标网元时激活lsp，配置成功" $fileId
	}
	puts $fileId ""
	if {$flag5_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA5（结论）lsp的激活测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA5（结论）lsp的激活测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====lsp的激活测试  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====lsp的带宽和性能统计配置测试  测试开始=====\n"
	gwd::GWStaLsp_AddLspEn $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "undo shutdown"
        if {![gwd::GWpublic_addBandwidth $telnet1 $matchType1 $Gpn_type1 $fd_log "lsp1" $bandwidth]} {
		set flag6_case1 1
		gwd::GWpublic_print "NOK" "激活lsp后配置带宽信息，配置成功" $fileId	
	} else {
		gwd::GWpublic_print "OK" "激活lsp后配置带宽信息，配置失败" $fileId
	}
	gwd::GWStaLsp_AddLspEn $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "shutdown"
	if {[gwd::GWpublic_addBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" $bandwidth]} {
		set flag6_case1 1
		gwd::GWpublic_print "NOK" "shutdown lsp后配置带宽信息，配置失败" $fileId
			
	} else {
		gwd::GWpublic_print "OK" "shutdown lsp后配置带宽信息，配置成功" $fileId
		
	}
	
	gwd::GWStaLsp_AddLspEn $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "undo shutdown"
        if {[gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "enable"]} {
		set flag6_case1 1
		gwd::GWpublic_print "NOK" "激活lsp后使能性能统计，配置失败" $fileId	
	} else {
		gwd::GWpublic_print "OK" "激活lsp后使能性能统计，配置成功" $fileId
	}
        if {[gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "disable"]} {
		set flag6_case1 1
		gwd::GWpublic_print "NOK" "激活lsp后去使能性能统计，配置失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "激活lsp后去使能性能统计，配置成功" $fileId	
	}	
        gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1" "enable"
        gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"
	puts $fileId ""
	if {$flag6_case1 == 1} {
		set flagCase1 1
		gwd::GWpublic_print "NOK" "FA6（结论）lsp的带宽和性能统计配置测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA6（结论）lsp的带宽和性能统计配置测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====lsp的带宽和性能统计配置测试  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
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
        puts $fileId "Test Case 1 lsp的参数合法性测试  测试结束\n"
        puts $fileId "**************************************************************************************\n"
        puts $fileId "**************************************************************************************\n"
        gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 2 创建pw，遍历参数测试\n"
	#   <1>创建pw
	#   <2>配置不正确的L2 vc id，系统有提示并创建失败
	#   <3>配置不正确destination adress，系统有提示并创建失败
	#   <4>配置不正确的remote/local label，系统有提示并创建失败
	#   <5>配置不正确的lsp id，系统有提示并创建失败
	#   <6>没有配置hqos使能时进行带宽信息配置，系统有提示不能激活
	#   <7>配置其带宽信息时pir低于cir时，系统有提示
	#   <8>配置其性能统计使能/禁止，系统无异常
	#   <9>配置其控制字禁止/使能，系统无异常
	###配置超过长度限制和非法的pw名称，验证是否创建失败
	set flag1_case2 0
	set flag2_case2 0
	set flag3_case2 0
	set flag4_case2 0
	set flag5_case2 0
	set flag6_case2 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====创建pw时配置不符合要求的pw名字，验证是否创建失败  测试开始=====\n"
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pwabcdefghijklmnopqrstuvwxyw_123"]
        if {$ret == 2} {
		gwd::GWpublic_print "OK" "创建pw时输入pw名字pwabcdefghijklmnopqrstuvwxyw_123长度超过限制字节，创建失败" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pwabcdefghijklmnopqrstuvwxyw_123"
			gwd::GWpublic_print "NOK" "创建pw时输入pw名字pwabcdefghijklmnopqrstuvwxyw_123长度超过限制字节，创建成功" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "创建pw时输入pw名字pwabcdefghijklmnopqrstuvwxyw_123长度超过限制字节，创建失败但是系统提示错误" $fileId	
		}
	}
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "@#awefawefpw"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：@#awefawefpw，创建失败" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "@#awefawefpw"
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：@#awefawefpw，创建成功" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：@#awefawefpw，创建失败但是系统提示错误" $fileId	
		}
	}
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernetpw1"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：ethernetpw1，创建失败" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "ethernetpw1"
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：ethernetpw1，创建成功" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：ethernetpw1，创建失败但是系统提示错误" $fileId	
		}
	}
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "trunkpw2"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：trunkpw2，创建失败" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "trunkpw2"
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：trunkpw2，创建成功" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：trunkpw2，创建失败但是系统提示错误" $fileId	
		}
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "e1pwa"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：e1pwa，创建失败" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "e1pwa"
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：e1pwa，创建成功" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：e1pwa，创建失败但是系统提示错误" $fileId	
		}
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "vlanifpwb"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：vlanifpwb，创建失败" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "vlanifpwb"
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：vlanifpwb，创建成功" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：vlanifpwb，创建失败但是系统提示错误" $fileId	
		}
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "trunkpwc"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：trunkpwc，创建失败" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "trunkpwc"
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：trunkpwc，创建成功" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：trunkpwc，创建失败但是系统提示错误" $fileId	
		}
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "e1pwd"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：e1pwd，创建失败" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "e1pwd"
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：e1pwd，创建成功" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：e1pwd，创建失败但是系统提示错误" $fileId	
		}
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "loopback0pwe"]
	if {$ret == 3} {
		gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：loopback0pwe，创建失败" $fileId
	} else {
		set flag1_case2 1
		if {$ret == 0} {
			gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "loopback0pwe"
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：loopback0pwe，创建成功" $fileId	
		} else {
			gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：loopback0pwe，创建失败但是系统提示错误" $fileId	
		}
	}
        
        set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "loopback9pwf"]
        if {$ret == 3} {
               gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：loopback9pwf，创建失败" $fileId
        } else {
               set flag1_case2 1
               if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "loopback9pwf"
        	       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：loopback9pwf，创建成功" $fileId	
               } else {
        	       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：loopback9pwf，创建失败但是系统提示错误" $fileId	
               }
        }
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "Null0pwg"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：Null0pwg，创建失败" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "Null0pwg"
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：Null0pwg，创建成功" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：Null0pwg，创建失败但是系统提示错误" $fileId	
	       }
	}
        
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "Null9pwh"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：Null9pwh，创建失败" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "Null9pwh"
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：Null9pwh，创建成功" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：Null9pwh，创建失败但是系统提示错误" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw/1"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：pw/1，创建失败" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw/1"
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw/1，创建成功" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw/1，创建失败但是系统提示错误" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log {pw\\}]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：pw\\，创建失败" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId {pw\\}
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw\\，创建成功" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw\\，创建失败但是系统提示错误" $fileId	
	       }
	}
       
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw:3"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：pw:3，创建失败" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw:3"
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw:3，创建成功" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw:3，创建失败但是系统提示错误" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw*4"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：pw*4，创建失败" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw*4"
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw*4，创建成功" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw*4，创建失败但是系统提示错误" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw<7"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：pw<7，创建失败" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw<7"
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw<7，创建成功" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw<7，创建失败但是系统提示错误" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw>8"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：pw>8，创建失败" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw>8"
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw>8，创建成功" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw>8，创建失败但是系统提示错误" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw'9"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：pw'9，创建失败" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw'9"
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw'9，创建成功" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw'9，创建失败但是系统提示错误" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw|10"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：pw|10，创建失败" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw|10"
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw|10，创建成功" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw|10，创建失败但是系统提示错误" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw%11"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：pw%11，创建失败" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw%11"
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw%11，创建成功" $fileId	
	       } else {
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw%11，创建失败但是系统提示错误" $fileId	
	       }
	}
	
	set ret [gwd::GWStaPw_AddPwName $telnet1 $matchType1 $Gpn_type1 $fd_log "pw a12"]
	if {$ret == 3} {
	       gwd::GWpublic_print "OK" "创建pw时输入非法pw名字：pw a12，创建失败" $fileId
	} else {
	       set flag1_case2 1
	       if {$ret == 0} {
		       gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw a12"
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw a12，创建成功" $fileId
	       } else {
		       gwd::GWpublic_print "NOK" "创建pw时输入非法pw名字：pw a12，创建失败但是系统提示错误" $fileId	
	       }
	}
	puts $fileId ""
	if {$flag1_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA7（结论）创建pw时配置不符合要求的pw名字，创建成功" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA7（结论）创建pw时配置不符合要求的pw名字，创建失败" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====创建pw时配置不符合要求的pw名字，验证是否创建失败  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置pw时配置错误的Vcid，目标网元，本地标签，远程标签，lspId，验证是否配置失败  测试开始=====\n"
        if {![gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fd_log "pw1" "l2transport" "2147483647" "" $address "40" "50" "1" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "创建pw时输入不正确的静态pw id：2147483647，创建成功" $fileId	
	} else {
		gwd::GWpublic_print "OK" "创建pw时输入不正确的静态pw id：2147483647，创建失败" $fileId
	}
        if {![gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fd_log "pw1" "l2transport" "1" "" "255.255.255.256" "40" "50" "1" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "创建pw时输入不正确的destination adress：255.255.255.256，创建成功" $fileId	
	} else {
		gwd::GWpublic_print "OK" "创建pw时输入不正确的destination adress：255.255.255.256，创建失败" $fileId
	}
        if {![gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fd_log "pw1" "l2transport" "1" "" $address "10" "50" "1" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "创建pw时输入不正确的Remote label：10，创建成功" $fileId
	} else {
		gwd::GWpublic_print "OK" "创建pw时输入不正确的Remote label：10，创建失败" $fileId		
	}
        if {![gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fd_log "pw1" "l2transport" "1" "" $address "40" "10" "1" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "创建pw时输入不正确的Local label：10，创建成功" $fileId	
	} else {
		gwd::GWpublic_print "OK" "创建pw时输入不正确的Local label：10，创建失败" $fileId
	}
        if {![gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fd_log "pw1" "l2transport" "1" "" $address "40" "50" "20" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "创建pw时输入不存在的lsp id：20，创建成功" $fileId
	} else {
		gwd::GWpublic_print "OK" "创建pw时输入不存在的lsp id：20，创建失败" $fileId	
	}
        if {[gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address "40" "50" "1" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag2_case2 1
		gwd::GWpublic_print "NOK" "创建pw时输入的所有参数都正确，创建失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "创建pw时输入的所有参数都正确，创建成功" $fileId
	}
	puts $fileId ""
	if {$flag2_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA8（结论）配置pw时配置错误的参数，配置成功" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA8（结论）配置pw时配置错误的参数，配置失败" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置pw时配置错误的Vcid，目标网元，本地标签，远程标签，lspId，验证是否配置失败  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置错误的pw静态标签和动态标签的范围，验证是否配置失败  测试开始=====\n"
        if {[gwd::GWpublic_addPwLabelRange $telnet1 $matchType1 $Gpn_type1 $fd_log "15" "39" "2048" "1048575"] != 2} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "设置pw的标签范围时静态标签的最小值小于最小标称值，设置成功或提示错误" $fileId
	} else {
		gwd::GWpublic_print "OK" "设置pw的标签范围时静态标签的最小值小于最小标称值，设置失败且提示正确" $fileId
	}
        if {[gwd::GWpublic_addPwLabelRange $telnet1 $matchType1 $Gpn_type1 $fd_log "16" "1048576" "2048" "1048575"] != 3} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "设置pw的标签范围时静态标签的最大值大于最大标称值，设置成功或提示错误" $fileId	
	} else {
		gwd::GWpublic_print "OK" "设置pw的标签范围时静态标签的最大值大于最大标称值，设置失败且提示正确" $fileId	
	}
        if {[gwd::GWpublic_addPwLabelRange $telnet1 $matchType1 $Gpn_type1 $fd_log "16" "2049" "2048" "1048575"] != 4} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "设置pw的标签范围时静态标签的范围与动态标签的范围有冲突，设置成功或提示错误" $fileId
	} else {
		gwd::GWpublic_print "OK" "设置pw的标签范围时静态标签的范围与动态标签的范围有冲突，设置失败且提示正确" $fileId	
	}
        if {[gwd::GWpublic_addPwLabelRange $telnet1 $matchType1 $Gpn_type1 $fileId "16" "2017" "2048" "1048575"] != 0} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "设置pw的标签范围时静态标签的范围与动态标签都正确，设置失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "设置pw的标签范围时静态标签的范围与动态标签都正确，设置成功" $fileId
	}
	#由于修改标签范围需保存重启后才生效，所以进行保存重启操作后再查询和设置测试
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
        gwd::GWpublic_getPwLabelRange $telnet1 $matchType1 $Gpn_type1 $fileId lresult
	puts "lresult:$lresult"
        if {([dict get $lresult static min] != 16) || ([dict get $lresult static max] != 2017) || ([dict get $lresult dynamic min] != 2048) \
        	|| ([dict get $lresult dynamic max] != 1048575)} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "pw静态标签的最小值设置值为16查询值为[dict get $lresult static min]最大值设置值为2017查询值为[dict get $lresult static max]；\
			动态标签的最小值设置值为2048查询值为[dict get $lresult dynamic min]最大值设置值为1048575查询值为[dict get $lresult dynamic max]" $fileId
	} else {
		gwd::GWpublic_print "OK" "pw静态标签的最小值应为16实为[dict get $lresult static min]最大值应为2017实为[dict get $lresult static max]；\
			动态标签的最小值应为2048实为[dict get $lresult dynamic min]最大值应为1048575实为[dict get $lresult dynamic max]" $fileId
	}
	
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        if {[gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "l2transport" "1" "" $address "1000" "1001" "1" "nochange" "" "1" "0" "0x8100" "0x8100" ""]} {
		set flag3_case2 1
		gwd::GWpublic_print "NOK" "设置正确的静态区间后再配置pw，配置失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "设置正确的静态区间后再配置pw，配置成功" $fileId
	}
	puts $fileId ""
	if {$flag3_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FA9（结论）pw静态标签和动态标签范围的配置测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FA9（结论）pw静态标签和动态标签范围的配置测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置错误的pw静态标签和动态标签的范围，验证是否配置失败  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====pw带宽的配置测试  测试开始=====\n"
        if {![gwd::GWpublic_addPwBandwidth $telnet1 $matchType1 $Gpn_type1 $fd_log "pw1" $cirwidth $pirwidth]} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "没有使能HQOS时配置PW带宽，配置成功" $fileId	
	} else {
		gwd::GWpublic_print "OK" "没有使能HQOS时配置PW带宽，配置失败" $fileId
	}
        gwd::GWpublic_cfgPwHqosEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "enable"
        if {[gwd::GWpublic_addPwBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" $cirwidth $pirwidth]} {
		set flag4_case2 1
		gwd::GWpublic_print "NOK" "使能HQOS时配置PW带宽，配置失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "使能HQOS时配置PW带宽，配置成功" $fileId	
	}
	puts $fileId ""
	if {$flag4_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB1（结论）pw带宽的配置测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB1（结论）pw带宽的配置测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====pw带宽的配置测试  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====使能/去使能pw性能统计的配置测试  测试开始=====\n"
        if {[gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "enable"]} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "使能PW性能统计，配置失败" $fileId	
	} else {
		gwd::GWpublic_print "OK" "使能PW性能统计，配置成功" $fileId	
	}
        if {[gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "disable"]} {
		set flag5_case2 1
		gwd::GWpublic_print "NOK" "去使能PW性能统计，配置失败" $fileId	
	} else {
		gwd::GWpublic_print "OK" "去使能PW性能统计，配置成功" $fileId
	}
        gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "enable"
	puts $fileId ""
	if {$flag5_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB2（结论）使能/去使能pw性能统计的配置测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB2（结论）使能/去使能pw性能统计的配置测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====使能/去使能pw性能统计的配置测试  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====使能/去使能pw控制字的配置测试  测试开始=====\n"
        if {[gwd::GWpublic_addPwWordEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "disable"]} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "使能PW控制字，配置失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "使能PW控制字，配置成功" $fileId	
	}
        if {[gwd::GWpublic_addPwWordEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "enable"]} {
		set flag6_case2 1
		gwd::GWpublic_print "NOK" "去使能PW控制字，配置失败" $fileId	
	} else {
		gwd::GWpublic_print "OK" "去使能PW控制字，配置成功" $fileId
	}
        gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" result
	puts $fileId ""
	if {$flag6_case2 == 1} {
		set flagCase2 1
		gwd::GWpublic_print "NOK" "FB3（结论）使能/去使能pw控制字的配置测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB3（结论）使能/去使能pw控制字的配置测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====使能/去使能pw控制字的配置测试  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
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
	puts $fileId "Test Case 2 创建pw，遍历参数测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 3 创建ac，遍历参数测试\n"
        #   <1>创建ac
        #   <2>接入模式为“端口+运营商vlan”时配置端口没有加入的或者错误vlan id时，系统有提示并创建失败
        #   <3>配置不正确的pw name，系统有提示并创建失败
        #   <4>配置其带宽信息时pir低于cir时，系统有提示
        #   <5>配置其性能统计使能/禁止，系统无异常
        #   <6>没有删除ac与pw的绑定关系，删除ac时，系统有提示不能删除
        #   <7>删除了ac与pw的绑定关系，没有删除ac，删除运营商vlan，系统有提示，删除失败
	set flag1_case3 0
	set flag2_case3 0
	set flag3_case3 0
	set flag4_case3 0
	set flag5_case3 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====创建ac时配置不符合要求的ac名字，验证是否创建失败  测试开始=====\n"
        PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "200" $testPort6
        
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "acabcdefghijklmnopqrstuvwxyw_123"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入ac名字acabcdefghijklmnopqrstuvwxyw_123 长度超过限制字节，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "acabcdefghijklmnopqrstuvwxyw_123"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入ac名字lspabcdefghijklmnopqrstuvwxyw_12 长度超过限制字节，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "@#awefawefac"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：@#awefawefac，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "@#awefawefac"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：@#awefawefac，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ethernetac1"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：ethernetac1，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ethernetac1"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：ethernetac1，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "trunkac2"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：trunkac2，创建成功" $fileId	
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "trunkac2"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：trunkac2，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "e1aca"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：e1aca，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "e1aca"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：e1aca，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "vlanifacb"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：vlanifacb，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "vlanifacb"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：vlanifacb，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "trunkacc"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：trunkacc，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "trunkacc"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：trunkacc，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "e1acd"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：e1acd，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "e1acd"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：e1acd，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "loopback0ace"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：loopback0ace，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "loopback0ace"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：loopback0ace，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "loopback9acf"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：loopback9acf，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "loopback9acf"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：loopback9acf，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "Null0acg"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：Null0acg，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "Null0acg"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：Null0acg，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "Null9ach"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：Null9ach，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "Null9ach"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：Null9ach，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac/1"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：ac/1，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac/1"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：ac/1，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log {ac\\}]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：ac\\，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId {ac\\}
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：ac\\，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac:3"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：ac:3，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac:3"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：ac:3，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac*4"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：ac*4，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac*4"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：ac*4，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac<7"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：ac<7，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac<7"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：ac<7，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac>8"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：ac>8，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac>8"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：ac>8，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac'9"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：ac'9，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac'9"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：ac'9，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac|10"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：ac|10，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac|10"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：ac|10，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac%11"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：ac%11，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac%11"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：ac%11，创建失败" $fileId
	}
        if {![gwd::GWAc_AddName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac a12"]} {
		set flag1_case3 1
		gwd::GWpublic_print "NOK" "创建ac时输入非法ac名字：ac a12，创建成功" $fileId
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac a12"
	} else {
		gwd::GWpublic_print "OK" "创建ac时输入非法ac名字：ac a12，创建失败" $fileId
	}
	puts $fileId ""
	if {$flag1_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB4（结论）创建ac时配置不符合要求的ac名字，创建成功" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB4（结论）创建ac时配置不符合要求的ac名字，创建失败" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====创建ac时配置不符合要求的ac名字，验证是否创建失败  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置ac时使用的端口号和vlan参数测试  测试开始=====\n"
        if {[gwd::GWAc_AddInfo $telnet1 $matchType1 $Gpn_type1 $fd_log "ac200" "" $testPort5  200 0 "nochange" 1 0 0 "0x8100"]} {
		gwd::GWpublic_print "OK" "配置ac时输入不正确的端口号，配置失败" $fileId	
	} else {
		set flag2_case3 1
		gwd::GWpublic_print "NOK" "配置ac时输入不正确的端口号，配置成功" $fileId
	}
        if {[gwd::GWAc_AddInfo $telnet1 $matchType1 $Gpn_type1 $fd_log "ac200" "" $testPort6  100 0 "nochange" 1 0 0 "0x8100"]} {
		gwd::GWpublic_print "OK" "配置ac时输入不正确的运营商vlan，配置失败" $fileId	
	} else {
		set flag2_case3 1
		gwd::GWpublic_print "NOK" "配置ac时输入不正确的运营商vlan，配置成功" $fileId
	}
        ###配置正确的端口或者vid
        if {[gwd::GWAc_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac200" "" $testPort6  200 0 "nochange" 1 0 0 "0x8100"]} {
		set flag2_case3 1
		gwd::GWpublic_print "NOK" "配置ac时输入正确的端口号和vlan，配置失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "配置ac时输入正确的端口号和vlan，配置成功" $fileId	
	}
	puts $fileId ""
	if {$flag2_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB5（结论）配置ac时使用的端口号和vlan参数测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB5（结论）配置ac时使用的端口号和vlan参数测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====配置ac时使用的端口号和vlan参数测试  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ac绑定pw的测试  测试开始=====\n"
        if {[gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fd_log "ac200" "pw2" "eline"]} {
		gwd::GWpublic_print "OK" "ac绑定的pw不存在，绑定失败" $fileId	
	} else {
		set flag3_case3 1
		gwd::GWpublic_print "NOK" "ac绑定的pw不存在，绑定成功" $fileId
	}
        if {[gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac200" "pw1" "eline"]} {
		set flag3_case3 1
		gwd::GWpublic_print "NOK" "ac绑定pw的参数都正确，绑定失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "ac绑定pw的参数都正确，绑定成功" $fileId	
	}
	puts $fileId ""
	if {$flag3_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB6（结论）ac绑定pw的测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB6（结论）ac绑定pw的测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ac绑定pw的测试  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ac配置带宽和端口统计的测试  测试开始=====\n"
        ###配置ac带宽信息和端口统计 
        if {[gwd::GWpublic_addAcBandwidth $telnet1 $matchType1 $Gpn_type1 $fd_log "ac200" $cirwidth $pirwidth5]} {
		gwd::GWpublic_print "OK" "配置ac带宽时pir值小于cir值，配置失败" $fileId	
	} else {
		set flag4_case3 1
		gwd::GWpublic_print "NOK" "配置ac带宽时pir值小于cir值，配置成功" $fileId
	}
        if {[gwd::GWpublic_addAcBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "ac200" $cirwidth $pirwidth]} {
		set flag4_case3 1
		gwd::GWpublic_print "NOK" "配置ac带宽时pir和cir都正确，配置失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "配置ac带宽时pir和cir都正确，配置成功" $fileId	
	}
        if {[gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac200" "enable"]} {
		set flag4_case3 1
		gwd::GWpublic_print "NOK" "使能ac性能统计，配置失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "使能ac性能统计，配置成功" $fileId	
	}
        if {[gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac200" "disable"]} {
		set flag4_case3 1
		gwd::GWpublic_print "NOK" "去使能ac性能统计，配置失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "去使能ac性能统计，配置成功" $fileId
	}
	puts $fileId ""
	if {$flag4_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB7（结论）ac配置带宽和端口统计的测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB7（结论）ac配置带宽和端口统计的测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ac配置带宽和端口统计的测试  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除ac及其绑定的测试  测试开始=====\n"
        if {[gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fd_log "ac200"]} {
		gwd::GWpublic_print "OK" "没有删除ac绑定时删除ac，删除失败" $fileId
	} else {
		set flag5_case3 1
		gwd::GWpublic_print "NOK" "没有删除ac绑定时删除ac，删除成功" $fileId	
	}
	gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac200"
	set ret [PTN_DelInterVid $fd_log $Worklevel $interface6 $matchType1 $Gpn_type1 $telnet1]
	if {[string match "L2" $Worklevel]} {
		if {$ret == 0} {
			set flag5_case3 1
			gwd::GWpublic_print "NOK" "二层接口在没有删除ac的情况下可以删除vlan200" $fileId
			
		} else {
			gwd::GWpublic_print "OK" "二层接口在没有删除ac的情况下不可以删除vlan200" $fileId	
		}
	} else {
		if {$ret == 1} {
			set flag5_case3 1
			gwd::GWpublic_print "NOK" "三层接口在没有删除ac的情况下不可以删除子接口$interface6" $fileId
		} else {
			gwd::GWpublic_print "OK" "三层接口在没有删除ac的情况下可以删除子接口$interface6" $fileId
		}
		PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "200" $testPort6
	}
	set ret [PTN_DelInterVid_new $fileId $Worklevel $testPort1.100 $matchType1 $Gpn_type1 $telnet1]
	if {[string match "L2" $Worklevel]} {
		if {$ret == 0} {
			set flag5_case3 1
			gwd::GWpublic_print "NOK" "二层接口在没有删除lsp的情况下可以删除承载lsp的vlan v100" $fileId
			
		} else {
			gwd::GWpublic_print "OK" "二层接口在没有删除lsp的情况下不可以删除承载lsp的vlan v100" $fileId	
		}
	} else {
		if {$ret == 1} {
			set flag5_case3 1
			gwd::GWpublic_print "NOK" "三层接口在没有删除lsp的情况下可以删除承载lsp的子接口$testPort1" $fileId
		} else {
			gwd::GWpublic_print "OK" "三层接口在没有删除lsp的情况下不可以删除承载lsp的子接口$testPort1" $fileId
		}
		PTN_NNI_AddInterIp $fileId $Worklevel $interface1 $ip $testPort1 $matchType1 $Gpn_type1 $telnet1
	}
        gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac200" "pw1" "eline"
        gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac200"
	puts $fileId ""
	if {$flag5_case3 == 1} {
		set flagCase3 1
		gwd::GWpublic_print "NOK" "FB8（结论）删除ac及其绑定的测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB8（结论）删除ac及其绑定的测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除ac及其绑定的测试  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
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
	puts $fileId "Test Case 3 创建ac，遍历参数测试  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 4 新建E-LINE业务，测试两个E-LINE业务是否互相影响\n"
        #   <1>再创建一条新E-LINE业务，配置相应LSP、PW、AC，可成功创建，发流验证对之前所创建的E-LINE业务无影响
        #   <2>对已创建好的LSP/PW/AC的带宽信息进行修改，修改成功，系统无异常
        #   <3>查看系统中已存在的E-LINE业务，保存配置，重启设备，设备可正常启动，配置无丢失
        #   <4>删除E-LINE业务时，需先将AC与PW绑定关系删除，再按照顺序删除ac pw lsp 
        #   <5>删除一条E-LINE业务不影响另一条
	set flag1_case4 0
	set flag2_case4 0
	set flag3_case4 0
	set flag4_case4 0
	set flag5_case4 0
	set flag6_case4 0
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在已有一条E-LINE业务的基础上新建lsp并对新建lsp进行配置 测试开始=====\n"
	if {[string match "L2" $Worklevel]} {
		gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort3 "enable"
	}
	lappend flag1_case4 [PTN_NNI_AddInterIp $fileId $Worklevel $interface3 $ip3 $testPort3 $matchType1 $Gpn_type1 $telnet1]
        #####创建LSP并查询
        lappend flag1_case4 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" $interface3 $ip4 "200" "300" "normal" "2"]
	lappend flag1_case4 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" $address3]
	lappend flag1_case4 [gwd::GWpublic_addBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" $bandwidth3]
	lappend flag1_case4 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"]
	lappend flag1_case4 [gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" "enable"]
	lappend flag1_case4 [gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag1_case4]} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FB9（结论）在已有一条E-LINE业务的基础上新建lsp并对新建lsp进行配置" $fileId
	} else {
		gwd::GWpublic_print "OK" "FB9（结论）在已有一条E-LINE业务的基础上新建lsp并对新建lsp进行配置" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在已有一条E-LINE业务的基础上新建lsp并对新建lsp进行配置  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在已有一条E-LINE业务的基础上新建pw并对新建pw进行配置  测试开始=====\n"
        lappend flag2_case4 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "l2transport" "2" "" $address3 "400" "500" "2" "nochange" "" 1 0 "0x8100" "0x8100" ""]
        lappend flag2_case4 [gwd::GWpublic_cfgPwHqosEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "enable"]
        lappend flag2_case4 [gwd::GWpublic_addPwBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" $cirwidth3 $pirwidth3]
        lappend flag2_case4 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "enable"]
        lappend flag2_case4 [gwd::GWpublic_addPwWordEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "disable"]
        lappend flag2_case4 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" result]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag2_case4]} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC1（结论）在已有一条E-LINE业务的基础上新建pw并对新建pw进行配置" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC1（结论）在已有一条E-LINE业务的基础上新建pw并对新建pw进行配置" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在已有一条E-LINE业务的基础上新建pw并对新建pw进行配置  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在已有一条E-LINE业务的基础上新建ac并对新建ac进行配置  测试开始=====\n"
        lappend flag3_case4 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "400" $testPort5]
        lappend flag3_case4 [gwd::GWAc_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac400" "" $testPort5  400 0 "nochange" 1 0 0 "0x8100"]
        lappend flag3_case4 [gwd::GWpublic_CfgAcBind $telnet1 $matchType1 $Gpn_type1 $fileId "ac400" "pw2" "eline2"]
        lappend flag3_case4 [gwd::GWpublic_addAcBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "ac400" $cirwidth3 $pirwidth3]
        lappend flag3_case4 [gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac400" "enable"]
        lappend flag3_case4 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac400"]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag3_case4]} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC2（结论）在已有一条E-LINE业务的基础上新建ac并对新建ac进行配置" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC2（结论）在已有一条E-LINE业务的基础上新建ac并对新建ac进行配置" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====在已有一条E-LINE业务的基础上新建ac并对新建ac进行配置  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====修改新建E-LINE业务的lsp、pw、ac的带宽和性能统计并查看修改后的信息  测试开始=====\n"
        lappend flag4_case4 [gwd::GWStaLsp_AddLspEn $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" "shutdown"]
        lappend flag4_case4 [gwd::GWpublic_addBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" "60000"]
        lappend flag4_case4 [gwd::GWStaLsp_AddLspEn $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" "undo shutdown"]
        lappend flag4_case4 [gwd::GWpublic_addLspStat $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2" "disable"]
        lappend flag4_case4 [gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"]
        
        lappend flag4_case4 [gwd::GWpublic_addPwBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "60000" "90000"]
        lappend flag4_case4 [gwd::GWpublic_addPwStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "disable"]
        lappend flag4_case4 [gwd::GWpublic_addPwWordEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "enable"]
        lappend flag4_case4 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" result]
        
        lappend flag4_case4 [gwd::GWpublic_addAcBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "ac400" "60000" "90000"]
        lappend flag4_case4 [gwd::GWpublic_addAcStatEn $telnet1 $matchType1 $Gpn_type1 $fileId "ac400" "disable"]
        lappend flag4_case4 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac400"]
        lappend flag4_case4 [gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag4_case4]} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC3（结论）修改新建E-LINE业务的lsp、pw、ac的带宽和性能统计并查看修改后的信息" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC3（结论）修改新建E-LINE业务的lsp、pw、ac的带宽和性能统计并查看修改后的信息" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====修改新建E-LINE业务的lsp、pw、ac的带宽和性能统计并查看修改后的信息  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====保存设备重启后，测试两条E-LINE业务是否发生变化  测试开始=====\n"
	#给测试前后的lsp pw ac内容参数赋值
	set lsp1_con "null"
	set pw1_con "null"
	set ac200_con "null"
	set lsp2_con "null"
	set pw2_con "null"
	set ac400_con "null"
	
	set lsp1_con1 ""
	set pw1_con1 ""
	set ac200_con1 ""
	set lsp2_con1 ""
	set pw2_con1 ""
	set ac400_con1 ""
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]} {
		incr showMpls -1
	}
	regexp {interface lsp tunnel lsp1.*?exit} $result lsp1_con
	regexp {interface pw pw1.*?exit} $result pw1_con
	regexp {interface ac ac200.*?exit} $result ac200_con
	regexp {interface lsp tunnel lsp2.*?exit} $result lsp2_con
	regexp {interface pw pw2.*?exit} $result pw2_con
	regexp {interface ac ac400.*?exit} $result ac400_con
	
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1] 
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]} {
		incr showMpls -1
	}
	regexp {interface lsp tunnel lsp1.*?exit} $result1 lsp1_con1
	regexp {interface pw pw1.*?exit} $result1 pw1_con1
	regexp {interface ac ac200.*?exit} $result1 ac200_con1
	regexp {interface lsp tunnel lsp2.*?exit} $result1 lsp2_con1
	regexp {interface pw pw2.*?exit} $result1 pw2_con1
	regexp {interface ac ac400.*?exit} $result1 ac400_con1
	if {[string match $lsp1_con $lsp1_con1]} {
		gwd::GWpublic_print "OK" "保存重启前后lsp1的内容没有发生变化" $fileId
	} else {
		set flag5_case4 1
		gwd::GWpublic_print "NOK" "保存重启前后lsp1的内容发生变化" $fileId
	}
	if {[string match $pw1_con $pw1_con1]} {
		gwd::GWpublic_print "OK" "保存重启前后pw1的内容没有发生变化" $fileId
	} else {
		set flag5_case4 1
		gwd::GWpublic_print "NOK" "保存重启前后pw1的内容发生变化" $fileId
	}
	if {[string match $ac200_con $ac200_con1]} {
		gwd::GWpublic_print "OK" "保存重启前后ac200的内容没有发生变化" $fileId
	} else {
		set flag5_case4 1
		gwd::GWpublic_print "NOK" "保存重启前后ac200的内容发生变化" $fileId
	}
	if {[string match $lsp2_con $lsp2_con1]} {
		gwd::GWpublic_print "OK" "保存重启前后lsp2的内容没有发生变化" $fileId
	} else {
		set flag5_case4 1
		gwd::GWpublic_print "NOK" "保存重启前后lsp2的内容发生变化" $fileId
	}
	if {[string match $pw2_con $pw2_con1]} {
		gwd::GWpublic_print "OK" "保存重启前后pw2的内容没有发生变化" $fileId
	} else {
		set flag5_case4 1
		gwd::GWpublic_print "NOK" "保存重启前后pw2的内容发生变化" $fileId
	}
	if {[string match $ac400_con $ac400_con1]} {
		gwd::GWpublic_print "OK" "保存重启前后ac400的内容没有发生变化" $fileId
	} else {
		set flag5_case4 1
		gwd::GWpublic_print "NOK" "保存重启前后ac400的内容发生变化" $fileId
	}
	puts $fileId ""
	if {[regexp {[^0\s]} $flag5_case4]} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC4（结论）保存设备重启后，测试两条E-LINE业务的配置发生变化" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC4（结论）保存设备重启后，测试两条E-LINE业务的配置没有发生变化" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====保存设备重启后，测试两条E-LINE业务是否发生变化  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts "lsp1_con   $lsp1_con  \n\n"
	puts "pw1_con    $pw1_con   \n\n"
	puts "ac200_con  $ac200_con \n\n"
	puts "lsp2_con   $lsp2_con  \n\n"
	puts "pw2_con    $pw2_con   \n\n"
	puts "ac400_con  $ac400_con \n\n"
	puts "lsp1_con1  $lsp1_con1 \n\n"
	puts "pw1_con1   $pw1_con1  \n\n"
	puts "ac200_con1 $ac200_con1\n\n"
	puts "lsp2_con1  $lsp2_con1 \n\n"
	puts "pw2_con1   $pw2_con1  \n\n"
	puts "ac400_con1 $ac400_con1\n\n"
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除第二条ELINE业务的配置，测试是否能删除成功并对第一条业务无影响  测试开始=====\n"
	set lsp1_con "null"
	set pw1_con "null"
	set ac200_con "null"
	set lsp2_con "null"
	set pw2_con "null"
	set ac400_con "null"
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]} {
		incr showMpls -1
	}
	regexp {interface lsp tunnel lsp1.*?exit} $result lsp1_con
	regexp {interface pw pw1.*?exit} $result pw1_con
	regexp {interface ac ac200.*?exit} $result ac200_con
	regexp {interface lsp tunnel lsp2.*?exit} $result lsp2_con
	regexp {interface pw pw2.*?exit} $result pw2_con
	regexp {interface ac ac400.*?exit} $result ac400_con
	lappend flag6_case4 [gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac400"]
	lappend flag6_case4 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac400"]
	lappend flag6_case4 [gwd::GWpublic_addPwBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" 0 0]
	lappend flag6_case4 [gwd::GWpublic_cfgPwHqosEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw2" "disable"]
	lappend flag6_case4 [gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"]
	lappend flag6_case4 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw2"]
	lappend flag6_case4 [gwd::GWpublic_delLspStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"]
	lappend flag6_case4 [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp2"]
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]} {
		incr showMpls -1
	}
	set lsp1_con1 ""
	set pw1_con1 ""
	set ac200_con1 ""
	set lsp2_con1 ""
	set pw2_con1 ""
	set ac400_con1 ""
	regexp {interface lsp tunnel lsp1.*?exit} $result1 lsp1_con1
	regexp {interface pw pw1.*?exit} $result1 pw1_con1
	regexp {interface ac ac200.*?exit} $result1 ac200_con1
	regexp {interface lsp tunnel lsp2.*?exit} $result1 lsp2_con1
	regexp {interface pw pw2.*?exit} $result1 pw2_con1
	regexp {interface ac ac400.*?exit} $result1 ac400_con1
	if {$lsp2_con1 != ""} {
		set flag6_case4 1
		gwd::GWpublic_print "NOK" "删除lsp2后查看mpls的信息，lsp2的配置仍然存在" $fileId
	} else {
		gwd::GWpublic_print "OK" "删除lsp2后查看mpls的信息，lsp2的配置被删除" $fileId
	}
	if {$pw2_con1 != ""} {
		set flag6_case4 1
		gwd::GWpublic_print "NOK" "删除pw2后查看mpls的信息，pw2的配置仍然存在" $fileId
	} else {
		gwd::GWpublic_print "OK" "删除pw2后查看mpls的信息，pw2的配置被删除" $fileId
	}
	if {$ac400_con1 != ""} {
		set flag6_case4 1
		gwd::GWpublic_print "NOK" "删除ac400后查看mpls的信息，ac400的配置仍然存在" $fileId
	} else {
		gwd::GWpublic_print "OK" "删除ac400后查看mpls的信息，ac400的配置被删除" $fileId
	}
	if {[string match $lsp1_con $lsp1_con1]} {
		gwd::GWpublic_print "OK" "删除第二条ELINE业务后lsp1的内容没有发生变化" $fileId
	} else {
		set flag6_case4 1
		gwd::GWpublic_print "NOK" "删除第二条ELINE业务后lsp1的内容发生变化" $fileId
	}
	if {[string match $pw1_con $pw1_con1]} {
		gwd::GWpublic_print "OK" "删除第二条ELINE业务后pw1的内容没有发生变化" $fileId
	} else {
		set flag6_case4 1
		gwd::GWpublic_print "NOK" "删除第二条ELINE业务后pw1的内容发生变化" $fileId
	}
	if {[string match $ac200_con $ac200_con1]} {
		gwd::GWpublic_print "OK" "删除第二条ELINE业务后ac200的内容没有发生变化" $fileId
	} else {
		set flag6_case4 1
		gwd::GWpublic_print "NOK" "删除第二条ELINE业务后ac200的内容发生变化" $fileId
	}
	puts $fileId ""
	if {[regexp {[^0\s]} $flag6_case4]} {
		set flagCase4 1
		gwd::GWpublic_print "NOK" "FC5（结论）删除第二条ELINE业务的配置，删除失败或对第一条业务有影响" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC5（结论）删除第二条ELINE业务的配置，删除成功并对第一条业务无影响" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除第二条ELINE业务的配置，测试是否能删除成功并对第一条业务无影响  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
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
	puts $fileId "Test Case 4 新建E-LINE业务，测试两个E-LINE业务是否互相影响  测试结束\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "Test Case 5 创建E-LAN和E-TREE业务，验证是否互相影响\n"
        #   <1>再创建一条新E-LINE业务，配置相应LSP、PW、AC，可成功创建，发流验证对之前所创建的E-LINE业务无影响
        #   <2>对已创建好的LSP/PW/AC的带宽信息进行修改，修改成功，系统无异常
        #   <3>查看系统中已存在的E-LINE业务，保存配置，重启设备，设备可正常启动，配置无丢失
        #   <4>删除E-LINE业务时，需先将AC与PW绑定关系删除，再按照顺序删除ac pw lsp 
        #   <5>删除一条E-LINE业务不影响另一条
	set flag1_case5 0
	set flag2_case5 0
	set flag3_case5 0
	set flag4_case5 0
	set flag5_case5 0
	set flag6_case5 0
	set flag7_case5 0
	set flag8_case5 0
	
        #删除之前的一条Eline------
        gwd::GWAc_DelActPw $telnet1 $matchType1 $Gpn_type1 $fileId "ac200"
        gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac200"
        gwd::GWpublic_addPwBandwidth $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" 0 0
        gwd::GWpublic_cfgPwHqosEn $telnet1 $matchType1 $Gpn_type1 $fileId "pw1" "disable"
        gwd::GWpublic_delPwStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw1"
        gwd::GWpublic_delLspStaticPara $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"
        gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp1"
        gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result
	#------删除之前的一条Eline
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====修改vpls域配置参数遍历测试  测试开始=====\n"
	gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "false" "false" "false" "true" "2000" "" ""
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	if {[gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "false" "false" "false" "true" "2500" "" ""]} {
		set flag1_case5 1
		gwd::GWpublic_print "NOK" "修改vpls参数中mac地址学习个数的参数，修改失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "修改vpls参数中mac地址学习个数的参数，修改成功" $fileId
	}
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	if {[gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "true" "false" "false" "true" "2000" "" ""]} {
		set flag1_case5 1
		gwd::GWpublic_print "NOK" "修改vpls参数中广播转发控制参数，修改失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "修改vpls参数中广播转发控制参数，修改成功" $fileId
	}
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	if {[gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "false" "true" "false" "true" "2000" "" ""]} {
		set flag1_case5 1
		gwd::GWpublic_print "NOK" "修改vpls参数中组播转发控制参数，修改失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "修改vpls参数中组播转发控制参数，修改成功" $fileId
	}
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	if {[gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "false" "false" "true" "true" "2000" "" ""]} {
		set flag1_case5 1
		gwd::GWpublic_print "NOK" "修改vpls参数中未知单播转发控制参数，修改失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "修改vpls参数中未知单播转发控制参数，修改成功" $fileId
	}
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	if {[gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "false" "false" "false" "false" "2000" "" ""]} {
		set flag1_case5 1
		gwd::GWpublic_print "NOK" "修改vpls参数中mac地址学习控制参数，修改失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "修改vpls参数中mac地址学习控制参数，修改成功" $fileId
	}
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	if {[gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "discard" "false" "false" "false" "true" "2000" "" ""]} {
		set flag1_case5 1
		gwd::GWpublic_print "NOK" "修改vpls参数中当mac地址转发表full以后对数据流处理的控制参数，修改失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "修改vpls参数中当mac地址转发表full以后对数据流处理的控制参数，修改成功" $fileId
	}
	gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"
	
	puts $fileId ""
	if {[regexp {[^0\s]} $flag1_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC6（结论）修改vpls域配置参数测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC6（结论）修改vpls域配置参数测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====修改vpls域配置参数测试  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新建ELAN业务，测试是否能创建成功  测试开始=====\n"
        lappend flag2_case5 [PTN_NNI_AddInterIp $fileId $Worklevel $interface4 $ip13 $testPort2 $matchType1 $Gpn_type1 $telnet1]
        lappend flag2_case5 [PTN_NNI_AddInterIp $fileId $Worklevel $interface5 $ip14 $testPort4 $matchType1 $Gpn_type1 $telnet1]
	if {[string match "L2" $Worklevel]} {
		lappend flag2_case5 [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort2 "enable"]
        	lappend flag2_case5 [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort4 "enable"]
	}
        lappend flag2_case5 [gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1" "1" "elan" "flood" "false" "false" "false" "true" "2000" "" ""]
        lappend flag2_case5 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3" $interface4 $ip31 "200" "200" "normal" "5"]
        lappend flag2_case5 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3" $address13]
        lappend flag2_case5 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3"]
        lappend flag2_case5 [gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3"]
        lappend flag2_case5 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6" $interface5 $ip41 "500" "600" "normal" "6"]
        lappend flag2_case5 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6" $address14]
        lappend flag2_case5 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6"]
        lappend flag2_case5 [gwd::GWpublic_showTunnelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6"]
        lappend flag2_case5 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" "vpls" "vpls1" "peer" $address13 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "5"]
        lappend flag2_case5 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw6" "vpls" "vpls1" "peer" $address14 "1000" "1100" "" "nochange" "none" 1 0 "0x8100" "0x8100" "6"]
        lappend flag2_case5 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw3" result]
        lappend flag2_case5 [gwd::GWpublic_getPwInfo $telnet1 $matchType1 $Gpn_type1 $fileId "pw6" result]
        lappend flag2_case5 [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "ethernet" $testPort5 "0" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"]
        lappend flag2_case5 [gwd::GWpublic_getAcInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag2_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC7（结论）新建ELAN业务，创建失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC7（结论）新建ELAN业务，创建成功" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新建ELAN业务，测试是否能创建成功  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====添加删除ELAN业务ac的测试  测试开始=====\n"
        if {[gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"]} {
        	set flag3_case5 1
        	gwd::GWpublic_print "NOK" "不删除vpls域，删除ac失败" $fileId
        } else {
        	gwd::GWpublic_print "OK" "不删除vpls域，删除ac成功" $fileId
        }
        if {[gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac1" "vpls1" "ethernet" $testPort5 "0" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"]} {
        	set flag3_case5 1
        	gwd::GWpublic_print "NOK" "删除ac后重新添加ac，添加失败" $fileId
        } else {
        	gwd::GWpublic_print "OK" "删除ac后重新添加ac，添加成功" $fileId
        }
	puts $fileId ""
	if {[regexp {[^0\s]} $flag3_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC8（结论）添加删除ELAN业务ac的测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC8（结论）添加删除ELAN业务ac的测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====添加删除ELAN业务ac的测试  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除ac并创建ac为port+vlan模式  测试开始=====\n"
	lappend flag4_case5 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac1"]
	lappend flag4_case5 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "11" $testPort5]
	lappend flag4_case5 [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac11" "vpls1" "ethernet" $testPort5 "11" "0" "none" "nochange" "1" "0" "0" "0x9100" "evc2"]
	puts $fileId ""
	if {[regexp {[^0\s]} $flag4_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FC9（结论）删除ac并创建ac为port+vlan模式" $fileId
	} else {
		gwd::GWpublic_print "OK" "FC9（结论）删除ac并创建ac为port+vlan模式" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除ac并创建ac为port+vlan模式  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====测试保存重启后ELAN业务的配置是否改变  测试开始=====\n"
	set vpls1_con "null"
	set lsp3_con "null"
	set lsp6_con "null"
	set pw3_con "null"
	set pw6_con "null"
	set ac11_con "null"
	
	set vpls1_con1 ""
	set lsp3_con1 ""
	set lsp6_con1 ""
	set pw3_con1 ""
	set pw6_con1 ""
	set ac11_con1 "" 
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]} {
		incr showMpls -1
	}
	regexp -line {mpls static vpls domain vpls1.+} $result vpls1_con
	regexp {interface lsp tunnel lsp3.*?exit} $result lsp3_con
	regexp {interface lsp tunnel lsp6.*?exit} $result lsp6_con
	regexp {interface pw pw3.*?exit} $result pw3_con
	regexp {interface pw pw6.*?exit} $result pw6_con
	regexp {interface ac ac11.*?exit} $result ac11_con
		
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result1]} {
		incr showMpls -1
	}
	regexp -line {mpls static vpls domain vpls1.+} $result vpls1_con1
	regexp {interface lsp tunnel lsp3.*?exit} $result lsp3_con1
	regexp {interface lsp tunnel lsp6.*?exit} $result lsp6_con1
	regexp {interface pw pw3.*?exit} $result pw3_con1
	regexp {interface pw pw6.*?exit} $result pw6_con1
	regexp {interface ac ac11.*?exit} $result ac11_con1
	if {[string match $vpls1_con $vpls1_con1]} {
		gwd::GWpublic_print "OK" "保存重启前后vpls1的内容没有发生变化" $fileId
	} else {
		set flag5_case5 1
		gwd::GWpublic_print "NOK" "保存重启前后vpls1的内容发生变化" $fileId
	}
	if {[string match $lsp3_con $lsp3_con1]} {
		gwd::GWpublic_print "OK" "保存重启前后lsp3的内容没有发生变化" $fileId
	} else {
		set flag5_case5 1
		gwd::GWpublic_print "NOK" "保存重启前后lsp3的内容发生变化" $fileId
	}
	if {[string match $lsp6_con $lsp6_con1]} {
		gwd::GWpublic_print "OK" "保存重启前后lsp6的内容没有发生变化" $fileId
	} else {
		set flag5_case5 1
		gwd::GWpublic_print "NOK" "保存重启前后lsp6的内容发生变化" $fileId
	}
	
	if {[string match $pw3_con $pw3_con1]} {
		gwd::GWpublic_print "OK" "保存重启前后pw3的内容没有发生变化" $fileId
	} else {
		set flag5_case5 1
		gwd::GWpublic_print "NOK" "保存重启前后pw3的内容发生变化" $fileId
	}
	if {[string match $pw6_con $pw6_con1]} {
		gwd::GWpublic_print "OK" "保存重启前后pw6的内容没有发生变化" $fileId
	} else {
		set flag5_case5 1
		gwd::GWpublic_print "NOK" "保存重启前后pw6的内容发生变化" $fileId
	}
	if {[string match $ac11_con $ac11_con1]} {
		gwd::GWpublic_print "OK" "保存重启前后ac1的内容没有发生变化" $fileId
	} else {
		set flag5_case5 1
		gwd::GWpublic_print "NOK" "保存重启前后ac1的内容发生变化" $fileId
	}
	puts $fileId ""
	if {[regexp {[^0\s]} $flag5_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD1（结论）保存重启后ELAN业务的配置会改变" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD1（结论）保存重启后ELAN业务的配置没有改变" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====测试保存重启后ELAN业务的配置是否改变  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务配置的删除  测试开始=====\n"
        lappend flag6_case5 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac11"]
        lappend flag6_case5 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw3"]
        lappend flag6_case5 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw6"]
        lappend flag6_case5 [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp3"]
        lappend flag6_case5 [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp6"]
        lappend flag6_case5 [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls1"]
	set vpls1_con1 ""
	set lsp3_con1 ""
	set lsp6_con1 ""
	set pw3_con1 ""
	set pw6_con1 ""
	set ac11_con1 ""
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]} {
		incr showMpls -1
	}
	regexp -line {mpls static vpls domain vpls1.+} $result vpls1_con1
	regexp {interface lsp tunnel lsp3.*?exit} $result lsp3_con1
	regexp {interface lsp tunnel lsp6.*?exit} $result lsp6_con1
	regexp {interface pw pw3.*?exit} $result pw3_con1
	regexp {interface pw pw6.*?exit} $result pw6_con1
	regexp {interface ac ac11.*?exit} $result ac11_con1
	if {$vpls1_con1 != ""} {
		set flag6_case5 1
		gwd::GWpublic_print "NOK" "删除vpls1后查看mpls的信息，vpls1的配置仍然存在" $fileId
	} else {
		gwd::GWpublic_print "OK" "删除vpls1后查看mpls的信息，vpls1的配置被删除" $fileId
	}
	if {$lsp3_con1 != ""} {
		set flag6_case5 1
		gwd::GWpublic_print "NOK" "删除lsp3后查看mpls的信息，lsp3的配置仍然存在" $fileId
	} else {
		gwd::GWpublic_print "OK" "删除lsp3后查看mpls的信息，lsp3的配置被删除" $fileId
	}
	if {$lsp6_con1 != ""} {
		set flag6_case5 1
		gwd::GWpublic_print "NOK" "删除lsp6后查看mpls的信息，lsp6的配置仍然存在" $fileId
	} else {
		gwd::GWpublic_print "OK" "删除lsp6后查看mpls的信息，lsp6的配置被删除" $fileId
	}
	if {$pw3_con1 != ""} {
		set flag6_case5 1
		gwd::GWpublic_print "NOK" "删除pw3后查看mpls的信息，pw3的配置仍然存在" $fileId
	} else {
		gwd::GWpublic_print "OK" "删除pw3后查看mpls的信息，pw3的配置被删除" $fileId
	}
	if {$pw6_con1 != ""} {
		set flag6_case5 1
		gwd::GWpublic_print "NOK" "删除pw6后查看mpls的信息，pw6的配置仍然存在" $fileId
	} else {
		gwd::GWpublic_print "OK" "删除pw6后查看mpls的信息，pw6的配置被删除" $fileId
	}
	if {$ac11_con1 != ""} {
		set flag6_case5 1
		gwd::GWpublic_print "NOK" "删除ac1后查看mpls的信息，ac1的配置仍然存在" $fileId
	} else {
		gwd::GWpublic_print "OK" "删除ac1后查看mpls的信息，ac1的配置被删除" $fileId
	}
	puts $fileId ""
	if {[regexp {[^0\s]} $flag6_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD2（结论）ELAN业务配置的删除测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD2（结论）ELAN业务配置的删除测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====ELAN业务配置的删除  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新建ETREE业务，测试是否能创建成功  测试开始=====\n"
	lappend flag7_case5 [gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls2" "2" "etree" "flood" "false" "false" "false" "true" "3000" "" ""]
	lappend flag7_case5 [gwd::GWpublic_CfgLspTunnel $telnet1 $matchType1 $Gpn_type1 $fileId "lsp4" $interface4 $ip31 "200" "200" "normal" "4"]
	lappend flag7_case5 [gwd::GWpublic_CfgLspAddress $telnet1 $matchType1 $Gpn_type1 $fileId "lsp4" $address13]
	lappend flag7_case5 [gwd::GWpublic_CfgUndoShutLsp $telnet1 $matchType1 $Gpn_type1 $fileId "lsp4"]
	lappend flag7_case5 [gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw4" "vpls" "vpls2" "peer" $address13 "20" "20" "" "nochange" "root" 1 0 "0x8100" "0x8100" "4"] 
	lappend flag7_case5 [PTN_UNI_AddInter $telnet1 $matchType1 $Gpn_type1 $fileId $Worklevel "12" $testPort5]
	lappend flag7_case5 [gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac12" "vpls2" "ethernet" $testPort5 "12" "0" "leaf" "add" "12" "0" "0" "0x8100" "evc2"]
	
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]} {
		incr showMpls -1
	}
	puts $fileId ""
	if {[regexp {[^0\s]} $flag7_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD3（结论）新建ETREE业务，创建失败" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD3（结论）新建ETREE业务，创建成功" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====新建ETREE业务，测试是否能创建成功  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
	if {$lFailFileTmp != ""} {
		set lFailFile [concat $lFailFile $lFailFileTmp]
	}
	puts $fileId "======================================================================================\n"
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除ETREE业务，测试是否能删除成功  测试开始=====\n"
	lappend flag8_case5 [gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac12"]
	lappend flag8_case5 [gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw4"]
	lappend flag8_case5 [gwd::GWStaLsp_DelLspName $telnet1 $matchType1 $Gpn_type1 $fileId "lsp4"]
	lappend flag8_case5 [gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls2"]
	set vpls2_con1 ""
	set lsp4_con1 ""
	set pw4_con1 ""
	set ac12_con1 ""
	set showMpls 3
	while {[gwd::GWpublic_showMplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId result]} {
		incr showMpls -1
	}
	regexp -line {mpls static vpls domain vpls2.+} $result vpls2_con1
	regexp {interface lsp tunnel lsp4.*?exit} $result lsp4_con1
	regexp {interface pw pw4.*?exit} $result pw4_con1
	regexp {interface ac ac12.*?exit} $result ac12_con1
	if {$vpls2_con1 != ""} {
		set flag8_case5 1
		gwd::GWpublic_print "NOK" "删除vpls2后查看mpls的信息，vpls2的配置仍然存在" $fileId
	} else {
		gwd::GWpublic_print "OK" "删除vpls2后查看mpls的信息，vpls2的配置被删除" $fileId
	}
	if {$lsp4_con1 != ""} {
		set flag8_case5 1
		gwd::GWpublic_print "NOK" "删除lsp4后查看mpls的信息，lsp4的配置仍然存在" $fileId
	} else {
		gwd::GWpublic_print "OK" "删除lsp4后查看mpls的信息，lsp4的配置被删除" $fileId
	}
	if {$pw4_con1 != ""} {
		set flag8_case5 1
		gwd::GWpublic_print "NOK" "删除pw4后查看mpls的信息，pw4的配置仍然存在" $fileId
	} else {
		gwd::GWpublic_print "OK" "删除pw4后查看mpls的信息，pw4的配置被删除" $fileId
	}
	if {$ac12_con1 != ""} {
		set flag8_case5 1
		gwd::GWpublic_print "NOK" "删除ac12后查看mpls的信息，ac12的配置仍然存在" $fileId
	} else {
		gwd::GWpublic_print "OK" "删除ac12后查看mpls的信息，ac12的配置被删除" $fileId
	}
	
	puts $fileId ""
	if {[regexp {[^0\s]} $flag8_case5]} {
		set flagCase5 1
		gwd::GWpublic_print "NOK" "FD4（结论）ETREE业务配置的删除测试" $fileId
	} else {
		gwd::GWpublic_print "OK" "FD4（结论）ETREE业务配置的删除测试" $fileId
	}
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "=====删除ETREE业务，测试是否能删除成功  测试结束=====\n"
	incr cfgId
	lappend FLAGF [gwd::GWpublic_uploadDevCfg 1 $lSpawn_id $lMatchType $lDutType $fileId $fd_log $startSeconds $lIp $ftp $cfgId "GPN_PTN_001" lFailFileTmp]
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
	puts $fileId "Test Case 5 创建E-LAN和E-TREE业务，验证是否互相影响\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId ""
	gwd::GWpublic_sendSameStrToFiles "$fd_debug $fd_log $fileId" "===恢复初始化配置...\n"
	if {[string match "L2" $Worklevel]} {
                lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort1 "none"]
                lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort3 "none"]
                lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort2 "none"]
                lappend flagDel [gwd::GWpublic_CfgVlanStack $telnet1 $matchType1 $Gpn_type1 $fileId $testPort4 "none"]
	}
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface8 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface9 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface1 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface4 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface6 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface3 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface5 $matchType1 $Gpn_type1 $telnet1]
        lappend flagDel [PTN_DelInterVid $fileId $Worklevel $interface7 $matchType1 $Gpn_type1 $telnet1]
	foreach port $lDev1TestPort {
		if {[string match -nocase "L3" $Worklevel] && [string match -nocase "PTN" $SoftVer]} {
			lappend flagDel [gwd::GWL2_AddPort $telnet1 $matchType1 $Gpn_type1 $fileId $port "enable" "disable"]
		}
	}
	lappend flagDel [gwd::GWpublic_addPwLabelRange $telnet1 $matchType1 $Gpn_type1 $fileId "16" "2047" "2048" "1048575"]
	#修改标签范围需保存重启后修改才生效
	gwd::GWpublic_SaveCfg $telnet1 $matchType1 $Gpn_type1 $fileId
	gwd::GWpublic_Reboot $telnet1 $matchType1 $Gpn_type1 $fileId
	after $rebootTime
	set telnet1 [gwd::GWpublic_loginGpn $gpnIp1 $userName1 $password1 $matchType1 $Gpn_type1 $fileId]
	set lSpawn_id [lreplace $lSpawn_id 0 0 $telnet1]
	gwd::GWpublic_printAbnormal $fileId $fd_log $flagDel "FLAGD" $startSeconds "测试结束后配置恢复" "测试结束后配置恢复" "GPN_PTN_001"
	gwd::GWpublic_printAbnormal $fileId $fd_log $FLAGF "FLAGF" $startSeconds $lFailFile "测试过程中所有配置文件都上传成功" "GPN_PTN_001"
	
	chan seek $fileId 0
	puts $fileId "\n**************************************************************************************\n"
	puts $fileId "**************************************************************************************\n"
	puts $fileId "GPN_PTN_001测试目的：E-LINE/E-LAN/E-TREE业务创建、修改、删除和保存测试\n"
	gwd::GWpublic_printCompletedRunTime $fileId $startSeconds
	if {$flagCase1 == 1 || $flagCase2 == 1 || $flagCase3 == 1 || $flagCase4 == 1 || $flagCase5 == 1 || [regexp {[^0\s]} $flagDel]} {
		set flagResult 1
	}
	gwd::GWpublic_print [expr {($flagResult == 1) ? "NOK" : "OK"}] "GPN_PTN_001测试结果" $fileId
	puts $fileId ""
	gwd::GWpublic_print [expr {($flagCase1 == 0) ? "OK" : "NOK"}] "Test Case 1测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase2 == 0) ? "OK" : "NOK"}] "Test Case 2测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase3 == 0) ? "OK" : "NOK"}] "Test Case 3测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase4 == 0) ? "OK" : "NOK"}] "Test Case 4测试结果" $fileId
	gwd::GWpublic_print [expr {($flagCase5 == 0) ? "OK" : "NOK"}] "Test Case 5测试结果" $fileId
	puts $fileId ""
	puts $fileId ""
	gwd::GWpublic_print "== FA1 == [expr {($flag1_case1 == 1) ? "NOK" : "OK"}]" "（结论）创建lsp时配置不符合要求的lsp名字，创建[expr {($flag1_case1 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FA2 == [expr {($flag2_case1 == 1) ? "NOK" : "OK"}]" "（结论）配置lsp时配置错误的接口Vlan、下一跳ip，配置[expr {($flag2_case1 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FA3 == [expr {($flag3_case1 == 1) ? "NOK" : "OK"}]" "（结论）配置lsp时配置错误的入标签、出标签、lspId，配置[expr {($flag3_case1 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FA4 == [expr {($flag4_case1 == 1) ? "NOK" : "OK"}]" "（结论）创建和配置lsp时各个参数配置都正确，配置[expr {($flag4_case1 == 1) ? "失败" : "成功"}]" $fileId
	gwd::GWpublic_print "== FA5 == [expr {($flag5_case1 == 1) ? "NOK" : "OK"}]" "（结论）lsp的激活测试" $fileId
	gwd::GWpublic_print "== FA6 == [expr {($flag6_case1 == 1) ? "NOK" : "OK"}]" "（结论）lsp的带宽和性能统计配置测试" $fileId
	gwd::GWpublic_print "== FA7 == [expr {($flag1_case2 == 1) ? "NOK" : "OK"}]" "（结论）创建pw时配置不符合要求的pw名字，创建[expr {($flag1_case2 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FA8 == [expr {($flag2_case2 == 1) ? "NOK" : "OK"}]" "（结论）配置pw时配置错误的参数，配置[expr {($flag2_case2 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FA9 == [expr {($flag3_case2 == 1) ? "NOK" : "OK"}]" "（结论）pw静态标签和动态标签范围的配置测试" $fileId
	gwd::GWpublic_print "== FB1 == [expr {($flag4_case2 == 1) ? "NOK" : "OK"}]" "（结论）pw带宽的配置测试" $fileId
	gwd::GWpublic_print "== FB2 == [expr {($flag5_case2 == 1) ? "NOK" : "OK"}]" "（结论）使能/去使能pw性能统计的配置测试" $fileId
	gwd::GWpublic_print "== FB3 == [expr {($flag6_case2 == 1) ? "NOK" : "OK"}]" "（结论）使能/去使能pw控制字的配置测试" $fileId
	gwd::GWpublic_print "== FB4 == [expr {($flag1_case3 == 1) ? "NOK" : "OK"}]" "（结论）创建ac时配置不符合要求的ac名字，创建[expr {($flag1_case3 == 1) ? "成功" : "失败"}]" $fileId
	gwd::GWpublic_print "== FB5 == [expr {($flag2_case3 == 1) ? "NOK" : "OK"}]" "（结论）配置ac时使用的端口号和vlan参数测试" $fileId
	gwd::GWpublic_print "== FB6 == [expr {($flag3_case3 == 1) ? "NOK" : "OK"}]" "（结论）ac绑定pw的测试" $fileId
	gwd::GWpublic_print "== FB7 == [expr {($flag4_case3 == 1) ? "NOK" : "OK"}]" "（结论）ac配置带宽和端口统计的测试" $fileId
	gwd::GWpublic_print "== FB8 == [expr {($flag5_case3 == 1) ? "NOK" : "OK"}]" "（结论）删除ac及其绑定的测试" $fileId
	gwd::GWpublic_print "== FB9 == [expr {($flag1_case4 == 1) ? "NOK" : "OK"}]" "（结论）在已有一条E-LINE业务的基础上新建lsp并对新建lsp进行配置" $fileId
	gwd::GWpublic_print "== FC1 == [expr {($flag2_case4 == 1) ? "NOK" : "OK"}]" "（结论）在已有一条E-LINE业务的基础上新建pw并对新建pw进行配置" $fileId
	gwd::GWpublic_print "== FC2 == [expr {($flag3_case4 == 1) ? "NOK" : "OK"}]" "（结论）在已有一条E-LINE业务的基础上新建ac并对新建ac进行配置" $fileId
	gwd::GWpublic_print "== FC3 == [expr {($flag4_case4 == 1) ? "NOK" : "OK"}]" "（结论）修改新建E-LINE业务的lsp、pw、ac的带宽和性能统计并查看修改后的信息" $fileId
	gwd::GWpublic_print "== FC4 == [expr {($flag5_case4 == 1) ? "NOK" : "OK"}]" "（结论）保存设备重启后，测试两条E-LINE业务的配置[expr {($flag5_case4 == 1) ? "" : "没有"}]发生变化" $fileId
	gwd::GWpublic_print "== FC5 == [expr {($flag6_case4 == 1) ? "NOK" : "OK"}]" "（结论）删除第二条ELINE业务的配置，删除失败或对第一条业务[expr {($flag6_case4 == 1) ? "有" : "没有"}]影响" $fileId
	gwd::GWpublic_print "== FC6 == [expr {($flag1_case5 == 1) ? "NOK" : "OK"}]" "（结论）修改vpls域配置参数测试" $fileId
	gwd::GWpublic_print "== FC7 == [expr {($flag2_case5 == 1) ? "NOK" : "OK"}]" "（结论）新建ELAN业务，创建[expr {($flag2_case5 == 1) ? "失败" : "成功"}]" $fileId
	gwd::GWpublic_print "== FC8 == [expr {($flag3_case5 == 1) ? "NOK" : "OK"}]" "（结论）添加删除ELAN业务ac的测试" $fileId
	gwd::GWpublic_print "== FC9 == [expr {($flag4_case5 == 1) ? "NOK" : "OK"}]" "（结论）删除ac并创建ac为port+vlan模式" $fileId
	gwd::GWpublic_print "== FD1 == [expr {($flag5_case5 == 1) ? "NOK" : "OK"}]" "（结论）保存重启后ELAN业务的配置[expr {($flag2_case5 == 1) ? "会" : "没有"}]改变" $fileId
	gwd::GWpublic_print "== FD2 == [expr {($flag6_case5 == 1) ? "NOK" : "OK"}]" "（结论）ELAN业务配置的删除测试" $fileId
	gwd::GWpublic_print "== FD3 == [expr {($flag7_case5 == 1) ? "NOK" : "OK"}]" "（结论）新建ETREE业务，创建[expr {($flag7_case5 == 1) ? "失败" : "成功"}]" $fileId
	gwd::GWpublic_print "== FD4 == [expr {($flag8_case5 == 1) ? "NOK" : "OK"}]" "（结论）ETREE业务配置的删除测试" $fileId
	gwd::GWpublic_print "== FLAGD == [expr {([regexp {[^0\s]} $flagDel]) ? "NOK" : "OK"}]" "（结论）测试结束后配置恢复" $fileId
	gwd::GWpublic_print "== FLAGF == [expr {([regexp {[^0\s]} $FLAGF]) ? "NOK" : "OK"}]" "（结论）测试过程中配置文件的上传" $fileId
	puts $fileId ""
	puts $fileId "**************************************************************************************"
	puts $fileId ""
	puts $fileId "**************************************************************************************"
} err]} {
	gwd::GWpublic_printAbnormal $fileId $fd_log 1 "FLAGE" $startSeconds "运行异常：错误为$err" "" "GPN_PTN_001"
}
close $fileId
log_file -noappend
close $fd_log

if {$flagResult == 1} {
	file rename "report\\GPN_PTN_001_REPORT.txt" "report\\NOK_GPN_PTN_001_REPORT.txt"
	file rename "log\\GPN_PTN_001_LOG.txt" "log\\NOK_GPN_PTN_001_LOG.txt"
} else {
	file rename "report\\GPN_PTN_001_REPORT.txt" "report\\OK_GPN_PTN_001_REPORT.txt"
	file rename "log\\GPN_PTN_001_LOG.txt" "log\\OK_GPN_PTN_001_LOG.txt"
}
if {[regexp {[^0\s]} $flagDel]} {
	exit 1
}
