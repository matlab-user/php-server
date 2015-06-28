
SET @g1 = 'rZteCbX2';

/*	state 类型数据1个	*/
INSERT INTO data_db.dev_data_unit ( d_id, dev_id, d_t, utid, v_name, remark) SELECT 4, @g1, 0, id, '设备状态', '[ { "0":"传感器1状态","v":["正常","故障"] },{"3":"传感器2状态","v":["正常","故障"]},{"10":"电源状态","v":["电网","电池"]},{"15":"电机1状态","v":["停止","运转"]} ]' FROM data_db.unit_table WHERE unit='state';

