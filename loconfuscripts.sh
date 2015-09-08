#!/bin/bash

# extracted from scaddins/source/analysis
# extracted from scaddins/source/datefunc
# extracted from scaddins/source/pricing
# extracted from sc/source/ui/src

#RU:Переменные для путей к файлам
resource=	"../translations/source/ru/formula/source/core/resource.po"
core_resource=	"../workdir/SrsPartTarget/formula/source/core/resource/core_resource.src"
scfuncs=	"../workdir/SrsPartTarget/sc/source/ui/src/scfuncs.src"
helpcontent=	"../helpcontent2/source/text/scalc/01/"
helpcontent_ls=	( $(ls "$helpcontent"))

#RU:Есть ли файлы для работы?
#EN:Is files for work?
if [ ! -f "$resource" ]; 	then echo "The file "$resource" do not exist."; 	exit 0; fi
if [ ! -f "$core_resource" ]; 	then echo "The file "$core_resource" do not exist."; 	exit 0; fi
if [ ! -f "$scfuncs" ]; 	then echo "The file "$scfuncs" do not exist."; 		exit 0; fi
if [ -z "$helpcontent_ls" ];	then echo "The file "$helpcontent" is empty" ; 		exit 0; fi

#RU: Массив для поиска функций
declare -a sc_opcode_fun

#RU:Делаем выборку функций и из кодов из файла
sc_opcode_fun=( $(grep -rhA2 '\"SC_OPCODE' "$resource" | 
	sed -e '/\"string.text\"/d'  -e 's/msgid \"//' -e 's/\\n\"//' -e 's/\"//' -e '2~2d' |
	sed -e '/SC_OPCODE_ERROR_T/!s/SC_OPCODE_ERROR/#SC_OPCODE_ERROR/g' -e '/ *#/d' -e '/SC_OPCODE_TABLE/d' |
	sed -e '1!G;h;$!d')) #переворачиваем сторки

i=0

while [[ ${sc_opcode_fun[$i]} != "" ]] 
	do
		(( i++ ))
	done

#grep -rh '\"DATE_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
#grep -rh '\"ANALYSIS_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
#grep -rh '\"PRICING_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'

#echo ${sc_opcode_fun[@]}

exit 0