<?php

	set_time_limit( 30 );
	
	require_once( "php-lib/codec_lib.php" );
	$config = read_config( 'php-lib/config.cf' );
	$mysql_user = $config->user;
	$mysql_pass = $config->pass;
	
	$l_ip = $argv[1];
	$l_port = $argv[2];
	
	$sock = socket_create( AF_INET, SOCK_STREAM, 0 );
	socket_set_option( $sock, SOL_SOCKET, SO_RCVTIMEO, array("sec"=>10, "usec"=>0 ) );
	socket_set_option( $sock, SOL_SOCKET, SO_SNDTIMEO, array("sec"=>3, "usec"=>0 ) );
	socket_set_option( $sock, SOL_SOCKET, SO_REUSEADDR, 1 );
	
	socket_bind( $sock, $l_ip, $l_port );       		// 绑定 ip、port
	
	socket_listen( $sock );      						 // 监听端口
	$conn = socket_accept( $sock );  
	if( $conn ) {
		socket_getpeername ( $conn , $r_ip, $r_port );
		echo "get client connection!\n"; 
		echo 'peer_ip-'.$r_ip.'peer_port-'.$r_port."\n";

		$dev_send = '';
		while( 1 ) {			// void gen TIME_WAIT
			$res = '';
			$res = socket_read( $conn, 128 );		
			
			if( $res=='' | $res==false )
				break;
			else {
				$l_c = substr( $res, -1, 1 );
				$I1 = get_guid1( $res );
				$con = touch_mysql();
				$query_str = "UPDATE dev_db.dev_table SET l_ip='".$l_ip."', l_port=".$l_port.", d_ip='".$r_ip."', d_port=".$r_port." WHERE guid1='".$I1."'";
				error_log( $query_str."\r\n", 3, '/tmp/php-server.log' );
				mysql_unbuffered_query( $query_str, $con );
				mysql_close( $con );
				break;			
			}
				
		}
		socket_close( $conn );
	}
	
	socket_close( $sock );
	
//-----------------------------------------------------------------------------
Function touch_mysql() {

	global $mysql_user, $mysql_pass;
	
	$con = mysql_connect( 'localhost', $mysql_user, $mysql_pass );
	if( !$con )
		die( 'Could not connect: ' . mysql_error() );
		
	mysql_unbuffered_query( "SET NAMES 'utf8'", $con );
	//mysql_select_db( 'dev_db', $con );
	return $con;
}

// str - I1=guid1, 以 \r\n 结尾
// 成功-返回 guid1 字符串； 否则返回空字符串
function get_guid1( $str ) {
	$tok = strtok( $str, " =\n\t\r" );
	if( $tok==='I1' ) {
		$tok = strtok( " =\r\n\t" );
		if( empty($tok) )
			$tok = '';			
	}
	else
		$tok = '';
	
	return $tok;
}
//-----------------测试代码----------------------
/*
	sleep( 8 );

	$sock = socket_create( AF_INET, SOCK_STREAM, 0 );
	socket_set_option( $sock, SOL_SOCKET, SO_RCVTIMEO, array("sec"=>3, "usec"=>0 ) );
	socket_set_option( $sock, SOL_SOCKET, SO_SNDTIMEO, array("sec"=>3, "usec"=>0 ) );
	socket_set_option( $sock, SOL_SOCKET, SO_REUSEADDR, 1 );
	
	socket_bind( $sock, $l_ip, $l_port );       		// 绑定客户端连接时，服务器的 ip、port
	socket_connect( $sock, $r_ip, $r_port );
	echo "send message!\n";
	$buff = "wangdehi\r\n";
	sleep( 1 );
	$res = socket_write( $sock, $buff, strlen($buff) );
	echo $res."\n";
	socket_close( $sock );
*/
?>