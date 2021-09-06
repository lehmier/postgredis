/**
 * Generically execute any redis command as a string.
 *
 * e.g. select redis.exec('SET x 12');
 *      select redis.exec('GET x');
 */
create or replace function redis.exec(command character varying)
    returns character varying as $$
declare
    _host varchar;
    _port int;
    _password varchar;
begin
    select host, port, password from redis.servers where env = 'dev' into _host, _port, _password;
    return redis.redis_exec(command, _host, _port, _password);
end;
$$ language plpgsql;

/**
 * SET key value [EX seconds|PX milliseconds|EXAT timestamp|PXAT milliseconds-timestamp|KEEPTTL] [NX|XX] [GET] 
 * https://redis.io/commands/set
 */
create function redis.set(key varchar, value varchar, expiry varchar default '') returns varchar as $$
begin
    return redis.exec('SET ' || key || ' ' || value || ' ' || expiry);
end;
$$ language plpgsql;

/**
 * GET key
 * https://redis.io/commands/get
 */
create function redis.get(key varchar) returns varchar as $$
begin
    return redis.exec('GET ' || key);
end;
$$ language plpgsql;