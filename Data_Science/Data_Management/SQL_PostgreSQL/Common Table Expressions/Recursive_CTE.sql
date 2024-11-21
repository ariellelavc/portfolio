-- Database: hr

-- DROP DATABASE IF EXISTS hr;

CREATE DATABASE hr
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- SCHEMA: hierarchy

-- DROP SCHEMA IF EXISTS hierarchy;

CREATE SCHEMA IF NOT EXISTS hierarchy
    AUTHORIZATION postgres;

-- Table: hierarchy.employee

-- DROP TABLE IF EXISTS hierarchy.employee;

CREATE TABLE IF NOT EXISTS hierarchy.employee
(
    employee_id integer NOT NULL,
    manager_id integer,
    employee_name character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT employee_id PRIMARY KEY (employee_id)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS hierarchy.employee
    OWNER to postgres;

SET search_path TO hierarchy;

INSERT INTO employee (employee_id, manager_id, employee_name)
VALUES (1, NULL, 'John Smith'),
       (2, 1, 'Jane Smith'),
       (3, 1, 'Bob Johnson'),
       (4, 2, 'Mary Jones'),
       (5, 2, 'Bill Williams'),
       (6, 3, 'Susan Brown'),
       (7, 3, 'Joe Davis')
RETURNING *;

-- Recursive Common Table Expression for querying hierarchical data
WITH RECURSIVE employee_hierarchy AS (
	SELECT employee_id, manager_id, employee_name, 1 AS depth
	FROM employee
	WHERE manager_id IS NULL

	UNION ALL

	SELECT e.employee_id, e.manager_id, e.employee_name, eh.depth + 1
	FROM employee e 
	JOIN employee_hierarchy eh
	ON e.manager_id = eh. employee_id
)
SELECT * FROM employee_hierarchy;

/*
-- Output

employee_id	manager_id	employee_name	depth
------------------------------------------------------
1		NULL		John Smith	1
2		1		Jane Smith	2
3		1		Bob Johnson	2
4		2		Mary Jones	3
5		2		Bill Williams	3
6		3		Susan Brown	3
7		3		Joe Davis	3
*/