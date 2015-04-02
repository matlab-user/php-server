/* ------------------------  create user_db -------------------------------- */
CREATE DATABASE IF NOT EXISTS `user_db` DEFAULT CHARACTER SET `utf8`;
CREATE TABLE IF NOT EXISTS user_db.user_table (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
	`uid` CHAR(32) UNIQUE DEFAULT '',
	`name` VARCHAR(60) DEFAULT 'Anonymous',
	`passwd` VARCHAR(32) NOT NULL DEFAULT 'NULL',
	`doas` CHAR(32) DEFAULT 'NULL',
	`state` ENUM('on-line','off-line','forbidden','merge','unknown','inactive') NOT NULL DEFAULT 'inactive',
	`type` ENUM('sway','weixin','company','admin') NOT NULL DEFAULT 'sway',
	`icon` VARCHAR(200) DEFAULT '',
	`logint` BIGINT NOT NULL DEFAULT 0,
	`logoutt` BIGINT NOT NULL DEFAULT 0,
	`phone` VARCHAR(20) DEFAULT '',
	`mail`	VARCHAR(64) UNIQUE DEFAULT '',
	`dnum`	INT DEFAULT 5,
	PRIMARY KEY ( `id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* ------------------------  create dev_db -------------------------------- */
CREATE DATABASE IF NOT EXISTS `dev_db` DEFAULT CHARACTER SET `utf8`;
CREATE TABLE IF NOT EXISTS dev_db.dev_table (
	`guid1` CHAR(32) UNIQUE DEFAULT '',
	`guid2` CHAR(32) DEFAULT '',
	`name` VARCHAR(30) DEFAULT 'DEV',
	`model` VARCHAR(40) DEFAULT 'swaytech-1',
	`maker` VARCHAR(40) DEFAULT 'swaytech',
	`k` VARCHAR(32) NOT NULL DEFAULT 'NULL',
	`state` ENUM('running','stopping','error','unknown','need_data','inactive') NOT NULL DEFAULT 'unknown',
	`owner` CHAR(32) DEFAULT '',
	`t` ENUM('up','op','mix','unknown') NOT NULL DEFAULT 'unknown',
	`intv` INT DEFAULT 60,						/* 更新间隔 */
	`d_ip` VARCHAR(65) DEFAULT '',
	`d_port` INT DEFAULT -1,
	`l_ip` VARCHAR(65) DEFAULT '',
	`l_port` INT DEFAULT -1,
	`timezone` INT DEFAULT 8,					/* 设备所在地时区 */
	`cell` CHAR(16) DEFAULT '',
	`longitude` DOUBLE DEFAULT 0,
	`latitude` DOUBLE DEFAULT 0,
	`height`  DOUBLE DEFAULT 0,
	`logo` VARCHAR(64) DEFAULT 'default',
	PRIMARY KEY ( `guid1`, `guid2` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS dev_db.dev_fun (
	`dev_id` CHAR(32) NOT NULL,
	`fun_id` INT NOT NULL,
	`fun_name` VARCHAR(100) DEFAULT '',
	`remark` VARCHAR(200) DEFAULT '',
	`m` ENUM('a','m','b','unknown') NOT NULL DEFAULT 'b',
	`valid` ENUM('y','n') NOT NULL DEFAULT 'y',
	`p_num` INT DEFAULT 0,
	`p1` BIGINT NOT NULL DEFAULT 0,
	`p2` BIGINT NOT NULL DEFAULT 0,
	`p3` BIGINT NOT NULL DEFAULT 0,
	`p4` BIGINT NOT NULL DEFAULT 0,
	`p1_name` VARCHAR(60) DEFAULT '',
	`p2_name` VARCHAR(60) DEFAULT '',
	`p3_name` VARCHAR(60) DEFAULT '',
	`p4_name` VARCHAR(60) DEFAULT '',
	`p1_remark` VARCHAR(200) DEFAULT '',
	`p2_remark` VARCHAR(200) DEFAULT '',
	`p3_remark` VARCHAR(200) DEFAULT '',
	`p4_remark` VARCHAR(200) DEFAULT '',
	`ret_v` VARCHAR(200) DEFAULT '',
	`ret_t` BIGINT DEFAULT 0,
	PRIMARY KEY ( `dev_id`, `fun_id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS dev_db.share_table (
	`guid1` CHAR(32) NOT NULL,
	`uid` CHAR(32) DEFAULT '',
	`owner` CHAR(32) DEFAULT '',
	`owner_name` CHAR(60) DEFAULT '',
	`auth` ENUM('op','view','forbidden','unknown') NOT NULL DEFAULT 'view',
	PRIMARY KEY ( `guid1`, `uid` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* ------------------------  create cell_db --------------------------------*/
CREATE DATABASE IF NOT EXISTS `cell_db` DEFAULT CHARACTER SET `utf8`;
CREATE TABLE IF NOT EXISTS cell_db.cell_table (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
	`name` VARCHAR(100) DEFAULT 'NO NAME',
	`cell_id` CHAR(32) UNIQUE DEFAULT '',
	`owner` CHAR(32) DEFAULT '',
	`state` ENUM('running','stopping','merged','unknown') NOT NULL DEFAULT 'unknown',
	`dev_table` VARCHAR(100) NOT NULL DEFAULT 'NULL',
	`data_table` VARCHAR(100) NOT NULL DEFAULT 'NULL',
	`share_table` VARCHAR(100) NOT NULL DEFAULT 'NULL',
	`found` BIGINT DEFAULT 0,
	`cell_ip` VARBINARY(32) DEFAULT '\0',
	`cell_port` INT DEFAULT 0,	
	`peer_ip` VARBINARY(32) DEFAULT '\0',
	`peer_port` INT DEFAULT 0,	
	PRIMARY KEY ( `id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS cell_db.cell_form (
	`c_id` CHAR(32) DEFAULT '',
	`remark` VARCHAR(100) NOT NULL DEFAULT 'NULL',
	`dev_id` CHAR(32) DEFAULT '',
	`p_dev` CHAR(32) DEFAULT '',
	PRIMARY KEY ( `c_id`, `dev_id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS cell_db.share_table (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
	`uid` CHAR(32) DEFAULT '',
	`if_dev` BOOLEAN DEFAULT FALSE,
	`c_did` CHAR(32) DEFAULT '',
	`auth` ENUM('op','view','forbidden','unknown') NOT NULL DEFAULT 'view',
	PRIMARY KEY ( `id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* ------------------------  create data_db --------------------------------*/
CREATE DATABASE IF NOT EXISTS `data_db` DEFAULT CHARACTER SET `utf8`;
CREATE TABLE IF NOT EXISTS data_db.unit_table (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
	`unit` VARCHAR(30) UNIQUE,
	PRIMARY KEY ( `id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO data_db.unit_table ( id, unit ) VALUES ( 1, 'bin' );
INSERT INTO data_db.unit_table ( id, unit ) VALUES ( 2, 'utf8' );
INSERT INTO data_db.unit_table ( id, unit ) VALUES ( 3, 'state' );
INSERT INTO data_db.unit_table ( id, unit ) VALUES ( 4, 'file/image' );
INSERT INTO data_db.unit_table ( id, unit ) VALUES ( 5, 'file/video' );
INSERT INTO data_db.unit_table ( id, unit ) VALUES ( 6, 'file/audio' );
INSERT INTO data_db.unit_table ( id, unit ) VALUES ( 7, 'file/points' );
INSERT INTO data_db.unit_table ( id, unit ) VALUES ( 8, 'sys/gps' );

CREATE TABLE IF NOT EXISTS data_db.dev_data_unit (
	`dev_id` CHAR(32) NOT NULL,
	`d_id` INT NOT NULL,
	`utid` BIGINT NOT NULL,
	`type` ENUM('1','2','3','4','5','6','7','8') NOT NULL DEFAULT '7',
	`d_t` INT NOT NULL DEFAULT 1,								/* ss==0 累积数据; ss==1 不累积数据; */
	`remark` VARCHAR(60) DEFAULT '',
	`s_t` BIGINT DEFAULT 0,
	`v_name` VARCHAR(60) DEFAULT '',
	PRIMARY KEY ( `dev_id`,`d_id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS data_db.alarm (
	`dev_id` CHAR(32) NOT NULL,
	`d_id` INT NOT NULL,
	`thr` DOUBLE DEFAULT 0,
	`thr2` DOUBLE DEFAULT 1,						/* 阈值2， 定义范围类型警报的上阈值 */
	`last_t` BIGINT DEFAULT 0,					/* 上一个短信警报产生时间，防止频繁发送短信 */
	`method` VARCHAR(6) DEFAULT '',				/* <> 在此范围内触发， thr< v <thr2 时触发；  !<> 不处于此范围内触发 */
	`valid`  TINYINT NOT NULL DEFAULT 1,
	PRIMARY KEY ( `dev_id`, `d_id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS data_db.alarm_message (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
	`dev_id` CHAR(32) NOT NULL,
	`d_id` INT NOT NULL,
	`dev_name` VARCHAR(30) DEFAULT 'DEV',
	`d_remark` VARCHAR(60) NOT NULL DEFAULT 'NULL',
	`t` DOUBLE NOT NULL,
	`v` DOUBLE DEFAULT 0,
	`state` INT NOT NULL DEFAULT 0,
	`b` INT NOT NULL,
	`tz` INT DEFAULT 8,
	`unit` VARCHAR(20) UNIQUE,
	`phone` VARCHAR(20) NOT NULL,
	PRIMARY KEY ( `id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS data_db.real_data (
	`dev_id` CHAR(32) NOT NULL,
	`d_id` INT NOT NULL,
	`value` DOUBLE DEFAULT 0,
	`v_name` VARCHAR(50) DEFAULT '',
	`unit` VARCHAR(20) DEFAULT '',
	`time` DOUBLE NOT NULL,
	`bin_d` VARCHAR(200) DEFAULT '',
	PRIMARY KEY ( `dev_id`, `d_id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS data_db.his_data (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
	`dev_id` CHAR(32) NOT NULL,
	`d_id` INT NOT NULL,
	`value` DOUBLE DEFAULT 0,
	`v_name` VARCHAR(50) DEFAULT '',
	`time` DOUBLE NOT NULL,
	`unit` VARCHAR(20) DEFAULT '',
	`bin_d` VARBINARY(200) DEFAULT '\0',
	`g_id` BIGINT DEFAULT -1,
	`cell_id` CHAR(16) NOT NULL DEFAULT '0',
	PRIMARY KEY ( `id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS data_db.fake_his_data (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
	`dev_id` CHAR(32) NOT NULL,
	`d_id` INT NOT NULL,
	`value` DOUBLE DEFAULT 0,
	`v_name` VARCHAR(50) DEFAULT '',
	`time` BIGINT NOT NULL,
	`bin_d` VARBINARY(200) DEFAULT '\0',
	`cell_id` CHAR(16) NOT NULL DEFAULT '0',
	PRIMARY KEY ( `id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/* -----------------------------------------------------------------------------------------
			
							Defining Stored Programs in user_db

---------------------------------------------------------------------------------------------*/
USE user_db;

DROP PROCEDURE IF EXISTS identify;

/* 
	验证 uname 用户身份的合法性 
	结果由 uname 返回  	== “OK” 合法
						== “NO” 非法
*/
DELIMITER |
CREATE PROCEDURE identify( INOUT uname VARCHAR(50) CHARACTER SET utf8, IN upasswd VARCHAR(64) CHARACTER SET utf8 )
MAIN:BEGIN
	SET @n = '';
	SET @md5_passwd = '';
	SET @st = '';
	
	SELECT @n:=name, @md5_passwd:=passwd, @st:=state FROM user_table WHERE name=uname;
	
	IF FOUND_ROWS()<= 0 THEN
		SET uname = "NO";
		LEAVE MAIN;
	END IF;
	
	IF @st='forbidden' OR @st='merge' THEN
		SET uname = "NO";
		LEAVE MAIN;
	END IF;
	
	SET @st = MD5( upasswd );
	IF @st = @md5_passwd THEN
		SET uname = "OK";
	ELSE 
		SET uname = "NO";
	END IF;
	
END MAIN
|

DROP PROCEDURE IF EXISTS identify_dev;
/*
	验证主设备的身份
*/
CREATE PROCEDURE identify_dev( INOUT gid1 VARCHAR(32) CHARACTER SET utf8, IN gid2 CHAR(32) CHARACTER SET utf8 )
F6:BEGIN

	SET @g2 = '';
	SELECT guid2 INTO @g2 FROM dev_db.dev_table WHERE guid1=gid1;
	
	IF FOUND_ROWS()<= 0 THEN
		SET gid1 = "NO";
		LEAVE F6;
	END IF;
	
	IF @g2 = gid2 THEN
		SET gid1 = "OK";
	ELSE 
		SET gid1 = "NO";
	END IF;
	
END F6
|

DROP PROCEDURE IF EXISTS add_unit;
/*
	注册变量单位
	返回注册成功单位的 id
	(未验证)
*/
CREATE PROCEDURE add_unit( OUT u_id BIGINT, IN unit_name VARCHAR(20) CHARACTER SET utf8 )
F1:BEGIN

	SELECT id INTO u_id FROM data_db.unit_table WHERE unit=unit_name;
	
	IF FOUND_ROWS()<= 0 THEN
		INSERT INTO data_db.unit_table ( unit ) VALUES ( unit_name );
		SELECT id INTO u_id FROM data_db.unit_table WHERE unit=unit_name;
	END IF;
	
END F1
|

DROP PROCEDURE IF EXISTS insert_dev_data_unit;
/*
	向 data_db.dev_data_unit 中注册返回值信息
	(未验证)
*/
CREATE PROCEDURE insert_dev_data_unit( IN gid1 VARCHAR(32) CHARACTER SET utf8, IN rp_id INT, IN unit VARCHAR(60) CHARACTER SET utf8, IN type CHAR, IN rp_name VARCHAR(60) CHARACTER SET utf8, IN rp_remark VARCHAR(60) CHARACTER SET utf8, IN in_dt INT )
F7:BEGIN

	SET @g1 = '';
	SELECT guid1 INTO @g1 FROM dev_db.dev_table WHERE guid1=gid1;
	
	IF FOUND_ROWS()<= 0 THEN
		LEAVE F7;
	END IF;
	
	/* 先注册单位 */
	SET @u_id = -1;
	CALL add_unit( @u_id, unit );
	
	IF @u_id>0 THEN
		SELECT d_id FROM data_db.dev_data_unit WHERE dev_id=gid1 AND d_id=rp_id;
		IF FOUND_ROWS()<=0 THEN
			INSERT INTO data_db.dev_data_unit (dev_id, d_id, v_name, type, remark, utid, d_t) VALUES (gid1, rp_id, rp_name, type, rp_remark, @u_id, in_dt);
		ELSE
			UPDATE data_db.dev_data_unit SET v_name=rp_name, type=type, remark=rp_remark, utid=@u_id, d_t=in_dt WHERE dev_id=gid1 AND d_id=rp_id;
		END IF;
	END IF;
		
END F7
|

DROP PROCEDURE IF EXISTS add_fun;
/*
	增加 设备操作 信息
	gid1 - 设备 guid1
	（未验证）
*/
CREATE PROCEDURE add_fun( IN gid1 VARCHAR(32) CHARACTER SET utf8, IN op_id BIGINT, IN op_name VARCHAR(60) CHARACTER SET utf8, IN op_remark VARCHAR(60) CHARACTER SET utf8, IN m CHAR(1), IN in_pnum INT )
F8:BEGIN

	SELECT guid1 FROM dev_db.dev_table WHERE guid1=gid1;
	
	IF FOUND_ROWS()<= 0 THEN
		LEAVE F8;
	END IF;
	
	SELECT fun_id FROM dev_db.dev_fun WHERE dev_id=gid1 AND fun_id=op_id;
	IF FOUND_ROWS()<=0 THEN
		INSERT INTO dev_db.dev_fun (dev_id, fun_id, fun_name, remark, m, p_num) VALUES ( gid1, op_id, op_name, op_remark, m, in_pnum );
	ELSE
		/*  清空所有 p 信息， 保证在参数数量发生变化时，仍能保证信息完整性 */
		UPDATE dev_db.dev_fun SET p1=0, p2=0, p3=0, p4=0, p1_name='', p2_name='', p3_name='', p4_name='',p1_remark='', p2_remark='',p3_remark='',p4_remark='', p_num=0 WHERE dev_id=gid1 AND fun_id=op_id;
		UPDATE dev_db.dev_fun SET fun_name=op_name, remark=op_remark, m=m, p_num=in_pnum WHERE dev_id=gid1 AND fun_id=op_id;
	END IF;
	
END F8
|

DROP PROCEDURE IF EXISTS add_fun_p;
/*
	增加 设备操作参数的 信息
	gid1 - 设备 guid1
	op_id - 操作号
	uint - 参数单位
	pindex - 参数序号
	（未验证）
*/
CREATE PROCEDURE add_fun_p( IN gid1 VARCHAR(32) CHARACTER SET utf8, IN op_id BIGINT, IN p_name VARCHAR(60) CHARACTER SET utf8, IN p_remark VARCHAR(60) CHARACTER SET utf8, IN pindex INT, IN unit VARCHAR(60) CHARACTER SET utf8 )
F9:BEGIN

	SELECT guid1 FROM dev_db.dev_table WHERE guid1=gid1;
	
	IF FOUND_ROWS()<= 0 THEN
		LEAVE F9;
	END IF;

	SET @u_id = -1;
	CALL add_unit( @u_id, unit );
	IF @u_id<0 THEN
		LEAVE F9;
	END IF;
	
	SET @PNAME = p_name;
	SET @PREMARK = p_remark;
	SET @GID1 = gid1;
	SET @OPID = op_id;
	
	SET @PX = CONCAT( 'p', pindex );
	SET @PX_NAME = CONCAT( 'p', pindex,'_name' );
	SET @PX_REMARK = CONCAT( 'p', pindex,'_remark' );
	
	SET @order_str = CONCAT( 'UPDATE dev_db.dev_fun SET ',@PX,'=?, ',@PX_NAME,'=?, ', @PX_REMARK, '=? WHERE dev_id=? AND fun_id=?' );
	SELECT p_name, @order_str;
	PREPARE comm FROM @order_str;
	EXECUTE comm USING @u_id, @PNAME, @PREMARK, @GID1, @OPID;
	DEALLOCATE PREPARE comm;

END F9
|

DROP PROCEDURE IF EXISTS save_val_data;
/*	
	gid1 - 设备16进制字符形式的标识
*/
CREATE PROCEDURE save_val_data( IN gid1 VARCHAR(32) CHARACTER SET utf8, IN did INT, IN val DOUBLE, IN t DOUBLE )
F11:BEGIN

	SELECT @amass:=d_t, @st:=s_t, @vname:=v_name, @utid:=utid FROM data_db.dev_data_unit WHERE dev_id=gid1 AND d_id=did;
	IF FOUND_ROWS()<= 0 THEN
		LEAVE F11;
	END IF;
	
	SELECT @my_unit:=unit FROM data_db.unit_table WHERE id=@utid;
	IF FOUND_ROWS()<= 0 THEN
		LEAVE F11;
	END IF;
	
	IF @amass=1 THEN
		UPDATE data_db.real_data SET value=val, v_name=@vname, time=t WHERE dev_id=gid1 AND d_id=did;
		IF ROW_COUNT() > 0 THEN
			LEAVE F11;
		END IF;
		INSERT INTO data_db.real_data ( dev_id, d_id, v_name, unit, value, time ) VALUES ( gid1, did, @vname, @my_unit, val, t );
	END IF;
	
	IF @amass=0 THEN
		INSERT INTO data_db.his_data ( dev_id, d_id, v_name, unit, value, time ) VALUES ( gid1, did, @vname, @my_unit, val, t );
	END IF;
	
	IF @amass=99 THEN
		IF @st>0 THEN
			SELECT @now:=unix_timestamp();
			DELETE FROM data_db.his_data WHERE dev_id=gid1 AND d_id=did AND (@now-time)>=@st*3600 AND unit!=3;
		END IF;
					
		INSERT INTO data_db.his_data ( dev_id, d_id, v_name, unit, value, time ) VALUES ( gid1, did, @vname, @my_unit, val, t );
	END IF;
	
END F11
|

DROP PROCEDURE IF EXISTS save_bin_data;
/*	
	gid1 - 设备16进制字符形式的标识
*/
CREATE PROCEDURE save_bin_data( IN gid1 VARCHAR(32) CHARACTER SET utf8, IN did INT, IN bind VARBINARY(200), IN t DOUBLE )
F12:BEGIN

	SELECT @amass:=d_t, @st:=s_t, @vname:=v_name, @utid:=utid FROM data_db.dev_data_unit WHERE dev_id=gid1 AND d_id=did;
	IF FOUND_ROWS()<= 0 THEN
		LEAVE F12;
	END IF;
	
	SELECT @my_unit:=unit FROM data_db.unit_table WHERE id=@utid;
	IF FOUND_ROWS()<= 0 THEN
		LEAVE F12;
	END IF;
	
	IF @amass=1 THEN
		UPDATE data_db.real_data SET bin_d=bind, v_name=@vname, time=t WHERE dev_id=gid1 AND d_id=did;
		IF ROW_COUNT() > 0 THEN
			LEAVE F12;
		END IF;
		INSERT INTO data_db.real_data ( dev_id, d_id, v_name, unit, bin_d, time ) VALUES ( gid1, did, @vname, @my_unit, bind, t );
	END IF;
	
	IF @amass=0 THEN
		INSERT INTO data_db.his_data ( dev_id, d_id, v_name, unit, bin_d, time ) VALUES ( gid1, did, @vname, @my_unit, bind, t );
	END IF;
	
	IF @amass=99 THEN
		IF @st>0 THEN
			SELECT @now:=unix_timestamp();
			DELETE FROM data_db.his_data WHERE dev_id=gid1 AND d_id=did AND (@now-time)>=@st*3600 AND unit!=3;
		END IF;
		
		INSERT INTO data_db.his_data ( dev_id, d_id, v_name, unit, bin_d, time ) VALUES ( gid1, did, @vname, @my_unit, bind, t );
	END IF;

END F12
|

DROP PROCEDURE IF EXISTS save_alarm_info;
/*
	向 data_db.alarm 中注册返回值信息
	(未验证)
*/
CREATE PROCEDURE save_alarm_info( IN in_dev_id VARCHAR(32) CHARACTER SET utf8, IN in_d_id INT, IN in_thr DOUBLE, IN in_method VARCHAR(5) CHARACTER SET utf8 )
F13:BEGIN

	UPDATE data_db.alarm SET thr=in_thr, method=in_method WHERE dev_id=in_dev_id AND d_id=in_d_id;
	IF ROW_COUNT() > 0 THEN
		LEAVE F13;
	END IF;
	
	INSERT INTO data_db.alarm ( dev_id, d_id, thr, method ) VALUES ( in_dev_id, in_d_id, in_thr, in_method );
		
END F13
|

DROP PROCEDURE IF EXISTS save_file;
/*
	向 data_db.real_data 中注册image、video、sound 等以文件形式存在的数据
*/
CREATE PROCEDURE save_file( IN in_dev_id VARCHAR(32) CHARACTER SET utf8, IN in_d_id INT, IN f_path VARCHAR(200) CHARACTER SET utf8, IN f_time DOUBLE )
F14:BEGIN

	UPDATE data_db.real_data SET time=f_time, bin_d=f_path WHERE dev_id=in_dev_id AND d_id=in_d_id;
	UPDATE dev_db.dev_table SET state='unknown' WHERE guid1=in_dev_id;
	
END F14
|

DROP PROCEDURE IF EXISTS add_alarm;
/*
	向 data_db.alarm_message 中注册 警报短信
*/
CREATE PROCEDURE add_alarm( IN in_dev_id VARCHAR(32) CHARACTER SET utf8, IN in_d_id INT, IN in_v DOUBLE, IN f_time DOUBLE )
F15:BEGIN

	SELECT @my_thr:=thr, @my_m:=method, @my_last_t:=last_t FROM data_db.alarm WHERE dev_id=in_dev_id AND d_id=in_d_id;
	IF FOUND_ROWS()<= 0 THEN
		LEAVE F15;
	END IF;
	
	IF @my_m='none' THEN 
		LEAVE F15;
	END IF;
	
	SET @if_alerm = 0;
	
	IF @my_m='>' THEN 
		IF in_v>@my_thr THEN
			SET @if_alerm = 1;
		END IF;
	END IF;

	IF @my_m='>=' THEN 
		IF in_v>=@my_thr THEN
			SET @if_alerm = 1;
		END IF;
	END IF;

	IF @my_m='=' THEN 
		IF in_v=@my_thr THEN
			SET @if_alerm = 1;
		END IF;
	END IF;
	
	IF @my_m='<=' THEN 
		IF in_v<=@my_thr THEN
			SET @if_alerm = 1;
		END IF;
	END IF;
	
	IF @my_m='<' THEN
		IF in_v<@my_thr THEN
			SET @if_alerm = 1;
		END IF;	
	END IF;
	
	IF @my_m='!=' THEN 
		IF in_v!=@my_thr THEN
			SET @if_alerm = 1;
		END IF;
	END IF;
	
	IF @if_alerm=1 THEN
		SELECT @dev_name:=name, @user:=owner, @tz:=timezone FROM dev_db.dev_table WHERE guid1=in_dev_id;
		IF FOUND_ROWS()<= 0 THEN
			LEAVE F15;
		END IF;
		
		SELECT @my_p:=phone FROM user_db.user_table WHERE uid=@user;
		IF FOUND_ROWS()<= 0 THEN
			LEAVE F15;
		END IF;
		
		SELECT @my_d_remark:=remark, @unit_id=utid FROM data_db.dev_data_unit WHERE d_id=in_d_id AND dev_id=in_dev_id;
		IF FOUND_ROWS()<= 0 THEN
			LEAVE F15;
		END IF;

		SELECT @my_unit:=unit FROM data_db.unit_table WHERE id=@unit_id;
		
		IF f_time-@my_last_t<=1800 THEN
			LEAVE F15;
		END IF;
	
		SET @my_b = ROUND( RAND()*10 );
		INSERT INTO data_db.alarm_message ( dev_id, d_id, dev_name, d_remark, t, v, b, phone, tz, unit ) VALUES ( in_dev_id, in_d_id, @dev_name, @my_d_remark, f_time, in_v, @my_b, @my_p, @tz, @my_unit );
		UPDATE data_db.alarm SET last_t=f_time WHERE dev_id=in_dev_id AND d_id=in_d_id;
	END IF;
	
END F15
|

DROP PROCEDURE IF EXISTS add_user;
/*
	增加新用户，但不激活
	passwd 用明文表示
	uid 返回ok，表示添加用户成功
*/
CREATE PROCEDURE add_user( INOUT in_uid VARCHAR(32) CHARACTER SET utf8, IN in_mail VARCHAR(64) CHARACTER SET utf8, IN in_name VARCHAR(60) CHARACTER SET utf8, IN in_passwd VARCHAR(32) CHARACTER SET utf8 )
F16:BEGIN
	IF in_uid='' THEN
		LEAVE F16;
	END IF;
	
	IF in_mail='' THEN
		LEAVE F16;
	END IF;
	
	IF in_name='' THEN
		SET in_name = in_mail;
	END IF;
	
	SET in_passwd = MD5( in_passwd );
	
	INSERT INTO user_db.user_table ( uid, name, mail, passwd, state ) VALUES( in_uid, in_name, in_mail, in_passwd, 'inactive' );
	
	
	IF ROW_COUNT() > 0 THEN
		SET in_uid = "OK";
	ELSE
		SET in_uid = "NO";
	END IF;

END F16
|

DROP PROCEDURE IF EXISTS rand_dev_guid;
/*
	生产随机的 n 位 guid
*/
CREATE PROCEDURE rand_dev_guid( IN n INT, OUT guid CHAR(32) CHARACTER SET utf8 )
F17:BEGIN
    SET @chars_str = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    SET @i = 0;
	SET guid = '';
	
    WHILE @i < n DO
        SET guid = concat( guid,substring(@chars_str , FLOOR(1 + RAND()*62 ),1) );
        SET @i = @i + 1;
    END WHILE;
END F17
| 

DROP PROCEDURE IF EXISTS apply_dev_guid;
/*
	申请合法的随机的 n 位 guid
	申请失败，返回空字符
*/
CREATE PROCEDURE apply_dev_guid( IN n INT, IN in_owner VARCHAR(32) CHARACTER SET utf8, OUT guid CHAR(32) CHARACTER SET utf8 )
F18:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION SET guid='';
	
	SET @mid_guid = '';
	SET guid = @mid_guid;
	SET @i = 10;
	
	LOOP1: WHILE @i > 0 DO
        CALL user_db.rand_dev_guid( n, @mid_guid );
		INSERT INTO dev_db.dev_table ( guid1, state, owner ) VALUES ( @mid_guid, 'inactive', in_owner );	
		IF ROW_COUNT() > 0 THEN
			SET guid = @mid_guid;
			LEAVE LOOP1;
		END IF;
		
        SET @i = @i - 1;
    END WHILE LOOP1;
	
END F18
|

DROP PROCEDURE IF EXISTS add_user_2;
/*
	增加新用户，但不激活,自动生成 uid 值
	passwd 用明文表示
	uid 返回空，表示添加用户失败；否则返回 uid 值
*/
CREATE PROCEDURE add_user_2( OUT out_uid VARCHAR(32) CHARACTER SET utf8, IN in_mail VARCHAR(64) CHARACTER SET utf8, IN in_name VARCHAR(60) CHARACTER SET utf8, IN in_passwd VARCHAR(32) CHARACTER SET utf8 )
F19:BEGIN
		
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SET out_uid='';
		
	IF in_mail='' THEN
		LEAVE F19;
	END IF;
	
	IF in_name='' THEN
		SET in_name = in_mail;
	END IF;
	
	SET in_passwd = MD5( in_passwd );
	
	SET @i = 10;
	SET @mid = '';
	SET out_uid = '';
	LOOP2: WHILE @i > 0 DO
        CALL user_db.rand_dev_guid( 32, @mid );	
		
		INSERT INTO user_db.user_table ( uid, name, mail, passwd, state ) VALUES( @mid, in_name, in_mail, in_passwd, 'inactive' );
	
		IF ROW_COUNT() > 0 THEN
			SET out_uid = @mid;
			LEAVE F19;
		END IF;
		
        SET @i = @i - 1;
    END WHILE LOOP2;
	
END F19
|

DROP PROCEDURE IF EXISTS add_user_3;
/*
	增加新用户，但不激活,自动生成 uid 值
	passwd 用明文表示
	uid 返回空，表示添加用户失败；否则返回 uid 值
*/
CREATE PROCEDURE add_user_3( OUT out_uid VARCHAR(32) CHARACTER SET utf8, IN in_mail VARCHAR(64) CHARACTER SET utf8, IN in_name VARCHAR(60) CHARACTER SET utf8, IN in_passwd VARCHAR(32) CHARACTER SET utf8, IN login_t BIGINT )
F20:BEGIN
		
	DECLARE EXIT HANDLER FOR SQLEXCEPTION SET out_uid='';
		
	IF in_mail='' THEN
		LEAVE F20;
	END IF;
	
	IF in_name='' THEN
		SET in_name = in_mail;
	END IF;
	
	SET in_passwd = MD5( in_passwd );
	
	SET @i = 10;
	SET @mid = '';
	SET out_uid = '';
	LOOP3: WHILE @i > 0 DO
        CALL user_db.rand_dev_guid( 32, @mid );	
		
		INSERT INTO user_db.user_table ( uid, name, mail, passwd, state, logint ) VALUES( @mid, in_name, in_mail, in_passwd, 'inactive', login_t );
	
		IF ROW_COUNT() > 0 THEN
			SET out_uid = @mid;
			LEAVE F20;
		END IF;
		
        SET @i = @i - 1;
    END WHILE LOOP3;
	
END F20
|
DELIMITER ;