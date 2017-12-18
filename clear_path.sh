#!/bin/bash
# clear_path.sh: выводит список всех существующих директорий из PATH, в которых есть исполняемые файлы.
# ----------------------------------------------------------------------------------------------------

ARGS=2
E_INCORRECTCOUNTARGS=60
E_INCORRECTARG=61

print_help() 
{
   echo "using: $0 [-p] PATH [-h]"
   echo "$0 выводит список всех существующих директорий из PATH,"
   echo "в которых есть исполняемые файлы."

}

CURRENT_PATH=$PATH

#-----------------------------------------------------------------------------------------------------
# Option parser, the order doesn't matter
while [ $# -gt 0 ]; do
	case "$1" in
		-p|--path)
            CURRENT_PATH=$2
            shift 2
            ;;
        -h|--help)
            print_help
            exit
            ;;
        *)
			echo "Unrecognized parametr: $1"
			print_help
            exit $E_INCORRECTARG
            ;;
    esac
done

#-----------------------------------------------------------------------------------------------------
# Checking for correct parameters
if [[ $# != "$ARGS" && $# != "0" ]]; then
   echo "Count of params is not correct! Expected ${ARGS} or 0 but got $#"
   echo "for help type '$0 -h' or '$0 --help'"
   exit $E_INCORRECTCOUNTARGS
fi
#-----------------------------------------------------------------------------------------------------

IFS=:
TEMPORARY_PATH=""
for dir in $CURRENT_PATH; do 
	if [ -d "$dir" ]; then
		for file in "$dir"/*; do
			if [ -f "$file" ] && [ -x "$file" ]; then 
				TEMPORARY_PATH=$TEMPORARY_PATH$dir:
				break
			fi
		done
	fi
done
IFS=
echo "$TEMPORARY_PATH"
