parameter Precipitations(REGION,YEAR);
*Km3
parameter EvaTrasp (REGION,YEAR);
*evapotranspiration from Turks empirical formula Km3
parameter Temp (REGION,YEAR);
*temperature of the set region °C
parameter Cap0(REGION);
*initial value of available capacity y0
parameter elle(REGION,YEAR);
*capacity of the atmosphere to evaporate water
positive variable CAP(REGION,YEAR);
*Km3/year

Precipitations(r,y) = 99;
Cap0(r) = 150;

Temp(r,y) = 20;
elle(r,y)= 300 + 0.25*Temp(r,y)+0.05*Temp(r,y)**2;
EvaTrasp(r,y) = Precipitations(r,y);
EvaTrasp(r,y)$(Precipitations(r,y)**2/elle(r,y)**2 gt 0.1) = Precipitations(r,y)/sqrt(0.9 + Precipitations(r,y)**2/elle(r,y)**2);

CAP.fx(r,y)$(ord(y) eq 1) = Cap0(r) + Precipitations(r,y)$(ord(y) eq 1) - EvaTrasp(r,y)$(ord(y) eq 1);

equation CapacityEQ(REGION,YEAR);
CapacityEQ(r,y+1).. CAP(r,y+1) =e= CAP(r,y) - PRODUCTIONBYTECHNOLOGYANNUAL(r,'RIVER', 'HY',y) + Precipitations(r,y+1) - EvaTrasp(r,y+1);

equation RIVERCAP(REGION, YEAR);
RIVERCAP(r,y).. TOTALCAPACITYANNUAL(r,'RIVER',y) =l= CAP(r,y);