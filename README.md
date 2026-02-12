# DBMS
DBMS Bash Project Documentation



write dbms.sh to run the program



1. Databases Commands

-Create Database

    create database <name>
    after create return you to use database


Show All Databases

    show databases


Use Database

    use <dbname>


Drop Database

    drop database <name>


Exit Program

    exit


Clear Screen

    clear

2. Database Tables Operations

-Create Table 

    create table name <colname:datatype> <colname:datatype> ...


    Then choose the primary key.

-List Tables

    list


-Drop Table

    drop table <name>


-Insert Data

    insert into <tablename>


    The program will ask you to enter the values for each column.

-Select Data

    select <tablename>


-Delete Records

    delete <tablename>


    The program will ask for:

    column (key) to search

    value to match
    Then it deletes all matching records.

-Update Records

    update <tablename>


    The program will ask for:

    column to search

    value to match

    new value to update

-Exit / Clear

    exit
    clear
