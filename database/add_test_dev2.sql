/*		添加公司第二台设备		*/
SET @g1 = '54455354444556535357415900000002';
SET @g2 = '00000002535741594445565354455354';
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