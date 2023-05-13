$offlisting
* ITALY_DATA.GMS
* Change of UTOPIA_DATA.GMS - specify Utopia Model data in format required by GAMS
*
* OSEMOSYS 2011.07.07 conversion to GAMS by Ken Noble.Noble-Soft Systems - August 2012
* OSEMOSYS 2016.08.01 update by Thorsten Burandt, Konstantin L?ffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
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

$onText
"AnnualEmissionLimit":'Mton',
"AvailabilityFactor":'none',
"CapitalCost":'M$/GW',
"DiscountRate":'none',
'Efficiency':'none',
"EmissionActivityRatio":'Mton/PJ',
"FixedCost":'M$/GW',
"OperationalLife":'yr',
"ResidualCapacity":'GW',
"SpecifiedAnnualDemand":'PJ',
"TotalAnnualMaxCapacityInvestment":'GW',
"TotalTechnologyAnnualActivityLowerLimit":'PJ',
"TotalTechnologyAnnualActivityUpperLimit":'PJ',
"VariableCost":'M$/PJ',
"CapacityFactor": 'none',
"VarialeCost":'M$/PJ',
"TotalAnnualMaxCapacity":'GW'
$offText


*------------------------------------------------------------------------
* Sets
*------------------------------------------------------------------------

$offlisting
set     YEAR    / 2015*2060 /;
set TECHNOLOGY      /
        BF00I00 'biofuel import'
        BF00X00 'biofuel generation'
        BFHPFH1 'biofuel ICE Heat and Power unit, final use, holding'
        BM00I00 'biomass import'
        BM00X00 'biomass extraction'
        BMCCPH1 'biomass combined cycle size1'
        BMCHPH3 'biomass combined steam size3'
        BMCSPN2 'biomass CARBON CAPTURE'
        BMSTPH3 'biomass steam cycle'
        CO00I00 'coal import'
        CO00X00 'coal extraction'
        COCHPH3 'coal combined heat and power'
        COCSPN2 'coal CARBON CAPTURE'
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
        HYDSPH2 'Hydro Pumped Storage 10-100MW'
        HYDSPH3 'Hydro Pumped Storage >100MW'
        NG00I00 'natural gas import'
        NG00X00 'natural gas extraction'
        NGCCPH2 'natural gas combined cycle'
        NGCHPH3 'natural gas combined heat power, old'
        NGCHPN3 'natural gas combined heat power, new'
        NGCSPN2 'natural gas CARBON CAPTURE and storage'
        NGFCFH1 'natural gas fuel cell, final use'
        NGGCPH2 'natural gas gas cycle, old'
        NGGCPN2 'natural gas gas cycle, new'
        NGHPFH1 'natural gas ICE Heat and Power unit, final use, holding'
        NGHPPH2 'natural gas ICE Heat and Power unity, production, holding'
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
        
*Plants cooled by sea water
        BMSTPH3S 'biomass steam cycle size3, SEA WATER'
        BMCSPN2S 'biomass CARBON CAPTURE, SEA WATER'
        HFCCPH2S 'heavy fuel oil combined cycle,SEA WATER'
        NGCCPH2S 'natural gas combined cycle, SEA WATER'
        NGCSPN2S 'natural gas CARBON CAPTURE and storage, SEA WATER'
        NUG3PH3S 'Nuclear Generation 3, SEA WATER'
        WSSTPH1S 'waste steam cycle, SEA WATER'
        
*Storage tech
        BATCHG 'battery sistem of control'      

*Water technologies
        RIVER 'river source of water'
        SEA   'sea source of water'
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

set     FUEL /
        BF 'biofuel liquid'
        BM 'biomass'
        CO 'coal'
        E1 'electricity 1'
        E2 'electricity 2'
        GO 'Geothermal'
        HF 'Heavy Fuel Oil'
        NG 'Natural Gas'
        OI 'Oil'
        UR 'Uranium'
        WS 'Waste'
        HY 'Water'
        SE 'Sea Water'
/;

set     EMISSION  /CO2/;
set     MODE_OF_OPERATION       / 1, 2 /;
set     REGION  / ITALY /;
set     SEASON /1, 2, 3, 4, 5 /;
set     DAYTYPE / 1/;
set     DAILYTIMEBRACKET / 1, 2, 3 /;
set     STORAGE / DAM, BAT/;

*Characterize technologies

set power_plants(TECHNOLOGY) /BFHPFH1, BMCCPH1, BMCHPH3, BMSTPH3, BMCSPN2, COCSPN2, COCHPH3, COSTPH1, COSTPH3, GOCVPH2, HFCCPH2, HFCHPH3, HFGCPH3, HFGCPN3, HFSTPH2, HFSTPH3, HFHPFH1, HFHPPH2,
                                HYDMPH0, HYDMPH1, HYDMPH2, HYDMPH3, HYDSPH2, HYDSPH3, NGCCPH2, NGCHPH3, NGCHPN3, NGCSPN2, NGFCFH1, NGGCPH2, NGGCPN2, NGHPFH1, NGHPPH2, NUG3PH3, OCWVPH1, SOUTPH2,
                                SODIFH1, WIOFPN2, WIOFPN3, WIONPH3, WIONPN3, WSCHPH2, WSSTPH1, BMSTPH3S, BMCSPN2S, HFCCPH2S, NGCCPH2S, NGCSPN2S, NUG3PH3S, WSSTPH1S, BATCHG /;
set storage_plants(TECHNOLOGY) / HYDSPH2, HYDSPH3, BATCHG/;
set fuel_transformation(TECHNOLOGY) / OIRFPH0/;
set appliances(TECHNOLOGY) ;
set unmet_demand(TECHNOLOGY);
set primary_imports(TECHNOLOGY) /BM00I00, CO00I00, OI00I00, NG00I00/;
set secondary_imports(TECHNOLOGY) /BF00I00, HF00I00/;

set fuel_production(TECHNOLOGY) /BF00X00, BM00X00, CO00X00, GO00X00, OI00X00,NG00X00, WS00X00, UR00I00/;

set fuel_production_fict(TECHNOLOGY)/RIVER/;

set secondary_production(TECHNOLOGY) /BFHPFH1, BMCCPH1, BMCHPH3, BMSTPH3, BMCSPN2, COCSPN2, COCHPH3, COSTPH1, COSTPH3, GOCVPH2, HFCCPH2, HFCHPH3, HFGCPH3, HFGCPN3, HFSTPH2, HFSTPH3, HFHPFH1, HFHPPH2,
                                HYDMPH0, HYDMPH1, HYDMPH2, HYDMPH3, HYDSPH2, HYDSPH3, OIRFPH0, NGCCPH2, NGCHPH3, NGCHPN3, NGCSPN2, NGFCFH1, NGGCPH2, NGGCPN2, NGHPFH1, NGHPPH2, NUG3PH3, OCWVPH1, SOUTPH2,
                                SODIFH1, WIOFPN2, WIOFPN3, WIONPH3, WIONPN3, WSCHPH2, WSSTPH1, BMSTPH3S, BMCSPN2S, HFCCPH2S, NGCCPH2S, NGCSPN2S, NUG3PH3S, WSSTPH1S, BATCHG/;
*Characterize fuels

set primary_fuel(FUEL) /BF, BM, CO, GO, HF, OI, NG, UR, WS/;
set secondary_carrier(FUEL) / E1/;
set final_demand(FUEL) /E2 /;

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

*DaySplit(y,lh) = 12/(24*365); vecchio
parameter DaySplit(y,lh,ls) /
    (2015*2060).1.1 0.000702247
    (2015*2060).2.1 0.001755618
    (2015*2060).3.1 0.000351124
    (2015*2060).1.2 0.000702247
    (2015*2060).2.2 0.001872659
    (2015*2060).3.2 0.000234082
    (2015*2060).1.3 0.000585206
    (2015*2060).2.3 0.001872659
    (2015*2060).3.3 0.000351124
    (2015*2060).1.4 0.000702247
    (2015*2060).2.4 0.001755618
    (2015*2060).3.4 0.000351124
    (2015*2060).1.5 0.000702247
    (2015*2060).2.5 0.001755618
    (2015*2060).3.5 0.000351124
/;

parameter Conversionls(l,ls) /
    S01B1.1 1
    S01B2.1 1
    S01B3.1 1
    S02B1.2 1
    S02B2.2 1
    S02B3.2 1
    S03B1.3 1
    S03B2.3 1
    S03B3.3 1
    S04B1.4 1
    S04B2.4 1
    S04B3.4 1
    S05B1.5 1
    S05B2.5 1
    S05B3.5 1
/;

parameter Conversionld(l,ld) /
    S01B1.1 1
    S01B2.1 1
    S01B3.1 1
    S02B1.1 1
    S02B2.1 1
    S02B3.1 1
    S03B1.1 1
    S03B2.1 1
    S03B3.1 1
    S04B1.1 1
    S04B2.1 1
    S04B3.1 1
    S05B1.1 1
    S05B2.1 1
    S05B3.1 1
/;

parameter Conversionlh(l,lh) /
    S01B1.1 1
    S01B2.2 1
    S01B3.3 1
    S02B1.1 1
    S02B2.2 1
    S02B3.3 1
    S03B1.1 1
    S03B2.2 1
    S03B3.3 1
    S04B1.1 1
    S04B2.2 1
    S04B3.3 1
    S05B1.1 1
    S05B2.2 1
    S05B3.3 1
/;

DaysInDayType(y,ls,ld) = 7;
TradeRoute(r,rr,f,y) = 0;
DepreciationMethod(r) = 1;

*------------------------------------------------------------------------
* Parameters - Demands
*------------------------------------------------------------------------

parameter SpecifiedAnnualDemand(r,f,y) /
*dati reali
    ITALY.E2.2015   1140.83
    ITALY.E2.2016   1131.34
    ITALY.E2.2017   1153.97
    ITALY.E2.2018   1157.15
    ITALY.E2.2019   1150.64
    ITALY.E2.2020   1084.25
    ITALY.E2.2021   1151.71
    ITALY.E2.2022   1140.48
*ipotesi da OSeMBE (anche se stimati, da modificare in base a realtà del 2o22)
    ITALY.E2.2023    1186.56
    ITALY.E2.2024    1205.28
    ITALY.E2.2025    1224
    ITALY.E2.2026    1242.72
    ITALY.E2.2027    1261.44
    ITALY.E2.2028    1280.16
    ITALY.E2.2029    1298.88
    ITALY.E2.2030    1317.6
    ITALY.E2.2031    1336.32
    ITALY.E2.2032    1355.04
    ITALY.E2.2033    1373.76
    ITALY.E2.2034    1392.48
    ITALY.E2.2035    1411.2
    ITALY.E2.2036    1429.92
    ITALY.E2.2037    1448.64
    ITALY.E2.2038    1467.36
    ITALY.E2.2039    1486.08
    ITALY.E2.2040    1504.8
    ITALY.E2.2041    1523.52
    ITALY.E2.2042    1542.24
    ITALY.E2.2043    1560.96
    ITALY.E2.2044    1579.68
    ITALY.E2.2045    1598.4
    ITALY.E2.2046    1617.12
    ITALY.E2.2047    1635.84
    ITALY.E2.2048    1654.56
    ITALY.E2.2049    1673.28
    ITALY.E2.2050    1692
    ITALY.E2.2051    1701.36
    ITALY.E2.2052    1710.72
    ITALY.E2.2053    1720.08
    ITALY.E2.2054    1729.44
    ITALY.E2.2055    1738.8
    ITALY.E2.2056    1748.16
    ITALY.E2.2057    1757.52
    ITALY.E2.2058    1766.88
    ITALY.E2.2059    1776.24
    ITALY.E2.2060    1785.6
/;

SpecifiedAnnualDemand(r,'E2',y)=SpecifiedAnnualDemand(r,'E2',y)*0.87;

parameter SpecifiedDemandProfile(r,f,l,y) /
    ITALY.E2.S01B1.(2015*2060) 0.031735813
    ITALY.E2.S01B2.(2015*2060) 0.125099667
    ITALY.E2.S01B3.(2015*2060) 0.021321847
    ITALY.E2.S02B1.(2015*2060) 0.018228813
    ITALY.E2.S02B2.(2015*2060) 0.072846668
    ITALY.E2.S02B3.(2015*2060) 0.007645084
    ITALY.E2.S03B1.(2015*2060) 0.081444192
    ITALY.E2.S03B2.(2015*2060) 0.361288723
    ITALY.E2.S03B3.(2015*2060) 0.063212768
    ITALY.E2.S04B1.(2015*2060) 0.019802481
    ITALY.E2.S04B2.(2015*2060) 0.076951675
    ITALY.E2.S04B3.(2015*2060) 0.013082935
    ITALY.E2.S05B1.(2015*2060) 0.019162822
    ITALY.E2.S05B2.(2015*2060) 0.075273649
    ITALY.E2.S05B3.(2015*2060) 0.012902865
    
    ITALY.HY.S01B1.(2015*2060) 0.0434
    ITALY.HY.S01B2.(2015*2060) 0.1086
    ITALY.HY.S01B3.(2015*2060) 0.0217
    ITALY.HY.S02B1.(2015*2060) 0.0243
    ITALY.HY.S02B2.(2015*2060) 0.0648
    ITALY.HY.S02B3.(2015*2060) 0.0081
    ITALY.HY.S03B1.(2015*2060) 0.1072
    ITALY.HY.S03B2.(2015*2060) 0.3432
    ITALY.HY.S03B3.(2015*2060) 0.0643
    ITALY.HY.S04B1.(2015*2060) 0.0283
    ITALY.HY.S04B2.(2015*2060) 0.0707
    ITALY.HY.S04B3.(2015*2060) 0.0141
    ITALY.HY.S05B1.(2015*2060) 0.0253
    ITALY.HY.S05B2.(2015*2060) 0.0633
    ITALY.HY.S05B3.(2015*2060) 0.0127
/;

*" because it is defined for demands that do not depend on temporal slices, but here we only have E2."
AccumulatedAnnualDemand(r,f,y)=0;

*------------------------------------------------------------------------
* Parameters - Performance
*------------------------------------------------------------------------

*Tech which had 31.536 in OSeMBE were put in power_plants
*PJ produced by a 1GW plant in one year
CapacityToActivityUnit(r,t)$power_plants(t) = 31.536;
CapacityToActivityUnit(r,t)$(CapacityToActivityUnit(r,t) = 0) = 1;

CapacityFactor(r,t,l,y) = 0;
CapacityFactor(r,t,l,y)$(CapacityFactor(r,t,l,y) = 0) = 1;

*river capacity
    CapacityFactor(r,'RIVER','S01B1',y) =0.047977755;
    CapacityFactor(r,'RIVER','S01B2',y) =0.119944388;
    CapacityFactor(r,'RIVER','S01B3',y) =0.023988877;
    CapacityFactor(r,'RIVER','S02B1',y) =0.051145783;
    CapacityFactor(r,'RIVER','S02B2',y) =0.136388753;
    CapacityFactor(r,'RIVER','S02B3',y) =0.017048595;
    CapacityFactor(r,'RIVER','S03B1',y) =0.037010798;
    CapacityFactor(r,'RIVER','S03B2',y) =0.118434553;
    CapacityFactor(r,'RIVER','S03B3',y) =0.022206479;
    CapacityFactor(r,'RIVER','S04B1',y) =0.055006628;
    CapacityFactor(r,'RIVER','S04B2',y) =0.137516568;
    CapacityFactor(r,'RIVER','S04B3',y) =0.027503314;
    CapacityFactor(r,'RIVER','S05B1',y) =0.05145688;
    CapacityFactor(r,'RIVER','S05B2',y) =0.128642201;
    CapacityFactor(r,'RIVER','S05B3',y) =0.02572844;

    
*Solar capacity
    CapacityFactor(r,'SODIFH1','S01B1',y) = 0.0000563558;
    CapacityFactor(r,'SODIFH1','S01B2',y) = 0.173036406;
    CapacityFactor(r,'SODIFH1','S01B3',y) = 0;
    CapacityFactor(r,'SODIFH1','S02B1',y) = 0.004242173;
    CapacityFactor(r,'SODIFH1','S02B2',y) = 0.250816839;
    CapacityFactor(r,'SODIFH1','S02B3',y) = 0;
    CapacityFactor(r,'SODIFH1','S03B1',y) = 0.00316014;
    CapacityFactor(r,'SODIFH1','S03B2',y) = 0.291570421;
    CapacityFactor(r,'SODIFH1','S03B3',y) = 0;
    CapacityFactor(r,'SODIFH1','S04B1',y) = 0.0000690295;
    CapacityFactor(r,'SODIFH1','S04B2',y) = 0.176523404;
    CapacityFactor(r,'SODIFH1','S04B3',y) = 0;
    CapacityFactor(r,'SODIFH1','S05B1',y) = 0;
    CapacityFactor(r,'SODIFH1','S05B2',y) = 0.127762552;
    CapacityFactor(r,'SODIFH1','S05B3',y) = 0;


    CapacityFactor(r,'SOUTPH2','S01B1',y) = 0.0000563558;
    CapacityFactor(r,'SOUTPH2','S01B2',y) = 0.173036406;
    CapacityFactor(r,'SOUTPH2','S01B3',y) = 0;
    CapacityFactor(r,'SOUTPH2','S02B1',y) = 0.004242173;
    CapacityFactor(r,'SOUTPH2','S02B2',y) = 0.250816839;
    CapacityFactor(r,'SOUTPH2','S02B3',y) = 0;
    CapacityFactor(r,'SOUTPH2','S03B1',y) = 0.00316014;
    CapacityFactor(r,'SOUTPH2','S03B2',y) = 0.291570421;
    CapacityFactor(r,'SOUTPH2','S03B3',y) = 0;
    CapacityFactor(r,'SOUTPH2','S04B1',y) = 0.0000690295;
    CapacityFactor(r,'SOUTPH2','S04B2',y) = 0.176523404;
    CapacityFactor(r,'SOUTPH2','S04B3',y) = 0;
    CapacityFactor(r,'SOUTPH2','S05B1',y) = 0;
    CapacityFactor(r,'SOUTPH2','S05B2',y) = 0.127762552;
    CapacityFactor(r,'SOUTPH2','S05B3',y) = 0;

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


parameter AvailabilityFactor(r,t,y) /
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
    ITALY.BFHPFH1.2046 .711
    ITALY.BFHPFH1.2047 .712
    ITALY.BFHPFH1.2048 .713
    ITALY.BFHPFH1.2049 .714
    ITALY.BFHPFH1.2050 .715
    ITALY.BFHPFH1.2051 .716
    ITALY.BFHPFH1.2052 .717
    ITALY.BFHPFH1.2053 .718
    ITALY.BFHPFH1.2054 .719
    ITALY.BFHPFH1.2055 .72
    ITALY.BFHPFH1.2056 .721
    ITALY.BFHPFH1.2057 .722
    ITALY.BFHPFH1.2058 .723
    ITALY.BFHPFH1.2059 .724
    ITALY.BFHPFH1.2060 .725

    ITALY.BMCHPH3.2015 .65
    ITALY.BMCHPH3.2016 .655
    ITALY.BMCHPH3.2017 .66
    ITALY.BMCHPH3.2018 .665
    ITALY.BMCHPH3.2019 .67
    ITALY.BMCHPH3.2020 .675
    ITALY.BMCHPH3.2021 .675
    ITALY.BMCHPH3.2022 .675
    ITALY.BMCHPH3.2023 .675
    ITALY.BMCHPH3.2024 .675
    ITALY.BMCHPH3.2025 .675
    ITALY.BMCHPH3.2026 .675
    ITALY.BMCHPH3.2027 .675
    ITALY.BMCHPH3.2028 .675
    ITALY.BMCHPH3.2029 .675
    ITALY.BMCHPH3.2030 .675
    ITALY.BMCHPH3.2031 .68
    ITALY.BMCHPH3.2032 .685
    ITALY.BMCHPH3.2033 .69
    ITALY.BMCHPH3.2034 .695
    ITALY.BMCHPH3.2035 .7
    ITALY.BMCHPH3.2036 .705
    ITALY.BMCHPH3.2037 .71
    ITALY.BMCHPH3.2038 .715
    ITALY.BMCHPH3.2039 .72
    ITALY.BMCHPH3.(2040*2060) .725

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

    AvailabilityFactor(r,'BMCCPH1',y) = .7;
    AvailabilityFactor(r,'BMSTPH3',y) = .7;
    AvailabilityFactor(r,'BMSTPH3S',y) = .7;
    AvailabilityFactor(r,'COCHPH3',y) = 0.85;
    AvailabilityFactor(r,'COSTPH1',y) = 0.8;
    AvailabilityFactor(r,'COSTPH3',y) = .8;
    AvailabilityFactor(r,'GOCVPH2',y) = .95;
    AvailabilityFactor(r,'HFCCPH2',y) = .85;
    AvailabilityFactor(r,'HFCCPH2S',y) = .85;
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
    AvailabilityFactor(r,'NUG3PH3',y) = .81;
    AvailabilityFactor(r,'NUG3PH3S',y) = .81;
    AvailabilityFactor(r,'NGCCPH2',y) = 0.85;
    AvailabilityFactor(r,'NGCCPH2S',y) = 0.85;
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
    AvailabilityFactor(r,'WSSTPH1S',y) = .7;
    AvailabilityFactor(r,'BMCSPN2',y) = .85;
    AvailabilityFactor(r,'BMCSPN2S',y) = .85;
    AvailabilityFactor(r,'COCSPN2',y) = .85;
    AvailabilityFactor(r,'NGCSPN2',y) = .85;
    AvailabilityFactor(r,'NGCSPN2S',y) = .85;

    AvailabilityFactor(r,t,y)$(AvailabilityFactor(r,t,y) = 0) = 1;
*Se mettessimo dentro alla dichiarazione precedente (2036*2060) per nucleare, il resto 0 così
*AvailabilityFactor(r,'NUG3PH3',y)$(AvailabilityFactor(r,'NUG3PH3',y) = 1) = 0;
*AvailabilityFactor(r,'NUG3PH3S',y)$(AvailabilityFactor(r,'NUG3PH3S',y) = 1) = 0;

parameter OperationalLife(r,t) /

    ITALY.COCSPN2 40
    ITALY.NGCSPN2 30
    ITALY.NGCSPN2S 30
    ITALY.BMCSPN2 35
    ITALY.BMCSPN2S 35
    ITALY.UR00I00 1

    ITALY.BF00I00 1
    ITALY.BF00X00 1
    ITALY.BFHPFH1 20
    ITALY.BM00I00 1
    ITALY.BM00X00 1
    ITALY.BMCCPH1 30
    ITALY.BMCHPH3 25
    ITALY.BMSTPH3 30
    ITALY.BMSTPH3S 30
    ITALY.CO00I00 1
    ITALY.CO00X00 1
    ITALY.COCHPH3 25
    ITALY.COSTPH1 30
    ITALY.COSTPH3 30
    ITALY.EL00TD0 1
    ITALY.GO00X00 1
    ITALY.GOCVPH2 40
    ITALY.HF00I00 1
    ITALY.HFCCPH2 30
    ITALY.HFCCPH2S 30
    ITALY.HFCHPH3 25
    ITALY.HFGCPH3 25
    ITALY.HFGCPN3 25
    ITALY.HFHPFH1 20
    ITALY.HFHPPH2 20
    ITALY.HFSTPH2 30
    ITALY.HFSTPH3 30
    ITALY.HYDMPH0 80
    ITALY.HYDMPH1 80
    ITALY.HYDMPH2 80
    ITALY.HYDMPH3 80
    ITALY.HYDSPH2 80
    ITALY.HYDSPH3 80
    ITALY.NG00I00 1
    ITALY.NG00X00 1
    ITALY.NGCCPH2 30
    ITALY.NGCCPH2S 30
    ITALY.NGCHPH3 25
    ITALY.NGCHPN3 25
    ITALY.NGFCFH1 5
    ITALY.NGGCPH2 25
    ITALY.NGGCPN2 25
    ITALY.NGHPFH1 20
    ITALY.NGHPPH2 20
    ITALY.NGSTPH2 30
    ITALY.NUG3PH3 60
    ITALY.NUG3PH3S 60
    ITALY.OCWVPH1 25
    ITALY.OI00I00 1
    ITALY.OI00X00 1
    ITALY.OIRFPH0 1
    ITALY.SODIFH1 25
    ITALY.SOUTPH2 25
    ITALY.WIOFPN2 25
    ITALY.WIOFPN3 25
    ITALY.WIONPH3 25
    ITALY.WIONPN3 25
    ITALY.WS00X00 1
    ITALY.WSCHPH2 25
    ITALY.WSSTPH1 30
    ITALY.WSSTPH1S 30
    
    ITALY.BATCHG 20
/;
OperationalLife(r,t)$(OperationalLife(r,t) = 0) = 1;

*given in GW
parameter ResidualCapacity(r,t,y) /
    ITALY.BFHPFH1.(2015*2022)    0.633283
    ITALY.BFHPFH1.2023    0.622297
    ITALY.BFHPFH1.2024    0.596737
    ITALY.BFHPFH1.2025    0.578218
    ITALY.BFHPFH1.2026    0.576688
    ITALY.BFHPFH1.2027    0.538838
    ITALY.BFHPFH1.2028    0.199178
    ITALY.BFHPFH1.2029    0.093502
    ITALY.BFHPFH1.2030    0.075079
    ITALY.BFHPFH1.2031    0.05246
    ITALY.BFHPFH1.2032    0.004196
    ITALY.BFHPFH1.2033    0.002198
    ITALY.BFHPFH1.2034    0.000099
    ITALY.BFHPFH1.(2035*2060)    0

    ITALY.BMCCPH1.(2015*2028)    0.009
    ITALY.BMCCPH1.(2029*2060)    0

    ITALY.BMCHPH3.(2015*2023)    0.005335
    ITALY.BMCHPH3.(2024*2033)    0.000535
    ITALY.BMCHPH3.2034    0.000075
    ITALY.BMCHPH3.(2035*2060)    0

    ITALY.BMSTPH3.(2015*2020)    0.302125
    ITALY.BMSTPH3.(2021*2022)    0.267125
    ITALY.BMSTPH3.(2023*2026)    0.266275
    ITALY.BMSTPH3.(2027*2028)    0.257775
    ITALY.BMSTPH3.2029    0.251775
    ITALY.BMSTPH3.2030    0.197336
    ITALY.BMSTPH3.2031    0.176978
    ITALY.BMSTPH3.2032    0.126578
    ITALY.BMSTPH3.2033    0.068578
    ITALY.BMSTPH3.2034    0.068578
    ITALY.BMSTPH3.(2035*2037)    0.068128
    ITALY.BMSTPH3.2038    0.067628
    ITALY.BMSTPH3.2039    0.065528
    ITALY.BMSTPH3.2040    0.041279
    ITALY.BMSTPH3.2041    0.027529
    ITALY.BMSTPH3.2042    0.000529
    ITALY.BMSTPH3.2043    0.000529
    ITALY.BMSTPH3.2044    0.000199
    ITALY.BMSTPH3.(2045*2060)    0

    ITALY.COCHPH3.(2015*2020)    0.475
    ITALY.COCHPH3.2021    0.405
    ITALY.COCHPH3.(2022*2025)    0.353
    ITALY.COCHPH3.(2026*2060)    0

    ITALY.COSTPH3.2015   8.2252
    ITALY.COSTPH3.2016   8.2172
    ITALY.COSTPH3.2017   7.4867
    ITALY.COSTPH3.2018   7.4867
    ITALY.COSTPH3.2019   7.4217
    ITALY.COSTPH3.2020   6.762
    ITALY.COSTPH3.2021   6.094
    ITALY.COSTPH3.2022   5.762
    ITALY.COSTPH3.(2023*2025)    2.061
    ITALY.COSTPH3.(2026*2060)    0

    ITALY.GOCVPH2.(2015*2020)    0.9464
    ITALY.GOCVPH2.2021    0.9384
    ITALY.GOCVPH2.2022    0.902
    ITALY.GOCVPH2.2023    0.894
    ITALY.GOCVPH2.2024    0.894
    ITALY.GOCVPH2.2025    0.874
    ITALY.GOCVPH2.2026    0.854
    ITALY.GOCVPH2.2027    0.8134
    ITALY.GOCVPH2.2028    0.7734
    ITALY.GOCVPH2.2029    0.7734
    ITALY.GOCVPH2.2030    0.7534
    ITALY.GOCVPH2.2031    0.6734
    ITALY.GOCVPH2.2032    0.6134
    ITALY.GOCVPH2.2033    0.6134
    ITALY.GOCVPH2.2034    0.5806
    ITALY.GOCVPH2.2035    0.5406
    ITALY.GOCVPH2.2036    0.4806
    ITALY.GOCVPH2.2037    0.4406
    ITALY.GOCVPH2.2038    0.3865
    ITALY.GOCVPH2.2039    0.3665
    ITALY.GOCVPH2.2040    0.352
    ITALY.GOCVPH2.2041    0.352
    ITALY.GOCVPH2.2042    0.172
    ITALY.GOCVPH2.2043    0.152
    ITALY.GOCVPH2.2044    0.152
    ITALY.GOCVPH2.(2045*2048)    0.092
    ITALY.GOCVPH2.2049    0.08
    ITALY.GOCVPH2.2050    0.06
    ITALY.GOCVPH2.2051    0.04
    ITALY.GOCVPH2.2052    0.04
    ITALY.GOCVPH2.2053    0.04
    ITALY.GOCVPH2.(2054*2060)    0

    ITALY.HFCHPH3.(2015*2020)    1.10118
    ITALY.HFCHPH3.2021    0.70418
    ITALY.HFCHPH3.2022    0.16883
    ITALY.HFCHPH3.2023    0.049
    ITALY.HFCHPH3.(2024*2027)    0.034
    ITALY.HFCHPH3.(2028*2060)    0

    ITALY.HFGCPH3.(2015*2020)    0.571885
    ITALY.HFGCPH3.2021    0.469885
    ITALY.HFGCPH3.2022    0.338795
    ITALY.HFGCPH3.2023    0.136395
    ITALY.HFGCPH3.(2024*2027)    0.093
    ITALY.HFGCPH3.(2028*2030)    0.08
    ITALY.HFGCPH3.(2031*2060)    0

    ITALY.HFHPPH2.(2015*2020)    0.187214
    ITALY.HFHPPH2.2021    0.185594
    ITALY.HFHPPH2.2022    0.163395
    ITALY.HFHPPH2.2023    0.105942
    ITALY.HFHPPH2.2024    0.06522
    ITALY.HFHPPH2.(2025*2027)    0.0078
    ITALY.HFHPPH2.2028    0.0063
    ITALY.HFHPPH2.2029    0.0063
    ITALY.HFHPPH2.2030    0.004
    ITALY.HFHPPH2.2031    0.004
    ITALY.HFHPPH2.(2032*2060)    0

