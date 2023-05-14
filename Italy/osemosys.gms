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
* 6. Spare time
*
* declarations for sets, parameters, variables
$eolcom #
$offlisting
$if not set scen $setglobal scen base
$include osemosys_dec.gms
* specify Model data
$include italy_data.gms
$include water_data2.gms
Cap0(r) = 175;
LimCap(r) = 0.6;
*TotalAnnualMaxCapacity(r,'RIVER',y) = 100;
* define model equations
$offlisting
$include osemosys_equ.gms
*$include Water_equations.gms
option threads=0;

****************************
******** SCENARIOS *********
****************************

$setglobal string_atom "N"
$ifthen.scen set noatom 
    TotalAnnualMaxCapacity(r,'NUG3PH3',y) = 0;
    TotalAnnualMaxCapacity(r,'NUG3PH3S',y) = 0;
    TotalAnnualMaxCapacity(r,'UR00I00',y) = 0;
$setglobal string_atom "B"
$endif.scen

$setglobal string_demand "_"
$ifthen.scen set WaterDemand
    $$ifthen.cond %WaterDemand%==126
        $$include "WaterDemandsRefined/WaterDemandLow26.gms";
        $$setglobal string_demand "L26"
    $$endif.cond
    
    $$ifthen.cond %WaterDemand%==145
        $$include "WaterDemandsRefined/WaterDemandLow45.gms";
        $$setglobal string_demand "L45"
    $$endif.cond
    
    $$ifthen.cond %WaterDemand%==185
        $$include "WaterDemandsRefined/WaterDemandLow85.gms";
        $$setglobal string_demand "L85"
    $$endif.cond
        
    $$ifthen.cond %WaterDemand%==1026
        $$include "WaterDemandsRefined/WaterDemandMedium26.gms";
        $$setglobal string_demand "M26"
    $$endif.cond
    
    $$ifthen.cond %WaterDemand%==1045
        $$include "WaterDemandsRefined/WaterDemandMedium45.gms";
        $$setglobal string_demand "M45"
    $$endif.cond
    
    $$ifthen.cond %WaterDemand%==1085
        $$include "WaterDemandsRefined/WaterDemandMedium85.gms";
        $$setglobal string_demand "M85"
    $$endif.cond
        
    $$ifthen.cond %WaterDemand%==10026
        $$include "WaterDemandsRefined/WaterDemandHigh26.gms";
        $$setglobal string_demand "H26"
    $$endif.cond
    
    $$ifthen.cond %WaterDemand%==10045
        $$include "WaterDemandsRefined/WaterDemandHigh45.gms";
        $$setglobal string_demand "H45"
    $$endif.cond
    
    $$ifthen.cond %WaterDemand%==10085
        $$include "WaterDemandsRefined/WaterDemandHigh85.gms";
        $$setglobal string_demand "H85"
    $$endif.cond
$endif.scen

*$setglobal string_demand "_"
*$ifthen.scen set WaterDemand
*    $$ifthen.cond %WaterDemand%==0
*        $$include "WaterDemands/WaterDemandLow.gms";
*        $$setglobal string_demand "L"
*    $$endif.cond
*        
*    $$ifthen.cond %WaterDemand%==10
*        $$include "WaterDemands/WaterDemandMedium.gms";
*        $$setglobal string_demand "M"
*    $$endif.cond
*        
*    $$ifthen.cond %WaterDemand%==100
*        $$include "WaterDemands/WaterDemandHigh.gms";
*        $$setglobal string_demand "H"
*    $$endif.cond
*$endif.scen

*$setglobal string_rcp "_"
*$ifthen.scen set RCP
*    $$ifthen.cond %RCP%==26
*        $$include "RCP/Rcp_26.gms";
*        $$setglobal string_rcp "26"
*    $$endif.cond
*          
*    $$ifthen.cond %RCP%==45
*        $$include "RCP/Rcp_45.gms";
*        $$setglobal string_rcp "45"
*    $$endif.cond
*            
*    $$ifthen.cond %RCP%==85
*        $$include "RCP/Rcp_85.gms";
*        $$setglobal string_rcp "85"
*    $$endif.cond
*$endif.scen

*$setglobal scen "%string_atom%%string_demand%%string_rcp%"
$setglobal scen "%string_atom%%string_demand%"
        
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































