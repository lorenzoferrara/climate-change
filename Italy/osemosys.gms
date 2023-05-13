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

* define model equations
$offlisting
$include osemosys_equ.gms
$include Water_equations.gms
option threads=0;

*
* Scnearios flags
*
$ifthen.scen set ren_target
equation my_RE4_EnergyConstraint(REGION,YEAR);
my_RE4_EnergyConstraint(r,y)..
    %ren_target%/100*(sum(f, AccumulatedAnnualDemand(r,f,y) + SpecifiedAnnualDemand(r,f,y))) =l= TotalREProductionAnnual(r,y);
$if not set scen $setglobal scen "rentarget%ren_target%"
$endif.scen

$ifthen.scen set noco2cap 
    AnnualEmissionLimit(r,'CO2',y)=999999;
$if not set scen $setglobal scen "brumbrum"
$endif.scen

$ifthen.scen set thirsty
    TotalAnnualMaxCapacity(r,'RIVER',y) = %thirsty%;
$if not set scen $setglobal scen "thirsty_%thirsty%"
$endif.scen

$ifthen.scen set noatom 
    TotalAnnualMaxCapacity(r,'NUG3PH3',y) = 0;
    TotalAnnualMaxCapacity(r,'NUG3PH3S',y) = 0;
    TotalAnnualMaxCapacity(r,'UR00I00',y) = 0;
$if not set scen $setglobal scen "noatom"
$endif.scen

$ifthen.scen set WaterDemand
    $$ifthen.cond %WaterDemand%==0
        $$include "WaterDemands\WaterDemandLow.gms";
    $$endif.cond
        
    $$ifthen.cond %WaterDemand%==10
        $$include "WaterDemands\WaterDemandMedium.gms";
    $$endif.cond
        
    $$ifthen.cond %WaterDemand%==100
        $$include "WaterDemands\WaterDemandHigh.gms";
    $$endif.cond
    
    $$if not set scen $setglobal scen "WaterDemand_%WaterDemand%"
$endif.scen

$ifthen.scen set WaterLevel
    $$ifthen.cond %WaterLevel%==0
        $$include "RCP\Rcp_26.gms";
    $$endif.cond
          
    $$ifthen.cond %WaterLevel%==10
        $$include "RCP\Rcp_45.gms";
    $$endif.cond
            
    $$ifthen.cond %WaterLevel%==100
        $$include "RCP\Rcp_85.gms";
    $$endif.cond
        
    $$if not set scen $setglobal scen "WaterLevel_%WaterLevel%"
$endif.scen

*$ifthen.scen set droughtMatteo
*
*$include "Po_level_WeakDecrease.gms";
*        
*$if not set scen $setglobal scen "drought_Matteo_%drought_Matteo%"
*$endif.scen


* solve the model
model osemosys /all/;
option limrow=0, limcol=0, solprint=on;
option mip = copt;
option threads=0;
solve osemosys minimizing z using mip;
* create results in file SelResults.CSV
$include osemosys_res.gms
$include report.gms
execute_unload 'Results\results_%scen%.gdx';































