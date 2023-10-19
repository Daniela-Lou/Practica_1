#!/bin/bash

opcio='XX'

codiP='XX'
codiE='XX'

#cadena ='(("\w+( +\w+)+")|\w+)'

while [[ $opcio!=q ]]; do 
	read -p "Escull una opció: " opcio
	#echo $opcio
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
			if [[ -z "$pais" ]] #si la variable està buida (intro)
			then
				codiP=$codiP
			else #si s'ha introduit alguna cosa
				codiP=$(cut -d ',' -f7,8 cities.csv | grep -w $pais |cut -d',' -f1| uniq) #grep -w: paraules
				if [[ -z $codiP ]]; then #si el pais no està existeix en el document
					codiP='XX'
				else 
					echo $codiP 
				fi
			fi
			echo $codiP
			;;
		'se')
			read -p "Nom de l'estat: " estat
			if [[ -z "$estat" ]] #si fa intro
			then 
				codiE=$codiE
			else #existeix en el document o la ciutat té 'codiP' (està al pais escullit) 
				#if [[ -n "grep $estat cities.csv" ]]; # && [[ (cut -d ',' -f5,7 cities.csv | grep $estat | uniq | cut -d ',' -f1) != $codiP ]]
				#then	
				codiE=$(cut -d',' -f4,5,7 cities.csv | grep -w $estat| grep -w $codiP| cut -d',' -f1| uniq ) 
				#cut -d',' -f4,5,7 cities.csv | grep -w Zaragoza| grep -w ES | uniq | cut -d',' -f1
				if [[ -z $codiE ]] #|| [[ -z "cut -d',' -f4,7 cities.csv | grep $codiP| grep -w $codiE| uniq" ]]
				then
					codiE='XX'
				else
					echo $codiE
				fi
			fi
			echo $codiE
			;;
		'le')
			cut -d',' -f4,5,7 cities.csv | grep -w $codiP | cut -d',' -f1,2 | uniq 
			
			;;
		'lcp')
			cut -d',' -f2,7,11 cities.csv | grep -w $codiP | cut -d',' -f1,3 | column -s',' -t
			
			;;

		'ecp')
			#Aquí està pensat perquè cada cop que es canvii de país, la llista substitueixi les dades anteriors per les noves i només crei 1 arxiu
			cut -d',' -f2,7,11 cities.csv | grep -w $codiP | cut -d',' -f1,3 | column -s',' -t > PoblacionsPais.csv
			mv PoblacionsPais.csv $codiP.csv 
			;;
		'lce')
			cut -d',' -f2,4,7,11 cities.csv | grep -w $codiP | grep -w $codiE | cut -d',' -f1,4 | column -s',' -t
			;;
		
		'ece')
			cut -d',' -f2,4,7,11 cities.csv | grep -w $codiP | grep -w $codiE | cut -d',' -f1,4 | column -s',' -t > PoblacionsEstat.csv
			mv PoblacionsEstat.csv ${codiP}_${codiE}.csv 
			;;#La part de l'arxiu està igual que a l'ordre "ecp"
		'gwd')
			read -p "Nom d'una població: " poblacio
			wikiData=$(cut -d',' -f2,4,7,11 cities.csv | grep -w $codiP | grep -w $codiE | grep -w ^$poblacio | cut -d',' -f4)
			echo $wikiData
			if [[ -n $wikiData ]]
			then
				curl https://www.wikidata.org/wiki/Special:EntityData/$widiData.json > wiki.json
				mv wiki.json $wikiData.json
			fi
			;;
		'est') 
			awk -F',' 'BEGIN { nord=0.0; sud=0.0; est=0.0; oest=0.0; nu=0.0; wiki=0.0 } { if (NR > 0) { nord += ( $9 > 0.0); sud += ( $9 < 0.0 ); est += ($10 > 0.0); oest += ($10 < 0.0); wiki += ($11 == ""); nu += ($10 == 0) && ($9 == 0) } } END { print "Nord", nord, "Sud", sud, "Est", est, "Oest", oest, "No ubicació", nu, "No WDId", wiki}' cities.csv
			;;
		*)
			echo "Sense argument vàlid"
			;;			
	esac
done
