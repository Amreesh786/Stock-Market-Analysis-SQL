use company1

-- first we convert given bajaj csv file into mysql tale name mytable in database
-- then perform given operation
alter table mytable
add NewDate date;

describe mytable

SET SQL_SAFE_UPDATES = 0;
update mytable set NewDate = str_to_date(date, '%d-%M-%Y');

create table bajaj1 as (select NewDate as `Date`, `Close_Price` as  Close_Price , 
avg(Close_Price) over (order by NewDate asc rows 19 preceding) as `20 Day MA`,
avg(Close_Price) over (order by NewDate asc rows 49 preceding) as `50 Day MA`,
row_number() over (order by `NewDate` ) as `Number of rows`
from mytable);
  
select * from bajaj1
limit 5;
delete from bajaj1
where  `Number of rows` < 50;
alter table bajaj1 drop column `Number of rows`

-- for second table eicher motors

select * from EicherMotor
limit 5

alter table EicherMotor
add NewDate date
SET SQL_SAFE_UPDATES = 0;
update eichermotor set NewDate = str_to_date(date, '%Y-%M-%D');
create table eicher1 as (select NewDate as `Date`, `Close_Price` as `Close Price`, 
avg(Close_Price) over (order by NewDate asc rows 19 preceding) as `20 Day MA`,
avg(Close_Price) over (order by NewDate asc rows 49 preceding) as `50 Day MA`,
row_number() over (order by `NewDate` ) as `Number of rows`
from eichermotor);

select * from eicher1
delete from eicher1
where  `Number of rows` < 50;
alter table eicher1 drop column `Number of rows`

-- 3rd table hero motocorp

alter table heromotocorp
add NewDate date

SET SQL_SAFE_UPDATES = 0;
update heromotocorp set NewDate = str_to_date(date, '%Y-%M-%D');
create table heromotocorp1 as (select NewDate as `Date`, `Close_Price` as `Close Price`, 
avg(Close_Price) over (order by NewDate asc rows 19 preceding) as `20 Day MA`,
avg(Close_Price) over (order by NewDate asc rows 49 preceding) as `50 Day MA`,
row_number() over (order by `NewDate` ) as `Number of rows`
from heromotocorp);
SET SQL_SAFE_UPDATES = 1;

select * from heromotocorp1
delete from heromotocorp1
where  `Number of rows` < 50;
alter table heromotocorp1 drop column `Number of rows`

-- 4 table infosys

alter table infosys
add NewDate date

SET SQL_SAFE_UPDATES = 0;
update infosys set NewDate = str_to_date(date, '%Y-%M-%D');
create table infosys1 as (select NewDate as `Date`, `Close_Price` as `Close Price`, 
avg(Close_Price) over (order by NewDate asc rows 19 preceding) as `20 Day MA`,
avg(Close_Price) over (order by NewDate asc rows 49 preceding) as `50 Day MA`,
row_number() over (order by `NewDate` ) as `Number of rows`
from infosys);

SET SQL_SAFE_UPDATES = 1;

select * from infosys1
delete from infosys1
where  `Number of rows` < 50;
alter table infosys1 drop column `Number of rows`

-- 5th table

alter table tcs
add NewDate date

SET SQL_SAFE_UPDATES = 0;
update tcs set NewDate = str_to_date(date, '%Y-%M-%D');
create table tcs1 as (select NewDate as `Date`, `Close_Price` as `Close Price`, 
avg(Close_Price) over (order by NewDate asc rows 19 preceding) as `20 Day MA`,
avg(Close_Price) over (order by NewDate asc rows 49 preceding) as `50 Day MA`,
row_number() over (order by `NewDate` ) as `Number of rows`
from tcs);
SET SQL_SAFE_UPDATES = 1;
select * from tcs1;
delete from tcs1
where  `Number of rows` < 50;
alter table tcs1 drop column `Number of rows`;

-- 6th table

alter table tvsmotor
add NewDate date

SET SQL_SAFE_UPDATES = 0;
update tvsmotor set NewDate = str_to_date(date, '%Y-%M-%D');
create table tvsmotor1 as (select NewDate as `Date`, `Close_Price` as `Close Price`, 
avg(Close_Price) over (order by NewDate asc rows 19 preceding) as `20 Day MA`,
avg(Close_Price) over (order by NewDate asc rows 49 preceding) as `50 Day MA`,
row_number() over (order by `NewDate` ) as `Number of rows`
from tvsmotor);
SET SQL_SAFE_UPDATES = 1;
select * from tvsmotor1;
delete from tvsmotor1
where  `Number of rows` < 50;
alter table tvsmotor1 drop column `Number of rows`;


---------------------------------------------------------------------------------
select * from infosys
limit 3
-- question 2 master table

create table master select x.NewDate as `Date` , x.`Close_Price` as `Bajaj` , y.Close_price as `TCS`,
z.Close_Price as `TVS` , info.Close_Price as `Infosys` , eiche.Close_Price as `Eicher`,
hero.Close_Price as `Hero` from `mytable` x
inner join `tcs` y on y.NewDate = x.NewDate
inner join `tvsmotor` z on z.NewDate = y.NewDate
inner join `infosys` info on info.NewDate = z.NewDate
inner join `eichermotor` eiche on eiche.NewDate= info.NewDate
inner join `heromotocorp` hero on hero.NewDate = eiche.NewDate ;

select * from master
LIMIT 4;

