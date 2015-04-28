% d_id - 参数的 id 号, 行向量
% value - 对应d_id参数的数值,行向量
% t - 对应value的采集时间， 行向量
function post_dev_data( I1, d_id, value, t )

global HOST PORT
host = HOST;
port = PORT;

[ encode_str, encode_time ] = data_encode( I1, d_id, value, t );
if isempty(encode_str) | isempty(encode_time)
    return;
end

post_str = [ 'I1=' I1 '&' encode_str '&' encode_time ];

conn = tcpip( host, port, 'InputBufferSize', 1024 );
try
    fopen( conn );
catch err
    disp('连接服务器失败,程序退出!');
    delete( conn );
    return;
end

cmd = sprintf( 'POST /php-server/0x82.php HTTP/1.1\r\n' );
cmd = [ cmd sprintf('Host:%s\r\n',host) ];
cmd = [ cmd sprintf('Content-Type:application/x-www-form-urlencoded\r\n') ];
mid = sprintf('Content-Length:%d \r\n', size(post_str,2) );
cmd = [ cmd mid 13 10 ];

post_str = [ cmd post_str ];
char( post_str )
fwrite( conn, post_str );

fclose( conn );
delete( conn );