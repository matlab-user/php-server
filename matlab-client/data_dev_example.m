function data_dev_example  
%------------------------------------------------
% 参数配置
% HOST - 服务器域名或IP地址
% PORT - 服务端口,http端口默认为80
% I1 - 设备的 GUID1 号

% INTER - 数据采集间隔

% TZ - 设备上设置的时区参数，正为东区，负为西区
%------------------------------------------------
global HOST PORT TZ
HOST = 'www.swaytech.biz';
PORT = 128;
I1 = 'rZteCbX2';

INTER = 20;

TZ = 8;
%-------------------------------------------------
% 发送设备信息（仅在设备首次接入平台时才需要）
%-------------------------------------------------
post_dev_info( I1, 'dev_info-1.xml' );
post_dev_op( I1, 'dev_op-1.xml' );

%-------------------------------------------------
% 定时发送数据
%-------------------------------------------------
t = timer;
t.Period         = INTER;
t.StartDelay     = 0;
t.ExecutionMode  = 'fixedSpacing';
t.TimerFcn       = { @my_callback_fcn, I1 };
t.BusyMode       = 'drop';
t.TasksToExecute = 1;
t.UserData       = [];
start(t)

function my_callback_fcn( obj, event, I1 )
    global TZ
    disp( '开始上传数据！' );
    d_id = [ 1 2 ];
    t = [ time(TZ) time(TZ) ];
    %t = [ 0 0 ];
    value = 2 * sin(pi/6/3600*t);

    %post_dev_data( I1, d_id, value, t );
