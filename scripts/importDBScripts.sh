#!/bin/sh
CURR_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

source $CURR_DIR/../config/db_config.properties

export ORACLE_HOME

LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$ORACLE_HOME:$ORACLE_HOME/lib

export LD_LIBRARY_PATH

CONNRCTION_STRING="(DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=${DB_HOSTNAME})(PORT=${DB_PORT}))(CONNECT_DATA=(SERVICE_NAME=${DB_SID})))"


PATH=$ORACLE_HOME:$PATH
export PATH

echo "$ORACLE_HOME"
echo "$LD_LIBRARY_PATH"
echo "$PATH"

db_statuscheck() {
   COUNT=0
   while :
   do
	echo "`date` :Checking DB connectivity...";
	echo "`date` :Trying to connect "${DBA_USERNAME}"/"${DBA_PASSWORD}"@"${CONNRCTION_STRING}" ..."

	echo "exit" | ${SQLPLUS} -L ${DBA_USERNAME}"/"${DBA_PASSWORD}@${CONNRCTION_STRING} | grep Connected > /dev/null
	if [ $? -eq 0 ]
	then
		DB_STATUS="UP"
		export DB_STATUS
		echo "`date` :Status: ${DB_STATUS}. Able to Connect..."
		echo "`date` :Status: ${DB_STATUS}. Populate data..."
               
                if [ "${CONTAINER_DB}"="NO" ] 
		then
                     echo "exit" | ${SQLPLUS} -s ${DBA_USERNAME}"/"${DBA_PASSWORD}@${CONNRCTION_STRING} @$CURR_DIR/ncdb/configNCDBUser.sql ${PDB_NAME} ${DB_USERNAME} ${DB_PASSWORD}
                     echo "exit" | ${SQLPLUS} -s ${DB_USERNAME}"/"${DB_PASSWORD}@${CONNRCTION_STRING} @$CURR_DIR/ncdb/sqlScriptsNCDB.sql 

                else

		     echo "exit" | ${SQLPLUS} -s ${DBA_USERNAME}"/"${DBA_PASSWORD}@${CONNRCTION_STRING} @$CURR_DIR/cdb/configCDBUser.sql ${PDB_NAME} ${DB_USERNAME} ${DB_PASSWORD}
		     echo "exit" | ${SQLPLUS} -s ${DB_USERNAME}"/"${DB_PASSWORD}@${CONNRCTION_STRING} @$CURR_DIR/cdb/sqlScriptsCDB.sql ${PDB_NAME} ${DB_USERNAME}

                fi      
		break

	else
		DB_STATUS="DOWN"
		export DB_STATUS
		echo "`date` :Status: DOWN . Not able to Connect."
		echo "`date` :Not able to connect to database with Username: "${DBA_USERNAME}" Password: "${DBA_PASSWORD}" DB HostName: "${DB_HOSTNAME}" DB Port: "${DB_PORT}" SID: "${DB_SID}"."
		sleep 30
		COUNT=$((COUNT + 1))
                if [ $COUNT -gt 30 ]
                then
			echo "`date` :Status: DOWN . Please check if DB is healthy, unable to connect to DB for long time."
			exit 1
		fi
	fi
   done
}

db_statuscheck



