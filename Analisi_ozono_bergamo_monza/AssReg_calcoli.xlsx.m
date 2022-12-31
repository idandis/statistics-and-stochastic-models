%% PROGETTO MONACO
% Carichiamo i nostri dati
load('G25.mat')
%Ispezione del dataset: per ogni variabile della table andiamo ad
%ispezionare le statistiche descrittive minime (minimo, mediaa e massimo).
summary(tG)

%% ANALISI DATI PER MONZA

%% Analisi e descrizione della variabile che vogliamo studiare (Ozono) 
%calcolo mean/std/min/max della variabile O3_tG1 raggruppando le
%righe per 'ARPA_AQ_cod_staz_tG1'
grpstats(tG,'ARPA_AQ_cod_staz_tG1',{'mean','std','min','max'},'DataVars',{'O3_tG1'})

%% Grafici che relazionano O3 con i vari inquinanti (NO2, NOx, umidità)
y = tG.O3_tG1;
x = tG.Temperatura_tG1;
scatter(x,y,'filled') 
title('O3 e Temperatura') 
%All'aumentare dell'ozono aumenta anche la temperatura--> potenziale
%correlazione positiva. 

y = tG.O3_tG1;
x = tG.NO2_tG1;
scatter(x,y,'filled')
title('O3 e NO2')
%All'aumentare dell'ozono diminuisce l'NO2--> potenziale
%correlazione negativa. 

x = tG.O3_tG1;
y = tG.NOx_tG1;
scatter(x,y,'filled')
title('O3 e NOx')
%All'aumentare dell'ozono diminuisce l'NOx--> potenziale
%correlazione negativa. 

x=tG.Umidita_relativa_tG1;
y=tG.O3_tG1;
scatter(x,y,'filled')
title('O3 e umidità')
%All'aumentare dell'ozono diminuisce l'umidità--> potenziale
%correlazione negativa. 

%Creo una matrice di dati con solo le variabili 'PM10_tG1','Temperatura_tG1','Pioggia_cum_tG1','Umidita_relativa_tG1','O3_tG1' .
tab = tG(:,{'PM10_tG1','Temperatura_tG1','Pioggia_cum_tG1','Umidita_relativa_tG1','O3_tG1'})
tab.Properties.VariableNames = {'PM10','Temperatura','Pioggia','Umidita','Ozono'};

%% Modello di regressione lineare
% m1: completo
m1 = fitlm(tab,'ResponseVar','Ozono','PredictorVars',{'PM10','Temperatura','Pioggia','Umidita'})
%Modello di regressione lineare: Ozono ~ 1 + PM10 + Temperatura + Pioggia +
%Umidita

%I coefficienti ottenuti sono significativi? 
%Analizziamo il P-value. Intercetta: PV=1.3393e-16, rifiutiamo l'ipotesi nulla, il coeff. è significativo. 
%PM10: PV= 0.0077467 , rifiutiamo l'ipotesi nulla, il coeff. è significativo.
%Temperatura: PV= 5.4476e-46, rifiutiamo l'ipotesi nulla, il coeff. è significativo.
%Pioggia: PV= 0.42337, accettiamo l'ipotesi nulla, non è un coeff. significativo.
%Umidità: PV=  8.9753e-16, rifiutiamo l'ipotesi nulla, il coeff. è significativo.

%Una visione più ampia è possibile tramite l'osservazione di
%F-statistic: il nostro P-Value è -->0 , rifiuto quindi l'ipotesi nulla 
%(la quale era: tutti i coeff. sono contemporaneamente non significativi).
%Si parla di RIGETTO FORTE.


%% Adattamento
r2 = m1.Rsquared.Ordinary
% Il 91.21% della variabilità complessiva di Ozono è spiegato dalla
% relazione lineare con la temperatura, pioggia, umidità e concentrazioni di PM10.

%% Modello di regressione con stepwiselm
%Selezione del modello migliore  aggiungendo o togliendo variabili.
stepwiselm (tab)
% NB= L'addatamento migliora e passa da 91.21% al 92.30%.
%Il modello di regressione ottenuto è : Ozono ~ 1 + PM10*Temperatura + Temperatura*Umidita.
%Da qui si deduce che la temperatura sia particolarmente influenzante,
%difatti l’ozono è un inquinante tipicamente estivo.

