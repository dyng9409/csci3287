select distinct c.customer_name, c.customer_city 
    from customer as c,borrower as b 
    where b.customer_name = c.customer_name;
/*
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

/*
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

/* inclusive result
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

/*
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

/*
+---------------+
| customer_name |
+---------------+
| Hayes         |
+---------------+
*/
