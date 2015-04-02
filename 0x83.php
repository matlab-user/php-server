<?php

	// 未支持 I2 E C 参数
	// 未处理数据中的 单位
	// 此程序仅支持 key=value 形式的数据传输，即所有 value 须为可显示字符

	require_once( "php-lib/codec_lib.php" );
	
	$config = read_config( 'php-lib/config.cf' );
	$mysql_user = $config->user;
	$mysql_pass = $config->pass;

	$_POST['T'] = 'dev/funs';
	//$_POST['T'] = 'dev/info';
	//$_POST['T'] = 'file/image';
	$_POST['I1'] = 'A1B0C4D0E0FF';
	$_POST['W'] = '<funs><f><id>12</id><n>wdh</n><r>fun_remark</r><p><n>p1</n><r>p1_remark</r><u>u1</u></p><p><n>p2</n></p></f><f><id>13</id><n>wdh2</n></f></funs>';
	//$_POST['W'] = '<dev><n>dev_name</n><m>model</m><c>company</c><tz>9</tz><logo></logo><d><id>1</id><n>s1</n><unit>w1</unit></d><d><id>2</id><n>s2</n><unit>w2</unit></d></dev>';

	if( !( isset($_POST['W']) & isset($_POST['I1']) ) )
		exit;
	
	if( !isset($_POST['T']) )
		exit;

	switch( $_POST['T'] ) {
		case 'dev/funs':
			$_POST['W'] = preproc_str( $_POST['W'] );
			parse_save_funs( $_POST['W'] );
			break;
			
		case 'dev/info':
			$_POST['W'] = preproc_str( $_POST['W'] );
			parse_save_dev_info( $_POST['W'] );
			break;
		
		case 'file/image':
			$raw_post_data = file_get_contents( 'php://input' );
			echo $raw_post_data."\n"; 
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
		add_fun( $one_f, count($ps_info) );
		add_fun_p( $one_f->id, $ps_info );
	}
}

function add_fun( $one_f, $pnum ) {
	
		
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
	
	$str .= "'m', ".$pnum." )";
	
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
	
		//echo $str."\r\n";
		mysql_unbuffered_query( $str, $sql_con );
		mysql_close( $sql_con );		
	}	
}

class dev_info {
	public $n = '';
	public $m = '';
	public $c = '';
	public $tz = '';
	public $logo = '';
	public $lo = '';
	public $la = '';
	public $h = '';
	public $data_info = []; 	
}

class dev_data_info {
	public $id = '';
	public $name = '';
	public $remark = '';
	public $type = '';
	public $st = '';
	public $sd = '';
	public $unit = '';
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
				
			case 'tz':
				$dev_info->tz = $v->__toString();
				break;
			
			case 'logo':
				$dev_info->logo = $v->__toString();
				break;
			
			case 'lo':
				$dev_info->lo = $v->__toString();
				break;
				
			case 'la':
				$dev_info->la = $v->__toString();
				break;
				
			case 'h':
				$dev_info->h = $v->__toString();
				break;
			
			case 'd':
				$mid_data_info = new dev_data_info();
				foreach ( $v as $key => $value ) {
					switch( $key ) {
						case 'id':
							$mid_data_info->id = $value->__toString();
							break;
						case 'n':
							$mid_data_info->name = $value->__toString();
							break;
						case 'rem':
							$mid_data_info->remark = $value->__toString();
							break;
						case 'ty':
							$mid_data_info->type = $value->__toString();
							break;
						case 'unit':
							$mid_data_info->unit = $value->__toString();
							break;
						case 'st':
							$mid_data_info->st = $value->__toString();
							break;
						case 'sd':
							$mid_data_info->sd = $value->__toString();
							break;
						default:
							break;
					}
				}
				array_push( $dev_info->data_info, $mid_data_info );
				break;
				
			default:
				break;
		}	
	}
	//var_dump( $dev_info );
	//var_dump( $dev_info->data_info );
	$sql_str = "UPDATE dev_db.dev_table SET ";
	if( !empty($dev_info->n) )
		$sql_str .= 'name="'.$dev_info->n.'", ';
	
	if( !empty($dev_info->m) )
		$sql_str .= "model='".$dev_info->m."', ";
	
	if( !empty($dev_info->c) )
		$sql_str .= "maker='".$dev_info->c."', ";
	
	if( !empty($dev_info->tz) )
		$sql_str .= "timezone=".$dev_info->tz.", ";
	
	if( !empty($dev_info->logo) )
		$sql_str .= "logo='".$dev_info->logo."', ";
	
	if( !empty($dev_info->lo) )
		$sql_str .= "longitude='".$dev_info->lo."', ";
	
	if( !empty($dev_info->la) )
		$sql_str .= "latitude='".$dev_info->la."', ";
	
	if( !empty($dev_info->h) )
		$sql_str .= "height='".$dev_info->h."', ";
	
	$mstr = substr( $sql_str, -2 );
	if( $mstr==', ' )
		$sql_str = rtrim( $sql_str, ', ' );
	
	$sql_str .= " WHERE guid1='".$_POST['I1']."'";
	
	$sql_con = touch_mysql();
	mysql_unbuffered_query( $sql_str, $sql_con );
	mysql_close( $sql_con );
		
	// 注册上传数据类型
	foreach( $dev_info->data_info as $v ) {
		
		if( $v->id=='' | $v->unit=='' )
			return false;
		
		if( $v->st=='' )
			$v->st = 1;				// 默认为不累积保存
		
		if( $v->type=='' )
			$v->type = '7';
		
		if( $v->name=='' )
			$v->name = $v->id;
		
		$sql_str = "CALL insert_dev_data_unit( '".$_POST['I1']."', ".$v->id.", '".$v->unit."', '".$v->type."', '".$v->name."', '".$v->remark."', ".$v->st." )";
		//echo $sql_str."\r\n";
		
		$sql_con = touch_mysql();
		mysql_unbuffered_query( $sql_str, $sql_con );
		mysql_close( $sql_con );
	}

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

// 对字符串进行防注入处理
function preproc_str( $str ) {
	$res = addslashes( $str );
	$res = str_replace( "_", "\_", $res );
	$res = str_replace( "%", "\%", $res );
	return $res;
}
?>