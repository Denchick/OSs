#!/bin/bash
# clear_path.sh: выводит список всех существующих директорий из PATH, в которых есть исполняемые файлы.
# СКАЗАЛИ, ЧТО РЕШЕНИЕ ОТСТОЙ, т.к. datamash все решает, а нужно самому
# ----------------------------------------------------------------------------------------------------

E_INCORRECT_ARG=1
E_INCORRECT_COUNT_ARG=2
E_LOG_FILE_DOES_NOT_EXIST=3

print_help() 
{
   echo "using: $0 [-s] SOURCE [-f] LOG_FILE"
   echo "$0 выводит медиану по времени обработки запроса для указанного SOURCE."
   echo "(по умолчанию поиск по всем запросам)"

}
#-----------------------------------------------------------------------------------------------------

# Check that get at least 1 parameter
if [ $# -lt 1 ]; then
   echo "Count of params is not correct! Expected at least 1 but got $#"
   echo "for help type '$0 -h' or '$0 --help'"
   exit $E_INCORRECT_COUNT_ARGS
fi

SOURCE="[/a-zA-Z0-9]+"
# Option parser, the order doesn't matter
while [ $# -gt 0 ]; do
	case "$1" in
		-s|--source)
            SOURCE=$2
            shift 2
            ;;
		-f|--file)
            FILE=$2
            shift 2
            ;;
        -h|--help)
            print_help
            exit
            ;;
        *)
			echo "Unrecognized parametr: $1"
			print_help
            exit $E_INCORRECT_ARG
            ;;
    esac
done

# Check that file exists
if ! [ -e $FILE ]; then
   echo "Log file $FILE does not exist."
   echo "For help type '$0 -h' or '$0 --help'"
   exit $E_LOG_FILE_DOES_NOT_EXIST
fi
#-----------------------------------------------------------------------------------------------------


CORRECT_LINES_REGEXP="(WARN|INFO|WARN|DEBUG|ERROR|FATAL)\s+\| \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2} \| (25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}\s+\| $SOURCE \| \d+"

grep -P "$CORRECT_LINES_REGEXP" $FILE | awk '{ print $NF, $0 }' | datamash -W --sort median 1