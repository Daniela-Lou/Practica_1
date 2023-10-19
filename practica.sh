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
		
		'ece')
			cut -d',' -f2,4,7,11 cities.csv | grep -w $codiP | grep -w $codiE | cut -d',' -f1,4 > PoblacionsEstat.csv
			mv PoblacionsEstat.csv ${codiP}_${codiE}.csv #Igual que l'ordre ecp respecte la quantitat d'arxius
			;;
		'gwd')
			read -p "Nom d'una població: " poblacio
			wikiData=$(cut -d',' -f2,4,7,11 cities.csv | grep -w $codiP | grep -w $codiE | grep -w ^$poblacio | cut -d',' -f4)
			if [[ -n $wikiData ]]
			then
				curl https://www.wikidata.org/wiki/Special:EntityData/$widiData.json > wiki.json
				mv wiki.json $wikiData.json #Igual que l'ordre ecp i ece respecta la quantitat d'arxius
			fi
			;;
		'est') 
			awk -F',' 'BEGIN { nord=0.0; sud=0.0; est=0.0; oest=0.0; nu=0.0; wiki=0.0 } 
			{ if (NR > 0) { 
				nord += ( $9 > 0.0); 
				sud += ( $9 < 0.0 ); 
				est += ($10 > 0.0); 
				oest += ($10 < 0.0); 
				wiki += ($11 == ""); 
				nu += ($10 == 0) && ($9 == 0) }
		       	} END { print "Nord", nord, "Sud", sud, "Est", est, "Oest", oest, "No ubicació", nu, "No WDId", wiki}' cities.csv
			;;
		*)
			echo "Sense argument vàlid"
			;;			
	esac
done
