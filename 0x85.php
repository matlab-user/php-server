<?php

	set_time_limit( 30 );

	// 增加身份验证信息
	require_once( dirname(__FILE__).'/php-lib/codec_lib.php' );
	$config = read_config( dirname(__FILE__).'/php-lib/config.cf' );
	$mysql_user = $config->user;
	$mysql_pass = $config->pass;
	
	$l_ip = strtok( $config->domain, ":" );						// 本地 ip
	$port_arr = range( 1024, 65535 );							// 本地 port
	$l_port = array_rand( $port_arr );
	$r_ip = '';									// 客户 ip
	$r_port = '';								// 客户 port
	
	$sock = socket_create( AF_INET, SOCK_STREAM, 0 );
	socket_set_option( $sock, SOL_SOCKET, SO_RCVTIMEO, array("sec"=>10, "usec"=>0 ) );
	socket_set_option( $sock, SOL_SOCKET, SO_SNDTIMEO, array("sec"=>3, "usec"=>0 ) );
	
	$sig = 0;
	for( $i=0; $i<=10; $i++ ) {
		if( socket_bind( $sock, $l_ip, $l_port )===FALSE ) {       		// 绑定要监听的 ip、port
			$l_port = array_rand( $port_arr );
		}
		else {
			$sig = 1;
			break;
		}
	}

	if( $sig==0 )
		exit;

	echo 'W=SAME;'.$l_port."\r\n";
	socket_close( $sock );
		
	$cmd = 'nohup php 0x85-exec.php '.$l_ip.' '.$l_port.' > /dev/null 2>&1 &';
	error_log( $cmd.'---------'.$_POST['I1']."\r\n", 3, '/tmp/php-server_0x85.log' );
	exec( $cmd );

	// echo gethostbyname( $config->domain )."\n";
	// echo getenv( 'REMOTE_ADDR' ).";".getenv( 'REMOTE_PORT' )."\n";
?>