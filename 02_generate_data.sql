
-- Part 2 - Data Generation
-- Generates realistic banking data


insert into customers(
  first_name,
  last_name,
  date_of_birth,
  city,
  employment_status,
  monthly_income,
  credit_score,
  customer_since,
  customer_status
)

select 
  
  (
     array[
         'Ana',
         'Stefan',
         'Eleonora',
         'Uros',
         'Mina'
      
     ]
  ) [floor(random() *5 +1 ):: integer],
  
  (
    array[
       'Rankovic',
       'Matic',
       'Dimitrijevic',
       'Stanojevic',
       'Sekulic'
    ]
  
  )[floor(random() *5 +1 ):: integer],

date '1985-01-01' + floor(random()*10000) ::integer,

(

array[
'Belgrade',
'Novi Sad',
'Valjevo',
'Nis',
'Kragujevac'
]
)[floor(random()*5+1)::integer],

(
array[
 'employed',
 'student',
 'self-employed',
 'retired'
]

)[floor(random()*4+1) ::integer],

round((50000+random()*200000) ::numeric, 2),

floor(300+random()*551)::integer,

date '2018-01-01'+floor(random()*2500)::integer,

'active'

from generate_series(1,490);
 

select count(*)
from customers;
 

insert into branches(
  branch_name,
  city,
  address,
  region,
  opened_at,
  branch_status

)

values

('Belgrade Center','Belgrade','Knez Mihailova 15','Belgrade','2010-05-01','active'),

('New Belgrade','Belgrade','Bulevar Mihajla Pupina 8','Belgrade','2012-08-15','active'),

('Novi Sad Center','Novi Sad','Bulevar Oslobodjenja 20','Vojvodina','2011-03-10','active'),

('Valjevo Center','Valjevo','Karadjordjeva 45','Western Serbia','2015-07-01','active'),

('Nis Center','Nis','Vozda Karadjordja 12','Southern Serbia','2014-04-18','active'),

('Kragujevac Center','Kragujevac','Kralja Petra 9','Central Serbia','2016-09-20','active'),

('Subotica Center','Subotica','Korzo 3','Vojvodina','2017-11-12','active'),

('Cacak Center','Cacak','Gradsko Setaliste 7','Western Serbia','2018-06-30','active'),

('Kraljevo Center','Kraljevo','Cara Lazara 25','Central Serbia','2019-02-14','active'),

('Uzice Center','Uzice','Dimitrija Tucovica 18','Western Serbia','2020-10-05','active');


with generated_accounts as(
  select
    c.customer_id,
    c.customer_since,
    
    (
      array[
        'checking',
        'savings',
        'foreign currency'
      ]
    
    )[floor(random()*3 +1) :: integer] as account_type
    
    from customers as c
    
    cross join lateral generate_series(
      1,
      1+floor(random()*3) :: integer
    )

)

insert into accounts(
  customer_id,
  branch_id,
  account_type,
  currency,
  balance,
  opened_at,
  account_status

)

select

 customer_id,
 
 floor( random() *10 +1) :: integer,
 
 account_type,
 
 case
 	when account_type='foreign_currency'
 	  then(
 	    array['EUR', 'USD']
 	    
 	  ) [floor(random()*2 +1 ) :: integer]
 	  
 	  else 'RSD'
 end,
 
 case
 	 when account_type = 'savings'

            then round((50000 + random() * 1450000)::numeric, 2)

        when account_type = 'foreign_currency'

            then round((100 + random() * 20000)::numeric, 2)

        else

            round((random() * 500000)::numeric, 2)
 end,
 
 customer_since
   + floor(random() * greatest(1, current_date - customer_since)) :: integer,
   
 case
 	when random()<0.90 then 'active'
 	when random()<0.97 then 'inactive'
 	else 'closed'
 end
 
 from generated_accounts;
 
 
 with selected_customers as (
   select
     customer_id,
     customer_since,
     
     (
       array[
         'cash',
         'mortgage',
         'auto',
         'business'
       
       ]
     )[floor(random() *4 +1) :: integer] as loan_type
     
  from customers
  
  where random() < 0.40
 
 ),
 
 loan_data as(
   select
     customer_id,
     customer_since,
     loan_type,
     
     case
       
	     when loan_type='mortgage'
	       then round((5000000 + random() * 25000000)::numeric, 2)

         when loan_type = 'auto'
           then round((500000 + random() * 3500000)::numeric, 2)

         when loan_type = 'business'
           then round((1000000 + random() * 9000000)::numeric, 2)
                
         else
           round((100000 + random() * 1900000)::numeric, 2)
           
     end as principal_amount,
     
     
     case
     	when loan_type = 'mortgage' then 240

        when loan_type = 'auto' then 60

        when loan_type = 'business' then 84

        else 36
     
     end as term_months,
     
     
     round((3+ random() *12) :: numeric, 2) as interest_rate
     
     
    from selected_customers
)