%% Analisi dei residui
residuim1 = m1.Residuals.Raw
%Bisogna analizzare la distribuzione dei residui: la media deve essere 0
% Serie storica
plot(residuim1)
yline(0,'y','LineWidth',4)
yline(mean(residuim1),'g','LineWidth',2)
% Istogramma
histfit(residuim1)

% Ulteriore conferma: usiamo qq plot per confrontare i quantili osservati con i quantili attesi nel caso la distribuzione fosse normale.
%Dato che i punti si dispongono lungo una retta, la distribuzione approssima bene la normale.
qqplot (residuim1)

% conferma analitica tramite l'utilizzo del test di Shapiro-Wilk 
function [H, pValue, W] = swtest(residuim1, 0.05)

%% ANALISI DEI DATI PER BERGAMO 

%Calcolo mean/std/min/max della variabile O3_tG1 raggruppando le
%righe per 'ARPA_AQ_cod_staz_tG1'
grpstats(tG,'ARPA_AQ_cod_staz_BG',{'mean','std','min','max'},'DataVars',{'O3_BG'})

%I grafici che relazionano O3 con i vari inquinanti (NO2, NOx, PM10) 
y = tG.O3_BG;
x = tG.Temperatura_BG;
scatter(x,y,'filled')
title('O3 e Temperatura') 

y = tG.O3_BG;
x = tG.NO2_BG;
scatter(x,y,'filled')
title('O3 e NO2')

y = tG.O3_BG;
x = tG.NOx_BG;
scatter(x,y,'filled')
title('O3 e NOx')

%Creo una matrice di dati con solo le variabili 'PM10_tG1','Temperatura_tG1','Pioggia_cum_tG1','Umidita_relativa_tG1','O3_tG1' .
tab2 = tG(:,{'PM10_BG','Temperatura_BG','Pioggia_cum_BG','Umidita_relativa_BG','O3_BG'})

tab2.Properties.VariableNames = {'PM10','Temperatura','Pioggia','Umidita','Ozono'};

%% Modello di regressione lineare
% m1: completo
mBG = fitlm(tab2,'ResponseVar','Ozono','PredictorVars',{'PM10','Temperatura','Pioggia','Umidita'})
%Modello di regressione lineare: Ozono ~ 1 + PM10 + Temperatura + Pioggia + Umidità

%% Adattamento
r2BG = mBG.Rsquared.Ordinary
% L' 88.04% della variabilità complessiva di Ozono è spiegato dalla
% relazione lineare con la temperatura, pioggia, umidità e concentrazioni
% di PM10.

%% Modello di regressione con stepwiselm
stepwiselm (tab2)
% Il modello di regressione lineare diventa Ozono ~ 1 + PM10 + Pioggia + Temperatura*Umidita.
% L'addattamento migliora e passa da 88.00% al 90.01%

%% Analisi dei residui
residuimBG = mBG.Residuals.Raw
%Bisogna analizzare la distribuzione dei residui: la media deve essere 0
% Serie storica

plot(residuimBG)
yline(0,'y','LineWidth',4)
yline(mean(residuimBG),'g','LineWidth',2)
% Istogramma
histfit(residuimBG)

% uso qq plot per controlare che i dati in questo caso i residui grezzi
%si distribiscono come una normale 
qqplot (residuimBG)

% conferma analitica tramite l'utilizzo del test di Shapiro-Wilk 
function [H, pValue, W] = swtest(residuimBG, 0.05)


%% CORRELAZIONE MONZA - BERGAMO PER I VALORI DELL'OZONO 
% controllo la correlazione dei dati della concentrazione di ozono di monza
% in funzione di bg 

x1 = tG.O3_BG;
y1 = tG.O3_tG1;

%Che relazione c'è tra x1 e y1? Covariano positivamente, negativamente o
%non covariano?
varcov=cov(x1, y1)
%Essendo la covarianza pari a 1.1893, x1 e y1 covariano positivamente.
%NB= Con la correlazione non ci attendiamo che tra le due variabili X e Y
%ci sia un rapporto causale.


