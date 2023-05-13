$stitle Model declarations except equations

* ============================================================================
* OSEMOSYS_DEC.GMS - declarations for sets, parameters, variables (but not equations)
* ============================================================================
* 2011.07.07 conversion to GAMS by Ken Noble, Noble-Soft Systems - August 2012
* 2017.11.08 update by Thorsten Burandt, Konstantin Löffler and Karlo Hainsch, TU Berlin (Workgroup for Infrastructure Policy) - October 2017
* 2022.03.28 add explanatory comments from documentation, improve formatting, by Giacomo Marangoni
* ============================================================================



*------------------------------------------------------------------------	
* SETS       
*------------------------------------------------------------------------

* YEAR / y: It represents the time frame of the model, it contains all the
* years to be considered in the study.
set YEAR;
alias (y,yy,yyy,YEAR);

* TECHNOLOGY / t: It includes any element of the energy system that
* changes a commodity from one form to another, uses it or supplies
* it. All system components are set up as a ‘technology’ in OSeMOSYS. As
* the model is an abstraction, the modeller is free to interpret the role
* of a technology at will, where relevant. It may for example represent a
* single real technology (such as a power plant) or can represent a
* heavily aggregated collection of technologies (such as the stock of
* several million light bulbs), or may even simply be a ‘dummy
* technology’, perhaps used for accounting purposes.
set TECHNOLOGY;
alias (t,TECHNOLOGY)

* TIMESLICE / l: It represents the time split of each modelled year,
* therefore the time resolution of the model. Common to several energy
* systems modelling tools (incl. MESSAGE / MARKAL / TIMES), the annual
* demand is ‘sliced’ into representative fractions of the year. It is
* necessary to assess times of the year when demand is high separately
* from times when demand is low, for fuels that are expensive to store. In
* order to reduce the computation time, these ‘slices’ are often
* grouped. Thus, the annual demand may be split into aggregate seasons
* where demand levels are similar (such as ‘summer, winter and
* intermediate’). Those seasons may be subdivided into aggregate ‘day
* types’ (such as workdays and weekends), and the day further sub divided
* (such as into day and night) depending on the level of demand.
set TIMESLICE;
alias (l,TIMESLICE);

* FUEL / f: It includes any energy vector, energy service or proxies
* entering or exiting technologies. These can be aggregate groups,
* individual flows or artificially separated, depending on the
* requirements of the analysis.
set FUEL;
alias (f,FUEL);

* EMISSION / e: It includes any kind of emission potentially deriving from
* the operation of the defined technologies. Typical examples would
* include atmospheric emissions of greenhouse gasses, such as CO2.
set EMISSION;
alias (e,EMISSION);

* MODE_OF_OPERATION / m: It defines the number of modes of operation that
* the technologies can have. If a technology can have various input or
* output fuels and it can choose the mix (i.e.  any linear combination) of
* these input or output fuels, each mix can be accounted as a separate
* mode of operation. For example, a CHP plant may produce heat in one mode
* of operation and electricity in another.
set MODE_OF_OPERATION;
alias (m,MODE_OF_OPERATION);

* REGION / r: It sets the regions to be modelled, e.g. different
* countries. For each of them, the supply-demand balances for all the
* energy vectors are ensured, including trades with other regions. In some
* occasions it might be computationally more convenient to model different
* countries within the same region and differentiate them simply by
* creating ad hoc fuels and technologies for each of them.
set REGION;
alias (r,REGION,rr);

* SEASON / ls: It gives indication (by successive numerical values) of how
* many seasons (e.g. winter, intermediate, summer) are accounted for and
* in which order.  This set is needed if storage facilities are included
* in the model.
set SEASON;
alias (ls,SEASON,lsls);

* DAYTYPE / ld: It gives indication (by successive numerical values) of
* how many day types (e.g. workday, weekend) are accounted for and in
* which order.  This set is needed if storage facilities are included in
* the model.
set DAYTYPE;
alias (ld,DAYTYPE,ldld);

* DAILYTIMEBRACKET / lh: It gives indication (by successive numerical
* values) of how many parts the day is split into (e.g. night, morning,
* afternoon, evening) and in which order these parts are sorted.  This set
* is needed if storage facilities are included in the model.
set DAILYTIMEBRACKET;
alias (lh,DAILYTIMEBRACKET,lhlh);

* STORAGE / s: It includes storage facilities in the model.
set STORAGE;
alias (s,STORAGE);



*------------------------------------------------------------------------	
* PARAMETERS       
*------------------------------------------------------------------------


*------------------------------------------------------------------------	
* * Global       
*------------------------------------------------------------------------

* YearSplit[l,y]: Duration of a modelled time slice, expressed as a
* fraction of the year. The sum of each entry over one modelled year
* should equal 1.
parameter YearSplit(TIMESLICE,YEAR);

* DiscountRate[r]: Region specific value for the discount rate, expressed
* in decimals (e.g. 0.05)
parameter DiscountRate(REGION);

