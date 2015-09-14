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

create table loan(

);

