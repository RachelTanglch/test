
#!/bin/sh
# PTN_Mode_Function.tcl \
exec tclsh "$0" ${1+"$@"}
########################################################################################################
#�������ܣ����ݷ�����������ͳ�Ƹ��������շ����
#���������statPara ==1 �����������vlanͳ���ֶ�                ==0 �������в����vlanͳ���ֶ�
#          hAna���˿ڷ�����handle
#���������aRecCnt��ͳ�ƽ��
#����ֵ��    ��
########################################################################################################
proc classificationStatisticsPortRxCnt {statPara hAna aRecCnt} {
	set flag 0
  	upvar $aRecCnt aTmpCnt
  	#ͬ���������ͷ�����ͳ����ʱ2s  
  	after 2000 
  	##��ȡ������ͳ�Ƶ���ֵ������ƥ��
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
#�������ܣ����ݷ�����������ͳ�Ƹ��������շ����
#���������statPara ==1 �����������vlanͳ���ֶ�                ==0 �������в����vlanͳ���ֶ�
#         statPara ==2 �����������mpls ��ǩͳ���ֶ�     ==3 �����������mpls vid ��Experrimental Bit��bottom of stackͳ���ֶ�
#          hAna���˿ڷ�����handle
#���������aRecCnt��ͳ�ƽ��
#����ֵ��    ��
########################################################################################################
proc classificationStatisticsPortRxCnt1 {statPara hAna aRecCnt} { 
	set flag 0
  	upvar $aRecCnt aTmpCnt
	global dev_sysmac1
	global dev_sysmac2
 	#ͬ���������ͷ�����ͳ����ʱ2s  
  	after 2000 
        ##��ȡ������ͳ�Ƶ���ֵ������ƥ��
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
#�������ܣ����ݷ�����������ͳ�Ƹ��������շ����
#���������statPara ==1 �����������vlanͳ���ֶ�                ==0 �������в����vlanͳ���ֶ�
#          hAna���˿ڷ�����handle
#���������aRecCnt��ͳ�ƽ��
#����ֵ��    ��
########################################################################################################
proc classificationStatisticsPortRxCnt3 {statPara hAna aRecCnt} { 
	set flag 0
        upvar $aRecCnt aTmpCnt
        array set aTmpCnt {cnt1 0 drop1 0 rate1 0 cnt2 0 drop2 0 rate2 0 cnt3 0 drop3 0 rate3 0 \
          cnt4 0 drop4 0 rate4 0 cnt5 0 drop5 0 rate5 0 cnt6 0 drop6 0 rate6 0 cnt7 0 drop7 0 rate7 0}
        #ͬ���������ͷ�����ͳ����ʱ2s  
        after 2000 
        ##��ȡ������ͳ�Ƶ���ֵ������ƥ��
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
#�������ܣ����ݷ�����������ͳ�Ƹ��������շ����
#���������statPara ==1 �����������vlanͳ���ֶ�                ==0 �������в����vlanͳ���ֶ�
#          hAna���˿ڷ�����handle
#���������aRecCnt��ͳ�ƽ��
#����ֵ��    ��
########################################################################################################
proc classificationStatisticsPortRxCnt4 {statPara hAna aRecCnt} { 
	set flag 0
	upvar $aRecCnt aTmpCnt
	#ͬ���������ͷ�����ͳ����ʱ2s  
	after 2000 
	#��ȡ������ͳ�Ƶ���ֵ������ƥ��
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
			#��ȡ������ͳ�Ƶ���ֵ
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
#�������ܣ����ݷ�����������ͳ�Ƹ��������շ����
#���������statPara ==1 �����������vlanͳ���ֶ�                ==0 �������в����vlanͳ���ֶ�
#          hAna���˿ڷ�����handle
#���������aRecCnt��ͳ�ƽ��
#����ֵ��    ��
########################################################################################################
proc classificationStatisticsPortRxCnt5 {statPara hAna aRecCnt} { 
	set flag 0
        upvar $aRecCnt aTmpCnt
        global newGPNMac
        global fileId
        #ͬ���������ͷ�����ͳ����ʱ2s  
        after 2000 
        #��ȡ������ͳ�Ƶ���ֵ������ƥ��
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
#�������ܣ����ݷ�����������ͳ�Ƹ��������շ����
#���������statPara ==1 �����������vlanͳ���ֶ�                ==0 �������в����vlanͳ���ֶ�
#          hAna���˿ڷ�����handle
#���������aRecCnt��ͳ�ƽ��
#����ֵ��    ��
########################################################################################################
proc classificationStatisticsPortRxCnt9 {statPara hAna aRecCnt} { 
	set flag 0
        upvar $aRecCnt aTmpCnt
        #ͬ���������ͷ�����ͳ����ʱ2s  
        after 2000 
  	#��ȡ������ͳ�Ƶ���ֵ������ƥ��
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
#�������ܣ����ݷ�����������ͳ�Ƹ��������շ����
#���������statPara ==1 �����������vlanͳ���ֶ�                ==0 �������в����vlanͳ���ֶ�
#          hAna���˿ڷ�����handle
#���������aRecCnt��ͳ�ƽ��
#����ֵ��    ��
########################################################################################################
proc classificationStatisticsPortRxCnt14 {statPara hAna aRecCnt} { 
	set flag 0
  	upvar $aRecCnt aTmpCnt
  	#ͬ���������ͷ�����ͳ����ʱ2s  
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
  		#statPara==1 �����������vlanͳ���ֶ�     statPara==0 �������в����vlanͳ���ֶ�
  		if {$statPara == 1} {
  		#��ȡ������ͳ�Ƶ���ֵ
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
#�������ܣ���������������
#�������: caseId:�˿�ץ�����к�
#��������� aGPNPort3Cnt1���˿�3������vlan��ȡ���
#         aGPNPort4Cnt1���˿�4������vlan��ȡ���
#         aGPNPort3Cnt2���˿�3������vlan��ȡ���
#         aGPNPort4Cnt2���˿�4������vlan��ȡ���
#����ֵ�� ��
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
#�������ܣ���������������
#�������: caseId:�˿�ץ�����к�
#��������� aGPNPort4Cnt1���˿�4������vlan��ȡ���
#         aGPNPort4Cnt2���˿�4������vlan��ȡ���
#         aGPNPort4Cnt4���˿�4��˫��vlan��ȡ���
#����ֵ�� ��
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
#�������ܣ���������������
#�������: caseId:�˿�ץ�����к�
#��������� aGPNPort4Cnt1���˿�4������vlan��ȡ���
#         aGPNPort4Cnt2���˿�4������vlan��ȡ���
#         aGPNPort4Cnt4���˿�4��˫��vlan��ȡ���
#����ֵ�� ��
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
#�������ܣ���������������
#�������: caseId:�˿�ץ�����к�
#���������aGPNPort3Cnt1���˿�3������vlan��ȡ���
#         aGPNPort4Cnt1���˿�4������vlan��ȡ���
#         aGPNPort3Cnt2���˿�3������vlan��ȡ���
#         aGPNPort4Cnt2���˿�4������vlan��ȡ���
#����ֵ�� ��
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
#�������ܣ���������������
#�������: caseId:�˿�ץ�����к�
#���������aGPNPort3Cnt41���˿�3������vlan��ȡ���
#         aGPNPort4Cnt41���˿�4������vlan��ȡ���
#         aGPNPort3Cnt4���˿�3��˫��vlan��ȡ���
#         aGPNPort4Cnt4���˿�4��˫��vlan��ȡ���
#         aGPNPort3Cnt40���˿�3������vlan��ȡ���
#         aGPNPort4Cnt40���˿�4������vlan��ȡ���
#����ֵ�� ��
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
#�������ܣ���������������
#�������: caseId:�˿�ץ�����к�
#���������aGPNPort2Cnt1���˿�2������vlan��ȡ���
#         aGPNPort4Cnt1���˿�4������vlan��ȡ���
#         aGPNPort2Cnt2���˿�2������vlan��ȡ���
#         aGPNPort4Cnt2���˿�4������vlan��ȡ���
#����ֵ�� ��
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
#�������ܣ���������������
#�������: caseId:�˿�ץ�����к�
#���������aGPNPort3Cnt1���˿�3������vlan��ȡ���
#         aGPNPort4Cnt1���˿�4������vlan��ȡ���
#         aGPNPort3Cnt2���˿�3������vlan��ȡ���
#         aGPNPort4Cnt2���˿�4������vlan��ȡ���
#����ֵ�� ��
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
#�������ܣ���������������
#�������: caseId:�˿�ץ�����к�
#���������aGPNPort1Cnt1���˿�1������vlan��ȡ���
#         aGPNPort2Cnt1���˿�2������vlan��ȡ���
#         aGPNPort3Cnt1���˿�3��˫��vlan��ȡ���
#         aGPNPort4Cnt1���˿�4��˫��vlan��ȡ���
#         aGPNPort3Cnt2���˿�3������vlan��ȡ���
#         aGPNPort4Cnt2���˿�4������vlan��ȡ���
#����ֵ�� ��
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
#�������ܣ���������������
#�������: caseId:�˿�ץ�����к�
#���������aGPNPort2Cnt2���˿�2������mpls��ǩ��ȡ���
#         aGPNPort2Cnt1���˿�2mpls��vid��Դmac��ȡ���
#����ֵ�� ��
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
#�������ܣ��������������õ����Խ��
#�������: capFlag��=1ץ��   =0��ץ��
#	lGenPort�������������Ķ˿�Gen handle�б�
#	  lAnaPort�������������Ķ˿�ana handle�б�
#         lPort��ץ���˿��б�
#         lCapPara��ץ���˿���ز����б�cap capAna ip���˿������豸��ip��
#	  matchPara��classificationStatisticsPortRxCnt4 �������������
#	  anaFliFrameCfg�����������ò���
#	  capFlag���Ƿ�ץ������ȫ�ֱ���cap_enable=1�ĵ������capFlag������Ч  =1ץ��    =0��ץ��
#��������� aGPNCnt1 aGPNCnt2 aGPNCnt3 aGPNCnt4����lAnaPort�˿����Ӧ	  
#����ֵ�� ��
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
#�������ܣ��������������õ����Խ��
#�������: capFlag��=1ץ��   =0��ץ��
#	lGenPort�������������Ķ˿�Gen handle�б�
#	  lAnaPort�������������Ķ˿�ana handle�б�
#         lPort��ץ���˿��б�
#         lCapPara��ץ���˿���ز����б�cap capAna ip���˿������豸��ip��
#	  matchPara��classificationStatisticsPortRxCnt4 �������������
#	  anaFliFrameCfg�����������ò���
#	  capFlag���Ƿ�ץ������ȫ�ֱ���cap_enable=1�ĵ������capFlag������Ч  =1ץ��    =0��ץ��
#��������� aGPNCnt1 aGPNCnt2 aGPNCnt3 aGPNCnt4����lAnaPort�˿����Ӧ	  
#����ֵ�� ��
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
#�������ܣ���������������
#�������:anaFliFrameCfg1:����������1
#	 anaFliFrameCfg2:����������2
#	          caseId:�˿�ץ�����к�
#���������aGPNPort1Cnt1���˿�1����������1��ȡ���
#         aGPNPort2Cnt1���˿�2����������1��ȡ���
#         aGPNPort3Cnt1���˿�3����������1��ȡ���
#         aGPNPort4Cnt1���˿�4����������1��ȡ���
#         aGPNPort1Cnt0���˿�1����������2��ȡ���
#         aGPNPort2Cnt0���˿�2����������2��ȡ���
#         aGPNPort3Cnt0���˿�3����������2��ȡ���
#         aGPNPort4Cnt0���˿�4����������2��ȡ���
#����ֵ�� ��
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
	###���ù�����
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
        ###��ʼץ��
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
	        
	###ֹͣץ��
	if {$::cap_enable} {
        	gwd::Stop_CapData $::hGPNPort1Cap 1 "$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap"
        	gwd::Stop_CapData $::hGPNPort2Cap 1 "$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap"
        	gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap"
        	gwd::Stop_CapData $::hGPNPort4Cap 1 "$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap"
	} 
        gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
        ###�޸Ĺ�����
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
#�������ܣ���������������
#�������:
#	          caseId:�˿�ץ�����к�
#���������aGPNPort1Cnt1���˿�1����������1��ȡ���
#         aGPNPort2Cnt1���˿�2����������1��ȡ���
#         aGPNPort3Cnt1���˿�3����������1��ȡ���
#         aGPNPort4Cnt1���˿�4����������1��ȡ���
#����ֵ�� ��
########################################################################################################
proc SendAndStat9 {anaFliFrameCfg id aGPNPort1Cnt1 aGPNPort2Cnt1 aGPNPort3Cnt1 aGPNPort4Cnt1 caseId} {
upvar $aGPNPort1Cnt1 aTmpGPNPort1Cnt1
upvar $aGPNPort2Cnt1 aTmpGPNPort2Cnt1
upvar $aGPNPort3Cnt1 aTmpGPNPort3Cnt1
upvar $aGPNPort4Cnt1 aTmpGPNPort4Cnt1
foreach i "aTmpGPNPort1Cnt1 aTmpGPNPort2Cnt1 aTmpGPNPort3Cnt1 aTmpGPNPort4Cnt1" {
  array set $i {cnt2 0 cnt6 0 cnt9 0 cnt22 0 cnt33 0 cnt44 0 cnt11 0 cnt12 0 cnt13 0 cnt14 0 cnt15 0 cnt16 0} 
}
###��ʼץ��
if {$::cap_enable} {
    foreach hCfgCap $::hGPNPortCapList hCapAna $::hGPNPortCapAnalyzerList {
    gwd::Start_CapAllData ::capArr $hCfgCap $hCapAna
    }
}
###���ù�����
foreach hCfgFil $::hGPNPortAnaFrameCfgFilList {
gwd::Cfg_AnalyzerFrameCfgFilter $hCfgFil $anaFliFrameCfg
}
###ֹͣץ��
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
#�������ܣ���������������
#�������: caseId:�˿�ץ�����к�
#���������aGPNPort3Cnt1���˿�3��vlan��ȡ���
#         aGPNPort4Cnt1���˿�4��vlan��ȡ���
#����ֵ�� ��
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
#�������ܣ�GPN������ĳ��vlan�İ�arp��mac
#�������: GPNType��GPN������
#         vid��vlan id��
#         arp����ARP��ַ
#         mac����MAC��ַ
#        port���󶨶˿�
#�����������
#����ֵ�� flagErr  =0����ӳɹ�       =1�����ʧ��            =2��ip��ַ��Ӵﵽ���ֵ���޷��������  =3�����ܰ󶨹㲥ip  =4���ܰ��鲥ip
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
  
  gwd::GWpublic_print [expr {($flagErr == 0) ? "OK" : "NOK"}] "��vlan$vid\�а�ip:$arp\�Ұ�mac:$mac" $fileId
  return $flagErr  
}
########################################################################################################
#�������ܣ�GPN��trunk��ģʽ����
#�������:ModeFlag:ģʽ����
#	  trunKName:trunk�������
#	  portlist:�˿��б�
#	  masterPort:�˿�������˿�
#�����������
#����ֵ�� ��
#���ߣ������
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap" $fileId
	if {$aGPNPort4Cnt1(cnt2) < $::rateL || $aGPNPort4Cnt1(cnt2) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱNE1($::gpnIp1)$::GPNTestEth3\����tag=50����������NE3($::gpnIp3)\
			$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱNE1($::gpnIp1)$::GPNTestEth3\����tag=50����������NE3($::gpnIp3)\
			$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$aGPNPort3Cnt1(cnt6) < $::rateL || $aGPNPort3Cnt1(cnt6) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱNE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������NE1($::gpnIp1)\
			$::GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱNE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������NE1($::gpnIp1)\
			$::GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)����$::rateL-$::rateR\��Χ��" $fileId
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
				set printWord "���˿�" 
			} else {
				set printWord "�Ӷ˿�"
			}
			if {$FrameRate21 != 0} {
				set DhTime2 [expr ($DropFrame22-$DropFrame21)*1000/$FrameRate21]
				if {$DhTime2>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$eth\down��up�����󣬷��͵���ʱ��Ϊ$DhTime2\ms�������������ʱ��$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "��$i\��$matchType trunk��$trunKName$printWord$eth\down��up�����󣬷��͵���ʱ��Ϊ$DhTime2\msС�����������ʱ��$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$eth\down��up������ҵ��ͨ���޷����Է��͵���ʱ��" $fileId
			}
			if {$FrameRate61 != 0} {
				set DhTime6 [expr ($DropFrame62-$DropFrame61)*1000/$FrameRate61]
				if {$DhTime6>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$eth\down��up�����󣬽��յ���ʱ��Ϊ$DhTime6\ms�������������ʱ��$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "��$i\��$matchType trunk��$trunKName$printWord$eth\down��up�����󣬽��յ���ʱ��Ϊ$DhTime6\msС�����������ʱ��$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$eth\down��up������ҵ��ͨ���޷����Խ��յ���ʱ��" $fileId
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap" $fileId
	if {$aGPNPort4Cnt1(cnt2)!=0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱshutdownTRUNK�����ж˿ڳ�ԱNE1($::gpnIp1)$::GPNTestEth3\����tag=50����������\
			NE3($::gpnIp3)$::GPNTestEth4\�յ�tag=50��������������ӦΪ0��ʵΪ$aGPNPort4Cnt1(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱshutdownTRUNK�����ж˿ڳ�ԱNE1($::gpnIp1)$::GPNTestEth3\����tag=50����������\
			NE3($::gpnIp3)$::GPNTestEth4\�յ�tag=50��������������ӦΪ0��ʵΪ$aGPNPort4Cnt1(cnt2)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt6)!=0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱshutdownTRUNK�����ж˿ڳ�ԱNE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������\
			NE1($::gpnIp1)$::GPNTestEth3\�յ�tag=1000��������������ӦΪ0��ʵΪ$aGPNPort3Cnt1(cnt6)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱshutdownTRUNK�����ж˿ڳ�ԱNE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������\
			NE1($::gpnIp1)$::GPNTestEth3\�յ�tag=1000��������������ӦΪ0��ʵΪ$aGPNPort3Cnt1(cnt6)" $fileId
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
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap" $fileId
		if {$aGPNPort4Cnt1(cnt2) < $::rateL || $aGPNPort4Cnt1(cnt2) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱtrunk��˿�$port1 up $port2 down NE1($::gpnIp1)$::GPNTestEth3\
				����tag=50����������NE3($::gpnIp3)$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱtrunk��˿�$port1 up $port2 down NE1($::gpnIp1)$::GPNTestEth3\
				����tag=50����������NE3($::gpnIp3)$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$aGPNPort3Cnt1(cnt6) < $::rateL || $aGPNPort3Cnt1(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱtrunk��˿�$port1 up $port2 down NE3($::gpnIp3)$::GPNTestEth4\
				����tag=1000����������NE1($::gpnIp1)$::GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱtrunk��˿�$port1 up $port2 down NE3($::gpnIp3)$::GPNTestEth4\
				����tag=1000����������NE1($::gpnIp1)$::GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)����$::rateL-$::rateR\��Χ��" $fileId
		}
	}
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth1 "undo shutdown"
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth2 "undo shutdown"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
	return $flag
}
########################################################################################################
#�������ܣ�GPN��epģʽ���ظ�����
#�������:RunFlag:�ظ����־λ
#	  caseId:ץ���˿�id��
#���������flag��ҵ���жϽ����־λ
#����ֵ�� ��
#���ߣ������
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap" $fileId
	if {$RunFlag == 0} {
		#DEV1 GPNTestEth1�Ľ��ռ�� 
        	if {$GPNPort1Cnt1(cnt22) < $::rateL || $GPNPort1Cnt1(cnt22) > $::rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord NE2($::gpnIp2)$::GPNTestEth2\����tag=500����֪������������NE1($::gpnIp1)\
        			$::GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt22)��û��$::rateL-$::rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord NE2($::gpnIp2)$::GPNTestEth2\����tag=500����֪������������NE1($::gpnIp1)\
        			$::GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt22)����$::rateL-$::rateR\��Χ��" $fileId
        	}
        	if {$GPNPort1Cnt1(cnt33) < $::rateL || $GPNPort1Cnt1(cnt33) > $::rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord NE3($::gpnIp3)$::GPNTestEth3\����tag=500��֪��������������NE1($::gpnIp1)\
        			$::GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt33)��û��$::rateL-$::rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord NE3($::gpnIp3)$::GPNTestEth3\����tag=500����֪������������NE1($::gpnIp1)\
        			$::GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt33)����$::rateL-$::rateR\��Χ��" $fileId
        	}
        	if {$GPNPort1Cnt1(cnt44) < $::rateL || $GPNPort1Cnt1(cnt44) > $::rateR} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=500����֪������������NE1($::gpnIp1)\
        			$::GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt44)��û��$::rateL-$::rateR\��Χ��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=500����֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt44)����$::rateL-$::rateR\��Χ��" $fileId
        	}
		if {$GPNPort1Cnt1(cnt10) < $::rateL0 || $GPNPort1Cnt1(cnt10) > $::rateR0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800�Ĺ㲥��������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt10)��û��$::rateL0-$::rateR0\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800�Ĺ㲥��������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt10)����$::rateL0-$::rateR0\��Χ��" $fileId
		}
		if {$GPNPort1Cnt1(cnt11) < $::rateL || $GPNPort1Cnt1(cnt11) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800���鲥��������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt11)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800���鲥��������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt11)����$::rateL-$::rateR\��Χ��" $fileId
		}
		#DEV2 GPNTestEth2�Ľ��ռ�� 
		if {$GPNPort2Cnt1(cnt2) < $::rateL || $GPNPort2Cnt1(cnt2) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����tag=500����֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����tag=500����֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt1(cnt1) != 0} {
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=500��������������Ӧ��Ϊ0ʵΪ$GPNPort2Cnt1(cnt1)" $fileId
		} else {
			if {$GPNPort2Cnt0(cnt1) < $::rateL || $GPNPort2Cnt0(cnt1) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt0(cnt1)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�untag��������������Ϊ$GPNPort2Cnt0(cnt1)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort2Cnt0(cnt5) < $::rateL0 || $GPNPort2Cnt0(cnt5) > $::rateR0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag�Ĺ㲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt0(cnt5)��û��$::rateL0-$::rateR0\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag�Ĺ㲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt0(cnt5)����$::rateL0-$::rateR0\��Χ��" $fileId
		}
		if {$GPNPort2Cnt0(cnt6) < $::rateL || $GPNPort2Cnt0(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag���鲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt0(cnt6)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag���鲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt0(cnt6)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt1(cnt10) < $::rateL0 || $GPNPort2Cnt1(cnt10) > $::rateR0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800�Ĺ㲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt1(cnt10)��û��$::rateL0-$::rateR0\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800�Ĺ㲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt1(cnt10)����$::rateL0-$::rateR0\��Χ��" $fileId
		}
		if {$GPNPort2Cnt1(cnt11) < $::rateL || $GPNPort2Cnt1(cnt11) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800���鲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt1(cnt11)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800���鲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt1(cnt11)����$::rateL-$::rateR\��Χ��" $fileId
		}
		#DEV3 GPNTestEth3�Ľ��ռ��
		if {$GPNPort3Cnt1(cnt3) < $::rateL || $GPNPort3Cnt1(cnt3) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����tag=500����֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt3)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����tag=500����֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt3)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt1(cnt1) != 0} {
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=500��������������Ӧ��Ϊ0ʵΪ$GPNPort3Cnt1(cnt1)" $fileId
		} else {
			if {$GPNPort3Cnt0(cnt1) < $::rateL || $GPNPort3Cnt0(cnt1) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE3($::gpnIp3)\
					$::GPNTestEth3\�յ�untag��������������Ϊ$GPNPort3Cnt0(cnt1)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE3($::gpnIp3)\
					$::GPNTestEth3\�յ�untag��������������Ϊ$GPNPort3Cnt0(cnt1)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort3Cnt0(cnt5) < $::rateL0 || $GPNPort3Cnt0(cnt5) > $::rateR0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag�Ĺ㲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt0(cnt5)��û��$::rateL0-$::rateR0\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag�Ĺ㲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt0(cnt5)����$::rateL0-$::rateR0\��Χ��" $fileId
		}
		if {$GPNPort3Cnt0(cnt6) < $::rateL || $GPNPort3Cnt0(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag���鲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt0(cnt6)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag���鲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt0(cnt6)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt1(cnt10) < $::rateL0 || $GPNPort3Cnt1(cnt10) > $::rateR0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800�Ĺ㲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt1(cnt10)��û��$::rateL0-$::rateR0\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800�Ĺ㲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt1(cnt10)����$::rateL0-$::rateR0\��Χ��" $fileId
		}
		if {$GPNPort3Cnt1(cnt11) < $::rateL || $GPNPort3Cnt1(cnt11) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800���鲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt1(cnt11)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800���鲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt1(cnt11)����$::rateL-$::rateR\��Χ��" $fileId
		}
		#DEV4 GPNTestEth4�Ľ��ռ��
		if {$GPNPort4Cnt1(cnt4) < $::rateL || $GPNPort4Cnt1(cnt4) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����tag=500����֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�tag=500��������������Ϊ$GPNPort4Cnt1(cnt4)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����tag=500����֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�tag=500��������������Ϊ$GPNPort4Cnt1(cnt4)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt1(cnt1) != 0} {
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE4($::gpnIp4)\
			$::GPNTestEth4\�յ�tag=500��������������Ӧ��Ϊ0ʵΪ$GPNPort4Cnt1(cnt1)" $fileId
		} else {
			if {$GPNPort4Cnt0(cnt1) < $::rateL || $GPNPort4Cnt0(cnt1) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE4($::gpnIp4)\
					$::GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt0(cnt1)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE4($::gpnIp4)\
					$::GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt0(cnt1)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort4Cnt0(cnt5) < $::rateL0 || $GPNPort4Cnt0(cnt5) > $::rateR0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag�Ĺ㲥��������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������Ϊ$GPNPort4Cnt0(cnt5)��û��$::rateL0-$::rateR0\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag�Ĺ㲥��������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������Ϊ$GPNPort4Cnt0(cnt5)����$::rateL0-$::rateR0\��Χ��" $fileId
		}
		if {$GPNPort4Cnt0(cnt6) < $::rateL || $GPNPort4Cnt0(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag���鲥��������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������Ϊ$GPNPort4Cnt0(cnt6)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag���鲥��������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������Ϊ$GPNPort4Cnt0(cnt6)����$::rateL-$::rateR\��Χ��" $fileId
		}
	} else {
		#DEV1 GPNTestEth1�Ľ��ռ�� 
		if {$GPNPort1Cnt1(cnt22) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE2($::gpnIp2)$::GPNTestEth2\����tag=500����֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt22)��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE2($::gpnIp2)$::GPNTestEth2\����tag=500����֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt22)" $fileId
		}
		if {$GPNPort1Cnt1(cnt33) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE3($::gpnIp3)$::GPNTestEth3\����tag=500��֪��������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt33)��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE3($::gpnIp3)$::GPNTestEth3\����tag=500����֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt33)" $fileId
		}
		if {$GPNPort1Cnt1(cnt44) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=500����֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt44)��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=500����֪������������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt44)" $fileId
		}
		if {$GPNPort1Cnt1(cnt10) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800�Ĺ㲥��������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=800��������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt10)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800�Ĺ㲥��������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=800��������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt10)" $fileId
		}
		if {$GPNPort1Cnt1(cnt11) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800���鲥��������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=800��������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt11)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800���鲥��������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�tag=800��������������ӦΪ0ʵΪ$GPNPort1Cnt1(cnt11)" $fileId
		}
		#DEV2 GPNTestEth2�Ľ��ռ�� 
		if {$GPNPort2Cnt1(cnt2) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����tag=500����֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt2)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����tag=500����֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt2)" $fileId
		}
		if {$GPNPort2Cnt0(cnt1) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�untag��������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�untag��������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
		}
		if {$GPNPort2Cnt0(cnt5) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag�Ĺ㲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt5)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag�Ĺ㲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt5)" $fileId
		}
		if {$GPNPort2Cnt0(cnt6) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag���鲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt6)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag���鲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt6)" $fileId
		}
		if {$GPNPort2Cnt1(cnt10) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800�Ĺ㲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt10)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800�Ĺ㲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt10)" $fileId
		}
		if {$GPNPort2Cnt1(cnt11) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800���鲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt11)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800���鲥��������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt11)" $fileId
		}
		#DEV3 GPNTestEth3�Ľ��ռ��
		if {$GPNPort3Cnt1(cnt3) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����tag=500����֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt3)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����tag=500����֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt3)" $fileId
		}
		if {$GPNPort3Cnt0(cnt1) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�untag��������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�untag��������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
		}
		if {$GPNPort3Cnt0(cnt5) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag�Ĺ㲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt5)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag�Ĺ㲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt5)" $fileId
		}
		if {$GPNPort3Cnt0(cnt6) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag���鲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt6)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag���鲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt6)" $fileId
		}
		if {$GPNPort3Cnt1(cnt10) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800�Ĺ㲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt10)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800�Ĺ㲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt10)" $fileId
		}
		if {$GPNPort3Cnt1(cnt11) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800���鲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt11)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE4($::gpnIp4)$::GPNTestEth4\����tag=800���鲥��������NE3($::gpnIp3)\
				$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt11)" $fileId
		}
		#DEV4 GPNTestEth4�Ľ��ռ��
		if {$GPNPort4Cnt1(cnt4) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����tag=500����֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt4)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����tag=500����֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�tag=500��������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt4)" $fileId
		}
		if {$GPNPort4Cnt0(cnt1) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�untag��������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag��δ֪������������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�untag��������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
		}
		if {$GPNPort4Cnt0(cnt5) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag�Ĺ㲥��������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt5)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag�Ĺ㲥��������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt5)" $fileId
		}
		if {$GPNPort4Cnt0(cnt6) != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag���鲥��������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt6)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord NE1($::gpnIp1)$::GPNTestEth1\����untag���鲥��������NE4($::gpnIp4)\
				$::GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt6)" $fileId
		}
	}
  	return $flag
}


