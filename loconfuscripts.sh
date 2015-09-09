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

#RU:Переменные для путей к файлам
resource="../translations/source/ru/formula/source/core/resource.po"
core_resource="../workdir/SrsPartTarget/formula/source/core/resource/core_resource.src"
scfuncs="../workdir/SrsPartTarget/sc/source/ui/src/scfuncs.src"
helpcontent="../helpcontent2/source/text/scalc/01/"
helpcontent_ls=( $(ls "$helpcontent"))

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

#RU:Делаем выборку функций и кодов из файла
sc_opcode_fun=( $(grep -rhA2 '\"SC_OPCODE' "$resource" | 
	sed -e '/\"string.text\"/d'  -e 's/msgid \"//' -e 's/\\n\"//' -e 's/\"//' -e '2~2d' |
	sed -e '/SC_OPCODE_ERROR_T/!s/SC_OPCODE_ERROR/#SC_OPCODE_ERROR/g' -e '/ *#/d' -e '/SC_OPCODE_TABLE_REF/d' -e '/SC_OPCODE_NO_NAME/d'|
	sed -e '1!G;h;$!d')) #переворачиваем сторки
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

	stringSEARCH=${sc_opcode_fun[$i]:9}
	
	#RU:Из-за того что кто-то не подумавши лепит названия макросам нужно проверять имена
	if [[ ${sc_opcode_fun[$i]: -3} == "HYP" || ${sc_opcode_fun[$i]:10:3} == "ARC" ]]
		then
		stringTMP=${sc_opcode_fun[$i]:9}
		stringSEARCH="_${stringTMP//_/}"
	fi
	
	#RU:Собираем и записываем в файл в порядке: Описание_из_описания, KeyID_описания, Имя_Макроса_описания,
	#RU:Кручу верчу - запутать хочу. Бред сивой кобылы, но по другому не знаю как
	file_tac=$(sed "/$stringSEARCH/,$ d" "$scfuncs" | tac | sed -e "/String 1$/,$ d" -e 's/^[\t]*//' -e 's/[{}]//' -e 's/[;]$//' | tac )
	file_tac=$(echo $file_tac | grep -ho 'qtz.*String 2')

 	stringKEY=${file_tac:9:5} 					#RU:Обрезаем всё лишнее с ключа
 	stringDG=$( echo "${file_tac:16}" | sed -e 's/..........$//')	#RU:Обрезаем начало строки для описания
	stringNMDG=$( grep -h "${sc_opcode_fun[i]:9}\"" "$scfuncs")		#RU:Находим имя макроса
 	stringNMDG=$( echo "$stringNMDG" | sed -e 's/..$//' -e 's/^[\t]*//' )	#RU:Срезаем с него всё лишнее
	
	#RU:Пишем в файлик
	echo "${stringDG}" >> fun_list.txt
	echo "${stringKEY}" >> fun_list.txt
	echo "${stringNMDG:1}" >> fun_list.txt
	echo "" >> fun_list.txt
	(( i++ ))

	done

#grep -rh '\"DATE_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
#grep -rh '\"ANALYSIS_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
#grep -rh '\"PRICING_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'

exit 0