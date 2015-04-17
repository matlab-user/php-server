<?php

	// 未支持 I2 E C 参数
	// 未处理数据中的 单位
	// 此程序仅支持 key=value 形式的数据传输，即所有 value 须为可显示字符

	require_once( dirname(__FILE__)."/php-lib/codec_lib.php" );

	$config = read_config( dirname(__FILE__).'/php-lib/config.cf' );
	$mysql_user = $config->user;
	$mysql_pass = $config->pass;
	
	// $config->upload_path 必须以 / 结尾
	mkdirs( $config->upload_path );
	
	$raw_post_data = file_get_contents( 'php://input' );
	error_log( date("Y-m-d H:i:s")."\t".$raw_post_data."\r\n", 3, '/tmp/wang_0x81.log' );
	
	$ps = decode_file_data( $raw_post_data );			// 随文件传来的参数
	
	if( empty($ps->i1) | empty($ps->t) | empty($ps->time) | empty($ps->id) | empty($ps->l) )
		exit;
	
	if( empty($ps->f) )
		$_POST['F'] = $_POST['I1'].'-'.time().'.jpg';
	else
		$_POST['F'] = $ps->f;
	
	if( empty($ps->s) )
		$_POST['S'] = 0;
	else
		$_POST['S'] = $ps->s;
	
	$_POST['I1'] = $ps->i1;
	$_POST['T'] = $ps->t;
	$_POST['TIME'] = $ps->time;
	$_POST['ID'] = $ps->id;
	$_POST['L'] = $ps->l;
		
	// 以后须增加 I1 参数的合法性验证
		
	$str = date("Y-m-d H:i:s")."\t".$_POST['TIME']."\t".$_POST['T']."\t".$_POST['I1']."\t".$_POST['F'].$_POST['L']."\r\n";
	error_log( $str, 3, '/tmp/wang_0x81.log' );
	
	switch( $_POST['T'] ) {
		
		case 'image':
		case 'file':

			$f_d = get_file_data( $raw_post_data );				// 获取文件数据
								
			switch( $_POST['S'] ) {
				case '2':			// 追加方式
					$file_path = $config->upload_path.$_POST['F'];
					$fid = fopen( $file_path, 'a+' );
					break;
					
				default:
					$file_path = $config->upload_path.$_POST['F'];
					$fid = fopen( $file_path, 'w+' );
					break;
			}
			fwrite( $fid, $f_d );
			fclose( $fid );
			
			// 写入数据库		
			$con = touch_mysql();
			$query_str = "CALL save_file( '".$_POST['I1']."',".$_POST['ID'].",'".$file_path."',".$_POST['TIME']." )";
			echo $query_str."\n";
			mysql_unbuffered_query( $query_str, $con );
			mysql_close( $con );
			break;
			
		default:
			break;
	}

//-----------------------------------------------------------------------------
	Function touch_mysql() {
	
		global $mysql_user, $mysql_pass;
		
		$con = mysql_connect( 'localhost', $mysql_user, $mysql_pass );
		if( !$con )
			die( 'Could not connect: ' . mysql_error() );
			
		mysql_unbuffered_query( "SET NAMES 'utf8'", $con );
		mysql_select_db( 'user_db', $con );
		return $con;
	}	
?>