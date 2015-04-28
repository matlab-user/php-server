function post_image( I1, d_id, image_file, t )

global HOST PORT
host = HOST;
port = PORT;

% 获取图片文件大小，单位：字节
D = dir( image_file );
image_size = D.bytes;

% 获取图片文件名
S = regexp( image_file, '\', 'split');
if size(S,2)>1
    image_name = S{end};
else
    image_name = S{1};
end

post_str = [ 'I1=' I1 0 'ID=' num2str(d_id) 0 'T=image' 0 'TIME=' num2str(t) 0 'F=' image_name 0 'L=' num2str(image_size) 0 13 ];

cmd = sprintf( 'POST /php-server/0x81.php HTTP/1.1\r\n' );
mid = sprintf( 'Host: %s\r\n', host );
cmd = [ cmd mid ];
mid = sprintf( 'Content-Type: application/octet-stream\r\n' );
cmd = [ cmd mid ];
mid = sprintf( 'Content-Length: %d \r\n', size(post_str,2)+image_size );
cmd = [ cmd mid 13 10 ];

cmd = [ cmd post_str ];

conn = tcpip( host, port, 'OutputBufferSize', 1024*100  );
try
    fopen( conn );
catch err
    disp('连接服务器失败,程序退出!');
    delete( conn );
    return;
end

fid = fopen( image_file );
A = fread( fid )';
fclose( fid );

post_str = [ cmd A ];
clear A cmd

fwrite( conn, post_str );

fclose( conn );
delete( conn );