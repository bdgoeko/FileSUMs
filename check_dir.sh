#!/bin/bash

# For every file see if there is a current dup in the db ? 
# First see if there is a file by same name in db ? 
# or just go for the MD5 sum, 
#  md5 sum file
#  search for md5 in file
#  see if name, size and maybe date match...

EXIT_STATUS=0 #Guess things doing go good.

SCRIPT=`basename $0`
DESCRIPTION="Script to search md5 db for all files in current hierarchy"
VERSION="1.0.0-goeko-20200308223648"

function usage {
  echo "Usage: ${SCRIPT} "
  echo "Description: ${DESCRIPTION}"
}

#Locate the db file
# if no db option, or other directory to search look @home
if test -d "${HOME}/.filemd5db"; then
  # find the newest version of the db file ?
  FILEMD5DB="$HOME/.filemd5db/filesdb_202001260018.csv"
fi

if test ! -f "${FILEMD5DB}"; then
  echo "No db file found."
  exit 131
fi


# Type of match todo on the db
MATCHTYPE=MD5PLUS
#  MD5PLUS - Match MD5Sum first and then all other fields
#  NAME - just match the name
#  MD5 - just match the MD5 Sum
#  NAMEMD5 - match name then the MD5 Sum

if test $# -ge 1; then
  SEARCHFROMHERE=$1
else
  SEARCHFROMHERE=.
fi

if test ! -d "${SEARCHFROMHERE}" ; then
  echo "Not a directory."
  exit 130
fi


echo "Searching file from '${SEARCHFROMHERE}' and below."
echo "Doing '${MATCHTYPE}' match."

find "${SEARCHFROMHERE}/" -depth -print | while read AFILE
do
  MATCHES=""
  if test ! -f "${AFILE}"; then
    echo "Not a file '${AFILE}', skipping"
  else
    echo "File: '${AFILE}'"
    case ${MATCHTYPE} in
      MD5PLUS)
        FILEMD5=`md5sum "${AFILE}"|cut -d\  -f1`
        echo "Md5Sum '${FILEMD5}'"
        MATCHES=`grep ${FILEMD5} "${FILEMD5DB}"`
      ;;
      *)
        # look for filename.....
        FILENAME=`basename ${AFILE}`
        MATCHES=`grep "${FILENAME}" "${FILEMD5DB}"`
      ;;
    esac

    if test -n "${MATCHES}"; then
      echo "Mactch found"
      echo "${MATCHES}"
      EXIST_STATUS=0
    fi
     
  fi

done
