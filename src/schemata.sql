create schema redis;
drop table if exists redis.servers;
create table redis.servers (
    env varchar(191),
    host varchar(191) default 'localhost',
    port integer default 6379,
    password varchar(191) default null,
    database integer default null
);
create or replace function redis.env() returns varchar as $$ select 'dev' $$ language sql;
insert into redis.servers (env, password) values (redis.env(), 'XXX');
