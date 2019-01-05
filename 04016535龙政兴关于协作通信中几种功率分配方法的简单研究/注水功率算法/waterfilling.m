function [shanonCapacity powerAllocated] = ofdmwaterfilling(...
    nSubChannel,totalPower,channelStateInformation,bandwidth,noiseDensity);
%==========================================================================
%����עˮ�㷨��Ϊ�����Ƶ��ѡ�����ŵ����������ܴ���ֽ��N�����ز���
%��Ƶ��ѡ�����ŵ��ֽ�ɶ��ƽ̹˥���ŵ���
%עˮ�㷨���������õ��ŵ��������Ĺ��ʣ����������õ��ŵ���������˥�䣩�����书�ʡ�
% =========================================================================
%                                ��������
% =========================================================================
% 
% nSubChannel               : ���ŵ���(4,16,32,...,2^N)
% totalPower                : ���Է����ÿ��OFDM�źŵ��ܹ���(p ����)
% channelStateInformation   : �ŵ�״̬��Ϣ��������������
%                             matrix "random('rayleigh',1,1,nSubChannel)"
% bandwidth                 : �����õ��ܴ���(��λHz)
% noiseDensity              : �����������ܶ�(w/Hz)

% =========================================================================
%                               ��������
% =========================================================================
% nSubChannel             = 16;
% totalPower              = 1e-5;           %  -20 dBm
% channelStateInformation = random('rayleigh',1/0.6552,1,nSubChannel);
% bandwidth               = 1e6;            %  1 MHz
% noiseDensity            = 1e-11;          % -80 dBm
% [Capacity PowerAllocated] = ofdmwaterfilling(...
%    nSubChannel,totalPower,channelStateInformation,bandwidth,noiseDensity)



%< �������� >
    
    subchannelNoise     = ...
        noiseDensity*bandwidth/nSubChannel;%���ŵ�����
    carrierToNoiseRatio = ...
        channelStateInformation.^2/subchannelNoise;%�����
    
    initPowerAllo       = ...                   (��ʽ 1)
        (totalPower + sum(1./carrierToNoiseRatio))...
        /nSubChannel - 1./carrierToNoiseRatio;%��ʼ�����ʷ���   
%��������֣���Ϊ���ŵĹ�ʽ1����Щ���ŵ������Ѿ��������˹���
%��Щ���ز��ڽ������ļ������ų�������ʹ���κι��ʣ����������ز��ظ��㷨��ֱ������ʣ�µ����ز�
%�������˹��ʡ�

% < �㷨�ĵ������� >
    while(length( find(initPowerAllo < 0 )) > 0 )%�ҵ���ʼ�����ʷ�����û�з��书�ʵ��ŵ���
                                                  %�����䳤�ȣ��������ŵ�����ʱ��������Ĳ��֡�
        negIndex       = find(initPowerAllo <= 0);%û�з��书�ʵ��ŵ�
        posIndex       = find(initPowerAllo >  0);%�����˹��ʵ��ŵ�
        nSubchannelRem = length(posIndex);%�����˹��ʵ��ŵ���
        initPowerAllo(negIndex) = 0;
        CnrRem         = carrierToNoiseRatio(posIndex);
        powerAlloTemp  = (totalPower + sum(1./CnrRem))...
            /nSubchannelRem - 1./CnrRem;
        initPowerAllo(posIndex) = powerAlloTemp;
    end

% < ������� >

%ÿ�����ŵ�����Ĺ���
    powerAllocated = initPowerAllo';        
% ������ũ����õ����ŵ�����
    shanonCapacity = bandwidth/nSubChannel * ...    
        sum(log2(1 + initPowerAllo.*carrierToNoiseRatio));

% <ͼ�ι۲�>
%ͨ���۲�ͼ��������Ŀ���������ˮһ��ע���������ز��Ȼ����ŵ�״̬��Ϣ�����ɵ������С�
f1 = figure(1);
    clf;
    set(f1,'Color',[1 1 1]);%����ͼ�α�����ɫ
    bar((initPowerAllo + 1./carrierToNoiseRatio),1,'r')%���ʷ����������ز��ȵĹ�ϵ
    hold on;%����ͼ�α��ֹ���    
    bar(1./carrierToNoiseRatio,1);%1��ʾԲ�����
    xlabel('���ŵ�����');
    title('עˮ�㷨')
    
    legend('�����ÿ�����ŵ��Ĺ���',...
           '�������ز���')
    
    