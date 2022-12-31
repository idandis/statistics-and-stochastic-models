%% PREVISIONE
%Caricamento del dataset completo ed eliminazione delle celle prive di
%alcuni valori.
tab = readtable ("dataset.xlsx");
tab = rmmissing(tab);
y=tab.Ozono;

%Plotto la serie ed elaboro l'histogram
plot(y)
title('OZONO')
histogram(y)

% Destagionalizzo 
for t=2:length(y)
y_d(t)= y(t)- y(t-1);
end

y_d=y_d';
plot(y_d)

histogram(y_d)

%Test statistici per la stazionarietà
h_test1 = adftest(y_d)  %Il risultato è h = 1 --> è stazionario
h_test2 = kpsstest(y_d) %Il risultato è h = 0 --> è stazionario

%% AUTOCORRELAZIONE
%Grafico autocorrelazione
autocorr(y_d)
%Grafico autocorrelazione parziale
parcorr(y_d)

%% Stima del modello
% Modelli derivanti da osservazione del grafico parcorr
%estimate arma(1,0,0)
Mdl1 = arima(1, 0, 0);
arma100 = estimate(Mdl1, y_d);
res = infer(arma100,y_d);
mm1 = mean(res);

h1 = lbqtest(res); %C'è correlazione tra i residui?
n1 = jbtest(res); % sono normali?
% I residui non sono normali, c'è correlazione tra i residui e la media è 0

%estimate arima(2,0,0)
Mdl2 = arima(2, 0, 0);
arma200 = estimate(Mdl2, y_d);
res = infer(arma200,y_d);
mm2 = mean(res);

h2 = lbqtest(res);
n2 = jbtest(res); % sono normali?
% I residui non sono normali, non c'è correlazione tra i residui e la media è 0

%estimate arima(4,0,0)
Mdl3 = arima(4, 0, 0);
arma400 = estimate(Mdl3, y_d);
res = infer(arma400,y_d);
mm3 = mean(res);

h3 = lbqtest(res);
n3 = jbtest(res); % sono normali?
% I residui sono incorrelati, non sono normali e media è zero.

%estimate arima(8,0,0)
Mdl4 = arima(8, 0, 0);
arma800 = estimate(Mdl4, y_d);
res = infer(arma800,y_d);
mm4 = mean(res);

h4 = lbqtest(res);
n4 = jbtest(res); % sono normali?
% I residui sono incorrelati, non sono normali e media è zero.

%% Modelli derivanti da osservazione del grafico autocorr
%estimate arima(0,0,1)
Mdl5 = arima(0, 0, 1);
arma001 = estimate(Mdl5, y_d);
res = infer(arma001,y_d);
mm5 = mean(res);

h5 = lbqtest(res);
n5 = jbtest(res); % sono normali?
% I residui non sono incorrelati, non sono normali e media  è zero.

%estimate arima(0,0,2)
Mdl6 = arima(0, 0, 2);
arma002 = estimate(Mdl6, y_d);
res = infer(arma002,y_d);
mm6 = mean(res);

h6 = lbqtest(res);
n6 = jbtest(res); % sono normali?
% I residui sono incorrelati, non sono normali e media non è zero.

%estimate arima(0,0,8)
Mdl7 = arima(0, 0, 8);
arma008 = estimate(Mdl7, y_d);
res = infer(arma008,y_d);
mm7 = mean(res);

h7 = lbqtest(res);
n7 = jbtest(res); % sono normali?
% I residui  sono incorrelati,non sono normali e media è zero.


%Algoritmo iterativo per la valutazione dei modelli arma(p,0,q)
for p=1:1:5
    for q=1:1:6
        Mdl_matrix(p,q) = arima(p, 0, q);
        arma_matrix(p,q) = estimate(Mdl_matrix(p,q), y_d);
        res = infer(arma_matrix(p,q),y_d);
        mm_matrix(p,q) = mean(res);

        temp = summarize(arma_matrix(p,q));
        AIC_models(p,q) = temp.AIC;
        BIC_models(p,q) = temp.BIC;
        STD_models(p,q) = temp.VarianceTable.StandardError;
        
    end    
