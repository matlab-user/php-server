<?php

	$sock = socket_create( AF_INET, SOCK_STREAM, 0 );
	
	socket_set_option( $sock, SOL_SOCKET, SO_RCVTIMEO, array("sec"=>10, "usec"=>0 ) );
	socket_set_option( $sock, SOL_SOCKET, SO_SNDTIMEO, array("sec"=>3, "usec"=>0 ) );
	socket_set_option( $sock, SOL_SOCKET, SO_REUSEADDR, 1 );
	
	// $l_ip = gethostbyname( 'www.swaytech.biz' );
	// $res = system( 'ifconfig eth0' );
	// echo $res."\n";

	$l_ip = '192.168.1.9';
	$l_port = 1984;
	
	socket_bind( $sock, $l_ip, $l_port );       		// 绑定要监听的 ip、port
	
	socket_listen( $sock );      						 // 监听端口
	$conn = socket_accept( $sock );  
	if( $conn ) {
		socket_getpeername ( $conn , $r_ip, $r_port );
		echo 'peer_ip: '.$r_ip."\tpeer_port: ".$r_port."\n";
		
		while( 1 ) {			// void gen TIME_WAIT
			$res = '';
			$res = socket_read( $conn, 10 );
			if( $res==='' | $res===false )
				break;
		}
		
		socket_close( $conn );
	}
	socket_close( $sock );
	
	echo "sleep and reconnect! \n";
	sleep( 18 );

	$sock = socket_create( AF_INET, SOCK_STREAM, 0 );
	socket_set_option( $sock, SOL_SOCKET, SO_RCVTIMEO, array("sec"=>3, "usec"=>0 ) );
	socket_set_option( $sock, SOL_SOCKET, SO_SNDTIMEO, array("sec"=>3, "usec"=>0 ) );
	$res = socket_set_option( $sock, SOL_SOCKET, SO_REUSEADDR, 1 );
	//echo 'Unable to set option on socket: '. socket_strerror(socket_last_error())."\n";
	echo "set reuse:".$res."\n";
	
	$res = socket_bind( $sock, $l_ip, $l_port );       		// 绑定客户端连接时，服务器的 ip、port
	//echo "bind    ".socket_strerror(socket_last_error())."\n";
	echo "bind :".$res."\n";
	
	socket_connect( $sock, $r_ip, $r_port );
	echo "send message!\n";
	$buff = "wangdehi\r\n";
	sleep( 1 );
	$res = socket_write( $sock, $buff, strlen($buff) );
	echo $res."\n";
	socket_close( $sock );
/*
		foreach( getallheaders() as $name => $value ) { 
			$str = $name.': '.$value."\n"; 
			error_log( $str, 3, '/tmp/weixin.log' );
		}
*/
?>