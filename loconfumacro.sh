#!/bin/bash

# extracted from scaddins/source/analysis
# extracted from scaddins/source/datefunc
# extracted from scaddins/source/pricing
# extracted from sc/source/ui/src

grep -rh '\"SC_OPCODE' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
grep -rh '\"DATE_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
grep -rh '\"ANALYSIS_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
grep -rh '\"PRICING_FUNCNAME' ../translations/source/ru/ | cut -c 2- | sed 's/...$//'
