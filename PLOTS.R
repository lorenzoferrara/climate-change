
require(data.table)
require(tidyverse)
require(gdxtools)
require(witchtools)
require(ggpubr)

file_directory <- "~/GitHub/climate-change/Italy/Results"
complete_directory <- here::here()
all_gdx <- c(Sys.glob(here::here(file_directory,"results_*.gdx")))

igdx('C:/GAMS/42')

osemosys_sanitize <- function(.x) {
  .x[, scen := basename(gdx)]
  .x[, scen := str_replace(scen,"results_","")]
  .x[, scen := str_replace(scen,".gdx","")]
  .x[, gdx := NULL]}

directory_graphs = "Italy/Graphs/"

################################################################################
########### PLOT EMISSIONS #####################################################
################################################################################

emissions <- batch_extract("ANNUALEMISSIONS",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
emissions = emissions[emissions$YEAR <= 2050,]
emissions = emissions[emissions$scen != 'base']

{
  x11()
  p = ggplot(emissions |> filter(EMISSION=="CO2")) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1)+ 
    labs(title = "Emissions [Mton/yr]",subtitle = "Only emissions of CO2", x = "year", y = "Emission [MtonCo2]") +
    theme_bw() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"AnnualEmissions.png"), p)
}
################################################################################
########### PLOT PRODUCTION BY TECHNOLOGY ######################################
################################################################################

prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
prod = prod[prod$FUEL=="E1" | prod$FUEL=='E2',]
prod = prod[ prod$TECHNOLOGY  != "EL00TD0",]
prod[prod$FUEL=="E1",]$value = 0.95*prod[prod$FUEL=="E1",]$value

prod$TECH=prod$TECHNOLOGY
for(i in unique(prod$TECHNOLOGY)){
  prod$TECH[prod$TECH==i] = substr(i, start=1, stop=2)
}

prod = prod |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
prod$value = round(as.numeric(prod$value),2)

prod=prod[prod$YEAR<=2050,]
prod=prod[prod$scen!='base',]

prod3=prod
for(i in unique(prod3$TECH)){
  if( sum(prod3[prod3$TECH==i,]$value != 0) ==0 ){
    prod3 = prod3[prod3$TECH!=i,]
  }
}

prod3$value_perc = prod3$value
for(year in unique(prod3$YEAR)){
  for(scenario in unique(prod3$scen)){
    prod3[prod3$YEAR==year & prod3$scen==scenario,]$value_perc = prod3[prod3$YEAR==year & prod3$scen==scenario,]$value/sum(prod3[prod3$YEAR==year & prod3$scen==scenario,]$value)
  }
}

{
  x11()
  p = ggplot(prod3) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    labs(title = "Production by Technology [PJ/yr]", subtitle = "Energy production by set of technology using the same fuel") +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() + 
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"ProductionByTechnology.png"), p)
}

{
  x11()
  p = ggplot(prod3) +
    geom_area(aes(x=as.numeric(YEAR),y=value_perc,fill=TECH)) +
    labs(title = "Production by Technology [PJ/yr]", subtitle = "Energy production by set of technology using the same fuel") +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() + 
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"MixProduttivo.png"), p)
}

################################################################################
########### PLOT ACCUMULATED CAPACITY ##########################################
################################################################################