*OLD VERSION
* DaySplit[lh,y]: Length of one DailyTimeBracket in one specific day as a
* fraction of the year (e.g., when distinguishing between days and night:
* 12h/(24h*365d)).
* parameter DaySplit(YEAR,DAILYTIMEBRACKET);

*OUR VERSION
* DaySplit[lh,y,ls]: Length of one DailyTimeBracket in one specific day as a
* fraction of the year 
parameter DaySplit(YEAR,DAILYTIMEBRACKET,SEASON);

* Conversionls[l,ls]: Binary parameter linking one TimeSlice to a certain
* Season. It has value 0 if the TimeSlice does not pertain to the specific
* season, 1 if it does.
parameter Conversionls(TIMESLICE,SEASON);

* Conversionld[ld,l]: Binary parameter linking one TimeSlice to a certain
* DayType. It has value 0 if the TimeSlice does not pertain to the
* specific DayType, 1 if it does.
parameter Conversionld(TIMESLICE,DAYTYPE);

* Conversionlh[lh,l]: Binary parameter linking one TimeSlice to a certain
* DaylyTimeBracket. It has value 0 if the TimeSlice does not pertain to
* the specific DaylyTimeBracket, 1 if it does.
parameter Conversionlh(TIMESLICE,DAILYTIMEBRACKET);

* DaysInDayType[ls,ld,y]: Number of days for each day type, within one
* week (natural number, ranging from 1 to 7)
parameter DaysInDayType(YEAR,SEASON,DAYTYPE);

* TradeRoute[r,rr,f,y]: Binary parameter defining the links between region
* r and region rr, to enable or disable trading of a specific
* commodity. It has value 1 when two regions are linked, 0 otherwise
parameter TradeRoute(REGION,rr,FUEL,YEAR);

* DepreciationMethod[r]: Binary parameter defining the type of
* depreciation to be applied. It has value 1 for sinking fund
* depreciation, value 2 for straight-line depreciation.
parameter DepreciationMethod(REGION);



*------------------------------------------------------------------------	
* * Demand       
*------------------------------------------------------------------------

* SpecifiedAnnualDemand[r,f,y]: Total specified demand for the year,
* linked to a specific 'time of use' during the year.
parameter SpecifiedAnnualDemand(REGION,FUEL,YEAR);

* SpecifiedDemandProfile[r,f,l,y]: Annual fraction of energy-service or
* commodity demand that is required in each time slice. For each year, all
* the defined SpecifiedDemandProfile input values should sum up to 1.
parameter SpecifiedDemandProfile(REGION,FUEL,TIMESLICE,YEAR);

* AccumulatedAnnualDemand[r,f,y]: Accumulated Demand for a certain
* commodity in one specific year. It cannot be defined for a commodity if
* its SpecifiedAnnualDemand for the same year is already defined and vice
* versa.
parameter AccumulatedAnnualDemand(REGION,FUEL,YEAR);



*------------------------------------------------------------------------	
* * Performance       
*------------------------------------------------------------------------

* CapacityToActivityUnit[r,t]: Conversion factor relating the energy that
* would be produced when one unit of capacity is fully used in one year.
parameter CapacityToActivityUnit(REGION,TECHNOLOGY);

* CapacityFactor[r,t,l,y]: Capacity available per each TimeSlice expressed
* as a fraction of the total installed capacity, with values ranging from
* 0 to 1. It gives the possibility to account for forced outages.
parameter CapacityFactor(REGION,TECHNOLOGY,TIMESLICE,YEAR);

* AvailabilityFactor[r,t,y]: Maximum time a technology can run in the
* whole year, as a fraction of the year ranging from 0 to 1. It gives the
* possibility to account for planned outages.
parameter AvailabilityFactor(REGION,TECHNOLOGY,YEAR);

* OperationalLife[r,t]: Useful lifetime of a technology, expressed in
* years.
parameter OperationalLife(REGION,TECHNOLOGY);

* ResidualCapacity[r,t,y]: Remained capacity available from before the
* modelling period.
parameter ResidualCapacity(REGION,TECHNOLOGY,YEAR);

* InputActivityRatio[r,t,f,m,y]: Rate of use of a commodity by a
* technology, as a ratio of the rate of activity.
parameter InputActivityRatio(REGION,TECHNOLOGY,FUEL,MODE_OF_OPERATION,YEAR);

* OutputActivityRatio[r,t,f,m,y]: Rate of commodity output from a
* technology, as a ratio of the rate of activity.
parameter OutputActivityRatio(REGION,TECHNOLOGY,FUEL,MODE_OF_OPERATION,YEAR);


*------------------------------------------------------------------------	
* * Technology costs       
*------------------------------------------------------------------------

* CapitalCost[r,t,y]: Capital investment cost of a technology, per unit of
* capacity.
parameter CapitalCost(REGION,TECHNOLOGY,YEAR);