*In 2021 coastal plants were 1.83GW, 23% (reduced HFSTPH2, 77%)
$ontext
    ITALY.HFSTPH2.(2015*2019)    11.502835
    ITALY.HFSTPH2.2020    11.129335
    ITALY.HFSTPH2.2021    7.997485
    ITALY.HFSTPH2.2022    2.55666
    ITALY.HFSTPH2.(2023*2029)    0.0375
    ITALY.HFSTPH2.(2030*2060)    0
$offtext

    ITALY.HFSTPH2.(2015*2019)    8.857
    ITALY.HFSTPH2.2020    8.570
    ITALY.HFSTPH2.2021    6.158
    ITALY.HFSTPH2.2022    1.969
    ITALY.HFSTPH2.(2023*2029)    0.02888
    ITALY.HFSTPH2.(2030*2060)    0
    
    ITALY.HFCCPH2S.(2015*2019)    2.646
    ITALY.HFCCPH2S.2020    2.560
    ITALY.HFCCPH2S.2021    0.2288
    ITALY.HFCCPH2S.2022    0.5880
    ITALY.HFCCPH2S.(2023*2029)    0.008625
    ITALY.HFCCPH2S.(2030*2060)    0


    ITALY.HYDMPH1.2015    3.096405
    ITALY.HYDMPH1.2016    2.917688
    ITALY.HYDMPH1.2017    2.627017
    ITALY.HYDMPH1.2018    2.352358
    ITALY.HYDMPH1.2019    2.333791
    ITALY.HYDMPH1.2020    2.299763
    ITALY.HYDMPH1.2021    2.214348
    ITALY.HYDMPH1.2022    2.13701
    ITALY.HYDMPH1.2023    2.105731
    ITALY.HYDMPH1.2024    2.105291
    ITALY.HYDMPH1.2025    2.096121
    ITALY.HYDMPH1.2026    2.082831
    ITALY.HYDMPH1.2027    2.067321
    ITALY.HYDMPH1.2028    2.036801
    ITALY.HYDMPH1.2029    1.969421
    ITALY.HYDMPH1.2030    1.950011
    ITALY.HYDMPH1.2031    1.882651
    ITALY.HYDMPH1.2032    1.871212
    ITALY.HYDMPH1.2033    1.839537
    ITALY.HYDMPH1.2034    1.804691
    ITALY.HYDMPH1.2035    1.759327
    ITALY.HYDMPH1.2036    1.724252
    ITALY.HYDMPH1.2037    1.702013
    ITALY.HYDMPH1.2038    1.644443
    ITALY.HYDMPH1.2039    1.588518
    ITALY.HYDMPH1.2040    1.580723
    ITALY.HYDMPH1.2041    1.563212
    ITALY.HYDMPH1.2042    1.542341
    ITALY.HYDMPH1.2043    1.493202
    ITALY.HYDMPH1.2044    1.477913
    ITALY.HYDMPH1.2045    1.468025
    ITALY.HYDMPH1.2046    1.467957
    ITALY.HYDMPH1.2047    1.465457
    ITALY.HYDMPH1.2048    1.462812
    ITALY.HYDMPH1.2049    1.461637
    ITALY.HYDMPH1.2050    1.446477
    ITALY.HYDMPH1.2051    1.439928
    ITALY.HYDMPH1.2052    1.439748
    ITALY.HYDMPH1.2053    1.439748
    ITALY.HYDMPH1.2054    1.439348
    ITALY.HYDMPH1.(2055*2057)    1.23869
    ITALY.HYDMPH1.2058    1.238364
    ITALY.HYDMPH1.2059    1.233204
    ITALY.HYDMPH1.2060    1.228039

    ITALY.HYDMPH2.2015    10.633227
    ITALY.HYDMPH2.2016    10.542527
    ITALY.HYDMPH2.2017    9.990237
    ITALY.HYDMPH2.2018    8.913137
    ITALY.HYDMPH2.2019    8.793637
    ITALY.HYDMPH2.2020    8.538637
    ITALY.HYDMPH2.2021    8.263557
    ITALY.HYDMPH2.2022    8.196907
    ITALY.HYDMPH2.2023    8.090907
    ITALY.HYDMPH2.2024    8.074707
    ITALY.HYDMPH2.2025    8.062707
    ITALY.HYDMPH2.2026    8.062707
    ITALY.HYDMPH2.2027    7.952487
    ITALY.HYDMPH2.2028    7.844387
    ITALY.HYDMPH2.2029    7.783787
    ITALY.HYDMPH2.2030    7.514697
    ITALY.HYDMPH2.2031    6.863097
    ITALY.HYDMPH2.2032    6.665597
    ITALY.HYDMPH2.2033    6.427777
    ITALY.HYDMPH2.2034    6.090997
    ITALY.HYDMPH2.2035    5.729437
    ITALY.HYDMPH2.2036    5.068237
    ITALY.HYDMPH2.2037    4.875667
    ITALY.HYDMPH2.2038    4.270907
    ITALY.HYDMPH2.2039    3.912237
    ITALY.HYDMPH2.2040    3.598997
    ITALY.HYDMPH2.2041    3.489677
    ITALY.HYDMPH2.2042    3.333277
    ITALY.HYDMPH2.2043    2.705907
    ITALY.HYDMPH2.2044    2.666407
    ITALY.HYDMPH2.2045    2.405757
    ITALY.HYDMPH2.2046    2.320757
    ITALY.HYDMPH2.2047    2.320757
    ITALY.HYDMPH2.2048    2.264057
    ITALY.HYDMPH2.2049    2.251057
    ITALY.HYDMPH2.2050    2.217557
    ITALY.HYDMPH2.2051    2.112557
    ITALY.HYDMPH2.2052    2.097557
    ITALY.HYDMPH2.2053    2.014557
    ITALY.HYDMPH2.2054    2.014557
    ITALY.HYDMPH2.2055    1.977057
    ITALY.HYDMPH2.2056    1.977057
    ITALY.HYDMPH2.2057    1.977057
    ITALY.HYDMPH2.2058    1.937657
    ITALY.HYDMPH2.2059    1.870157
    ITALY.HYDMPH2.2060    1.700625

    ITALY.HYDMPH3.(2015*2032)    2.16992
    ITALY.HYDMPH3.(2033*2039)    2.06848
    ITALY.HYDMPH3.(2040*2043)    1.85448
    ITALY.HYDMPH3.(2044*2046)    1.74748
    ITALY.HYDMPH3.(2047*2050)    1.50748
    ITALY.HYDMPH3.2051    1.27748
    ITALY.HYDMPH3.2052    0.92248
    ITALY.HYDMPH3.(2053*2060)    0.39248

    ITALY.HYDSPH2.(2015*2028)   1.08785
    ITALY.HYDSPH2.(2029*2040)   0.94685
    ITALY.HYDSPH2.2041    0.88425
    ITALY.HYDSPH2.2042    0.86185
    ITALY.HYDSPH2.2043    0.85165
    ITALY.HYDSPH2.2044    0.71203
    ITALY.HYDSPH2.2045    0.71203
    ITALY.HYDSPH2.2046    0.59703
    ITALY.HYDSPH2.2047    0.59703
    ITALY.HYDSPH2.(2048*2050)    0.55503
    ITALY.HYDSPH2.2051    0.38675
    ITALY.HYDSPH2.2052    0.38675
    ITALY.HYDSPH2.(2053*2057)    0.3839
    ITALY.HYDSPH2.2058    0.2239
    ITALY.HYDSPH2.2059    0.1439
    ITALY.HYDSPH2.2060    0.1439

    ITALY.HYDSPH3.(2015*2052)   4.89
    ITALY.HYDSPH3.2053    4.765
    ITALY.HYDSPH3.2054    4.36
    ITALY.HYDSPH3.2055    4.195
    ITALY.HYDSPH3.2056    4.03
    ITALY.HYDSPH3.2057    4.03
    ITALY.HYDSPH3.2058    3.905
    ITALY.HYDSPH3.2059    3.905
    ITALY.HYDSPH3.2060    3.78

*Helf of residual capacity of NG combined cycle is made of seaside plants
$ontext
    ITALY.NGCCPH2.(2015*2022)    23.50937
    ITALY.NGCCPH2.2023    23.08783
    ITALY.NGCCPH2.2024    22.96433
    ITALY.NGCCPH2.2025    22.80048
    ITALY.NGCCPH2.2026    21.94748
    ITALY.NGCCPH2.2027    21.1642
    ITALY.NGCCPH2.2028    20.4582
    ITALY.NGCCPH2.2029    19.9402
    ITALY.NGCCPH2.2030    18.5182
    ITALY.NGCCPH2.2031    18.1392
    ITALY.NGCCPH2.2032    16.8032
    ITALY.NGCCPH2.2033    15.5282
    ITALY.NGCCPH2.2034    12.3147
    ITALY.NGCCPH2.2035    9.6647
    ITALY.NGCCPH2.2036    7.7352
    ITALY.NGCCPH2.2037    5.5046
    ITALY.NGCCPH2.2038    3.072
    ITALY.NGCCPH2.2039    2.71
    ITALY.NGCCPH2.2040    1.56
    ITALY.NGCCPH2.2041    0.52
    ITALY.NGCCPH2.(2042*2060)    0
$offtext

    ITALY.NGCCPH2.(2015*2022)  11.754685
    ITALY.NGCCPH2.2023        11.543915
    ITALY.NGCCPH2.2024        11.482165
    ITALY.NGCCPH2.2025        11.40024
    ITALY.NGCCPH2.2026        10.97374
    ITALY.NGCCPH2.2027        10.5821
    ITALY.NGCCPH2.2028        10.2291
    ITALY.NGCCPH2.2029        9.9701
    ITALY.NGCCPH2.2030        9.2591
    ITALY.NGCCPH2.2031        9.0696
    ITALY.NGCCPH2.2032        8.4016
    ITALY.NGCCPH2.2033        7.7641
    ITALY.NGCCPH2.2034        6.15735
    ITALY.NGCCPH2.2035        4.83235
    ITALY.NGCCPH2.2036        3.8676
    ITALY.NGCCPH2.2037        2.7523
    ITALY.NGCCPH2.2038        1.536
    ITALY.NGCCPH2.2039        1.355
    ITALY.NGCCPH2.2040        0.78
    ITALY.NGCCPH2.2041        0.26
    ITALY.NGCCPH2.(2042*2060) 0

*Sea water cooled plant
    ITALY.NGCCPH2S.(2015*2022)  11.754685
    ITALY.NGCCPH2S.2023        11.543915
    ITALY.NGCCPH2S.2024        11.482165
    ITALY.NGCCPH2S.2025        11.40024
    ITALY.NGCCPH2S.2026        10.97374
    ITALY.NGCCPH2S.2027        10.5821
    ITALY.NGCCPH2S.2028        10.2291
    ITALY.NGCCPH2S.2029        9.9701
    ITALY.NGCCPH2S.2030        9.2591
    ITALY.NGCCPH2S.2031        9.0696
    ITALY.NGCCPH2S.2032        8.4016
    ITALY.NGCCPH2S.2033        7.7641
    ITALY.NGCCPH2S.2034        6.15735
    ITALY.NGCCPH2S.2035        4.83235
    ITALY.NGCCPH2S.2036        3.8676
    ITALY.NGCCPH2S.2037        2.7523
    ITALY.NGCCPH2S.2038        1.536
    ITALY.NGCCPH2S.2039        1.355
    ITALY.NGCCPH2S.2040        0.78
    ITALY.NGCCPH2S.2041        0.26
    ITALY.NGCCPH2S.(2042*2060) 0


    ITALY.NGCHPH3.(2015*2018)    10.144444
    ITALY.NGCHPH3.2019    10.142764
    ITALY.NGCHPH3.2020    10.058614
    ITALY.NGCHPH3.2021    9.928579
    ITALY.NGCHPH3.2022    9.760909
    ITALY.NGCHPH3.2023    8.47561
    ITALY.NGCHPH3.2024    6.831134
    ITALY.NGCHPH3.2025    6.461534
    ITALY.NGCHPH3.2026    5.874384
    ITALY.NGCHPH3.2027    5.841777
    ITALY.NGCHPH3.2028    5.415977
    ITALY.NGCHPH3.2029    5.283977
    ITALY.NGCHPH3.2030    3.91927
    ITALY.NGCHPH3.2031    2.12892
    ITALY.NGCHPH3.2032    1.84232
    ITALY.NGCHPH3.2033    1.47538
    ITALY.NGCHPH3.2034    1.30368
    ITALY.NGCHPH3.2035    0.450485
    ITALY.NGCHPH3.2036    0.18036
    ITALY.NGCHPH3.2037    0.151
    ITALY.NGCHPH3.2038    0.0062
    ITALY.NGCHPH3.2039    0.0062
    ITALY.NGCHPH3.(2040*2060)    0

    ITALY.NGFCFH1.(2015*2023)    0.000115
    ITALY.NGFCFH1.2024    0.00011
    ITALY.NGFCFH1.(2025*2060)    0

    ITALY.NGGCPH2.(2015*2020)    2.252338
    ITALY.NGGCPH2.2021    2.210638
    ITALY.NGGCPH2.2022    1.151388
    ITALY.NGGCPH2.2023    0.27987
    ITALY.NGGCPH2.(2024*2027)    0.06706
    ITALY.NGGCPH2.2028    0.06406
    ITALY.NGGCPH2.(2029*2032)    0.064
    ITALY.NGGCPH2.2033    0.032
    ITALY.NGGCPH2.(2034*2060)    0

    ITALY.NGHPPH2.(2015*2021)    0.943734
    ITALY.NGHPPH2.2022    0.931799
    ITALY.NGHPPH2.2023    0.859569
    ITALY.NGHPPH2.2024    0.393228
    ITALY.NGHPPH2.2025    0.233493
    ITALY.NGHPPH2.2026    0.215964
    ITALY.NGHPPH2.2027    0.171627
    ITALY.NGHPPH2.2028    0.151007
    ITALY.NGHPPH2.2029    0.075442
    ITALY.NGHPPH2.2030    0.017161
    ITALY.NGHPPH2.2031    0.010861
    ITALY.NGHPPH2.2032    0.005651
    ITALY.NGHPPH2.2033    0.005651
    ITALY.NGHPPH2.2034    0.003
    ITALY.NGHPPH2.(2035*2060)    0

    ITALY.NGSTPH2.(2015*2019)    3.77688
    ITALY.NGSTPH2.2020    3.76188
    ITALY.NGSTPH2.2021    3.74688
    ITALY.NGSTPH2.2022    0.65038
    ITALY.NGSTPH2.2023    0.0043
    ITALY.NGSTPH2.(2024*2027)    0.003
    ITALY.NGSTPH2.2028    0.001
    ITALY.NGSTPH2.2029    0.001
    ITALY.NGSTPH2.(2030*2060)    0


    ITALY.SODIFH1.(2015*2023)    0.002208
    ITALY.SODIFH1.2024    0.002089
    ITALY.SODIFH1.2025    0.002089
    ITALY.SODIFH1.2026    0.001989
    ITALY.SODIFH1.2027    0.001944
    ITALY.SODIFH1.2028    0.001158
    ITALY.SODIFH1.2029    0.001069
    ITALY.SODIFH1.2030    0.001069
    ITALY.SODIFH1.2031    0.000969
    ITALY.SODIFH1.2032    0.000622
    ITALY.SODIFH1.2033    0.000469
    ITALY.SODIFH1.2034    0.000393
    ITALY.SODIFH1.2035    0.000393
    ITALY.SODIFH1.2036    0.000221
    ITALY.SODIFH1.(2037*2060)    0

    ITALY.SOUTPH2.2015    18.9008
    ITALY.SOUTPH2.2016    19.2832
    ITALY.SOUTPH2.2017    19.6823
    ITALY.SOUTPH2.2018    20.1076
    ITALY.SOUTPH2.2019    20.8653
    ITALY.SOUTPH2.2020    21.6500
    ITALY.SOUTPH2.(2021*2023)    22.5943
    ITALY.SOUTPH2.(2024*2026)    22.59082
    ITALY.SOUTPH2.2027    22.5906
    ITALY.SOUTPH2.2028    22.18456
    ITALY.SOUTPH2.2029    22.18444
    ITALY.SOUTPH2.2030    22.18444
    ITALY.SOUTPH2.2031    22.18404
    ITALY.SOUTPH2.2032    22.06825
    ITALY.SOUTPH2.2033    21.65912
    ITALY.SOUTPH2.2034    20.80512
    ITALY.SOUTPH2.2035    18.21077
    ITALY.SOUTPH2.2036    7.55696
    ITALY.SOUTPH2.2037    2.630533
    ITALY.SOUTPH2.2038    0.893928
    ITALY.SOUTPH2.2039    0.373955
    ITALY.SOUTPH2.(2040*2060)    0

    ITALY.WIONPH3.2015    9.1619
    ITALY.WIONPH3.2016    9.4099
    ITALY.WIONPH3.2017    9.7659
    ITALY.WIONPH3.2018    10.2647
    ITALY.WIONPH3.2019    10.7148
    ITALY.WIONPH3.2020    10.9069
    ITALY.WIONPH3.2021    11.2898
    ITALY.WIONPH3.2022    11.28973
    ITALY.WIONPH3.2023    11.28644
    ITALY.WIONPH3.2024    11.00472
    ITALY.WIONPH3.2025    10.37119
    ITALY.WIONPH3.2026    9.967643
    ITALY.WIONPH3.2027    9.199878
    ITALY.WIONPH3.2028    8.330017
    ITALY.WIONPH3.2029    7.949329
    ITALY.WIONPH3.2030    6.759300
    ITALY.WIONPH3.2031    6.023267
    ITALY.WIONPH3.2032    5.287235
    ITALY.WIONPH3.2033    4.618435
    ITALY.WIONPH3.2034    3.813
    ITALY.WIONPH3.2035    2.587975
    ITALY.WIONPH3.2036    1.628525
    ITALY.WIONPH3.2037    0.545
    ITALY.WIONPH3.2038    0.112
    ITALY.WIONPH3.(2039*2060)    0

    ITALY.WIONPN3.(2015*2039)    0.295
    ITALY.WIONPN3.(2040*2060)    0

    ITALY.WSCHPH2.(2015*2022)    0.27173
    ITALY.WSCHPH2.2023    0.26567
    ITALY.WSCHPH2.2024    0.2044
    ITALY.WSCHPH2.2025    0.19215
    ITALY.WSCHPH2.2026    0.18635
    ITALY.WSCHPH2.2027    0.18635
    ITALY.WSCHPH2.2028    0.1782
    ITALY.WSCHPH2.2029    0.1413
    ITALY.WSCHPH2.2030    0.1283
    ITALY.WSCHPH2.2031    0.1283
    ITALY.WSCHPH2.2032    0.116
    ITALY.WSCHPH2.2033    0.0925
    ITALY.WSCHPH2.2034    0.0925
    ITALY.WSCHPH2.(2035*2037)    0.0825
    ITALY.WSCHPH2.(2038*2060)    0

*Coastal plants were 0.0262 in 2022, I take 6% of total capacity
$ontext
    ITALY.WSSTPH1.(2015*2020)    0.46711
    ITALY.WSSTPH1.(2021*2023)    0.46611
    ITALY.WSSTPH1.(2024*2026)    0.45711
    ITALY.WSSTPH1.2027    0.45361
    ITALY.WSSTPH1.2028    0.45146
    ITALY.WSSTPH1.2029    0.36821
    ITALY.WSSTPH1.2030    0.32736
    ITALY.WSSTPH1.2031    0.30601
    ITALY.WSSTPH1.2032    0.25438
    ITALY.WSSTPH1.2033    0.2318
    ITALY.WSSTPH1.2034    0.2289
    ITALY.WSSTPH1.2035    0.2012
    ITALY.WSSTPH1.2036    0.1872
    ITALY.WSSTPH1.2037    0.1682
    ITALY.WSSTPH1.2038    0.1598
    ITALY.WSSTPH1.2039    0.0548
    ITALY.WSSTPH1.(2040*2060)    0
$offtext
 
    ITALY.WSSTPH1.(2015*2020)    0.43908
    ITALY.WSSTPH1.(2021*2023)    0.43814
    ITALY.WSSTPH1.(2024*2026)    0.42968
    ITALY.WSSTPH1.2027           0.42639
    ITALY.WSSTPH1.2028           0.42437
    ITALY.WSSTPH1.2029           0.34612
    ITALY.WSSTPH1.2030           0.30772
    ITALY.WSSTPH1.2031           0.28765
    ITALY.WSSTPH1.2032           0.23912
    ITALY.WSSTPH1.2033           0.21789
    ITALY.WSSTPH1.2034           0.21517
    ITALY.WSSTPH1.2035           0.18913
    ITALY.WSSTPH1.2036           0.17597
    ITALY.WSSTPH1.2037           0.15811
    ITALY.WSSTPH1.2038           0.15021
    ITALY.WSSTPH1.2039           0.05151
    ITALY.WSSTPH1.(2040*2060)    0
    
    ITALY.WSSTPH1S.(2015*2020) 0.0280266
    ITALY.WSSTPH1S.(2021*2023) 0.0279666
    ITALY.WSSTPH1S.(2024*2026) 0.0274266
    ITALY.WSSTPH1S.2027        0.0272166
    ITALY.WSSTPH1S.2028        0.0270876
    ITALY.WSSTPH1S.2029        0.0220926
    ITALY.WSSTPH1S.2030        0.0196416
    ITALY.WSSTPH1S.2031        0.0183606
    ITALY.WSSTPH1S.2032        0.0152628
    ITALY.WSSTPH1S.2033        0.013908
    ITALY.WSSTPH1S.2034        0.013734
    ITALY.WSSTPH1S.2035        0.012072
    ITALY.WSSTPH1S.2036        0.011232
    ITALY.WSSTPH1S.2037        0.010092
    ITALY.WSSTPH1S.2038        0.009588
    ITALY.WSSTPH1S.2039        0.003288
    ITALY.WSSTPH1S.(2040*2060) 0
    
    ITALY.BATCHG.2015 0
    ITALY.BATCHG.2016 0
    ITALY.BATCHG.2017 0
    ITALY.BATCHG.2018 0.060
    ITALY.BATCHG.2019 0.140
    ITALY.BATCHG.2020 0.230
    ITALY.BATCHG.2021 0.804
    ITALY.BATCHG.2022 1.876
/;

