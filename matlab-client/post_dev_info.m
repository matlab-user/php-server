% dev_info_path - �豸�ļ���Ϣ�ļ����·��
% conn - ���ӷ������� socket 
% �˺����У��涨�豸��Ϣ�ļ���� 10k �ֽ�
function post_dev_info( I1, dev_info_path )

global HOST PORT
host = HOST;
port = PORT;

%-------------------------------------------------
% ���ӷ�����
%-------------------------------------------------
conn = tcpip( host, port, 'OutputBufferSize', 1024 );
try
    fopen( conn );
catch err
    disp('���ӷ�����ʧ��,�����˳�!');
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