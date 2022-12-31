% carico il dataset 
tab = readtable ("dataset.xlsx");

% eliminazione Nan
tab = rmmissing(tab);

%fitlm
model = fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','SpostamentiInMacchina','Umidit_Relativa','Ammoniaca','PM10', 'PM2_5','Benzene','BiossidoDiAzoto'})
%R2=0.892

%STEPWISE AUTOMATICA
mm= stepwiselm(tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','SpostamentiInMacchina','Umidit_Relativa','Ammoniaca','PM10', 'PM2_5','Benzene','BiossidoDiAzoto'})

%STEPWISE MANUALE
%Tolgo umidità relativa-- 0.785
m1= fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','SpostamentiInMacchina','Ammoniaca','PM10', 'PM2_5','Benzene','BiossidoDiAzoto'})
%Aggiungo umidità relativa, tolgo spostamenti in macchina--0.869
m1= fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','Umidit_Relativa','Ammoniaca','PM10', 'PM2_5','Benzene','BiossidoDiAzoto'})
%Tolgo biossido di azoto--0.816
m1= fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','Umidit_Relativa','Ammoniaca','PM10', 'PM2_5','Benzene'})
%Aggiungo biossido di azoto e tolgo il benzene --0.867
m1= fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','Umidit_Relativa','Ammoniaca','PM10', 'PM2_5','BiossidoDiAzoto'})
%Aggiungo gli spostamenti in macchina--0.891
m1= fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','SpostamentiInMacchina','Umidit_Relativa','Ammoniaca','PM10', 'PM2_5','BiossidoDiAzoto'})
%Tolgo ammoniaca--0.891
m1= fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','SpostamentiInMacchina','Umidit_Relativa','PM10', 'PM2_5','BiossidoDiAzoto'})
%Aggiungo ammoniaca e tolgo PM2_5--0.888
m1= fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','SpostamentiInMacchina','Umidit_Relativa','Ammoniaca','PM10','BiossidoDiAzoto'})
%Aggiungo PM2_5 e tolgo PM_10--0.890
m1= fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','SpostamentiInMacchina','Umidit_Relativa','Ammoniaca','PM2_5','BiossidoDiAzoto'})
%Tolgo la temperatura--0.846
m1= fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'SpostamentiInMacchina','Umidit_Relativa','Ammoniaca','PM2_5','BiossidoDiAzoto'})

%La migliore sembra essere 
m1= fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','SpostamentiInMacchina','Umidit_Relativa','Ammoniaca','PM10', 'PM2_5','BiossidoDiAzoto'})
%Qui ho un R2=0.891 molto vicino ad 0.909 trovato usando la stepwise
