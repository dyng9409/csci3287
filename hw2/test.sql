select * 
    from borrower as b
        left join depositor as d 
            on b.customer_name = d.customer_name