* VariableCost[r,t,m,y]: Cost of a technology for a given mode of
* operation (Variable O&M cost), per unit of activity.
parameter VariableCost(REGION,TECHNOLOGY,MODE_OF_OPERATION,YEAR);

* FixedCost[r,t,y]: Fixed O&M cost of a technology, per unit of capacity.
parameter FixedCost(REGION,TECHNOLOGY,YEAR);



*------------------------------------------------------------------------	
* * Storage parameters       
*------------------------------------------------------------------------

* TechnologyToStorage[r,t,s,m]: Binary parameter linking a technology to
* the storage facility it charges. It has value 1 if the technology and
* the storage facility are linked, 0 otherwise.
parameter TechnologyToStorage(REGION,MODE_OF_OPERATION,TECHNOLOGY,STORAGE);

* TechnologyFromStorage[r,t,s,m]: Binary parameter linking a storage
* facility to the technology it feeds. It has value 1 if the technology
* and the storage facility are linked, 0 otherwise.
parameter TechnologyFromStorage(REGION,MODE_OF_OPERATION,TECHNOLOGY,STORAGE);

* StorageLevelStart[r,s]: Level of storage at the beginning of first
* modelled year, in units of activity.
parameter StorageLevelStart(REGION,STORAGE);

* StorageMaxChargeRate[r,s]: Maximum charging rate for the storage, in
* units of activity per year.
parameter StorageMaxChargeRate(REGION,STORAGE);

* StorageMaxDischargeRate[r,s]: Maximum discharging rate for the storage,
* in units of activity per year.
parameter StorageMaxDischargeRate(REGION,STORAGE);

* MinStorageCharge[r,s,y]: It sets a lower bound to the amount of energy
* stored, as a fraction of the maximum, with a number reanging between 0
* and 1. The storage facility cannot be emptied below this level.
parameter MinStorageCharge(REGION,STORAGE,YEAR);

* OperationalLifeStorage[r,s]: Useful lifetime of the storage facility.
parameter OperationalLifeStorage(REGION,STORAGE);

* CapitalCostStorage[r,s,y]: Investment costs of storage additions,
* defined per unit of storage capacity.
parameter CapitalCostStorage(REGION,STORAGE,YEAR);

* ResidualStorageCapacity[r,s,y]: Exogenously defined storage capacities.
parameter ResidualStorageCapacity(REGION,STORAGE,YEAR);



*------------------------------------------------------------------------	
* * Capacity constraints       
*------------------------------------------------------------------------

* CapacityOfOneTechnologyUnit[r,t,y]: Capacity of one new unit of a
* technology. In case the user sets this parameter, the related technology
* will be installed only in batches of the specified capacity and the
* problem will turn into a Mixed Integer Linear Problem.
parameter CapacityOfOneTechnologyUnit(REGION,TECHNOLOGY,YEAR);

* TotalAnnualMaxCapacity[r,t,y]: Total maximum existing (residual plus
* cumulatively installed) capacity allowed for a technology in a specified
* year.
parameter TotalAnnualMaxCapacity(REGION,TECHNOLOGY,YEAR);

* TotalAnnualMinCapacity[r,t,y]: Total minimum existing (residual plus
* cumulatively installed) capacity allowed for a technology in a specified
* year.
parameter TotalAnnualMinCapacity(REGION,TECHNOLOGY,YEAR);



*------------------------------------------------------------------------	
* * Investment constraints       
*------------------------------------------------------------------------


* TotalAnnualMaxCapacityInvestment[r,t,y]: Maximum capacity of a
* technology, expressed in power units.
parameter TotalAnnualMaxCapacityInvestment(REGION,TECHNOLOGY,YEAR);

* TotalAnnualMinCapacityInvestment[r,t,y]: Minimum capacity of a
* technology, expressed in power units.
parameter TotalAnnualMinCapacityInvestment(REGION,TECHNOLOGY,YEAR);


*------------------------------------------------------------------------	
* * Activity constraints       
*------------------------------------------------------------------------


* TotalTechnologyAnnualActivityUpperLimit[r,t,y]: Total maximum level of
* activity allowed for a technology in one year.
parameter TotalTechnologyAnnualActivityUpperLimit(REGION,TECHNOLOGY,YEAR);

* TotalTechnologyAnnualActivityLowerLimit[r,t,y]: Total minimum level of
* activity allowed for a technology in one year.
parameter TotalTechnologyAnnualActivityLowerLimit(REGION,TECHNOLOGY,YEAR);

* TotalTechnologyModelPeriodActivityUpperLimit[r,t]: Total maximum level
* of activity allowed for a technology in the entire modelled period.
parameter TotalTechnologyModelPeriodActivityUpperLimit(REGION,TECHNOLOGY);

* TotalTechnologyModelPeriodActivityLowerLimit[r,t]: Total minimum level
* of activity allowed for a technology in the entire modelled period.
parameter TotalTechnologyModelPeriodActivityLowerLimit(REGION,TECHNOLOGY);


