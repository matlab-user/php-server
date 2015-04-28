% dev_info_path - 设备文件信息文件存放路径
% conn - 连接服务器的 socket 
% 此函数中，规定设备信息文件最大 10k 字节
function post_dev_info( I1, dev_info_path )

global HOST PORT
host = HOST;
port = PORT;

%-------------------------------------------------
% 连接服务器
%-------------------------------------------------
conn = tcpip( host, port, 'OutputBufferSize', 1024 );
try
    fopen( conn );
catch err
    disp('连接服务器失败,程序退出!');
    delete( conn );
    return;
end

cmd = sprintf( 'POST /php-server/0x83.php HTTP/1.1\r\n' );
cmd = [ cmd sprintf('Host:%s\r\n',host) ];
cmd = [ cmd sprintf('Content-Type:application/x-www-form-urlencoded\r\n') ];

fid = fopen( dev_info_path, 'r' );
A = fread( fid, 1024*10 )';
fclose( fid );

index = find( A==32 );
A(index) = [];
index = find( A==13 );
A(index) = [];
index = find( A==10 );
A(index) = [];
index = find( A==9 );
A(index) = [];
A = char( A );

W_str = [ 'W=' A ];
clear A;
T_str = [ 'T=dev/info' ];
I1_str = [ 'I1=' I1 ];

post_str = [ I1_str '&' W_str '&' T_str 13 10 ];
mid = sprintf('Content-Length:%d \r\n', size(post_str,2) );
cmd = [ cmd mid 13 10 ];

post_str = [ cmd post_str ];
char( post_str )
fwrite( conn, post_str );

fclose( conn );
delete( conn );