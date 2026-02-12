echo  "create databse"

if [ -d "$HOME/DBMS/databases/$1" ]; then
echo "Database Alerdy  exist ❌"
else
mkdir "$HOME/DBMS/databases/$1"
use.sh "$1"

fi
