#!/bin/bash

###################################################################
## You may distribute or modify it under the terms of either the ##
## GNU LESSER GENERAL PUBLIC LICENSE Version 3.0 or later,       ##
## or Mozilla Public License Version 2.0 or later.               ##
###################################################################

# extracted from scaddins/source/analysis
# extracted from scaddins/source/datefunc
# extracted from scaddins/source/pricing
# extracted from sc/source/ui/src

#EN:variables for file paths
resource="../translations/source/ru/formula/source/core/resource.po"
core_resource="../workdir/SrsPartTarget/formula/source/core/resource/core_resource.src"
scfuncs="../workdir/SrsPartMergeTarget/sc/source/ui/src/scfuncs.src"
helpcontent="../helpcontent2/source/text/scalc/01/"
helpcontent_ls=( $(ls "$helpcontent"))
datefunc="../translations/source/ru/scaddins/source/datefunc.po"
file_datefunc="../workdir/SrsPartMergeTarget/scaddins/source/datefunc/datefunc.src"
analysis="../translations/source/ru/scaddins/source/analysis.po"
file_analysis="../workdir/SrsPartMergeTarget/scaddins/source/analysis/analysis_funcnames.src"
file_danalisis="../workdir/SrsPartMergeTarget/scaddins/source/analysis/analysis.src"
pricing="../translations/source/ru/scaddins/source/pricing.po"
file_pricing="../workdir/SrsPartMergeTarget/scaddins/source/pricing/pricing.src"

#EN:Are there files for work?
if [ ! -f "$resource" ]; 	then echo "The file "$resource" do not exist."; 	exit 0; fi
if [ ! -f "$core_resource" ]; 	then echo "The file "$core_resource" do not exist."; 	exit 0; fi
if [ ! -f "$scfuncs" ]; 	then echo "The file "$scfuncs" do not exist."; 		exit 0; fi
if [ -z "$helpcontent_ls" ];	then echo "The file "$helpcontent" is empty" ; 		exit 0; fi

#EN:Create files for writing
> fun_list.csv
echo -e "{| class=\"wikitable sortable\" style=\"text-align:center; font-size:10pt\"
|+ Names, descriptions and KeyIDs of functions
! width="70" | Function Name \n! width="50" | Function IDKey \n! width="200" | Function Macros
! width="200" | Function Discription  \n! width="50" | Discription IDKey
! width="200" | Discription Macros \n! width="200" | Discription in Help \n|-" > fun_list.wiki

#EN: Declaring arrays for search of functions
declare -a sc_opcode_fun
declare -a date_funcname_fun
declare -a analysis_fun
declare -a pricing_fun

#EN:Make a selection of functions and codes from the formula/source/core/resource.po file 
sc_opcode_fun=( $(grep -rhA2 '\"SC_OPCODE' "$resource" | 
	sed -e '/\"string.text\"/d'  -e 's/msgid \"//' -e 's/\\n\"//' -e 's/\"//' -e '2~2d' |
	sed -e '/SC_OPCODE_ERROR_T/!s/SC_OPCODE_ERROR/#SC_OPCODE_ERROR/g' -e '/ *#/d' -e '/SC_OPCODE_TABLE_REF/d' |
	sed -e '/SC_OPCODE_NO_NAME/d' -e '1!G;h;$!d')) #переворачиваем сторки

i=0

