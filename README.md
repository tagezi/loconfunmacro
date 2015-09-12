# loconfuscripts
loconfuscript v1.0 (Congregating Functions for LibreOffice)

You may distribute or modify it under the terms of either the GNU LESSER GENERAL PUBLIC LICENSE Version 3.0 or later, or Mozilla Public License Version 2.0 or later.

The purpose of this script is to put together information about all available functions of Calc for l10n and documentation teams. It may allow to see a broad picture about functions, and find mistakes and inefficiencies and make it easier to analyze what is happening with functions of Calc.

This script uses directories 'workdir', 'helpcontent2' and 'translations' in the directory, where LibreOffice was build from source code.

Using for Linux.

Download source code of LibreOffice:
```
$ git clone git://anongit.freedesktop.org/libreoffice/core libreoffice
$ cd libreoffice
```
Build the code of LibreOffice with --with-help and --with-lang="ru" options:
```
$ ./autogen.sh --with-lang="ru" --with-help
$ make
```
The LibreOffice build takes 3 to 8 hours, depending on the capacity of your computer. 

Download this script:
```
$ git clone https://github.com/tagezi/loconfuscripts.git
```
And run it:
```
$ cd loconfuscripts
$ ./loconfuscripts.sh
```
The script creates two new files: fun_list.csv and fun_list.wiki.

The file CSV has field separator | (vertical bar). It is used because other characters occur in Help text often.
The file Wiki is the prepared wiki table as shown here: https://wiki.documentfoundation.org/User:Tagezi/CalcFunction
