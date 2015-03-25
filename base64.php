<?php
	//$str = 'this is a apple!';
	require_once( "php-lib/codec_lib.php" );
	
	$str = array( 255 );
	$res = base64_encode( implode($str) );
	echo $res."\n";
	
	$str2 = base64_decode( $res );
	echo $str2."\n";
	
	$res = read_config( 'php-lib/config.cf' );
	echo $res->user."\n";
	echo $res->pass."\n";
	echo $res->upload_path."\n";
	
	if( is_dir( '/tmp/wang/' ) )
		echo "dir \n";
	else {
		echo "no dir \n";
		mkdirs( '/tmp/wang/' );
	}

/*
	file_get_contents("php://input");
*/
?>