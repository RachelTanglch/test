
#!/bin/sh
# PTN_Mode_Function.tcl \
exec tclsh "$0" ${1+"$@"}
########################################################################################################
#函数功能：根据分析器的设置统计各条流的收发情况
#输入参数：statPara ==1 分析器中添加vlan统计字段                ==0 分析器中不添加vlan统计字段
#          hAna：端口分析器handle
#输出参数：aRecCnt：统计结果
#返回值：    无
########################################################################################################
proc classificationStatisticsPortRxCnt {statPara hAna aRecCnt} {
	set flag 0
  	upvar $aRecCnt aTmpCnt
  	#同步分析器和发生器统计延时2s  
  	after 2000 
  	##获取分析器统计的数值并进行匹配
	foreach resultsObj [stc::get $hAna -children-FilteredStreamResults] {
		if {[catch {
			send_log "\n resultsObj:$resultsObj"
                        after 2000
                        array set aResults [stc::get $resultsObj]
                        after 2000
                        gwd::Clear_ResultViewStat $resultsObj
                } err]} {
			set flag 1
                      send_log "\n filter_err:$err"
                      continue
                }
  		if {$statPara == 1} {
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	  		$aResults(-FilteredValue_1) == "50" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
				set aTmpCnt(cnt2) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt2)]
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	  		$aResults(-FilteredValue_1) == "50" && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
				set aTmpCnt(cnt3) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt3)]
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	  		$aResults(-FilteredValue_1) == "60" && $aResults(-FilteredValue_2) == "00:00:00:00:00:04"} {
	 			set aTmpCnt(cnt4) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt4)]
      			} 
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	   		$aResults(-FilteredValue_1) == "50" && $aResults(-FilteredValue_2) == "00:00:00:00:00:06"} {
	 			set aTmpCnt(cnt6) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	   		$aResults(-FilteredValue_1) == "50" && $aResults(-FilteredValue_2) == "00:00:00:00:00:07"} {
	 			set aTmpCnt(cnt7) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	   		$aResults(-FilteredValue_1) == "60" && $aResults(-FilteredValue_2) == "00:00:00:00:00:08"} {
	 			set aTmpCnt(cnt8) $aResults(-L1BitRate)
      			}
     			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	  		$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:09"} {
				set aTmpCnt(cnt9) $aResults(-L1BitRate)
     			}
     			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
	  		$aResults(-FilteredValue_1) == "30" && $aResults(-FilteredValue_2) == "50"} {
				set aTmpCnt(cnt10) $aResults(-L1BitRate)
     			}
     			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	    		$aResults(-FilteredValue_1) == "80" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
	  			set aTmpCnt(cnt11) $aResults(-L1BitRate)
       			}
     			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
	       		$aResults(-FilteredValue_1) == "50" && $aResults(-FilteredValue_2) == "100"} {
	      			set aTmpCnt(cnt12) $aResults(-L1BitRate)
			}
     			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
	  		$aResults(-FilteredValue_1) == "30" && $aResults(-FilteredValue_2) == "50"} {
				set aTmpCnt(cnt13) $aResults(-L1BitRate)
     			}
     			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
	  		$aResults(-FilteredValue_1) == "20" && $aResults(-FilteredValue_2) == "50"} {
				set aTmpCnt(cnt14) $aResults(-L1BitRate)
     			}
     			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	  		$aResults(-FilteredValue_1) == "30" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0a"} {
	  			set aTmpCnt(cnt15) $aResults(-L1BitRate)
       			}
     			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
	  		$aResults(-FilteredValue_1) == "30" && $aResults(-FilteredValue_2) == "80"} {
				set aTmpCnt(cnt16) $aResults(-L1BitRate)
     			}
#     			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
#	    		$aResults(-FilteredValue_1) == "60" && $aResults(-FilteredValue_2) == $::vid8fx} {
#	  			set aTmpCnt(cnt17) $aResults(-L1BitRate)
#       			}
     			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
			$aResults(-FilteredValue_1) == "60" && $aResults(-FilteredValue_2) == 80} {
	    			set aTmpCnt(cnt18) $aResults(-L1BitRate)
			}
     			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
			$aResults(-FilteredValue_1) == "60" && $aResults(-FilteredValue_2) == 100} {
	  			set aTmpCnt(cnt19) $aResults(-L1BitRate)
			}
    		
  		} elseif {$statPara == 0} {
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:01"} {
	   			set aTmpCnt(cnt1) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt1)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:02"} {
	  			set aTmpCnt(cnt2) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt2)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:03"} {
	   			set aTmpCnt(cnt3) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt3)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:04"} {
	   			set aTmpCnt(cnt4) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt4)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:05"} {
	   			set aTmpCnt(cnt5) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt5)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:06"} {
	   			set aTmpCnt(cnt6) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt6)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:07"} {
	   			set aTmpCnt(cnt7) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt7)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:08"} {
	   			set aTmpCnt(cnt8) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:09"} {
	   			set aTmpCnt(cnt9) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt9)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0a"} {
	   			set aTmpCnt(cnt10) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0b"} {
	   			set aTmpCnt(cnt13) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0c"} {
	   			set aTmpCnt(cnt14) $aResults(-L1BitRate)
			}
     		} elseif {$statPara == 2} {
	      		if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
		  	$aResults(-FilteredValue_2) == "100" && $aResults(-FilteredValue_1) == "1000"} {
				set aTmpCnt(cnt1) $aResults(-L1BitRate)
	      		}
	      		if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
		  	$aResults(-FilteredValue_2) == "1000" && $aResults(-FilteredValue_1) == "100"} {
				set aTmpCnt(cnt2) $aResults(-L1BitRate)
	      		}
      		} elseif {$statPara == 3} {
	      	
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_3)] && [string match -nocase "Mpls 0 - Experimental Bits (bits)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Bottom of stack (bit)" $aResults(-FilteredName_1)] &&\
		    	$aResults(-FilteredValue_3) == "10" && $aResults(-FilteredValue_2) == "000" && $aResults(-FilteredValue_1) == "1"} {
		  		set aTmpCnt(cnt1) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_3)] && [string match -nocase "Mpls 0 - Experimental Bits (bits)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Bottom of stack (bit)" $aResults(-FilteredName_1)] &&\
		    	$aResults(-FilteredValue_3) == "10" && $aResults(-FilteredValue_2) == "000" && $aResults(-FilteredValue_1) == "0"} {
		  		set aTmpCnt(cnt2) $aResults(-L1BitRate)
			}
      		}
	}
	return $flag
}
########################################################################################################
#函数功能：根据分析器的设置统计各条流的收发情况
#输入参数：statPara ==1 分析器中添加vlan统计字段                ==0 分析器中不添加vlan统计字段
#         statPara ==2 分析器中添加mpls 标签统计字段     ==3 分析器中添加mpls vid 、Experrimental Bit和bottom of stack统计字段
#          hAna：端口分析器handle
#输出参数：aRecCnt：统计结果
#返回值：    无
########################################################################################################
proc classificationStatisticsPortRxCnt1 {statPara hAna aRecCnt} { 
	set flag 0
  	upvar $aRecCnt aTmpCnt
	global dev_sysmac1
	global dev_sysmac2
 	#同步分析器和发生器统计延时2s  
  	after 2000 
        ##获取分析器统计的数值并进行匹配
        foreach resultsObj [stc::get $hAna -children-FilteredStreamResults] {
                if {[catch {
                        send_log "\n resultsObj:$resultsObj"
                        after 2000
                        array set aResults [stc::get $resultsObj]
                        after 2000
                        gwd::Clear_ResultViewStat $resultsObj
                } err]} {
			set flag 1
                        send_log "\n filter_err:$err"
                        continue
        	}
		if {$statPara == 1} {
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	  			$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:01"} {
				set aTmpCnt(cnt1) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt1)]
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	  			$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
				set aTmpCnt(cnt2) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt2)]
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	  			$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
				set aTmpCnt(cnt3) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt3)]
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	  			$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:04"} {
	 			set aTmpCnt(cnt4) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt4)]
      			} 
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "1000" && $aResults(-FilteredValue_2) == "00:00:00:00:00:05"} {
	 			set aTmpCnt(cnt5) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "2000" && $aResults(-FilteredValue_2) == "00:00:00:00:00:06"} {
	 			set aTmpCnt(cnt6) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "300" && $aResults(-FilteredValue_2) == "00:00:00:00:00:07"} {
	 			set aTmpCnt(cnt7) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "3000" && $aResults(-FilteredValue_2) == "00:00:00:00:00:08"} {
	 			set aTmpCnt(cnt8) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "300" && $aResults(-FilteredValue_2) == "3000"} {
	 			set aTmpCnt(cnt9) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "1000"} {
	 			set aTmpCnt(cnt10) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0b"} {
	 			set aTmpCnt(cnt11) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0c"} {
	 			set aTmpCnt(cnt12) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0d"} {
	 			set aTmpCnt(cnt13) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0e"} {
	   			set aTmpCnt(cnt14) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:15"} {
	   			set aTmpCnt(cnt15) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:16"} {
	   			set aTmpCnt(cnt16) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "100"} {
	   			set aTmpCnt(cnt17) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
	   			$aResults(-FilteredValue_1) == "1000" && $aResults(-FilteredValue_2) == "1000"} {
	   			set aTmpCnt(cnt18) $aResults(-L1BitRate)
      			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				$aResults(-FilteredValue_1) == "1000" && $aResults(-FilteredValue_2) == "00:00:00:00:00:06"} {
				set aTmpCnt(cnt19) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				$aResults(-FilteredValue_1) == "2000" && $aResults(-FilteredValue_2) == "00:00:00:00:00:05"} {
			   	set aTmpCnt(cnt20) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				$aResults(-FilteredValue_1) == "1000" && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
				set aTmpCnt(cnt21) $aResults(-L1BitRate)
			}
		} elseif {$statPara == 0} {
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:01"} {
	   			set aTmpCnt(cnt1) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt1)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:02"} {
	   			set aTmpCnt(cnt2) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt2)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:03"} {
	   			set aTmpCnt(cnt3) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt3)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:04"} {
	   			set aTmpCnt(cnt4) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt4)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:05"} {
	   			set aTmpCnt(cnt5) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt5)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:06"} {
	   			set aTmpCnt(cnt6) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt6)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:07"} {
	   			set aTmpCnt(cnt7) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:08"} {
	   			set aTmpCnt(cnt8) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:09"} {
	   			set aTmpCnt(cnt9) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0a"} {
	   			set aTmpCnt(cnt10) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0b"} {
	   			set aTmpCnt(cnt11) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt11)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0c"} {
	   			set aTmpCnt(cnt12) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt12)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0d"} {
	   			set aTmpCnt(cnt13) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt13)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0e"} {
	   			set aTmpCnt(cnt14) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt14)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:15"} {
	   			set aTmpCnt(cnt15) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt15)]
        		}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:16"} {
	   			set aTmpCnt(cnt16) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt16)]
			}    
		} elseif {$statPara == 2} {   
			if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
	    		$aResults(-FilteredValue_2) == "200" && $aResults(-FilteredValue_1) == "1000"} {
	  			set aTmpCnt(cnt1) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
	    		$aResults(-FilteredValue_2) == "200" && $aResults(-FilteredValue_1) == "1000"} {
	  			set aTmpCnt(cnt2) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
	    		$aResults(-FilteredValue_2) == "17" && $aResults(-FilteredValue_1) == "21"} {
	  			set aTmpCnt(cnt3) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt3)]
			}
			if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
	    		$aResults(-FilteredValue_2) == "17" && $aResults(-FilteredValue_1) == "21"} {
	   			set aTmpCnt(cnt4) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt4)]
			}
			if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
	    		$aResults(-FilteredValue_2) == "18" && $aResults(-FilteredValue_1) == "21"} {
	   			set aTmpCnt(cnt5) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt5)]
			}
			if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
	   		$aResults(-FilteredValue_2) == "18" && $aResults(-FilteredValue_1) == "21"} {
	   			set aTmpCnt(cnt6) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt6)]
			} 
			if {[string match -nocase "LSP-TTL (hex)" $aResults(-FilteredName_2)] &&\
				 [string match -nocase "PW-TTL (hex)" $aResults(-FilteredName_3)] &&\
				$aResults(-FilteredValue_2) == "ff 00 " &&\
				$aResults(-FilteredValue_3) == "ff 00 "} {
				set aTmpCnt(cnt7) $aResults(-L1BitRate)
			}
			if {[string match -nocase "LSP-TTL (hex)" $aResults(-FilteredName_2)] &&\
				 [string match -nocase "PW-TTL (hex)" $aResults(-FilteredName_3)] &&\
				$aResults(-FilteredValue_2) == "fe 00 " &&\
				$aResults(-FilteredValue_3) == "ff 00 "} {
				set aTmpCnt(cnt8) $aResults(-L1BitRate)
			}
		} elseif {$statPara == 3} {    
	  		if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_3)] && [string match -nocase "Mpls 0 - Experimental Bits (bits)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Bottom of stack (bit)" $aResults(-FilteredName_1)] &&\
	      		$aResults(-FilteredValue_3) == "100" && $aResults(-FilteredValue_2) == "000" && $aResults(-FilteredValue_1) == "1"} {
	    			set aTmpCnt(cnt1) $aResults(-L1BitRate)
	 		}
	  		if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_3)] && [string match -nocase "Mpls 0 - Experimental Bits (bits)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Bottom of stack (bit)" $aResults(-FilteredName_1)] &&\
	      		$aResults(-FilteredValue_3) == "100" && $aResults(-FilteredValue_2) == "000" && $aResults(-FilteredValue_1) == "1"} {
	    			set aTmpCnt(cnt2) $aResults(-L1BitRate)
	  		}
	  		if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_3)] && [string match -nocase "Mpls 0 - Experimental Bits (bits)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Bottom of stack (bit)" $aResults(-FilteredName_1)] &&\
	      		$aResults(-FilteredValue_3) == "300" && $aResults(-FilteredValue_2) == "000" && $aResults(-FilteredValue_1) == "1"} {
	    			set aTmpCnt(cnt3) [expr $aResults(-L1BitRate)+$aTmpCnt(cnt3)]
	  		}
	  		if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_3)] && [string match -nocase "Mpls 0 - Experimental Bits (bits)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Bottom of stack (bit)" $aResults(-FilteredName_1)] &&\
	      		$aResults(-FilteredValue_3) == "300" && $aResults(-FilteredValue_2) == "000" && $aResults(-FilteredValue_1) == "1"} {
	    			set aTmpCnt(cnt4) [expr $aResults(-L1BitRate)+$aTmpCnt(cnt4)]
	  		}
	  		if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_3)] && [string match -nocase "Mpls 0 - Experimental Bits (bits)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Bottom of stack (bit)" $aResults(-FilteredName_1)] &&\
	      		$aResults(-FilteredValue_3) == "400" && $aResults(-FilteredValue_2) == "000" && $aResults(-FilteredValue_1) == "1"} {
	    			set aTmpCnt(cnt5) [expr $aResults(-L1BitRate)+$aTmpCnt(cnt5)]
	  		}
	  		if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_3)] && [string match -nocase "Mpls 0 - Experimental Bits (bits)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Bottom of stack (bit)" $aResults(-FilteredName_1)] &&\
	      		$aResults(-FilteredValue_3) == "400" && $aResults(-FilteredValue_2) == "000" && $aResults(-FilteredValue_1) == "1"} {
	    			set aTmpCnt(cnt6) [expr $aResults(-L1BitRate)+$aTmpCnt(cnt6)]
	  		}	  
		} elseif {$statPara == 4} {
	      		if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
		  	$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:01"} {
		  		set aTmpCnt(cnt1) [expr $aResults(-FrameCount) + $aTmpCnt(cnt1)]
	       		}
	      		if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
		  	$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
		  		set aTmpCnt(cnt2) [expr $aResults(-FrameCount) + $aTmpCnt(cnt2)]
	       		}
	      		if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0b"} {
				set aTmpCnt(cnt3) [expr $aResults(-FrameCount) + $aTmpCnt(cnt3)]
	       		}
	      		if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
		 	$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0c"} {
		 		set aTmpCnt(cnt4) [expr $aResults(-FrameCount) + $aTmpCnt(cnt4)]
	       		}
	      		if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
			$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "100"} {
				set aTmpCnt(cnt5) $aResults(-FrameCount)
		   	}	  
		} elseif {$statPara == 5} { 
		      	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:01"} {
			 	set aTmpCnt(cnt1) [expr $aResults(-FrameCount) + $aTmpCnt(cnt1)]
#			 	set aTmpCnt(cnt15) $aResults(-FrameRate)
		       	}
		       	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:02"} {
			 	set aTmpCnt(cnt2) [expr $aResults(-FrameCount) + $aTmpCnt(cnt2)]
		       	}
		      	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0b"} {
				set aTmpCnt(cnt3) [expr $aResults(-FrameCount) + $aTmpCnt(cnt3)]
		       	}
		      	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0c"} {
				set aTmpCnt(cnt4) [expr $aResults(-FrameCount) + $aTmpCnt(cnt4)]
		       	}	  
		} elseif {$statPara == 6} {
		     	if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			 $aResults(-FilteredValue_1) == "100" && [string match -nocase $aResults(-FilteredValue_2) $dev_sysmac1]} {
			 	set aTmpCnt(cnt1) [expr $aResults(-FrameCount) + $aTmpCnt(cnt1)]
		       	}
		     	if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			 $aResults(-FilteredValue_1) == "400" && [string match -nocase $aResults(-FilteredValue_2) $dev_sysmac2]} {
			 	set aTmpCnt(cnt2) [expr $aResults(-FrameCount) + $aTmpCnt(cnt2)]
		       	}
		     	if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			$aResults(-FilteredValue_1) == "100" && [string match -nocase $aResults(-FilteredValue_2) $dev_sysmac1]} {
				set aTmpCnt(cnt3) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			$aResults(-FilteredValue_1) == "100" && [string match -nocase $aResults(-FilteredValue_2) $dev_sysmac2]} {
				set aTmpCnt(cnt4) $aResults(-L1BitRate)
			}
		}
	}
	return $flag
}
########################################################################################################
#函数功能：根据分析器的设置统计各条流的收发情况
#输入参数：statPara ==1 分析器中添加vlan统计字段                ==0 分析器中不添加vlan统计字段
#          hAna：端口分析器handle
#输出参数：aRecCnt：统计结果
#返回值：    无
########################################################################################################
proc classificationStatisticsPortRxCnt3 {statPara hAna aRecCnt} { 
	set flag 0
        upvar $aRecCnt aTmpCnt
        array set aTmpCnt {cnt1 0 drop1 0 rate1 0 cnt2 0 drop2 0 rate2 0 cnt3 0 drop3 0 rate3 0 \
          cnt4 0 drop4 0 rate4 0 cnt5 0 drop5 0 rate5 0 cnt6 0 drop6 0 rate6 0 cnt7 0 drop7 0 rate7 0}
        #同步分析器和发生器统计延时2s  
        after 2000 
        ##获取分析器统计的数值并进行匹配
        foreach resultsObj [stc::get $hAna -children-FilteredStreamResults] {
                if {[catch {
                        send_log "\n resultsObj:$resultsObj"
                        after 2000
                        array set aResults [stc::get $resultsObj]
                        after 2000
                        gwd::Clear_ResultViewStat $resultsObj
                } err]} {
			set flag 1
                        send_log "\n filter_err:$err"
                        continue
                }
		if {$statPara == 1} {
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "50" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                                set aTmpCnt(cnt2)  $aResults(-L1BitRate)
                                set aTmpCnt(drop2) $aResults(-DroppedFrameCount)
                                set aTmpCnt(rate2) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "1000" && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
                                set aTmpCnt(cnt3)  $aResults(-L1BitRate)
                                set aTmpCnt(drop3) $aResults(-DroppedFrameCount)
                                set aTmpCnt(rate3) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                           $aResults(-FilteredValue_1) == "3000" && $aResults(-FilteredValue_2) == "00:00:00:00:00:05"} {
                                set aTmpCnt(cnt5) $aResults(-L1BitRate)
                                set aTmpCnt(drop5) $aResults(-DroppedFrameCount)
                                set aTmpCnt(rate5) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                           $aResults(-FilteredValue_1) == "1000" && $aResults(-FilteredValue_2) == "00:00:00:00:00:06"} {
                                set aTmpCnt(cnt6) $aResults(-L1BitRate)
                                set aTmpCnt(drop6) $aResults(-DroppedFrameCount)
                                set aTmpCnt(rate6) $aResults(-FrameRate)
                        }
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                              $aResults(-FilteredValue_1) == "2000" && $aResults(-FilteredValue_2) == "00:00:00:00:00:07"} {
                            set aTmpCnt(cnt7) $aResults(-L1BitRate)
                            set aTmpCnt(drop7) $aResults(-DroppedFrameCount)
                            set aTmpCnt(rate7) $aResults(-FrameRate)
			}
		} elseif {$statPara == 0} {
                        if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:01"} {
                           set aTmpCnt(cnt1) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt1)]
                           set aTmpCnt(drop1) $aResults(-DroppedFrameCount)
                           set aTmpCnt(rate1) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:02"} {
                           set aTmpCnt(cnt2) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt2)]
                           set aTmpCnt(drop2) $aResults(-DroppedFrameCount)
                           set aTmpCnt(rate2) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:03"} {
                           set aTmpCnt(cnt3) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt3)]
                           set aTmpCnt(drop3) $aResults(-DroppedFrameCount)
                           set aTmpCnt(rate3) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:04"} {
                           set aTmpCnt(cnt4) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt4)]
                           set aTmpCnt(drop4) $aResults(-DroppedFrameCount)
                           set aTmpCnt(rate4) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:05"} {
                           set aTmpCnt(cnt5) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt5)]
                           set aTmpCnt(drop5) $aResults(-DroppedFrameCount)
                           set aTmpCnt(rate5) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:06"} {
                           set aTmpCnt(cnt6) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt6)]
                           set aTmpCnt(drop6) $aResults(-DroppedFrameCount)
                           set aTmpCnt(rate6) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:07"} {
                           set aTmpCnt(cnt7) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt7)]
                           set aTmpCnt(drop7) $aResults(-DroppedFrameCount)
                           set aTmpCnt(rate7) $aResults(-FrameRate)
                        }
		}
	}
	return $flag
}
########################################################################################################
#函数功能：根据分析器的设置统计各条流的收发情况
#输入参数：statPara ==1 分析器中添加vlan统计字段                ==0 分析器中不添加vlan统计字段
#          hAna：端口分析器handle
#输出参数：aRecCnt：统计结果
#返回值：    无
########################################################################################################
proc classificationStatisticsPortRxCnt4 {statPara hAna aRecCnt} { 
	set flag 0
	upvar $aRecCnt aTmpCnt
	#同步分析器和发生器统计延时2s  
	after 2000 
	#获取分析器统计的数值并进行匹配
	foreach resultsObj [stc::get $hAna -children-FilteredStreamResults] {
		if {[catch {
			send_log "\n resultsObj:$resultsObj"
			after 2000
			array set aResults [stc::get $resultsObj]
			after 2000
			gwd::Clear_ResultViewStat $resultsObj
		} err]} {
			set flag 1
			send_log "\n filter_err:$err"
			continue
		}
		if {$statPara == 1} {
			#获取分析器统计的数值
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:01"} {
				set aTmpCnt(cnt1) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt1)]
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:01"} {
				set aTmpCnt(cnt81) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt1)]
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
				set aTmpCnt(cnt2) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt2)]
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
					[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
				set aTmpCnt(cnt3) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt3)]
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:04"} {
				set aTmpCnt(cnt4) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt4)]
			} 
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
				$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "1000"} {
				set aTmpCnt(cnt8) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "800"} {
				set aTmpCnt(cnt9) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "1000"} {
				set aTmpCnt(cnt5) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
				$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "800"} {
				set aTmpCnt(cnt23) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0a"} {
				set aTmpCnt(cnt10) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0b"} {
				set aTmpCnt(cnt11) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0c"} {
				set aTmpCnt(cnt12) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0c"} {
				set aTmpCnt(cnt14) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0d"} {
				set aTmpCnt(cnt13) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:22"} {
				set aTmpCnt(cnt22) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:33"} {
				set aTmpCnt(cnt33) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:44"} {
				set aTmpCnt(cnt44) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:f2"} {
				set aTmpCnt(cnt18) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:f2"} {
				set aTmpCnt(cnt15) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:f3"} {
				set aTmpCnt(cnt23) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "102" && $aResults(-FilteredValue_2) == "00:00:00:00:00:f2"} {
				set aTmpCnt(cnt6) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "104" && $aResults(-FilteredValue_2) == "00:00:00:00:00:f2"} {
				set aTmpCnt(cnt7) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "102" && $aResults(-FilteredValue_2) == "00:00:00:00:00:f3"} {
				set aTmpCnt(cnt16) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "104" && $aResults(-FilteredValue_2) == "00:00:00:00:00:04"} {
				set aTmpCnt(cnt17) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:f3"} {
				set aTmpCnt(cnt19) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:f4"} {
				set aTmpCnt(cnt20) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:cc"} {
				set aTmpCnt(cnt21) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "88 47 " && \
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:12"} {
				set aTmpCnt(cnt61) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "88 47 " && \
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:13"} {
				set aTmpCnt(cnt62) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "88 47 " && \
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:14"} {
				set aTmpCnt(cnt63) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "88 47 " && \
			  $aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:15"} {
			  set aTmpCnt(cnt64) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				 [string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
			    $aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:1b"} {
			    set aTmpCnt(cnt101) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
			    $aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:1c"} {
			    set aTmpCnt(cnt102) $aResults(-L1BitRate)
			      }
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
			    $aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:1d"} {
			    set aTmpCnt(cnt104) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				 [string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "88 47 " && \
			    $aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:1b"} {
			    set aTmpCnt(cnt111) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "88 47 " && \
			    $aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:1c"} {
			    set aTmpCnt(cnt112) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "88 47 " && \
			    $aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:1d"} {
			    set aTmpCnt(cnt114) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
			    $aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "800"} {
			    set aTmpCnt(cnt24) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
			    $aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "500"} {
			    set aTmpCnt(cnt25) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
			    $aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "500"} {
			    set aTmpCnt(cnt26) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
			    $aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "100"} {
			    set aTmpCnt(cnt27) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
			    $aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "100"} {
			    set aTmpCnt(cnt28) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
			     $aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:01:05"} {
			     set aTmpCnt(cnt50) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:02:00"} {
				set aTmpCnt(cnt51) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:02:00"} {
				set aTmpCnt(cnt52) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:02:05"} {
				set aTmpCnt(cnt53) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:02:08"} {
				set aTmpCnt(cnt54) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0d"} {
				set aTmpCnt(cnt55) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:03:05"} {
				 set aTmpCnt(cnt56) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:02:08"} {
				set aTmpCnt(cnt57) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:03:05"} {
				 set aTmpCnt(cnt58) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				     $aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:01:05"} {
				     set aTmpCnt(cnt59) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				     $aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:01:0a"} {
				     set aTmpCnt(cnt60) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				     $aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:01:0b"} {
				     set aTmpCnt(cnt65) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
					$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:08"} {
						set aTmpCnt(cnt66) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
					$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:01"} {
						set aTmpCnt(cnt67) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
					$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:f3:f3"} {
						set aTmpCnt(cnt68) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
					$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0d"} {
				set aTmpCnt(cnt69) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
					$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:dd"} {
				set aTmpCnt(cnt70) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
					$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:26"} {
				set aTmpCnt(cnt71) $aResults(-L1BitRate)
			}
		} elseif {$statPara == 0} {
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:01"} {
			   set aTmpCnt(cnt1) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt1)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:02"} {
			   set aTmpCnt(cnt2) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt2)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:03"} {
			   set aTmpCnt(cnt3) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt3)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:04"} {
			   set aTmpCnt(cnt4) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt4)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:05"} {
			   set aTmpCnt(cnt5) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt5)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:08"} {
			   set aTmpCnt(cnt8) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:09"} {
			   set aTmpCnt(cnt9) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0a"} {
			   set aTmpCnt(cnt10) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0b"} {
			   set aTmpCnt(cnt11) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt11)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0c"} {
			   set aTmpCnt(cnt12) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt12)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:f2"} {
			   set aTmpCnt(cnt14) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt12)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0d"} {
			   set aTmpCnt(cnt13) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt13)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:06"} {
			   set aTmpCnt(cnt6) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt6)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:22"} {
			   set aTmpCnt(cnt02) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt02)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:33"} {
			   set aTmpCnt(cnt03) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt03)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:44"} {
			   set aTmpCnt(cnt04) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt04)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:0e"} {
			   set aTmpCnt(cnt01) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt01)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:f3"} {
			   set aTmpCnt(cnt16) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt16)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:04"} {
			   set aTmpCnt(cnt17) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt17)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:f2"} {
			   set aTmpCnt(cnt7) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt17)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:12"} {
			   set aTmpCnt(cnt61) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt61)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:13"} {
			   set aTmpCnt(cnt62) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt62)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:14"} {
			   set aTmpCnt(cnt63) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt63)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:15"} {
			   set aTmpCnt(cnt64) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt64)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:1b"} {
			   set aTmpCnt(cnt101) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt101)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:1c"} {
			   set aTmpCnt(cnt102) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt102)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:1d"} {
			   set aTmpCnt(cnt104) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt104)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:01:05"} {
			   set aTmpCnt(cnt50) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt50)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:04:05"} {
			   set aTmpCnt(cnt51) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt51)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:02:00"} {
			   set aTmpCnt(cnt52) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt52)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:02:05"} {
			   set aTmpCnt(cnt53) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt53)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:02:08"} {
			   set aTmpCnt(cnt54) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt54)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:03:00"} {
				set aTmpCnt(cnt55) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt55)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:03:05"} {
				set aTmpCnt(cnt56) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt56)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:03:08"} {
				 set aTmpCnt(cnt57) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt57)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:f4"} {
				set aTmpCnt(cnt58) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt58)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:f3:f3"} {
				set aTmpCnt(cnt68) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:26"} {
				set aTmpCnt(cnt69) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:dd"} {
				set aTmpCnt(cnt70) $aResults(-L1BitRate)
			}  
		} elseif {$statPara == 2} {
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			     $aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
			     set aTmpCnt(cnt02) [expr $aResults(-FrameCount)+$aTmpCnt(cnt02)]
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			     $aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
			     set aTmpCnt(cnt03) [expr $aResults(-FrameCount)+$aTmpCnt(cnt03)]
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			     $aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:04"} {
			     set aTmpCnt(cnt04) [expr $aResults(-FrameCount)+$aTmpCnt(cnt04)]
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			     $aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0d"} {
			     set aTmpCnt(cnt2) [expr $aResults(-FrameCount)+$aTmpCnt(cnt2)]
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			    $aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:f2"} {
			    set aTmpCnt(cnt3) [expr $aResults(-FrameCount)+$aTmpCnt(cnt3)]
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			    $aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:f3"} {
			    set aTmpCnt(cnt4) [expr $aResults(-FrameCount)+$aTmpCnt(cnt4)]
			}
		} elseif {$statPara == 3} {
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0c"} {
					set aTmpCnt(cnt12) $aResults(-L1BitRate)
					set aTmpCnt(drop12) $aResults(-DroppedFrameCount)
					set aTmpCnt(rate12) $aResults(-FrameRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:0d"} {
				set aTmpCnt(cnt13) $aResults(-L1BitRate)
				set aTmpCnt(drop13) $aResults(-DroppedFrameCount)
				set aTmpCnt(rate13) $aResults(-FrameRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:f3"} {
					set aTmpCnt(cnt19) $aResults(-L1BitRate)
					set aTmpCnt(drop19) $aResults(-DroppedFrameCount)
					set aTmpCnt(rate19) $aResults(-FrameRate)
			}
		} elseif {$statPara == 5} {
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			    $aResults(-FilteredValue_1) == "1000" && $aResults(-FilteredValue_2) == "00:00:00:0c:00:00"} {
			    set aTmpCnt(cnt8) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt8)]
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			    $aResults(-FilteredValue_1) == "7" && $aResults(-FilteredValue_2) == "00:00:F4:F4:00:00"} {
			    set aTmpCnt(cnt12) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt12)]
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			    $aResults(-FilteredValue_1) == "4" && $aResults(-FilteredValue_2) == "00:00:00:dd:00:00"} {
			    set aTmpCnt(cnt14) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt14)]
			}
		} elseif {$statPara == 6} {
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == 800 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:0c"} {
				set aTmpCnt(cnt1) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 500 && \
				$aResults(-FilteredValue_2) == 1000 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:26"} {
				set aTmpCnt(cnt2) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 500 && \
				$aResults(-FilteredValue_2) == 800 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:26"} {
				set aTmpCnt(cnt10) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 500 && \
				$aResults(-FilteredValue_2) == 500 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:01:05"} {
				set aTmpCnt(cnt11) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 500 && \
				$aResults(-FilteredValue_2) == 800 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:01:05"} {
				set aTmpCnt(cnt12) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 800 && \
				$aResults(-FilteredValue_2) == 500 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:0c"} {
				set aTmpCnt(cnt13) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 800 && \
				$aResults(-FilteredValue_2) == 800 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:0c"} {
				set aTmpCnt(cnt14) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == 1000 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:08"} {
				set aTmpCnt(cnt15) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 800 && \
				$aResults(-FilteredValue_2) == 1000 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:0c"} {
				set aTmpCnt(cnt16) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == 800 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:08"} {
				set aTmpCnt(cnt17) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 500 && \
				$aResults(-FilteredValue_2) == 100 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:02"} {
				set aTmpCnt(cnt18) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == 100 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:0c"} {
				set aTmpCnt(cnt19) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 500 && \
				$aResults(-FilteredValue_2) == 500 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:02:05"} {
				set aTmpCnt(cnt21) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 500 && \
				$aResults(-FilteredValue_2) == 800 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:02:05"} {
				set aTmpCnt(cnt22) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 800 && \
				$aResults(-FilteredValue_2) == 500 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:02:08"} {
				set aTmpCnt(cnt23) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 800 && \
				$aResults(-FilteredValue_2) == 800 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:02:08"} {
				set aTmpCnt(cnt24) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == 1000 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:02:10"} {
				set aTmpCnt(cnt25) $aResults(-L1BitRate)
			} 
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == 800 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:09"} {
				set aTmpCnt(cnt26) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == 800 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:dd"} {
				set aTmpCnt(cnt27) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 500 && \
				$aResults(-FilteredValue_2) == 500 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:03:05"} {
				set aTmpCnt(cnt31) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 500 && \
				$aResults(-FilteredValue_2) == 800 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:03:05"} {
				set aTmpCnt(cnt32) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 800 && \
				$aResults(-FilteredValue_2) == 500 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:03:08"} {
				set aTmpCnt(cnt33) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 800 && \
				$aResults(-FilteredValue_2) == 800 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:03:08"} {
				set aTmpCnt(cnt34) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == 1000 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:03:10"} {
				set aTmpCnt(cnt35) $aResults(-L1BitRate)
			} 
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 500 && \
				$aResults(-FilteredValue_2) == 500 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:04:05"} {
				set aTmpCnt(cnt41) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 500 && \
				$aResults(-FilteredValue_2) == 800 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:04:05"} {
				set aTmpCnt(cnt42) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 800 && \
				$aResults(-FilteredValue_2) == 500 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:0d"} {
				set aTmpCnt(cnt43) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 800 && \
				$aResults(-FilteredValue_2) == 800 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:0d"} {
				set aTmpCnt(cnt44) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == 1000 && \
				$aResults(-FilteredValue_4) == "08 00 " && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:09"} {
				set aTmpCnt(cnt45) $aResults(-L1BitRate)
			}
		} elseif {$statPara == 7} {
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
				$aResults(-FilteredValue_2) == "08 00 " && \
				$aResults(-FilteredValue_1) == "00:00:00:00:00:02"} {
				set aTmpCnt(cnt2) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
				$aResults(-FilteredValue_2) == "08 00 " && \
				$aResults(-FilteredValue_1) == "00:00:00:00:00:26"} {
				set aTmpCnt(cnt3) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
				$aResults(-FilteredValue_2) == "08 00 " && \
				$aResults(-FilteredValue_1) == "00:00:00:00:00:05"} {
				set aTmpCnt(cnt5) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
			  [string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
			  $aResults(-FilteredValue_2) == "08 00 " && \
			  $aResults(-FilteredValue_1) == "00:00:00:00:00:06"} {
			  set aTmpCnt(cnt6) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
				$aResults(-FilteredValue_2) == "08 00 " && \
				$aResults(-FilteredValue_1) == "00:00:00:00:00:01"} {
				set aTmpCnt(cnt10) $aResults(-L1BitRate)
			}
			
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
			  $aResults(-FilteredValue_2) == "08 00 " && \
			  $aResults(-FilteredValue_1) == "00:00:00:00:01:05"} {
			  set aTmpCnt(cnt15) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
			  $aResults(-FilteredValue_2) == "08 00 " && \
			  $aResults(-FilteredValue_1) == "00:00:00:00:00:0c"} {
			  set aTmpCnt(cnt18) $aResults(-L1BitRate)
			}
		  if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
			 $aResults(-FilteredValue_2) == "08 00 " && \
			 $aResults(-FilteredValue_1) == "00:00:00:00:02:00"} {
			 set aTmpCnt(cnt20) $aResults(-L1BitRate)
		  }
		  if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
				$aResults(-FilteredValue_2) == "08 00 " && \
				$aResults(-FilteredValue_1) == "00:00:00:00:00:f2"} {
				set aTmpCnt(cnt21) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
			      $aResults(-FilteredValue_2) == "08 00 " && \
			      $aResults(-FilteredValue_1) == "00:00:00:00:02:05"} {
			      set aTmpCnt(cnt25) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
			      $aResults(-FilteredValue_2) == "08 00 " && \
			      $aResults(-FilteredValue_1) == "00:00:00:00:02:08"} {
			      set aTmpCnt(cnt28) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
			   $aResults(-FilteredValue_2) == "08 00 " && \
			   $aResults(-FilteredValue_1) == "00:00:00:00:03:00"} {
			   set aTmpCnt(cnt30) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
			  [string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
			     $aResults(-FilteredValue_2) == "08 00 " && \
			     $aResults(-FilteredValue_1) == "00:00:00:00:00:f3"} {
			     set aTmpCnt(cnt31) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
			  $aResults(-FilteredValue_2) == "08 00 " && \
			  $aResults(-FilteredValue_1) == "00:00:00:00:03:05"} {
			  set aTmpCnt(cnt35) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
			  $aResults(-FilteredValue_2) == "08 00 " && \
			  $aResults(-FilteredValue_1) == "00:00:00:00:03:08"} {
			  set aTmpCnt(cnt38) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
			  $aResults(-FilteredValue_2) == "08 00 " && \
			  $aResults(-FilteredValue_1) == "00:00:00:00:00:0e"} {
			  set aTmpCnt(cnt40) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
			  [string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
				$aResults(-FilteredValue_2) == "08 00 " && \
					$aResults(-FilteredValue_1) == "00:00:00:00:00:04"} {
				set aTmpCnt(cnt41) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
			   [string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
			      $aResults(-FilteredValue_2) == "08 00 " && \
			      $aResults(-FilteredValue_1) == "00:00:00:00:00:f3"} {
			      set aTmpCnt(cnt42) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
				 $aResults(-FilteredValue_2) == "08 00 " && \
				 $aResults(-FilteredValue_1) == "00:00:00:00:04:05"} {
				 set aTmpCnt(cnt45) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
			      $aResults(-FilteredValue_2) == "08 00 " && \
			      $aResults(-FilteredValue_1) == "00:00:00:00:00:0d"} {
			      set aTmpCnt(cnt48) $aResults(-L1BitRate)
			}
		}
	}
	return $flag
}
########################################################################################################
#函数功能：根据分析器的设置统计各条流的收发情况
#输入参数：statPara ==1 分析器中添加vlan统计字段                ==0 分析器中不添加vlan统计字段
#          hAna：端口分析器handle
#输出参数：aRecCnt：统计结果
#返回值：    无
########################################################################################################
proc classificationStatisticsPortRxCnt5 {statPara hAna aRecCnt} { 
	set flag 0
        upvar $aRecCnt aTmpCnt
        global newGPNMac
        global fileId
        #同步分析器和发生器统计延时2s  
        after 2000 
        #获取分析器统计的数值并进行匹配
	foreach resultsObj [stc::get $hAna -children-FilteredStreamResults] {
                if {[catch {
                        send_log "\n resultsObj:$resultsObj"
                        after 2000
                        array set aResults [stc::get $resultsObj]
                        after 2000
                        gwd::Clear_ResultViewStat $resultsObj
                } err]} {
			set flag 1
                        send_log "\n filter_err:$err"
                        continue
                }
        	if {$statPara == 1} {
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                        	set aTmpCnt(cnt1)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Destination MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "402" && [string match -nocase $newGPNMac $aResults(-FilteredValue_2)]} {
                        	set aTmpCnt(cnt2)  $aResults(-L1BitRate)
                        } 
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Destination MAC" $aResults(-FilteredName_2)] &&\
                           $aResults(-FilteredValue_1) == "403" && [string match -nocase $newGPNMac $aResults(-FilteredValue_2)]} {
                        	set aTmpCnt(cnt3) $aResults(-L1BitRate)
                        } 
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Destination MAC" $aResults(-FilteredName_2)] &&\
                           $aResults(-FilteredValue_1) == "404" && [string match -nocase $newGPNMac $aResults(-FilteredValue_2)]} {
                        	set aTmpCnt(cnt4) $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Destination MAC" $aResults(-FilteredName_2)] &&\
                             $aResults(-FilteredValue_1) == "405" && [string match -nocase $newGPNMac $aResults(-FilteredValue_2)]} {
                        	set aTmpCnt(cnt5) $aResults(-L1BitRate)
                        } 
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Destination MAC" $aResults(-FilteredName_2)] &&\
                           $aResults(-FilteredValue_1) == "406" && [string match -nocase $newGPNMac $aResults(-FilteredValue_2)]} {
                        	set aTmpCnt(cnt6) $aResults(-L1BitRate)
                        } 
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Destination MAC" $aResults(-FilteredName_2)] &&\
                           $aResults(-FilteredValue_1) == "407" && [string match -nocase $newGPNMac $aResults(-FilteredValue_2)]} {
                        	set aTmpCnt(cnt7) $aResults(-L1BitRate)
                        } 
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "501" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                        	set aTmpCnt(cnt8)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "502" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                        	set aTmpCnt(cnt9)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "503" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                        	set aTmpCnt(cnt10)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "504" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                        	set aTmpCnt(cnt11)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "505" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                       		set aTmpCnt(cnt12)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "600" && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
                        	set aTmpCnt(cnt13)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "601" && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
                        	set aTmpCnt(cnt14)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "602" && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
                        	set aTmpCnt(cnt15)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "603" && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
                        	set aTmpCnt(cnt16)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "604" && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
                        	set aTmpCnt(cnt17)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                          $aResults(-FilteredValue_1) == "605" && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
                        	set aTmpCnt(cnt18)  $aResults(-L1BitRate)
                        }
        	} elseif {$statPara == 0} {
                	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:01"} {
                	   set aTmpCnt(cnt1) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt1)]
                	   set aTmpCnt(drop1) $aResults(-DroppedFrameCount)
                	   set aTmpCnt(rate1) $aResults(-FrameRate)
                	}
                	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:02"} {
                	   set aTmpCnt(cnt2) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt2)]
                	   set aTmpCnt(drop2) $aResults(-DroppedFrameCount)
                	   set aTmpCnt(rate2) $aResults(-FrameRate)
                	}
                	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:03"} {
                	   set aTmpCnt(cnt3) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt3)]
                	   set aTmpCnt(drop3) $aResults(-DroppedFrameCount)
                	   set aTmpCnt(rate3) $aResults(-FrameRate)
                	}
                	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:04"} {
                	   set aTmpCnt(cnt4) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt4)]
                	   set aTmpCnt(drop4) $aResults(-DroppedFrameCount)
                	   set aTmpCnt(rate4) $aResults(-FrameRate)
                	}
		} elseif {$statPara == 2} {
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                         	$aResults(-FilteredValue_2) == "1000" && $aResults(-FilteredValue_1) == "1600"} {
                          	set aTmpCnt(cnt1) $aResults(-L1BitRate)
                        } 
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                         	$aResults(-FilteredValue_2) == "1001" && $aResults(-FilteredValue_1) == "1601"} {
                          	set aTmpCnt(cnt2) $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                         	$aResults(-FilteredValue_2) == "1002" && $aResults(-FilteredValue_1) == "1602"} {
                          	set aTmpCnt(cnt3) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt3)]
                        }
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                         	$aResults(-FilteredValue_2) == "1003" && $aResults(-FilteredValue_1) == "1603"} {
                        	set aTmpCnt(cnt4) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt4)]
                        } 
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                         	$aResults(-FilteredValue_2) == "1004" && $aResults(-FilteredValue_1) == "1604"} {
                        	set aTmpCnt(cnt5) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt5)]
                        } 
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                        	$aResults(-FilteredValue_2) == "1005" && $aResults(-FilteredValue_1) == "1605"} {
                        	set aTmpCnt(cnt6) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt6)]
                        } 
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                                $aResults(-FilteredValue_2) == "100" && $aResults(-FilteredValue_1) == "1000"} {
                                set aTmpCnt(cnt7) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt7)]
                        }
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                                $aResults(-FilteredValue_2) == "500" && $aResults(-FilteredValue_1) == "5000"} {
                                set aTmpCnt(cnt8) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt8)]
                        }
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                                $aResults(-FilteredValue_2) == "400" && $aResults(-FilteredValue_1) == "4000"} {
                                set aTmpCnt(cnt9) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt9)]
                        }
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                                $aResults(-FilteredValue_2) == "17" && $aResults(-FilteredValue_1) == "1000"} {
                                set aTmpCnt(cnt10) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt10)]
                        }
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                                $aResults(-FilteredValue_2) == "20" && $aResults(-FilteredValue_1) == "3000"} {
                                set aTmpCnt(cnt11) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt11)]
                        }
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                                $aResults(-FilteredValue_2) == "18" && $aResults(-FilteredValue_1) == "2000"} {
                                set aTmpCnt(cnt12) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt12)]
                        }
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                                $aResults(-FilteredValue_2) == "21" && $aResults(-FilteredValue_1) == "3000"} {
                                set aTmpCnt(cnt13) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt13)]
                        }
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                                $aResults(-FilteredValue_2) == "22" && $aResults(-FilteredValue_1) == "3000"} {
                                set aTmpCnt(cnt14) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt14)]
                        }
                        if {[string match -nocase "Mpls 0 - Label (int)" $aResults(-FilteredName_2)] && [string match -nocase "Mpls 1 - Label (int)" $aResults(-FilteredName_1)] &&\
                                $aResults(-FilteredValue_2) == "23" && $aResults(-FilteredValue_1) == "3000"} {
                                set aTmpCnt(cnt15) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt15)]
			}	  
		} elseif {$statPara == 4} {
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                                $aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                                set aTmpCnt(cnt1) [expr $aResults(-FrameCount) + $aTmpCnt(cnt1)]
                                set aTmpCnt(cnt21) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                                $aResults(-FilteredValue_1) == "501" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                                set aTmpCnt(cnt2) [expr $aResults(-FrameCount) + $aTmpCnt(cnt2)]
                                set aTmpCnt(cnt22) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                                $aResults(-FilteredValue_1) == "502" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                                set aTmpCnt(cnt3) [expr $aResults(-FrameCount) + $aTmpCnt(cnt3)]
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                                $aResults(-FilteredValue_1) == "503" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                                set aTmpCnt(cnt4) [expr $aResults(-FrameCount) + $aTmpCnt(cnt4)]
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                                $aResults(-FilteredValue_1) == "504" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                                set aTmpCnt(cnt5) [expr $aResults(-FrameCount) + $aTmpCnt(cnt5)]
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                                $aResults(-FilteredValue_1) == "505" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                                set aTmpCnt(cnt6) [expr $aResults(-FrameCount) + $aTmpCnt(cnt6)]
                        }
		}	  	
	}
	return $flag
}
########################################################################################################
#函数功能：根据分析器的设置统计各条流的收发情况
#输入参数：statPara ==1 分析器中添加vlan统计字段                ==0 分析器中不添加vlan统计字段
#          hAna：端口分析器handle
#输出参数：aRecCnt：统计结果
#返回值：    无
########################################################################################################
proc classificationStatisticsPortRxCnt9 {statPara hAna aRecCnt} { 
	set flag 0
        upvar $aRecCnt aTmpCnt
        #同步分析器和发生器统计延时2s  
        after 2000 
  	#获取分析器统计的数值并进行匹配
	foreach resultsObj [stc::get $hAna -children-FilteredStreamResults] {
        	if {[catch {
                	send_log "\n resultsObj:$resultsObj"
                	after 2000
                	array set aResults [stc::get $resultsObj]
                	after 2000
                	gwd::Clear_ResultViewStat $resultsObj
        	} err]} {
			set flag 1
                	send_log "\n filter_err:$err"
                	continue
        	}
		if {$statPara == 1} {
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                        	[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
                                  $aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
                                set aTmpCnt(cnt2)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                        	[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
                          	$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:06"} {
                        	set aTmpCnt(cnt6)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                        	[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
                           	$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:05"} {
                        	set aTmpCnt(cnt9) $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                              [string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
                          	$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:22"} {
                        	set aTmpCnt(cnt22)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                              [string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
                          	$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:33"} {
                        	set aTmpCnt(cnt33)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                        	[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
                           	$aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:55"} {
                         	set aTmpCnt(cnt44) $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                        		[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
                            	$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:11"} {
                          	set aTmpCnt(cnt11)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                        	       [string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
                            	$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:12"} {
                          	set aTmpCnt(cnt12)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                        	[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
                             	$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:13"} {
                           	set aTmpCnt(cnt13) $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                        	[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
                            	$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:11:11"} {
                          	set aTmpCnt(cnt14)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                        	[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
                            	$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:12:12"} {
                          	set aTmpCnt(cnt15)  $aResults(-L1BitRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                        	[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
                            	 $aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:13:13"} {
                           	set aTmpCnt(cnt16) $aResults(-L1BitRate)
                        }
		} elseif {$statPara == 0} {
                	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:11"} {
                	  set aTmpCnt(cnt2) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt2)]
                	}
                	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:12"} {
                	  set aTmpCnt(cnt6) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt6)]
                	}
                	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:13"} {
                	  set aTmpCnt(cnt9) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt9)]
                	}
                	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:11:11"} {
                	  set aTmpCnt(cnt22) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt22)]
                	}
                	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:12:12"} {
                	  set aTmpCnt(cnt33) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt33)]
                	}
                	if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:13:13"} {
                	  set aTmpCnt(cnt44) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt44)]
                	} 
		} elseif {$statPara == 2} {
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
                           $aResults(-FilteredValue_1) == "800" && $aResults(-FilteredValue_2) == "00:00:00:00:00:05"} {
                           set aTmpCnt(cnt9) [expr $aResults(-FrameCount)+$aTmpCnt(cnt9)]
                        }
		}
	}
	return $flag
}
########################################################################################################
#函数功能：根据分析器的设置统计各条流的收发情况
#输入参数：statPara ==1 分析器中添加vlan统计字段                ==0 分析器中不添加vlan统计字段
#          hAna：端口分析器handle
#输出参数：aRecCnt：统计结果
#返回值：    无
########################################################################################################
proc classificationStatisticsPortRxCnt14 {statPara hAna aRecCnt} { 
	set flag 0
  	upvar $aRecCnt aTmpCnt
  	#同步分析器和发生器统计延时2s  
  	after 2000 
	foreach resultsObj [stc::get $hAna -children-FilteredStreamResults] {
		if {[catch {
#			send_log "\n resultsObj:$resultsObj"
                	after 2000
                	array set aResults [stc::get $resultsObj]
                	gwd::Clear_ResultViewStat $resultsObj
                } err]} {
			set flag 1
                      send_log "\n filter_err:$err"
                      continue
                }
  		#statPara==1 分析器中添加vlan统计字段     statPara==0 分析器中不添加vlan统计字段
  		if {$statPara == 1} {
  		#获取分析器统计的数值
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  	[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
			  	$aResults(-FilteredValue_1) == "50" && $aResults(-FilteredValue_2) == "00:00:00:00:00:01"} {
				set aTmpCnt(cnt1)  $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				  [string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				      $aResults(-FilteredValue_1) == "50" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
				set aTmpCnt(cnt2)  $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			   	[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				      $aResults(-FilteredValue_1) == "50" && $aResults(-FilteredValue_2) == "00:00:00:00:00:03"} {
	 			set aTmpCnt(cnt3) $aResults(-L1BitRate)
      			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			  	[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:04"} {
				set aTmpCnt(cnt4)  $aResults(-L1BitRate)
      			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "5"} {
				set aTmpCnt(cnt5) $aResults(-L1BitRate)
			}
      			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				   [string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				    $aResults(-FilteredValue_1) == "50" && $aResults(-FilteredValue_2) == "00:00:00:00:00:04"} {
	 			set aTmpCnt(cnt6) $aResults(-L1BitRate)
      			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "60" && $aResults(-FilteredValue_2) == "00:00:00:00:00:06"} {
				set aTmpCnt(cnt7) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "80" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
				set aTmpCnt(cnt8) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:02"} {
				set aTmpCnt(cnt9) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
				  [string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
				  $aResults(-FilteredValue_1) == "80" && $aResults(-FilteredValue_2) == "00:00:00:00:00:01"} {
				  set aTmpCnt(cnt10) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			    [string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
			    $aResults(-FilteredValue_1) == "100" && $aResults(-FilteredValue_2) == "00:00:00:00:00:01"} {
			    set aTmpCnt(cnt11) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)] &&\
			    [string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && $aResults(-FilteredValue_3) == "08 00 " && \
			    $aResults(-FilteredValue_1) == "500" && $aResults(-FilteredValue_2) == "00:00:00:00:00:05"} {
			    set aTmpCnt(cnt12) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "custom-etherType (hex)" $aResults(-FilteredName_2)] && \
				[string match -nocase "custom-vlanId (hex)" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_1) == "00:00:00:00:00:02" && \
				$aResults(-FilteredValue_2) == "81 00 " && \
				$aResults(-FilteredValue_3) == "00 50 "} {
				set aTmpCnt(cnt13)  $aResults(-L1BitRate)
			}
    		
  		} elseif {$statPara == 0} {
      		
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:01"} {
	  			set aTmpCnt(cnt1) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt1)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:02"} {
	  			set aTmpCnt(cnt2) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt2)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:03"} {
	  			set aTmpCnt(cnt3) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt3)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:04"} {
	  			set aTmpCnt(cnt4) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt4)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:05"} {
	  			set aTmpCnt(cnt5) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt5)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:06"} {
	  			set aTmpCnt(cnt6) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt6)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:03:01"} {
				  set aTmpCnt(cnt7) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:03:02"} {
				  set aTmpCnt(cnt8) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:03:03"} {
				  set aTmpCnt(cnt9) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:03:04"} {
				  set aTmpCnt(cnt10) $aResults(-L1BitRate)
			}
      		
     		} elseif {$statPara == 2} {
		
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:01"} {
				set aTmpCnt(cnt1) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt1)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == "00:00:00:00:00:02"} {
				set aTmpCnt(cnt2) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt2)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == $::gpnMac1} {
				set aTmpCnt(cnt3) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt3)]
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && $aResults(-FilteredValue_1) == $::gpnMac2} {
				set aTmpCnt(cnt4) [expr $aResults(-L1BitRate) + $aTmpCnt(cnt4)]
			}
		
		} elseif {$statPara == 3} {
			if {[string match -nocase "VLAN TAG (hex)" $aResults(-FilteredName_2)] && $aResults(-FilteredValue_2) == "08 00 "} {
				set aTmpCnt(cnt1) $aResults(-L1BitRate)
			}
			if {[string match -nocase "VLAN TAG (hex)" $aResults(-FilteredName_2)] && $aResults(-FilteredValue_2) == "00 32 "} {
				set aTmpCnt(cnt2) $aResults(-L1BitRate)
			}
			if {[string match -nocase "VLAN TAG (hex)" $aResults(-FilteredName_2)] && $aResults(-FilteredValue_2) == "01 f4 "} {
				set aTmpCnt(cnt3) $aResults(-L1BitRate)
			}
			if {[string match -nocase "VLAN TAG (hex)" $aResults(-FilteredName_2)] && $aResults(-FilteredValue_2) == "00 01 "} {
				set aTmpCnt(cnt4) $aResults(-L1BitRate)
			}
			
			if {[string match -nocase "customer-etherType (hex)" $aResults(-FilteredName_2)] &&\
				 [string match -nocase "customer-vlanId (hex)" $aResults(-FilteredName_3)] &&\
				$aResults(-FilteredValue_2) == "08 00 " &&\
				$aResults(-FilteredValue_3) == "00 32 "} {
				set aTmpCnt(cnt5) $aResults(-L1BitRate)
			}
			if {[string match -nocase "customer-vid0 (hex)" $aResults(-FilteredName_2)] &&\
				[string match -nocase "customer-vid1 (hex)" $aResults(-FilteredName_3)] &&\
				$aResults(-FilteredValue_2) == "00 01 " &&\
				$aResults(-FilteredValue_3) == "00 32 "} {
				set aTmpCnt(cnt6) $aResults(-L1BitRate)
			}
			if {[string match -nocase "customer-etherType (hex)" $aResults(-FilteredName_2)] && \
				 [string match -nocase "customer-vlanId (hex)" $aResults(-FilteredName_3)] && \
				$aResults(-FilteredValue_2) == "91 00 " && \
				$aResults(-FilteredValue_3) == "00 01 "} {
				set aTmpCnt(cnt7) $aResults(-L1BitRate)
			}
			if {[string match -nocase "LSP-TTL (hex)" $aResults(-FilteredName_2)] &&\
				 [string match -nocase "PW-TTL (hex)" $aResults(-FilteredName_3)] &&\
				$aResults(-FilteredValue_2) == "ff 00 " &&\
				$aResults(-FilteredValue_3) == "ff 00 "} {
				set aTmpCnt(cnt8) $aResults(-L1BitRate)
			}
			if {[string match -nocase "LSP-TTL (hex)" $aResults(-FilteredName_2)] &&\
				 [string match -nocase "PW-TTL (hex)" $aResults(-FilteredName_3)] &&\
				$aResults(-FilteredValue_2) == "fe 00 " &&\
				$aResults(-FilteredValue_3) == "fe 00 "} {
				set aTmpCnt(cnt9) $aResults(-L1BitRate)
			}
		} elseif {$statPara == 4} {
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
				[string match -nocase "custom-etherType (hex)" $aResults(-FilteredName_3)] && \
				[string match -nocase "custom-vlanId (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == "00:00:00:00:00:03" && \
				$aResults(-FilteredValue_2) == "91 00 " && \
				$aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_4) == "00 32 "} {
				set aTmpCnt(cnt1) $aResults(-L1BitRate)
			} 
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
				[string match -nocase "custom-etherType (hex)" $aResults(-FilteredName_3)] && \
				[string match -nocase "custom-vlanId (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == "00:00:00:00:00:04" && \
				$aResults(-FilteredValue_2) == "81 00 " && \
				$aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_4) == "00 64 "} {
				set aTmpCnt(cnt2) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && \
				[string match -nocase "custom-InnerVid (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 50 && \
				$aResults(-FilteredValue_2) == "00:00:00:00:00:03" && \
				$aResults(-FilteredValue_3) == "91 00 " && \
				$aResults(-FilteredValue_4) == "00 32 "} {
				set aTmpCnt(cnt3) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && \
				[string match -nocase "custom-InnerVid (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 80 && \
				$aResults(-FilteredValue_2) == "00:00:00:00:00:03" && \
				$aResults(-FilteredValue_3) == "91 00 " && \
				$aResults(-FilteredValue_4) == "00 32 "} {
				set aTmpCnt(cnt4) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && \
				[string match -nocase "custom-InnerVid (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == "00:00:00:00:00:03" && \
				$aResults(-FilteredValue_3) == "91 00 " && \
				$aResults(-FilteredValue_4) == "00 32 "} {
				set aTmpCnt(cnt5) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && \
				[string match -nocase "custom-InnerVid (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 50 && \
				$aResults(-FilteredValue_2) == "00:00:00:00:00:04" && \
				$aResults(-FilteredValue_3) == "81 00 " && \
				$aResults(-FilteredValue_4) == "00 64 "} {
				set aTmpCnt(cnt6) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && \
				[string match -nocase "custom-InnerVid (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 80 && \
				$aResults(-FilteredValue_2) == "00:00:00:00:00:04" && \
				$aResults(-FilteredValue_3) == "81 00 " && \
				$aResults(-FilteredValue_4) == "00 64 "} {
				set aTmpCnt(cnt7) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_2)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_3)] && \
				[string match -nocase "custom-InnerVid (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == "00:00:00:00:00:04" && \
				$aResults(-FilteredValue_3) == "81 00 " && \
				$aResults(-FilteredValue_4) == "00 64 "} {
				set aTmpCnt(cnt8) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
				[string match -nocase "custom-etherType (hex)" $aResults(-FilteredName_3)] && \
				[string match -nocase "custom-vlanId (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == "00:00:00:00:00:02" && \
				$aResults(-FilteredValue_2) == "81 00 " && \
				$aResults(-FilteredValue_3) == "08 00 " && \
				$aResults(-FilteredValue_4) == "00 32 "} {
				set aTmpCnt(cnt9) $aResults(-L1BitRate)
			} 
		} elseif {$statPara == 6} {
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 50 && \
				$aResults(-FilteredValue_2) == 50 && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:02" && \
				$aResults(-FilteredValue_4) == "08 00 "} {
				set aTmpCnt(cnt1) $aResults(-L1BitRate)
			} 
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 50 && \
				$aResults(-FilteredValue_2) == 80 && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:02" && \
				$aResults(-FilteredValue_4) == "08 00 "} {
				set aTmpCnt(cnt2) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 50 && \
				$aResults(-FilteredValue_2) == 100 && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:02" && \
				$aResults(-FilteredValue_4) == "08 00 "} {
				set aTmpCnt(cnt3) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 50 && \
				$aResults(-FilteredValue_2) == 50 && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:03" && \
				$aResults(-FilteredValue_4) == "08 00 "} {
				set aTmpCnt(cnt4) $aResults(-L1BitRate)
			} 
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 50 && \
				$aResults(-FilteredValue_2) == 80 && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:03" && \
				$aResults(-FilteredValue_4) == "08 00 "} {
				set aTmpCnt(cnt5) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 50 && \
				$aResults(-FilteredValue_2) == 100 && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:03" && \
				$aResults(-FilteredValue_4) == "08 00 "} {
				set aTmpCnt(cnt6) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == 50 && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:04" && \
				$aResults(-FilteredValue_4) == "08 00 "} {
				set aTmpCnt(cnt7) $aResults(-L1BitRate)
			} 
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == 80 && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:04" && \
				$aResults(-FilteredValue_4) == "08 00 "} {
				set aTmpCnt(cnt8) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 100 && \
				$aResults(-FilteredValue_2) == 100 && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:04" && \
				$aResults(-FilteredValue_4) == "08 00 "} {
				set aTmpCnt(cnt9) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 500 && \
				$aResults(-FilteredValue_2) == 80 && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:05" && \
				$aResults(-FilteredValue_4) == "08 00 "} {
				set aTmpCnt(cnt10) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 500 && \
				$aResults(-FilteredValue_2) == 80 && \
				$aResults(-FilteredValue_3) == "00:00:00:00:00:07" && \
				$aResults(-FilteredValue_4) == "08 00 "} {
				set aTmpCnt(cnt11) $aResults(-L1BitRate)
			}
			if {[string match -nocase "Vlan 1 - ID (int)" $aResults(-FilteredName_1)] && \
				[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_2)] && \
				[string match -nocase "Source MAC" $aResults(-FilteredName_3)] && \
				[string match -nocase "EtherType (hex)" $aResults(-FilteredName_4)] && \
				$aResults(-FilteredValue_1) == 80 && \
				$aResults(-FilteredValue_2) == 50 && \
				$aResults(-FilteredValue_3) == "00:00:00:00:03:02" && \
				$aResults(-FilteredValue_4) == "08 00 "} {
				set aTmpCnt(cnt12) $aResults(-L1BitRate)
			}
		} elseif {$statPara == 7} {
        		if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
        			[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
        			$aResults(-FilteredValue_2) == "08 00 " && \
        			$aResults(-FilteredValue_1) == "00:00:00:00:00:01"} {
        			set aTmpCnt(cnt1) $aResults(-L1BitRate)
        		}
        		if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
        			[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
        			$aResults(-FilteredValue_2) == "08 00 " && \
        			$aResults(-FilteredValue_1) == "00:00:00:00:00:02"} {
        			set aTmpCnt(cnt2) $aResults(-L1BitRate)
        		}
        		if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
        			[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
        			$aResults(-FilteredValue_2) == "08 00 " && \
        			$aResults(-FilteredValue_1) == "00:00:00:00:00:03"} {
        			set aTmpCnt(cnt3) $aResults(-L1BitRate)
        		}
        		if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
        			[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
        			$aResults(-FilteredValue_2) == "08 00 " && \
        			$aResults(-FilteredValue_1) == "00:00:00:00:00:04"} {
        			set aTmpCnt(cnt4) $aResults(-L1BitRate)
        		}
        		if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
        			[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
        			$aResults(-FilteredValue_2) == "08 00 " && \
        			$aResults(-FilteredValue_1) == "00:00:00:00:00:05"} {
        			set aTmpCnt(cnt5) $aResults(-L1BitRate)
        		}
        		if {[string match -nocase "Source MAC" $aResults(-FilteredName_1)] && \
        			[string match -nocase "EtherType (hex)" $aResults(-FilteredName_2)] && \
        			$aResults(-FilteredValue_2) == "08 00 " && \
        			$aResults(-FilteredValue_1) == "00:00:00:00:00:06"} {
        			set aTmpCnt(cnt6) $aResults(-L1BitRate)
        		}
		}
		
	}
	return $flag 
}
proc Recustomization {flag1 flag2 flag3 flag4 flag5 flag6} {
	if {$flag1 == 1} {
		stc::unsubscribe $::hGPNPort1TxInfo
		stc::unsubscribe $::hGPNPort1RxInfo1
		stc::unsubscribe $::hGPNPort1RxInfo2
	}
	if {$flag2 == 1} {
		stc::unsubscribe $::hGPNPort2TxInfo
		stc::unsubscribe $::hGPNPort2RxInfo1
		stc::unsubscribe $::hGPNPort2RxInfo2	
	}
	if {$flag3 == 1} {
		stc::unsubscribe $::hGPNPort3TxInfo
		stc::unsubscribe $::hGPNPort3RxInfo1
		stc::unsubscribe $::hGPNPort3RxInfo2
	}
	if {$flag4 == 1} {
		stc::unsubscribe $::hGPNPort4TxInfo
		stc::unsubscribe $::hGPNPort4RxInfo1
		stc::unsubscribe $::hGPNPort4RxInfo2	
	}
	if {$flag5 == 1} {
		stc::unsubscribe $::hGPNPort5TxInfo
		stc::unsubscribe $::hGPNPort5RxInfo1
		stc::unsubscribe $::hGPNPort5RxInfo2	
	}
	if {$flag6 == 1} {
		stc::unsubscribe $::hGPNPort6TxInfo
		stc::unsubscribe $::hGPNPort6RxInfo1
		stc::unsubscribe $::hGPNPort6RxInfo2	
	}
	stc::apply
	if {$flag1 == 1} {
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort1 ::txInfoArr ::hGPNPort1TxInfo
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort1 ::rxInfoArr1 ::hGPNPort1RxInfo1
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort1 ::rxInfoArr2 ::hGPNPort1RxInfo2
	}
	if {$flag2 == 1} {
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort2 ::txInfoArr ::hGPNPort2TxInfo
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort2 ::rxInfoArr1 ::hGPNPort2RxInfo1
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort2 ::rxInfoArr2 ::hGPNPort2RxInfo2
	}
	if {$flag3 == 1} {
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort3 ::txInfoArr ::hGPNPort3TxInfo
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort3 ::rxInfoArr1 ::hGPNPort3RxInfo1
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort3 ::rxInfoArr2 ::hGPNPort3RxInfo2
	}
	if {$flag4 == 1} {
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort4 ::txInfoArr ::hGPNPort4TxInfo
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort4 ::rxInfoArr1 ::hGPNPort4RxInfo1
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort4 ::rxInfoArr2 ::hGPNPort4RxInfo2
	}
	if {$flag5 == 1} {
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort5 ::txInfoArr ::hGPNPort5TxInfo
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort5 ::rxInfoArr1 ::hGPNPort5RxInfo1
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort5 ::rxInfoArr2 ::hGPNPort5RxInfo2
	}
	if {$flag6 == 1} {
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort6 ::txInfoArr ::hGPNPort6TxInfo
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort6 ::rxInfoArr1 ::hGPNPort6RxInfo1
		gwd::Sub_TxAndRx_Info $::hPtnProject $::hGPNPort6 ::rxInfoArr2 ::hGPNPort6RxInfo2
	}
	stc::apply
}
########################################################################################################
#函数功能：发送数据流测试
#输入参数: caseId:端口抓包序列号
#输出参数： aGPNPort3Cnt1：端口3带单层vlan获取结果
#         aGPNPort4Cnt1：端口4带单层vlan获取结果
#         aGPNPort3Cnt2：端口3带不带vlan获取结果
#         aGPNPort4Cnt2：端口4带不带vlan获取结果
#返回值： 无
########################################################################################################
proc sendAndStat {aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 caseId} {
        upvar $aGPNPort3Cnt1 aTmpGPNPort3Cnt1
        upvar $aGPNPort3Cnt2 aTmpGPNPort3Cnt2
        upvar $aGPNPort4Cnt1 aTmpGPNPort4Cnt1
        upvar $aGPNPort4Cnt2 aTmpGPNPort4Cnt2
        set hGPNPortGenList "$::hGPNPort3Gen $::hGPNPort4Gen"
        set hGPNPortAnaList "$::hGPNPort3Ana $::hGPNPort4Ana"
        foreach i "aTmpGPNPort3Cnt1 aTmpGPNPort3Cnt2 aTmpGPNPort4Cnt1 aTmpGPNPort4Cnt2" {
		array set $i {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0 cnt11 0 cnt12 0 cnt13 0 cnt14 0 cnt15 0 cnt16 0 cnt17 0 cnt18 0 cnt19 0} 
        }
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg1
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg1
        if {$::cap_enable} {
            gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
            gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
        }
        gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
        after 10000
        if {$::cap_enable} {
            gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$::GPNTestEth3_cap\($::gpnIp1\).pcap"	
            gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$::GPNTestEth4_cap\($::gpnIp3\).pcap"
        }
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt 1 $::hGPNPort3Ana aTmpGPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt 1 $::hGPNPort4Ana aTmpGPNPort4Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
        gwd::Stop_SendFlow $hGPNPortGenList  $hGPNPortAnaList
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg0
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg0
        gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
        after 10000
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt 0 $::hGPNPort3Ana aTmpGPNPort3Cnt2]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt 0 $::hGPNPort4Ana aTmpGPNPort4Cnt2]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
        gwd::Stop_SendFlow $hGPNPortGenList  $hGPNPortAnaList
}
########################################################################################################
#函数功能：发送数据流测试
#输入参数: caseId:端口抓包序列号
#输出参数： aGPNPort4Cnt1：端口4带单层vlan获取结果
#         aGPNPort4Cnt2：端口4带不带vlan获取结果
#         aGPNPort4Cnt4：端口4带双层vlan获取结果
#返回值： 无
########################################################################################################
proc sendAndStat1 {aGPNPort4Cnt4 aGPNPort4Cnt1 aGPNPort4Cnt2 caseId} {
        upvar $aGPNPort4Cnt4 aTmpGPNPort4Cnt4
        upvar $aGPNPort4Cnt1 aTmpGPNPort4Cnt1
        upvar $aGPNPort4Cnt2 aTmpGPNPort4Cnt2	
        foreach i "aTmpGPNPort4Cnt4 aTmpGPNPort4Cnt1 aTmpGPNPort4Cnt2" {
		array set $i {cnt2 0 cnt10 0 cnt12 0 cnt13 0 cnt14 0 cnt15 0 cnt16 0} 
        }
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg4
        if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
        }
        gwd::Start_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort4Ana"
        after 10000
        if {$::cap_enable} {
		gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$::GPNTestEth4_cap\($::gpnIp3\).pcap"
        }
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt 1 $::hGPNPort4Ana aTmpGPNPort4Cnt4]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 0 1 0 0
		after 5000
	}
        gwd::Stop_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort4Ana"
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg1
        gwd::Start_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort4Ana"
        after 10000
	while {[classificationStatisticsPortRxCnt 1 $::hGPNPort4Ana aTmpGPNPort4Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 0 1 0 0
		after 5000
	}
        gwd::Stop_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort4Ana"
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg0
        gwd::Start_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort4Ana"
        after 10000
	while {[classificationStatisticsPortRxCnt 0 $::hGPNPort4Ana aTmpGPNPort4Cnt2]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 0 1 0 0
		after 5000
	} 
        gwd::Stop_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort4Ana"
}
########################################################################################################
#函数功能：发送数据流测试
#输入参数: caseId:端口抓包序列号
#输出参数： aGPNPort4Cnt1：端口4带单层vlan获取结果
#         aGPNPort4Cnt2：端口4带不带vlan获取结果
#         aGPNPort4Cnt4：端口4带双层vlan获取结果
#返回值： 无
########################################################################################################
proc sendAndStat14 {anaFliFrameCfg hGPNPortGen aGPNPort1Cnt1 aGPNPort1Cnt0 aGPNPort2Cnt1 aGPNPort2Cnt0 aGPNPort3Cnt1 aGPNPort3Cnt0 aGPNPort4Cnt1 aGPNPort4Cnt0 aGPNPort5Cnt1 aGPNPort5Cnt0 caseId} {
	upvar $aGPNPort1Cnt1 aTmpGPNPort1Cnt1
	upvar $aGPNPort1Cnt0 aTmpGPNPort1Cnt0
	upvar $aGPNPort2Cnt1 aTmpGPNPort2Cnt1
	upvar $aGPNPort2Cnt0 aTmpGPNPort2Cnt0
	upvar $aGPNPort3Cnt1 aTmpGPNPort3Cnt1
	upvar $aGPNPort3Cnt0 aTmpGPNPort3Cnt0
	upvar $aGPNPort4Cnt1 aTmpGPNPort4Cnt1
	upvar $aGPNPort4Cnt0 aTmpGPNPort4Cnt0
	upvar $aGPNPort5Cnt1 aTmpGPNPort5Cnt1
	upvar $aGPNPort5Cnt0 aTmpGPNPort5Cnt0
	set id 1
	foreach i "aTmpGPNPort1Cnt0 aTmpGPNPort1Cnt1 aTmpGPNPort2Cnt0 aTmpGPNPort2Cnt1 aTmpGPNPort3Cnt0 aTmpGPNPort3Cnt1 aTmpGPNPort4Cnt0 aTmpGPNPort4Cnt1 aTmpGPNPort5Cnt0 aTmpGPNPort5Cnt1" {
	  	array set $i {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0} 
	}
	foreach hCfgFil $::hGPNPortAnaFrameCfgFilList {
		gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $anaFliFrameCfg
	}
#	if {$::cap_enable} {
#		foreach hGPNPortCap $::hGPNPortCapList hGPNPortCapAnalyzer $::hGPNPortCapAnalyzerList {
#			gwd::Start_CapAllData ::capArr $hGPNPortCap $hGPNPortCapAnalyzer
#		}
#	}
	gwd::Start_SendFlow "$hGPNPortGen"  $::hGPNPortAnaList
	after $::sendTime
#	if {$::cap_enable} {
#		foreach hGPNPortCap $::hGPNPortCapList {
#			gwd::Stop_CapData $hGPNPortCap 1 "$caseId\-GPNPtn014-GPNport$id.pcap"
#			after 5000
#			incr id
#		}
#	} 
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 1 $::hGPNPort1Ana aTmpGPNPort1Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 1 $::hGPNPort2Ana aTmpGPNPort2Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 1 $::hGPNPort3Ana aTmpGPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 1 $::hGPNPort4Ana aTmpGPNPort4Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 1 $::hGPNPort5Ana aTmpGPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	gwd::Stop_SendFlow "$hGPNPortGen" $::hGPNPortAnaList
	foreach hCfgFil $::hGPNPortAnaFrameCfgFilList {
		gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $::anaFliFrameCfg0
	}
	gwd::Start_SendFlow "$hGPNPortGen"  $::hGPNPortAnaList
	after $::sendTime
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 0 $::hGPNPort1Ana aTmpGPNPort1Cnt0]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 0 $::hGPNPort2Ana aTmpGPNPort2Cnt0]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 0 $::hGPNPort3Ana aTmpGPNPort3Cnt0]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 0 $::hGPNPort4Ana aTmpGPNPort4Cnt0]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 0 $::hGPNPort5Ana aTmpGPNPort5Cnt0]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	gwd::Stop_SendFlow "$hGPNPortGen"  $::hGPNPortAnaList
}
########################################################################################################
#函数功能：发送数据流测试
#输入参数: caseId:端口抓包序列号
#输出参数：aGPNPort3Cnt1：端口3带单层vlan获取结果
#         aGPNPort4Cnt1：端口4带单层vlan获取结果
#         aGPNPort3Cnt2：端口3带不带vlan获取结果
#         aGPNPort4Cnt2：端口4带不带vlan获取结果
#返回值： 无
########################################################################################################
proc sendAndStat21 {aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 caseId} {
  upvar $aGPNPort3Cnt1 aTmpGPNPort3Cnt1
  upvar $aGPNPort3Cnt2 aTmpGPNPort3Cnt2
  upvar $aGPNPort4Cnt1 aTmpGPNPort4Cnt1
  upvar $aGPNPort4Cnt2 aTmpGPNPort4Cnt2
  set hGPNPortGenList "$::hGPNPort3Gen $::hGPNPort4Gen"
  set hGPNPortAnaList "$::hGPNPort3Ana $::hGPNPort4Ana"
  foreach i "aTmpGPNPort3Cnt1 aTmpGPNPort3Cnt2 aTmpGPNPort4Cnt1 aTmpGPNPort4Cnt2" {
    array set $i {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0 \
	    cnt11 0 cnt12 0 cnt13 0 cnt14 0 cnt15 0 cnt16 0 cnt17 0 cnt18 0 cnt19 0 cnt20 0 cnt21 0} 
  }
  if {$::cap_enable} {
      gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
      gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
  }
#  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg1
#  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg1
  gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
  after 30000
	regsub {/} $::GPNTestEth3 {_} GPNTestEth3_cap
	regsub {/} $::GPNTestEth4 {_} GPNTestEth4_cap
  if {$::cap_enable} {
      gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$GPNTestEth3_cap\($::gpnIp1\).pcap"
      gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$GPNTestEth4_cap\($::gpnIp3\).pcap"
  }
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 1 $::hGPNPort3Ana aTmpGPNPort3Cnt1]} {
  	if {$filterCnt == $::filterGlobalCnt} {
  		break
  	}
  	incr filterCnt
  	Recustomization 0 0 1 1 0 0
  	after 5000
  }
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 1 $::hGPNPort4Ana aTmpGPNPort4Cnt1]} {
  	if {$filterCnt == $::filterGlobalCnt} {
  		break
  	}
  	incr filterCnt
  	Recustomization 0 0 1 1 0 0
  	after 5000
  }
  gwd::Stop_SendFlow $hGPNPortGenList  $hGPNPortAnaList
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg0
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg0
  gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
  after 30000
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt1 0 $::hGPNPort3Ana aTmpGPNPort3Cnt2]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[ classificationStatisticsPortRxCnt1 0 $::hGPNPort4Ana aTmpGPNPort4Cnt2]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
  gwd::Stop_SendFlow $hGPNPortGenList  $hGPNPortAnaList
}
########################################################################################################
#函数功能：发送数据流测试
#输入参数: caseId:端口抓包序列号
#输出参数：aGPNPort3Cnt41：端口3带单层vlan获取结果
#         aGPNPort4Cnt41：端口4带单层vlan获取结果
#         aGPNPort3Cnt4：端口3带双层vlan获取结果
#         aGPNPort4Cnt4：端口4带双层vlan获取结果
#         aGPNPort3Cnt40：端口3带不带vlan获取结果
#         aGPNPort4Cnt40：端口4带不带vlan获取结果
#返回值： 无
########################################################################################################
proc sendAndStat2 {aGPNPort3Cnt4 aGPNPort4Cnt4 aGPNPort3Cnt41 aGPNPort4Cnt41 aGPNPort3Cnt40 aGPNPort4Cnt40 caseId} {
  upvar $aGPNPort3Cnt4  aTmpGPNPort3Cnt4
  upvar $aGPNPort4Cnt4  aTmpGPNPort4Cnt4
  upvar $aGPNPort3Cnt41 aTmpGPNPort3Cnt41
  upvar $aGPNPort4Cnt41 aTmpGPNPort4Cnt41
  upvar $aGPNPort3Cnt40 aTmpGPNPort3Cnt40
  upvar $aGPNPort4Cnt40 aTmpGPNPort4Cnt40
  set hGPNPortGenList "$::hGPNPort3Gen $::hGPNPort4Gen"
  set hGPNPortAnaList "$::hGPNPort3Ana $::hGPNPort4Ana"
  foreach i "aTmpGPNPort3Cnt4 aTmpGPNPort4Cnt4 aTmpGPNPort3Cnt41 aTmpGPNPort4Cnt41 aTmpGPNPort3Cnt40 aTmpGPNPort4Cnt40" {
    array set $i {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0 cnt12 0} 
  }
  if {$::cap_enable} {
      gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
      gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
  }
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg4
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg4
  gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
  after 10000
	regsub {/} $::GPNTestEth3 {_} GPNTestEth3_cap
	regsub {/} $::GPNTestEth4 {_} GPNTestEth4_cap
  if {$::cap_enable} {
	gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$GPNTestEth3_cap\($::gpnIp1\).pcap"
	gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$GPNTestEth4_cap\($::gpnIp3\).pcap"
  } 
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 1 $::hGPNPort3Ana aTmpGPNPort3Cnt4]} {
  	if {$filterCnt == $::filterGlobalCnt} {
  		break
  	}
  	incr filterCnt
  	Recustomization 0 0 1 1 0 0
  	after 5000
  }
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 1 $::hGPNPort4Ana aTmpGPNPort4Cnt4]} {
  	if {$filterCnt == $::filterGlobalCnt} {
  		break
  	}
  	incr filterCnt
  	Recustomization 0 0 1 1 0 0
  	after 5000
  }
  gwd::Stop_SendFlow $hGPNPortGenList  $hGPNPortAnaList
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg1
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg1
  gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
  after 10000
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 1 $::hGPNPort3Ana aTmpGPNPort3Cnt41]} {
  	if {$filterCnt == $::filterGlobalCnt} {
  		break
  	}
  	incr filterCnt
  	Recustomization 0 0 1 1 0 0
  	after 5000
  }
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 1 $::hGPNPort4Ana aTmpGPNPort4Cnt41]} {
  	if {$filterCnt == $::filterGlobalCnt} {
  		break
  	}
  	incr filterCnt
  	Recustomization 0 0 1 1 0 0
  	after 5000
  }

  gwd::Stop_SendFlow $hGPNPortGenList  $hGPNPortAnaList	
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg0
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg0
  gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
  after 10000
  set filterCnt 0
  while {[ classificationStatisticsPortRxCnt1 0 $::hGPNPort3Ana aTmpGPNPort3Cnt40]} {
  	if {$filterCnt == $::filterGlobalCnt} {
  		break
  	}
  	incr filterCnt
  	Recustomization 0 0 1 1 0 0
  	after 5000
  }
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 0 $::hGPNPort4Ana aTmpGPNPort4Cnt40]} {
  	if {$filterCnt == $::filterGlobalCnt} {
  		break
  	}
  	incr filterCnt
  	Recustomization 0 0 1 1 0 0
  	after 5000
  }
  gwd::Stop_SendFlow $hGPNPortGenList  $hGPNPortAnaList
}
########################################################################################################
#函数功能：发送数据流测试
#输入参数: caseId:端口抓包序列号
#输出参数：aGPNPort2Cnt1：端口2带单层vlan获取结果
#         aGPNPort4Cnt1：端口4带单层vlan获取结果
#         aGPNPort2Cnt2：端口2带不带vlan获取结果
#         aGPNPort4Cnt2：端口4带不带vlan获取结果
#返回值： 无
########################################################################################################
proc sendAndStat3 {aGPNPort2Cnt1 aGPNPort2Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 caseId} {
  upvar $aGPNPort2Cnt1 aTmpGPNPort2Cnt1
  upvar $aGPNPort2Cnt2 aTmpGPNPort2Cnt2
  upvar $aGPNPort4Cnt1 aTmpGPNPort4Cnt1
  upvar $aGPNPort4Cnt2 aTmpGPNPort4Cnt2
  set hGPNPortGenList "$::hGPNPort2Gen $::hGPNPort4Gen"
  set hGPNPortAnaList "$::hGPNPort2Ana $::hGPNPort4Ana"
  foreach i "aTmpGPNPort4Cnt1 aTmpGPNPort4Cnt2 aTmpGPNPort2Cnt1 aTmpGPNPort2Cnt2" {
    array set $i {cnt11 0 cnt12 0 cnt13 0 cnt14 0 cnt7 0 cnt8 0 cnt9 0 cnt12 0} 
  }
  if {$::cap_enable} {
      gwd::Start_CapAllData ::capArr $::hGPNPort2Cap $::hGPNPort2CapAnalyzer 
      gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
  }
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort2AnaFrameCfgFil $::anaFliFrameCfg1
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg1
  gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
  after 30000
  if {$::cap_enable} {
      gwd::Stop_CapData $::hGPNPort2Cap 1 "$caseId\-GPNPtn002_1-GPNport2.pcap"
      gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId\-GPNPtn002_1-GPNport4.pcap"
  } 
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 1 $::hGPNPort2Ana aTmpGPNPort2Cnt1]} {
	  if {$filterCnt == $::filterGlobalCnt} {
		  break
	  }
	  incr filterCnt
	  Recustomization 0 1 0 1 0 0
	  after 5000
  }
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 1 $::hGPNPort4Ana aTmpGPNPort4Cnt1]} {
	  if {$filterCnt == $::filterGlobalCnt} {
		  break
	  }
	  incr filterCnt
	  Recustomization 0 1 0 1 0 0
	  after 5000
  }
  gwd::Stop_SendFlow $hGPNPortGenList  $hGPNPortAnaList
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort2AnaFrameCfgFil $::anaFliFrameCfg0
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg0
  gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
  after 30000
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 0 $::hGPNPort2Ana aTmpGPNPort2Cnt2]} {
	  if {$filterCnt == $::filterGlobalCnt} {
		  break
	  }
	  incr filterCnt
	  Recustomization 0 1 0 1 0 0
	  after 5000
  }
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 0 $::hGPNPort4Ana aTmpGPNPort4Cnt2]} {
	  if {$filterCnt == $::filterGlobalCnt} {
		  break
	  }
	  incr filterCnt
	  Recustomization 0 1 0 1 0 0
	  after 5000
  }
  
}
########################################################################################################
#函数功能：发送数据流测试
#输入参数: caseId:端口抓包序列号
#输出参数：aGPNPort3Cnt1：端口3带单层vlan获取结果
#         aGPNPort4Cnt1：端口4带单层vlan获取结果
#         aGPNPort3Cnt2：端口3带不带vlan获取结果
#         aGPNPort4Cnt2：端口4带不带vlan获取结果
#返回值： 无
########################################################################################################
proc sendAndStat4 {aGPNPort3Cnt1 aGPNPort3Cnt2 aGPNPort4Cnt1 aGPNPort4Cnt2 caseId} {
  upvar $aGPNPort3Cnt1 aTmpGPNPort3Cnt1
  upvar $aGPNPort3Cnt2 aTmpGPNPort3Cnt2
  upvar $aGPNPort4Cnt1 aTmpGPNPort4Cnt1
  upvar $aGPNPort4Cnt2 aTmpGPNPort4Cnt2
  set hGPNPortGenList "$::hGPNPort3Gen $::hGPNPort4Gen"
  set hGPNPortAnaList "$::hGPNPort3Ana $::hGPNPort4Ana"
  foreach i "aTmpGPNPort4Cnt1 aTmpGPNPort4Cnt2 aTmpGPNPort3Cnt1 aTmpGPNPort3Cnt2" {
    array set $i {cnt1 0 cnt2 0 cnt13 0 cnt14 0} 
  }
  if {$::cap_enable} {
      gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
      gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
  }
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg1
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg1
  gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
  after 30000
  if {$::cap_enable} {
      gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId\-GPNPtn002_1-GPNport3.pcap"
      gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId\-GPNPtn002_1-GPNport4.pcap"
  } 
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 1 $::hGPNPort3Ana aTmpGPNPort3Cnt1]} {
	  if {$filterCnt == $::filterGlobalCnt} {
		  break
	  }
	  incr filterCnt
	  Recustomization 0 0 1 1 0 0
	  after 5000
  }
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 1 $::hGPNPort4Ana aTmpGPNPort4Cnt1]} {
	  if {$filterCnt == $::filterGlobalCnt} {
		  break
	  }
	  incr filterCnt
	  Recustomization 0 0 1 1 0 0
	  after 5000
  }
  gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg0
  gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg0
  gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
  after 30000
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 0 $::hGPNPort3Ana aTmpGPNPort3Cnt2]} {
	  if {$filterCnt == $::filterGlobalCnt} {
		  break
	  }
	  incr filterCnt
	  Recustomization 0 0 1 1 0 0
	  after 5000
  }
  set filterCnt 0
  while {[classificationStatisticsPortRxCnt1 0 $::hGPNPort4Ana aTmpGPNPort4Cnt2]} {
	  if {$filterCnt == $::filterGlobalCnt} {
		  break
	  }
	  incr filterCnt
	  Recustomization 0 0 1 1 0 0
	  after 5000
  }

}
########################################################################################################
#函数功能：发送数据流测试
#输入参数: caseId:端口抓包序列号
#输出参数：aGPNPort1Cnt1：端口1带单层vlan获取结果
#         aGPNPort2Cnt1：端口2带单层vlan获取结果
#         aGPNPort3Cnt1：端口3带双层vlan获取结果
#         aGPNPort4Cnt1：端口4带双层vlan获取结果
#         aGPNPort3Cnt2：端口3带不带vlan获取结果
#         aGPNPort4Cnt2：端口4带不带vlan获取结果
#返回值： 无
########################################################################################################
proc sendAndStat41 {caseId aGPNPort3Cnt4 aGPNPort3Cnt2 aGPNPort4Cnt4 aGPNPort4Cnt2 aGPNPort2Cnt1 aGPNPort4Cnt1} {
        upvar $aGPNPort3Cnt4 aTmpGPNPort3Cnt4
        upvar $aGPNPort3Cnt2 aTmpGPNPort3Cnt2
        upvar $aGPNPort4Cnt4 aTmpGPNPort4Cnt4
        upvar $aGPNPort4Cnt2 aTmpGPNPort4Cnt2
        upvar $aGPNPort2Cnt1 aTmpGPNPort2Cnt1
        upvar $aGPNPort4Cnt1 aTmpGPNPort4Cnt1
        set hGPNPortGenList "$::hGPNPort2Gen $::hGPNPort3Gen $::hGPNPort4Gen"
        set hGPNPortAnaList "$::hGPNPort2Ana $::hGPNPort3Ana $::hGPNPort4Ana"
        foreach i "aTmpGPNPort3Cnt4 aTmpGPNPort3Cnt2 aTmpGPNPort4Cnt4 aTmpGPNPort4Cnt2 aTmpGPNPort2Cnt1 aTmpGPNPort4Cnt1" {
        	array set $i {cnt5 0 cnt8 0 cnt9 0 cnt10 0 cnt11 0} 
        }
        if {$::cap_enable} {
                gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
                gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
                gwd::Start_CapAllData ::capArr $::hGPNPort2Cap $::hGPNPort2CapAnalyzer 
        }
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg4
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg4
        gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
        after $::sendTime
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort3Ana aTmpGPNPort3Cnt4]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort4Ana aTmpGPNPort4Cnt4]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
        
        
        if {$::cap_enable} {
        	gwd::Stop_CapData $::hGPNPort2Cap 1 "$caseId-p$::GPNTestEth2_cap\($::gpnIp1).pcap"
        	gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$::GPNTestEth3_cap\($::gpnIp1).pcap"
        	gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$::GPNTestEth4_cap\($::gpnIp3).pcap"
        }
        gwd::Stop_SendFlow $hGPNPortGenList  $hGPNPortAnaList
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg0
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg0
        gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
        after $::sendTime
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 0 $::hGPNPort3Ana aTmpGPNPort3Cnt2]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 0 $::hGPNPort4Ana aTmpGPNPort4Cnt2]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
        
        
        gwd::Stop_SendFlow $hGPNPortGenList  $hGPNPortAnaList
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort2AnaFrameCfgFil $::anaFliFrameCfg1
        gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg1
        gwd::Start_SendFlow $hGPNPortGenList  $hGPNPortAnaList
        after $::sendTime
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort2Ana aTmpGPNPort2Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort4Ana aTmpGPNPort4Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 1 0 1 0 0
		after 5000
	}

        gwd::Stop_SendFlow $hGPNPortGenList  $hGPNPortAnaList
}
########################################################################################################
#函数功能：发送数据流测试
#输入参数: caseId:端口抓包序列号
#输出参数：aGPNPort2Cnt2：端口2带两层mpls标签获取结果
#         aGPNPort2Cnt1：端口2mpls的vid和源mac获取结果
#返回值： 无
########################################################################################################
proc sendAndStat51 {aGPNPort2Cnt2 aGPNPort2Cnt1 fileName} {
upvar $aGPNPort2Cnt1 aTmpGPNPort2Cnt1
upvar $aGPNPort2Cnt2 aTmpGPNPort2Cnt2
foreach i "aTmpGPNPort2Cnt1 aTmpGPNPort2Cnt2" {
  array set $i {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0} 
}
if {$::cap_enable} {
    gwd::Start_CapAllData ::capArr $::hGPNPort2Cap $::hGPNPort2CapAnalyzer 
}
gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort2AnaFrameCfgFil $::anaFliFrameCfg2
gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort2Ana"
after $::sendTime
if {$::cap_enable} {
    gwd::Stop_CapData $::hGPNPort2Cap 1 $fileName
}
set filterCnt 0
while {[classificationStatisticsPortRxCnt5 2 $::hGPNPort2Ana aTmpGPNPort2Cnt2]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 0 1 0 0 0 0
	after 5000
}
gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort2Ana"
gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort2AnaFrameCfgFil $::anaFliFrameCfg5
gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort2Ana"
after $::sendTime
set filterCnt 0
while {[classificationStatisticsPortRxCnt5 1 $::hGPNPort2Ana aTmpGPNPort2Cnt1]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 0 1 0 0 0 0
	after 5000
}
gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort2Ana"
}
########################################################################################################
#函数功能：发送数据流，得到测试结果
#输入参数: capFlag：=1抓包   =0不抓包
#	lGenPort：发送数据流的端口Gen handle列表
#	  lAnaPort：接收数据流的端口ana handle列表
#         lPort：抓包端口列表
#         lCapPara：抓包端口相关参数列表cap capAna ip（端口所在设备的ip）
#	  matchPara：classificationStatisticsPortRxCnt4 函数的输入参数
#	  anaFliFrameCfg：分析器配置参数
#	  capFlag：是否抓包，在全局变量cap_enable=1的的情况下capFlag参数生效  =1抓包    =0不抓包
#输出参数： aGPNCnt1 aGPNCnt2 aGPNCnt3 aGPNCnt4：与lAnaPort端口相对应	  
#返回值： 无
########################################################################################################
proc SendAndStat_ptn006 {capFlag lGenPort lAnaPort lPort lCapPara lAnaFrameCfgFil aGPNCnt1 aGPNCnt2 aGPNCnt3 aGPNCnt4 matchPara anaFliFrameCfg caseId} {
	upvar $aGPNCnt1 aTmpCnt1
	upvar $aGPNCnt2 aTmpCnt2
	upvar $aGPNCnt3 aTmpCnt3
	upvar $aGPNCnt4 aTmpCnt4
	foreach aTmpCnt "aTmpCnt1 aTmpCnt2 aTmpCnt3 aTmpCnt4" {
		array set $aTmpCnt {cnt1 0 cnt01 0 cnt2 0 cnt02 0 cnt3 0 cnt03 0 cnt4 0 cnt04 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0 \
			cnt11 0 cnt12 0 cnt13 0 cnt14 0 cnt15 0 cnt16 0 cnt17 0 cnt18 0 cnt19 0 cnt20 0 cnt21 0\
			cnt22 0 cnt23 0 cnt24 0 cnt25 0 cnt26 0 cnt27 0 cnt28 0 cnt30 0 cnt31 0 cnt32 0 cnt33 0 cnt34 0 cnt35 0 cnt38 0 \
			cnt40 0 cnt41 0 cnt42 0 cnt43 0 cnt44 0 cnt45 0 cnt48 0 cnt50 0 cnt51 0 cnt52 0 cnt53 0 cnt54 0 cnt55 0 cnt56 0 cnt57 0 \
			cnt58 0 cnt59 0 cnt81 0 cnt60 0 cnt61 0 cnt62 0 cnt63 0 cnt64 0 cnt65 0 cnt66 0 cnt67 0 cnt68 0 cnt69 0 cnt70 0 cnt71 0\
			cnt101 0 cnt102 0 cnt104 0 cnt111 0 cnt112 0 cnt114 0
		} 
	}
	foreach anaFrameCfgFil $lAnaFrameCfgFil {
		gwd::Cfg_AnalyzerFrameCfgFilter $anaFrameCfgFil $anaFliFrameCfg
	}
	
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $lGenPort  $lAnaPort
	after 5000
	gwd::Stop_SendFlow $lGenPort  $lAnaPort
	after 2000
	Recustomization 1 1 1 1 1 0
	if {($::cap_enable == 1) && ($capFlag == 1)} {
		foreach {cap capAna ip} $lCapPara {
			gwd::Start_CapAllData ::capArr $cap $capAna
		}
	}
	
	gwd::Start_SendFlow $lGenPort  $lAnaPort
	after 10000
	if {($::cap_enable == 1) && ($capFlag == 1)} {
		foreach {cap capAna ip} $lCapPara port $lPort {
			regsub {/} $port {_} port_cap
			gwd::Stop_CapData $cap 1 "$caseId-p$port_cap\($ip\).pcap"
		}
	}
	set i 1
	foreach hAnaPort $lAnaPort {
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt4 $matchPara $hAnaPort aTmpCnt$i]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 1 1 1 1 1 0
			after 5000
		}
#		parray aTmpCnt$i
		incr i
	}
	gwd::Stop_SendFlow $lGenPort $lAnaPort
}


########################################################################################################
#函数功能：发送数据流，得到测试结果
#输入参数: capFlag：=1抓包   =0不抓包
#	lGenPort：发送数据流的端口Gen handle列表
#	  lAnaPort：接收数据流的端口ana handle列表
#         lPort：抓包端口列表
#         lCapPara：抓包端口相关参数列表cap capAna ip（端口所在设备的ip）
#	  matchPara：classificationStatisticsPortRxCnt4 函数的输入参数
#	  anaFliFrameCfg：分析器配置参数
#	  capFlag：是否抓包，在全局变量cap_enable=1的的情况下capFlag参数生效  =1抓包    =0不抓包
#输出参数： aGPNCnt1 aGPNCnt2 aGPNCnt3 aGPNCnt4：与lAnaPort端口相对应	  
#返回值： 无
########################################################################################################
proc SendAndStat_ptn014 {capFlag lGenPort lAnaPort lPort lCapPara lAnaFrameCfgFil aGPNCnt1 aGPNCnt2 aGPNCnt3 aGPNCnt4 aGPNCnt5 matchPara anaFliFrameCfg caseId} {
	upvar $aGPNCnt1 aTmpCnt1
	upvar $aGPNCnt2 aTmpCnt2
	upvar $aGPNCnt3 aTmpCnt3
	upvar $aGPNCnt4 aTmpCnt4
	upvar $aGPNCnt5 aTmpCnt5
	foreach aTmpCnt "aTmpCnt1 aTmpCnt2 aTmpCnt3 aTmpCnt4 aTmpCnt5" {
		array set $aTmpCnt {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0 cnt11 0 cnt12 0 cnt13 0
		} 
	}
	foreach anaFrameCfgFil $lAnaFrameCfgFil {
		gwd::Cfg_AnalyzerFrameCfgFilter $anaFrameCfgFil $anaFliFrameCfg
	}
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $lGenPort $lAnaPort
	after 5000
	gwd::Stop_SendFlow $lGenPort $lAnaPort
	after 2000
	Recustomization 1 1 1 1 1 0
	
	if {($::cap_enable == 1) && ($capFlag == 1)} {
		foreach {cap capAna ip} $lCapPara {
			gwd::Start_CapAllData ::capArr $cap $capAna
		}
	}
	gwd::Start_SendFlow $lGenPort  $lAnaPort
	after 10000
	if {($::cap_enable == 1) && ($capFlag == 1)} {
		foreach {cap capAna ip} $lCapPara port $lPort {
			regsub {/} $port {_} port_cap
			gwd::Stop_CapData $cap 1 "$caseId-p$port_cap\($ip\).pcap"
		}
	}
	
	set i 1
	foreach hAnaPort $lAnaPort {
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt14 $matchPara $hAnaPort aTmpCnt$i]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 1 1 1 1 1 0
			after 5000
		}
		parray aTmpCnt$i
		incr i
	}
	gwd::Stop_SendFlow $lGenPort $lAnaPort
}
########################################################################################################
#函数功能：发送数据流测试
#输入参数:anaFliFrameCfg1:分析器类型1
#	 anaFliFrameCfg2:分析器类型2
#	          caseId:端口抓包序列号
#输出参数：aGPNPort1Cnt1：端口1分析器类型1获取结果
#         aGPNPort2Cnt1：端口2分析器类型1获取结果
#         aGPNPort3Cnt1：端口3分析器类型1获取结果
#         aGPNPort4Cnt1：端口4分析器类型1获取结果
#         aGPNPort1Cnt0：端口1分析器类型2获取结果
#         aGPNPort2Cnt0：端口2分析器类型2获取结果
#         aGPNPort3Cnt0：端口3分析器类型2获取结果
#         aGPNPort4Cnt0：端口4分析器类型2获取结果
#返回值： 无
########################################################################################################
proc SendAndStat61 {hGPNPortAna anaFliFrameCfg1 anaFliFrameCfg2 aGPNPort1Cnt1 aGPNPort2Cnt1 aGPNPort3Cnt1 aGPNPort4Cnt1 aGPNPort1Cnt0 aGPNPort2Cnt0 aGPNPort3Cnt0 aGPNPort4Cnt0 caseId} {
        upvar $aGPNPort1Cnt1 aTmpGPNPort1Cnt1
        upvar $aGPNPort2Cnt1 aTmpGPNPort2Cnt1
        upvar $aGPNPort3Cnt1 aTmpGPNPort3Cnt1
        upvar $aGPNPort4Cnt1 aTmpGPNPort4Cnt1
        upvar $aGPNPort1Cnt0 aTmpGPNPort1Cnt0
        upvar $aGPNPort2Cnt0 aTmpGPNPort2Cnt0
        upvar $aGPNPort3Cnt0 aTmpGPNPort3Cnt0
        upvar $aGPNPort4Cnt0 aTmpGPNPort4Cnt0
        foreach i "aTmpGPNPort1Cnt1 aTmpGPNPort1Cnt0 aTmpGPNPort2Cnt1 aTmpGPNPort2Cnt0 aTmpGPNPort3Cnt1 aTmpGPNPort3Cnt0 aTmpGPNPort4Cnt1 aTmpGPNPort4Cnt0" {
        	array set $i {cnt01 0 cnt02 0 cnt03 0 cnt04 0 cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0\
        	        cnt11 0 cnt12 0 cnt13 0 cnt15 0 cnt16 0 cnt17 0 cnt19 0 cnt20 0 cnt23 0 cnt22 0 cnt33 0 cnt44 0\
        	        cnt61 0 cnt62 0 cnt63 0 cnt64 0 cnt101 0 cnt102 0 cnt103 0 cnt104 0 cnt27 0} 
        }
	###配置过滤器
	foreach hCfgFil $::hGPNPortAnaFrameCfgFilList {
	gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $anaFliFrameCfg1
	}
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	after 5000
	gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	after 2000
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	after 10000
        ###开始抓包
        if {$::cap_enable} {
                foreach hCfgCap $::hGPNPortCapList hCapAna $::hGPNPortCapAnalyzerList {
                	gwd::Start_CapAllData ::capArr $hCfgCap $hCapAna
                }
        }
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $hGPNPortAna aTmpGPNPort1Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort2Ana aTmpGPNPort2Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort3Ana aTmpGPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort4Ana aTmpGPNPort4Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	        
	###停止抓包
	if {$::cap_enable} {
        	gwd::Stop_CapData $::hGPNPort1Cap 1 "$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap"
        	gwd::Stop_CapData $::hGPNPort2Cap 1 "$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap"
        	gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap"
        	gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap"
	} 
        gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
        ###修改过滤器
        foreach hCfgFil $::hGPNPortAnaFrameCfgFilList {
        	gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $anaFliFrameCfg2
        }
	stc::apply
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	after 5000
	gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	after 2000
	Recustomization 1 1 1 1 1 0
        gwd::Start_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
        after 10000
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 0 $hGPNPortAna aTmpGPNPort1Cnt0]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 0 $::hGPNPort2Ana aTmpGPNPort2Cnt0]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 0 $::hGPNPort3Ana aTmpGPNPort3Cnt0]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 0 $::hGPNPort4Ana aTmpGPNPort4Cnt0]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
        gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
}
########################################################################################################
#函数功能：发送数据流测试
#输入参数:
#	          caseId:端口抓包序列号
#输出参数：aGPNPort1Cnt1：端口1分析器类型1获取结果
#         aGPNPort2Cnt1：端口2分析器类型1获取结果
#         aGPNPort3Cnt1：端口3分析器类型1获取结果
#         aGPNPort4Cnt1：端口4分析器类型1获取结果
#返回值： 无
########################################################################################################
proc SendAndStat9 {anaFliFrameCfg id aGPNPort1Cnt1 aGPNPort2Cnt1 aGPNPort3Cnt1 aGPNPort4Cnt1 caseId} {
upvar $aGPNPort1Cnt1 aTmpGPNPort1Cnt1
upvar $aGPNPort2Cnt1 aTmpGPNPort2Cnt1
upvar $aGPNPort3Cnt1 aTmpGPNPort3Cnt1
upvar $aGPNPort4Cnt1 aTmpGPNPort4Cnt1
foreach i "aTmpGPNPort1Cnt1 aTmpGPNPort2Cnt1 aTmpGPNPort3Cnt1 aTmpGPNPort4Cnt1" {
  array set $i {cnt2 0 cnt6 0 cnt9 0 cnt22 0 cnt33 0 cnt44 0 cnt11 0 cnt12 0 cnt13 0 cnt14 0 cnt15 0 cnt16 0} 
}
###开始抓包
if {$::cap_enable} {
    foreach hCfgCap $::hGPNPortCapList hCapAna $::hGPNPortCapAnalyzerList {
    gwd::Start_CapAllData ::capArr $hCfgCap $hCapAna
    }
}
###配置过滤器
foreach hCfgFil $::hGPNPortAnaFrameCfgFilList {
gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $anaFliFrameCfg
}
###停止抓包
if {$::cap_enable} {
    gwd::Stop_CapData $::hGPNPort1Cap 1 "$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap"
    gwd::Stop_CapData $::hGPNPort2Cap 1 "$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap"
    gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap"
    gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap"
}
set filterCnt 0
while {[classificationStatisticsPortRxCnt9 $id $::hGPNPort1Ana aTmpGPNPort1Cnt1]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 1 1 1 1 0 0
	after 5000
}
set filterCnt 0
while {[classificationStatisticsPortRxCnt9 $id $::hGPNPort2Ana aTmpGPNPort2Cnt1]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 1 1 1 1 0 0
	after 5000
}
set filterCnt 0
while {[classificationStatisticsPortRxCnt9 $id $::hGPNPort3Ana aTmpGPNPort3Cnt1]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 1 1 1 1 0 0
	after 5000
}
set filterCnt 0
while {[classificationStatisticsPortRxCnt9 $id $::hGPNPort4Ana aTmpGPNPort4Cnt1]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 1 1 1 1 0 0
	after 5000
}

}
########################################################################################################
#函数功能：发送数据流测试
#输入参数: caseId:端口抓包序列号
#输出参数：aGPNPort3Cnt1：端口3带vlan获取结果
#         aGPNPort4Cnt1：端口4带vlan获取结果
#返回值： 无
########################################################################################################
proc sendAndStat52 {aGPNPort4Cnt1 aGPNPort3Cnt1 caseId} {
upvar $aGPNPort4Cnt1 aTmpGPNPort4Cnt1
upvar $aGPNPort3Cnt1 aTmpGPNPort3Cnt1
foreach i "aTmpGPNPort4Cnt1 aTmpGPNPort3Cnt1" {
  array set $i {cnt1 0 cnt8 0 cnt9 0 cnt10 0 cnt11 0 cnt12 0 cnt13 0 cnt14 0 cnt15 0 cnt16 0 cnt17 0 cnt18 0} 
}
if {$::cap_enable} {
    gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer 
    gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
}
gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg1
gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg1
gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
after $::sendTime
if {$::cap_enable} {
    gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$::GPNTestEth4_cap\($::gpnIp3\).pcap"
    gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$::GPNTestEth3_cap\($::gpnIp1\).pcap"
}
set filterCnt 0
while {[classificationStatisticsPortRxCnt5 1 $::hGPNPort4Ana aTmpGPNPort4Cnt1]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 0 0 1 1 0 0
	after 5000
}
set filterCnt 0
while {[classificationStatisticsPortRxCnt5 1 $::hGPNPort3Ana aTmpGPNPort3Cnt1]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 0 0 1 1 0 0
	after 5000
}

gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
}
########################################################################################################
#函数功能：GPN上设置某个vlan的绑定arp和mac
#输入参数: GPNType：GPN的类型
#         vid：vlan id号
#         arp：绑定ARP地址
#         mac：绑定MAC地址
#        port：绑定端口
#输出参数：无
#返回值： flagErr  =0：添加成功       =1：添加失败            =2：ip地址添加达到最大值，无法继续添加  =3：不能绑定广播ip  =4不能绑定组播ip
########################################################################################################
proc GPN_CfgVlanArpAddr {matchType fileId GPNType vid arp mac port GPN_Id} {
  set flagErr 0
  expect {
    -i $GPN_Id
    -nocase -re "$matchType\\(config\\)#" {exp_send -i $GPN_Id "vlan $vid\r"}     
    timeout {set flagErr 1;exp_send -i $GPN_Id "\r"}  
  }
  expect {
    -i $GPN_Id
    -nocase -re "$matchType\\(vlan-v$vid\\)#" {exp_send -i $GPN_Id "ip static-arp $arp $mac $port\r"}  
    -timeout 20
    timeout {set flagErr 1;exp_send -i $GPN_Id "\r"}  
  }
  expect {
    -i $GPN_Id 
    -nocase -re {There are too many static ARP items} {exp_send -i $GPN_Id "exit\r";set flagErr 2}
    -nocase -re {Vlan need configure ip address} {exp_send -i $GPN_Id "exit\r";set flagErr 2}
    -nocase -re {Can't set broadcast IP address} {exp_send -i $GPN_Id "exit\r";set flagErr 3}
    -nocase -re {Can't set multicast IP address} {exp_send -i $GPN_Id "exit\r";set flagErr 4}
    -nocase -re "$matchType\\(vlan-v$vid\\)#" {exp_send -i $GPN_Id "exit\r"}
    -timeout 20
    timeout {set flagErr 1;exp_send -i $GPN_Id "\r"}  
  }
  expect {
    -i $GPN_Id
    -nocase -re "$matchType\\(config\\)#" {exp_send -i $GPN_Id "\r"}
    -timeout 20
    timeout {set flagErr 1;exp_send -i $GPN_Id "\r"}
  }  
  
  gwd::GWpublic_print [expr {($flagErr == 0) ? "OK" : "NOK"}] "在vlan$vid\中绑定ip:$arp\且绑定mac:$mac" $fileId
  return $flagErr  
}
########################################################################################################
#函数功能：GPN上trunk组模式测试
#输入参数:ModeFlag:模式类型
#	  trunKName:trunk组的名字
#	  portlist:端口列表
#	  masterPort:端口组的主端口
#输出参数：无
#返回值： 无
#作者：吴军妮
########################################################################################################
proc Test_TrunkMode {spawn_id matchType dutType fileId ModeFlag trunKName portlist masterPort caseId} {
	global capId
	global trunkSwTime
	set flag 0
        if {$::cap_enable} {
                gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
                gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
        }
        gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
        after 10000
	incr capId
	if {$::cap_enable} {
                gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap"
                gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap"
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt3 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt3 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
        parray aGPNPort3Cnt1
        parray aGPNPort4Cnt1
	gwd::GWpublic_print "  " "抓包文件为$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap" $fileId
	if {$aGPNPort4Cnt1(cnt2) < $::rateL || $aGPNPort4Cnt1(cnt2) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时NE1($::gpnIp1)$::GPNTestEth3\发送tag=50的数据流，NE3($::gpnIp3)\
			$::GPNTestEth4\收到tag=50的数据流的速率为$aGPNPort4Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时NE1($::gpnIp1)$::GPNTestEth3\发送tag=50的数据流，NE3($::gpnIp3)\
			$::GPNTestEth4\收到tag=50的数据流的速率为$aGPNPort4Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$aGPNPort3Cnt1(cnt6) < $::rateL || $aGPNPort3Cnt1(cnt6) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时NE3($::gpnIp3)$::GPNTestEth4\发送tag=1000的数据流，NE1($::gpnIp1)\
			$::GPNTestEth3\收到tag=1000的数据流的速率为$aGPNPort3Cnt1(cnt6)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时NE3($::gpnIp3)$::GPNTestEth4\发送tag=1000的数据流，NE1($::gpnIp1)\
			$::GPNTestEth3\收到tag=1000的数据流的速率为$aGPNPort3Cnt1(cnt6)，在$::rateL-$::rateR\范围内" $fileId
	}
        foreach eth $portlist {
                for {set i 1} {$i<3} {incr i} {
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt3 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 0 0 1 1 0 0
				after 5000
			}
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt3 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 0 0 1 1 0 0
				after 5000
			}
                        
                        
                        set FrameRate21 $aGPNPort4Cnt1(rate2)
                        set FrameRate61 $aGPNPort3Cnt1(rate6)
                        set DropFrame21 $aGPNPort4Cnt1(drop2)
                        set DropFrame61 $aGPNPort3Cnt1(drop6)
			send_log "\nFrameRate21:$FrameRate21"
			send_log "\nFrameRate61:$FrameRate61"
			send_log "\nDropFrame21:$DropFrame21"
			send_log "\nDropFrame61:$DropFrame61"
			gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth "shutdown"
			after 5000
			gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth "undo shutdown"
                        after 5000
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt3 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 0 0 1 1 0 0
				after 5000
			}
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt3 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 0 0 1 1 0 0
				after 5000
			}
                        parray aGPNPort3Cnt1
                        parray aGPNPort4Cnt1
                        set FrameRate22 $aGPNPort4Cnt1(rate2)
                        set FrameRate62 $aGPNPort3Cnt1(rate6)
                        set DropFrame22 $aGPNPort4Cnt1(drop2)
                        set DropFrame62 $aGPNPort3Cnt1(drop6)
                        send_log "\nFrameRate22:$FrameRate22"
                        send_log "\nFrameRate62:$FrameRate62"
                        send_log "\nDropFrame22:$DropFrame22"
                        send_log "\nDropFrame62:$DropFrame62"
			if {[string match "$masterPort" $eth]} {
				set printWord "主端口" 
			} else {
				set printWord "从端口"
			}
			if {$FrameRate21 != 0} {
				set DhTime2 [expr ($DropFrame22-$DropFrame21)*1000/$FrameRate21]
				if {$DhTime2>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$eth\down和up操作后，发送倒换时间为$DhTime2\ms大于最大允许倒换时间$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "第$i\次$matchType trunk组$trunKName$printWord$eth\down和up操作后，发送倒换时间为$DhTime2\ms小于最大允许倒换时间$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$eth\down和up操作后业务不通，无法测试发送倒换时间" $fileId
			}
			if {$FrameRate61 != 0} {
				set DhTime6 [expr ($DropFrame62-$DropFrame61)*1000/$FrameRate61]
				if {$DhTime6>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$eth\down和up操作后，接收倒换时间为$DhTime6\ms大于最大允许倒换时间$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "第$i\次$matchType trunk组$trunKName$printWord$eth\down和up操作后，接收倒换时间为$DhTime6\ms小于最大允许倒换时间$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$eth\down和up操作后业务不通，无法测试接收倒换时间" $fileId
			}
		}
	}
	lassign $portlist eth1 eth2
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth1 "shutdown"
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth2 "shutdown"
	after 5000
	if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
		gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
	}
	gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
	after 5000
	incr capId
	if {$::cap_enable} {
		gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap"
		gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap"
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt3 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt3 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
	parray aGPNPort3Cnt1
	parray aGPNPort4Cnt1
	gwd::GWpublic_print "  " "抓包文件为$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap" $fileId
	if {$aGPNPort4Cnt1(cnt2)!=0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时shutdownTRUNK组所有端口成员NE1($::gpnIp1)$::GPNTestEth3\发送tag=50的数据流，\
			NE3($::gpnIp3)$::GPNTestEth4\收到tag=50的数据流的速率应为0，实为$aGPNPort4Cnt1(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时shutdownTRUNK组所有端口成员NE1($::gpnIp1)$::GPNTestEth3\发送tag=50的数据流，\
			NE3($::gpnIp3)$::GPNTestEth4\收到tag=50的数据流的速率应为0，实为$aGPNPort4Cnt1(cnt2)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt6)!=0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时shutdownTRUNK组所有端口成员NE3($::gpnIp3)$::GPNTestEth4\发送tag=1000的数据流，\
			NE1($::gpnIp1)$::GPNTestEth3\收到tag=1000的数据流的速率应为0，实为$aGPNPort3Cnt1(cnt6)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时shutdownTRUNK组所有端口成员NE3($::gpnIp3)$::GPNTestEth4\发送tag=1000的数据流，\
			NE1($::gpnIp1)$::GPNTestEth3\收到tag=1000的数据流的速率应为0，实为$aGPNPort3Cnt1(cnt6)" $fileId
	}
	foreach port1 "$eth1 $eth2" port2 "$eth2 $eth1" {
		gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $port1 "undo shutdown"
		gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $port2 "shutdown"
		after 5000
		if {$::cap_enable} {
			gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
			gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
		}
		gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
		after 5000
		incr capId
		if {$::cap_enable} {
			gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap"	
			gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap"
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt3 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 1 0 0
			after 5000
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt3 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 1 0 0
			after 5000
		}
		parray aGPNPort3Cnt1
		parray aGPNPort4Cnt1
		gwd::GWpublic_print "  " "抓包文件为$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap" $fileId
		if {$aGPNPort4Cnt1(cnt2) < $::rateL || $aGPNPort4Cnt1(cnt2) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时trunk组端口$port1 up $port2 down NE1($::gpnIp1)$::GPNTestEth3\
				发送tag=50的数据流，NE3($::gpnIp3)$::GPNTestEth4\收到tag=50的数据流的速率为$aGPNPort4Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时trunk组端口$port1 up $port2 down NE1($::gpnIp1)$::GPNTestEth3\
				发送tag=50的数据流，NE3($::gpnIp3)$::GPNTestEth4\收到tag=50的数据流的速率为$aGPNPort4Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$aGPNPort3Cnt1(cnt6) < $::rateL || $aGPNPort3Cnt1(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时trunk组端口$port1 up $port2 down NE3($::gpnIp3)$::GPNTestEth4\
				发送tag=1000的数据流，NE1($::gpnIp1)$::GPNTestEth3\收到tag=1000的数据流的速率为$aGPNPort3Cnt1(cnt6)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时trunk组端口$port1 up $port2 down NE3($::gpnIp3)$::GPNTestEth4\
				发送tag=1000的数据流，NE1($::gpnIp1)$::GPNTestEth3\收到tag=1000的数据流的速率为$aGPNPort3Cnt1(cnt6)，在$::rateL-$::rateR\范围内" $fileId
		}
	}
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth1 "undo shutdown"
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth2 "undo shutdown"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
	return $flag
}
########################################################################################################
#函数功能：GPN上ep模式的重复测试
#输入参数:RunFlag:重复项标志位
#	  caseId:抓包端口id号
#输出参数：flag：业务判断结果标志位
#返回值： 无
#作者：吴军妮
########################################################################################################
proc PTN_EPRepeatFunc {fileId RunFlag printWord caseId} {
	set flag 0
	SendAndStat61 $::hGPNPort1Ana $::anaFliFrameCfg1 $::anaFliFrameCfg0 GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 $caseId
	parray GPNPort1Cnt1
	parray GPNPort2Cnt1
	parray GPNPort3Cnt1
	parray GPNPort4Cnt1
	parray GPNPort1Cnt0
	parray GPNPort2Cnt0
	parray GPNPort3Cnt0
	parray GPNPort4Cnt0
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap" $fileId
	if {$RunFlag == 0} {
		#DEV1 GPNTestEth1的接收检查 
        	if {$GPNPort1Cnt1(cnt22) < $::rateL || $GPNPort1Cnt1(cnt22) > $::rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord NE2($::gpnIp2)$::GPNTestEth2\发送tag=500的已知单播数据流，NE1($::gpnIp1)\
        			$::GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt22)，没在$::rateL-$::rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord NE2($::gpnIp2)$::GPNTestEth2\发送tag=500的已知单播数据流，NE1($::gpnIp1)\
        			$::GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt22)，在$::rateL-$::rateR\范围内" $fileId
        	}
        	if {$GPNPort1Cnt1(cnt33) < $::rateL || $GPNPort1Cnt1(cnt33) > $::rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord NE3($::gpnIp3)$::GPNTestEth3\发送tag=500已知单播的数据流，NE1($::gpnIp1)\
        			$::GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt33)，没在$::rateL-$::rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的已知单播数据流，NE1($::gpnIp1)\
        			$::GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt33)，在$::rateL-$::rateR\范围内" $fileId
        	}
        	if {$GPNPort1Cnt1(cnt44) < $::rateL || $GPNPort1Cnt1(cnt44) > $::rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的已知单播数据流，NE1($::gpnIp1)\
        			$::GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt44)，没在$::rateL-$::rateR\范围内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的已知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt44)，在$::rateL-$::rateR\范围内" $fileId
        	}
		if {$GPNPort1Cnt1(cnt10) < $::rateL0 || $GPNPort1Cnt1(cnt10) > $::rateR0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的广播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt10)，没在$::rateL0-$::rateR0\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的广播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt10)，在$::rateL0-$::rateR0\范围内" $fileId
		}
		if {$GPNPort1Cnt1(cnt11) < $::rateL || $GPNPort1Cnt1(cnt11) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的组播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt11)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的组播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt11)，在$::rateL-$::rateR\范围内" $fileId
		}
		#DEV2 GPNTestEth2的接收检查 
		if {$GPNPort2Cnt1(cnt2) < $::rateL || $GPNPort2Cnt1(cnt2) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的已知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的已知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort2Cnt1(cnt1) != 0} {
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=500的数据流的速率应该为0实为$GPNPort2Cnt1(cnt1)" $fileId
		} else {
			if {$GPNPort2Cnt0(cnt1) < $::rateL || $GPNPort2Cnt0(cnt1) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt0(cnt1)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到untag的数据流的速率为$GPNPort2Cnt0(cnt1)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort2Cnt0(cnt5) < $::rateL0 || $GPNPort2Cnt0(cnt5) > $::rateR0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的广播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率为$GPNPort2Cnt0(cnt5)，没在$::rateL0-$::rateR0\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的广播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率为$GPNPort2Cnt0(cnt5)，在$::rateL0-$::rateR0\范围内" $fileId
		}
		if {$GPNPort2Cnt0(cnt6) < $::rateL || $GPNPort2Cnt0(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的组播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率为$GPNPort2Cnt0(cnt6)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的组播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率为$GPNPort2Cnt0(cnt6)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort2Cnt1(cnt10) < $::rateL0 || $GPNPort2Cnt1(cnt10) > $::rateR0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的广播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率为$GPNPort2Cnt1(cnt10)，没在$::rateL0-$::rateR0\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的广播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率为$GPNPort2Cnt1(cnt10)，在$::rateL0-$::rateR0\范围内" $fileId
		}
		if {$GPNPort2Cnt1(cnt11) < $::rateL || $GPNPort2Cnt1(cnt11) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的组播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率为$GPNPort2Cnt1(cnt11)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的组播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率为$GPNPort2Cnt1(cnt11)，在$::rateL-$::rateR\范围内" $fileId
		}
		#DEV3 GPNTestEth3的接收检查
		if {$GPNPort3Cnt1(cnt3) < $::rateL || $GPNPort3Cnt1(cnt3) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的已知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt3)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的已知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt3)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort3Cnt1(cnt1) != 0} {
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=500的数据流的速率应该为0实为$GPNPort3Cnt1(cnt1)" $fileId
		} else {
			if {$GPNPort3Cnt0(cnt1) < $::rateL || $GPNPort3Cnt0(cnt1) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE3($::gpnIp3)\
					$::GPNTestEth3\收到untag的数据流的速率为$GPNPort3Cnt0(cnt1)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE3($::gpnIp3)\
					$::GPNTestEth3\收到untag的数据流的速率为$GPNPort3Cnt0(cnt1)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort3Cnt0(cnt5) < $::rateL0 || $GPNPort3Cnt0(cnt5) > $::rateR0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的广播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率为$GPNPort3Cnt0(cnt5)，没在$::rateL0-$::rateR0\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的广播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率为$GPNPort3Cnt0(cnt5)，在$::rateL0-$::rateR0\范围内" $fileId
		}
		if {$GPNPort3Cnt0(cnt6) < $::rateL || $GPNPort3Cnt0(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的组播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率为$GPNPort3Cnt0(cnt6)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的组播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率为$GPNPort3Cnt0(cnt6)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort3Cnt1(cnt10) < $::rateL0 || $GPNPort3Cnt1(cnt10) > $::rateR0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的广播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率为$GPNPort3Cnt1(cnt10)，没在$::rateL0-$::rateR0\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的广播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率为$GPNPort3Cnt1(cnt10)，在$::rateL0-$::rateR0\范围内" $fileId
		}
		if {$GPNPort3Cnt1(cnt11) < $::rateL || $GPNPort3Cnt1(cnt11) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的组播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率为$GPNPort3Cnt1(cnt11)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的组播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率为$GPNPort3Cnt1(cnt11)，在$::rateL-$::rateR\范围内" $fileId
		}
		#DEV4 GPNTestEth4的接收检查
		if {$GPNPort4Cnt1(cnt4) < $::rateL || $GPNPort4Cnt1(cnt4) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的已知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到tag=500的数据流的速率为$GPNPort4Cnt1(cnt4)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的已知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到tag=500的数据流的速率为$GPNPort4Cnt1(cnt4)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$GPNPort4Cnt1(cnt1) != 0} {
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE4($::gpnIp4)\
			$::GPNTestEth4\收到tag=500的数据流的速率应该为0实为$GPNPort4Cnt1(cnt1)" $fileId
		} else {
			if {$GPNPort4Cnt0(cnt1) < $::rateL || $GPNPort4Cnt0(cnt1) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE4($::gpnIp4)\
					$::GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt0(cnt1)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE4($::gpnIp4)\
					$::GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt0(cnt1)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort4Cnt0(cnt5) < $::rateL0 || $GPNPort4Cnt0(cnt5) > $::rateR0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的广播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率为$GPNPort4Cnt0(cnt5)，没在$::rateL0-$::rateR0\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的广播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率为$GPNPort4Cnt0(cnt5)，在$::rateL0-$::rateR0\范围内" $fileId
		}
		if {$GPNPort4Cnt0(cnt6) < $::rateL || $GPNPort4Cnt0(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的组播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率为$GPNPort4Cnt0(cnt6)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的组播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率为$GPNPort4Cnt0(cnt6)，在$::rateL-$::rateR\范围内" $fileId
		}
	} else {
		#DEV1 GPNTestEth1的接收检查 
		if {$GPNPort1Cnt1(cnt22) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE2($::gpnIp2)$::GPNTestEth2\发送tag=500的已知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=500的数据流的速率应为0实为$GPNPort1Cnt1(cnt22)，" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE2($::gpnIp2)$::GPNTestEth2\发送tag=500的已知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=500的数据流的速率应为0实为$GPNPort1Cnt1(cnt22)" $fileId
		}
		if {$GPNPort1Cnt1(cnt33) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE3($::gpnIp3)$::GPNTestEth3\发送tag=500已知单播的数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=500的数据流的速率应为0实为$GPNPort1Cnt1(cnt33)，" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE3($::gpnIp3)$::GPNTestEth3\发送tag=500的已知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=500的数据流的速率应为0实为$GPNPort1Cnt1(cnt33)" $fileId
		}
		if {$GPNPort1Cnt1(cnt44) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的已知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=500的数据流的速率应为0实为$GPNPort1Cnt1(cnt44)，" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=500的已知单播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=500的数据流的速率应为0实为$GPNPort1Cnt1(cnt44)" $fileId
		}
		if {$GPNPort1Cnt1(cnt10) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的广播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=800的数据流的速率应为0实为$GPNPort1Cnt1(cnt10)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的广播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=800的数据流的速率应为0实为$GPNPort1Cnt1(cnt10)" $fileId
		}
		if {$GPNPort1Cnt1(cnt11) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的组播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=800的数据流的速率应为0实为$GPNPort1Cnt1(cnt11)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的组播数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到tag=800的数据流的速率应为0实为$GPNPort1Cnt1(cnt11)" $fileId
		}
		#DEV2 GPNTestEth2的接收检查 
		if {$GPNPort2Cnt1(cnt2) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的已知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到tag=500的数据流的速率应为0实为$GPNPort2Cnt1(cnt2)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的已知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到tag=500的数据流的速率应为0实为$GPNPort2Cnt1(cnt2)" $fileId
		}
		if {$GPNPort2Cnt0(cnt1) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到untag的数据流的速率应为0实为$GPNPort2Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到untag的数据流的速率应为0实为$GPNPort2Cnt0(cnt1)" $fileId
		}
		if {$GPNPort2Cnt0(cnt5) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的广播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt5)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的广播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt5)" $fileId
		}
		if {$GPNPort2Cnt0(cnt6) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的组播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt6)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的组播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt6)" $fileId
		}
		if {$GPNPort2Cnt1(cnt10) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的广播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt1(cnt10)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的广播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt1(cnt10)" $fileId
		}
		if {$GPNPort2Cnt1(cnt11) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的组播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt1(cnt11)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的组播数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt1(cnt11)" $fileId
		}
		#DEV3 GPNTestEth3的接收检查
		if {$GPNPort3Cnt1(cnt3) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的已知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到tag=500的数据流的速率应为0实为$GPNPort3Cnt1(cnt3)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的已知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到tag=500的数据流的速率应为0实为$GPNPort3Cnt1(cnt3)" $fileId
		}
		if {$GPNPort3Cnt0(cnt1) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到untag的数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到untag的数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
		}
		if {$GPNPort3Cnt0(cnt5) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的广播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt5)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的广播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt5)" $fileId
		}
		if {$GPNPort3Cnt0(cnt6) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的组播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt6)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的组播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt6)" $fileId
		}
		if {$GPNPort3Cnt1(cnt10) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的广播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt1(cnt10)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的广播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt1(cnt10)" $fileId
		}
		if {$GPNPort3Cnt1(cnt11) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的组播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt1(cnt11)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\发送tag=800的组播数据流，NE3($::gpnIp3)\
				$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt1(cnt11)" $fileId
		}
		#DEV4 GPNTestEth4的接收检查
		if {$GPNPort4Cnt1(cnt4) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的已知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到tag=500的数据流的速率应为0实为$GPNPort4Cnt1(cnt4)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送tag=500的已知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到tag=500的数据流的速率应为0实为$GPNPort4Cnt1(cnt4)" $fileId
		}
		if {$GPNPort4Cnt0(cnt1) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到untag的数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的未知单播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到untag的数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
		}
		if {$GPNPort4Cnt0(cnt5) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的广播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt5)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的广播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt5)" $fileId
		}
		if {$GPNPort4Cnt0(cnt6) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的组播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt6)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\发送untag的组播数据流，NE4($::gpnIp4)\
				$::GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt6)" $fileId
		}
	}
  	return $flag
}


#########################################################################################################
##函数功能：GPN上删除四台设备的ac pw和vpls的配置
##输入参数: pw:pw和vpls id的初值
##	  RunFlag:删除项标志位
##	  AcName:ac接口名称
##输出参数：无
##返回值： 无
##作者：吴军妮
#########################################################################################################
#proc PTN_DelConfig {pw RunFlag AcName} {
#foreach telnet $::Telnetlist Gpn_type $::Typelist {
#if {$RunFlag==0} {
#set pw1 [expr $pw+1]
#set pw2 [expr $pw+2]
#set pw3 [expr $pw+3]
#} elseif {$RunFlag==1} {
#set pw1 [expr [expr $pw*10]+1]
#set pw2 [expr [expr $pw*10]+2]
#set pw3 [expr [expr $pw*10]+3]
#} elseif {$RunFlag==2} {
#set pw1 $pw
#set pw2 [expr $pw+1]
#set pw3 [expr $pw+2]
#} 
#gwd::GPN_DelAc "GPN_PTN_006" $::fileId $AcName $telnet $Gpn_type
#if {[string match $::telnet1 $telnet] && [string match "11" $pw1] } {
#set pw1 [expr $pw1+3]
#} 
#if {$RunFlag==0} {
#gwd::GPN_DelPw "GPN_PTN_006" $::fileId "pw0$pw1" $telnet $Gpn_type	
#} elseif {$RunFlag==1} {
#gwd::GPN_DelPw "GPN_PTN_006" $::fileId "pw$pw1" $telnet $Gpn_type
#} elseif {$RunFlag==2} {
#gwd::GPN_DelPw "GPN_PTN_006" $::fileId "pw[expr $pw1*10]" $telnet $Gpn_type
#} 
#if {[string match $::telnet2 $telnet] && [string match "22" $pw2] } {
#set pw2 [expr $pw2+2]
#} 
#if {$RunFlag==0} {
#gwd::GPN_DelPw "GPN_PTN_006" $::fileId "pw0$pw2" $telnet $Gpn_type	
#} elseif {$RunFlag==1} {
#gwd::GPN_DelPw "GPN_PTN_006" $::fileId "pw$pw2" $telnet $Gpn_type
#} elseif {$RunFlag==2} {
#gwd::GPN_DelPw "GPN_PTN_006" $::fileId "pw[expr $pw2*10]" $telnet $Gpn_type
#} 
#if {[string match $::telnet3 $telnet] && [string match "33" $pw3] } {
#set pw3 [expr $pw3+1]
#}
#if {$RunFlag==0} {
#gwd::GPN_DelPw "GPN_PTN_006" $::fileId "pw0$pw3" $telnet $Gpn_type	
#} elseif {$RunFlag==1} {
#gwd::GPN_DelPw "GPN_PTN_006" $::fileId "pw$pw3" $telnet $Gpn_type
#} elseif {$RunFlag==2} {
#gwd::GPN_DelPw "GPN_PTN_006" $::fileId "pw[expr $pw3*10]" $telnet $Gpn_type
#} 
#if {$RunFlag!=2} {
#gwd::GPN_DelVlanVPLS "GPN_PTN_006" $::fileId "vpls$pw" $Gpn_type $telnet
#} 
#if {$RunFlag!=1} {
#set pw [expr $pw+10]
#} else {
#set pw [expr $pw+1]
#} 
#}
#}
########################################################################################################
#函数功能：GPN上修改四台设备的ac pw和vpls的配置
#输入参数: fileId:测试报告的文件id
#                     id:pw和vpls id的初值
#                     type:mac地址学习规则 discard/flood
#                     maccnt:mac地址学习数量
#	  ifDel：是否删除之前的配置  =1 删除        =0不删除
#	  ifAdd：是否添加配置  =1 添加        =0不添加
#输出参数：无
#返回值： 无
#作者：吴军妮
########################################################################################################
proc PTN_ChangeElanConfig {fileId id type maccnt ifDel ifAdd} {
	global telnet1
	global matchType1
	global Gpn_type1
	global telnet2
	global matchType2
	global Gpn_type2
	global telnet3
	global matchType3
	global Gpn_type3
	global telnet4
	global matchType4
	global Gpn_type4
	
	if {$ifDel == 1} {
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac500"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
		gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls$id"
	}
	if {$ifAdd == 1} {
		#============配置设备NE1==========="
		gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls$id" $id "elan" $type "false" "false" "false" "true" $maccnt "" ""
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls$id" "peer" $::address612 "102" "102" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls$id" "peer" $::address614 "402" "402" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4" 
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls$id" "peer" $::address613 "52" "52" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac500" "vpls$id" "" $::GPNTestEth1 "500" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"	
	}
}
########################################################################################################
#函数功能：GPN上修改四台设备的ac pw和vpls的配置
#输入参数: fileId:测试报告的文件id
#                     id:pw和vpls id的初值
#                     type:mac地址学习规则 discard/flood
#                     maccnt:mac地址学习数量
#	  ifDel：是否删除之前的配置  =1 删除        =0不删除
#	  ifAdd：是否添加配置  =1 添加        =0不添加
#输出参数：无
#返回值： 无
#作者：吴军妮
########################################################################################################
proc PTN_ChangeETreeConfig {fileId id type maccnt ifDel ifAdd bcastCfg mcastCfg unicastCfg} {
	global telnet1
	global matchType1
	global Gpn_type1
		
	if {$ifDel == 1} {
		gwd::GWAc_DelName $telnet1 $matchType1 $Gpn_type1 $fileId "ac800"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13"
		gwd::GWStaPw_DelPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14"
		gwd::GWVpls_DelInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls$id"
	}
	if {$ifAdd == 1} {
		#============配置设备NE1==========="
		gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls$id" $id "etree" $type $bcastCfg $mcastCfg $unicastCfg "true" $maccnt "" ""
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls$id" "peer" $::address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls$id" "peer" $::address614 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls$id" "peer" $::address613 "3000" "3000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls$id" "" $::GPNTestEth1 "800" "0" "root" "nochange" "1" "0" "0" "0x8100" "evc2"	
	}
}
########################################################################################################
#函数功能：GPN上修改四台设备的ac pw和vpls的配置
#输入参数: fileId:测试报告的文件id
#                     id:pw和vpls id的初值
#                   vid1:运营商vlan
#                   vid2:客户vlan
#                   type:mac地址学习规则 discard/flood
#                 maccnt:mac地址学习数量
#               RoleList:AC角色列表
#                  role1:PW角色1
#                  role2:PW角色2
#输出参数：无
#返回值： 无
#作者：吴军妮
########################################################################################################
#proc PTN_ChangeEtreeConfig {fileId id vid1 vid2 type maccnt RoleList role1 role2} {
#foreach telnet $::Telnetlist Gpn_type $::Typelist eth $::Portlist0 role $RoleList {
####配置vpls
#gwd::GPN_CfgVlanVpls "GPN_PTN_010" $fileId "vpls$id" $id "etree" $type "false" "false" "false" "true" $maccnt $Gpn_type $telnet
##配置ac
#gwd::GPN_CfgVlanAC "GPN_PTN_010" $fileId "ac$vid1" "vpls$id" $eth $vid1 $vid2 $role "nochange" "1" "0" "0" "0x8100" "evc2" $Gpn_type $telnet
#incr id 10
#}
####配置pw
#puts $fileId "\n============配置设备NE1===========\n"
#gwd::GPN_CreatePw "GPN_PTN_010" $fileId "pw012" "vpls" "vpls10" "peer" $::address612 "100" "100" "" "nochange" $role1 1 0 "0x8100" "0x8100" "2" $::telnet1 $::Gpn_type1
#gwd::GPN_CreatePw "GPN_PTN_010" $fileId "pw014" "vpls" "vpls10" "peer" $::address614 "200" "200" "" "nochange" $role1 1 0 "0x8100" "0x8100" "4" $::telnet1 $::Gpn_type1
#gwd::GPN_CreatePw "GPN_PTN_010" $fileId "pw013" "vpls" "vpls10" "peer" $::address613 "300" "300" "" "nochange" $role1 1 0 "0x8100" "0x8100" "3" $::telnet1 $::Gpn_type1
#puts $fileId "\n============配置设备NE2===========\n"
#gwd::GPN_CreatePw "GPN_PTN_010" $fileId "pw021" "vpls" "vpls20" "peer" $::address621 "100" "100" "" "nochange" $role2 1 0 "0x8100" "0x8100" "1" $::telnet2 $::Gpn_type2
#puts $fileId "\n============配置设备NE3===========\n"
#gwd::GPN_CreatePw "GPN_PTN_010" $fileId "pw031" "vpls" "vpls30" "peer" $::address631 "300" "300" "" "nochange" $role2 1 0 "0x8100" "0x8100" "1" $::telnet3 $::Gpn_type3
#puts $fileId "\n============配置设备NE4===========\n"
#gwd::GPN_CreatePw "GPN_PTN_010" $fileId "pw041" "vpls" "vpls40" "peer" $::address641 "200" "200" "" "nochange" $role2 1 0 "0x8100" "0x8100" "1" $::telnet4 $::Gpn_type4
#}
########################################################################################################
#函数功能：查询vpls表项
#输入参数: fileId:测试报告的文件id
#         type:ac/pw
#     typename:ac/pw名称
#     vplsname:vpls名称
#     GPN_type:设备类型
#       GPN_Id:spawn id
#输出参数：无
#返回值： tableList：vpls表项列表
#作者：吴军妮
########################################################################################################
proc GPN_QueryVPLSForwardTable1 {fileId type typename vplsname GPN_type GPN_Id} {
  set flagErr 0
  set tableList ""
  expect {
    -i $GPN_Id
    -re "$matchType\\(config\\)#" {exp_send -i $GPN_Id "show forward-entry $type $typename vpls $vplsname\r"}
    timeout {set flagErr 1;exp_send -i $GPN_Id "\r"}
  }
  after 30000;exp_send -i $GPN_Id "\r"
 for {set j 1} {$j<=100} {incr j} {
   expect {
     -i $GPN_Id
     -re {.+} {exp_send -i $GPN_Id "\r"}
     after 1000;exp_send -i $GPN_Id "\r"
     }
 }
  expect {
     -i $GPN_Id
     -re {.+} {
     set tableList [regexp  -all -inline -nocase -line "(?:\[0-9|a-f|\.]+){3}\\s+$vplsname\\s+\[a-z|0-9|_]+.+" $expect_out(0,string)]
     exp_send -i $GPN_Id "\r"}   
     timeout {set flagErr 1;exp_send -i $GPN_Id "\r"}  
   }
  puts -nonewline $fileId [format "%-59s" "在GPN上查询vpls表项"]
  if {$flagErr} {
    puts $fileId "NOK"   
  } else {
    puts $fileId "OK" 
  }
  return $tableList
}
########################################################################################################
#函数功能：GPN上测试vpls域中mac地址学习数量和规则
#输入参数: type:flood/discard
#          acName ：查看地址转发表时输入ac的名字
#          vplsName ：查看地址转发表时输入vpls的名字
#          macLearnCnt ：期望的mac地址学习个数
#          recCnt ：期望的接收到的数据包的个数
#返回值： flag
#作者：吴军妮
########################################################################################################
proc PTN_VplsChangeTest {spawn_id matchType dutType fileId type acName vplsName macLearnCnt recCnt} {
	set flag 0 
	stc::perform ResultsClearViewCommand -ResultList "[stc::get $::hGPNPort2Ana -children-AnalyzerPortResults] [stc::get $::hGPNPort3Ana -children-AnalyzerPortResults] [stc::get $::hGPNPort4Ana -children-AnalyzerPortResults]"
        gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort2Ana $::hGPNPort3Ana $::hGPNPort4Ana"
        after 10000
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort2Ana $::hGPNPort3Ana $::hGPNPort4Ana"
        gwd::GWpubic_queryVPLSForwardTable $spawn_id $matchType $dutType $fileId "ac" $acName $vplsName dTable
        set maccnt [dict size $dTable]
        puts "maccnt: $maccnt"
	if {$maccnt!=$macLearnCnt} {
		set flag 1
		gwd::GWpublic_print "NOK" "设置mac地址学习限制为$macLearnCnt\个学习规则为$type\，NE1($::gpnIp1)发送200个mac地址变化的数据流，NE1($::gpnIp1)mac地址表中学习到ac1的mac地址个数为$maccnt" $fileId
	} else {
		gwd::GWpublic_print "OK" "设置mac地址学习限制为$macLearnCnt\个学习规则为$type\，NE1($::gpnIp1)发送200个mac地址变化的数据流，NE1($::gpnIp1)mac地址表中学习到ac1的mac地址个数为$maccnt" $fileId
	}
	
	set cnt2 [stc::get $::hGPNPort2Ana.AnalyzerPortResults -SigFrameCount]
	set cnt3 [stc::get $::hGPNPort3Ana.AnalyzerPortResults -SigFrameCount]
	set cnt4 [stc::get $::hGPNPort4Ana.AnalyzerPortResults -SigFrameCount]
        puts "portcnt2: $cnt2 portcnt3: $cnt3 portcnt4: $cnt4"
        if {$cnt2 !=$recCnt} {
		set flag 1
		gwd::GWpublic_print "NOK" "设置mac地址学习限制为$macLearnCnt\个学习规则为$type\，NE1($::gpnIp1)发送200个mac地址变化的数据流，NE2($::gpnIp2)收到的mac地址变化的数据流个数为$cnt2" $fileId
        } else {
		gwd::GWpublic_print "OK" "设置mac地址学习限制为$macLearnCnt\个学习规则为$type\，NE1($::gpnIp1)发送200个mac地址变化的数据流，NE2($::gpnIp2)收到的mac地址变化的数据流个数为$cnt2" $fileId
        }
	if {$cnt3 !=$recCnt} {
		set flag 1
		gwd::GWpublic_print "NOK" "设置mac地址学习限制为$macLearnCnt\个学习规则为$type\，NE1($::gpnIp1)发送200个mac地址变化的数据流，NE3($::gpnIp4)收到的mac地址变化的数据流个数为$cnt3" $fileId
	} else {
		gwd::GWpublic_print "OK" "设置mac地址学习限制为$macLearnCnt\个学习规则为$type\，NE1($::gpnIp1)发送200个mac地址变化的数据流，NE3($::gpnIp4)收到的mac地址变化的数据流个数为$cnt3" $fileId
	}
	if {$cnt4 !=$recCnt} {
		set flag 1
		gwd::GWpublic_print "NOK" "设置mac地址学习限制为$macLearnCnt\个学习规则为$type\，NE1($::gpnIp1)发送200个mac地址变化的数据流，NE4($::gpnIp4)收到的mac地址变化的数据流个数为$cnt4" $fileId
	} else {
		gwd::GWpublic_print "OK" "设置mac地址学习限制为$macLearnCnt\个学习规则为$type\，NE1($::gpnIp1)发送200个mac地址变化的数据流，NE4($::gpnIp4)收到的mac地址变化的数据流个数为$cnt4" $fileId
	}
	return $flag
}
########################################################################################################
#函数功能：GPN上报文过滤测试
#输入参数: RunFlag ：测试项标志位
#输出参数：flag:数据转发结果判断标志位
#返回值： 无
########################################################################################################
proc PTN_ElanMessageRestrain {RunFlag flag} {
upvar $flag aTempFlag
set aTempFlag 0
foreach i "GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1" {
  array set $i {cnt10 0 cnt11 0 cnt44 0} 
}
gwd::Start_SendFlow "$::hGPNPort4Gen"  $::hGPNPortAnaList
after $::sendTime
set filterCnt 0
while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort2Ana GPNPort2Cnt1]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 1 1 1 0 0 0
	after 5000
}
set filterCnt 0
while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort3Ana GPNPort3Cnt1]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 1 1 1 0 0 0
	after 5000
}
set filterCnt 0
while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort1Ana GPNPort1Cnt1]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 1 1 1 0 0 0
	after 5000
}
gwd::Stop_SendFlow "$::hGPNPort4Gen"  $::hGPNPortAnaList
if {$GPNPort1Cnt1(cnt44) < $::rateL || $GPNPort1Cnt1(cnt44) > $::rateR || $GPNPort1Cnt1(cnt10) < $::rateL0 || $GPNPort1Cnt1(cnt10) > $::rateR0 || $GPNPort1Cnt1(cnt11) < $::rateL || $GPNPort1Cnt1(cnt11) > $::rateR\
 || $GPNPort2Cnt1(cnt44) < $::rateL || $GPNPort2Cnt1(cnt44) > $::rateR || $GPNPort2Cnt1(cnt10) < $::rateL0 || $GPNPort2Cnt1(cnt10) > $::rateR0 || $GPNPort2Cnt1(cnt11) < $::rateL || $GPNPort2Cnt1(cnt11) > $::rateR\
 || $GPNPort3Cnt1(cnt44) < $::rateL || $GPNPort3Cnt1(cnt44) > $::rateR || $GPNPort3Cnt1(cnt10) < $::rateL0 || $GPNPort3Cnt1(cnt10) > $::rateR0 || $GPNPort3Cnt1(cnt11) < $::rateL || $GPNPort3Cnt1(cnt11) > $::rateR} { 
if {$RunFlag==1} {
set aTempFlag 1
puts $::fileId "NE4发送未知单播、广播、组播，取消组播/广播抑制发流验证业务转发异常"
} elseif {$RunFlag==2} {
puts $::fileId "NE4发送未知单播、广播、组播，使能组播/广播抑制发流验证业务转发正常"
} elseif {$RunFlag==3} {
set aTempFlag 1
puts $::fileId "NE4发送未知单播、广播、组播，取消组播/广播抑制发流验证业务恢复异常"
} 
puts $::fileId "NE1设备收到NE4的未知单播，广播，组播分别为：$GPNPort1Cnt1(cnt44) bps $GPNPort1Cnt1(cnt10) bps $GPNPort1Cnt1(cnt11) bps"
puts $::fileId "NE2设备收到NE4的未知单播，广播，组播分别为：$GPNPort2Cnt1(cnt44) bps $GPNPort2Cnt1(cnt10) bps $GPNPort2Cnt1(cnt11) bps"
puts $::fileId "NE3设备收到NE4的未知单播，广播，组播分别为：$GPNPort3Cnt1(cnt44) bps $GPNPort3Cnt1(cnt10) bps $GPNPort3Cnt1(cnt11) bps"
 }
}
########################################################################################################
#函数功能：GPN上报文过滤测试
#输入参数: RunFlag ：测试项标志位
#输出参数：flag:数据转发结果判断标志位
#返回值： 无
#作者：吴军妮
########################################################################################################
proc PTN_EtreeMessageRestrain {RunFlag flag} {
upvar $flag aTempFlag
set aTempFlag 0
foreach i "GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1" {
  array set $i {cnt10 0 cnt11 0 cnt13 0} 
}
gwd::Start_SendFlow "$::hGPNPort1Gen"  $::hGPNPortAnaList
after $::sendTime
set filterCnt 0
while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort2Ana GPNPort2Cnt1]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 0 1 1 1 0 0
	after 5000
}
set filterCnt 0
while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort3Ana GPNPort3Cnt1]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 0 1 1 1 0 0
	after 5000
}
set filterCnt 0
while {[classificationStatisticsPortRxCnt4 1 $::hGPNPort4Ana GPNPort4Cnt1]} {
	if {$filterCnt == $::filterGlobalCnt} {
		break
	}
	incr filterCnt
	Recustomization 0 1 1 1 0 0
	after 5000
}
gwd::Stop_SendFlow "$::hGPNPort1Gen"  $::hGPNPortAnaList
if {$RunFlag==2} {
set rateL0 70000
set rateR0 75000
} else {
set rateL0 $::rateL0
set rateR0 $::rateR0
}
if {$GPNPort4Cnt1(cnt13) < $::rateL || $GPNPort4Cnt1(cnt13) > $::rateR || $GPNPort4Cnt1(cnt10) < $rateL0 || $GPNPort4Cnt1(cnt10) > $rateR0 || $GPNPort4Cnt1(cnt11) < $::rateL || $GPNPort4Cnt1(cnt11) > $::rateR\
 || $GPNPort2Cnt1(cnt13) < $::rateL || $GPNPort2Cnt1(cnt13) > $::rateR || $GPNPort2Cnt1(cnt10) < $rateL0 || $GPNPort2Cnt1(cnt10) > $rateR0 || $GPNPort2Cnt1(cnt11) < $::rateL || $GPNPort2Cnt1(cnt11) > $::rateR\
 || $GPNPort3Cnt1(cnt13) < $::rateL || $GPNPort3Cnt1(cnt13) > $::rateR || $GPNPort3Cnt1(cnt10) < $rateL0 || $GPNPort3Cnt1(cnt10) > $rateR0 || $GPNPort3Cnt1(cnt11) < $::rateL || $GPNPort3Cnt1(cnt11) > $::rateR} {
set aTempFlag 1 
if {$RunFlag==1} {
puts $::fileId "NE1发送未知单播、广播、组播，取消组播/广播抑制发流验证业务转发异常"
} elseif {$RunFlag==2} {
puts $::fileId "NE1发送未知单播、广播、组播，使能组播/广播抑制发流验证业务转发异常"
} elseif {$RunFlag==3} {
puts $::fileId "NE1发送未知单播、广播、组播，取消组播/广播抑制发流验证业务恢复异常"
} 
puts $::fileId "抑制不生效，NE4设备收到NE1的未知单播，广播，组播分别为：$GPNPort4Cnt1(cnt13) bps $GPNPort4Cnt1(cnt10) bps $GPNPort4Cnt1(cnt11) bps"
puts $::fileId "抑制不生效，NE2设备收到NE1的未知单播，广播，组播分别为：$GPNPort2Cnt1(cnt13) bps $GPNPort2Cnt1(cnt10) bps $GPNPort2Cnt1(cnt11) bps"
puts $::fileId "抑制不生效，NE3设备收到NE1的未知单播，广播，组播分别为：$GPNPort3Cnt1(cnt13) bps $GPNPort3Cnt1(cnt10) bps $GPNPort3Cnt1(cnt11) bps"
 }
}
########################################################################################################
#函数功能：GPN上黑白名单测试
#         f_black：    =1黑名单测试         =0白名单测试
#         f_addStatic：是否添加了静态mac地址     =1添加了静态mac地址/黑洞         =0没有添加静态mac地址/黑洞
#         f_pw：     =1在pw上添加了静态mac地址/黑洞 
#	  printWord：报告中打印的关键字符串
#             type ：mac查询类型 vpls pw ac 
#         typename ：查询类型对应的名称
#         vplsname ：查询mac地址的vpls域的名字
#              mac ：静态mac地址/黑洞地址
# 	  caseId：抓包文件名字的关键字
#输出参数：flag1:数据转发结果判断标志位
#	  flag2:mac地址学习结果判断标志位
#返回值： 无
#作者：吴军妮
########################################################################################################
proc PTN_BlackAndWhiteMac {f_black f_addStatic f_pw printWord type typename vplsname mac caseId} {
	global gpnIp1
	global gpnIp2
	global gpnIp3
	global gpnIp4
	global fileId
	global GPNTestEth1
	global GPNTestEth2
	global GPNTestEth3
	global GPNTestEth4
	set flag 0
		
	SendAndStat_ptn006 1 $::hGPNPort1Gen "$::hGPNPort2Ana $::hGPNPort3Ana $::hGPNPort4Ana" "$GPNTestEth2 $GPNTestEth3 $GPNTestEth4" "$::hGPNPort2Cap $::hGPNPort2CapAnalyzer \
		$::gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $::gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $::gpnIp4" "$::hGPNPort2AnaFrameCfgFil \
		$::hGPNPort3AnaFrameCfgFil $::hGPNPort4AnaFrameCfgFil" GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 TmpCnt2 1 $::anaFliFrameCfg1 $caseId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap" $fileId
	if {[string match "0000.0000.0022" $mac]} {
		set prtStr "dmac"
	} else {
		set prtStr "smac"
	}
        if {$f_black==0} {
        	if {$f_pw == 1 && $f_addStatic == 1} {
				if {$GPNPort2Cnt1(cnt2) < $::rateL || $GPNPort2Cnt1(cnt2) > $::rateR} {
					set flag 1
					gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE2($gpnIp2)\
						$GPNTestEth2\收到数据流的速率为$GPNPort2Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
				} else {
					gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE2($gpnIp2)\
						$GPNTestEth2\收到数据流的速率为$GPNPort2Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
				}
				if {$GPNPort3Cnt1(cnt2) != 0} {
					set flag 1
					gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE3($gpnIp3)\
						$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt1(cnt2)" $fileId
				} else {
					gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE3($gpnIp3)\
						$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt1(cnt2)" $fileId
				}
				if {$GPNPort4Cnt1(cnt2) != 0} {
					set flag 1
					gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE4($gpnIp4)\
						$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt1(cnt2)" $fileId
				} else {
					gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE4($gpnIp4)\
						$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt1(cnt2)" $fileId
				}
        	} else {
			if {$GPNPort2Cnt1(cnt2) < $::rateL || $GPNPort2Cnt1(cnt2) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率为$GPNPort2Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率为$GPNPort2Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
			}
        		if {$GPNPort3Cnt1(cnt2) < $::rateL || $GPNPort3Cnt1(cnt2) > $::rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE3($gpnIp3)\
        				$GPNTestEth3\收到数据流的速率为$GPNPort3Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE3($gpnIp3)\
        				$GPNTestEth3\收到数据流的速率为$GPNPort3Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
        		}
        		if {$GPNPort4Cnt1(cnt2) < $::rateL || $GPNPort4Cnt1(cnt2) > $::rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE4($gpnIp4)\
        				$GPNTestEth4\收到数据流的速率为$GPNPort4Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE4($gpnIp4)\
        				$GPNTestEth4\收到数据流的速率为$GPNPort4Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
        		}
        		
        	}
        
        } elseif {$f_black==1} {
            	if {$f_pw == 0 && $f_addStatic == 1} {
                    	if {$GPNPort2Cnt1(cnt2) != 0} {
                    		set flag 1
                    		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE2($gpnIp2)\
                    			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt1(cnt2)" $fileId
                    	} else {
                    		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE2($gpnIp2)\
                    			$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt1(cnt2)" $fileId
                    	}
                    	if {$GPNPort3Cnt1(cnt2) != 0} {
                    		set flag 1
                    		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE3($gpnIp3)\
                    			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt1(cnt2)" $fileId
                    	} else {
                    		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE3($gpnIp3)\
                    			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt1(cnt2)" $fileId
                    	}
                    	if {$GPNPort4Cnt1(cnt2) != 0} {
                    		set flag 1
                    		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE4($gpnIp4)\
                    			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt1(cnt2)" $fileId
                    	} else {
                    		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE4($gpnIp4)\
                    			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt1(cnt2)" $fileId
                    	}
            	} elseif {$f_pw == 1 && $f_addStatic == 1} {
			if {$GPNPort2Cnt1(cnt2) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt1(cnt2)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE2($gpnIp2)\
					$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt1(cnt2)" $fileId
			}
			if {$GPNPort3Cnt1(cnt2) < $::rateL || $GPNPort3Cnt1(cnt2) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率为$GPNPort3Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE3($gpnIp3)\
					$GPNTestEth3\收到数据流的速率为$GPNPort3Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
			}
			if {$GPNPort4Cnt1(cnt2) < $::rateL || $GPNPort4Cnt1(cnt2) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率为$GPNPort4Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE4($gpnIp4)\
					$GPNTestEth4\收到数据流的速率为$GPNPort4Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
			}
		} else {
        		if {$GPNPort2Cnt1(cnt2) < $::rateL || $GPNPort2Cnt1(cnt2) > $::rateR} {
        		    set flag 1
        		    gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE2($gpnIp2)\
        			    $GPNTestEth2\收到数据流的速率为$GPNPort2Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
        		} else {
        		    gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE2($gpnIp2)\
        			    $GPNTestEth2\收到数据流的速率为$GPNPort2Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
        		}
        		if {$GPNPort3Cnt1(cnt2) < $::rateL || $GPNPort3Cnt1(cnt2) > $::rateR} {
        		    set flag 1
        		    gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE3($gpnIp3)\
        			    $GPNTestEth3\收到数据流的速率为$GPNPort3Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
        		} else {
        		    gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE3($gpnIp3)\
        			    $GPNTestEth3\收到数据流的速率为$GPNPort3Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
        		}
        		if {$GPNPort4Cnt1(cnt2) < $::rateL || $GPNPort4Cnt1(cnt2) > $::rateR} {
        		    set flag 1
        		    gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE4($gpnIp4)\
        			    $GPNTestEth4\收到数据流的速率为$GPNPort4Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
        		} else {
        		    gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\发送$prtStr=$mac\的未知单播数据流，NE4($gpnIp4)\
        			    $GPNTestEth4\收到数据流的速率为$GPNPort4Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
        		}
		} 
	}
	gwd::GWpubic_queryVPLSForwardTable $::telnet1 $::matchType1 $::Gpn_type1 $fileId $type $typename $vplsname dTable
        if {$f_addStatic == 1} {
        	if {[dict exists $dTable $mac]} {
        		if {[string match -nocase $typename [dict get $dTable $mac portname]]} {
        			gwd::GWpublic_print "OK" "$printWord\mac地址$mac\的portname是$typename" $fileId
        		} else {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\mac地址$mac\的portname是[dict get $dTable $mac portname]" $fileId
        		}
			if {[string match -nocase "static" [dict get $dTable $mac flag]]} {
				gwd::GWpublic_print "OK" "$printWord\mac地址$mac\显示是静态mac地址" $fileId
			} elseif {[string match -nocase "none" [dict get $dTable $mac flag]]} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\mac地址$mac\显示是动态学习到的mac地址" $fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\mac地址$mac\的flag信息显示是[dict get $dTable $mac flag]" $fileId
			}
			if {$f_black==1} {
				if {[string match -nocase "src" [dict get $dTable $mac drop]]} {
					gwd::GWpublic_print "OK" "$printWord\mac地址$mac\的drop信息显示是[dict get $dTable $mac drop]" $fileId
				} else {
					set flag 1
					gwd::GWpublic_print "NOK" "$printWord\mac地址$mac\的drop信息显示是[dict get $dTable $mac drop]" $fileId
				}
			}
        	} else {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord\没有mac=$mac\的转发表项" $fileId
        	}
        } else {
        	if {[dict exists $dTable $mac]} {
        		if {[string match -nocase $typename [dict get $dTable $mac portname]]} {
        			gwd::GWpublic_print "OK" "$printWord\mac地址$mac\的portname是$typename" $fileId
        		} else {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\mac地址$mac\的portname是[dict get $dTable $mac portname]" $fileId
        		}
        		if {[string match -nocase "static" [dict get $dTable $mac flag]]} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\mac地址$mac\显示是静态mac地址" $fileId
        		} elseif {[string match -nocase "none" [dict get $dTable $mac flag]]} {
        			gwd::GWpublic_print "OK" "$printWord\mac地址$mac\显示是动态学习到的mac地址" $fileId
        		} else {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\mac地址$mac\显示是[dict get $dTable $mac flag]的mac地址" $fileId
        		}
			if {![string match -nocase "none" [dict get $dTable $mac drop]]} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\mac地址$mac\的drop信息显示是[dict get $dTable $mac drop]" $fileId
			}
        	} else {
			if {![string match -nocase "pw" $type]} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\没有mac=$mac\的转发表项" $fileId
			}
        	}
        }
	return $flag

}
########################################################################################################
#函数功能：GPN上测试elan业务的AC和PW的动作
#输入参数:       Action ：VLAN动作类型 AC/PW
#               RunFlag ：调用函数标志位
#		matchPara：classificationStatisticsPortRxCnt4的匹配参数
#           hGPNPortGen ：发送数据流端口指针
#           hGPNPortAna ：接收数据流端口指针
#hGPNPortAnaFrameCfgFil ：配置分析器端口指针
#        anaFliFrameCfg ：配置分析器类型
#输出参数：无
#返回值： flag:数据流结果统计标志位
########################################################################################################
proc PTN_ElanActiveChange {Action RunFlag matchPara hGPNPortGen hGPNPortAna hGPNPortAnaFrameCfgFil anaFliFrameCfg caseId} {
	set flag 0
	global fileId
        foreach i "GPNPort12Cnt01 GPNPort12Cnt02 GPNPort5Cnt2" {
          array set $i {cnt01 0 cnt02 0 cnt1 0 cnt2 0 cnt5 0 cnt7 0 cnt12 0 cnt13 0 cnt14 0 cnt15 0 cnt16 0 cnt17 0 cnt18 0 cnt19 0 cnt22 0 cnt26 0 cnt66 0} 
        }
        if {$RunFlag!=3} {
                gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPortAnaFrameCfgFil $::anaFliFrameCfg0
		Recustomization 1 1 1 1 1 0
		gwd::Start_SendFlow $hGPNPortGen  $hGPNPortAna
		after 5000
		gwd::Stop_SendFlow $hGPNPortGen  $hGPNPortAna
		after 2000
		Recustomization 1 1 1 1 1 0
                gwd::Start_SendFlow $hGPNPortGen  $hGPNPortAna
                after 10000
		
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt4 0 $hGPNPortAna GPNPort12Cnt01]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 1 1 1 1 1 0
			after 5000
		}
                gwd::Stop_SendFlow $hGPNPortGen  $hGPNPortAna
        }
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $hGPNPortGen  $hGPNPortAna
	after 5000
	gwd::Stop_SendFlow $hGPNPortGen  $hGPNPortAna
	after 2000
	Recustomization 1 1 1 1 1 0
	
        gwd::Cfg_AnalyzerFrameCfgFilter $hGPNPortAnaFrameCfgFil $anaFliFrameCfg
	stc::perform saveasxml -fileName "007_3.xml"
	gwd::Start_CapAllData ::capArr $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
	gwd::Start_CapAllData ::capArr $::hGPNPort2Cap $::hGPNPort2CapAnalyzer
        gwd::Start_SendFlow $hGPNPortGen  $hGPNPortAna
        after 10000
        if {$RunFlag!=3} {
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt4 $matchPara $hGPNPortAna GPNPort12Cnt02]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 1 1 1 1 1 0
			after 5000
		}
        } else {
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt5 2 $hGPNPortAna GPNPort5Cnt2]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 1 1 1 1 1 0
			after 5000
		}
        }
        gwd::Stop_SendFlow $hGPNPortGen  $hGPNPortAna
	gwd::Stop_CapData $::hGPNPort1Cap 1 "$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap"
	gwd::Stop_CapData $::hGPNPort2Cap 1 "$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap"
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $fileId
        if {($RunFlag == 1) || ($RunFlag == 7)} {
		#AC/PW 动作不变 NE1--->NE2
		if {$RunFlag == 1} {
			if {$GPNPort12Cnt02(cnt12) < $::rateL || $GPNPort12Cnt02(cnt12) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到tag=800数据流的速率为$GPNPort12Cnt02(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到tag=800数据流的速率为$GPNPort12Cnt02(cnt12)，在$::rateL-$::rateR\范围内" $fileId
			}
		} else {
			if {$GPNPort12Cnt02(cnt17) < $::rateL || $GPNPort12Cnt02(cnt17) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\发送外层tag=800 内层tag=100 tpid=0x8100的数据流，\
					NE2($::gpnIp2)$::GPNTestEth2\收到外层tag=800 内层tag=100数据流的速率为$GPNPort12Cnt02(cnt17)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\发送外层tag=800 内层tag=100 tpid=0x8100的数据流，\
					NE2($::gpnIp2)$::GPNTestEth2\收到外层tag=800 内层tag=100数据流的速率为$GPNPort12Cnt02(cnt17)，在$::rateL-$::rateR\范围内" $fileId
			}
			if {$GPNPort12Cnt01(cnt12) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt12)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt12)" $fileId
			}
		}
		if {$GPNPort12Cnt01(cnt1)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\发送untag的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\发送untag的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt1)" $fileId
		}
		if {$GPNPort12Cnt01(cnt2)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\发送tag=500 tpid=8100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt2)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\发送tag=500 tpid=8100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt2)" $fileId
		}
		if {$GPNPort12Cnt01(cnt14)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=9100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt14)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=9100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt14)" $fileId
		}
        } elseif {($RunFlag == 2) || ($RunFlag == 8)} {
		#AC 动作为nochange NE2--->NE1
		if {$RunFlag == 2} {
			if {$GPNPort12Cnt02(cnt13) < $::rateL || $GPNPort12Cnt02(cnt13) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为nochange，NE2($::gpnIp2)$::GPNTestEth2\发送tag=800 tpid=0x8100的数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到tag=800数据流的速率为$GPNPort12Cnt02(cnt13)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为nochange，NE2($::gpnIp2)$::GPNTestEth2\发送tag=800 tpid=0x8100的数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到tag=800数据流的速率为$GPNPort12Cnt02(cnt13)，在$::rateL-$::rateR\范围内" $fileId
			}
		} else {
			if {$GPNPort12Cnt01(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为nochange，NE2($::gpnIp2)$::GPNTestEth2\发送tag=800 tpid=0x8100的数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为nochange，NE2($::gpnIp2)$::GPNTestEth2\发送tag=800 tpid=0x8100的数据流，NE1($::gpnIp1)\
					$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt13)" $fileId
			}
			if {$GPNPort12Cnt02(cnt26) < $::rateL || $GPNPort12Cnt02(cnt26) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为nochange，NE2($::gpnIp2)$::GPNTestEth2\发送外层tag=800 内层tag=100 tpid=0x8100的数据流，\
					NE1($::gpnIp1)$::GPNTestEth1\收到外层tag=800 内层tag=100的数据流的速率为$GPNPort12Cnt02(cnt26)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为nochange，NE2($::gpnIp2)$::GPNTestEth2\发送外层tag=800 内层tag=100 tpid=0x8100的数据流，\
					NE1($::gpnIp1)$::GPNTestEth1\收到外层tag=800 内层tag=100的数据流的速率为$GPNPort12Cnt02(cnt26)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort12Cnt01(cnt16)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为nochange，NE2($::gpnIp2)$::GPNTestEth2\发送tag=800 tpid=9100的数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt16)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为nochange，NE2($::gpnIp2)$::GPNTestEth2\发送tag=800 tpid=9100的数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt16)" $fileId
		}
		if {$GPNPort12Cnt01(cnt02)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为nochange，NE2($::gpnIp2)$::GPNTestEth2\发送tag=500 tpid=8100的数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt02)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为nochange，NE2($::gpnIp2)$::GPNTestEth2\发送tag=500 tpid=8100的数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt02)" $fileId
		}
		if {$GPNPort12Cnt01(cnt01)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为nochange，NE2($::gpnIp2)$::GPNTestEth2\发送untag的数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为nochange，NE2($::gpnIp2)$::GPNTestEth2\发送untag的数据流，NE1($::gpnIp1)\
				$::GPNTestEth1\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt01)" $fileId
		}
        } elseif {$RunFlag == 3} {
                if {$GPNPort5Cnt2(cnt7) < $::rateL1 || $GPNPort5Cnt2(cnt7) > $::rateR1} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\和NE2($::gpnIp2)$::GPNTestEth2互发tag=800的已知单播的数据流，\
				NE1($::gpnIp1)$::GPNTestEth5镜像NNI的数据，收到MPLS标签为100 1000的数据流速率为$GPNPort5Cnt2(cnt7)，没在$::rateL1-$::rateR1\范围内" $fileId
                } else {
			gwd::GWpublic_print "OK" "$Action\动作为nochange，NE1($::gpnIp1)$::GPNTestEth1\和NE2($::gpnIp2)$::GPNTestEth2互发tag=800的已知单播的数据流，\
				NE1($::gpnIp1)$::GPNTestEth5镜像NNI的数据，收到MPLS标签为100 1000的数据流速率为$GPNPort5Cnt2(cnt7)，在$::rateL1-$::rateR1\范围内" $fileId
                }
        } elseif {($RunFlag == 4) || ($RunFlag == 9)} {
		#动作为删除
		if {$RunFlag == 4} {
			if {$GPNPort12Cnt02(cnt18) < $::rateL || $GPNPort12Cnt02(cnt18) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为delete，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到untag数据流的速率为$GPNPort12Cnt02(cnt18)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为delete，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到untag数据流的速率为$GPNPort12Cnt02(cnt18)，在$::rateL-$::rateR\范围内" $fileId
			}
		} else {
			if {$GPNPort12Cnt01(cnt12) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为delete，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt12)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为delete，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt12)" $fileId
			}
			if {$GPNPort12Cnt02(cnt66) < $::rateL || $GPNPort12Cnt02(cnt66) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为delete，NE1($::gpnIp1)$::GPNTestEth1\发送外层tag=800内层tag=100 tpid=0x8100的数据流，\
					NE2($::gpnIp2)$::GPNTestEth2\收到tag=100的数据流的速率为$GPNPort12Cnt02(cnt66)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为delete，NE1($::gpnIp1)$::GPNTestEth1\发送外层tag=800内层tag=100 tpid=0x8100的数据流，\
					NE2($::gpnIp2)$::GPNTestEth2\收到tag=100的数据流的速率为$GPNPort12Cnt02(cnt66)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		
		if {$GPNPort12Cnt01(cnt1)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为delete，NE1($::gpnIp1)$::GPNTestEth1\发送untag的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为delete，NE1($::gpnIp1)$::GPNTestEth1\发送untag的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt1)" $fileId
		}
		if {$GPNPort12Cnt01(cnt2)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为delete，NE1($::gpnIp1)$::GPNTestEth1\发送tag=500 tpid=8100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt2)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为delete，NE1($::gpnIp1)$::GPNTestEth1\发送tag=500 tpid=8100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt2)" $fileId
		}
		if {$GPNPort12Cnt01(cnt14)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为delete，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=9100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt14)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为delete，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=9100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt14)" $fileId
		}
        } elseif {($RunFlag == 5) || ($RunFlag == 10)} {
		#动作为modify
		if {$RunFlag == 5} {
			if {$GPNPort12Cnt02(cnt14) < $::rateL || $GPNPort12Cnt02(cnt14) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为modify，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到tag=100的数据流的速率为$GPNPort12Cnt02(cnt14)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为modify，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到tag=100的数据流的速率为$GPNPort12Cnt02(cnt14)，在$::rateL-$::rateR\范围内" $fileId
			}
		} else {
			if {$GPNPort12Cnt01(cnt12) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为modify，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt12)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为modify，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt12)" $fileId
			}
			if {$GPNPort12Cnt02(cnt15) < $::rateL || $GPNPort12Cnt02(cnt15) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为modify，NE1($::gpnIp1)$::GPNTestEth1\发送外层tag=800内层tag=100 tpid=0x8100的数据流，\
					NE2($::gpnIp2)$::GPNTestEth2\收到外层tag=1000内层tag=100的数据流的速率为$GPNPort12Cnt02(cnt15)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为modify，NE1($::gpnIp1)$::GPNTestEth1\发送外层tag=800内层tag=100 tpid=0x8100的数据流，\
					NE2($::gpnIp2)$::GPNTestEth2\收到外层tag=1000内层tag=100的数据流的速率为$GPNPort12Cnt02(cnt15)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		if {$GPNPort12Cnt01(cnt1)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为modify，NE1($::gpnIp1)$::GPNTestEth1\发送untag的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为modify，NE1($::gpnIp1)$::GPNTestEth1\发送untag的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt1)" $fileId
		}
		if {$GPNPort12Cnt01(cnt2)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为modify，NE1($::gpnIp1)$::GPNTestEth1\发送tag=500 tpid=8100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt2)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为modify，NE1($::gpnIp1)$::GPNTestEth1\发送tag=500 tpid=8100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt2)" $fileId
		}
		if {$GPNPort12Cnt01(cnt14)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为modify，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=9100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt14)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为modify，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=9100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt14)" $fileId
		} 
        } elseif {($RunFlag == 6) || ($RunFlag == 11)} {
		if {$RunFlag == 6} {
			if {$GPNPort12Cnt02(cnt16) < $::rateL || $GPNPort12Cnt02(cnt16) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为add，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到内层tag=800外层tag=1000的数据流的速率为$GPNPort12Cnt02(cnt16)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为add，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到内层tag=800外层tag=1000的数据流的速率为$GPNPort12Cnt02(cnt16)，在$::rateL-$::rateR\范围内" $fileId
			} 
		} else {
			if {$GPNPort12Cnt01(cnt12) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为add，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt12)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为add，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=0x8100的数据流，NE2($::gpnIp2)\
					$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt12)" $fileId
			}
			if {$GPNPort12Cnt02(cnt5) < $::rateL || $GPNPort12Cnt02(cnt5) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\动作为add，NE1($::gpnIp1)$::GPNTestEth1\发送外层tag=800内层tag=100 tpid=0x8100的数据流，\
					NE2($::gpnIp2)$::GPNTestEth2\收到外层tag=1000内层tag=800的数据流的速率为$GPNPort12Cnt02(cnt5)，没在$::rateL-$::rateR\范围内" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\动作为add，NE1($::gpnIp1)$::GPNTestEth1\发送外层tag=800内层tag=100 tpid=0x8100的数据流，\
					NE2($::gpnIp2)$::GPNTestEth2\收到外层tag=1000内层tag=800的数据流的速率为$GPNPort12Cnt02(cnt5)，在$::rateL-$::rateR\范围内" $fileId
			}
		}
		
	 	if {$GPNPort12Cnt01(cnt1)!=0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$Action\动作为add，NE1($::gpnIp1)$::GPNTestEth1\发送untag的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为add，NE1($::gpnIp1)$::GPNTestEth1\发送untag的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt1)" $fileId
		}
		if {$GPNPort12Cnt01(cnt2)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为add，NE1($::gpnIp1)$::GPNTestEth1\发送tag=500 tpid=8100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt2)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为add，NE1($::gpnIp1)$::GPNTestEth1\发送tag=500 tpid=8100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt2)" $fileId
		}
		if {$GPNPort12Cnt01(cnt14)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\动作为add，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=9100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt14)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\动作为add，NE1($::gpnIp1)$::GPNTestEth1\发送tag=800 tpid=9100的数据流，NE2($::gpnIp2)\
				$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort12Cnt01(cnt14)" $fileId
		}
        }
	return $flag
}
########################################################################################################
#函数功能：GPN上测试etree业务的AC和PW的动作
#输入参数:       ifAc ：VLAN动作类型 AC/PW =1 ac动作    =0 pw动作
#               动作类型 ：add/nochange/delete/modify
#               lStream ：发送的数据流
#返回值：flag =0 业务验证正确   =1业务验证有误
#作者：吴军妮 
########################################################################################################
proc PTN_EtreeActiveChange {fileId ifAc action caseId rateL rateR} {
	global gpnIp1
	global gpnIp2
	global gpnIp3
	global gpnIp4
	global GPNTestEth1
	global GPNTestEth2
	global GPNTestEth3
	global GPNTestEth4
	set flag 0
	
	incr capId
	#分析单层vlan报文
	SendAndStat_ptn006 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
		$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $::anaFliFrameCfg1 $caseId
	#分析只匹配smac的报文
	SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
		$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $::anaFliFrameCfg0 $caseId
	#分析双层vlan报文
	SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
		$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt2 GPNPort2Cnt2 GPNPort3Cnt2 GPNPort4Cnt2 6 $::anaFliFrameCfg6 $caseId
	#分析untag报文
	SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
		$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 7 $::anaFliFrameCfg7 $caseId
	
	
        gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
        gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
        #NE1的接收
	if {($ifAc == 0) && [string match $action "add"]} {
		if {$GPNPort1Cnt2(cnt27) < $rateL || $GPNPort1Cnt2(cnt27) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE1($gpnIp1)$GPNTestEth1\
				收到外层tag=800内层tag=100的数据流的速率为$GPNPort1Cnt2(cnt27)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE1($gpnIp1)$GPNTestEth1\
				收到外层tag=800内层tag=100的数据流的速率为$GPNPort1Cnt2(cnt27)，在$rateL-$rateR\范围内" $fileId
		}
	} else {
		if {$GPNPort1Cnt1(cnt70) < $rateL || $GPNPort1Cnt1(cnt70) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE1($gpnIp1)$GPNTestEth1\
				收到tag=100的数据流的速率为$GPNPort1Cnt1(cnt70)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE1($gpnIp1)$GPNTestEth1\
				收到tag=100的数据流的速率为$GPNPort1Cnt1(cnt70)，在$rateL-$rateR\范围内" $fileId
		}
	}
        
        #NE2接收
        if {$GPNPort2Cnt0(cnt1) !=0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE2($gpnIp2)\
        		$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt1)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE2($gpnIp2)\
        		$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt1)" $fileId
        }
        if {$GPNPort2Cnt0(cnt14) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x9100)的未知单播数据流，NE2($gpnIp2)\
        		$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt14)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x9100)的未知单播数据流，NE2($gpnIp2)\
        		$GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt14)" $fileId
        }
	if {[string match $action "nochange"]} {
		if {$GPNPort2Cnt1(cnt69) < $rateL || $GPNPort2Cnt1(cnt69) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE2($gpnIp2)$GPNTestEth2\
				收到tag=100的数据流的速率为$GPNPort2Cnt1(cnt69)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE2($gpnIp2)$GPNTestEth2\
				收到tag=100的数据流的速率为$GPNPort2Cnt1(cnt69)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort2Cnt1(cnt14) < $rateL || $GPNPort2Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x8100)的未知单播，NE2($gpnIp2)$GPNTestEth2\
				收到tag=100的数据流的速率为$GPNPort2Cnt1(cnt14)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x8100)的未知单播，NE2($gpnIp2)$GPNTestEth2\
				收到tag=100的数据流的速率为$GPNPort2Cnt1(cnt14)，在$rateL-$rateR\范围内" $fileId
		}
	} else {
		if {$GPNPort2Cnt7(cnt48) < $rateL || $GPNPort2Cnt7(cnt48) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE2($gpnIp2)$GPNTestEth2\
				收到untag的数据流的速率为$GPNPort2Cnt7(cnt48)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE2($gpnIp2)$GPNTestEth2\
				收到untag的数据流的速率为$GPNPort2Cnt7(cnt48)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort2Cnt7(cnt18) < $rateL || $GPNPort2Cnt7(cnt18) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x8100)的未知单播，NE2($gpnIp2)$GPNTestEth2\
				收到untag的数据流的速率为$GPNPort2Cnt7(cnt18)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x8100)的未知单播，NE2($gpnIp2)$GPNTestEth2\
				收到untag的数据流的速率为$GPNPort2Cnt7(cnt18)，在$rateL-$rateR\范围内" $fileId
		}
	}
        
        #NE3的接收
        if {$GPNPort3Cnt0(cnt1) !=0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE3($gpnIp3)\
        		$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE3($gpnIp3)\
        		$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
        }
        if {$GPNPort3Cnt0(cnt14) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
        		$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt14)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
        		$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt14)" $fileId
        }
        if {$GPNPort3Cnt0(cnt13) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE1($gpnIp1)$GPNTestEth1\发送的数据流\
        		NE3($gpnIp3)$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt13)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE1($gpnIp1)$GPNTestEth1\发送的数据流\
        		NE3($gpnIp3)$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt13)" $fileId
        }
        if {$GPNPort3Cnt0(cnt70) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE2($gpnIp2)$GPNTestEth2\发送的数据流\
        		NE3($gpnIp3)$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt70)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE2($gpnIp2)$GPNTestEth2\发送的数据流\
        		NE3($gpnIp3)$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt70)" $fileId
        }
	if { [string match $action "add"] || [string match $action "modify"]} {
		if {$GPNPort3Cnt1(cnt12) < $rateL || $GPNPort3Cnt1(cnt12) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x8100)的未知单播，NE3($gpnIp3)$GPNTestEth3\
				收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt12)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x8100)的未知单播，NE3($gpnIp3)$GPNTestEth3\
				收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt12)，在$rateL-$rateR\范围内" $fileId
		}
	} else {
		if {$GPNPort3Cnt1(cnt14) < $rateL || $GPNPort3Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x8100)的未知单播，NE3($gpnIp3)$GPNTestEth3\
				收到tag=100的数据流的速率为$GPNPort3Cnt1(cnt14)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x8100)的未知单播，NE3($gpnIp3)$GPNTestEth3\
				收到tag=100的数据流的速率为$GPNPort3Cnt1(cnt14)，在$rateL-$rateR\范围内" $fileId
		}
	}
        
        #NE4的接收
        if {$GPNPort4Cnt0(cnt1) !=0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE4($gpnIp4)\
        		$GPNTestEth3\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送untag的未知单播数据流，NE4($gpnIp4)\
        		$GPNTestEth3\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
        }
        if {$GPNPort4Cnt0(cnt14) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
        		$GPNTestEth3\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt14)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
        		$GPNTestEth3\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt14)" $fileId
        }
        if {$GPNPort4Cnt0(cnt13) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE1($gpnIp1)$GPNTestEth1\发送的数据流\
        		NE4($gpnIp4)$GPNTestEth3\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt13)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE1($gpnIp1)$GPNTestEth1\发送的数据流\
        		NE4($gpnIp4)$GPNTestEth3\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt13)" $fileId
        }
        if {$GPNPort4Cnt0(cnt70) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE2($gpnIp2)$GPNTestEth2\发送的数据流\
        		NE4($gpnIp4)$GPNTestEth3\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt70)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\与NE2($gpnIp2)$GPNTestEth2互发tag=100的已知单播，NE2($gpnIp2)$GPNTestEth2\发送的数据流\
        		NE4($gpnIp4)$GPNTestEth3\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt70)" $fileId
        }
	if {($ifAc==1) && [string match $action "add"]} {
		if {$GPNPort4Cnt2(cnt1) < $rateL || $GPNPort4Cnt2(cnt1) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x8100)的未知单播，NE4($gpnIp4)$GPNTestEth3\
				收到内层tag=100外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt1)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x8100)的未知单播，NE4($gpnIp4)$GPNTestEth3\
				收到内层tag=100外层tag=800的数据流的速率为$GPNPort4Cnt2(cnt1)，在$rateL-$rateR\范围内" $fileId
		}
	} else {
		if {$GPNPort4Cnt1(cnt14) < $rateL || $GPNPort4Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x8100)的未知单播，NE4($gpnIp4)$GPNTestEth3\
				收到tag=100的数据流的速率为$GPNPort4Cnt1(cnt14)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=100(tpid=0x8100)的未知单播，NE4($gpnIp4)$GPNTestEth3\
				收到tag=100的数据流的速率为$GPNPort4Cnt1(cnt14)，在$rateL-$rateR\范围内" $fileId
		}
	}
        
	return $flag
}
########################################################################################################
#函数功能：GPN上测试elan业务与fdb互操作
#输入参数: printWord:打印的描述字符串
#          lExpect1：输入vplsName后查询到的转发表的期望输出
#          vplsName：vpls的名字
#          lExpect2：输入pwName后查询到的转发表的期望输出
#          pwName：pw的名字
#          lExpect3：输入acName后查询到的转发表的期望输出
#          acName：ac的名字
#	   attchPara：预留参数
#输出参数：flag:mac地址学习结果标志位
#返回值：     flag：0测试结果正确       1测试结果错误
#作者：吴军妮
########################################################################################################
proc PTN_ElanAndFdb {printWord lExpect1 vplsName lExpect2 pwName lExpect3 acName attchPara} {
	set flag 0
	gwd::GWpubic_queryVPLSForwardTable $::telnet1 $::matchType1 $::Gpn_type1 $::fileId "" "" $vplsName dTable1
	gwd::GWpubic_queryVPLSForwardTable $::telnet1 $::matchType1 $::Gpn_type1 $::fileId "pw" $pwName $vplsName dTable2
	gwd::GWpubic_queryVPLSForwardTable $::telnet1 $::matchType1 $::Gpn_type1 $::fileId "ac" $acName $vplsName dTable3
	foreach dTable "\"$dTable1\" \"$dTable2\" \"$dTable3\"" lExpect "\"$lExpect1\" \"$lExpect2\" \"$lExpect3\"" printName "$vplsName $pwName $acName" \
		describe "根据vpls的名字$vplsName\查看mac地址转发表  根据pw的名字$pwName\查看mac地址转发表   根据ac的名字$acName\查看mac地址转发表" {
        	dict for {mac value} $lExpect {
        		if {[dict exists $dTable $mac]} {
        			if {[string match -nocase [dict get $value portname] [dict get $dTable $mac portname]]} {
        				gwd::GWpublic_print "OK" "$printWord$describe\，NE1($::gpnIp1)上mac地址$mac\学习到了[dict get $value portname]上" $::fileId
        			} else {
        				set flag 1
        				gwd::GWpublic_print "NOK" "$printWord$describe\，NE1($::gpnIp1)上mac地址$mac\学习到了[dict get $dTable $mac portname]上" $::fileId
        			}
        		} else {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord$describe\，$printName上没有mac=$mac\的转发表项" $::fileId
        		}
        	}
	}
	return $flag
}
########################################################################################################
#函数功能：GPN上trunk组模式测试
#输入参数: ModeFlag:策略类型 share lag1:1 Lacp
#	      portlist:trunk成员组列表
#         testPort1：DEV1添加删除up、down 端口
#         testPort2：DEV2添加删除up、down 端口
#	  trafficType:业务类型，=elan/etree
#输出参数：无
#返回值：flag
#作者：吴军妮
########################################################################################################
proc PTN_TrunkMode {spawn_id matchType dutType fileId caseId id ModeFlag trunKName portlist testPort1 testPort2 trafficType} {
	set flag 0
	global capId
	global trunkSwTime
	###得到trunk组成员的主端口和从端口，端口号小的口是主端口------
	regexp {(\d+)/(\d+)} [lindex $portlist 0] match slot1 port1
	regexp {(\d+)/(\d+)} [lindex $portlist 1] match slot2 port2
	if {($slot1 < $slot2) || (($slot1 == $slot2) && ($port1 < $port2))} {
		set masterPort $slot1/$port1
		set standPort $slot2/$port2
	} else {
		set masterPort $slot2/$port2
		set standPort $slot1/$port1
	}
	##------得到trunk组成员的主端口和从端口，端口号小的口是主端口
	set TestTrafficFunc [expr {([string match -nocase "elan" $trafficType]) ? "PTN_TrunkStream_elan" : "PTN_TrunkStream_etree"}]
	incr capId
	if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk组$trunKName\模式为$ModeFlag\时"]} {
		set flag 1
	}
	foreach hCfgFil $::hGPNPortAnaFrameCfgFilList {
		gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $::anaFliFrameCfg1
	}
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	after 5000
	gwd::Stop_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	after 2000
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	after 10000
	#主从端口down、up测试倒换时间------
	foreach i "aGPNPort5Cnt1 aGPNPort3Cnt1" {
		array set $i {cnt12 0 drop12 0 rate12 0 cnt13 0 drop13 0 rate13 0 cnt19 0 drop19 0 rate19 0} 
	}
        foreach eth $portlist {
        	for {set i 1} {$i<$::ptn008_case2_cnt} {incr i} {
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt4 3 $::hGPNPort5Ana aGPNPort5Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 1 1 1 1 1 0
				after 5000
			}
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt4 3 $::hGPNPort3Ana aGPNPort3Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 1 1 1 1 1 0
				after 5000
			}
                	set FrameRate11 $aGPNPort3Cnt1(rate12)
                	set DropFrame11 $aGPNPort3Cnt1(drop12)
        		set FrameRate31 $aGPNPort5Cnt1(rate19)
                	set DropFrame31 $aGPNPort5Cnt1(drop19)
                        send_log "\nFrameRate11:$FrameRate11"
                        send_log "\nFrameRate31:$FrameRate31"
                        send_log "\nDropFrame11:$DropFrame11"
                        send_log "\nDropFrame31:$DropFrame31"
			gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth "shutdown"
			after 5000
			gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth "undo shutdown"
			after 5000
			set filterCnt 0
			classificationStatisticsPortRxCnt4 3 $::hGPNPort5Ana aGPNPort5Cnt1
			classificationStatisticsPortRxCnt4 3 $::hGPNPort3Ana aGPNPort3Cnt1
			set FrameRate12 $aGPNPort3Cnt1(rate12)
			set DropFrame12 $aGPNPort3Cnt1(drop12)
			set FrameRate32 $aGPNPort5Cnt1(rate19)
			set DropFrame32 $aGPNPort5Cnt1(drop19)
			send_log "\nFrameRate12:$FrameRate12"
			send_log "\nFrameRate32:$FrameRate32"
			send_log "\nDropFrame12:$DropFrame12"
			send_log "\nDropFrame32:$DropFrame32"
			set DhTime1 -1
			set DhTime3 -1
			if {[string match "$masterPort" $eth]} {
				set printWord "主端口" 
			} else {
				set printWord "从端口"
			}
			if {$FrameRate31!=0} {
				set DhTime3 [expr ($DropFrame32-$DropFrame31)*1000/$FrameRate31]
				if {$DhTime3>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$eth\down和up操作后，接收倒换时间为$DhTime3\ms大于最大允许倒换时间$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "第$i\次$matchType trunk组$trunKName$printWord$eth\down和up操作后，接收倒换时间为$DhTime3\ms小于最大允许倒换时间$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$eth\down和up操作后业务不通，无法测试接收倒换时间" $fileId
			}
			if {$FrameRate11!=0} {
				set DhTime1 [expr ($DropFrame12-$DropFrame11)*1000/$FrameRate11]
				if {$DhTime1>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$eth\down和up操作后，发送倒换时间为$DhTime1\ms大于最大允许倒换时间$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "第$i\次$matchType trunk组$trunKName$printWord$eth\down和up操作后，发送倒换时间为$DhTime1\ms小于最大允许倒换时间$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$eth\down和up操作后业务不通，无法测试发送倒换时间" $fileId
			}
		}
	}
	#------主从端口down、up测试倒换时间
	#shudown trunk组的所有成员，测试业务------
	lassign $portlist eth1 eth2
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth1 "shutdown"
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth2 "shutdown"
	after 5000
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	after 5000
	gwd::Stop_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	after 2000
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	foreach i "aGPNPort1Cnt1 aGPNPort2Cnt1 aGPNPort3Cnt1" {
		array set $i {cnt12 0 drop12 0 rate12 0 cnt13 0 drop13 0 rate13 0 cnt19 0 drop19 0 rate19 0} 
	}
	if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $::hGPNPort5Cap $::hGPNPort5CapAnalyzer
		gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 3 $::hGPNPort5Ana aGPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 3 $::hGPNPort3Ana aGPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
		
	parray aGPNPort5Cnt1
	parray aGPNPort3Cnt1
	incr capId
	if {$::cap_enable} {
		gwd::Stop_CapData $::hGPNPort5Cap 1 "$caseId\_$capId-p$::GPNTestEth5_cap\($::gpnIp1\).pcap"	
		gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap"
	}
	gwd::Stop_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	gwd::GWpublic_print "  " "抓包文件为$caseId\_$capId-p$::GPNTestEth5_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
	if {$aGPNPort5Cnt1(cnt19) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时shutdownTRUNK组所有端口成员NE3($::gpnIp3)$::GPNTestEth3\
			发送tag=800的数据流，NE1($::gpnIp1)$::GPNTestEth5\收到tag=800的数据流的速率应为0实为$aGPNPort5Cnt1(cnt19)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时shutdownTRUNK组所有端口成员NE3($::gpnIp3)$::GPNTestEth3\
			发送tag=800的数据流，NE1($::gpnIp1)::GPNTestEth5\收到tag=800的数据流的速率应为0实为$aGPNPort5Cnt1(cnt19)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt12) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时shutdownTRUNK组所有端口成员NE1($::gpnIp1)$::GPNTestEth1\
			发送tag=800的数据流，NE3($::gpnIp3)$::GPNTestEth3\收到tag=800的数据流的速率应为0实为$aGPNPort3Cnt1(cnt12)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时shutdownTRUNK组所有端口成员NE1($::gpnIp1)$::GPNTestEth1\
			发送tag=800的数据流，NE3($::gpnIp3)$::GPNTestEth3\收到tag=800的数据流的速率应为0实为$aGPNPort3Cnt1(cnt12)" $fileId
	}
	#------shudown trunk组的所有成员，测试业务	
	foreach port1 "$eth1 $eth2" port2 "$eth2 $eth1" {
		gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $port1 "undo shutdown"
		gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $port2 "shutdown"
		after 5000
		incr capId
		if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk组$trunKName\模式为$ModeFlag\时trunk组端口$port1 up $port2 down "]} {
			set flag 1
		}
	}
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth1 "undo shutdown"
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth2 "undo shutdown"
	after 5000
	#trunk组中添加删除down端口------lag1:1和lag1+1不测试，应为这两种模式trunk组中的端口固定为2个，也不能多也不能少
	if {![string match "lag1:1" $ModeFlag] && ![string match "lag1+1" $ModeFlag]} {
		if {[string match "L3" $::trunkLevel]} {
			gwd::GWL2_AddPort $::telnet1 $::matchType1 $::Gpn_type1 $fileId $::downPort_dev1 "disable" "disable"
			gwd::GWL2_AddPort $::telnet2 $::matchType2 $::Gpn_type2 $fileId $::downPort_dev2 "disable" "disable"
		} elseif {[string match "L2" $::trunkLevel]&&[string match "L3" $::Worklevel]} {
			gwd::GWL2_AddPort $::telnet1 $::matchType1 $::Gpn_type1 $fileId $::downPort_dev1 "disable" "enable"
			gwd::GWL2_AddPort $::telnet2 $::matchType2 $::Gpn_type2 $fileId $::downPort_dev2 "disable" "enable"
		}
        	if {[string match "static" $ModeFlag]} {
        		gwd::GWTrunk_AddInfo $::telnet1 $::matchType1 $::Gpn_type1 $fileId $trunKName "static" $::downPort_dev1
        		gwd::GWTrunk_AddInfo $::telnet2 $::matchType2 $::Gpn_type2 $fileId $trunKName "static" $::downPort_dev2
        	} else {
        		gwd::GWTrunk_AddInfo $::telnet1 $::matchType1 $::Gpn_type1 $fileId $trunKName "" $::downPort_dev1
        		gwd::GWTrunk_AddInfo $::telnet2 $::matchType2 $::Gpn_type2 $fileId $trunKName "" $::downPort_dev2
        	}
        	incr capId
        	if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk组$trunKName\模式为$ModeFlag\新添加一个down端口$::downPort_dev1\后"]} {
        		set flag 1
        	}
        	if {[string match "static" $ModeFlag]} {
        		gwd::GWpublic_delPortFromStaticTrunk $::telnet1 $::matchType1 $::Gpn_type1 $fileId $trunKName $::downPort_dev1
        		gwd::GWpublic_delPortFromStaticTrunk $::telnet2 $::matchType2 $::Gpn_type2 $fileId $trunKName $::downPort_dev2
        	} else {
        		gwd::GWpublic_delPortFromTrunk $::telnet1 $::matchType1 $::Gpn_type1 $fileId $trunKName $::downPort_dev1
        		gwd::GWpublic_delPortFromTrunk $::telnet2 $::matchType2 $::Gpn_type2 $fileId $trunKName $::downPort_dev2
        	}
        	incr capId
        	if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk组$trunKName\模式为$ModeFlag\删除一个down端口$::downPort_dev1\后"]} {
        		set flag 1
        	}
		if {[string match "L3" $::Worklevel]} {
			gwd::GWL2_AddPort $::telnet1 $::matchType1 $::Gpn_type1 $fileId $::downPort_dev1 "enable" "disable"
			gwd::GWL2_AddPort $::telnet2 $::matchType2 $::Gpn_type2 $fileId $::downPort_dev2 "enable" "disable"
		}
        	#------trunk组中添加删除down端口
        	
        	#trunk组中添加删除up端口------lag1:1和lag1+1不测试，应为这两种模式trunk组中的端口固定为2个，也不能多也不能少
		gwd::GWpublic_CfgPortState $::telnet1 $::matchType1 $::Gpn_type1 $fileId $testPort1 "undo shutdown"
		if {[string match "L2" $::trunkLevel]&&[string match "L3" $::Worklevel]} {
			gwd::GWL2_AddPort $::telnet1 $::matchType1 $::Gpn_type1 $fileId $testPort1 "disable" "enable"
			gwd::GWL2_AddPort $::telnet2 $::matchType2 $::Gpn_type2 $fileId $testPort2 "disable" "enable"
		} elseif {[string match "L3" $::trunkLevel]} {
			gwd::GWL2_AddPort $::telnet1 $::matchType1 $::Gpn_type1 $fileId $testPort1 "disable" "disable"
			gwd::GWL2_AddPort $::telnet2 $::matchType2 $::Gpn_type2 $fileId $testPort2 "disable" "disable"
		}
        	after 10000
        	if {[string match "static" $ModeFlag]} {
        		gwd::GWTrunk_AddInfo $::telnet1 $::matchType1 $::Gpn_type1 $fileId $trunKName "static" $testPort1
        		gwd::GWTrunk_AddInfo $::telnet2 $::matchType2 $::Gpn_type2 $fileId $trunKName "static" $testPort2
        	} else {
        		gwd::GWTrunk_AddInfo $::telnet1 $::matchType1 $::Gpn_type1 $fileId $trunKName "" $testPort1
        		gwd::GWTrunk_AddInfo $::telnet2 $::matchType2 $::Gpn_type2 $fileId $trunKName "" $testPort2
        	}
        	incr capId
        	if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk组$trunKName\模式为$ModeFlag\新添加一个up端口$testPort1\后"]} {
        		set flag 1
        	}
        	if {[string match "static" $ModeFlag]} {
        		gwd::GWpublic_delPortFromStaticTrunk $::telnet1 $::matchType1 $::Gpn_type1 $fileId $trunKName $testPort1
        		gwd::GWpublic_delPortFromStaticTrunk $::telnet2 $::matchType2 $::Gpn_type2 $fileId $trunKName $testPort2
        	} else {
        		gwd::GWpublic_delPortFromTrunk $::telnet1 $::matchType1 $::Gpn_type1 $fileId $trunKName $testPort1
        		gwd::GWpublic_delPortFromTrunk $::telnet2 $::matchType2 $::Gpn_type2 $fileId $trunKName $testPort2
        	}
        	incr capId
        	if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk组$trunKName\模式为$ModeFlag\删除一个up端口$testPort1\后"]} {
        		set flag 1
        	}
        	gwd::GWpublic_CfgPortState $::telnet1 $::matchType1 $::Gpn_type1 $fileId $testPort1 "shutdown"
		if {[string match "L3" $::Worklevel]} {
			gwd::GWL2_AddPort $::telnet1 $::matchType1 $::Gpn_type1 $fileId $testPort1 "enable" "disable"
			gwd::GWL2_AddPort $::telnet2 $::matchType2 $::Gpn_type2 $fileId $testPort2 "enable" "disable"
		}
        	#------trunk组中添加删除up端口
	}
	if {![string match -nocase "elan" $trafficType]} {
        	#反复reboot NNI口所在板卡----
        	for {set j 1} {$j<=$::cnt} {incr j} {
        		gwd::GWCard_AddReboot $spawn_id $matchType $dutType $fileId $::rebootSlot1
        		if {[string match $::mslot1 $::rebootSlot1]} {
        		        after $::rebootBoardTime
        		        set spawn_id [gwd::GWpublic_loginGpn $::gpnIp1 $::userName1 $::password1 $matchType $dutType $fileId]
        		        set ::lSpawn_id [lreplace $::lSpawn_id 0 0 $spawn_id]
        		        gwd::GWCard_AddReboot $spawn_id $matchType $dutType $fileId $::rebootSlot2
        		} else {
        		        gwd::GWCard_AddReboot $spawn_id $matchType $dutType $fileId $::rebootSlot2
        		}
        		after $::rebootBoardTime
        		if {[string match $::mslot1 $::rebootSlot2]} {
                                set spawn_id [gwd::GWpublic_loginGpn $::gpnIp1 $::userName1 $::password1 $matchType $dutType $fileId]
                                set ::lSpawn_id [lreplace $::lSpawn_id 0 0 $spawn_id]
        		}
        		incr capId
        		if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk组$trunKName\模式为$ModeFlag，第$j\次重启NE1($::gpnIp1)$::rebootSlot1 $::rebootSlot2\槽位板卡后"]} {
        			set flag 1
        		}
        	}
        	#----反复reboot NNI口所在板卡
        	#反复NMS主备倒换------
        	for {set j 1} {$j<$::cntdh} {incr j} {
        		if {![gwd::GWCard_AddSwitch $spawn_id $matchType $dutType $fileId]} {
        			after $::rebootTime
        			set spawn_id [gwd::GWpublic_loginGpn $::gpnIp1 $::userName1 $::password1 $matchType $dutType $fileId]
        			set ::lSpawn_id [lreplace $::lSpawn_id 0 0 $spawn_id]
        			incr capId
        			if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk组$trunKName\模式为$ModeFlag\，第$j\次 NE1($::gpnIp1)进行NMS主备倒换后"]} {
        				set flag 1
        			}
        		} else {
        			gwd::GWpublic_print "OK" "$matchType\只有一个主控盘，测试跳过" $fileId
        			break
        		}
        	}
        	#------反复NMS主备倒换
        	#反复NMS主备倒换------
        	for {set j 1} {$j<$::cntdh} {incr j} {
        		if {![gwd::GWCard_AddSwitchSw $spawn_id $matchType $dutType $fileId]} {
        			after $::rebootTime
        			set spawn_id [gwd::GWpublic_loginGpn $::gpnIp1 $::userName1 $::password1 $matchType $dutType $fileId]
        			set ::lSpawn_id [lreplace $::lSpawn_id 0 0 $spawn_id]
        			incr capId
        			if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk组$trunKName\模式为$ModeFlag\，第$j\次 NE1($::gpnIp1)进行SW主备倒换后"]} {
        				set flag 1
        			}
        		} else {
        			gwd::GWpublic_print "OK" "$matchType\只有一个SW盘，测试跳过" $fileId
        			break
        		}
        	}
        	#------反复NMS主备倒换
        	set ::telnet1 $spawn_id
	}
	return $flag

}
########################################################################################################
#函数功能：ELAN与trunk互操作中业务转发的测试
#输入参数: 
#         RunFlag:不同类型标志位
#         hGPNPortAna1:发流的端口1
#         hGPNPortAna2:发流的端口2
#输出参数：flag：数据流判断结果标志位
#返回值： 无
#作者：吴军妮/dj
########################################################################################################
proc PTN_TrunkStream_elan {fileId caseId printWord} {
	set flag 0
	foreach i "GPNPort5Cnt1 GPNPort2Cnt1 GPNPort3Cnt1" {
		array set $i {cnt12 0 drop12 0 rate12 0 cnt13 0 drop13 0 rate13 0 cnt19 0 drop19 0 rate19 0} 
	}
	foreach hCfgFil $::hGPNPortAnaFrameCfgFilList {
		gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $::anaFliFrameCfg1
	}
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	after 5000
	gwd::Stop_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	after 2000
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	after 10000
	
	if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $::hGPNPort5Cap $::hGPNPort5CapAnalyzer
		gwd::Start_CapAllData ::capArr $::hGPNPort2Cap $::hGPNPort2CapAnalyzer
		gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 3 $::hGPNPort5Ana GPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 3 $::hGPNPort2Ana GPNPort2Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 3 $::hGPNPort3Ana GPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort5Cnt1
	parray GPNPort2Cnt1
	parray GPNPort3Cnt1
	if {$::cap_enable} {
		gwd::Stop_CapData $::hGPNPort5Cap 1 "$caseId-p$::GPNTestEth5_cap\($::gpnIp1\).pcap"	
		gwd::Stop_CapData $::hGPNPort2Cap 1 "$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap"
		gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap"
	}
	gwd::Stop_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth5_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
	if {$GPNPort5Cnt1(cnt13) < $::rateL || $GPNPort5Cnt1(cnt13) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的数据流，NE1($::gpnIp1)\
			$::GPNTestEth5\收到tag=800的数据流的速率为$GPNPort5Cnt1(cnt13)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的数据流，NE1($::gpnIp1)\
			$::GPNTestEth5\收到tag=800的数据流的速率为$GPNPort5Cnt1(cnt13)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort5Cnt1(cnt19) < $::rateL || $GPNPort5Cnt1(cnt19) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE1($::gpnIp1)\
			$::GPNTestEth5\收到tag=800的数据流的速率为$GPNPort5Cnt1(cnt19)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE1($::gpnIp1)\
			$::GPNTestEth5\收到tag=800的数据流的速率为$GPNPort5Cnt1(cnt19)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt1(cnt12) < $::rateL || $GPNPort2Cnt1(cnt12) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\发送tag=800的数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\发送tag=800的数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt12)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt1(cnt19) < $::rateL || $GPNPort2Cnt1(cnt19) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt19)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt19)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt1(cnt12) < $::rateL || $GPNPort3Cnt1(cnt12) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\发送tag=800的数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\发送tag=800的数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt12)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt1(cnt13) < $::rateL || $GPNPort3Cnt1(cnt13) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt13)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt13)，在$::rateL-$::rateR\范围内" $fileId
	}
	return $flag
}
########################################################################################################
#函数功能：ELAN与trunk互操作中业务转发的测试
#输入参数: 
#         RunFlag:不同类型标志位
#         hGPNPortAna1:发流的端口1
#         hGPNPortAna2:发流的端口2
#输出参数：flag：数据流判断结果标志位
#返回值： 无
#作者：吴军妮/dj
########################################################################################################
proc PTN_TrunkStream_etree {fileId caseId printWord} {
	set flag 0
	foreach i "GPNPort5Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort5Cnt0 GPNPort2Cnt0 GPNPort3Cnt0" {
		array set $i {cnt12 0 drop12 0 rate12 0 cnt13 0 drop13 0 rate13 0 cnt19 0 drop19 0 rate19 0 cnt16 0} 
	}
	foreach hCfgFil $::hGPNPortAnaFrameCfgFilList {
		gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $::anaFliFrameCfg1
	}
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	after 5000
	gwd::Stop_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	after 2000
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $::hGPNPort5Cap $::hGPNPort5CapAnalyzer
		gwd::Start_CapAllData ::capArr $::hGPNPort2Cap $::hGPNPort2CapAnalyzer
		gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
	}
	after 10000
	if {$::cap_enable} {
		gwd::Stop_CapData $::hGPNPort5Cap 1 "$caseId-p$::GPNTestEth5_cap\($::gpnIp1\).pcap"	
		gwd::Stop_CapData $::hGPNPort2Cap 1 "$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap"
		gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap"
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 3 $::hGPNPort5Ana GPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 3 $::hGPNPort2Ana GPNPort2Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 3 $::hGPNPort3Ana GPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	gwd::Stop_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	foreach hCfgFil $::hGPNPortAnaFrameCfgFilList {
		gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $::anaFliFrameCfg0
	}
	after 2000
	gwd::Start_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	after 10000
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 0 $::hGPNPort5Ana GPNPort5Cnt0]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 0 $::hGPNPort2Ana GPNPort2Cnt0]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt4 0 $::hGPNPort3Ana GPNPort3Cnt0]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	gwd::Stop_SendFlow $::hGPNPortGenList1  $::hGPNPortAnaList1
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth5_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
	if {$GPNPort5Cnt1(cnt13) < $::rateL || $GPNPort5Cnt1(cnt13) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的数据流，NE1($::gpnIp1)\
			$::GPNTestEth5\收到tag=800的数据流的速率为$GPNPort5Cnt1(cnt13)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的数据流，NE1($::gpnIp1)\
			$::GPNTestEth5\收到tag=800的数据流的速率为$GPNPort5Cnt1(cnt13)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort5Cnt1(cnt19) < $::rateL || $GPNPort5Cnt1(cnt19) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE1($::gpnIp1)\
			$::GPNTestEth5\收到tag=800的数据流的速率为$GPNPort5Cnt1(cnt19)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE1($::gpnIp1)\
			$::GPNTestEth5\收到tag=800的数据流的速率为$GPNPort5Cnt1(cnt19)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt1(cnt12) < $::rateL || $GPNPort2Cnt1(cnt12) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\发送tag=800的数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\发送tag=800的数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt12)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort2Cnt0(cnt16)!= 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt16)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\发送tag=800的数据流，NE2($::gpnIp2)\
			$::GPNTestEth2\收到数据流的速率应为0实为$GPNPort2Cnt0(cnt16)" $fileId
	}
	if {$GPNPort3Cnt1(cnt12) < $::rateL || $GPNPort3Cnt1(cnt12) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\发送tag=800的数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt12)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\发送tag=800的数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt12)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt0(cnt13) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt13)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\发送tag=800的数据流，NE3($::gpnIp3)\
			$::GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt13)" $fileId
	}
	return $flag
}


########################################################################################################
#函数功能：GPN上trunk组模式数据流测试
#输入参数:runFlag:不同类型标志位  =0 不检查另另一条eLAN业务，=1检查另一条ELAN业务
#  anaFliFrameCfg:分析器类型
#              id:数据流判断类别
#输出参数：flag1：数据流判断结果标志位1
#          flag2：数据流判断结果标志位2
#返回值： 无
#作者：吴军妮
########################################################################################################
proc PTN_Stability {spawn_id matchType dutType fileId runFlag printWord anaFliFrameCfg caseId rateL rateR rateL1 rateR1} {
	set flag 0
	global gpnIp1
	global gpnIp2
	global gpnIp3
	global gpnIp4
	global GPNTestEth1
	global GPNTestEth2
	global GPNTestEth3
	global GPNTestEth4
	
	gwd::GWmanage_GetSystemResource $spawn_id $matchType $dutType $fileId "" resource1
	gwd::Start_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	after 10000
	SendAndStat9 $anaFliFrameCfg 1 GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 $caseId
        parray GPNPort1Cnt1
        parray GPNPort2Cnt1
        parray GPNPort3Cnt1
        parray GPNPort4Cnt1
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	set addPrint ""
	if {$runFlag != 0} {
		set addPrint "已存在ELAN业务："
	}
	if {$GPNPort2Cnt1(cnt2) < $rateL || $GPNPort2Cnt1(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord$addPrint\NE1($gpnIp1)$GPNTestEth1\发送tag=800的已知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord$addPrint\NE1($gpnIp1)$GPNTestEth1\发送tag=800的已知单播数据流，NE2($gpnIp2)\
			$GPNTestEth2\收到tag=800的数据流的速率为$GPNPort2Cnt1(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt1(cnt6) < $rateL || $GPNPort3Cnt1(cnt6) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord$addPrint\NE1($gpnIp1)$GPNTestEth1\发送tag=800的已知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt6)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord$addPrint\NE1($gpnIp1)$GPNTestEth1\发送tag=800的已知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=800的数据流的速率为$GPNPort3Cnt1(cnt6)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt1(cnt9) < $rateL1 || $GPNPort4Cnt1(cnt9) > $rateR1} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord$addPrint\NE1($gpnIp1)$GPNTestEth1\发送tag=800的已知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt9)，没在$rateL1-$rateR1\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord$addPrint\NE1($gpnIp1)$GPNTestEth1\发送tag=800的已知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=800的数据流的速率为$GPNPort4Cnt1(cnt9)，在$rateL1-$rateR1\范围内" $fileId
	}
	if {$GPNPort1Cnt1(cnt22) < $rateL || $GPNPort1Cnt1(cnt22) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord$addPrint\NE2($gpnIp2)$GPNTestEth2\发送tag=800的已知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt22)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord$addPrint\NE2($gpnIp2)$GPNTestEth2\发送tag=800的已知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt22)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt1(cnt33) < $rateL || $GPNPort1Cnt1(cnt33) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord$addPrint\NE3($gpnIp3)$GPNTestEth3\发送tag=800的已知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt33)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord$addPrint\NE3($gpnIp3)$GPNTestEth3\发送tag=800的已知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt33)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt1(cnt44) < $rateL || $GPNPort1Cnt1(cnt44) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord$addPrint\NE4($gpnIp4)$GPNTestEth4\发送tag=800的已知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt44)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord$addPrint\NE4($gpnIp4)$GPNTestEth4\发送tag=800的已知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=800的数据流的速率为$GPNPort1Cnt1(cnt44)，在$rateL-$rateR\范围内" $fileId
	}
	if {$runFlag == 2} {
		if {$GPNPort2Cnt1(cnt11) < $rateL || $GPNPort2Cnt1(cnt11) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\新建[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]业务：NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt11)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\新建[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]业务：NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE2($gpnIp2)\
				$GPNTestEth2\收到tag=500的数据流的速率为$GPNPort2Cnt1(cnt11)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort3Cnt1(cnt12) < $rateL || $GPNPort3Cnt1(cnt12) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\新建[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]业务：NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt12)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\新建[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]业务：NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE3($gpnIp3)\
				$GPNTestEth3\收到tag=500的数据流的速率为$GPNPort3Cnt1(cnt12)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort4Cnt1(cnt13) < $rateL1 || $GPNPort4Cnt1(cnt13) > $rateR1} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\新建[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]业务：NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到tag=500的数据流的速率为$GPNPort4Cnt1(cnt13)，没在$rateL1-$rateR1\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\新建[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]业务：NE1($gpnIp1)$GPNTestEth1\发送tag=500的已知单播数据流，NE4($gpnIp4)\
				$GPNTestEth4\收到tag=500的数据流的速率为$GPNPort4Cnt1(cnt13)，在$rateL1-$rateR1\范围内" $fileId
		}
		if {$GPNPort1Cnt1(cnt14) < $rateL || $GPNPort1Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\新建[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]业务：NE2($gpnIp2)$GPNTestEth2\发送tag=500的已知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt14)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\新建[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]业务：NE2($gpnIp2)$GPNTestEth2\发送tag=500的已知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt14)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort1Cnt1(cnt15) < $rateL || $GPNPort1Cnt1(cnt15) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\新建[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]业务：NE3($gpnIp3)$GPNTestEth3\发送tag=500的已知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt15)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\新建[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]业务：NE3($gpnIp3)$GPNTestEth3\发送tag=500的已知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt15)，在$rateL-$rateR\范围内" $fileId
		}
		if {$GPNPort1Cnt1(cnt16) < $rateL || $GPNPort1Cnt1(cnt16) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\新建[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]业务：NE4($gpnIp4)$GPNTestEth4\发送tag=500的已知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt16)，没在$rateL-$rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\新建[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]业务：NE4($gpnIp4)$GPNTestEth4\发送tag=500的已知单播数据流，NE1($gpnIp1)\
				$GPNTestEth1\收到tag=500的数据流的速率为$GPNPort1Cnt1(cnt16)，在$rateL-$rateR\范围内" $fileId
		}
	}
	gwd::GWmanage_GetSystemResource $spawn_id $matchType $dutType $fileId "" resource2
	send_log "\n resource1:$resource1"
	send_log "\n resource2:$resource2"
	set cpu1 [dget $resource1 pCPU]
	set cpu2 [dget $resource2 pCPU]
	if {$cpu1 == "" || [string match $cpu1 null]} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\之前系统CPU利用率获取失败，无法测试cpu利用率的变化" $fileId
		
	} elseif {$cpu2 == "" || [string match $cpu2 null]} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\之后系统CPU利用率获取失败，无法测试cpu利用率的变化" $fileId
	} else {
        	if {$cpu2 > [expr $cpu1 + $cpu1 * $::errRate]} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord\之前系统CPU利用率为$cpu1%，之后CPU利用率为$cpu2%。CPU利用率变化不在允许误差$::errRate\内" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord\之前系统CPU利用率为$cpu1%，之后CPU利用率为$cpu2%。CPU利用率变化在允许误差$::errRate\内" $fileId
        	}
	}
	gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	return $flag
}
########################################################################################################
#函数功能：ETree:一个vsi满配ac测试
#输入参数:printWord:report中打印的测试说明
#expStartVid2 expEndVid2 = 0时将expStartVid1 expEndVid1赋值给expStartVid2 expEndVid2
#输出参数：无
#返回值： flag
########################################################################################################
proc PTN_PWACVPLSCnt {printWord expectList1 expectList2 caseId} {
	global fileId
	set flag 0
	set resultList1 ""
	set resultList2 ""
	###开始抓包
	if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
		gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
	}
	gwd::Start_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort1Ana"
	after 10000
	gwd::Stop_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort1Ana"
	gwd::Start_SendFlow "$::hGPNPort1Gen $::hGPNPort3Gen"  "$::hGPNPort1Ana $::hGPNPort3Ana"
	after 30000
	###停止抓包
	if {$::cap_enable} {
        	gwd::Stop_CapData $::hGPNPort1Cap 1 "$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap"
        	gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap"
	}
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
	set totalPage [stc::get $::hGPNPort1RxInfo1 -TotalPageCount]
        for {set pageNum 1} {$pageNum <= $totalPage} {incr pageNum} {
        	stc::config $::hGPNPort1RxInfo1 -PageNumber $pageNum  
		stc::apply
		after 4000
                set lstRxResults [stc::get $::hGPNPort1RxInfo1 -ResultHandleList]
                foreach resultRx $lstRxResults {  
                        array set aResults [stc::get $resultRx]
                        gwd::Clear_ResultViewStat $resultRx
           		if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)]\
				&& $aResults(-L1BitRate) != 0} {
	    			lappend resultList1 $aResults(-FilteredValue_1) $aResults(-FilteredValue_2)
            		} 
        	}
        }
	send_log "\n resultList1:$resultList1"
	set flag_vid1 0
	dict for {key value} $expectList1 {
		if {[dict exists $resultList1 $key]} {
			if {[string match [dict get $resultList1 $key] $value]} {
				gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)vlan$key\的smac应为$value\实为[dict get $resultList1 $key]" $::fd_log
			} else {
				set flag_vid1 1
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)vlan$key\的smac应为$value\实为[dict get $resultList1 $key]" $::fileId
			}
		} else {
			set flag_vid1 1
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)没有收到vlan$key\的数据流" $::fileId
		}
		
	}
	if {$flag_vid1 == 0} {
		gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)所有vlan中的数据接收都正确" $::fileId
	}
	set totalPage [stc::get $::hGPNPort3RxInfo1 -TotalPageCount]
	for {set pageNum 1} {$pageNum <= $totalPage} {incr pageNum} {
		stc::config $::hGPNPort3RxInfo1 -PageNumber $pageNum  
		stc::apply
		after 4000
		set lstRxResults [stc::get $::hGPNPort3RxInfo1 -ResultHandleList]
		foreach resultRx $lstRxResults {  
			array set aResults [stc::get $resultRx]
			gwd::Clear_ResultViewStat $resultRx
			   if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)]\
				&& $aResults(-L1BitRate) != 0} {
				    lappend resultList2 $aResults(-FilteredValue_1) $aResults(-FilteredValue_2)
			    } 
		}
	}
	send_log "\n resultList2:$resultList2"
	set flag_vid2 0
	dict for {key value} $expectList2 {
		if {[dict exists $resultList2 $key]} {
			if {[string match [dict get $resultList2 $key] $value]} {
				gwd::GWpublic_print "OK" "$printWord\NE3($::gpnIp3)vlan$key\的smac应为$value\实为[dict get $resultList2 $key]" $::fd_log
			} else {
				set flag_vid2 1
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE3($::gpnIp3)vlan$key\的smac应为$value\实为[dict get $resultList2 $key]" $::fileId
			}
		} else {
			set flag_vid2 1
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($::gpnIp3)没有收到vlan$key\的数据流" $::fileId
		}
		
	}
	if {$flag_vid2 == 0} {
		gwd::GWpublic_print "OK" "$printWord\NE3($::gpnIp3)所有vlan中的数据接收都正确" $::fileId
	}
	gwd::Stop_SendFlow "$::hGPNPort1Gen $::hGPNPort3Gen"  "$::hGPNPort1Ana $::hGPNPort3Ana"

	return $flag
 }

#########################################################################################################
#函数功能：登录设备串口
#输入参数：comPort：串口号 eg:com1-COM1
#输出参数：无
#返回值： 无
#作者：吴军妮
#########################################################################################################
proc Login_GPNCOM {comPort} {
regexp -nocase {(com[0-9]+)-(com[0-9]+)} $comPort match sun1 sun2
set comh1 [open $sun2 RDWR]
chan configure $comh1 -blocking 0 -buffering none \
	  -mode 9600,n,8,1 -translation binary -eofchar {} 
spawn -open $comh1
return $spawn_id
}
#########################################################################################################
#函数功能：清空设备配置后串口登录配置
#输入参数：case：测试脚本编号
#         Gpn_type：设备型号
#           telnet：设备telent id
#          comPort：串口号 eg:com1-COM1
#         portList：设备的用到的端口列表
#            GpnIp：设备的登录ip
#       managePort：设备的管理口
#输出参数：无
#返回值： 无
#作者：吴军妮
#########################################################################################################
proc PTN_EraseConfig {case Gpn_type matchType telnet comPort GpnIp managePort} {
global Worklevel
gwd::GPN_EraseConfigFile $case $::fileId "config-file" $Gpn_type $telnet
gwd::GPN_Reboot $case $::fileId $telnet
after $::rebootTime
set spawn_id [Login_GPNCOM $comPort]
gwd::Login_GPN $case $::fileId $comPort $spawn_id $Gpn_type
if {[string match "7600S" $Gpn_type] || [string match "7600M" $Gpn_type]} {
  gwd::GPN_CfgPortSpeedAndDup $case $::fileId $managePort "disable" "100" "full" $Gpn_type $spawn_id
  }
  if {[string match "L2" $Worklevel]} {
  gwd::GPN_CfgForwardL2 $case $::fileId $managePort "disable" "enable" $Gpn_type $spawn_id
  gwd::GPN_AddVlan $case $::fileId "4000" $spawn_id
  gwd::GPN_CfgVlanIp $case $::fileId "4000" $GpnIp "24" $spawn_id $Gpn_type
  gwd::GPN_AddPortToVlan $case $::fileId "4000" "untagged" $spawn_id $managePort
  } else {
  gwd::GPN_CfgManagePort $spawn_id $matchType $Gpn_type $::fileId $managePort $GpnIp "24"
  }
set spawn_com $spawn_id
close $spawn_com
}



########################################################################################################
#函数功能：EVP-TREE业务标签交换测试
#输入参数:RunFlag:不同类型标志位
#         GPNPort：被镜像端口
#             dir：镜像方向
#输出参数：      flag：数据流判断结果标志位
#返回值： 无
#作者：吴军妮
########################################################################################################
proc PTN_EVP_LabelSwith {RunFlag printWord GPNPort dir caseId flag} {
        upvar $flag aTmpFlag
        set aTmpFlag 0
        foreach i "aTmpGPNPort6Cnt1" {
        	array set $i {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0 cnt11 0 cnt12 0 cnt13 0 cnt14 0 cnt15 0} 
        }

	array set aMirror "dir1 $dir port1 $GPNPort dir2 \"\" port2 \"\""
	gwd::GWpublic_CfgPortMirror $::telnet2 $::matchType2 $::Gpn_type2 $::fileId $::GPNTestEth6 aMirror
	gwd::Start_CapAllData ::capArr $::hGPNPort6Cap $::hGPNPort6CapAnalyzer
        gwd::Start_SendFlow "$::hGPNPort1Gen $::hGPNPort3Gen"  "$::hGPNPort6Ana"
        after 10000
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt5 2 $::hGPNPort6Ana aTmpGPNPort6Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 0 0 0 1
		after 5000
	}
        gwd::Stop_SendFlow "$::hGPNPort1Gen $::hGPNPort3Gen"  "$::hGPNPort6Ana"
	gwd::Stop_CapData $::hGPNPort6Cap 1 "$caseId-p$::GPNTestEth6_cap\($::gpnIp1\).pcap"
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth6_cap\($::gpnIp1\).pcap" $::fileId
        if {$RunFlag==1} {
                if {$aTmpGPNPort6Cnt1(cnt13) < $::rateL1 || $aTmpGPNPort6Cnt1(cnt13) > $::rateR1} {
                	set aTmpFlag 1
			gwd::GWpublic_print "NOK" "$printWord\在NE2($::gpnIp2)上镜像NE2与NE1相连的NNI口$GPNPort\的ingree方向，mpls标签lsp为21 pw为3000的数据包\
				速率为$aTmpGPNPort6Cnt1(cnt13)，没在$::rateL1-$::rateR1\范围内" $::fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\在NE2($::gpnIp2)上镜像NE2与NE1相连的NNI口$GPNPort\的ingree方向，mpls标签lsp为21 pw为3000的数据包\
				速率为$aTmpGPNPort6Cnt1(cnt13)，在$::rateL1-$::rateR1\范围内" $::fileId
		}
        } elseif {$RunFlag==2} {
		if {$aTmpGPNPort6Cnt1(cnt14) < $::rateL1 || $aTmpGPNPort6Cnt1(cnt14) > $::rateR1} {
			set aTmpFlag 1
			gwd::GWpublic_print "NOK" "$printWord\在NE2($::gpnIp2)上镜像NE2与NE3相连的NNI口$GPNPort\的egree方向，mpls标签lsp为22 pw为3000的数据包\
				速率为$aTmpGPNPort6Cnt1(cnt14)，没在$::rateL1-$::rateR1\范围内" $::fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\在NE2($::gpnIp2)上镜像NE2与NE3相连的NNI口$GPNPort\的egree方向，mpls标签lsp为22 pw为3000的数据包\
				速率为$aTmpGPNPort6Cnt1(cnt14)，在$::rateL1-$::rateR1\范围内" $::fileId
		}
        } elseif {$RunFlag==3} {
		if {$aTmpGPNPort6Cnt1(cnt11) < $::rateL1 || $aTmpGPNPort6Cnt1(cnt11) > $::rateR1} {
			set aTmpFlag 1
			gwd::GWpublic_print "NOK" "$printWord\在NE2($::gpnIp2)上镜像NE2与NE1相连的NNI口$GPNPort\的egree方向，mpls标签lsp为20 pw为3000的数据包\
				速率为$aTmpGPNPort6Cnt1(cnt11)，没在$::rateL1-$::rateR1\范围内" $::fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\在NE2($::gpnIp2)上镜像NE2与NE1相连的NNI口$GPNPort\的egree方向，mpls标签lsp为20 pw为3000的数据包\
				速率为$aTmpGPNPort6Cnt1(cnt11)，在$::rateL1-$::rateR1\范围内" $::fileId
		}
        } elseif {$RunFlag==4} {
		if {$aTmpGPNPort6Cnt1(cnt15) < $::rateL1 || $aTmpGPNPort6Cnt1(cnt15) > $::rateR1} {
			set aTmpFlag 1
			gwd::GWpublic_print "NOK" "$printWord\在NE2($::gpnIp2)上镜像NE2与NE3相连的NNI口$GPNPort\的ingree方向，mpls标签lsp为23 pw为3000的数据包\
				速率为$aTmpGPNPort6Cnt1(cnt15)，没在$::rateL1-$::rateR1\范围内" $::fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\在NE2($::gpnIp2)上镜像NE2与NE3相连的NNI口$GPNPort\的ingree方向，mpls标签lsp为23 pw为3000的数据包\
				速率为$aTmpGPNPort6Cnt1(cnt15)，在$::rateL1-$::rateR1\范围内" $::fileId
		}
        }
	gwd::GWpublic_DelPortMirror $::telnet2 $::matchType2 $::Gpn_type2 $::fileId $::GPNTestEth6
}
########################################################################################################
#函数功能：EVP-TREE业务标签交换和业务恢复反复测试
#输入参数:RunFlag:不同类型标志位
#输出参数：      flag1：镜像数据流判断结果标志位
#           flag2：业务数据流判断结果标志位
#返回值： 无
#作者：吴军妮
########################################################################################################
proc PTN_EVP_LabelSwithRepeat {printWord} {
	global capId
	set flag 0
	incr capId
	PTN_EVP_LabelSwith 1 $printWord $::GPNPort6 "ingress" "GPN_PTN_010_$capId" flag1
	incr capId
	PTN_EVP_LabelSwith 2 $printWord $::GPNPort7 "egress" "GPN_PTN_010_$capId" flag2
	incr capId
	PTN_EVP_LabelSwith 3 $printWord $::GPNPort6 "egress" "GPN_PTN_010_$capId" flag3
	incr capId
	PTN_EVP_LabelSwith 4 $printWord $::GPNPort7 "ingress" "GPN_PTN_010_$capId" flag4
	if {($flag1 == 1) || ($flag2 ==1) || ($flag3 ==1) || ($flag4 ==1)} {
		set flag 1
	}
	return $flag
}
########################################################################################################
#函数功能：ac pw lsp port 性能统计测试
#输入参数: lStream:要发送的数据流
#         eth 、lspName 、pwName 、acName：要统计的端口、lsp、pw、ac
#         hGPNPortAna：与eth相连的TC analyzer的handle
#         hGPNPortGen：与eth相连的TC generator的handle
#返回值：flag =0 所有统计正确    =1有统计不正确的项
########################################################################################################
proc PTN_EVP_State {spawn_id matchType dutType fileId lStream eth lspName pwName acName hGPNPortAna hGPNPortGen} {
	set flag 0
	stc::perform streamBlockActivate \
		-streamBlockList "$lStream" \
		-activate "true"
	stc::perform ResultsClearViewCommand -ResultList "[stc::get $hGPNPortAna -children-AnalyzerPortResults] [stc::get $hGPNPortGen -children-GeneratorPortResults]"	
	gwd::GWpublic_getPortStat $spawn_id $matchType $dutType $fileId $eth GPNPortStat1
	gwd::GWpublic_getMplsStat $spawn_id $matchType $dutType $fileId "lsp tunnel" $lspName GPNLspStat1
	gwd::GWpublic_getMplsStat $spawn_id $matchType $dutType $fileId "pw" $pwName GPNPwStat1
	gwd::GWpublic_getMplsStat $spawn_id $matchType $dutType $fileId "ac" $acName GPNAcStat1
        gwd::Start_SendFlow  $::hGPNPortGenList  $::hGPNPortAnaList
        after 60000
        gwd::Stop_SendFlow  $::hGPNPortGenList  $::hGPNPortAnaList
	after 20000
	stc::perform streamBlockActivate \
		-streamBlockList "$lStream" \
		-activate "false"
	set rxCnt [stc::get $hGPNPortAna.AnalyzerPortResults -SigFrameCount]
	set txCnt [stc::get $hGPNPortGen.GeneratorPortResults -GeneratorSigFrameCount]
	gwd::GWpublic_getMplsStat $spawn_id $matchType $dutType $fileId "lsp tunnel" $lspName GPNLspStat2
	gwd::GWpublic_getMplsStat $spawn_id $matchType $dutType $fileId "pw" $pwName GPNPwStat2
	gwd::GWpublic_getMplsStat $spawn_id $matchType $dutType $fileId "ac" $acName GPNAcStat2
        gwd::GWpublic_getPortStat $spawn_id $matchType $dutType $fileId $eth GPNPortStat2
        set LspFrameIn [expr $GPNLspStat2(-inTotalPkts)-$GPNLspStat1(-inTotalPkts)]
        set PwFrameIn [expr $GPNPwStat2(-inTotalPkts)-$GPNPwStat1(-inTotalPkts)]
        set AcFrameIn [expr $GPNAcStat2(-inTotalPkts)-$GPNAcStat1(-inTotalPkts)]
        set PortFrameIn [expr $GPNPortStat2(-inUniPkts)-$GPNPortStat1(-inUniPkts)]
        set LspFrameOut [expr $GPNLspStat2(-outTotalPkts)-$GPNLspStat1(-outTotalPkts)]
        set PwFrameOut [expr $GPNPwStat2(-outTotalPkts)-$GPNPwStat1(-outTotalPkts)]
        set AcFrameOut [expr $GPNAcStat2(-outTotalPkts)-$GPNAcStat1(-outTotalPkts)]
        set PortFrameOut [expr $GPNPortStat2(-outUniPkts)-$GPNPortStat1(-outUniPkts)]
	if {$LspFrameIn != $rxCnt || $PwFrameIn != $rxCnt || $AcFrameIn != $txCnt || $PortFrameIn != $txCnt\
		|| $LspFrameOut != $txCnt || $PwFrameOut != $txCnt || $AcFrameOut != $rxCnt || $PortFrameOut != $rxCnt
	} {
		set flag 1
	}
	gwd::GWpublic_print [expr {($LspFrameIn == $rxCnt) ? "OK" : "NOK"}] "$matchType\的$lspName\的inTotalPkts统计发送数据流前为$GPNLspStat1(-inTotalPkts)\
		发送数据流后为$GPNLspStat2(-inTotalPkts)，差值应为$rxCnt\实为$LspFrameIn" $fileId
	gwd::GWpublic_print [expr {($PwFrameIn == $rxCnt) ? "OK" : "NOK"}] "$matchType\的$pwName\的inTotalPkts统计发送数据流前为$GPNPwStat1(-inTotalPkts)\
		发送数据流后为$GPNPwStat2(-inTotalPkts)，差值应为$rxCnt\实为$PwFrameIn" $fileId
	gwd::GWpublic_print [expr {($AcFrameIn == $txCnt) ? "OK" : "NOK"}] "$matchType\的$acName\的inTotalPkts统计发送数据流前为$GPNAcStat1(-inTotalPkts)\
		发送数据流后为$GPNAcStat2(-inTotalPkts)，差值应为$txCnt\实为$AcFrameIn" $fileId
	gwd::GWpublic_print [expr {($PortFrameIn == $txCnt) ? "OK" : "NOK"}] "$matchType\的$eth\的inTotalPkts统计发送数据流前为$GPNPortStat1(-inTotalPkts)\
		发送数据流后为$GPNPortStat2(-inTotalPkts)，差值应为$txCnt\实为$PortFrameIn" $fileId
	
	gwd::GWpublic_print [expr {($LspFrameOut == $txCnt) ? "OK" : "NOK"}] "$matchType\的$lspName\的outTotalPkts统计发送数据流前为$GPNLspStat1(-outTotalPkts)\
		发送数据流后为$GPNLspStat2(-outTotalPkts)，差值应为$txCnt\实为$LspFrameOut" $fileId
	gwd::GWpublic_print [expr {($PwFrameOut == $txCnt) ? "OK" : "NOK"}] "$matchType\的$pwName\的outTotalPkts统计发送数据流前为$GPNPwStat1(-outTotalPkts)\
		发送数据流后为$GPNPwStat2(-outTotalPkts)，差值应为$txCnt\实为$PwFrameOut" $fileId
	gwd::GWpublic_print [expr {($AcFrameOut == $rxCnt) ? "OK" : "NOK"}] "$matchType\的$acName\的outTotalPkts统计发送数据流前为$GPNAcStat1(-outTotalPkts)\
		发送数据流后为$GPNAcStat2(-outTotalPkts)，差值应为$rxCnt\实为$AcFrameOut" $fileId
	gwd::GWpublic_print [expr {($PortFrameOut == $rxCnt) ? "OK" : "NOK"}] "$matchType\的$eth\的outTotalPkts统计发送数据流前为$GPNPortStat1(-outTotalPkts)\
		发送数据流后为$GPNPortStat2(-outUniPkts)，差值应为$rxCnt\实为$PortFrameOut" $fileId
	return $flag
}
########################################################################################################
#函数功能：ptn业务nni口添加vlan和ip
#输入参数:      case:测试用例编号
#       Worklevel:L2/L3层模式
#       interface:L2/L3层接口
#              ip:ip的配置
#         GPNPort:NNI接口
#       matchType:匹配命令行节点用字符串
#        Gpn_type:设备类型
#          telnet:spwan_id号
#输出参数：  无
#返回值： 无
#作者：吴军妮
########################################################################################################
proc PTN_NNI_AddInterIp {fileId Worklevel interface ip GPNPort matchType Gpn_type telnet} {
	set flagErr 0
        if {[string match "L2" $Worklevel]} {
                regexp -nocase {(\d+)} $interface match vid
		lappend flagErr [gwd::GWpublic_Addvlan $telnet $matchType $Gpn_type $fileId $vid]
		lappend flagErr [gwd::GWpublic_Addporttovlan $telnet $matchType $Gpn_type $fileId $vid "port" $GPNPort "untagged"]
		lappend flagErr [gwd::GWpublic_CfgVlanIp $telnet $matchType $Gpn_type $fileId $vid $ip 24]
        } else {
                regexp -nocase {(\d+/\d+).(\d+)} $interface match port vid
		lappend flagErr [gwd::GWL3Inter_AddL3 $telnet $matchType $Gpn_type $fileId "ethernet" $GPNPort $vid]
		lappend flagErr [gwd::GWL3port_AddIP $telnet $matchType $Gpn_type $fileId "ethernet" $GPNPort $vid $ip 24]
        }
	return [regexp {[^0\s]} $flagErr]
}
proc PTN_NNI_AddInterIp_tag {fileId Worklevel interface ip GPNPort matchType Gpn_type telnet} {
	set flagErr 0
	if {[string match "L2" $Worklevel]} {
		regexp -nocase {(\d+)} $interface match vid
		lappend flagErr [gwd::GWpublic_Addvlan $telnet $matchType $Gpn_type $fileId $vid]
		lappend flagErr [gwd::GWpublic_Addporttovlan $telnet $matchType $Gpn_type $fileId $vid "port" $GPNPort "tagged"]
		lappend flagErr [gwd::GWpublic_CfgVlanIp $telnet $matchType $Gpn_type $fileId $vid $ip 24]
	} else {
		regexp -nocase {(\d+/\d+).(\d+)} $interface match port vid
		lappend flagErr [gwd::GWL3Inter_AddL3 $telnet $matchType $Gpn_type $fileId "ethernet" $GPNPort $vid]
		lappend flagErr [gwd::GWL3port_AddIP $telnet $matchType $Gpn_type $fileId "ethernet" $GPNPort $vid $ip 24]
	}
	return [regexp {[^0\s]} $flagErr]
}
########################################################################################################
#函数功能：ptn业务uni口添加vlan
#输入参数:      case:测试用例编号
#       Worklevel:L2/L3层模式
#             vid:vlan id号
#      GPNTestEth:接入ac的端口
#       matchType:匹配命令行节点用字符串
#        Gpn_type:设备类型
#          telnet:spwan_id号
#输出参数：  无
#返回值： flagErr
#作者：吴军妮
########################################################################################################
proc PTN_UNI_AddInter {telnet matchType Gpn_type fileId Worklevel vid GPNTestEth} {
   set flagErr 0
   if {[string match "L2" $Worklevel]} {  
   lappend flagErr [gwd::GWpublic_Addvlan $telnet $matchType $Gpn_type $fileId $vid]
   lappend flagErr [gwd::GWpublic_Addporttovlan $telnet $matchType $Gpn_type $fileId $vid "port" $GPNTestEth "tagged"]
   } else {
   lappend flagErr [gwd::GWL3Inter_AddL3 $telnet $matchType $Gpn_type $fileId "ethernet" $GPNTestEth $vid]
   }
   return [regexp {[^0\s]} $flagErr]
}
########################################################################################################
#函数功能：ptn业务删除子接口vlan
#输入参数:      case:测试用例编号
#       Worklevel:L2/L3层模式
#       interface:L2/L3层接口
#       matchType:匹配命令行节点用字符串
#        Gpn_type:设备类型
#          telnet:spwan_id号
#输出参数：  无
#返回值： FlagErr
#作者：吴军妮
########################################################################################################
proc PTN_DelInterVid {fileId Worklevel interface matchType Gpn_type telnet} {
   	set FlagErr 0
   	if {[string match "L2" $Worklevel]} {
   		regexp -nocase {(\d+)} $interface match vid
   		set FlagErr [gwd::GWL2Inter_DelVlan $telnet $matchType $Gpn_type $fileId $vid]
   	} else {
		   
		regexp -nocase {(.+)\.(.+)} $interface match port subifno
   		set FlagErr [gwd::GWL3Inter_DelL3 $telnet $matchType $Gpn_type $fileId "eth" $port $subifno]
   	}
   	return $FlagErr
}
proc PTN_DelInterVid_new {fileId Worklevel interface matchType Gpn_type telnet} {
	   set FlagErr 0
	   regexp -nocase {(.+)\.(.+)} $interface match port subifno
	   if {[string match "L2" $Worklevel]} {
		   set FlagErr [gwd::GWL2Inter_DelVlan $telnet $matchType $Gpn_type $fileId $subifno]
	   } else {
		   set FlagErr [gwd::GWL3Inter_DelL3 $telnet $matchType $Gpn_type $fileId "eth" $port $subifno]
	   }
	   return $FlagErr
}
########################################################################################################
#函数功能：ptn业务子接口vlan添加静态arp
#输入参数:      case:测试用例编号
#       Worklevel:L2/L3层模式
#       interface:L2/L3层接口
#              ip:arp的配置
#              ip:mac的配置
#         GPNPort:NNI接口
#       matchType:匹配命令行节点用字符串
#        Gpn_type:设备类型
#          telnet:spwan_id号
#输出参数：  无
#返回值： FlagErr
#作者：吴军妮
########################################################################################################
proc PTN_AddInterArp {fileId Worklevel interface ip mac GPNPort matchType Gpn_type telnet} {
   set FlagErr 0
   if {[string match "L2" $Worklevel]} {
   regexp -nocase {(\d+)} $interface match vid
   set FlagErr [GPN_CfgVlanArpAddr $matchType $fileId $Gpn_type $vid $ip $mac $GPNPort $telnet]
   } else {
   set FlagErr [GPN_CfgInterArpAddr $telnet $matchType $Gpn_type $fileId $interface $ip $mac]
   }
   return $FlagErr
}
########################################################################################################
#函数功能：ptn配置三层trunk
#输入参数:      case:测试用例编号
#           tname:trunk名称
#        portlist:trunk成员端口
#       Worklevel:L2/L3层模式
#       matchType:匹配命令行节点用字符串
#        Gpn_type:设备类型
#          telnet:spwan_id号
#输出参数：  无
#返回值： FlagErr
#作者：吴军妮
########################################################################################################
proc PTN_AddTrunkPort {matchType tname portlist Worklevel Gpn_type telnet} {
   	set FlagErr 0
   	if {![string match "L2" $Worklevel]} {
		foreach eth $portlist {
			set FlagErr [gwd::GWL2_AddPort $telnet $matchType $Gpn_type $::fileId $eth "disable" "disable"]
		}	
   	}
	set FlagErr [gwd::GWTrunk_AddInfo $telnet $matchType $Gpn_type $::fileId $tname "" $portlist]
   	return $FlagErr
}
########################################################################################################
#函数功能：ptn配置三层lacp trunk
#输入参数:      case:测试用例编号
#           tname:trunk名称
#        portlist:trunk成员端口
#       Worklevel:L2/L3层模式
#       matchType:匹配命令行节点用字符串
#        Gpn_type:设备类型
#          telnet:spwan_id号
#输出参数：  无
#返回值： FlagErr
#作者：吴军妮
########################################################################################################
proc PTN_AddStaticTrunkPort {spawn_id matchType dutType fileId tname portlist Worklevel} {
        set flagErr 0
        if {[string match "L2" $Worklevel]} {
		lappend flagErr [gwd::GWTrunk_AddInfo $spawn_id $matchType $dutType $fileId $tname "static" $portlist]
        } elseif {[string match "L3" $Worklevel] && [string match "L2" $trunkLevel]} {
		foreach eth $portlist {
			lappend flagErr [gwd::GWL2_AddPort $spawn_id $matchType $dutType $fileId $eth "disable" "enable"]
		}
		lappend flagErr [gwd::GWTrunk_AddInfo $spawn_id $matchType $dutType $fileId $tname "static" $portlist]
        } else {
		foreach eth $portlist {
			lappend flagErr [gwd::GWL3_AddInterDcn $spawn_id $matchType $dutType $fileId "ethernet" "eth" "disable"]
		}
		lappend flagErr [gwd::GWTrunk_AddInfo $spawn_id $matchType $dutType $fileId $tname "static" $portlist]
		lappend flagErr [gwd::GWL3_AddInterDcn $spawn_id $matchType $dutType $fileId "trunk" "t1" "enable"]
        }
	return [regexp {[^0\s]} $flagErr]
}
########################################################################################################
#函数功能：ptn配置三层trunk子接口
#输入参数:      case:测试用例编号
#       Worklevel:L2/L3层模式
#       interface:trunk子接口
#            type:trunk属性
#        Gpn_type:设备类型
#          telnet:spwan_id号
#输出参数：  无
#返回值： FlagErr
#作者：吴军妮
########################################################################################################
proc PTN_AddTrunkInter {matchType Worklevel interface type Gpn_type telnet} {
        set flagErr 0
	regexp -nocase {\w.(\d+)} $interface match vid
	regexp -nocase {(\w+)} $interface match tname
        if {[string match "L2" $Worklevel]} {
		lappend flagErr [gwd::GWL2Inter_AddVlanPort $telnet $matchType $Gpn_type $::fileId $vid "trunk" $tname "untagged"]
        } else {
		lappend flagErr [gwd::GWL3Inter_AddL3 $telnet $matchType $Gpn_type $::fileId "trunk" $tname $vid]
        }
        return [regexp {[^0\s]} $flagErr]
}
########################################################################################################
#函数功能：ptn删除三层trunk子接口
#输入参数:      case:测试用例编号
#       Worklevel:L2/L3层模式
#       interface:trunk子接口
#            type:trunk属性
#          telnet:spwan_id号
#输出参数：  无
#返回值： FlagErr
#作者：吴军妮
########################################################################################################
proc PTN_DelTrunkInter {spawn_id matchType dutType fileId Worklevel interface type} {
	set flagErr 0
	regexp -nocase {(\w+)} $interface match tname
        if {[string match "L2" $Worklevel]} {
        	lappend flagErr [gwd::GWTrunk_DelInfo $spawn_id $matchType $dutType $fileId $tname $type]
        } else {
        	lappend flagErr [gwd::GWTrunk_DelInfo $spawn_id $matchType $dutType $fileId $interface ""]
        	lappend flagErr [gwd::GWTrunk_DelInfo $spawn_id $matchType $dutType $fileId $tname $type]
        }
        return [regexp {[^0\s]} $flagErr]
}
########################################################################################################
#函数功能：GPN上设置某个子接口的绑定arp和mac
#输入参数:  spawn_id:TELNET进程
#       matchType:匹配命令行节点用字符串
#	  dutType:设备类型。
#	   fileId:报告输出的文件标识符
#           inter：子接口号
#             arp：绑定ARP地址
#             mac：绑定MAC地址
#输出参数：无
#返回值： flagErr  =0：添加成功       =1：添加失败            =2：ip地址添加达到最大值，无法继续添加  =3：不能绑定广播ip  =4不能绑定组播ip
########################################################################################################
proc GPN_CfgInterArpAddr {spawn_id matchType dutType fileId inter arp mac} {
  set flagErr 0
  expect {
    -i $spawn_id
    -nocase -re "$matchType\\(config\\)#" {exp_send -i $spawn_id "interface eth $inter\r"}     
    timeout {set flagErr 1;exp_send -i $spawn_id "\r"}  
  }
  expect {
     -i $spawn_id
     -re {Unknown command} {set flagErr 1;send -i $spawn_id "\r"} 
     -re ".+" {send -i $spawn_id "\r"}
     timeout {set flagErr 1}  
   }
  expect {
    -i $spawn_id
    -nocase -re "$matchType\\(config-subinterface-eth$inter\\)#" {exp_send -i $spawn_id "ip static-arp $arp $mac\r"}     
    timeout {set flagErr 1;exp_send -i $spawn_id "\r"}  
  }
  expect {
    -i $spawn_id
    -nocase -re {There are too many static ARP items} {exp_send -i $spawn_id "exit\r";set flagErr 2}
    -nocase -re {Interface need configure ip address} {exp_send -i $spawn_id "exit\r";set flagErr 2}
    -nocase -re {Can't set broadcast IP address} {exp_send -i $spawn_id "exit\r";set flagErr 3}
    -nocase -re {Can't set multicast IP address} {exp_send -i $spawn_id "exit\r";set flagErr 4}
    -nocase -re "(% Error.*)$matchType\\(config-subinterface-eth$inter\\)#" {
        set flagErr 1
        gwd::GWpublic_print NOK "在$matchType\子接口$inter\中绑定ip:$arp\且绑定mac:$mac，失败。系统提示：$expect_out(1,string)" $fileId
        send -i $spawn_id "exit\r"
    }
    -nocase -re "$matchType\\(config-subinterface-eth$inter\\)#" {exp_send -i $spawn_id "exit\r"}
    timeout {set flagErr 1;exp_send -i $spawn_id "\r"}  
  }
  expect {
    -i $spawn_id
    -nocase -re "$matchType\\(config\\)#" {exp_send -i $spawn_id "\r"}
    timeout {set flagErr 1;exp_send -i $spawn_id "\r"}
  } 
  gwd::GWpublic_print [expr {($flagErr == 0) ? "OK" : "NOK"}] "在$matchType\子接口$inter\中绑定ip:$arp\且绑定mac:$mac" $fileId
  return $flagErr  
}
proc dget {dict args} {
	if {[dict exist $dict {*}$args]} {
		set result [dict get $dict {*}$args]
	} else {
		set result null
	}
	return $result
}

proc AddportAndIptovlan {spawn_id matchType dutType fileId vid type inter mode ip mask} {
        set errorTmp 0
        send -i $spawn_id "\r"
        expect {
            -i $spawn_id
            -re "$matchType\\(config\\)#" {
            	send -i $spawn_id "\r"
            }
            -timeout 5
            timeout {
            	gwd::GWpublic_toConfig $spawn_id $matchType
            }
        }
        expect {
            -i $spawn_id
            -re "$matchType\\(config\\)#" {
        	  send -i $spawn_id "vlan $vid\r"
            }
        }
	if {$inter != ""} {
                expect {
                    -i $spawn_id
                    -re "$matchType\\(vlan.*\\)#" {
                        send -i $spawn_id "add $type $inter $mode\r" 
                    }
                }
        	expect {
            		-i $spawn_id
                	-re {Unknown command} {
                              	set errorTmp 1
        			gwd::GWpublic_print NOK "$matchType\上vlan$vid中添加端口，失败。命令参数有误" $fileId
                              	send -i $spawn_id "\r"
                      	}
                      	-re {untagged in another non-default VLAN} {
                          	set errorTmp 1
        			gwd::GWpublic_print NOK "$matchType\上vlan$vid中添加端口，失败。端口已untag方式加入了非default vlan" $fileId
                          	send -i $spawn_id "\r"
                      	}
                      	-re {Layer 2 forwarding has been disabled on this port} {
                          	set errorTmp 1
        			gwd::GWpublic_print NOK "$matchType\上vlan$vid中添加端口，失败。端口的二层转发功能没有使能" $fileId    
                      	}
                      	-re "$matchType\\(vlan.*\\)#" {
                          	send -i $spawn_id "\r"
        			gwd::GWpublic_print OK "$matchType\上vlan$vid中添加端口，成功" $fileId    
                	}
        	}
		
	}
	if {$ip != ""} {
                expect {
                        -i $spawn_id
                        -re "$matchType\\(vlan.*\\)#" {
                            send -i  $spawn_id "ip address $ip/$mask\r" 
                        }
                }
                expect {
                        -i $spawn_id
                        -re {Unknown command} {
                            set errorTmp 1
                            gwd::GWpublic_print NOK "$matchType\设置vlan$vid\的ip为$ip，失败。命令参数有误" $fileId
                            send -i $spawn_id "exit\r"
                        }
                        -re {Connot set ip address} {
                            set errorTmp 1
                            gwd::GWpublic_print NOK "$matchType\设置vlan$vid\的ip为$ip，失败。不支持ip地址配置" $fileId
                            send -i $spawn_id "exit\r"
                        }
                        -re "$matchType\\(vlan.*\\)#" {
                            gwd::GWpublic_print OK "$matchType\设置vlan$vid\的ip为$ip，成功" $fileId
			    send -i $spawn_id "\r" 
                        }
                }
		
	}
	expect {
        	-i $spawn_id
        	-re "$matchType\\(vlan.*\\)#" {
        		send -i $spawn_id "exit\r"
        	}
	}
	return $errorTmp
}

#函数功能：查询vpls表项
#输入参数: fileId:测试报告的文件id
#         tableList:实际查询到的转发表字典 格式：mac1 "name1" mac2 "name2"
#     expectTable:期望表项列表 mac1 name1 mac2 name2 mac3 name3 mac4 name4
#     vplsname:vpls名称
#     printWord:打印报告的说明字符串
#       spawn_id:spawn id
#输出参数：无
#返回值： tableList：vpls表项列表
proc TestVplsForwardEntry {fileId printWord dTable expectTable} {
	set flag 0
	foreach {mac name} $expectTable {
		if {[dict exists $dTable $mac]} {
			if {[string match -nocase $name [dict get $dTable $mac portname]]} {
				gwd::GWpublic_print "OK" "$printWord\mac地址$mac\学习到了$name上" $fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\mac地址$mac\学习到了[dict get $dTable $mac portname]上" $fileId
			}
		} else {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\没有mac=$mac\的转发表项" $fileId
		}
	}
	return $flag
}

########################################################################################################
#函数功能：测试过程中增加的NE1--NE3的一条业务，测试此业务的环回
#输入参数：
#	fileId：测试报告的文件标识符
#	rateL rateR：接收速率判断标准
#输出参数：无
#返回值：flag
########################################################################################################
proc TestPWLoop {fileId rateL rateR} {
	set flag 0
	global capId
	global gpnIp1
	global gpnIp3
	global GPNTestEth1
	
	gwd::GWpublic_addPwLoop $::telnet3 $::matchType3 $::Gpn_type3 $fileId "pw321"
	#测试GPNTestEth1有没有收到NE3环回的数据------
	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort1AnaFrameCfgFil $::anaFliFrameCfg1
	Recustomization 1 1 1 1 1 0
	if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
	}
	gwd::Start_SendFlow "$::hGPNPort1Gen"  $::hGPNPort1Ana
	after 10000
	incr capId
	if {$::cap_enable} {
		gwd::Stop_CapData $::hGPNPort1Cap 1 "GPN_PTN_014_1_$capId-p$::GPNTestEth1_cap\($gpnIp1\).pcap"
	}
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_014_1_$capId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	array set GPNPort1Cnt1 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0 cnt10 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 1 $::hGPNPort1Ana GPNPort1Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort1Cnt1
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  $::hGPNPort1Ana
	if {$GPNPort1Cnt1(cnt7) < $rateL || $GPNPort1Cnt1(cnt7) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\发送tag=60的未知单播数据流，NE3($gpnIp3)的pw上做环回\
			NE1 $GPNTestEth1\收到tag=60的数据流的速率为$GPNPort1Cnt1(cnt7)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\发送tag=60的未知单播数据流，NE3($gpnIp3)的pw上做环回\
			NE1 $GPNTestEth1\收到tag=60的数据流的速率为$GPNPort1Cnt1(cnt7)，在$rateL-$rateR\范围内" $fileId
	}
	#------测试GPNTestEth1有没有收到NE3环回的数据
	#测试环回数据的mac地址有没有被交换------
	array set aMirror "dir1 ingress port1 $::GPNPort5 dir2 egress port2 $::GPNPort5"
	gwd::GWpublic_CfgPortMirror $::telnet1 $::matchType1 $::Gpn_type1 $fileId $::GPNTestEth5 aMirror
	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort5AnaFrameCfgFil $::anaFliFrameCfg51
	Recustomization 1 1 1 1 1 0
	if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $::hGPNPort5Cap $::hGPNPort5CapAnalyzer 
	}
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort5Ana"
	after 10000
	incr capId
	if {$::cap_enable} {
		gwd::Stop_CapData $::hGPNPort5Cap 1 "GPN_PTN_014_1_$capId-p$::GPNTestEth1_cap\($gpnIp1\).pcap"
	}
	array set aGPNPort5Cnt1 {cnt3 0 cnt4 0} 
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 2 $::hGPNPort5Ana aGPNPort5Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray aGPNPort5Cnt1
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort5Ana"
	if {$aGPNPort5Cnt1(cnt3) < $::rateL1 || $aGPNPort5Cnt1(cnt3) > $::rateR1} {
		set flag 1
		gwd::GWpublic_print "NOK" "vpls为etree业务raw模式在NE3设置数据环回，在NE1发送报文，镜像NE1 NNI的出方向报文，mac没有被交换" $fileId
	} else {
		gwd::GWpublic_print "OK" "vpls为etree业务raw模式在NE3设置数据环回，在NE1发送报文，镜像NE1 NNI的出方向报文，mac被交换" $fileId
	}
	if {$aGPNPort5Cnt1(cnt4) < $::rateL1 || $aGPNPort5Cnt1(cnt4) > $::rateR1} {
		set flag 1
		gwd::GWpublic_print "NOK" "vpls为etree业务raw模式在NE3设置数据环回，在NE1发送报文，镜像NE1 NNI的入方向报文，mac没有被交换" $fileId
	} else {
		gwd::GWpublic_print "OK" "vpls为etree业务raw模式在NE3设置数据环回，在NE1发送报文，镜像NE1 NNI的入方向报文，mac被交换" $fileId
	}
	gwd::GWpublic_DelPortMirror $::telnet1 $::matchType1 $::Gpn_type1 $fileId $::GPNTestEth5
	#------测试环回数据的mac地址有没有被交换
	return $flag
}
########################################################################################################
#函数功能：NE1的AC为PORT+VALN模式    NE3的AC为PORT+VLAN模式    发流验证
#输入参数：printWord：打印的说明字符串
#	caseId：保存抓包文件时文件名字中使用的关键字
#	fileId：测试报告的文件标识符
#	rateL rateR：接收速率判断标准
#输出参数：无
#返回值：flag
########################################################################################################
proc PortVlan_portVlan_repeat_014 {printWord caseId fileId rateL rateR} {
	set flag 0
	
	global gpnIp1
	global gpnIp3
	global gpnIp4
	global GPNTestEth1
	global GPNTestEth2
	global GPNTestEth3
	global GPNTestEth4
	global GPNTestEth5
			
	#NE1的GPNTestEth1 AC1发送untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100的数据流
	SendAndStat_ptn014 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 GPNPort5Cnt1\
		1 $::anaFliFrameCfg1 "$caseId"
	SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 GPNPort5Cnt7\
		7 $::anaFliFrameCfg7 "$caseId"
	SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 GPNPort5Cnt0\
		0 $::anaFliFrameCfg0 "$caseId"
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
			
	#NE3 的GPNTestEth3接收
	if {$GPNPort3Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
	}
	if {$GPNPort3Cnt1(cnt2) < $rateL || $GPNPort3Cnt1(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=50的数据流的速率为$GPNPort3Cnt1(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=50的数据流的速率为$GPNPort3Cnt1(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt3)" $fileId
	}
	if {$GPNPort3Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt4)" $fileId
	}
	#NE4 GPNTestEth4 的接收
	if {$GPNPort4Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
	}
	if {$GPNPort4Cnt7(cnt2) < $rateL || $GPNPort4Cnt7(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt7(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt7(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt3)" $fileId
	}
	if {$GPNPort4Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt4)" $fileId
	}
	return $flag
}

########################################################################################################
#函数功能：NE1的AC为PORT模式    NE3的AC为PORT模式    发流验证
#输入参数：printWord：打印的说明字符串
#	caseId：保存抓包文件时文件名字中使用的关键字
#	fileId：测试报告的文件标识符
#	rateL rateR：接收速率判断标准
#输出参数：无
#返回值：flag
########################################################################################################
proc Port_port_repeat_014 {printWord caseId fileId rateL rateR} {
	set flag 0
	
	global gpnIp1
	global gpnIp3
	global gpnIp4
	global GPNTestEth1
	global GPNTestEth2
	global GPNTestEth3
	global GPNTestEth4
	global GPNTestEth5
			
	#NE1的GPNTestEth1 AC1发送untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100的数据流
	
	SendAndStat_ptn014 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 GPNPort5Cnt7\
		7 $::anaFliFrameCfg7 "$caseId"
	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg7
	set ::hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $::hGPNPort3Ana -FilterName "custom-vlanId" -Offset 14]
	set ::hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $::hGPNPort3Ana -FilterName "custom-etherType" -Offset 16]
	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort4AnaFrameCfgFil $::anaFliFrameCfg7
	set ::hfilter16BitFilAna3 [stc::create Analyzer16BitFilter -under $::hGPNPort4Ana -FilterName "custom-vlanId" -Offset 14]
	set ::hfilter16BitFilAna4 [stc::create Analyzer16BitFilter -under $::hGPNPort4Ana -FilterName "custom-etherType" -Offset 16]
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
	after 10000
	array set GPNPort3Cnt4 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0}
	array set GPNPort4Cnt4 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 4 $::hGPNPort3Ana GPNPort3Cnt4]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 4 $::hGPNPort4Ana GPNPort4Cnt4]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	parray GPNPort3Cnt4
	parray GPNPort4Cnt4
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
	
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	#NE3 的GPNTestEth3接收
	if {$GPNPort3Cnt7(cnt1) < $rateL || $GPNPort3Cnt7(cnt1) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到untag数据流的速率为$GPNPort3Cnt7(cnt1)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到untag数据流的速率为$GPNPort3Cnt7(cnt1)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt4(cnt9) < $rateL || $GPNPort3Cnt4(cnt9) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=50的数据流的速率为$GPNPort3Cnt4(cnt9)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=50的数据流的速率为$GPNPort3Cnt4(cnt9)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt4(cnt1) < $rateL || $GPNPort3Cnt4(cnt1) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=50的数据流的速率为$GPNPort3Cnt4(cnt1)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=50的数据流的速率为$GPNPort3Cnt4(cnt1)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt4(cnt2) < $rateL || $GPNPort3Cnt4(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=100的数据流的速率为$GPNPort3Cnt4(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=100的数据流的速率为$GPNPort3Cnt4(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	#NE4 GPNTestEth4 的接收
	if {$GPNPort4Cnt7(cnt1) < $rateL || $GPNPort4Cnt7(cnt1) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag数据流的速率为$GPNPort4Cnt7(cnt1)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag数据流的速率为$GPNPort4Cnt7(cnt1)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt4(cnt9) < $rateL || $GPNPort4Cnt4(cnt9) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=50的数据流的速率为$GPNPort4Cnt4(cnt9)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=50的数据流的速率为$GPNPort4Cnt4(cnt9)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt4(cnt1) < $rateL || $GPNPort4Cnt4(cnt1) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=50的数据流的速率为$GPNPort4Cnt4(cnt1)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=50的数据流的速率为$GPNPort4Cnt4(cnt1)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt4(cnt2) < $rateL || $GPNPort4Cnt4(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=100的数据流的速率为$GPNPort4Cnt4(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=100的数据流的速率为$GPNPort4Cnt4(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	
	return $flag
} 

########################################################################################################
#函数功能：NE1的AC为PORT+VLAN模式    NE3的AC为PORT模式    发流验证
#输入参数：printWord：打印的说明字符串
#	caseId：保存抓包文件时文件名字中使用的关键字
#	fileId：测试报告的文件标识符
#	rateL rateR：接收速率判断标准
#输出参数：无
#返回值：flag
########################################################################################################
proc PortVlan_port_repeat_014 {printWord caseId fileId rateL rateR} {
	set flag 0
	
	global gpnIp1
	global gpnIp3
	global gpnIp4
	global GPNTestEth1
	global GPNTestEth2
	global GPNTestEth3
	global GPNTestEth4
	global GPNTestEth5
			
	#NE1的GPNTestEth1 AC1发送untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100的数据流
	#NE4的GPNTestEth4 AC1发送untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100的数据流
	SendAndStat_ptn014 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 GPNPort5Cnt7\
		7 $::anaFliFrameCfg7 "$caseId"
	SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 GPNPort5Cnt1\
		1 $::anaFliFrameCfg1 "$caseId"
	SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt6 GPNPort2Cnt6 GPNPort3Cnt6 GPNPort4Cnt6 GPNPort5Cnt6\
		6 $::anaFliFrameCfg6 "$caseId"
	SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 GPNPort5Cnt0\
		0 $::anaFliFrameCfg0 "$caseId"
	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort1AnaFrameCfgFil $::anaFliFrameCfg1
	set ::hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $::hGPNPort1Ana -FilterName "custom-InnerVid" -Offset 18]
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort4Gen"  "$::hGPNPort1Ana"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort4Gen"  "$::hGPNPort1Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort4Gen"  "$::hGPNPort1Ana"
	after 10000
	array set GPNPort1Cnt4 {cnt1 0 cnt2 0 cnt3 0 cnt4 0 cnt5 0 cnt6 0 cnt7 0 cnt8 0 cnt9 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 4 $::hGPNPort1Ana GPNPort1Cnt4]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	parray GPNPort1Cnt4
	gwd::Stop_SendFlow "$::hGPNPort4Gen"  "$::hGPNPort1Ana"
	
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	
	#NE1 的GPNTestEth1接收
	if {$GPNPort1Cnt1(cnt1) < $rateL || $GPNPort1Cnt1(cnt1) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=50的数据流的速率为$GPNPort1Cnt1(cnt1)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送untag的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到tag=50的数据流的速率为$GPNPort1Cnt1(cnt1)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt6(cnt1) < $rateL || $GPNPort1Cnt6(cnt1) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=50(tpid=0x8100)的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到内层tag=50外层tag=50的数据流的速率为$GPNPort1Cnt6(cnt1)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=50(tpid=0x8100)的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到内层tag=50外层tag=50的数据流的速率为$GPNPort1Cnt6(cnt1)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt4(cnt3) < $rateL || $GPNPort1Cnt4(cnt3) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=50(tpid=0x9100)的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到内层tag=50外层tag=50的数据流的速率为$GPNPort1Cnt4(cnt3)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=50(tpid=0x9100)的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到内层tag=50外层tag=50的数据流的速率为$GPNPort1Cnt4(cnt3)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt6(cnt7) < $rateL || $GPNPort1Cnt6(cnt7) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到内层tag=100外层tag=50的数据流的速率为$GPNPort1Cnt6(cnt7)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\发送tag=100的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到内层tag=100外层tag=50的数据流的速率为$GPNPort1Cnt6(cnt7)，在$rateL-$rateR\范围内" $fileId
	}
	
	#NE3 的GPNTestEth3接收
	if {$GPNPort3Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
	}
	if {$GPNPort3Cnt7(cnt2) < $rateL || $GPNPort3Cnt7(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到untag的数据流的速率为$GPNPort3Cnt7(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到untag的数据流的速率为$GPNPort3Cnt7(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt3)" $fileId
	}
	if {$GPNPort3Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt4)" $fileId
	}
	#NE4 GPNTestEth4 的接收
	if {$GPNPort4Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
	}
	if {$GPNPort4Cnt7(cnt2) < $rateL || $GPNPort4Cnt7(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt7(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt7(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt3)" $fileId
	}
	if {$GPNPort4Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt4)" $fileId
	}
	
	return $flag
}
########################################################################################################
#函数功能：raw 模式NE1的AC为PORT+V1模式    NE3的AC为PORT+V2模式    发流验证
#输入参数：printWord：打印的说明字符串
#	caseId：保存抓包文件时文件名字中使用的关键字
#	fileId：测试报告的文件标识符
#	rateL rateR：接收速率判断标准
#输出参数：无
#返回值：flag
########################################################################################################
proc PortVlan1_portVlan2_repeat_014 {printWord caseId fileId rateL rateR} {
	set flag 0
	
	global gpnIp1
	global gpnIp3
	global gpnIp4
	global GPNTestEth1
	global GPNTestEth2
	global GPNTestEth3
	global GPNTestEth4
	global GPNTestEth5
			
	#NE1的GPNTestEth1 AC1发送untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100的数据流
	SendAndStat_ptn014 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 GPNPort5Cnt1\
		1 $::anaFliFrameCfg1 "$caseId"
	SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 GPNPort5Cnt7\
		7 $::anaFliFrameCfg7 "$caseId"
	SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 GPNPort5Cnt0\
		0 $::anaFliFrameCfg0 "$caseId"
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
			
	#NE3 的GPNTestEth3接收
	if {$GPNPort3Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
	}
	if {$GPNPort3Cnt1(cnt8) < $rateL || $GPNPort3Cnt1(cnt8) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=80的数据流的速率为$GPNPort3Cnt1(cnt8)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=80的数据流的速率为$GPNPort3Cnt1(cnt8)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt3)" $fileId
	}
	if {$GPNPort3Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt4)" $fileId
	}
	#NE4 GPNTestEth4 的接收
	if {$GPNPort4Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
	}
	if {$GPNPort4Cnt7(cnt2) < $rateL || $GPNPort4Cnt7(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt7(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt7(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt3)" $fileId
	}
	if {$GPNPort4Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt4)" $fileId
	}
	return $flag
}
########################################################################################################
#函数功能：tag 模式NE1的AC为PORT+V1模式    NE3的AC为PORT+V2模式    发流验证
#输入参数：printWord：打印的说明字符串
#	caseId：保存抓包文件时文件名字中使用的关键字
#	fileId：测试报告的文件标识符
#	rateL rateR：接收速率判断标准
#输出参数：无
#返回值：flag
########################################################################################################
proc PortVlan1_portVlan2_tag_repeat_014 {printWord caseId fileId rateL rateR} {
	set flag 0
	
	global gpnIp1
	global gpnIp3
	global gpnIp4
	global GPNTestEth1
	global GPNTestEth2
	global GPNTestEth3
	global GPNTestEth4
	global GPNTestEth5
			
	#NE1的GPNTestEth1 AC1发送untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100的数据流
	#NE3的GPNTestEth3 AC1发送untag tag=80(tpid=8100) tag=80(tpid=9100) tag=100的数据流
	SendAndStat_ptn014 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 GPNPort5Cnt7\
		7 $::anaFliFrameCfg7 "$caseId"
	SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt6 GPNPort2Cnt6 GPNPort3Cnt6 GPNPort4Cnt6 GPNPort5Cnt6\
		6 $::anaFliFrameCfg6 "$caseId"
	SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 GPNPort5Cnt0\
		0 $::anaFliFrameCfg0 "$caseId"
	gwd::Cfg_AnalyzerFrameCfgFilter $::hGPNPort3AnaFrameCfgFil $::anaFliFrameCfg0
	set ::hfilter16BitFilAna1 [stc::create Analyzer16BitFilter -under $::hGPNPort3Ana -FilterName "custom-etherType" -Offset 12]
	set ::hfilter16BitFilAna2 [stc::create Analyzer16BitFilter -under $::hGPNPort3Ana -FilterName "custom-vlanId" -Offset 14]
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 2000
	Recustomization 1 1 1 1 1 0
	gwd::Start_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	after 10000
	array set GPNPort3Cnt1 {cnt13 0}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt14 1 $::hGPNPort3Ana GPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 1 1 1 1 1 0
		after 5000
	}
	
	parray GPNPort3Cnt1
	gwd::Stop_SendFlow "$::hGPNPort1Gen"  "$::hGPNPort3Ana"
	
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	
	#NE1 的GPNTestEth1接收
	if {$GPNPort1Cnt0(cnt7) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\的AC1发送untag的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt7)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\的AC1发送untag的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt7)" $fileId
	}
	if {$GPNPort1Cnt6(cnt12) < $rateL || $GPNPort1Cnt6(cnt12) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\的AC1发送tag=80(tpid=0x8100)的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到外层tag=50内层tag=80的数据流的速率为$GPNPort1Cnt6(cnt12)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\的AC1发送tag=80(tpid=0x8100)的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到外层tag=50内层tag=80的数据流的速率为$GPNPort1Cnt6(cnt12)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort1Cnt0(cnt9) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\的AC1发送tag=80(tpid=0x9100)的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt9)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\的AC1发送tag=80(tpid=0x9100)的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt9)" $fileId
	}
	if {$GPNPort1Cnt0(cnt10) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\的AC1发送tag=100的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt10)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\的AC1发送tag=100的未知单播数据流，NE1($gpnIp1)\
			$GPNTestEth1\收到数据流的速率应为0实为$GPNPort1Cnt0(cnt10)" $fileId
	}
	
	#NE3 的GPNTestEth3接收
	if {$GPNPort3Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
	}
	if {$GPNPort3Cnt1(cnt13) < $rateL || $GPNPort3Cnt1(cnt13) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=80(tpid=0x9100)的数据流的速率为$GPNPort3Cnt1(cnt13)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到tag=80(tpid=0x9100)的数据流的速率为$GPNPort3Cnt1(cnt13)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort3Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt3)" $fileId
	}
	if {$GPNPort3Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt4)" $fileId
	}
	#NE4 GPNTestEth4 的接收
	if {$GPNPort4Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
	}
	if {$GPNPort4Cnt7(cnt2) < $rateL || $GPNPort4Cnt7(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt7(cnt2)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到untag的数据流的速率为$GPNPort4Cnt7(cnt2)，在$rateL-$rateR\范围内" $fileId
	}
	if {$GPNPort4Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt3)" $fileId
	}
	if {$GPNPort4Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt4)" $fileId
	}
	return $flag
}
########################################################################################################
#函数功能：NE1的AC为PORT+SVlan+Cvlan模式    NE3的AC为PORT+SVlan+Cvlan模式    发流验证
#输入参数：printWord：打印的说明字符串
#	caseId：保存抓包文件时文件名字中使用的关键字
#	fileId：测试报告的文件标识符
#	rateL rateR：接收速率判断标准
#输出参数：无
#返回值：flag
########################################################################################################
proc PortSVlanCvlan_portSVlanCvlan_repeat_014 {printWord caseId fileId rateL rateR} {
	set flag 0
	
	global gpnIp1
	global gpnIp3
	global gpnIp4
	global GPNTestEth1
	global GPNTestEth2
	global GPNTestEth3
	global GPNTestEth4
	global GPNTestEth5
			
	#NE1的GPNTestEth1 AC1发送untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100  tag= 80+500的数据流
	SendAndStat_ptn014 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 GPNPort5Cnt1\
		1 $::anaFliFrameCfg1 "$caseId"
	SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt6 GPNPort2Cnt6 GPNPort3Cnt6 GPNPort4Cnt6 GPNPort5Cnt6\
		6 $::anaFliFrameCfg6 "$caseId"
	SendAndStat_ptn014 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4 \
		$::hGPNPort5Cap $::hGPNPort5CapAnalyzer $gpnIp1" $::hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 GPNPort5Cnt0\
		0 $::anaFliFrameCfg0 "$caseId"
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
			
	#NE3 的GPNTestEth3接收
	if {$GPNPort3Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt1)" $fileId
	}
	if {$GPNPort3Cnt0(cnt2) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt2)" $fileId
	}
	if {$GPNPort3Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt3)" $fileId
	}
	if {$GPNPort3Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到数据流的速率应为0实为$GPNPort3Cnt0(cnt4)" $fileId
	}
	if {$GPNPort3Cnt6(cnt10) < $rateL || $GPNPort3Cnt6(cnt10) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送外层tag=80内层tag=500的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到外层tag=80内层tag=500的数据流的速率为$GPNPort3Cnt6(cnt10)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送外层tag=80内层tag=500的未知单播数据流，NE3($gpnIp3)\
			$GPNTestEth3\收到外层tag=80内层tag=500的数据流的速率为$GPNPort3Cnt6(cnt10)，在$rateL-$rateR\范围内" $fileId
	}
	#NE4 GPNTestEth4 的接收
	if {$GPNPort4Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送untag的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt1)" $fileId
	}
	if {$GPNPort4Cnt0(cnt2) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x8100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt2)" $fileId
	}
	if {$GPNPort4Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=50(tpid=0x9100)的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt3)" $fileId
	}
	if {$GPNPort4Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送tag=100的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到数据流的速率应为0实为$GPNPort4Cnt0(cnt4)" $fileId
	}
	if {$GPNPort4Cnt1(cnt12) < $rateL || $GPNPort4Cnt1(cnt12) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送外层tag=80内层tag=500的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=500的数据流的速率为$GPNPort4Cnt1(cnt12)，没在$rateL-$rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\的AC1发送外层tag=80内层tag=500的未知单播数据流，NE4($gpnIp4)\
			$GPNTestEth4\收到tag=500的数据流的速率为$GPNPort4Cnt1(cnt12)，在$rateL-$rateR\范围内" $fileId
	}
	return $flag
}

proc Check_Tracertroute {printWord expectTrace resultTrace} {
	set flag 0
	dict for {key value} $expectTrace {
		if {[dict exists $resultTrace $key]} {
			if {[dict get $value replier] == [dict get $resultTrace $key replier]} {
				gwd::GWpublic_print "OK" "$printWord\TTL=$key\的replier应为[dict get $value replier]实际为[dict get $resultTrace $key replier]" $::fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\TTL=$key\的replier应为[dict get $value replier]实际为[dict get $resultTrace $key replier]" $::fileId
			}
			if {[dict get $value traceTime] == [dict get $resultTrace $key traceTime]} {
				gwd::GWpublic_print "OK" "$printWord\TTL=$key\的traceTime应为[dict get $value traceTime]实际为[dict get $resultTrace $key traceTime]" $::fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\TTL=$key\的traceTime应为[dict get $value traceTime]实际为[dict get $resultTrace $key traceTime]" $::fileId
			}
			if {[dict get $value type] == [dict get $resultTrace $key type]} {
				gwd::GWpublic_print "OK" "$printWord\TTL=$key\的type应为[dict get $value type]实际为[dict get $resultTrace $key type]" $::fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\TTL=$key\的type应为[dict get $value type]实际为[dict get $resultTrace $key type]" $::fileId
			}
			if {[dict get $value downstream] == [dict get $resultTrace $key downstream]} {
				gwd::GWpublic_print "OK" "$printWord\TTL=$key\的downstream应为[dict get $value downstream]实际为[dict get $resultTrace $key downstream]" $::fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\TTL=$key\的downstream应为[dict get $value downstream]实际为[dict get $resultTrace $key downstream]" $::fileId
			}
			if {[dict get $value ret] == [dict get $resultTrace $key ret]} {
				gwd::GWpublic_print "OK" "$printWord\TTL=$key\的ret应为[dict get $value ret]实际为[dict get $resultTrace $key ret]" $::fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\TTL=$key\的ret应为[dict get $value ret]实际为[dict get $resultTrace $key ret]" $::fileId
			}
		} else {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\没有TTL=$key\的表项" $::fileId
		}
		
	}
	return $flag
}



########################################################################################################
#函数功能：反复操作后比较系统资源前后的值是否符合要求
#输入参数：printWord：打印的说明字符串
#	fileId：测试报告的文件标识符
#	printWord：打印信息，举例："第$i次重启$matchType1\的NNI口UNI口"
#	oldResult ：反复操作前读取的系统资源值
#	newResult ：反复操作后读取的系统资源值
#输出参数：无
#返回值：flag =0，所有值的变化符合要求   =1有参数值的变化不符合要求
########################################################################################################
proc CheckSystemResource {fileId printWord oldResult newResult} {
	set flag 0
	global cpuErrRatio
	global sysErrRatio
	global userErrRatio

	dict for {key value} $oldResult {
		set errRatio [expr abs ([dget $newResult $key cpu] - [dget $value cpu])]
		if {$errRatio > $cpuErrRatio} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\前$key\槽位cpu的利用率为[dget $value cpu]，$printWord\后cpu的利用率为[dget $newResult $key cpu]。cpu利用率的变化为$errRatio\%大于可接受的最大值$cpuErrRatio" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\前$key\槽位cpu的利用率为[dget $value cpu]，$printWord\后cpu的利用率为[dget $newResult $key cpu]。cpu利用率的变化为$errRatio\%小于等于可接受的最大值$cpuErrRatio" $fileId
		}
		set errRatio [expr abs ([dget $newResult $key sys] - [dget $value sys])]
		if {$errRatio > $sysErrRatio} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\前$key\槽位sys的利用率为[dget $value sys]，$printWord\后sys的利用率为[dget $newResult $key sys]。sys利用率的变化为$errRatio\%大于可接受的最大值$sysErrRatio" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\前$key\槽位sys的利用率为[dget $value sys]，$printWord\后sys的利用率为[dget $newResult $key sys]。sys利用率的变化为$errRatio\%小于等于可接受的最大值$sysErrRatio" $fileId
		}
		set errRatio [expr abs ([dget $newResult $key user] - [dget $value user])]
		if {$errRatio > $userErrRatio} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\前$key\槽位user的利用率为[dget $value user]，$printWord\后user的利用率为[dget $newResult $key user]。user利用率的变化为$errRatio\%大于可接受的最大值$userErrRatio" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\前$key\槽位user的利用率为[dget $value user]，$printWord\后user的利用率为[dget $newResult $key user]。user利用率的变化为$errRatio\%小于等于可接受的最大值$userErrRatio" $fileId
		}
	}
	return $flag
}
########################################################################################################
#函数功能：ELAN业务容量测试统计ac和pw数量不同时的业务流情况
#输入参数：        flag： 1表示在发未知单播   2表示在发已知单播和协议报文    
#                  hAna1：本端端口分析器handle
#                  hAna2：对端端口分析器handle
#返回值：无
#输出参数：                    
#唐丽春
#########################################################################################################
proc MPLS_ClassStatisticsAna {flag infoObj1 infoObj2 vid1 smac1 vid2 smac2 valuedrop1 valuedrop2 valuecnt1 valuecnt2 caseId} {
		upvar $valuedrop1 tmpvalue1
		upvar $valuedrop2 tmpvalue2
		upvar $valuecnt1 tmpCnt1
		upvar $valuecnt2 tmpCnt2
		set errorTmp 0
		set tmpCnt1 0
		if {[string length $smac1]>0 && [string length $vid1]>0} {
			set errorTmp [MPLS_ClassStatisticsStream $flag $infoObj1 $vid1 $smac1 tmpvalue1 tmpCnt1 $caseId $::matchType1 $::matchType2 $::hGPNPort1Cap $::hGPNPort1CapAnalyzer]
			set drop1 [lsort -decreasing $tmpvalue1]
			foreach {dropmax1} $drop1 {break}
		}
		if {[string length $smac2]>0 && [string length $vid2]>0} {
			set errorTmp [MPLS_ClassStatisticsStream $flag $infoObj2 $vid2 $smac2 tmpvalue2 tmpCnt2 $caseId $::matchType2 $::matchType1 $::hGPNPort2Cap $::hGPNPort2CapAnalyzer]
			set drop2 [lsort -decreasing $tmpvalue2]
			foreach {dropmax2} $drop2 {break}
		}
		if {[string equal -nocase "1" $flag]} {
			if {$dropmax1 == 0 && $dropmax2 == 0} {
				gwd::GWpublic_print OK "NE1($::gpnIp1)和NE2($::gpnIp2)发送未知单播1M，端口$::GPNTestEth1\接收到1*([expr $tmpCnt1])M流，端口$::GPNTestEth2接收到*([expr $tmpCnt2])M流,\业务收到全部的流。" $::fileId
			} elseif {$errorTmp == 1} {
				gwd::GWpublic_print NOK "NE1($::gpnIp1)和NE2($::gpnIp2)发送未知单播1M，端口没有收到全部的流。" $::fileId
			} elseif {$tmpCnt1 == 0 && $errorTmp == 0} {
				gwd::GWpublic_print OK "NE1($::gpnIp1)发送未知单播1M，端口$::GPNTestEth2接收到0.001*([expr $tmpCnt2])M流,\业务收到全部的流。" $::fileId
			}

		} elseif {[string equal -nocase "2" $flag]} {
			if {$dropmax1 > 0 || $dropmax2 >0 || $errorTmp == 1} {
				set errorTmp 1
				gwd::GWpublic_print NOK "NE1($::gpnIp1)和NE2($::gpnIp2)发送已知单播600M，业务丢包，请查看report。" $::fileId
			} else {
				gwd::GWpublic_print OK "NE1($::gpnIp1)和NE2($::gpnIp2)发送已知单播600M，业务不丢包。" $::fileId
			}
		} elseif {[string equal -nocase "3" $flag]} {
			if {$dropmax2 > 0 || $errorTmp == 1} {
				gwd::GWpublic_print NOK "NE1($::gpnIp1)的UNI口发送0.001M业务流量（源mac变化、不同波长报文），业务流丢包" $::fileId
			} else {
				gwd::GWpublic_print OK "NE1($::gpnIp1)的UNI口发送0.001M业务流量（源mac变化、不同波长报文），业务不丢包。" $::fileId
			}
		} elseif {[string equal -nocase "4" $flag]} {
			if {$dropmax1 == 0 && $dropmax2 == 0} {
				gwd::GWpublic_print OK "NE1($::gpnIp1)和NE2($::gpnIp2)发送已知单播600M，端口$::GPNTestEth1\接收到[expr $tmpCnt1]条共计600M流，端口$::GPNTestEth2接收到[expr $tmpCnt2]条共计600M流,\业务收到全部的流。" $::fileId
			} elseif {$dropmax1 > 0 || $dropmax2 > 0 || $errorTmp == 1} {
				gwd::GWpublic_print NOK "NE1($::gpnIp1)和NE2($::gpnIp2)发送已知单播500M，端口没有收到全部的流。" $::fileId

			}
		} 
		return $errorTmp 
	}
########################################################################################################
#函数功能：统计业务流的丢包情况
#输入参数：            
#                   hAna：端口分析器handle
#					vid：vlan的id
#					smac：源mac地址
#					DropCnt：统计结果
#					flag:1 发送未知单播 2 发送已知单播和各种协议报文
#返回值：无
#输出参数：
#唐丽春
########################################################################################################
proc MPLS_ClassStatisticsStream {flag infoObj vid smac valuedrop valuecnt caseId sendType returnType hGPNPortCap hGPNPortCapAnalyzer} {
		upvar $valuedrop tmpvalue
		upvar $valuecnt tmpCnt
		set errorTmp 0
		set tmpvalue -1
		set tmpCnt 0
		gwd::Start_SendFlow  $::hGPNPortGenList  $::hGPNPortAnaList
    	
		set protocolresults {p1 {name crcsmac value "00:10:94:00:00:01"
											}
		     							 p2 {name arp_reply value "00:10:94:00:00:02"
		     							    }
		     							 p3 {name 组播 value "00:10:94:00:00:03"    
		     							    }
		     							 p4 {name pim-1 value "00:10:94:00:00:04"			     
		     							    }
		     							 p5 {name pimv6-1 value "00:10:94:00:00:05"
		     							    }
		     							 p6 {name ldp value "00:10:94:00:00:06"
										 	}
		     							 p7 {name ospf-1 value "00:10:94:00:00:07"
										 	}
		     							 p8 {name ospf-2 value "00:10:94:00:00:08"
										 	}
                    					 p9 {name rip value "00:10:94:00:00:09"
                    					    }
                    					 p10 {name pim-2 value "00:10:94:00:00:10"  
                    					    }
                    					 p11 {name pimv6-2 value "00:10:94:00:00:11" 
                    					    }
                    					 p12 {name cfm value "00:10:94:00:00:12"
                    					    }
                    					 p13 {name lacp/eth/efm value "00:10:94:00:00:13"
                    					    }
                    					 p14 {name lldp value "00:10:94:00:00:14"
                    					    }
                    					 p15 {name isis-1 value "00:10:94:00:00:15"
                    					    }
                    					 p16 {name isis-2 value "00:10:94:00:00:16"
                    					    }
                    					 p17 {name mrps value "00:10:94:00:00:17"  
                    					    }
                    					 p18 {name isis-3 value "00:10:94:00:00:18"
                    					    }
                    					 p19 {name ospfv3-1 value "00:10:94:00:00:19"
                    					    }
                    					 p20 {name ospfv3-2 value "00:10:94:00:00:20"
                    					    }
		    							 p21 {name rping value "00:10:94:00:00:21"
										 }
		    							 p22 {name arp-req value "00:10:94:00:00:22"
										 }
		    							  p23 {name 广播 value "00:10:94:00:00:23"
										 }
									}
#		同步分析器和发生器统计延时2s  
		after 4000
		stc::perform ResultsClearAll -PortList $hGPNPortCap
		if {$::cap_enable} {
			gwd::Start_CapAllData ::capArr $hGPNPortCap $hGPNPortCapAnalyzer
		}
		if {$::cap_enable} {
			gwd::Stop_CapData $hGPNPortCap 1 "$caseId-p_cap\($returnType\).pcap"
		}
		gwd::GWpublic_print "  " "抓包文件为$caseId-p\($returnType\).pcap" $::fileId
		send_log "\n time1:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		set totalPage [stc::get $infoObj -TotalPageCount]
		send_log "页数：$totalPage"
		set i 1
		for {set pageNum 1} {$pageNum <= $totalPage} {incr pageNum} {
			stc::config $infoObj -PageNumber $pageNum
			stc::apply
			after 4000
			send_log "\n time@@@@@:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
			set lstRxResults [stc::get $infoObj -ResultHandleList]
			
			foreach resultsObj $lstRxResults {
				set d [stc::get $resultsObj]]
				array set aResults $d
				gwd::Clear_ResultViewStat $resultsObj
				if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && [string match -nocase "Source MAC" $aResults(-FilteredName_2)]\
					&& $aResults(-L1BitRate) != 0} {
					lappend resultList2 $aResults(-FilteredValue_2) $aResults(-DroppedFrameCount)
					lappend resultList1 $aResults(-FilteredValue_1) $resultList2
					lappend finalresult $i $resultList1
					set resultList2 [lreplace $resultList2 0 1]
					set resultList1 [lreplace $resultList1 0 1]
					incr i
				} 
			}
			send_log "\n time#####:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		}
		send_log "\n finalresult:$finalresult"
		send_log "\n time2:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		set a 1
		set b 0
		after 60000
    	gwd::Stop_SendFlow  $::hGPNPortGenList  $::hGPNPortAnaList
		if {[string equal -nocase "2" $flag]} {
			for {set m 1} {$m < [expr $::acPwCnt]} {incr m} {
				set tmpvid [expr $vid+$m-1]
				foreach item [dict keys $finalresult] {
					set tmpitem [dict get $finalresult $item]
					if {[dict exists $tmpitem $tmpvid]} {
						dict for {key value} [dict get $tmpitem $tmpvid] {
							if {$a==256} {
								incr b
								set a 0
							}
							if {[string match -nocase "00:00:00:01:00:01" $smac]} {
								set tmpsmac 00:00:00:01:[format %02x $b]:[format %02x $a]
							} elseif {[string match -nocase "00:00:00:00:00:01" $smac]} {
								set tmpsmac 00:00:00:00:[format %02x $b]:[format %02x $a]
							} elseif {[string match -nocase "00:00:00:10:00:01" $smac]} {
								set tmpsmac 00:00:00:10:[format %02x $b]:[format %02x $a]
							} elseif {[string match -nocase "00:00:00:20:00:01" $smac]} {
								set tmpsmac 00:00:00:20:[format %02x $b]:[format %02x $a]
							} elseif {[string match -nocase "00:00:00:30:00:01" $smac]} {
								set tmpsmac 00:00:00:30:[format %02x $b]:[format %02x $a]
							} elseif {[string match -nocase "00:00:00:40:00:01" $smac]} {
								set tmpsmac 00:00:00:40:[format %02x $b]:[format %02x $a]
							} elseif {[string match -nocase "00:00:00:50:00:01" $smac]} {
								set tmpsmac 00:00:00:50:[format %02x $b]:[format %02x $a]
							} elseif {[string match -nocase "00:00:00:60:00:01" $smac]} {
								set tmpsmac 00:00:00:60:[format %02x $b]:[format %02x $a]
							}
							lappend  tmpvalue $value		
							if {$value > 0 && [string match -nocase $key $tmpsmac]} {
								set errorTmp 1
								gwd::GWpublic_print "NOK" "$sendType\发送已知单播600M，$returnType\收到已知单播(vid:$tmpvid\,smac:$key)\，丢包数为$value" $::fileId	
							}
						}
						# foreach item [dict keys $protocolresults] {
						# 	set valuemac [dict get $protocolresults $item value]
						# 	set valuename [dict get $protocolresults $item name]
						# 	if {$value > 0 [string match -nocase $valuemac $key]} {
						# 		set errorTmp 1
						# 		gwd::GWpublic_print NOK "NE1($::gpnIp1)发送协议报文$valuename，NE2($::gpnIp2)收到报文丢包，丢包数为$value" $::fileId
						# 	}
						# }
						
					}
					
				}
				incr a
				incr tmpCnt
			}
		} elseif {[string equal -nocase "1" $flag]} {
				for {set m 1} {$m < [expr $::acPwCnt]} {incr m} {
					set tmpvid [expr $vid+$m-1]
					foreach item [dict keys $finalresult] {
					set tmpitem [dict get $finalresult $item]
					if {[dict exists $tmpitem $tmpvid]} {
						dict for {key value} [dict get $tmpitem $tmpvid] {
							lappend tmpvalue $value
							if {$value > 0 && [string match -nocase $key $smac]} {
								set errorTmp 1
								gwd::GWpublic_print "NOK" "$sendType\发送未知单播（vid:$vid,smac:$smac）1M，$returnType\收到未知单播(vid:$tmpvid\,smac:$key)\，丢包数为$value" $::fileId	
							} 
						}
						
					}
					
				} 
				incr tmpCnt
			} 
		} elseif {[string equal -nocase "3" $flag]} {
				if {[string match "1000" $vid] && [string match -nocase "00:00:00:00:00:01" $smac]} {
					for {set m 1} {$m < [expr $::acPwCnt]} {incr m} {
						foreach item [dict keys $finalresult] {
							set tmpitem [dict get $finalresult $item]
							if {[dict exists $tmpitem "1000"]} {
							dict for {key value} [dict get $tmpitem "1000"] {
							if {$a==256} {
								incr b
								set a 0
							}
							lappend tmpvalue $value
							set tmpsmac 00:00:00:01:[format %02x $b]:[format %02x $a]	
							if {$value > 0 && [string match -nocase $key $tmpsmac]} {
								set errorTmp 1
								gwd::GWpublic_print "NOK" "NE1($::gpnIp1)\发送业务流（vid:1000,smac:$key），NE2($::gpnIp2)收到业务流(vid:1000\,smac:$key)\，丢包数为$value" $::fileId	
							}
						}
						# foreach item [dict keys $protocolresults] {
						# 	set valuemac [dict get $protocolresults $item value]
						# 	set valuename [dict get $protocolresults $item name]
						# 	if {$value > 0 [string match -nocase $valuemac $key]} {
						# 		set errorTmp 1
						# 		gwd::GWpublic_print NOK "NE1($::gpnIp1)发送协议报文$valuename，NE2($::gpnIp2)收到报文丢包，丢包数为$value" $::fileId
						# 		}
						# 	}
							
						}
						
					}
				incr a
				incr tmpCnt
			}
		}
	} elseif {[string equal -nocase "4" $flag]} {
		for {set m 1} {$m < [expr $::acPwCnt]} {incr m} {
						foreach item [dict keys $finalresult] {
							set tmpitem [dict get $finalresult $item]
							if {[dict exists $tmpitem "1000"]} {
							dict for {key value} [dict get $tmpitem "1000"] {
							if {$a==256} {
								incr b
								set a 0
							}
							lappend tmpvalue $value
							set tmpsmac 00:00:00:01:[format %02x $b]:[format %02x $a]	
							if {$value > 0 && [string match -nocase $key $tmpsmac]} {
								set errorTmp 1
								gwd::GWpublic_print "NOK" "$sendType\发送已知单播（vid:$vid,smac:$tmpsmac）1M，$returnType\收到已知单播(vid:$vid\,smac:$key)\丢包" $::fileId	
							}
						}
						# foreach item [dict keys $protocolresults] {
						# 	set valuemac [dict get $protocolresults $item value]
						# 	set valuename [dict get $protocolresults $item name]
						# 	if {$value > 0 [string match -nocase $valuemac $key]} {
						# 		set errorTmp 1
						# 		gwd::GWpublic_print NOK "NE1($::gpnIp1)发送协议报文$valuename，NE2($::gpnIp2)收到报文丢包，丢包数为$value" $::fileId
						# 		}
						# 	}
							
					}
					
				}
			incr a
			incr tmpCnt
		}

	}

	send_log "resultcnt:$tmpCnt\n"
	return $errorTmp
}
#########################################################################################################
#函数功能：端口 性能统计测试
#输入参数: lStream:要发送的数据流
#         eth 、lspName 、pwName 、acName：要统计的端口
#         hGPNPortAna：与eth相连的TC analyzer的handle
#         hGPNPortGen：与eth相连的TC generator的handle
#返回值：flag =0 所有统计正确    =1有统计不正确的项
########################################################################################################
proc PTN_ETH_Stat {spawn_id matchType dutType fileId eth hGPNPort1Ana hGPNPort1Gen hGPNPort2Ana hGPNPort2Gen} {
	set flag 0
	stc::perform ResultsClearViewCommand -ResultList "[stc::get $hGPNPort1Ana -children-AnalyzerPortResults] [stc::get $hGPNPort2Ana -children-AnalyzerPortResults] [stc::get $hGPNPort1Gen -children-GeneratorPortResults] [stc::get $hGPNPort2Gen -children-GeneratorPortResults]"
	#gwd::GPN_ClearPortStat
	gwd::GWpublic_getPortStat $spawn_id $matchType $dutType $fileId $eth GPNPortStat1
    gwd::Start_SendFlow  $::hGPNPortGenList  $::hGPNPortAnaList
    after 60000
    gwd::Stop_SendFlow  $::hGPNPortGenList  $::hGPNPortAnaList
	after 20000
	# stc::perform streamBlockActivate \
	# 	-streamBlockList "$lStream" \
	# 	-activate "false"
	send_log "\n time1:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
	set rxCnt_port1 [stc::get $hGPNPort1Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port1 [stc::get $hGPNPort1Gen.GeneratorPortResults -GeneratorSigFrameCount]
    set rxCnt_port2 [stc::get $hGPNPort2Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port2 [stc::get $hGPNPort2Gen.GeneratorPortResults -GeneratorSigFrameCount]
	gwd::GWpublic_getPortStat $spawn_id $matchType $dutType $fileId $eth GPNPortStat2
	send_log "rxCnt_port1:$rxCnt_port1\n txCnt_port1:$txCnt_port1\n rxCnt_port2:$rxCnt_port2 \n txCnt_port2 $txCnt_port2"
    set PortFrameOut [expr $GPNPortStat2(-outUniPkts)-$GPNPortStat1(-outUniPkts)]
	if {$PortFrameOut != [expr $txCnt_port1*($::acPwCnt-1)]
	} {
		set flag 1
	}
	gwd::GWpublic_print [expr {($PortFrameOut == [expr $txCnt_port1*($::acPwCnt-1)]) ? "OK" : "NOK"}] "$matchType\的$eth\的outTotalPkts统计发送数据流前为$GPNPortStat1(-outTotalPkts)\
		发送数据流后为$GPNPortStat2(-outUniPkts)，差值应为[expr $txCnt_port1*($::acPwCnt-1)]\实为$PortFrameOut,NE1发流$txCnt_port1\,NE2收流$rxCnt_port2" $fileId
	return $flag
}

########################################################################################################
#函数功能：统计业务流的丢包情况
#输入参数：
#返回值：无
#输出参数：
#唐丽春
########################################################################################################
proc MPLS_ClassStatisticsPort {fileId hGPNPort1Ana hGPNPort1Gen hGPNPort2Ana hGPNPort2Gen caseId} {
	set errorTmp 0
	stc::perform ResultsClearAll -PortList $::lport1
	stc::perform ResultsClearViewCommand -ResultList "[stc::get $hGPNPort1Ana -children-AnalyzerPortResults] [stc::get $hGPNPort2Ana -children-AnalyzerPortResults] [stc::get $hGPNPort1Gen -children-GeneratorPortResults] [stc::get $hGPNPort2Gen -children-GeneratorPortResults]"
    set rxCnt_port1 [stc::get $hGPNPort1Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port1 [stc::get $hGPNPort1Gen.GeneratorPortResults -GeneratorSigFrameCount]
    set rxCnt_port2 [stc::get $hGPNPort2Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port2 [stc::get $hGPNPort2Gen.GeneratorPortResults -GeneratorSigFrameCount]
        send_log "\nNE1($::gpnIp1)发包：$txCnt_port1\,收到包个数为：$rxCnt_port1\n\NE2($::gpnIp2)发包：$txCnt_port2\,收到包个数为：$rxCnt_port2"

    gwd::Start_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
    after 30000
    stc::perform ResultsClearAll -PortList $::hGPNPort1Cap
		stc::perform ResultsClearAll -PortList $::hGPNPort2Cap
		if {$::cap_enable} {
			gwd::Start_CapAllData ::capArr $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
			gwd::Start_CapAllData ::capArr $::hGPNPort2Cap $::hGPNPort2CapAnalyzer
		}
		if {$::cap_enable} {
			gwd::Stop_CapData $::hGPNPort1Cap 1 "$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap"
			gwd::Stop_CapData $::hGPNPort2Cap 1 "$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap"
		}
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap" $::fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $::fileId
	gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	after 2000
    set rxCnt_port1 [stc::get $hGPNPort1Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port1 [stc::get $hGPNPort1Gen.GeneratorPortResults -GeneratorSigFrameCount]
    set rxCnt_port2 [stc::get $hGPNPort2Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port2 [stc::get $hGPNPort2Gen.GeneratorPortResults -GeneratorSigFrameCount]
    send_log "\nNE1($::gpnIp1)发包：$txCnt_port1\,收到包个数为：$rxCnt_port1\n\NE2($::gpnIp2)发包：$txCnt_port2\,收到包个数为：$rxCnt_port2"
    if {$rxCnt_port2 == $txCnt_port1} {
    	gwd::GWpublic_print "OK" "NE1和NE2互发已知单播600M，NE1($::gpnIp1)发包数$txCnt_port1\,NE2($::gpnIp2)收包数$rxCnt_port2\,业务不丢包" $fileId
    } else {
    	set errorTmp 1
    	gwd::GWpublic_print "NOK" "NE1和NE2互发已知单播600M，NE1($::gpnIp1)发包数$txCnt_port1\,NE2($::gpnIp2)收包数$rxCnt_port2\,业务丢包" $fileId
    }
    if {$rxCnt_port1 == $txCnt_port2} {
    	gwd::GWpublic_print "OK" "NE1和NE2互发已知单播600M，NE2($::gpnIp2)发包数$txCnt_port2\,NE1($::gpnIp1)收包数$rxCnt_port1\,业务不丢包" $fileId
    } else {
    	set errorTmp 1
    	gwd::GWpublic_print "NOK" "NE1和NE2互发已知单播600M，NE2($::gpnIp2)发包数$txCnt_port2\,NE1($::gpnIp1)收包数$rxCnt_port1\,业务丢包" $fileId
    }
    return $errorTmp
}

########################################################################################################
#函数功能：ELAN业务容量测试统计vsi数量不同时的业务流情况
#输入参数：        flag： 1表示在发未知单播   2表示在发已知单播和协议报文    
#                  hAna1：本端端口分析器handle
#                  hAna2：对端端口分析器handle
#返回值：无
#输出参数：                    
#唐丽春
#########################################################################################################
proc MPLS_ClassStatisticsAna4 {flag infoObj1 infoObj2 infoObj3 infoObj4 vid1 smac1 vid2 smac2 vid3 smac3 vid4 smac4 valuedrop1 valuedrop2 valuedrop3 valuedrop4 valuecnt1 valuecnt2 valuecnt3 valuecnt4 caseId} {
		upvar $valuedrop1 tmpvalue1
		upvar $valuedrop2 tmpvalue2
		upvar $valuedrop3 tmpvalue4
		upvar $valuedrop3 tmpvalue4
		upvar $valuecnt1 tmpCnt1
		upvar $valuecnt2 tmpCnt2
		upvar $valuecnt3 tmpCnt3
		upvar $valuecnt4 tmpCnt4
		set errorTmp 0
		if {[string length $smac1]>0 && [string length $vid1]>0} {
			set errorTmp [MPLS_ClassStatisticsStream $flag $infoObj1 $vid1 $smac1 tmpvalue1 tmpCnt1 $caseId $::matchType1 $::matchType2 $::hGPNPort1Cap $::hGPNPort1CapAnalyzer]
		}
		if {[string length $smac2]>0 && [string length $vid2]>0} {
			set errorTmp [MPLS_ClassStatisticsStream $flag $infoObj2 $vid2 $smac2 tmpvalue2 tmpCnt2 $caseId $::matchType1 $::matchType2 $::hGPNPort2Cap $::hGPNPort2CapAnalyzer]
		}
		if {[string length $smac3]>0 && [string length $vid3]>0} {
			set errorTmp [MPLS_ClassStatisticsStream $flag $infoObj3 $vid3 $smac3 tmpvalue3 tmpCnt3 $caseId $::matchType1 $::matchType3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer]
		}
		if {[string length $smac4]>0 && [string length $vid4]>0} {
			set errorTmp [MPLS_ClassStatisticsStream $flag $infoObj4 $vid4 $smac4 tmpvalue4 tmpCnt4 $caseId $::matchType1 $::matchType2 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer]
		}
		if {[string equal -nocase "1" $flag]} {
			set drop3 [lsort -decreasing $tmpvalue3]
			set drop2 [lsort -decreasing $tmpvalue2]
			set drop4 [lsort -decreasing $tmpvalue4]
			foreach {dropmax3} $drop3 {break}
			foreach {dropmax2} $drop2 {break}
			foreach {dropmax4} $drop4 {break}
			if {$tmpCnt2 > 0 && $tmpCnt3 > 0 && $tmpCnt4 > 0 && $errorTmp == 0} {
				gwd::GWpublic_print OK "NE1($::gpnIp1)发送未知单播$::loadcnt\M,NE2端口$::GPNTestEth2接收到$::loadcnt\M流,NE3端口$::GPNTestEth3接收到$::loadcnt\M流,NE4端口$::GPNTestEth4接收到$::loadcnt\M流业务收到全部的流。" $::fileId
			} elseif {$dropmax2 > 0 || $dropmax3 > 0 || $dropmax4 > 0 || $errorTmp == 1} {
				gwd::GWpublic_print NOK "NE1($::gpnIp1)发送未知单播$::loadcnt\M，端口没有收到全部的流,存在丢包，" $::fileId

			}

		}
		return $errorTmp 
	}


########################################################################################################
#函数功能：统计业务流的丢包情况挂长期测试
#输入参数：
#返回值：无
#输出参数：
#唐丽春
########################################################################################################
proc MPLS_ClassStatisticsPort4 {fileId hGPNPort1Ana hGPNPort1Gen hGPNPort2Ana hGPNPort2Gen hGPNPort3Ana hGPNPort3Gen hGPNPort4Ana hGPNPort4Gen lTermTime flag} {
	set errorTmp 0
	stc::perform ResultsClearViewCommand -ResultList "[stc::get $hGPNPort1Ana -children-AnalyzerPortResults] [stc::get $hGPNPort2Ana -children-AnalyzerPortResults] [stc::get $hGPNPort3Ana -children-AnalyzerPortResults] [stc::get $hGPNPort1Gen -children-GeneratorPortResults] [stc::get $hGPNPort2Gen -children-GeneratorPortResults] [stc::get $hGPNPort4Ana -children-AnalyzerPortResults] [stc::get $hGPNPort3Gen -children-GeneratorPortResults] [stc::get $hGPNPort4Gen -children-GeneratorPortResults]"
    gwd::Start_SendFlow $::hGPNPortGenList $::hGPNPortAnaList
    after [expr $lTermTime*3600*1000]
	gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	after 2000
    set rxCnt_port1 [stc::get $hGPNPort1Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port1 [stc::get $hGPNPort1Gen.GeneratorPortResults -GeneratorSigFrameCount]
    set rxCnt_port2 [stc::get $hGPNPort2Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port2 [stc::get $hGPNPort2Gen.GeneratorPortResults -GeneratorSigFrameCount]
    set rxCnt_port3 [stc::get $hGPNPort3Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port3 [stc::get $hGPNPort3Gen.GeneratorPortResults -GeneratorSigFrameCount]
    set rxCnt_port4 [stc::get $hGPNPort4Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port4 [stc::get $hGPNPort4Gen.GeneratorPortResults -GeneratorSigFrameCount]
    send_log "\nNE1($::gpnIp1)发包：$txCnt_port1\,收到包个数为：$rxCnt_port1\n\NE2($::gpnIp2)发包：$txCnt_port2\,收到包个数为：$rxCnt_port2\
    \n\NE3($::gpnIp3)发包：$txCnt_port3\,收到包个数为：$rxCnt_port3\n\NE4($::gpnIp4)发包：$txCnt_port4\,收到包个数为：$rxCnt_port4"
    if {[string equal -nocase "1" $flag]} {
    		if {$rxCnt_port1 == $txCnt_port2} {
    			gwd::GWpublic_print "OK" "NE1($::gpnIp1)发包数$txCnt_port1\,NE2($::gpnIp2)收包数$rxCnt_port2\,业务不丢包" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj2 "1000" "00:00:00:00:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_2_FA10" $::matchType1 $::matchType2 $::hGPNPort2Cap $::hGPNPort2CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)发包数$txCnt_port1\,NE2($::gpnIp2)收包数$rxCnt_port2\,业务丢包" $fileId
    		}
    		if {$rxCnt_port2 == $txCnt_port1} {
    			gwd::GWpublic_print "OK" "NE2($::gpnIp2)发包数$txCnt_port2\,NE1($::gpnIp1)收包数$rxCnt_port1\,业务不丢包" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj1 "1000" "00:00:00:01:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_2_FA10" $::matchType2 $::matchType1 $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)发包数$txCnt_port2\,NE1($::gpnIp1)收包数$rxCnt_port1\,业务丢包" $fileId
    		}
    	} elseif {[string equal -nocase "2" $flag]} {
    		if {$rxCnt_port1 == $txCnt_port2} {
    			gwd::GWpublic_print "OK" "NE1($::gpnIp1)发包数$txCnt_port1\,NE2($::gpnIp2)收包数$rxCnt_port2\,业务不丢包" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj2 "1000" "00:00:00:00:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_3_FB10" $::matchType1 $::matchType2 $::hGPNPort2Cap $::hGPNPort2CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)发包数$txCnt_port1\,NE2($::gpnIp2)收包数$rxCnt_port2\,业务丢包" $fileId
    		}
    		if {$rxCnt_port2 == $txCnt_port1} {
    			gwd::GWpublic_print "OK" "NE2($::gpnIp2)发包数$txCnt_port2\,NE1($::gpnIp1)收包数$rxCnt_port1\,业务不丢包" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj1 "1000" "00:00:00:01:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_3_FB10" $::matchType2 $::matchType1 $::hGPNPort1Cap $::hGPNPort1CapAnalyzer

    			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)发包数$txCnt_port2\,NE1($::gpnIp1)收包数$rxCnt_port1\,业务丢包" $fileId
    		}

    	} elseif {[string equal -nocase "3" $flag]} {
    		if {$rxCnt_port1 == $txCnt_port1} {
    			gwd::GWpublic_print "OK" "NE1($::gpnIp1)发包数$txCnt_port1\,NE1($::gpnIp1)收到来自NE2、NE3、NE4的收包数$rxCnt_port1\,业务不丢包" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj1 "1000" "00:00:00:20:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_4_FC10" $::matchType2 $::matchType1 $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
    			MPLS_ClassStatisticsStream 2 $::infoObj1 "1000" "00:00:00:40:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_4_FC10" $::matchType3 $::matchType1 $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
    			MPLS_ClassStatisticsStream 2 $::infoObj1 "1000" "00:00:00:60:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_4_FC10" $::matchType4 $::matchType1 $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)发包数$txCnt_port1\,NE1($::gpnIp1)收到来自NE2、NE3、NE4的收包数$rxCnt_port1\,业务丢包" $fileId
    		}
    		if {$rxCnt_port2 == $txCnt_port2} {
    			gwd::GWpublic_print "OK" "NE2($::gpnIp2)发包数$txCnt_port2\,NE2($::gpnIp2)收到来自NE1的收包数$rxCnt_port2\,业务不丢包" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj2 "1000" "00:00:00:10:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_4_FC10" $::matchType1 $::matchType2 $::hGPNPort2Cap $::hGPNPort2CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)发包数$txCnt_port2\,NE2($::gpnIp2)收到来自NE1的收包数$rxCnt_port2\,业务丢包" $fileId
    		}
    		if {$rxCnt_port3 == $txCnt_port3} {
    			gwd::GWpublic_print "OK" "NE3($::gpnIp3)发包数$txCnt_port3\,NE3($::gpnIp3)收到来自NE1的收包数$rxCnt_port3\,业务不丢包" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj3 "1000" "00:00:00:30:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_4_FC10" $::matchType1 $::matchType3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)发包数$txCnt_port3\,NE3($::gpnIp3)收到来自NE1的收包数$rxCnt_port3\,业务丢包" $fileId
    		}
    		if {$rxCnt_port4 == $txCnt_port4} {
    			gwd::GWpublic_print "OK" "NE4($::gpnIp4)发包数$txCnt_port4\,NE4($::gpnIp4)收到来自NE1的收包数$rxCnt_port4\,业务不丢包" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj4 "1000" "00:00:00:50:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_4_FC10" $::matchType1 $::matchType4 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE4($::gpnIp2)发包数$txCnt_port4\,NE4($::gpnIp4)收到来自NE1的收包数$rxCnt_port4\,业务丢包" $fileId
    		}
	
    	}
    
    return $errorTmp
}
########################################################################################################
#函数功能：根据分析器的设置统计各条流的收发情况
#输入参数：statPara ==1 分析器中添加vlan统计字段                ==0 分析器中不添加vlan统计字段
#          hAna：端口分析器handle
#输出参数：aRecCnt：统计结果
#返回值：    无
########################################################################################################
proc classificationStatisticsPortRxCnt10 {statPara hAna aRecCnt} { 
		set flag 0
        upvar $aRecCnt aTmpCnt
        array set aTmpCnt {cnt1 0 drop1 0 rate1 0 cnt2 0 drop2 0 rate2 0 cnt3 0 drop3 0 rate3 0 \
          cnt4 0 drop4 0 rate4 0 cnt5 0 drop5 0 rate5 0 cnt6 0 drop6 0 rate6 0 cnt7 0 drop7 0 rate7 0}
        #同步分析器和发生器统计延时2s  
        after 2000 
        ##获取分析器统计的数值并进行匹配
        foreach resultsObj [stc::get $hAna -children-FilteredStreamResults] {
                if {[catch {
                        send_log "\n resultsObj:$resultsObj"
                        after 2000
                        array set aResults [stc::get $resultsObj]
                        after 2000
                } err]} {
						set flag 1
                        send_log "\n filter_err:$err"
                        continue
                }
		if {$statPara == 1} {
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && aResults(-FrameRate) > 0\
                          $aResults(-FilteredValue_1) == "50"} {
                                set aTmpCnt(cnt2)  $aResults(-L1BitRate)
                                set aTmpCnt(drop2) $aResults(-DroppedFrameCount)
                                set aTmpCnt(rate2) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && aResults(-FrameRate) > 0\
                          $aResults(-FilteredValue_1) == "1000"} {
                                set aTmpCnt(cnt3)  $aResults(-L1BitRate)
                                set aTmpCnt(drop3) $aResults(-DroppedFrameCount)
                                set aTmpCnt(rate3) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && aResults(-FrameRate) > 0\
                           $aResults(-FilteredValue_1) == "3000"} {
                                set aTmpCnt(cnt5) $aResults(-L1BitRate)
                                set aTmpCnt(drop5) $aResults(-DroppedFrameCount)
                                set aTmpCnt(rate5) $aResults(-FrameRate)
                        }
                        if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && aResults(-FrameRate) > 0\
                           $aResults(-FilteredValue_1) == "1000"} {
                                set aTmpCnt(cnt6) $aResults(-L1BitRate)
                                set aTmpCnt(drop6) $aResults(-DroppedFrameCount)
                                set aTmpCnt(rate6) $aResults(-FrameRate)
                        }
						if {[string match -nocase "Vlan 0 - ID (int)" $aResults(-FilteredName_1)] && aResults(-FrameRate) > 0\
                              $aResults(-FilteredValue_1) == "2000"} {
                            set aTmpCnt(cnt7) $aResults(-L1BitRate)
                            set aTmpCnt(drop7) $aResults(-DroppedFrameCount)
                            set aTmpCnt(rate7) $aResults(-FrameRate)
						}
		} 
	}
	return $flag
}

########################################################################################################
#函数功能：GPN上trunk组模式测试
#输入参数:ModeFlag:模式类型
#	  slavePort:从端口
#	  masterPort:端口组的主端口
#输出参数：无
#返回值： 无
#作者：吴军妮(唐丽春修改)
########################################################################################################
proc Test_TrunkModeAdd {spawn_id matchType dutType fileId ModeFlag trunKName masterPort slavePort ptn003_case1_cnt caseId} {
	global capId
	global trunkSwTime
	set flag 0
        if {$::cap_enable} {
                gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
                gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
        }
    set lport1 "$::hGPNPort1 $::hGPNPort2 $::hGPNPort3 $::hGPNPort4"
	stc::perform ResultsClearAll -PortList $lport1
    gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
    after 10000
	incr capId
	if {$::cap_enable} {
                gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap"
                gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap"
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
        parray aGPNPort3Cnt1
        parray aGPNPort4Cnt1
	gwd::GWpublic_print "  " "抓包文件为$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap" $fileId
	if {$aGPNPort4Cnt1(cnt2) < $::rateL || $aGPNPort4Cnt1(cnt2) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时NE1($::gpnIp1)$::GPNTestEth3\发送tag=50的数据流，NE3($::gpnIp3)\
			$::GPNTestEth4\收到tag=50的数据流的速率为$aGPNPort4Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时NE1($::gpnIp1)$::GPNTestEth3\发送tag=50的数据流，NE3($::gpnIp3)\
			$::GPNTestEth4\收到tag=50的数据流的速率为$aGPNPort4Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
	}
	if {$aGPNPort3Cnt1(cnt6) < $::rateL || $aGPNPort3Cnt1(cnt6) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时NE3($::gpnIp3)$::GPNTestEth4\发送tag=1000的数据流，NE1($::gpnIp1)\
			$::GPNTestEth3\收到tag=1000的数据流的速率为$aGPNPort3Cnt1(cnt6)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时NE3($::gpnIp3)$::GPNTestEth4\发送tag=1000的数据流，NE1($::gpnIp1)\
			$::GPNTestEth3\收到tag=1000的数据流的速率为$aGPNPort3Cnt1(cnt6)，在$::rateL-$::rateR\范围内" $fileId
	}
    for {set i 1} {$i < [expr $ptn003_case1_cnt+1]} {incr i} {
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 0 0 1 1 0 0
				after 5000
			}
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 0 0 1 1 0 0
				after 5000
			}
                        
                        
            set FrameRate21 $aGPNPort4Cnt1(rate2)
            set FrameRate61 $aGPNPort3Cnt1(rate6)
            set DropFrame21 $aGPNPort4Cnt1(drop2)
            set DropFrame61 $aGPNPort3Cnt1(drop6)
			send_log "\nmasterFrameRate21:$FrameRate21"
			send_log "\nmasterFrameRate61:$FrameRate61"
			send_log "\nmasterDropFrame21:$DropFrame21"
			send_log "\nmasterDropFrame61:$DropFrame61"
			gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $masterPort "shutdown"
			after 5000
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 0 0 1 1 0 0
				after 5000
			}
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 0 0 1 1 0 0
				after 5000
			}
                        parray aGPNPort3Cnt1
                        parray aGPNPort4Cnt1
                        set FrameRate22 $aGPNPort4Cnt1(rate2)
                        set FrameRate62 $aGPNPort3Cnt1(rate6)
                        set DropFrame22 $aGPNPort4Cnt1(drop2)
                        set DropFrame62 $aGPNPort3Cnt1(drop6)
                        send_log "\nmasterFrameRate22:$FrameRate22"
                        send_log "\nmasterFrameRate62:$FrameRate62"
                        send_log "\nmasterDropFrame22:$DropFrame22"
                        send_log "\nmasterDropFrame62:$DropFrame62"
			set printWord "主端口" 
			if {$FrameRate22 != 0} {
				set DhTime2 [expr ($DropFrame22-$DropFrame21)*1000/$FrameRate22]
				if {$DhTime2>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$masterPort\down操作后，TC4口接收倒换时间为$DhTime2\ms大于最大允许倒换时间$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "第$i\次$matchType trunk组$trunKName$printWord$masterPort\down操作后，TC4口接收倒换时间为$DhTime2\ms小于最大允许倒换时间$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$masterPort\down操作后TC4口收不到流，无法测试TC3发送倒换时间" $fileId
			}
			if {$FrameRate62 != 0} {
				set DhTime6 [expr ($DropFrame62-$DropFrame61)*1000/$FrameRate62]
				if {$DhTime6>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$masterPort\down操作后，TC3口接收倒换时间为$DhTime6\ms大于最大允许倒换时间$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "第$i\次$matchType trunk组$trunKName$printWord$masterPort\down操作后，TC3口接收倒换时间为$DhTime6\ms小于最大允许倒换时间$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$masterPort\down操作后TC3口收不到流，无法测试TC4发送倒换时间" $fileId
			}
			gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $masterPort "undo shutdown"
            after 60000 ;#等待回切时间
            after 2000
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 0 0 1 1 0 0
				after 5000
			}
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 0 0 1 1 0 0
				after 5000
			}
                        parray aGPNPort3Cnt1
                        parray aGPNPort4Cnt1
                        set FrameRate23 $aGPNPort4Cnt1(rate2)
                        set FrameRate63 $aGPNPort3Cnt1(rate6)
                        set DropFrame23 $aGPNPort4Cnt1(drop2)
                        set DropFrame63 $aGPNPort3Cnt1(drop6)
                        send_log "\nmasterFrameRate23:$FrameRate23"
                        send_log "\nmasterFrameRate63:$FrameRate63"
                        send_log "\nmasterDropFrame23:$DropFrame23"
                        send_log "\nmasterDropFrame63:$DropFrame63"
						
			if {$FrameRate23 != 0} {
				set DhTime2 [expr ($DropFrame23-$DropFrame22)*1000/$FrameRate23]
				if {$DhTime2>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$masterPort\up操作后，TC4口接收倒换时间为$DhTime2\ms大于最大允许倒换时间$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "第$i\次$matchType trunk组$trunKName$printWord$masterPort\up操作后，TC4口接收倒换时间为$DhTime2\ms小于最大允许倒换时间$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$masterPort\up操作后TC4口接收不到流，无法测试TC3发送倒换时间" $fileId
			}
			if {$FrameRate63 != 0} {
				set DhTime6 [expr ($DropFrame63-$DropFrame62)*1000/$FrameRate63]
				if {$DhTime6>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$masterPort\up操作后，TC3口接收倒换时间为$DhTime6\ms大于最大允许倒换时间$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "第$i\次$matchType trunk组$trunKName$printWord$masterPort\up操作后，TC3口接收倒换时间为$DhTime6\ms小于最大允许倒换时间$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$masterPort\up操作后TC3接收不到流，无法测试TC4倒换时间" $fileId
			}
	}
	stc::perform ResultsClearAll -PortList $lport1
	for {set i 1} {$i < [expr $ptn003_case1_cnt+1]} {incr i} {
		set filterCnt 0
			while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 0 0 1 1 0 0
				after 5000
			}
			set filterCnt 0
			while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
				if {$filterCnt == $::filterGlobalCnt} {
					break
				}
				incr filterCnt
				Recustomization 0 0 1 1 0 0
				after 5000
			}
        set FrameRate21 $aGPNPort4Cnt1(rate2)
        set FrameRate61 $aGPNPort3Cnt1(rate6)
        set DropFrame21 $aGPNPort4Cnt1(drop2)
        set DropFrame61 $aGPNPort3Cnt1(drop6)
		send_log "\nslaveFrameRate21:$FrameRate21"
		send_log "\nslaveFrameRate61:$FrameRate61"
		send_log "\nslaveDropFrame21:$DropFrame21"
		send_log "\nslaveDropFrame61:$DropFrame61"
		gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $slavePort "shutdown"
		after 5000
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 1 0 0
			after 5000
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 1 0 0
			after 5000
		}
        parray aGPNPort3Cnt1
        parray aGPNPort4Cnt1
        set FrameRate22 $aGPNPort4Cnt1(rate2)
        set FrameRate62 $aGPNPort3Cnt1(rate6)
        set DropFrame22 $aGPNPort4Cnt1(drop2)
        set DropFrame62 $aGPNPort3Cnt1(drop6)
        send_log "\nslaveFrameRate22:$FrameRate22"
        send_log "\nslaveFrameRate62:$FrameRate62"
        send_log "\nslaveDropFrame22:$DropFrame22"
        send_log "\nslaveDropFrame62:$DropFrame62"
		set printWord "从端口"
		if {$FrameRate22 != 0} {
				set DropFrame2 [expr $DropFrame22-$DropFrame21]
				if {$DropFrame2>0} {
					set flag 1
					gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$slavePort\down操作后，TC4口接收到的流业务发生丢包" $fileId
				} else {
					gwd::GWpublic_print "OK" "第$i\次$matchType trunk组$trunKName$printWord$slavePort\down操作后，TC4口接收到的流业务不丢包" $fileId
				}
		} else {
			gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$slavePort\down操作后业务不通，TC4口无法测试TC3口发送倒换时间" $fileId
		}
		if {$FrameRate62 != 0} {
				set DropFrame6 [expr $DropFrame62-$DropFrame61]
				if {$DropFrame6>0} {
					set flag 1
					gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$slavePort\down操作后，TC3口接收到的流业务发生丢包" $fileId
				} else {
					gwd::GWpublic_print "OK" "第$i\次$matchType trunk组$trunKName$printWord$slavePort\down操作后，TC3口接收到的流业务不丢包" $fileId
				}
		} else {
			gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$slavePort\down操作后业务不通，TC4口无法测试TC3口发送倒换时间" $fileId
		}
		gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $slavePort "undo shutdown"
		after 5000
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 1 0 0
			after 5000
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 1 0 0
			after 5000
		}
        parray aGPNPort3Cnt1
        parray aGPNPort4Cnt1
        set FrameRate23 $aGPNPort4Cnt1(rate2)
        set FrameRate63 $aGPNPort3Cnt1(rate6)
        set DropFrame23 $aGPNPort4Cnt1(drop2)
        set DropFrame63 $aGPNPort3Cnt1(drop6)
        send_log "\nslaveFrameRate23:$FrameRate23"
        send_log "\nslaveFrameRate63:$FrameRate63"
        send_log "\nslaveDropFrame23:$DropFrame23"
        send_log "\nslaveDropFrame63:$DropFrame63"
		if {$FrameRate23 != 0} {
				set DropFrame2 [expr $DropFrame23-$DropFrame22]
				if {$DropFrame2>0} {
					set flag 1
					gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$slavePort\down操作后，TC4口接收到的流业务发生丢包" $fileId
				} else {
					gwd::GWpublic_print "OK" "第$i\次$matchType trunk组$trunKName$printWord$slavePort\down操作后，TC4口接收到的流业务不丢包" $fileId
				}
		} else {
			gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$slavePort\down操作后业务不通，TC4口无法测试TC3发送倒换时间" $fileId
		}
		if {$FrameRate63 != 0} {
				set DropFrame6 [expr $DropFrame63-$DropFrame62]
				if {$DropFrame6>0} {
					set flag 1
					gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$slavePort\down操作后，TC3口接收到的流业务发生丢包" $fileId
				} else {
					gwd::GWpublic_print "OK" "第$i\次$matchType trunk组$trunKName$printWord$slavePort\down操作后，TC3口接收到的流业务不丢包" $fileId
				}
		} else {
			gwd::GWpublic_print "NOK" "第$i\次$matchType trunk组$trunKName$printWord$slavePort\down操作后业务不通，TC4口无法测试TC3口发送倒换时间" $fileId
		}
	}
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $masterPort "shutdown"
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $slavePort "shutdown"
	after 5000
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
	set filterCnt 0
	while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
		if {$filterCnt == $::filterGlobalCnt} {
			break
		}
		incr filterCnt
		Recustomization 0 0 1 1 0 0
		after 5000
	}
    parray aGPNPort3Cnt1
    parray aGPNPort4Cnt1
    if {$aGPNPort4Cnt1(cnt2)!=0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时shutdownTRUNK组所有端口成员NE1($::gpnIp1)$::GPNTestEth3\发送tag=50的数据流，\
			NE3($::gpnIp3)$::GPNTestEth4\收到tag=50的数据流的速率应为0，实为$aGPNPort4Cnt1(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时shutdownTRUNK组所有端口成员NE1($::gpnIp1)$::GPNTestEth3\发送tag=50的数据流，\
			NE3($::gpnIp3)$::GPNTestEth4\收到tag=50的数据流的速率应为0，实为$aGPNPort4Cnt1(cnt2)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt6)!=0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时shutdownTRUNK组所有端口成员NE3($::gpnIp3)$::GPNTestEth4\发送tag=1000的数据流，\
			NE1($::gpnIp1)$::GPNTestEth3\收到tag=1000的数据流的速率应为0，实为$aGPNPort3Cnt1(cnt6)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时shutdownTRUNK组所有端口成员NE3($::gpnIp3)$::GPNTestEth4\发送tag=1000的数据流，\
			NE1($::gpnIp1)$::GPNTestEth3\收到tag=1000的数据流的速率应为0，实为$aGPNPort3Cnt1(cnt6)" $fileId
	}

	foreach port1 "$masterPort $slavePort" port2 "$slavePort $masterPort" {
		gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $port1 "undo shutdown"
		gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $port2 "shutdown"
		after 60000 ;#等待回切时间
		if {$::cap_enable} {
			gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
			gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
		}
		gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
		after 10000
		incr capId
		if {$::cap_enable} {
			gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap"	
			gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap"
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort3Ana aGPNPort3Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 1 0 0
			after 5000
		}
		set filterCnt 0
		while {[classificationStatisticsPortRxCnt10 1 $::hGPNPort4Ana aGPNPort4Cnt1]} {
			if {$filterCnt == $::filterGlobalCnt} {
				break
			}
			incr filterCnt
			Recustomization 0 0 1 1 0 0
			after 5000
		}
		parray aGPNPort3Cnt1
		parray aGPNPort4Cnt1
		gwd::GWpublic_print "  " "抓包文件为$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap" $fileId
		gwd::GWpublic_print "  " "抓包文件为$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap" $fileId
		if {$aGPNPort4Cnt1(cnt2) < $::rateL || $aGPNPort4Cnt1(cnt2) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时trunk组端口$port1 up $port2 down NE1($::gpnIp1)$::GPNTestEth3\
				发送tag=50的数据流，NE3($::gpnIp3)$::GPNTestEth4\收到tag=50的数据流的速率为$aGPNPort4Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时trunk组端口$port1 up $port2 down NE1($::gpnIp1)$::GPNTestEth3\
				发送tag=50的数据流，NE3($::gpnIp3)$::GPNTestEth4\收到tag=50的数据流的速率为$aGPNPort4Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
		}
		if {$aGPNPort3Cnt1(cnt6) < $::rateL || $aGPNPort3Cnt1(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$matchType trunk组$trunKName\模式为$ModeFlag\时trunk组端口$port1 up $port2 down NE3($::gpnIp3)$::GPNTestEth4\
				发送tag=1000的数据流，NE1($::gpnIp1)$::GPNTestEth3\收到tag=1000的数据流的速率为$aGPNPort3Cnt1(cnt6)，没在$::rateL-$::rateR\范围内" $fileId
		} else {
			gwd::GWpublic_print "OK" "$matchType trunk组$trunKName\模式为$ModeFlag\时trunk组端口$port1 up $port2 down NE3($::gpnIp3)$::GPNTestEth4\
				发送tag=1000的数据流，NE1($::gpnIp1)$::GPNTestEth3\收到tag=1000的数据流的速率为$aGPNPort3Cnt1(cnt6)，在$::rateL-$::rateR\范围内" $fileId
		}
	}
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $masterPort "undo shutdown"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
	return $flag
}
########################################################################################################
#函数功能：统计端口上的丢包和速率
#输入参数:
#	  ana:分析器
#	  resultDrop:丢包数
#	  resultRate:速率
#输出参数：无
#返回值： 无
#作者：唐丽春
########################################################################################################
proc Stat_dropAndRate {Ana resultDrop resultRate} {
	upvar $resultDrop tmp_Drop
	upvar $resultRate tmp_Rate
	set errorTmp 0
	set tmp_Drop 0
	foreach resultsObj [stc::get $::hGPNPort4Ana -children-FilteredStreamResults] {
                if {[catch {
                        send_log "\n resultsObj:$resultsObj"
                        after 2000
                        array set aResults [stc::get $resultsObj]
                        if {[string match -nocase "50" $aResults(-FilteredValue_1)]} {
							set tmp_Drop [expr $aResults(-DroppedFrameCount)]
							set tmp_Rate [expr $aResults(-FrameRate)]
						}
                        stc::perform ResultsClearView -ResultList $resultsObj
                } err]} {
				set errorTmp 1
                        send_log "\n filter_err:$err"
                        continue
                }
            }
    return $errorTmp
}
########################################################################################################
#函数功能：GPN上trunk组模式测试sharing模式的测试
#输入参数:ModeFlag:模式类型
#	  slavePort:从端口
#	  masterPort:端口组的主端口
#	  smacAdd:smac是否增加 true 增加 false 不增加
#输出参数：无
#返回值： 无
#作者：唐丽春
########################################################################################################
proc Test_TrunkSharing {spawn_id matchType dutType fileId ModeFlag trunKName masterPort slavePort smacAdd caseId} {
	global capId
	global trunkSwTime
	set flag 0
    if {$::cap_enable} {
            gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
            gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
    }
    set lport1 "$::hGPNPort1 $::hGPNPort2 $::hGPNPort3 $::hGPNPort4"
	stc::perform ResultsClearAll -PortList $lport1
    gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
    after 15000
	incr capId
	if {$::cap_enable} {
                gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap"
                gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap"
	}
	gwd::GWpublic_getPortStat $spawn_id $matchType $dutType $fileId $masterPort statArr1
	gwd::GWpublic_getPortStat $spawn_id $matchType $dutType $fileId $slavePort statArr2
	set rateCntflag 0 ;###判断流量是否在一个端口上的指针
	set outRate1 $statArr1(-outBytesRate)
	set outRate2 $statArr2(-outBytesRate)
	send_log "\noutRate1:$outRate1\n\outRate2:$outRate2"

	if {$outRate1 > 0} {
		incr rateCntflag 
		set bearerPort $masterPort
	}
	if {$outRate2 > 0} {
		incr rateCntflag 
		set bearerPort $slavePort
	}
	if {[string match -nocase $smacAdd "true"]} {
		set smacStatus "跳变"
		if {$rateCntflag>1} {
			gwd::GWpublic_print "OK" "sharing时NE1($::gpnIp1)发送带vlan50,SMAC$smacStatus的流，查看业务承载在两个端口上" $fileId
		} else {
			set flag 1 
			gwd::GWpublic_print "NOK" "sharing时NE1($::gpnIp1)发送带vlan50,SMAC$smacStatus的流，业务承载在一个端口上" $fileId
		}
	} else {
		set smacStatus "不变"
		if {$rateCntflag>1} {
			set flag 1 
			gwd::GWpublic_print "NOK" "sharing时NE1($::gpnIp1)发送带vlan50,SMAC$smacStatus的一条流，业务不仅在一个端口上，两端都有流量" $fileId
		} else {
			gwd::GWpublic_print "OK" "sharing时NE1($::gpnIp1)发送带vlan50,SMAC$smacStatus的一条流，查看业务在一个端口上" $fileId
		}
	}
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $bearerPort "shutdown"
	after 5000
	Stat_dropAndRate $::hGPNPort3Ana tmp_Drop1 tmp_Rate1
    send_log "\ntmp_DropPort3:$tmp_Drop1"
    send_log "\ntmp_RatePort3:$tmp_Rate1"
	set printWord "承载端口" 
	if {$tmp_Rate1 != 0} {
		set DhTime2 [expr $tmp_Drop1*1000/$tmp_Rate1]
		if {$DhTime2>$trunkSwTime} {
			set flag 1
			gwd::GWpublic_print "NOK" "（SMAC$smacStatus）$matchType trunk组$trunKName$printWord$bearerPort\down操作后，TC4口接收倒换时间为$DhTime2\ms大于最大允许倒换时间$trunkSwTime\ms" $fileId
		} else {
			gwd::GWpublic_print "OK" "（SMAC$smacStatus）$matchType trunk组$trunKName$printWord$bearerPort\down操作后，TC4口接收倒换时间为$DhTime2\ms小于最大允许倒换时间$trunkSwTime\ms" $fileId
		}
	} else {
		gwd::GWpublic_print "NOK" "（SMAC$smacStatus）$matchType trunk组$trunKName$printWord$bearerPort\down操作后TC4口收不到流，无法测试TC3发送倒换时间" $fileId
	}
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $bearerPort "undo shutdown"
    after 60000 ;#等待回切时间
    after 2000
	Stat_dropAndRate $::hGPNPort3Ana tmp_Drop1 tmp_Rate1
    send_log "\ntmp_DropPort3:$tmp_Drop1"
    send_log "\ntmp_RatePort3:$tmp_Rate1"	
	if {$tmp_Rate1 != 0} {
		
		if {$tmp_Drop1 != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "（SMAC$smacStatus）$matchType trunk组$trunKName$printWord$bearerPort\up操作后，TC4口接收到的流量丢包" $fileId
		} else {
			gwd::GWpublic_print "OK" "（SMAC$smacStatus）$matchType trunk组$trunKName$printWord$bearerPort\up操作后，TC4口接收到的流量不丢包" $fileId
		}
	} else {
		gwd::GWpublic_print "NOK" "（SMAC$smacStatus）$matchType trunk组$trunKName$printWord$bearerPort\up操作后TC4口接收不到流，无法测试TC3发送的业务" $fileId
	}
	
	set lport1 "$::hGPNPort1 $::hGPNPort2 $::hGPNPort3 $::hGPNPort4"
	stc::perform ResultsClearAll -PortList $lport1
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
	return $flag
}

########################################################################################################
#函数功能：GPN上trunk组模式测试sharing模式的测试
#输入参数:ModeFlag:模式类型
#	  slavePort:从端口
#	  masterPort:端口组的主端口
#	  smacAdd:smac是否增加
#输出参数：无
#返回值： 无
#作者：唐丽春
########################################################################################################
proc Test_TrunkSharingAC {spawn_id matchType dutType fileId ModeFlag trunKName masterPort slavePort smacAdd caseId} {
	set flag 0
	gwd::Start_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort2Ana $::hGPNPort3Ana $::hGPNPort4Ana"
	stc::perform ResultsClearViewCommand -ResultList "[stc::get $::hGPNPort2Ana -children-AnalyzerPortResults] [stc::get $::hGPNPort3Ana -children-AnalyzerPortResults] [stc::get $::hGPNPort4Ana -children-AnalyzerPortResults]"
	after 2000
    
	
	if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $::hGPNPort2Cap $::hGPNPort2CapAnalyzer
		gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer 
		gwd::Start_CapAllData ::capArr $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
	}
	after 6000
	incr capId
	if {$::cap_enable} {
		gwd::Stop_CapData $::hGPNPort2Cap 1 "GPN_PTN_003_$capId-p$::GPNTestEth2_cap\($::gpnIp1\).pcap"
		gwd::Stop_CapData $::hGPNPort3Cap 1 "GPN_PTN_003_$capId-p$::GPNTestEth3_cap\($::gpnIp1\).pcap"	
		gwd::Stop_CapData $::hGPNPort4Cap 1 "GPN_PTN_003_$capId-p$::GPNTestEth4_cap\($::gpnIp3\).pcap"
	}
	
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_003_$capId-p$::GPNTestEth2_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_003_$capId-p$::GPNTestEth3_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "抓包文件为GPN_PTN_003_$capId-p$::GPNTestEth4_cap\($::gpnIp3\).pcap" $fileId
	set GPNPort2AnaRate2 [stc::get $::hGPNPort2Ana.AnalyzerPortResults -L1BitRate]
    set GPNPort3AnaRate3 [stc::get $::hGPNPort3Ana.AnalyzerPortResults -L1BitRate]
    set GPNPort4AnaRate4 [stc::get $::hGPNPort4Ana.AnalyzerPortResults -L1BitRate]
	if {$GPNPort4AnaRate4 < $::rateL || $GPNPort4AnaRate4 > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth3\发送tag=50的数据流，NE3($::gpnIp3)\
			$::GPNTestEth4\收到tag=50的数据流的速率为$aGPNPort4Cnt1(cnt2)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth3\发送tag=50的数据流，NE3($::gpnIp3)\
			$::GPNTestEth4\收到tag=50的数据流的速率为$aGPNPort4Cnt1(cnt2)，在$::rateL-$::rateR\范围内" $fileId
	}
	set trunkRate [expr $GPNPort2AnaRate2 + $GPNPort3AnaRate3]
	if {$trunkRate < $::rateL || $trunkRate > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth4\发送tag=1000的数据流，NE1($::gpnIp1)\
			$::GPNTestEth3\收到tag=1000的数据流的速率为$aGPNPort3Cnt1(cnt6)，没在$::rateL-$::rateR\范围内" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth4\发送tag=1000的数据流，NE1($::gpnIp1)\
			$::GPNTestEth3\收到tag=1000的数据流的速率为$aGPNPort3Cnt1(cnt6)，在$::rateL-$::rateR\范围内" $fileId
	}
	gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
	return $flag
}

########################################################################################################
#函数功能：设置trunk的主端口
#          trunKName 	trunk组的名字
#          GPNPort      想要设置为主端口的端口
#输出参数：aRecCnt：统计结果
#返回值：    无
#唐丽春
########################################################################################################
proc GW_SetTrunkMaster {spawn_id matchType dutType fileId trunKName GPNPort} {
		send -i $spawn_id "\r"
		 #检测节点
		 expect {
	 		 -i $spawn_id
	 		 -re "$matchType\\(config\\)#" {
				send -i $spawn_id "interface trunk $trunKName\r\r"
	 		}
  		}
  		expect {
			-i $spawn_id
			-re "$matchType\\(trunk-$trunKName\\)#" {
			    send -i $spawn_id "master port $GPNPort\r" 
			}
  		}
		expect {
	     -i $spawn_id
	     -re {Unknown command} {
	      set errorTmp 1
	      gwd::GWpublic_print NOK "$dutType\上配置trunk$trunKName\主端口为$GPNPort\，失败。命令参数有误" $fileId
	  }
	  -re "$matchType\\(trunk-$trunKName\\)#" {
	       send -i $spawn_id "exit\r" 
	      gwd::GWpublic_print OK "$dutType\上配置trunk$trunKName\主端口为$GPNPort\，成功" $fileId   
	  }
   }
  return $errorTmp 
}
########################################################################################################
#函数功能：设置端口的队列调度
#          GPNPort 	端口号
#          queMode      调度类型
#输出参数：aRecCnt：统计结果
#返回值：    无
#唐丽春
########################################################################################################
proc GW_SetEthQueueMode {spawn_id matchType dutType fileId GPNPort queMode} {
		send -i $spawn_id "\r"
		 #检测节点
		 expect {
	 		 -i $spawn_id
	 		 -re "$matchType\\(config\\)#" {
				send -i $spawn_id "interface ethernet $GPNPort\r\r"
	 		}
  		}
  		expect {
			-i $spawn_id
			-re "$matchType\\(if-eth$GPNPort\\)#" {
			    send -i $spawn_id "config queue-mode $queMode\r" 
			}
  		}
		expect {
	     -i $spawn_id
	     -re {Unknown command} {
	      set errorTmp 1
	      GWpublic_print NOK "$dutType\上配置$GPNPort端口为$queMode\，失败。命令参数有误" $fileId
	  }
	  -re "$matchType\\(if-eth$GPNPort\\)#" {
	       send -i $spawn_id "exit\r" 
	      GWpublic_print OK "$dutType\上配置$GPNPort端口为$queMode\，成功" $fileId   
	  }
   }
  return $errorTmp 
}

########################################################################################################
#函数功能：设置pw、ac的队列调度
#          GPNPort 	端口号
#          queMode      调度类型
#输出参数：aRecCnt：统计结果
#返回值：    无
#唐丽春
########################################################################################################
proc GW_SetPWQueueMode {spawn_id matchType dutType fileId pwName queMode} {
		send -i $spawn_id "\r"
		 #检测节点
		 expect {
	 		 -i $spawn_id
	 		 -re "$matchType\\(config\\)#" {
				send -i $spawn_id "interface pw $pwName\r"
	 		}
  		}
  		expect {
			-i $spawn_id
			-re "$matchType\\(config-pw-$pwName\\)#" {
			    send -i $spawn_id "hqos enable\r" 
			}
  		}
  		expect {
			-i $spawn_id
			-re "$matchType\\(config-pw-$pwName\\)#" {
			    send -i $spawn_id "config queue-mode $queMode\r" 
			}
  		}
		expect {
	     -i $spawn_id
	     -re {Unknown command} {
	      set errorTmp 1
	      GWpublic_print NOK "$dutType\上配置pw\ $pwName\模式为$queMode\，失败。命令参数有误" $fileId
	  }
	  -re "$matchType\\(config-pw-$pwName\\)#" {
	       send -i $spawn_id "exit\r" 
	      GWpublic_print OK "$dutType\上配置pw\ $pwName\模式为$queMode\，成功" $fileId   
	  }
   }
  return $errorTmp 
}
########################################################################################################
#函数功能：设置端口限速
#          GPNPort 	端口号
#          dir      方向
#		   rate 	速率（单位M）
#输出参数：aRecCnt：统计结果
#返回值：    无
#唐丽春
########################################################################################################
proc GW_SetPWQueueMode {spawn_id matchType dutType fileId GPNPort dir rate} {
		send -i $spawn_id "\r"
		 #检测节点
		 expect {
	 		 -i $spawn_id
	 		 -re "$matchType\\(config\\)#" {
				send -i $spawn_id "interface ethernet $GPNPort\r"
	 		}
  		}
  		expect {
			-i $spawn_id
			-re "$matchType\\(if-eth$GPNPort\\)#" {
			    send -i $spawn_id "line-rate $dir cir [expr $rate*1000] cbs 1024\r" 
			}
  		}
		expect {
	     -i $spawn_id
	     -re {Unknown command} {
	      set errorTmp 1
	      GWpublic_print NOK "$dutType\上配置pw\ $pwName\模式为$queMode\，失败。命令参数有误" $fileId
	  }
	  -re "$matchType\\(config-pw-$pwName\\)#" {
	       send -i $spawn_id "exit\r" 
	      GWpublic_print OK "$dutType\上配置pw\ $pwName\模式为$queMode\，成功" $fileId   
	  }
   }
  return $errorTmp 
}