-- Easy questions


-- 1. Definitions

-- Data: Raw facts or figures that have no meaning on their own (e.g., "34", "Jamshid").
-- Database: A structured collection of data stored and accessed electronically.
-- Relational Database: A type of database that stores data in tables with predefined relationships between them.
-- Table: A collection of related data entries organized in rows and columns.


-- 2. Five Key Features of SQL Server

-- It stores, manages, and processes data using SQL (Structured Query Language).
-- Can create and manage multiple databases. Relational database engine.
-- Integration and ETL tools.
-- SQL Server lets you control who can see or change the data using usernames and passwords.
-- Containts SQL Server Management Studio (SSMS), a free tool with a friendly interface.
-- SSMS suggests keywords and shows errors to help beginners write better SQL.
-- SQL Server lets you make backups of your database and restore them if needed — useful for safety.
-- Data types & JSON/XML support.


-- 3. Authentication Modes in SQL Server

-- Windows Authentication: Uses the Windows credentials of the user. (DESKTOP-... or WIN-...)
-- SQL Server Authentication: Requires username and password set within SQL Server.



-- Medium questions


-- 4. Create a New Database: "SchoolDB":

CREATE DATABASE SchoolDB;


-- 5. Create "Students" Table:

-- Switch to the new database and run:

USE SchoolDB;

CREATE TABLE Students (StudentID INT PRIMARY KEY, Name VARCHAR(50), Age INT);


-- 6. Difference Between SQL Server, SSMS, and SQL

-- SQL Server - A Relational Database Management System (RDBMS) developed by Microsoft to store, retrieve, and manage data.

-- SSMS (SQL Server Management Studio)- A GUI tool used to manage SQL Server.
-- It allows users to run queries, manage databases, back up, and restore, using SQL code.

-- SQL (Structured Query Language) - The language used to interact with databases, e.g., for querying, updating, creating tables, etc.



-- Hard questions


-- 7. Types of SQL Commands

-- DQL (Data Query Language)
-- Description: Queries data from tables.
-- Example: SELECT * FROM Students; (only SELECT)

-- DML (Data Manipulation Language)
-- Description: Modifies data.
-- Examples: INSERT, UPDATE, DELETE

-- DDL (Data Definition Language)
-- Description: Defines database structure.
-- Examples: CREATE, ALTER, DROP

-- DCL (Data Control Language)
-- Description: Manages access.
-- Examples: GRANT, REVOKE

-- TCL (Transaction Control Language)
-- Description: Controls transactions.
-- Examples: COMMIT, ROLLBACK


-- 8. Insert Three Records into "Students" Table

INSERT INTO Students VALUES (1, 'Jaxongir', 20), (2, 'Feruza', 22), (3, 'Azizbek', 19);


-- 9. Restore "AdventureWorksDW2022.bak" File

-- Steps:
-- 1) Download the backup file
-- 2) Place the .bak file in a location accessible by SQL Server (e.g., "C:\Backups\").
-- 3) Open SSMS and connect to your server.
-- 4) Right-click Databases > Restore Database…
-- 5) Choose:
--     - Source: Device
--     - Click the "..." > Add > Select your ".bak" file. It has to be located in the "C:\Backups\" folder.
-- 6) Click "OK" to restore.
-- 7) Refresh the Databases tab if it's not there yet.
-- 8) Done. Your database should be successfully restored.
