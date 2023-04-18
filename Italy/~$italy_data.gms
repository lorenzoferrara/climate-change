$offlisting
* ITALY_DATA.GMS
* Change of UTOPIA_DATA.GMS - specify Utopia Model data in format required by GAMS
*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble.Noble-Soft Systems - August 2012
* OSEMOSYS 2016.08.01 update by Thorsten Burandt, Konstantin L�ffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
* OSEMOSYS 2020.04.13 reformatting by Giacomo Marangoni
* OSEMOSYS 2020.04.15 change yearsplit by Giacomo Marangoni
* OSEMOSYS 2023 Italy by WaterGAMS

$offlisting

* OSEMOSYS 2016.08.01
* Open Source energy Modeling SYStem
*
*#      Based on UTOPIA version 5: BASE - Utopia Base Model
*#      Energy and demands in PJ/a
*#      Power plants in GW
*#      Investment and Fixed O&M Costs: Power plant: Million $ / GW (//$/kW)
*#      Investment  and Fixed O&M Costs Costs: Other plant costs: Million $/PJ/a
*#      Variable O&M (& Import) Costs: Million $ / PJ (//$/GJ)
*#
*#****************************************


*------------------------------------------------------------------------	
* Sets       
*------------------------------------------------------------------------


$offlisting
set     YEAR    / 2015*2060 /;
set     TECHNOLOGY      /
        BF00I00 'biofuel import'
        BF00X00 'biofuel generation'
        BFHPFH1 'biofuel ICE Heat and Power unit, final use, holding'
        BM00I00 'biomass import'
        BM00X00 'biomass extraction'
        BMCCPH1 'biomass combined cycle size1'
        BMCHPH3 'biomass combined cycle size3'
        BMCSPN2 'biomass carbon capture'
        BMSTPH3 'biomass steam cycle'
        CO00I00 'coal import'
        CO00X00 'coal extraction'
        COCHPH3 'coal combined heat and power'
        COCSPN2 'coal carbon capture'
        COSTPH1 'coal steam cycle size1'
        COSTPH3 'coal steam cycle size3'
        EL00TD0 'electricity domestic transmission and distribution'
        GO00X00 'geothermal generation'
        GOCVPH2 'geothermal conventional plant'
        HF00I00 'heavy fuel oil import'
        HFCCPH2 'heavy fuel oil combined cycle'
        HFCHPH3 'heavy fuel oil combined heat power'
        HFGCPH3 'heavy fuel oil gas cycle, old'
        HFGCPN3 'heavy fuel oil gas cycle, new'
        HFHPFH1 'heavy fuel oil ICE Heat and Power unit, final use, holding'
        HFHPPH2 'heavy fuel oil ICE Heat and Power unit, production, holding'
        HFSTPH2 'heavy fuel oil steam cycle, size2'
        HFSTPH3 'heavy fuel oil steam cycle, size3'
        HYDMPH0 'hydroelectric Run of river'
        HYDMPH1 'Hydro Dam <10MW'
        HYDMPH2 'Hydro Dam 10-100MW'
        HYDMPH3 'Hydro Dam >100MW'
        HYDSPH2 'hHydro Pumped Storage 10-100MW'
        HYDSPH3 'Hydro Pumped Storage >100MW'
        NG00I00 'natural gas import'
        NG00X00 'natural gas extraction'
        NGCCPH2 'natural gas combined cycle'
        NGCHPH3 'natural gas combined heat power, old'
        NGCHPN3 'natural gas combined heat power, new'
        NGCSPN2 'natural gas carbon capture and storage'
        NGFCFH1 'natural gas fuel cell, final use' 
        NGGCPH2 'natural gas gas cycle, old'
        NGGCPN2 'natural gas gas cycle, new'
        NGHPFH1 'natural gas ICE Heat and Power unit, final use, holding'
        NGHPPH2 'heavy fuel oil ICE Heat and Power unity, production, holding'
        NGSTPH2 'natural gas steam cycle'
        NUG3PH3 'Nuclear Generation 3'
        OCWVPH1 'ocean wave power production'
        OI00I00 'oil import'
        OI00X00 'oil extraction'
        OIRFPH0 'oil refinery'
        SODIFH1 'Solar Distributed PV <=0.1MW, final consumption'
        SOUTPH2 'Solar Utility PV >0.1MW, production'
        UR00I00 'Uranium Import'
        WIOFPN2 'wind offshore Near-term'
        WIOFPN3 'wind offshore Long-term'
        WIONPH3 'wind onshore current'
        WIONPN3 'wind onshore near-term'
        WS00X00 'waste generation'
        WSCHPH2 'waste combined heat power'
        WSSTPH1 'waste steam cycle' 
/;

set     TIMESLICE       /
        S01B1 'Gen-feb, 1'
        S01B2 'Gen-feb, 2'
        S01B3 'Gen-feb, 3'
        S02B1 'Mar-Apr, 1'
        S02B2 'Mar-Apr, 2'
        S02B3 'Mar-Apr, 3'
        S03B1 'Apr-Sep, 1'
        S03B2 'Apr-Sep, 2'
        S03B3 'Apr-Sep, 3'
        S04B1 'Oct-Nov, 1'
        S04B2 'Oct-Nov, 2'
        S04B3 'Oct-Nov, 3'
        S05B1 'Nov-Dec, 1'
        S05B2 'Nov-Dec, 2'
        S05B3 'Nov-Dec, 3'
/;

set     FUEL    / BF BM CO E1 E2 GO HF NG OI UR WS /;

set     EMISSION  /CO2 HO HY WI  /;   
        *Old emissions / CO2, NOX /;
set     MODE_OF_OPERATION       / 1, 2 /;
set     REGION  / ITALY /;
set     SEASON / 1, 2, 3, 4, 5 /;
set     DAYTYPE / 1 /; *non so, penso 5 tipi diversi
set     DAILYTIMEBRACKET / 1, 2, 3 /;
set     STORAGE / DAM /;

# characterize technologies 
*DUBBIO
*elettricità
 EL00TD0 
 ELMTPH1 *in plants cause capacity to activity 31536
 ELSIPH1 *in plants cause capacity to activity 31536
*heavy fuel tipo motori? *in plants cause capacity to activity 31536
 HFHPFH1
 HFHPPH2
*storage (anche in plants)
 HYDSPH2
 HYDSPH3
*NG fuel cells??
 NGFCFH1
 NGFCFH2
*NG tipo motori?
 NGHPFH1
 NGHPPH2
