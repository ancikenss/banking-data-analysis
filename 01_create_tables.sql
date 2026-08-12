
-- Banking Analytics SQL Project
-- Author: Ana Rankovic
-- Database: PostgreSQL
-- Part 1: Database Schema




create table customers (
    customer_id integer generated always as identity primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    date_of_birth date not null,
    city varchar(50) not null,
    employment_status varchar(30),
    monthly_income numeric(12,2),
    credit_score integer,
    customer_since date not null,
    customer_status varchar(20) not null
);

create table branches (
    branch_id integer generated always as identity primary key,
    branch_name varchar(100) not null,
    city varchar(50) not null,
    address varchar(150) not null,
    region varchar(30) not null,
    opened_at date not null,
    branch_status varchar(20) not null
);

create table accounts (
    account_id integer generated always as identity primary key,
    customer_id integer not null references customers(customer_id),
    branch_id integer not null references branches(branch_id),
    account_type varchar(30) not null,
    currency varchar(3) not null,
    balance numeric(14,2) not null default 0,
    opened_at date not null,
    account_status varchar(30) not null,
    
);


create table transactions(
  transaction_id integer generated always as identity primary key,
  account_id integer not null references accounts(account_id),
  transaction_timestamp timestamp not null,
  transaction_type varchar(30) not null,
  transaction_direction varchar(10) not null,
  currency varchar(3) not null,
  amount numeric(14,2) not null,
  channel varchar(20),
  merchant_category varchar(50),
  transaction_status varchar(20) not null,
  
  constraint positive_transaction_amount
    check (amount > 0),

  constraint valid_transaction_direction
    check (transaction_direction in ('credit', 'debit')),

  constraint valid_transaction_status
    check (transaction_status in ('completed', 'pending', 'declined', 'reversed'))
    
);

create table loans(
  loan_id integer generated always as identity primary key,
  customer_id integer not null references customers(customer_id),
  branch_id integer not null references branches(branch_id),
  loan_type varchar(30) not null,
  principal_amount numeric(14,2) not null,
  interest_rate numeric(5,2) not null,
  start_date date not null,
  term_months integer not null,
  monthly_payment numeric(14,2) not null,
  outstanding_balance numeric(14,2) not null,
  loan_status varchar(20) not null,
  
  constraint positive_principal_amount
    check(principal_amount>0),
   
   constraint valid_interest_rate
     check(interest_rate >=0),
     
   constraint positive_loan_term
     check(term_months>0),
     
   constraint valid_outstanding_balance
     check(outstanding_balance>=0),
     
   constraint valid_loan_status
     check(loan_status in ('active', 'paid_off', 'overdue', 'defaulted'))
   
     
 );