#########################################################################################################
##�������ܣ�GPN��ɾ����̨�豸��ac pw��vpls������
##�������: pw:pw��vpls id�ĳ�ֵ
##	  RunFlag:ɾ�����־λ
##	  AcName:ac�ӿ�����
##�����������
##����ֵ�� ��
##���ߣ������
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
#�������ܣ�GPN���޸���̨�豸��ac pw��vpls������
#�������: fileId:���Ա�����ļ�id
#                     id:pw��vpls id�ĳ�ֵ
#                     type:mac��ַѧϰ���� discard/flood
#                     maccnt:mac��ַѧϰ����
#	  ifDel���Ƿ�ɾ��֮ǰ������  =1 ɾ��        =0��ɾ��
#	  ifAdd���Ƿ��������  =1 ���        =0�����
#�����������
#����ֵ�� ��
#���ߣ������
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
		#============�����豸NE1==========="
		gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls$id" $id "elan" $type "false" "false" "false" "true" $maccnt "" ""
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls$id" "peer" $::address612 "102" "102" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls$id" "peer" $::address614 "402" "402" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4" 
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls$id" "peer" $::address613 "52" "52" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac500" "vpls$id" "" $::GPNTestEth1 "500" "0" "none" "nochange" "1" "0" "0" "0x8100" "evc2"	
	}
}
########################################################################################################
#�������ܣ�GPN���޸���̨�豸��ac pw��vpls������
#�������: fileId:���Ա�����ļ�id
#                     id:pw��vpls id�ĳ�ֵ
#                     type:mac��ַѧϰ���� discard/flood
#                     maccnt:mac��ַѧϰ����
#	  ifDel���Ƿ�ɾ��֮ǰ������  =1 ɾ��        =0��ɾ��
#	  ifAdd���Ƿ��������  =1 ���        =0�����
#�����������
#����ֵ�� ��
#���ߣ������
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
		#============�����豸NE1==========="
		gwd::GWVpls_AddInfo $telnet1 $matchType1 $Gpn_type1 $fileId "vpls$id" $id "etree" $type $bcastCfg $mcastCfg $unicastCfg "true" $maccnt "" ""
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw12" "vpls" "vpls$id" "peer" $::address612 "1000" "1000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "2"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw14" "vpls" "vpls$id" "peer" $::address614 "2000" "2000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "4"
		gwd::GWpublic_CfgPw $telnet1 $matchType1 $Gpn_type1 $fileId "pw13" "vpls" "vpls$id" "peer" $::address613 "3000" "3000" "" "nochange" "none" 1 0 "0x8100" "0x8100" "3"
		gwd::GWAc_AddVplsInfo $telnet1 $matchType1 $Gpn_type1 $fileId "ac800" "vpls$id" "" $::GPNTestEth1 "800" "0" "root" "nochange" "1" "0" "0" "0x8100" "evc2"	
	}
}
########################################################################################################
#�������ܣ�GPN���޸���̨�豸��ac pw��vpls������
#�������: fileId:���Ա�����ļ�id
#                     id:pw��vpls id�ĳ�ֵ
#                   vid1:��Ӫ��vlan
#                   vid2:�ͻ�vlan
#                   type:mac��ַѧϰ���� discard/flood
#                 maccnt:mac��ַѧϰ����
#               RoleList:AC��ɫ�б�
#                  role1:PW��ɫ1
#                  role2:PW��ɫ2
#�����������
#����ֵ�� ��
#���ߣ������
########################################################################################################
#proc PTN_ChangeEtreeConfig {fileId id vid1 vid2 type maccnt RoleList role1 role2} {
#foreach telnet $::Telnetlist Gpn_type $::Typelist eth $::Portlist0 role $RoleList {
####����vpls
#gwd::GPN_CfgVlanVpls "GPN_PTN_010" $fileId "vpls$id" $id "etree" $type "false" "false" "false" "true" $maccnt $Gpn_type $telnet
##����ac
#gwd::GPN_CfgVlanAC "GPN_PTN_010" $fileId "ac$vid1" "vpls$id" $eth $vid1 $vid2 $role "nochange" "1" "0" "0" "0x8100" "evc2" $Gpn_type $telnet
#incr id 10
#}
####����pw
#puts $fileId "\n============�����豸NE1===========\n"
#gwd::GPN_CreatePw "GPN_PTN_010" $fileId "pw012" "vpls" "vpls10" "peer" $::address612 "100" "100" "" "nochange" $role1 1 0 "0x8100" "0x8100" "2" $::telnet1 $::Gpn_type1
#gwd::GPN_CreatePw "GPN_PTN_010" $fileId "pw014" "vpls" "vpls10" "peer" $::address614 "200" "200" "" "nochange" $role1 1 0 "0x8100" "0x8100" "4" $::telnet1 $::Gpn_type1
#gwd::GPN_CreatePw "GPN_PTN_010" $fileId "pw013" "vpls" "vpls10" "peer" $::address613 "300" "300" "" "nochange" $role1 1 0 "0x8100" "0x8100" "3" $::telnet1 $::Gpn_type1
#puts $fileId "\n============�����豸NE2===========\n"
#gwd::GPN_CreatePw "GPN_PTN_010" $fileId "pw021" "vpls" "vpls20" "peer" $::address621 "100" "100" "" "nochange" $role2 1 0 "0x8100" "0x8100" "1" $::telnet2 $::Gpn_type2
#puts $fileId "\n============�����豸NE3===========\n"
#gwd::GPN_CreatePw "GPN_PTN_010" $fileId "pw031" "vpls" "vpls30" "peer" $::address631 "300" "300" "" "nochange" $role2 1 0 "0x8100" "0x8100" "1" $::telnet3 $::Gpn_type3
#puts $fileId "\n============�����豸NE4===========\n"
#gwd::GPN_CreatePw "GPN_PTN_010" $fileId "pw041" "vpls" "vpls40" "peer" $::address641 "200" "200" "" "nochange" $role2 1 0 "0x8100" "0x8100" "1" $::telnet4 $::Gpn_type4
#}
########################################################################################################
#�������ܣ���ѯvpls����
#�������: fileId:���Ա�����ļ�id
#         type:ac/pw
#     typename:ac/pw����
#     vplsname:vpls����
#     GPN_type:�豸����
#       GPN_Id:spawn id
#�����������
#����ֵ�� tableList��vpls�����б�
#���ߣ������
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
  puts -nonewline $fileId [format "%-59s" "��GPN�ϲ�ѯvpls����"]
  if {$flagErr} {
    puts $fileId "NOK"   
  } else {
    puts $fileId "OK" 
  }
  return $tableList
}
########################################################################################################
#�������ܣ�GPN�ϲ���vpls����mac��ַѧϰ�����͹���
#�������: type:flood/discard
#          acName ���鿴��ַת����ʱ����ac������
#          vplsName ���鿴��ַת����ʱ����vpls������
#          macLearnCnt ��������mac��ַѧϰ����
#          recCnt �������Ľ��յ������ݰ��ĸ���
#����ֵ�� flag
#���ߣ������
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
		gwd::GWpublic_print "NOK" "����mac��ַѧϰ����Ϊ$macLearnCnt\��ѧϰ����Ϊ$type\��NE1($::gpnIp1)����200��mac��ַ�仯����������NE1($::gpnIp1)mac��ַ����ѧϰ��ac1��mac��ַ����Ϊ$maccnt" $fileId
	} else {
		gwd::GWpublic_print "OK" "����mac��ַѧϰ����Ϊ$macLearnCnt\��ѧϰ����Ϊ$type\��NE1($::gpnIp1)����200��mac��ַ�仯����������NE1($::gpnIp1)mac��ַ����ѧϰ��ac1��mac��ַ����Ϊ$maccnt" $fileId
	}
	
	set cnt2 [stc::get $::hGPNPort2Ana.AnalyzerPortResults -SigFrameCount]
	set cnt3 [stc::get $::hGPNPort3Ana.AnalyzerPortResults -SigFrameCount]
	set cnt4 [stc::get $::hGPNPort4Ana.AnalyzerPortResults -SigFrameCount]
        puts "portcnt2: $cnt2 portcnt3: $cnt3 portcnt4: $cnt4"
        if {$cnt2 !=$recCnt} {
		set flag 1
		gwd::GWpublic_print "NOK" "����mac��ַѧϰ����Ϊ$macLearnCnt\��ѧϰ����Ϊ$type\��NE1($::gpnIp1)����200��mac��ַ�仯����������NE2($::gpnIp2)�յ���mac��ַ�仯������������Ϊ$cnt2" $fileId
        } else {
		gwd::GWpublic_print "OK" "����mac��ַѧϰ����Ϊ$macLearnCnt\��ѧϰ����Ϊ$type\��NE1($::gpnIp1)����200��mac��ַ�仯����������NE2($::gpnIp2)�յ���mac��ַ�仯������������Ϊ$cnt2" $fileId
        }
	if {$cnt3 !=$recCnt} {
		set flag 1
		gwd::GWpublic_print "NOK" "����mac��ַѧϰ����Ϊ$macLearnCnt\��ѧϰ����Ϊ$type\��NE1($::gpnIp1)����200��mac��ַ�仯����������NE3($::gpnIp4)�յ���mac��ַ�仯������������Ϊ$cnt3" $fileId
	} else {
		gwd::GWpublic_print "OK" "����mac��ַѧϰ����Ϊ$macLearnCnt\��ѧϰ����Ϊ$type\��NE1($::gpnIp1)����200��mac��ַ�仯����������NE3($::gpnIp4)�յ���mac��ַ�仯������������Ϊ$cnt3" $fileId
	}
	if {$cnt4 !=$recCnt} {
		set flag 1
		gwd::GWpublic_print "NOK" "����mac��ַѧϰ����Ϊ$macLearnCnt\��ѧϰ����Ϊ$type\��NE1($::gpnIp1)����200��mac��ַ�仯����������NE4($::gpnIp4)�յ���mac��ַ�仯������������Ϊ$cnt4" $fileId
	} else {
		gwd::GWpublic_print "OK" "����mac��ַѧϰ����Ϊ$macLearnCnt\��ѧϰ����Ϊ$type\��NE1($::gpnIp1)����200��mac��ַ�仯����������NE4($::gpnIp4)�յ���mac��ַ�仯������������Ϊ$cnt4" $fileId
	}
	return $flag
}
########################################################################################################
#�������ܣ�GPN�ϱ��Ĺ��˲���
#�������: RunFlag ���������־λ
#���������flag:����ת������жϱ�־λ
#����ֵ�� ��
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
puts $::fileId "NE4����δ֪�������㲥���鲥��ȡ���鲥/�㲥���Ʒ�����֤ҵ��ת���쳣"
} elseif {$RunFlag==2} {
puts $::fileId "NE4����δ֪�������㲥���鲥��ʹ���鲥/�㲥���Ʒ�����֤ҵ��ת������"
} elseif {$RunFlag==3} {
set aTempFlag 1
puts $::fileId "NE4����δ֪�������㲥���鲥��ȡ���鲥/�㲥���Ʒ�����֤ҵ��ָ��쳣"
} 
puts $::fileId "NE1�豸�յ�NE4��δ֪�������㲥���鲥�ֱ�Ϊ��$GPNPort1Cnt1(cnt44) bps $GPNPort1Cnt1(cnt10) bps $GPNPort1Cnt1(cnt11) bps"
puts $::fileId "NE2�豸�յ�NE4��δ֪�������㲥���鲥�ֱ�Ϊ��$GPNPort2Cnt1(cnt44) bps $GPNPort2Cnt1(cnt10) bps $GPNPort2Cnt1(cnt11) bps"
puts $::fileId "NE3�豸�յ�NE4��δ֪�������㲥���鲥�ֱ�Ϊ��$GPNPort3Cnt1(cnt44) bps $GPNPort3Cnt1(cnt10) bps $GPNPort3Cnt1(cnt11) bps"
 }
}
########################################################################################################
#�������ܣ�GPN�ϱ��Ĺ��˲���
#�������: RunFlag ���������־λ
#���������flag:����ת������жϱ�־λ
#����ֵ�� ��
#���ߣ������
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
puts $::fileId "NE1����δ֪�������㲥���鲥��ȡ���鲥/�㲥���Ʒ�����֤ҵ��ת���쳣"
} elseif {$RunFlag==2} {
puts $::fileId "NE1����δ֪�������㲥���鲥��ʹ���鲥/�㲥���Ʒ�����֤ҵ��ת���쳣"
} elseif {$RunFlag==3} {
puts $::fileId "NE1����δ֪�������㲥���鲥��ȡ���鲥/�㲥���Ʒ�����֤ҵ��ָ��쳣"
} 
puts $::fileId "���Ʋ���Ч��NE4�豸�յ�NE1��δ֪�������㲥���鲥�ֱ�Ϊ��$GPNPort4Cnt1(cnt13) bps $GPNPort4Cnt1(cnt10) bps $GPNPort4Cnt1(cnt11) bps"
puts $::fileId "���Ʋ���Ч��NE2�豸�յ�NE1��δ֪�������㲥���鲥�ֱ�Ϊ��$GPNPort2Cnt1(cnt13) bps $GPNPort2Cnt1(cnt10) bps $GPNPort2Cnt1(cnt11) bps"
puts $::fileId "���Ʋ���Ч��NE3�豸�յ�NE1��δ֪�������㲥���鲥�ֱ�Ϊ��$GPNPort3Cnt1(cnt13) bps $GPNPort3Cnt1(cnt10) bps $GPNPort3Cnt1(cnt11) bps"
 }
}
########################################################################################################
#�������ܣ�GPN�Ϻڰ���������
#         f_black��    =1����������         =0����������
#         f_addStatic���Ƿ�����˾�̬mac��ַ     =1����˾�̬mac��ַ/�ڶ�         =0û����Ӿ�̬mac��ַ/�ڶ�
#         f_pw��     =1��pw������˾�̬mac��ַ/�ڶ� 
#	  printWord�������д�ӡ�Ĺؼ��ַ���
#             type ��mac��ѯ���� vpls pw ac 
#         typename ����ѯ���Ͷ�Ӧ������
#         vplsname ����ѯmac��ַ��vpls�������
#              mac ����̬mac��ַ/�ڶ���ַ
# 	  caseId��ץ���ļ����ֵĹؼ���
#���������flag1:����ת������жϱ�־λ
#	  flag2:mac��ַѧϰ����жϱ�־λ
#����ֵ�� ��
#���ߣ������
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($::gpnIp4\).pcap" $fileId
	if {[string match "0000.0000.0022" $mac]} {
		set prtStr "dmac"
	} else {
		set prtStr "smac"
	}
        if {$f_black==0} {
        	if {$f_pw == 1 && $f_addStatic == 1} {
				if {$GPNPort2Cnt1(cnt2) < $::rateL || $GPNPort2Cnt1(cnt2) > $::rateR} {
					set flag 1
					gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE2($gpnIp2)\
						$GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
				} else {
					gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE2($gpnIp2)\
						$GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
				}
				if {$GPNPort3Cnt1(cnt2) != 0} {
					set flag 1
					gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE3($gpnIp3)\
						$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt2)" $fileId
				} else {
					gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE3($gpnIp3)\
						$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt2)" $fileId
				}
				if {$GPNPort4Cnt1(cnt2) != 0} {
					set flag 1
					gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE4($gpnIp4)\
						$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt2)" $fileId
				} else {
					gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE4($gpnIp4)\
						$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt2)" $fileId
				}
        	} else {
			if {$GPNPort2Cnt1(cnt2) < $::rateL || $GPNPort2Cnt1(cnt2) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
			}
        		if {$GPNPort3Cnt1(cnt2) < $::rateL || $GPNPort3Cnt1(cnt2) > $::rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE3($gpnIp3)\
        				$GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE3($gpnIp3)\
        				$GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
        		}
        		if {$GPNPort4Cnt1(cnt2) < $::rateL || $GPNPort4Cnt1(cnt2) > $::rateR} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE4($gpnIp4)\
        				$GPNTestEth4\�յ�������������Ϊ$GPNPort4Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
        		} else {
        			gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE4($gpnIp4)\
        				$GPNTestEth4\�յ�������������Ϊ$GPNPort4Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
        		}
        		
        	}
        
        } elseif {$f_black==1} {
            	if {$f_pw == 0 && $f_addStatic == 1} {
                    	if {$GPNPort2Cnt1(cnt2) != 0} {
                    		set flag 1
                    		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE2($gpnIp2)\
                    			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt2)" $fileId
                    	} else {
                    		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE2($gpnIp2)\
                    			$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt2)" $fileId
                    	}
                    	if {$GPNPort3Cnt1(cnt2) != 0} {
                    		set flag 1
                    		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE3($gpnIp3)\
                    			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt2)" $fileId
                    	} else {
                    		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE3($gpnIp3)\
                    			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt1(cnt2)" $fileId
                    	}
                    	if {$GPNPort4Cnt1(cnt2) != 0} {
                    		set flag 1
                    		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE4($gpnIp4)\
                    			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt2)" $fileId
                    	} else {
                    		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE4($gpnIp4)\
                    			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt1(cnt2)" $fileId
                    	}
            	} elseif {$f_pw == 1 && $f_addStatic == 1} {
			if {$GPNPort2Cnt1(cnt2) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt2)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE2($gpnIp2)\
					$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt1(cnt2)" $fileId
			}
			if {$GPNPort3Cnt1(cnt2) < $::rateL || $GPNPort3Cnt1(cnt2) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE3($gpnIp3)\
					$GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
			}
			if {$GPNPort4Cnt1(cnt2) < $::rateL || $GPNPort4Cnt1(cnt2) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������Ϊ$GPNPort4Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE4($gpnIp4)\
					$GPNTestEth4\�յ�������������Ϊ$GPNPort4Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
			}
		} else {
        		if {$GPNPort2Cnt1(cnt2) < $::rateL || $GPNPort2Cnt1(cnt2) > $::rateR} {
        		    set flag 1
        		    gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE2($gpnIp2)\
        			    $GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
        		} else {
        		    gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE2($gpnIp2)\
        			    $GPNTestEth2\�յ�������������Ϊ$GPNPort2Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
        		}
        		if {$GPNPort3Cnt1(cnt2) < $::rateL || $GPNPort3Cnt1(cnt2) > $::rateR} {
        		    set flag 1
        		    gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE3($gpnIp3)\
        			    $GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
        		} else {
        		    gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE3($gpnIp3)\
        			    $GPNTestEth3\�յ�������������Ϊ$GPNPort3Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
        		}
        		if {$GPNPort4Cnt1(cnt2) < $::rateL || $GPNPort4Cnt1(cnt2) > $::rateR} {
        		    set flag 1
        		    gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE4($gpnIp4)\
        			    $GPNTestEth4\�յ�������������Ϊ$GPNPort4Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
        		} else {
        		    gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\����$prtStr=$mac\��δ֪������������NE4($gpnIp4)\
        			    $GPNTestEth4\�յ�������������Ϊ$GPNPort4Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
        		}
		} 
	}
	gwd::GWpubic_queryVPLSForwardTable $::telnet1 $::matchType1 $::Gpn_type1 $fileId $type $typename $vplsname dTable
        if {$f_addStatic == 1} {
        	if {[dict exists $dTable $mac]} {
        		if {[string match -nocase $typename [dict get $dTable $mac portname]]} {
        			gwd::GWpublic_print "OK" "$printWord\mac��ַ$mac\��portname��$typename" $fileId
        		} else {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\mac��ַ$mac\��portname��[dict get $dTable $mac portname]" $fileId
        		}
			if {[string match -nocase "static" [dict get $dTable $mac flag]]} {
				gwd::GWpublic_print "OK" "$printWord\mac��ַ$mac\��ʾ�Ǿ�̬mac��ַ" $fileId
			} elseif {[string match -nocase "none" [dict get $dTable $mac flag]]} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\mac��ַ$mac\��ʾ�Ƕ�̬ѧϰ����mac��ַ" $fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\mac��ַ$mac\��flag��Ϣ��ʾ��[dict get $dTable $mac flag]" $fileId
			}
			if {$f_black==1} {
				if {[string match -nocase "src" [dict get $dTable $mac drop]]} {
					gwd::GWpublic_print "OK" "$printWord\mac��ַ$mac\��drop��Ϣ��ʾ��[dict get $dTable $mac drop]" $fileId
				} else {
					set flag 1
					gwd::GWpublic_print "NOK" "$printWord\mac��ַ$mac\��drop��Ϣ��ʾ��[dict get $dTable $mac drop]" $fileId
				}
			}
        	} else {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord\û��mac=$mac\��ת������" $fileId
        	}
        } else {
        	if {[dict exists $dTable $mac]} {
        		if {[string match -nocase $typename [dict get $dTable $mac portname]]} {
        			gwd::GWpublic_print "OK" "$printWord\mac��ַ$mac\��portname��$typename" $fileId
        		} else {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\mac��ַ$mac\��portname��[dict get $dTable $mac portname]" $fileId
        		}
        		if {[string match -nocase "static" [dict get $dTable $mac flag]]} {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\mac��ַ$mac\��ʾ�Ǿ�̬mac��ַ" $fileId
        		} elseif {[string match -nocase "none" [dict get $dTable $mac flag]]} {
        			gwd::GWpublic_print "OK" "$printWord\mac��ַ$mac\��ʾ�Ƕ�̬ѧϰ����mac��ַ" $fileId
        		} else {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord\mac��ַ$mac\��ʾ��[dict get $dTable $mac flag]��mac��ַ" $fileId
        		}
			if {![string match -nocase "none" [dict get $dTable $mac drop]]} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\mac��ַ$mac\��drop��Ϣ��ʾ��[dict get $dTable $mac drop]" $fileId
			}
        	} else {
			if {![string match -nocase "pw" $type]} {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\û��mac=$mac\��ת������" $fileId
			}
        	}
        }
	return $flag

}
########################################################################################################
#�������ܣ�GPN�ϲ���elanҵ���AC��PW�Ķ���
#�������:       Action ��VLAN�������� AC/PW
#               RunFlag �����ú�����־λ
#		matchPara��classificationStatisticsPortRxCnt4��ƥ�����
#           hGPNPortGen �������������˿�ָ��
#           hGPNPortAna �������������˿�ָ��
#hGPNPortAnaFrameCfgFil �����÷������˿�ָ��
#        anaFliFrameCfg �����÷���������
#�����������
#����ֵ�� flag:���������ͳ�Ʊ�־λ
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $fileId
        if {($RunFlag == 1) || ($RunFlag == 7)} {
		#AC/PW �������� NE1--->NE2
		if {$RunFlag == 1} {
			if {$GPNPort12Cnt02(cnt12) < $::rateL || $GPNPort12Cnt02(cnt12) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�tag=800������������Ϊ$GPNPort12Cnt02(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�tag=800������������Ϊ$GPNPort12Cnt02(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
			}
		} else {
			if {$GPNPort12Cnt02(cnt17) < $::rateL || $GPNPort12Cnt02(cnt17) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\�������tag=800 �ڲ�tag=100 tpid=0x8100����������\
					NE2($::gpnIp2)$::GPNTestEth2\�յ����tag=800 �ڲ�tag=100������������Ϊ$GPNPort12Cnt02(cnt17)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\�������tag=800 �ڲ�tag=100 tpid=0x8100����������\
					NE2($::gpnIp2)$::GPNTestEth2\�յ����tag=800 �ڲ�tag=100������������Ϊ$GPNPort12Cnt02(cnt17)����$::rateL-$::rateR\��Χ��" $fileId
			}
			if {$GPNPort12Cnt01(cnt12) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt12)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt12)" $fileId
			}
		}
		if {$GPNPort12Cnt01(cnt1)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\����untag����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\����untag����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt1)" $fileId
		}
		if {$GPNPort12Cnt01(cnt2)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\����tag=500 tpid=8100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt2)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\����tag=500 tpid=8100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt2)" $fileId
		}
		if {$GPNPort12Cnt01(cnt14)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=9100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt14)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=9100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt14)" $fileId
		}
        } elseif {($RunFlag == 2) || ($RunFlag == 8)} {
		#AC ����Ϊnochange NE2--->NE1
		if {$RunFlag == 2} {
			if {$GPNPort12Cnt02(cnt13) < $::rateL || $GPNPort12Cnt02(cnt13) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊnochange��NE2($::gpnIp2)$::GPNTestEth2\����tag=800 tpid=0x8100����������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�tag=800������������Ϊ$GPNPort12Cnt02(cnt13)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊnochange��NE2($::gpnIp2)$::GPNTestEth2\����tag=800 tpid=0x8100����������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�tag=800������������Ϊ$GPNPort12Cnt02(cnt13)����$::rateL-$::rateR\��Χ��" $fileId
			}
		} else {
			if {$GPNPort12Cnt01(cnt13) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊnochange��NE2($::gpnIp2)$::GPNTestEth2\����tag=800 tpid=0x8100����������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt13)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊnochange��NE2($::gpnIp2)$::GPNTestEth2\����tag=800 tpid=0x8100����������NE1($::gpnIp1)\
					$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt13)" $fileId
			}
			if {$GPNPort12Cnt02(cnt26) < $::rateL || $GPNPort12Cnt02(cnt26) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊnochange��NE2($::gpnIp2)$::GPNTestEth2\�������tag=800 �ڲ�tag=100 tpid=0x8100����������\
					NE1($::gpnIp1)$::GPNTestEth1\�յ����tag=800 �ڲ�tag=100��������������Ϊ$GPNPort12Cnt02(cnt26)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊnochange��NE2($::gpnIp2)$::GPNTestEth2\�������tag=800 �ڲ�tag=100 tpid=0x8100����������\
					NE1($::gpnIp1)$::GPNTestEth1\�յ����tag=800 �ڲ�tag=100��������������Ϊ$GPNPort12Cnt02(cnt26)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort12Cnt01(cnt16)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊnochange��NE2($::gpnIp2)$::GPNTestEth2\����tag=800 tpid=9100����������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt16)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊnochange��NE2($::gpnIp2)$::GPNTestEth2\����tag=800 tpid=9100����������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt16)" $fileId
		}
		if {$GPNPort12Cnt01(cnt02)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊnochange��NE2($::gpnIp2)$::GPNTestEth2\����tag=500 tpid=8100����������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt02)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊnochange��NE2($::gpnIp2)$::GPNTestEth2\����tag=500 tpid=8100����������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt02)" $fileId
		}
		if {$GPNPort12Cnt01(cnt01)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊnochange��NE2($::gpnIp2)$::GPNTestEth2\����untag����������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt01)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊnochange��NE2($::gpnIp2)$::GPNTestEth2\����untag����������NE1($::gpnIp1)\
				$::GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt01)" $fileId
		}
        } elseif {$RunFlag == 3} {
                if {$GPNPort5Cnt2(cnt7) < $::rateL1 || $GPNPort5Cnt2(cnt7) > $::rateR1} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\��NE2($::gpnIp2)$::GPNTestEth2����tag=800����֪��������������\
				NE1($::gpnIp1)$::GPNTestEth5����NNI�����ݣ��յ�MPLS��ǩΪ100 1000������������Ϊ$GPNPort5Cnt2(cnt7)��û��$::rateL1-$::rateR1\��Χ��" $fileId
                } else {
			gwd::GWpublic_print "OK" "$Action\����Ϊnochange��NE1($::gpnIp1)$::GPNTestEth1\��NE2($::gpnIp2)$::GPNTestEth2����tag=800����֪��������������\
				NE1($::gpnIp1)$::GPNTestEth5����NNI�����ݣ��յ�MPLS��ǩΪ100 1000������������Ϊ$GPNPort5Cnt2(cnt7)����$::rateL1-$::rateR1\��Χ��" $fileId
                }
        } elseif {($RunFlag == 4) || ($RunFlag == 9)} {
		#����Ϊɾ��
		if {$RunFlag == 4} {
			if {$GPNPort12Cnt02(cnt18) < $::rateL || $GPNPort12Cnt02(cnt18) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊdelete��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�untag������������Ϊ$GPNPort12Cnt02(cnt18)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊdelete��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�untag������������Ϊ$GPNPort12Cnt02(cnt18)����$::rateL-$::rateR\��Χ��" $fileId
			}
		} else {
			if {$GPNPort12Cnt01(cnt12) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊdelete��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt12)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊdelete��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt12)" $fileId
			}
			if {$GPNPort12Cnt02(cnt66) < $::rateL || $GPNPort12Cnt02(cnt66) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊdelete��NE1($::gpnIp1)$::GPNTestEth1\�������tag=800�ڲ�tag=100 tpid=0x8100����������\
					NE2($::gpnIp2)$::GPNTestEth2\�յ�tag=100��������������Ϊ$GPNPort12Cnt02(cnt66)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊdelete��NE1($::gpnIp1)$::GPNTestEth1\�������tag=800�ڲ�tag=100 tpid=0x8100����������\
					NE2($::gpnIp2)$::GPNTestEth2\�յ�tag=100��������������Ϊ$GPNPort12Cnt02(cnt66)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		
		if {$GPNPort12Cnt01(cnt1)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊdelete��NE1($::gpnIp1)$::GPNTestEth1\����untag����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊdelete��NE1($::gpnIp1)$::GPNTestEth1\����untag����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt1)" $fileId
		}
		if {$GPNPort12Cnt01(cnt2)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊdelete��NE1($::gpnIp1)$::GPNTestEth1\����tag=500 tpid=8100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt2)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊdelete��NE1($::gpnIp1)$::GPNTestEth1\����tag=500 tpid=8100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt2)" $fileId
		}
		if {$GPNPort12Cnt01(cnt14)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊdelete��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=9100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt14)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊdelete��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=9100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt14)" $fileId
		}
        } elseif {($RunFlag == 5) || ($RunFlag == 10)} {
		#����Ϊmodify
		if {$RunFlag == 5} {
			if {$GPNPort12Cnt02(cnt14) < $::rateL || $GPNPort12Cnt02(cnt14) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊmodify��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�tag=100��������������Ϊ$GPNPort12Cnt02(cnt14)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊmodify��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�tag=100��������������Ϊ$GPNPort12Cnt02(cnt14)����$::rateL-$::rateR\��Χ��" $fileId
			}
		} else {
			if {$GPNPort12Cnt01(cnt12) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊmodify��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt12)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊmodify��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt12)" $fileId
			}
			if {$GPNPort12Cnt02(cnt15) < $::rateL || $GPNPort12Cnt02(cnt15) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊmodify��NE1($::gpnIp1)$::GPNTestEth1\�������tag=800�ڲ�tag=100 tpid=0x8100����������\
					NE2($::gpnIp2)$::GPNTestEth2\�յ����tag=1000�ڲ�tag=100��������������Ϊ$GPNPort12Cnt02(cnt15)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊmodify��NE1($::gpnIp1)$::GPNTestEth1\�������tag=800�ڲ�tag=100 tpid=0x8100����������\
					NE2($::gpnIp2)$::GPNTestEth2\�յ����tag=1000�ڲ�tag=100��������������Ϊ$GPNPort12Cnt02(cnt15)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		if {$GPNPort12Cnt01(cnt1)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊmodify��NE1($::gpnIp1)$::GPNTestEth1\����untag����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊmodify��NE1($::gpnIp1)$::GPNTestEth1\����untag����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt1)" $fileId
		}
		if {$GPNPort12Cnt01(cnt2)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊmodify��NE1($::gpnIp1)$::GPNTestEth1\����tag=500 tpid=8100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt2)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊmodify��NE1($::gpnIp1)$::GPNTestEth1\����tag=500 tpid=8100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt2)" $fileId
		}
		if {$GPNPort12Cnt01(cnt14)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊmodify��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=9100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt14)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊmodify��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=9100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt14)" $fileId
		} 
        } elseif {($RunFlag == 6) || ($RunFlag == 11)} {
		if {$RunFlag == 6} {
			if {$GPNPort12Cnt02(cnt16) < $::rateL || $GPNPort12Cnt02(cnt16) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊadd��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ��ڲ�tag=800���tag=1000��������������Ϊ$GPNPort12Cnt02(cnt16)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊadd��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ��ڲ�tag=800���tag=1000��������������Ϊ$GPNPort12Cnt02(cnt16)����$::rateL-$::rateR\��Χ��" $fileId
			} 
		} else {
			if {$GPNPort12Cnt01(cnt12) != 0} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊadd��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt12)" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊadd��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=0x8100����������NE2($::gpnIp2)\
					$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt12)" $fileId
			}
			if {$GPNPort12Cnt02(cnt5) < $::rateL || $GPNPort12Cnt02(cnt5) > $::rateR} {
				set flag 1
				gwd::GWpublic_print "NOK" "$Action\����Ϊadd��NE1($::gpnIp1)$::GPNTestEth1\�������tag=800�ڲ�tag=100 tpid=0x8100����������\
					NE2($::gpnIp2)$::GPNTestEth2\�յ����tag=1000�ڲ�tag=800��������������Ϊ$GPNPort12Cnt02(cnt5)��û��$::rateL-$::rateR\��Χ��" $fileId
			} else {
				gwd::GWpublic_print "OK" "$Action\����Ϊadd��NE1($::gpnIp1)$::GPNTestEth1\�������tag=800�ڲ�tag=100 tpid=0x8100����������\
					NE2($::gpnIp2)$::GPNTestEth2\�յ����tag=1000�ڲ�tag=800��������������Ϊ$GPNPort12Cnt02(cnt5)����$::rateL-$::rateR\��Χ��" $fileId
			}
		}
		
	 	if {$GPNPort12Cnt01(cnt1)!=0} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$Action\����Ϊadd��NE1($::gpnIp1)$::GPNTestEth1\����untag����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt1)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊadd��NE1($::gpnIp1)$::GPNTestEth1\����untag����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt1)" $fileId
		}
		if {$GPNPort12Cnt01(cnt2)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊadd��NE1($::gpnIp1)$::GPNTestEth1\����tag=500 tpid=8100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt2)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊadd��NE1($::gpnIp1)$::GPNTestEth1\����tag=500 tpid=8100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt2)" $fileId
		}
		if {$GPNPort12Cnt01(cnt14)!=0} {
			set flag 1
			gwd::GWpublic_print "NOK" "$Action\����Ϊadd��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=9100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt14)" $fileId
		} else {
			gwd::GWpublic_print "OK" "$Action\����Ϊadd��NE1($::gpnIp1)$::GPNTestEth1\����tag=800 tpid=9100����������NE2($::gpnIp2)\
				$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort12Cnt01(cnt14)" $fileId
		}
        }
	return $flag
}
########################################################################################################
#�������ܣ�GPN�ϲ���etreeҵ���AC��PW�Ķ���
#�������:       ifAc ��VLAN�������� AC/PW =1 ac����    =0 pw����
#               �������� ��add/nochange/delete/modify
#               lStream �����͵�������
#����ֵ��flag =0 ҵ����֤��ȷ   =1ҵ����֤����
#���ߣ������ 
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
	#��������vlan����
	SendAndStat_ptn006 1 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
		$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt1 GPNPort2Cnt1 GPNPort3Cnt1 GPNPort4Cnt1 1 $::anaFliFrameCfg1 $caseId
	#����ֻƥ��smac�ı���
	SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
		$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt0 GPNPort2Cnt0 GPNPort3Cnt0 GPNPort4Cnt0 0 $::anaFliFrameCfg0 $caseId
	#����˫��vlan����
	SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
		$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt2 GPNPort2Cnt2 GPNPort3Cnt2 GPNPort4Cnt2 6 $::anaFliFrameCfg6 $caseId
	#����untag����
	SendAndStat_ptn006 0 $::hGPNPortGenList $::hGPNPortAnaList $::Portlist0 "$::hGPNPort1Cap $::hGPNPort1CapAnalyzer $gpnIp1 \
		$::hGPNPort2Cap $::hGPNPort2CapAnalyzer $gpnIp2 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer $gpnIp3 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer $gpnIp4" \
		$::hGPNPortAnaFrameCfgFilList GPNPort1Cnt7 GPNPort2Cnt7 GPNPort3Cnt7 GPNPort4Cnt7 7 $::anaFliFrameCfg7 $caseId
	
	
        gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
        gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
        #NE1�Ľ���
	if {($ifAc == 0) && [string match $action "add"]} {
		if {$GPNPort1Cnt2(cnt27) < $rateL || $GPNPort1Cnt2(cnt27) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE1($gpnIp1)$GPNTestEth1\
				�յ����tag=800�ڲ�tag=100��������������Ϊ$GPNPort1Cnt2(cnt27)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE1($gpnIp1)$GPNTestEth1\
				�յ����tag=800�ڲ�tag=100��������������Ϊ$GPNPort1Cnt2(cnt27)����$rateL-$rateR\��Χ��" $fileId
		}
	} else {
		if {$GPNPort1Cnt1(cnt70) < $rateL || $GPNPort1Cnt1(cnt70) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE1($gpnIp1)$GPNTestEth1\
				�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt70)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE1($gpnIp1)$GPNTestEth1\
				�յ�tag=100��������������Ϊ$GPNPort1Cnt1(cnt70)����$rateL-$rateR\��Χ��" $fileId
		}
	}
        
        #NE2����
        if {$GPNPort2Cnt0(cnt1) !=0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE2($gpnIp2)\
        		$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE2($gpnIp2)\
        		$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt1)" $fileId
        }
        if {$GPNPort2Cnt0(cnt14) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x9100)��δ֪������������NE2($gpnIp2)\
        		$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt14)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x9100)��δ֪������������NE2($gpnIp2)\
        		$GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt14)" $fileId
        }
	if {[string match $action "nochange"]} {
		if {$GPNPort2Cnt1(cnt69) < $rateL || $GPNPort2Cnt1(cnt69) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE2($gpnIp2)$GPNTestEth2\
				�յ�tag=100��������������Ϊ$GPNPort2Cnt1(cnt69)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE2($gpnIp2)$GPNTestEth2\
				�յ�tag=100��������������Ϊ$GPNPort2Cnt1(cnt69)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt1(cnt14) < $rateL || $GPNPort2Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x8100)��δ֪������NE2($gpnIp2)$GPNTestEth2\
				�յ�tag=100��������������Ϊ$GPNPort2Cnt1(cnt14)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x8100)��δ֪������NE2($gpnIp2)$GPNTestEth2\
				�յ�tag=100��������������Ϊ$GPNPort2Cnt1(cnt14)����$rateL-$rateR\��Χ��" $fileId
		}
	} else {
		if {$GPNPort2Cnt7(cnt48) < $rateL || $GPNPort2Cnt7(cnt48) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE2($gpnIp2)$GPNTestEth2\
				�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt48)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE2($gpnIp2)$GPNTestEth2\
				�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt48)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort2Cnt7(cnt18) < $rateL || $GPNPort2Cnt7(cnt18) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x8100)��δ֪������NE2($gpnIp2)$GPNTestEth2\
				�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt18)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x8100)��δ֪������NE2($gpnIp2)$GPNTestEth2\
				�յ�untag��������������Ϊ$GPNPort2Cnt7(cnt18)����$rateL-$rateR\��Χ��" $fileId
		}
	}
        
        #NE3�Ľ���
        if {$GPNPort3Cnt0(cnt1) !=0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE3($gpnIp3)\
        		$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE3($gpnIp3)\
        		$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
        }
        if {$GPNPort3Cnt0(cnt14) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
        		$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt14)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
        		$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt14)" $fileId
        }
        if {$GPNPort3Cnt0(cnt13) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE1($gpnIp1)$GPNTestEth1\���͵�������\
        		NE3($gpnIp3)$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt13)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE1($gpnIp1)$GPNTestEth1\���͵�������\
        		NE3($gpnIp3)$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt13)" $fileId
        }
        if {$GPNPort3Cnt0(cnt70) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE2($gpnIp2)$GPNTestEth2\���͵�������\
        		NE3($gpnIp3)$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt70)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE2($gpnIp2)$GPNTestEth2\���͵�������\
        		NE3($gpnIp3)$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt70)" $fileId
        }
	if { [string match $action "add"] || [string match $action "modify"]} {
		if {$GPNPort3Cnt1(cnt12) < $rateL || $GPNPort3Cnt1(cnt12) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x8100)��δ֪������NE3($gpnIp3)$GPNTestEth3\
				�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt12)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x8100)��δ֪������NE3($gpnIp3)$GPNTestEth3\
				�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt12)����$rateL-$rateR\��Χ��" $fileId
		}
	} else {
		if {$GPNPort3Cnt1(cnt14) < $rateL || $GPNPort3Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x8100)��δ֪������NE3($gpnIp3)$GPNTestEth3\
				�յ�tag=100��������������Ϊ$GPNPort3Cnt1(cnt14)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x8100)��δ֪������NE3($gpnIp3)$GPNTestEth3\
				�յ�tag=100��������������Ϊ$GPNPort3Cnt1(cnt14)����$rateL-$rateR\��Χ��" $fileId
		}
	}
        
        #NE4�Ľ���
        if {$GPNPort4Cnt0(cnt1) !=0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE4($gpnIp4)\
        		$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����untag��δ֪������������NE4($gpnIp4)\
        		$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
        }
        if {$GPNPort4Cnt0(cnt14) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
        		$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt14)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
        		$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt14)" $fileId
        }
        if {$GPNPort4Cnt0(cnt13) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE1($gpnIp1)$GPNTestEth1\���͵�������\
        		NE4($gpnIp4)$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt13)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE1($gpnIp1)$GPNTestEth1\���͵�������\
        		NE4($gpnIp4)$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt13)" $fileId
        }
        if {$GPNPort4Cnt0(cnt70) != 0} {
        	set flag 1
        	gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE2($gpnIp2)$GPNTestEth2\���͵�������\
        		NE4($gpnIp4)$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt70)" $fileId
        } else {
        	gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\��NE2($gpnIp2)$GPNTestEth2����tag=100����֪������NE2($gpnIp2)$GPNTestEth2\���͵�������\
        		NE4($gpnIp4)$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt70)" $fileId
        }
	if {($ifAc==1) && [string match $action "add"]} {
		if {$GPNPort4Cnt2(cnt1) < $rateL || $GPNPort4Cnt2(cnt1) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x8100)��δ֪������NE4($gpnIp4)$GPNTestEth3\
				�յ��ڲ�tag=100���tag=800��������������Ϊ$GPNPort4Cnt2(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x8100)��δ֪������NE4($gpnIp4)$GPNTestEth3\
				�յ��ڲ�tag=100���tag=800��������������Ϊ$GPNPort4Cnt2(cnt1)����$rateL-$rateR\��Χ��" $fileId
		}
	} else {
		if {$GPNPort4Cnt1(cnt14) < $rateL || $GPNPort4Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x8100)��δ֪������NE4($gpnIp4)$GPNTestEth3\
				�յ�tag=100��������������Ϊ$GPNPort4Cnt1(cnt14)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=100(tpid=0x8100)��δ֪������NE4($gpnIp4)$GPNTestEth3\
				�յ�tag=100��������������Ϊ$GPNPort4Cnt1(cnt14)����$rateL-$rateR\��Χ��" $fileId
		}
	}
        
	return $flag
}
########################################################################################################
#�������ܣ�GPN�ϲ���elanҵ����fdb������
#�������: printWord:��ӡ�������ַ���
#          lExpect1������vplsName���ѯ����ת������������
#          vplsName��vpls������
#          lExpect2������pwName���ѯ����ת������������
#          pwName��pw������
#          lExpect3������acName���ѯ����ת������������
#          acName��ac������
#	   attchPara��Ԥ������
#���������flag:mac��ַѧϰ�����־λ
#����ֵ��     flag��0���Խ����ȷ       1���Խ������
#���ߣ������
########################################################################################################
proc PTN_ElanAndFdb {printWord lExpect1 vplsName lExpect2 pwName lExpect3 acName attchPara} {
	set flag 0
	gwd::GWpubic_queryVPLSForwardTable $::telnet1 $::matchType1 $::Gpn_type1 $::fileId "" "" $vplsName dTable1
	gwd::GWpubic_queryVPLSForwardTable $::telnet1 $::matchType1 $::Gpn_type1 $::fileId "pw" $pwName $vplsName dTable2
	gwd::GWpubic_queryVPLSForwardTable $::telnet1 $::matchType1 $::Gpn_type1 $::fileId "ac" $acName $vplsName dTable3
	foreach dTable "\"$dTable1\" \"$dTable2\" \"$dTable3\"" lExpect "\"$lExpect1\" \"$lExpect2\" \"$lExpect3\"" printName "$vplsName $pwName $acName" \
		describe "����vpls������$vplsName\�鿴mac��ַת����  ����pw������$pwName\�鿴mac��ַת����   ����ac������$acName\�鿴mac��ַת����" {
        	dict for {mac value} $lExpect {
        		if {[dict exists $dTable $mac]} {
        			if {[string match -nocase [dict get $value portname] [dict get $dTable $mac portname]]} {
        				gwd::GWpublic_print "OK" "$printWord$describe\��NE1($::gpnIp1)��mac��ַ$mac\ѧϰ����[dict get $value portname]��" $::fileId
        			} else {
        				set flag 1
        				gwd::GWpublic_print "NOK" "$printWord$describe\��NE1($::gpnIp1)��mac��ַ$mac\ѧϰ����[dict get $dTable $mac portname]��" $::fileId
        			}
        		} else {
        			set flag 1
        			gwd::GWpublic_print "NOK" "$printWord$describe\��$printName��û��mac=$mac\��ת������" $::fileId
        		}
        	}
	}
	return $flag
}
########################################################################################################
#�������ܣ�GPN��trunk��ģʽ����
#�������: ModeFlag:�������� share lag1:1 Lacp
#	      portlist:trunk��Ա���б�
#         testPort1��DEV1���ɾ��up��down �˿�
#         testPort2��DEV2���ɾ��up��down �˿�
#	  trafficType:ҵ�����ͣ�=elan/etree
#�����������
#����ֵ��flag
#���ߣ������
########################################################################################################
proc PTN_TrunkMode {spawn_id matchType dutType fileId caseId id ModeFlag trunKName portlist testPort1 testPort2 trafficType} {
	set flag 0
	global capId
	global trunkSwTime
	###�õ�trunk���Ա�����˿ںʹӶ˿ڣ��˿ں�С�Ŀ������˿�------
	regexp {(\d+)/(\d+)} [lindex $portlist 0] match slot1 port1
	regexp {(\d+)/(\d+)} [lindex $portlist 1] match slot2 port2
	if {($slot1 < $slot2) || (($slot1 == $slot2) && ($port1 < $port2))} {
		set masterPort $slot1/$port1
		set standPort $slot2/$port2
	} else {
		set masterPort $slot2/$port2
		set standPort $slot1/$port1
	}
	##------�õ�trunk���Ա�����˿ںʹӶ˿ڣ��˿ں�С�Ŀ������˿�
	set TestTrafficFunc [expr {([string match -nocase "elan" $trafficType]) ? "PTN_TrunkStream_elan" : "PTN_TrunkStream_etree"}]
	incr capId
	if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱ"]} {
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
	#���Ӷ˿�down��up���Ե���ʱ��------
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
				set printWord "���˿�" 
			} else {
				set printWord "�Ӷ˿�"
			}
			if {$FrameRate31!=0} {
				set DhTime3 [expr ($DropFrame32-$DropFrame31)*1000/$FrameRate31]
				if {$DhTime3>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$eth\down��up�����󣬽��յ���ʱ��Ϊ$DhTime3\ms�������������ʱ��$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "��$i\��$matchType trunk��$trunKName$printWord$eth\down��up�����󣬽��յ���ʱ��Ϊ$DhTime3\msС�����������ʱ��$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$eth\down��up������ҵ��ͨ���޷����Խ��յ���ʱ��" $fileId
			}
			if {$FrameRate11!=0} {
				set DhTime1 [expr ($DropFrame12-$DropFrame11)*1000/$FrameRate11]
				if {$DhTime1>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$eth\down��up�����󣬷��͵���ʱ��Ϊ$DhTime1\ms�������������ʱ��$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "��$i\��$matchType trunk��$trunKName$printWord$eth\down��up�����󣬷��͵���ʱ��Ϊ$DhTime1\msС�����������ʱ��$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$eth\down��up������ҵ��ͨ���޷����Է��͵���ʱ��" $fileId
			}
		}
	}
	#------���Ӷ˿�down��up���Ե���ʱ��
	#shudown trunk������г�Ա������ҵ��------
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId\_$capId-p$::GPNTestEth5_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
	if {$aGPNPort5Cnt1(cnt19) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱshutdownTRUNK�����ж˿ڳ�ԱNE3($::gpnIp3)$::GPNTestEth3\
			����tag=800����������NE1($::gpnIp1)$::GPNTestEth5\�յ�tag=800��������������ӦΪ0ʵΪ$aGPNPort5Cnt1(cnt19)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱshutdownTRUNK�����ж˿ڳ�ԱNE3($::gpnIp3)$::GPNTestEth3\
			����tag=800����������NE1($::gpnIp1)::GPNTestEth5\�յ�tag=800��������������ӦΪ0ʵΪ$aGPNPort5Cnt1(cnt19)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt12) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱshutdownTRUNK�����ж˿ڳ�ԱNE1($::gpnIp1)$::GPNTestEth1\
			����tag=800����������NE3($::gpnIp3)$::GPNTestEth3\�յ�tag=800��������������ӦΪ0ʵΪ$aGPNPort3Cnt1(cnt12)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱshutdownTRUNK�����ж˿ڳ�ԱNE1($::gpnIp1)$::GPNTestEth1\
			����tag=800����������NE3($::gpnIp3)$::GPNTestEth3\�յ�tag=800��������������ӦΪ0ʵΪ$aGPNPort3Cnt1(cnt12)" $fileId
	}
	#------shudown trunk������г�Ա������ҵ��	
	foreach port1 "$eth1 $eth2" port2 "$eth2 $eth1" {
		gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $port1 "undo shutdown"
		gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $port2 "shutdown"
		after 5000
		incr capId
		if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱtrunk��˿�$port1 up $port2 down "]} {
			set flag 1
		}
	}
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth1 "undo shutdown"
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $eth2 "undo shutdown"
	after 5000
	#trunk�������ɾ��down�˿�------lag1:1��lag1+1�����ԣ�ӦΪ������ģʽtrunk���еĶ˿ڹ̶�Ϊ2����Ҳ���ܶ�Ҳ������
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
        	if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\�����һ��down�˿�$::downPort_dev1\��"]} {
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
        	if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ɾ��һ��down�˿�$::downPort_dev1\��"]} {
        		set flag 1
        	}
		if {[string match "L3" $::Worklevel]} {
			gwd::GWL2_AddPort $::telnet1 $::matchType1 $::Gpn_type1 $fileId $::downPort_dev1 "enable" "disable"
			gwd::GWL2_AddPort $::telnet2 $::matchType2 $::Gpn_type2 $fileId $::downPort_dev2 "enable" "disable"
		}
        	#------trunk�������ɾ��down�˿�
        	
        	#trunk�������ɾ��up�˿�------lag1:1��lag1+1�����ԣ�ӦΪ������ģʽtrunk���еĶ˿ڹ̶�Ϊ2����Ҳ���ܶ�Ҳ������
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
        	if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\�����һ��up�˿�$testPort1\��"]} {
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
        	if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ɾ��һ��up�˿�$testPort1\��"]} {
        		set flag 1
        	}
        	gwd::GWpublic_CfgPortState $::telnet1 $::matchType1 $::Gpn_type1 $fileId $testPort1 "shutdown"
		if {[string match "L3" $::Worklevel]} {
			gwd::GWL2_AddPort $::telnet1 $::matchType1 $::Gpn_type1 $fileId $testPort1 "enable" "disable"
			gwd::GWL2_AddPort $::telnet2 $::matchType2 $::Gpn_type2 $fileId $testPort2 "enable" "disable"
		}
        	#------trunk�������ɾ��up�˿�
	}
	if {![string match -nocase "elan" $trafficType]} {
        	#����reboot NNI�����ڰ忨----
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
        		if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk��$trunKName\ģʽΪ$ModeFlag����$j\������NE1($::gpnIp1)$::rebootSlot1 $::rebootSlot2\��λ�忨��"]} {
        			set flag 1
        		}
        	}
        	#----����reboot NNI�����ڰ忨
        	#����NMS��������------
        	for {set j 1} {$j<$::cntdh} {incr j} {
        		if {![gwd::GWCard_AddSwitch $spawn_id $matchType $dutType $fileId]} {
        			after $::rebootTime
        			set spawn_id [gwd::GWpublic_loginGpn $::gpnIp1 $::userName1 $::password1 $matchType $dutType $fileId]
        			set ::lSpawn_id [lreplace $::lSpawn_id 0 0 $spawn_id]
        			incr capId
        			if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\����$j\�� NE1($::gpnIp1)����NMS����������"]} {
        				set flag 1
        			}
        		} else {
        			gwd::GWpublic_print "OK" "$matchType\ֻ��һ�������̣���������" $fileId
        			break
        		}
        	}
        	#------����NMS��������
        	#����NMS��������------
        	for {set j 1} {$j<$::cntdh} {incr j} {
        		if {![gwd::GWCard_AddSwitchSw $spawn_id $matchType $dutType $fileId]} {
        			after $::rebootTime
        			set spawn_id [gwd::GWpublic_loginGpn $::gpnIp1 $::userName1 $::password1 $matchType $dutType $fileId]
        			set ::lSpawn_id [lreplace $::lSpawn_id 0 0 $spawn_id]
        			incr capId
        			if {[$TestTrafficFunc $fileId $caseId\_$capId "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\����$j\�� NE1($::gpnIp1)����SW����������"]} {
        				set flag 1
        			}
        		} else {
        			gwd::GWpublic_print "OK" "$matchType\ֻ��һ��SW�̣���������" $fileId
        			break
        		}
        	}
        	#------����NMS��������
        	set ::telnet1 $spawn_id
	}
	return $flag

}
########################################################################################################
#�������ܣ�ELAN��trunk��������ҵ��ת���Ĳ���
#�������: 
#         RunFlag:��ͬ���ͱ�־λ
#         hGPNPortAna1:�����Ķ˿�1
#         hGPNPortAna2:�����Ķ˿�2
#���������flag���������жϽ����־λ
#����ֵ�� ��
#���ߣ������/dj
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth5_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
	if {$GPNPort5Cnt1(cnt13) < $::rateL || $GPNPort5Cnt1(cnt13) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\����tag=800����������NE1($::gpnIp1)\
			$::GPNTestEth5\�յ�tag=800��������������Ϊ$GPNPort5Cnt1(cnt13)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\����tag=800����������NE1($::gpnIp1)\
			$::GPNTestEth5\�յ�tag=800��������������Ϊ$GPNPort5Cnt1(cnt13)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort5Cnt1(cnt19) < $::rateL || $GPNPort5Cnt1(cnt19) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE1($::gpnIp1)\
			$::GPNTestEth5\�յ�tag=800��������������Ϊ$GPNPort5Cnt1(cnt19)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE1($::gpnIp1)\
			$::GPNTestEth5\�յ�tag=800��������������Ϊ$GPNPort5Cnt1(cnt19)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt1(cnt12) < $::rateL || $GPNPort2Cnt1(cnt12) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\����tag=800����������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\����tag=800����������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt1(cnt19) < $::rateL || $GPNPort2Cnt1(cnt19) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt19)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt19)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt1(cnt12) < $::rateL || $GPNPort3Cnt1(cnt12) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\����tag=800����������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\����tag=800����������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt1(cnt13) < $::rateL || $GPNPort3Cnt1(cnt13) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\����tag=800����������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt13)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\����tag=800����������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt13)����$::rateL-$::rateR\��Χ��" $fileId
	}
	return $flag
}
########################################################################################################
#�������ܣ�ELAN��trunk��������ҵ��ת���Ĳ���
#�������: 
#         RunFlag:��ͬ���ͱ�־λ
#         hGPNPortAna1:�����Ķ˿�1
#         hGPNPortAna2:�����Ķ˿�2
#���������flag���������жϽ����־λ
#����ֵ�� ��
#���ߣ������/dj
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth5_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
	if {$GPNPort5Cnt1(cnt13) < $::rateL || $GPNPort5Cnt1(cnt13) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\����tag=800����������NE1($::gpnIp1)\
			$::GPNTestEth5\�յ�tag=800��������������Ϊ$GPNPort5Cnt1(cnt13)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\����tag=800����������NE1($::gpnIp1)\
			$::GPNTestEth5\�յ�tag=800��������������Ϊ$GPNPort5Cnt1(cnt13)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort5Cnt1(cnt19) < $::rateL || $GPNPort5Cnt1(cnt19) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE1($::gpnIp1)\
			$::GPNTestEth5\�յ�tag=800��������������Ϊ$GPNPort5Cnt1(cnt19)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE1($::gpnIp1)\
			$::GPNTestEth5\�յ�tag=800��������������Ϊ$GPNPort5Cnt1(cnt19)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt1(cnt12) < $::rateL || $GPNPort2Cnt1(cnt12) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\����tag=800����������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\����tag=800����������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort2Cnt0(cnt16)!= 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt16)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($::gpnIp3)$::GPNTestEth3\����tag=800����������NE2($::gpnIp2)\
			$::GPNTestEth2\�յ�������������ӦΪ0ʵΪ$GPNPort2Cnt0(cnt16)" $fileId
	}
	if {$GPNPort3Cnt1(cnt12) < $::rateL || $GPNPort3Cnt1(cnt12) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\����tag=800����������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt12)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)$::GPNTestEth5\����tag=800����������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt12)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt0(cnt13) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\����tag=800����������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt13)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE2($::gpnIp2)$::GPNTestEth2\����tag=800����������NE3($::gpnIp3)\
			$::GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt13)" $fileId
	}
	return $flag
}


