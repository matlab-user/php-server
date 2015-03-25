<?php

	// 产生用户帐户激活链接

	require_once( "php-lib/codec_lib.php" );
	require_once( "php-lib/randcode.php" );
	
	$config = read_config( 'php-lib/config.cf' );
	$mysql_user = $config->user;
	$mysql_pass = $config->pass;
	
	$active_link_dir = 'active_link_dir';
	if( !is_dir($active_link_dir) )
		mkdir( $active_link_dir );
	
	$file_name = time().'-'.rand(0,time()).'-'.rand();
	$file_name = $active_link_dir.'/'.base64_encode( $file_name ).'.php';
	//echo $file_name."\r\n";
	//echo randCode( 6, 0 )."\r\n";
	
	$fp = fopen( $file_name, "w+" ); 
	if( !is_writable($file_name) )
		  die("file:" .$file_name. "Unwriteable! \r\n");

	fwrite( $fp, "anything you want to write to ".$file_name );
	fclose( $fp );  //关闭指针
?>