parameter InputActivityRatio(r,t,f,m,y) /
*Rendimento approssimato, internet dice circa 80%, faccio 80% per il grande e 75% per piccolo
    ITALY.HYDSPH2.E2.2.(2015*2060) 1.33
    ITALY.HYDSPH3.E2.2.(2015*2060) 1.25

    ITALY.BFHPFH1.BF.1.(2015*2060) 1.538461538

    ITALY.BMCCPH1.BM.1.2015   2.857142857
    ITALY.BMCCPH1.BM.1.2016   2.826254826
    ITALY.BMCCPH1.BM.1.2017   2.795366795
    ITALY.BMCCPH1.BM.1.2018   2.764478764
    ITALY.BMCCPH1.BM.1.2019   2.733590734
    ITALY.BMCCPH1.BM.1.2020   2.702702703
    ITALY.BMCCPH1.BM.1.2021   2.664990572
    ITALY.BMCCPH1.BM.1.2022   2.627278441
    ITALY.BMCCPH1.BM.1.2023   2.58956631
    ITALY.BMCCPH1.BM.1.2024   2.55185418
    ITALY.BMCCPH1.BM.1.2025   2.514142049
    ITALY.BMCCPH1.BM.1.2026   2.476429918
    ITALY.BMCCPH1.BM.1.2027   2.438717788
    ITALY.BMCCPH1.BM.1.2028   2.401005657
    ITALY.BMCCPH1.BM.1.2029   2.363293526
    ITALY.BMCCPH1.BM.1.2030   2.325581395
    ITALY.BMCCPH1.BM.1.2031   2.305789213
    ITALY.BMCCPH1.BM.1.2032   2.285997031
    ITALY.BMCCPH1.BM.1.2033   2.266204849
    ITALY.BMCCPH1.BM.1.2034   2.246412667
    ITALY.BMCCPH1.BM.1.2035   2.226620485
    ITALY.BMCCPH1.BM.1.2036   2.206828303
    ITALY.BMCCPH1.BM.1.2037   2.187036121
    ITALY.BMCCPH1.BM.1.2038   2.167243939
    ITALY.BMCCPH1.BM.1.2039   2.147451757
    ITALY.BMCCPH1.BM.1.2040   2.127659574
    ITALY.BMCCPH1.BM.1.2041   2.12322695
    ITALY.BMCCPH1.BM.1.2042   2.118794326
    ITALY.BMCCPH1.BM.1.2043   2.114361702
    ITALY.BMCCPH1.BM.1.2044   2.109929078
    ITALY.BMCCPH1.BM.1.2045   2.105496454
    ITALY.BMCCPH1.BM.1.2046   2.10106383
    ITALY.BMCCPH1.BM.1.2047   2.096631206
    ITALY.BMCCPH1.BM.1.2048   2.092198582
    ITALY.BMCCPH1.BM.1.2049   2.087765957
    ITALY.BMCCPH1.BM.1.2050   2.083333333
    ITALY.BMCCPH1.BM.1.2051   2.080833333
    ITALY.BMCCPH1.BM.1.2052   2.078336333
    ITALY.BMCCPH1.BM.1.2053   2.07584233
    ITALY.BMCCPH1.BM.1.2054   2.073351319
    ITALY.BMCCPH1.BM.1.2055   2.070863297
    ITALY.BMCCPH1.BM.1.2056   2.069206607
    ITALY.BMCCPH1.BM.1.2057   2.067551241
    ITALY.BMCCPH1.BM.1.2058   2.0658972
    ITALY.BMCCPH1.BM.1.2059   2.064244483
    ITALY.BMCCPH1.BM.1.2060   2.062593087

    ITALY.BMCHPH3.BM.1.(2015*2060) 3.333333333
    ITALY.BMSTPH3.BM.1.(2015*2060) 3.333333333
    ITALY.BMSTPH3S.BM.1.(2015*2060) 3.333333334

    ITALY.COCHPH3.CO.1.2015   2.564102564
    ITALY.COCHPH3.CO.1.2016   2.539086929
    ITALY.COCHPH3.CO.1.2017   2.514071295
    ITALY.COCHPH3.CO.1.2018   2.48905566
    ITALY.COCHPH3.CO.1.2019   2.464040025
    ITALY.COCHPH3.CO.1.2020   2.43902439
    ITALY.COCHPH3.CO.1.2021   2.433217189
    ITALY.COCHPH3.CO.1.2022   2.427409988
    ITALY.COCHPH3.CO.1.2023   2.421602787
    ITALY.COCHPH3.CO.1.2024   2.415795587
    ITALY.COCHPH3.CO.1.2025   2.409988386
    ITALY.COCHPH3.CO.1.2026   2.404181185
    ITALY.COCHPH3.CO.1.2027   2.398373984
    ITALY.COCHPH3.CO.1.2028   2.392566783
    ITALY.COCHPH3.CO.1.2029   2.386759582
    ITALY.COCHPH3.CO.1.2030   2.380952381
    ITALY.COCHPH3.CO.1.2031   2.375415282
    ITALY.COCHPH3.CO.1.2032   2.369878184
    ITALY.COCHPH3.CO.1.2033   2.364341085
    ITALY.COCHPH3.CO.1.2034   2.358803987
    ITALY.COCHPH3.CO.1.2035   2.353266888
    ITALY.COCHPH3.CO.1.2036   2.34772979
    ITALY.COCHPH3.CO.1.2037   2.342192691
    ITALY.COCHPH3.CO.1.2038   2.336655592
    ITALY.COCHPH3.CO.1.2039   2.331118494
    ITALY.COCHPH3.CO.1.(2040*2060)   2.32558139

    ITALY.COSTPH1.CO.1.2015 2.564102564
    ITALY.COSTPH1.CO.1.2016   2.539086929
    ITALY.COSTPH1.CO.1.2017   2.514071295
    ITALY.COSTPH1.CO.1.2018   2.48905566
    ITALY.COSTPH1.CO.1.2019   2.464040025
    ITALY.COSTPH1.CO.1.2020   2.43902439
    ITALY.COSTPH1.CO.1.2021   2.433217189
    ITALY.COSTPH1.CO.1.2022   2.427409988
    ITALY.COSTPH1.CO.1.2023   2.421602787
    ITALY.COSTPH1.CO.1.2024   2.415795587
    ITALY.COSTPH1.CO.1.2025   2.409988386
    ITALY.COSTPH1.CO.1.2026   2.404181185
    ITALY.COSTPH1.CO.1.2027   2.398373984
    ITALY.COSTPH1.CO.1.2028   2.392566783
    ITALY.COSTPH1.CO.1.2029   2.386759582
    ITALY.COSTPH1.CO.1.2030   2.380952381
    ITALY.COSTPH1.CO.1.2031   2.375415282
    ITALY.COSTPH1.CO.1.2032   2.369878184
    ITALY.COSTPH1.CO.1.2033   2.364341085
    ITALY.COSTPH1.CO.1.2034   2.358803987
    ITALY.COSTPH1.CO.1.2035   2.353266888
    ITALY.COSTPH1.CO.1.2036   2.34772979
    ITALY.COSTPH1.CO.1.2037   2.342192691
    ITALY.COSTPH1.CO.1.2038   2.336655592
    ITALY.COSTPH1.CO.1.2039   2.331118494
    ITALY.COSTPH1.CO.1.2040   2.325581395
    ITALY.COSTPH1.CO.1.2041   2.325581395
    ITALY.COSTPH1.CO.1.2042   2.325581395
    ITALY.COSTPH1.CO.1.2043   2.325581395
    ITALY.COSTPH1.CO.1.2044   2.325581395
    ITALY.COSTPH1.CO.1.2045   2.325581395
    ITALY.COSTPH1.CO.1.2046   2.325581395
    ITALY.COSTPH1.CO.1.2047   2.325581395
    ITALY.COSTPH1.CO.1.2048   2.325581395
    ITALY.COSTPH1.CO.1.2049   2.325581395
    ITALY.COSTPH1.CO.1.2050   2.325581395
    ITALY.COSTPH1.CO.1.2051   2.325581395
    ITALY.COSTPH1.CO.1.2052   2.325581395
    ITALY.COSTPH1.CO.1.2053   2.325581395
    ITALY.COSTPH1.CO.1.2054   2.325581395
    ITALY.COSTPH1.CO.1.2055   2.325581395
    ITALY.COSTPH1.CO.1.2056   2.325581395
    ITALY.COSTPH1.CO.1.2057   2.325581395
    ITALY.COSTPH1.CO.1.2058   2.325581395
    ITALY.COSTPH1.CO.1.2059   2.325581395
    ITALY.COSTPH1.CO.1.2060   2.325581395

    ITALY.COSTPH3.CO.1.2015   2.173913043
    ITALY.COSTPH3.CO.1.2016   2.16466235
    ITALY.COSTPH3.CO.1.2017   2.155411656
    ITALY.COSTPH3.CO.1.2018   2.146160962
    ITALY.COSTPH3.CO.1.2019   2.136910268
    ITALY.COSTPH3.CO.1.2020   2.127659574
    ITALY.COSTPH3.CO.1.2021   2.121870025
    ITALY.COSTPH3.CO.1.2022   2.116080475
    ITALY.COSTPH3.CO.1.2023   2.110290925
    ITALY.COSTPH3.CO.1.2024   2.104501375
    ITALY.COSTPH3.CO.1.2025   2.098711825
    ITALY.COSTPH3.CO.1.2026   2.092922275
    ITALY.COSTPH3.CO.1.2027   2.087132725
    ITALY.COSTPH3.CO.1.2028   2.081343176
    ITALY.COSTPH3.CO.1.2029   2.075553626
    ITALY.COSTPH3.CO.1.2030   2.069764076
    ITALY.COSTPH3.CO.1.2031   2.063974526
    ITALY.COSTPH3.CO.1.2032   2.058184976
    ITALY.COSTPH3.CO.1.2033   2.052395426
    ITALY.COSTPH3.CO.1.2034   2.046605876
    ITALY.COSTPH3.CO.1.2035   2.040816327
    ITALY.COSTPH3.CO.1.2036   2.03877551
    ITALY.COSTPH3.CO.1.2037   2.036736735
    ITALY.COSTPH3.CO.1.2038   2.034699998
    ITALY.COSTPH3.CO.1.2039   2.032665298
    ITALY.COSTPH3.CO.1.(2040*2060)    2.030632633

    ITALY.EL00TD0.E1.1.(2015*2060)    1

    ITALY.GOCVPH2.GO.1.2015   4.347826087
    ITALY.GOCVPH2.GO.1.2016 4.329324699
    ITALY.GOCVPH2.GO.1.2017 4.310823312
    ITALY.GOCVPH2.GO.1.2018 4.292321924
    ITALY.GOCVPH2.GO.1.2019 4.273820537
    ITALY.GOCVPH2.GO.1.2020 4.255319149
    ITALY.GOCVPH2.GO.1.2021 4.248197276
    ITALY.GOCVPH2.GO.1.2022 4.241075403
    ITALY.GOCVPH2.GO.1.2023 4.23395353
    ITALY.GOCVPH2.GO.1.2024 4.226831657
    ITALY.GOCVPH2.GO.1.2025 4.219709784
    ITALY.GOCVPH2.GO.1.2026 4.212587911
    ITALY.GOCVPH2.GO.1.2027 4.205466038
    ITALY.GOCVPH2.GO.1.2028 4.198344165
    ITALY.GOCVPH2.GO.1.2029 4.191222291
    ITALY.GOCVPH2.GO.1.2030 4.184100418
    ITALY.GOCVPH2.GO.1.2031 4.175526442
    ITALY.GOCVPH2.GO.1.2032 4.166952466
    ITALY.GOCVPH2.GO.1.2033 4.15837849
    ITALY.GOCVPH2.GO.1.2034 4.149804513
    ITALY.GOCVPH2.GO.1.2035 4.141230537
    ITALY.GOCVPH2.GO.1.2036 4.132656561
    ITALY.GOCVPH2.GO.1.2037 4.124082585
    ITALY.GOCVPH2.GO.1.2038 4.115508608
    ITALY.GOCVPH2.GO.1.2039 4.106934632
    ITALY.GOCVPH2.GO.1.2040 4.098360656
    ITALY.GOCVPH2.GO.1.2041 4.090131016
    ITALY.GOCVPH2.GO.1.2042 4.081901376
    ITALY.GOCVPH2.GO.1.2043 4.073671736
    ITALY.GOCVPH2.GO.1.2044 4.065442096
    ITALY.GOCVPH2.GO.1.2045 4.057212456
    ITALY.GOCVPH2.GO.1.2046 4.048982817
    ITALY.GOCVPH2.GO.1.2047 4.040753177
    ITALY.GOCVPH2.GO.1.2048 4.032523537
    ITALY.GOCVPH2.GO.1.2049 4.024293897
    ITALY.GOCVPH2.GO.1.2050 4.016064257
    ITALY.GOCVPH2.GO.1.2051 4.012048193
    ITALY.GOCVPH2.GO.1.2052 4.008036145
    ITALY.GOCVPH2.GO.1.2053 4.004028108
    ITALY.GOCVPH2.GO.1.2054 4.00002408
    ITALY.GOCVPH2.GO.1.2055 3.996024056
    ITALY.GOCVPH2.GO.1.2056 3.992028032
    ITALY.GOCVPH2.GO.1.2057 3.988036004
    ITALY.GOCVPH2.GO.1.2058 3.984047968
    ITALY.GOCVPH2.GO.1.2059 3.98006392
    ITALY.GOCVPH2.GO.1.2060 3.976083856

    ITALY.HFCCPH2.HF.1.2015 1.724137931
    ITALY.HFCCPH2.HF.1.2016 1.712643678
    ITALY.HFCCPH2.HF.1.2017 1.701149425
    ITALY.HFCCPH2.HF.1.2018 1.689655172
    ITALY.HFCCPH2.HF.1.2019 1.67816092
    ITALY.HFCCPH2.HF.1.2020 1.666666667
    ITALY.HFCCPH2.HF.1.2021 1.661290323
    ITALY.HFCCPH2.HF.1.2022 1.655913978
    ITALY.HFCCPH2.HF.1.2023 1.650537634
    ITALY.HFCCPH2.HF.1.2024 1.64516129
    ITALY.HFCCPH2.HF.1.2025 1.639784946
    ITALY.HFCCPH2.HF.1.2026 1.634408602
    ITALY.HFCCPH2.HF.1.2027 1.629032258
    ITALY.HFCCPH2.HF.1.2028 1.623655914
    ITALY.HFCCPH2.HF.1.2029 1.61827957
    ITALY.HFCCPH2.HF.1.(2030*2040) 1.612903226
    ITALY.HFCCPH2.HF.1.2041 1.610343062
    ITALY.HFCCPH2.HF.1.2042 1.607782898
    ITALY.HFCCPH2.HF.1.2043 1.605222734
    ITALY.HFCCPH2.HF.1.2044 1.60266257
    ITALY.HFCCPH2.HF.1.2045 1.600102407
    ITALY.HFCCPH2.HF.1.2046 1.597542243
    ITALY.HFCCPH2.HF.1.2047 1.594982079
    ITALY.HFCCPH2.HF.1.2048 1.592421915
    ITALY.HFCCPH2.HF.1.2049 1.589861751
    ITALY.HFCCPH2.HF.1.(2050*2060) 1.587301587
    
    ITALY.HFCCPH2S.HF.1.2015 1.724137932
    ITALY.HFCCPH2S.HF.1.2016 1.712643679
    ITALY.HFCCPH2S.HF.1.2017 1.701149426
    ITALY.HFCCPH2S.HF.1.2018 1.689655173
    ITALY.HFCCPH2S.HF.1.2019 1.67816093
    ITALY.HFCCPH2S.HF.1.2020 1.666666668
    ITALY.HFCCPH2S.HF.1.2021 1.661290324
    ITALY.HFCCPH2S.HF.1.2022 1.655913979
    ITALY.HFCCPH2S.HF.1.2023 1.650537635
    ITALY.HFCCPH2S.HF.1.2024 1.64516130
    ITALY.HFCCPH2S.HF.1.2025 1.639784947
    ITALY.HFCCPH2S.HF.1.2026 1.634408603
    ITALY.HFCCPH2S.HF.1.2027 1.629032259
    ITALY.HFCCPH2S.HF.1.2028 1.623655915
    ITALY.HFCCPH2S.HF.1.2029 1.61827958
    ITALY.HFCCPH2S.HF.1.(2030*2040) 1.612903227
    ITALY.HFCCPH2S.HF.1.2041 1.610343063
    ITALY.HFCCPH2S.HF.1.2042 1.607782899
    ITALY.HFCCPH2S.HF.1.2043 1.605222735
    ITALY.HFCCPH2S.HF.1.2044 1.60266258
    ITALY.HFCCPH2S.HF.1.2045 1.600102408
    ITALY.HFCCPH2S.HF.1.2046 1.597542244
    ITALY.HFCCPH2S.HF.1.2047 1.594982080
    ITALY.HFCCPH2S.HF.1.2048 1.592421916
    ITALY.HFCCPH2S.HF.1.2049 1.589861752
    ITALY.HFCCPH2S.HF.1.(2050*2060) 1.587301588

    ITALY.HFCHPH3.HF.1.(2015*2060) 13.67989056
    ITALY.HFGCPH3.HF.1.(2015*2060) 2.631578947

    ITALY.HFGCPN3.HF.1.(2015*2020)  2.5
    ITALY.HFGCPN3.HF.1.2021 2.48255814
    ITALY.HFGCPN3.HF.1.2022 2.465116279
    ITALY.HFGCPN3.HF.1.2023 2.447674419
    ITALY.HFGCPN3.HF.1.2024 2.430232558
    ITALY.HFGCPN3.HF.1.2025 2.412790698
    ITALY.HFGCPN3.HF.1.2026 2.395348837
    ITALY.HFGCPN3.HF.1.2027 2.377906977
    ITALY.HFGCPN3.HF.1.2028 2.360465116
    ITALY.HFGCPN3.HF.1.2029 2.343023256
    ITALY.HFGCPN3.HF.1.2030 2.325581395
    ITALY.HFGCPN3.HF.1.2031 2.320295983
    ITALY.HFGCPN3.HF.1.2032 2.315010571
    ITALY.HFGCPN3.HF.1.2033 2.309725159
    ITALY.HFGCPN3.HF.1.2034 2.304439746
    ITALY.HFGCPN3.HF.1.2035 2.299154334
    ITALY.HFGCPN3.HF.1.2036 2.293868922
    ITALY.HFGCPN3.HF.1.2037 2.28858351
    ITALY.HFGCPN3.HF.1.2038 2.283298097
    ITALY.HFGCPN3.HF.1.2039 2.278012685
    ITALY.HFGCPN3.HF.1.2040 2.272727273
    ITALY.HFGCPN3.HF.1.2041 2.267676768
    ITALY.HFGCPN3.HF.1.2042 2.262626263
    ITALY.HFGCPN3.HF.1.2043 2.257575758
    ITALY.HFGCPN3.HF.1.2044 2.252525253
    ITALY.HFGCPN3.HF.1.2045 2.247474747
    ITALY.HFGCPN3.HF.1.2046 2.242424242
    ITALY.HFGCPN3.HF.1.2047 2.237373737
    ITALY.HFGCPN3.HF.1.2048 2.232323232
    ITALY.HFGCPN3.HF.1.2049 2.227272727
    ITALY.HFGCPN3.HF.1.(2050*2060)  2.222222222

    ITALY.HFHPFH1.HF.1.(2015*2060) 2.941176471
    ITALY.HFHPPH2.HF.1.(2015*2060) 2.403846154

    ITALY.HFSTPH2.HF.1.(2015*2060) 2.325581395

    ITALY.HFSTPH3.HF.1.2015 2.16466235
    ITALY.HFSTPH3.HF.1.2016 2.16466235
    ITALY.HFSTPH3.HF.1.2017 2.155411656
    ITALY.HFSTPH3.HF.1.2018 2.146160962
    ITALY.HFSTPH3.HF.1.2019 2.136910268
    ITALY.HFSTPH3.HF.1.2020 2.127659574
    ITALY.HFSTPH3.HF.1.2021 2.121870025
    ITALY.HFSTPH3.HF.1.2022 2.116080475
    ITALY.HFSTPH3.HF.1.2023 2.110290925
    ITALY.HFSTPH3.HF.1.2024 2.104501375
    ITALY.HFSTPH3.HF.1.2025 2.098711825
    ITALY.HFSTPH3.HF.1.2026 2.092922275
    ITALY.HFSTPH3.HF.1.2027 2.087132725
    ITALY.HFSTPH3.HF.1.2028 2.081343176
    ITALY.HFSTPH3.HF.1.2029 2.075553626
    ITALY.HFSTPH3.HF.1.2030 2.069764076
    ITALY.HFSTPH3.HF.1.2031 2.063974526
    ITALY.HFSTPH3.HF.1.2032 2.058184976
    ITALY.HFSTPH3.HF.1.2033 2.052395426
    ITALY.HFSTPH3.HF.1.2034 2.046605876
    ITALY.HFSTPH3.HF.1.2035 2.040816327
    ITALY.HFSTPH3.HF.1.2036 2.03877551
    ITALY.HFSTPH3.HF.1.2037 2.036736735
    ITALY.HFSTPH3.HF.1.2038 2.034699998
    ITALY.HFSTPH3.HF.1.2039 2.032665298
    ITALY.HFSTPH3.HF.1.(2040*2060)  2.030632633

    ITALY.NGCCPH2.NG.1.2015 1.724137931
    ITALY.NGCCPH2.NG.1.2016 1.712643678
    ITALY.NGCCPH2.NG.1.2017 1.701149425
    ITALY.NGCCPH2.NG.1.2018 1.689655172
    ITALY.NGCCPH2.NG.1.2019 1.67816092
    ITALY.NGCCPH2.NG.1.2020 1.666666667
    ITALY.NGCCPH2.NG.1.2021 1.661290323
    ITALY.NGCCPH2.NG.1.2022 1.655913978
    ITALY.NGCCPH2.NG.1.2023 1.650537634
    ITALY.NGCCPH2.NG.1.2024 1.64516129
    ITALY.NGCCPH2.NG.1.2025 1.639784946
    ITALY.NGCCPH2.NG.1.2026 1.634408602
    ITALY.NGCCPH2.NG.1.2027 1.629032258
    ITALY.NGCCPH2.NG.1.2028 1.623655914
    ITALY.NGCCPH2.NG.1.2029 1.61827957
    ITALY.NGCCPH2.NG.1.2030 1.612903226
    ITALY.NGCCPH2.NG.1.2031 1.612903226
    ITALY.NGCCPH2.NG.1.2032 1.612903226
    ITALY.NGCCPH2.NG.1.2033 1.612903226
    ITALY.NGCCPH2.NG.1.2034 1.612903226
    ITALY.NGCCPH2.NG.1.2035 1.612903226
    ITALY.NGCCPH2.NG.1.2036 1.612903226
    ITALY.NGCCPH2.NG.1.2037 1.612903226
    ITALY.NGCCPH2.NG.1.2038 1.612903226
    ITALY.NGCCPH2.NG.1.2039 1.612903226
    ITALY.NGCCPH2.NG.1.2040 1.612903226
    ITALY.NGCCPH2.NG.1.2041 1.610343062
    ITALY.NGCCPH2.NG.1.2042 1.607782898
    ITALY.NGCCPH2.NG.1.2043 1.605222734
    ITALY.NGCCPH2.NG.1.2044 1.60266257
    ITALY.NGCCPH2.NG.1.2045 1.600102407
    ITALY.NGCCPH2.NG.1.2046 1.597542243
    ITALY.NGCCPH2.NG.1.2047 1.594982079
    ITALY.NGCCPH2.NG.1.2048 1.592421915
    ITALY.NGCCPH2.NG.1.2049 1.589861751
    ITALY.NGCCPH2.NG.1.(2050*2060)  1.587301587
    
    ITALY.NGCCPH2S.NG.1.2015 1.724137932
    ITALY.NGCCPH2S.NG.1.2016 1.712643679
    ITALY.NGCCPH2S.NG.1.2017 1.701149426
    ITALY.NGCCPH2S.NG.1.2018 1.689655173
    ITALY.NGCCPH2S.NG.1.2019 1.67816093
    ITALY.NGCCPH2S.NG.1.2020 1.666666668
    ITALY.NGCCPH2S.NG.1.2021 1.661290324
    ITALY.NGCCPH2S.NG.1.2022 1.655913979
    ITALY.NGCCPH2S.NG.1.2023 1.650537635
    ITALY.NGCCPH2S.NG.1.2024 1.64516130
    ITALY.NGCCPH2S.NG.1.2025 1.639784947
    ITALY.NGCCPH2S.NG.1.2026 1.634408603
    ITALY.NGCCPH2S.NG.1.2027 1.629032259
    ITALY.NGCCPH2S.NG.1.2028 1.623655915
    ITALY.NGCCPH2S.NG.1.2029 1.61827958
    ITALY.NGCCPH2S.NG.1.(2030*2040) 1.612903227
    ITALY.NGCCPH2S.NG.1.2041 1.610343063
    ITALY.NGCCPH2S.NG.1.2042 1.607782899
    ITALY.NGCCPH2S.NG.1.2043 1.605222735
    ITALY.NGCCPH2S.NG.1.2044 1.60266258
    ITALY.NGCCPH2S.NG.1.2045 1.600102408
    ITALY.NGCCPH2S.NG.1.2046 1.597542244
    ITALY.NGCCPH2S.NG.1.2047 1.594982080
    ITALY.NGCCPH2S.NG.1.2048 1.592421916
    ITALY.NGCCPH2S.NG.1.2049 1.589861752
    ITALY.NGCCPH2S.NG.1.(2050*2060)  1.587301588

    ITALY.NGCHPH3.NG.1.(2015*2060) 2.380952381

    ITALY.NGCHPN3.NG.1.2015 1.754385965
    ITALY.NGCHPN3.NG.1.2016 1.742491823
    ITALY.NGCHPN3.NG.1.2017 1.730597681
    ITALY.NGCHPN3.NG.1.2018 1.718703539
    ITALY.NGCHPN3.NG.1.2019 1.706809396
    ITALY.NGCHPN3.NG.1.2020 1.694915254
    ITALY.NGCHPN3.NG.1.2021 1.689358155
    ITALY.NGCHPN3.NG.1.2022 1.683801056
    ITALY.NGCHPN3.NG.1.2023 1.678243957
    ITALY.NGCHPN3.NG.1.2024 1.672686857
    ITALY.NGCHPN3.NG.1.2025 1.667129758
    ITALY.NGCHPN3.NG.1.2026 1.661572659
    ITALY.NGCHPN3.NG.1.2027 1.65601556
    ITALY.NGCHPN3.NG.1.2028 1.650458461
    ITALY.NGCHPN3.NG.1.2029 1.644901361
    ITALY.NGCHPN3.NG.1.2030 1.639344262
    ITALY.NGCHPN3.NG.1.2031 1.636700159
    ITALY.NGCHPN3.NG.1.2032 1.634056055
    ITALY.NGCHPN3.NG.1.2033 1.631411951
    ITALY.NGCHPN3.NG.1.2034 1.628767848
    ITALY.NGCHPN3.NG.1.2035 1.626123744
    ITALY.NGCHPN3.NG.1.2036 1.62347964
    ITALY.NGCHPN3.NG.1.2037 1.620835537
    ITALY.NGCHPN3.NG.1.2038 1.618191433
    ITALY.NGCHPN3.NG.1.2039 1.615547329
    ITALY.NGCHPN3.NG.1.2040 1.612903226
    ITALY.NGCHPN3.NG.1.2041 1.610343062
    ITALY.NGCHPN3.NG.1.2042 1.607782898
    ITALY.NGCHPN3.NG.1.2043 1.605222734
    ITALY.NGCHPN3.NG.1.2044 1.60266257
    ITALY.NGCHPN3.NG.1.2045 1.600102407
    ITALY.NGCHPN3.NG.1.2046 1.597542243
    ITALY.NGCHPN3.NG.1.2047 1.594982079
    ITALY.NGCHPN3.NG.1.2048 1.592421915
    ITALY.NGCHPN3.NG.1.2049 1.589861751
    ITALY.NGCHPN3.NG.1.(2050*2060)  1.587301587

    ITALY.NGFCFH1.NG.1.(2015*2060) 1.886792453
    ITALY.NGGCPH2.NG.1.(2015*2060) 2.631578947

    ITALY.NGGCPN2.NG.1.(2015*2020)  2.5
    ITALY.NGGCPN2.NG.1.2021 2.48255814
    ITALY.NGGCPN2.NG.1.2022 2.465116279
    ITALY.NGGCPN2.NG.1.2023 2.447674419
    ITALY.NGGCPN2.NG.1.2024 2.430232558
    ITALY.NGGCPN2.NG.1.2025 2.412790698
    ITALY.NGGCPN2.NG.1.2026 2.395348837
    ITALY.NGGCPN2.NG.1.2027 2.377906977
    ITALY.NGGCPN2.NG.1.2028 2.360465116
    ITALY.NGGCPN2.NG.1.2029 2.343023256
    ITALY.NGGCPN2.NG.1.2030 2.325581395
    ITALY.NGGCPN2.NG.1.2031 2.320295983
    ITALY.NGGCPN2.NG.1.2032 2.315010571
    ITALY.NGGCPN2.NG.1.2033 2.309725159
    ITALY.NGGCPN2.NG.1.2034 2.304439746
    ITALY.NGGCPN2.NG.1.2035 2.299154334
    ITALY.NGGCPN2.NG.1.2036 2.293868922
    ITALY.NGGCPN2.NG.1.2037 2.28858351
    ITALY.NGGCPN2.NG.1.2038 2.283298097
    ITALY.NGGCPN2.NG.1.2039 2.278012685
    ITALY.NGGCPN2.NG.1.2040 2.272727273
    ITALY.NGGCPN2.NG.1.2041 2.267676768
    ITALY.NGGCPN2.NG.1.2042 2.262626263
    ITALY.NGGCPN2.NG.1.2043 2.257575758
    ITALY.NGGCPN2.NG.1.2044 2.252525253
    ITALY.NGGCPN2.NG.1.2045 2.247474747
    ITALY.NGGCPN2.NG.1.2046 2.242424242
    ITALY.NGGCPN2.NG.1.2047 2.237373737
    ITALY.NGGCPN2.NG.1.2048 2.232323232
    ITALY.NGGCPN2.NG.1.2049 2.227272727
    ITALY.NGGCPN2.NG.1.(2050*2060)  2.222222222

    ITALY.NGHPFH1.NG.1.(2015*2060) 2.941176471
    ITALY.NGHPPH2.NG.1.(2015*2060) 2.403846154
    ITALY.NGSTPH2.NG.1.(2015*2060) 2.325581395

*ITALY.NUG3PH3.UR.1.(2015*2020)  2.702702703
*ITALY.NUG3PH3.UR.1.2021  2.695590327
*ITALY.NUG3PH3.UR.1.2022  2.688477952
*ITALY.NUG3PH3.UR.1.2023  2.681365576
*ITALY.NUG3PH3.UR.1.2024  2.674253201
*ITALY.NUG3PH3.UR.1.2025  2.667140825
*ITALY.NUG3PH3.UR.1.2026  2.66002845
*ITALY.NUG3PH3.UR.1.2027  2.652916074
*ITALY.NUG3PH3.UR.1.2028  2.645803698
*ITALY.NUG3PH3.UR.1.2029  2.638691323
*ITALY.NUG3PH3.UR.1.(2030*2060)  2.631578947
    ITALY.NUG3PH3.UR.1.(2015*2035)  0
    ITALY.NUG3PH3.UR.1.(2036*2060)  2.631578947
    
    ITALY.NUG3PH3S.UR.1.(2015*2035)  0
    ITALY.NUG3PH3S.UR.1.(2036*2060)  2.631578948

    ITALY.OIRFPH0.OI.1.(2015*2060) 1

    ITALY.WSCHPH2.WS.1.2015   3.703703704
    ITALY.WSCHPH2.WS.1.2016 3.608124253
    ITALY.WSCHPH2.WS.1.2017 3.512544803
    ITALY.WSCHPH2.WS.1.2018 3.416965352
    ITALY.WSCHPH2.WS.1.2019 3.321385902
    ITALY.WSCHPH2.WS.1.2020 3.225806452
    ITALY.WSCHPH2.WS.1.2021 3.197343454
    ITALY.WSCHPH2.WS.1.2022 3.168880455
    ITALY.WSCHPH2.WS.1.2023 3.140417457
    ITALY.WSCHPH2.WS.1.2024 3.111954459
    ITALY.WSCHPH2.WS.1.2025 3.083491461
    ITALY.WSCHPH2.WS.1.2026 3.055028463
    ITALY.WSCHPH2.WS.1.2027 3.026565465
    ITALY.WSCHPH2.WS.1.2028 2.998102467
    ITALY.WSCHPH2.WS.1.2029 2.969639469
    ITALY.WSCHPH2.WS.1.2030 2.941176471
    ITALY.WSCHPH2.WS.1.2031 2.917329094
    ITALY.WSCHPH2.WS.1.2032 2.893481717
    ITALY.WSCHPH2.WS.1.2033 2.86963434
    ITALY.WSCHPH2.WS.1.2034 2.845786963
    ITALY.WSCHPH2.WS.1.2035 2.821939587
    ITALY.WSCHPH2.WS.1.2036 2.79809221
    ITALY.WSCHPH2.WS.1.2037 2.774244833
    ITALY.WSCHPH2.WS.1.2038 2.750397456
    ITALY.WSCHPH2.WS.1.2039 2.726550079
    ITALY.WSCHPH2.WS.1.2040 2.702702703
    ITALY.WSCHPH2.WS.1.2041 2.670527671
    ITALY.WSCHPH2.WS.1.2042 2.638352638
    ITALY.WSCHPH2.WS.1.2043 2.606177606
    ITALY.WSCHPH2.WS.1.2044 2.574002574
    ITALY.WSCHPH2.WS.1.2045 2.541827542
    ITALY.WSCHPH2.WS.1.2046 2.50965251
    ITALY.WSCHPH2.WS.1.2047 2.477477477
    ITALY.WSCHPH2.WS.1.2048 2.445302445
    ITALY.WSCHPH2.WS.1.2049 2.413127413
    ITALY.WSCHPH2.WS.1.(2050*2060)  2.380952381

    ITALY.WSSTPH1.WS.1.2015 2.941176471
    ITALY.WSSTPH1.WS.1.2016 2.924369748
    ITALY.WSSTPH1.WS.1.2017 2.907563025
    ITALY.WSSTPH1.WS.1.2018 2.890756303
    ITALY.WSSTPH1.WS.1.2019 2.87394958
    ITALY.WSSTPH1.WS.1.2020 2.857142857
    ITALY.WSSTPH1.WS.1.2021 2.849206349
    ITALY.WSSTPH1.WS.1.2022 2.841269841
    ITALY.WSSTPH1.WS.1.2023 2.833333333
    ITALY.WSSTPH1.WS.1.2024 2.825396825
    ITALY.WSSTPH1.WS.1.2025 2.817460317
    ITALY.WSSTPH1.WS.1.2026 2.80952381
    ITALY.WSSTPH1.WS.1.2027 2.801587302
    ITALY.WSSTPH1.WS.1.2028 2.793650794
    ITALY.WSSTPH1.WS.1.2029 2.785714286
    ITALY.WSSTPH1.WS.1.2030 2.777777778
    ITALY.WSSTPH1.WS.1.2031 2.763157895
    ITALY.WSSTPH1.WS.1.2032 2.748538012
    ITALY.WSSTPH1.WS.1.2033 2.733918129
    ITALY.WSSTPH1.WS.1.2034 2.719298246
    ITALY.WSSTPH1.WS.1.2035 2.704678363
    ITALY.WSSTPH1.WS.1.2036 2.69005848
    ITALY.WSSTPH1.WS.1.2037 2.675438596
    ITALY.WSSTPH1.WS.1.2038 2.660818713
    ITALY.WSSTPH1.WS.1.2039 2.64619883
    ITALY.WSSTPH1.WS.1.(2040*2060)  2.631578947
    
    ITALY.WSSTPH1S.WS.1.2015 2.941176472
    ITALY.WSSTPH1S.WS.1.2016 2.924369749
    ITALY.WSSTPH1S.WS.1.2017 2.907563026
    ITALY.WSSTPH1S.WS.1.2018 2.890756304
    ITALY.WSSTPH1S.WS.1.2019 2.87394959
    ITALY.WSSTPH1S.WS.1.2020 2.857142858
    ITALY.WSSTPH1S.WS.1.2021 2.849206350
    ITALY.WSSTPH1S.WS.1.2022 2.841269842
    ITALY.WSSTPH1S.WS.1.2023 2.833333334
    ITALY.WSSTPH1S.WS.1.2024 2.825396826
    ITALY.WSSTPH1S.WS.1.2025 2.817460318
    ITALY.WSSTPH1S.WS.1.2026 2.80952382
    ITALY.WSSTPH1S.WS.1.2027 2.801587303
    ITALY.WSSTPH1S.WS.1.2028 2.793650795
    ITALY.WSSTPH1S.WS.1.2029 2.785714287
    ITALY.WSSTPH1S.WS.1.2030 2.777777779
    ITALY.WSSTPH1S.WS.1.2031 2.763157896
    ITALY.WSSTPH1S.WS.1.2032 2.748538013
    ITALY.WSSTPH1S.WS.1.2033 2.733918130
    ITALY.WSSTPH1S.WS.1.2034 2.719298247
    ITALY.WSSTPH1S.WS.1.2035 2.704678364
    ITALY.WSSTPH1S.WS.1.2036 2.69005849
    ITALY.WSSTPH1S.WS.1.2037 2.675438597
    ITALY.WSSTPH1S.WS.1.2038 2.660818714
    ITALY.WSSTPH1S.WS.1.2039 2.64619884
    ITALY.WSSTPH1S.WS.1.(2040*2060)  2.631578948

