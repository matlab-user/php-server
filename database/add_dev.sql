/* ADD USER test */
INSERT INTO user_db.user_table SET uid='1982011602030410182910a1F2C3D02A', name='test', passwd=MD5('test'), phone='18215512330';
/*
	dev	-guid1(hex) 19-82-01-16-02-03-04-10-18-29-10-a1-F2-C3-D0-2A
		-guid2(hex)	19-82-01-16-02-03-04-10-28-19-30-E1-F2-1C-2D-2B
*/

SET @g1 = '1982011602030410182910a1F2C3D02A';
SET @g2 = '1982011602030410281930E1F21C2D2B';
SET @intv = 30;
SET @name = '空气参数测量仪';

/* 增加设备 */
INSERT INTO dev_db.dev_table SET guid1=@g1, guid2=@g2, intv=@intv, name=@name, k='wangdehui', owner=@g1;

/* 增加单位 */
INSERT INTO data_db.unit_table SET unit='%';
INSERT INTO data_db.unit_table SET unit='<sup>。</sup>C';
INSERT INTO data_db.unit_table SET unit='V';
INSERT INTO data_db.unit_table SET unit='ppt';
INSERT INTO data_db.unit_table SET unit='p';
INSERT INTO data_db.unit_table SET unit='<sup>。</sup>';
INSERT INTO data_db.unit_table SET unit='ppm';
INSERT INTO data_db.unit_table SET unit='lux';

/* 
	增加设备参数信息
	数据非累积型
*/
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 1, @g1, 0, id, '湿度', '客厅内的湿度' FROM data_db.unit_table WHERE unit='%';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 2, @g1, 1, id, '温度', '客厅内的温度' FROM data_db.unit_table WHERE unit='<sup>。</sup>C';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 3, @g1, 1, id, '氧气浓度', '客厅内的氧气浓度' FROM data_db.unit_table WHERE unit='ppt';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 4, @g1, 1, id, '电压', '仪器电源电压' FROM data_db.unit_table WHERE unit='V';

/* 增加alarm信息 */
INSERT INTO data_db.alarm ( d_id, dev_id, thr, method ) VALUE ( 1, @g1, 90, '>' );
INSERT INTO data_db.alarm ( d_id, dev_id, thr, method ) VALUE ( 2, @g1, 35, '>' );
INSERT INTO data_db.alarm ( d_id, dev_id, thr, method ) VALUE ( 3, @g1, 20, '<=' );
INSERT INTO data_db.alarm ( d_id, dev_id, thr, method ) VALUE ( 4, @g1, 10, '<' );

/*   增加alarm_message */
INSERT INTO data_db.alarm_message ( dev_id, d_id, dev_name, d_remark, t, v, b, phone, tz, unit ) VALUES ( @g1, 1, @name, '客厅内的湿度', 1406637812, 20, 1, 18215512330, 8, '%' );

/* 增加即时数据 */
INSERT INTO data_db.real_data ( d_id, dev_id, unit, v_name, value, time ) VALUE ( 1, @g1, '%', '湿度', 49.4, 1406637812 );
INSERT INTO data_db.real_data ( d_id, dev_id, unit, v_name, value, time ) VALUE ( 2, @g1, '<sup>。</sup>C', '温度', 24.8, 1406637812 );
INSERT INTO data_db.real_data ( d_id, dev_id, unit, v_name, value, time ) VALUE ( 3, @g1, 'ppt', '氧气浓度', 34.8, 1406637812 );
INSERT INTO data_db.real_data ( d_id, dev_id, unit, v_name, value, time ) VALUE ( 4, @g1, 'V', '电压', 11.6, 1406637812 );

/* 增加设备操作信息 */
INSERT INTO dev_db.dev_fun ( dev_id, fun_id, fun_name, m, p_num, remark ) VALUES ( @g1, 1, '转动', 'm', 4, '控制设备转动' );
INSERT INTO dev_db.dev_fun ( dev_id, fun_id, fun_name, m, p_num, remark ) VALUES ( @g1, 2, '启动', 'b', 2, '设备启动' );
INSERT INTO dev_db.dev_fun ( dev_id, fun_id, fun_name, m, p_num, remark ) VALUES ( @g1, 3, '停止', 'b', 0, '设备停止' );

UPDATE dev_db.dev_fun SET p1_name='方位角', p2_name='俯仰角', p3_name='方位角转速', p4_name='俯仰角转速' WHERE dev_id = @g1 AND fun_id=1;
UPDATE dev_db.dev_fun SET p1_remark='单位:角度', p2_remark='单位:角度', p3_remark='单位:角度/秒', p4_remark='单位:角度/秒' WHERE dev_id = @g1 AND fun_id=1;

UPDATE dev_db.dev_fun SET p1_name='模式', p2_name='启动时间' WHERE dev_id = @g1 AND fun_id=2;
UPDATE dev_db.dev_fun SET p1_remark='设备启动后进入的状态', p2_remark='启动时间，默认为立即启动' WHERE dev_id = @g1 AND fun_id=2;

/* 将设备添加至cell */
INSERT INTO cell_db.cell_table ( name, cell_id ) VALUE ( 'default_cell', '0102030040506' );
INSERT INTO cell_db.cell_form ( c_id, dev_id ) VALUE ( '0102030040506', @g1 );

