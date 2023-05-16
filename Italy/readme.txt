*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
* OSEMOSYS 2017.11.08 update by Thorsten Burandt, Konstantin Liffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
* OSEMOSYS+OSEMBE 2023 WaterGAMS
*
* Files required are:
* osemosys.gms (this file)
* osemosys_dec.gms
* italy_data.gms
* water_data.gms
* 
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

