*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
* OSEMOSYS 2017.11.08 update by Thorsten Burandt, Konstantin L�ffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
* OSEMOSYS+OSEMBE 2023 WaterGAMS
*
* Files required are:
* osemosys.gms (this file)
* osemosys_dec.gms
* italy_data.gms
* water_data.gms
* osemosys_equ.gms
*
* To run this GAMS version of OSeMOSYS on your PC:
* 1. YOU MUST HAVE GAMS VERSION 22.7 OR HIGHER INSTALLED.
* This is because OSeMOSYS has some parameter, variable and equation names
* that exceed 31 characters in length, and GAMS versions prior to 22.7 have
* a limit of 31 characters on the length of such names.
* 2. Ensure that your PATH contains the GAMS Home Folder.
* 3. Place all 5 of the above files in a convenient folder,
* open a Command Prompt window in this folder, and enter:
* gams osemosys.gms
* 5. Some results are created in file SelResults.CSV that you can view in Excel.
* 6. To run the scenarios set 'noatom = 1 ' to exclude nuclear power plants, or 0 to include it;
* for the water parameter 1, 10, 100  represent the demand level (low, Medium, High);
* for water availability 26, 45, 85 represent the RCP scenarios;
* concatenate the last two number in 'WaterDemand' to create a scenario ( eg: 126 Low demand + high availability).
* 7. Default settings are with nuclear energy, no water demand, constant precipitations and temperature.
* 8. Spare time.
*
* declarations for sets, parameters, variables
$eolcom #
$offlisting
$if not set scen $setglobal scen base
$include osemosys_dec.gms
* specify Model data
$include italy_data.gms
$include water_data.gms

* define model equations
$offlisting
$include osemosys_equ.gms

****************************
******** SCENARIOS *********
****************************

$$setglobal string_atom "N"
$ifthen.scen set noatom
    $$ifthen.cond %noatom%==0
        $$setglobal string_atom "N"
    $$endif.cond
    
    $$ifthen.cond %noatom%==1
        TotalAnnualMaxCapacity(r,'NUG3PH3',y) = 0;
        TotalAnnualMaxCapacity(r,'NUG3PH3S',y) = 0;
        TotalAnnualMaxCapacity(r,'UR00I00',y) = 0;
        $$setglobal string_atom "B"
    $$endif.cond
    $$setglobal scen "%string_atom%_"
$endif.scen

$ifthen.scen set WaterDemand
    $$ifthen.cond %WaterDemand%==126
        $$include "WaterScenarios/WaterDemandLow26.gms";
        $$setglobal string_demand "L26"
    $$endif.cond
    
    $$ifthen.cond %WaterDemand%==145
        $$include "WaterScenarios/WaterDemandLow45.gms";
        $$setglobal string_demand "L45"
    $$endif.cond
    
    $$ifthen.cond %WaterDemand%==185
        $$include "WaterScenarios/WaterDemandLow85.gms";
        $$setglobal string_demand "L85"
    $$endif.cond
        
    $$ifthen.cond %WaterDemand%==1026
        $$include "WaterScenarios/WaterDemandMedium26.gms";
        $$setglobal string_demand "M26"
    $$endif.cond
    
    $$ifthen.cond %WaterDemand%==1045
        $$include "WaterScenarios/WaterDemandMedium45.gms";
        $$setglobal string_demand "M45"
    $$endif.cond
    
    $$ifthen.cond %WaterDemand%==1085
        $$include "WaterScenarios/WaterDemandMedium85.gms";
        $$setglobal string_demand "M85"
    $$endif.cond
        
    $$ifthen.cond %WaterDemand%==10026
        $$include "WaterScenarios/WaterDemandHigh26.gms";
        $$setglobal string_demand "H26"
    $$endif.cond
    
    $$ifthen.cond %WaterDemand%==10045
        $$include "WaterScenarios/WaterDemandHigh45.gms";
        $$setglobal string_demand "H45"
    $$endif.cond
    
    $$ifthen.cond %WaterDemand%==10085
        $$include "WaterScenarios/WaterDemandHigh85.gms";
        $$setglobal string_demand "H85"
    $$endif.cond
    $$setglobal scen "%string_atom%%string_demand%"
$endif.scen


        
* solve the model
model osemosys /all/;
option limrow=0, limcol=0, solprint=on;
option mip = copt;
option threads=0;
solve osemosys minimizing z using mip;
* create results in file SelResults.CSV
$include osemosys_res.gms
*$include report.gms
execute_unload 'Results\results_%scen%.gdx';