*carbon capture plants
    ITALY.COCSPN2.CO.1.2015  4.347826087
    ITALY.COCSPN2.CO.1.2016  4.311594203
    ITALY.COCSPN2.CO.1.2017  4.275362319
    ITALY.COCSPN2.CO.1.2018  4.239130435
    ITALY.COCSPN2.CO.1.2019  4.202898551
    ITALY.COCSPN2.CO.1.2020  4.166666667
    ITALY.COCSPN2.CO.1.2021  4.15
    ITALY.COCSPN2.CO.1.2022  4.133333333
    ITALY.COCSPN2.CO.1.2023  4.116666667
    ITALY.COCSPN2.CO.1.2024  4.1
    ITALY.COCSPN2.CO.1.2025  4.083333333
    ITALY.COCSPN2.CO.1.2026  4.066666667
    ITALY.COCSPN2.CO.1.2027  4.05
    ITALY.COCSPN2.CO.1.2028  4.033333333
    ITALY.COCSPN2.CO.1.2029  4.016666667
    ITALY.COCSPN2.CO.1.2030  4
    ITALY.COCSPN2.CO.1.2031  3.957142857
    ITALY.COCSPN2.CO.1.2032  3.914285714
    ITALY.COCSPN2.CO.1.2033   3.871428571
    ITALY.COCSPN2.CO.1.2034   3.828571429
    ITALY.COCSPN2.CO.1.2035   3.785714286
    ITALY.COCSPN2.CO.1.2036   3.742857143
    ITALY.COCSPN2.CO.1.2037   3.7
    ITALY.COCSPN2.CO.1.2038   3.657142857
    ITALY.COCSPN2.CO.1.2039   3.614285714
    ITALY.COCSPN2.CO.1.(2040*2060)   3.571428571

    ITALY.NGCSPN2.NG.1.2015  2.380952
    ITALY.NGCSPN2.NG.1.2016  2.359307
    ITALY.NGCSPN2.NG.1.2017  2.337662
    ITALY.NGCSPN2.NG.1.2018  2.316017
    ITALY.NGCSPN2.NG.1.2019  2.294372
    ITALY.NGCSPN2.NG.1.2020  2.272727
    ITALY.NGCSPN2.NG.1.2021  2.253788
    ITALY.NGCSPN2.NG.1.2022  2.234848
    ITALY.NGCSPN2.NG.1.2023  2.215909
    ITALY.NGCSPN2.NG.1.2024  2.196970
    ITALY.NGCSPN2.NG.1.2025  2.178030
    ITALY.NGCSPN2.NG.1.2026  2.159091
    ITALY.NGCSPN2.NG.1.2027  2.140152
    ITALY.NGCSPN2.NG.1.2028  2.121212
    ITALY.NGCSPN2.NG.1.2029  2.102273
    ITALY.NGCSPN2.NG.1.(2030*2060)  2.083333
    
    ITALY.NGCSPN2S.NG.1.2015  2.380952
    ITALY.NGCSPN2S.NG.1.2016  2.359307
    ITALY.NGCSPN2S.NG.1.2017  2.337662
    ITALY.NGCSPN2S.NG.1.2018  2.316017
    ITALY.NGCSPN2S.NG.1.2019  2.294372
    ITALY.NGCSPN2S.NG.1.2020  2.272727
    ITALY.NGCSPN2S.NG.1.2021  2.253788
    ITALY.NGCSPN2S.NG.1.2022  2.234848
    ITALY.NGCSPN2S.NG.1.2023  2.215909
    ITALY.NGCSPN2S.NG.1.2024  2.196970
    ITALY.NGCSPN2S.NG.1.2025  2.178030
    ITALY.NGCSPN2S.NG.1.2026  2.159091
    ITALY.NGCSPN2S.NG.1.2027  2.140152
    ITALY.NGCSPN2S.NG.1.2028  2.121212
    ITALY.NGCSPN2S.NG.1.2029  2.102273
    ITALY.NGCSPN2S.NG.1.(2030*2060)  2.083333

    ITALY.BMCSPN2.BM.1.2015     4
    ITALY.BMCSPN2.BM.1.2016     3.914285714
    ITALY.BMCSPN2.BM.1.2017     3.828571429
    ITALY.BMCSPN2.BM.1.2018     3.742857143
    ITALY.BMCSPN2.BM.1.2019     3.657142857
    ITALY.BMCSPN2.BM.1.2020     3.571428571
    ITALY.BMCSPN2.BM.1.2021     3.508403361
    ITALY.BMCSPN2.BM.1.2022     3.445378151
    ITALY.BMCSPN2.BM.1.2023     3.382352941
    ITALY.BMCSPN2.BM.1.2024     3.319327731
    ITALY.BMCSPN2.BM.1.2025     3.256302521
    ITALY.BMCSPN2.BM.1.2026     3.193277311
    ITALY.BMCSPN2.BM.1.2027     3.130252101
    ITALY.BMCSPN2.BM.1.2028     3.067226891
    ITALY.BMCSPN2.BM.1.2029     3.004201681
    ITALY.BMCSPN2.BM.1.2030     2.941176471
    ITALY.BMCSPN2.BM.1.2031     2.932773109
    ITALY.BMCSPN2.BM.1.2032     2.924369748
    ITALY.BMCSPN2.BM.1.2033     2.915966387
    ITALY.BMCSPN2.BM.1.2034     2.907563025
    ITALY.BMCSPN2.BM.1.2035     2.899159664
    ITALY.BMCSPN2.BM.1.2036     2.890756303
    ITALY.BMCSPN2.BM.1.2037     2.882352941
    ITALY.BMCSPN2.BM.1.2038     2.87394958
    ITALY.BMCSPN2.BM.1.2039     2.865546218
    ITALY.BMCSPN2.BM.1.2040     2.857142857
    ITALY.BMCSPN2.BM.1.2041     2.834586466
    ITALY.BMCSPN2.BM.1.2042     2.812030075
    ITALY.BMCSPN2.BM.1.2043     2.789473684
    ITALY.BMCSPN2.BM.1.2044     2.766917293
    ITALY.BMCSPN2.BM.1.2045     2.744360902
    ITALY.BMCSPN2.BM.1.2046     2.721804511
    ITALY.BMCSPN2.BM.1.2047     2.69924812
    ITALY.BMCSPN2.BM.1.2048     2.676691729
    ITALY.BMCSPN2.BM.1.2049     2.654135338
    ITALY.BMCSPN2.BM.1.2050     2.631578947
    ITALY.BMCSPN2.BM.1.2051     2.613671935
    ITALY.BMCSPN2.BM.1.2052     2.599434098
    ITALY.BMCSPN2.BM.1.2053     2.588099692
    ITALY.BMCSPN2.BM.1.2054     2.579067761
    ITALY.BMCSPN2.BM.1.2055     2.571864915
    ITALY.BMCSPN2.BM.1.2056     2.566117126
    ITALY.BMCSPN2.BM.1.2057     2.561528144
    ITALY.BMCSPN2.BM.1.2058     2.557862868
    ITALY.BMCSPN2.BM.1.2059     2.554934423
    ITALY.BMCSPN2.BM.1.2060     2.554934423
    
    ITALY.BMCSPN2S.BM.1.2015     4
    ITALY.BMCSPN2S.BM.1.2016     3.914285715
    ITALY.BMCSPN2S.BM.1.2017     3.828571430
    ITALY.BMCSPN2S.BM.1.2018     3.742857144
    ITALY.BMCSPN2S.BM.1.2019     3.657142858
    ITALY.BMCSPN2S.BM.1.2020     3.571428572
    ITALY.BMCSPN2S.BM.1.2021     3.508403362
    ITALY.BMCSPN2S.BM.1.2022     3.445378152
    ITALY.BMCSPN2S.BM.1.2023     3.382352942
    ITALY.BMCSPN2S.BM.1.2024     3.319327732
    ITALY.BMCSPN2S.BM.1.2025     3.256302522
    ITALY.BMCSPN2S.BM.1.2026     3.193277312
    ITALY.BMCSPN2S.BM.1.2027     3.130252102
    ITALY.BMCSPN2S.BM.1.2028     3.067226892
    ITALY.BMCSPN2S.BM.1.2029     3.004201682
    ITALY.BMCSPN2S.BM.1.2030     2.941176472
    ITALY.BMCSPN2S.BM.1.2031     2.932773110
    ITALY.BMCSPN2S.BM.1.2032     2.924369749
    ITALY.BMCSPN2S.BM.1.2033     2.915966388
    ITALY.BMCSPN2S.BM.1.2034     2.907563026
    ITALY.BMCSPN2S.BM.1.2035     2.899159665
    ITALY.BMCSPN2S.BM.1.2036     2.890756304
    ITALY.BMCSPN2S.BM.1.2037     2.882352942
    ITALY.BMCSPN2S.BM.1.2038     2.87394959
    ITALY.BMCSPN2S.BM.1.2039     2.865546219
    ITALY.BMCSPN2S.BM.1.2040     2.857142858
    ITALY.BMCSPN2S.BM.1.2041     2.834586467
    ITALY.BMCSPN2S.BM.1.2042     2.812030076
    ITALY.BMCSPN2S.BM.1.2043     2.789473685
    ITALY.BMCSPN2S.BM.1.2044     2.766917294
    ITALY.BMCSPN2S.BM.1.2045     2.744360903
    ITALY.BMCSPN2S.BM.1.2046     2.721804512
    ITALY.BMCSPN2S.BM.1.2047     2.69924813
    ITALY.BMCSPN2S.BM.1.2048     2.676691730
    ITALY.BMCSPN2S.BM.1.2049     2.654135339
    ITALY.BMCSPN2S.BM.1.2050     2.631578948
    ITALY.BMCSPN2S.BM.1.2051     2.613671936
    ITALY.BMCSPN2S.BM.1.2052     2.599434099
    ITALY.BMCSPN2S.BM.1.2053     2.588099693
    ITALY.BMCSPN2S.BM.1.2054     2.579067762
    ITALY.BMCSPN2S.BM.1.2055     2.571864916
    ITALY.BMCSPN2S.BM.1.2056     2.566117127
    ITALY.BMCSPN2S.BM.1.2057     2.561528145
    ITALY.BMCSPN2S.BM.1.2058     2.557862869
    ITALY.BMCSPN2S.BM.1.2059     2.554934424
    ITALY.BMCSPN2S.BM.1.2060     2.554934424
    
    ITALY.BATCHG.E2.2.(2015*2060) 1.10
/;

parameter OutputActivityRatio(r,t,f,m,y) /
    ITALY.BF00I00.BF.1.(2015*2060)  1
    ITALY.BF00X00.BF.1.(2015*2060)  1
    ITALY.BFHPFH1.E2.1.(2015*2060)  1
    ITALY.BM00I00.BM.1.(2015*2060)  1
    ITALY.BM00X00.BM.1.(2015*2060)  1
    ITALY.BMCCPH1.E1.1.(2015*2060)  1

    ITALY.BMCHPH3.E1.1.(2015*2060)  1
    ITALY.BMSTPH3.E1.1.(2015*2060)  1
    ITALY.BMSTPH3S.E1.1.(2015*2060)  1
    ITALY.CO00I00.CO.1.(2015*2060)  1
    ITALY.CO00X00.CO.1.(2015*2060)  1
    ITALY.COCHPH3.E1.1.(2015*2060)  1
    ITALY.COSTPH1.E1.1.(2015*2060)  1
    ITALY.COSTPH3.E1.1.(2015*2060)  1
    ITALY.EL00TD0.E2.1.(2015*2060)  0.95
    
    ITALY.GO00X00.GO.1.(2015*2060)  1
    ITALY.GOCVPH2.E1.1.(2015*2060)  1
    ITALY.HF00I00.HF.1.(2015*2060)  1
    ITALY.HFCCPH2.E1.1.(2015*2060)  1
    ITALY.HFCCPH2S.E1.1.(2015*2060)  1
    ITALY.HFCHPH3.E1.1.(2015*2060)  1
    ITALY.HFGCPH3.E1.1.(2015*2060)  1
    ITALY.HFGCPN3.E1.1.(2015*2060)  1
    ITALY.HFHPFH1.E2.1.(2015*2060)  1
    ITALY.HFHPPH2.E1.1.(2015*2060)  1
    ITALY.HFSTPH2.E1.1.(2015*2060)  1
    ITALY.HFSTPH3.E1.1.(2015*2060)  1
    ITALY.HYDMPH0.E1.1.(2015*2060)  1
    ITALY.HYDMPH1.E1.1.(2015*2060)  1
    ITALY.HYDMPH2.E1.1.(2015*2060)  1
    ITALY.HYDMPH3.E1.1.(2015*2060)  1
    ITALY.HYDSPH2.E1.1.(2015*2060)  1
    ITALY.HYDSPH3.E1.1.(2015*2060)  1
    ITALY.NG00I00.NG.1.(2015*2060)  1
    ITALY.NG00X00.NG.1.(2015*2060)  1
    ITALY.NGCCPH2.E1.1.(2015*2060)  1
    ITALY.NGCCPH2S.E1.1.(2015*2060)  1
    ITALY.NGCHPH3.E1.1.(2015*2060)  1
    ITALY.NGCHPN3.E1.1.(2015*2060)  1
    ITALY.NGFCFH1.E2.1.(2015*2060)  1
    ITALY.NGGCPH2.E1.1.(2015*2060)  1
    ITALY.NGGCPN2.E1.1.(2015*2060)  1
    ITALY.NGHPFH1.E2.1.(2015*2060)  1
    ITALY.NGHPPH2.E1.1.(2015*2060)  1
    ITALY.NGSTPH2.E1.1.(2015*2060)  1
    ITALY.NUG3PH3.E1.1.(2015*2060)  1
    ITALY.NUG3PH3S.E1.1.(2015*2060)  1
    ITALY.OCWVPH1.E1.1.(2015*2060)  1
    ITALY.OI00I00.OI.1.(2015*2060)  1
    ITALY.OI00X00.OI.1.(2015*2060)  1
    ITALY.OIRFPH0.HF.1.(2015*2060)  1
    ITALY.SODIFH1.E2.1.(2015*2060)  1
    ITALY.SOUTPH2.E1.1.(2015*2060)  1
    ITALY.WIOFPN2.E1.1.(2015*2060)  1
    ITALY.WIOFPN3.E1.1.(2015*2060)  1
    ITALY.WIONPH3.E1.1.(2015*2060)  1
    ITALY.WIONPN3.E1.1.(2015*2060)  1
    ITALY.WS00X00.WS.1.(2015*2060)  1
    ITALY.WSCHPH2.E1.1.(2015*2060)  1
    ITALY.WSSTPH1.E1.1.(2015*2060)  1
    ITALY.WSSTPH1S.E1.1.(2015*2060)  1

    ITALY.BMCSPN2.E1.1.(2015*2060)  1
    ITALY.BMCSPN2S.E1.1.(2015*2060)  1
    ITALY.COCSPN2.E1.1.(2015*2060)  1
    ITALY.NGCSPN2.E1.1.(2015*2060)  1
    ITALY.NGCSPN2S.E1.1.(2015*2060)  1

    ITALY.RIVER.HY.1.(2015*2060) 1
    ITALY.UR00I00.UR.1.(2015*2060) 1
    ITALY.SEA.SE.1.(2015*2060) 1

    ITALY.BATCHG.E1.1.(2015*2060) 1
/;

*By default, assume for imported secondary fuels the same efficiency of the internal refineries
InputActivityRatio(r,'OI00I00','OI',m,y)$(not OutputActivityRatio(r,'OIRFPH0','HF',m,y) eq 0) = 1/OutputActivityRatio(r,'OIRFPH0','HF',m,y);

