

%GRAFICI

tab = readtable ("dataset.xlsx");
tab = rmmissing(tab);


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