*solar distributed qui conta come final use... in che senso?
 SODIFH1 
 

set power_plants(TECHNOLOGY) /BFHPFH1, BMCCPH1, BMCHPH3, BMSTPH3, COCHPH3, COSTPH1, COSTPH3, ELMTPH1, ELSIPH1, GOCVPH2, HFCCPH2, HFCHPH3, HFGCPH3, HFGCPN3, HFSTPH2, HFSTPH3, HFHPFH1, HFHPPH2, 
                                HYDMPH0, HYDMPH1, HYDMPH2, HYDMPH3, HYDSPH2, HYDSPH3, NGCCPH2, NGCCPH3, NGCHPN3, NGGCPN2, NGSTPH2, OCWVPH1, SOUTPH2, SODIFH1, WIOFPN2, WIOFPN3, WIONPH3, WIONPN3, WSCHPH2, WSSTPH1/;
set storage_plants(TECHNOLOGY) / HYDSPH2, HYDSPH3/;
set fuel_transformation(TECHNOLOGY) / OIRFPH0/;
set appliances(TECHNOLOGY) / /;
set unmet_demand(TECHNOLOGY) / /;
set transport(TECHNOLOGY) / /;
set primary_imports(TECHNOLOGY) /BM00I00, CO00I00,  OI00I00, NG00I00/;
set secondary_imports(TECHNOLOGY) /BF00I00, HF00I00 /;

set fuel_production(TECHNOLOGY) /BF00X00, BM00X00, CO00X00, GO00X00, NG00X00, WS00X00, OI00X00,  /;
        *su WS00X00 non sono sicurissima perchè la produzione di waste non è proprio ricercata
set fuel_production_fict(TECHNOLOGY) /RIV, SUN, WIN/;
set secondary_production(TECHNOLOGY) /E01, E21, E31, E51, E70, SPP, WPP, SRE/;


#Characterize fuels 

*DUBBIO HF hevy fuel oil come conta??? Anche il gas ha final?
set primary_fuel(FUEL) /BF BM CO GO HF NG OI UR WS/;
set secondary_carrier(FUEL) / E1 E2 /;
set final_demand(FUEL) /BF HF NG /; 
*non sono sicura


*------------------------------------------------------------------------	
* Parameters - Global
*------------------------------------------------------------------------

parameter YearSplit(l,y) /
  S01B1.(2015*2060)  0.043835616
  S01B2.(2015*2060)  0.109589041
  S01B3.(2015*2060)  0.021917808
  S02B1.(2015*2060)  0.025342466
  S02B2.(2015*2060)  0.067579909
  S02B3.(2015*2060)  0.008447489
  S03B1.(2015*2060)  0.104452055
  S03B2.(2015*2060)  0.334246575
  S03B3.(2015*2060)  0.062671233
  S04B1.(2015*2060)  0.028082192
  S04B2.(2015*2060)  0.070205479
  S04B3.(2015*2060)  0.014041096
  S05B1.(2015*2060)  0.02739726
  S05B2.(2015*2060)  0.068493151
  S05B3.(2015*2060)  0.01369863
/;

DiscountRate(r) = 0.05;

*DUBBIO Che cos'è??? e tutti i successivi???
DaySplit(y,lh) = 12/(24*365);

parameter Conversionls(l,ls) /
ID.2 1
IN.2 1
SD.3 1
SN.3 1
WD.1 1
WN.1 1
/;

parameter Conversionld(l,ld) /
ID.1 1
IN.1 1
SD.1 1
SN.1 1
WD.1 1
WN.1 1
/;

parameter Conversionlh(l,lh) /
ID.1 1
IN.2 1
SD.1 1 
SN.2 1
WD.1 1
WN.2 1
/;

DaysInDayType(y,ls,ld) = 7;
        

TradeRoute(r,rr,f,y) = 0;

DepreciationMethod(r) = 1;

*------------------------------------------------------------------------	
* Parameters - Demands       
*------------------------------------------------------------------------
*prosegue il DUBBIO
parameter SpecifiedAnnualDemand(r,f,y) /
  UTOPIA.RH.1990  25.2
  UTOPIA.RL.2010  12.6
  
  ITALY.E2.2015
/;

parameter SpecifiedDemandProfile(r,f,l,y) /
  UTOPIA.RH.ID.(1990*2010)  .12
  UTOPIA.RH.IN.(1990*2010)  .06
  UTOPIA.RH.SD.(1990*2010)  0
  UTOPIA.RH.SN.(1990*2010)  0
  UTOPIA.RH.WD.(1990*2010)  .5467
  UTOPIA.RH.WN.(1990*2010)  .2733
  UTOPIA.RL.ID.(1990*2010)  .15
  UTOPIA.RL.IN.(1990*2010)  .05
  UTOPIA.RL.SD.(1990*2010)  .15
  UTOPIA.RL.SN.(1990*2010)  .05
  UTOPIA.RL.WD.(1990*2010)  .5
  UTOPIA.RL.WN.(1990*2010)  .1
/;

parameter AccumulatedAnnualDemand(r,f,y) /
  UTOPIA.TX.1990  5.2
  UTOPIA.TX.1991  5.46
  UTOPIA.TX.1992  5.72
  UTOPIA.TX.1993  5.98
  UTOPIA.TX.1994  6.24
  UTOPIA.TX.1995  6.5
  UTOPIA.TX.1996  6.76
  UTOPIA.TX.1997  7.02
  UTOPIA.TX.1998  7.28
  UTOPIA.TX.1999  7.54
  UTOPIA.TX.2000  7.8
  UTOPIA.TX.2001  8.189
  UTOPIA.TX.2002  8.578
  UTOPIA.TX.2003  8.967
  UTOPIA.TX.2004  9.356
  UTOPIA.TX.2005  9.745
  UTOPIA.TX.2006  10.134
  UTOPIA.TX.2007  10.523
  UTOPIA.TX.2008  10.912
  UTOPIA.TX.2009  11.301
  UTOPIA.TX.2010  11.69
/;
*fine DUBBIO

*------------------------------------------------------------------------	
* Parameters - Performance       
*------------------------------------------------------------------------

*Quelle che avevano 31536 in OSeMBE le ho messe in power_plants
CapacityToActivityUnit(r,t)$power_plants(t) = 31.536;

