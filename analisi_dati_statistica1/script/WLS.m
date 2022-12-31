
% WLS 

clear
clc

tab = readtable ("dataset.xlsx");
tab = rmmissing(tab);

x=tab.Temperatura;
y=tab.Ozono;
scatter (x,y);

X=[ones(length(x),1) x];
beta = (X'*X)^-1*X'*y;

%Parte 2: Pesi scelti mediante algoritmo iterativo

figure
mi = min(x);
ma = max(x);
xx = mi:0.01:ma;
yy=xx*beta(2)+beta(1);
D=ones(length(x),1);

%Prima iterazione: do per scontato che i dati giusti sono quelli che ho 
plot(xx,yy)
hold on
last_beta=[0 0]'; % all'inizio è uguale a zero ma poi mi salva il valore dell'ultimo beta
exit=0;
iteration_count=1;
while exit==0
    DD(iteration_count,:)=D;
    D = diag(D);
    beta = inv(X'*inv(D)*X)*X'*inv(D)*y; 
    res = y - (beta(1)+beta(2)*x); %criterio del risiduo 
    D = abs(res)'+0.001; %sommo una quantità piccola al valore assoluto per 
    %non avere problemi di segno 
    yy=xx*beta(2)+beta(1);
    plot(xx,yy)
    y1=yy;
    %Calcola la distanza
    delta=norm(last_beta-beta);
    if delta<0.001
        exit=1;
    end
    iteration_count=iteration_count+1;
    last_beta=beta;
end
totale = iteration_count; %28 interazioni 
%Matrice dei pesi delle simulazioni
DD
omega = diag(DD(end,:));
b_hat_omega_ls = last_beta
figure
plot(x,y,'o')
hold on
retta=b_hat_omega_ls(1)+x*b_hat_omega_ls(2)
plot(x,retta) 
title('Minimi quadrati ponderati')
xlabel('Temperatura')
ylabel('Ozono')