*------------------------------------------------------------------------	
* * Reserve margin       
*------------------------------------------------------------------------

* ReserveMarginTagTechnology[r,t,y]: Binary parameter tagging the
* technologies that are allowed to contribute to the reserve margin. It
* has value 1 for the technologies allowed, 0 otherwise.
parameter ReserveMarginTagTechnology(REGION,TECHNOLOGY,YEAR);

* ReserveMarginTagFuel[r,f,y]: Binary parameter tagging the fuels to which
* the reserve margin applies. It has value 1 if the reserve margin applies
* to the fuel, 0 otherwise.
parameter ReserveMarginTagFuel(REGION,FUEL,YEAR);

* ReserveMargin[r,y]: Minimum level of the reserve margin required to be
* provided for all the tagged commodities, by the tagged technologies. If
* no reserve margin is required, the parameter will have value 1; if, for
* instance, 20% reserve margin is required, the parameter will have value
* 1.2.
parameter ReserveMargin(REGION,YEAR);



*------------------------------------------------------------------------	
* * RE generation target       
*------------------------------------------------------------------------

* RETagTechnology[r,t,y]: Binary parameter tagging the renewable
* technologies that must contribute to reaching the indicated minimum
* renewable production target. It has value 1 for thetechnologies
* contributing, 0 otherwise.
parameter RETagTechnology(REGION,TECHNOLOGY,YEAR);

* RETagFuel[r,f,y]: Binary parameter tagging the fuels to which the
* renewable target applies to. It has value 1 if the target applies, 0
* otherwise.
parameter RETagFuel(REGION,FUEL,YEAR);

* REMinProductionTarget[r,y]: Minimum ratio of all renewable commodities
* tagged in the RETagCommodity parameter, to be produced by the
* technologies tagged with the RETechnology parameter.
parameter REMinProductionTarget(REGION,YEAR);


*------------------------------------------------------------------------	
* * Emissions & Penalties
*------------------------------------------------------------------------

* EmissionActivityRatio[r,t,e,m,y]: Emission factor of a technology per
* unit of activity, per mode of operation.
parameter EmissionActivityRatio(REGION,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,YEAR);

* EmissionsPenalty[r,e,y]: Penalty per unit of emission.
parameter EmissionsPenalty(REGION,EMISSION,YEAR);

* AnnualExogenousEmission[r,e,y]: It allows the user to account for
* additional annual emissions, on top of those computed endogenously by
* the model (e.g. emissions generated outside the region).
parameter AnnualExogenousEmission(REGION,EMISSION,YEAR);

* AnnualEmissionLimit[r,e,y]: Annual upper limit for a specific emission
* generated in the whole modelled region.
parameter AnnualEmissionLimit(REGION,EMISSION,YEAR);

* ModelPeriodExogenousEmission[r,e]: It allows the user to account for
* additional emissions over the entire modelled period, on top of those
* computed endogenously by the model (e.g. generated outside the region).
parameter ModelPeriodExogenousEmission(REGION,EMISSION);

* ModelPeriodEmissionLimit[r,e]: Annual upper limit for a specific
* emission generated in the whole modelled region, over the entire
* modelled period.
parameter ModelPeriodEmissionLimit(REGION,EMISSION);




*------------------------------------------------------------------------	
* VARIABLES       
*------------------------------------------------------------------------



*------------------------------------------------------------------------	
* * Demand       
*------------------------------------------------------------------------

* RATEOFDEMAND[r,l,f,y]>=0: Intermediate variable. It represents the
* energy that would be demanded in one time slice l if the latter lasted
* the whole year. It is a function of the parameters SpecifiedAnnualDemand
* and SpecifiedDemandProfile. [Energy (per year)]
positive variable RATEOFDEMAND(REGION,TIMESLICE,FUEL,YEAR);

* DEMAND[r,l,f,y]>=0: Demand for one fuel in one time slice. [Energy]
positive variable DEMAND(REGION,TIMESLICE,FUEL,YEAR);



*------------------------------------------------------------------------
* * Storage
*------------------------------------------------------------------------

* RATEOFSTORAGECHARGE[r,s,ls,ld,lh,y]: Intermediate variable. It
* represents the commodity that would be charged to the storage facility s
* in one time slice if the latter lasted the whole year. It is a function
* of the RateOfActivity and the parameter TechnologyToStorage. [Energy
* (per year)]
free variable  RATEOFSTORAGECHARGE(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,YEAR);

* RATEOFSTORAGEDISCHARGE[r,s,ls,ld,lh,y]: Intermediate variable. It
* represents the commodity that would be discharged from storage facility
* s in one time slice if the latter lasted the whole year. It is a
* function of the RateOfActivity and the parameter
* TechnologyFromStorage. [Energy (per year)]
free variable  RATEOFSTORAGEDISCHARGE(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,YEAR);

