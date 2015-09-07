#!/bin/bash

# extracted from scaddins/source/analysis
# extracted from scaddins/source/datefunc
<<<<<<< HEAD
# extracted from scaddins/source/pricing
=======
# extracted from scaddins/source/pricing 
>>>>>>> the start thinking
# extracted from sc/source/ui/src

#find ../translations/source/ru/ -type f -exec cat $* {} \; 2>/dev/null | grep -r 'useradminpage.ui'

<<<<<<< HEAD
grep -rh 'useradminpage.ui' ../translations/source/ru/
=======
grep -rh '\"SC_OPCODE' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
grep -rh '\"DATE_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
grep -rh '\"ANALYSIS_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
grep -rh '\"PRICING_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
>>>>>>> the start thinking
