select distinct c.customer_name, c.customer_city 
    from customer as c,borrower as b 
    where b.customer_name = c.customer_name;
/* 1
+---------------+---------------+
| customer_name | customer_city |
+---------------+---------------+
| Adams         | Pittsfield    |
| Curry         | Rye           |
| Hayes         | Harrison      |
| Jackson       | Salt Lake     |
| Jones         | Harrison      |
| McBride       | Rye           |
| Smith         | Rye           |
| Williams      | Princeton     |
+---------------+---------------+
*/

select c.customer_name, c.customer_city 
    from borrower as b 
        join loan 
            on loan.loan_number = b.loan_number
        join customer as c
            on c.customer_name = b.customer_name
    where branch_name = 'Perryridge';

/* 2
+---------------+---------------+
| customer_name | customer_city |
+---------------+---------------+
| Adams         | Pittsfield    |
| Hayes         | Harrison      |
+---------------+---------------+
*/

select count(account_number)
    from account
    where balance <= 900 and balance >=700;

/* 3 inclusive result
+-----------------------+
| count(account_number) |
+-----------------------+
|                     5 |
+-----------------------+
*/

select count(account_number)
    from account
    where balance < 900 and balance > 700;

/* exclusive
+-----------------------+
| count(account_number) |
+-----------------------+
|                     2 |
+-----------------------+
*/

select customer_name from customer where customer_street regexp '[hH]ill$';

/* 4
+---------------+
| customer_name |
+---------------+
| Glenn         |
+---------------+
*/

select b.customer_name 
    from borrower as b
        join depositor as d 
            on b.customer_name = d.customer_name
        join account as a
            on a.account_number = d.account_number
        join loan as l
            on l.loan_number = b.loan_number
    where l.branch_name = 'Perryridge' and
     a.branch_name = 'Perryridge';

/* 5
+---------------+
| customer_name |
+---------------+
| Hayes         |
+---------------+
*/

select d.customer_name 
    from account as a
        join depositor as d
            on d.account_number = a.account_number
        left join borrower as b
            on b.customer_name = d.customer_name
        left join loan as l
            on l.loan_number = b.loan_number
    where
        a.branch_name = 'Perryridge' AND
        (l.branch_name != 'Perryridge' OR l.branch_name is NULL);

/* 6
+---------------+
| customer_name |
+---------------+
| Johnson       |
+---------------+
*/

select distinct d.customer_name
    from depositor as d
        join account as a
            on a.account_number = d.account_number
    where
        a.branch_name in (
            select a.branch_name
                from account as a
                    join depositor as d
                        on a.account_number = d.account_number
                where
                    d.customer_name = 'Hayes'
        ) AND
        d.customer_name != 'Hayes';

/* 7
+---------------+
| customer_name |
+---------------+
| Johnson       |
+---------------+
*/

select branch_name
    from branch
        where 
            branch_city != 'Brooklyn' AND
            assets >= (
                select MIN(assets)
                    from branch
                        where
                            branch_city = 'Brooklyn'
                );

/* 8
+-------------+
| branch_name |
+-------------+
| North Town  |
| Perryridge  |
| Redwood     |
| Round Hill  |
+-------------+
*/                

select branch_name
    from branch
        where 
            branch_city != 'Brooklyn' AND
            assets >= (
                select MAX(assets)
                    from branch
                        where
                            branch_city = 'Brooklyn'
                );

/* 
+-------------+
| branch_name |
+-------------+
| Round Hill  |
+-------------+
*/

select b.customer_name 
    from borrower as b
        join depositor as d 
            on b.customer_name = d.customer_name
        join account as a
            on a.account_number = d.account_number
        join loan as l
            on l.loan_number = b.loan_number
    where l.branch_name = 'Perryridge' and
     a.branch_name = 'Perryridge';

/* 9
+---------------+
| customer_name |
+---------------+
| Hayes         |
+---------------+
*/

select d.customer_name 
    from account as a
        join depositor as d
            on d.account_number = a.account_number
        left join borrower as b
            on b.customer_name = d.customer_name
        left join loan as l
            on l.loan_number = b.loan_number
    where
        a.branch_name = 'Perryridge' AND
        (l.branch_name != 'Perryridge' OR l.branch_name is NULL);

/* 10
+---------------+
| customer_name |
+---------------+
| Johnson       |
+---------------+
*/

select customer_name
    from depositor as d
    join (
        select a.account_number
            from account as a
            where a.branch_name = 'Perryridge'
    ) as j on j.account_number = d.account_number
union distinct
select customer_name
    from borrower as b
    join (
        select l.loan_number
            from loan as l
            where l.branch_name = 'Perryridge'
        ) as k on k.loan_number = b.loan_number
    order by
        customer_name;

/* 11
+---------------+
| customer_name |
+---------------+
| Adams         |
| Hayes         |
| Johnson       |
+---------------+
*/

select *
    from loan
    order by
        amount desc,
        loan_number;

/* 12
+-------------+-------------+--------+
| loan_number | branch_name | amount |
+-------------+-------------+--------+
| L-20        | North Town  |   7500 |
| L-23        | Redwood     |   2000 |
| L-14        | Downtown    |   1500 |
| L-15        | Perryridge  |   1500 |
| L-16        | Perryridge  |   1300 |
| L-17        | Downtown    |   1000 |
| L-11        | Round Hill  |    900 |
| L-21        | Central     |    570 |
| L-93        | Mianus      |    500 |
+-------------+-------------+--------+
*/

select ROUND(AVG(balance),2) as average_balance
    from account;

/* 13
+-----------------+
| average_balance |
+-----------------+
|          641.67 |
+-----------------+
*/

select *
    from (
        select avg(balance) as avg, branch_name
            from account
            group by branch_name
    ) as x
    where x.avg >= 700;

/* 14
+------+-------------+
| avg  | branch_name |
+------+-------------+
|  750 | Brighton    |
|  850 | Central     |
|  700 | Mianus      |
|  700 | Redwood     |
+------+-------------+
*/

select branch_name
    from (
        select avg(balance) as avg, branch_name
            from account
            group by branch_name
            order by avg desc
    ) as x
    LIMIT 1;


/* 15
+-------------+
| branch_name |
+-------------+
| Central     |
+-------------+
*/

select AVG(account.balance) from account 
    join depositor
        on account.account_number = depositor.account_number
    where depositor.customer_name in (
        select customer.customer_name
            from customer
                join (
                    select count(a.account_number) as accts, avg(a.balance) as avgbal, d.customer_name
                        from account as a
                            join depositor as d 
                                on d.account_number = a.account_number
                        group by d.customer_name
                    ) as x
                on customer.customer_name = x.customer_name
                where 
                    x.accts >= 2 AND
                    customer.customer_city = 'Harrison'
    ) 

/* 16
+----------------------+
| AVG(account.balance) |
+----------------------+
|                  450 |
+----------------------+
*/
