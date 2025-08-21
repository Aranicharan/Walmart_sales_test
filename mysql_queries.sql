show databases
use walmart_db
show tables from walmart_db
select * from walmart
select count(*) from walmart

1. find the different payment methods, number of transactions, number of quantity sold 
select distinct payment_method , count(*) as no_of_transaction ,sum(quantity) from walmart
group by payment_method 
order by payment_method

2.identity the highest rated category in each branch,display the branch name,category ,avg rating

select * from ( 
select branch ,category,avg(rating) as avg_rating ,
dense_rank() over(partition by branch order by avg(rating) desc) as rnk from walmart
group by branch,category
) as ranked_categories
where rnk=1

3. identity the busiest day for each branch based on the no of transaction 

select * from (
select branch,DAYNAME(STR_TO_DATE(date,'%d/%m/%y')) AS formatted_date , count(*) as no_of_trans ,
rank() over(partition by branch order by count(*) desc) as rnk
from walmart
group by branch,DAYNAME(STR_TO_DATE(date,'%d/%m/%y'))
) as busyist
where rnk=1


4.calculate total quantity of items sold per payment method.list payment method and total quantity

select distinct payment_method , count(*) from walmart
group by payment_method

5.determine the avg,min,max rating of category for each city .list the city avg rating ,min rating,max rating .

select city,category,min(rating) , max(rating) from walmart group by city,category

6.Calculate the total profit for each category by considering total_profit as
(unit_price * quantity * profit_margin). List category and total_profit, ordered from highest to lowest profit.

select category ,sum(total* profit_margin) as total_profit from walmart group by category order by sum(total) desc 

7.determine the most common payment method for each branch.display branch and the preferred payment method 

with cte
as (
select branch , payment_method ,count(*) as total_trans ,
rank() over(partition by branch order by count(*) desc) as rnk 
from walmart group by branch , payment_method
) select * from cte where rnk=1

8.categorizes sales into 3 groups morning,afternoon,evening.finding out which of the shift and number of invoices 

select hour(time) as dnfks from walmart

select 
case 
when hour(time) <12 then "morning"
when  hour(time) between 12 and 17 then "afternoon"
else "evening"
end as day_time,
count(*) as no_invoiceid 
from walmart 
group by day_time
order by no_invoiceid desc 
