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
declare -a file_tac

#RU:Делаем выборку функций и из кодов из файла
sc_opcode_fun=( $(grep -rhA2 '\"SC_OPCODE' "$resource" | 
	sed -e '/\"string.text\"/d'  -e 's/msgid \"//' -e 's/\\n\"//' -e 's/\"//' -e '2~2d' |
	sed -e '/SC_OPCODE_ERROR_T/!s/SC_OPCODE_ERROR/#SC_OPCODE_ERROR/g' -e '/ *#/d' -e '/SC_OPCODE_TABLE_REF/d' -e '/SC_OPCODE_NO_NAME/d'|
	sed -e '1!G;h;$!d')) #переворачиваем сторки
i=0

#RU:Собираем и записываем в файл в порядке: Имя_Функции, KeyID, Имя_Макроса, Описание_из_описания, Имя_Макроса_описания_описания,
#RU:Описание_из_Help, Имя_Макроса_описания_Help
while [[ ${sc_opcode_fun[$i]} != "" ]] 
	do
	#RU:Собираем Собираем и записываем в файл в порядке: Имя_Функции, KeyID, Имя_Макроса
	echo "${sc_opcode_fun[$i]}"
	echo "${sc_opcode_fun[i]}" >> fun_list.txt
	stringQTZ=$(grep -rh "||${sc_opcode_fun[i]/\./\\\.}\"" "$core_resource")
	echo "${stringQTZ:17:5}" >> fun_list.txt
	(( i++ ))
	echo "${sc_opcode_fun[i]}" >> fun_list.txt
# 	i=1
	#RU:Собираем и записываем в файл в порядке: Описание_из_GUI, KeyID_описания, Имя_Макроса_описания_описания,
	#RU: Кручу верчу - запутать хочу. Бред сивой кобылы, но по другому не знаю как
	file_tac=( $(sed "/${sc_opcode_fun[$i]:9}/,$ d" "$scfuncs" | tac | sed -e "/String 1/,$ d" -e 's/^[\t]*//' -e 's/[{}]//' -e 's/[;]$//' | tac ))
	ii=0
	
	#RU: Из-за того что кто-то не подумавши лепит названия макросам нужно проверять имена
	if [ ! "$file_tac" = '' ] ; then echo "Не нахожу аналога ${sc_opcode_fun[i]} в описании" ; exit 0; fi
	
	#RU: Где же ключик?
	while [[ ${file_tac[$ii]} != "qtz" ]]
		do
		(( ii++ ))
		done

	ii=$ii+3
	stringKEY=${file_tac[$ii]:1:5} 	#RU:Обрезаем всё лишнее с ключа
	stringDG=${file_tac[$ii]:8}	#RU:Обрезаем начало строки для описания
	ii=$ii+1
	p=" "
	
	#RU:Собираем саму строку с описанием
	while [[ ${file_tac[$ii]} != 'String' ]]
		do
		stringDG="$stringDG$p${file_tac[$ii]}"
		(( ii++ ))
		done
	
	stringNMDG=$( grep -h ${sc_opcode_fun[1]:9} "$scfuncs")			#RU:Находим имя макроса
	stringNMDG=$( echo "$stringNMDG" | sed -e 's/..$//' -e 's/^[\t]*//' )	#RU:Срезаем с него всё лишнее
	stringDG=$( echo "$stringDG" | sed -e 's/.$//')				#RU:убираем последнюю кавычку у описания
	
	#RU:Пишем в файлик
	echo "${stringDG}" >> fun_list.txt
	echo "${stringKEY}" >> fun_list.txt
	echo "${stringNMDG:1}" >> fun_list.txt
	echo "" >> fun_list.txt
	(( i++ ))
	
	unset file_tac[*]
	done
	
#grep -rh '\"DATE_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
#grep -rh '\"ANALYSIS_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
#grep -rh '\"PRICING_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'

#echo ${sc_opcode_fun[@]}

exit 0