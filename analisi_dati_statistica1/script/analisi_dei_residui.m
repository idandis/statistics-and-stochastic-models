clc
clear
%% ANALISI DEI RESIDUI
% carico il dataset 
tab = readtable ("dataset.xlsx");

% eliminazione Nan
tab = rmmissing(tab);

%fitlm
model = fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','SpostamentiInMacchina','Umidit_Relativa','Ammoniaca','PM10', 'PM2_5','Benzene','BiossidoDiAzoto'})

stepwiselm (tab)

%residui
residui = model.Residuals.Raw;
mean(residui)

%plot semplice con la media dei residui
plot(residui)
histfit(residui);
normplot(residui);

%jbtest 
h = jbtest(residui) 

% controllo s e k 
s = skewness(residui)
k = kurtosis(residui)

%test Lilliefors
l = lillietest(residui)

%omoschedasticita dei redisui 

%confronto residui e temperatura
temp = [tab.Temperatura];
scatter (temp, residui)
title('Confronto tra residui e temperatura')
ylabel('Residui')
xlabel('Temperatura')

%confronto residui e benzene 
benzene = [tab.Benzene];
scatter (benzene, residui)
title('Confronto tra residui e benzene')
ylabel('Residui')
xlabel('Benzene')

%confronto residui e ozono
ozono = [tab.Ozono];
scatter (ozono, residui)
title('Confronto tra residui e ozono')
ylabel('Residui')
xlabel('Ozono')

%confronto residui e ozono
ozono = [tab.Ozono];
scatter (ozono, residui)
title('Confronto tra residui e ozono')
ylabel('Residui')
xlabel('Ozono')




