########################################################################################################
#�������ܣ�GPN��trunk��ģʽ����������
#�������:runFlag:��ͬ���ͱ�־λ  =0 ���������һ��eLANҵ��=1�����һ��ELANҵ��
#  anaFliFrameCfg:����������
#              id:�������ж����
#���������flag1���������жϽ����־λ1
#          flag2���������жϽ����־λ2
#����ֵ�� ��
#���ߣ������
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp2\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	set addPrint ""
	if {$runFlag != 0} {
		set addPrint "�Ѵ���ELANҵ��"
	}
	if {$GPNPort2Cnt1(cnt2) < $rateL || $GPNPort2Cnt1(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord$addPrint\NE1($gpnIp1)$GPNTestEth1\����tag=800����֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord$addPrint\NE1($gpnIp1)$GPNTestEth1\����tag=800����֪������������NE2($gpnIp2)\
			$GPNTestEth2\�յ�tag=800��������������Ϊ$GPNPort2Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt1(cnt6) < $rateL || $GPNPort3Cnt1(cnt6) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord$addPrint\NE1($gpnIp1)$GPNTestEth1\����tag=800����֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt6)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord$addPrint\NE1($gpnIp1)$GPNTestEth1\����tag=800����֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=800��������������Ϊ$GPNPort3Cnt1(cnt6)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt1(cnt9) < $rateL1 || $GPNPort4Cnt1(cnt9) > $rateR1} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord$addPrint\NE1($gpnIp1)$GPNTestEth1\����tag=800����֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt9)��û��$rateL1-$rateR1\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord$addPrint\NE1($gpnIp1)$GPNTestEth1\����tag=800����֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=800��������������Ϊ$GPNPort4Cnt1(cnt9)����$rateL1-$rateR1\��Χ��" $fileId
	}
	if {$GPNPort1Cnt1(cnt22) < $rateL || $GPNPort1Cnt1(cnt22) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord$addPrint\NE2($gpnIp2)$GPNTestEth2\����tag=800����֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt22)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord$addPrint\NE2($gpnIp2)$GPNTestEth2\����tag=800����֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt22)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt1(cnt33) < $rateL || $GPNPort1Cnt1(cnt33) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord$addPrint\NE3($gpnIp3)$GPNTestEth3\����tag=800����֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt33)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord$addPrint\NE3($gpnIp3)$GPNTestEth3\����tag=800����֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt33)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt1(cnt44) < $rateL || $GPNPort1Cnt1(cnt44) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord$addPrint\NE4($gpnIp4)$GPNTestEth4\����tag=800����֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt44)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord$addPrint\NE4($gpnIp4)$GPNTestEth4\����tag=800����֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=800��������������Ϊ$GPNPort1Cnt1(cnt44)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$runFlag == 2} {
		if {$GPNPort2Cnt1(cnt11) < $rateL || $GPNPort2Cnt1(cnt11) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\�½�[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]ҵ��NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt11)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\�½�[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]ҵ��NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE2($gpnIp2)\
				$GPNTestEth2\�յ�tag=500��������������Ϊ$GPNPort2Cnt1(cnt11)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort3Cnt1(cnt12) < $rateL || $GPNPort3Cnt1(cnt12) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\�½�[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]ҵ��NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt12)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\�½�[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]ҵ��NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE3($gpnIp3)\
				$GPNTestEth3\�յ�tag=500��������������Ϊ$GPNPort3Cnt1(cnt12)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort4Cnt1(cnt13) < $rateL1 || $GPNPort4Cnt1(cnt13) > $rateR1} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\�½�[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]ҵ��NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�tag=500��������������Ϊ$GPNPort4Cnt1(cnt13)��û��$rateL1-$rateR1\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\�½�[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]ҵ��NE1($gpnIp1)$GPNTestEth1\����tag=500����֪������������NE4($gpnIp4)\
				$GPNTestEth4\�յ�tag=500��������������Ϊ$GPNPort4Cnt1(cnt13)����$rateL1-$rateR1\��Χ��" $fileId
		}
		if {$GPNPort1Cnt1(cnt14) < $rateL || $GPNPort1Cnt1(cnt14) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\�½�[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]ҵ��NE2($gpnIp2)$GPNTestEth2\����tag=500����֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt14)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\�½�[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]ҵ��NE2($gpnIp2)$GPNTestEth2\����tag=500����֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt14)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt1(cnt15) < $rateL || $GPNPort1Cnt1(cnt15) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\�½�[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]ҵ��NE3($gpnIp3)$GPNTestEth3\����tag=500����֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt15)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\�½�[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]ҵ��NE3($gpnIp3)$GPNTestEth3\����tag=500����֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt15)����$rateL-$rateR\��Χ��" $fileId
		}
		if {$GPNPort1Cnt1(cnt16) < $rateL || $GPNPort1Cnt1(cnt16) > $rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\�½�[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]ҵ��NE4($gpnIp4)$GPNTestEth4\����tag=500����֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt16)��û��$rateL-$rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\�½�[expr {([string match -nocase "ELAN" $printWord]) ? "ELAN" : "ETREE"}]ҵ��NE4($gpnIp4)$GPNTestEth4\����tag=500����֪������������NE1($gpnIp1)\
				$GPNTestEth1\�յ�tag=500��������������Ϊ$GPNPort1Cnt1(cnt16)����$rateL-$rateR\��Χ��" $fileId
		}
	}
	gwd::GWmanage_GetSystemResource $spawn_id $matchType $dutType $fileId "" resource2
	send_log "\n resource1:$resource1"
	send_log "\n resource2:$resource2"
	set cpu1 [dget $resource1 pCPU]
	set cpu2 [dget $resource2 pCPU]
	if {$cpu1 == "" || [string match $cpu1 null]} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\֮ǰϵͳCPU�����ʻ�ȡʧ�ܣ��޷�����cpu�����ʵı仯" $fileId
		
	} elseif {$cpu2 == "" || [string match $cpu2 null]} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\֮��ϵͳCPU�����ʻ�ȡʧ�ܣ��޷�����cpu�����ʵı仯" $fileId
	} else {
        	if {$cpu2 > [expr $cpu1 + $cpu1 * $::errRate]} {
        		set flag 1
        		gwd::GWpublic_print "NOK" "$printWord\֮ǰϵͳCPU������Ϊ$cpu1%��֮��CPU������Ϊ$cpu2%��CPU�����ʱ仯�����������$::errRate\��" $fileId
        	} else {
        		gwd::GWpublic_print "OK" "$printWord\֮ǰϵͳCPU������Ϊ$cpu1%��֮��CPU������Ϊ$cpu2%��CPU�����ʱ仯���������$::errRate\��" $fileId
        	}
	}
	gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	return $flag
}
########################################################################################################
#�������ܣ�ETree:һ��vsi����ac����
#�������:printWord:report�д�ӡ�Ĳ���˵��
#expStartVid2 expEndVid2 = 0ʱ��expStartVid1 expEndVid1��ֵ��expStartVid2 expEndVid2
#�����������
#����ֵ�� flag
########################################################################################################
proc PTN_PWACVPLSCnt {printWord expectList1 expectList2 caseId} {
	global fileId
	set flag 0
	set resultList1 ""
	set resultList2 ""
	###��ʼץ��
	if {$::cap_enable} {
		gwd::Start_CapAllData ::capArr $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
		gwd::Start_CapAllData ::capArr $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
	}
	gwd::Start_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort1Ana"
	after 10000
	gwd::Stop_SendFlow "$::hGPNPort3Gen"  "$::hGPNPort1Ana"
	gwd::Start_SendFlow "$::hGPNPort1Gen $::hGPNPort3Gen"  "$::hGPNPort1Ana $::hGPNPort3Ana"
	after 30000
	###ֹͣץ��
	if {$::cap_enable} {
        	gwd::Stop_CapData $::hGPNPort1Cap 1 "$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap"
        	gwd::Stop_CapData $::hGPNPort3Cap 1 "$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap"
	}
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($::gpnIp3\).pcap" $fileId
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
				gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)vlan$key\��smacӦΪ$value\ʵΪ[dict get $resultList1 $key]" $::fd_log
			} else {
				set flag_vid1 1
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)vlan$key\��smacӦΪ$value\ʵΪ[dict get $resultList1 $key]" $::fileId
			}
		} else {
			set flag_vid1 1
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE1($::gpnIp1)û���յ�vlan$key\��������" $::fileId
		}
		
	}
	if {$flag_vid1 == 0} {
		gwd::GWpublic_print "OK" "$printWord\NE1($::gpnIp1)����vlan�е����ݽ��ն���ȷ" $::fileId
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
				gwd::GWpublic_print "OK" "$printWord\NE3($::gpnIp3)vlan$key\��smacӦΪ$value\ʵΪ[dict get $resultList2 $key]" $::fd_log
			} else {
				set flag_vid2 1
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\NE3($::gpnIp3)vlan$key\��smacӦΪ$value\ʵΪ[dict get $resultList2 $key]" $::fileId
			}
		} else {
			set flag_vid2 1
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\NE3($::gpnIp3)û���յ�vlan$key\��������" $::fileId
		}
		
	}
	if {$flag_vid2 == 0} {
		gwd::GWpublic_print "OK" "$printWord\NE3($::gpnIp3)����vlan�е����ݽ��ն���ȷ" $::fileId
	}
	gwd::Stop_SendFlow "$::hGPNPort1Gen $::hGPNPort3Gen"  "$::hGPNPort1Ana $::hGPNPort3Ana"

	return $flag
 }

