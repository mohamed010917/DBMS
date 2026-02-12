
source validate.sh
echo "use Database"



if [ -d "$HOME/DBMS/databases/$1" ]; then
    clear 
    while [ true ]
    do
        read -p "$1> " input
        words=($input)

        if [[ "${words[0]}" == "create" && "${words[1]}" == "table" ]]; then

                file="$HOME/DBMS/databases/$1/${words[2]}"

                if [ -f "$file" ]; then
                        echo "Table exists"

                else
                        cols=("${words[@]:3}")

                        names=()
                        types=()

                        for c in "${cols[@]}"
                        do
                        IFS=':' read name type <<< "$c"
                        names+=("$name")
                        types+=("$type")
                        done

                        touch "$file"

                        echo "$(IFS=:; echo "${names[*]}")" > "$file"
                        echo "$(IFS=:; echo "${types[*]}")" >> "$file"

                        read -p "Primary Key column > " pk
                        echo "$pk" >> "$file"
                fi


        elif [ "${words[0]}" == "list" ]; then
            ls -1 "$HOME/DBMS/databases/$1"

        elif [[ "${words[0]}" == "drop" && "${words[1]}" == "table" ]]; then
            if [ -f "$HOME/DBMS/databases/$1/${words[2]}" ]; then
                rm "$HOME/DBMS/databases/$1/${words[2]}"
                echo "Table Deleted "
            else
                echo "Table Not exists"
            fi

        elif [[ "${words[0]}" == "insert" && "${words[1]}" == "into" ]]; then

                if [ -f "$HOME/DBMS/databases/$1/${words[2]}" ]; then

                        file="$HOME/DBMS/databases/$1/${words[2]}"

                        IFS=':' read -ra cols  <<< "$(sed -n '1p' "$file")"
                        IFS=':' read -ra types <<< "$(sed -n '2p' "$file")"
                        pk="$(sed -n '3p' "$file")"

                        col=()

                        for i in "${!cols[@]}"
                        do
                        read -p "${cols[$i]} (${types[$i]}) > " var

                     if ! validate_value "${types[$i]}" "$var"; then
                        echo "Invalid value for type ${types[$i]}"
                        continue 2
                     fi


                        col+=("$var")
                        done

                        line=$(IFS=:; echo "${col[*]}")

                        pk_index=-1
                        for i in "${!cols[@]}"
                        do
                        if [ "${cols[$i]}" == "$pk" ]; then
                                pk_index=$i
                                
                        fi
                        done

                        pk_value="${col[$pk_index]}"

                        if tail -n +4 "$file" | cut -d: -f$((pk_index+1)) | grep -qx "$pk_value"; then
                        echo "Primary Key duplicate"
                        else
                        echo "$line" >> "$file"
                        clear
                        echo "column add"
                        fi
                fi


        elif [ "${words[0]}" == "select" ]; then
                
                file="$HOME/DBMS/databases/$1/${words[1]}" 
                if [ -f $file ] ; then
                column -t -s: "$file" | head -1
                column -t -s: "$file" | tail +4
                else
                echo "Table Not Found "
                fi
               
        elif [ "${words[0]}" == "delete" ]; then

                file="$HOME/DBMS/databases/$1/${words[1]}"

                if [ -f "$file" ]; then

                    
                        IFS=':' read -ra cols <<< "$(sed -n '1p' "$file")"

                        echo "Columns:"
                        for c in "${cols[@]}"
                        do
                        echo "- $c"
                        done

                    
                        read -p "Enter column to search by > " search_col

                        col_index=-1
                        for i in "${!cols[@]}"
                        do
                        if [ "${cols[$i]}" == "$search_col" ]; then
                                col_index=$i
                        fi
                        done

                        if [ "$col_index" -eq -1 ]; then
                        echo "Column not found"
                        exit
                        fi

                        read -p "Enter value to delete > " val

                        awk -F: -v v="$val" -v idx="$((col_index+1))" '
                        NR<=3 {print; next}
                        $idx!=v {print}
                        ' "$file" > temp && mv temp "$file"

                        echo "Data Deleted"

                fi



        elif [ "${words[0]}" == "update" ]; then
                file="$HOME/DBMS/databases/$1/${words[1]}"

                if [ -f "$file" ]; then

                        IFS=':' read -ra cols  <<< "$(sed -n '1p' "$file")"
                        IFS=':' read -ra types <<< "$(sed -n '2p' "$file")"
                        pk="$(sed -n '3p' "$file")"

                        pk_index=-1
                        for i in "${!cols[@]}"
                        do
                                if [ "${cols[$i]}" == "$pk" ]; then
                                        pk_index=$i
                                fi
                        done

                        read -p "Enter PK value to update > " target_pk

                        new_row=()

                        for i in "${!cols[@]}"
                        do
                                read -p "new ${cols[$i]} (${types[$i]}) > " var

                       
                                if ! validate_value "${types[$i]}" "$var"; then
                                        echo "Invalid value for type ${types[$i]}"
                                        continue 2
                                fi     
                                

                                new_row+=("$var")
                        done
                        dup=$(tail -n +4 "$file" | cut -d: -f$((pk_index+1)) | grep -x "$new_pk" | wc -l)
                        if [ "$dup" -gt 0 ]; then
                                echo "Error: Primary Key already exists"
                                continue
                        fi

                        newline=$(IFS=:; echo "${new_row[*]}")

                        awk -F: -v pkv="$target_pk" \
                        -v idx="$((pk_index+1))" \
                        -v newl="$newline" '
                        NR<=3 {print; next}
                        $idx==pkv {print newl; next}
                        {print}
                        ' "$file" > temp && mv temp "$file"

                        echo "updated successfully"

                fi

        elif [ "${words[0]}" == "exit" ]; then
             break 
        elif [ "${words[0]}" == "clear" ]; then
             clear 
             continue 
        else
           echo "Syntax error"
        fi
    done

else
    echo "Database   Dont exist "
fi