/*     dev 2    */ 
SET @g1 = '00000000000000000000A0B0C0D0E0F0';
SET @g2 = '0000000000000000000010A0C0010002';
INSERT INTO dev_db.dev_table SET guid1=@g1, guid2=@g2, intv=10, name='气象数据采集仪', owner='1982011602030410182910a1F2C3D02A';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 1, @g1, 0, id, '温度', '室外温度' FROM data_db.unit_table WHERE unit='<sup>。</sup>C';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 2, @g1, 1, id, '湿度', '室外湿度' FROM data_db.unit_table WHERE unit='%';
INSERT INTO data_db.alarm ( d_id, dev_id, thr, method ) VALUE ( 1, @g1, 10, '>' );
INSERT INTO data_db.alarm ( d_id, dev_id, thr, method ) VALUE ( 2, @g1, 36, '>' );

/* dev 2 添加进 cell */
INSERT INTO cell_db.cell_table ( name, cell_id ) VALUE ( 'wangdehui', '0102030405060708090A' );
INSERT INTO cell_db.cell_form (  c_id, dev_id ) VALUE ( '0102030405060708090A', @g1 );

/*    cell: wangdehui dev 3  */   
SET @g1 = 'A1B0C4D0E0FF';
INSERT INTO dev_db.dev_table SET guid1=@g1, intv=12, name='环境数据采集仪', owner='1982011602030410182910a1F2C3D02A';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 1, @g1, 1, id, '湿度', '室外湿度' FROM data_db.unit_table WHERE unit='%';
INSERT INTO data_db.alarm ( d_id, dev_id, thr, method ) VALUE ( 1, @g1, 10, '>' );
INSERT INTO cell_db.cell_form (  c_id, dev_id ) VALUE ( '0102030405060708090A', @g1 );
	
/*    cell: wangdehui dev 4  图像设备  */   
SET @g1 = '1982011602030410182910a1F2C3D08A';
SET @g2 = '1982011602030410281930E1F21C2D21';
INSERT INTO dev_db.dev_table SET guid1=@g1, guid2=@g2, intv=12, k='wangdehui', name='图像采集仪', owner='1982011602030410182910a1F2C3D02A';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 1, @g1, 1, id, '室内图像', '我的办公司' FROM data_db.unit_table WHERE unit='file/image';
INSERT INTO data_db.alarm ( d_id, dev_id, thr, method ) VALUE ( 1, @g1, 10, 'none' );
INSERT INTO data_db.real_data ( dev_id, d_id, v_name, unit, time, bin_d ) VALUE ( @g1, 1, '室内图像', 'file/image', 0, '' );
INSERT INTO cell_db.cell_form (  c_id, dev_id ) VALUE ( '0102030405060708090A', @g1 );

/*    cell: wangdehui dev 5  视频设备		*/   
/*	  目前视频参数id( d_id ) 仅支持为 1 	*/
/*
SET @g1 = '1983011602030410182910a1F2C8D08A';
SET @g2 = '1982011602030410281930E1F21C2D21';
INSERT INTO dev_db.dev_table SET guid1=@g1, guid2=@g2, intv=12, k='wangdehui', name='视频采集', owner='1982011602030410182910a1F2C3D02A';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 1, @g1, 1, id, '地点1视频', '我的空间' FROM data_db.unit_table WHERE unit='file/video';
INSERT INTO data_db.alarm ( d_id, dev_id, thr, method ) VALUE ( 1, @g1, 10, 'none' );
INSERT INTO data_db.real_data ( dev_id, d_id, v_name, unit, time, bin_d ) VALUE ( @g1, 1, '室内图像', 'file', 0, '' );
INSERT INTO cell_db.cell_form (  c_id, dev_id ) VALUE ( '0102030405060708090A', @g1 );
*/

/*		添加公司第一台设备		*/
SET @g1 = '54455354444556535357415900000001';
SET @g2 = '00000001535741594445565354455354';
SET @intv = 30;
SET @name = '农业环境测量仪';

/* 增加设备 */
INSERT INTO dev_db.dev_table SET guid1=@g1, guid2=@g2, intv=@intv, name=@name, k='wangdehui', owner=@g1;

/* 
	增加设备参数信息
	数据累积型
*/
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 1, @g1, 0, id, '姿态', '设备姿态' FROM data_db.unit_table WHERE unit='<sup>。</sup>';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 2, @g1, 0, id, 'CO2浓度', '大气二氧化碳浓度' FROM data_db.unit_table WHERE unit='ppm';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 3, @g1, 0, id, '土壤温度', '土壤温度' FROM data_db.unit_table WHERE unit='<sup>。</sup>C';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 4, @g1, 0, id, '土壤湿度', '土壤湿度' FROM data_db.unit_table WHERE unit='%';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 5, @g1, 0, id, '大气温度', '大气温度' FROM data_db.unit_table WHERE unit='<sup>。</sup>C';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 6, @g1, 0, id, '大气湿度', '大气湿度' FROM data_db.unit_table WHERE unit='%';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 7, @g1, 0, id, '光照', '太阳光照强度' FROM data_db.unit_table WHERE unit='lux';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 8, @g1, 0, id, '大气压力', '大气压力' FROM data_db.unit_table WHERE unit='p';

/* 将设备添加至cell */
INSERT INTO cell_db.cell_form ( c_id, dev_id ) VALUE ( '0102030040506', @g1 );