#########################################################################################################
#�������ܣ���¼�豸����
#���������comPort�����ں� eg:com1-COM1
#�����������
#����ֵ�� ��
#���ߣ������
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
#�������ܣ�����豸���ú󴮿ڵ�¼����
#���������case�����Խű����
#         Gpn_type���豸�ͺ�
#           telnet���豸telent id
#          comPort�����ں� eg:com1-COM1
#         portList���豸���õ��Ķ˿��б�
#            GpnIp���豸�ĵ�¼ip
#       managePort���豸�Ĺ����
#�����������
#����ֵ�� ��
#���ߣ������
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
#�������ܣ�EVP-TREEҵ���ǩ��������
#�������:RunFlag:��ͬ���ͱ�־λ
#         GPNPort��������˿�
#             dir��������
#���������      flag���������жϽ����־λ
#����ֵ�� ��
#���ߣ������
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth6_cap\($::gpnIp1\).pcap" $::fileId
        if {$RunFlag==1} {
                if {$aTmpGPNPort6Cnt1(cnt13) < $::rateL1 || $aTmpGPNPort6Cnt1(cnt13) > $::rateR1} {
                	set aTmpFlag 1
			gwd::GWpublic_print "NOK" "$printWord\��NE2($::gpnIp2)�Ͼ���NE2��NE1������NNI��$GPNPort\��ingree����mpls��ǩlspΪ21 pwΪ3000�����ݰ�\
				����Ϊ$aTmpGPNPort6Cnt1(cnt13)��û��$::rateL1-$::rateR1\��Χ��" $::fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\��NE2($::gpnIp2)�Ͼ���NE2��NE1������NNI��$GPNPort\��ingree����mpls��ǩlspΪ21 pwΪ3000�����ݰ�\
				����Ϊ$aTmpGPNPort6Cnt1(cnt13)����$::rateL1-$::rateR1\��Χ��" $::fileId
		}
        } elseif {$RunFlag==2} {
		if {$aTmpGPNPort6Cnt1(cnt14) < $::rateL1 || $aTmpGPNPort6Cnt1(cnt14) > $::rateR1} {
			set aTmpFlag 1
			gwd::GWpublic_print "NOK" "$printWord\��NE2($::gpnIp2)�Ͼ���NE2��NE3������NNI��$GPNPort\��egree����mpls��ǩlspΪ22 pwΪ3000�����ݰ�\
				����Ϊ$aTmpGPNPort6Cnt1(cnt14)��û��$::rateL1-$::rateR1\��Χ��" $::fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\��NE2($::gpnIp2)�Ͼ���NE2��NE3������NNI��$GPNPort\��egree����mpls��ǩlspΪ22 pwΪ3000�����ݰ�\
				����Ϊ$aTmpGPNPort6Cnt1(cnt14)����$::rateL1-$::rateR1\��Χ��" $::fileId
		}
        } elseif {$RunFlag==3} {
		if {$aTmpGPNPort6Cnt1(cnt11) < $::rateL1 || $aTmpGPNPort6Cnt1(cnt11) > $::rateR1} {
			set aTmpFlag 1
			gwd::GWpublic_print "NOK" "$printWord\��NE2($::gpnIp2)�Ͼ���NE2��NE1������NNI��$GPNPort\��egree����mpls��ǩlspΪ20 pwΪ3000�����ݰ�\
				����Ϊ$aTmpGPNPort6Cnt1(cnt11)��û��$::rateL1-$::rateR1\��Χ��" $::fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\��NE2($::gpnIp2)�Ͼ���NE2��NE1������NNI��$GPNPort\��egree����mpls��ǩlspΪ20 pwΪ3000�����ݰ�\
				����Ϊ$aTmpGPNPort6Cnt1(cnt11)����$::rateL1-$::rateR1\��Χ��" $::fileId
		}
        } elseif {$RunFlag==4} {
		if {$aTmpGPNPort6Cnt1(cnt15) < $::rateL1 || $aTmpGPNPort6Cnt1(cnt15) > $::rateR1} {
			set aTmpFlag 1
			gwd::GWpublic_print "NOK" "$printWord\��NE2($::gpnIp2)�Ͼ���NE2��NE3������NNI��$GPNPort\��ingree����mpls��ǩlspΪ23 pwΪ3000�����ݰ�\
				����Ϊ$aTmpGPNPort6Cnt1(cnt15)��û��$::rateL1-$::rateR1\��Χ��" $::fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\��NE2($::gpnIp2)�Ͼ���NE2��NE3������NNI��$GPNPort\��ingree����mpls��ǩlspΪ23 pwΪ3000�����ݰ�\
				����Ϊ$aTmpGPNPort6Cnt1(cnt15)����$::rateL1-$::rateR1\��Χ��" $::fileId
		}
        }
	gwd::GWpublic_DelPortMirror $::telnet2 $::matchType2 $::Gpn_type2 $::fileId $::GPNTestEth6
}
########################################################################################################
#�������ܣ�EVP-TREEҵ���ǩ������ҵ��ָ���������
#�������:RunFlag:��ͬ���ͱ�־λ
#���������      flag1�������������жϽ����־λ
#           flag2��ҵ���������жϽ����־λ
#����ֵ�� ��
#���ߣ������
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
#�������ܣ�ac pw lsp port ����ͳ�Ʋ���
#�������: lStream:Ҫ���͵�������
#         eth ��lspName ��pwName ��acName��Ҫͳ�ƵĶ˿ڡ�lsp��pw��ac
#         hGPNPortAna����eth������TC analyzer��handle
#         hGPNPortGen����eth������TC generator��handle
#����ֵ��flag =0 ����ͳ����ȷ    =1��ͳ�Ʋ���ȷ����
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
	gwd::GWpublic_print [expr {($LspFrameIn == $rxCnt) ? "OK" : "NOK"}] "$matchType\��$lspName\��inTotalPktsͳ�Ʒ���������ǰΪ$GPNLspStat1(-inTotalPkts)\
		������������Ϊ$GPNLspStat2(-inTotalPkts)����ֵӦΪ$rxCnt\ʵΪ$LspFrameIn" $fileId
	gwd::GWpublic_print [expr {($PwFrameIn == $rxCnt) ? "OK" : "NOK"}] "$matchType\��$pwName\��inTotalPktsͳ�Ʒ���������ǰΪ$GPNPwStat1(-inTotalPkts)\
		������������Ϊ$GPNPwStat2(-inTotalPkts)����ֵӦΪ$rxCnt\ʵΪ$PwFrameIn" $fileId
	gwd::GWpublic_print [expr {($AcFrameIn == $txCnt) ? "OK" : "NOK"}] "$matchType\��$acName\��inTotalPktsͳ�Ʒ���������ǰΪ$GPNAcStat1(-inTotalPkts)\
		������������Ϊ$GPNAcStat2(-inTotalPkts)����ֵӦΪ$txCnt\ʵΪ$AcFrameIn" $fileId
	gwd::GWpublic_print [expr {($PortFrameIn == $txCnt) ? "OK" : "NOK"}] "$matchType\��$eth\��inTotalPktsͳ�Ʒ���������ǰΪ$GPNPortStat1(-inTotalPkts)\
		������������Ϊ$GPNPortStat2(-inTotalPkts)����ֵӦΪ$txCnt\ʵΪ$PortFrameIn" $fileId
	
	gwd::GWpublic_print [expr {($LspFrameOut == $txCnt) ? "OK" : "NOK"}] "$matchType\��$lspName\��outTotalPktsͳ�Ʒ���������ǰΪ$GPNLspStat1(-outTotalPkts)\
		������������Ϊ$GPNLspStat2(-outTotalPkts)����ֵӦΪ$txCnt\ʵΪ$LspFrameOut" $fileId
	gwd::GWpublic_print [expr {($PwFrameOut == $txCnt) ? "OK" : "NOK"}] "$matchType\��$pwName\��outTotalPktsͳ�Ʒ���������ǰΪ$GPNPwStat1(-outTotalPkts)\
		������������Ϊ$GPNPwStat2(-outTotalPkts)����ֵӦΪ$txCnt\ʵΪ$PwFrameOut" $fileId
	gwd::GWpublic_print [expr {($AcFrameOut == $rxCnt) ? "OK" : "NOK"}] "$matchType\��$acName\��outTotalPktsͳ�Ʒ���������ǰΪ$GPNAcStat1(-outTotalPkts)\
		������������Ϊ$GPNAcStat2(-outTotalPkts)����ֵӦΪ$rxCnt\ʵΪ$AcFrameOut" $fileId
	gwd::GWpublic_print [expr {($PortFrameOut == $rxCnt) ? "OK" : "NOK"}] "$matchType\��$eth\��outTotalPktsͳ�Ʒ���������ǰΪ$GPNPortStat1(-outTotalPkts)\
		������������Ϊ$GPNPortStat2(-outUniPkts)����ֵӦΪ$rxCnt\ʵΪ$PortFrameOut" $fileId
	return $flag
}
########################################################################################################
#�������ܣ�ptnҵ��nni�����vlan��ip
#�������:      case:�����������
#       Worklevel:L2/L3��ģʽ
#       interface:L2/L3��ӿ�
#              ip:ip������
#         GPNPort:NNI�ӿ�
#       matchType:ƥ�������нڵ����ַ���
#        Gpn_type:�豸����
#          telnet:spwan_id��
#���������  ��
#����ֵ�� ��
#���ߣ������
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
#�������ܣ�ptnҵ��uni�����vlan
#�������:      case:�����������
#       Worklevel:L2/L3��ģʽ
#             vid:vlan id��
#      GPNTestEth:����ac�Ķ˿�
#       matchType:ƥ�������нڵ����ַ���
#        Gpn_type:�豸����
#          telnet:spwan_id��
#���������  ��
#����ֵ�� flagErr
#���ߣ������
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
#�������ܣ�ptnҵ��ɾ���ӽӿ�vlan
#�������:      case:�����������
#       Worklevel:L2/L3��ģʽ
#       interface:L2/L3��ӿ�
#       matchType:ƥ�������нڵ����ַ���
#        Gpn_type:�豸����
#          telnet:spwan_id��
#���������  ��
#����ֵ�� FlagErr
#���ߣ������
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
#�������ܣ�ptnҵ���ӽӿ�vlan��Ӿ�̬arp
#�������:      case:�����������
#       Worklevel:L2/L3��ģʽ
#       interface:L2/L3��ӿ�
#              ip:arp������
#              ip:mac������
#         GPNPort:NNI�ӿ�
#       matchType:ƥ�������нڵ����ַ���
#        Gpn_type:�豸����
#          telnet:spwan_id��
#���������  ��
#����ֵ�� FlagErr
#���ߣ������
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
#�������ܣ�ptn��������trunk
#�������:      case:�����������
#           tname:trunk����
#        portlist:trunk��Ա�˿�
#       Worklevel:L2/L3��ģʽ
#       matchType:ƥ�������нڵ����ַ���
#        Gpn_type:�豸����
#          telnet:spwan_id��
#���������  ��
#����ֵ�� FlagErr
#���ߣ������
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
#�������ܣ�ptn��������lacp trunk
#�������:      case:�����������
#           tname:trunk����
#        portlist:trunk��Ա�˿�
#       Worklevel:L2/L3��ģʽ
#       matchType:ƥ�������нڵ����ַ���
#        Gpn_type:�豸����
#          telnet:spwan_id��
#���������  ��
#����ֵ�� FlagErr
#���ߣ������
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
#�������ܣ�ptn��������trunk�ӽӿ�
#�������:      case:�����������
#       Worklevel:L2/L3��ģʽ
#       interface:trunk�ӽӿ�
#            type:trunk����
#        Gpn_type:�豸����
#          telnet:spwan_id��
#���������  ��
#����ֵ�� FlagErr
#���ߣ������
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
#�������ܣ�ptnɾ������trunk�ӽӿ�
#�������:      case:�����������
#       Worklevel:L2/L3��ģʽ
#       interface:trunk�ӽӿ�
#            type:trunk����
#          telnet:spwan_id��
#���������  ��
#����ֵ�� FlagErr
#���ߣ������
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
#�������ܣ�GPN������ĳ���ӽӿڵİ�arp��mac
#�������:  spawn_id:TELNET����
#       matchType:ƥ�������нڵ����ַ���
#	  dutType:�豸���͡�
#	   fileId:����������ļ���ʶ��
#           inter���ӽӿں�
#             arp����ARP��ַ
#             mac����MAC��ַ
#�����������
#����ֵ�� flagErr  =0����ӳɹ�       =1�����ʧ��            =2��ip��ַ��Ӵﵽ���ֵ���޷��������  =3�����ܰ󶨹㲥ip  =4���ܰ��鲥ip
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
        gwd::GWpublic_print NOK "��$matchType\�ӽӿ�$inter\�а�ip:$arp\�Ұ�mac:$mac��ʧ�ܡ�ϵͳ��ʾ��$expect_out(1,string)" $fileId
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
  gwd::GWpublic_print [expr {($flagErr == 0) ? "OK" : "NOK"}] "��$matchType\�ӽӿ�$inter\�а�ip:$arp\�Ұ�mac:$mac" $fileId
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
        			gwd::GWpublic_print NOK "$matchType\��vlan$vid����Ӷ˿ڣ�ʧ�ܡ������������" $fileId
                              	send -i $spawn_id "\r"
                      	}
                      	-re {untagged in another non-default VLAN} {
                          	set errorTmp 1
        			gwd::GWpublic_print NOK "$matchType\��vlan$vid����Ӷ˿ڣ�ʧ�ܡ��˿���untag��ʽ�����˷�default vlan" $fileId
                          	send -i $spawn_id "\r"
                      	}
                      	-re {Layer 2 forwarding has been disabled on this port} {
                          	set errorTmp 1
        			gwd::GWpublic_print NOK "$matchType\��vlan$vid����Ӷ˿ڣ�ʧ�ܡ��˿ڵĶ���ת������û��ʹ��" $fileId    
                      	}
                      	-re "$matchType\\(vlan.*\\)#" {
                          	send -i $spawn_id "\r"
        			gwd::GWpublic_print OK "$matchType\��vlan$vid����Ӷ˿ڣ��ɹ�" $fileId    
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
                            gwd::GWpublic_print NOK "$matchType\����vlan$vid\��ipΪ$ip��ʧ�ܡ������������" $fileId
                            send -i $spawn_id "exit\r"
                        }
                        -re {Connot set ip address} {
                            set errorTmp 1
                            gwd::GWpublic_print NOK "$matchType\����vlan$vid\��ipΪ$ip��ʧ�ܡ���֧��ip��ַ����" $fileId
                            send -i $spawn_id "exit\r"
                        }
                        -re "$matchType\\(vlan.*\\)#" {
                            gwd::GWpublic_print OK "$matchType\����vlan$vid\��ipΪ$ip���ɹ�" $fileId
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

#�������ܣ���ѯvpls����
#�������: fileId:���Ա�����ļ�id
#         tableList:ʵ�ʲ�ѯ����ת�����ֵ� ��ʽ��mac1 "name1" mac2 "name2"
#     expectTable:���������б� mac1 name1 mac2 name2 mac3 name3 mac4 name4
#     vplsname:vpls����
#     printWord:��ӡ�����˵���ַ���
#       spawn_id:spawn id
#�����������
#����ֵ�� tableList��vpls�����б�
proc TestVplsForwardEntry {fileId printWord dTable expectTable} {
	set flag 0
	foreach {mac name} $expectTable {
		if {[dict exists $dTable $mac]} {
			if {[string match -nocase $name [dict get $dTable $mac portname]]} {
				gwd::GWpublic_print "OK" "$printWord\mac��ַ$mac\ѧϰ����$name��" $fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\mac��ַ$mac\ѧϰ����[dict get $dTable $mac portname]��" $fileId
			}
		} else {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\û��mac=$mac\��ת������" $fileId
		}
	}
	return $flag
}

########################################################################################################
#�������ܣ����Թ��������ӵ�NE1--NE3��һ��ҵ�񣬲��Դ�ҵ��Ļ���
#���������
#	fileId�����Ա�����ļ���ʶ��
#	rateL rateR�����������жϱ�׼
#�����������
#����ֵ��flag
########################################################################################################
proc TestPWLoop {fileId rateL rateR} {
	set flag 0
	global capId
	global gpnIp1
	global gpnIp3
	global GPNTestEth1
	
	gwd::GWpublic_addPwLoop $::telnet3 $::matchType3 $::Gpn_type3 $fileId "pw321"
	#����GPNTestEth1��û���յ�NE3���ص�����------
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
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_014_1_$capId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
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
		gwd::GWpublic_print "NOK" "NE1($gpnIp1)$GPNTestEth1\����tag=60��δ֪������������NE3($gpnIp3)��pw��������\
			NE1 $GPNTestEth1\�յ�tag=60��������������Ϊ$GPNPort1Cnt1(cnt7)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($gpnIp1)$GPNTestEth1\����tag=60��δ֪������������NE3($gpnIp3)��pw��������\
			NE1 $GPNTestEth1\�յ�tag=60��������������Ϊ$GPNPort1Cnt1(cnt7)����$rateL-$rateR\��Χ��" $fileId
	}
	#------����GPNTestEth1��û���յ�NE3���ص�����
	#���Ի������ݵ�mac��ַ��û�б�����------
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
		gwd::GWpublic_print "NOK" "vplsΪetreeҵ��rawģʽ��NE3�������ݻ��أ���NE1���ͱ��ģ�����NE1 NNI�ĳ������ģ�macû�б�����" $fileId
	} else {
		gwd::GWpublic_print "OK" "vplsΪetreeҵ��rawģʽ��NE3�������ݻ��أ���NE1���ͱ��ģ�����NE1 NNI�ĳ������ģ�mac������" $fileId
	}
	if {$aGPNPort5Cnt1(cnt4) < $::rateL1 || $aGPNPort5Cnt1(cnt4) > $::rateR1} {
		set flag 1
		gwd::GWpublic_print "NOK" "vplsΪetreeҵ��rawģʽ��NE3�������ݻ��أ���NE1���ͱ��ģ�����NE1 NNI���뷽���ģ�macû�б�����" $fileId
	} else {
		gwd::GWpublic_print "OK" "vplsΪetreeҵ��rawģʽ��NE3�������ݻ��أ���NE1���ͱ��ģ�����NE1 NNI���뷽���ģ�mac������" $fileId
	}
	gwd::GWpublic_DelPortMirror $::telnet1 $::matchType1 $::Gpn_type1 $fileId $::GPNTestEth5
	#------���Ի������ݵ�mac��ַ��û�б�����
	return $flag
}
########################################################################################################
#�������ܣ�NE1��ACΪPORT+VALNģʽ    NE3��ACΪPORT+VLANģʽ    ������֤
#���������printWord����ӡ��˵���ַ���
#	caseId������ץ���ļ�ʱ�ļ�������ʹ�õĹؼ���
#	fileId�����Ա�����ļ���ʶ��
#	rateL rateR�����������жϱ�׼
#�����������
#����ֵ��flag
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
			
	#NE1��GPNTestEth1 AC1����untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100��������
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
			
	#NE3 ��GPNTestEth3����
	if {$GPNPort3Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
	}
	if {$GPNPort3Cnt1(cnt2) < $rateL || $GPNPort3Cnt1(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=50��������������Ϊ$GPNPort3Cnt1(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=50��������������Ϊ$GPNPort3Cnt1(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt3)" $fileId
	}
	if {$GPNPort3Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt4)" $fileId
	}
	#NE4 GPNTestEth4 �Ľ���
	if {$GPNPort4Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
	}
	if {$GPNPort4Cnt7(cnt2) < $rateL || $GPNPort4Cnt7(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt7(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt7(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt3)" $fileId
	}
	if {$GPNPort4Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt4)" $fileId
	}
	return $flag
}

########################################################################################################
#�������ܣ�NE1��ACΪPORTģʽ    NE3��ACΪPORTģʽ    ������֤
#���������printWord����ӡ��˵���ַ���
#	caseId������ץ���ļ�ʱ�ļ�������ʹ�õĹؼ���
#	fileId�����Ա�����ļ���ʶ��
#	rateL rateR�����������жϱ�׼
#�����������
#����ֵ��flag
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
			
	#NE1��GPNTestEth1 AC1����untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100��������
	
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
	
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	#NE3 ��GPNTestEth3����
	if {$GPNPort3Cnt7(cnt1) < $rateL || $GPNPort3Cnt7(cnt1) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�untag������������Ϊ$GPNPort3Cnt7(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�untag������������Ϊ$GPNPort3Cnt7(cnt1)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt4(cnt9) < $rateL || $GPNPort3Cnt4(cnt9) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=50��������������Ϊ$GPNPort3Cnt4(cnt9)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=50��������������Ϊ$GPNPort3Cnt4(cnt9)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt4(cnt1) < $rateL || $GPNPort3Cnt4(cnt1) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=50��������������Ϊ$GPNPort3Cnt4(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=50��������������Ϊ$GPNPort3Cnt4(cnt1)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt4(cnt2) < $rateL || $GPNPort3Cnt4(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=100��������������Ϊ$GPNPort3Cnt4(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=100��������������Ϊ$GPNPort3Cnt4(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	#NE4 GPNTestEth4 �Ľ���
	if {$GPNPort4Cnt7(cnt1) < $rateL || $GPNPort4Cnt7(cnt1) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag������������Ϊ$GPNPort4Cnt7(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag������������Ϊ$GPNPort4Cnt7(cnt1)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt4(cnt9) < $rateL || $GPNPort4Cnt4(cnt9) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=50��������������Ϊ$GPNPort4Cnt4(cnt9)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=50��������������Ϊ$GPNPort4Cnt4(cnt9)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt4(cnt1) < $rateL || $GPNPort4Cnt4(cnt1) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=50��������������Ϊ$GPNPort4Cnt4(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=50��������������Ϊ$GPNPort4Cnt4(cnt1)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt4(cnt2) < $rateL || $GPNPort4Cnt4(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=100��������������Ϊ$GPNPort4Cnt4(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=100��������������Ϊ$GPNPort4Cnt4(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	
	return $flag
} 

########################################################################################################
#�������ܣ�NE1��ACΪPORT+VLANģʽ    NE3��ACΪPORTģʽ    ������֤
#���������printWord����ӡ��˵���ַ���
#	caseId������ץ���ļ�ʱ�ļ�������ʹ�õĹؼ���
#	fileId�����Ա�����ļ���ʶ��
#	rateL rateR�����������жϱ�׼
#�����������
#����ֵ��flag
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
			
	#NE1��GPNTestEth1 AC1����untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100��������
	#NE4��GPNTestEth4 AC1����untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100��������
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
	
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	
	#NE1 ��GPNTestEth1����
	if {$GPNPort1Cnt1(cnt1) < $rateL || $GPNPort1Cnt1(cnt1) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=50��������������Ϊ$GPNPort1Cnt1(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�tag=50��������������Ϊ$GPNPort1Cnt1(cnt1)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt6(cnt1) < $rateL || $GPNPort1Cnt6(cnt1) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=50(tpid=0x8100)��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ��ڲ�tag=50���tag=50��������������Ϊ$GPNPort1Cnt6(cnt1)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=50(tpid=0x8100)��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ��ڲ�tag=50���tag=50��������������Ϊ$GPNPort1Cnt6(cnt1)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt4(cnt3) < $rateL || $GPNPort1Cnt4(cnt3) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=50(tpid=0x9100)��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ��ڲ�tag=50���tag=50��������������Ϊ$GPNPort1Cnt4(cnt3)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=50(tpid=0x9100)��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ��ڲ�tag=50���tag=50��������������Ϊ$GPNPort1Cnt4(cnt3)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt6(cnt7) < $rateL || $GPNPort1Cnt6(cnt7) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ��ڲ�tag=100���tag=50��������������Ϊ$GPNPort1Cnt6(cnt7)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE4($gpnIp4)$GPNTestEth4\����tag=100��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ��ڲ�tag=100���tag=50��������������Ϊ$GPNPort1Cnt6(cnt7)����$rateL-$rateR\��Χ��" $fileId
	}
	
	#NE3 ��GPNTestEth3����
	if {$GPNPort3Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
	}
	if {$GPNPort3Cnt7(cnt2) < $rateL || $GPNPort3Cnt7(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�untag��������������Ϊ$GPNPort3Cnt7(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�untag��������������Ϊ$GPNPort3Cnt7(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt3)" $fileId
	}
	if {$GPNPort3Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt4)" $fileId
	}
	#NE4 GPNTestEth4 �Ľ���
	if {$GPNPort4Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
	}
	if {$GPNPort4Cnt7(cnt2) < $rateL || $GPNPort4Cnt7(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt7(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt7(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt3)" $fileId
	}
	if {$GPNPort4Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt4)" $fileId
	}
	
	return $flag
}
########################################################################################################
#�������ܣ�raw ģʽNE1��ACΪPORT+V1ģʽ    NE3��ACΪPORT+V2ģʽ    ������֤
#���������printWord����ӡ��˵���ַ���
#	caseId������ץ���ļ�ʱ�ļ�������ʹ�õĹؼ���
#	fileId�����Ա�����ļ���ʶ��
#	rateL rateR�����������жϱ�׼
#�����������
#����ֵ��flag
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
			
	#NE1��GPNTestEth1 AC1����untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100��������
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
			
	#NE3 ��GPNTestEth3����
	if {$GPNPort3Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
	}
	if {$GPNPort3Cnt1(cnt8) < $rateL || $GPNPort3Cnt1(cnt8) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=80��������������Ϊ$GPNPort3Cnt1(cnt8)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=80��������������Ϊ$GPNPort3Cnt1(cnt8)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt3)" $fileId
	}
	if {$GPNPort3Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt4)" $fileId
	}
	#NE4 GPNTestEth4 �Ľ���
	if {$GPNPort4Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
	}
	if {$GPNPort4Cnt7(cnt2) < $rateL || $GPNPort4Cnt7(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt7(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt7(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt3)" $fileId
	}
	if {$GPNPort4Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt4)" $fileId
	}
	return $flag
}
########################################################################################################
#�������ܣ�tag ģʽNE1��ACΪPORT+V1ģʽ    NE3��ACΪPORT+V2ģʽ    ������֤
#���������printWord����ӡ��˵���ַ���
#	caseId������ץ���ļ�ʱ�ļ�������ʹ�õĹؼ���
#	fileId�����Ա�����ļ���ʶ��
#	rateL rateR�����������жϱ�׼
#�����������
#����ֵ��flag
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
			
	#NE1��GPNTestEth1 AC1����untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100��������
	#NE3��GPNTestEth3 AC1����untag tag=80(tpid=8100) tag=80(tpid=9100) tag=100��������
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
	
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
	
	#NE1 ��GPNTestEth1����
	if {$GPNPort1Cnt0(cnt7) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\��AC1����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt7)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\��AC1����untag��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt7)" $fileId
	}
	if {$GPNPort1Cnt6(cnt12) < $rateL || $GPNPort1Cnt6(cnt12) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\��AC1����tag=80(tpid=0x8100)��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ����tag=50�ڲ�tag=80��������������Ϊ$GPNPort1Cnt6(cnt12)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\��AC1����tag=80(tpid=0x8100)��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ����tag=50�ڲ�tag=80��������������Ϊ$GPNPort1Cnt6(cnt12)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort1Cnt0(cnt9) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\��AC1����tag=80(tpid=0x9100)��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt9)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\��AC1����tag=80(tpid=0x9100)��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt9)" $fileId
	}
	if {$GPNPort1Cnt0(cnt10) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE3($gpnIp3)$GPNTestEth3\��AC1����tag=100��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt10)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE3($gpnIp3)$GPNTestEth3\��AC1����tag=100��δ֪������������NE1($gpnIp1)\
			$GPNTestEth1\�յ�������������ӦΪ0ʵΪ$GPNPort1Cnt0(cnt10)" $fileId
	}
	
	#NE3 ��GPNTestEth3����
	if {$GPNPort3Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
	}
	if {$GPNPort3Cnt1(cnt13) < $rateL || $GPNPort3Cnt1(cnt13) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=80(tpid=0x9100)��������������Ϊ$GPNPort3Cnt1(cnt13)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�tag=80(tpid=0x9100)��������������Ϊ$GPNPort3Cnt1(cnt13)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort3Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt3)" $fileId
	}
	if {$GPNPort3Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt4)" $fileId
	}
	#NE4 GPNTestEth4 �Ľ���
	if {$GPNPort4Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
	}
	if {$GPNPort4Cnt7(cnt2) < $rateL || $GPNPort4Cnt7(cnt2) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt7(cnt2)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�untag��������������Ϊ$GPNPort4Cnt7(cnt2)����$rateL-$rateR\��Χ��" $fileId
	}
	if {$GPNPort4Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt3)" $fileId
	}
	if {$GPNPort4Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt4)" $fileId
	}
	return $flag
}
########################################################################################################
#�������ܣ�NE1��ACΪPORT+SVlan+Cvlanģʽ    NE3��ACΪPORT+SVlan+Cvlanģʽ    ������֤
#���������printWord����ӡ��˵���ַ���
#	caseId������ץ���ļ�ʱ�ļ�������ʹ�õĹؼ���
#	fileId�����Ա�����ļ���ʶ��
#	rateL rateR�����������жϱ�׼
#�����������
#����ֵ��flag
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
			
	#NE1��GPNTestEth1 AC1����untag tag=50(tpid=8100) tag=50(tpid=9100) tag=100  tag= 80+500��������
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth3_cap\($gpnIp3\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth4_cap\($gpnIp4\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth5_cap\($gpnIp1\).pcap" $fileId
			
	#NE3 ��GPNTestEth3����
	if {$GPNPort3Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt1)" $fileId
	}
	if {$GPNPort3Cnt0(cnt2) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt2)" $fileId
	}
	if {$GPNPort3Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt3)" $fileId
	}
	if {$GPNPort3Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ�������������ӦΪ0ʵΪ$GPNPort3Cnt0(cnt4)" $fileId
	}
	if {$GPNPort3Cnt6(cnt10) < $rateL || $GPNPort3Cnt6(cnt10) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1�������tag=80�ڲ�tag=500��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ����tag=80�ڲ�tag=500��������������Ϊ$GPNPort3Cnt6(cnt10)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1�������tag=80�ڲ�tag=500��δ֪������������NE3($gpnIp3)\
			$GPNTestEth3\�յ����tag=80�ڲ�tag=500��������������Ϊ$GPNPort3Cnt6(cnt10)����$rateL-$rateR\��Χ��" $fileId
	}
	#NE4 GPNTestEth4 �Ľ���
	if {$GPNPort4Cnt0(cnt1) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����untag��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt1)" $fileId
	}
	if {$GPNPort4Cnt0(cnt2) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x8100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt2)" $fileId
	}
	if {$GPNPort4Cnt0(cnt3) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt3)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=50(tpid=0x9100)��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt3)" $fileId
	}
	if {$GPNPort4Cnt0(cnt4) != 0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt4)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1����tag=100��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�������������ӦΪ0ʵΪ$GPNPort4Cnt0(cnt4)" $fileId
	}
	if {$GPNPort4Cnt1(cnt12) < $rateL || $GPNPort4Cnt1(cnt12) > $rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1�������tag=80�ڲ�tag=500��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=500��������������Ϊ$GPNPort4Cnt1(cnt12)��û��$rateL-$rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$printWord\NE1($gpnIp1)$GPNTestEth1\��AC1�������tag=80�ڲ�tag=500��δ֪������������NE4($gpnIp4)\
			$GPNTestEth4\�յ�tag=500��������������Ϊ$GPNPort4Cnt1(cnt12)����$rateL-$rateR\��Χ��" $fileId
	}
	return $flag
}

