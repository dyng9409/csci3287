/*
#DROP TABLES SCRIPT SO THAT I DONT PULL MY HAIR OUT
SET FOREIGN_KEY_CHECKS = 0;
drop table section;
drop table teaches;
drop table takes;
drop table advisor;
drop table instructor;
drop table student;
drop table department;
drop table classroom;
drop table course;
drop table prereq;
drop table time_slot;
SET FOREIGN_KEY_CHECKS = 1;
*/

create table classroom(
    building varchar(15),
    room_number varchar(7),
    capacity numeric(4,0),
    primary key(
        building,
        room_number
    )
);

create table department(
    dept_name varchar(20),
    building varchar(15),
    budget numeric(12,2) check (budget > 0),
    primary key(
        dept_name
    )
);

create table course(
    course_id varchar(8),
    title varchar(50),
    dept_name varchar(20),
    credits numeric(2,0) check (credits > 0),
    primary key(
        course_id
    ),
    foreign key(
        dept_name
    ) references department(dept_name) on delete set null
);

create table prereq(
    course_id varchar(8),
    prereq_id varchar(8),
    primary key(
        course_id,
        prereq_id
    ),
    foreign key(
        course_id
    ) references course(course_id)
);

create table time_slot(
    time_slot_id varchar(4),
    day varchar(1),
    start_hr decimal(2,0),
    start_min decimal(2,0),
    end_hr decimal(2,0),
    end_min decimal(2,0),
    primary key(
        time_slot_id,
        day,
        start_hr,
        start_min
    )
);

create table student(
    ID varchar(5),
    name varchar(20),
    dept_name varchar(20),
    tot_cred decimal(3,0) check (tot_cred >= 0),
    primary key(
        ID
    ),
    foreign key(
        dept_name
    ) references department(dept_name)
);

create table instructor(
    ID varchar(5),
    name varchar(2),
    dept_name varchar(20),
    salary decimal(8,2),
    primary key(
        ID
    ),
    foreign key(
        dept_name
    ) references department(dept_name)
);

create table advisor(
    s_ID varchar(5),
    i_ID varchar(5),
    primary key(
        s_ID
    ),
    foreign key(
        s_ID
    ) references student(ID),
    foreign key(
        i_ID
    ) references instructor(ID)
);

create table section(
    course_id varchar(8),
    sec_id varchar(8),
    semester varchar(6),
    year decimal(4,0),
    building varchar(15),
    room_number varchar(7),
    time_slot_id varchar(4),
    primary key(
        course_id,
        sec_id,
        semester,
        year
    ),
    foreign key(
        building,
        room_number
    ) references classroom(building, room_number)
);

create table teaches(
    ID varchar(5),
    course_id varchar(8),
    sec_id varchar(8),
    semester varchar(6),
    year decimal(4,0),
    primary key(
        ID,
        course_id,
        sec_id,
        semester,
        year
    ),
    foreign key(
        ID
    ) references instructor(ID),
    foreign key(
        course_id,
        sec_id,
        semester,
        year
    ) references section(course_id, sec_id, semester, year)
);

create table takes(
    ID varchar(5),
    course_id varchar(8),
    sec_id varchar(8),
    semester varchar(6),
    year decimal(4,0),
    grade varchar(2),
    primary key(
        ID,
        course_id,
        sec_id,
        semester,
        year
    ),
    foreign key(
        ID
    ) references student(ID),
    foreign key(
        course_id,
        sec_id,
        semester,
        year
    ) references section(course_id, sec_id, semester, year)
);
