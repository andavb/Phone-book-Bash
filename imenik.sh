#!/bin/bash
function vprasaj(){
	read -p "Ali ste prepricani da zelite izvediti akcijo? (y/n) " -n 1 -r
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]
	then
	   nadaljuj=1
	else
		nadaljuj=0
		exit 1
	fi
}


function preberi(){

	if [ -f "imenik.dat" ]
	then
		exec 5<"imenik.dat"
		vrstice=$(cat imenik.dat | wc -l)
		stevec=0
		for (( l=0; l<$vrstice; l++ )) #beremo iz datoteke in zapisujemo v polje1 matriko1
		do
		read -a pomozno -u 5
		  for (( c=0; c<6; c++ ))
		  do
		  imenik[$stevec]=${pomozno[$c]}
		  stevec=$[$stevec+1]
		  done
		done
	fi	
	#echo "${imenik[@]}" 
}

function dodaj(){
	vprasaj

	declare -a arr=("0" "ime" "priiemk" "naslov" "posta" "tel")

	for (( var=1; var<=10; var+=2))
	do
		#eval vrednost='$'$(( var+1 ))
		eval vrednost='$'$var
		#echo $vrednost
		if [ -z $vrednost ]
		then
			vrednost=" asd"
		fi

		if [ $vrednost == "--ime" ]
		then 
			eval v='$'$(( var+1 ))
			arr[1]=$v
		elif [ $vrednost == "--priimek" ]
		then 
			eval v='$'$(( var+1 ))
			arr[2]=$v
		elif [ $vrednost == "--naslov" ]
		then
			eval v='$'$(( var+1 ))
			arr[3]=$v
		elif [ $vrednost == "--posta" ]
		then 
			eval v='$'$(( var+1 ))
			arr[4]=$v
		elif [ $vrednost == "--tel" ]
		then
			eval v='${'$(( var+1 ))'}'
			arr[5]=$v
		elif [[ $vrednost =~ --.* ]]
		then 
			echo "Vnesli ste napacno zastavico!"
			exit 1
		fi
	done
	r=$(( ( RANDOM % 10000 )  + 1 ))
	arr[0]=$(( vrstice*1+r ))

	printf "%s " "${arr[@]}">> imenik.dat
	echo >> imenik.dat
}

function isci(){
	iskani=("" "" "" "" "" "")
	for (( var=1; var<=10; var+=2))
	do
		#eval vrednost='$'$(( var+1 ))
		eval vrednost='$'$var
		#echo $vrednost
		if [ -z $vrednost ]
		then
			vrednost=" asd"c
		fi

		if [ $vrednost == "--id" ]
		then 
			eval v='$'$(( var+1 ))
			iskani[0]=$v
		elif [ $vrednost == "--ime" ]
		then 
			eval v='$'$(( var+1 ))
			iskani[1]=$v
		elif [ $vrednost == "--priimek" ]
		then 
			eval v='$'$(( var+1 ))
			iskani[2]=$v
		elif [ $vrednost == "--naslov" ]
		then
			eval v='$'$(( var+1 ))
			iskani[3]=$v
		elif [ $vrednost == "--posta" ]
		then 
			eval v='$'$(( var+1 ))
			iskani[4]=$v
		elif [ $vrednost == "--tel" ]
		then
			eval v='${'$(( var+1 ))'}'
			iskani[5]=$v
		elif [[ $vrednost =~ --.* ]]
		then 
			echo "Vnesli ste napacno zastavico!"
			exit 1
		fi
	done

	poz="$(grep "" imenik.dat)"

	for(( h=0; h<6; h++ ))
	do
		if [ $iskani[h] != "" ]
		then
			poz="$(echo "$poz" | grep "${iskani[h]}")"
		fi
	done

	echo "$poz"
}

