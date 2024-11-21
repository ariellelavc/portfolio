-- create database

-- drop database if exists lc;

create database lc;

use lc;

create table if not exists employee (id int, salary int);

truncate table employee;

insert into employee (id, salary) values (1, 100), (2,200), (3, 300);

drop function if exists getnthhighestsalary;

create function getNthHighestSalary(N int) returns int
deterministic
begin
declare m int;
set m=N-1;
return (
ifnull((select distinct salary from employee order by salary desc limit m, 1), null)
);
end

set @highest = getNthHighestSalary(2) ;

select @highest;   --result 200

set @highest = getNthHighestSalary(4) ;

select @highest; --result null