CapacityToActivityUnit(r,t)$(CapacityToActivityUnit(r,t) = 0) = 1;
*Solar capacity 
CapacityFactor(r,'SODIFH1','S01B1',y) = 0.0000563558;
CapacityFactor(r,'SODIFH1','S01B2',y) = 0.173036406;
CapacityFactor(r,'SODIFH1','S02B1',y) = 0.004242173;
CapacityFactor(r,'SODIFH1','S02B2',y) = 0.250816839;
CapacityFactor(r,'SODIFH1','S03B1',y) = 0.00316014;
CapacityFactor(r,'SODIFH1','S03B2',y) = 0.291570421
CapacityFactor(r,'SODIFH1','S04B1',y) = 0.0000690295;
CapacityFactor(r,'SODIFH1','S04B2',y) = 0.176523404;
CapacityFactor(r,'SODIFH1','S05B2',y) = 0.127762552;

CapacityFactor(r,'SOUTPH2','S01B1',y) = 0.0000563558;
CapacityFactor(r,'SOUTPH2','S01B2',y) = 0.173036406;
CapacityFactor(r,'SOUTPH2','S02B1',y) = 0.004242173;
CapacityFactor(r,'SOUTPH2','S02B2',y) = 0.250816839;
CapacityFactor(r,'SOUTPH2','S03B1',y) = 0.00316014;
CapacityFactor(r,'SOUTPH2','S03B2',y) = 0.291570421
CapacityFactor(r,'SOUTPH2','S04B1',y) = 0.0000690295;
CapacityFactor(r,'SOUTPH2','S04B2',y) = 0.176523404;
CapacityFactor(r,'SOUTPH2','S05B2',y) = 0.127762552;

*Wind capacity
CapacityFactor(r,'WIOFPN2','S01B1',y) = 0.271624523;
CapacityFactor(r,'WIOFPN2','S01B2',y) = 0.280495029;
CapacityFactor(r,'WIOFPN2','S01B3',y) = 0.272288194;
CapacityFactor(r,'WIOFPN2','S02B1',y) = 0.233572022;
CapacityFactor(r,'WIOFPN2','S02B2',y) = 0.253291944;
CapacityFactor(r,'WIOFPN2','S02B3',y) = 0.228561449;
CapacityFactor(r,'WIOFPN2','S03B1',y) = 0.141437599;
CapacityFactor(r,'WIOFPN2','S03B2',y) = 0.170367342;
CapacityFactor(r,'WIOFPN2','S03B3',y) = 0.14269156;
CapacityFactor(r,'WIOFPN2','S04B1',y) = 0.207350982;
CapacityFactor(r,'WIOFPN2','S04B2',y) = 0.216981129;
CapacityFactor(r,'WIOFPN2','S04B3',y) = 0.208548103;
CapacityFactor(r,'WIOFPN2','S05B1',y) = 0.277614919;
CapacityFactor(r,'WIOFPN2','S05B2',y) = 0.280326125;
CapacityFactor(r,'WIOFPN2','S05B3',y) = 0.277337245;

CapacityFactor(r,'WIOFPN3','S01B1',y) = 0.260441558;
CapacityFactor(r,'WIOFPN3','S01B2',y) = 0.235286505;
CapacityFactor(r,'WIOFPN3','S01B3',y) = 0.26148737;
CapacityFactor(r,'WIOFPN3','S02B1',y) = 0.259217142;
CapacityFactor(r,'WIOFPN3','S02B2',y) = 0.217824611;
CapacityFactor(r,'WIOFPN3','S02B3',y) = 0.263665428;
CapacityFactor(r,'WIOFPN3','S03B1',y) = 0.16549636;
CapacityFactor(r,'WIOFPN3','S03B2',y) = 0.124478964;
CapacityFactor(r,'WIOFPN3','S03B3',y) = 0.158662523;
CapacityFactor(r,'WIOFPN3','S04B1',y) = 0.227057103;
CapacityFactor(r,'WIOFPN3','S04B2',y) = 0.208764761;
CapacityFactor(r,'WIOFPN3','S04B3',y) = 0.22720271;
CapacityFactor(r,'WIOFPN3','S05B1',y) = 0.259406609;
CapacityFactor(r,'WIOFPN3','S05B2',y) = 0.242499556;
CapacityFactor(r,'WIOFPN3','S05B3',y) = 0.258099051;

CapacityFactor(r,'WIONPH3','S01B1',y) = 0.250054789;
CapacityFactor(r,'WIONPH3','S01B2',y) = 0.258935787;
CapacityFactor(r,'WIONPH3','S01B3',y) = 0.249928414;
CapacityFactor(r,'WIONPH3','S02B1',y) = 0.221012713;
CapacityFactor(r,'WIONPH3','S02B2',y) = 0.236890803;
CapacityFactor(r,'WIONPH3','S02B3',y) = 0.219970721;
CapacityFactor(r,'WIONPH3','S03B1',y) = 0.141445556;
CapacityFactor(r,'WIONPH3','S03B2',y) = 0.15676146;
CapacityFactor(r,'WIONPH3','S03B3',y) = 0.13642287;
CapacityFactor(r,'WIONPH3','S04B1',y) = 0.198595596;
CapacityFactor(r,'WIONPH3','S04B2',y) = 0.208439097;
CapacityFactor(r,'WIONPH3','S04B3',y) = 0.200085795;
CapacityFactor(r,'WIONPH3','S05B1',y) = 0.253027697;
CapacityFactor(r,'WIONPH3','S05B2',y) = 0.257144495;
CapacityFactor(r,'WIONPH3','S05B3',y) = 0.251741019;

CapacityFactor(r,'WIONPN3','S01B1',y) = 0.21623444;
CapacityFactor(r,'WIONPN3','S01B2',y) = 0.227427928;
CapacityFactor(r,'WIONPN3','S01B3',y) = 0.216360286;
CapacityFactor(r,'WIONPN3','S02B1',y) = 0.189594019;
CapacityFactor(r,'WIONPN3','S02B2',y) = 0.210939367;
CapacityFactor(r,'WIONPN3','S02B3',y) = 0.193675225;
CapacityFactor(r,'WIONPN3','S03B1',y) = 0.124110677;
CapacityFactor(r,'WIONPN3','S03B2',y) = 0.146488898;
CapacityFactor(r,'WIONPN3','S03B3',y) = 0.119650916;
CapacityFactor(r,'WIONPN3','S04B1',y) = 0.176302812;
CapacityFactor(r,'WIONPN3','S04B2',y) = 0.185701278;
CapacityFactor(r,'WIONPN3','S04B3',y) = 0.177835253;
CapacityFactor(r,'WIONPN3','S05B1',y) = 0.22164809;
CapacityFactor(r,'WIONPN3','S05B2',y) = 0.224300426;
CapacityFactor(r,'WIONPN3','S05B3',y) = 0.217316319;

