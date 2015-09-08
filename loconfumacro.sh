#!/bin/bash

# extracted from scaddins/source/analysis
# extracted from scaddins/source/datefunc
# extracted from scaddins/source/pricing
# extracted from sc/source/ui/src

grep -rhA2 '\"SC_OPCODE' ../translations/source/ru/ | sed -e '/"string.text"/d' -e 's/msgid "//' -e 's/\\n\"//' -e 's/"//' -e '2~2d'  | sed '/SC_OPCODE_ERROR/{n;p;}' #
#grep -rh '\"DATE_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
#grep -rh '\"ANALYSIS_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
#grep -rh '\"PRICING_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
