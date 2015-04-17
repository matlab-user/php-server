<?php
	// 清理指定文件夹内超时文件

	require_once( dirname(__FILE__)."/php-lib/codec_lib.php" );

	$config = read_config( dirname(__FILE__).'/php-lib/config.cf' );
	$timeout = $config->timeout;

	//打开文件目录(末尾加‘/’)
	$file_dir = '/home/blue/';
	if( !is_dir($file_dir) ) 
		return;

	cleaner( $file_dir, $timeout );
	
//--------------------------------------------------------------
	Function cleaner( $file_dir, $timeout ) {
		
		//列出目录中的文件
		$dir = opendir( $file_dir );
		while( ($file=readdir($dir))!==false ) {
			
			if( $file=='.'  ||  $file=='..' )
				continue;	
			if( is_dir($file_dir.$file) ) 
				continue;
			
			$now = time();
			$ct = filemtime( $file_dir.$file );
			if( ($now-$ct)>$timeout ) {
				echo "filename: ".$file_dir.$file."\t\tCT: ".($now-$ct)."\r\n";
			}
		}
		closedir( $dir );
	}
?>