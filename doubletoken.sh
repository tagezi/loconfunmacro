#!/bin/bash

###################################################################
## You may distribute or modify it under the terms of either the ##
## GNU LESSER GENERAL PUBLIC LICENSE Version 3.0 or later,       ##
## or Mozilla Public License Version 2.0 or later.               ##
###################################################################

testLIST=( $(cat list.log)); 
i=2;
while [[ ${testLIST[$i]} != "" ]]
	do 
	grep -rho "\"${testLIST[$i]}\"" ../helpcontent2/source/text/scalc/
	
	(( i++))
	done |
	
sort | uniq -c | sort -r > list0.log

exit 0