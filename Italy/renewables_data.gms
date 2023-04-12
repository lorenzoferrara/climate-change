set t_res(TECHNOLOGY) /SPP,WPP,E31/; 
set f_res(FUEL) /SOL,WND,HYD/; 

# Characterize SOLAR technology
OperationalLife(r,'SPP') = 15;
CapacityFactor(r,'SPP','ID',y) = 0.4;
CapacityFactor(r,'SPP','IN',y) = 0;
CapacityFactor(r,'SPP','SD',y) = 0.8;
CapacityFactor(r,'SPP','SN',y) = 0;
CapacityFactor(r,'SPP','WD',y) = 0.1;
CapacityFactor(r,'SPP','WN',y) = 0;

InputActivityRatio(r,'SPP','SOL',m,y) = 1; #IEA convention
OutputActivityRatio(r,'SPP','ELC',m,y) = 1; 
OutputActivityRatio(r,'SUN','SOL',m,y) = 1; 

CapitalCost(r,'SPP',y) = 1000;
CapitalCost(r,'SUN',y) = 0; #the sun is free
VariableCost(r,'SPP',m,y) = 1e-5;
FixedCost(r,'SPP',y) = 5;


# Characterize WIND technology
OperationalLife(r,'WPP') = 15;

CapacityFactor(r,'WPP','ID',y) = 0.2;
CapacityFactor(r,'WPP','IN',y) = 0.3;
CapacityFactor(r,'WPP','SD',y) = 0.1;
CapacityFactor(r,'WPP','SN',y) = 0.15;
CapacityFactor(r,'WPP','WD',y) = 0.3;
CapacityFactor(r,'WPP','WN',y) = 0.4;

InputActivityRatio(r,'WPP','WND',m,y) = 1; #IEA convention
OutputActivityRatio(r,'WPP','ELC',m,y) = 1; 
OutputActivityRatio(r,'WIN','WND',m,y) = 1; 

CapitalCost(r,'WPP',y) = 1;
CapitalCost(r,'WIN',y) = 1200;
VariableCost(r,'WPP',m,y) = 1e-5;
FixedCost(r,'WPP',y) = 7;

#ReserveMarginTagTechnology(r,t,y)$res(t) = 1;
RETagTechnology(r,t,y)$t_res(t) = 1;
RETagFuel(r,f,y)$f_res(f) = 1;