end

%arma(1,0,8)
p=1;
q=8;
Mdl_matrix(p,q) = arima(p, 0, q);
arma_matrix(p,q) = estimate(Mdl_matrix(p,q), y_d);
res = infer(arma_matrix(p,q),y_d);
mm_matrix(p,q) = mean(res);

temp = summarize(arma_matrix(p,q));
AIC_models(p,q) = temp.AIC;
BIC_models(p,q) = temp.BIC;
STD_models(p,q) = temp.VarianceTable.StandardError;

%arma(1,0,7) 
p=1;
q=7;
Mdl_matrix(p,q) = arima(p, 0, q);
arma_matrix(p,q) = estimate(Mdl_matrix(p,q), y_d);
res = infer(arma_matrix(p,q),y_d);
mm_matrix(p,q) = mean(res);

temp = summarize(arma_matrix(p,q));
AIC_models(p,q) = temp.AIC;
BIC_models(p,q) = temp.BIC;
STD_models(p,q) = temp.VarianceTable.StandardError;

%arma(2,0,7)
p=2;
q=7;
Mdl_matrix(p,q) = arima(p, 0, q);
arma_matrix(p,q) = estimate(Mdl_matrix(p,q), y_d);
res = infer(arma_matrix(p,q),y_d);
mm_matrix(p,q) = mean(res);

temp = summarize(arma_matrix(p,q));
AIC_models(p,q) = temp.AIC;
BIC_models(p,q) = temp.BIC;
STD_models(p,q) = temp.VarianceTable.StandardError;

%arma(2,0,8)
p=2;
q=8;
Mdl_matrix(p,q) = arima(p, 0, q);
arma_matrix(p,q) = estimate(Mdl_matrix(p,q), y_d);
res = infer(arma_matrix(p,q),y_d);
mm_matrix(p,q) = mean(res);

temp = summarize(arma_matrix(p,q));
AIC_models(p,q) = temp.AIC;
BIC_models(p,q) = temp.BIC;
STD_models(p,q) = temp.VarianceTable.StandardError;

%arma(3,0,7)
p=3;
q=7;
Mdl_matrix(p,q) = arima(p, 0, q);
arma_matrix(p,q) = estimate(Mdl_matrix(p,q), y_d);
res = infer(arma_matrix(p,q),y_d);
mm_matrix(p,q) = mean(res);

temp = summarize(arma_matrix(p,q));
AIC_models(p,q) = temp.AIC;
BIC_models(p,q) = temp.BIC;
STD_models(p,q) = temp.VarianceTable.StandardError;

%arma(3,0,8)
p=3;
q=8;
Mdl_matrix(p,q) = arima(p, 0, q);
arma_matrix(p,q) = estimate(Mdl_matrix(p,q), y_d);
res = infer(arma_matrix(p,q),y_d);
mm_matrix(p,q) = mean(res);

temp = summarize(arma_matrix(p,q));
AIC_models(p,q) = temp.AIC;
BIC_models(p,q) = temp.BIC;
STD_models(p,q) = temp.VarianceTable.StandardError;

%arma(4,0,7)
p=4;
q=7;
Mdl_matrix(p,q) = arima(p, 0, q);
arma_matrix(p,q) = estimate(Mdl_matrix(p,q), y_d);
res = infer(arma_matrix(p,q),y_d);
mm_matrix(p,q) = mean(res);

temp = summarize(arma_matrix(p,q));
AIC_models(p,q) = temp.AIC;
BIC_models(p,q) = temp.BIC;
STD_models(p,q) = temp.VarianceTable.StandardError;

%arma(4,0,8)
p=4;
q=8;
Mdl_matrix(p,q) = arima(p, 0, q);
arma_matrix(p,q) = estimate(Mdl_matrix(p,q), y_d);
res = infer(arma_matrix(p,q),y_d);
mm_matrix(p,q) = mean(res);

