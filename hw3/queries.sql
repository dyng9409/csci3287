/*
Formatting:
RELATION[predicate](argument)
eg
SELECT[x>5](PROJECT[x,y](relation))
*/

/*
1.
PROJECT[supplier.name](
    SELECT[supplier.sid = catalog.sid](
        CARTESIAN(
            supplier,
            SELECT[catalog.pid = part.pid](
                CARTESIAN(
                    catalog, 
                    SELECT[color = red](
                        part
                    )
                )
            )
        )
    )
)
*/
SELECT s.sname
    from part as p
        join catalog as c
            on p.pid = c.pid
        join supplier as s
            on s.sid = c.sid
     where
        p.color = 'Red';

/*
2.
PROJECT[catalog.sid](
    SELECT[catalog.pid = part.pid](
        CARTESIAN(
            catalog,
            SELECT[color = 'Red' OR color = 'Green'](
                part
            )
        )
    )
)
)
*/

SELECT c.sid
    from catalog as c
        join part as p on
            c.pid = p.pid
    where
        p.color = 'Red' OR p.color = 'Green';

/*
3.
UNION(
    PROJECT[supplier.sid](
        SELECT[supplier.address = '221 Packard Street'](
            supplier
        )
    ),
    PROJECT[catalog.sid](
        SELECT[catalog.pid = part.pid](
            CARTESIAN(
                catalog,
                SELECT[part.color = 'Red'](
                    part
                )
            )
        )
    )
)
*/
SELECT s.sid 
    from supplier as s
    where s.address = '221 Packard Street'
UNION
SELECT c.sid
    from catalog as c
    join part as p on
        p.pid = c.pid
    where
        p.color = 'Red';
       
/*
4.
RENAME(
    PROJECT[catalog.sid](
        SELECT[catalog.pid = part.pid](
            CARTESIAN(
                catalog,
                SELECT[part.color = 'Red'](
                    part
                )
            )
        )
    ),
    reds
)
RENAME(
    PROJECT[catalog.sid](
        SELECT[catalog.pid = part.pid](
            CARTESIAN(
                catalog,
                SELECT[part.color = 'Green'](
                    part
                )
            )
        )
    ),
    greens
)
PROJECT[sid](
    reds-(reds-greens)
)
*/
SELECT *
    from(
        SELECT c.sid
            from catalog as c
                join part as p
                    on c.pid = p.pid
             where 
                p.color = 'Red'
            ) as x
    where x.sid in
    (
        SELECT c.sid
            from catalog as c
                join part as p
                    on c.pid = p.pid
             where
                p.color = 'Green'
    );
/*
5.
RENAME(
    PROJECT[part.pid](
        part
    ),
    partIDs
)
PROJECT[catalog.sid](
    DIVIDE(
        catalog,
        partIDs
    )
)
*/

select distinct c.sid
    from catalog as c
    where c.sid not in
    (
        select distinct tmp1.sid
            from
            (
                select distinct c.sid
                    from catalog as c
                ) as tmp1
            cross join
            (
                select p.pid 
                    from part as p
                ) as s
            where (tmp1.sid, s.pid) not in
            (
                select c.sid, c.pid
                    from catalog as c
                ));

/*
6.
RENAME(
    PROJECT[part.pid](
        SELECT[part.color = 'Red'](
            part
        )
    ),
    redIDs
)
PROJECT[catalog.sid](
    DIVIDE(
        catalog,
        redIDs
    )
)

*/

select distinct c.sid
    from catalog as c
    where c.sid not in
    (
        select distinct tmp1.sid
            from
            (
                select distinct c.sid
                    from catalog as c
                ) as tmp1
            cross join
            (
                select p.pid 
                    from part as p
                    where p.color = 'Red'
                ) as s
            where (tmp1.sid, s.pid) not in
            (
                select c.sid, c.pid
                    from catalog as c
                ));


