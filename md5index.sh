#!/bin/bash

#make csv of 
#md5sum,"path and filename", sizeinbytes?, date created, Machine,file output ? `
#goeko@elefisch:~$ ls -l | while read AFILE; do echo "Some ${AFILE}"; done
VERSION="0.0.1-goeko-20200308223147"

SCRIPT=`basename $0`
EXITSTATUS=0

DATEM=`date +%Y%m%d%H%M`
FILEMD5DBDIR=.
FILEMD5DB=.filemd5db
INDEXDIR="${HOME}"
MACHINE=`uname -n`
LOCKFILE=
LOGFILE=
SCRIPT=

function usage {
  echo "Script to create an MD5 index for a directory tree..."
  echo "Version:'${VERSION}'"
}

if test $# -eq 1 
then
  INDEXDIR="${1}"
fi
echo "Indexing directory '${INDEXDIR}'..."

DBFILE=${FILEMD5DB}/filesMD5db_${DATEM}.csv

# Output the header
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

# check everything is good...
  
if ${EXIT_STATUS}" -eq 0 ; then
  if test -f "${FILEMD5DBDIR}/latest_filesMD5db.csv"; then
    echo "Removing old latest file."
    rm 
  fi
  echo "Creating new latest file, '${DBFILE}' to '${FILEMD5DBDIR}/latest_filesMD5db.csv'"
  ln -s "${DBFILE}" "${FILEMD5DBDIR}/latest_filesMD5db.csv"

exit ${EXIT_STATUS}

