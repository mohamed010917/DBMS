echo "Delete database "

if [ -d "$HOME/DBMS/databases/$1" ]; then
    rm -r "$HOME/DBMS/databases/$1"
    echo "Database Deleted"
else
    echo "Database does not exist ❌"
fi
