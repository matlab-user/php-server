function test_http_085()

    host = 'www.swaytech.biz';
    obj = tcpip( host, 128 );
    fopen( obj );

    post_str = sprintf( 'I1=TFwqovfw\r\n' );
    cmd = sprintf( 'POST /php-server/0x85.php HTTP/1.1\r\n' );
    
    mid = sprintf( 'Host: %s\r\n', host );
    cmd = [ cmd mid ];
    mid = sprintf( 'Content-Type: application/x-www-form-urlencoded\r\n' );
    cmd = [ cmd mid ];
    mid = sprintf('Content-Length: %d \r\n', size(post_str,2) );
    cmd = [ cmd mid 13 10 ];
    cmd = [ cmd post_str ];

    mid = 0;
    char( cmd );
    fwrite( obj, uint8( cmd ) );

    txt = [];
    txt = recv_data( obj );
    fclose( obj ); 
    char( txt )
    
    [ new_ip, new_port ] = decode_ip_port( txt );
    if new_ip=='SAME'
        new_ip = host;
    end

    % 重新连接返回的ip、port
    obj = tcpip( new_ip, new_port );
    fopen( obj );
    fwrite( obj, uint8(post_str) );
    l_port = get( obj, 'LocalPort' )
    fclose( obj );
 
    obj = [];
    disp( 'open the listen port!' );
    
    % 转为监听进程
    obj = tcpip( '0.0.0.0', l_port, 'NetworkRole', 'server' );
    fopen( obj );
    disp( 'get a conn' );
    res = [];
    while 1
        [ A, count ] = fread( obj, 1 );
        if count <= 0
            break;
        end
        
        res = [ res A(1) ];
        
        if A(1)==']'
            break;
        end
    end
    char( res )
    fclose( obj );

%--------------------------------------------------------------------------
function [ ip, port ] = decode_ip_port( str ) 
    ind1 = strfind( str, 'W=' );
    ind2 = strfind( str, ';' );
    ip = char( str( ind1+2:ind2-1 ) );
    port = str2num( char(str( ind2+1:end )) );
