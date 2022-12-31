clc;
clearvars

clc;
clearvars;

load('AutoDatasetISLR.mat');


data = Auto(:,{'mpg', 'horsepower'});
s = size(data);
N = s(1);

X = table2array(data(:, 'horsepower'));
y = table2array(data(:, 'mpg'));

X1 = make_poly(X, 1);
X2 = make_poly(X, 2);
X3 = make_poly(X, 3);
X4 = make_poly(X, 4);
X5 = make_poly(X, 5);
X6 = make_poly(X, 6);
%{
X7 = make_poly(X, 7);
X8 = make_poly(X, 8);
X9 = make_poly(X, 9);
X10 = make_poly(X, 10);


%}
warning off
figure
for i = 1:10
    cvMSE1 = crossval('mse',X1,y,'Predfun',@regf)
    cvMSE2 = crossval('mse',X2,y,'Predfun',@regf)
    cvMSE3 = crossval('mse',X3,y,'Predfun',@regf)
    cvMSE4 = crossval('mse',X4,y,'Predfun',@regf)
    cvMSE5 = crossval('mse',X5,y,'Predfun',@regf)
    cvMSE6 = crossval('mse',X6,y,'Predfun',@regf)
    %{
    ESPLODE da qua
    cvMSE7 = crossval('mse',X7,y,'Predfun',@regf, 'leaveout', 1)
    cvMSE8 = crossval('mse',X8,y,'Predfun',@regf, 'leaveout', 1)
    cvMSE9 = crossval('mse',X9,y,'Predfun',@regf, 'leaveout', 1)
    cvMSE10 = crossval('mse',X10,y,'Predfun',@regf, 'leaveout', 1)
    %}
    
    MSE = [cvMSE1, cvMSE2, cvMSE3, cvMSE4, cvMSE5, cvMSE6];
    ordine = [1, 2, 3, 4, 5, 6];
    plot(ordine, MSE)
    hold on
    xlabel('Gradi del polinomio')
    ylabel('EQM')
end
hold off

function yfit = regf(Xtrain,ytrain,Xtest)
b = regress(ytrain, Xtrain); % qua se uso fitlm and predict o deficient rank matrix
yfit = Xtest*b; 
end