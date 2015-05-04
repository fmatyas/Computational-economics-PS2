clear all;
clc;
close all;

%% LOAD SERIES

GDP = xlsread('\data\OECD-Germany_Greece_GDP.xls', 'E7:CF8');
GDP = GDP';
lGDP = log(GDP);
trendGDP = hpfilter(lGDP,1600);

%% OLS

X = zeros(80,2);
X(:,1) = 1;
X(:,2) = 1:1:80;
OLStrendGDP = zeros(80,2);

for i=1:2
    y = lGDP(:,i);
    b = inv(X'*X)*X'*y;
    OLStrendGDP(:,i) = b(1)+b(2)*X(:,2);
end

exptrendGDP=exp(trendGDP);
expOLStrendGDP=exp(OLStrendGDP);
HPgap = (GDP-exptrendGDP)./exptrendGDP;
OLSgap = (GDP-expOLStrendGDP)./expOLStrendGDP;

V=cell(2,1);
V{1}='Germany';
V{2}='Greece';

for i=1:2
    figure(i);
    plot(X(:,2), lGDP(:,i), X(:,2), trendGDP(:,i), X(:,2), OLStrendGDP(:,i));
    title(['GDP trends for ' V(i)]);
    legend('log GDP','HP trend','OLS trend');
    xlabel('Quarter');
    saveas(i,['figure ' num2str(i) '.pdf']);
    figure(i+2);
    plot(X(:,2),HPgap(:,i), X(:,2), OLSgap(:,i));
    title(['Output gaps for ' V(i)]);
    legend('HP gap','OLS gap');
    xlabel('Quarter');
    saveas(i+2,['figure ' num2str(i+2) '.pdf']); 
end