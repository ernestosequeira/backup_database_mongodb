#!/bin/bash
########### Autor: Ernesto Sequeira ##################################
########### Backup Script MongoDB ###############################

# Colors constants
NONE="$(tput sgr0)"
RED="$(tput setaf 1)"
GREEN="$(tput setaf 2)"
YELLOW="\n$(tput setaf 3)"
BLUE="\n$(tput setaf 4)"

message_date() {
	# $1 : Message
	# $2 : Color
	# return : Message colorized
	local NOW="[$(date +%H:%M:%S)]"
	echo -e "${2}${NOW}${1}${NONE}"
}

message() {
	# $1 : Message
	# $2 : Color
	# return : Message colorized
	echo -e "${2}${1}${NONE}"
}


### System Setup ###
BACKUP="bkp_mongodb"

### MongoDB Setup ###
USER="usuario"
PASS="MiPassword"
HOST="localhost"
DATABASES=(admin testing)


### Binaries ###
TAR="$(which tar)"
GZIP="$(which gzip)"
MONGODUMP="$(which mongodump)"

### Today + hour in 24h format ###
NOW=$("-"+date +"%F")

bkp_databases_mongodb(){
	message_date ">> Start backup databases" ${GREEN}
	for i in 0 1
	do
		mongodump --db ${DATABASES[$i]} --username $USER --password $PASS --out $BACKUP$NOW
	done
	$TAR -cvf $BACKUP$NOW
	$TAR czvf $BACKUP$NOW.tar.gz $BACKUP$NOW/*
	#rm -rf $BACKUP$NOW
	message_date ">> Backup completed." ${GREEN}
}

# Call Functions
bkp_databases_mongodb
