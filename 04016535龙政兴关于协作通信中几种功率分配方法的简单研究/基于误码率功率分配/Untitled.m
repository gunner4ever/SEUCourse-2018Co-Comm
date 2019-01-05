clear all;
close all;
clc;

N=1;%��վ������
M=3;% һ���м�
S=1;%һ��Դ�ڵ�
Nsi=rand(1,M)*2+1;%Դ�ڵ㵽�м̵��������� 1-3�������
Nid=rand(1,M)*2;%�м̽ڵ㵽Ŀ�Ľڵ���������� 0-2�������
R=1;%��������,�����ж��жϸ��� ��λ��bit/��/Hz
Nsd=0.7;

   %e_v=(1/2).*ones(40,1);
co=1;
for SNR=0:3:30  %�����
SNR_power=10^(SNR/10);
    lamda_E=(2^(2*R)-1)/SNR_power;
% figure(1);
% fplot('variable.*sin(10*pi*variable)+2.0',[-1,2]);   %������������
%�����Ŵ��㷨����
NIND=40;        %������Ŀ(Number of individuals)
MAXGEN=50;      %����Ŵ�����(Maximum number of generations)
PRECI=20;       %�����Ķ�����λ��(Precision of variables)
GGAP=0.9;       %����(Generation gap)
trace=zeros(2, MAXGEN);                        %Ѱ�Ž���ĳ�ʼֵ
FieldD=[20;0;1;1;0;1;1];                      %����������(Build field descriptor)
Chrom=crtbp(NIND, PRECI);                      %��ʼ��Ⱥ
gen=0;                                         %��������
variable=bs2rv(Chrom, FieldD);                 %�����ʼ��Ⱥ��ʮ����ת��
ObjV=obj(variable,lamda_E,Nsi,Nid,Nsd,M,SNR_power);        %����Ŀ�꺯��ֵ
while gen<MAXGEN
   FitnV=ranking(ObjV);                                 %������Ӧ��ֵ(Assign fitness values)         
   SelCh=select('sus', Chrom, FitnV, GGAP);               %ѡ��
   SelCh=recombin('xovsp', SelCh, 0.7);                   %����
   SelCh=mut(SelCh);                                      %����
   variable=bs2rv(SelCh, FieldD);                         %�Ӵ������ʮ����ת��
   ObjVSel=variable.*sin(10*pi*variable)+2.0;             %�����Ӵ���Ŀ�꺯��ֵ
   [Chrom ObjV]=reins(Chrom, SelCh, 1, 1, ObjV, ObjVSel); %�ز����Ӵ�������Ⱥ
   variable=bs2rv(Chrom, FieldD);
   gen=gen+1;                                             %������������
   %������Ž⼰����ţ�����Ŀ�꺯��ͼ���б����YΪ���Ž�,IΪ��Ⱥ�����
   [Y, I]=min(ObjV);
   OP=variable(I)
   hold on;
   Popt(co)=Y;
   %e_v=(1/2).*ones(40,1);
   Pnor(co)=objP(0.5,lamda_E,Nsi,Nid,Nsd,M,SNR_power);
   %Py(SNR+1)=objY(OP,lamda_E,Nsi,Nid,N);
   %figure (2)
  % plot(variable(I), Y, 'bo');
%    trace(1, gen)=max(ObjV);                               %�Ŵ��㷨���ܸ���
%    trace(2, gen)=sum(ObjV)/length(ObjV);
end
co=co+1
end
Popt
Pnor
%SNR=1:1:25;
S=0:3:30;
xlabe=S;
ylabe=Popt;
ylabe1=Pnor;
axis([0 25 0 1]);
semilogy(xlabe,ylabe,'-r*');
hold on;
semilogy(xlabe,ylabe1,'-ko')
legend('Adaptive PA','Uniform PA')
xlabel('P/N0(dB)'),ylabel('Outage probability')
% hold on;
% semilogy(S,Py,'-ko')
grid on;
% variable=bs2rv(Chrom, FieldD)                            %���Ÿ����ʮ����ת��
% hold on, grid;
% plot(variable,ObjV,'b*');
% figure(2);
% plot(trace(1,:));
% hold on;
% plot(trace(2,:),'-.');grid
% legend('��ı仯','��Ⱥ��ֵ�ı仯')
    