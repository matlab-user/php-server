/*		添加demo设备		*/
SET @g1 = 'example-1';
SET @g2 = 'example';
SET @intv = 30;
SET @name = '实唯样例设备-1';

INSERT INTO dev_db.dev_table SET guid1=@g1, guid2=@g2, intv=@intv, name=@name, k='wangdehui', owner='demo2', model='wdh-1', state='running', maker='成都实唯科技', longitude=104.06, latitude=30.67;

/* 增加单位 */
INSERT INTO data_db.unit_table SET unit='<sup>。</sup>';
INSERT INTO data_db.unit_table SET unit='ppm';
INSERT INTO data_db.unit_table SET unit='<sup>。</sup>C';

/*   增加设备参数信息  */	
/*   数据累积型 2个   */
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 1, @g1, 0, id, '角度', '转动角度' FROM data_db.unit_table WHERE unit='<sup>。</sup>';
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 2, @g1, 0, id, 'CO2浓度', '大气二氧化碳浓度' FROM data_db.unit_table WHERE unit='ppm';
/*   数据非累积型 1个   */
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 3, @g1, 1, id, '温度', '大气温度' FROM data_db.unit_table WHERE unit='<sup>。</sup>C';
/*   图片数据 1个  */
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 4, @g1, 0, id, '观测点1', '某观测点的图像' FROM data_db.unit_table WHERE unit='file/image';

/* 增加设备操作信息 */
CALL user_db.add_fun( @g1, 1, '待机', '设备停止', 'b', 0 );

CALL user_db.add_fun( @g1, 2, '水平转动', '控制设备水平转动', 'b', 1 );
CALL user_db.add_fun_p( @g1, 2, '转动角度', '水平角转动角度值', 1, '<sup>。</sup>C' );

CALL user_db.add_fun( @g1, 3, '双轴转动', '控制设备水平、俯仰转动', 'b', 2 );
CALL user_db.add_fun_p( @g1, 3, '方位转角', '方位角转动角度值', 1, '<sup>。</sup>C' );
CALL user_db.add_fun_p( @g1, 3, '俯仰转角', '俯仰角转动角度值', 2, '<sup>。</sup>C' );