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
