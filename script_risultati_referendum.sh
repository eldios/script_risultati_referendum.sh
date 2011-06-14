#!/bin/bash

## MacOSX sucks a lot #1 (no sed -r)
export STRING=`uname -s`
if [ "$STRING" = "Darwin" ] ; then
    export BSD_SED_SUCKS="-E"
else
    export BSD_SED_SUCKS="-r"
fi

export timeout=5
export CUR=$(curl -ks http://referendum.interno.it/referendum/RF000.htm) ; 
## MacOSX sucks a lot #2 (no watch)
while true
do (
	clear 
	echo -en 'Ultimo aggiornamento ore: ' ;
	date +'%x %X' ;
	echo -e 'I risultati si aggiorneranno automaticamente ogni ' $timeout 'secondi.' ;
	for i in "1" "2" "3" "4" 
		do (
			case $i in 
				1) echo -en 'SERVIZI PUBBLICI LOCALI\t\t' ;; 
				2) echo -en 'TARIFFA SERVIZIO IDRICO\t\t' ;;
				3) echo -en 'ENERGIA ELETTRICA NUCLEARE\t' ;; 
				4) echo -en 'LEGITTIMO IMPEDIMENTO\t\t' ;; 
			esac ; 
			echo -ne $CUR | grep -o '_'$i'">..,..%' | sed $BSD_SED_SUCKS 's/'_$i'">/ ---> Affluenza al /g' ; 
			echo -ne $CUR | sed $BSD_SED_SUCKS 's/.*SI.*([[:digit:]]{2},[[:digit:]]{2}%).*NO.*([[:digit:]]{1,2},[[:digit:]]{2}\%).*/SI: \1       NO: \2/g' ; echo ;
		) 
		done ; 
	echo $CUR | sed $BSD_SED_SUCKS 's/.*>([[:digit:]]{1,2}\.[[:digit:]]{3} comuni su [[:digit:]]{1,2}\.[[:digit:]]{3}).*/Affluenza valutata in \1/g' ; 
	echo $CUR | sed $BSD_SED_SUCKS 's/.*>([[:digit:]]{1,2}\.[[:digit:]]{3} sezioni su [[:digit:]]{1,2}\.[[:digit:]]{3}).*/Preferenze valutata in \1/g' ;
	sleep $timeout
	)
done;
