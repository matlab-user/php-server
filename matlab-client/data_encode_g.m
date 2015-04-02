% d_id - 行向量，参数的 id 号
% value - 对应d_id参数的数值
% t - 对应value的采集时间
% g - 数据组id，行向量
% 3个输入参数必须具有相同的列数
function [ encode_str, encode_time ] = data_encode_g( dev_guid1, d_id, value, t, g )
    encode_str = '';
    encode_time = '';
    
    v_num = size( value, 2 );
    did_num = size( d_id, 2 );
    t_num = size( t, 2 );
    g_num = size( g, 2 );
    
    if did_num ~= v_num | did_num ~= t_num | did_num ~= g_num
        return;
    end
   
    base_t = t(1);
    t = t - base_t;
    
    for i = 1 : v_num
       mid = [ '(' num2str(d_id(i)) ',' num2str(value(i)) ',g' num2str(g(i)) ];
       if t(i) ~= 0
          mid = [ mid  ',t'  num2str(t(i))  ')' ];
       else
          mid = [ mid ')' ];
       end
       encode_str = [ encode_str mid ];
    end
    
    encode_str = [ 'W=[' dev_guid1 ';' encode_str ']' ];
    encode_time = [ 'TIME=' num2str(base_t) ];