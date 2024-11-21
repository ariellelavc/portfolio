-- Database: cx

-- DROP DATABASE IF EXISTS cx;

CREATE DATABASE cx
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-- SCHEMA: cx

-- DROP SCHEMA IF EXISTS cx ;

CREATE SCHEMA IF NOT EXISTS cx
    AUTHORIZATION postgres;

-- Table: cx.currency_prices

-- DROP TABLE IF EXISTS cx.currency_prices;

CREATE TABLE IF NOT EXISTS cx.currency_prices
(
    date date NOT NULL,
    price numeric(5,4) NOT NULL,
    CONSTRAINT date PRIMARY KEY (date)
)

TABLESPACE pg_default;

ALTER TABLE IF EXISTS cx.currency_prices
    OWNER to postgres;

SET search_path TO cx;

INSERT INTO currency_prices (date, price)
VALUES ('2024-10-06', 1.3616),
	   ('2024-10-07', 1.3647),
	   ('2024-10-08', 1.3710),
	   ('2024-10-09', 1.3739),
	   ('2024-10-10', 1.3762),
	   ('2024-10-13', 1.3795),
	   ('2024-10-14', 1.3774),
	   ('2024-10-15', 1.3750),
	   ('2024-10-16', 1.3794),
	   ('2024-10-17', 1.3800),
	   ('2024-10-20', 1.3831),
	   ('2024-10-21', 1.3816),
	   ('2024-10-22', 1.3836),
	   ('2024-10-23', 1.3854),
	   ('2024-10-24', 1.3891),
	   ('2024-10-27', 1.3889),
	   ('2024-10-28', 1.3914),
	   ('2024-10-29', 1.3903),	   
	   ('2024-10-30', 1.3933),
	   ('2024-10-31', 1.3950)
RETURNING *;

-- Time series analysis using window functions: NTILE OVER(), AVG OVER() and LAG OVER()
-- create 4 tiles for each week and calculate weekly average of the currency exchange price
-- calculate 5-days moving average of the currency exchange price
-- calculate day-over-day percent change

WITH cx_time_series AS (
	SELECT 
	date, 
	price, 
	NTILE(4) OVER (ORDER BY date) as week,
	AVG(price) OVER (ORDER BY date ROWS BETWEEN 5 PRECEDING AND CURRENT ROW) AS moving_average,
	((price - LAG(price) OVER (ORDER BY date))/ LAG(price) OVER (ORDER BY date)) * 100 AS percent_change
	FROM currency_prices
)
SELECT date, 
	   price, 
	   week, 
	   ROUND(AVG(price) OVER (PARTITION BY week), 4) as weekly_average, 
	   ROUND(moving_average, 4) as five_days_moving_average, 
	   COALESCE(ROUND(percent_change, 2), 0) as daily_percent_change
FROM cx_time_series; 