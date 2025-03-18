create table intelicity_users (
    id number primary key,
    name varchar(255),
    username varchar(255) not null unique,
    password varchar(255) not null,
    created_at timestamp default current_timestamp,
    created_by varchar2(255) default user,
    updated_at timestamp default current_timestamp,
    updated_by varchar2(255) default user
);

comment on table intelicity_users is 'Table to store users of the system';
comment on column intelicity_users.id is 'Unique identifier of the user';
comment on column intelicity_users.name is 'Name of the user';
comment on column intelicity_users.username is 'Username of the user';
comment on column intelicity_users.password is 'Password of the user';
comment on column intelicity_users.created_at is 'Date and time of the user registration';
comment on column intelicity_users.created_by is 'User who registered the user';
comment on column intelicity_users.updated_at is 'Date and time of the last update of the user';
comment on column intelicity_users.updated_by is 'User who last updated the user';

create sequence seq_intelicity_users start with 1 increment by 1;