CapacityFactor(r,t,l,y)$(CapacityFactor(r,t,l,y) = 0) = 1;

AvailabilityFactor(r,'BMCCPH1',y) = .7;
AvailabilityFactor(r,'BMSTPH3',y) = .7;
AvailabilityFactor(r,'COCHPH3',y) = 0.85;
AvailabilityFactor(r,'COSTPH1',y) = 0.8;
AvailabilityFactor(r,'COSTPH3',y) = .8;
AvailabilityFactor(r,'GOCVPH2',y) = .95;
AvailabilityFactor(r,'HFCCPH2',y) = .85;
AvailabilityFactor(r,'HFCHPH3',y) = .91;
AvailabilityFactor(r,'HFGCPH3',y) = .15;
AvailabilityFactor(r,'HFGCPN3',y) = .15;
AvailabilityFactor(r,'HFHPFH1',y) = .97;
AvailabilityFactor(r,'HFHPPH2',y) = .97;
AvailabilityFactor(r,'HFSTPH2',y) = .8;
AvailabilityFactor(r,'HFSTPH3',y) = .8;
AvailabilityFactor(r,'HYDMPH0',y) = 0.37;
AvailabilityFactor(r,'HYDMPH1',y) = 0.37;
AvailabilityFactor(r,'HYDMPH2',y) = 0.4;
AvailabilityFactor(r,'HYDMPH3',y) = 0.35;
AvailabilityFactor(r,'HYDSPH2',y) = 0.4;
AvailabilityFactor(r,'HYDSPH3',y) = 0.35;
AvailabilityFactor(r,'NGCCPH2',y) = 0.85;
AvailabilityFactor(r,'NGCHPH3',y) = .89;
AvailabilityFactor(r,'NGCHPN3',y) = .86;
AvailabilityFactor(r,'NGFCFH1',y) = .98;
AvailabilityFactor(r,'NGGCPH2',y) = .15;
AvailabilityFactor(r,'NGGCPN2',y) = .15;
AvailabilityFactor(r,'NGHPFH1',y) = .97;
AvailabilityFactor(r,'NGHPPH2',y) = .97;
AvailabilityFactor(r,'NGSTPH2',y) = .8;
AvailabilityFactor(r,'WSCHPH2',y) = .8;
AvailabilityFactor(r,'WSSTPH1',y) = .7;
AvailabilityFactor(r,'',y) = ;


AvailabilityFactor(r,t,y) /
 ITALY.BFHPFH1.2015 .6
 ITALY.BFHPFH1.2016 .61
 ITALY.BFHPFH1.2017 .62
 ITALY.BFHPFH1.2018 .63
 ITALY.BFHPFH1.2019 .64
 ITALY.BFHPFH1.2020 .65
 ITALY.BFHPFH1.2021 .653333333
 ITALY.BFHPFH1.2022 .656666667
 ITALY.BFHPFH1.2023 .66
 ITALY.BFHPFH1.2024 .663333333
 ITALY.BFHPFH1.2025 .666666667
 ITALY.BFHPFH1.2026 .67
 ITALY.BFHPFH1.2027 .673333333
 ITALY.BFHPFH1.2028 .676666667
 ITALY.BFHPFH1.2029 .68
 ITALY.BFHPFH1.2030 .683333333
 ITALY.BFHPFH1.2031 .686666667
 ITALY.BFHPFH1.2032 .69
 ITALY.BFHPFH1.2033 .693333333
 ITALY.BFHPFH1.2034 .696666667
 ITALY.BFHPFH1.2035 .7
 ITALY.BFHPFH1.2036 .701
 ITALY.BFHPFH1.2037 .702
 ITALY.BFHPFH1.2038 .703
 ITALY.BFHPFH1.2039 .704
 ITALY.BFHPFH1.2040 .705
 ITALY.BFHPFH1.2041 .706
 ITALY.BFHPFH1.2042 .707
 ITALY.BFHPFH1.2043 .708
 ITALY.BFHPFH1.2044 .709
 ITALY.BFHPFH1.2045 .71
 ITALY.BFHPFH1.2046 0.711
 ITALY.BFHPFH1.2047 0.712
 ITALY.BFHPFH1.2048 0.713
 ITALY.BFHPFH1.2049 0.714
 ITALY.BFHPFH1.2050 0.715
 ITALY.BFHPFH1.2051 0.716
 ITALY.BFHPFH1.2052 0.717
 ITALY.BFHPFH1.2053 0.718
 ITALY.BFHPFH1.2054 0.719
 ITALY.BFHPFH1.2055 0.72
 ITALY.BFHPFH1.2056 0.721
 ITALY.BFHPFH1.2057 0.722
 ITALY.BFHPFH1.2058 0.723
 ITALY.BFHPFH1.2059 0.724
 ITALY.BFHPFH1.2060 0.725

 ITALY.IBMCHPH3.2015 0.65
 ITALY.IBMCHPH3.2016 0.655
 ITALY.IBMCHPH3.2017 0.66
 ITALY.IBMCHPH3.2018 0.665
 ITALY.IBMCHPH3.2019 0.67
 ITALY.IBMCHPH3.2020 .675
 ITALY.IBMCHPH3.2021 .675 
 ITALY.IBMCHPH3.2022 .675
 ITALY.IBMCHPH3.2023 .675
 ITALY.IBMCHPH3.2024 .675
 ITALY.IBMCHPH3.2025 .675
 ITALY.IBMCHPH3.2026 .675
 ITALY.IBMCHPH3.2027 .675
 ITALY.IBMCHPH3.2028 .675
 ITALY.IBMCHPH3.2029 .675
 ITALY.IBMCHPH3.2030 .675
 











