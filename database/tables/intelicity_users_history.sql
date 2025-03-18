create table intelicity_users_history (
    id number,
    name varchar(255),
    username varchar(255) not null,
    password varchar(255) not null,
    created_at timestamp default current_timestamp,
    created_by varchar2(255) default user,
    updated_at timestamp default current_timestamp,
    updated_by varchar2(255) default user,
    deleted_at timestamp default current_timestamp,
    deleted_by varchar2(255) default user
);

comment on table intelicity_users_history is 'Table to store the history of users of the system';