while [[ ${sc_opcode_fun[$i]} != "" ]] 
	do
	#EN:Collect and record in the file in order: function_name, KeyID, Macro_name
	strQTZ=$(grep -rh "||${sc_opcode_fun[$i]/\./\\\.}\"" "$core_resource")
	strNAME="${sc_opcode_fun[$i]}"
	(( i++ ))

	#EN:Collect in the file in order:
	#EN:Description_function, Description_KeyID, Description_Macro, Description_from_Help
	strKEY=$(grep -A17 "${sc_opcode_fun[$i]}"'$' "$scfuncs" | sed 's/^[ \t]*//' | grep "qtz")
	strNMDG=$(grep -A17 "${sc_opcode_fun[$i]}"'$' "$scfuncs" | sed 's/^[ \t]*//;' | grep "U2S")
	strNMDG=$( echo $strNMDG | sed -e 's/...$//' )
	strDG=$( echo $strKEY | sed -e 's/..$//' )
	strHELP=$(grep -rhA4 "\"${strNMDG:5}\"" $helpcontent | 
		  sed -e :a -e 's/<[^>]*>//g;/</N;//ba;s/^[ \t]*//;' | sed '/Syntax/,$d' | tr -d '\n')
	
	#EN:Write CSV ans Wiki files
	echo "$strNAME|${strQTZ:17:5}|${sc_opcode_fun[$i]}|${strDG:22}|${strKEY:15:5}|${strNMDG:5}|$strHELP|" >> fun_list.csv
	echo -e "| $strNAME \n| ${strQTZ:17:5} \n| ${sc_opcode_fun[$i]} \n| ${strDG:22} \n| ${strKEY:15:5} \n| ${strNMDG:5} \n| $strHELP" >> fun_list.wiki
	echo "|-" >> fun_list.wiki
	(( i++ ))

	#EN:Skip function: NEG, GOALSEEK, MVALUE, MULTIRANGE, MULTIPLE.OPERATIONS
	if [[ ${sc_opcode_fun[$i]} == "NEG" 		|| ${sc_opcode_fun[$i]} == "MULTIPLE.OPERATIONS" ]] ||
	   [[ ${sc_opcode_fun[$i]} == "MULTIRANGE" 	|| ${sc_opcode_fun[$i]} == "GOALSEEK" ]] ||
	   [[ ${sc_opcode_fun[$i]} == "MVALUE" ]]
		then 
		i=$i+2
	fi

	done

#EN:Make a selection of functions and codes from the scaddins/source/datefunc.po file
date_funcname_fun=( $(grep -rhA2 '\"DATE_FUNCNAME' "$datefunc" | 
	sed -e '/\"string.text\"/d'  -e 's/msgid \"//' -e 's/\\n\"//' -e 's/\"//' -e '2~2d' |
	sed '1!G;h;$!d'))

i=0

while [[ ${date_funcname_fun[$i]} != "" ]] 
	do
	#EN:Collect and record in the file in order: function_name, KeyID, Macro_name
	sterNAME=${date_funcname_fun[$i]}
	strQTZ=$(grep -rh "||${date_funcname_fun[$i]}\"" "$file_datefunc")
	(( i++ ))
	strSEARCH="DATE_FUNCDESC_${date_funcname_fun[$i]:14}"

	#EN:Collect in the file in order: Description_function, Description_KeyID, Description_Macro,
	#EN:Description_from_Help (but, Description_from_Help have not eyt)
	file_tac=$(sed "1,/$strSEARCH/ d;/}.$/,$ d" "$file_datefunc" | sed 's/^[ \t]*//' | grep "qtz" )
	
	strKEY=${file_tac:15:5}
	strDG=$( echo "${file_tac:22}" | sed -e 's/..$//')
	strHELP=$(grep -rhA4 "\"$strSEARCH\"" $helpcontent | 
		  sed -e :a -e 's/<[^>]*>//g;/</N;//ba;s/^[ \t]*//;' | sed '/Syntax/,$d' | tr -d '\n')

	#EN:Write CSV ans Wiki files
	echo "$sterNAME|${strQTZ:20:5}|${date_funcname_fun[$i]}|${strDG}|${strKEY}|$strSEARCH|$strHELP|" >> fun_list.csv
	echo -e "| $sterNAME \n| ${strQTZ:20:5} \n| ${date_funcname_fun[$i]} \n| ${strDG} \n| ${strKEY} \n| $strSEARCH \n| $strHELP" >> fun_list.wiki
	echo "|-" >> fun_list.wiki
	(( i++ ))

	done

