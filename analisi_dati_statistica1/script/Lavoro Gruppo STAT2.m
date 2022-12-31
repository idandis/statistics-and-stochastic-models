%PARTE 1: [Ary]
%-Parte introduttiva con descrizione del dataset (Variabili che vengono analizzate, e perchè analizziamo l'ozono in relazione alle altre
% -Calcolo del vettore delle medie (medie di ogni variabile, organizzata in un vettore)
% -Grafici di correlazione tra ozono e gli altri regressori (es: ozono e spostamenti/ ozono e temperatura / ecc...)
%% 
% PARTE 2:
%
%test t-stepwise-
% OK* _ |% _*% -Elaborazione del modello di regressione: stima dei coefficienti [Luca]
%OK -Calcolo della varianza residua, R^2, ed R [Luca]
% OK-Test di adattamento? [Luca]*_-->E' R2
% OK-Test sui coefficienti singoli [Luca]| *

% -Analisi dei residui classica + tramite test JB [Iana]
% -Omoschedasticità dei residui (+ test opzionale?)  [Iana]
% 
% PARTE 3:
% -Validazione tramite dataset di validazione [Iana]
% -Validazione tramite metodo di cross-validazione [Miriam]
% 
% PARTE 4:
% -Analisi tramite basi monomiali/basi di Fourier/ Spline [Miriam]
% -Metodo Smoothing Spline (se necessario) [Miriam]
% 
% PARTE DA VALUTARE:
%-GLS successivo al OLS già utilizzato
%-Criterio del residuo (se si usa GLS)

% carico il dataset 
tab = readtable ("dataset.xlsx");
% eliminazione Nan
tab = rmmissing(tab);

%fitlm
model = fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura','SpostamentiInMacchina','Umidit_Relativa','Ammoniaca','PM10', 'PM2_5','Benzene','BiossidoDiAzoto'})
%%
%------------------------------------------------------------------------
%%parte mia
%calcolo la n dei vari elementi (PER TUTTI E' 160)
n1=numel(tab.Ozono)
n2=numel(tab.Temperatura)
n3=numel(tab.SpostamentiInMacchina)
n4=numel(tab.Umidit_Relativa)
n5=numel(tab.Ammoniaca)
n6=numel(tab.PM10)
n7=numel(tab.PM2_5)
n8=numel(tab.Benzene)
n9=numel(tab.BiossidoDiAzoto)
%------------------------------------------------------------------------
%r-squared è dentro al fitlm oppure calcolo manuale
R2=1-(model.SSE/model.SST)
%------------------------------------------------------------------------
%Coefficiente ci correlazione R è la radice quadrata di R^2
R=sqrt(R2)

%------------------------------------------------------------------------
%calcolo i coefficienti beta
beta_hat = model.Coefficients.Estimate

%intervallo confidenza coefficienti (NON SO A COSA SERVE PERO' L'HO MESSO,
%PROBABILMENTE DA ELIMINARE
beta_hatIC = model.coefCI
%------------------------------------------------------------------------


%varianza residua + altre
model.SSE %residua
model.SST %TOTALE
model.SSR %di regressione
%------------------------------------------------------------------------

%BONTA' DI ADATTAMENTO
%E' rappresentato da R^2 (almeno da quello che ho capito) poichè esso
%descrive se il modello si presta a rappresentare il nostro modello oppure
%no
%------------------------------------------------------------------------
%TEST-T SUI COEFFICIENTI
%Con il t test vedo che molti dei dati non sono significativi per il nostor
%modello, in particolare il benzene, il pm10 e ammoniaca hanno una
%statistica t dentro la regione critica e un p-value troppo alto rispetto
%ad alpha (posto allo 0.05)
%BIOSSIDOAZOTO
t_beta1 = model.Coefficients.tStat(2)
alpha = 0.05
t_oss = t_beta1
t_crit1 = - tinv(1-alpha/2,160-2)
t_crit1 = + tinv(1-alpha/2,160-2)
pv_t_beta1 = model.Coefficients.pValue(2)
%BENZENE
t_beta2 = model.Coefficients.tStat(3)
alpha = 0.05
t_oss = t_beta2
t_crit2 = - tinv(1-alpha/2,160-2)
t_crit2 = + tinv(1-alpha/2,160-2)
pv_t_beta1 = model.Coefficients.pValue(3)
%PM10
t_beta3 = model.Coefficients.tStat(4)
alpha = 0.05
t_oss = t_beta3
t_crit3 = - tinv(1-alpha/2,160-2)
t_crit3 = + tinv(1-alpha/2,160-2)
pv_t_beta1 = model.Coefficients.pValue(4)
%PM2_5
t_beta4 = model.Coefficients.tStat(5)
alpha = 0.05
t_oss = t_beta4
t_crit4 = - tinv(1-alpha/2,160-2)
t_crit = + tinv(1-alpha/2,160-2)
pv_t_beta1 = model.Coefficients.pValue(5)
%TEMPERATURA
t_beta5 = model.Coefficients.tStat(6)
alpha = 0.05
t_oss = t_beta5
t_crit5 = - tinv(1-alpha/2,160-2)
t_crit5 = + tinv(1-alpha/2,160-2)
pv_t_beta1 = model.Coefficients.pValue(6)
%UMIDITA'
t_beta6 = model.Coefficients.tStat(7)
alpha = 0.05
t_oss = t_beta6
t_crit6 = - tinv(1-alpha/2,160-2)
t_crit6 = + tinv(1-alpha/2,160-2)
pv_t_beta1 = model.Coefficients.pValue(7)
%SPOSTAMENTI
t_beta7 = model.Coefficients.tStat(8)
alpha = 0.05
t_oss = t_beta7
t_crit7 = - tinv(1-alpha/2,160-2)
t_crit7 = + tinv(1-alpha/2,160-2)
pv_t_beta1 = model.Coefficients.pValue(8)
%AMMONIACA
t_beta8 = model.Coefficients.tStat(9)
alpha = 0.05
t_oss = t_beta8
t_crit8 = - tinv(1-alpha/2,160-2)
t_crit8 = + tinv(1-alpha/2,160-2)
pv_t_beta1 = model.Coefficients.pValue(9)

%------------------------------------------------------------------------
%GRAFICI
%O3/Temp
y = tab.Ozono;
x = tab.Temperatura;
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('OZONO TEMPERATURA') 
%O3/UMIDITA'
y = tab.Ozono;
x = tab.Umidit_Relativa;
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('OZONO UMITIDA') 
%O3/AMMONIACA
y = tab.Ozono;
x = tab.Ammoniaca;
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('OZONO AMMONIACA') 
%O3/PM2_5
y = tab.Ozono;
x = tab.PM2_5;
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('OZONO PM2_5')
%O3/BENZ',
y = tab.Ozono;
x = tab.Benzene;
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('OZONO BENZ') 
%O3/NO2
y = tab.Ozono;
x = tab.BiossidoDiAzoto;
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('OZONO BiossidoDiAzoto') 
%O3/SPOST
y = tab.Ozono;
x = tab.SpostamentiInMacchina;
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('OZONO SPOSTAMENTI') 
%O3/PM10
y = tab.Ozono;
x = tab.PM10;
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('OZONO PM10') 
%------------------------------------------------------------------------

%PARTE AGGIUNTIVA PER FARE DELLE PROVE NON CENTRA COL PROGETTO!!!!!!(FORSE
%QUALCOSA DI UTILE C'E')




%coefficiente di correlazione R tra ozono e altre variabili
%stabilisco le variabili
ozono=tab.Ozono
temperatura=tab.Temperatura
spostamenti=tab.SpostamentiInMacchina
umidita=tab.Umidit_Relativa
ammoniaca=tab.Ammoniaca
pm10=tab.PM10
pm2=tab.PM2_5
benzene=tab.Benzene
no2=tab.BiossidoDiAzoto
%correlazione ozono-temperatura
corr_matrix = corrcoef(ozono,temperatura)
rho1 = corr_matrix(1,2)
%correlazione ozono-spostamenti
corr_matrix = corrcoef(ozono,spostamenti)
rho2 = corr_matrix(1,2)
%correlazione ozono-umidità
corr_matrix = corrcoef(ozono,umidita)
rho3 = corr_matrix(1,2)
%correlazione ozono-ammoniaca
corr_matrix = corrcoef(ozono,ammoniaca)
rho4 = corr_matrix(1,2)
%correlazione ozono-pm10
corr_matrix = corrcoef(ozono,pm10)
rho5 = corr_matrix(1,2)
%correlazione ozono-pm2_5
corr_matrix = corrcoef(ozono,pm2)
rho6 = corr_matrix(1,2)
%correlazione ozono-benzene
corr_matrix = corrcoef(ozono,benzene)
rho7 = corr_matrix(1,2)
%correlazione ozono-no2
corr_matrix = corrcoef(ozono,no2)
rho8 = corr_matrix(1,2)


%------------------------------------------------------------------------


% Valori critici al 5%
alpha = 0.05
t_oss = t_beta1
t_crit1 = - tinv(1-alpha/2,n2-2)
t_crit1 = + tinv(1-alpha/2,n2-2)

y = tab.Ozono;
x = pm10;
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)

title('O3log e Temperatura (MB)') 

model = fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura'})
model = fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'SpostamentiInMacchina'})
model = fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Umidit_Relativa'})
model = fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Ammoniaca'})
model = fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'PM10'})
model = fitlm (tab,'ResponseVar','Ozono','PredictorVars',{ 'PM2_5'})
model = fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'Benzene'})
model = fitlm (tab,'ResponseVar','Ozono','PredictorVars',{'BiossidoDiAzoto'})








