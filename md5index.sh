#!/bin/bash

#make csv of 
#md5sum,"path and filename", sizeinbytes?, date created, Machine

# should add the machine name ? 

EXITSTATUS=0

DATEM=`date +%Y%m%d%H%M`
FILEMD5DB=.filemd5db
INDEXDIR="${HOME}"
MACHINE=`uname -n`


DBFILE=${FILEMD5DB}/filesdb_${DATEM}.csv

if test $? -eq 1 
then
  INDEXDIR="${HOME}"
fi

#goeko@elefisch:~$ ls -l | while read AFILE; do echo "Some ${AFILE}"; done
echo "#v1.1#MD5SUM,\"FILENAME\",SIZE( in bytes),DATECREATED( in Epoch),MACHINE"  >> "${DBFILE}"

find "${INDEXDIR}"/ -depth -print | while read AFILE
do
  echo "File: $AFILE"
  if test ! -f "${AFILE}"
  then
    echo "Ignoring not a file '${AFILE}'"
  else
    # Get data we want...
    MD5SUM=`md5sum "${AFILE}" | cut -d\  -f1`
    FILENAME="${AFILE##${INDEXDIR}}"
    SIZE=`ls -l "${AFILE}" | cut -d\  -f5`
    #FILENAME=`basename "${AFILE}"`
    DATECREATED=`ls -l --time-style=+%s "${AFILE}" | cut -d\  -f6`

    echo "${MD5SUM},\"${FILENAME}\",${SIZE},${DATECREATED},${MACHINE}"
    echo "${MD5SUM},\"${FILENAME}\",${SIZE},${DATECREATED},${MACHINE}"  >> "${DBFILE}"
  fi
done

exit ${EXIT_STATUS}