#EN:Make a selection of functions and codes from the scaddins/source/analysis.po file
analysis_fun=( $(grep -rhA2 '\"ANALYSIS_FUNCNAME' "$analysis" | 
	sed -e '/\"string.text\"/d'  -e 's/msgid \"//' -e 's/\\n\"//' -e 's/\"//' -e '2~2d' |
	sed '1!G;h;$!d'))

i=0

while [[ ${analysis_fun[$i]} != "" ]] 
	do
	#EN:Collect and record in the file in order: function_name, KeyID, Macro_name
	strNAME="${analysis_fun[$i]}"
	strQTZ=$(grep -rh "||${analysis_fun[$i]}\"" "$file_analysis")
	(( i++ ))
	strSEARCH="ANALYSIS_${analysis_fun[$i]:18}"

	#EN:Collect and record in the file in order: Description_function, Description_KeyID, Description_Macro,
	#EN:Description_from_Help (but, Description_from_Help have not eyt)
	file_tac=$(sed "1,/$strSEARCH/ d;/}.$/,$ d" "$file_danalisis" | sed 's/^[ \t]*//' | grep "qtz" )
	strKEY=${file_tac:15:5}
	strDG=$( echo "${file_tac:22}" | sed -e 's/..$//')
	strHELP=$(grep -rhA4 "\"$strSEARCH\"" $helpcontent |
		  sed -e :a -e 's/<[^>]*>//g;/</N;//ba;s/^[ \t]*//;' | sed '/Syntax/,$d' | tr -d '\n')

	echo "$strNAME|${strQTZ:20:5}|${analysis_fun[$i]}|${strDG}|${strKEY}|$strSEARCH|$strHELP|" >> fun_list.csv
	echo -e "| $strNAME \n| ${strQTZ:20:5} \n| ${analysis_fun[$i]} \n| ${strDG} \n| ${strKEY} \n| $strSEARCH \n| $strHELP" >> fun_list.wiki
	echo "|-" >> fun_list.wiki
	(( i++ ))

	done

#EN:Make a selection of functions and codes from the scaddins/source/analysis.po file
pricing_fun=( $(grep -rhA2 '\"PRICING_FUNCNAME' "$pricing" |
	sed -e '/\"string.text\"/d'  -e 's/msgid \"//' -e 's/\\n\"//' -e 's/\"//' -e '2~2d' |
	sed '1!G;h;$!d'))

i=0

while [[ ${pricing_fun[$i]} != "" ]] 
	do
	#EN:Collect and record in the file in order: function_name, KeyID, Macro_name
	strNAME=${pricing_fun[$i]}
	strQTZ=$(grep -rh "||${pricing_fun[$i]}\"" "$file_pricing")
	(( i++ ))
	strSEARCH="PRICING_FUNCDESC_${pricing_fun[$i]:17}"

	#EN:Collect and record in the file in order: Description_function, Description_KeyID, Description_Macro,
	#EN:Description_from_Help (but, Description_from_Help have not eyt)
	file_tac=$(sed "1,/$strSEARCH/ d;/}.$/,$ d" "$file_pricing" | sed 's/^[ \t]*//' | grep "qtz" )
	strKEY=${file_tac:15:5}
	strDG=$( echo "${file_tac:22}" | sed -e 's/..$//')
	strHELP=$(grep -rhA4 "\"$strSEARCH\"" $helpcontent |
		  sed -e :a -e 's/<[^>]*>//g;/</N;//ba;s/^[ \t]*//;' | sed '/Syntax/,$d' | tr -d '\n')

	#EN:Write CSV ans Wiki files
	echo "$strNAME|${strQTZ:20:5}|${pricing_fun[$i]}|${strDG}|${strKEY}|$strSEARCH|$strHELP|" >> fun_list.csv
	echo -e "| $strNAME \n| ${strQTZ:20:5} \n| ${pricing_fun[$i]} \n| ${strDG} \n| ${strKEY} \n| $strSEARCH \n| $strHELP" >> fun_list.wiki
	echo "|-" >> fun_list.wiki
	(( i++ ))

	done

echo "|}" >> fun_list.wiki

exit 0