0.725
0.725
0.725
0.725
0.725
 ITALY.IBMCHPH3.2031 0.68
 ITALY.IBMCHPH3.2032 0.685
 ITALY.IBMCHPH3.2033 0.69
 ITALY.IBMCHPH3.2034 0.695
 ITALY.IBMCHPH3.2035 0.7
 ITALY.IBMCHPH3.2036 0.705
 ITALY.IBMCHPH3.2037 0.71
 ITALY.IBMCHPH3.2038 0.715
 ITALY.IBMCHPH3.2039 0.72
 ITALY.IBMCHPH3.2040 0.725
 ITALY.IBMCHPH3.2041 0.725
 ITALY.IBMCHPH3.2042 0.725
 ITALY.IBMCHPH3.2043 0.725
 ITALY.IBMCHPH3.2044 0.725
 ITALY.IBMCHPH3.2045 0.725
 ITALY.IBMCHPH3.2046 0.725
 ITALY.IBMCHPH3.2047 0.725
 ITALY.IBMCHPH3.2048 0.725
 ITALY.IBMCHPH3.2049 0.725
 ITALY.IBMCHPH3.2050 0.725
 ITALY.IBMCHPH3.2051 0.725
 ITALY.IBMCHPH3.2052 0.725
 ITALY.IBMCHPH3.2053 0.725
 ITALY.IBMCHPH3.2054 0.725
 ITALY.IBMCHPH3.2055 0.725
 ITALY.IBMCHPH3.2056 0.725
 ITALY.IBMCHPH3.2057 0.725
 ITALY.IBMCHPH3.2058 0.725
 ITALY.IBMCHPH3.2059 0.725
 ITALY.IBMCHPH3.2060 0.725

 ITALY.OCWVPH1.2015 .2
 ITALY.OCWVPH1.2016 .206
 ITALY.OCWVPH1.2017 .212
 ITALY.OCWVPH1.2018 .218
 ITALY.OCWVPH1.2019 .224
 ITALY.OCWVPH1.2020 .23
 ITALY.OCWVPH1.2021 .235
 ITALY.OCWVPH1.2022 .24
 ITALY.OCWVPH1.2023 .245
 ITALY.OCWVPH1.2024 .25
 ITALY.OCWVPH1.2025 .255
 ITALY.OCWVPH1.2026 .26
 ITALY.OCWVPH1.2027 .265
 ITALY.OCWVPH1.2028 .27
 ITALY.OCWVPH1.2029 .275
 ITALY.OCWVPH1.2030 .28
 ITALY.OCWVPH1.2031 .284
 ITALY.OCWVPH1.2032 .288
 ITALY.OCWVPH1.2033 .292
 ITALY.OCWVPH1.2034 .296
 ITALY.OCWVPH1.2035 .3
 ITALY.OCWVPH1.2036 .304
 ITALY.OCWVPH1.2037 .308 
 ITALY.OCWVPH1.2038 .312
 ITALY.OCWVPH1.2039 .316
 ITALY.OCWVPH1.2040 .32
 ITALY.OCWVPH1.2041 .324
 ITALY.OCWVPH1.2042 .328
 ITALY.OCWVPH1.2043 .332 
 ITALY.OCWVPH1.2044 .336
 ITALY.OCWVPH1.2045 .34
 ITALY.OCWVPH1.2046 .344
 ITALY.OCWVPH1.2047 .348 
 ITALY.OCWVPH1.2048 .352
 ITALY.OCWVPH1.2049 .356
 ITALY.OCWVPH1.2050 .36
 ITALY.OCWVPH1.2051 .363
 ITALY.OCWVPH1.2052 .366
 ITALY.OCWVPH1.2053 .369
 ITALY.OCWVPH1.2054 .372
 ITALY.OCWVPH1.2055 .375
 ITALY.OCWVPH1.2056 .378
 ITALY.OCWVPH1.2057 .381
 ITALY.OCWVPH1.2058 .384
 ITALY.OCWVPH1.2059 .387
 ITALY.OCWVPH1.2060 .39
/;

AvailabilityFactor(r,t,y)$(AvailabilityFactor(r,t,y) = 0) = 1;

*                                                       sistemato fino a qua
parameter OperationalLife(r,t) /
  UTOPIA.E01  40
  UTOPIA.E21  40
  UTOPIA.E31  100
  UTOPIA.E51  100
  UTOPIA.E70  40
  UTOPIA.RHE  30
  UTOPIA.RHO  30
  UTOPIA.RL1  10
  UTOPIA.SRE  50
  UTOPIA.TXD  15
  UTOPIA.TXE  15
  UTOPIA.TXG  15
/;
OperationalLife(r,t)$(OperationalLife(r,t) = 0) = 1;

parameter ResidualCapacity(r,t,y) /
  UTOPIA.E01.1990  .5
  UTOPIA.E01.1991  .5
  UTOPIA.E01.1992  .5
  UTOPIA.E01.1993  .4
  UTOPIA.E01.1994  .4
  UTOPIA.E01.1995  .4
  UTOPIA.E01.1996  .4
  UTOPIA.E01.1997  .4
  UTOPIA.E01.1998  .4
  UTOPIA.E01.1999  .3
  UTOPIA.E01.2000  .3
  UTOPIA.E01.2001  .3
  UTOPIA.E01.2002  .3
  UTOPIA.E01.2003  .3
  UTOPIA.E01.2004  .3
  UTOPIA.E01.2005  .2
  UTOPIA.E01.2006  .2
  UTOPIA.E01.2007  .2
  UTOPIA.E01.2008  .2
  UTOPIA.E01.2009  .2
  UTOPIA.E01.2010  .15
  UTOPIA.E21.(1990*2010)  0
  UTOPIA.E31.(1990*2010)  .1
  UTOPIA.E51.(1990*2010)  .5
  UTOPIA.E70.1990  .3
  UTOPIA.E70.1991  .3
  UTOPIA.E70.1992  .29
  UTOPIA.E70.1993  .29
  UTOPIA.E70.1994  .28
  UTOPIA.E70.1995  .28
  UTOPIA.E70.1996  .27
  UTOPIA.E70.1997  .27
  UTOPIA.E70.1998  .26
  UTOPIA.E70.1999  .26
  UTOPIA.E70.2000  .25
  UTOPIA.E70.2001  .25
  UTOPIA.E70.2002  .24
  UTOPIA.E70.2003  .24
  UTOPIA.E70.2004  .23
  UTOPIA.E70.2005  .23
  UTOPIA.E70.2006  .22
  UTOPIA.E70.2007  .22
  UTOPIA.E70.2008  .21
  UTOPIA.E70.2009  .21
  UTOPIA.E70.2010  .2
  UTOPIA.RHE.(1990*2010)  0
  UTOPIA.RHO.1990  25
  UTOPIA.RHO.1991  23.8
  UTOPIA.RHO.1992  22.5
  UTOPIA.RHO.1993  21.3
  UTOPIA.RHO.1994  20
  UTOPIA.RHO.1995  18.8
  UTOPIA.RHO.1996  17.5
  UTOPIA.RHO.1997  16.3
  UTOPIA.RHO.1998  15
  UTOPIA.RHO.1999  13.8
  UTOPIA.RHO.2000  12.5
  UTOPIA.RHO.2001  11.3
  UTOPIA.RHO.2002  10
  UTOPIA.RHO.2003  8.8
  UTOPIA.RHO.2004  7.5
  UTOPIA.RHO.2005  6.3
  UTOPIA.RHO.2006  5
  UTOPIA.RHO.2007  3.8
  UTOPIA.RHO.2008  2.5
  UTOPIA.RHO.2009  1.3
  UTOPIA.RHO.2010  0
  UTOPIA.RL1.1990  5.6
  UTOPIA.RL1.1991  5
  UTOPIA.RL1.1992  4.5
  UTOPIA.RL1.1993  3.9
  UTOPIA.RL1.1994  3.4
  UTOPIA.RL1.1995  2.8
  UTOPIA.RL1.1996  2.2
  UTOPIA.RL1.1997  1.7
  UTOPIA.RL1.1998  1.1
  UTOPIA.RL1.1999  .6
  UTOPIA.RL1.2000  0
  UTOPIA.RL1.2001  0
  UTOPIA.RL1.2002  0
  UTOPIA.RL1.2003  0
  UTOPIA.RL1.2004  0
  UTOPIA.RL1.2005  0
  UTOPIA.RL1.2006  0
  UTOPIA.RL1.2007  0
  UTOPIA.RL1.2008  0
  UTOPIA.RL1.2009  0
  UTOPIA.RL1.2010  0
  UTOPIA.TXD.1990  .6
  UTOPIA.TXD.1991  .6
  UTOPIA.TXD.1992  .5
  UTOPIA.TXD.1993  .5
  UTOPIA.TXD.1994  .4
  UTOPIA.TXD.1995  .4
  UTOPIA.TXD.1996  .4
  UTOPIA.TXD.1997  .3
  UTOPIA.TXD.1998  .3
  UTOPIA.TXD.1999  .2
  UTOPIA.TXD.2000  .2
  UTOPIA.TXD.2001  .2
  UTOPIA.TXD.2002  .2
  UTOPIA.TXD.2003  .1
  UTOPIA.TXD.2004  .1
  UTOPIA.TXD.2005  .1
  UTOPIA.TXD.2006  .1
  UTOPIA.TXD.2007  .1
  UTOPIA.TXD.2008  0
  UTOPIA.TXD.2009  0
  UTOPIA.TXD.2010  0