proc Check_Tracertroute {printWord expectTrace resultTrace} {
	set flag 0
	dict for {key value} $expectTrace {
		if {[dict exists $resultTrace $key]} {
			if {[dict get $value replier] == [dict get $resultTrace $key replier]} {
				gwd::GWpublic_print "OK" "$printWord\TTL=$key\��replierӦΪ[dict get $value replier]ʵ��Ϊ[dict get $resultTrace $key replier]" $::fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\TTL=$key\��replierӦΪ[dict get $value replier]ʵ��Ϊ[dict get $resultTrace $key replier]" $::fileId
			}
			if {[dict get $value traceTime] == [dict get $resultTrace $key traceTime]} {
				gwd::GWpublic_print "OK" "$printWord\TTL=$key\��traceTimeӦΪ[dict get $value traceTime]ʵ��Ϊ[dict get $resultTrace $key traceTime]" $::fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\TTL=$key\��traceTimeӦΪ[dict get $value traceTime]ʵ��Ϊ[dict get $resultTrace $key traceTime]" $::fileId
			}
			if {[dict get $value type] == [dict get $resultTrace $key type]} {
				gwd::GWpublic_print "OK" "$printWord\TTL=$key\��typeӦΪ[dict get $value type]ʵ��Ϊ[dict get $resultTrace $key type]" $::fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\TTL=$key\��typeӦΪ[dict get $value type]ʵ��Ϊ[dict get $resultTrace $key type]" $::fileId
			}
			if {[dict get $value downstream] == [dict get $resultTrace $key downstream]} {
				gwd::GWpublic_print "OK" "$printWord\TTL=$key\��downstreamӦΪ[dict get $value downstream]ʵ��Ϊ[dict get $resultTrace $key downstream]" $::fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\TTL=$key\��downstreamӦΪ[dict get $value downstream]ʵ��Ϊ[dict get $resultTrace $key downstream]" $::fileId
			}
			if {[dict get $value ret] == [dict get $resultTrace $key ret]} {
				gwd::GWpublic_print "OK" "$printWord\TTL=$key\��retӦΪ[dict get $value ret]ʵ��Ϊ[dict get $resultTrace $key ret]" $::fileId
			} else {
				set flag 1
				gwd::GWpublic_print "NOK" "$printWord\TTL=$key\��retӦΪ[dict get $value ret]ʵ��Ϊ[dict get $resultTrace $key ret]" $::fileId
			}
		} else {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\û��TTL=$key\�ı���" $::fileId
		}
		
	}
	return $flag
}