*------------------------------------------------------------------------
* Parameters - Technology costs
*------------------------------------------------------------------------
parameter CapitalCost /
    ITALY.COCSPN2.2015    2916.813095
    ITALY.COCSPN2.2016    2858.476833
    ITALY.COCSPN2.2017    2800.140571
    ITALY.COCSPN2.2018    2741.80431
    ITALY.COCSPN2.2019    2683.468048
    ITALY.COCSPN2.2020    2625.131786
    ITALY.COCSPN2.2021    2610.54772
    ITALY.COCSPN2.2022    2595.963655
    ITALY.COCSPN2.2023    2581.379589
    ITALY.COCSPN2.2024    2566.795524
    ITALY.COCSPN2.2025    2552.211458
    ITALY.COCSPN2.2026    2537.627393
    ITALY.COCSPN2.2027    2523.043327
    ITALY.COCSPN2.2028    2508.459262
    ITALY.COCSPN2.2029    2493.875196
    ITALY.COCSPN2.(2030*2060) 2479.291131

    ITALY.BMCSPN2.2015    3014.040198
    ITALY.BMCSPN2.2016    2972.232544
    ITALY.BMCSPN2.2017    2930.42489
    ITALY.BMCSPN2.2018    2888.617235
    ITALY.BMCSPN2.2019    2846.809581
    ITALY.BMCSPN2.2020    2805.001927
    ITALY.BMCSPN2.2021    2799.1683
    ITALY.BMCSPN2.2022    2793.334674
    ITALY.BMCSPN2.2023    2787.501048
    ITALY.BMCSPN2.2024    2781.667422
    ITALY.BMCSPN2.2025    2775.833796
    ITALY.BMCSPN2.2026    2770.000169
    ITALY.BMCSPN2.2027    2764.166543
    ITALY.BMCSPN2.2028    2758.332917
    ITALY.BMCSPN2.2029    2752.499291
    ITALY.BMCSPN2.(2030*2060) 2746.665665

    ITALY.NGCSPN2.(2015*2030) 1530.1125

    ITALY.BFHPFH1.2015 4966.896226
    ITALY.BFHPFH1.2016    4934.20733
    ITALY.BFHPFH1.2017    4901.518433
    ITALY.BFHPFH1.2018    4868.829537
    ITALY.BFHPFH1.2019    4836.14064
    ITALY.BFHPFH1.2020    4803.451744
    ITALY.BFHPFH1.2021    4788.317995
    ITALY.BFHPFH1.2022    4773.184247
    ITALY.BFHPFH1.2023    4758.050498
    ITALY.BFHPFH1.2024    4742.91675
    ITALY.BFHPFH1.2025    4727.783002
    ITALY.BFHPFH1.2026    4712.649253
    ITALY.BFHPFH1.2027    4697.515505
    ITALY.BFHPFH1.2028    4682.381756
    ITALY.BFHPFH1.2029    4667.248008
    ITALY.BFHPFH1.2030    4652.11426
    ITALY.BFHPFH1.2031    4636.980511
    ITALY.BFHPFH1.2032    4621.846763
    ITALY.BFHPFH1.2033    4606.713014
    ITALY.BFHPFH1.2034    4591.579266
    ITALY.BFHPFH1.2035    4576.445518
    ITALY.BFHPFH1.2036    4574.157295
    ITALY.BFHPFH1.2037    4571.870216
    ITALY.BFHPFH1.2038    4569.584281
    ITALY.BFHPFH1.2039    4567.299489
    ITALY.BFHPFH1.2040    4565.015839
    ITALY.BFHPFH1.2041    4562.733331
    ITALY.BFHPFH1.2042    4560.451965
    ITALY.BFHPFH1.2043    4558.171739
    ITALY.BFHPFH1.2044    4555.892653
    ITALY.BFHPFH1.2045    4553.614706
    ITALY.BFHPFH1.2046    4551.337899
    ITALY.BFHPFH1.2047    4549.06223
    ITALY.BFHPFH1.2048    4546.787699
    ITALY.BFHPFH1.2049    4544.514305
    ITALY.BFHPFH1.2050    4542.242048
    ITALY.BFHPFH1.2051    4539.970927
    ITALY.BFHPFH1.2052    4537.700941
    ITALY.BFHPFH1.2053    4535.432091
    ITALY.BFHPFH1.2054    4533.164375
    ITALY.BFHPFH1.2055    4530.897793
    ITALY.BFHPFH1.2056    4528.632344
    ITALY.BFHPFH1.2057    4526.368028
    ITALY.BFHPFH1.2058    4524.104844
    ITALY.BFHPFH1.2059    4521.842791
    ITALY.BFHPFH1.2060    4519.58187

    ITALY.BMCCPH1.2015    4676.623663
    ITALY.BMCCPH1.2016    4500.089005
    ITALY.BMCCPH1.2017    4323.554348
    ITALY.BMCCPH1.2018    4147.01969
    ITALY.BMCCPH1.2019    3970.485033
    ITALY.BMCCPH1.2020    3793.950375
    ITALY.BMCCPH1.2021    3727.232613
    ITALY.BMCCPH1.2022    3660.51485
    ITALY.BMCCPH1.2023    3593.797088
    ITALY.BMCCPH1.2024    3527.079325
    ITALY.BMCCPH1.2025    3460.361563
    ITALY.BMCCPH1.2026    3393.6438
    ITALY.BMCCPH1.2027    3326.926038
    ITALY.BMCCPH1.2028    3260.208275
    ITALY.BMCCPH1.2029    3193.490513
    ITALY.BMCCPH1.2030    3126.77275
    ITALY.BMCCPH1.2031    3096.899125
    ITALY.BMCCPH1.2032    3067.0255
    ITALY.BMCCPH1.2033    3037.151875
    ITALY.BMCCPH1.2034    3007.27825
    ITALY.BMCCPH1.2035    2977.404625
    ITALY.BMCCPH1.2036    2947.531
    ITALY.BMCCPH1.2037    2917.657375
    ITALY.BMCCPH1.2038    2887.78375
    ITALY.BMCCPH1.2039    2857.910125
    ITALY.BMCCPH1.2040    2828.0365
    ITALY.BMCCPH1.2041    2800.15445
    ITALY.BMCCPH1.2042    2772.2724
    ITALY.BMCCPH1.2043    2744.39035
    ITALY.BMCCPH1.2044    2716.5083
    ITALY.BMCCPH1.2045    2688.62625
    ITALY.BMCCPH1.2046    2660.7442
    ITALY.BMCCPH1.2047    2632.86215
    ITALY.BMCCPH1.2048    2604.9801
    ITALY.BMCCPH1.2049    2577.09805
    ITALY.BMCCPH1.2050    2549.216
    ITALY.BMCCPH1.2051    2528.822272
    ITALY.BMCCPH1.2052    2508.591694
    ITALY.BMCCPH1.2053    2488.52296
    ITALY.BMCCPH1.2054    2468.614777
    ITALY.BMCCPH1.2055    2448.865858
    ITALY.BMCCPH1.2056    2436.621529
    ITALY.BMCCPH1.2057    2424.438421
    ITALY.BMCCPH1.2058    2412.316229
    ITALY.BMCCPH1.2059    2400.254648
    ITALY.BMCCPH1.2060    2388.253375

    ITALY.BMCHPH3.2015    3654.540125
    ITALY.BMCHPH3.2016    3565.330981
    ITALY.BMCHPH3.2017    3476.121837
    ITALY.BMCHPH3.2018    3386.912693
    ITALY.BMCHPH3.2019    3297.703549
    ITALY.BMCHPH3.2020    3208.494405
    ITALY.BMCHPH3.2021    3178.354003
    ITALY.BMCHPH3.2022    3148.213601
    ITALY.BMCHPH3.2023    3118.073199
    ITALY.BMCHPH3.2024    3087.932797
    ITALY.BMCHPH3.2025    3057.792395
    ITALY.BMCHPH3.2026    3027.651993
    ITALY.BMCHPH3.2027    2997.511591
    ITALY.BMCHPH3.2028    2967.371189
    ITALY.BMCHPH3.2029    2937.230787
    ITALY.BMCHPH3.2030    2907.090385
    ITALY.BMCHPH3.2031    2883.75588
    ITALY.BMCHPH3.2032    2860.421375
    ITALY.BMCHPH3.2033    2837.086871
    ITALY.BMCHPH3.2034    2813.752366
    ITALY.BMCHPH3.2035    2790.417861
    ITALY.BMCHPH3.2036    2767.083356
    ITALY.BMCHPH3.2037    2743.748852
    ITALY.BMCHPH3.2038    2720.414347
    ITALY.BMCHPH3.2039    2697.079842
    ITALY.BMCHPH3.2040    2673.745337
    ITALY.BMCHPH3.2041    2653.327646
    ITALY.BMCHPH3.2042    2632.909954
    ITALY.BMCHPH3.2043    2612.492262
    ITALY.BMCHPH3.2044    2592.074571
    ITALY.BMCHPH3.2045    2571.656879
    ITALY.BMCHPH3.2046    2551.239187
    ITALY.BMCHPH3.2047    2530.821496
    ITALY.BMCHPH3.2048    2510.403804
    ITALY.BMCHPH3.2049    2489.986112
    ITALY.BMCHPH3.2050    2469.568421
    ITALY.BMCHPH3.2051    2459.568421
    ITALY.BMCHPH3.2052    2449.568421
    ITALY.BMCHPH3.2053    2439.568421
    ITALY.BMCHPH3.2054    2429.568421
    ITALY.BMCHPH3.2055    2419.568421
    ITALY.BMCHPH3.2056    2409.568421
    ITALY.BMCHPH3.2057    2399.568421
    ITALY.BMCHPH3.2058    2389.568421
    ITALY.BMCHPH3.2059    2379.568421
    ITALY.BMCHPH3.2060    2369.568421

    ITALY.BMSTPH3.2015    2110.062859
    ITALY.BMSTPH3.2016    2094.1044
    ITALY.BMSTPH3.2017    2078.145942
    ITALY.BMSTPH3.2018    2062.187483
    ITALY.BMSTPH3.2019    2046.229024
    ITALY.BMSTPH3.2020    2030.270566
    ITALY.BMSTPH3.2021    2023.177918
    ITALY.BMSTPH3.2022    2016.085269
    ITALY.BMSTPH3.2023    2008.992621
    ITALY.BMSTPH3.2024    2001.899973
    ITALY.BMSTPH3.2025    1994.807325
    ITALY.BMSTPH3.2026    1987.714676
    ITALY.BMSTPH3.2027    1980.622028
    ITALY.BMSTPH3.2028    1973.52938
    ITALY.BMSTPH3.2029    1966.436731
    ITALY.BMSTPH3.2030    1959.344083
    ITALY.BMSTPH3.2031    1952.251435
    ITALY.BMSTPH3.2032    1945.158787
    ITALY.BMSTPH3.2033    1938.066138
    ITALY.BMSTPH3.2034    1930.97349
    ITALY.BMSTPH3.2035    1923.880842
    ITALY.BMSTPH3.2036    1921.956961
    ITALY.BMSTPH3.2037    1920.035004
    ITALY.BMSTPH3.2038    1918.114969
    ITALY.BMSTPH3.2039    1916.196854
    ITALY.BMSTPH3.2040    1914.280657
    ITALY.BMSTPH3.2041    1912.366377
    ITALY.BMSTPH3.2042    1910.45401
    ITALY.BMSTPH3.2043    1908.543556
    ITALY.BMSTPH3.2044    1906.635013
    ITALY.BMSTPH3.2045    1904.728378
    ITALY.BMSTPH3.2046    1902.823649
    ITALY.BMSTPH3.2047    1900.920826
    ITALY.BMSTPH3.2048    1899.019905
    ITALY.BMSTPH3.2049    1897.120885
    ITALY.BMSTPH3.2050    1895.223764
    ITALY.BMSTPH3.2051    1893.32854
    ITALY.BMSTPH3.2052    1891.435212
    ITALY.BMSTPH3.2053    1889.543776
    ITALY.BMSTPH3.2054    1887.654233
    ITALY.BMSTPH3.2055    1885.766578
    ITALY.BMSTPH3.2056    1883.880812
    ITALY.BMSTPH3.2057    1881.996931
    ITALY.BMSTPH3.2058    1880.114934
    ITALY.BMSTPH3.2059    1878.234819
    ITALY.BMSTPH3.2060    1876.356584

    ITALY.COCHPH3.(2015*2060)    1973.710194

    ITALY.COSTPH1.(2015*2060)    1507.187756

    ITALY.COSTPH3.(2015*2060)    1950.478273

    ITALY.GOCVPH2.(2015*2019)    5506.704875
    ITALY.GOCVPH2.2020    4949.063875
    ITALY.GOCVPH2.2021    4899.2745
    ITALY.GOCVPH2.2022    4849.485125
    ITALY.GOCVPH2.2023    4799.69575
    ITALY.GOCVPH2.2024    4749.906375
    ITALY.GOCVPH2.2025    4700.117
    ITALY.GOCVPH2.2026    4650.327625
    ITALY.GOCVPH2.2027    4600.53825
    ITALY.GOCVPH2.2028    4550.748875
    ITALY.GOCVPH2.2029    4500.9595
    ITALY.GOCVPH2.2030    4451.170125
    ITALY.GOCVPH2.2031    4406.359688
    ITALY.GOCVPH2.2032    4361.54925
    ITALY.GOCVPH2.2033    4316.738813
    ITALY.GOCVPH2.2034    4271.928375
    ITALY.GOCVPH2.2035    4227.117938
    ITALY.GOCVPH2.2036    4182.3075
    ITALY.GOCVPH2.2037    4137.497063
    ITALY.GOCVPH2.2038    4092.686625
    ITALY.GOCVPH2.2039    4047.876188
    ITALY.GOCVPH2.2040    4003.06575
    ITALY.GOCVPH2.2041    3962.238463
    ITALY.GOCVPH2.2042    3921.411175
    ITALY.GOCVPH2.2043    3880.583888
    ITALY.GOCVPH2.2044    3839.7566
    ITALY.GOCVPH2.2045    3798.929313
    ITALY.GOCVPH2.2046    3758.102025
    ITALY.GOCVPH2.2047    3717.274738
    ITALY.GOCVPH2.2048    3676.44745
    ITALY.GOCVPH2.2049    3635.620163
    ITALY.GOCVPH2.(2050*2060)    3594.792875

    ITALY.HFCCPH2.(2015*2060)    826.430377

    ITALY.HFCHPH3.(2015*2060)    572.1540388

    ITALY.HFGCPH3.(2015*2060)    748.6486944

    ITALY.HFGCPN3.(2015*2060)    534.7490675

    ITALY.HFHPFH1.(2015*2060)    2016.63421

    ITALY.HFHPPH2.(2015*2060)    1313.562192

    ITALY.HFSTPH2.(2015*2060)    1773.162066

    ITALY.HFSTPH3.(2015*2060)    1950.478273

    ITALY.HYDMPH0.2015    5222.239321
    ITALY.HYDMPH0.2016    5241.229282
    ITALY.HYDMPH0.2017    5260.219243
    ITALY.HYDMPH0.2018    5279.209205
    ITALY.HYDMPH0.2019    5298.199166
    ITALY.HYDMPH0.2020    5317.189127
    ITALY.HYDMPH0.2021    5319.088123
    ITALY.HYDMPH0.2022    5320.987119
    ITALY.HYDMPH0.2023    5322.886115
    ITALY.HYDMPH0.2024    5324.785111
    ITALY.HYDMPH0.2025    5326.684108
    ITALY.HYDMPH0.2026    5328.583104
    ITALY.HYDMPH0.2027    5330.4821
    ITALY.HYDMPH0.2028    5332.381096
    ITALY.HYDMPH0.2029    5334.280092
    ITALY.HYDMPH0.(2030*2060)    5336.179088

    ITALY.HYDMPH1.2015    4177.791457
    ITALY.HYDMPH1.2016    4192.983426
    ITALY.HYDMPH1.2017    4208.175395
    ITALY.HYDMPH1.2018    4223.367364
    ITALY.HYDMPH1.2019    4238.559333
    ITALY.HYDMPH1.2020    4253.751302
    ITALY.HYDMPH1.2021    4255.650298
    ITALY.HYDMPH1.2022    4257.549294
    ITALY.HYDMPH1.2023    4259.44829
    ITALY.HYDMPH1.2024    4261.347286
    ITALY.HYDMPH1.2025    4263.246282
    ITALY.HYDMPH1.2026    4265.145278
    ITALY.HYDMPH1.2027    4267.044274
    ITALY.HYDMPH1.2028    4268.943271
    ITALY.HYDMPH1.2029    4270.842267
    ITALY.HYDMPH1.(2030*2060)    4272.741263

    ITALY.HYDMPH2.2015    3133.343593
    ITALY.HYDMPH2.2016    3144.737569
    ITALY.HYDMPH2.2017    3156.131546
    ITALY.HYDMPH2.2018    3167.525523
    ITALY.HYDMPH2.2019    3178.919499
    ITALY.HYDMPH2.2020    3190.313476
    ITALY.HYDMPH2.2021    3191.262974
    ITALY.HYDMPH2.2022    3192.212472
    ITALY.HYDMPH2.2023    3193.16197
    ITALY.HYDMPH2.2024    3194.111468
    ITALY.HYDMPH2.2025    3195.060966
    ITALY.HYDMPH2.2026    3196.010465
    ITALY.HYDMPH2.2027    3196.959963
    ITALY.HYDMPH2.2028    3197.909461
    ITALY.HYDMPH2.2029    3198.858959
    ITALY.HYDMPH2.(2030*2060)    3199.808457

    ITALY.HYDMPH3.(2015*2060)    2088.895728

    ITALY.HYDSPH2.2015    3133.343593
    ITALY.HYDSPH2.2016    3144.737569
    ITALY.HYDSPH2.2017    3156.131546
    ITALY.HYDSPH2.2018    3167.525523
    ITALY.HYDSPH2.2019    3178.919499
    ITALY.HYDSPH2.2020    3190.313476
    ITALY.HYDSPH2.2021    3191.262974
    ITALY.HYDSPH2.2022    3192.212472
    ITALY.HYDSPH2.2023    3193.16197
    ITALY.HYDSPH2.2024    3194.111468
    ITALY.HYDSPH2.2025    3195.060966
    ITALY.HYDSPH2.2026    3196.010465
    ITALY.HYDSPH2.2027    3196.959963
    ITALY.HYDSPH2.2028    3197.909461
    ITALY.HYDSPH2.2029    3198.858959
    ITALY.HYDSPH2.(2030*2060)    3199.808457

    ITALY.HYDSPH3.(2015*2060)    2088.895728

    ITALY.NGCCPH2.(2015*2060)    826.430377

    ITALY.NGCHPH3.(2015*2060)    876.293

    ITALY.NGCHPN3.2015    1005.745375
    ITALY.NGCHPN3.2016    1003.7538
    ITALY.NGCHPN3.2017    1001.762225
    ITALY.NGCHPN3.2018    999.77065
    ITALY.NGCHPN3.2019    997.779075
    ITALY.NGCHPN3.2020    995.7875
    ITALY.NGCHPN3.2021    994.7917125
    ITALY.NGCHPN3.2022    993.795925
    ITALY.NGCHPN3.2023    992.8001375
    ITALY.NGCHPN3.2024    991.80435
    ITALY.NGCHPN3.2025    990.8085625
    ITALY.NGCHPN3.2026    989.812775
    ITALY.NGCHPN3.2027    988.8169875
    ITALY.NGCHPN3.2028    987.8212
    ITALY.NGCHPN3.2029    986.8254125
    ITALY.NGCHPN3.2030    985.829625
    ITALY.NGCHPN3.2031    984.8338375
    ITALY.NGCHPN3.2032    983.83805
    ITALY.NGCHPN3.2033    982.8422625
    ITALY.NGCHPN3.2034    981.846475
    ITALY.NGCHPN3.2035    980.8506875
    ITALY.NGCHPN3.2036    979.8549
    ITALY.NGCHPN3.2037    978.8591125
    ITALY.NGCHPN3.2038    977.863325
    ITALY.NGCHPN3.2039    976.8675375
    ITALY.NGCHPN3.2040    975.87175
    ITALY.NGCHPN3.2041    974.8759625
    ITALY.NGCHPN3.2042    973.880175
    ITALY.NGCHPN3.2043    972.8843875
    ITALY.NGCHPN3.2044    971.8886
    ITALY.NGCHPN3.2045    970.8928125
    ITALY.NGCHPN3.2046    969.897025
    ITALY.NGCHPN3.2047    968.9012375
    ITALY.NGCHPN3.2048    967.90545
    ITALY.NGCHPN3.2049    966.9096625
    ITALY.NGCHPN3.(2050*2060)    965.913875

    ITALY.NGFCFH1.2015    17924.175
    ITALY.NGFCFH1.2016    15594.03225
    ITALY.NGFCFH1.2017    13263.8895
    ITALY.NGFCFH1.2018    10933.74675
    ITALY.NGFCFH1.2019    8603.604
    ITALY.NGFCFH1.2020    6273.46125
    ITALY.NGFCFH1.2021    6044.430125
    ITALY.NGFCFH1.2022    5815.399
    ITALY.NGFCFH1.2023    5586.367875
    ITALY.NGFCFH1.2024    5357.33675
    ITALY.NGFCFH1.2025    5128.305625
    ITALY.NGFCFH1.2026    4899.2745
    ITALY.NGFCFH1.2027    4670.243375
    ITALY.NGFCFH1.2028    4441.21225
    ITALY.NGFCFH1.2029    4212.181125
    ITALY.NGFCFH1.2030    3983.15
    ITALY.NGFCFH1.2031    3838.760813
    ITALY.NGFCFH1.2032    3694.371625
    ITALY.NGFCFH1.2033    3549.982438
    ITALY.NGFCFH1.2034    3405.59325
    ITALY.NGFCFH1.2035    3261.204063
    ITALY.NGFCFH1.2036    3116.814875
    ITALY.NGFCFH1.2037    2972.425688
    ITALY.NGFCFH1.2038    2828.0365
    ITALY.NGFCFH1.2039    2683.647313
    ITALY.NGFCFH1.2040    2539.258125
    ITALY.NGFCFH1.2041    2469.553
    ITALY.NGFCFH1.2042    2399.847875
    ITALY.NGFCFH1.2043    2330.14275
    ITALY.NGFCFH1.2044    2260.437625
    ITALY.NGFCFH1.2045    2190.7325
    ITALY.NGFCFH1.2046    2121.027375
    ITALY.NGFCFH1.2047    2051.32225
    ITALY.NGFCFH1.2048    1981.617125
    ITALY.NGFCFH1.2049    1911.912
    ITALY.NGFCFH1.(2050*2060)    1842.206875

    ITALY.NGGCPH2.(2015*2060)    748.6486944

    ITALY.NGGCPN2.(2015*2060)    534.7490675

    ITALY.NGHPFH1.(2015*2060)    2016.63421

    ITALY.NGHPPH2.(2015*2060)    1313.562192

    ITALY.NGSTPH2.(2015*2060)    1773.162066

*ITALY.NUG3PH3.2015  4077.349436
*ITALY.NUG3PH3.2016  4149.344799
*ITALY.NUG3PH3.2017  4221.340162
*ITALY.NUG3PH3.2018  4293.335524
*ITALY.NUG3PH3.2019  4365.330887
*ITALY.NUG3PH3.2020  4437.32625
*ITALY.NUG3PH3.2021  4411.824375
*ITALY.NUG3PH3.2022  4386.3225
*ITALY.NUG3PH3.2023  4360.820625
*ITALY.NUG3PH3.2024  4335.31875
*ITALY.NUG3PH3.2025  4309.816875
*ITALY.NUG3PH3.2026  4284.315
*ITALY.NUG3PH3.2027  4258.813125
*ITALY.NUG3PH3.2028  4233.31125
*ITALY.NUG3PH3.2029  4207.809375
*ITALY.NUG3PH3.2030  4182.3075
*ITALY.NUG3PH3.2031  4151.70525
*ITALY.NUG3PH3.2032  4121.103
*ITALY.NUG3PH3.2033  4090.50075
*ITALY.NUG3PH3.2034  4059.8985
*ITALY.NUG3PH3.2035  4029.29625
    ITALY.NUG3PH3.2036  3998.694
    ITALY.NUG3PH3.2037  3968.09175
    ITALY.NUG3PH3.2038  3937.4895
    ITALY.NUG3PH3.2039  3906.88725
    ITALY.NUG3PH3.2040  3876.285
    ITALY.NUG3PH3.2041  3871.184625
    ITALY.NUG3PH3.2042  3866.08425
    ITALY.NUG3PH3.2043  3860.983875
    ITALY.NUG3PH3.2044  3855.8835
    ITALY.NUG3PH3.2045  3850.783125
    ITALY.NUG3PH3.2046  3845.68275
    ITALY.NUG3PH3.2047  3840.582375
    ITALY.NUG3PH3.2048  3835.482
    ITALY.NUG3PH3.2049  3830.381625
    ITALY.NUG3PH3.2050  3825.28125
    ITALY.NUG3PH3.2051  3822.78125
    ITALY.NUG3PH3.2052  3820.28125
    ITALY.NUG3PH3.2053  3817.78125
    ITALY.NUG3PH3.2054  3815.28125
    ITALY.NUG3PH3.2055  3812.78125
    ITALY.NUG3PH3.2056  3810.28125
    ITALY.NUG3PH3.2057  3807.78125
    ITALY.NUG3PH3.2058  3805.28125
    ITALY.NUG3PH3.2059  3802.78125
    ITALY.NUG3PH3.2060  3800.28125

    ITALY.OCWVPH1.(2015*2019)    8621.44237
    ITALY.OCWVPH1.2020    5497.593758
    ITALY.OCWVPH1.2021    5373.209512
    ITALY.OCWVPH1.2022    5248.825267
    ITALY.OCWVPH1.2023    5124.441021
    ITALY.OCWVPH1.2024    5000.056775
    ITALY.OCWVPH1.2025    4875.67253
    ITALY.OCWVPH1.2026    4751.288284
    ITALY.OCWVPH1.2027    4626.904039
    ITALY.OCWVPH1.2028    4502.519793
    ITALY.OCWVPH1.2029    4378.135547
    ITALY.OCWVPH1.2030    4253.751302
    ITALY.OCWVPH1.2031    4079.993157
    ITALY.OCWVPH1.2032    3906.235012
    ITALY.OCWVPH1.2033    3732.476868
    ITALY.OCWVPH1.2034    3558.718723
    ITALY.OCWVPH1.2035    3384.960578
    ITALY.OCWVPH1.2036    3211.202433
    ITALY.OCWVPH1.2037    3037.444289
    ITALY.OCWVPH1.2038    2863.686144
    ITALY.OCWVPH1.2039    2689.927999
    ITALY.OCWVPH1.2040    2516.169855
    ITALY.OCWVPH1.2041    2482.937423
    ITALY.OCWVPH1.2042    2449.704991
    ITALY.OCWVPH1.2043    2416.472559
    ITALY.OCWVPH1.2044    2383.240127
    ITALY.OCWVPH1.2045    2350.007695
    ITALY.OCWVPH1.2046    2316.775262
    ITALY.OCWVPH1.2047    2283.54283
    ITALY.OCWVPH1.2048    2250.310398
    ITALY.OCWVPH1.2049    2217.077966
    ITALY.OCWVPH1.(2050*2060)    2183.845534

    ITALY.SODIFH1.2015    1336.29825
    ITALY.SODIFH1.2016    1293.4551
    ITALY.SODIFH1.2017    1250.61195
    ITALY.SODIFH1.2018    1207.7688
    ITALY.SODIFH1.2019    1164.92565
    ITALY.SODIFH1.2020    1122.0825
    ITALY.SODIFH1.2021    1110.861675
    ITALY.SODIFH1.2022    1099.64085
    ITALY.SODIFH1.2023    1088.420025
    ITALY.SODIFH1.2024    1077.1992
    ITALY.SODIFH1.2025    1065.978375
    ITALY.SODIFH1.2026    1054.75755
    ITALY.SODIFH1.2027    1043.536725
    ITALY.SODIFH1.2028    1032.3159
    ITALY.SODIFH1.2029    1021.095075
    ITALY.SODIFH1.2030    1009.87425
    ITALY.SODIFH1.2031    1003.7538
    ITALY.SODIFH1.2032    997.63335
    ITALY.SODIFH1.2033    991.5129
    ITALY.SODIFH1.2034    985.39245
    ITALY.SODIFH1.2035    979.272
    ITALY.SODIFH1.2036    973.15155
    ITALY.SODIFH1.2037    967.0311
    ITALY.SODIFH1.2038    960.91065
    ITALY.SODIFH1.2039    954.7902
    ITALY.SODIFH1.2040    948.66975
    ITALY.SODIFH1.2041    943.569375
    ITALY.SODIFH1.2042    938.469
    ITALY.SODIFH1.2043    933.368625
    ITALY.SODIFH1.2044    928.26825
    ITALY.SODIFH1.2045    923.167875
    ITALY.SODIFH1.2046    918.0675
    ITALY.SODIFH1.2047    912.967125
    ITALY.SODIFH1.2048    907.86675
    ITALY.SODIFH1.2049    902.766375
    ITALY.SODIFH1.2050    897.666
    ITALY.SODIFH1.2051    893.666
    ITALY.SODIFH1.2052    889.666
    ITALY.SODIFH1.2053    885.666
    ITALY.SODIFH1.2054    881.666
    ITALY.SODIFH1.2055    877.666
    ITALY.SODIFH1.2056    873.666
    ITALY.SODIFH1.2057    869.666
    ITALY.SODIFH1.2058    865.666
    ITALY.SODIFH1.2059    861.666
    ITALY.SODIFH1.2060    857.666

    ITALY.SOUTPH2.2015    1104.271667
    ITALY.SOUTPH2.2016    1064.116333
    ITALY.SOUTPH2.2017    1023.961
    ITALY.SOUTPH2.2018    983.8056667
    ITALY.SOUTPH2.2019    943.6503333
    ITALY.SOUTPH2.2020    903.495
    ITALY.SOUTPH2.2021    894.46005
    ITALY.SOUTPH2.2022    885.4251
    ITALY.SOUTPH2.2023    876.39015
    ITALY.SOUTPH2.2024    867.3552
    ITALY.SOUTPH2.2025    858.32025
    ITALY.SOUTPH2.2026    849.2853
    ITALY.SOUTPH2.2027    840.25035
    ITALY.SOUTPH2.2028    831.2154
    ITALY.SOUTPH2.2029    822.18045
    ITALY.SOUTPH2.2030    813.1455
    ITALY.SOUTPH2.2031    808.1260833
    ITALY.SOUTPH2.2032    803.1066667
    ITALY.SOUTPH2.2033    798.08725
    ITALY.SOUTPH2.2034    793.0678333
    ITALY.SOUTPH2.2035    788.0484167
    ITALY.SOUTPH2.2036    783.029
    ITALY.SOUTPH2.2037    778.0095833
    ITALY.SOUTPH2.2038    772.9901667
    ITALY.SOUTPH2.2039    767.97075
    ITALY.SOUTPH2.2040    762.9513333
    ITALY.SOUTPH2.2041    758.9358
    ITALY.SOUTPH2.2042    754.9202667
    ITALY.SOUTPH2.2043    750.9047333
    ITALY.SOUTPH2.2044    746.8892
    ITALY.SOUTPH2.2045    742.8736667
    ITALY.SOUTPH2.2046    738.8581333
    ITALY.SOUTPH2.2047    734.8426
    ITALY.SOUTPH2.2048    730.8270667
    ITALY.SOUTPH2.2049    726.8115333
    ITALY.SOUTPH2.2050    722.796
    ITALY.SOUTPH2.2051    719.796
    ITALY.SOUTPH2.2052    716.796
    ITALY.SOUTPH2.2053    713.796
    ITALY.SOUTPH2.2054    710.796
    ITALY.SOUTPH2.2055    707.796
    ITALY.SOUTPH2.2056    704.796
    ITALY.SOUTPH2.2057    701.796
    ITALY.SOUTPH2.2058    698.796
    ITALY.SOUTPH2.2059    695.796
    ITALY.SOUTPH2.2060    692.796


*Lowered wind price
ITALY.WIOFPN2.2015    2725.1370704
ITALY.WIOFPN2.2016    2632.4667032
ITALY.WIOFPN2.2017    2539.796336
ITALY.WIOFPN2.2018    2447.1259688
ITALY.WIOFPN2.2019    2354.4556016
ITALY.WIOFPN2.2020    2261.7852344
ITALY.WIOFPN2.2021    2238.2249712
ITALY.WIOFPN2.2022    2214.6647088
ITALY.WIOFPN2.2023    2191.1044456
ITALY.WIOFPN2.2024    2167.5441832
ITALY.WIOFPN2.2025    2143.98392
ITALY.WIOFPN2.2026    2120.4236568
ITALY.WIOFPN2.2027    2096.8633944
ITALY.WIOFPN2.2028    2073.3031312
ITALY.WIOFPN2.2029    2049.7428688
ITALY.WIOFPN2.2030    2026.1826056
ITALY.WIOFPN2.2031    2010.4757640
ITALY.WIOFPN2.2032    1994.7689216
ITALY.WIOFPN2.2033    1979.06208
ITALY.WIOFPN2.2034    1963.3552384
ITALY.WIOFPN2.2035    1947.6483960
ITALY.WIOFPN2.2036    1931.9415544
ITALY.WIOFPN2.2037    1916.234712
ITALY.WIOFPN2.2038    1900.5278704
ITALY.WIOFPN2.2039    1884.8210288
ITALY.WIOFPN2.2040    1869.1141864
ITALY.WIOFPN2.2041    1861.2607656
ITALY.WIOFPN2.2042    1853.4073448
ITALY.WIOFPN2.2043    1845.5539240
ITALY.WIOFPN2.2044    1837.7005032
ITALY.WIOFPN2.2045    1829.8470816
ITALY.WIOFPN2.2046    1821.9936608
ITALY.WIOFPN2.2047    1814.14024
ITALY.WIOFPN2.2048    1806.2868192
ITALY.WIOFPN2.2049    1798.4333984
ITALY.WIOFPN2.(2050*2060)    1790.5799768

    ITALY.WIOFPN3.2015    27251370704
    ITALY.WIOFPN3.2016    26324667032
    ITALY.WIOFPN3.2017    2539796336
    ITALY.WIOFPN3.2018    24471259688
    ITALY.WIOFPN3.2019    23544556016
    ITALY.WIOFPN3.2020    22617852344
    ITALY.WIOFPN3.2021    22382249712
    ITALY.WIOFPN3.2022    22146647088
    ITALY.WIOFPN3.2023    21911044456
    ITALY.WIOFPN3.2024    21675441832
    ITALY.WIOFPN3.2025    214398392
    ITALY.WIOFPN3.2026    21204236568
    ITALY.WIOFPN3.2027    20968633944
    ITALY.WIOFPN3.2028    20733031312  
    ITALY.WIOFPN3.2029    2049.7428688
    ITALY.WIOFPN3.2030    2026.1826056
    ITALY.WIOFPN3.2031    2010.4757640
    ITALY.WIOFPN3.2032    1994.7689216
    ITALY.WIOFPN3.2033    1979.06208
    ITALY.WIOFPN3.2034    1963.3552384
    ITALY.WIOFPN3.2035    1947.6483960
    ITALY.WIOFPN3.2036    1931.9415544
    ITALY.WIOFPN3.2037    1916.234712
    ITALY.WIOFPN3.2038    1900.5278704
    ITALY.WIOFPN3.2039    1884.8210288
    ITALY.WIOFPN3.2040    1869.1141864
    ITALY.WIOFPN3.2041    1861.2607656
    ITALY.WIOFPN3.2042    1853.4073448
    ITALY.WIOFPN3.2043    1845.5539240
    ITALY.WIOFPN3.2044    1837.7005032
    ITALY.WIOFPN3.2045    1829.8470816
    ITALY.WIOFPN3.2046    1821.9936608
    ITALY.WIOFPN3.2047    1814.14024
    ITALY.WIOFPN3.2048    1806.2868192
    ITALY.WIOFPN3.2049    1798.4333984
    ITALY.WIOFPN3.(2050*2060)    1790.5799768
    
ITALY.WIONPH3.2015   1124.3493336
ITALY.WIONPH3.2016   1116.3182664
ITALY.WIONPH3.2017   1108.2872
ITALY.WIONPH3.2018   1100.2561336
ITALY.WIONPH3.2019   1092.2250664
ITALY.WIONPH3.2020   1084.19400
ITALY.WIONPH3.2021   1080.1784664
ITALY.WIONPH3.2022   1076.1629336
ITALY.WIONPH3.2023   1072.147400
ITALY.WIONPH3.2024   1068.1318664
ITALY.WIONPH3.2025   1064.1163336
ITALY.WIONPH3.2026   1060.1008
ITALY.WIONPH3.2027   1056.0852664
ITALY.WIONPH3.2028   1052.0697336
ITALY.WIONPH3.2029   1048.054200
ITALY.WIONPH3.2030   1044.0386664
ITALY.WIONPH3.2031   1036.00760
ITALY.WIONPH3.2032   1027.9765336
ITALY.WIONPH3.2033   1019.9454664
ITALY.WIONPH3.2034   1011.9144
ITALY.WIONPH3.2035   1003.8833336
ITALY.WIONPH3.2036   9958.522664
ITALY.WIONPH3.2037   9878.2120
ITALY.WIONPH3.2038   9797.901336
ITALY.WIONPH3.2039   9717.590664
ITALY.WIONPH3.2040   9637.28
ITALY.WIONPH3.2041   9556.969336
ITALY.WIONPH3.2042   9476.658664
ITALY.WIONPH3.2043   9396.3480
ITALY.WIONPH3.2044   9316.037336
ITALY.WIONPH3.2045   9235.726664
ITALY.WIONPH3.2046   9155.416
ITALY.WIONPH3.2047   9075.105336
ITALY.WIONPH3.2048   8994.794664
ITALY.WIONPH3.2049   8914.4840
ITALY.WIONPH3.(2050*2060)   8834.173336

