
-- Part 3 - Business Analysis Queries
-- SQL reports and analytical queries


select
    city,
    count(*) as number_of_customers
    
 from customers
 group by city
 order by number_of_customers desc;
 
 
 select
    city,
    count(*) as number_of_customers,
    round(avg(monthly_income), 2) as average_income
 from customers
 group by city
 order by average_income desc;
 
 
 select
    c.first_name,
    c.last_name,
    a.account_type,
    a.balance
 from customers as c
 join accounts as a
   on c.customer_id= a.customer_id
 order by a.balance desc;
 
 
 select
    c.customer_id,
    c.first_name,
    c.last_name,
    count(a.account_id) as number_of_accounts,
    round(sum(a.balance), 2) as total_balance
 from customers as c
 join accounts as a
    on c.customer_id= a.customer_id
 group by
   c.customer_id,
   c.first_name,
   c.last_name
 order by total_balance desc;
 
 
 select
    c.customer_id,
    c.first_name,
    c.last_name,
    l.loan_type,
    l.principal_amount
 from customers as c
 left join loans as l
    on c.customer_id= l.customer_id
 
 order by c.customer_id;
 
 
 select
    c.customer_id,
    c.first_name,
    c.last_name,
    count(a.account_id) as number_of_accounts
 from customers as c
 join accounts as a
    on c.customer_id= a.customer_id
 group by
   c.customer_id,
   c.first_name,
   c.last_name
 having count(a.account_id)>2
 order by number_of_accounts desc;
    
    
 select 
    c.city,
    round(min(a.balance),2) as minimum_balance,
    round(max(a.balance), 2) as maximum_balance,
    round(avg(a.balance), 2) as average_balance
 from customers as c
 join accounts as a
   on c.customer_id= a.customer_id
 group by c.city
 order by average_balance desc;
 
 
 select
   first_name,
   last_name,
   credit_score
 from customers
 where credit_score > 
 (
   select
       avg(credit_score)
   from customers
 )
 order by credit_score desc;
 
 
 select
    first_name,
    last_name,
    credit_score,
    
    case
	    when credit_score <500 then 'High Risk'
	    when credit_score between 500 and 700 then 'Medium Risk'
	    else 'Low Risk'
	end as risk_cateogory
	
from customers
order by credit_score;


select
  first_name,
  last_name,
  monthly_income,
  rank() over(
     order by monthly_income desc
  )as income_rank
from customers;


select 
   first_name,
   last_name,
   monthly_income,
   
   row_number() over(
     order by monthly_income desc
   ) as row_num
   
 from customers;

 
select
   first_name,
   last_name,
   monthly_income,
   
   dense_rank() over(
      order by monthly_income desc
   ) as dense_rank
   
 from customers;
 

 
 select
    b.branch_name,
    count(a.account_id) as number_of_accounts,
    round(sum(a.balance), 2) as total_balance,
    round(avg(a.balance), 2) as average_balance
from branches as b
join accounts as a
    on b.branch_id = a.branch_id
group by
    b.branch_name
order by total_balance desc;


select
   c.customer_id,
   c.first_name,
   c.last_name,
   count(a.account_id) as number_of_accounts,
   round(sum(a.balance),2) as total_balance
   
 from customers as c
 join accounts as a
    on c.customer_id = a.customer_id 
    
 group by
   c.customer_id,
   c.first_name,
   c.last_name
   
 order by total_balance desc
 
 limit 10;
 
 
 #VIP korisnici

select
    c.customer_id,
    c.first_name,
    c.last_name,
    count(a.account_id) as number_of_accounts,
    round(sum(a.balance), 2) as total_balance

from customers as c

join accounts as a
    on c.customer_id = a.customer_id

group by
    c.customer_id,
    c.first_name,
    c.last_name

order by total_balance desc

limit 10;


#Koji tip transakcije pravi najveći ukupan promet u banci?

select
   transaction_type,
   count(*) as number_of_transactions,
   round(sum(amount), 2) as total_amount,
   round(avg(amount), 2) as average_amount
from transactions
group by transaction_type
order by total_amount desc;



#Želim da vidim svakog klijenta i da znam kako se njegov prihod poredi sa prosečnim prihodom u njegovom gradu.

select
   first_name,
   last_name,
   city,
   monthly_income,
   
   round(
      avg(monthly_income) over (
          partition by city
      ),
      2
   ) as city_average_income
   
 from customers
 
 order by city, monthly_income desc;


 
 #Za svaku filijalu pronađi klijente koji imaju iznadprosečno stanje na računima
 
 with customer_balance as(
   select 
      c.customer_id,
      c.first_name,
      c.last_name,
      a.branch_id,
      round(sum(a.balance), 2) as total_balance
      
    from customers c
    join accounts a
       on c.customer_id= a.customer_id 
    
    group by
      c.customer_id,
      c.first_name,
      c.last_name,
      a.branch_id
    
 
 ),
 
 branch_comparison as (

    select

        customer_id,
        first_name,
        last_name,
        branch_id,
        total_balance,

        round(

            avg(total_balance) over (

              partition by branch_id

            ),

            2

        ) as average_branch_balance

    from customer_balance

)

select

    customer_id,
    first_name,
    last_name,
    branch_id,
    total_balance,
    average_branch_balance

from branch_comparison

where total_balance > average_branch_balance

order by branch_id, total_balance desc;
 

 
#Koliko novca ukupno ulazi na račune, a koliko izlazi?

select
   transaction_direction,
   count(*) as number_of_transactions,
   round(sum(amount), 2) as total_amount,
   round(avg(amount), 2) as average_amount
 from transactions
 group by transaction_direction
 order by total_amount desc;



select 
   loan_type,
   count(*) as number_of_loans,
   round(sum(principal_amount), 2) as total_loan_amount,
   round(avg(principal_amount), 2) as average_loan_amount,
   round(avg(interest_rate), 2) as average_interest_rate
 
 from loans
 group by loan_type
 order by total_loan_amount desc;





 
 
 
 


