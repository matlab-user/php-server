/* ADD USER test */
SET @uid = '12345678';
INSERT INTO user_db.user_table SET uid=@uid, name='test', passwd=MD5('test'), phone='18215512330', state='on-line';

SET @intv = 30;

/* 增加设备 */
INSERT INTO dev_db.dev_table SET guid1='0001', guid2='000a', intv=@intv, name='dev1', k='wangdehui', owner=@uid;
INSERT INTO dev_db.dev_table SET guid1='0002', guid2='000b', intv=@intv, name='dev2', k='wangdehui', owner=@uid;
INSERT INTO dev_db.dev_table SET guid1='0003', guid2='000c', intv=@intv, name='dev3', k='wangdehui', owner=@uid;