########################################################################################################
#�������ܣ�����������Ƚ�ϵͳ��Դǰ���ֵ�Ƿ����Ҫ��
#���������printWord����ӡ��˵���ַ���
#	fileId�����Ա�����ļ���ʶ��
#	printWord����ӡ��Ϣ��������"��$i������$matchType1\��NNI��UNI��"
#	oldResult ����������ǰ��ȡ��ϵͳ��Դֵ
#	newResult �������������ȡ��ϵͳ��Դֵ
#�����������
#����ֵ��flag =0������ֵ�ı仯����Ҫ��   =1�в���ֵ�ı仯������Ҫ��
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
			gwd::GWpublic_print "NOK" "$printWord\ǰ$key\��λcpu��������Ϊ[dget $value cpu]��$printWord\��cpu��������Ϊ[dget $newResult $key cpu]��cpu�����ʵı仯Ϊ$errRatio\%���ڿɽ��ܵ����ֵ$cpuErrRatio" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\ǰ$key\��λcpu��������Ϊ[dget $value cpu]��$printWord\��cpu��������Ϊ[dget $newResult $key cpu]��cpu�����ʵı仯Ϊ$errRatio\%С�ڵ��ڿɽ��ܵ����ֵ$cpuErrRatio" $fileId
		}
		set errRatio [expr abs ([dget $newResult $key sys] - [dget $value sys])]
		if {$errRatio > $sysErrRatio} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\ǰ$key\��λsys��������Ϊ[dget $value sys]��$printWord\��sys��������Ϊ[dget $newResult $key sys]��sys�����ʵı仯Ϊ$errRatio\%���ڿɽ��ܵ����ֵ$sysErrRatio" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\ǰ$key\��λsys��������Ϊ[dget $value sys]��$printWord\��sys��������Ϊ[dget $newResult $key sys]��sys�����ʵı仯Ϊ$errRatio\%С�ڵ��ڿɽ��ܵ����ֵ$sysErrRatio" $fileId
		}
		set errRatio [expr abs ([dget $newResult $key user] - [dget $value user])]
		if {$errRatio > $userErrRatio} {
			set flag 1
			gwd::GWpublic_print "NOK" "$printWord\ǰ$key\��λuser��������Ϊ[dget $value user]��$printWord\��user��������Ϊ[dget $newResult $key user]��user�����ʵı仯Ϊ$errRatio\%���ڿɽ��ܵ����ֵ$userErrRatio" $fileId
		} else {
			gwd::GWpublic_print "OK" "$printWord\ǰ$key\��λuser��������Ϊ[dget $value user]��$printWord\��user��������Ϊ[dget $newResult $key user]��user�����ʵı仯Ϊ$errRatio\%С�ڵ��ڿɽ��ܵ����ֵ$userErrRatio" $fileId
		}
	}
	return $flag
}
########################################################################################################
#�������ܣ�ELANҵ����������ͳ��ac��pw������ͬʱ��ҵ�������
#���������        flag�� 1��ʾ�ڷ�δ֪����   2��ʾ�ڷ���֪������Э�鱨��    
#                  hAna1�����˶˿ڷ�����handle
#                  hAna2���Զ˶˿ڷ�����handle
#����ֵ����
#���������                    
#������
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
				gwd::GWpublic_print OK "NE1($::gpnIp1)��NE2($::gpnIp2)����δ֪����1M���˿�$::GPNTestEth1\���յ�1*([expr $tmpCnt1])M�����˿�$::GPNTestEth2���յ�*([expr $tmpCnt2])M��,\ҵ���յ�ȫ��������" $::fileId
			} elseif {$errorTmp == 1} {
				gwd::GWpublic_print NOK "NE1($::gpnIp1)��NE2($::gpnIp2)����δ֪����1M���˿�û���յ�ȫ��������" $::fileId
			} elseif {$tmpCnt1 == 0 && $errorTmp == 0} {
				gwd::GWpublic_print OK "NE1($::gpnIp1)����δ֪����1M���˿�$::GPNTestEth2���յ�0.001*([expr $tmpCnt2])M��,\ҵ���յ�ȫ��������" $::fileId
			}

		} elseif {[string equal -nocase "2" $flag]} {
			if {$dropmax1 > 0 || $dropmax2 >0 || $errorTmp == 1} {
				set errorTmp 1
				gwd::GWpublic_print NOK "NE1($::gpnIp1)��NE2($::gpnIp2)������֪����600M��ҵ�񶪰�����鿴report��" $::fileId
			} else {
				gwd::GWpublic_print OK "NE1($::gpnIp1)��NE2($::gpnIp2)������֪����600M��ҵ�񲻶�����" $::fileId
			}
		} elseif {[string equal -nocase "3" $flag]} {
			if {$dropmax2 > 0 || $errorTmp == 1} {
				gwd::GWpublic_print NOK "NE1($::gpnIp1)��UNI�ڷ���0.001Mҵ��������Դmac�仯����ͬ�������ģ���ҵ��������" $::fileId
			} else {
				gwd::GWpublic_print OK "NE1($::gpnIp1)��UNI�ڷ���0.001Mҵ��������Դmac�仯����ͬ�������ģ���ҵ�񲻶�����" $::fileId
			}
		} elseif {[string equal -nocase "4" $flag]} {
			if {$dropmax1 == 0 && $dropmax2 == 0} {
				gwd::GWpublic_print OK "NE1($::gpnIp1)��NE2($::gpnIp2)������֪����600M���˿�$::GPNTestEth1\���յ�[expr $tmpCnt1]������600M�����˿�$::GPNTestEth2���յ�[expr $tmpCnt2]������600M��,\ҵ���յ�ȫ��������" $::fileId
			} elseif {$dropmax1 > 0 || $dropmax2 > 0 || $errorTmp == 1} {
				gwd::GWpublic_print NOK "NE1($::gpnIp1)��NE2($::gpnIp2)������֪����500M���˿�û���յ�ȫ��������" $::fileId

			}
		} 
		return $errorTmp 
	}
