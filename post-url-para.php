<?php

	$raw_post_data = file_get_contents( 'php://input' );
	error_log( date("Y-m-d H:i:s")."\t".$raw_post_data."\r\n", 3, '/tmp/post-get-para.log' );
	error_log( date("Y-m-d H:i:s")."\t".$_GET['id']."\t".$_GET['w']."\r\n", 3, '/tmp/post-get-para.log' );
	error_log( "name  a\t".$_POST['name']."\t".$_POST['a']."\r\n", 3, '/tmp/post-get-para.log' );
	
?>