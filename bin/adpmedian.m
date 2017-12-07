function [F]=adpmedian(g)         %fΪ�˲����ͼ��FΪ����ֵȡ��������
%g=double(g);
[M,N]=size(g);
F=zeros(M,N);
f=g;
Smax=min(M,N);
%f=zeros(M,N);       
alreadyProcessed=zeros(size(g));
alreadyProcessed=logical(alreadyProcessed);

for k=3:2:Smax
    zmin=ordfilt2(f,1,ones(k,k),'symmetric');
    zmax=ordfilt2(f,k*k,ones(k,k),'symmetric');
    zmed=medfilt2(f,[k,k],'symmetric');
    processUsingLevelB=(zmed>zmin) & (zmax>zmed) &...
        ~alreadyProcessed;
    zB=(f>zmin) & (zmax>f);
    outputZxy=processUsingLevelB & zB;
    outputZmed=processUsingLevelB & ~zB;
%    f(outputZxy)=g(outputZxy);         
%    f(outputZmed)=zmed(outputZmed);
%    F(outputZmed)=1;               %����һ�������
    F(outputZmed)=g(outputZmed)==0 | g(outputZmed)==255;        %���Խ�������
    f(outputZmed&F)=zmed(outputZmed&F);
    alreadyProcessed=alreadyProcessed | processUsingLevelB;
    if all(alreadyProcessed(:))
        break;
    end
end
% f(~alreadyProcessed)=zmed(~alreadyProcessed);
F(~alreadyProcessed)=1;