cap <- batch_extract("ACCUMULATEDNEWCAPACITY",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
cap = cap[cap$value!=99999]
cap = cap[cap$TECHNOLOGY != 'RIVER']

temp = cap$TECHNOLOGY
cap$TECH=temp

for(i in unique(temp)){
  cap$TECH[cap$TECH==i] = substr(i, start=1, stop=2)
}

cap2 = cap |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
cap2$value = round(as.numeric(cap2$value),2)

cap3=cap2
for(i in unique(cap3$TECH)){
  if( sum(cap3[cap3$TECH==i,]$value != 0) ==0 ){
    cap3 = cap3[cap3$TECH!=i,]
  }
}

cap3 = cap3[cap3$YEAR <= 2050,]
cap3 = cap3[cap3$scen != 'base',]

{
  x11()
  p = ggplot(cap3) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    scale_fill_brewer(palette="Paired") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("POWER [GW]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"AccumulatedNewCapacity.png"), p)
}

################################################################################
########### PLOT TOTAL CAPACITY ################################################
################################################################################

totcap <- batch_extract("TOTALCAPACITYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
totcap = totcap[totcap$value<99999]
totcap = totcap[totcap$TECHNOLOGY!='RIVER']

temp = totcap$TECHNOLOGY
totcap$TECH=temp

for(i in unique(temp)){
  totcap$TECH[totcap$TECH==i] = substr(i, start=1, stop=2)
}

totcap2 = totcap |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
totcap2$value = round(as.numeric(totcap2$value),2)
totcap2 = totcap2[totcap2$YEAR <= 2050,]
totcap2 = totcap2[totcap2$scen != 'base',]

{
  x11()
  p = ggplot(totcap2[totcap2$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    facet_wrap(scen~.,) +
    scale_fill_brewer(palette="Paired") +
    xlab("year") + ylab("POWER [GW]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"TotalCapacity.png"), p)
} # ci son troppe variabili, la palette non ne ha abbastanza

################################################################################
########### PLOT WATER USAGE ###################################################
################################################################################

#WATER USED BY TECH
water2 <- batch_extract("USEBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
water2 = water2[water2$FUEL=='HY']

water2$TECH=water2$TECHNOLOGY
for(i in unique(water2$TECHNOLOGY)){
  water2$TECH[water2$TECH==i] = substr(i, start=1, stop=2)
}

water2 = water2 |> 
  group_by(scen,TECH,YEAR) |>
  summarise(value = sum(value))
water2$value = round(as.numeric(water2$value),2)
water2 = water2[water2$YEAR <=2050,]
water2 = water2[water2$scen != 'base',]

{
  x11()
  p = ggplot(water2[water2$value!=0 & water2$TECH!='HY',]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECH)) +
    facet_wrap(scen~.,) +
    labs(title = "Use of water by technology (excepted hydroelectrical)") +
    scale_fill_brewer(palette="Paired") +
    xlab("year") + ylab("Water used [km3]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"WaterUsageByTechnology.png"), p)
}

################################################################################
########### PLOT STORAGE USAGE ###################################################
################################################################################

storage <- batch_extract("STORAGELEVELSEASONSTART",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
storage = storage[storage$STORAGE=='DAM' | storage$STORAGE=='H2' | storage$STORAGE=='BAT']
storage = storage[storage$YEAR <= 2050,]
storage = storage[storage$scen != 'base',]

{
  x11()
  p = ggplot(storage) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=STORAGE), linewidth=0.5) +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("storage capacity [PJ]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))

  print(p)
  ggsave(paste0(directory_graphs,"StorageUsage.png"), p)
}

################################################################################
########### PLOT TOTAL WATER USAGE #############################################
################################################################################

use2 <- batch_extract("USEANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
use2 = use2[use2$FUEL=="HY",]
use2 = use2[use2$YEAR<=2050,]
use2 = use2[use2$scen!='base',]

#RIVER WATER
{
  x11()
  p = ggplot(use2) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1.3) +
    labs(title = "Total Water Usage") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Water [km3]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  print(p)
  ggsave(paste0(directory_graphs,"TotalWaterUsage.png"), p)
}

use3 <- batch_extract("USEANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
use3 = use3[use3$FUEL=="SE",]
use3 = use3[use3$YEAR<=2050,]
use3 = use3[use3$scen!='base',]

#SEA WATER
{
  x11()
  p = ggplot(use3) +
    geom_line(aes(x=as.numeric(YEAR),y=value,color=scen), linewidth=1.3) +
    labs(title = "Total Sea Water Usage") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Water [km3]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  print(p)
  ggsave(paste0(directory_graphs,"TotalSeaWaterUsage.png"), p)
}
################################################################################
########### PLOT COST ##########################################################
################################################################################

cost <- batch_extract("OPERATINGCOST",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

cost = cost |> 
  group_by(scen,YEAR) |>
  summarise(value = sum(value))
# storage3$value = round(as.numeric(water2$value),2)

cost = cost[cost$YEAR <=2050,]
cost = cost[cost$scen != 'base',]


cost$NUCLEAR = substr(cost$scen,1,1)
cost$NUCLEAR[cost$NUCLEAR == 'N']='YES'
cost$NUCLEAR[cost$NUCLEAR == 'B']='NO'

#COSTS
{
  x11()
  p = ggplot(cost) +
    geom_line(aes(x=as.numeric(YEAR),y=value/1000,color=scen), linewidth=1.3) +
    labs(title = "Operating cost") +
    xlab("year") + ylab("Cost [BIllions of $]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  print(p)
  ggsave(paste0(directory_graphs,"OperatingCost.png"), p)
  }

#COST GROUPED BY NUCLEAR/NO-NUCLEAR
{
  x11()
  p = ggplot(cost) +
    geom_line(aes(x=as.numeric(YEAR),y=value/1000,group=scen, color=NUCLEAR), linewidth=1.1) +
    labs(title = "Operating Cost") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Cost [BIllions of $]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  print(p)
  ggsave(paste0(directory_graphs,"OperatingCostByNuclear.png"), p)
}

cost2 = cost |> 
  group_by(NUCLEAR, YEAR) |>
  summarise(value = mean(value))

#MEAN COSTS NUCLEAR-NO NUCLEAR
{
  x11()
  p = ggplot(cost2) +
    geom_line(aes(x=as.numeric(YEAR),y=value/1000,color=NUCLEAR), linewidth=1.3) +
    labs(title = "Operating Cost with/without nuclear") +
    # facet_wrap(scen~.,) +
    xlab("year") + ylab("Cost [BIllions of $]") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  print(p)
  ggsave(paste0(directory_graphs,"OperatingCostMeanByNuclear.png"), p)
  }

################################################################################
########### PLOT CARBON CAPTURE ######################################
################################################################################

prod4 <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()
prod4 = prod4[prod4$TECHNOLOGY=='COCSPN2' | prod4$TECHNOLOGY=='NGCSPN2' | prod4$TECHNOLOGY=='BMCSPN2',]
prod4 = prod4[prod4$FUEL=='E2' | prod4$FUEL=='E1',]
prod4[prod4$FUEL=="E1",]$value = 0.95*prod4[prod4$FUEL=="E1",]$value

prod4 = prod4[prod4$YEAR<=2050,]
prod4 = prod4[prod4$scen!='base',]

{
  x11()
  p = ggplot(prod4[prod4$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value,fill=TECHNOLOGY)) +
    labs(title = "Production by Technology [PJ/yr]", subtitle = "Energy production by set of technology using the same fuel") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() +
    scale_fill_brewer(palette="Paired") +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"CarbonCapture.png"), p)
}

################################################################################
########### WATER PRESENCE #####################################################
################################################################################

cap <- batch_extract("CAP",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

prod = prod[prod$FUEL == 'HY',]
prod = prod[prod$TECHNOLOGY == 'RIVER',]

cap = cap[cap$YEAR <= 2050,]
cap = cap[cap$scen != 'base',]
prod = prod[prod$YEAR <= 2050,]
prod = prod[prod$scen != 'base',]


{
  x11()
  p = ggplot(cap) +
    geom_line(aes(x=as.numeric(YEAR),y=value),color='red', linewidth=1.3) +
    geom_line(data=prod, aes(x=as.numeric(YEAR),y=value),color='blue', linewidth=1.3) +
    labs(title = "Water production and limit", subtitle = "Water use and max") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Km3") + theme_pubr() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"WaterProductionVSLimit.png"), p)
}

################################################################################
########### HYDRO Vs SEA #######################################################
################################################################################

prod <- batch_extract("PRODUCTIONBYTECHNOLOGYANNUAL",all_gdx)[[1]] |> setDT() |> osemosys_sanitize()

prod = prod[prod$FUEL=="E1" | prod$FUEL=='E2',]
prod = prod[ prod$TECHNOLOGY  != "EL00TD0",]
prod[prod$FUEL=="E1",]$value = 0.95*prod[prod$FUEL=="E1",]$value

for(i in unique(prod$TECHNOLOGY)){
  prod$type[prod$TECHNOLOGY==i] = substr(i, start=nchar(i), stop=nchar(i))
}
prod$type[prod$type!='S'] = 'R'

prod = prod |> 
  group_by(YEAR, scen, type) |>
  summarise(value = sum(value))


prod = prod[prod$YEAR <= 2050,]
prod = prod[prod$scen != 'base',]

prod$value = round(as.numeric(prod$value),2)
{
  x11()
  p = ggplot(prod[prod$value!=0,]) +
    geom_area(aes(x=as.numeric(YEAR),y=value, fill=type)) +
    labs(title = "Energy production by watertype used [PJ/yr]", subtitle = "") +
    facet_wrap(scen~.,) +
    xlab("year") + ylab("Energy [PJ]") + theme_pubr() +
    scale_fill_brewer(palette="Paired") +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5))
  
  print(p)
  ggsave(paste0(directory_graphs,"RiverVSSeaEnergy.png"), p)
}