/;

parameter InputActivityRatio(r,t,f,m,y) /
  UTOPIA.E01.HCO.1.(1990*2010)  3.125
  UTOPIA.E21.URN.1.(1990*2010)  3.5
  UTOPIA.E31.HYD.1.(1990*2010)  3.125
  UTOPIA.E51.ELC.2.(1990*2010)  1.3889
  UTOPIA.E70.DSL.1.(1990*2010)  3.4
  UTOPIA.RHE.ELC.1.(1990*2010)  1
  UTOPIA.RHO.DSL.1.(1990*2010)  1.428571
  UTOPIA.RL1.ELC.1.(1990*2010)  1
  UTOPIA.SRE.OIL.1.(1990*2010)  1
  UTOPIA.TXD.DSL.1.(1990*2010)  1
  UTOPIA.TXE.ELC.1.(1990*2010)  1
  UTOPIA.TXG.GSL.1.(1990*2010)  1
/;

parameter OutputActivityRatio(r,t,f,m,y) /
  UTOPIA.E01.ELC.1.(1990*2010)  1
  UTOPIA.E21.ELC.1.(1990*2010)  1
  UTOPIA.E31.ELC.1.(1990*2010)  1
  UTOPIA.E51.ELC.1.(1990*2010)  1
  UTOPIA.E70.ELC.1.(1990*2010)  1
  UTOPIA.IMPDSL1.DSL.1.(1990*2010)  1
  UTOPIA.IMPGSL1.GSL.1.(1990*2010)  1
  UTOPIA.IMPHCO1.HCO.1.(1990*2010)  1
  UTOPIA.IMPOIL1.OIL.1.(1990*2010)  1
  UTOPIA.IMPURN1.URN.1.(1990*2010)  1
  UTOPIA.RHE.RH.1.(1990*2010)  1
  UTOPIA.RHO.RH.1.(1990*2010)  1
  UTOPIA.RHU.RH.1.(1990*2010)  1
  UTOPIA.RIV.HYD.1.(1990*2010)  1
  UTOPIA.RL1.RL.1.(1990*2010)  1
  UTOPIA.RLU.RL.1.(1990*2010)  1
  UTOPIA.SRE.DSL.1.(1990*2010)  .7
  UTOPIA.SRE.GSL.1.(1990*2010)  .3
  UTOPIA.TXD.TX.1.(1990*2010)  1
  UTOPIA.TXE.TX.1.(1990*2010)  1
  UTOPIA.TXG.TX.1.(1990*2010)  1
  UTOPIA.TXU.TX.1.(1990*2010)  1
/;

# By default, assume for imported secondary fuels the same efficiency of the internal refineries
InputActivityRatio(r,'IMPDSL1','OIL',m,y)$(not OutputActivityRatio(r,'SRE','DSL',m,y) eq 0) = 1/OutputActivityRatio(r,'SRE','DSL',m,y); 
InputActivityRatio(r,'IMPGSL1','OIL',m,y)$(not OutputActivityRatio(r,'SRE','GSL',m,y) eq 0) = 1/OutputActivityRatio(r,'SRE','GSL',m,y); 

*------------------------------------------------------------------------	
* Parameters - Technology costs       
*------------------------------------------------------------------------

