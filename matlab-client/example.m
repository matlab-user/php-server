function example   

%[ W, TIME ] = data_encode( 'guid1', [1 2 3], [0.5 0.6 0.7], [2 1 4] );
% [ W, TIME ] = data_encode_g( 'guid1', [1 2 3], [0.5 0.6 0.7], [2 1 4], [1 2 1] );
% W
% TIME
post_dev_info( 'guid1', '345', 'dev_info-1.xml' );
return;
%-------------------------------------------------
% ��������
% host - ������������IP��ַ
% port - ����˿�,http�˿�Ĭ��Ϊ80
% I1 - �豸�� GUID1 ��
%------------------------------------------------
host = 'www.baidu.com';
port = 80;
I1 = 'demo-1';

%-------------------------------------------------
% ���ӷ�����
%-------------------------------------------------
conn = tcpip( host, port );
try
    fopen( conn );
catch err
    disp('���ӷ�����ʧ��,�����˳�!');
    delete( conn );
    return;
end

%-------------------------------------------------
% �����豸��Ϣ
%-------------------------------------------------
post_dev_info( I1, host );


fclose( conn );
delete( conn );

% dev_info_path - �豸�ļ���Ϣ�ļ����·��
% �˺����У��涨�豸��Ϣ�ļ���� 10k �ֽ�
function post_dev_info( I1, host, dev_info_path )
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
    T_str = 'T=dev/info';
    I1_str = [ 'I1=' num2str(I1) ];
    
    post_str = [ I1_str '&' W_str '&' T_str 13 10 ];    
    mid = sprintf('Content-Length:%d \r\n', size(post_str,2) );
    cmd = [ cmd 13 10 ];
    
    post_str = [ cmd post_str ]
    
%     host = '192.168.31.21';
%     obj = tcpip( host, 80, 'InputBufferSize', 1024 );
%     fopen( obj );
% 
%     t_stamp = etime( clock(), [1970 1 1 0 0 0] ) - 8*3600;
%     t_stamp = num2str( floor(t_stamp) );
% 
%     %post_str = sprintf( 'I1=54455354444556535357415900000003&TIME=%s,3,-4&W=[54455354444556535357415900000003;(1,2.4,t-2)(2,2.56,t1)][3;(2,8.56,t-4)][4;(1,256,t4)]\r\n', t_stamp );
%     post_str = sprintf( 'I1=1982011602030410182910a1F2C3D02A&TIME=%s,3,-4&W=[1982011602030410182910a1F2C3D02A;(1,2.4,t-2)(2,2.56,t1)][3;(2,8.56,t-4)][4;(1,256,t4)]\r\n', t_stamp );
%     cmd = sprintf( 'POST /php-server/0x82.php HTTP/1.1\r\n' );
%     
%     mid = sprintf( 'Host:%s\r\n', host );
%     cmd = [ cmd mid ];
%     mid = sprintf( 'Content-Type:application/x-www-form-urlencoded\r\n' );
%     cmd = [ cmd mid ];
%     mid = sprintf('Content-Length:%d \r\n', size(post_str,2) );
%     cmd = [ cmd mid 13 10 ];
%     cmd = [ cmd post_str ];
% 
%     mid = 0;
%     char( cmd )
%     
%     fwrite( obj, uint8( cmd ) );
%     
%     [ A, count ] = fread( obj, 1000 );
%     char( A' )
%     
%     fclose( obj );