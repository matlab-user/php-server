<?php

	set_time_limit( 30 );

	// 增加身份验证信息
	require_once( dirname(__FILE__)."/php-lib/codec_lib.php" );

	$config = read_config( dirname(__FILE__).'/php-lib/config.cf' );
	$mysql_user = $config->user;
	$mysql_pass = $config->pass;
	
	$l_ip = '192.168.31.21';		// 本地 ip
	$l_port = '';				// 本地 port
	$r_ip = '';					// 客户 ip
	$r_port = '';				// 客户 port
	
	$sock = socket_create( AF_INET, SOCK_STREAM, 0 );
	socket_set_option( $sock, SOL_SOCKET, SO_RCVTIMEO, array("sec"=>10, "usec"=>0 ) );
	socket_set_option( $sock, SOL_SOCKET, SO_SNDTIMEO, array("sec"=>3, "usec"=>0 ) );
	
	socket_bind( $sock, $l_ip, 0 );       		// 绑定要监听的 ip、port
	socket_getsockname( $sock, $l_ip, $l_port );		// 获取绑定的 ip、port
	socket_close( $sock );
		
	echo 'W=SAME;'.$l_port."\r\n";
	
	$cmd = 'nohup php 0x85-exec.php '.$l_ip.' '.$l_port.'> /dev/null 2>&1 &';
	exec( $cmd );

	// echo gethostbyname( $config->domain )."\n";
	// echo getenv( 'REMOTE_ADDR' ).";".getenv( 'REMOTE_PORT' )."\n";
?>