########################################################################################################
#�������ܣ�ͳ��ҵ�����Ķ������
#���������            
#                   hAna���˿ڷ�����handle
#					vid��vlan��id
#					smac��Դmac��ַ
#					DropCnt��ͳ�ƽ��
#					flag:1 ����δ֪���� 2 ������֪�����͸���Э�鱨��
#����ֵ����
#���������
#������
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
		     							 p3 {name �鲥 value "00:10:94:00:00:03"    
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
		    							  p23 {name �㲥 value "00:10:94:00:00:23"
										 }
									}
#		ͬ���������ͷ�����ͳ����ʱ2s  
		after 4000
		stc::perform ResultsClearAll -PortList $hGPNPortCap
		if {$::cap_enable} {
			gwd::Start_CapAllData ::capArr $hGPNPortCap $hGPNPortCapAnalyzer
		}
		if {$::cap_enable} {
			gwd::Stop_CapData $hGPNPortCap 1 "$caseId-p_cap\($returnType\).pcap"
		}
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p\($returnType\).pcap" $::fileId
		send_log "\n time1:[clock format [clock seconds] -format "%Y-%m-%d,%H:%M:%S"]"
		set totalPage [stc::get $infoObj -TotalPageCount]
		send_log "ҳ����$totalPage"
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
								gwd::GWpublic_print "NOK" "$sendType\������֪����600M��$returnType\�յ���֪����(vid:$tmpvid\,smac:$key)\��������Ϊ$value" $::fileId	
							}
						}
						# foreach item [dict keys $protocolresults] {
						# 	set valuemac [dict get $protocolresults $item value]
						# 	set valuename [dict get $protocolresults $item name]
						# 	if {$value > 0 [string match -nocase $valuemac $key]} {
						# 		set errorTmp 1
						# 		gwd::GWpublic_print NOK "NE1($::gpnIp1)����Э�鱨��$valuename��NE2($::gpnIp2)�յ����Ķ�����������Ϊ$value" $::fileId
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
								gwd::GWpublic_print "NOK" "$sendType\����δ֪������vid:$vid,smac:$smac��1M��$returnType\�յ�δ֪����(vid:$tmpvid\,smac:$key)\��������Ϊ$value" $::fileId	
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
								gwd::GWpublic_print "NOK" "NE1($::gpnIp1)\����ҵ������vid:1000,smac:$key����NE2($::gpnIp2)�յ�ҵ����(vid:1000\,smac:$key)\��������Ϊ$value" $::fileId	
							}
						}
						# foreach item [dict keys $protocolresults] {
						# 	set valuemac [dict get $protocolresults $item value]
						# 	set valuename [dict get $protocolresults $item name]
						# 	if {$value > 0 [string match -nocase $valuemac $key]} {
						# 		set errorTmp 1
						# 		gwd::GWpublic_print NOK "NE1($::gpnIp1)����Э�鱨��$valuename��NE2($::gpnIp2)�յ����Ķ�����������Ϊ$value" $::fileId
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
								gwd::GWpublic_print "NOK" "$sendType\������֪������vid:$vid,smac:$tmpsmac��1M��$returnType\�յ���֪����(vid:$vid\,smac:$key)\����" $::fileId	
							}
						}
						# foreach item [dict keys $protocolresults] {
						# 	set valuemac [dict get $protocolresults $item value]
						# 	set valuename [dict get $protocolresults $item name]
						# 	if {$value > 0 [string match -nocase $valuemac $key]} {
						# 		set errorTmp 1
						# 		gwd::GWpublic_print NOK "NE1($::gpnIp1)����Э�鱨��$valuename��NE2($::gpnIp2)�յ����Ķ�����������Ϊ$value" $::fileId
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
#�������ܣ��˿� ����ͳ�Ʋ���
#�������: lStream:Ҫ���͵�������
#         eth ��lspName ��pwName ��acName��Ҫͳ�ƵĶ˿�
#         hGPNPortAna����eth������TC analyzer��handle
#         hGPNPortGen����eth������TC generator��handle
#����ֵ��flag =0 ����ͳ����ȷ    =1��ͳ�Ʋ���ȷ����
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
	gwd::GWpublic_print [expr {($PortFrameOut == [expr $txCnt_port1*($::acPwCnt-1)]) ? "OK" : "NOK"}] "$matchType\��$eth\��outTotalPktsͳ�Ʒ���������ǰΪ$GPNPortStat1(-outTotalPkts)\
		������������Ϊ$GPNPortStat2(-outUniPkts)����ֵӦΪ[expr $txCnt_port1*($::acPwCnt-1)]\ʵΪ$PortFrameOut,NE1����$txCnt_port1\,NE2����$rxCnt_port2" $fileId
	return $flag
}

########################################################################################################
#�������ܣ�ͳ��ҵ�����Ķ������
#���������
#����ֵ����
#���������
#������
########################################################################################################
proc MPLS_ClassStatisticsPort {fileId hGPNPort1Ana hGPNPort1Gen hGPNPort2Ana hGPNPort2Gen caseId} {
	set errorTmp 0
	stc::perform ResultsClearAll -PortList $::lport1
	stc::perform ResultsClearViewCommand -ResultList "[stc::get $hGPNPort1Ana -children-AnalyzerPortResults] [stc::get $hGPNPort2Ana -children-AnalyzerPortResults] [stc::get $hGPNPort1Gen -children-GeneratorPortResults] [stc::get $hGPNPort2Gen -children-GeneratorPortResults]"
    set rxCnt_port1 [stc::get $hGPNPort1Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port1 [stc::get $hGPNPort1Gen.GeneratorPortResults -GeneratorSigFrameCount]
    set rxCnt_port2 [stc::get $hGPNPort2Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port2 [stc::get $hGPNPort2Gen.GeneratorPortResults -GeneratorSigFrameCount]
        send_log "\nNE1($::gpnIp1)������$txCnt_port1\,�յ�������Ϊ��$rxCnt_port1\n\NE2($::gpnIp2)������$txCnt_port2\,�յ�������Ϊ��$rxCnt_port2"

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
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth1_cap\($::gpnIp1\).pcap" $::fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId-p$::GPNTestEth2_cap\($::gpnIp2\).pcap" $::fileId
	gwd::Stop_SendFlow $::hGPNPortGenList  $::hGPNPortAnaList
	after 2000
    set rxCnt_port1 [stc::get $hGPNPort1Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port1 [stc::get $hGPNPort1Gen.GeneratorPortResults -GeneratorSigFrameCount]
    set rxCnt_port2 [stc::get $hGPNPort2Ana.AnalyzerPortResults -SigFrameCount]
    set txCnt_port2 [stc::get $hGPNPort2Gen.GeneratorPortResults -GeneratorSigFrameCount]
    send_log "\nNE1($::gpnIp1)������$txCnt_port1\,�յ�������Ϊ��$rxCnt_port1\n\NE2($::gpnIp2)������$txCnt_port2\,�յ�������Ϊ��$rxCnt_port2"
    if {$rxCnt_port2 == $txCnt_port1} {
    	gwd::GWpublic_print "OK" "NE1��NE2������֪����600M��NE1($::gpnIp1)������$txCnt_port1\,NE2($::gpnIp2)�հ���$rxCnt_port2\,ҵ�񲻶���" $fileId
    } else {
    	set errorTmp 1
    	gwd::GWpublic_print "NOK" "NE1��NE2������֪����600M��NE1($::gpnIp1)������$txCnt_port1\,NE2($::gpnIp2)�հ���$rxCnt_port2\,ҵ�񶪰�" $fileId
    }
    if {$rxCnt_port1 == $txCnt_port2} {
    	gwd::GWpublic_print "OK" "NE1��NE2������֪����600M��NE2($::gpnIp2)������$txCnt_port2\,NE1($::gpnIp1)�հ���$rxCnt_port1\,ҵ�񲻶���" $fileId
    } else {
    	set errorTmp 1
    	gwd::GWpublic_print "NOK" "NE1��NE2������֪����600M��NE2($::gpnIp2)������$txCnt_port2\,NE1($::gpnIp1)�հ���$rxCnt_port1\,ҵ�񶪰�" $fileId
    }
    return $errorTmp
}

########################################################################################################
#�������ܣ�ELANҵ����������ͳ��vsi������ͬʱ��ҵ�������
#���������        flag�� 1��ʾ�ڷ�δ֪����   2��ʾ�ڷ���֪������Э�鱨��    
#                  hAna1�����˶˿ڷ�����handle
#                  hAna2���Զ˶˿ڷ�����handle
#����ֵ����
#���������                    
#������
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
				gwd::GWpublic_print OK "NE1($::gpnIp1)����δ֪����$::loadcnt\M,NE2�˿�$::GPNTestEth2���յ�$::loadcnt\M��,NE3�˿�$::GPNTestEth3���յ�$::loadcnt\M��,NE4�˿�$::GPNTestEth4���յ�$::loadcnt\M��ҵ���յ�ȫ��������" $::fileId
			} elseif {$dropmax2 > 0 || $dropmax3 > 0 || $dropmax4 > 0 || $errorTmp == 1} {
				gwd::GWpublic_print NOK "NE1($::gpnIp1)����δ֪����$::loadcnt\M���˿�û���յ�ȫ������,���ڶ�����" $::fileId

			}

		}
		return $errorTmp 
	}


