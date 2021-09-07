create schema redis;

create table redis.servers (
    env varchar(191),
    host varchar(191) default 'localhost',
    port integer default 6379,
    password varchar(191) default null,
    database integer default null
);

insert into redis.servers (env, password) values ('dev', 'XXX');