* NETCHARGEWITHINYEAR[r,s,ls,ld,lh,y]: Net quantity of commodity charged
* to storage facility s in year y. It is a function of the
* RateOfStorageCharge and the RateOfStorageDischarge and it can be
* negative. [Energy]
free variable  NETCHARGEWITHINYEAR(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,YEAR);

* NETCHARGEWITHINDAY[r,s,ls,ld,lh,y]: Net quantity of commodity charged to
* storage facility s in daytype ld. It is a function of the
* RateOfStorageCharge and the RateOfStorageDischarge and can be
* negative. [Energy]
free variable NETCHARGEWITHINDAY(REGION,STORAGE,SEASON,DAYTYPE,DAILYTIMEBRACKET,YEAR);

* STORAGELEVELYEARSTART[r,s,y]>=0: Level of stored commodity in storage
* facility s in the first time step of year y. [Energy]
positive variable STORAGELEVELYEARSTART(REGION,STORAGE,YEAR);

* STORAGELEVELYEARFINISH[r,s,y]>=0: Level of stored commodity in storage
* facility s in the last time step of year y. [Energy]
positive variable STORAGELEVELYEARFINISH(REGION,STORAGE,YEAR);

* STORAGELEVELSEASONSTART[r,s,ls,y]>=0: Level of stored commodity in
* storage facility s in the first time step of season ls. [Energy]
positive variable STORAGELEVELSEASONSTART(REGION,STORAGE,SEASON,YEAR);

* STORAGELEVELDAYTYPESTART[r,s,ls,ld,y]>=0: Level of stored commodity in
* storage facility s in the first time step of daytype ld. [Energy]
positive variable STORAGELEVELDAYTYPESTART(REGION,STORAGE,SEASON,DAYTYPE,YEAR);

* STORAGELEVELDAYTYPEFINISH[r,s,ls,ld,y]>=0: Level of stored commodity in
* storage facility s in the last time step of daytype ld. [Energy]
positive variable STORAGELEVELDAYTYPEFINISH(REGION,STORAGE,SEASON,DAYTYPE,YEAR);

* STORAGELOWERLIMIT[r,s,y]>=0: Minimum allowed level of stored commodity
* in storage facility s, as a function of the storage capacity and the
* user-defined MinStorageCharge ratio. [Energy]
positive variable STORAGELOWERLIMIT(REGION,STORAGE,YEAR);

* STORAGEUPPERLIMIT[r,s,y]>=0: Maximum allowed level of stored commodity
* in storage facility s. It corresponds to the total existing capacity of
* storage facility s (summing newly installed and pre-existing
* capacities). [Energy]
positive variable STORAGEUPPERLIMIT(REGION,STORAGE,YEAR);

* ACCUMULATEDNEWSTORAGECAPACITY[r,s,y]>=0: Cumulative capacity of newly
* installed storage from the beginning of the time domain to year
* y. [Energy]
positive variable ACCUMULATEDNEWSTORAGECAPACITY(REGION,STORAGE,YEAR);

* NEWSTORAGECAPACITY[r,s,y]>=0: Capacity of newly installed storage in
* year y. [Energy]
positive variable NEWSTORAGECAPACITY(REGION,STORAGE,YEAR);

* CAPITALINVESTMENTSTORAGE[r,s,y]>=0: Undiscounted investment in new
* capacity for storage facility s. Derived from the NewStorageCapacity and
* the parameter CapitalCostStorage. [Monetary units]
positive variable CAPITALINVESTMENTSTORAGE(REGION,STORAGE,YEAR);

* DISCOUNTEDCAPITALINVESTMENTSTORAGE[r,s,y]>=0: Investment in new capacity
* for storage facility s, discounted through the parameter
* DiscountRate. [Monetary units]
positive variable DISCOUNTEDCAPITALINVESTMENTSTORAGE(REGION,STORAGE,YEAR);

* SALVAGEVALUESTORAGE[r,s,y]>=0: Salvage value of storage facility s in
* year y, as a function of the parameters OperationalLifeStorage and
* DepreciationMethod. [Monetary units]
positive variable SALVAGEVALUESTORAGE(REGION,STORAGE,YEAR);

* DISCOUNTEDSALVAGEVALUESTORAGE[r,s,y]>=0: Salvage value of storage
* facility s, discounted through the parameter DiscountRate. [Monetary
* units]
positive variable DISCOUNTEDSALVAGEVALUESTORAGE(REGION,STORAGE,YEAR);

* TOTALDISCOUNTEDSTORAGECOST[r,s,y]>=0: Difference between the discounted
* capital investment in new storage facilities and the salvage value in
* year y. [Monetary units]
positive variable TOTALDISCOUNTEDSTORAGECOST(REGION,STORAGE,YEAR);


*------------------------------------------------------------------------
* * Capacity variables
*------------------------------------------------------------------------

