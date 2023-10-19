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
		'se')
			read -p "Nom de l'estat: " estat
			if [[ -z "$estat" ]] #si fa intro
			then 
				codiE=$codiE
			else #si existeix en el document o la ciutat té codiP
				codiE=$(cut -d',' -f4,5,7 cities.csv | grep -w $estat| grep -w $codiP| cut -d',' -f1| uniq ) 
				if [[ -z $codiE ]] #significa que l'estat no pertany al pais 
				then
					codiE='XX'
				fi
			fi
			;;
		'le')
			cut -d',' -f4,5,7 cities.csv | grep -w $codiP | cut -d',' -f1,2 | uniq | column -s',' -t 
			
			;;
		'lcp')
			cut -d',' -f2,7,11 cities.csv | grep -w $codiP | cut -d',' -f1,3 | column -s',' -t
			;;

		'ecp')
			#Aquí està pensat perquè cada cop que es canvii de país, la llista substitueixi les dades anteriors per les noves i només hi hagi 1 arxiu
			cut -d',' -f2,7,11 cities.csv | grep -w $codiP | cut -d',' -f1,3 > PoblacionsPais.csv
			mv PoblacionsPais.csv $codiP.csv 
			;;
		'lce')
			cut -d',' -f2,4,7,11 cities.csv | grep -w $codiP | grep -w $codiE | cut -d',' -f1,4 | column -s',' -t
			;;
		*)#Qualsevol cosa que no sigui una des les opcions
			echo "Sense argument vàlid"
			;;			
	esac
done