insert into loans(
  customer_id,
  branch_id,
  loan_type,
  principal_amount,
  interest_rate,
  start_date,
  term_months,
  monthly_payment,
  outstanding_balance,
  loan_status

)

select

  customer_id,
  
  floor(random()*10 + 1)::integer,
  
  loan_type,
  
  principal_amount,
  
  interest_rate,
  
  customer_since
    + floor(random() * greatest( 1 , current_date-customer_since))::integer,
    
  term_months,
  
  round((principal_amount * (1+interest_rate / 100) / term_months)::numeric, 2),
  
  round(( principal_amount * (0.15 + random()* 0.85))::numeric, 2 ),
  
  case
  	
	  when random()<0.72 then 'active'
	  when random()<0.84 then 'paid_off'
	  when random()<0.95 then 'overdue'
	  else 'defaulted'
  end
  
 from loan_data;
 
 
 with generated_transactions as (
   select
     a.account_id,
     a.currency,
     a.opened_at,
     
     (
       array[
          'card_payment',
          'cash_withdrawal',
          'bank_transfer',
          'salary',
          'fee',
          'refund'
       ]
     
     )[floor(random() * 6 +1):: integer] as transaction_type
     
     from accounts as a
     
     cross join lateral generate_series(
       1, 20+ floor(random()* 21):: integer
     
     )
     
)

insert into transactions(
  account_id,
  transaction_timestamp,
  transaction_type,
  transaction_direction,
  amount,
  currency,
  channel,
  merchant_category,
  transaction_status

)

select

   account_id,
   
   opened_at::timestamp + random()* (current_timestamp- opened_at :: timestamp),
   
   transaction_type,
   
   case
   	 when transaction_type in ('salary', 'refund')
   	   then 'credit'
   	   
   	 else 'debit'
   end,
   
   case
        when transaction_type = 'salary'
            then round((50000 + random() * 250000)::numeric, 2)

        when transaction_type = 'bank_transfer'
            then round((1000 + random() * 300000)::numeric, 2)

        when transaction_type = 'cash_withdrawal'
            then round((500 + random() * 50000)::numeric, 2)

        else
            round((100 + random() * 30000)::numeric, 2)
    end,
    
    currency,
    
    case
    	when transaction_type= 'cash_withdrawal' then 'atm'
    	when transaction_type= 'card_payment' then 'pos'
    	when transaction_type= 'bank_transfer' then 'mobile_app'
    	when transaction_type= 'salary' then 'bank_transfer'
    	else 'online_banking'
    end,
    
    case
    	when transaction_type= 'card_payment'
    	  then (
    	     array[
    	         'groceries',
    	         'restaurants',
    	         'fuel',
    	         'shopping',
    	         'travel',
    	         'utilities'
    	     
    	     ]
    	     
    	  )[floor(random()*6 +1):: integer]
    	else null
    end,
    
    case
    	when random()<0.92 then 'completed'
        when random()<0.97 then 'pending'
        when random()<0.99 then 'declined'
        else 'reversed'
    end
    
  from generated_transactions;
    
   
  select
     'customers' as table_name,
     count(*) as row_count
  from customers
  
  union all
  
  select
    'branches',
    count(*)
  from branches
  
  union all
  
  select
     'accounts',
     count(*)
  from accounts
  
  union all
  
  select
     'loans',
     count(*)
  from loans
  
  union all
  
  select
     'transactions',
     count(*)
  from transactions;

  
 