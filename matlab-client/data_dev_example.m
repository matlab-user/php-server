function data_dev_example  
%------------------------------------------------
% ��������
% HOST - ������������IP��ַ
% PORT - ����˿�,http�˿�Ĭ��Ϊ80
% I1 - �豸�� GUID1 ��

% INTER - ���ݲɼ����

% TZ - �豸�����õ�ʱ����������Ϊ��������Ϊ����
%------------------------------------------------
global HOST PORT TZ
HOST = 'www.swaytech.biz';
PORT = 128;
I1 = 'rZteCbX2';

INTER = 20;

TZ = 8;
%-------------------------------------------------
% �����豸��Ϣ�������豸�״ν���ƽ̨ʱ����Ҫ��
%-------------------------------------------------
post_dev_info( I1, 'dev_info-1.xml' );
post_dev_op( I1, 'dev_op-1.xml' );

%-------------------------------------------------
% ��ʱ��������
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
    disp( '��ʼ�ϴ����ݣ�' );
    d_id = [ 1 2 ];
    t = [ time(TZ) time(TZ) ];
    %t = [ 0 0 ];
    value = 2 * sin(pi/6/3600*t);

    %post_dev_data( I1, d_id, value, t );