function uredi(){
	vprasaj

	id=-1

	for (( q=1; q<=10; q+=1))
	do
		eval z='$'$q
		if [ $z == "--id" ]
		then
			eval v='$'$(( q+1 ))
			id=$v
			break
		fi
	done

	len=${#imenik[@]}
	idNajden=-1
	for (( i = 0; i < $len; i++ ))
	do
		if [[ ${imenik[$i]} == $id ]]
		then
			idNajden=$i
			break
		fi
	done

	if [ $idNajden == -1 ]
	then
		echo "Id ne obstaja !"
		exit 1
	fi

	#echo "${imenik[$idNajden]}"
	#echo "${imenik[$idNajden+1]}"
	#echo $idNajden

	for (( var=1; var<=10; var+=2))
	do
		#eval vrednost='$'$(( var+1 ))
		eval vrednost='$'$var
		#echo $vrednost
		if [ -z $vrednost ]
		then
			vrednost=" asd"
		fi

		if [ $vrednost == "--ime" ]
		then 
			eval v='$'$(( var+1 ))
			imenik[$idNajden+1]=$v
		elif [ $vrednost == "--priimek" ]
		then 
			eval v='$'$(( var+1 ))
			imenik[$idNajden+2]=$v
		elif [ $vrednost == "--naslov" ]
		then
			eval v='$'$(( var+1 ))
			imenik[$idNajden+3]=$v
		elif [ $vrednost == "--posta" ]
		then 
			eval v='$'$(( var+1 ))
			imenik[$idNajden+4]=$v
		elif [ $vrednost == "--tel" ]
		then
			eval v='${'$(( var+1 ))'}'
			imenik[$idNajden+5]=$v
		elif [ $vrednost == "--id" ]
		then 
			eval v='$'$(( var+1 ))
		elif [[ $vrednost =~ --.* ]]
		then 
			echo "Vnesli ste napacno zastavico ali pa niste podali parametrov!"
			exit 1
		fi
	done

	pomozna=-1

	cp imenik.dat{,bak} #naredi kopijo za usak slucaj

	rm imenik.dat

	for (( j = 0; j < $len; j++ )); do

		eval v="${imenik[$j]}" 
		printf "%s " "$v" >> imenik.dat
		((pomozna++))
		if [[ $pomozna == 5 ]]; then
			echo >> imenik.dat
			pomozna=-1
		fi
	done
}

function brisi(){
	vprasaj

	id=-1

	for (( q=1; q<=10; q+=1))
	do
		eval z='$'$q
		if [ $z == "--id" ]
		then
			eval v='$'$(( q+1 ))
			id=$v
			break
		fi
	done

	len=${#imenik[@]}
	idNajden=-1

	for (( i = 0; i < $len; i++ ))
	do
		if [[ ${imenik[$i]} == $id ]]
		then
			idNajden=$i
			break
		fi
	done

	if [ $idNajden == -1 ]
	then
		echo "Id ne obstaja !"
		exit 1
	fi

	for (( stevec = 0; stevec < 6; stevec++ )); do
		unset imenik[$((idNajden+stevec))]
	done

	cp imenik.dat{,bak}  #naredi kopijo za usak slucaj
	rm imenik.dat
	pomozno=-1

	for (( j = 0; j < $len; j++ )); do
		eval v="${imenik[$j]}"
		if [ ! -z "$v" ]
   		then
			printf "%s " "$v" >> imenik.dat
			((pomozno++))
			if [[ $pomozno == 5 ]]; then
				echo >> imenik.dat
				pomozno=-1
			fi
		fi
	done
}

imenik=()
vrstice=0
preberi

if [ $1 == "--dodaj" ]
then
	shift
	dodaj $@
elif [ $1 == "--isci" ]
then 
	shift
	isci $@
elif [ $1 == "--uredi" ]
then 
	shift
	uredi $@
elif [ $1 == "--brisi" ]
then 
	shift
	brisi $@
else
	echo "Napacna prva zastavica!"
	exit 1
fi