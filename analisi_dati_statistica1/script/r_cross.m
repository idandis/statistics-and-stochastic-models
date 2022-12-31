%% CROSS-VALIDAZIONE
%Carico i dati
tab = readtable ("dataset.xlsx");
tab = rmmissing(tab); 
model = fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','SpostamentiInMacchina','Umidit_Relativa','Ammoniaca','PM10', 'PM2_5'})

MSE = nan(6,1);
R2 = nan(6,1);
regr_to_add =[{'PM10'} {'PM2_5'} {'Temperatura'} {'Umidit_Relativa'} {'SpostamentiInMacchina'} {'Ammoniaca'}]

for num_regr = 1:length(regr_to_add)
    all_data = rmmissing([ ...
        tab.Ozono, ...
        tab.BiossidoDiAzoto, ...
        tab.Benzene, ...
        table2array(tab(:, regr_to_add(1:num_regr))) ...
    ])

    y = all_data(:, 1) 
    X = [ones(size(all_data , 1), 1), all_data(:, 2:end)]
    b = (X' * X) \ X' * y
    y_hat = X * b
    res = y - y_hat
    
    % Caratteristiche del modello
    SST = sum((y - mean(y)).^2)
    SSE = sum(res.^2)
    R2(num_regr) = 1 - SSE / SST

    % Crossval
    regf=@(XTRAIN,ytrain,XTEST)(XTEST*regress(ytrain,XTRAIN));
    MSE(num_regr) = crossval('mse', X, y, 'Predfun', regf);

end

%Grafici di quanto osservato
figure('Name', 'R squared ed MSE')

subplot(1,2,1)
plot(3:8, R2, 'o-')
title('R squared')
ylabel('Percentuale')
xlabel('Numero regressori')

set(gca, 'XTick', 3:8)
subplot(1,2,2)
plot(3:8, MSE, 'o-')
title('Mean Square Error')
xlabel('Numero regressori')
set(gca, 'XTick', 3:8)
axis([3 8 0 1000])