* NUMBEROFNEWTECHNOLOGYUNITS[r,t,y]>=0, integer: Number of newly installed
* units of technology t in year y, as a function of the parameter
* CapacityOfOneTechnologyUnit. [No unit]
integer variable NUMBEROFNEWTECHNOLOGYUNITS(REGION,TECHNOLOGY,YEAR);

* NEWCAPACITY[r,t,y]>=0: Newly installed capacity of technology t in year
* y. [Power]
positive variable NEWCAPACITY(REGION,TECHNOLOGY,YEAR);

* ACCUMULATEDNEWCAPACITY[r,t,y]>=0: Cumulative newly installed capacity of
* technology t from the beginning of the time domain to year y. [Power]
positive variable ACCUMULATEDNEWCAPACITY(REGION,TECHNOLOGY,YEAR);

* TOTALCAPACITYANNUAL[r,t,y]>=0: Total existing capacity of technology t
* in year y (sum of cumulative newly installed and pre-existing
* capacity). [Power]
positive variable TOTALCAPACITYANNUAL(REGION,TECHNOLOGY,YEAR);


*------------------------------------------------------------------------	
* * Activity        
*------------------------------------------------------------------------

* RATEOFACTIVITY[r,l,t,m,y] >=0: Intermediate variable. It represents the
* activity of technology t in one mode of operation and in time slice l,
* if the latter lasted the whole year. [Energy (per year)]
positive variable RATEOFACTIVITY(REGION,TIMESLICE,TECHNOLOGY,MODE_OF_OPERATION,YEAR);
* RATEOFTOTALACTIVITY[r,t,l,y] >=0: Sum of the RateOfActivity of a
* technology over the modes of operation. [Energy (per year)]
positive variable RATEOFTOTALACTIVITY(REGION,TIMESLICE,TECHNOLOGY,YEAR);
* TOTALTECHNOLOGYANNUALACTIVITY[r,t,y] >=0: Total annual activity of
* technology t. [Energy]

* TOTALTECHNOLOGYANNUALACTIVITY[r,t,y] >=0: Total annual activity of
* technology t. [Energy]
positive variable TOTALTECHNOLOGYANNUALACTIVITY(REGION,TECHNOLOGY,YEAR);

* TOTALANNUALTECHNOLOGYACTIVITYBYMODE[r,t,m,y] >=0: Annual activity of
* technology t in mode of operation m. [Energy]
positive variable TOTALANNUALTECHNOLOGYACTIVITYBYMODE(REGION,TECHNOLOGY,MODE_OF_OPERATION,YEAR);

* RATEOFPRODUCTIONBYTECHNOLOGYBYMODE[r,l,t,m,f,y] >=0: Intermediate variable. It represents the quantity of fuel f that technology t would produce in one mode of operation and in time slice l, if the latter lasted the whole year. It is a function of the variable RateOfActivity and the parameter OutputActivityRatio. [Energy (per year)]
positive variable RATEOFPRODUCTIONBYTECHNOLOGYBYMODE(REGION,TIMESLICE,TECHNOLOGY,MODE_OF_OPERATION,FUEL,YEAR);

* RATEOFPRODUCTIONBYTECHNOLOGY[r,l,t,f,y] >=0: Sum of the
* RateOfProductionByTechnologyByMode over the modes of operation. [Energy
* (per year)]
positive variable RATEOFPRODUCTIONBYTECHNOLOGY(REGION,TIMESLICE,TECHNOLOGY,FUEL,YEAR);

* PRODUCTIONBYTECHNOLOGY[r,l,t,f,y] >=0: Production of fuel f by
* technology t in time slice l. [Energy]
positive variable PRODUCTIONBYTECHNOLOGY(REGION,TIMESLICE,TECHNOLOGY,FUEL,YEAR);

* PRODUCTIONBYTECHNOLOGYANNUAL[r,t,f,y] >=0: Annual production of fuel f
* by technology t. [Energy]
positive variable PRODUCTIONBYTECHNOLOGYANNUAL(REGION,TECHNOLOGY,FUEL,YEAR);

* RATEOFPRODUCTION[r,l,f,y] >=0: Sum of the RateOfProductionByTechnology
* over all the technologies. [Energy (per year)]
positive variable RATEOFPRODUCTION(REGION,TIMESLICE,FUEL,YEAR);

* PRODUCTION[r,l,f,y] >=0: Total production of fuel f in time slice l. It
* is the sum of the ProductionByTechnology over all technologies. [Energy]
positive variable PRODUCTION(REGION,TIMESLICE,FUEL,YEAR);

* RATEOFUSEBYTECHNOLOGYBYMODE[r,l,t,m,f,y] >=0: Intermediate variable. It
* represents the quantity of fuel f that technology t would use in one
* mode of operation and in time slice l, if the latter lasted the whole
* year. It is the function of the variable RateOfActivity and the
* parameter InputActivityRatio. [Energy (per year)]
positive variable RATEOFUSEBYTECHNOLOGYBYMODE(REGION,TIMESLICE,TECHNOLOGY,MODE_OF_OPERATION,FUEL,YEAR);