% Per ovviare il problema di eventuali dati mancanti, usiamo le ulteriori
% specifiche del comando "corr"
corr (x1, y1, 'Rows' , 'Complete') % ottengo una correlazione del 98.74%. Essendo prossima ad 1, dati molto simili 
scatter (x1, y1) % Per una maggiore chiarezza utilizzo un grafico a dispersione

m_BG_M= fitlm (x1, y1) % C'è una buona correlazione per i dati dell'ozono -> R-squared = 0.975 

%___________________________________________________________________________________________________
% Analisi dei dati usando la trasformazione logaritmica 
%Carico la tabella dati
load('G25.mat')
summary(tG)
%Creo una nuova tabella contenente solo i dati che ci interessano
data = tG(:,{'PM10_tG1','Temperatura_tG1','Pioggia_cum_tG1','Umidita_relativa_tG1','O3_tG1'})
%Trasformo l'ozono in logaritmo
data.logO3_tG1=log(data.O3_tG1)
%Confronto tra modelli
mlog1=fitlm(data,'responsevar','logO3_tG1','predictorvars',{'PM10_tG1','Temperatura_tG1','Pioggia_cum_tG1','Umidita_relativa_tG1'})
mlog2=fitlm(data,'responsevar','logO3_tG1','predictorvars',{'PM10_tG1','Temperatura_tG1','Pioggia_cum_tG1'})
mlog3=fitlm(data,'responsevar','logO3_tG1','predictorvars',{'PM10_tG1','Temperatura_tG1'})
mlog4=fitlm(data,'responsevar','logO3_tG1','predictorvars',{'Temperatura_tG1'})
mlog5=fitlm(data,'responsevar','logO3_tG1','predictorvars',{'Pioggia_cum_tG1'})
%GRAFICI
%O3/T
y = data.logO3_tG1;
x = data.Temperatura_tG1;
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('O3log e Temperatura (MB)') 
%O3/PM10
y = data.logO3_tG1;
x = data.PM10_tG1;
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('O3log e PM10 (MB)')
%O3/Pioggia
y = data.logO3_tG1;
x = data.Pioggia_cum_tG1
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('O3log e Pioggia (MB)')
%O3/Umidità
y=data.logO3_tG1;
x=data.Umidita_relativa_tG1
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('O3log e Umidità (MB)')
%BERGAMO
data2 = tG(:,{'PM10_BG','Temperatura_BG','Pioggia_cum_BG','Umidita_relativa_BG','O3_BG'})
%Trasformo l'ozono in logaritmo
data2.logO3_BG=log(data2.O3_BG)
%esempi di modelli
m1 = fitlm(data2,'responseVar','logO3_BG','predictorvars',{'PM10_BG','Temperatura_BG','Pioggia_cum_BG','Umidita_relativa_BG'})
m2 = fitlm(data2,'responseVar','logO3_BG','predictorvars',{'PM10_BG','Temperatura_BG','Pioggia_cum_BG'})
m3 = fitlm(data2,'responseVar','logO3_BG','predictorvars',{'PM10_BG','Temperatura_BG'})
m4 = fitlm(data2,'responseVar','logO3_BG','predictorvars',{'Temperatura_BG'})
%Analisi dei residui del modello m1
r=m1.Residuals.Raw
plot(r)
yline(0,'y','LineWidth',4)
yline(mean(r),'g','LineWidth',2)
%Istogramma dei residui
histogram(r)
%GRAFICI
%O3/T
y = data2.logO3_BG;
x = data2.Temperatura_BG;
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('O3log e Temperatura (BG)') 
%O3/PM10
y = data2.logO3_BG;
x = data2.PM10_BG;
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('O3log e PM10 (BG)')
%O3/Pioggia
y = data2.logO3_BG;
x = data2.Pioggia_cum_BG
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('O3log e Pioggia (BG)')
%O3/Umidità
y=data2.logO3_BG;
x=data2.Umidita_relativa_BG
scatter(x,y,'filled')
p=polyfit(x,y,1)
fx=polyval(p,x)
hold on
plot(x,fx)
title('O3log e Umidita (BG)')




