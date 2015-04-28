function res = recv_data( obj )

    res = [];
    ind1 = [];
    ind2 = [];
    sig = 0;
    c_len = 0;
    
    pat = sprintf('\r\n\r\n');
        
    while 1
        [ A, count ] = fread( obj, 1 );
        if count<=0
            break;
        end
        
        res = [ res A(1) ];

        if isempty( ind1 )
            ind1 = strfind( res, 'Content-Length:' );
            ind1 = ind1 + 15;
            ind2 = ind1;
            sig = 1;
        else
        
            if sig==1
                if A(1)==13
                   c_len = str2num( char(res(1,ind1:ind2)) );
                   sig = 2;
                else
                   ind2 = ind2 + 1;
                end
            end
            
        end
    
        if sig==2
            mid = strfind( res, pat );
            if isempty(mid)~=1 & c_len~=0
                [ A, count ] = fread( obj, c_len );
                res = A';
                break;
            end
        end
    end  