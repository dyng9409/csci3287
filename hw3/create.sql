set FOREIGN_KEY_CHECKS = 0;
drop table supplier;
drop table part;
drop table catalog;
set FOREIGN_KEY_CHECKS = 1;

create table supplier(
    sid integer,
    sname varchar(15),
    address varchar(25),
    primary key(
        sid
    )
);

create table part(
    pid integer,
    pname varchar(15),
    color varchar(10),
    primary key(
        pid
    )
);

create table catalog(
    sid integer,
    pid integer,
    cost decimal,
    primary key(
        sid,
        pid
    ),
    foreign key(
        sid
    ) references supplier(sid),
    foreign key(
        pid
    ) references part(pid)
);
