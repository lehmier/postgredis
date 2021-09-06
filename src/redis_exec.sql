create or replace function redis.redis_exec(
    cmd character varying,
    host character varying default 'localhost',
    port integer default 6379,
    password character varying default null,
    database integer default null
  ) returns character varying as
$body$
def redis_exec(_cmd, _host, _port, _password=None, _database=None, _socket=None):
    import shlex
    import socket
    try:
        s = _socket
        if not s:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.settimeout(0.1)
            s.connect((_host, _port))
        if _password:
            redis_exec('AUTH %s' % _password, _host, _host, None, _database, s)
        if _database:
            redis_exec('SELECT %d' % _database, _host, _host, None, None, s)

        cmds = ['$%s\r\n%s' % (len(x), x) for x in shlex.split(_cmd) if x]
        cmds = ['*%d' % len(cmds)] + cmds + ['']
        s.sendall('\r\n'.join(cmds).encode('utf8'))

        resp = b''
        # TODO:  Actual parsing of the response
        while b'\r\n' not in resp:
            resp += s.recv(4096)
        
        if not (_cmd.startswith('AUTH') or _cmd.startswith('SELECT')):
            s.close()
        return resp.decode('utf8')
    except Exception as e:
        return str(e)
return redis_exec(cmd, host, port, password, database);
$body$ language plpythonu volatile;

alter function redis.redis_exec(
    character varying, character varying, integer, character varying, integer)
    owner to jesse;