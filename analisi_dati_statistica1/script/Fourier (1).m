%% Spline con funzioni di base di Fourier sulla temperatura

% Vettore di dati continuo nel tempo (senza Nan)
tab = readtable ("temperature.xlsx");
Temperature=tab.Temperatura;
Temperature = rmmissing(Temperature);   % eliminazione Nan
Temperature = Temperature(1 : 240);     % seleziono un periodo di 10 giorni
Temperature = Temperature + 273.15;     % trasformo da C° in Kelvin

% Plot della temperatura
figure('Name','Temperatura nel tempo')
plot(Temperature)                       % si nota l'andamento periodico della temperatura

% parametri del vettore temperatura
n = length(Temperature);                % numero di osservazioni
t = 1:n;                                % vettore del tempo
T = length(Temperature)/10;             % periodo pari ad un giorno
f = 1/T;                                % frequenza = 1 / periodo
w = 2*pi/T;                             % pulsazione = 2 * pi / periodo
range_value = [min(t), max(t)];         % vettore di inizio e fine misurazione

% determinazione n_basis tramite General Cross-Validation (GCV)
n_max_basis = 10;
GCV = zeros(n_max_basis,1);
for order = 1 : n_max_basis
    
    % creazione basi di Fourier
    m = order - 1;                      % numero di basi senza la costante
    n_basis_temp = 2*m + 1;             % numero di basi di Fourier
    basis = create_fourier_basis(range_value,n_basis_temp,T);
    
    % valutazione delle basi nel tempo
    phi = full(eval_basis(t,basis));
    
    % parametri regressione lineare
    Cmap = (phi' * phi) \ (phi');       % Cmap
    c_hat = Cmap * Temperature;         % vettore delle stime dei coefficienti
    S = phi * Cmap;                     % matrice di smoothing
    y_hat = phi * c_hat;                % osservazioni stimate
    
    % calcolo dei residui e SSE
    res = Temperature - y_hat;          % vettore dei residui
    SSE = res' * res;                   %v SSE
    
    % calcolo della statistica GCV
    GCV(order) = (1/n) * SSE / ((1 - (trace(S)/n))^2);
end
clear order m;

% il numero di basi ottimale minimizza la statistica GCV
order = find(GCV == min(GCV));
m = order - 1;
n_basis = 2*m + 1;

% creazione e plot basi
basis = create_fourier_basis(range_value,n_basis,T);
figure('Name','Funzioni di base')
plot(basis)

% valutazione delle funzioni nel tempo e plot
basis_mat = full(eval_basis(t,basis));              % matrice phi
figure('Name','Funzioni di base nel dominio delle osservazioni')
plot(t,basis_mat)

% parametri regressione lineare
Cmap  = (basis_mat' * basis_mat) \ (basis_mat');    % Cmap
c_hat = Cmap*Temperature;                           % vettore dei coefficienti delle funzioni basi
S = basis_mat * Cmap;                               % matrice di smoothing
y_hat = basis_mat*c_hat;                            % osservazioni stimate

% plot osservazioni e osservazioni stimate
plot1 = figure('Name','Funzione stimata e misure reali')
plot(t,Temperature,'black.-');
hold on
plot(t,y_hat,'red')
xlabel('osservazioni')
ylabel('valori stimati')
legend('valori rumorosi', 'funzione stimata dai valori rumorosi')
