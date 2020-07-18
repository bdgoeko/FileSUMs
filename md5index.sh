#!/bin/bash

#make csv of 
#md5sum,"path and filename", sizeinbytes?, date created, Machine,file output ? `
#goeko@elefisch:~$ ls -l | while read AFILE; do echo "Some ${AFILE}"; done

VERSION="0.0.2-goeko-20200521105131"

SCRIPT=`basename $0`
EXITSTATUS=0

DATEM=`date +%Y%m%d%H%M`
FILEMD5DB=.filemd5db
INDEXDIR="${HOME}"
MACHINE=`uname -n`
LOCKFILE=
LOGFILE=
SCRIPT=`basename $0`

function usage {
  echo "Usage: ${SCRIPT} {BASE_of_DIRECOTRY_2_Index}"
  echo "Script to create an MD5 index for a directory tree..."
  echo "Version:'${VERSION}'"
}

# going to create index where base dir is...
#if test -z "${FILEMD5DBDIR}" ; then
#  FILEMD5DBDIR=${HOME}/
#fi

# By deafult index home dir...
if test -z "${INDEXDIR}" ; then
  INDEXDIR=${HOME}/
fi

# if given a option use that as the index dir
if test $# -eq 1 
then
  INDEXDIR="${1}"
elif test $# -ge 2 ;then
  usage
  echo "Error, too many arguments."
  exit 132
fi

if test ! -d "${INDEXDIR}" 
  then
  echo "Directoyr to index '${INDEXDIR}' not found."
  exit 133
fi

FILEMD5DBDIR="${INDEXDIR}/${FILEMD5DB}/"
DBFILE=${FILEMD5DBDIR}/filesMD5db_${DATEM}.csv

if test ! -d "${FILEMD5DBDIR}" ; then
  echo "Creating MD5 index directory '${FILEMD5DBDIR}'"
  mkdir -p "${FILEMD5DBDIR}"
fi

echo "Indexing directory '${INDEXDIR}'..."

# Output the header
echo "#v1.1#MD5SUM,\"FILENAME\",SIZE( in bytes),DATECREATED( in Epoch),MACHINE"  >> "${DBFILE}"

#cd "${INDEXDIR}"
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

    #echo "${MD5SUM},\"${FILENAME}\",${SIZE},${DATECREATED},${MACHINE}"
    echo "${MD5SUM},\"${FILENAME}\",${SIZE},${DATECREATED},${MACHINE}"  >> "${DBFILE}"
  fi
done

# check everything is good... and link to default index
if "${EXIT_STATUS}" -eq 0 ; then
  if test -f "${FILEMD5DBDIR}/latest.csv"; then
    echo "Removing old latest file."
    rm "${FILEMD5DBDIR}/latest.csv"
  fi
  echo "Creating new latest file, '${DBFILE}' to '${FILEMD5DBDIR}/latest.csv'"
  ln -s "${DBFILE}" "${FILEMD5DBDIR}/latest.csv"
fi

exit ${EXIT_STATUS}

