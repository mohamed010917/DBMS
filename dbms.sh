#!/bin/bash

DB_PATH="$HOME/DBMS/databases"




while true
do
    read -p "DBMS> " input

    words=($input)

    cmd="${words[0]}"
    subcmd="${words[1]}"
    name="${words[2]}"

    if [[ "$cmd" == "create" && "$subcmd" == "database" ]]; then
        creat.sh "$name"

    elif [[ "$cmd" == "show" && "$subcmd" == "databases" ]]; then
        ls -1 "$DB_PATH"

    elif [[ "$cmd" == "use" ]]; then
        use.sh "$subcmd"

    elif [[ "$cmd" == "drop" && "$subcmd" == "database" ]]; then
        rmdb.sh "$name"

    elif [[ "$cmd" == "exit" ]]; then
        break
    elif [[ "$cmd" == "clear" ]]; then
        clear
        continue

    else
        echo "Syntax error"
    fi

done
