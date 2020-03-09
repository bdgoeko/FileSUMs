#!/bin/bash

# For every file see if there is a current dup in the db ? 
# First see if there is a file by same name in db ? 
# or just go for the MD5 sum, 
#  md5 sum file
#  search for md5 in file
#  see if name, size and maybe date match...

VERSION="1.0.0-goeko-20200308223629"
EXIT_STATUS=0 #Guess things doing go good.

SCRIPT=`basename $0`
DESCRIPTION="Script to search md5 db files"
FILEMD5DBDIR=${HOME}/.filemd5db

function usage {
  echo "Usage: ${SCRIPT} file [file file ...]"
  echo "Description: ${DESCRIPTION}"
  echo "Version:${VERSION}"
}

#Locate the db file
# if no db option, or other directory to search look @home
if test -d "${FILEMD5DBDIR}"; then
  # find the newest version of the db file ?
  #FILEMD5DB="$HOME/.filemd5db/filesdb_202001260018.csv"
  # try index, if it desn't exist grab the latest file...

  FILEMD5DB="${FILEMD5DBDIR}/latest_filesMD5db.csv"
  if test ! -f "${FILEMD5DB}"; then
    # No latest index, try to find the file...
    #FILEMD5DB=`ls -1rt "${FILEMD5DBDIR}/????????_fileMD5db.csv" | tail -1`
    #filesdb_202001260018.csv
    echo "Trying to find MD5DB file."
    ls -1rt "${FILEMD5DBDIR}/"filesdb_????????????.csv | tail -1
    FILEMD5DB=`ls -1rt "${FILEMD5DBDIR}/"filesdb_????????????.csv | tail -1`
  fi 
fi

if test ! -f "${FILEMD5DB}"; then
  echo "Unable to find MD5 db file. ('${FILEMD5DB}')"
  exit 131
fi

# Type of match todo on the db
MATCHTYPE=MD5PLUS
#  MD5PLUS - Match MD5Sum first and then all other fields
#  NAME - just match the name
#  MD5 - just match the MD5 Sum
#  NAMEMD5 - match name then the MD5 Sum

#if test $# -ge 1; then
#  SEARCHFOR=$1
#else
#  usage
#  exit 130
#fi

echo "Doing '${MATCHTYPE}' match."

while test $# -ge 1
do
  AFILE=$1
  MATCHES=""

  if test -f "${AFILE}"; then
    echo "File: '${AFILE}'"

    case ${MATCHTYPE} in
      MD5PLUS)
        # we need to check that the file isn't empty first.. 0 size files have a md5sum of d41d8cd98f00b204e9800998ecf8427e
        FILEMD5=`md5sum "${AFILE}"|cut -d\  -f1`
        if test "${FILEMD5}" = "d41d8cd98f00b204e9800998ecf8427e"; then
          echo " *Empty* file, MD5Sum not possbile."
          MATCHES=""
        else
          #echo "Md5Sum '${FILEMD5}'"
          MATCHES=`grep ${FILEMD5} "${FILEMD5DB}"`
        fi
      ;;
      *)
        # look for filename.....
        FILENAME=`basename ${AFILE}`
        MATCHES=`grep "${FILENAME}" "${FILEMD5DB}"`
      ;;
    esac
  
  else
    echo "File '${AFILE}' not found, or not a file."
  fi

  if test -n "${MATCHES}"; then
    MCNT=`echo ${MATCHES} | wc -l`
    echo " *Mactch* (${MCNT}) found"
    echo "${MATCHES}" | tail -1
    EXIST_STATUS=0
  else
    echo " *No* match."
  fi
   
  #echo "Count: $#"
  shift
done
