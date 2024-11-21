/*CREATE TABLE `lc`.`bank_transactions` (`id` INTEGER DEFAULT '0',`created_at` DATETIME,`transaction_value` FLOAT, PRIMARY KEY (`id`));

-- sample insert
insert into bank_transactions (id, created_at, transaction_value) values  
(1, curdate(), 100), (2, date_add(curdate(), INTERVAL 1 MINUTE),  200), (3, date_add(curdate(), INTERVAL 1 HOUR), 300);

-- data.csv for querying
*/

-- SUM OVER
with running_total as (
select created_at, 
transaction_value,  
sum(transaction_value) over (partition by date(created_at) order by created_at range between unbounded preceding and current row) as run_total_per_day,
sum(transaction_value) over (partition by date(created_at) order by date(created_at) range between unbounded preceding and current row) as total_per_day,
sum(transaction_value) over (order by created_at range between unbounded preceding and current row) as run_total 
from bank_transactions) select * from running_total;

-- RANK OVER
with top2_transactions as (
select created_at, 
transaction_value, 
rank() over (partition by date(created_at) order by transaction_value desc) as ranking from bank_transactions)
select created_at, transaction_value from top2_transactions where ranking in (1,2);

-- DENSE_RANK OVER
with last_transactions as (
select *, dense_rank() over (partition by date(created_at) order by created_at desc) as ranking from bank_transactions) 
select created_at, transaction_value, id from last_transactions where ranking = 1;

-- LAST_VALUE OVER, ROW_NUMBER OVER
with last_transactions as (
select created_at as transaction_date, 
last_value(transaction_value) over (partition by date(created_at) order by created_at desc) as last_daily_transactions, 
row_number() over (partition by date(created_at) order by created_at desc) as row_num 
from bank_transactions) 
select transaction_date, last_daily_transactions from last_transactions where row_num = 1;
