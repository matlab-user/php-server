#include <stdio.h>
#include <stdlib.h>
#include <string.h>	
#include <time.h>
#include <stdint.h>

#include "mysql.h"

// 将 len 字节个 d 数据转换为 2×len+1 字节个十六进制字符
// 成功-返回生成的新字符串； 失败-返回 NULL
// 存放结果的空间由 内存动态分配 获取，不用时需要释放
unsigned char* bin_to_hex_str( unsigned char* d, unsigned int len ) {
	
	if( d==NULL || len==0)
		return NULL;
	
	unsigned char *res = (unsigned char*)calloc( len*2+1, 1 );
	unsigned int i = len;
	
	for( i=0; i<len; i++ )
		sprintf( res+i*2, "%02x", *(d+i) );
	
	return res;
}

// 验证主设备的身份， guid1/2 - 16字节长
// 身份验证通过，返回 1； 否则返回 -1
int verify_main_dev( unsigned char* guid1, unsigned char* guid2 ) {
	
	if( guid1==NULL || guid2==NULL )
		return -1;
	
	unsigned char sql_str[200];
	unsigned char *gid1 = bin_to_hex_str( guid1, 16 );
	unsigned char *gid2 = bin_to_hex_str( guid2, 16 );
	
	if( gid1==NULL || gid2==NULL )
		return -1;
	
	sprintf( sql_str, "SET @g1='%s';CALL identify_main_dev( @g1, '%s');SELECT @g1;", gid1, gid2 );
	
	free( gid1 );
	free( gid2 );
	
	MYSQL mysql;		  //定义数据库连接的句柄
	MYSQL_RES *res;       //查询结果集，结构类型
	MYSQL_ROW row ;       //存放一行查询结果的字符串数组
	
	mysql_init( &mysql );
	mysql_options( &mysql, MYSQL_SET_CHARSET_NAME, "utf8" );

	if( !mysql_real_connect(&mysql, "127.0.0.1", "root", "blue", "user_db", 0, NULL, CLIENT_MULTI_STATEMENTS) ) {
		fprintf( stderr, "Failed to connect to database: Error: %s\n", mysql_error(&mysql) );
		return -1;
	}
	
	if( mysql_query(&mysql, sql_str) ) {
		fprintf( stderr, "Query failed (%s)\n", mysql_error(&mysql) );
		return -1;
	}

	do {	
		if( !(res=mysql_store_result(&mysql)) )
			continue;	
			
		row = mysql_fetch_row( res );
		mysql_free_result( res );
		
	} while( !mysql_next_result(&mysql) );

	mysql_close( &mysql );
	
	if( row==NULL )
		return -1;

	if( strcmp(row[0],"OK")==0 )
		return 1;
	else
		return -1;
}

int main() {

	MYSQL mysql;		  //定义数据库连接的句柄，它被用于几乎所有的MySQL函数
	MYSQL_RES *res;       //查询结果集，结构类型
	MYSQL_ROW row ;       //存放一行查询结果的字符串数组
	
	char name[10] = "root";
	char passwd[10] = "blue";
	char database[11] = "data_db";
	char host[20] = "127.0.0.1";
/*	
	mysql_init( &mysql );
	mysql_options( &mysql,MYSQL_SET_CHARSET_NAME, "utf8" );
	
	if ( !mysql_real_connect(&mysql, host, name, passwd, database, 0, NULL, CLIENT_MULTI_STATEMENTS) ) {
		fprintf( stderr, "Failed to connect to database: Error: %s\n", mysql_error(&mysql) );
		return 0;
	}
*/	
//	dev	-guid1(hex) 19-82-01-16-02-03-04-10-18-29-10-a1-F2-C3-D0-2A
//		-guid2(hex)	19-82-01-16-02-03-04-10-28-19-30-E1-F2-1C-2D-2B
		
	unsigned char guid1[16] = { 25, 130, 1, 22, 2, 3, 4, 16, 24, 41, 16, 161, 242, 195, 208, 42 };
	unsigned char guid2[16] = { 25, 130, 1, 22, 2, 3, 4, 16, 40, 25, 48, 225, 242, 28, 45, 43 };
	
	int i = verify_main_dev( guid1, guid2 );
	printf( "i %d\n", i );
/*	
	// char sql_str[200] = "SET @t=6;SELECT @t;CALL t1(@t);";
	// char sql_str[200] = "SELECT length(bin_d), bin_d from real_data";
	char sql_str[100] = " INSERT INTO real_data (bin_d) VALUES (0x01020345)";
	if( mysql_real_query(&mysql, sql_str, strlen(sql_str)) ) {
		fprintf( stderr, "Query failed (%s)\n", mysql_error(&mysql) );
		return 0;
	}

	res= mysql_store_result( &mysql );
	row = mysql_fetch_row( res );
	printf( "res is %s\n", row[0] );
	
	printf( "res is %x\n", *row[1] );
	printf( "res is %x\n", *(row[1]+1) );
	printf( "res is %x\n", *(row[1]+2) );
	return 0;

	unsigned char sql_str[200];
	unsigned char d[3] = {200, 255, 10};
	mysql_real_escape_string( &mysql, sql_str, d, sizeof(d) );
	printf( "sql_str: %s   %lu\n\n", sql_str, strlen(sql_str) );
	
	printf( "sql_str: %u\n", *sql_str );
	printf( "sql_str: %u\n", *(sql_str+1) );
	printf( "sql_str: %u\n", *(sql_str+2) );
	printf( "sql_str: %u\n", *(sql_str+3) );
	
*/	
/*	
unsigned char a = -1;
char b = -1;
// a = a + b;
if( a>b )
printf("sss %u\n", (unsigned int)b );
return 0;

	do {
		
		if( !(res=mysql_store_result(&mysql)) ) {
			fprintf(stderr, "Got fatal error processing query\n");
			continue;
		}

		row = mysql_fetch_row( res );
		printf( "res is %s\n", row[0] );
		
		mysql_free_result( res );
		
	} while( !mysql_next_result(&mysql) );

//	res = mysql_store_result( &mysql );     //保存查询到的数据到result
// mysql_free_result( res );
*/
 //   mysql_close( &mysql );

	return 1;
	
}