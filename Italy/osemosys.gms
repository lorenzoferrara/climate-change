*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
* OSEMOSYS 2017.11.08 update by Thorsten Burandt, Konstantin L�ffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
* OSEMOSYS+OSEMBE 2023 WaterGAMS
*
* Files required are:
* osemosys.gms (this file)
* osemosys_dec.gms
* italy_data.txt
* osemosys_equ.gms
*
* To run this GAMS version of OSeMOSYS on your PC:
* 1. YOU MUST HAVE GAMS VERSION 22.7 OR HIGHER INSTALLED.
* This is because OSeMOSYS has some parameter, variable and equation names
* that exceed 31 characters in length, and GAMS versions prior to 22.7 have
* a limit of 31 characters on the length of such names.
* 2. Ensure that your PATH contains the GAMS Home Folder.
* 3. Place all 4 of the above files in a convenient folder,
* open a Command Prompt window in this folder, and enter:
* gams osemosys.gms
* 4. You should find that you get an optimal value of 29446.861.
* 5. Some results are created in file SelResults.CSV that you can view in Excel.
*
* declarations for sets, parameters, variables
$eolcom #
$offlisting
$if not set scen $setglobal scen base
$include osemosys_dec.gms
* specify Model data
$include italy_data.gms
$include water_data2.gms
*$include renewables_data.gms
* define model equations
$offlisting
$include osemosys_equ.gms


*
* Complete scenarios
*
$ifthen.scen '%scen%'=='emission' 
AnnualEmissionLimit(r,'CO2',y)$(ord(y) ge 10) = %emicap%;
$setglobal scen "emicap%emicap%"
$endif.scen

$ifthen.scen '%scen%'=='nogeo'
TotalAnnualMaxCapacity(r,'GO00X00',y) = 3;
TotalAnnualMaxCapacity(r,'GOCVPH2',y) = 3;
$setglobal scen "nogeo"
$endif.scen

*
* Scnearios flags
*
$ifthen.scen set ren_target
equation my_RE4_EnergyConstraint(REGION,YEAR);
my_RE4_EnergyConstraint(r,y)..
    %ren_target%/100*(sum(f, AccumulatedAnnualDemand(r,f,y) + SpecifiedAnnualDemand(r,f,y))) =l= TotalREProductionAnnual(r,y);
$setglobal scen "rentarget%ren_target%"
$endif.scen

$ifthen.scen set ctax 
    EmissionsPenalty('ITALY','CO2','2015') = 7.724;
    EmissionsPenalty('ITALY','CO2','2016') = 5.25;
    EmissionsPenalty('ITALY','CO2','2017') = 6.354;
    EmissionsPenalty('ITALY','CO2','2018') = 18.109;
    EmissionsPenalty('ITALY','CO2','2019') = 25.8508;
    EmissionsPenalty('ITALY','CO2','2020') = 25.665;
    EmissionsPenalty('ITALY','CO2','2021') = 55.365;
    EmissionsPenalty('ITALY','CO2','2022') = 81.345;
    EmissionsPenalty('ITALY','CO2','2023') = 91.39;
    EmissionsPenalty('ITALY','CO2','2024') = 106.525;
    EmissionsPenalty('ITALY','CO2','2025') = 121.66;
    EmissionsPenalty('ITALY','CO2','2026') = 136.795;
    EmissionsPenalty('ITALY','CO2','2027') = 151.93;
    EmissionsPenalty('ITALY','CO2','2028') = 167.065;
    EmissionsPenalty('ITALY','CO2','2029') = 182.2;
    EmissionsPenalty('ITALY','CO2','2030') = 197.335;
    EmissionsPenalty('ITALY','CO2','2031') = 212.47;
    EmissionsPenalty('ITALY','CO2','2032') = 227.605;
    EmissionsPenalty('ITALY','CO2','2033') = 242.74;
    EmissionsPenalty('ITALY','CO2','2034') = 257.875;
    EmissionsPenalty('ITALY','CO2','2035') = 273.01;
    EmissionsPenalty('ITALY','CO2','2036') = 288.145;
    EmissionsPenalty('ITALY','CO2','2037') = 303.28;
    EmissionsPenalty('ITALY','CO2','2038') = 318.415;
    EmissionsPenalty('ITALY','CO2','2039') = 333.55;
    EmissionsPenalty('ITALY','CO2','2040') = 348.685;
    EmissionsPenalty('ITALY','CO2','2041') = 363.82;
    EmissionsPenalty('ITALY','CO2','2042') = 378.955;
    EmissionsPenalty('ITALY','CO2','2043') = 394.09;
    EmissionsPenalty('ITALY','CO2','2044') = 409.225;
    EmissionsPenalty('ITALY','CO2','2045') = 424.36;
    EmissionsPenalty('ITALY','CO2','2046') = 439.495;
    EmissionsPenalty('ITALY','CO2','2047') = 454.63;
    EmissionsPenalty('ITALY','CO2','2048') = 469.765;
    EmissionsPenalty('ITALY','CO2','2049') = 484.9;
    EmissionsPenalty('ITALY','CO2','2050') = 500;
    EmissionsPenalty('ITALY','CO2','2051') = 530;
    EmissionsPenalty('ITALY','CO2','2052') = 560;
    EmissionsPenalty('ITALY','CO2','2053') = 590;
    EmissionsPenalty('ITALY','CO2','2054') = 620;
    EmissionsPenalty('ITALY','CO2','2055') = 650;
    EmissionsPenalty('ITALY','CO2','2056') = 680;
    EmissionsPenalty('ITALY','CO2','2057') = 710;
    EmissionsPenalty('ITALY','CO2','2058') = 740;
    EmissionsPenalty('ITALY','CO2','2059') = 770;
    EmissionsPenalty('ITALY','CO2','2060') = 800;
