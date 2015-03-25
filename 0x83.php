<?php

	// 未支持 I2 E C 参数
	// 未处理数据中的 单位
	// 此程序仅支持 key=value 形式的数据传输，即所有 value 须为可显示字符

	require_once( "php-lib/codec_lib.php" );
	
	$config = read_config( 'php-lib/config.cf' );
	$mysql_user = $config->user;
	$mysql_pass = $config->pass;

	//$_POST['T'] = 'dev/funs';
	//$_POST['T'] = 'dev/info';
	//$_POST['I1'] = 's001';
	//$_POST['W'] = '<funs><f><id>12</id><n>wdh</n><r>fun_remark</r><p><n>p1</n><r>p1_remark</r><u>u1</u></p><p><n>p2</n></p></f><f><id>13</id><n>wdh2</n></f></funs>';
	//$_POST['W'] = '<dev><n>dev_name</n><m>model</m><c>company</c></dev>';

	if( !( isset($_POST['W']) & isset($_POST['I1']) ) )
		exit;
	
	if( !isset($_POST['T']) )
		exit;

	switch( $_POST['T'] ) {
		case 'dev/funs':
			parse_save_funs( $_POST['W'] );
			break;
			
		case 'dev/info':
			parse_save_dev_info( $_POST['W'] );
			break;
			
		default:
			break;
	}
	
//---------------------------------------------------------------------
class fun {
    public $id;
    public $n = "未命名";
    public $r;
}

class p_info {
	public $index = -1;
	public $n = '';
	public $r = '';
	public $u = '';
}
	
function parse_save_funs( $data ) {
	
	$xml = simplexml_load_string( $data );
	
	$one_f = new fun();
		
	$children = $xml->children();
	foreach ( $children as $child ) {
		if( $child->getName()=='f' ) {
			
			$one_f->id = '';
			$one_f->n = '未命名';
			$one_f->r = '';
			
			unset( $ps_info );	
			$ps_info = array();
			$index = 0;
	
			$c = $child->children();
			
			foreach ( $c as $v ) {
				
				switch( $v->getName() ) {
					case 'id':
						$one_f->id = $v->__toString();
						break;
						
					case 'n':
						$one_f->n = $v->__toString();
						break;
						
					case 'r':
						$one_f->r = $v->__toString();
						break;
					
					case 'p':
						$ps_info[$index] = new p_info();
						$ps_info[$index]->index = $index;

						foreach( $v->children() as $k => $pv ) {
							
							switch( $k ) {
								case 'n':
									$ps_info[$index]->n = $pv->__toString();
									break;
									
								case 'r':
									$ps_info[$index]->r = $pv->__toString();
									break;
								
								case 'u':
									$ps_info[$index]->u = $pv->__toString();
									break;
									
								default:
									break;
							}
						}
						$index++;
						break;
						
					default:
						break;
				}
			}	
		}
		
		// 解析完一个 fun
		//var_dump( $one_f );
		//var_dump( $ps_info );
		add_fun( $one_f );
		add_fun_p( $one_f->id, $ps_info );
	}
}

function add_fun( $one_f ) {
	
		
	if( $one_f->id=='' )
		return '';
		
	$sql_con = touch_mysql();
	
	$str = "CALL add_fun( '".$_POST['I1']."', ".($one_f->id).", ";
	
	if( $one_f->n=='' )
		$str .= "'', ";
	else
		$str .="'".($one_f->n)."', ";
	
	if( $one_f->r=='' )
		$str .= "'', ";
	else
		$str .= "'".($one_f->r)."', ";
	
	$str .= "'m' )";
	
	// 添加将函数写入数据库的代码
	if( empty($sql_con) )
		return;
	
	echo $str."\r\n";
	mysql_unbuffered_query( $str, $sql_con );
	
	mysql_close( $sql_con );
}

function add_fun_p( $f_id, $ps_info ) {
	
	foreach( $ps_info as $i => $v ) {
		
		$sql_con = touch_mysql();
				
		$str = "CALL add_fun_p( '".$_POST['I1']."', ".$f_id.", ";
		
		if( $v->n=='' )
			$str .= "'', ";
		else
			$str .="'".($v->n)."', ";
	
		if( $v->r=='' )
			$str .= "'', ";
		else
			$str .="'".($v->r)."', ";
		
		$str .= ($i+1).", ";
		
		if( $v->u=='' )
			$str .= "'' )";
		else
			$str .="'".($v->u)."' )";
	
		// 添加将参数写入数据库的代码
		if( empty($sql_con) )
			return;
	
		echo $str."\r\n";
		mysql_unbuffered_query( $str, $sql_con );
		mysql_close( $sql_con );		
	}	
}

class dev_info {
	public $n = '';
	public $m = '';
	public $c = '';
}

function parse_save_dev_info( $data ) {
	
	$xml = simplexml_load_string( $data );
	$dev_info = new dev_info();
	
	if( $xml->getName()!=='dev' )
		return;
		
	$children = $xml->children();
	foreach ( $children as $v ) {
		switch( $v->getName() ) {
			case 'n':
				$dev_info->n = $v->__toString();
				break;
				
			case 'm':
				$dev_info->m = $v->__toString();
				break;
				
			case 'c':
				$dev_info->c = $v->__toString();
				break;
				
			default:
				break;
		}	
	}
	//var_dump( $dev_info );
	$sql_str = "UPDATE dev_db.dev_table SET ";
	if( !empty($dev_info->n) )
		$sql_str .= "name='".$dev_info->n."', ";
	
	if( !empty($dev_info->m) )
		$sql_str .= "model='".$dev_info->m."', ";
	
	if( !empty($dev_info->c) )
		$sql_str .= "maker='".$dev_info->c."' ";
	
	$sql_str .= "WHERE guid1='".$_POST['I1']."'";
	//echo $sql_str."\r\n";
	
	$sql_con = touch_mysql();
	mysql_unbuffered_query( $sql_str, $sql_con );
	mysql_close( $sql_con );
}
			
function touch_mysql() {
	
	global $mysql_user, $mysql_pass;
	
	$con = mysql_connect( 'localhost', $mysql_user, $mysql_pass );
	if( !$con )
		die( 'Could not connect: ' . mysql_error() );
		
	mysql_unbuffered_query( "SET NAMES 'utf8'", $con );
	mysql_select_db( 'user_db', $con );
	return $con;
}
?>