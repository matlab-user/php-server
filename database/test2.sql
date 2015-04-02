
SET @dev_id = '1982011602030410182910a1F2C3D02A';
	
CALL user_db.save_val_data( @dev_id, 1, 2.5, 121 );
CALL user_db.save_val_data( @dev_id, 2, 23.5, 125 );
CALL user_db.save_val_data( @dev_id, 3, 28, 125 );
CALL user_db.save_val_data( @dev_id, 4, 2.5, 121 );