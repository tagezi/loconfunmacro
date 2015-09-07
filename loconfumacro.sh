#!/bin/bash

# extracted from scaddins/source/analysis
# extracted from scaddins/source/datefunc
# extracted from scaddins/source/pricing
# extracted from sc/source/ui/src

#find ../translations/source/ru/ -type f -exec cat $* {} \; 2>/dev/null | grep -r 'useradminpage.ui'

grep -rh 'useradminpage.ui' ../translations/source/ru/