temp = summarize(arma_matrix(p,q));
AIC_models(p,q) = temp.AIC;
BIC_models(p,q) = temp.BIC;
STD_models(p,q) = temp.VarianceTable.StandardError;

%arma(5,0,7)
p=5;
q=7;
mm_matrix(p,q) = NaN;

AIC_models(p,q) = NaN;
BIC_models(p,q) = NaN;
STD_models(p,q) = NaN;

%arma(5,0,8)
p=5;
q=8;
Mdl_matrix(p,q) = arima(p, 0, q);
arma_matrix(p,q) = estimate(Mdl_matrix(p,q), y_d);
res = infer(arma_matrix(p,q),y_d);
mm_matrix(p,q) = mean(res);

temp = summarize(arma_matrix(p,q));
AIC_models(p,q) = temp.AIC;
BIC_models(p,q) = temp.BIC;
STD_models(p,q) = temp.VarianceTable.StandardError;


for p=6
    for q=1:1:6
        Mdl_matrix(p,q) = arima(p, 0, q);
        arma_matrix(p,q) = estimate(Mdl_matrix(p,q), y_d);
        res = infer(arma_matrix(p,q),y_d);
        mm_matrix(p,q) = mean(res);

        temp = summarize(arma_matrix(p,q));
        AIC_models(p,q) = temp.AIC;
        BIC_models(p,q) = temp.BIC;
        STD_models(p,q) = temp.VarianceTable.StandardError;
    end    
end

%arma(6,0,7)
p=6;
q=7;
mm_matrix(p,q) = NaN;

AIC_models(p,q) = NaN;
BIC_models(p,q) = NaN;
STD_models(p,q) = NaN;

%arma(6,0,8)
p=6;
q=8;
Mdl_matrix(p,q) = arima(p, 0, q);
arma_matrix(p,q) = estimate(Mdl_matrix(p,q), y_d);
res = infer(arma_matrix(p,q),y_d);
mm_matrix(p,q) = mean(res);

temp = summarize(arma_matrix(p,q));
AIC_models(p,q) = temp.AIC;
BIC_models(p,q) = temp.BIC;
STD_models(p,q) = temp.VarianceTable.StandardError;
        
for p=7:1:8
    for q=1:1:8
        Mdl_matrix(p,q) = arima(p, 0, q);
        arma_matrix(p,q) = estimate(Mdl_matrix(p,q), y_d);
        res = infer(arma_matrix(p,q),y_d);
        mm_matrix(p,q) = mean(res);

        temp = summarize(arma_matrix(p,q));
        AIC_models(p,q) = temp.AIC;
        BIC_models(p,q) = temp.BIC;
        STD_models(p,q) = temp.VarianceTable.StandardError;
    end    
end


%Estrapolo dai modelli ottenuti dall'algoritmo iterativo quelli aventi BIC
%e AIC minori

%Calcolo p e q per BIC minimo
clear min
BICminimo = min(min(BIC_models));

for(i=1:1:8)
    for(j=1:1:8)
        if(BICminimo ==BIC_models(i,j))
            p=i;
            q=j;
        end
    end
end
model1=arima(p, 0, q);
arma_new1= estimate(model1, y_d); %--> Modello con BIC minimo

%Calcolo p e q per AIC minimo
clear min
AICminimo = min(min(AIC_models));

for(i=1:1:8)
    for(j=1:1:8)
        if(AICminimo == AIC_models(i,j))
            p=i;
            q=j;
        end
    end
end
model2=arima(p, 0, q);
arma_new2= estimate(model2, y_d); %--> Modello con AIC minimo

%Calcolo p e q per STD minimo
clear min
STDminimo = min(min(STD_models));

for(i=1:1:8)
    for(j=1:1:8)
        if(STDminimo == STD_models(i,j))
            p=i;
            q=j;
        end
    end
end

%Conferma che il modello migliore sia arma101

%% TECNICA DI VALIDAZIONE: CRITERIO AIC + CRITERIO BIC + STD
%Seleziono il miglior modello usando i criteri AIC e BIC
models = [arma100, arma200, arma400, arma800, arma001, arma002, arma008, arma_new1,arma_new2];
AIC_models = zeros(9, 1);

