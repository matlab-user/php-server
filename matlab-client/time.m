function res = time( tz )
    
res = round((now-datenum(1970,1,1))*24*3600-tz*3600);