* RATEOFUSEBYTECHNOLOGY[r,l,t,f,y] >=0: Sum of the
* RateOfUseByTechnologyByMode over the modes of operation. [Energy (per
* year)]
positive variable RATEOFUSEBYTECHNOLOGY(REGION,TIMESLICE,TECHNOLOGY,FUEL,YEAR);

* USEBYTECHNOLOGYANNUAL[r,t,f,y] >=0: Annual use of fuel f by technology
* t. [Energy]
positive variable USEBYTECHNOLOGYANNUAL(REGION,TECHNOLOGY,FUEL,YEAR);

* RATEOFUSE[r,l,f,y] >=0: Sum of the RateOfUseByTechnology
* over all the technologies. [Energy (per year)]
positive variable RATEOFUSE(REGION,TIMESLICE,FUEL,YEAR);

* USEBYTECHNOLOGY[r,l,t,f,y] >=0: Use of fuel f by technology t in time
* slice l. [Energy]
positive variable USEBYTECHNOLOGY(REGION,TIMESLICE,TECHNOLOGY,FUEL,YEAR);

* USE[r,l,f,y] >=0: Total use of fuel f in time slice l. It is the sum of
* the UseByTechnology over all technologies. [Energy]
positive variable USE(REGION,TIMESLICE,FUEL,YEAR);

* TRADE[r,rr,l,f,y]: Quantity of fuel f traded between region r and rr in
* time slice l. [Energy]
positive variable TRADE(REGION,rr,TIMESLICE,FUEL,YEAR);

* TRADEANNUAL[r,rr,f,y]: Annual quantity of fuel f traded between region r
* and rr. It is the sum of the variable Trade over all the time
* slices. [Energy]
positive variable TRADEANNUAL(REGION,rr,FUEL,YEAR);

* PRODUCTIONANNUAL[r,f,y] >=0: Total annual production of fuel f. It is
* the sum of the variable Production over all technologies. [Energy]
positive variable PRODUCTIONANNUAL(REGION,FUEL,YEAR);

* USEANNUAL[r,f,y] >=0: Total annual use of fuel f. It is the sum of the
* variable Use over all technologies. [Energy]
positive variable USEANNUAL(REGION,FUEL,YEAR);


*------------------------------------------------------------------------	
* * Costing variables       
*------------------------------------------------------------------------

* CAPITALINVESTMENT[r,t,y] >=0: Undiscounted investment in new capacity of
* technology t. It is a function of the NewCapacity and the parameter
* CapitalCost. [Monetary units]
positive variable CAPITALINVESTMENT(REGION,TECHNOLOGY,YEAR);

* DISCOUNTEDCAPITALINVESTMENT[r,t,y] >=0: Investment in new capacity of
* technology t, discounted through the parameter DiscountRate. [Monetary
* units]
positive variable DISCOUNTEDCAPITALINVESTMENT(REGION,TECHNOLOGY,YEAR);

* SALVAGEVALUE[r,t,y] >=0: Salvage value of technology t in year y, as a
* function of the parameters OperationalLife and
* DepreciationMethod. [Monetary units]
positive variable SALVAGEVALUE(REGION,TECHNOLOGY,YEAR);

* DISCOUNTEDSALVAGEVALUE[r,t,y] >=0: Salvage value of technology t,
* discounted through the parameter DiscountRate. [Monetary units]
positive variable DISCOUNTEDSALVAGEVALUE(REGION,TECHNOLOGY,YEAR);

* OPERATINGCOST[r,t,y] >=0: Undiscounted sum of the annual variable and
* fixed operating costs of technology t. [Monetary units]
positive variable OPERATINGCOST(REGION,TECHNOLOGY,YEAR);

* DISCOUNTEDOPERATINGCOST[r,t,y] >=0: Annual OperatingCost of technology
* t, discounted through the parameter DiscountRate. [Monetary units]
positive variable DISCOUNTEDOPERATINGCOST(REGION,TECHNOLOGY,YEAR);

* ANNUALVARIABLEOPERATINGCOST[r,t,y] >=0: Annual variable operating cost
* of technology t. Derived from the TotalAnnualTechnologyActivityByMode
* and the parameter VariableCost. [Monetary units]
positive variable ANNUALVARIABLEOPERATINGCOST(REGION,TECHNOLOGY,YEAR);

* ANNUALFIXEDOPERATINGCOST[r,t,y] >=0: Annual fixed operating cost of
* technology t. Derived from the TotalCapacityAnnual and the parameter
* FixedCost. [Monetary units]
positive variable ANNUALFIXEDOPERATINGCOST(REGION,TECHNOLOGY,YEAR);

* TOTALDISCOUNTEDCOSTBYTECHNOLOGY[r,t,y] >=0: Difference between the sum
* of discounted operating cost / capital cost / emission penalties and the
* salvage value. [Monetary units]
positive variable TOTALDISCOUNTEDCOSTBYTECHNOLOGY(REGION,TECHNOLOGY,YEAR);

