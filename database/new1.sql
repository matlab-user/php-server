CREATE DATABASE IF NOT EXISTS `wdh_db` DEFAULT CHARACTER SET `utf8`;
CREATE TABLE IF NOT EXISTS wdh_db.w_table (
	`id` BIGINT NOT NULL AUTO_INCREMENT,
	`b` BLOB DEFAULT '',
	PRIMARY KEY ( `id` )
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

USE mysql
DELIMITER |
CREATE PROCEDURE t1( INOUT t VARBINARY(3) )
BEGIN
	SELECT t+3 INTO t;
	SELECT t+1;
	
	IF 1=2 THEN
		SELECT 1;
	END IF;
	
END
|
DELIMITER ;