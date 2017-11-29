#!/bin/bash
# resizer.sh: пропорционально изменяет размеры всех .jpg-картинок 
# в директории.
# ----------------------------------------------------------------------------
ARGS=3
E_INCORRECTCOUNTARGS=60
E_INCORRECTWIDTH=61
E_INCORRECTHEIGHT=62
E_INCORRECTDIRECTORY=63

function print_help() 
{
   echo "using: $0 [width] [height] [directory]"
   echo "$0 пропорционально изменяет размеры всех \"больших\""
   echo "по ширине или высоте .jpg-картинок в директории."

}
# ----------------------------------------------------------------------------
# Checking for help

if [[ "$1" == "-h"  ||  "$1" == "--help" ]] ; then
   print_help
   exit 0
fi

# ----------------------------------------------------------------------------
# Checking for correct arguments


WIDTH=$1
HEIGHT=$2
DIRECTORY=$3

if [[ $# != "$ARGS" ]]; then
   echo "Count of params is not correct! Expected 3 but got $#"
   echo "for help type '$0 -h' or '$0 --help'"
   exit $E_INCORRECTCOUNTARGS
fi

if ! [[ $WIDTH =~ ^-?[0-9]+$ ]]; then
  echo "$WIDTH is not a number!"
  echo "for help type '$0 -h' or '$0 --help'"  
  exit $E_INCORRECTWIDTH
fi

if ! [[ $HEIGHT =~ ^-?[0-9]+$ ]]; then
   echo "$HEIGHT is not a number!"
   echo "for help type '$0 -h' or '$0 --help'"
   exit $E_INCORRECTHEIGHT
fi

if ! [ -d "$DIRECTORY" ]; then
   echo "Directory $DIRECTORY does not exists."
   echo "for help type '$0 -h' or '$0 --help'"
   exit $E_INCORRECTDIRECTORY
fi

# ----------------------------------------------------------------------------

FILES=$(find "$DIRECTORY" -type f -name "*.jpg")

for filename in $FILES; do
   echo "Converting $filename..."
   convert "$filename" -resize "${WIDTH}x${HEIGHT}>" "$filename"
   echo "OK"
done