for i = 1:9
    temp = summarize(models(i));
    AIC_models(i) = temp.AIC;
end

BIC_models = zeros(9, 1);

for i = 1:9
    temp = summarize(models(i));
    BIC_models(i) = temp.BIC;
end

%Aggiungo anche la valutazione dello standard error per una maggiore
%chiarezza
STD_models = zeros(9, 1);
for i = 1:9
    temp = summarize(models(i));
    STD_models(i) = temp.VarianceTable.StandardError;
end

subplot(1,3,1)
plot(AIC_models, 'o-')
title('AIC')
xlabel('Numero regressori')
set(gca)

subplot(1,3,2)
plot(BIC_models, 'o-')
title('BIC')
xlabel('Numero regressori')

subplot(1,3,3)
plot(STD_models, 'o-')
title('Standard Error')
xlabel('Numero regressori')

%Il migliore modello risulta essere arma_new1 --> arma101

%Il modello individuato è stazionario?
arma101=arma_new1
arma101.AR
r = roots([1, arma101.AR{1}])
abs(r) %--> Tutte le radici risultano essere all'interno del cerchio unitario

%Simulo traiettorie casuali del modello trovato
y_star = simulate(arma101,160,'NumPaths',10)
plot(y_star)

%% ANALISI DEI RESIDUI
%Diagnosi dei residui
res = infer(arma101,y_d); 
%I residui hanno media nulla?
mean(res) %--> La media è nulla

% I residui sono autocorrelati?
h = lbqtest(res)   %--> I residui sono incorrelati
% I residui sono normali?
n = jbtest(res)    %--> I residui non sono normali
%I residui sono eteroschedastici?
a = archtest(res)  %--> I residui sono omoschedastici

%% Normalizzazione dei residui
%Le trasformazioni logaritmiche sono usate per normalizzare una variabile
%che ha una distribuzione asimmetrica. Queste tendono anche a ridurre gli
%effetti degli outliers.
reslog = log(res)
rl = jbtest(reslog) %Non raggiungiamo il nostro obiettivo

%2° METODO
%Simulo altri residui che estraggo da quelli già osservati
maxres = max(res)
minres = min(res)
numres = length(res)          
R =minres + (maxres-minres)*rand(160,1);  

C = [res', R']'  %Concateno residui osservati e simulati
length (C)
normres = jbtest(C)
plot(C)

%% Bootstrap semi-parametrico 
%Voglio stimare e fare poi inferenza su beta 
y=tab.Ozono
x=tab.Temperatura   %--> Scelgo Ozono e temperatura perchè sono dipendenti
plot (x, y, 'o')    % dal grafico vedo che si avvicinano ad una retta
                    % voglio fare inferenza su beta 

X = [ones(length(x),1),x];
[b, bint, res] = regress(y, X, 0.05);

m1 = fitlm(tab,'ResponseVar','Ozono','PredictorVars',{'Temperatura'})
% il coef beta stimato da fitlm è 3.5281... solo per sicurezza 

%Intervallo di confidenza sul coefficiente angolare
%assumendo che epsilon sia normale 
disp ('coefficiente angolare + IC 95%');
disp([bint(2,1) b(2) bint(2,2)]) 

%Se non sono sicuro che epsilon sia normale e che quindi IC 
%sia corretto allora eseguiamo bootstrap
histfit (res);
%Creo il vettore della previsione 
y_hat=b(2)*x+b(1); %stima fatta dal modello per le x osservate deterministiche 

%Esecuzione del bootstrap
m=10000;
b_boot = zeros(m,2);

for i=1:m
idx = unidrnd(160,160,1)
y_boot = y_hat+res(idx)
b_boot(i,:) = regress(y_boot,X); %faccio la nuova stima
end    

figure
histfit(b_boot(:,2));

m = mean (b_boot(:,2)); %3.5254 coincide con quello stimato sopra 
s = std(b_boot(:,2)); %0.2602