ITALY.WIONPN3.2015  1124.3493336
ITALY.WIONPN3.2016  1116.3182664
ITALY.WIONPN3.2017  1108.2872
ITALY.WIONPN3.2018  1100.2561336
ITALY.WIONPN3.2019  1092.2250664
ITALY.WIONPN3.2020  1084.19400
ITALY.WIONPN3.2021  1080.1784664
ITALY.WIONPN3.2022  1076.1629336
ITALY.WIONPN3.2023  1072.147400
ITALY.WIONPN3.2024  1068.1318664
ITALY.WIONPN3.2025  1064.1163336
ITALY.WIONPN3.2026  1060.1008
ITALY.WIONPN3.2027  1056.0852664
ITALY.WIONPN3.2028  1052.0697336
ITALY.WIONPN3.2029  1048.054200
ITALY.WIONPN3.2030  1044.0386664
ITALY.WIONPN3.2031  1036.00760
ITALY.WIONPN3.2032  1027.9765336
ITALY.WIONPN3.2033  1019.9454664
ITALY.WIONPN3.2034  1011.9144
ITALY.WIONPN3.2035  1003.8833336
ITALY.WIONPN3.2036  9958.522664
ITALY.WIONPN3.2037  9878.2120
ITALY.WIONPN3.2038  9797.901336
ITALY.WIONPN3.2039  9717.590664
ITALY.WIONPN3.2040  9637.28
ITALY.WIONPN3.2041  9556.969336
ITALY.WIONPN3.2042  9476.658664
ITALY.WIONPN3.2043  9396.3480
ITALY.WIONPN3.2044  9316.037336
ITALY.WIONPN3.2045  9235.726664
ITALY.WIONPN3.2046  9155.416
ITALY.WIONPN3.2047  9075.105336
ITALY.WIONPN3.2048  8994.794664
ITALY.WIONPN3.2049  8914.4840
ITALY.WIONPN3.(2050*2060)   8834.173336
*end of lowered wind price

    ITALY.WSCHPH2.2015    5911.407873
    ITALY.WSCHPH2.2016    5823.90348
    ITALY.WSCHPH2.2017    5736.399087
    ITALY.WSCHPH2.2018    5648.894694
    ITALY.WSCHPH2.2019    5561.390302
    ITALY.WSCHPH2.2020    5473.885909
    ITALY.WSCHPH2.2021    5435.967338
    ITALY.WSCHPH2.2022    5398.048768
    ITALY.WSCHPH2.2023    5360.130198
    ITALY.WSCHPH2.2024    5322.211628
    ITALY.WSCHPH2.2025    5284.293058
    ITALY.WSCHPH2.2026    5246.374487
    ITALY.WSCHPH2.2027    5208.455917
    ITALY.WSCHPH2.2028    5170.537347
    ITALY.WSCHPH2.2029    5132.618777
    ITALY.WSCHPH2.2030    5094.700206
    ITALY.WSCHPH2.2031    5058.726178
    ITALY.WSCHPH2.2032    5022.75215
    ITALY.WSCHPH2.2033    4986.778122
    ITALY.WSCHPH2.2034    4950.804094
    ITALY.WSCHPH2.2035    4914.830065
    ITALY.WSCHPH2.2036    4878.856037
    ITALY.WSCHPH2.2037    4842.882009
    ITALY.WSCHPH2.2038    4806.907981
    ITALY.WSCHPH2.2039    4770.933953
    ITALY.WSCHPH2.2040    4734.959925
    ITALY.WSCHPH2.2041    4702.874981
    ITALY.WSCHPH2.2042    4670.790037
    ITALY.WSCHPH2.2043    4638.705092
    ITALY.WSCHPH2.2044    4606.620148
    ITALY.WSCHPH2.2045    4574.535204
    ITALY.WSCHPH2.2046    4542.45026
    ITALY.WSCHPH2.2047    4510.365316
    ITALY.WSCHPH2.2048    4478.280372
    ITALY.WSCHPH2.2049    4446.195428
    ITALY.WSCHPH2.2050    4414.110484
    ITALY.WSCHPH2.2051    4379.110484
    ITALY.WSCHPH2.2052    4344.110484
    ITALY.WSCHPH2.2053    4309.110484
    ITALY.WSCHPH2.2054    4274.110484
    ITALY.WSCHPH2.2055    4239.110484
    ITALY.WSCHPH2.2056    4204.110484
    ITALY.WSCHPH2.2057    4169.110484
    ITALY.WSCHPH2.2058    4134.110484
    ITALY.WSCHPH2.2059    4099.110484
    ITALY.WSCHPH2.2060    4064.110484

    ITALY.WSSTPH1.2015    2809.863282
    ITALY.WSSTPH1.2016    2757.360646
    ITALY.WSSTPH1.2017    2704.85801
    ITALY.WSSTPH1.2018    2652.355375
    ITALY.WSSTPH1.2019    2599.852739
    ITALY.WSSTPH1.2020    2547.350103
    ITALY.WSSTPH1.2021    2523.043327
    ITALY.WSSTPH1.2022    2498.736552
    ITALY.WSSTPH1.2023    2474.429776
    ITALY.WSSTPH1.2024    2450.123
    ITALY.WSSTPH1.2025    2425.816224
    ITALY.WSSTPH1.2026    2401.509448
    ITALY.WSSTPH1.2027    2377.202673
    ITALY.WSSTPH1.2028    2352.895897
    ITALY.WSSTPH1.2029    2328.589121
    ITALY.WSSTPH1.2030    2304.282345
    ITALY.WSSTPH1.2031    2282.892383
    ITALY.WSSTPH1.2032    2261.50242
    ITALY.WSSTPH1.2033    2240.112457
    ITALY.WSSTPH1.2034    2218.722494
    ITALY.WSSTPH1.2035    2197.332532
    ITALY.WSSTPH1.2036    2175.942569
    ITALY.WSSTPH1.2037    2154.552606
    ITALY.WSSTPH1.2038    2133.162644
    ITALY.WSSTPH1.2039    2111.772681
    ITALY.WSSTPH1.2040    2090.382718
    ITALY.WSSTPH1.2041    2070.937298
    ITALY.WSSTPH1.2042    2051.491877
    ITALY.WSSTPH1.2043    2032.046456
    ITALY.WSSTPH1.2044    2012.601036
    ITALY.WSSTPH1.2045    1993.155615
    ITALY.WSSTPH1.2046    1973.710194
    ITALY.WSSTPH1.2047    1954.264774
    ITALY.WSSTPH1.2048    1934.819353
    ITALY.WSSTPH1.2049    1915.373933
    ITALY.WSSTPH1.2050    1895.928512
    ITALY.WSSTPH1.2051    1874.928512
    ITALY.WSSTPH1.2052    1853.928512
    ITALY.WSSTPH1.2053    1832.928512
    ITALY.WSSTPH1.2054    1811.928512
    ITALY.WSSTPH1.2055    1790.928512
    ITALY.WSSTPH1.2056    1769.928512
    ITALY.WSSTPH1.2057    1748.928512
    ITALY.WSSTPH1.2058    1727.928512
    ITALY.WSSTPH1.2059    1706.928512
    ITALY.WSSTPH1.2060    1685.928512

    ITALY.BATCHG.(2015*2060) 1100
/;

CapitalCost(r,'BMCSPN2S',y)=CapitalCost(r,'BMCSPN2',y)*1.1;
CapitalCost(r,'HFCCPH2S',y)=CapitalCost(r,'HFCCPH2',y)*1.1;
CapitalCost(r,'NGCCPH2S',y)=CapitalCost(r,'NGCCPH2',y)*1.1;
CapitalCost(r,'NGCSPN2S',y)=CapitalCost(r,'NGCSPN2',y)*1.1;
CapitalCost(r,'NUG3PH3S',y)=CapitalCost(r,'NUG3PH3',y)*1.1;
CapitalCost(r,'WSSTPH1S',y)=CapitalCost(r,'WSSTPH1',y)*1.1;

*################################################################################################
parameter VariableCost(r,t,m,y) /
    ITALY.BF00I00.1.2015 27.51234251
    ITALY.BF00I00.1.2016  27.43873938
    ITALY.BF00I00.1.2017  27.36533316
    ITALY.BF00I00.1.2018  27.29212332
    ITALY.BF00I00.1.2019  27.21910934
    ITALY.BF00I00.1.2020  27.13737408
    ITALY.BF00I00.1.2021  27.02162225
    ITALY.BF00I00.1.2022  26.90636414
    ITALY.BF00I00.1.2023  26.79159766
    ITALY.BF00I00.1.2024  26.6773207
    ITALY.BF00I00.1.2025  26.56353118
    ITALY.BF00I00.1.2026  26.45022702
    ITALY.BF00I00.1.2027  26.33740615
    ITALY.BF00I00.1.2028  26.2250665
    ITALY.BF00I00.1.2029  26.11320603
    ITALY.BF00I00.1.2030  25.97985575
    ITALY.BF00I00.1.2031  25.93226889
    ITALY.BF00I00.1.2032  25.88476919
    ITALY.BF00I00.1.2033  25.83735649
    ITALY.BF00I00.1.2034  25.79003064
    ITALY.BF00I00.1.2035  25.74279148
    ITALY.BF00I00.1.2036  25.69563884
    ITALY.BF00I00.1.2037  25.64857257
    ITALY.BF00I00.1.2038  25.60159251
    ITALY.BF00I00.1.2039  25.55469851
    ITALY.BF00I00.1.2040  25.50789039
    ITALY.BF00I00.1.2041  25.46116802
    ITALY.BF00I00.1.2042  25.41453123
    ITALY.BF00I00.1.2043  25.36797986
    ITALY.BF00I00.1.2044  25.32151376
    ITALY.BF00I00.1.2045  25.27513277
    ITALY.BF00I00.1.2046  25.22883673
    ITALY.BF00I00.1.2047  25.1826255
    ITALY.BF00I00.1.2048  25.1364989
    ITALY.BF00I00.1.2049  25.0904568
    ITALY.BF00I00.1.2050  25.02811846
    ITALY.BF00I00.1.2051  25.00309035
    ITALY.BF00I00.1.2052  24.97808726
    ITALY.BF00I00.1.2053  24.95310917
    ITALY.BF00I00.1.2054  24.92815606
    ITALY.BF00I00.1.2055  24.9032279
    ITALY.BF00I00.1.2056  24.89077629
    ITALY.BF00I00.1.2057  24.8783309
    ITALY.BF00I00.1.2058  24.86589174
    ITALY.BF00I00.1.2059  24.85345879
    ITALY.BF00I00.1.2060  24.84103206

    ITALY.BF00X00.1.2015  25.01122047
    ITALY.BF00X00.1.2016  24.94430853
    ITALY.BF00X00.1.2017  24.8775756
    ITALY.BF00X00.1.2018  24.8110212
    ITALY.BF00X00.1.2019  24.74464485
    ITALY.BF00X00.1.2020  24.67034007
    ITALY.BF00X00.1.2021  24.56511113
    ITALY.BF00X00.1.2022  24.46033104
    ITALY.BF00X00.1.2023  24.35599787
    ITALY.BF00X00.1.2024  24.25210973
    ITALY.BF00X00.1.2025  24.14866471
    ITALY.BF00X00.1.2026  24.04566093
    ITALY.BF00X00.1.2027  23.9430965
    ITALY.BF00X00.1.2028  23.84096955
    ITALY.BF00X00.1.2029  23.73927821
    ITALY.BF00X00.1.2030  23.61805069
    ITALY.BF00X00.1.2031  23.5747899
    ITALY.BF00X00.1.2032  23.53160835
    ITALY.BF00X00.1.2033  23.4885059
    ITALY.BF00X00.1.2034  23.4454824
    ITALY.BF00X00.1.2035  23.40253771
    ITALY.BF00X00.1.2036  23.35967167
    ITALY.BF00X00.1.2037  23.31688415
    ITALY.BF00X00.1.2038  23.27417501
    ITALY.BF00X00.1.2039  23.2315441
    ITALY.BF00X00.1.2040  23.18899127
    ITALY.BF00X00.1.2041  23.14651638
    ITALY.BF00X00.1.2042  23.1041193
    ITALY.BF00X00.1.2043  23.06179987
    ITALY.BF00X00.1.2044  23.01955796
    ITALY.BF00X00.1.2045  22.97739342
    ITALY.BF00X00.1.2046  22.93530612
    ITALY.BF00X00.1.2047  22.8932959
    ITALY.BF00X00.1.2048  22.85136264
    ITALY.BF00X00.1.2049  22.80950618
    ITALY.BF00X00.1.2050  22.75283497
    ITALY.BF00X00.1.2051  22.73008213
    ITALY.BF00X00.1.2052  22.70735205
    ITALY.BF00X00.1.2053  22.6846447
    ITALY.BF00X00.1.2054  22.66196005
    ITALY.BF00X00.1.2055  22.63929809
    ITALY.BF00X00.1.2056  22.62797844
    ITALY.BF00X00.1.2057  22.61666446
    ITALY.BF00X00.1.2058  22.60535612
    ITALY.BF00X00.1.2059  22.59405344
    ITALY.BF00X00.1.2060  22.58275642

    ITALY.BM00I00.1.(2015*2060)  4.655510125

    ITALY.BM00X00.1.(2015*2060)  2.327755063

    ITALY.BMCCPH1.1.(2015*2060)  0.008364

    ITALY.BMCHPH3.1.(2015*2060)  0.003366

    ITALY.CO00I00.1.2015  2.61450974
    ITALY.CO00I00.1.2016  2.696567808
    ITALY.CO00I00.1.2017  2.778625877
    ITALY.CO00I00.1.2018  2.860683946
    ITALY.CO00I00.1.2019  2.942742014
    ITALY.CO00I00.1.2020  3.024800083
    ITALY.CO00I00.1.2021  3.102056881
    ITALY.CO00I00.1.2022  3.17931368
    ITALY.CO00I00.1.2023  3.256570479
    ITALY.CO00I00.1.2024  3.333827277
    ITALY.CO00I00.1.2025  3.411084076
    ITALY.CO00I00.1.2026  3.488340875
    ITALY.CO00I00.1.2027  3.565597673
    ITALY.CO00I00.1.2028  3.642854472
    ITALY.CO00I00.1.2029  3.720111271
    ITALY.CO00I00.1.(2030*2060)  3.797368069
    
    ITALY.CO00X00.1.2015  2.353058766
    ITALY.CO00X00.1.2016  2.426911027
    ITALY.CO00X00.1.2017  2.500763289
    ITALY.CO00X00.1.2018  2.574615551
    ITALY.CO00X00.1.2019  2.648467813
    ITALY.CO00X00.1.2020  2.722320074
    ITALY.CO00X00.1.2021  2.791851193
    ITALY.CO00X00.1.2022  2.861382312
    ITALY.CO00X00.1.2023  2.930913431
    ITALY.CO00X00.1.2024  3.00044455
    ITALY.CO00X00.1.2025  3.069975668
    ITALY.CO00X00.1.2026  3.139506787
    ITALY.CO00X00.1.2027  3.209037906
    ITALY.CO00X00.1.2028  3.278569025
    ITALY.CO00X00.1.2029  3.348100144
    ITALY.CO00X00.1.(2030*2060)  3.417631262

    ITALY.COCHPH3.1.(2015*2060)  0.005202

    ITALY.HF00I00.1.2015  8.848033205
    ITALY.HF00I00.1.2016  9.129238908
    ITALY.HF00I00.1.2017  9.410444611
    ITALY.HF00I00.1.2018  9.691650314
    ITALY.HF00I00.1.2019  9.972856017
    ITALY.HF00I00.1.2020  10.25406172
    ITALY.HF00I00.1.2021  10.67628779
    ITALY.HF00I00.1.2022  11.09851386
    ITALY.HF00I00.1.2023  11.52073993
    ITALY.HF00I00.1.2024  11.942966
    ITALY.HF00I00.1.2025  12.36519207
    ITALY.HF00I00.1.2026  12.78741814
    ITALY.HF00I00.1.2027  13.20964421
    ITALY.HF00I00.1.2028  13.63187029
    ITALY.HF00I00.1.2029  14.05409636
    ITALY.HF00I00.1.(2030*2060)  14.47632243

    ITALY.HFCCPH2.1.(2015*2060)  0.00204

    ITALY.HFGCPH3.1.(2015*2060)  0.01326

    ITALY.HFGCPN3.1.(2015*2060)  0.01122

    ITALY.HFHPFH1.1.(2015*2060)  0.015322598

    ITALY.HFHPPH2.1.(2015*2060)  0.015322598

    ITALY.HYDMPH0.1.(2015*2060)  0.0051

    ITALY.HYDMPH1.1.(2015*2060)  0.0051

    ITALY.HYDMPH2.1.(2015*2060)  0.0051

    ITALY.HYDMPH3.1.(2015*2060)  0.00306

    ITALY.HYDSPH2.1.(2015*2060)  0.0051

    ITALY.HYDSPH3.1.(2015*2060)  0.00306

    ITALY.NG00I00.1.2015  6.13753634
    ITALY.NG00I00.1.2016  6.26812222
    ITALY.NG00I00.1.2017  6.3987081
    ITALY.NG00I00.1.2018  6.529293979
    ITALY.NG00I00.1.2019  6.659879859
    ITALY.NG00I00.1.2020  6.790465738
    ITALY.NG00I00.1.2021  6.999403146
    ITALY.NG00I00.1.2022  7.208340553
    ITALY.NG00I00.1.2023  7.41727796
    ITALY.NG00I00.1.2024  7.626215368
    ITALY.NG00I00.1.2025  7.835152775
    ITALY.NG00I00.1.2026  8.044090182
    ITALY.NG00I00.1.2027  8.25302759
    ITALY.NG00I00.1.2028  8.461964997
    ITALY.NG00I00.1.2029  8.670902404
    ITALY.NG00I00.1.(2030*2060)  8.879839812

    ITALY.NG00X00.1.2015  5.523782706
    ITALY.NG00X00.1.2016  5.641309998
    ITALY.NG00X00.1.2017  5.75883729
    ITALY.NG00X00.1.2018  5.876364581
    ITALY.NG00X00.1.2019  5.993891873
    ITALY.NG00X00.1.2020  6.111419164
    ITALY.NG00X00.1.2021  6.299462831
    ITALY.NG00X00.1.2022  6.487506498
    ITALY.NG00X00.1.2023  6.675550164
    ITALY.NG00X00.1.2024  6.863593831
    ITALY.NG00X00.1.2025  7.051637497
    ITALY.NG00X00.1.2026  7.239681164
    ITALY.NG00X00.1.2027  7.427724831
    ITALY.NG00X00.1.2028  7.615768497
    ITALY.NG00X00.1.2029  7.803812164
    ITALY.NG00X00.1.(2030*2060)  7.99185583

    ITALY.NGCCPH2.1.(2015*2060)  0.00204

    ITALY.NGCHPH3.1.(2015*2060)  0.002448

    ITALY.NGCHPN3.1.(2015*2060)  0.00408

    ITALY.NGFCFH1.1.2015  0.1224
    ITALY.NGFCFH1.1.2016  0.11118
    ITALY.NGFCFH1.1.2017  0.09996
    ITALY.NGFCFH1.1.2018  0.08874
    ITALY.NGFCFH1.1.2019  0.07752
    ITALY.NGFCFH1.1.2020  0.0663
    ITALY.NGFCFH1.1.2021  0.06222
    ITALY.NGFCFH1.1.2022  0.05814
    ITALY.NGFCFH1.1.2023  0.05406
    ITALY.NGFCFH1.1.2024  0.04998
    ITALY.NGFCFH1.1.2025  0.0459
    ITALY.NGFCFH1.1.2026  0.04182
    ITALY.NGFCFH1.1.2027  0.03774
    ITALY.NGFCFH1.1.2028  0.03366
    ITALY.NGFCFH1.1.2029  0.02958
    ITALY.NGFCFH1.1.2030  0.0255
    ITALY.NGFCFH1.1.2031  0.02397
    ITALY.NGFCFH1.1.2032  0.02244
    ITALY.NGFCFH1.1.2033  0.02091
    ITALY.NGFCFH1.1.2034  0.01938
    ITALY.NGFCFH1.1.2035  0.01785
    ITALY.NGFCFH1.1.2036  0.01632
    ITALY.NGFCFH1.1.2037  0.01479
    ITALY.NGFCFH1.1.2038  0.01326
    ITALY.NGFCFH1.1.2039  0.01173
    ITALY.NGFCFH1.1.2040  0.0102
    ITALY.NGFCFH1.1.2041  0.009996
    ITALY.NGFCFH1.1.2042  0.009792
    ITALY.NGFCFH1.1.2043  0.009588
    ITALY.NGFCFH1.1.2044  0.009384
    ITALY.NGFCFH1.1.2045  0.00918
    ITALY.NGFCFH1.1.2046  0.008976
    ITALY.NGFCFH1.1.2047  0.008772
    ITALY.NGFCFH1.1.2048  0.008568
    ITALY.NGFCFH1.1.2049  0.008364
    ITALY.NGFCFH1.1.2050  0.00816
    ITALY.NGFCFH1.1.2051  0.00796
    ITALY.NGFCFH1.1.2052  0.00776
    ITALY.NGFCFH1.1.2053  0.00756
    ITALY.NGFCFH1.1.2054  0.00736
    ITALY.NGFCFH1.1.2055  0.00716
    ITALY.NGFCFH1.1.2056  0.00696
    ITALY.NGFCFH1.1.2057  0.00676
    ITALY.NGFCFH1.1.2058  0.00656
    ITALY.NGFCFH1.1.2059  0.00636
    ITALY.NGFCFH1.1.2060  0.00616

    ITALY.NGGCPH2.1.(2015*2060)  0.01326

    ITALY.NGGCPN2.1.(2015*2060)  0.01122

    ITALY.NGHPFH1.1.(2015*2060)  0.015322598

    ITALY.NGHPPH2.1.(2015*2060)  0.015322598

*ITALY.NUG3PH3.1.(2015*2060)  0.00255
    ITALY.NUG3PH3.1.(2036*2060)  0.00255

    ITALY.OI00I00.1.2015  8.848033205
    ITALY.OI00I00.1.2016  9.428685384
    ITALY.OI00I00.1.2017  10.00933756
    ITALY.OI00I00.1.2018  10.58998974
    ITALY.OI00I00.1.2019  11.17064192
    ITALY.OI00I00.1.2020  11.7512941
    ITALY.OI00I00.1.2021  12.23517092
    ITALY.OI00I00.1.2022  12.71904773
    ITALY.OI00I00.1.2023  13.20292455
    ITALY.OI00I00.1.2024  13.68680136
    ITALY.OI00I00.1.2025  14.17067818
    ITALY.OI00I00.1.2026  14.654555
    ITALY.OI00I00.1.2027  15.13843181
    ITALY.OI00I00.1.2028  15.62230863
    ITALY.OI00I00.1.2029  16.10618544
    ITALY.OI00I00.1.(2030*2060)  16.59006226

    ITALY.OI00X00.1.2015  7.963229885
    ITALY.OI00X00.1.2016  8.485816846
    ITALY.OI00X00.1.2017  9.008403807
    ITALY.OI00X00.1.2018  9.530990768
    ITALY.OI00X00.1.2019  10.05357773
    ITALY.OI00X00.1.2020  10.57616469
    ITALY.OI00X00.1.2021  11.01165382
    ITALY.OI00X00.1.2022  11.44714296
    ITALY.OI00X00.1.2023  11.88263209
    ITALY.OI00X00.1.2024  12.31812123
    ITALY.OI00X00.1.2025  12.75361036
    ITALY.OI00X00.1.2026  13.1890995
    ITALY.OI00X00.1.2027  13.62458863
    ITALY.OI00X00.1.2028  14.06007777
    ITALY.OI00X00.1.2029  14.4955669
    ITALY.OI00X00.1.(2030*2060)  14.93105603

    ITALY.WSCHPH2.1.(2015*2060)  0.007038
    ITALY.WSSTPH1.1.(2015*2060)  0.00357

    ITALY.UR00I00.1.(2015*2060)  1.301920122
/;

VariableCost(r,t,m,y)$(VariableCost(r,t,m,y) = 0) = 1e-5;

VariableCost(r,'BMCSPN2S',m,y)=VariableCost(r,'BMCSPN2',m,y)*1.1;
VariableCost(r,'HFCCPH2S',m,y)=VariableCost(r,'HFCCPH2',m,y)*1.1;
VariableCost(r,'NGCCPH2S',m,y)=VariableCost(r,'NGCCPH2',m,y)*1.1;
VariableCost(r,'NGCSPN2S',m,y)=VariableCost(r,'NGCSPN2',m,y)*1.1;
VariableCost(r,'NUG3PH3S',m,y)=VariableCost(r,'NUG3PH3',m,y)*1.1;
VariableCost(r,'WSSTPH1S',m,y)=VariableCost(r,'WSSTPH1',m,y)*1.1;
                


*################################################################################################

