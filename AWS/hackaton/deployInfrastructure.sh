#!/bin/bash

USAGE="""Usage: ./deployInfrastructure.sh <ARGUMENTS>

ARGUMENTS:
  -h                            Display this help message
  -d <Domain Name>              AD Domain Name
  -c <Client Number>            Number of clients to generate
  -u <U1/P1,U2/P2,U3/U3>        Users and passwords for the clients (format: User1/Pass1,User2/Pass2,...)

Note: Ensure to follow the specified format for users and passwords.
"""

if [ $# -ne 6 ]
then
	echo "$USAGE"
	exit 1
fi

extract_argument() {
	echo "${2:-${1#*=}}"
}

DOMAIN=""
CLIENTS=""
declare -A USERS_PASS

while [ $# -gt 0 ]
do
	case $1 in
		-d) # Domain name
			DOMAIN=$(extract_argument $@)
			shift
			;;
		-c) # Number of clients
			CLIENTS=$(extract_argument $@)
			shift
			if [ $CLIENTS -gt 10 ] && [ $CLIENTS -lt 1 ]
			then
				echo "Number of clients must be between 1 and 10"
				exit 1
			fi
			;;
		-u) # Users and passwords
			# Separar per parelles d'usuari i contrasenya
			IFS='/' read -ra pairs <<< "$(extract_argument $@)"
			# Per cada parella separar-la i guardar en un array associatiu
			for pair in "${pairs[@]}"; do
				IFS=',' read -r key value <<< "$pair"
    				USERS_PASS["$key"]="$value"
			done
			;;
	esac
	shift
done

# Debug
echo "Deploying infrastructure for hackatoon with the following parameters:"
echo "	Domain name: $DOMAIN"
echo "	Number of clients: $CLIENTS"
echo "	Users:"
for key in "${!USERS_PASS[@]}"; do
    echo "	- User: $key Pass: ${USERS_PASS[$key]}"
done
# End debug

# Crear SG
echo "Creating Security Group:"
SGID=$(./createSG.sh)

# Error general
if [ $? -eq 2 ]
then
	echo "Error while creating Security Group!"
	exit 2
fi
echo $SGID

# Crear WS22
echo "Creating WS22 instance:"
./createWS.sh $SGID