#!/bin/bash
# shard_collect.sh: выводит список всех подкаталогов первого уровня, в которых не открыт ни один файл.
# ----------------------------------------------------------------------------------------------------

E_INCORRECTARG=1
E_DIRECTORYNOTFOUND=2

print_help() 
{
   echo "using: $0 [-d] DIRECTORY [-h]"
   echo "$0 выводит список подкаталогов первого уровня,"
   echo "в которых не открыт ни один файл."
}

#-----------------------------------------------------------------------------------------------------
# Option parser, the order doesn't matter
SEARCHDIR="."
while [ $# -gt 0 ]; do
	case "$1" in
		-d|--directory)
            SEARCHDIR=$2
            shift 2
            ;;
        -h|--help)
            print_help
            exit
            ;;
        *)
			echo "Unrecognized parameter: $1"
			print_help
            exit $E_INCORRECTARG
            ;;
    esac
done

if ! [[ -d $SEARCHDIR ]]; then
	echo "Input directory $SEARCHDIR not found"
	exit $E_DIRECTORYNOTFOUND
fi

ACTIVE=$(lsof +D "$SEARCHDIR" 2> /dev/null)
find "$SEARCHDIR" -mindepth 1 -maxdepth 1 -type d | while read -r DIR
do
	if echo "$ACTIVE" | grep -q "$DIR"; then
		echo "$DIR"
	fi
done
