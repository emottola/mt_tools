#!/bin/bash - 
#title           :gralogreader.sh
#description     :Print out Galera Cluster GRA_*.log file content
#author	         :emottola
#date            :20180522
#version         :0.1
#usage           :bash gralogreader.sh /path/GRA_1_1.log
#notes           :You need mysqlbinlog and xxd installed.
#=========================================================================================

# Temporary file location and name (pid of the running script process)
TMP_FILE=/tmp/$$
MYSQL_BINLOG_HEADER_BIN="fe62696e347502500f01000000670000006b00000001000400352e352e32352d\
64656275672d6c6f6700000000000000000000000000000000000000000000000000000000000000000000347\
5025013380d0008001200040404041200005400041a080000000808080200"
MYSQLBINLOG_BIN=$(which mysqlbinlog)
XXD_BIN=$(which xxd)

# Check required executables
if [ -z "${MYSQLBINLOG_BIN}" ] ||  [ -z "${MYSQLBINLOG_BIN}" ]; then
	'Error: Unable to locate mysqlbinlog binary or xxd' && exit 1
fi

# Check target file
if [ -z $1 ] || [ ! -e $1 ]; then
	echo 'Error: please specify valid target GRA_*.log file path' && exit 1
else
	TARGET_GRALOGFILE=$1; fi

# Recreate the binlog header
echo ${MYSQL_BINLOG_HEADER_BIN} | ${XXD_BIN} -c 120 -r -p > ${TMP_FILE}

# Append the target file to generate a readable binlog 
cat ${TARGET_GRALOGFILE} >> ${TMP_FILE}

# Print and delete the temporary file
echo; ${MYSQLBINLOG_BIN} -vvv ${TMP_FILE} && echo; rm -f ${TMP_FILE}
exit 0