-----------------------------------------------------------------------
create table temporary_table
select `Date` as Date1,`Close_Price` as `close Price`,
case
		when (`20 Day MA`>`50 Day MA`) then 'Y'
        else 'N'
        end as ShortTermGreater
from bajaj1 
drop table if exists `bajaj2`;
create table bajaj2 as
select date1 AS "Date",`close price` AS "Close Price",
case 
      when first_value(ShortTermGreater) over w = nth_value(ShortTermGreater,2) over w then  'Hold'
	  when nth_value(ShortTermGreater,2) over w = 'Y' then 'Buy'
	  when nth_value(ShortTermGreater,2) over w = 'N' then 'Sell'
	  else 'Hold'
	  end as "Signal" 
	from temporary_table
window w as (order by date1 rows between 1 preceding and 0 following);

drop table temporary_table;
 

---- eicher 2

drop table if exists `temporary_table`;
create table temporary_table
select `Date` as Date1,`Close Price` as `close Price`,
case
		when (`20 Day MA`>`50 Day MA`) then 'Y'
        else 'N'
        end as ShortTermGreater
from eicher1 

drop table if exists `eicher2`;
create table eicher2 as
select date1 AS "Date",`close price` AS "Close Price",
case 
      when first_value(ShortTermGreater) over w = nth_value(ShortTermGreater,2) over w then  'Hold'
	  when nth_value(ShortTermGreater,2) over w = 'Y' then 'Buy'
	  when nth_value(ShortTermGreater,2) over w = 'N' then 'Sell'
	  else 'Hold'
	  end as "Signal" 
	from temporary_table
window w as (order by date1 rows between 1 preceding and 0 following);

select * from eicher2 limit 5
drop table temporary_table;

---  hero 2
drop table if exists `temporary_table`;
create table temporary_table
select `Date` as Date1,`Close Price` as `close Price`,
case
		when (`20 Day MA`>`50 Day MA`) then 'Y'
        else 'N'
        end as ShortTermGreater
from heromotocorp1 

drop table if exists `hero2`;
create table hero2 as
select date1 AS "Date",`close price` AS "Close Price",
case 
      when first_value(ShortTermGreater) over w = nth_value(ShortTermGreater,2) over w then  'Hold'
	  when nth_value(ShortTermGreater,2) over w = 'Y' then 'Buy'
	  when nth_value(ShortTermGreater,2) over w = 'N' then 'Sell'
	  else 'Hold'
	  end as "Signal" 
	from temporary_table
window w as (order by date1 rows between 1 preceding and 0 following);

select * from hero2 limit 5
drop table temporary_table;
---- infosys2

drop table if exists `temporary_table`;
create table temporary_table
select `Date` as Date1,`Close Price` as `close Price`,
case
		when (`20 Day MA`>`50 Day MA`) then 'Y'
        else 'N'
        end as ShortTermGreater
from infosys1 

drop table if exists `infosys2`;
create table infosys2 as
select date1 AS "Date",`close price` AS "Close Price",
case 
      when first_value(ShortTermGreater) over w = nth_value(ShortTermGreater,2) over w then  'Hold'
	  when nth_value(ShortTermGreater,2) over w = 'Y' then 'Buy'
	  when nth_value(ShortTermGreater,2) over w = 'N' then 'Sell'
	  else 'Hold'
	  end as "Signal" 
	from temporary_table
window w as (order by date1 rows between 1 preceding and 0 following);

select * from infosys2 limit 5
drop table temporary_table;
----tcs2

drop table if exists `temporary_table`;
create table temporary_table
select `Date` as Date1,`Close Price` as `close Price`,
case
		when (`20 Day MA`>`50 Day MA`) then 'Y'
        else 'N'
        end as ShortTermGreater
from tcs1 

drop table if exists `tcs2`;
create table tcs2 as
select date1 AS "Date",`close price` AS "Close Price",
case 
      when first_value(ShortTermGreater) over w = nth_value(ShortTermGreater,2) over w then  'Hold'
	  when nth_value(ShortTermGreater,2) over w = 'Y' then 'Buy'
	  when nth_value(ShortTermGreater,2) over w = 'N' then 'Sell'
	  else 'Hold'
	  end as "Signal" 
	from temporary_table
window w as (order by date1 rows between 1 preceding and 0 following);

select * from tcs2 limit 5
drop table temporary_table;

--tvsmotor2
drop table if exists `temporary_table`;
create table temporary_table
select `Date` as Date1,`Close Price` as `close Price`,
case
		when (`20 Day MA`>`50 Day MA`) then 'Y'
        else 'N'
        end as ShortTermGreater
from tvsmotor1 

drop table if exists `tvs2`;
create table tvs2 as
select date1 AS "Date",`close price` AS "Close Price",
case 
      when first_value(ShortTermGreater) over w = nth_value(ShortTermGreater,2) over w then  'Hold'
	  when nth_value(ShortTermGreater,2) over w = 'Y' then 'Buy'
	  when nth_value(ShortTermGreater,2) over w = 'N' then 'Sell'
	  else 'Hold'
	  end as "Signal" 
	from temporary_table
window w as (order by date1 rows between 1 preceding and 0 following);

select * from tvs2 limit 5
drop table temporary_table;
-------------------------------------------------------------------------------

---question 4 user defined

delimiter //

create function getSignal( input date)
returns varchar(50)
deterministic
begin
declare `result` varchar(10);
select `Signal` into result
from bajaj2
where `Date` = input;
return result;
end //
delimiter ;

----------------------------------------------------------------------------