parameter CapitalCost /
  UTOPIA.E01.1990  1400
  UTOPIA.E01.1991  1390
  UTOPIA.E01.1992  1380
  UTOPIA.E01.1993  1370
  UTOPIA.E01.1994  1360
  UTOPIA.E01.1995  1350
  UTOPIA.E01.1996  1340
  UTOPIA.E01.1997  1330
  UTOPIA.E01.1998  1320
  UTOPIA.E01.1999  1310
  UTOPIA.E01.2000  1300
  UTOPIA.E01.2001  1290
  UTOPIA.E01.2002  1280
  UTOPIA.E01.2003  1270
  UTOPIA.E01.2004  1260
  UTOPIA.E01.2005  1250
  UTOPIA.E01.2006  1240
  UTOPIA.E01.2007  1230
  UTOPIA.E01.2008  1220
  UTOPIA.E01.2009  1210
  UTOPIA.E01.2010  1200
  UTOPIA.E21.(1990*2010)  5000
  UTOPIA.E31.(1990*2010)  3000
  UTOPIA.E51.(1990*2010)  900
  UTOPIA.E70.(1990*2010)  1000
  UTOPIA.IMPDSL1.(1990*2010)  0
  UTOPIA.IMPGSL1.(1990*2010)  0
  UTOPIA.IMPHCO1.(1990*2010)  0
  UTOPIA.IMPOIL1.(1990*2010)  0
  UTOPIA.IMPURN1.(1990*2010)  0
  UTOPIA.RHE.(1990*2010)  90
  UTOPIA.RHO.(1990*2010)  100
  UTOPIA.RHU.(1990*2010)  0
  UTOPIA.RIV.(1990*2010)  0
  UTOPIA.RL1.(1990*2010)  0
  UTOPIA.RLU.(1990*2010)  0
  UTOPIA.SRE.(1990*2010)  100
  UTOPIA.TXD.(1990*2010)  1044
  UTOPIA.TXE.1990  2000
  UTOPIA.TXE.1991  1975
  UTOPIA.TXE.1992  1950
  UTOPIA.TXE.1993  1925
  UTOPIA.TXE.1994  1900
  UTOPIA.TXE.1995  1875
  UTOPIA.TXE.1996  1850
  UTOPIA.TXE.1997  1825
  UTOPIA.TXE.1998  1800
  UTOPIA.TXE.1999  1775
  UTOPIA.TXE.2000  1750
  UTOPIA.TXE.2001  1725
  UTOPIA.TXE.2002  1700
  UTOPIA.TXE.2003  1675
  UTOPIA.TXE.2004  1650
  UTOPIA.TXE.2005  1625
  UTOPIA.TXE.2006  1600
  UTOPIA.TXE.2007  1575
  UTOPIA.TXE.2008  1550
  UTOPIA.TXE.2009  1525
  UTOPIA.TXE.2010  1500
  UTOPIA.TXG.(1990*2010)  1044
  UTOPIA.TXU.(1990*2010)  0
/;

parameter VariableCost(r,t,m,y) /
  UTOPIA.E01.1.(1990*2010)  .3
  UTOPIA.E21.1.(1990*2010)  1.5
  UTOPIA.E70.1.(1990*2010)  .4
  UTOPIA.IMPDSL1.1.(1990*2010)  10
  UTOPIA.IMPGSL1.1.(1990*2010)  15
  UTOPIA.IMPHCO1.1.(1990*2010)  2
  UTOPIA.IMPOIL1.1.(1990*2010)  8
  UTOPIA.IMPURN1.1.(1990*2010)  2
  UTOPIA.RHU.1.(1990*2010)  99999
  UTOPIA.RLU.1.(1990*2010)  99999
  UTOPIA.SRE.1.(1990*2010)  10
  UTOPIA.TXU.1.(1990*2010)  99999
/;
VariableCost(r,t,m,y)$(VariableCost(r,t,m,y) = 0) = 1e-5;

parameter FixedCost /
  UTOPIA.E01.(1990*2010)  40
  UTOPIA.E21.(1990*2010)  500
  UTOPIA.E31.(1990*2010)  75
  UTOPIA.E51.(1990*2010)  30
  UTOPIA.E70.(1990*2010)  30
  UTOPIA.RHO.(1990*2010)  1
  UTOPIA.RL1.(1990*2010)  9.46
  UTOPIA.TXD.(1990*2010)  52
  UTOPIA.TXE.(1990*2010)  100
  UTOPIA.TXG.(1990*2010)  48
/;


*------------------------------------------------------------------------	
* Parameters - Storage       
*------------------------------------------------------------------------

parameter TechnologyToStorage(r,m,t,s) /
  UTOPIA.2.E51.DAM  1
/;

parameter TechnologyFromStorage(r,m,t,s) /
  UTOPIA.1.E51.DAM  1
/;

StorageLevelStart(r,s) = 999;

StorageMaxChargeRate(r,s) = 99;

StorageMaxDischargeRate(r,s) = 99;

MinStorageCharge(r,s,y) = 0;

OperationalLifeStorage(r,s) = 99;

CapitalCostStorage(r,s,y) = 0;

ResidualStorageCapacity(r,s,y) = 999;



*------------------------------------------------------------------------	
* Parameters - Capacity and investment constraints       
*------------------------------------------------------------------------

CapacityOfOneTechnologyUnit(r,t,y) = 0;

parameter TotalAnnualMaxCapacity /
  UTOPIA.E31.1990  .1301
  UTOPIA.E31.1991  .1401
  UTOPIA.E31.1992  .1401
  UTOPIA.E31.1993  .1501
  UTOPIA.E31.1994  .1501
  UTOPIA.E31.1995  .1501
  UTOPIA.E31.1996  .1601
  UTOPIA.E31.1997  .1601
  UTOPIA.E31.1998  .1601
  UTOPIA.E31.1999  .1601
  UTOPIA.E31.2000  .1701
  UTOPIA.E31.2001  .201
  UTOPIA.E31.2002  .201
  UTOPIA.E31.2003  .201
  UTOPIA.E31.2004  .201
  UTOPIA.E31.2005  .201
  UTOPIA.E31.2006  .201
  UTOPIA.E31.2007  .201
  UTOPIA.E31.2008  .201
  UTOPIA.E31.2009  .201
  UTOPIA.E31.2010  .2101
  UTOPIA.E51.(1990*2010)  3
  UTOPIA.RHE.1990  EPS
  UTOPIA.RHE.1991  EPS
  UTOPIA.RHE.1992  EPS
  UTOPIA.RHE.1993  EPS
  UTOPIA.RHE.1994  EPS
  UTOPIA.RHE.1995  EPS
  UTOPIA.RHE.1996  EPS
  UTOPIA.RHE.1997  EPS
  UTOPIA.RHE.1998  EPS
  UTOPIA.RHE.1999  EPS
  UTOPIA.RHE.2000  99999
  UTOPIA.RHE.2001  99999
  UTOPIA.RHE.2002  99999
  UTOPIA.RHE.2003  99999
  UTOPIA.RHE.2004  99999
  UTOPIA.RHE.2005  99999
  UTOPIA.RHE.2006  99999
  UTOPIA.RHE.2007  99999
  UTOPIA.RHE.2008  99999
  UTOPIA.RHE.2009  99999
  UTOPIA.RHE.2010  99999
  UTOPIA.SRE.1990  .1001
  UTOPIA.SRE.1991  .1001
  UTOPIA.SRE.1992  .1001
  UTOPIA.SRE.1993  .1001
  UTOPIA.SRE.1994  .1001
  UTOPIA.SRE.1995  .1001
  UTOPIA.SRE.1996  .1001
  UTOPIA.SRE.1997  .1001
  UTOPIA.SRE.1998  .1001
  UTOPIA.SRE.1999  .1001
  UTOPIA.SRE.2000  99999
  UTOPIA.SRE.2001  99999
  UTOPIA.SRE.2002  99999
  UTOPIA.SRE.2003  99999
  UTOPIA.SRE.2004  99999
  UTOPIA.SRE.2005  99999
  UTOPIA.SRE.2006  99999
  UTOPIA.SRE.2007  99999
  UTOPIA.SRE.2008  99999
  UTOPIA.SRE.2009  99999
  UTOPIA.SRE.2010  99999
  UTOPIA.TXE.1990  EPS
  UTOPIA.TXE.1991  .4
  UTOPIA.TXE.1992  .8
  UTOPIA.TXE.1993  1.2
  UTOPIA.TXE.1994  1.6
  UTOPIA.TXE.1995  2
  UTOPIA.TXE.1996  2.4
  UTOPIA.TXE.1997  2.8
  UTOPIA.TXE.1998  3.2
  UTOPIA.TXE.1999  3.6
  UTOPIA.TXE.2000  4
  UTOPIA.TXE.2001  4.6
  UTOPIA.TXE.2002  5.2
  UTOPIA.TXE.2003  5.8
  UTOPIA.TXE.2004  6.4
  UTOPIA.TXE.2005  7
  UTOPIA.TXE.2006  7.6
  UTOPIA.TXE.2007  8.2
  UTOPIA.TXE.2008  8.8
  UTOPIA.TXE.2009  9.4
  UTOPIA.TXE.2010  10