$setglobal scen "ctax"
$endif.scen

$ifthen.scen set nocoal 
    TotalAnnualMaxCapacity(r,'COCHPH3',y) = .5;
    TotalAnnualMaxCapacity(r,'COCSPN2',y) = .5;
    TotalAnnualMaxCapacity(r,'COSTPH1',y) = .5;
    TotalAnnualMaxCapacity(r,'COSTPH3',y) = .5;
    TotalAnnualMaxCapacity(r,'CO00I00',y) = .5;
    TotalAnnualMaxCapacity(r,'CO00X00',y) = .5;
$setglobal scen "nocoal"
$endif.scen

$ifthen.scen set nogas
    TotalAnnualMaxCapacity(r,'NG00I00',y) = .5;
    TotalAnnualMaxCapacity(r,'NG00X00',y) = .5;
    TotalAnnualMaxCapacity(r,'NGCCPH2',y) = .5;
    TotalAnnualMaxCapacity(r,'NGCHPH3',y) = .5;
    TotalAnnualMaxCapacity(r,'NGCHPN3',y) = .5;
    TotalAnnualMaxCapacity(r,'NGCSPN2',y) = .5;
    TotalAnnualMaxCapacity(r,'NGFCFH1',y) = .5;
    TotalAnnualMaxCapacity(r,'NGGCPH2',y) = .5;
    TotalAnnualMaxCapacity(r,'NGGCPN2',y) = .5;
    TotalAnnualMaxCapacity(r,'NGHPFH1',y) = .5;
$setglobal scen "nogas"
$endif.scen

$ifthen.scen set noatom 
    TotalAnnualMaxCapacity(r,'NUG3PH3',y) = 0;
    TotalAnnualMaxCapacity(r,'NUG3PH3S',y) = 0;
    TotalAnnualMaxCapacity(r,'UR00I00',y) = 0;
$setglobal scen "noatom"
$endif.scen

$ifthen.scen set cost_res 
CapitalCost(r,t,y)$t_res(t) = %cost_res%/100 * CapitalCost(r,t,y);
$setglobal scen "lowcost"
$endif.scen

$ifthen.scen set brumbrum 
    AnnualEmissionLimit(r,'CO2',y)=999999;
$setglobal scen "brumbrum"
$endif.scen


* solve the model
model osemosys /all/;
option limrow=0, limcol=0, solprint=on;
option mip = copt;
solve osemosys minimizing z using mip;
* create results in file SelResults.CSV
$include osemosys_res.gms
$include report.gms
execute_unload 'results_%scen%.gdx';