/*
7.
RENAME(
    PROJECT[part.pid](
        SELECT[part.color = 'Red' OR part.color = 'Green'](
            part
        )
    ),
    rgIDs
)
PROJECT[catalog.sid](
    DIVIDE(
        catalog,
        rgIDs
    )
)


*/
select distinct c.sid
    from catalog as c
    where c.sid not in
    (
        select distinct tmp1.sid
            from
            (
                select distinct c.sid
                    from catalog as c
                ) as tmp1
            cross join
            (
                select p.pid 
                    from part as p
                    where p.color = 'Red' OR p.color = 'Green'
                ) as s
            where (tmp1.sid, s.pid) not in
            (
                select c.sid, c.pid
                    from catalog as c
                ));



/*
8.
RENAME(
    PROJECT[part.pid](
        SELECT[part.color = 'Red'](
            part
        )
    ),
    redIDs
)
RENAME(
    PROJECT[part.pid](
        SELECT[part.color = 'Green'](
            part
        )
    ),
    greenIDs
)
PROJECT[catalog.sid](
    UNION(
        DIVIDE(
            catalog,
            redIDs
        ),
        DIVIDE(
            catalog,
            greenIDs
        )
    )
)

*/

select distinct c.sid
    from catalog as c
    where c.sid not in
    (
        select distinct tmp1.sid
            from
            (
                select distinct c.sid
                    from catalog as c
                ) as tmp1
            cross join
            (
                select p.pid 
                    from part as p
                    where p.color = 'Red'
                ) as s
            where (tmp1.sid, s.pid) not in
            (
                select c.sid, c.pid
                    from catalog as c
                ))
UNION
select distinct c.sid
    from catalog as c
    where c.sid not in
    (
        select distinct tmp1.sid
            from
            (
                select distinct c.sid
                    from catalog as c
                ) as tmp1
            cross join
            (
                select p.pid 
                    from part as p
                    where p.color = 'Green'
                ) as s
            where (tmp1.sid, s.pid) not in
            (
                select c.sid, c.pid
                    from catalog as c
                ));

/*
9.
RENAME(catalog, c1)
RENAME(catalog, c2)
PROJECT[c1.sid, c2.sid](
    SELECT[c1.pid = c2.pid, c1.cost > c2.cost, c1.sid != c2.sid](
        CARTESIAN(
            c1,
            c2
        )
    )
)

*/
SELECT c1.sid sid1, c2.sid sid2
    from catalog as c1
    cross join catalog as c2
    where
        c1.pid = c2.pid AND
        c1.sid != c2.sid AND
        c1.cost > c2.cost;


/*
10.
RENAME(catalog, c1)
RENAME(catalog, c2)
PROJECT[c1.sid](
    SELECT[c1.sid != c2.sid AND c1.pid = c2.pid](
        CARTESIAN(
            c1,
            c2
        )
    )
)
*/

SELECT DISTINCT c1.pid
    from catalog as c1
    cross join catalog as c2
    where
        c1.pid = c2.pid AND
        c1.sid != c2.sid;


/*
11.
RENAME(
    PROJECT[catalog.pid, catalog.cost](
        SELECT[supplier.sname = 'Yosemite Sham'](
            SELECT[catalog.sid = supplier.sid](
                CARTESIAN(
                    catalog,
                    supplier
                )
            )
        )
    ),
    t1
)
RENAME(
    PROJECT[catalog.pid, catalog.cost](
        SELECT[supplier.sname = 'Yosemite Sham'](
            SELECT[catalog.sid = supplier.sid](
                CARTESIAN(
                    catalog,
                    supplier
                )
            )
        )
    ),
    t2
)
PROJECT[t1.pid](
    SELECT[t1.cost > t2.cost](
        CARTESIAN(
            t1,
            t2
        )
    )
)
*/
select t1.pid
    from (
        select c.pid, c.cost
            from catalog as c
            join supplier as s
                on s.sid = c.sid
            where s.sname = 'Yosemite Sham') as t1
    cross join(
        select c.pid, c.cost
            from catalog as c
            join supplier as s
                on s.sid = c.sid
            where s.sname = 'Yosemite Sham') as t2
    where t1.cost > t2.cost;