%IC 95% bootstrap 
q=quantile (b_boot(:,2), [0.025 0.975]);
disp ('coefficiente angolare + IC 95%');
disp ([q(1) m q(2)])

%% Standardizzazione dei residui
stdr = res/sqrt(arma101.Variance);
figure
subplot(2,2,1)
plot(stdr)
title('Standardized Residuals')
subplot(2,2,2)
histogram(stdr,10)
title('Standardized Residuals')
subplot(2,2,3)
autocorr(stdr)
subplot(2,2,4)
parcorr(stdr)

%% PREVISIONE
%forecasting 5 steps in avanti
hf = 5;
[YF, YMSE] = forecast(arma101, hf, y_d);
figure
p1 = plot(y,'Color',[.7,.7,.7]);
hold on
Thf = (length(y_d) + 1):(length(y_d) + hf);
Thf = Thf';
p2 = plot(Thf,YF,'b','LineWidth',2);
p3 = plot(Thf,YF + 1.96*sqrt(YMSE),'r:',...
		'LineWidth',2);
plot(Thf,YF - 1.96*sqrt(YMSE),'r:','LineWidth',2);
legend([p1 p2 p3],'Observed','Forecast',...
		'95% Confidence Interval','Location','NorthWest');
title(['30-Period Forecasts and Approximate 95% '...
			'Confidence Intervals'])
hold off

%forecasting 100 steps in avanti
hf = 100;
[YF, YMSE] = forecast(arma101, hf, y_d);
figure
p1 = plot(y_d,'Color',[.7,.7,.7]);
hold on
Thf = (length(y) + 1):(length(y_d) + hf);
Thf = Thf';
p2 = plot(Thf,YF,'b','LineWidth',2);
p3 = plot(Thf,YF + 1.96*sqrt(YMSE),'r:',...
		'LineWidth',2);
plot(Thf,YF - 1.96*sqrt(YMSE),'r:','LineWidth',2);
legend([p1 p2 p3],'Observed','Forecast',...
		'95% Confidence Interval','Location','NorthWest');
title(['30-Period Forecasts and Approximate 95% '...
			'Confidence Intervals'])
hold off

%% METODO JACKKNIFE 
% Il metodo jackknife è una procedura di ricampionamento utilizzata in
% statistica per stimare l'errore standard di una grandezza.


%% AGGIUNTAAAAAA
dati = readtable ("Meteo.xlsx");
dati = rmmissing(dati);

%Utilizzo "regArima" solo con PM10 e Spostamenti --> Supponiamo che il
%meteo rimanga costante (presupposto non reale)
Mdl1 = regARIMA('ARLags',1);
Mdl2 = regARIMA('MALags', 1:2);

EstMdl1 = estimate(Mdl1,dati.PM10,'X', dati.SpostamentiInMacchina,'Display','params')
EstMdl2 = estimate(Mdl2,dati.PM10,'X', dati.SpostamentiInMacchina,'Display','params')

models = [EstMdl1, EstMdl2];
AIC_models = zeros(2, 1);

for i = 1:2
    temp = summarize(models(i));
    AIC_models(i) = temp.AIC;
end

BIC_models = zeros(2, 1);

for i = 1:2
    temp = summarize(models(i));
    BIC_models(i) = temp.BIC;
end

subplot(1,2,1)
plot(AIC_models, 'o-')
title('AIC')
xlabel('Numero regressori')
set(gca)

subplot(1,2,2)
plot(BIC_models, 'o-')
title('BIC')
xlabel('Numero regressori')

%Il migliore modello risulta essere EstMdl1
y_stimato1= EstMdl1.Intercept + EstMdl1.Beta(1) * dati.SpostamentiInMacchina;
plot(y_stimato1)

%Utilizzo "regArima" con PM10 e Spostamenti + Meteo 

X= [dati.SpostamentiInMacchina dati.Pressione dati.Temperatura dati.Umidit_Relativa dati.Vento] 