parameter FixedCost /
    ITALY.COCSPN2.2015    72.92032738
    ITALY.COCSPN2.2016    71.46192083
    ITALY.COCSPN2.2017    70.00351429
    ITALY.COCSPN2.2018    68.54510774
    ITALY.COCSPN2.2019    67.08670119
    ITALY.COCSPN2.2020    65.62829464
    ITALY.COCSPN2.2021    65.26369301
    ITALY.COCSPN2.2022    64.89909137
    ITALY.COCSPN2.2023    64.53448973
    ITALY.COCSPN2.2024    64.1698881
    ITALY.COCSPN2.2025    63.80528646
    ITALY.COCSPN2.2026    63.44068482
    ITALY.COCSPN2.2027    63.07608318
    ITALY.COCSPN2.2028    62.71148155
    ITALY.COCSPN2.2029    62.34687991
    ITALY.COCSPN2.(2030*2060) 61.98227827

    ITALY.NGCSPN2.(2015*2060) 38.2528125

    ITALY.BMCSPN2.2015    90.42120595
    ITALY.BMCSPN2.2016    89.16697632
    ITALY.BMCSPN2.2017    87.91274669
    ITALY.BMCSPN2.2018    86.65851706
    ITALY.BMCSPN2.2019    85.40428743
    ITALY.BMCSPN2.2020    84.1500578
    ITALY.BMCSPN2.2021    83.97504901
    ITALY.BMCSPN2.2022    83.80004023
    ITALY.BMCSPN2.2023    83.62503144
    ITALY.BMCSPN2.2024    83.45002265
    ITALY.BMCSPN2.2025    83.27501387
    ITALY.BMCSPN2.2026    83.10000508
    ITALY.BMCSPN2.2027    82.9249963
    ITALY.BMCSPN2.2028    82.74998751
    ITALY.BMCSPN2.2029    82.57497873
    ITALY.BMCSPN2.(2030*2060) 82.39996994

    ITALY.BFHPFH1.2015    190.6852299
    ITALY.BFHPFH1.2016    189.3829893
    ITALY.BFHPFH1.2017    188.0807487
    ITALY.BFHPFH1.2018    186.7785081
    ITALY.BFHPFH1.2019    185.4762675
    ITALY.BFHPFH1.2020    184.1740269
    ITALY.BFHPFH1.2021    183.6159238
    ITALY.BFHPFH1.2022    183.0578207
    ITALY.BFHPFH1.2023    182.4997176
    ITALY.BFHPFH1.2024    181.9416145
    ITALY.BFHPFH1.2025    181.3835114
    ITALY.BFHPFH1.2026    180.8254083
    ITALY.BFHPFH1.2027    180.2673051
    ITALY.BFHPFH1.2028    179.709202
    ITALY.BFHPFH1.2029    179.1510989
    ITALY.BFHPFH1.2030    178.5929958
    ITALY.BFHPFH1.2031    178.0348927
    ITALY.BFHPFH1.2032    177.4767896
    ITALY.BFHPFH1.2033    176.9186865
    ITALY.BFHPFH1.2034    176.3605834
    ITALY.BFHPFH1.2035    175.8024802
    ITALY.BFHPFH1.2036    175.2750728
    ITALY.BFHPFH1.2037    174.7492476
    ITALY.BFHPFH1.2038    174.2249998
    ITALY.BFHPFH1.2039    173.7023248
    ITALY.BFHPFH1.2040    173.1812179
    ITALY.BFHPFH1.2041    172.6616742
    ITALY.BFHPFH1.2042    172.1436892
    ITALY.BFHPFH1.2043    171.6272581
    ITALY.BFHPFH1.2044    171.1123764
    ITALY.BFHPFH1.2045    170.5990392
    ITALY.BFHPFH1.2046    170.0872421
    ITALY.BFHPFH1.2047    169.5769804
    ITALY.BFHPFH1.2048    169.0682494
    ITALY.BFHPFH1.2049    168.5610447
    ITALY.BFHPFH1.2050    168.0553616
    ITALY.BFHPFH1.2051    167.5511955
    ITALY.BFHPFH1.2052    167.0485419
    ITALY.BFHPFH1.2053    166.5473963
    ITALY.BFHPFH1.2054    166.0477541
    ITALY.BFHPFH1.2055    165.5496108
    ITALY.BFHPFH1.2056    165.052962
    ITALY.BFHPFH1.2057    164.5578031
    ITALY.BFHPFH1.2058    164.0641297
    ITALY.BFHPFH1.2059    163.5719373
    ITALY.BFHPFH1.2060    163.0812215

    ITALY.BMCCPH1.2015    128.6071507
    ITALY.BMCCPH1.2016    123.7524476
    ITALY.BMCCPH1.2017    118.8977446
    ITALY.BMCCPH1.2018    114.0430415
    ITALY.BMCCPH1.2019    109.1883384
    ITALY.BMCCPH1.2020    104.3336353
    ITALY.BMCCPH1.2021    102.4988968
    ITALY.BMCCPH1.2022    100.6641584
    ITALY.BMCCPH1.2023    98.82941991
    ITALY.BMCCPH1.2024    96.99468144
    ITALY.BMCCPH1.2025    95.15994297
    ITALY.BMCCPH1.2026    93.3252045
    ITALY.BMCCPH1.2027    91.49046603
    ITALY.BMCCPH1.2028    89.65572756
    ITALY.BMCCPH1.2029    87.82098909
    ITALY.BMCCPH1.2030    85.98625063
    ITALY.BMCCPH1.2031    85.16472594
    ITALY.BMCCPH1.2032    84.34320125
    ITALY.BMCCPH1.2033    83.52167656
    ITALY.BMCCPH1.2034    82.70015188
    ITALY.BMCCPH1.2035    81.87862719
    ITALY.BMCCPH1.2036    81.0571025
    ITALY.BMCCPH1.2037    80.23557781
    ITALY.BMCCPH1.2038    79.41405313
    ITALY.BMCCPH1.2039    78.59252844
    ITALY.BMCCPH1.2040    77.77100375
    ITALY.BMCCPH1.2041    77.00424738
    ITALY.BMCCPH1.2042    76.237491
    ITALY.BMCCPH1.2043    75.47073463
    ITALY.BMCCPH1.2044    74.70397825
    ITALY.BMCCPH1.2045    73.93722188
    ITALY.BMCCPH1.2046    73.1704655
    ITALY.BMCCPH1.2047    72.40370913
    ITALY.BMCCPH1.2048    71.63695275
    ITALY.BMCCPH1.2049    70.87019638
    ITALY.BMCCPH1.2050    70.10344
    ITALY.BMCCPH1.2051    69.7529228
    ITALY.BMCCPH1.2052    69.40415819
    ITALY.BMCCPH1.2053    69.0571374
    ITALY.BMCCPH1.2054    68.71185171
    ITALY.BMCCPH1.2055    68.36829245
    ITALY.BMCCPH1.2056    68.23155586
    ITALY.BMCCPH1.2057    68.09509275
    ITALY.BMCCPH1.2058    67.95890257
    ITALY.BMCCPH1.2059    67.82298476
    ITALY.BMCCPH1.2060    67.68733879

    ITALY.BMCHPH3.2015    104.1543936
    ITALY.BMCHPH3.2016    101.611933
    ITALY.BMCHPH3.2017    99.06947235
    ITALY.BMCHPH3.2018    96.52701175
    ITALY.BMCHPH3.2019    93.98455114
    ITALY.BMCHPH3.2020    91.44209054
    ITALY.BMCHPH3.2021    90.58308908
    ITALY.BMCHPH3.2022    89.72408762
    ITALY.BMCHPH3.2023    88.86508617
    ITALY.BMCHPH3.2024    88.00608471
    ITALY.BMCHPH3.2025    87.14708325
    ITALY.BMCHPH3.2026    86.2880818
    ITALY.BMCHPH3.2027    85.42908034
    ITALY.BMCHPH3.2028    84.57007888
    ITALY.BMCHPH3.2029    83.71107743
    ITALY.BMCHPH3.2030    82.85207597
    ITALY.BMCHPH3.2031    82.18704258
    ITALY.BMCHPH3.2032    81.5220092
    ITALY.BMCHPH3.2033    80.85697581
    ITALY.BMCHPH3.2034    80.19194243
    ITALY.BMCHPH3.2035    79.52690904
    ITALY.BMCHPH3.2036    78.86187566
    ITALY.BMCHPH3.2037    78.19684227
    ITALY.BMCHPH3.2038    77.53180888
    ITALY.BMCHPH3.2039    76.8667755
    ITALY.BMCHPH3.2040    76.20174211
    ITALY.BMCHPH3.2041    75.6198379
    ITALY.BMCHPH3.2042    75.03793369
    ITALY.BMCHPH3.2043    74.45602948
    ITALY.BMCHPH3.2044    73.87412526
    ITALY.BMCHPH3.2045    73.29222105
    ITALY.BMCHPH3.2046    72.71031684
    ITALY.BMCHPH3.2047    72.12841263
    ITALY.BMCHPH3.2048    71.54650841
    ITALY.BMCHPH3.2049    70.9646042
    ITALY.BMCHPH3.2050    70.38269999
    ITALY.BMCHPH3.2051    69.88269999
    ITALY.BMCHPH3.2052    69.38269999
    ITALY.BMCHPH3.2053    68.88269999
    ITALY.BMCHPH3.2054    68.38269999
    ITALY.BMCHPH3.2055    67.88269999
    ITALY.BMCHPH3.2056    67.38269999
    ITALY.BMCHPH3.2057    66.88269999
    ITALY.BMCHPH3.2058    66.38269999
    ITALY.BMCHPH3.2059    65.88269999
    ITALY.BMCHPH3.2060    65.38269999

    ITALY.BMSTPH3.2015    77.20426381
    ITALY.BMSTPH3.2016    76.6461607
    ITALY.BMSTPH3.2017    76.08805759
    ITALY.BMSTPH3.2018    75.52995448
    ITALY.BMSTPH3.2019    74.97185136
    ITALY.BMSTPH3.2020    74.41374825
    ITALY.BMSTPH3.2021    74.16570242
    ITALY.BMSTPH3.2022    73.9176566
    ITALY.BMSTPH3.2023    73.66961077
    ITALY.BMSTPH3.2024    73.42156494
    ITALY.BMSTPH3.2025    73.17351911
    ITALY.BMSTPH3.2026    72.92547329
    ITALY.BMSTPH3.2027    72.67742746
    ITALY.BMSTPH3.2028    72.42938163
    ITALY.BMSTPH3.2029    72.1813358
    ITALY.BMSTPH3.2030    71.93328998
    ITALY.BMSTPH3.2031    71.68524415
    ITALY.BMSTPH3.2032    71.43719832
    ITALY.BMSTPH3.2033    71.18915249
    ITALY.BMSTPH3.2034    70.94110667
    ITALY.BMSTPH3.2035    70.69306084
    ITALY.BMSTPH3.2036    70.48098166
    ITALY.BMSTPH3.2037    70.26953871
    ITALY.BMSTPH3.2038    70.0587301
    ITALY.BMSTPH3.2039    69.84855391
    ITALY.BMSTPH3.2040    69.63900824
    ITALY.BMSTPH3.2041    69.43009122
    ITALY.BMSTPH3.2042    69.22180095
    ITALY.BMSTPH3.2043    69.01413554
    ITALY.BMSTPH3.2044    68.80709314
    ITALY.BMSTPH3.2045    68.60067186
    ITALY.BMSTPH3.2046    68.39486984
    ITALY.BMSTPH3.2047    68.18968523
    ITALY.BMSTPH3.2048    67.98511618
    ITALY.BMSTPH3.2049    67.78116083
    ITALY.BMSTPH3.2050    67.57781734
    ITALY.BMSTPH3.2051    67.37508389
    ITALY.BMSTPH3.2052    67.17295864
    ITALY.BMSTPH3.2053    66.97143977
    ITALY.BMSTPH3.2054    66.77052545
    ITALY.BMSTPH3.2055    66.57021387
    ITALY.BMSTPH3.2056    66.37050323
    ITALY.BMSTPH3.2057    66.17139172
    ITALY.BMSTPH3.2058    65.97287754
    ITALY.BMSTPH3.2059    65.77495891
    ITALY.BMSTPH3.2060    65.57763403

    ITALY.COSTPH1.(2015*2060)    39.99738969

    ITALY.COSTPH3.(2015*2060)    61.39134231

    ITALY.GOCVPH2.2015    77.09386825
    ITALY.GOCVPH2.2016    77.512099
    ITALY.GOCVPH2.2017    77.93032975
    ITALY.GOCVPH2.2018    78.3485605
    ITALY.GOCVPH2.2019    78.76679125
    ITALY.GOCVPH2.2020    79.185022
    ITALY.GOCVPH2.2021    79.27862603
    ITALY.GOCVPH2.2022    79.37223005
    ITALY.GOCVPH2.2023    79.46583408
    ITALY.GOCVPH2.2024    79.5594381
    ITALY.GOCVPH2.2025    79.65304213
    ITALY.GOCVPH2.2026    79.74664615
    ITALY.GOCVPH2.2027    79.84025018
    ITALY.GOCVPH2.2028    79.9338542
    ITALY.GOCVPH2.2029    80.02745823
    ITALY.GOCVPH2.2030    80.12106225
    ITALY.GOCVPH2.2031    80.11508753
    ITALY.GOCVPH2.2032    80.1091128
    ITALY.GOCVPH2.2033    80.10313808
    ITALY.GOCVPH2.2034    80.09716335
    ITALY.GOCVPH2.2035    80.09118863
    ITALY.GOCVPH2.2036    80.0852139
    ITALY.GOCVPH2.2037    80.07923918
    ITALY.GOCVPH2.2038    80.07326445
    ITALY.GOCVPH2.2039    80.06728973
    ITALY.GOCVPH2.2040    80.061315
    ITALY.GOCVPH2.2041    79.96372783
    ITALY.GOCVPH2.2042    79.86614065
    ITALY.GOCVPH2.2043    79.76855348
    ITALY.GOCVPH2.2044    79.6709663
    ITALY.GOCVPH2.2045    79.57337913
    ITALY.GOCVPH2.2046    79.47579195
    ITALY.GOCVPH2.2047    79.37820478
    ITALY.GOCVPH2.2048    79.2806176
    ITALY.GOCVPH2.2049    79.18303043
    ITALY.GOCVPH2.2050    79.08544325
    ITALY.GOCVPH2.2051    79.00635781
    ITALY.GOCVPH2.2052    78.92735145
    ITALY.GOCVPH2.2053    78.8484241
    ITALY.GOCVPH2.2054    78.76957567
    ITALY.GOCVPH2.2055    78.6908061
    ITALY.GOCVPH2.2056    78.61211529
    ITALY.GOCVPH2.2057    78.53350318
    ITALY.GOCVPH2.2058    78.45496967
    ITALY.GOCVPH2.2059    78.3765147
    ITALY.GOCVPH2.2060    78.29813819

    ITALY.HFCCPH2.(2015*2060)    20.66075942

    ITALY.HFCHPH3.(2015*2060)    0.005407976

    ITALY.HFGCPH3.2015    7.486486944
    ITALY.HFGCPH3.2016    7.650685956
    ITALY.HFGCPH3.2017    7.814884967
    ITALY.HFGCPH3.2018    7.979083978
    ITALY.HFGCPH3.2019    8.143282989
    ITALY.HFGCPH3.(2020*2060)    8.307482

    ITALY.HFGCPN3.(2015*2060)    16.04247202

    ITALY.HFSTPH2.(2015*2060)    55.81031119

    ITALY.HFSTPH3.(2015*2060)    61.39134231

    ITALY.HYDMPH0.2015    156.6671796
    ITALY.HYDMPH0.2016    157.2368785
    ITALY.HYDMPH0.2017    157.8065773
    ITALY.HYDMPH0.2018    158.3762761
    ITALY.HYDMPH0.2019    158.945975
    ITALY.HYDMPH0.2020    159.5156738
    ITALY.HYDMPH0.2021    159.5726437
    ITALY.HYDMPH0.2022    159.6296136
    ITALY.HYDMPH0.2023    159.6865835
    ITALY.HYDMPH0.2024    159.7435533
    ITALY.HYDMPH0.2025    159.8005232
    ITALY.HYDMPH0.2026    159.8574931
    ITALY.HYDMPH0.2027    159.914463
    ITALY.HYDMPH0.2028    159.9714329
    ITALY.HYDMPH0.2029    160.0284028
    ITALY.HYDMPH0.(2030*2060)    160.0853726

    ITALY.HYDMPH1.2015    125.3337437
    ITALY.HYDMPH1.2016    125.7895028
    ITALY.HYDMPH1.2017    126.2452618
    ITALY.HYDMPH1.2018    126.7010209
    ITALY.HYDMPH1.2019    127.15678
    ITALY.HYDMPH1.2020    127.612539
    ITALY.HYDMPH1.2021    127.6695089
    ITALY.HYDMPH1.2022    127.7264788
    ITALY.HYDMPH1.2023    127.7834487
    ITALY.HYDMPH1.2024    127.8404186
    ITALY.HYDMPH1.2025    127.8973885
    ITALY.HYDMPH1.2026    127.9543583
    ITALY.HYDMPH1.2027    128.0113282
    ITALY.HYDMPH1.2028    128.0682981
    ITALY.HYDMPH1.2029    128.125268
    ITALY.HYDMPH1.(2030*2060)    128.1822379

    ITALY.HYDMPH2.2015    94.00030778
    ITALY.HYDMPH2.2016    94.34212708
    ITALY.HYDMPH2.2017    94.68394638
    ITALY.HYDMPH2.2018    95.02576568
    ITALY.HYDMPH2.2019    95.36758498
    ITALY.HYDMPH2.2020    95.70940429
    ITALY.HYDMPH2.2021    95.73788923
    ITALY.HYDMPH2.2022    95.76637417
    ITALY.HYDMPH2.2023    95.79485911
    ITALY.HYDMPH2.2024    95.82334405
    ITALY.HYDMPH2.2025    95.85182899
    ITALY.HYDMPH2.2026    95.88031394
    ITALY.HYDMPH2.2027    95.90879888
    ITALY.HYDMPH2.2028    95.93728382
    ITALY.HYDMPH2.2029    95.96576876
    ITALY.HYDMPH2.(2030*2060)    95.9942537

    ITALY.HYDMPH3.(2015*2060)    52.22239321

    ITALY.HYDSPH2.2015    94.00030778
    ITALY.HYDSPH2.2016    94.34212708
    ITALY.HYDSPH2.2017    94.68394638
    ITALY.HYDSPH2.2018    95.02576568
    ITALY.HYDSPH2.2019    95.36758498
    ITALY.HYDSPH2.2020    95.70940429
    ITALY.HYDSPH2.2021    95.73788923
    ITALY.HYDSPH2.2022    95.76637417
    ITALY.HYDSPH2.2023    95.79485911
    ITALY.HYDSPH2.2024    95.82334405
    ITALY.HYDSPH2.2025    95.85182899
    ITALY.HYDSPH2.2026    95.88031394
    ITALY.HYDSPH2.2027    95.90879888
    ITALY.HYDSPH2.2028    95.93728382
    ITALY.HYDSPH2.2029    95.96576876
    ITALY.HYDSPH2.(2030*2060)    95.9942537

    ITALY.HYDSPH3.(2015*2060)    52.22239321

    ITALY.NGCCPH2.(2015*2060)    20.66075942

    ITALY.NGCHPH3.(2015*2060)    85.876714

    ITALY.NGCHPN3.2015    39.22406963
    ITALY.NGCHPN3.2016    39.1463982
    ITALY.NGCHPN3.2017    39.06872678
    ITALY.NGCHPN3.2018    38.99105535
    ITALY.NGCHPN3.2019    38.91338393
    ITALY.NGCHPN3.2020    38.8357125
    ITALY.NGCHPN3.2021    39.43766604
    ITALY.NGCHPN3.2022    40.03961959
    ITALY.NGCHPN3.2023    40.64157313
    ITALY.NGCHPN3.2024    41.24352668
    ITALY.NGCHPN3.2025    41.84548022
    ITALY.NGCHPN3.2026    42.44743376
    ITALY.NGCHPN3.2027    43.04938731
    ITALY.NGCHPN3.2028    43.65134085
    ITALY.NGCHPN3.2029    44.25329439
    ITALY.NGCHPN3.2030    44.85524794
    ITALY.NGCHPN3.2031    44.80993961
    ITALY.NGCHPN3.2032    44.76463128
    ITALY.NGCHPN3.2033    44.71932294
    ITALY.NGCHPN3.2034    44.67401461
    ITALY.NGCHPN3.2035    44.62870628
    ITALY.NGCHPN3.2036    44.58339795
    ITALY.NGCHPN3.2037    44.53808962
    ITALY.NGCHPN3.2038    44.49278129
    ITALY.NGCHPN3.2039    44.44747296
    ITALY.NGCHPN3.2040    44.40216463
    ITALY.NGCHPN3.2041    44.35685629
    ITALY.NGCHPN3.2042    44.31154796
    ITALY.NGCHPN3.2043    44.26623963
    ITALY.NGCHPN3.2044    44.2209313
    ITALY.NGCHPN3.2045    44.17562297
    ITALY.NGCHPN3.2046    44.13031464
    ITALY.NGCHPN3.2047    44.08500631
    ITALY.NGCHPN3.2048    44.03969798
    ITALY.NGCHPN3.2049    43.99438964
    ITALY.NGCHPN3.2050    43.94908131
    ITALY.NGCHPN3.2051    43.90908131
    ITALY.NGCHPN3.2052    43.86908131
    ITALY.NGCHPN3.2053    43.82908131
    ITALY.NGCHPN3.2054    43.78908131
    ITALY.NGCHPN3.2055    43.74908131
    ITALY.NGCHPN3.2056    43.70908131
    ITALY.NGCHPN3.2057    43.66908131
    ITALY.NGCHPN3.2058    43.62908131
    ITALY.NGCHPN3.2059    43.58908131
    ITALY.NGCHPN3.2060    43.54908131

    ITALY.NGGCPH2.(2015*2060)    7.486486944

    ITALY.NGGCPN2.(2015*2060)    16.04247202

    ITALY.NGSTPH2.(2015*2060)    55.81031119

*ITALY.NUG3PH3.2015  85.62433816
*ITALY.NUG3PH3.2016  87.13624078
*ITALY.NUG3PH3.2017  88.64814339
*ITALY.NUG3PH3.2018  90.16004601
*ITALY.NUG3PH3.2019  91.67194863
*ITALY.NUG3PH3.2020  93.18385125
*ITALY.NUG3PH3.2021  91.81185038
*ITALY.NUG3PH3.2022  90.4398495
*ITALY.NUG3PH3.2023  89.06784863
*ITALY.NUG3PH3.2024  87.69584775
*ITALY.NUG3PH3.2025  86.32384688
*ITALY.NUG3PH3.2026  84.951846
*ITALY.NUG3PH3.2027  83.57984513
*ITALY.NUG3PH3.2028  82.20784425
*ITALY.NUG3PH3.2029  80.83584338
*ITALY.NUG3PH3.2030  79.4638425
*ITALY.NUG3PH3.2031  81.98342775
*ITALY.NUG3PH3.2032  84.503013
*ITALY.NUG3PH3.2033  87.02259825
*ITALY.NUG3PH3.2034  89.5421835
*ITALY.NUG3PH3.2035  92.06176875
    ITALY.NUG3PH3.2036  94.581354
    ITALY.NUG3PH3.2037  97.10093925
    ITALY.NUG3PH3.2038  99.6205245
    ITALY.NUG3PH3.2039  102.1401098
    ITALY.NUG3PH3.2040  104.659695
    ITALY.NUG3PH3.2041  104.1394568
    ITALY.NUG3PH3.2042  103.6192185
    ITALY.NUG3PH3.2043  103.0989803
    ITALY.NUG3PH3.2044  102.578742
    ITALY.NUG3PH3.2045  102.0585038
    ITALY.NUG3PH3.2046  101.5382655
    ITALY.NUG3PH3.2047  101.0180273
    ITALY.NUG3PH3.2048  100.497789
    ITALY.NUG3PH3.2049  99.97755075
    ITALY.NUG3PH3.2050  99.4573125
    ITALY.NUG3PH3.2051  98.9573125
    ITALY.NUG3PH3.2052  98.4573125
    ITALY.NUG3PH3.2053  97.9573125
    ITALY.NUG3PH3.2054  97.4573125
    ITALY.NUG3PH3.2055  96.9573125
    ITALY.NUG3PH3.2056  96.4573125
    ITALY.NUG3PH3.2057  95.9573125
    ITALY.NUG3PH3.2058  95.4573125
    ITALY.NUG3PH3.2059  94.9573125
    ITALY.NUG3PH3.2060  94.4573125


    ITALY.OCWVPH1.2015    310.3719253
    ITALY.OCWVPH1.2016    293.3778091
    ITALY.OCWVPH1.2017    276.3836928
    ITALY.OCWVPH1.2018    259.3895766
    ITALY.OCWVPH1.2019    242.3954603
    ITALY.OCWVPH1.2020    225.4013441
    ITALY.OCWVPH1.2021    222.8538408
    ITALY.OCWVPH1.2022    220.3063375
    ITALY.OCWVPH1.2023    217.7588342
    ITALY.OCWVPH1.2024    215.2113309
    ITALY.OCWVPH1.2025    212.6638276
    ITALY.OCWVPH1.2026    210.1163243
    ITALY.OCWVPH1.2027    207.568821
    ITALY.OCWVPH1.2028    205.0213178
    ITALY.OCWVPH1.2029    202.4738145
    ITALY.OCWVPH1.2030    199.9263112
    ITALY.OCWVPH1.2031    194.5274652
    ITALY.OCWVPH1.2032    189.1286193
    ITALY.OCWVPH1.2033    183.7297733
    ITALY.OCWVPH1.2034    178.3309273
    ITALY.OCWVPH1.2035    172.9320814
    ITALY.OCWVPH1.2036    167.5332354
    ITALY.OCWVPH1.2037    162.1343895
    ITALY.OCWVPH1.2038    156.7355435
    ITALY.OCWVPH1.2039    151.3366975
    ITALY.OCWVPH1.2040    145.9378516
    ITALY.OCWVPH1.2041    144.0103705
    ITALY.OCWVPH1.2042    142.0828895
    ITALY.OCWVPH1.2043    140.1554084
    ITALY.OCWVPH1.2044    138.2279273
    ITALY.OCWVPH1.2045    136.3004463
    ITALY.OCWVPH1.2046    134.3729652
    ITALY.OCWVPH1.2047    132.4454842
    ITALY.OCWVPH1.2048    130.5180031
    ITALY.OCWVPH1.2049    128.590522
    ITALY.OCWVPH1.2050    126.663041
    ITALY.OCWVPH1.2051    124.663041
    ITALY.OCWVPH1.2052    122.663041
    ITALY.OCWVPH1.2053    120.663041
    ITALY.OCWVPH1.2054    118.663041
    ITALY.OCWVPH1.2055    116.663041
    ITALY.OCWVPH1.2056    114.663041
    ITALY.OCWVPH1.2057    112.663041
    ITALY.OCWVPH1.2058    110.663041
    ITALY.OCWVPH1.2059    108.663041
    ITALY.OCWVPH1.2060    106.663041

    ITALY.SODIFH1.2015    26.725965
    ITALY.SODIFH1.2016    25.869102
    ITALY.SODIFH1.2017    25.012239
    ITALY.SODIFH1.2018    24.155376
    ITALY.SODIFH1.2019    23.298513
    ITALY.SODIFH1.2020    22.44165
    ITALY.SODIFH1.2021    22.2172335
    ITALY.SODIFH1.2022    21.992817
    ITALY.SODIFH1.2023    21.7684005
    ITALY.SODIFH1.2024    21.543984
    ITALY.SODIFH1.2025    21.3195675
    ITALY.SODIFH1.2026    21.095151
    ITALY.SODIFH1.2027    20.8707345
    ITALY.SODIFH1.2028    20.646318
    ITALY.SODIFH1.2029    20.4219015
    ITALY.SODIFH1.2030    20.197485
    ITALY.SODIFH1.2031    20.075076
    ITALY.SODIFH1.2032    19.952667
    ITALY.SODIFH1.2033    19.830258
    ITALY.SODIFH1.2034    19.707849
    ITALY.SODIFH1.2035    19.58544
    ITALY.SODIFH1.2036    19.463031
    ITALY.SODIFH1.2037    19.340622
    ITALY.SODIFH1.2038    19.218213
    ITALY.SODIFH1.2039    19.095804
    ITALY.SODIFH1.2040    18.973395
    ITALY.SODIFH1.2041    18.8713875
    ITALY.SODIFH1.2042    18.76938
    ITALY.SODIFH1.2043    18.6673725
    ITALY.SODIFH1.2044    18.565365
    ITALY.SODIFH1.2045    18.4633575
    ITALY.SODIFH1.2046    18.36135
    ITALY.SODIFH1.2047    18.2593425
    ITALY.SODIFH1.2048    18.157335
    ITALY.SODIFH1.2049    18.0553275
    ITALY.SODIFH1.2050    17.95332
    ITALY.SODIFH1.2051    17.85332
    ITALY.SODIFH1.2052    17.75332
    ITALY.SODIFH1.2053    17.65332
    ITALY.SODIFH1.2054    17.55332
    ITALY.SODIFH1.2055    17.45332
    ITALY.SODIFH1.2056    17.35332
    ITALY.SODIFH1.2057    17.25332
    ITALY.SODIFH1.2058    17.15332
    ITALY.SODIFH1.2059    17.05332
    ITALY.SODIFH1.2060    16.95332

    ITALY.SOUTPH2.2015    27.60679167
    ITALY.SOUTPH2.2016    26.60290833
    ITALY.SOUTPH2.2017    25.599025
    ITALY.SOUTPH2.2018    24.59514167
    ITALY.SOUTPH2.2019    23.59125833
    ITALY.SOUTPH2.2020    22.587375
    ITALY.SOUTPH2.2021    22.36150125
    ITALY.SOUTPH2.2022    22.1356275
    ITALY.SOUTPH2.2023    21.90975375
    ITALY.SOUTPH2.2024    21.68388
    ITALY.SOUTPH2.2025    21.45800625
    ITALY.SOUTPH2.2026    21.2321325
    ITALY.SOUTPH2.2027    21.00625875
    ITALY.SOUTPH2.2028    20.780385
    ITALY.SOUTPH2.2029    20.55451125
    ITALY.SOUTPH2.2030    20.3286375
    ITALY.SOUTPH2.2031    20.20315208
    ITALY.SOUTPH2.2032    20.07766667
    ITALY.SOUTPH2.2033    19.95218125
    ITALY.SOUTPH2.2034    19.82669583
    ITALY.SOUTPH2.2035    19.70121042
    ITALY.SOUTPH2.2036    19.575725
    ITALY.SOUTPH2.2037    19.45023958
    ITALY.SOUTPH2.2038    19.32475417
    ITALY.SOUTPH2.2039    19.19926875
    ITALY.SOUTPH2.2040    19.07378333
    ITALY.SOUTPH2.2041    18.973395
    ITALY.SOUTPH2.2042    18.87300667
    ITALY.SOUTPH2.2043    18.77261833
    ITALY.SOUTPH2.2044    18.67223
    ITALY.SOUTPH2.2045    18.57184167
    ITALY.SOUTPH2.2046    18.47145333
    ITALY.SOUTPH2.2047    18.371065
    ITALY.SOUTPH2.2048    18.27067667
    ITALY.SOUTPH2.2049    18.17028833
    ITALY.SOUTPH2.2050    18.0699
    ITALY.SOUTPH2.2051    17.9699
    ITALY.SOUTPH2.2052    17.8699
    ITALY.SOUTPH2.2053    17.7699
    ITALY.SOUTPH2.2054    17.6699
    ITALY.SOUTPH2.2055    17.5699
    ITALY.SOUTPH2.2056    17.4699
    ITALY.SOUTPH2.2057    17.3699
    ITALY.SOUTPH2.2058    17.2699
    ITALY.SOUTPH2.2059    17.1699
    ITALY.SOUTPH2.2060    17.0699


*Wind lower prices
ITALY.WIOFPN2.2015    100.8300716
ITALY.WIOFPN2.2016    95.1394828
ITALY.WIOFPN2.2017    89.4488940
ITALY.WIOFPN2.2018    83.75830512
ITALY.WIOFPN2.2019    78.06771632
ITALY.WIOFPN2.2020    72.37712750
ITALY.WIOFPN2.2021    71.21796257
ITALY.WIOFPN2.2022    70.05879763
ITALY.WIOFPN2.2023    68.89963270
ITALY.WIOFPN2.2024    67.74046777
ITALY.WIOFPN2.2025    66.58130283
ITALY.WIOFPN2.2026    65.42213790
ITALY.WIOFPN2.2027    64.26297297
ITALY.WIOFPN2.2028    63.10380804
ITALY.WIOFPN2.2029    61.94464310
ITALY.WIOFPN2.2030    60.78547817
ITALY.WIOFPN2.2031    59.94045008
ITALY.WIOFPN2.2032    59.09542198
ITALY.WIOFPN2.2033    58.25039389
ITALY.WIOFPN2.2034    57.40536579
ITALY.WIOFPN2.2035    56.56033770
ITALY.WIOFPN2.2036    55.71530961
ITALY.WIOFPN2.2037    54.87028151
ITALY.WIOFPN2.2038    54.02525342
ITALY.WIOFPN2.2039    53.18022532
ITALY.WIOFPN2.2040    52.33519722
ITALY.WIOFPN2.2041    51.22001145
ITALY.WIOFPN2.2042    50.10482568
ITALY.WIOFPN2.2043    48.98963990
ITALY.WIOFPN2.2044    47.87445413
ITALY.WIOFPN2.2045    46.75926835
ITALY.WIOFPN2.2046    45.64408258
ITALY.WIOFPN2.2047    44.5288968
ITALY.WIOFPN2.2048    43.41371102
ITALY.WIOFPN2.2049    42.29852525
ITALY.WIOFPN2.(2050*2050)    41.18333947

ITALY.WIOFPN3.2015  100.8300716
ITALY.WIOFPN3.2016  95.1394828
ITALY.WIOFPN3.2017  89.4488940
ITALY.WIOFPN3.2018  83.75830512
ITALY.WIOFPN3.2019  78.06771632
ITALY.WIOFPN3.2020  72.37712750
ITALY.WIOFPN3.2021  71.21796257
ITALY.WIOFPN3.2022  70.05879763
ITALY.WIOFPN3.2023  68.89963270
ITALY.WIOFPN3.2024  67.74046777
ITALY.WIOFPN3.2025  66.58130283
ITALY.WIOFPN3.2026  65.42213790
ITALY.WIOFPN3.2027  64.26297297
ITALY.WIOFPN3.2028  63.10380804
ITALY.WIOFPN3.2029  61.94464310
ITALY.WIOFPN3.2030  60.78547817
ITALY.WIOFPN3.2031  59.94045008
ITALY.WIOFPN3.2032  59.09542198
ITALY.WIOFPN3.2033  58.25039389
ITALY.WIOFPN3.2034  57.40536579
ITALY.WIOFPN3.2035  56.56033770
ITALY.WIOFPN3.2036  55.71530961
ITALY.WIOFPN3.2037  54.87028151
ITALY.WIOFPN3.2038  54.02525342
ITALY.WIOFPN3.2039  53.18022532
ITALY.WIOFPN3.2040  52.33519722
ITALY.WIOFPN3.2041  51.22001145
ITALY.WIOFPN3.2042  50.10482568
ITALY.WIOFPN3.2043  48.98963990
ITALY.WIOFPN3.2044  47.87445413
ITALY.WIOFPN3.2045  46.75926835
ITALY.WIOFPN3.2046  45.64408258
ITALY.WIOFPN3.2047  44.5288968
ITALY.WIOFPN3.2048  43.41371102
ITALY.WIOFPN3.2049  42.29852525
ITALY.WIOFPN3.(2050*2060)  41.18333947

