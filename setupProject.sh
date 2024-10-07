#!/bin/sh
usage() {
	echo "Script usage":
        echo "setupProject [OPTIONS]"
        echo "-c | --client        Nom del client"
        echo "-p | --projecte      Nom del projecte"
	echo "-d | --directory     Ruta a on es creara el directori"
}

extract_argument() {
	echo "${2:-${1#*=}}"
}

path="./"

while [ $# -gt 0 ]
do
	case $1 in
		-c | --client)
			client=$(extract_argument $@)
			shift
			;;
		-p | --projecte)
			proj=$(extract_argument $@)
			shift
			;;
		-d | --directory)
			path=$(extract_argument $@)
			shift
			;;
	esac
	shift
done

if [ ! -n "$client" ]
then
	echo [$(date +'%d/%m/%Y %H:%M') $(whoami)] "(Error de parametres) L'script ha fallat perque no has introduit el parametre -c"
	echo [$(date +'%d/%m/%Y %H:%M') $(whoami)] "(Error de parametres) L'script ha fallat perque no has introduit el parametre -c" >> /var/log/setupProject/output.log
	exit 1
fi

if [ ! -n "$proj" ]
then
	echo [$(date +'%d/%m/%Y %H:%M') $(whoami)] "(Error de parametres) L'script ha fallat perque no has introduit el parametre -j"
        echo [$(date +'%d/%m/%Y %H:%M') $(whoami)] "(Error de parametres) L'script ha fallat perque no has introduit el parametre -j" >> /var/log/setupProject/output.log
	exit 1
fi

if [ -d $path/$client/$proj ]
then
	echo [$(date +'%d/%m/%Y %H:%M') $(whoami)] "(Error de creació) L'script ha fallat perque ja existeix un projecte '$proj' per el client '$client' al directori '$path'"
        echo [$(date +'%d/%m/%Y %H:%M') $(whoami)] "(Error de creació) L'script ha fallat perque ja existeix un projecte '$proj' per el client '$client' al directori '$path'" >> /var/log/setupProject/output.log
        exit 3
fi

if [ ! -w $path ]
then
        echo [$(date +'%d/%m/%Y %H:%M') $(whoami)] "(Error de permisos) L'script ha fallat perque no tens permisos per escriure a la ruta '$path' o be no existeix"
        echo [$(date +'%d/%m/%Y %H:%M') $(whoami)] "(Error de permisos) L'script ha fallat perque no tens permisos per escriure a la ruta '$path' o be no existeix" >> /var/log/setupProject/output.log
        exit 2
fi

mkdir -p "$path/$client/$proj"/codi "$path/$client/$proj"/documentacio/legal "$path/$client/$proj"/documentacio/manuals

echo [$(date +'%d/%m/%Y %H:%M') $(whoami)] "(Execució correcte) L'script s'ha executat correctament"
echo [$(date +'%d/%m/%Y %H:%M') $(whoami)] "(Execució correcte) L'script s'ha executat correctament" >> /var/log/setupProject/output.log
