#!/bin/bash

EXIT_STATUS=0
VERSION="0.0.1-goeko-20200308223153"

SCRIPT=`basename $0`

if test $# -lt 1; then
  echo "USAGE: ${SCRIPT} filedb"
  exit 130
fi

FILE="$1"

if test ! -f "${FILE}" ; then
  echo "Not a file"
fi


sort "${FILE}" | while read LINE
do
  MD5SUM=`echo "${LINE}" | cut -d, -f1`

  if test -n "${OLDMD5}" ; then
    if test ${OLDMD5} == ${MD5SUM} ; then
      echo "Match ${OLDLINE}"
      echo "${LINE}"
    fi
  fi

  OLDLINE=${LINE}
  OLDMD5=${MD5SUM}

done


exit ${EXIST_STATUS}
