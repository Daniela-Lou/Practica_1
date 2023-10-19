#!/bin/bash

opcio='XX'
codiP='XX'
codiE='XX'

while [[ $opcio!=q ]]; do #bucle
	read -p "Escull una opció: " opcio
	case $opcio in 
		'q') 		
			echo "Sortint de l'aplicació"
			exit 0
			;;
	
		'lp')
			cut -d',' -f7,8 cities.csv | uniq | column -s ',' -t
			;;
		'sc')
			echo "Nom del pais" ; read pais
			if [[ -z "$pais" ]] #si es fa intro
			then
				codiP=$codiP
			else 
				codiP=$(cut -d ',' -f7,8 cities.csv | grep -w $pais |cut -d',' -f1| uniq) 
				if [[ -z $codiP ]]; then #si el pais no existeix en el document
					codiP='XX' 
				fi
			fi
			;;
		*)
			echo "Sense argument vàlid"
			;;			
	esac
done