/;
TotalAnnualMaxCapacity(r,t,y)$(TotalAnnualMaxCapacity(r,t,y) = 0) = 99999;
TotalAnnualMaxCapacity(r,'TXE','1990') = 0;
TotalAnnualMaxCapacity(r,'RHE','1990') = 0;

parameter TotalAnnualMinCapacity(r,t,y) /
  UTOPIA.E31.1990  .13
  UTOPIA.E31.1991  .14
  UTOPIA.E31.1992  .14
  UTOPIA.E31.1993  .15
  UTOPIA.E31.1994  .15
  UTOPIA.E31.1995  .15
  UTOPIA.E31.1996  .16
  UTOPIA.E31.1997  .16
  UTOPIA.E31.1998  .16
  UTOPIA.E31.1999  .16
  UTOPIA.E31.2000  .17
  UTOPIA.E31.2001  .2
  UTOPIA.E31.2002  .2
  UTOPIA.E31.2003  .2
  UTOPIA.E31.2004  .2
  UTOPIA.E31.2005  .2
  UTOPIA.E31.2006  .2
  UTOPIA.E31.2007  .2
  UTOPIA.E31.2008  .2
  UTOPIA.E31.2009  .2
  UTOPIA.E31.2010  .21
  UTOPIA.SRE.1990  .1
  UTOPIA.SRE.1991  .1
  UTOPIA.SRE.1992  .1
  UTOPIA.SRE.1993  .1
  UTOPIA.SRE.1994  .1
  UTOPIA.SRE.1995  .1
  UTOPIA.SRE.1996  .1
  UTOPIA.SRE.1997  .1
  UTOPIA.SRE.1998  .1
  UTOPIA.SRE.1999  .1
  UTOPIA.SRE.2000  0
  UTOPIA.SRE.2001  0
  UTOPIA.SRE.2002  0
  UTOPIA.SRE.2003  0
  UTOPIA.SRE.2004  0
  UTOPIA.SRE.2005  0
  UTOPIA.SRE.2006  0
  UTOPIA.SRE.2007  0
  UTOPIA.SRE.2008  0
  UTOPIA.SRE.2009  0
  UTOPIA.SRE.2010  0
/;

TotalAnnualMaxCapacityInvestment(r,t,y) = 99999;

TotalAnnualMinCapacityInvestment(r,t,y) = 0;


*------------------------------------------------------------------------	
* Parameters - Activity constraints       
*------------------------------------------------------------------------

TotalTechnologyAnnualActivityUpperLimit(r,t,y) = 99999;

TotalTechnologyAnnualActivityLowerLimit(r,t,y) = 0;

TotalTechnologyModelPeriodActivityUpperLimit(r,t) = 99999;

TotalTechnologyModelPeriodActivityLowerLimit(r,t) = 0;


*------------------------------------------------------------------------	
* Parameters - Reserve margin
*-----------------------------------------------------------------------

parameter ReserveMarginTagTechnology(r,t,y) /
  UTOPIA.E01.(1990*2010)  1
  UTOPIA.E21.(1990*2010)  1
  UTOPIA.E31.(1990*2010)  1
  UTOPIA.E51.(1990*2010)  1
  UTOPIA.E70.(1990*2010)  1
/;

parameter ReserveMarginTagFuel(r,f,y) /
  UTOPIA.ELC.(1990*2010)  1
/;

parameter ReserveMargin(r,y) /
  UTOPIA.(1990*2010)  1.18
/;


*------------------------------------------------------------------------	
* Parameters - RE Generation Target       
*------------------------------------------------------------------------

RETagTechnology(r,t,y) = 0;

RETagFuel(r,f,y) = 0;

REMinProductionTarget(r,y) = 0;


*------------------------------------------------------------------------	
* Parameters - Emissions       
*------------------------------------------------------------------------

parameter EmissionActivityRatio(r,t,e,m,y) /
  UTOPIA.IMPDSL1.CO2.1.(1990*2010)  .075
  UTOPIA.IMPGSL1.CO2.1.(1990*2010)  .075
  UTOPIA.IMPHCO1.CO2.1.(1990*2010)  .089
  UTOPIA.IMPOIL1.CO2.1.(1990*2010)  .075
  UTOPIA.TXD.NOX.1.(1990*2010)  1
  UTOPIA.TXG.NOX.1.(1990*2010)  1
/;

EmissionsPenalty(r,e,y) = 0;

AnnualExogenousEmission(r,e,y) = 0;

AnnualEmissionLimit(r,e,y) = 9999;

ModelPeriodExogenousEmission(r,e) = 0;

ModelPeriodEmissionLimit(r,e) = 9999;
