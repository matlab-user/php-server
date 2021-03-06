<?php

	// 未支持 I2 E C 参数
	// 未处理数据中的 单位
	// 此程序仅支持 key=value 形式的数据传输，即所有 value 须为可显示字符

	require_once( dirname(__FILE__)."/php-lib/codec_lib.php" );
/*	
	$W = '[1982;(1,2.4,ucm,t-2,g1)(2,2.56,t1,g2)]'; 
	$res = decode_W( $W );
	var_dump( $res );
	return;
*/
	$config = read_config( dirname(__FILE__).'/php-lib/config.cf' );
	$mysql_user = $config->user;
	$mysql_pass = $config->pass;
	
	// $config->upload_path 必须以 / 结尾
	mkdirs( $config->upload_path );
	
	$raw_post_data = file_get_contents( 'php://input' );
	error_log( date("Y-m-d H:i:s")."\t".$raw_post_data."\r\n", 3, '/tmp/php_server_0x82.log' );
	
/*
	$_POST['TIME'] = '1234,+1';
	//$_POST['W'] = '[1982011602030410182910a1F2C3D02A;(1,2.4,ucm,t-2)(2,2.56,t+1)][1982011602030410182910a1F2C3D02A;(1,34)(2,wdh,dascii)(3,asd,dascii)]'; 
	$_POST['W'] = '[1982011602030410182910a1F2C3D02A;(1,2.4,ucm,t-2,dascii)(2,2.56,t+1)][1982011602030410182910a1F2C3D02A;(3,34)(4,0.5)]'; 
	$_POST['I1'] = '1982011602030410182910a1F2C3D02A';
	//$_POST['T'] = 'alarm';
	$_POST['T'] = 'file';

	$_POST['I1'] = '1982011602030410182910a1F2C3D02A';
	$_POST['W'] = '[1982011602030410182910a1F2C3D02A;(1,2.4,ucm,t-2)(2,2.56,t1)]'; 
	$_POST['TIME'] = '1417074241';
*/

	if( !( isset($_POST['W']) & isset($_POST['I1']) ) )
		exit;
	
	// 以后须增加 I1 参数的合法性验证
	
	if( !isset($_POST['E']) )
		$_POST['E'] = 'NULL';
		
	if( !isset($_POST['C']) )
		$_POST['C'] = 'NULL';
	
	if( !isset($_POST['T']) )
		$_POST['T'] = 'data';
		
	$str = date("Y-m-d H:i:s")."\t".$_POST['TIME']."\t".$_POST['T']."\t".$_POST['I1']."\t".$_POST['W']."\r\n";
	error_log( $str, 3, '/tmp/php_server_0x82.log' );
	
	if( $_POST['TIME']=='0')
		$_POST['TIME'] = time();
		
	switch( $_POST['T'] ) {
		case 'data':
			if( !isset($_POST['TIME'] ) )
				exit;
			$t_int = decode_time( $_POST['TIME'] );
			$d = decode_W( $_POST['W'] );
			if( $d!==false ) {
				count_data_time( $t_int, $d );
				//show_W_obj( $d );
				
				foreach( $d as $v ) {
					$dev_id = $v->dev_id;
					foreach( $v->data as $value ) {
						$query_str = "CALL user_db.save_val_data( '".$dev_id."',".$value->id.",".$value->value.",".$value->time." )";
						//$query_str = sprintf( "SELECT d_t, v_name, utid FROM data_db.dev_data_unit WHERE dev_id='%s' AND d_id=%s", $dev_id, $value->id );
						error_log( $query_str."\r\n", 3, '/tmp/php_server_0x82.log' );
						$con = touch_mysql();
						$res = mysql_query( $query_str, $con );
/*						if( !$res ) {
							error_log( "mysql query results is empty!\r\n", 3, '/tmp/wang.log' );
							mysql_close( $con );
							exit;
						}
						$row = mysql_fetch_row( $res );
						$dt = $row[0];
						$vname = $row[1];
						$utid = $row[2];
						mysql_free_result( $res );
						
						$query_str = sprintf( "SELECT unit FROM data_db.unit_table WHERE id=%s", $utid );
						if( !$res ) {
							error_log( "mysql query results is empty!\r\n", 3, '/tmp/wang.log' );
							mysql_close( $con );
							exit;
						}
						$row = mysql_fetch_row( $res );
						$unit = $row[0];
						mysql_free_result( $res );
						
						if( $dt==0 ) {					// 积累数据
							$query_str = sprintf( "INSERT INTO data_db.his_data ( dev_id, d_id, v_name, unit, value, time ) VALUES ( '%s', %s, '%s', '%s', %s, %f )", $dev_id, $value->id, $vname, $unit, $value->value, $value->time );
							mysql_query( $query_str, $con );
						}
						else {
							$query_str = sprintf( "INSERT INTO data_db.real_data ( dev_id, d_id, v_name, unit, value, time ) VALUES ( '%s', %s, '%s', '%s', %s, %f )", $dev_id, $value->id, $vname, $unit, $value->value, $value->time );
							mysql_query( $query_str, $con );
							$query_str = sprintf( "UPDATE data_db.real_data SET value=%s, v_name='%s', time=%f WHERE dev_id='%s' AND d_id=%s", $value->value, $vname, $value->time, $dev_id, $value->id );
							mysql_query( $query_str, $con );							
						}
*/
						mysql_close( $con );
					}
				}
			}
			break;
			
		case 'alarm':
			if( !isset($_POST['TIME'] ) )
				exit;	
			$t_int = decode_time( $_POST['TIME'] );
			$d = decode_W( $_POST['W'] );
			
			if( $d!==false ) {
				count_data_time( $t_int, $d );
				show_W_obj( $d );
				
				foreach( $d as $v ) {
					$dev_id = $v->dev_id;
					foreach( $v->data as $value ) {
						$query_str = "CALL add_alarm( '".$dev_id."',".$value->id.",".$value->value.",".$value->time." )";
						echo 'alarm: '.$query_str."\n";
						$con = touch_mysql();
						mysql_query( $query_str, $con );
						mysql_close( $con );
					}
				}
			}
			break;
			
		case 'image':
		case 'file':
			if( !isset($_POST['TIME'] ) )
				exit;	
			$t_int = decode_time( $_POST['TIME'] );
			$d = decode_W( $_POST['W'] );
			if( $d!==false )
				count_data_time( $t_int, $d );
			else
				exit;
				
			if( !isset($_POST['CN']) )
				$_POST['CN'] = 'plain';
			
			switch( $_POST['CN'] ) {
				case 'base64':
					$c = base64_decode( $d[0]->data[0]->value ); 		
					break;
				default:
					$c = $d[0]->data[0]->value;
					break;
			}
			
			if( !isset($_POST['S']) )
				$_POST['S'] = '0';
				
			switch( $_POST['S'] ) {
				case '2':			// 追加方式
					if( !isset($_POST['F']) )
						exit;
					$file_path = $config->upload_path.$_POST['F'];
					$fid = fopen( $file_path, 'a+' );
					break;
				default:
					if( !isset($_POST['F']) )
						$_POST['F'] = $_POST['I1'].'_'.time().'.dat';
					$file_path = $config->upload_path.$_POST['F'];
					$fid = fopen( $file_path, 'w+' );
					break;
			}
			fwrite( $fid, $c );
			fclose( $fid );
			
			// 写入数据库
			$value = $d[0]->data[0];
			$dev_id = $d[0]->dev_id;
			
			$con = touch_mysql();
			$query_str = "CALL save_file( '".$dev_id."',".$value->id.",'".$file_path."',".$value->time." )";
			echo $query_str."\n";
			mysql_query( $query_str, $con );
			mysql_close( $con );
			break;
			
		default:
			break;
	}
	
/*	
	$file_d = "F=wangdehui.bmp\0T=file/image\0\rxiezhimei";
	$res = decode_file_data( $file_d );
	
	$res->time = time();
	$res->show();

	$f_d = get_file_data( $file_d );
	echo $f_d."\n";
*/

//-----------------------------------------------------------------------------
	Function touch_mysql() {
	
		global $mysql_user, $mysql_pass;
		
		$con = mysql_connect( 'localhost', $mysql_user, $mysql_pass );
		if( !$con ) {
			error_log( "mysql touch failed--".mysql_error()."\r\n", 3, '/tmp/php_server_0x82.log' );
			die( 'Could not connect: ' . mysql_error() );
		}
		
		mysql_query( "SET NAMES 'utf8'", $con );
		mysql_select_db( 'user_db', $con );
		return $con;
	}	
?>