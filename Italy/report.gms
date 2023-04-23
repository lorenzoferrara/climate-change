alias(f,ff);
set ftm_elec(f,t,m);
set t_feeding_demand_f_using_ff(t,f,ff,m);
 
parameter rep_fen_tot(*,r,y) 'PJ/yr';
parameter rep_pes_tot(*,r,y) 'PJ/yr';
parameter rep_pes_share(*,r,f,y) '%';
parameter rep_elec_tot(*,r,y) 'PJ/yr';
parameter rep_elec_share(*,r,f,y) '%';
parameter rep_capacity_elec_tot(*,r,y) 'GW';
parameter rep_capacity_elec_share(*,r,t,y) '%';
parameter rep_investment_elec_tot(*,r,y) 'M$';
parameter rep_investment_elec_share(*,r,t,y) '%';
parameter rep_co2emiss_tot(*,r,y) 'GtonCO2';
parameter rep_co2emiss_by_fuel(*,r,f,y) 'GtonCO2';
parameter rep_sen_by_fen(*,r,ff,f,y) 'Amount of fuel ff used to feed f [PJ/yr]';
parameter rep_co2emiss_by_fen(*,r,f,y) 'GtonCO2';
parameter rep_co2emiss_share_fen(*,r,f,y) '%';
parameter rep_cost_wrt_base(*,r) '%';

$ifthen.scen not %scen%=="base" 
variable cost_base(r);
$gdxin results_base.gdx
$loaddc cost_base=ModelPeriodCostByRegion
$gdxin
$endif.scen


*------------------------------------------------------------------------	
*    - total final energy [PJ/yr]
*------------------------------------------------------------------------

* Final energy services are listed in the set f

* Quantities demanded are contained in two demand parameters, one for
* annual and one for time-slice demand (but both referring to annual
* quantitites). The Demand variable refers only to time-slice demand.
rep_fen_tot('%scen%',r,y) = sum(final_demand(f), AccumulatedAnnualDemand(r,f,y) + SpecifiedAnnualDemand(r,f,y));

*------------------------------------------------------------------------	
*    - total primary energy supply [PJ/yr]       
*------------------------------------------------------------------------

* You need to clarify what we mean by primary energy supply. In this case,
* we consider energy sources that can be used as fuels for transport,
* heating or to produce electricity, i.e. the primary_fuel set.

rep_pes_tot('%scen%',r,y) = sum(primary_fuel(f), ProductionAnnual.L(r,f,y));

*------------------------------------------------------------------------	
*    - share of primary energy sources [%]       
*------------------------------------------------------------------------

rep_pes_share('%scen%',r,f,y)$(primary_fuel(f) and rep_pes_tot('%scen%',r,y)<>0 ) = 100.*ProductionAnnual.L(r,f,y)/rep_pes_tot('%scen%',r,y);

*------------------------------------------------------------------------	
*    - total electricity production [PJ/yr]       
*------------------------------------------------------------------------

* First, we identify the combinations of ("fuel","tech","mode") such that
* electricity is produced from "fuel" using "tech" operating according to
* "mode", where "fuel" is a primary energy source (i.e. for simplicity we
* assume not to be interested in electricity supplied from storage).
ftm_elec(f,t,m) = yes$(sum((r,y)$(primary_fuel(f) and InputActivityRatio(r,t,f,m,y) and OutputActivityRatio(r,t,'E2',m,y)),1));

* ProductionAnnual is only per fuel. We need a variable which is indexed
* by technology, e.g. RateOfProductionByTechnologyByMode.
rep_elec_tot('%scen%',r,y) = sum((f,t,m,l)$ftm_elec(f,t,m),
    RateOfProductionByTechnologyByMode.l(r,l,t,m,'E2',y)*YearSplit(l,y));


*------------------------------------------------------------------------	
*    - share of electricity production by primary energy source [%]       
*------------------------------------------------------------------------
rep_elec_tot('%scen%',r,y)$(rep_elec_tot('%scen%',r,y)<EPS) = 2*EPS;
rep_elec_share('%scen%',r,f,y)$primary_fuel(f) = 100.*sum((t,m,l)$ftm_elec(f,t,m),
    RateOfProductionByTechnologyByMode.l(r,l,t,m,'E2',y)*YearSplit(l,y))/rep_elec_tot('%scen%',r,y);

*------------------------------------------------------------------------	
*    - total capacity for electricity production [GW]       
*------------------------------------------------------------------------

* Having power_plants, it is just a matter of summing TotalCapacityAnnual over power_plants
rep_capacity_elec_tot('%scen%',r,y) = sum(power_plants(t), TotalCapacityAnnual.l(r,t,y));


*------------------------------------------------------------------------	
*    - share of capacity for electricity production by technology       
*------------------------------------------------------------------------

rep_capacity_elec_share('%scen%',r,t,y)$power_plants(t) = 100.*TotalCapacityAnnual.l(r,t,y)/rep_capacity_elec_tot('%scen%',r,y);

*------------------------------------------------------------------------	
*    - total investments in capacity for electricity production [M$]       
*------------------------------------------------------------------------

* Like capacity, with the variable used for investment accounting.
rep_investment_elec_tot('%scen%',r,y) = sum(t$power_plants(t), CapitalInvestment.l(r,t,y));


*------------------------------------------------------------------------	
*    - share of investments in capacity for electricity production per technology [%]       
*------------------------------------------------------------------------

* We condition also on rep_investmenpower_plants_tot to avoid division by 0 if no
* investments are done in certain years.
rep_investment_elec_share('%scen%',r,t,y)$(power_plants(t) and rep_investment_elec_tot('%scen%',r,y)) = 100.*CapitalInvestment.l(r,t,y)/rep_investment_elec_tot('%scen%',r,y);


*------------------------------------------------------------------------	
*    - total CO2 emissions [GtonCO2]       
*------------------------------------------------------------------------

rep_co2emiss_tot('%scen%',r,y) = AnnualEmissions.l(r,'co2',y) + AnnualExogenousEmission(r,'co2',y);

*------------------------------------------------------------------------	
*    - share of CO2 emissions by final energy end use and primary energy [%]       
*------------------------------------------------------------------------

* The specific formulas to calculate such values depend on where emissions
* are accounted for. In the utopia dataset, emissions are accounted at the
* level of IMP* technologies (i.e. boxes representing import of primary
* fuels).

rep_co2emiss_by_fuel('%scen%',r,f,y) = sum((t,m)$(OutputActivityRatio(r,t,f,m,y) and EmissionActivityRatio(r,t,'co2',m,y)), EmissionActivityRatio(r,t,'co2',m,y)*ProductionByTechnologyAnnual.l(r,t,f,y));

*------------------------------------------------------------------------	
*   - cost wrt base case
*------------------------------------------------------------------------

$if not %scen%=="base" rep_cost_wrt_base('%scen%',r) = 100*(ModelPeriodCostByRegion.l(r)/cost_base.l(r)-1);


execute_unload 'report_%scen%.gdx',
rep_fen_tot
rep_pes_tot
rep_pes_share
rep_elec_tot
rep_elec_share
rep_capacity_elec_tot
rep_capacity_elec_share
rep_investment_elec_share
rep_investment_elec_share
rep_co2emiss_tot
rep_co2emiss_by_fuel
rep_cost_wrt_base
;
