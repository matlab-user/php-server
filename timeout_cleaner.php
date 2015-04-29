<?php
	// 清理指定文件夹内超时文件

	require_once( dirname(__FILE__)."/php-lib/codec_lib.php" );

	$config = read_config( dirname(__FILE__).'/php-lib/config.cf' );
	$timeout = $config->timeout;
	$mysql_user = $config->user;
	$mysql_pass = $config->pass;
	
	$MAX_NUM = 64;			// 每台设备所能保存的最大数量文件数,必须大于等于 1
	
	//打开文件目录(末尾加‘/’)
	$file_dir = dirname(dirname(__FILE__)).'/'.$config->upload_path;
	if( !is_dir($file_dir) ) 
		return;
	
	$dev_id = $argv[1];
	$d_id = intval($argv[2]);
	//$dev_id = 'TFwqovfw';
	//$d_id = 3;
	
	// 清除超时文件
	$file_name = get_file_name_in_database( $dev_id, $d_id );
	cleaner( $file_dir, $timeout, $dev_id, $file_name );
	
	$num = count_dev_files_num( $file_dir, $dev_id );
	if( $num>$MAX_NUM )
		clean_oldest_file( $file_dir, $dev_id );
	
//--------------------------------------------------------------
// $leave_file - 要保留的文件名
// 清除 $dev_id 的超时文件，除了要保留的文件
	function cleaner( $file_dir, $timeout, $dev_id, $leave_file ) {
		
		//列出目录中的文件
		$dir = opendir( $file_dir );
		while( ($file=readdir($dir))!==false ) {
			
			if( $file=='.'  ||  $file=='..' || $file==$leave_file )
				continue;	
			if( is_dir($file_dir.$file) ) 
				continue;
			
			if( strpos($file, $dev_id)!==FALSE ) {
				$now = time();
				$ct = filemtime( $file_dir.$file );
				if( ($now-$ct)>$timeout ) {
					//echo "filename: ".$file_dir.$file."\t\tCT: ".($now-$ct)."\r\n";
					unlink( $file_dir.$file );
				}
			}
		}
		closedir( $dir );
	}
	
	function touch_mysql() {

		global $mysql_user, $mysql_pass;
		
		$con = mysql_connect( 'localhost', $mysql_user, $mysql_pass );
		if( !$con )
			die( 'Could not connect: ' . mysql_error() );
			
		mysql_unbuffered_query( "SET NAMES 'utf8'", $con );
		mysql_select_db( 'data_db', $con );
		return $con;
	}
	
	function get_file_name_in_database( $dev_id, $d_id ) {
		
		$con = touch_mysql();
		
		$res = mysql_query( "SELECT utid FROM data_db.dev_data_unit WHERE dev_id='".$dev_id."' AND d_id=".$d_id, $con );
		if( empty($res) ) {
			mysql_close( $con );
			return '';
		}
		$row1 = mysql_fetch_array( $res );
		$utid = $row1[0];
		mysql_free_result( $res );
		
		// 获取单位
		$unit = '';
		$res1 = mysql_query( "SELECT unit FROM data_db.unit_table WHERE id=".$utid, $con );
		if( empty($res1) ) {
			mysql_close( $con );
			return '';
		}
		while( $row1=mysql_fetch_array( $res1 ) )
			$unit = $row1[0];
		mysql_free_result( $res1 );
		
		if( strpos($unit,'file')===FALSE ) {
			mysql_close( $con );
			return '';
		}
		
		$sql_str = "SELECT bin_d FROM data_db.real_data WHERE dev_id='".$dev_id."' AND d_id=".$d_id;
		$res1 = mysql_query( $sql_str, $con );
		if( empty($res1) ) {
			mysql_close( $con );
			return '';
		}
		
		$row1 = mysql_fetch_array( $res1 );
		$file_name = basename( $row1[0] );
		mysql_free_result( $res1 );
		
		return $file_name;
		
		mysql_close( $con );
	}
	
// 计算给定文件夹内，$dev_id 设备上传的文件数量
	function count_dev_files_num( $file_dir, $dev_id ) {
		
		$num = 0;
		//列出目录中的文件
		$dir = opendir( $file_dir );
		while( ($file=readdir($dir))!==false ) {
			
			if( $file=='.'  ||  $file=='..' )
				continue;	
			if( is_dir($file_dir.$file) ) 
				continue;
			
			if( strpos($file, $dev_id)!==FALSE )
				$num++;
		}
		closedir( $dir );
		return $num;
	}
	
	function clean_oldest_file( $file_dir, $dev_id ) {
		
		global $MAX_NUM;
		
		$file_name = array();
		
		//列出目录中的文件
		$dir = opendir( $file_dir );
		while( ($file=readdir($dir))!==false ) {
			
			if( $file=='.'  ||  $file=='..' )
				continue;	
			if( is_dir($file_dir.$file) ) 
				continue;
			
			if( strpos($file, $dev_id)!==FALSE ) {
				$file_name[$file] = filemtime( $file_dir.$file );
			}

		}
		
		asort( $file_name );
		$le = count( $file_name ) - $MAX_NUM;
		array_splice( $file_name, $le );
		foreach( $file_name as $k=>$v ) {
			unlink( $file_dir.$k );	
		}
		closedir( $dir );
	}
?>