ITALY.WIONPH3.2015    30.357432
ITALY.WIONPH3.2016    29.4900768
ITALY.WIONPH3.2017    28.6227216
ITALY.WIONPH3.2018    27.7553664
ITALY.WIONPH3.2019    26.8880112
ITALY.WIONPH3.2020    26.020656
ITALY.WIONPH3.2021    25.71547546
ITALY.WIONPH3.2022    25.41029494
ITALY.WIONPH3.2023    25.1051144
ITALY.WIONPH3.2024    24.79993386
ITALY.WIONPH3.2025    24.49475334
ITALY.WIONPH3.2026    24.1895728
ITALY.WIONPH3.2027    23.88439226
ITALY.WIONPH3.2028    23.57921174
ITALY.WIONPH3.2029    23.2740312
ITALY.WIONPH3.2030    22.96885066
ITALY.WIONPH3.2031    22.5030488
ITALY.WIONPH3.2032    22.03724694
ITALY.WIONPH3.2033    21.57144506
ITALY.WIONPH3.2034    21.1056432
ITALY.WIONPH3.2035    20.63984134
ITALY.WIONPH3.2036    20.17403946
ITALY.WIONPH3.2037    19.7082376
ITALY.WIONPH3.2038    19.24243574
ITALY.WIONPH3.2039    18.77663386
ITALY.WIONPH3.2040    18.310832
ITALY.WIONPH3.2041    17.98155826
ITALY.WIONPH3.2042    17.65228454
ITALY.WIONPH3.2043    17.3230108
ITALY.WIONPH3.2044    16.99373706
ITALY.WIONPH3.2045    16.66446334
ITALY.WIONPH3.2046    16.3351896
ITALY.WIONPH3.2047    16.00591586
ITALY.WIONPH3.2048    15.67664214
ITALY.WIONPH3.2049    15.3473684
ITALY.WIONPH3.(2050*2060)    15.01809466
                                 
ITALY.WIONPN3.2015     30.357432
ITALY.WIONPN3.2016     29.4900768
ITALY.WIONPN3.2017     28.6227216
ITALY.WIONPN3.2018     27.7553664
ITALY.WIONPN3.2019     26.8880112
ITALY.WIONPN3.2020     26.020656
ITALY.WIONPN3.2021     25.71547546
ITALY.WIONPN3.2022     25.41029494
ITALY.WIONPN3.2023     25.1051144
ITALY.WIONPN3.2024     24.79993386
ITALY.WIONPN3.2025     24.49475334
ITALY.WIONPN3.2026     24.1895728
ITALY.WIONPN3.2027     23.88439226
ITALY.WIONPN3.2028     23.57921174
ITALY.WIONPN3.2029     23.2740312
ITALY.WIONPN3.2030     22.96885066
ITALY.WIONPN3.2031     22.5030488
ITALY.WIONPN3.2032     22.03724694
ITALY.WIONPN3.2033     21.57144506
ITALY.WIONPN3.2034     21.1056432
ITALY.WIONPN3.2035     20.63984134
ITALY.WIONPN3.2036     20.17403946
ITALY.WIONPN3.2037     19.7082376
ITALY.WIONPN3.2038     19.24243574
ITALY.WIONPN3.2039     18.77663386
ITALY.WIONPN3.2040     18.310832
ITALY.WIONPN3.2041     17.98155826
ITALY.WIONPN3.2042     17.65228454
ITALY.WIONPN3.2043     17.3230108
ITALY.WIONPN3.2044     16.99373706
ITALY.WIONPN3.2045     16.66446334
ITALY.WIONPN3.2046     16.3351896
ITALY.WIONPN3.2047     16.00591586
ITALY.WIONPN3.2048     15.67664214
ITALY.WIONPN3.2049     15.3473684
ITALY.WIONPN3.(2050*2060)     15.01809466
*End of lower wind prices

    ITALY.WSCHPH2.2015    221.6777952
    ITALY.WSCHPH2.2016    218.3963805
    ITALY.WSCHPH2.2017    215.1149658
    ITALY.WSCHPH2.2018    211.833551
    ITALY.WSCHPH2.2019    208.5521363
    ITALY.WSCHPH2.2020    205.2707216
    ITALY.WSCHPH2.2021    203.8487752
    ITALY.WSCHPH2.2022    202.4268288
    ITALY.WSCHPH2.2023    201.0048824
    ITALY.WSCHPH2.2024    199.582936
    ITALY.WSCHPH2.2025    198.1609897
    ITALY.WSCHPH2.2026    196.7390433
    ITALY.WSCHPH2.2027    195.3170969
    ITALY.WSCHPH2.2028    193.8951505
    ITALY.WSCHPH2.2029    192.4732041
    ITALY.WSCHPH2.2030    191.0512577
    ITALY.WSCHPH2.2031    189.7022317
    ITALY.WSCHPH2.2032    188.3532056
    ITALY.WSCHPH2.2033    187.0041796
    ITALY.WSCHPH2.2034    185.6551535
    ITALY.WSCHPH2.2035    184.3061275
    ITALY.WSCHPH2.2036    182.9571014
    ITALY.WSCHPH2.2037    181.6080753
    ITALY.WSCHPH2.2038    180.2590493
    ITALY.WSCHPH2.2039    178.9100232
    ITALY.WSCHPH2.2040    177.5609972
    ITALY.WSCHPH2.2041    176.3578118
    ITALY.WSCHPH2.2042    175.1546264
    ITALY.WSCHPH2.2043    173.951441
    ITALY.WSCHPH2.2044    172.7482556
    ITALY.WSCHPH2.2045    171.5450702
    ITALY.WSCHPH2.2046    170.3418848
    ITALY.WSCHPH2.2047    169.1386994
    ITALY.WSCHPH2.2048    167.935514
    ITALY.WSCHPH2.2049    166.7323286
    ITALY.WSCHPH2.2050    165.5291432
    ITALY.WSCHPH2.2051    164.3291432
    ITALY.WSCHPH2.2052    163.1291432
    ITALY.WSCHPH2.2053    161.9291432
    ITALY.WSCHPH2.2054    160.7291432
    ITALY.WSCHPH2.2055    159.5291432
    ITALY.WSCHPH2.2056    158.3291432
    ITALY.WSCHPH2.2057    157.1291432
    ITALY.WSCHPH2.2058    155.9291432
    ITALY.WSCHPH2.2059    154.7291432
    ITALY.WSCHPH2.2060    153.5291432

    ITALY.WSSTPH1.2015    77.27124025
    ITALY.WSSTPH1.2016    75.82741777
    ITALY.WSSTPH1.2017    74.38359528
    ITALY.WSSTPH1.2018    72.9397728
    ITALY.WSSTPH1.2019    71.49595032
    ITALY.WSSTPH1.2020    70.05212784
    ITALY.WSSTPH1.2021    69.3836915
    ITALY.WSSTPH1.2022    68.71525517
    ITALY.WSSTPH1.2023    68.04681883
    ITALY.WSSTPH1.2024    67.3783825
    ITALY.WSSTPH1.2025    66.70994617
    ITALY.WSSTPH1.2026    66.04150983
    ITALY.WSSTPH1.2027    65.3730735
    ITALY.WSSTPH1.2028    64.70463716
    ITALY.WSSTPH1.2029    64.03620083
    ITALY.WSSTPH1.2030    63.36776449
    ITALY.WSSTPH1.2031    62.77954052
    ITALY.WSSTPH1.2032    62.19131655
    ITALY.WSSTPH1.2033    61.60309257
    ITALY.WSSTPH1.2034    61.0148686
    ITALY.WSSTPH1.2035    60.42664462
    ITALY.WSSTPH1.2036    59.83842065
    ITALY.WSSTPH1.2037    59.25019667
    ITALY.WSSTPH1.2038    58.6619727
    ITALY.WSSTPH1.2039    58.07374873
    ITALY.WSSTPH1.2040    57.48552475
    ITALY.WSSTPH1.2041    56.95077568
    ITALY.WSSTPH1.2042    56.41602662
    ITALY.WSSTPH1.2043    55.88127755
    ITALY.WSSTPH1.2044    55.34652848
    ITALY.WSSTPH1.2045    54.81177941
    ITALY.WSSTPH1.2046    54.27703035
    ITALY.WSSTPH1.2047    53.74228128
    ITALY.WSSTPH1.2048    53.20753221
    ITALY.WSSTPH1.2049    52.67278314
    ITALY.WSSTPH1.2050    52.13803408
    ITALY.WSSTPH1.2051    51.63803408
    ITALY.WSSTPH1.2052    51.13803408
    ITALY.WSSTPH1.2053    50.63803408
    ITALY.WSSTPH1.2054    50.13803408
    ITALY.WSSTPH1.2055    49.63803408
    ITALY.WSSTPH1.2056    49.13803408
    ITALY.WSSTPH1.2057    48.63803408
    ITALY.WSSTPH1.2058    48.13803408
    ITALY.WSSTPH1.2059    47.63803408
    ITALY.WSSTPH1.2060    47.13803408

/;

FixedCost(r,'BMCSPN2S',y)=FixedCost(r,'BMCSPN2',y)*1.1;
FixedCost(r,'HFCCPH2S',y)=FixedCost(r,'HFCCPH2',y)*1.1;
FixedCost(r,'NGCCPH2S',y)=FixedCost(r,'NGCCPH2',y)*1.1;
FixedCost(r,'NGCSPN2S',y)=FixedCost(r,'NGCSPN2',y)*1.1;
FixedCost(r,'NUG3PH3S',y)=FixedCost(r,'NUG3PH3',y)*1.1;
FixedCost(r,'WSSTPH1S',y)=FixedCost(r,'WSSTPH1',y)*1.1;

*------------------------------------------------------------------------
* Parameters - Storage
*------------------------------------------------------------------------

parameter TechnologyToStorage(r,m,t,s) /
    ITALY.2.HYDSPH2.DAM  1
    ITALY.2.HYDSPH3.DAM  1
    ITALY.2.BATCHG.BAT  1

/;

parameter TechnologyFromStorage(r,m,t,s) /
    ITALY.1.HYDSPH2.DAM  1
    ITALY.1.HYDSPH3.DAM  1
    ITALY.1.BATCHG.BAT  1
/;

*PJ
Parameter StorageLevelStart(r,s)    /
    ITALY.DAM 8.64
    ITALY.BAT 0
/;

*PJ/anno
StorageMaxChargeRate(r,s) = 999;

*PJ/anno
StorageMaxDischargeRate(r,s) = 999;

*PJ
MinStorageCharge(r,s,y) = 0;

*YEARS
Parameter OperationalLifeStorage(r,s) /
    ITALY.DAM 40
    ITALY.BAT 20
/;

CapitalCostStorage(r,s,y) = 0;

*PJ
Parameter ResidualStorageCapacity(r,s,y) /
    ITALY.DAM.(2015*2021) 90
    ITALY.BAT.(2015*2018) 0
    ITALY.BAT.2019 0.000604
    ITALY.BAT.2020 0.000963
    ITALY.BAT.2021 0.002646
    ITALY.BAT.2022 0.006538
/;

*------------------------------------------------------------------------
* Parameters - Capacity and investment constraints
*------------------------------------------------------------------------

CapacityOfOneTechnologyUnit(r,t,y) = 0;
*Mesured in GW (o equivalenti, per acqua in km3/anno)
parameter TotalAnnualMaxCapacity(r,t,y) /
    ITALY.BFHPFH1.(2015*2021) 1
    ITALY.BM00X00.(2015*2060) 0.95
    ITALY.BMCCPH1.(2015*2021) 1
    ITALY.BMCHPH3.(2015*2021) 1
    ITALY.BMSTPH3.(2015*2021) 1
    ITALY.COCHPH3.(2015*2021) 1
    ITALY.COSTPH3.(2015*2021) 9
    ITALY.GOCVPH2.(2015*2021) 0.95
    ITALY.HFCHPH3.(2015*2021) 2
    ITALY.HFGCPH3.(2015*2021) 1
    ITALY.HFHPPH2.(2015*2021) 1
    ITALY.HFSTPH2.(2015*2021) 9
    ITALY.HFCCPH2S.(2015*2021) 3
    ITALY.HYDMPH0.(2015*2021) 0.5
    ITALY.HYDMPH1.(2015*2021) 3.1
    ITALY.HYDMPH2.(2015*2021) 10.7
    ITALY.HYDMPH3.(2015*2021) 2.5
    ITALY.HYDSPH2.(2015*2021) 2
    ITALY.HYDSPH3.(2015*2021) 5
    ITALY.NGCCPH2.(2015*2021) 12
    ITALY.NGCCPH2S.(2015*2021) 12
    ITALY.NGCHPH3.(2015*2021) 11
    ITALY.NGFCFH1.(2015*2021) 0.0002
    ITALY.NGGCPH2.(2015*2021) 2.5
    ITALY.NGHPPH2.(2015*2021) 2
    ITALY.NGSTPH2.(2015*2021) 5
    ITALY.SODIFH1.(2015*2021) 0.01
    ITALY.SOUTPH2.2015 19
    ITALY.SOUTPH2.2016 19.5
    ITALY.SOUTPH2.2017 20
    ITALY.SOUTPH2.2018 20.5
    ITALY.SOUTPH2.2019 21
    ITALY.SOUTPH2.2020 22
    ITALY.SOUTPH2.2021 23
    ITALY.WIONPH3.2015 9.5
    ITALY.WIONPH3.2016 9.5
    ITALY.WIONPH3.2017 10
    ITALY.WIONPH3.2018 10.5
    ITALY.WIONPH3.2019 11
    ITALY.WIONPH3.2020 11
    ITALY.WIONPH3.2021 11.5
    ITALY.WIONPN3.(2015*2021) 0.5
    ITALY.WSCHPH2.(2015*2021) 0.5
    ITALY.WSSTPH1.(2015*2021) 0.45
    ITALY.WSSTPH1S.(2015*2021) 0.03
    
*dati estrazione Gas
    ITALY.NG00X00.2015 7.570
    ITALY.NG00X00.2016 6.505
    ITALY.NG00X00.2017 6.269
    ITALY.NG00X00.2018 6.150
    ITALY.NG00X00.2019 5.441
    ITALY.NG00X00.2020 4.613
    ITALY.NG00X00.2021 3.785
    ITALY.NG00X00.2022 3.903
    ITALY.NG00X00.2023 4.731
    ITALY.NG00X00.2024 5.914
    ITALY.NG00X00.2025 7.097
    ITALY.NG00X00.(2026*2060) 7.688
*dati estrazione Petrolio
    ITALY.OI00X00.2015 7.262
    ITALY.OI00X00.2016 4.973
    ITALY.OI00X00.2017 5.493
    ITALY.OI00X00.2018 6.218
    ITALY.OI00X00.2019 5.680
    ITALY.OI00X00.2020 7.147
    ITALY.OI00X00.2021 6.413 
    ITALY.OI00X00.(2022*2060) 8.244

*dati futuri    
    ITALY.GOCVPH2.(2022*2030) 1.1
    ITALY.GOCVPH2.(2031*2060) 3.5

    ITALY.HYDMPH0.(2022*2060) 1
    ITALY.HYDMPH1.(2022*2060) 4
    ITALY.HYDMPH2.(2022*2060) 11
    ITALY.HYDMPH3.(2022*2060) 3
    ITALY.HYDSPH2.(2022*2060) 2
    ITALY.HYDSPH3.(2022*2060) 5
    
    ITALY.WSCHPH2.(2022*2060) 0.55
    ITALY.WSSTPH1.(2022*2060) 0.5
    ITALY.WSSTPH1S.(2022*2060) 0.5
/;

TotalAnnualMaxCapacity(r,t,y)$(TotalAnnualMaxCapacity(r,t,y) = 0 ) = 99999;
*TotalAnnualMaxCapacity(r,t,y) = 99999;

TotalAnnualMaxCapacity(r,'NUG3PH3','2015') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2016') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2017') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2018') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2019') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2020') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2021') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2022') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2023') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2024') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2025') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2026') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2027') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2028') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2029') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2030') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2031') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2032') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2033') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2034') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3','2035') = 0;

TotalAnnualMaxCapacity(r,'NUG3PH3S','2015') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2016') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2017') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2018') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2019') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2020') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2021') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2022') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2023') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2024') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2025') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2026') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2027') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2028') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2029') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2030') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2031') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2032') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2033') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2034') = 0;
TotalAnnualMaxCapacity(r,'NUG3PH3S','2035') = 0;

TotalAnnualMaxCapacity(r,'BMCSPN2S','2015') = 0;
TotalAnnualMaxCapacity(r,'BMCSPN2S','2016') = 0;
TotalAnnualMaxCapacity(r,'BMCSPN2S','2017') = 0;
TotalAnnualMaxCapacity(r,'BMCSPN2S','2018') = 0;
TotalAnnualMaxCapacity(r,'BMCSPN2S','2019') = 0;
TotalAnnualMaxCapacity(r,'BMCSPN2S','2020') = 0;
TotalAnnualMaxCapacity(r,'BMCSPN2S','2021') = 0;
TotalAnnualMaxCapacity(r,'BMCSPN2S','2022') = 0;
TotalAnnualMaxCapacity(r,'BMCSPN2S','2023') = 0;
TotalAnnualMaxCapacity(r,'BMCSPN2S','2024') = 0;
TotalAnnualMaxCapacity(r,'BMCSPN2S','2025') = 0;

TotalAnnualMaxCapacity(r,'BMSTPH3S','2015') = 0;
TotalAnnualMaxCapacity(r,'BMSTPH3S','2016') = 0;
TotalAnnualMaxCapacity(r,'BMSTPH3S','2017') = 0;
TotalAnnualMaxCapacity(r,'BMSTPH3S','2018') = 0;
TotalAnnualMaxCapacity(r,'BMSTPH3S','2019') = 0;
TotalAnnualMaxCapacity(r,'BMSTPH3S','2020') = 0;
TotalAnnualMaxCapacity(r,'BMSTPH3S','2021') = 0;
TotalAnnualMaxCapacity(r,'BMSTPH3S','2022') = 0;
TotalAnnualMaxCapacity(r,'BMSTPH3S','2023') = 0;
TotalAnnualMaxCapacity(r,'BMSTPH3S','2024') = 0;
TotalAnnualMaxCapacity(r,'BMSTPH3S','2025') = 0;

TotalAnnualMaxCapacity(r,'NGCSPN2S','2015') = 0;
TotalAnnualMaxCapacity(r,'NGCSPN2S','2016') = 0;
TotalAnnualMaxCapacity(r,'NGCSPN2S','2017') = 0;
TotalAnnualMaxCapacity(r,'NGCSPN2S','2018') = 0;
TotalAnnualMaxCapacity(r,'NGCSPN2S','2019') = 0;
TotalAnnualMaxCapacity(r,'NGCSPN2S','2020') = 0;
TotalAnnualMaxCapacity(r,'NGCSPN2S','2021') = 0;
TotalAnnualMaxCapacity(r,'NGCSPN2S','2022') = 0;
TotalAnnualMaxCapacity(r,'NGCSPN2S','2023') = 0;
TotalAnnualMaxCapacity(r,'NGCSPN2S','2024') = 0;
TotalAnnualMaxCapacity(r,'NGCSPN2S','2025') = 0;

TotalAnnualMaxCapacity(r,'CO00X00',y) = 0;

*Minimum capacity
*ACCORDING TO PNIEC in 30
parameter TotalAnnualMinCapacity(r,t,y) /
    ITALY.SOUTPH2.2030      51
    ITALY.WIOFPN3.(2030*2060) 1.950
    ITALY.WIONPN3.2030 10.6
    ITALY.WIONPN3.2031 11.3360
    ITALY.WIONPN3.2032 12.0721
    ITALY.WIONPN3.2033 12.7409
    ITALY.WIONPN3.2034 13.5463
    ITALY.WIONPN3.2035 14.7713
    ITALY.WIONPN3.2036 15.7308
    ITALY.WIONPN3.2037 16.8143
    ITALY.WIONPN3.2038 17.2473
    ITALY.WIONPN3.(2039*2060) 17.3593
        /;
*PNIEC 2030
*TotalAnnualMinCapacity(r,'SOUTPH2','2030') = 51;
*TotalAnnualMinCapacity(r,'WIOFPN3','2030') = 1.950;
*TotalAnnualMinCapacity(r,'WIONPN3','2030') = 10.6;


*GW/year
parameter TotalAnnualMaxCapacityInvestment(r,t,y) /
    ITALY.NUG3PH3.(2036*2060) 1
    ITALY.NUG3PH3S.(2036*2060) 1

    ITALY.SODIFH1.2015 0.09
    ITALY.SODIFH1.2016 0.09
    ITALY.SODIFH1.2017 0.22
    ITALY.SODIFH1.2018 0.43
    ITALY.SODIFH1.2019 0.76
    ITALY.SODIFH1.2020 0.8
    ITALY.SODIFH1.2021 0.94
    ITALY.SODIFH1.2022 1.6
    ITALY.SODIFH1.(2023*2060) 4.6

    ITALY.SOUTPH2.2015 0.09
    ITALY.SOUTPH2.2016 0.09
    ITALY.SOUTPH2.2017 0.22
    ITALY.SOUTPH2.2018 0.43
    ITALY.SOUTPH2.2019 0.76
    ITALY.SOUTPH2.2020 0.8
    ITALY.SOUTPH2.2021 0.94
    ITALY.SOUTPH2.2022 1.6
    ITALY.SOUTPH2.(2023*2060) 4.6

    ITALY.WIOFPN2.(2015*2017) 0.4
    ITALY.WIOFPN2.2018 0.5
    ITALY.WIOFPN2.2019 0.4
    ITALY.WIOFPN2.2020 0.4
    ITALY.WIOFPN3.(2021*2060) 0.5

    ITALY.WIONPN3.(2015*2017) 0.4
    ITALY.WIONPN3.2018 0.5
    ITALY.WIONPN3.2019 0.4
    ITALY.WIONPN3.2020 0.8
    ITALY.WIONPN3.(2021*2030) 1.2
    ITALY.WIONPN3.(2031*2060) 1.5
    
    ITALY.GOCVPH2.(2022*2030) 0.03
    ITALY.GOCVPH2.(2031*2060) 0.09
    
*test in limiting some tech investment dati da trovare!

    ITALY.BFHPFH1.(2015*2060) 0.1
    ITALY.BMCCPH1.(2015*2060) 0.1
    ITALY.BMCHPH3.(2015*2060) 0.1
    ITALY.BMSTPH3.(2015*2060) 0.1

*vincolato in TotalMaxCapacity
*    ITALY.HYDMPH0.(2015*2060) 0.05
*    ITALY.HYDMPH1.(2015*2060) 0.5
*    ITALY.HYDMPH2.(2015*2060) 0.1
*    ITALY.HYDMPH3.(2015*2060) 0.05
*    ITALY.HYDSPH2.(2015*2060) 1
*    ITALY.HYDSPH3.(2015*2060) 1

*    ITALY.WSCHPH2.(2015*2060) 0.5
*    ITALY.WSSTPH1.(2015*2060) 0.5

*Seaside plants: dati momentanei, messi un po' a caso (alti per provare a falo andare)

    ITALY.BMSTPH3S.(2022*2060) 0.4
    ITALY.BMCSPN2S.(2022*2060) 0.4
    ITALY.NGCCPH2S.(2022*2060) 0.5
    ITALY.NGCSPN2S.(2022*2060) 0.5
    
    ITALY.BATCHG.(2022*2060) 0.8
/;

TotalAnnualMaxCapacityInvestment(r,t,y)$(TotalAnnualMaxCapacityInvestment(r,t,y) = 0 AND power_plants(t) ) = 5;
TotalAnnualMaxCapacityInvestment(r,t,y)$(TotalAnnualMaxCapacityInvestment(r,t,y) = 0) = 99999;

TotalAnnualMaxCapacityInvestment(r,'HFGCPH3',y) = 0;

TotalAnnualMaxCapacityInvestment(r,'COCHPH3',y) = 0;
TotalAnnualMaxCapacityInvestment(r,'COSTPH1',y) = 0;
TotalAnnualMaxCapacityInvestment(r,'COSTPH3',y) = 0;

TotalAnnualMaxCapacityInvestment(r,'NGCHPH3',y) = 0;
TotalAnnualMaxCapacityInvestment(r,'NGGCPH2',y) = 0;

TotalAnnualMaxCapacityInvestment(r,'WIONPH3',y) = 0;

TotalAnnualMaxCapacityInvestment(r,'HFCCPH2S',y) = 0;

TotalAnnualMaxCapacityInvestment(r,'CO00X00',y) = 0;

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

ReserveMarginTagTechnology(r,t,y) = 0;
ReserveMarginTagFuel(r,f,y) = 0;
ReserveMargin(r,y) = 1.2;

*------------------------------------------------------------------------
* Parameters - RE Generation Target
*------------------------------------------------------------------------

RETagTechnology(r,t,y) = 0;

RETagFuel(r,f,y) = 0;

REMinProductionTarget(r,y) = 0;

*------------------------------------------------------------------------
* Parameters - Emissions
*------------------------------------------------------------------------
*Measured in Mton/PJ
parameter EmissionActivityRatio(r,t,e,m,y) /
    ITALY.CO00I00.CO2.1.(2015*2060)  0.0905355
    ITALY.CO00X00.CO2.1.(2015*2060)  0.0905355
    ITALY.HF00I00.CO2.1.(2015*2060)  0.0700778
    ITALY.NG00I00.CO2.1.(2015*2060)  0.05029118
    ITALY.NG00X00.CO2.1.(2015*2060)  0.05029118
    ITALY.OI00I00.CO2.1.(2015*2060)  0.0700778
    ITALY.OI00X00.CO2.1.(2015*2060)  0.0700778

*dato ancora un po' incerto,ma ha più senso (solo emissioni fossili, esclusi i rifiuti biogenici)
    ITALY.WS00X00.CO2.1.(2015*2060)  0.00005

*biomass considered net zero

*carbon capture
    ITALY.BMCSPN2.CO2.1.(2015*2060)  -0.2051944046
    ITALY.COCSPN2.CO2.1.(2015*2060)  -0.2833775418
    ITALY.NGCSPN2.CO2.1.(2015*2060)  -0.08976521937

    ITALY.BMCSPN2S.CO2.1.(2015*2060)  -0.2051944046
    ITALY.NGCSPN2S.CO2.1.(2015*2060)  -0.08976521937

*Fake emissioni per hydro,solar e wind avevano tutti 1
/;

EmissionsPenalty(r,e,y) = 0;

AnnualExogenousEmission(r,e,y) = 0;

parameter AnnualEmissionLimit(r,e,y) /
    ITALY.CO2.2015            136
    ITALY.CO2.2016          133.5
    ITALY.CO2.2017          130.4
    ITALY.CO2.2018            128
    ITALY.CO2.2019            125
    ITALY.CO2.2020          122.5
    ITALY.CO2.2021            120
    ITALY.CO2.2022          117.5
    ITALY.CO2.2023            115
    ITALY.CO2.2024          112.5
    ITALY.CO2.2025            110
    ITALY.CO2.2026          107.2
    ITALY.CO2.2027            104
    ITALY.CO2.2028          100.5
    ITALY.CO2.2029           96.5
    ITALY.CO2.2030          91.941
    ITALY.CO2.2031            87.5
    ITALY.CO2.2032             83
    ITALY.CO2.2033         78.000
    ITALY.CO2.2034          73.412
    ITALY.CO2.2035          68.824
    ITALY.CO2.2036          64.235
    ITALY.CO2.2037          59.647
    ITALY.CO2.2038          55.059
    ITALY.CO2.2039          50.471
    ITALY.CO2.2040          45.882
    ITALY.CO2.2041          41.294
    ITALY.CO2.2042          36.706
    ITALY.CO2.2043          32.118
    ITALY.CO2.2044          27.529
    ITALY.CO2.2045          22.941
    ITALY.CO2.2046          18.353
    ITALY.CO2.2047          13.765
    ITALY.CO2.2048           9.176
    ITALY.CO2.2049           4.588
    ITALY.CO2.2050             0
/;

*se sono Mt CO2eq =161,3 nel 2005, da diminuire di 43% entro il 2030
*AnnualEmissionLimit(r,'CO2','2050') = 0;

ModelPeriodExogenousEmission(r,e) = 0;

ModelPeriodEmissionLimit(r,e) = 9999;
