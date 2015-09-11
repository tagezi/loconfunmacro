#!/bin/bash

# extracted from scaddins/source/analysis
# extracted from scaddins/source/datefunc
# extracted from scaddins/source/pricing
# extracted from sc/source/ui/src

#RU:Переменные для путей к файлам
resource="../translations/source/ru/formula/source/core/resource.po"
core_resource="../workdir/SrsPartTarget/formula/source/core/resource/core_resource.src"
scfuncs="../workdir/SrsPartTarget/sc/source/ui/src/scfuncs.src"
helpcontent="../helpcontent2/source/text/scalc/01/"
helpcontent_ls=( $(ls "$helpcontent"))
datefunc="../translations/source/ru/scaddins/source/datefunc.po"
file_datefunc="../workdir/SrsPartMergeTarget/scaddins/source/datefunc/datefunc.src"
analysis="../translations/source/ru/scaddins/source/analysis.po"
file_analysis="../workdir/SrsPartMergeTarget/scaddins/source/analysis/analysis_funcnames.src"
file_danalisis="../workdir/SrsPartMergeTarget/scaddins/source/analysis/analysis.src"
pricing="../translations/source/ru/scaddins/source/pricing.po"
file_pricing="../workdir/SrsPartMergeTarget/scaddins/source/pricing/pricing.src"


#RU:Есть ли файлы для работы?
#EN:Is files for work?
if [ ! -f "$resource" ]; 	then echo "The file "$resource" do not exist."; 	exit 0; fi
if [ ! -f "$core_resource" ]; 	then echo "The file "$core_resource" do not exist."; 	exit 0; fi
if [ ! -f "$scfuncs" ]; 	then echo "The file "$scfuncs" do not exist."; 		exit 0; fi
if [ -z "$helpcontent_ls" ];	then echo "The file "$helpcontent" is empty" ; 		exit 0; fi

#RU:Создаём файл куда будем писать
> fun_list.txt

#RU: Массив для поиска функций
declare -a sc_opcode_fun
declare -a date_funcname_fun
declare -a analysis_fun
declare -a pricing_fun

# #RU:Делаем выборку функций и из кодов из файла
sc_opcode_fun=( $(grep -rhA2 '\"SC_OPCODE' "$resource" | 
	sed -e '/\"string.text\"/d'  -e 's/msgid \"//' -e 's/\\n\"//' -e 's/\"//' -e '2~2d' |
	sed -e '/SC_OPCODE_ERROR_T/!s/SC_OPCODE_ERROR/#SC_OPCODE_ERROR/g' -e '/ *#/d' -e '/SC_OPCODE_TABLE_REF/d' |
	sed -e '/SC_OPCODE_NO_NAME/d' -e '1!G;h;$!d')) #переворачиваем сторки

i=0

