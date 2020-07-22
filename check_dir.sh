#!/bin/bash

DESCRIPTION=" Progam to search the MD5 Index file"
# For every file see if there is a current dup in the db ? 
# First see if there is a file by same name in db ? 
# or just go for the MD5 sum, 
#  md5 sum file
#  search for md5 in file
#  see if name, size and maybe date match...

EXIT_STATUS=0 #Guess things doing go good.

SCRIPT=`basename $0`
DESCRIPTION="Script to search md5 db for all files in current hierarchy"
VERSION="2.0.2-goeko-20200721235547"
INDEXDIR=${HOME}
export NOMATCH=0
export VERBOSE=/bin/false
export FILECNT=0
SEARCHFROMHERE=.

function usage {
  echo "Usage: ${SCRIPT} [-i|--index DIRECTORY_BASE_OF_FILEMD5_INDEX] [--verbose] "
  echo "Description: ${DESCRIPTION}"
}

echo "$# $*"
#check if index file in arguments...
# we are super broken, only one argumet
if test $# -ge 1 ; then
#for ARG in $*
while test $#  -ge 1
do
  ${VERBOSE} && echo "Arg '$1'"
  case "$1" in
    -i|--index) # Specify an index file
      echo "Setting FileMD5 index"
      # make sure a second argument...
      INDEXDIR=$2
      shift
      shift
    ;;
    -v|--verbose)
      echo "Setting verbose"
      VERBOSE=/bin/true
      shift
    ;;
    *)
      # if last argument, must be dir... 
      ##if ${ARGCNT} = $# ; then
      #  if test $# -ge 1; then
      #    SEARCHFROMHERE=${ARG}
      #  else
          SEARCHFROMHERE=.
      #  fi
      #else
        echo "Unknown option '$1' ignoring"
        usage
      #fi
    ;;
  esac
done
fi
 
#Locate the db file
# if no db option, or other directory to search look @home
if test -d "${INDEXDIR}/.filemd5db"; then
  # find the newest version of the db file ?
  FILEMD5DB="${INDEXDIR}/.filemd5db/latest.csv"
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

if test ! -d "${SEARCHFROMHERE}" ; then
  echo "Not a directory."
  exit 130
fi


echo "Searching index '${FILEMD5DB}'"
echo "Searching file from '${SEARCHFROMHERE}' and below."
echo "Doing '${MATCHTYPE}' match."

#find "${SEARCHFROMHERE}/" -depth -print | while read AFILE
while read AFILE
#for AFILE in `find "${SEARCHFROMHERE}/" -depth -print`
do
  MATCHES=""
  if test ! -f "${AFILE}"; then
    echo "Not a file '${AFILE}', skipping"
  else
    ((FILECNT++))
    echo -e "File: '${AFILE}' \c"
    case ${MATCHTYPE} in
      MD5PLUS)
        FILEMD5=`md5sum "${AFILE}"|cut -d\  -f1`
        # add verbose to print this
        ${VERBOSE} && echo ""
        ${VERBOSE} && echo "Md5Sum '${FILEMD5}'"
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
      # add verbose to print this
      ${VERBOSE} && echo "${MATCHES}"
      EXIST_STATUS=0
    else
      echo "no match"
      #let NOMATCH++
      ((NOMATCH++ ))
      #export NOMATCH
    fi
  fi
done < <(find "${SEARCHFROMHERE}/" -depth -print)

echo "Checked '${FILECNT}'"
if test ${NOMATCH} -ne 0 ; then
  echo "no match for '${NOMATCH}' files, see above output."
  let TMP=$NOMATCH*100
  let PERCENT_MATCH=$TMP/$FILECNT
  echo "${PERCENT_MATCH}% file(s) NOT found."
fi


echo "Run complete."

exit ${EXIST_STATUS}
