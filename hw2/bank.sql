/*DROP TABLE SCRIPT*/
set FOREIGN_KEY_CHECKS = 0;
drop table branch;
drop table loan;
drop table depositor;
drop table account;
drop table borrower;
drop table customer;
set FOREIGN_KEY_CHECKS = 1;

create table branch(
    branch_name varchar(15),
    branch_city varchar(15),
    assets float,
    primary key(
        branch_name
    )
);

create table customer(
    customer_name varchar(15),
    customer_street varchar(12),
    customer_city varchar(15),
    primary key(
        customer_name
    )
);

create table loan(
    loan_number varchar(15),
    branch_name varchar(15),
    amount float,
    primary key(
        loan_number
    )
);

create table account(
    account_number varchar(15),
    branch_name varchar(15),
    balance float,
    primary key(
        account_number
    )
);

create table borrower(
    customer_name varchar(15),
    loan_number varchar(15),
    primary key(
        loan_number,
        customer_name
    ),
    foreign key(
        customer_name
    ) references customer(customer_name),
    foreign key(
        loan_number
    ) references loan(loan_number)
);

create table depositor(
    customer_name varchar(15),
    account_number varchar(15),
    primary key(
        account_number,
        customer_name
    ),
    foreign key(
        customer_name
    ) references customer(customer_name),
    foreign key(
        account_number
    ) references account(account_number)
);