#RU:Собираем и записываем в файл в порядке: Имя_Функции, KeyID, Имя_Макроса, Описание_из_описания, Имя_Макроса_описания,
#RU:Описание_из_Help, Имя_Макроса_описания_Help
while [[ ${sc_opcode_fun[$i]} != "" ]] 
	do
	#RU:Собираем и записываем в файл в порядке: Имя_Функции, KeyID, Имя_Макроса
	echo "${sc_opcode_fun[$i]}"
	echo "${sc_opcode_fun[$i]}" >> fun_list.txt
	stringQTZ=$(grep -rh "||${sc_opcode_fun[$i]/\./\\\.}\"" "$core_resource")
	echo "${stringQTZ:17:5}" >> fun_list.txt
	(( i++ ))
	echo "${sc_opcode_fun[$i]}" >> fun_list.txt

	stringSEARCH=${sc_opcode_fun[$i]:10}
	strTEST=$stringSEARCH
	
	#RU: Из-за того что кто-то не подумавши лепит названия макросам нужно проверять имена (обработал 50 исключений из 240)
	#EN: made 50 exclusions from 240
	if [[ ${sc_opcode_fun[$i]: -3} == "HYP" || ${sc_opcode_fun[$i]:10:3} == "ARC" ]]
		then
		stringTMP=${sc_opcode_fun[$i]:9}
		stringSEARCH="${stringTMP//_/}"
	elif [[ $strTEST == "CHISQ_INV_MS" 	|| $strTEST == "CHISQ_DIST_MS" 		|| $strTEST == "BETA_INV_MS" 	]] ||
	     [[ $strTEST == "BETA_DIST_MS" 	|| $strTEST == "LOG_INV_MS" 		|| $strTEST == "CHI_TEST_MS" 	]] || 
	     [[ $strTEST == "T_INV_MS" 		|| $strTEST == "GAMMA_INV_MS" 		|| $strTEST == "GAMMA_DIST_MS" 	]] || 
	     [[ $strTEST == "CHI_INV_MS" 	|| $strTEST == "NORM_INV_MS" 		|| $strTEST == "T_TEST_MS" 	]] || 
	     [[ $strTEST == "T_TEST_MS" 	|| $strTEST == "NEG_BINOM_DIST_MS" 	|| $strTEST == "T_DIST_MS" 	]] || 
	     [[ $strTEST == "LOG_NORM_DIST_MS" 	|| $strTEST == "NORM_DIST_MS" 		|| $strTEST == "GAMMA_LN_MS" 	]]
		then
		stringTMP=${strTEST//_/}
		stringSEARCH="${stringTMP//MS/_MS}"
		
	elif [[ $strTEST == "CHISQ_INV" 	|| $strTEST == "CHISQ_DIST" 	|| $strTEST == "GET_PIVOT_DATA" ]] ||
	     [[ $strTEST == "BETA_INV" 		|| $strTEST == "BETA_DIST" 	|| $strTEST == "LOG_INV" 	]] ||
	     [[ $strTEST == "CHI_TEST" 		|| $strTEST == "T_INV" 		|| $strTEST == "GAMMA_INV"  	]] ||
	     [[ $strTEST == "NORM_INV" 		|| $strTEST == "T_TEST" 	|| $strTEST == "NEG_BINOM_VERT" ]] ||
	     [[ $strTEST == "AVERAGE_IFS" 	|| $strTEST == "SUM_IFS" 	|| $strTEST == "AVERAGE_IF" 	]] ||
	     [[ $strTEST == "MIN_A" 		|| $strTEST == "GAMMA_LN" 	|| $strTEST == "FISHER_INV" 	]] ||
	     [[ $strTEST == "IF_ERROR" 		|| $strTEST == "GAMMA_LN" 	|| $strTEST == "FISHER_INV" 	]] ||
	     [[ $strTEST == "CHI_INV" 		|| $strTEST == "COUNT_IFS"  	|| $strTEST == "MAX_A" 		]] ||
	     [[ $strTEST == "IF_NA" ]]
		then
		stringSEARCH=${strTEST//_/}
	fi
	
	stringSEARCH="SC_HID_FUNC_$stringSEARCH"
	
	echo "$stringSEARCH"
	#RU:Собираем и записываем в файл в порядке: Описание_из_описания, KeyID_описания, Имя_Макроса_описания,
	#RU: Кручу верчу - запутать хочу. Бред сивой кобылы, но по другому не знаю как
	file_tac=$(sed "/$stringSEARCH/,$ d" "$scfuncs" | tac | sed -e "/String 1$/,$ d" -e 's/^[\t]*//' -e 's/[{}]//' -e 's/[;]$//' | tac )
	file_tac=$(echo $file_tac | grep -ho 'qtz.*String 2')

 	stringKEY=${file_tac:9:5} 					#RU:Обрезаем всё лишнее с ключа
 	stringDG=$( echo "${file_tac:16}" | sed -e 's/..........$//')	#RU:Обрезаем начало строки для описания
	stringNMDG=$( grep -ho "${stringSEARCH}\"" "$scfuncs")		#RU:Находим имя макроса
	#strHELP=$(grep -rhA4 "\"${stringSEARCH:3}\"" $helpcontent | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed 's/^[ \t]*//;' | sed '/Syntax/,$d')
	
	#RU:Пишем в файлик
	echo "${stringDG}" >> fun_list.txt
	echo "${stringKEY}" >> fun_list.txt
	echo "${stringNMDG/\"/}" >> fun_list.txt
	#echo "$strHELP" >> fun_list.txt
	echo "" >> fun_list.txt
	(( i++ ))

	done

date_funcname_fun=( $(grep -rhA2 '\"DATE_FUNCNAME' "$datefunc" | 
	sed -e '/\"string.text\"/d'  -e 's/msgid \"//' -e 's/\\n\"//' -e 's/\"//' -e '2~2d' |
	sed '1!G;h;$!d')) #переворачиваем сторки

i=0

while [[ ${date_funcname_fun[$i]} != "" ]] 
	do
	#RU:Собираем и записываем в файл в порядке: Имя_Функции, KeyID, Имя_Макроса
	echo "${date_funcname_fun[$i]}"
	echo "${date_funcname_fun[$i]}" >> fun_list.txt
	stringQTZ=$(grep -rh "||${date_funcname_fun[$i]}\"" "$file_datefunc")
	echo "${stringQTZ:20:5}" >> fun_list.txt
	(( i++ ))
	echo "${date_funcname_fun[$i]}" >> fun_list.txt

	stringSEARCH="DATE_FUNCDESC_${date_funcname_fun[$i]:14}"
	
	#RU:Собираем и записываем в файл в порядке: Описание_из_описания, KeyID_описания, Имя_Макроса_описания,
	file_tac=$(sed "1,/$stringSEARCH/ d;/}.$/,$ d" "$file_datefunc" | sed 's/^[ \t]*//' | grep "qtz" )
	
	stringKEY=${file_tac:15:5} 				#RU:Обрезаем всё лишнее с ключа
	stringDG=$( echo "${file_tac:22}" | sed -e 's/..$//')	#RU:Обрезаем начало строки для описания

	#strHELP=$(grep -rhA4 "\"${stringSEARCH:3}\"" $helpcontent | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed 's/^[ \t]*//;' | sed '/Syntax/,$d')
	
	#RU:Пишем в файлик
	echo "${stringDG}" >> fun_list.txt
	echo "${stringKEY}" >> fun_list.txt
	echo "$stringSEARCH" >> fun_list.txt
	#echo "$strHELP" >> fun_list.txt
	echo "" >> fun_list.txt
	(( i++ ))

	done

analysis_fun=( $(grep -rhA2 '\"ANALYSIS_FUNCNAME' "$analysis" | 
	sed -e '/\"string.text\"/d'  -e 's/msgid \"//' -e 's/\\n\"//' -e 's/\"//' -e '2~2d' |
	sed '1!G;h;$!d')) #переворачиваем сторки

i=0

while [[ ${analysis_fun[$i]} != "" ]] 
	do
	#RU:Собираем и записываем в файл в порядке: Имя_Функции, KeyID, Имя_Макроса
	echo "${analysis_fun[$i]}" >> fun_list.txt
	stringQTZ=$(grep -rh "||${analysis_fun[$i]}\"" "$file_analysis")
	echo "${stringQTZ:20:5}" >> fun_list.txt
	(( i++ ))
	echo "${analysis_fun[$i]}" >> fun_list.txt

	stringSEARCH="ANALYSIS_${analysis_fun[$i]:18}"

	#RU:Собираем и записываем в файл в порядке: Описание_из_описания, KeyID_описания, Имя_Макроса_описания,
	file_tac=$(sed "1,/$stringSEARCH/ d;/}.$/,$ d" "$file_danalisis" | sed 's/^[ \t]*//' | grep "qtz" )

	stringKEY=${file_tac:15:5} 				#RU:Обрезаем всё лишнее с ключа
	stringDG=$( echo "${file_tac:22}" | sed -e 's/..$//')	#RU:Обрезаем начало строки для описания

	#strHELP=$(grep -rhA4 "\"${stringSEARCH:3}\"" $helpcontent | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed 's/^[ \t]*//;' | sed '/Syntax/,$d')
	
	#RU:Пишем в файлик
	echo "${stringDG}" >> fun_list.txt
	echo "${stringKEY}" >> fun_list.txt
	echo "$stringSEARCH" >> fun_list.txt
	#echo "$strHELP" >> fun_list.txt
	echo "" >> fun_list.txt
	(( i++ ))

	done

pricing_fun=( $(grep -rhA2 '\"PRICING_FUNCNAME' "$pricing" |
	sed -e '/\"string.text\"/d'  -e 's/msgid \"//' -e 's/\\n\"//' -e 's/\"//' -e '2~2d' |
	sed '1!G;h;$!d')) #переворачиваем сторки

i=0

while [[ ${pricing_fun[$i]} != "" ]] 
	do
	#RU:Собираем и записываем в файл в порядке: Имя_Функции, KeyID, Имя_Макроса
	echo "${pricing_fun[$i]}" >> fun_list.txt
	stringQTZ=$(grep -rh "||${pricing_fun[$i]}\"" "$file_pricing")
	echo "${stringQTZ:20:5}" >> fun_list.txt
	(( i++ ))
	echo "${pricing_fun[$i]}" >> fun_list.txt

	stringSEARCH="PRICING_FUNCDESC_${pricing_fun[$i]:17}"

	#RU:Собираем и записываем в файл в порядке: Описание_из_описания, KeyID_описания, Имя_Макроса_описания,
	file_tac=$(sed "1,/$stringSEARCH/ d;/}.$/,$ d" "$file_pricing" | sed 's/^[ \t]*//' | grep "qtz" )
	
	stringKEY=${file_tac:15:5} 					#RU:Обрезаем всё лишнее с ключа
	stringDG=$( echo "${file_tac:22}" | sed -e 's/..$//')	#RU:Обрезаем начало строки для описания
	#strHELP=$(grep -rhA4 "\"${stringSEARCH:3}\"" $helpcontent | sed -e :a -e 's/<[^>]*>//g;/</N;//ba' | sed 's/^[ \t]*//;' | sed '/Syntax/,$d')
	
	#RU:Пишем в файлик
	echo "${stringDG}" >> fun_list.txt
	echo "${stringKEY}" >> fun_list.txt
	echo "$stringSEARCH" >> fun_list.txt
	#echo "$strHELP" >> fun_list.txt
	echo "" >> fun_list.txt
	(( i++ ))

	done

exit 0