########################################################################################################
#�������ܣ�ͳ��ҵ�����Ķ�������ҳ��ڲ���
#���������
#����ֵ����
#���������
#������
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
    send_log "\nNE1($::gpnIp1)������$txCnt_port1\,�յ�������Ϊ��$rxCnt_port1\n\NE2($::gpnIp2)������$txCnt_port2\,�յ�������Ϊ��$rxCnt_port2\
    \n\NE3($::gpnIp3)������$txCnt_port3\,�յ�������Ϊ��$rxCnt_port3\n\NE4($::gpnIp4)������$txCnt_port4\,�յ�������Ϊ��$rxCnt_port4"
    if {[string equal -nocase "1" $flag]} {
    		if {$rxCnt_port1 == $txCnt_port2} {
    			gwd::GWpublic_print "OK" "NE1($::gpnIp1)������$txCnt_port1\,NE2($::gpnIp2)�հ���$rxCnt_port2\,ҵ�񲻶���" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj2 "1000" "00:00:00:00:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_2_FA10" $::matchType1 $::matchType2 $::hGPNPort2Cap $::hGPNPort2CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)������$txCnt_port1\,NE2($::gpnIp2)�հ���$rxCnt_port2\,ҵ�񶪰�" $fileId
    		}
    		if {$rxCnt_port2 == $txCnt_port1} {
    			gwd::GWpublic_print "OK" "NE2($::gpnIp2)������$txCnt_port2\,NE1($::gpnIp1)�հ���$rxCnt_port1\,ҵ�񲻶���" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj1 "1000" "00:00:00:01:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_2_FA10" $::matchType2 $::matchType1 $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)������$txCnt_port2\,NE1($::gpnIp1)�հ���$rxCnt_port1\,ҵ�񶪰�" $fileId
    		}
    	} elseif {[string equal -nocase "2" $flag]} {
    		if {$rxCnt_port1 == $txCnt_port2} {
    			gwd::GWpublic_print "OK" "NE1($::gpnIp1)������$txCnt_port1\,NE2($::gpnIp2)�հ���$rxCnt_port2\,ҵ�񲻶���" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj2 "1000" "00:00:00:00:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_3_FB10" $::matchType1 $::matchType2 $::hGPNPort2Cap $::hGPNPort2CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)������$txCnt_port1\,NE2($::gpnIp2)�հ���$rxCnt_port2\,ҵ�񶪰�" $fileId
    		}
    		if {$rxCnt_port2 == $txCnt_port1} {
    			gwd::GWpublic_print "OK" "NE2($::gpnIp2)������$txCnt_port2\,NE1($::gpnIp1)�հ���$rxCnt_port1\,ҵ�񲻶���" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj1 "1000" "00:00:00:01:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_3_FB10" $::matchType2 $::matchType1 $::hGPNPort1Cap $::hGPNPort1CapAnalyzer

    			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)������$txCnt_port2\,NE1($::gpnIp1)�հ���$rxCnt_port1\,ҵ�񶪰�" $fileId
    		}

    	} elseif {[string equal -nocase "3" $flag]} {
    		if {$rxCnt_port1 == $txCnt_port1} {
    			gwd::GWpublic_print "OK" "NE1($::gpnIp1)������$txCnt_port1\,NE1($::gpnIp1)�յ�����NE2��NE3��NE4���հ���$rxCnt_port1\,ҵ�񲻶���" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj1 "1000" "00:00:00:20:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_4_FC10" $::matchType2 $::matchType1 $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
    			MPLS_ClassStatisticsStream 2 $::infoObj1 "1000" "00:00:00:40:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_4_FC10" $::matchType3 $::matchType1 $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
    			MPLS_ClassStatisticsStream 2 $::infoObj1 "1000" "00:00:00:60:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_4_FC10" $::matchType4 $::matchType1 $::hGPNPort1Cap $::hGPNPort1CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE1($::gpnIp1)������$txCnt_port1\,NE1($::gpnIp1)�յ�����NE2��NE3��NE4���հ���$rxCnt_port1\,ҵ�񶪰�" $fileId
    		}
    		if {$rxCnt_port2 == $txCnt_port2} {
    			gwd::GWpublic_print "OK" "NE2($::gpnIp2)������$txCnt_port2\,NE2($::gpnIp2)�յ�����NE1���հ���$rxCnt_port2\,ҵ�񲻶���" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj2 "1000" "00:00:00:10:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_4_FC10" $::matchType1 $::matchType2 $::hGPNPort2Cap $::hGPNPort2CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE2($::gpnIp2)������$txCnt_port2\,NE2($::gpnIp2)�յ�����NE1���հ���$rxCnt_port2\,ҵ�񶪰�" $fileId
    		}
    		if {$rxCnt_port3 == $txCnt_port3} {
    			gwd::GWpublic_print "OK" "NE3($::gpnIp3)������$txCnt_port3\,NE3($::gpnIp3)�յ�����NE1���հ���$rxCnt_port3\,ҵ�񲻶���" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj3 "1000" "00:00:00:30:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_4_FC10" $::matchType1 $::matchType3 $::hGPNPort3Cap $::hGPNPort3CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE3($::gpnIp3)������$txCnt_port3\,NE3($::gpnIp3)�յ�����NE1���հ���$rxCnt_port3\,ҵ�񶪰�" $fileId
    		}
    		if {$rxCnt_port4 == $txCnt_port4} {
    			gwd::GWpublic_print "OK" "NE4($::gpnIp4)������$txCnt_port4\,NE4($::gpnIp4)�յ�����NE1���հ���$rxCnt_port4\,ҵ�񲻶���" $fileId
    		} else {
    			set errorTmp 1
    			MPLS_ClassStatisticsStream 2 $::infoObj4 "1000" "00:00:00:50:00:01" tmpvalue1 tmpCnt1 "GPN_PTN_009_4_FC10" $::matchType1 $::matchType4 $::hGPNPort4Cap $::hGPNPort4CapAnalyzer
    			gwd::GWpublic_print "NOK" "NE4($::gpnIp2)������$txCnt_port4\,NE4($::gpnIp4)�յ�����NE1���հ���$rxCnt_port4\,ҵ�񶪰�" $fileId
    		}
	
    	}
    
    return $errorTmp
}
########################################################################################################
#�������ܣ����ݷ�����������ͳ�Ƹ��������շ����
#���������statPara ==1 �����������vlanͳ���ֶ�                ==0 �������в����vlanͳ���ֶ�
#          hAna���˿ڷ�����handle
#���������aRecCnt��ͳ�ƽ��
#����ֵ��    ��
########################################################################################################
proc classificationStatisticsPortRxCnt10 {statPara hAna aRecCnt} { 
		set flag 0
        upvar $aRecCnt aTmpCnt
        array set aTmpCnt {cnt1 0 drop1 0 rate1 0 cnt2 0 drop2 0 rate2 0 cnt3 0 drop3 0 rate3 0 \
          cnt4 0 drop4 0 rate4 0 cnt5 0 drop5 0 rate5 0 cnt6 0 drop6 0 rate6 0 cnt7 0 drop7 0 rate7 0}
        #ͬ���������ͷ�����ͳ����ʱ2s  
        after 2000 
        ##��ȡ������ͳ�Ƶ���ֵ������ƥ��
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
#�������ܣ�GPN��trunk��ģʽ����
#�������:ModeFlag:ģʽ����
#	  slavePort:�Ӷ˿�
#	  masterPort:�˿�������˿�
#�����������
#����ֵ�� ��
#���ߣ������(�������޸�)
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
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap" $fileId
	if {$aGPNPort4Cnt1(cnt2) < $::rateL || $aGPNPort4Cnt1(cnt2) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱNE1($::gpnIp1)$::GPNTestEth3\����tag=50����������NE3($::gpnIp3)\
			$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱNE1($::gpnIp1)$::GPNTestEth3\����tag=50����������NE3($::gpnIp3)\
			$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
	}
	if {$aGPNPort3Cnt1(cnt6) < $::rateL || $aGPNPort3Cnt1(cnt6) > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱNE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������NE1($::gpnIp1)\
			$::GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱNE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������NE1($::gpnIp1)\
			$::GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)����$::rateL-$::rateR\��Χ��" $fileId
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
			set printWord "���˿�" 
			if {$FrameRate22 != 0} {
				set DhTime2 [expr ($DropFrame22-$DropFrame21)*1000/$FrameRate22]
				if {$DhTime2>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$masterPort\down������TC4�ڽ��յ���ʱ��Ϊ$DhTime2\ms�������������ʱ��$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "��$i\��$matchType trunk��$trunKName$printWord$masterPort\down������TC4�ڽ��յ���ʱ��Ϊ$DhTime2\msС�����������ʱ��$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$masterPort\down������TC4���ղ��������޷�����TC3���͵���ʱ��" $fileId
			}
			if {$FrameRate62 != 0} {
				set DhTime6 [expr ($DropFrame62-$DropFrame61)*1000/$FrameRate62]
				if {$DhTime6>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$masterPort\down������TC3�ڽ��յ���ʱ��Ϊ$DhTime6\ms�������������ʱ��$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "��$i\��$matchType trunk��$trunKName$printWord$masterPort\down������TC3�ڽ��յ���ʱ��Ϊ$DhTime6\msС�����������ʱ��$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$masterPort\down������TC3���ղ��������޷�����TC4���͵���ʱ��" $fileId
			}
			gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $masterPort "undo shutdown"
            after 60000 ;#�ȴ�����ʱ��
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
					gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$masterPort\up������TC4�ڽ��յ���ʱ��Ϊ$DhTime2\ms�������������ʱ��$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "��$i\��$matchType trunk��$trunKName$printWord$masterPort\up������TC4�ڽ��յ���ʱ��Ϊ$DhTime2\msС�����������ʱ��$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$masterPort\up������TC4�ڽ��ղ��������޷�����TC3���͵���ʱ��" $fileId
			}
			if {$FrameRate63 != 0} {
				set DhTime6 [expr ($DropFrame63-$DropFrame62)*1000/$FrameRate63]
				if {$DhTime6>$trunkSwTime} {
					set flag 1
					gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$masterPort\up������TC3�ڽ��յ���ʱ��Ϊ$DhTime6\ms�������������ʱ��$trunkSwTime\ms" $fileId
				} else {
					gwd::GWpublic_print "OK" "��$i\��$matchType trunk��$trunKName$printWord$masterPort\up������TC3�ڽ��յ���ʱ��Ϊ$DhTime6\msС�����������ʱ��$trunkSwTime\ms" $fileId
				}
			} else {
				gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$masterPort\up������TC3���ղ��������޷�����TC4����ʱ��" $fileId
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
		set printWord "�Ӷ˿�"
		if {$FrameRate22 != 0} {
				set DropFrame2 [expr $DropFrame22-$DropFrame21]
				if {$DropFrame2>0} {
					set flag 1
					gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$slavePort\down������TC4�ڽ��յ�����ҵ��������" $fileId
				} else {
					gwd::GWpublic_print "OK" "��$i\��$matchType trunk��$trunKName$printWord$slavePort\down������TC4�ڽ��յ�����ҵ�񲻶���" $fileId
				}
		} else {
			gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$slavePort\down������ҵ��ͨ��TC4���޷�����TC3�ڷ��͵���ʱ��" $fileId
		}
		if {$FrameRate62 != 0} {
				set DropFrame6 [expr $DropFrame62-$DropFrame61]
				if {$DropFrame6>0} {
					set flag 1
					gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$slavePort\down������TC3�ڽ��յ�����ҵ��������" $fileId
				} else {
					gwd::GWpublic_print "OK" "��$i\��$matchType trunk��$trunKName$printWord$slavePort\down������TC3�ڽ��յ�����ҵ�񲻶���" $fileId
				}
		} else {
			gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$slavePort\down������ҵ��ͨ��TC4���޷�����TC3�ڷ��͵���ʱ��" $fileId
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
					gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$slavePort\down������TC4�ڽ��յ�����ҵ��������" $fileId
				} else {
					gwd::GWpublic_print "OK" "��$i\��$matchType trunk��$trunKName$printWord$slavePort\down������TC4�ڽ��յ�����ҵ�񲻶���" $fileId
				}
		} else {
			gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$slavePort\down������ҵ��ͨ��TC4���޷�����TC3���͵���ʱ��" $fileId
		}
		if {$FrameRate63 != 0} {
				set DropFrame6 [expr $DropFrame63-$DropFrame62]
				if {$DropFrame6>0} {
					set flag 1
					gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$slavePort\down������TC3�ڽ��յ�����ҵ��������" $fileId
				} else {
					gwd::GWpublic_print "OK" "��$i\��$matchType trunk��$trunKName$printWord$slavePort\down������TC3�ڽ��յ�����ҵ�񲻶���" $fileId
				}
		} else {
			gwd::GWpublic_print "NOK" "��$i\��$matchType trunk��$trunKName$printWord$slavePort\down������ҵ��ͨ��TC4���޷�����TC3�ڷ��͵���ʱ��" $fileId
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
		gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱshutdownTRUNK�����ж˿ڳ�ԱNE1($::gpnIp1)$::GPNTestEth3\����tag=50����������\
			NE3($::gpnIp3)$::GPNTestEth4\�յ�tag=50��������������ӦΪ0��ʵΪ$aGPNPort4Cnt1(cnt2)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱshutdownTRUNK�����ж˿ڳ�ԱNE1($::gpnIp1)$::GPNTestEth3\����tag=50����������\
			NE3($::gpnIp3)$::GPNTestEth4\�յ�tag=50��������������ӦΪ0��ʵΪ$aGPNPort4Cnt1(cnt2)" $fileId
	}
	if {$aGPNPort3Cnt1(cnt6)!=0} {
		set flag 1
		gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱshutdownTRUNK�����ж˿ڳ�ԱNE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������\
			NE1($::gpnIp1)$::GPNTestEth3\�յ�tag=1000��������������ӦΪ0��ʵΪ$aGPNPort3Cnt1(cnt6)" $fileId
	} else {
		gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱshutdownTRUNK�����ж˿ڳ�ԱNE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������\
			NE1($::gpnIp1)$::GPNTestEth3\�յ�tag=1000��������������ӦΪ0��ʵΪ$aGPNPort3Cnt1(cnt6)" $fileId
	}

	foreach port1 "$masterPort $slavePort" port2 "$slavePort $masterPort" {
		gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $port1 "undo shutdown"
		gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $port2 "shutdown"
		after 60000 ;#�ȴ�����ʱ��
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
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId\_$capId-p$::GPNTestEth3_cap\($::gpnIp1).pcap" $fileId
		gwd::GWpublic_print "  " "ץ���ļ�Ϊ$caseId\_$capId-p$::GPNTestEth4_cap\($::gpnIp3).pcap" $fileId
		if {$aGPNPort4Cnt1(cnt2) < $::rateL || $aGPNPort4Cnt1(cnt2) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱtrunk��˿�$port1 up $port2 down NE1($::gpnIp1)$::GPNTestEth3\
				����tag=50����������NE3($::gpnIp3)$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱtrunk��˿�$port1 up $port2 down NE1($::gpnIp1)$::GPNTestEth3\
				����tag=50����������NE3($::gpnIp3)$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
		}
		if {$aGPNPort3Cnt1(cnt6) < $::rateL || $aGPNPort3Cnt1(cnt6) > $::rateR} {
			set flag 1
			gwd::GWpublic_print "NOK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱtrunk��˿�$port1 up $port2 down NE3($::gpnIp3)$::GPNTestEth4\
				����tag=1000����������NE1($::gpnIp1)$::GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)��û��$::rateL-$::rateR\��Χ��" $fileId
		} else {
			gwd::GWpublic_print "OK" "$matchType trunk��$trunKName\ģʽΪ$ModeFlag\ʱtrunk��˿�$port1 up $port2 down NE3($::gpnIp3)$::GPNTestEth4\
				����tag=1000����������NE1($::gpnIp1)$::GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)����$::rateL-$::rateR\��Χ��" $fileId
		}
	}
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $masterPort "undo shutdown"
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
	return $flag
}
########################################################################################################
#�������ܣ�ͳ�ƶ˿��ϵĶ���������
#�������:
#	  ana:������
#	  resultDrop:������
#	  resultRate:����
#�����������
#����ֵ�� ��
#���ߣ�������
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
#�������ܣ�GPN��trunk��ģʽ����sharingģʽ�Ĳ���
#�������:ModeFlag:ģʽ����
#	  slavePort:�Ӷ˿�
#	  masterPort:�˿�������˿�
#	  smacAdd:smac�Ƿ����� true ���� false ������
#�����������
#����ֵ�� ��
#���ߣ�������
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
	set rateCntflag 0 ;###�ж������Ƿ���һ���˿��ϵ�ָ��
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
		set smacStatus "����"
		if {$rateCntflag>1} {
			gwd::GWpublic_print "OK" "sharingʱNE1($::gpnIp1)���ʹ�vlan50,SMAC$smacStatus�������鿴ҵ������������˿���" $fileId
		} else {
			set flag 1 
			gwd::GWpublic_print "NOK" "sharingʱNE1($::gpnIp1)���ʹ�vlan50,SMAC$smacStatus������ҵ�������һ���˿���" $fileId
		}
	} else {
		set smacStatus "����"
		if {$rateCntflag>1} {
			set flag 1 
			gwd::GWpublic_print "NOK" "sharingʱNE1($::gpnIp1)���ʹ�vlan50,SMAC$smacStatus��һ������ҵ�񲻽���һ���˿��ϣ����˶�������" $fileId
		} else {
			gwd::GWpublic_print "OK" "sharingʱNE1($::gpnIp1)���ʹ�vlan50,SMAC$smacStatus��һ�������鿴ҵ����һ���˿���" $fileId
		}
	}
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $bearerPort "shutdown"
	after 5000
	Stat_dropAndRate $::hGPNPort3Ana tmp_Drop1 tmp_Rate1
    send_log "\ntmp_DropPort3:$tmp_Drop1"
    send_log "\ntmp_RatePort3:$tmp_Rate1"
	set printWord "���ض˿�" 
	if {$tmp_Rate1 != 0} {
		set DhTime2 [expr $tmp_Drop1*1000/$tmp_Rate1]
		if {$DhTime2>$trunkSwTime} {
			set flag 1
			gwd::GWpublic_print "NOK" "��SMAC$smacStatus��$matchType trunk��$trunKName$printWord$bearerPort\down������TC4�ڽ��յ���ʱ��Ϊ$DhTime2\ms�������������ʱ��$trunkSwTime\ms" $fileId
		} else {
			gwd::GWpublic_print "OK" "��SMAC$smacStatus��$matchType trunk��$trunKName$printWord$bearerPort\down������TC4�ڽ��յ���ʱ��Ϊ$DhTime2\msС�����������ʱ��$trunkSwTime\ms" $fileId
		}
	} else {
		gwd::GWpublic_print "NOK" "��SMAC$smacStatus��$matchType trunk��$trunKName$printWord$bearerPort\down������TC4���ղ��������޷�����TC3���͵���ʱ��" $fileId
	}
	gwd::GWpublic_CfgPortState $spawn_id $matchType $dutType $fileId $bearerPort "undo shutdown"
    after 60000 ;#�ȴ�����ʱ��
    after 2000
	Stat_dropAndRate $::hGPNPort3Ana tmp_Drop1 tmp_Rate1
    send_log "\ntmp_DropPort3:$tmp_Drop1"
    send_log "\ntmp_RatePort3:$tmp_Rate1"	
	if {$tmp_Rate1 != 0} {
		
		if {$tmp_Drop1 != 0} {
			set flag 1
			gwd::GWpublic_print "NOK" "��SMAC$smacStatus��$matchType trunk��$trunKName$printWord$bearerPort\up������TC4�ڽ��յ�����������" $fileId
		} else {
			gwd::GWpublic_print "OK" "��SMAC$smacStatus��$matchType trunk��$trunKName$printWord$bearerPort\up������TC4�ڽ��յ�������������" $fileId
		}
	} else {
		gwd::GWpublic_print "NOK" "��SMAC$smacStatus��$matchType trunk��$trunKName$printWord$bearerPort\up������TC4�ڽ��ղ��������޷�����TC3���͵�ҵ��" $fileId
	}
	
	set lport1 "$::hGPNPort1 $::hGPNPort2 $::hGPNPort3 $::hGPNPort4"
	stc::perform ResultsClearAll -PortList $lport1
	after 5000
	gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
	return $flag
}

########################################################################################################
#�������ܣ�GPN��trunk��ģʽ����sharingģʽ�Ĳ���
#�������:ModeFlag:ģʽ����
#	  slavePort:�Ӷ˿�
#	  masterPort:�˿�������˿�
#	  smacAdd:smac�Ƿ�����
#�����������
#����ֵ�� ��
#���ߣ�������
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
	
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_003_$capId-p$::GPNTestEth2_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_003_$capId-p$::GPNTestEth3_cap\($::gpnIp1\).pcap" $fileId
	gwd::GWpublic_print "  " "ץ���ļ�ΪGPN_PTN_003_$capId-p$::GPNTestEth4_cap\($::gpnIp3\).pcap" $fileId
	set GPNPort2AnaRate2 [stc::get $::hGPNPort2Ana.AnalyzerPortResults -L1BitRate]
    set GPNPort3AnaRate3 [stc::get $::hGPNPort3Ana.AnalyzerPortResults -L1BitRate]
    set GPNPort4AnaRate4 [stc::get $::hGPNPort4Ana.AnalyzerPortResults -L1BitRate]
	if {$GPNPort4AnaRate4 < $::rateL || $GPNPort4AnaRate4 > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "NE1($::gpnIp1)$::GPNTestEth3\����tag=50����������NE3($::gpnIp3)\
			$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE1($::gpnIp1)$::GPNTestEth3\����tag=50����������NE3($::gpnIp3)\
			$::GPNTestEth4\�յ�tag=50��������������Ϊ$aGPNPort4Cnt1(cnt2)����$::rateL-$::rateR\��Χ��" $fileId
	}
	set trunkRate [expr $GPNPort2AnaRate2 + $GPNPort3AnaRate3]
	if {$trunkRate < $::rateL || $trunkRate > $::rateR} {
		set flag 1
		gwd::GWpublic_print "NOK" "NE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������NE1($::gpnIp1)\
			$::GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)��û��$::rateL-$::rateR\��Χ��" $fileId
	} else {
		gwd::GWpublic_print "OK" "NE3($::gpnIp3)$::GPNTestEth4\����tag=1000����������NE1($::gpnIp1)\
			$::GPNTestEth3\�յ�tag=1000��������������Ϊ$aGPNPort3Cnt1(cnt6)����$::rateL-$::rateR\��Χ��" $fileId
	}
	gwd::Stop_SendFlow "$::hGPNPort3Gen $::hGPNPort4Gen"  "$::hGPNPort3Ana $::hGPNPort4Ana"
	return $flag
}

########################################################################################################
#�������ܣ�����trunk�����˿�
#          trunKName 	trunk�������
#          GPNPort      ��Ҫ����Ϊ���˿ڵĶ˿�
#���������aRecCnt��ͳ�ƽ��
#����ֵ��    ��
#������
########################################################################################################
proc GW_SetTrunkMaster {spawn_id matchType dutType fileId trunKName GPNPort} {
		send -i $spawn_id "\r"
		 #���ڵ�
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
	      gwd::GWpublic_print NOK "$dutType\������trunk$trunKName\���˿�Ϊ$GPNPort\��ʧ�ܡ������������" $fileId
	  }
	  -re "$matchType\\(trunk-$trunKName\\)#" {
	       send -i $spawn_id "exit\r" 
	      gwd::GWpublic_print OK "$dutType\������trunk$trunKName\���˿�Ϊ$GPNPort\���ɹ�" $fileId   
	  }
   }
  return $errorTmp 
}
########################################################################################################
#�������ܣ����ö˿ڵĶ��е���
#          GPNPort 	�˿ں�
#          queMode      ��������
#���������aRecCnt��ͳ�ƽ��
#����ֵ��    ��
#������
########################################################################################################
proc GW_SetEthQueueMode {spawn_id matchType dutType fileId GPNPort queMode} {
		send -i $spawn_id "\r"
		 #���ڵ�
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
	      GWpublic_print NOK "$dutType\������$GPNPort�˿�Ϊ$queMode\��ʧ�ܡ������������" $fileId
	  }
	  -re "$matchType\\(if-eth$GPNPort\\)#" {
	       send -i $spawn_id "exit\r" 
	      GWpublic_print OK "$dutType\������$GPNPort�˿�Ϊ$queMode\���ɹ�" $fileId   
	  }
   }
  return $errorTmp 
}

########################################################################################################
#�������ܣ�����pw��ac�Ķ��е���
#          GPNPort 	�˿ں�
#          queMode      ��������
#���������aRecCnt��ͳ�ƽ��
#����ֵ��    ��
#������
########################################################################################################
proc GW_SetPWQueueMode {spawn_id matchType dutType fileId pwName queMode} {
		send -i $spawn_id "\r"
		 #���ڵ�
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
	      GWpublic_print NOK "$dutType\������pw\ $pwName\ģʽΪ$queMode\��ʧ�ܡ������������" $fileId
	  }
	  -re "$matchType\\(config-pw-$pwName\\)#" {
	       send -i $spawn_id "exit\r" 
	      GWpublic_print OK "$dutType\������pw\ $pwName\ģʽΪ$queMode\���ɹ�" $fileId   
	  }
   }
  return $errorTmp 
}
########################################################################################################
#�������ܣ����ö˿�����
#          GPNPort 	�˿ں�
#          dir      ����
#		   rate 	���ʣ���λM��
#���������aRecCnt��ͳ�ƽ��
#����ֵ��    ��
#������
########################################################################################################
proc GW_SetPWQueueMode {spawn_id matchType dutType fileId GPNPort dir rate} {
		send -i $spawn_id "\r"
		 #���ڵ�
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
	      GWpublic_print NOK "$dutType\������pw\ $pwName\ģʽΪ$queMode\��ʧ�ܡ������������" $fileId
	  }
	  -re "$matchType\\(config-pw-$pwName\\)#" {
	       send -i $spawn_id "exit\r" 
	      GWpublic_print OK "$dutType\������pw\ $pwName\ģʽΪ$queMode\���ɹ�" $fileId   
	  }
   }
  return $errorTmp 
}