y_stimato= EstMdl3.Intercept + EstMdl3.Beta(1) * dati.SpostamentiInMacchina +  EstMdl3.Beta(2) * dati.Pressione + EstMdl3.Beta(3) * dati.Temperatura+ EstMdl3.Beta(4) * dati.Umidit_Relativa+ EstMdl3.Beta(5) * dati.Vento ;

Mdl3 = regARIMA('ARLags',1);
Mdl4 = regARIMA('MALags', 1:2);
Mdl5 = regARIMA('MALags', 1:3);
Mdl6 = regARIMA('MALags', 1:4);

EstMdl3 = estimate(Mdl3,dati.PM10,'X', X,'Display','params')
EstMdl4 = estimate(Mdl4,dati.PM10,'X', X,'Display','params')
EstMdl5 = estimate(Mdl5,dati.PM10,'X', X,'Display','params')
EstMdl6 = estimate(Mdl6,dati.PM10,'X', X,'Display','params')

models = [EstMdl3, EstMdl4, EstMdl5, EstMdl6];
AIC_models = zeros(4, 1);

for i = 1:4
    temp = summarize(models(i));
    AIC_models(i) = temp.AIC;
end

BIC_models = zeros(4, 1);

for i = 1:4
    temp = summarize(models(i));
    BIC_models(i) = temp.BIC;
end

subplot(1,2,1)
plot(AIC_models, 'o-')
title('AIC')
xlabel('Numero regressori')
set(gca)

subplot(1,2,2)
plot(BIC_models, 'o-')
title('BIC')
xlabel('Numero regressori')

% Il modello migliore secondo metodi di validazione risulta essere EstMdl3
y_stimato2= EstMdl3.Intercept + EstMdl3.Beta(1) * dati.SpostamentiInMacchina +  EstMdl3.Beta(2) * dati.Pressione + EstMdl3.Beta(3) * dati.Temperatura+ EstMdl3.Beta(4) * dati.Umidit_Relativa+ EstMdl3.Beta(5) * dati.Vento;

%IPOTESI --> Mantenento le caratteristiche meteo costante, cosa
%succederebbe se diminuissimo ad un terzo gli spostamenti in macchina?

newSpostamenti=dati.SpostamentiInMacchina * (1/3);
y_stimato3= EstMdl3.Intercept + EstMdl3.Beta(1) * newSpostamenti +  EstMdl3.Beta(2) * dati.Pressione + EstMdl3.Beta(3) * dati.Temperatura+ EstMdl3.Beta(4) * dati.Umidit_Relativa+ EstMdl3.Beta(5) * dati.Vento;
plot(y_stimato2)
hold on
plot(y_stimato3,'b--o')

nuovo1=y_stimato3;
vecchio1=y_stimato2;

for i=1:1:length(nuovo1)
    aumento1(i) = (nuovo1(i)/vecchio1(i))-1;
end

aumento_percentuale= mean(aumento1) *100

%Concentrazione di PM10 diminuisce, ma non significativamente
% Diminuisce del 2,24%

%IPOTESI --> Mantenento le caratteristiche meteo costante, cosa
%succederebbe se a causa del surriscaldamento globale, la temperatura media aumentasse
%di 10 gradi?

newTemperatura= dati.Temperatura+10;
y_stimato4= EstMdl3.Intercept + EstMdl3.Beta(1) * dati.SpostamentiInMacchina +  EstMdl3.Beta(2) * dati.Pressione + EstMdl3.Beta(3) * newTemperatura+ EstMdl3.Beta(4) * dati.Umidit_Relativa+ EstMdl3.Beta(5) * dati.Vento;
plot(y_stimato2)
hold on
plot(y_stimato4,'b--o')

%Concentrazione di PM10 aumenta significativamente a causa dell'aumento
%della temperatura. Di quanto aumenta?
nuovo=y_stimato4;
vecchio=y_stimato2;

for i=1:1:length(nuovo)
    aumento(i) = (nuovo(i)/vecchio(i))-1;
end

aumento_percentuale= mean(aumento) *100 %--> Si ha un aumento medio del 75,59%