* TOTALDISCOUNTEDCOST[r,y] >=0: Sum of the TotalDiscountedCostByTechnology
* over all the technologies. [Monetary units]
positive variable TOTALDISCOUNTEDCOST(REGION,YEAR);

* MODELPERIODCOSTBYREGION[r] >=0: Sum of the TotalDiscountedCost over all
* modelled years. [Monetary units]
positive variable MODELPERIODCOSTBYREGION(REGION);



*------------------------------------------------------------------------	
* * Reserve margin      
*------------------------------------------------------------------------

* TOTALCAPACITYINRESERVEMARGIN[r,y] >=0: Total available capacity of the
* technologies required to provide reserve margin. It is derived from the
* TotalCapacityAnnual and the parameter
* ReserveMarginTagTechnology. [Energy]
positive variable TOTALCAPACITYINRESERVEMARGIN(REGION,YEAR);

* DEMANDNEEDINGRESERVEMARGIN[r,l,y] >=0: Quantity of fuel produced that is
* assigned to a target of reserve margin. Derived from the
* RateOfProduction and the parameter ReserveMarginTagFuel. [Energy (per
* year)]
positive variable DEMANDNEEDINGRESERVEMARGIN(REGION,TIMESLICE,YEAR);


*------------------------------------------------------------------------	
* * RE generation target       
*------------------------------------------------------------------------

* TOTALREPRODUCTIONANNUAL[r,y]: Annual production by all technologies
* tagged as renewable in the model. Derived from the
* ProductionByTechnologyAnnual and the parameter RETagTechnology. [Energy]
free variable TOTALREPRODUCTIONANNUAL(REGION,YEAR);

* RETOTALPRODUCTIONOFTARGETFUELANNUAL[r,y]: Annual production of fuels
* tagged as renewable in the model. Derived from the RateOfProduction and
* the parameter RETagFuel. [Energy]
free variable RETOTALPRODUCTIONOFTARGETFUELANNUAL(REGION,YEAR);

* TOTALTECHNOLOGYMODELPERIODACTIVITY[r,t]: Sum of the
* TotalTechnologyAnnualActivity over the years of the modelled
* period. [Energy]
free variable TOTALTECHNOLOGYMODELPERIODACTIVITY(REGION,TECHNOLOGY);


*------------------------------------------------------------------------	
* Emissions       
*------------------------------------------------------------------------

* ANNUALTECHNOLOGYEMISSIONBYMODE[r,t,e,m,y] >=0: Annual emission of agent
* e by technology t in mode of operation m. Derived from the
* RateOfActivity and the parameter EmissionActivityRatio. [Quantity of
* emission]
positive variable ANNUALTECHNOLOGYEMISSIONBYMODE(REGION,TECHNOLOGY,EMISSION,MODE_OF_OPERATION,YEAR);

* ANNUALTECHNOLOGYEMISSION[r,t,e,y] >=0: Sum of the
* AnnualTechnologyEmissionByMode over the modes of operation. [Quantity of
* emission]
positive variable ANNUALTECHNOLOGYEMISSION(REGION,TECHNOLOGY,EMISSION,YEAR);

* ANNUALTECHNOLOGYEMISSIONPENALTYBYEMISSION[r,t,e,y] >=0: Undiscounted
* annual cost of emission e by technology t. It is a function of the
* AnnualTechnologyEmission and the parameter EmissionPenalty. [Monetary
* units]
positive variable ANNUALTECHNOLOGYEMISSIONPENALTYBYEMISSION(REGION,TECHNOLOGY,EMISSION,YEAR);

* ANNUALTECHNOLOGYEMISSIONSPENALTY[r,t,y] >=0: Total undiscounted annual
* cost of all emissions generated by technology t. Sum of the
* AnnualTechnologyEmissionPenaltyByEmission over all the emitted
* agents. [Monetary units]
positive variable ANNUALTECHNOLOGYEMISSIONSPENALTY(REGION,TECHNOLOGY,YEAR);

* DISCOUNTEDTECHNOLOGYEMISSIONSPENALTY[r,t,y] >=0: Annual cost of
* emissions by technology t, discounted through the
* DiscountRate. [Monetary units]
positive variable DISCOUNTEDTECHNOLOGYEMISSIONSPENALTY(REGION,TECHNOLOGY,YEAR);

* ANNUALEMISSIONS[r,e,y] >=0: Sum of the AnnualTechnologyEmission over all
* technologies. [Quantity of emission]
positive variable ANNUALEMISSIONS(REGION,EMISSION,YEAR);

* MODELPERIODEMISSIONS[r,e] >=0: Total system emissions of agent e in the
* model period, accounting for both the emissions by technologies and the
* user defined ModelPeriodExogenousEmission. [Quantity of emission]
positive variable MODELPERIODEMISSIONS(EMISSION,REGION);

*****************************************************************************************
* DA IMBELLIRE
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
