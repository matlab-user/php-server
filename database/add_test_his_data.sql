
USE user_db;
DROP PROCEDURE IF EXISTS add_his_data;

DELIMITER |
CREATE PROCEDURE add_his_data( IN g1 CHAR(32) CHARACTER SET utf8 )
	MAIN:BEGIN
		SET @i=0;
		SET @ct = unix_timestamp();
		select @ct;
		WHILE @i<700 DO
			CALL user_db.save_val_data( g1, 1, rand(), @ct );
			SET @ct = @ct+10;
			SET @i = @i+1;
		END WHILE;
	END MAIN
|
DELIMITER ;

CALL user_db.add_his_data( '1982011602030410182910a1F2C3D02A' );